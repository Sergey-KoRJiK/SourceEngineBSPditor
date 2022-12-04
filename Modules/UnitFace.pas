unit UnitFace;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  OpenGL,
  EXTOpengl32Glew32,
  UnitVec,
  UnitPlane,
  UnitLightmap,
  UnitTexture,
  UnitToneMapControl;


type tFace = record
    iPlane: WORD;
    isInverseNormal: ByteBool;
    isInNode: ByteBool;
    iFirstSurfEdge: Integer;
    nSurfEdges: Smallint;
    iTextureInfo: Smallint;
    DispInfoIndex: Smallint;      // displament info number in "DispInfo Lump"
    surfaceFogVolumeId: Smallint; // ?
    //
    nStyles: array[0..3] of Byte;
    nLightmapOffset: Integer;
    FaceArea: Single;
    LmpMinS, LmpMinT: Integer;
    LmpWidth, LmpHeight: Integer;
    //
    OrigFaceIndex: Integer;		  // original Face Index in "OrigFace Lump"
    CountPrimitives: Word;		    // Count primitives in "<Name Here> Lump"
    StartPrimitiveIndex: Word;    // index of Primitives in "<Name Here> Lump"
    LmpSmoothGroup: DWORD;	      // lightmap smoothing group
  end;
type PFace = ^tFace;
type AFace = array of tFace;

// used for fast render, ray intersection, contatin pre-calculated data and GPU pre-build Textures
type tFaceInfo = record
    isValidToRender: Boolean; // if is have lightmaps, not degenerate and not tool texture
    isHaveBumpLightmap: Boolean;
    //
    CountLightStyles: Integer;
    OffsetLmp: Integer;
    LmpSize: TPoint;
    LmpSquare: Integer;
    //
    BrushId: Integer;
    VisLeafId: Integer;
    Plane: tPlane;
    //
    CountTriangles: Integer;
    CountVertex: Integer;
    Vertex: AVec3f; // pre-calculated Vertex data by Edge LUMP
    LmpCoords: AVec2f;
    //
    TexInfo: tTexInfo;
    TextureRender: GLuint; // some of next two arrays for fast render
    LmpPages: array[0..3] of GLuint;
    LmpPagesHDR: array[0..3] of GLuint;
    lpFirstLightmap: array[0..3] of PLightmapColor;
    lpFirstLightmapHDR: array[0..3] of PLightmapColor;
    StylesRatio: array[0..3] of Single;
    StylesRatioHDR: array[0..3] of Single;
    //
    AverageLmp: array[0..3] of tLightmapColor;
    AverageLmpHDR: array[0..3] of tLightmapColor;
  end;
type PFaceInfo = ^tFaceInfo;
type AFaceInfo = array of tFaceInfo;
type APtrFaceInfo = array of PFaceInfo;


procedure UpdateFaceRatio(const lpFaceInfo: PFaceInfo; const isHDR, isLDR: Boolean);
procedure CreateLightmapTexture(const lpFaceInfo: PFaceInfo;
  const StylePage: Integer; const lpToneMapScale: PSingle; const isHDR: Boolean);

procedure RenderFace(const lpFaceInfo: PFaceInfo);
procedure RenderSelectedFace(const lpFaceInfo: PFaceInfo; const lpColor: tColor4fv);
procedure RenderFaceList(const FaceList: AFaceInfo; const CountFaces: Integer);

function GetRayFaceIntersection(const lpFaceInfo: PFaceInfo; const Ray: tRay;
  const RayValue: PSingle): Boolean;


implementation


procedure UpdateFaceRatio(const lpFaceInfo: PFaceInfo; const isHDR, isLDR: Boolean);
var
  i, j: Integer;
  Max: ShortInt;
  tmpPointer: PShortInt;
begin
  {$R-}
  for i:=0 to (lpFaceInfo.CountLightStyles - 1) do
    begin
      if (isLDR) then
        begin
          Max:=-128;
          tmpPointer:=@lpFaceInfo.lpFirstLightmap[i].e;
          for j:=0 to (lpFaceInfo.LmpSquare - 1) do
            begin
              if (tmpPointer^ > Max) then Max:=tmpPointer^;
              Inc(tmpPointer, 4);
            end;
          if (Max >= 0) then
            begin
              lpFaceInfo.StylesRatio[i]:=Max + 1;
            end
          else
            begin
              lpFaceInfo.StylesRatio[i]:=1/(1 shl -Max);
            end;
        end;

      if (isHDR) then
        begin
          Max:=-128;
          tmpPointer:=@lpFaceInfo.lpFirstLightmapHDR[i].e;
          for j:=0 to (lpFaceInfo.LmpSquare - 1) do
            begin
              if (tmpPointer^ > Max) then Max:=tmpPointer^;
              Inc(tmpPointer, 4);
            end;
          if (Max >= 0) then
            begin
              lpFaceInfo.StylesRatioHDR[i]:=Max + 1;
            end
          else
            begin
              lpFaceInfo.StylesRatioHDR[i]:=1/(1 shl -Max);
            end;
        end;
    end;
  {$R+}
