unit UnitLeafAmbientLight;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  UnitVec,
  UnitLightmap,
  UnitToneMapControl,
  OpenGL,
  EXTOpengl32Glew32;

const
  MAX_AMBIENT_SAMPLES = 16; // max count of ambient cubes in Leaf
  AmbientColorScale: Single = 256.0;
  AmbientCubeSize: Single = 16.0;

type tCubeAmbientColor = array[0..5] of tLightmapColor; // 24 bytes
type PCubeAmbientColor = ^tCubeAmbientColor;
type ACubeAmbientColor = array of tCubeAmbientColor;

type tRenderCubeAmbientColor = array[0..5] of tVec3f;
type PRenderCubeAmbientColor = ^tRenderCubeAmbientColor;
type ARenderCubeAmbientColor = array of tRenderCubeAmbientColor;

type tLeafAmbientLighting = record
	  colors: tCubeAmbientColor;
	  x, y, z: Byte; // relative position in Leaf by Min and Max of Leaf BBOX
    // by vrad.exe relative position generated randomly
    padding: Byte;
  end; // 28 bytes
type PLeafAmbientLighting = ^tLeafAmbientLighting;
type ALeafAmbientLighting = array of tLeafAmbientLighting;

// [i]-th Leaf always corresponds [i]-th tLeafAmbientIndex
type tLeafAmbientIndex = record
    CountSamples: SmallInt;
    FirstSample: SmallInt;
  end; // 4 bytes
type PLeafAmbientIndex = ^tLeafAmbientIndex;
type ALeafAmbientIndex = array of tLeafAmbientIndex;


type tCubeInfo = record
    BBOXf: tBBOXf;
    Position: tVec3f; // center of cube in World
    RawPosition: tVec3s; // cube pos by byte fraction
    RawColor: tCubeAmbientColor; // RGBExp HDR colors
    RenderColor: tRenderCubeAmbientColor; // gamma-corrected HDR colors
  end;
type PCubeInfo = ^tCubeInfo;
type ACubeInfo = array of tCubeInfo;

type tLeafAmbientInfo = record
    SampleCount: Integer;
    FirstSampleIndex: Integer;
    CubeList: ACubeInfo; // SampleCount
    StepSize: tVec3f; // minimal move step for change sample pos
  end;
type PLeafAmbientInfo = ^tLeafAmbientInfo;
type ALeafAmbientInfo = array of tLeafAmbientInfo;


const
  LeafAmbSize = SizeOf(tLeafAmbientLighting);
  LeafAmbIndexSize = SizeOf(tLeafAmbientIndex);
  //
  CubeIndexNormal: array[0..5] of tVec3f = (
    (x:  1.0; y:  0.0; z:  0.0),
    (x: -1.0; y:  0.0; z:  0.0),
    (x:  0.0; y:  1.0; z:  0.0),
    (x:  0.0; y: -1.0; z:  0.0),
    (x:  0.0; y:  0.0; z:  1.0),
    (x:  0.0; y:  0.0; z: -1.0)
  );

const
  // index array of vertex array for glDrawElements()
  CubeIndexes: array[0..35] of GLubyte = (
     2,  1,  0,    0,  3,  2,      // front   - color index 4
     6,  5,  4,    4,  7,  6,      // right   - color index 0
    10,  9,  8,    8, 11, 10,      // top     - color index 2
    12, 15, 14,   14, 13, 12,      // left    - color index 1
    16, 19, 18,   18, 17, 16,      // bottom  - color index 3
    20, 23, 22,   22, 21, 20       // back    - color index 5
  );
  CubeVertex: array[0..71] of GLfloat = (
     1, 1, 1,  -1, 1, 1,  -1,-1, 1,   1,-1, 1,   // v0,v1,v2,v3 (front)
     1, 1, 1,   1,-1, 1,   1,-1,-1,   1, 1,-1,   // v0,v3,v4,v5 (right)
     1, 1, 1,   1, 1,-1,  -1, 1,-1,  -1, 1, 1,   // v0,v5,v6,v1 (top)
    -1, 1, 1,  -1, 1,-1,  -1,-1,-1,  -1,-1, 1,   // v1,v6,v7,v2 (left)
    -1,-1,-1,   1,-1,-1,   1,-1, 1,  -1,-1, 1,   // v7,v4,v3,v2 (bottom)
     1,-1,-1,  -1,-1,-1,  -1, 1,-1,   1, 1,-1    // v4,v7,v6,v5 (back)
  );
  // Color Map:
  // Color[4], Color[4], Color[4], Color[4]
  // Color[0], Color[0], Color[0], Color[0]
  // Color[2], Color[2], Color[2], Color[2]
  // Color[1], Color[1], Color[1], Color[1]
  // Color[3], Color[3], Color[3], Color[3]
  // Color[5], Color[5], Color[5], Color[5]


