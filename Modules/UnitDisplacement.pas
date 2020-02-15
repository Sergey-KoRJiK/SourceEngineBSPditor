unit UnitDisplacement;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  OpenGL,
  EXTOpengl32Glew32,
  UnitVec,
  UnitLightmap;
  

type tDispVert = packed record
    DirOffset: tVec3f; // Normalized direction offset of initial flat Pos
    DistOffset: Single; // Dist of direction offset
    Alpha: Single; // "per vertex" alpha values for texture blending
    // 20 bytes
  end;
type PDispVert = ^tDispVert;
type ADispVert = array of tDispVert;


type tDispInfo = packed record
    StartPosition: tVec3f; // Start position used for orientation
    DispVertStart: Integer; // Index into LUMP_DISP_VERTS.
    DispTriStart: Integer; // Index into LUMP_DISP_TRIS
    Power: Integer; // indicates size of surface = (2^power) + 1;
    MinTess: Integer; // minimum tesselation allowed
    sSmoothingAngle: Single; // lighting smoothing angle
    Contents: Integer; // surface contents
    MapFace: Word; // Face, that contain this disp surface
    LightmapAlphaStart: Integer;
    LightmapSamplePosStart: Integer; // Index into LUMP_DISP_LIGHTMAP
    // 46 bytes
    // next going unused Neighbor data
    NeighborData: array[0..129] of Byte;
  end;
type PDispInfo = ^tDispInfo;
type ADispInfo = array of tDispInfo;

const
  DISP_SIZE_BY_POWER_2 = 5;
  DISP_SIZE_BY_POWER_3 = 9;
  DISP_SIZE_BY_POWER_4 = 17;


type tDispTrig = record
    Normal: tVec3f;
    V0, V1, V2: tVec3f;
    Edge0, Edge1: tVec3f;
    L0, L1, L2: tVec2f;
  end;
type PDispTrig = ^tDispTrig;
type ADispTrig = array of tDispTrig;


type tDispRenderInfo = record
    isValidToRender: Boolean;
    Size: Integer; // GetSurfaceSize(tDispInfo.Power)
    SqrSize: Integer; // Sqr(Size)
    CountTriangles: Integer; // Sqr(Size - 1)*2
    TriangleList: ADispTrig; // CountTriangles
    TrianglesToRender: AByteBool; // CountTriangles
    DegenerateTriangles: AByteBool; // CountTriangles
    TextureRender: GLuint;
    //
    BBOXf: tBBOXf;
  end;
type PDispRenderInfo = ^tDispRenderInfo;
type ADispRenderInfo = array of tDispRenderInfo;


procedure InitDispTriangleIndexTable();
procedure RenderDisplament(const lpDisp: PDispRenderInfo);
function GetRayDispIntersection(const lpDisp: PDispRenderInfo;
  const Ray: tRay; const RayValue: PSingle): Integer;


  // Disp Triangle Count = Sqr(Size - 1)*2;
  // Power = 2..4 -> Size = 5, 9, 17
  // -> Count = 32, 128, 512;
  // Disp Vertex Triangle Count = Count*3 -> 96, 384, 1536
const
  DISP_TRIG_INDEX_COUNT_POWER_2 = 96;
  DISP_TRIG_INDEX_COUNT_POWER_3 = 384;
  DISP_TRIG_INDEX_COUNT_POWER_4 = 1536;
var
  DISP_TRIG_INDEX_TABLE_VALID: Boolean = False;
  DISP_TRIG_INDEX_TABLE_POWER_2: array[0..DISP_TRIG_INDEX_COUNT_POWER_2-1] of Byte;
  DISP_TRIG_INDEX_TABLE_POWER_3: array[0..DISP_TRIG_INDEX_COUNT_POWER_3-1] of Byte;
  DISP_TRIG_INDEX_TABLE_POWER_4: array[0..DISP_TRIG_INDEX_COUNT_POWER_4-1] of Byte;


implementation


procedure InitDispTriangleIndexTable();
var
  i, j, TrigIndex, PowerIndex: Integer;
  OffsetTrigIndex, VertOffset, VertOffsetNext: Integer;
  DispSizes: array[0..2] of Integer;
  DispTables: array[0..2] of Pointer;
begin
  {$R-}
  DispSizes[0]:=DISP_SIZE_BY_POWER_2;
  DispSizes[1]:=DISP_SIZE_BY_POWER_3;
  DispSizes[2]:=DISP_SIZE_BY_POWER_4;

  DispTables[0]:=@DISP_TRIG_INDEX_TABLE_POWER_2[0];
  DispTables[1]:=@DISP_TRIG_INDEX_TABLE_POWER_3[0];
  DispTables[2]:=@DISP_TRIG_INDEX_TABLE_POWER_4[0];

  // Get Table
  for PowerIndex:=0 to 2 do
    begin
      for i:=0 to (DispSizes[PowerIndex] - 2) do
        begin
          OffsetTrigIndex:=i*(DispSizes[PowerIndex] - 1)*2;
          VertOffset:=i*DispSizes[PowerIndex];
          VertOffsetNext:=VertOffset + DispSizes[PowerIndex];

          for j:=0 to (DispSizes[PowerIndex] - 2) do
            begin
              // Upper Triangle
              TrigIndex:=2*j + OffsetTrigIndex;
              AByte(DispTables[PowerIndex])[3*TrigIndex]:=      VertOffsetNext + j;
              AByte(DispTables[PowerIndex])[3*TrigIndex + 1]:=  VertOffset +     j + 1;
              AByte(DispTables[PowerIndex])[3*TrigIndex + 2]:=  VertOffset +     j;

              // Downer Triangle
              Inc(TrigIndex);
              AByte(DispTables[PowerIndex])[3*TrigIndex]:=      VertOffsetNext + j;
              AByte(DispTables[PowerIndex])[3*TrigIndex + 1]:=  VertOffsetNext + j + 1;
              AByte(DispTables[PowerIndex])[3*TrigIndex + 2]:=  VertOffset +     j + 1;
            end;
        end;
    end;

  DISP_TRIG_INDEX_TABLE_VALID:=True;
  {$R+}