end;

procedure CreateLightmapTexture(const lpFaceInfo: PFaceInfo;
  const StylePage: Integer; const lpToneMapScale: PSingle; const isHDR: Boolean);
var
  i: Integer;
  BufferLDR: AVec3f;
  tmpPointer: PLightmapColor;
begin
  {$R-}
  if (lpFaceInfo.isValidToRender = False) then Exit;

  if (StylePage < 0) then Exit;
  if (StylePage >= lpFaceInfo.CountLightStyles) then Exit;
                                     
  if (isHDR) then
    begin
      glDeleteTextures(1, @lpFaceInfo.LmpPagesHDR[StylePage]);
      glGenTextures(1, @lpFaceInfo.LmpPagesHDR[StylePage]);
      if (lpFaceInfo.LmpPagesHDR[StylePage] = 0) then Exit;
      glBindTexture(GL_TEXTURE_2D, lpFaceInfo.LmpPagesHDR[StylePage]);
    end
  else
    begin
      glDeleteTextures(1, @lpFaceInfo.LmpPages[StylePage]);
      glGenTextures(1, @lpFaceInfo.LmpPages[StylePage]);
      if (lpFaceInfo.LmpPages[StylePage] = 0) then Exit;
      glBindTexture(GL_TEXTURE_2D, lpFaceInfo.LmpPages[StylePage]);
    end;

  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

  SetLength(BufferLDR, lpFaceInfo.LmpSquare);
  if (isHDR) then tmpPointer:=lpFaceInfo.lpFirstLightmapHDR[StylePage]
  else tmpPointer:=lpFaceInfo.lpFirstLightmap[StylePage];
  
  for i:=0 to (lpFaceInfo.LmpSquare - 1) do
    begin
      RGBExpToVec3f(tmpPointer, @BufferLDR[i]);
      ApplyLinearToneMap(@BufferLDR[i], lpToneMapScale);
      ClampVec3fToOne(@BufferLDR[i]);
      //RGBExpToRGB888_Gamma_NoScale(tmpPointer, @BufferLDR[i]);

      Inc(tmpPointer);
    end;
  glTexImage2D(GL_TEXTURE_2D, 0, 3, lpFaceInfo.LmpSize.X, lpFaceInfo.LmpSize.Y, 0,
    GL_RGB, GL_FLOAT, @BufferLDR[0].x);

  glBindTexture(GL_TEXTURE_2D, 0);
  SetLength(BufferLDR, 0);
  {$R+}
end;


procedure RenderFace(const lpFaceInfo: PFaceInfo);
begin
  {$R-}
  if (lpFaceInfo.isValidToRender = False) then Exit;

  glBindTexture(GL_TEXTURE_2D, lpFaceInfo.TextureRender);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  glVertexPointer(3, GL_FLOAT, 0, @lpFaceInfo.Vertex[0].x);
  glTexCoordPointer(2, GL_FLOAT, 0, @lpFaceInfo.LmpCoords[0].x);
  glDrawArrays(GL_TRIANGLE_FAN, 0, lpFaceInfo.CountVertex);

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  {$R+}
end;

procedure RenderSelectedFace(const lpFaceInfo: PFaceInfo; const lpColor: tColor4fv);
begin
  {$R-}
  if (lpFaceInfo.isValidToRender = False) then Exit;
  
  glEnableClientState(GL_VERTEX_ARRAY);
  glColor4fv(@lpColor[0]);
  glVertexPointer(3, GL_FLOAT, 0, @lpFaceInfo.Vertex[0].x);
  glDrawArrays(GL_TRIANGLE_FAN, 0, lpFaceInfo.CountVertex);
  glDisableClientState(GL_VERTEX_ARRAY);
  {$R+}
end;

procedure RenderFaceList(const FaceList: AFaceInfo; const CountFaces: Integer);
var
  i: Integer;