procedure GetAmbientSampleWorldPos(const lpSample: PLeafAmbientLighting;
  const lpLeafBBOXf: PBBOXf; const lpOutPos: PVec3f);

procedure ClearLeafAmbientInfo(const lpInfo: PLeafAmbientInfo);
procedure GetAmbientLightAtPosition(const lpInfo: PLeafAmbientInfo;
  const lpWorldPos: PVec3f; const OutSixColors: PRenderCubeAmbientColor);
procedure GetFinalAmbientLightByNormal(const OutSixColors: PRenderCubeAmbientColor;
  const lpNormal, lpOutColor: PVec3f);


procedure RenderMapAmbientColor(const lpList, lpSrc: PVec3f);
procedure RenderAmbientCubeList(const lpLeafAmbientInfo: PLeafAmbientInfo;
  const RenderIndex: AByteBool);


implementation


procedure GetAmbientSampleWorldPos(const lpSample: PLeafAmbientLighting;
  const lpLeafBBOXf: PBBOXf; const lpOutPos: PVec3f);
var
  LocalPoint: tVec3f;
begin
  {$R-}
  LocalPoint.x:=lpSample.x*inv255f;
  LocalPoint.y:=lpSample.y*inv255f;
  LocalPoint.z:=lpSample.z*inv255f;

  MapLocalPointInBBOXf(lpLeafBBOXf, @LocalPoint, lpOutPos);
  {$R+}
end;


procedure ClearLeafAmbientInfo(const lpInfo: PLeafAmbientInfo);
begin
  {$R-}
  if (lpInfo = nil) then Exit;
  lpInfo.SampleCount:=0;
  lpInfo.FirstSampleIndex:=0;
  SetLength(lpInfo.CubeList, 0);
  {$R+}
end;

procedure GetAmbientLightAtPosition(const lpInfo: PLeafAmbientInfo;
  const lpWorldPos: PVec3f; const OutSixColors: PRenderCubeAmbientColor);
var
  i: Integer;
  locFactor, totFactor: Single;
  tmpVec: tVec3f;
begin
  {$R-}
  // this procedure is same of Mod_LeafAmbientColorAtPos of Source SDK 2013 MP
  // from GitHub: mp/src/utils/vrad/leaf_ambient_lighting.cpp

  OutSixColors[0]:=VEC_ZERO;
  OutSixColors[1]:=VEC_ZERO;
  OutSixColors[2]:=VEC_ZERO;
  OutSixColors[3]:=VEC_ZERO;
  OutSixColors[4]:=VEC_ZERO;
  OutSixColors[5]:=VEC_ZERO;

  totFactor:=0.0;
  for i:=0 to (lpInfo.SampleCount - 1) do
    begin
      locFactor:=1.0/(SqrDistTwoVec(lpWorldPos^, lpInfo.CubeList[i].Position) + 1.0);
      totFactor:=totFactor + locFactor;

      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[0], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[0], @tmpVec, @locFactor);
      //
      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[1], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[1], @tmpVec, @locFactor);
      //
      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[2], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[2], @tmpVec, @locFactor);
      //
      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[3], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[3], @tmpVec, @locFactor);
      //
      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[4], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[4], @tmpVec, @locFactor);
      //
      RGBExpToVec3f(@lpInfo.CubeList[i].RawColor[5], @tmpVec);
      ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
      AddWithScaleVec(@OutSixColors[5], @tmpVec, @locFactor);
      //
    end;

  InvScaleVec(@OutSixColors[0], @OutSixColors[0], @totFactor);
  InvScaleVec(@OutSixColors[1], @OutSixColors[1], @totFactor);
  InvScaleVec(@OutSixColors[2], @OutSixColors[2], @totFactor);
  InvScaleVec(@OutSixColors[3], @OutSixColors[3], @totFactor);
  InvScaleVec(@OutSixColors[4], @OutSixColors[4], @totFactor);
  InvScaleVec(@OutSixColors[5], @OutSixColors[5], @totFactor);
  {$R+}
end;

procedure GetFinalAmbientLightByNormal(const OutSixColors: PRenderCubeAmbientColor;
  const lpNormal, lpOutColor: PVec3f);
var
  totFactor: Single;