end;

procedure RenderDisplament(const lpDisp: PDispRenderInfo);
var
  i: Integer;
begin
  {$R-}
  if (lpDisp.isValidToRender = False) then Exit;

  glBindTexture(GL_TEXTURE_2D, lpDisp.TextureRender);
  for i:=0 to (lpDisp.CountTriangles - 1) do
    begin
      if (lpDisp.TrianglesToRender[i] = False) then Continue;
      if (lpDisp.DegenerateTriangles[i]) then Continue;
      
      glEnableClientState(GL_VERTEX_ARRAY);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);

      glVertexPointer(3, GL_FLOAT, 0, @lpDisp.TriangleList[i].V0);
      glTexCoordPointer(2, GL_FLOAT, 0, @lpDisp.TriangleList[i].L0);
      glDrawArrays(GL_TRIANGLES, 0, 3);

      glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);
    end;
  {$R+}
end;

function GetRayDispIntersection(const lpDisp: PDispRenderInfo;
  const Ray: tRay; const RayValue: PSingle): Integer;
var
  tmp, u, v: Single;
  lpCurrTrig: PDispTrig;
  tvec, pvec, qvec: tVec3f;
  i: Integer;
begin
  {$R-}
  if (lpDisp.isValidToRender = False) then
    begin
      Result:=-1;
      Exit;
    end;

  for i:=0 to (lpDisp.CountTriangles - 1) do
    begin
      if (lpDisp.TrianglesToRender[i] = False) then Continue;
      if (lpDisp.DegenerateTriangles[i]) then Continue;

      lpCurrTrig:=@lpDisp.TriangleList[i];

      tmp:=Ray.Dir.X*lpCurrTrig.Normal.x
        + Ray.Dir.Y*lpCurrTrig.Normal.y
        + Ray.Dir.Z*lpCurrTrig.Normal.z;
      // Test that ray "see" Front Face of rectangle
      if (PInteger(@tmp)^ > 0) then Continue;

      // Calculate distance from vert0 to ray origin
      tvec.x:=Ray.Start.x - lpCurrTrig.V0.x;
      tvec.y:=Ray.Start.y - lpCurrTrig.V0.y;
      tvec.z:=Ray.Start.z - lpCurrTrig.V0.z;

      pvec.x:=Ray.Dir.y*lpCurrTrig.Edge1.z - Ray.Dir.z*lpCurrTrig.Edge1.y;
      pvec.y:=Ray.Dir.z*lpCurrTrig.Edge1.x - Ray.Dir.x*lpCurrTrig.Edge1.z;
      pvec.z:=Ray.Dir.x*lpCurrTrig.Edge1.y - Ray.Dir.y*lpCurrTrig.Edge1.x;

      tmp:=lpCurrTrig.Edge0.x*pvec.x
        + lpCurrTrig.Edge0.y*pvec.y
        + lpCurrTrig.Edge0.z*pvec.z;
      // If tmp is near zero, ray lies in plane of triangle
      if ((PInteger(@tmp)^ and $7FFFFFFF) < 0) then Continue;

      // Calculate normalazed U baricentric coordinate and test bounds
      u:=(tvec.x*pvec.x + tvec.y*pvec.y + tvec.z*pvec.z)/tmp;
  
      if (PInteger(@u)^ < 0) then Continue;
      if (u > 1.0) then Continue;

      qvec.x:=tvec.y*lpCurrTrig.Edge0.z - tvec.z*lpCurrTrig.Edge0.y;
      qvec.y:=tvec.z*lpCurrTrig.Edge0.x - tvec.x*lpCurrTrig.Edge0.z;
      qvec.z:=tvec.x*lpCurrTrig.Edge0.y - tvec.y*lpCurrTrig.Edge0.x;

      // Calculate normalazed V baricentric coordinate and test bounds
      v:=(Ray.Dir.x*qvec.x + Ray.Dir.y*qvec.y + Ray.Dir.z*qvec.z)/tmp;

      if (PInteger(@v)^ < 0) then Continue;
      if ((u + v) > 1.0) then Continue;

      // Calculate RayValue trace parameter and test zero bound
      RayValue^:=(lpCurrTrig.Edge1.x*qvec.x
        + lpCurrTrig.Edge1.y*qvec.y
        + lpCurrTrig.Edge1.z*qvec.z)/tmp;
      if (PInteger(RayValue)^ < 0 ) then Continue;

      Result:=i;
      Exit;
    end;

  Result:=-1;
  {$R+}
end;

end.