begin
  {$R-}
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  for i:=0 to (CountFaces - 1) do
    begin
      if (FaceList[i].isValidToRender = False) then Continue;

      glBindTexture(GL_TEXTURE_2D, FaceList[i].TextureRender);
      glVertexPointer(3, GL_FLOAT, 0, @FaceList[i].Vertex[0].x);
      glTexCoordPointer(2, GL_FLOAT, 0, @FaceList[i].LmpCoords[0].x);
      glDrawArrays(GL_TRIANGLE_FAN, 0, FaceList[i].CountVertex);
    end;

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  {$R+}
end;


function GetRayFaceIntersection(const lpFaceInfo: PFaceInfo; const Ray: tRay;
  const RayValue: PSingle): Boolean;
var
  tmp, u, v: Single;
  Edge0, Edge1: tVec3f;
  tvec, pvec, qvec: tVec3f;
  i: Integer;
begin
  {$R-}
  // Based on: Moller, Tomas; Trumbore, Ben (1997). "Fast, Minimum Storage 
  // Ray-Triangle Intersection". Journal of Graphics Tools. 2: 21–28.

  
  if (lpFaceInfo.isValidToRender = False) then
    begin
      Result:=False;
      Exit;
    end;
  
  tmp:=Ray.Dir.X*lpFaceInfo.Plane.vNormal.x + Ray.Dir.Y*lpFaceInfo.Plane.vNormal.y
    + Ray.Dir.Z*lpFaceInfo.Plane.vNormal.z;

  // Test that ray "see" Front Face of rectangle
  if (PInteger(@tmp)^ > 0) then
    begin
      Result:=False;
      Exit;
    end;

  // Calculate First Edge
  Edge1.x:=lpFaceInfo.Vertex[1].x - lpFaceInfo.Vertex[0].x;
  Edge1.y:=lpFaceInfo.Vertex[1].y - lpFaceInfo.Vertex[0].y;
  Edge1.z:=lpFaceInfo.Vertex[1].z - lpFaceInfo.Vertex[0].z;

  // Calculate distance from vert0 to ray origin
  tvec.x:=Ray.Start.x - lpFaceInfo.Vertex[0].x;
  tvec.y:=Ray.Start.y - lpFaceInfo.Vertex[0].y;
  tvec.z:=Ray.Start.z - lpFaceInfo.Vertex[0].z;

  for i:=0 to (lpFaceInfo.CountTriangles - 1) do
    begin
      // First Get Edges
      Edge0:=Edge1;
      Edge1.x:=lpFaceInfo.Vertex[i + 2].x - lpFaceInfo.Vertex[0].x;
      Edge1.y:=lpFaceInfo.Vertex[i + 2].y - lpFaceInfo.Vertex[0].y;
      Edge1.z:=lpFaceInfo.Vertex[i + 2].z - lpFaceInfo.Vertex[0].z;

      pvec.x:=Ray.Dir.y*Edge1.z - Ray.Dir.z*Edge1.y;
      pvec.y:=Ray.Dir.z*Edge1.x - Ray.Dir.x*Edge1.z;
      pvec.z:=Ray.Dir.x*Edge1.y - Ray.Dir.y*Edge1.x;

      tmp:=Edge0.x*pvec.x + Edge0.y*pvec.y + Edge0.z*pvec.z;
      // If tmp is near zero, ray lies in plane of triangle
      if ((PInteger(@tmp)^ and $7FFFFFFF) = 0) then Continue;

      // Calculate normalazed U baricentric coordinate and test bounds
      u:=(tvec.x*pvec.x + tvec.y*pvec.y + tvec.z*pvec.z)/tmp;
  
      if (PInteger(@u)^ < 0) then Continue;
      if (u > 1.0) then Continue;

      qvec.x:=tvec.y*Edge0.z - tvec.z*Edge0.y;
      qvec.y:=tvec.z*Edge0.x - tvec.x*Edge0.z;
      qvec.z:=tvec.x*Edge0.y - tvec.y*Edge0.x;

      // Calculate normalazed V baricentric coordinate and test bounds
      v:=(Ray.Dir.x*qvec.x + Ray.Dir.y*qvec.y + Ray.Dir.z*qvec.z)/tmp;

      if (PInteger(@v)^ < 0) then Continue;
      if ((u + v) > 1.0) then Continue;

      // Calculate RayValue trace parameter and test zero bound
      RayValue^:=(Edge1.x*qvec.x + Edge1.y*qvec.y + Edge1.z*qvec.z)/tmp;
      if (PInteger(RayValue)^ < 0 ) then Continue;

      Result:=True;
      Exit;
    end;

  Result:=False;
  {$R+}
end;


end.