begin
  {$R-}
  totFactor:=(Abs(lpNormal.x) + Abs(lpNormal.y) + Abs(lpNormal.z));
  if (totFactor = 0) then
    begin
      lpOutColor^:=VEC_ZERO;
      Exit;
    end;

  if (lpNormal.x >= 0) then
    begin
      ScaleVec(@OutSixColors[0], lpOutColor, @lpNormal.x);
    end
  else
    begin
      lpOutColor.x:=-OutSixColors[1].x*lpNormal.x;
      lpOutColor.y:=-OutSixColors[1].y*lpNormal.x;
      lpOutColor.z:=-OutSixColors[1].z*lpNormal.x;
    end;

  if (lpNormal.y >= 0) then
    begin
      AddWithScaleVec(lpOutColor, @OutSixColors[2], @lpNormal.y);
    end
  else
    begin
      SubWithScaleVec(lpOutColor, @OutSixColors[3], @lpNormal.y);
    end;

  if (lpNormal.z >= 0) then
    begin
      AddWithScaleVec(lpOutColor, @OutSixColors[4], @lpNormal.z);
    end
  else
    begin
      SubWithScaleVec(lpOutColor, @OutSixColors[5], @lpNormal.z);
    end;

  InvScaleVec(lpOutColor, lpOutColor, @totFactor);
  {$R+}
end;


procedure RenderMapAmbientColor(const lpList, lpSrc: PVec3f);
begin
  {$R-}
  // Map Rule:
  //  4 4 4 4
  //  0 0 0 0
  //  2 2 2 2
  //  1 1 1 1
  //  3 3 3 3
  //  5 5 5 5
  // total 24 colors

  AVec3f(lpList)[ 0]:=AVec3f(lpSrc)[4];
  AVec3f(lpList)[ 1]:=AVec3f(lpSrc)[4];
  AVec3f(lpList)[ 2]:=AVec3f(lpSrc)[4];
  AVec3f(lpList)[ 3]:=AVec3f(lpSrc)[4];

  AVec3f(lpList)[ 4]:=AVec3f(lpSrc)[0];
  AVec3f(lpList)[ 5]:=AVec3f(lpSrc)[0];
  AVec3f(lpList)[ 6]:=AVec3f(lpSrc)[0];
  AVec3f(lpList)[ 7]:=AVec3f(lpSrc)[0];

  AVec3f(lpList)[ 8]:=AVec3f(lpSrc)[2];
  AVec3f(lpList)[ 9]:=AVec3f(lpSrc)[2];
  AVec3f(lpList)[10]:=AVec3f(lpSrc)[2];
  AVec3f(lpList)[11]:=AVec3f(lpSrc)[2];

  AVec3f(lpList)[12]:=AVec3f(lpSrc)[1];
  AVec3f(lpList)[13]:=AVec3f(lpSrc)[1];
  AVec3f(lpList)[14]:=AVec3f(lpSrc)[1];
  AVec3f(lpList)[15]:=AVec3f(lpSrc)[1];

  AVec3f(lpList)[16]:=AVec3f(lpSrc)[3];
  AVec3f(lpList)[17]:=AVec3f(lpSrc)[3];
  AVec3f(lpList)[18]:=AVec3f(lpSrc)[3];
  AVec3f(lpList)[19]:=AVec3f(lpSrc)[3];

  AVec3f(lpList)[20]:=AVec3f(lpSrc)[5];
  AVec3f(lpList)[21]:=AVec3f(lpSrc)[5];
  AVec3f(lpList)[22]:=AVec3f(lpSrc)[5];
  AVec3f(lpList)[23]:=AVec3f(lpSrc)[5];
  {$R+}
end;

procedure RenderAmbientCubeList(const lpLeafAmbientInfo: PLeafAmbientInfo;
  const RenderIndex: AByteBool);
var
  i: Integer;
  CurrCube: PCubeInfo;
  CubeColors: AVec3f; // Size = 6*4 = 24
begin
  {$R-}
  if (lpLeafAmbientInfo.SampleCount <= 0) then Exit;
  SetLength(CubeColors, 24);

  for i:=0 to (lpLeafAmbientInfo.SampleCount - 1) do
    begin
      if (RenderIndex[i] = False) then Continue;

      glEnableClientState(GL_COLOR_ARRAY);
      glEnableClientState(GL_VERTEX_ARRAY);
      glColorPointer(3, GL_FLOAT, 0, @CubeColors[0]);
      glVertexPointer(3, GL_FLOAT, 0, @CubeVertex[0]);

      CurrCube:=@lpLeafAmbientInfo.CubeList[i];
      RenderMapAmbientColor(@CubeColors[0], @CurrCube.RenderColor[0]);

      glPushMatrix();
      glTranslatef(
        CurrCube.Position.x,
        CurrCube.Position.y,
        CurrCube.Position.z
      );
	    glScalef(
        AmbientCubeSize*0.5,
        AmbientCubeSize*0.5,
        AmbientCubeSize*0.5
      );
      glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, @CubeIndexes[0]);
      glPopMatrix();

      glDisableClientState(GL_VERTEX_ARRAY);  // disable vertex arrays
      glDisableClientState(GL_COLOR_ARRAY);
    end;
    
  SetLength(CubeColors, 24);
  {$R+}
end;

end.
