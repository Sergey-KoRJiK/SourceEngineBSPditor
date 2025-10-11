unit UnitVec;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  UnitUserTypes;

procedure ZeroFillChar(const Buffer: PByte; const SizeBuffer: Integer);
procedure ZeroFillDWORD(const Buffer: PByte; const SizeBuffer: Integer);
procedure FillChar0xFF(const Buffer: PByte; const SizeBuffer: Integer);
procedure ZeroFill16K(const Buffer: Pointer);
procedure ZeroFill64K(const Buffer: Pointer);

procedure NormalizeVec3f(const lpVec: PVec3f);
function SqrLengthVec3f(const Vec: tVec3f): Extended;
function DotVec3f(const VecA, VecB: tVec3f): Extended; overload;
function DotVec3f(const VecA, VecB: tVec4f): Extended; overload;
function DotVec3f(const VecA: tVec3f; const VecB: tVec4f): Extended; overload;
function DotVec3f(const VecA: tVec4f; const VecB: tVec3f): Extended; overload;
procedure DotVec4f(const VecA, VecB: PVec4f; const res: PSingle);
procedure CrossVec3f(const VecA, VecB, VecRes: PVec3f);
procedure TranslateVertexArray4f(const Vertex: PVec4f; const lpOffset: PVec4f; const Count: Integer);
function  SqrDistVec3f(const VecA, VecB: tVec3f): Extended;

function  DotVec3f4f(const Vec3: tVec3f; const Vec4: tVec4f): Extended;

function FloatToStrFixed(const Value: Single): String;
function VecToStr(const Vec3f: tVec3f): String; overload;
function VecToStr(const Vec4f: tVec4f): String; overload;
function StrToVec(const Str: String; const Vec: PVec3f): Boolean;

// if Stride < SizeOf(tVec3f) then using Stride=0
procedure GetBBOX3f(const Vertices: PVec3f; const BBOX3f: PBBOX3f;
  const Count, Stride: Integer);

procedure GetTexBBOX(const TexCoords: AVec2f; const lpTexBBOXf: PTexBBOXf;
  const CountCoords: Integer);

procedure BBOX3sTo3f(const src: PBBOXs; const dst: PBBOX3f);

function TestPointInBBOX4f(const BBOX4f: tBBOX4f; const Point: tVec4f): Boolean;
function TestIntersectionTwoBBOX4f(const BBOX4fA, BBOX4fB: tBBOX4f): Boolean;
function TestIntersectionTwoBBOX3f(const BBOX3fA, BBOX3fB: tBBOX3f): Boolean;
procedure TranslateBBOX4f(const BBOX4f: tBBOX4f; const OffsetVec: tVec4f);
procedure GetSizeBBOX4f(const BBOX4f: tBBOX4f; const lpSize: PVec4f);
procedure GetCenterBBOX4f(const BBOX4f: tBBOX4f; const lpCenter: PVec4f);
procedure GetCenterBBOX3s(const BBOX3s: tBBOXs; const lpCenter: PVec3f);
procedure GetCenterBBOX3f(const BBOX3f: tBBOX3f; const lpCenter: PVec3f);

procedure RGB888toTRGBTriple(const lpRGBColor: PRGB888; var BGRColor: TRGBTriple);
procedure TRGBTripleToRGB888(const BGRColor: TRGBTriple; const lpRGBColor: PRGB888);
procedure RGBA8888toTRGBQuad(const lpRGBAColor: PRGBA8888; var BGRAColor: TRGBQuad);
procedure TRGBQuadToRGBA8888(const BGRColor: TRGBQuad; const lpRGBAColor: PRGBA8888);
function LightMapToStr(const LightMap: tRGB888): String;

function BoolToStrYesNo(const boolValue: Boolean): String;

procedure CopyBytes(const lpSrc, lpDest: PByte; const CountCopyBytes: Integer);

// this function fill lpDest array by first or second byte of Value, depend of
// lpBoolMask array. 3 and 4 bytes (bits 16..31) of Value will be ignored.
procedure SetBytesByBoolMask(const lpBoolMask, lpDest: PByte;
  const CountCopyBytes: Integer; const Value: DWORD);

procedure FillLightmaps(const lpDest, FillColor: PRGB888; const CountDest: Integer);

function CompareString(const Str1, Str2: String; CompareSize: Integer): Boolean;


function GetPointPlaneDistance(const Plane: PPlane; const Point: tVec4f): Single;
function GetPointPlaneDistanceFull(const Plane: PPlane; const Point: tVec4f): Single;

function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec4f): Boolean;
function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec4f): Boolean;

function GetPlaneByPoints(const V0, V1, V2: tVec4f; const Plane: PPlane): Boolean;
// Normal = Cross(V2 - V0, V1 - V0), if Normal is zeros -> return False;

procedure TranslatePlane(const SrcPlane, DstPlane: PPlane; const Offset: Single); overload;
procedure TranslatePlane(const SrcPlane, DstPlane: PPlane; const OffsetVec: tVec4f); overload;
// First, translate plane by add Offset to Plane.fDist
// Second, translate plane by project OffsetVec on Plane.Normal and add this
// project result to Plane.fDist

function PlaneToStr(const PlaneBSP: tPlane): String;
function PlaneToStrExt(const PlaneBSP: tPlane): String;
function PlaneTypeToStrExt(const PlaneType: Integer): String;

function GetPlaneTypeByNormal(const Normal: tVec3f): Integer;


// TraceInfo.t must be contain max value (or +Infinity)
// function return True/False and fill t-value and point of ray-plane intersection
function GetRayPlaneIntersection(
  const Plane: tPlane; const Ray: tRay; const TraceInfo: PTraceInfo): Boolean;
function GetRayPlaneIntersectionASM(
  const Plane: tPlane; const Ray: tRay; const TraceInfo: PTraceInfo): Boolean;

procedure FreePolygon(const Poly: PPolygon3f);
procedure UpdatePolygon(const Poly: PPolygon3f);

// TraceInfo.t must be contain max value (or +Infinity) because may be
// used for reject triangle intersection in some version of functions.
// TestPointInsidePolygon is faster test, special for faces in loop,
// based on polygon sides test and must be call after GetRayPlaneIntersection()
// GetRayPolygonIntersection_MollerTrumbore is slow, special for few faces,
// but it find t-value, triangle ID and UV coordinates.
// GetRayFaceIntersection_MollerTrumbore slow for direct face vertices
// CountVertices must be >= 3
procedure GetRayFaceIntersection_MollerTrumbore(
  const Vertices: PVec3f; const CountVertices: Integer;
  const Plane: tPlane;
  const Ray: tRay; const TraceInfo: PTraceInfo);
procedure GetRayPolygonIntersection_MollerTrumbore(
  const Poly: tPolygon3f; const Ray: tRay; const TraceInfo: PTraceInfo); //}
function TestPointInsidePolygon(
  const Poly: tPolygon3f; const PointOnPlane: tVec4f): Boolean;


procedure CopyBitmapToRGB888(const Src: TBitmap; const Dest: PRGB888);
procedure CopyRGB888toBitmap(const Src: PRGB888; const Dest: TBitmap);
procedure SumTexturesRGB(const SrcA, SrcB, Dst: PRGB888; const Count: Integer);
procedure CopyTexturesRGB(const Src, Dst: PRGB888; const Count: Integer);

procedure CopyLightmaps(const Src, Dst: PLightmap; const Count: Integer);
procedure CopyLightmapsFixExp(const Src, Dst: PLightmap; const Count: Integer);


procedure NearestRescaleLightmapToBitmap(const SrcData: PLightmap;
  const SrcSize: PVec2s; const DstImg: TBitmap; const isRGB: Boolean);


implementation


procedure ZeroFillChar(const Buffer: PByte; const SizeBuffer: Integer);
asm
  // EAX -> Buffer Pointer
  // EDX -> Buffer Size in Bytes
  {$R-}
  push EDI

  mov EDI, EAX { Point EDI to destination }
  xor EAX, EAX

  mov ECX, EDX
  sar ECX, 2
  js  @@exit

  REP stosd   { Fill dwords }

  mov ECX, EDX
  and ECX, 3
  REP stosb   { Fill remainder 0-3 bytes }

@@exit:
  pop EDI
  {$R+}
end;

procedure ZeroFillDWORD(const Buffer: PByte; const SizeBuffer: Integer);
asm
  // EAX -> Buffer Pointer
  // EDX -> Buffer Size in Bytes
  {$R-}
  push EDI

  mov EDI, EAX { Point EDI to destination }
  xor EAX, EAX

  mov ECX, EDX
  sar ECX, 2
  js  @@exit

  REP stosd   { Fill dwords }

@@exit:
  pop EDI
  {$R+}
end;

procedure FillChar0xFF(const Buffer: PByte; const SizeBuffer: Integer);
asm
  // EAX -> Buffer Pointer
  // EDX -> Buffer Size in Bytes
  {$R-}
  CMP   EDX, 0
  JLE   @@exit
  //
  PUSH  EDI
  MOV   EDI, EAX        { Point EDI to destination }
  MOV   EAX, $FFFFFFFF
  MOV   ECX, EDX
  SHR   ECX, 2
  REP   STOSD           { Fill count DIV 4 dwords }
  MOV   ECX, EDX
  AND   ECX, 3
  REP   STOSB           { Fill count MOD 4 bytes }
  POP   EDI
@@exit:

  {$R+}
end;

procedure ZeroFill16K(const Buffer: Pointer);
asm
  {$R-}
  // EAX = Buffer
  push EDI
  mov EDI, EAX
  xor EAX, EAX // Filler EAX = 0
  mov ECX, $00001000 // $1000 = 4096 = 16384 / 4;
  rep stosd
  // rep:
  // 1. MOV [EDX], EAX
  // 2. EDI = EDI + 4
  // 3. ECX = ECX - 1
  // 4. if (ECX <> 0) go to step 1.
  pop EDI
  {$R+}
end;

procedure ZeroFill64K(const Buffer: Pointer);
asm
  {$R-}
  // EAX = Buffer
  push EDI
  mov EDI, EAX
  xor EAX, EAX // Filler EAX = 0
  mov ECX, $00004000 // $4000 = 16384 = 65536 / 4;
  rep stosd
  // rep:
  // 1. MOV [EDX], EAX
  // 2. EDI = EDI + 4
  // 3. ECX = ECX - 1
  // 4. if (ECX <> 0) go to step 1.
  pop EDI
  {$R+}
end;

procedure NormalizeVec3f(const lpVec: PVec3f);
{var
  tmp: Single;
begin //}
asm
  {$R-}
  {tmp:=Sqr(lpVec.x) + Sqr(lpVec.y) + Sqr(lpVec.z);
  if (PInteger(@tmp)^ > 0) then
    begin
      tmp:=1.0/Sqrt(tmp);
      lpVec.x:=lpVec.x*tmp;
      lpVec.y:=lpVec.y*tmp;
      lpVec.z:=lpVec.z*tmp;
    end
  else
    begin
      lpVec^:=VEC_ZERO;
    end; //}

  FLD     tVec3f[EAX].x
  FLD     tVec3f[EAX].y
  FLD     tVec3f[EAX].z
  // st0..2 = [z, y, x]
  FLD     ST(0)
  FMUL    ST(0), ST(0)
  // st0..3 = [Sqr(z), z, y, x]
  FLD     ST(2)
  FMUL    ST(0), ST(0)
  FADDP   ST(1), ST(0)
  // st0..3 = [Sqr(y) + Sqr(z), z, y, x]
  FLD     ST(3)
  FMUL    ST(0), ST(0)
  FADDP   ST(1), ST(0)
  FSQRT
  // st0..3 = [Length = Sqrt(Sqr(x) + Sqr(y) + Sqr(z)), z, y, x]
  FLDZ
  // st0..4 = [0, Length, z, y, x]
  FCOMIP  ST(0), ST(1)
  // st0..4 = [Length, z, y, x], EFLAGS is set
  FLD1
  // st0..4 = [1, Length, z, y, x]
  FCMOVB  ST(0), ST(1)  // if (Length > 0) then ST(0) = Length, else ST(0) = 1
  FSTP    ST(1)
  // st0..3 = [denom, z, y, x]
  FLD1
  // st0..4 = [1, denom, z, y, x]
  FDIVRP  ST(1), ST(0)
  // st0..3 = [1/denom, z, y, x]
  FMUL    ST(3), ST(0)
  FMUL    ST(2), ST(0)
  FMULP   ST(1), ST(0)
  // st0..2 = [z/denom, y/denom, x/denom]
  FSTP    tVec3f[EAX].z
  FSTP    tVec3f[EAX].y
  FSTP    tVec3f[EAX].x
  {$R+}
end;

function SqrLengthVec3f(const Vec: tVec3f): Extended;
asm
  {$R-}
  FLD     Vec.x
  FMUL    ST(0), ST(0)
  FLD     Vec.y
  FMUL    ST(0), ST(0)
  FLD     Vec.z
  FMUL    ST(0), ST(0)
  FADDP
  FADDP

  {$R+}
end;

function DotVec3f(const VecA, VecB: tVec3f): Extended; overload;
asm
  {$R-}
  FLD   VecA.x
  FMUL  VecB.x
  FLD   VecA.y
  FMUL  VecB.y
  FLD   VecA.z
  FMUL  VecB.z
  FADDP
  FADDP
  {$R+}
end;

function DotVec3f(const VecA, VecB: tVec4f): Extended; overload;
asm
  {$R-}
  FLD   VecA.x
  FMUL  VecB.x
  FLD   VecA.y
  FMUL  VecB.y
  FLD   VecA.z
  FMUL  VecB.z
  FADDP
  FADDP
  {$R+}
end;

function DotVec3f(const VecA: tVec3f; const VecB: tVec4f): Extended; overload;
asm
  {$R-}
  FLD   VecA.x
  FMUL  VecB.x
  FLD   VecA.y
  FMUL  VecB.y
  FLD   VecA.z
  FMUL  VecB.z
  FADDP
  FADDP
  {$R+}
end;

function DotVec3f(const VecA: tVec4f; const VecB: tVec3f): Extended; overload;
asm
  {$R-}
  FLD   VecA.x
  FMUL  VecB.x
  FLD   VecA.y
  FMUL  VecB.y
  FLD   VecA.z
  FMUL  VecB.z
  FADDP
  FADDP
  {$R+}
end;

function  DotVec3f4f(const Vec3: tVec3f; const Vec4: tVec4f): Extended;
asm
  {$R-}
  FLD   Vec3.x
  FMUL  Vec4.x
  FLD   Vec3.y
  FMUL  Vec4.y
  FLD   Vec3.z
  FMUL  Vec4.z
  FADDP
  FADDP
  FADD  Vec4.w
  {$R+}
end;

procedure DotVec4f(const VecA, VecB: PVec4f; const res: PSingle);
asm
  {$R-}
  MOVUPS    XMM0, DQWORD PTR [EAX]
  MOVUPS    XMM1, DQWORD PTR [EDX]
  MULPS     XMM0, XMM1
  MOVUPS    XMM1, XMM0
  SHUFPS    XMM1, XMM0, $B1
  ADDPS     XMM0, XMM1
  MOVHLPS   XMM1, XMM0
  ADDSS     XMM0, XMM1
  MOVSS     DWORD PTR [ECX], XMM0
  {$R+}
end;

procedure CrossVec3f(const VecA, VecB, VecRes: PVec3f);
begin
  // VecRes = [VecA, VecB];
  {$R-}
  VecRes.x:=VecA.y*VecB.z - VecA.z*VecB.y;
  VecRes.z:=VecA.x*VecB.y - VecA.y*VecB.x;
  VecRes.y:=VecA.z*VecB.x - VecA.x*VecB.z;
  {$R+}
end;

procedure TranslateVertexArray4f(const Vertex: PVec4f; const lpOffset: PVec4f; const Count: Integer);
asm
  // EAX -> Pointer on Vertex[0] (tVec4f)
  // EDX -> Pointer on tVec3f
  // ECX -> Pointer on Count of Vertex
  {$R-}
  CMP     ECX, 0
  JLE   @@BadLen // if array length <= 0 - Exit
  //
  MOVUPS  XMM1, DQWORD PTR [EDX]
  XOR     EDX, EDX
  SHL     ECX, 4
  //
@@LoopTranslate:
  MOVUPS  XMM0, DQWORD PTR [EAX + EDX]
  ADDPS   XMM0, XMM1
  MOVUPS  DQWORD PTR [EAX + EDX], XMM0
  ADD     EDX, 16
  CMP     EDX, ECX
  JL    @@LoopTranslate
  //
@@BadLen:
  {$R+}
end;

function  SqrDistVec3f(const VecA, VecB: tVec3f): Extended;
var
  Dist: tVec3f;
begin
  {$R-}
  Dist.x:=VecB.x - VecA.x;
  Dist.y:=VecB.y - VecA.y;
  Dist.z:=VecB.z - VecA.z;
  Result:=SqrLengthVec3f(Dist);
  {$R+}
end;

function FloatToStrFixed(const Value: Single): String;
begin
  {$R-}
  Result:=FloatToStrF(Value, ffGeneral, 6, 6);
  {$R+}
end;

function VecToStr(const Vec3f: tVec3f): String; overload;
var
  tmpStr: String;
begin
  {$R-}
  Result:='(';
  tmpStr:=FloatToStrFixed(Vec3f.x);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=FloatToStrFixed(Vec3f.y);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=FloatToStrFixed(Vec3f.z);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ')'
  else Result:=Result + ' ' + tmpStr + ')';
  {$R+}
end;

function VecToStr(const Vec4f: tVec4f): String; overload;
var
  tmpStr: String;
begin
  {$R-}
  Result:='(';
  tmpStr:=FloatToStrFixed(Vec4f.x);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=FloatToStrFixed(Vec4f.y);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=FloatToStrFixed(Vec4f.z);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ')'
  else Result:=Result + ' ' + tmpStr + ')';
  {$R+}
end;

function StrToVec(const Str: String; const Vec: PVec3f): Boolean;
var
  n: Integer;
  tmp: TStringList;
begin
  {$R-}
  StrToVec:=False;
  n:=Length(Str);
  if (n < 5) then Exit;

  tmp:=TStringList.Create;
  tmp.Delimiter:=' ';
  tmp.DelimitedText:=Str;
  if (tmp.Count <> 3) then
    begin
      tmp.Clear;
      tmp.Destroy;
      Exit;
    end;

  Vec.x:=StrToFloatDef(tmp.Strings[0], 1/0);
  Vec.y:=StrToFloatDef(tmp.Strings[1], 1/0);
  Vec.z:=StrToFloatDef(tmp.Strings[2], 1/0);

  tmp.Clear;
  tmp.Destroy;
  StrToVec:=True;
  {$R+}
end;

procedure GetBBOX3f(const Vertices: PVec3f; const BBOX3f: PBBOX3f;
  const Count, Stride: Integer);
var
  i: Integer;
  ptr: PByte;
begin
  {$R-}
  ptr:=Pointer(Vertices);
  BBOX3f.vMin:=Vertices^;
  BBOX3f.vMax:=Vertices^;
  if (Stride < 0) then Exit;

  if (Stride >= SizeOf(tVec3f)) then for i:=1 to Count-1 do
    begin
      if (PVec3f(ptr).x < BBOX3f.vMin.x) then BBOX3f.vMin.x:=PVec3f(ptr).x;
      if (PVec3f(ptr).y < BBOX3f.vMin.y) then BBOX3f.vMin.y:=PVec3f(ptr).y;
      if (PVec3f(ptr).z < BBOX3f.vMin.z) then BBOX3f.vMin.z:=PVec3f(ptr).z;

      if (PVec3f(ptr).x > BBOX3f.vMax.x) then BBOX3f.vMax.x:=PVec3f(ptr).x;
      if (PVec3f(ptr).y > BBOX3f.vMax.y) then BBOX3f.vMax.y:=PVec3f(ptr).y;
      if (PVec3f(ptr).z > BBOX3f.vMax.z) then BBOX3f.vMax.z:=PVec3f(ptr).z;

      Inc(ptr, Stride);
    end
  else for i:=1 to Count-1 do
    begin
      if (PVec3f(ptr).x < BBOX3f.vMin.x) then BBOX3f.vMin.x:=PVec3f(ptr).x;
      if (PVec3f(ptr).y < BBOX3f.vMin.y) then BBOX3f.vMin.y:=PVec3f(ptr).y;
      if (PVec3f(ptr).z < BBOX3f.vMin.z) then BBOX3f.vMin.z:=PVec3f(ptr).z;

      if (PVec3f(ptr).x > BBOX3f.vMax.x) then BBOX3f.vMax.x:=PVec3f(ptr).x;
      if (PVec3f(ptr).y > BBOX3f.vMax.y) then BBOX3f.vMax.y:=PVec3f(ptr).y;
      if (PVec3f(ptr).z > BBOX3f.vMax.z) then BBOX3f.vMax.z:=PVec3f(ptr).z;

      Inc(ptr, SizeOf(tVec3f));
    end;
  {$R+}
end;

procedure GetTexBBOX(const TexCoords: AVec2f; const lpTexBBOXf: PTexBBOXf;
  const CountCoords: Integer);
var
  i: Integer;
begin
  {$R-}
  lpTexBBOXf.vMin:=TexCoords[0];
  lpTexBBOXf.vMax:=TexCoords[0];
  if (CountCoords = 1) then Exit;
  for i:=1 to (CountCoords - 1) do
    begin
      if (TexCoords[i].x < lpTexBBOXf.vMin.x) then lpTexBBOXf.vMin.x:=TexCoords[i].x;
      if (TexCoords[i].x > lpTexBBOXf.vMax.x) then lpTexBBOXf.vMax.x:=TexCoords[i].x;

      if (TexCoords[i].y < lpTexBBOXf.vMin.y) then lpTexBBOXf.vMin.y:=TexCoords[i].y;
      if (TexCoords[i].y > lpTexBBOXf.vMax.y) then lpTexBBOXf.vMax.y:=TexCoords[i].y;
    end;
  {$R+}
end;

procedure BBOX3sTo3f(const src: PBBOXs; const dst: PBBOX3f);
begin
  {$R-}
  dst.vMin.x:=src.nMin.x;
  dst.vMin.y:=src.nMin.y;
  dst.vMin.z:=src.nMin.z;
  dst.vMax.x:=src.nMax.x;
  dst.vMax.y:=src.nMax.y;
  dst.vMax.z:=src.nMax.z;
  {$R+}
end;

function TestPointInBBOX4f(const BBOX4f: tBBOX4f; const Point: tVec4f): Boolean;
begin
  {$R-}
  if (Point.x < BBOX4f.vMin.x) then
    begin
      Result:=False;
      Exit;
    end;
  if (Point.y < BBOX4f.vMin.y) then
    begin
      Result:=False;
      Exit;
    end;
  if (Point.z < BBOX4f.vMin.z) then
    begin
      Result:=False;
      Exit;
    end;

  if (Point.x > BBOX4f.vMax.x) then
    begin
      Result:=False;
      Exit;
    end;
  if (Point.y > BBOX4f.vMax.y) then
    begin
      Result:=False;
      Exit;
    end;
  if (Point.z > BBOX4f.vMax.z) then
    begin
      Result:=False;
      Exit;
    end;

  Result:=True;
  {$R+}
end;

function TestIntersectionTwoBBOX4f(const BBOX4fA, BBOX4fB: tBBOX4f): Boolean;
asm
  {$R-}
  {Result:=(
    (BBOX4fA.vMax.x >= BBOX4fB.vMin.x) and (BBOX4fA.vMin.x <= BBOX4fB.vMax.x) and
    (BBOX4fA.vMax.y >= BBOX4fB.vMin.y) and (BBOX4fA.vMin.y <= BBOX4fB.vMax.y) and
    (BBOX4fA.vMax.z >= BBOX4fB.vMin.z) and (BBOX4fA.vMin.z <= BBOX4fB.vMax.z)
  ); //}
  MOVUPS    XMM2, DQWORD PTR [EAX +  0]  // BBOX4fA.vMin
  MOVUPS    XMM3, DQWORD PTR [EAX + 16]  // BBOX4fA.vMax
  MOVUPS    XMM4, DQWORD PTR [EDX +  0]  // BBOX4fB.vMin
  MOVUPS    XMM5, DQWORD PTR [EDX + 16]  // BBOX4fB.vMax
  //
  MOVUPS    XMM0, XMM3
  CMPPS     XMM0, XMM4, 5
  MOVUPS    XMM1, XMM2
  CMPPS     XMM1, XMM5, 2
  ANDPS     XMM0, XMM1
  PMOVMSKB   EAX, XMM0
  OR          AX, $0F
  NOT         AX
  TEST        AX, AX
  SETZ        AL
  {$R+}
end;

function TestIntersectionTwoBBOX3f(const BBOX3fA, BBOX3fB: tBBOX3f): Boolean;
begin
  {$R-}
  Result:=(
    (BBOX3fA.vMax.x >= BBOX3fB.vMin.x) and (BBOX3fA.vMin.x <= BBOX3fB.vMax.x) and
    (BBOX3fA.vMax.y >= BBOX3fB.vMin.y) and (BBOX3fA.vMin.y <= BBOX3fB.vMax.y) and
    (BBOX3fA.vMax.z >= BBOX3fB.vMin.z) and (BBOX3fA.vMin.z <= BBOX3fB.vMax.z)
  ); //}
  {$R+}
end;

procedure TranslateBBOX4f(const BBOX4f: tBBOX4f; const OffsetVec: tVec4f);
asm
  {$R-}
  MOVUPS    XMM1, DQWORD PTR [EDX]
  //
  MOVUPS    XMM0, DQWORD PTR [EAX]
  ADDPS     XMM0, XMM1
  MOVUPS    DQWORD PTR [EAX], XMM0
  MOVUPS    XMM0, DQWORD PTR [EAX + 16]
  ADDPS     XMM0, XMM1
  MOVUPS    DQWORD PTR [EAX + 16], XMM0
  {$R+}
end;

procedure GetSizeBBOX4f(const BBOX4f: tBBOX4f; const lpSize: PVec4f);
asm
  {$R-}
  MOVUPS    XMM0, DQWORD PTR [EAX]
  MOVUPS    XMM1, DQWORD PTR [EAX + 16]
  SUBPS     XMM1, XMM0
  MOVUPS    DQWORD PTR [EDX], XMM1
  {$R+}
end;

procedure GetCenterBBOX4f(const BBOX4f: tBBOX4f; const lpCenter: PVec4f);
const
  Half4f: tVec4f = (x: 0.5; y:0.5; z: 0.5; w: 0.5);
asm
  {$R-}
  MOVUPS    XMM0, DQWORD PTR [EAX]
  MOVUPS    XMM1, DQWORD PTR [EAX + 16]
  ADDPS     XMM0, XMM1
  MOVUPS    XMM1, Half4f
  MULPS     XMM0, XMM1
  MOVUPS    DQWORD PTR [EDX], XMM0
  {$R+}
end;

procedure GetCenterBBOX3s(const BBOX3s: tBBOXs; const lpCenter: PVec3f);
begin
  {$R-}
  lpCenter.x:=(BBOX3s.nMin.x - BBOX3s.nMax.x)*0.5;
  lpCenter.y:=(BBOX3s.nMin.y - BBOX3s.nMax.y)*0.5;
  lpCenter.z:=(BBOX3s.nMin.z - BBOX3s.nMax.z)*0.5;
  {$R+}
end;

procedure GetCenterBBOX3f(const BBOX3f: tBBOX3f; const lpCenter: PVec3f);
begin
  {$R-}
  lpCenter.x:=(BBOX3f.vMin.x - BBOX3f.vMax.x)*0.5;
  lpCenter.y:=(BBOX3f.vMin.y - BBOX3f.vMax.y)*0.5;
  lpCenter.z:=(BBOX3f.vMin.z - BBOX3f.vMax.z)*0.5;
  {$R+}
end;

procedure RGB888toTRGBTriple(const lpRGBColor: PRGB888; var BGRColor: TRGBTriple);
begin
  {$R-}
  BGRColor.rgbtRed:=lpRGBColor.r;
  BGRColor.rgbtGreen:=lpRGBColor.g;
  BGRColor.rgbtBlue:=lpRGBColor.b;
  {$R+}
end;

procedure TRGBTripleToRGB888(const BGRColor: TRGBTriple; const lpRGBColor: PRGB888);
begin
  {$R-}
  lpRGBColor.r:=BGRColor.rgbtRed;
  lpRGBColor.g:=BGRColor.rgbtGreen;
  lpRGBColor.b:=BGRColor.rgbtBlue;
  {$R+}
end;

procedure RGBA8888toTRGBQuad(const lpRGBAColor: PRGBA8888; var BGRAColor: TRGBQuad);
begin
  {$R-}
  BGRAColor.rgbRed:=lpRGBAColor.r;
  BGRAColor.rgbGreen:=lpRGBAColor.g;
  BGRAColor.rgbBlue:=lpRGBAColor.b;
  BGRAColor.rgbReserved:=lpRGBAColor.a;
  {$R+}
end;

procedure TRGBQuadToRGBA8888(const BGRColor: TRGBQuad; const lpRGBAColor: PRGBA8888);
begin
  {$R-}
  lpRGBAColor.r:=BGRColor.rgbRed;
  lpRGBAColor.g:=BGRColor.rgbGreen;
  lpRGBAColor.b:=BGRColor.rgbBlue;
  lpRGBAColor.a:=BGRColor.rgbReserved;
  {$R+}
end;


function LightMapToStr(const LightMap: tRGB888): String;
begin
  {$R-}
  Result:='( ' + IntToStr(LightMap.r) + ', ' + IntToStr(LightMap.g) +
    ', ' + IntToStr(LightMap.b) + ')';
  {$R+}
end;

function BoolToStrYesNo(const boolValue: Boolean): String;
const
  StrYes: String = 'Yes';
  StrNo: String = 'No';
begin
  if (boolValue) then Result:=StrYes else Result:=StrNo;
end;


procedure CopyBytes(const lpSrc, lpDest: PByte; const CountCopyBytes: Integer);
asm
  {$R-}
  CMP     ECX, 0    // ECX = CountCopyBytes
  JLE   @@exitcopy
  CMP     EAX, 0    // lpSrc = nil
  JZ    @@exitcopy
  CMP     EDX, 0    // lpDest = nil
  JZ    @@exitcopy
  //
  PUSH    ESI
  PUSH    EDI
  MOV     EDI, EDX  // lpDest to EDI
  MOV     ESI, EAX  // lpSrc to ESI
  MOV     EDX, ECX
  SHR     ECX, 2
  AND     EDX, $03
  //
  REP     MOVSD   { Copy count DIV 4 dwords }
  //
  MOV     ECX, EDX
  REP     MOVSB   { Copy count MOD 4 bytes }
  //
  POP     EDI
  POP     ESI
@@exitcopy:
  {$R+}
end;

procedure SetBytesByBoolMask(const lpBoolMask, lpDest: PByte;
  const CountCopyBytes: Integer; const Value: DWORD);
{var
  i: Integer;
begin //}
asm
  {$R-}
  {for i:=0 to (CountCopyBytes - 1) do
    begin
      if (AByteBool(lpBoolMask)[i]) then
        begin
          AByte(lpDest)[i]:=Value;
        end
      else
        begin
          AByte(lpDest)[i]:=(Value shr 8);
        end;
    end; //}
  //
  // EAX = lpBoolMask; EDX = lpDest; ECX = CountCopyBytes;
  // Value in Stack as dword [EBP + 8]
  //
	// Faster version with CMOVcc instead of if-else in loop
  CMP     ECX, 0
  JLE   @@exitfill
  PUSH    ESI
  PUSH    EDI
  PUSH    EBX
  MOV     ESI, EAX
  MOV     EDI, EDX
  //
  XOR     EAX, EAX
  MOV     EDX, Value  // DL for True case, DH for False case
  MOVZX   EBX, DH     // EBX have value for False case
  MOVZX   EDX, DL     // EDX have value for True case
  //
@@fillloop:
  LODSB
  TEST    EAX, EAX    // False = 0, True <> 0
  CMOVNE  EAX, EDX
  CMOVE   EAX, EBX
  STOSB
  DEC     ECX
  JNZ   @@fillloop
  //
  POP     EBX
  POP     EDI
  POP     ESI
@@exitfill: //}
  {$R+}
end;

procedure FillLightmaps(const lpDest, FillColor: PRGB888; const CountDest: Integer);
var
  i: Integer;
begin
  {$R-}
  for i:=0 to (CountDest - 1) do
    begin
      ARGB888(lpDest)[i]:=FillColor^;
    end;
  {$R+}
end;

function CompareString(const Str1, Str2: String; CompareSize: Integer): Boolean;
var
  i: Integer;
begin
  {$R-}
  if ((Length(Str1) < CompareSize) or (Length(Str2) < CompareSize)) then
    begin
      Result:=False;
      Exit;
    end;

  for i:=1 to CompareSize do
    begin
      if (Str1[i] <> Str2[i]) then
        begin
          Result:=False;
          Exit;
        end;
    end;

  Result:=True;
  {$R+}
end;



function GetPointPlaneDistance(const Plane: PPlane; const Point: tVec4f): Single;
begin
  {$R-}
  if (Plane.AxisType = PLANE_X) then
    begin
      Result:=Point.x*Plane.Normal.x - Plane.Dist;
      Exit;
    end;

  if (Plane.AxisType = PLANE_Y) then
    begin
      Result:=Point.y*Plane.Normal.y - Plane.Dist;
      Exit;
    end;

  if (Plane.AxisType = PLANE_Z) then
    begin
      Result:=Point.z*Plane.Normal.z - Plane.Dist;
      Exit;
    end; //}

  Result:=Plane.Normal.x*Point.x + Plane.Normal.y*Point.y +
    Plane.Normal.z*Point.z - Plane.Dist;
  {$R+}
end;
function GetPointPlaneDistanceFull(const Plane: PPlane; const Point: tVec4f): Single;
asm
  {$R-}
  {Result:=Plane.Normal.x*Point.x + Plane.Normal.y*Point.y +
    Plane.Normal.z*Point.z - Plane.Dist; //}
  FLD     tVec4f[EDX].x
  FMUL    tPlane[EAX].Normal.x
  FLD     tVec4f[EDX].y
  FMUL    tPlane[EAX].Normal.y
  FLD     tVec4f[EDX].z
  FMUL    tPlane[EAX].Normal.z
  FADDP
  FADDP
  FSUB    tPlane[EAX].Dist
  {$R+}
end;


function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec4f): Boolean;
begin
  {$R-}
  if (Plane.AxisType = PLANE_X) then
    begin
      if (PInteger(@Plane.Normal.x)^ >= 0) then
        begin
          Result:=Boolean( Point.x >= Plane.Dist);
          Exit;
        end
      else
        begin
          Result:=Boolean(-Point.x >= Plane.Dist);
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Y) then
    begin
      if (PInteger(@Plane.Normal.y)^ >= 0) then
        begin
          Result:=Boolean( Point.y >= Plane.Dist);
          Exit;
        end
      else
        begin
          Result:=Boolean(-Point.y >= Plane.Dist);
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Z) then
    begin
      if (PInteger(@Plane.Normal.z)^ >= 0) then
        begin
          Result:=Boolean( Point.z >= Plane.Dist);
          Exit;
        end
      else
        begin
          Result:=Boolean(-Point.z >= Plane.Dist);
          Exit;
        end;
    end;

  Result:=Boolean(
    ( Plane.Normal.x*Point.x +
      Plane.Normal.y*Point.y +
      Plane.Normal.z*Point.z ) >= Plane.Dist
  );
  {$R+}
end;

function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec4f): Boolean;
asm
  {$R-}
  {isPointInFrontPlaneSpaceFull:=Boolean(
    ( Plane.Normal.x*Point.x +
      Plane.Normal.y*Point.y +
      Plane.Normal.z*Point.z ) >= Plane.Dist
  ); //}
  FLD     tPlane[EAX].Dist
  FLD     tVec4f[EDX].x
  FMUL    tPlane[EAX].Normal.x
  FLD     tVec4f[EDX].y
  FMUL    tPlane[EAX].Normal.y
  FLD     tVec4f[EDX].z
  FMUL    tPlane[EAX].Normal.z
  FADDP
  FADDP
  // st0 = Dot(Plane.Normal, Point.xyz), st1 = Dist
  XOR     EAX, EAX
  FCOMIP  ST(0), ST(1)
  SETAE   AL
  FSTP    ST(0)
  {$R+}
end;


function GetPlaneByPoints(const V0, V1, V2: tVec4f; const Plane: PPlane): Boolean;
var
  Edge1, Edge2: tVec4f;
begin
  {$R-}
  // Get Edges
  Edge1.x:=V1.x - V0.x;
  Edge1.y:=V1.y - V0.y;
  Edge1.z:=V1.z - V0.z;

  Edge2.x:=V2.x - V0.x;
  Edge2.y:=V2.y - V0.y;
  Edge2.z:=V2.z - V0.z;

  // Get Normal by Cross(Edge2, Edge1);
  CrossVec3f(@Edge2, @Edge1, @Plane.Normal);

  // Normalize plane end check if normal is zeros
  NormalizeVec3f(@Plane.Normal);
  if (SqrLengthVec3f(Plane.Normal) <= 0) then
    begin
      // Triple Points V0..2 is bad, belong to both line or lie on one point.
      Result:=False;
      Exit;
    end;

  // Get fourth parameter of Plane Equation and plane axis type
  Plane.Dist:=DotVec3f(Plane.Normal, V0);
  Plane.AxisType:=GetPlaneTypeByNormal(Plane.Normal);
  Result:=True;
  {$R+}
end;

procedure TranslatePlane(const SrcPlane, DstPlane: PPlane; const Offset: Single);
begin
  {$R-}
  DstPlane.Normal:=SrcPlane.Normal;
  DstPlane.Dist:=SrcPlane.Dist + Offset;
  DstPlane.AxisType:=SrcPlane.AxisType;
  {$R+}
end;

procedure TranslatePlane(const SrcPlane, DstPlane: PPlane; const OffsetVec: tVec4f);
begin
  {$R-}
  DstPlane.Normal:=SrcPlane.Normal;
  DstPlane.Dist:=SrcPlane.Dist +
    OffsetVec.x*SrcPlane.Normal.x +
    OffsetVec.y*SrcPlane.Normal.y +
    OffsetVec.z*SrcPlane.Normal.z;
  DstPlane.AxisType:=SrcPlane.AxisType;
  {$R+}
end;


function PlaneToStr(const PlaneBSP: tPlane): String;
begin
  {$R-}
  Result:='[' + VecToStr(PlaneBSP.Normal) +
    ', ' + FloatToStrFixed(PlaneBSP.Dist) + ']';
  {$R+}
end;

function PlaneToStrExt(const PlaneBSP: tPlane): String;
begin
  {$R-}
  Result:='[Normal: ' + VecToStr(PlaneBSP.Normal) +
    ', Dist: ' + FloatToStrFixed(PlaneBSP.Dist) +
    ', AxisType: ';
  case (PlaneBSP.AxisType) of
    PLANE_X: Result:=Result + 'PLANE_X]';
    PLANE_Y: Result:=Result + 'PLANE_Y]';
    PLANE_Z: Result:=Result + 'PLANE_Z]';
    PLANE_ANY_X: Result:=Result + 'PLANE_ANY_X]';
    PLANE_ANY_Y: Result:=Result + 'PLANE_ANY_Y]';
    PLANE_ANY_Z: Result:=Result + 'PLANE_ANY_Z]';
  else
    Result:=Result + 'Unknown]';
  end;
  {$R+}
end;

function PlaneTypeToStrExt(const PlaneType: Integer): String;
begin
  {$R-}
  case (PlaneType) of
    PLANE_X: Result:='X';
    PLANE_Y: Result:='Y';
    PLANE_Z: Result:='Z';
    PLANE_ANY_X: Result:='Any X';
    PLANE_ANY_Y: Result:='Any Y';
    PLANE_ANY_Z: Result:='Any Z';
  else
    Str(PlaneType, Result);
  end;
  {$R+}
end;

function GetPlaneTypeByNormal(const Normal: tVec3f): Integer;
var
  maxf: Single;
  axis: Integer;
begin
  {$R-}
  // based on GitHub, Valve Source SDK 2013, vbsp, map.cpp:
  // |x| = abs(x), N = Plane Normal;
  // 0-2 are axial planes
  //   PLANE_X: Integer =    0; // vbsp (map.cpp) set when |N.x| = 0x3f800000;
  //   PLANE_Y: Integer =    1; // vbsp (map.cpp) set when |N.y| = 0x3f800000;
  //   PLANE_Z: Integer =    2; // vbsp (map.cpp) set when |N.z| = 0x3f800000;
  // 3-5 are non-axial planes snapped to the nearest
  //   PLANE_ANYX: Integer = 3; // vbsp (map.cpp) set when |N.x| >= Max(|N.y|, |N.z|);
  //   PLANE_ANYY: Integer = 4; // vbsp (map.cpp) set when |N.y| >= Max(|N.x|, |N.z|);
  //   PLANE_ANYZ: Integer = 5; // vbsp (map.cpp) set in other "non-axial plane" cases

  if (Abs(Normal.x) = 1.0) then
    begin
      Result:=PLANE_X;
      Exit;
    end;

  if (Abs(Normal.y) = 1.0) then
    begin
      Result:=PLANE_Y;
      Exit;
    end;

  if (Abs(Normal.z) = 1.0) then
    begin
      Result:=PLANE_Z;
      Exit;
    end;

  maxf:=Abs(Normal.x);
  axis:=PLANE_ANY_X;
  if (maxf > Normal.y) then
    begin
      maxf:=Abs(Normal.y);
      axis:=PLANE_ANY_Y;
    end;
  if (maxf > Abs(Normal.z)) then axis:=PLANE_ANY_Z;
  Result:=axis; //}
  {$R+}
end;


function GetRayPlaneIntersection(
  const Plane: tPlane; const Ray: tRay; const TraceInfo: PTraceInfo): Boolean;
var
  dotRN, proj: Single;
begin
  {$R-}
  // Ray Dir and Poly Normal must be normalized
  dotRN:=Ray.Dir.x*Plane.Normal.x + Ray.Dir.y*Plane.Normal.y
    + Ray.Dir.z*Plane.Normal.z;

  // Test that ray "see" Front Face of Polygon
  // Use fast integer compare technique for positives Float-32 IEEE-754;
  if (PInteger(@dotRN)^ >= 0) then
    begin
      Result:=False;
      Exit;
    end;

  // "Dot(Ray.Start, Normal) - Dist" = distance to plane, and divide by tmp
  // make projection of distance to plane on Ray direction.
  // As when Ray must see plane, then ray.start must be in front part
  // of plane space.
  proj:=-(
    Ray.Start.x*Plane.Normal.x +
    Ray.Start.y*Plane.Normal.y +
    Ray.Start.z*Plane.Normal.z -
    Plane.Dist
  )/dotRN; //}


  if ((PInteger(@proj)^ <= 0) or (PInteger(@proj)^ > PInteger(@TraceInfo.t)^)) then
    begin
      Result:=False;
      Exit;
    end;
  TraceInfo.t:=proj;

  TraceInfo.Point.x:=Ray.Dir.x*TraceInfo.t + Ray.Start.x;
  TraceInfo.Point.y:=Ray.Dir.y*TraceInfo.t + Ray.Start.y;
  TraceInfo.Point.z:=Ray.Dir.z*TraceInfo.t + Ray.Start.z;
  Result:=True;
  {$R+}
end;

function GetRayPlaneIntersectionASM(
  const Plane: tPlane; const Ray: tRay; const TraceInfo: PTraceInfo): Boolean;
asm
  {$R-}
  // EAX = Plane, EDX = Ray, ECX = TraceInfo
  FLD       FLOAT32_INF_POSITIVE
  FLD       tPlane[EAX].Normal.x
  FLD       tPlane[EAX].Normal.y
  FLD       tPlane[EAX].Normal.z
  // st0..3 = (Nz, Ny, Nx, +Inf)
  FLD       tRay[EDX].Dir.x
  FMUL      ST(0), ST(3)
  FLD       tRay[EDX].Dir.y
  FMUL      ST(0), ST(3)
  FLD       tRay[EDX].Dir.z
  FMUL      ST(0), ST(3)
  FADDP     ST(1), ST(0)
  FADDP     ST(1), ST(0)
  FLDZ
  // st0..5 = (0.0, dot(N, R.D), Nz, Ny, Nx, +Inf)
  FCOMIP    ST(0), ST(1)
  FCMOVBE   ST(0), ST(4)
  FCHS
  FXCH      ST(3)
  // st0..4 = (Nx, Nz, Ny, -dotND, +Inf), dotND < 0
  FMUL      tRay[EDX].Start.x
  FXCH      ST(1)
  // st0..4 = (Nz, Nx*Sx, Ny, -dotND, +Inf)
  FMUL      tRay[EDX].Start.z
  FXCH      ST(2)
  FMUL      tRay[EDX].Start.y
  FADDP     ST(1), ST(0)
  FADDP     ST(1), ST(0)
  FSUB      tPlane[EAX].Dist
  // st0..2 = (dot(S, N) - Dist, -dotND, +Inf)
  FDIVRP    ST(1), ST(0)
  // st0..1 = (proj, +Inf)
  FLDZ
  FCOMIP    ST(0), ST(1)
  FXCH      ST(1)
  FCMOVB    ST(0), ST(1)
  FSTP      ST(1)
  FLD       tTraceInfo[ECX].t
  // st0..1 = (t, proj)
  FCOMIP    ST(0), ST(1)
  JAE      @@ProjectionIsValid
  FSTP      ST(0)
  XOR       EAX, EAX
  RET
@@ProjectionIsValid:
  // st0..0 = (proj)
  // now get trace point = Start + Dir*proj
  FLD       tRay[EDX].Dir.x
  FMUL      ST(0), ST(1)
  FADD      tRay[EDX].Start.x
  FSTP      tTraceInfo[ECX].Point.x
  //
  FLD       tRay[EDX].Dir.y
  FMUL      ST(0), ST(1)
  FADD      tRay[EDX].Start.y
  FSTP      tTraceInfo[ECX].Point.y
  //
  FLD       tRay[EDX].Dir.z
  FMUL      ST(0), ST(1)
  FADD      tRay[EDX].Start.z
  FSTP      tTraceInfo[ECX].Point.z
  //
  FSTP      tTraceInfo[ECX].t
  MOV       EAX, $01
  {$R+}
end;


procedure FreePolygon(const Poly: PPolygon3f);
begin
  {$R-}
  Poly.Plane.Normal:=VEC_ZERO_3F;
  Poly.Plane.Dist:=0.0;
  Poly.Plane.AxisType:=PLANE_ANY_Z;
  Poly.Center:=VEC_ZERO_4F;
  Poly.CountVertecies:=0;
  Poly.CountTriangles:=0;
  Poly.CountPackets:=0;
  Poly.CountPlanes:=0;
  SetLength(Poly.Vertecies, 0);
  SetLength(Poly.SidePlanes, 0);
  {$R+}
end;

procedure UpdatePolygon(const Poly: PPolygon3f);
var
  i, j, k, l, m: Integer;
  v1, v2: tVec4f;
  WindingPool: AVec4f;
begin
  {$R-}
  Poly.CountTriangles:=Poly.CountVertecies - 2;
  if (Poly.CountTriangles < 1) then Exit;

  // 1. Resolve plane equation, because Face plane reference to node/visleaf plane,
  // where normal can be in opposite direction.
  Poly.Plane.Dist:=DotVec3f(
    Poly.Plane.Normal,
    Poly.Vertecies[0].Vec3f
  );
  Poly.Plane.AxisType:=GetPlaneTypeByNormal(Poly.Plane.Normal);

  // 2. Get Polygon Center
  Poly.Center:=VEC_ZERO_4F;
  for i:=0 to (Poly.CountVertecies - 1) do
    begin
      Poly.Center.x:=Poly.Center.x + Poly.Vertecies[i].x;
      Poly.Center.y:=Poly.Center.y + Poly.Vertecies[i].y;
      Poly.Center.z:=Poly.Center.z + Poly.Vertecies[i].z;
    end;
  Poly.Center.x:=Poly.Center.x/Poly.CountVertecies;
  Poly.Center.y:=Poly.Center.y/Poly.CountVertecies;
  Poly.Center.z:=Poly.Center.z/Poly.CountVertecies; //}

  // 3. Get polygon side-planes
  // 3.1. Get winding with non-colinear points
  // Original code from: github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/utils/common/polylib.cpp#L90
  SetLength(WindingPool, Poly.CountVertecies);
  Poly.CountPlanes:=0;
  for i:=0 to (Poly.CountVertecies - 1) do
    begin
      j:=(i + 1) mod Poly.CountVertecies;
      k:=(i + (Poly.CountVertecies - 1)) mod Poly.CountVertecies;

      v1.x:=Poly.Vertecies[j].x - Poly.Vertecies[i].x;
      v1.y:=Poly.Vertecies[j].y - Poly.Vertecies[i].y;
      v1.z:=Poly.Vertecies[j].z - Poly.Vertecies[i].z;

      v2.x:=Poly.Vertecies[i].x - Poly.Vertecies[k].x;
      v2.y:=Poly.Vertecies[i].y - Poly.Vertecies[k].y;
      v2.z:=Poly.Vertecies[i].z - Poly.Vertecies[k].z;

      NormalizeVec3f(@v1);
      NormalizeVec3f(@v2);

      if (DotVec3f(v1, v2) < 0.999) then
        begin
          WindingPool[Poly.CountPlanes]:=Poly.Vertecies[i];
          Inc(Poly.CountPlanes);
        end;
    end;

  // 3.2 Allocate Plane Packet array with corrected non-colinear vertecies
  Poly.CountPackets:=(Poly.CountPlanes div 4);
  if ((Poly.CountPlanes mod 4) <> 0) then Inc(Poly.CountPackets);
  SetLength(Poly.SidePlanes, Poly.CountPackets);
  // Special case for unused planes in packet: zeros normal and dist?
  // that make point always "inside face" for test "Is dot(0, P) <= 0"
  ZeroFillChar(@Poly.SidePlanes[0], SizeOf(tPlanePacket)*Poly.CountPackets);
  for i:=0 to (Poly.CountPlanes - 1) do
    begin
      j:=i div 4;
      k:=i mod 4;

      l:=i mod Poly.CountPlanes;
      m:=(i + 1) mod Poly.CountPlanes;

      // Get polygon side edge
      v1.x:=WindingPool[m].x - WindingPool[l].x;
      v1.y:=WindingPool[m].y - WindingPool[l].y;
      v1.z:=WindingPool[m].z - WindingPool[l].z;

      // Get side normal lie on Face, perpendicular to Face plane normal and side edge
      CrossVec3f(@v1, @Poly.Plane.Normal, @v2);
      NormalizeVec3f(@v2);

      Poly.SidePlanes[j].Nx[k]:=v2.x;
      Poly.SidePlanes[j].Ny[k]:=v2.y;
      Poly.SidePlanes[j].Nz[k]:=v2.z;
      Poly.SidePlanes[j].fD[k]:=DotVec3f(v2, WindingPool[l]);
    end;
  {$R+}
end;

procedure GetRayPolygonIntersection_MollerTrumbore(
  const Poly: tPolygon3f; const Ray: tRay; const TraceInfo: PTraceInfo);
var
  tmp: Single;
  edge0, edge1: tVec3f;
  tvec, pvec, qvec: tVec3f;
  i: Integer;
begin
  {$R-}
  // Based on: Moller, Tomas; Trumbore, Ben (1997). "Fast, Minimum Storage
  // Ray-Triangle Intersection". Journal of Graphics Tools. 2: 21–28.
  TraceInfo.iTriangle:=-1;
  // u, v - normalized barycentric coordinates on Poly triangle;
  // t - ray value;
  //
  // PointOnPolyTriangle = Origin + FanEdge0*u + FanEdge1*v;
  // where Origin = Poly.Vertecies[0];
  // FanEdge0 = FanEdges[i]; FanEdge1 = FanEdges[i + 1];
  // Triangle[i] -> vertecies {0, i, i + 1};
  //
  // PoitnOnRay = rayStart + rayDir*t;

  // Ray Dir and Poly Normal must be normalized
  tmp:=Ray.Dir.x*Poly.Plane.Normal.x + Ray.Dir.y*Poly.Plane.Normal.y
    + Ray.Dir.z*Poly.Plane.Normal.z;

  // Test that ray "see" Front Face of Polygon
  if (tmp >= 0.0) then Exit;

  // Calculate distance from vert0 to ray origin, FanEdges[0] = Vertecies[0]
  // FanEdges[i] = Vertecies[i] - Vertecies[0];
  tvec.x:=Ray.Start.x - Poly.Vertecies[0].x;
  tvec.y:=Ray.Start.y - Poly.Vertecies[0].y;
  tvec.z:=Ray.Start.z - Poly.Vertecies[0].z;

  for i:=0 to (Poly.CountTriangles - 1) do
    begin
      edge0.x:=Poly.Vertecies[i + 1].x - Poly.Vertecies[0].x;
      edge0.y:=Poly.Vertecies[i + 1].y - Poly.Vertecies[0].y;
      edge0.z:=Poly.Vertecies[i + 1].z - Poly.Vertecies[0].z;
      //
      edge1.x:=Poly.Vertecies[i + 2].x - Poly.Vertecies[0].x;
      edge1.y:=Poly.Vertecies[i + 2].y - Poly.Vertecies[0].y;
      edge1.z:=Poly.Vertecies[i + 2].z - Poly.Vertecies[0].z;

      CrossVec3f(@Ray.Dir, @edge1, @pvec);
      tmp:=DotVec3f(edge0, pvec);
      // tmp ~ projection triangle Area to screen space.
      // If tmp is near zero, projected triangle is degenerate;
      if (tmp = 0.0) then Continue;

      // Calculate normalazed U baricentric coordinate and test bounds;
      TraceInfo.u:=DotVec3f(tvec, pvec)/tmp;

      // Test U value on boundary [0..1];
      // Use fast integer compare technique for positives Float-32 IEEE-754;
      if (TraceInfo.u < 0.0) then Continue;
      if (TraceInfo.u > 1.0) then Continue;

      CrossVec3f(@tvec, @edge0, @qvec);
      // Calculate normalazed V baricentric coordinate and test bounds
      TraceInfo.v:=DotVec3f(Ray.Dir, qvec)/tmp;

      // Test V value on boundary [0..1];
      // Use fast integer compare technique for positives Float-32 IEEE-754;
      if (TraceInfo.v < 0.0) then Continue;
      if ((TraceInfo.u + TraceInfo.v) > 1.0) then Continue;

      // Calculate RayValue trace parameter and test zero boundary
      TraceInfo.t:=DotVec3f(edge1, qvec)/tmp;
      if (TraceInfo.t < 0.0) then Continue;

      TraceInfo.Point.x:=Ray.Start.x + Ray.Dir.x*TraceInfo.t;
      TraceInfo.Point.y:=Ray.Start.y + Ray.Dir.y*TraceInfo.t;
      TraceInfo.Point.z:=Ray.Start.z + Ray.Dir.z*TraceInfo.t;

      TraceInfo.iTriangle:=i;
      Exit;
    end;
  {$R+}
end;

procedure GetRayFaceIntersection_MollerTrumbore(
  const Vertices: PVec3f; const CountVertices: Integer;
  const Plane: tPlane;
  const Ray: tRay; const TraceInfo: PTraceInfo);
var
  tmp: Single;
  edge0, edge1: tVec3f;
  tvec, pvec, qvec: tVec3f;
  i: Integer;
begin
  {$R-}
  // Based on: Moller, Tomas; Trumbore, Ben (1997). "Fast, Minimum Storage
  // Ray-Triangle Intersection". Journal of Graphics Tools. 2: 21–28.
  TraceInfo.iTriangle:=-1;
  // u, v - normalized barycentric coordinates on Poly triangle;
  // t - ray value;
  //
  // PointOnTriangle = Origin + FanEdge0*u + FanEdge1*v;
  // where Origin = Vertecies[0];
  // FanEdge0 = FanEdges[i]; FanEdge1 = FanEdges[i + 1];
  // Triangle[i] -> vertecies {0, i, i + 1};
  //
  // PoitnOnRay = rayStart + rayDir*t;
  if (CountVertices < 3) then Exit;

  // Ray Dir and Face Normal must be normalized
  tmp:=Ray.Dir.x*Plane.Normal.x + Ray.Dir.y*Plane.Normal.y
    + Ray.Dir.z*Plane.Normal.z;

  // Test that ray "see" Front Face
  if (tmp >= 0.0) then Exit;

  // Calculate distance from vert0 to ray origin, FanEdges[0] = Vertecies[0]
  // FanEdges[i] = Vertecies[i] - Vertecies[0];
  tvec.x:=Ray.Start.x - AVec3f(Vertices)[0].x;
  tvec.y:=Ray.Start.y - AVec3f(Vertices)[0].y;
  tvec.z:=Ray.Start.z - AVec3f(Vertices)[0].z;

  for i:=0 to (CountVertices - 2)-1 do
    begin
      edge0.x:=AVec3f(Vertices)[i + 1].x - AVec3f(Vertices)[0].x;
      edge0.y:=AVec3f(Vertices)[i + 1].y - AVec3f(Vertices)[0].y;
      edge0.z:=AVec3f(Vertices)[i + 1].z - AVec3f(Vertices)[0].z;
      //
      edge1.x:=AVec3f(Vertices)[i + 2].x - AVec3f(Vertices)[0].x;
      edge1.y:=AVec3f(Vertices)[i + 2].y - AVec3f(Vertices)[0].y;
      edge1.z:=AVec3f(Vertices)[i + 2].z - AVec3f(Vertices)[0].z;

      CrossVec3f(@Ray.Dir, @edge1, @pvec);
      tmp:=DotVec3f(edge0, pvec);
      // tmp ~ projection triangle Area to screen space.
      // If tmp is near zero, projected triangle is degenerate;
      if (tmp = 0.0) then Continue;

      // Calculate normalazed U baricentric coordinate and test bounds;
      TraceInfo.u:=DotVec3f(tvec, pvec)/tmp;

      // Test U value on boundary [0..1];
      if (TraceInfo.u < 0.0) then Continue;
      if (TraceInfo.u > 1.0) then Continue;

      CrossVec3f(@tvec, @edge0, @qvec);
      // Calculate normalazed V baricentric coordinate and test bounds
      TraceInfo.v:=DotVec3f(Ray.Dir, qvec)/tmp;

      // Test V value on boundary [0..1];
      if (TraceInfo.v < 0.0) then Continue;
      if ((TraceInfo.u + TraceInfo.v) > 1.0) then Continue;

      // Calculate RayValue trace parameter and test zero boundary
      TraceInfo.t:=DotVec3f(edge1, qvec)/tmp;
      if (TraceInfo.t < 0.0) then Continue;

      TraceInfo.Point.x:=Ray.Start.x + Ray.Dir.x*TraceInfo.t;
      TraceInfo.Point.y:=Ray.Start.y + Ray.Dir.y*TraceInfo.t;
      TraceInfo.Point.z:=Ray.Start.z + Ray.Dir.z*TraceInfo.t;

      TraceInfo.iTriangle:=i;
      Exit;
    end;
  {$R+}
end;

function TestPointInsidePolygon(
  const Poly: tPolygon3f; const PointOnPlane: tVec4f): Boolean;
asm
  {$R-}
  // Based on Valve VRAD Ray-Winding intersection
  {for i:=0 to (Poly.CountVertecies - 1) do
    begin
      if (DotVec3f(Poly.PlaneSides[i].Normal, PointOnPlane) > Poly.PlaneSides[i].Dist) then
        begin
          Result:=False;
          Exit;
        end;
    end;
  Result:=True;}

  // input: EAX -> Poly, EDX -> PointOnPlane
  //  PointOnPlane -> P, PointOnPlane.x -> P.x, ... ect,
  //  Poly.PlaneSides[i].Normal -> Ni, Poly.PlaneSides[i].Dist -> di
  //  Poly.PlaneSides[i].Normal.x -> Nix, ... ect.
  PUSH    ECX
  PUSH    EBX
  MOV     ECX, tPolygon3f[EAX].CountPackets
  MOV     EAX, tPolygon3f[EAX].SidePlanes
  MOVUPS  XMM5, DQWORD PTR [EDX]
  MOVUPS  XMM6, XMM5
  MOVUPS  XMM7, XMM5
  SHUFPS  XMM5, XMM5, $00   // XMM5 = (Px, Px, Px, Px)
  SHUFPS  XMM6, XMM6, $55   // XMM6 = (Py, Py, Py, Py)
  SHUFPS  XMM7, XMM7, $AA   // XMM7 = (Pz, Pz, Pz, Pz)
  // Now ECX = CountVertecies, EAX = SidePlanes as array of tPlanePacket (64 byte)
@@SidePlanesLoop:
  // Plane-Point test part, body of main loop
  MOVUPS  XMM0, DQWORD PTR [EAX + 0*16] // (N1x, N2x, N3x, N4x)
  MULPS   XMM0, XMM5
  MOVUPS  XMM1, DQWORD PTR [EAX + 1*16] // (N1y, N2y, N3y, N4y)
  MULPS   XMM1, XMM6
  MOVUPS  XMM2, DQWORD PTR [EAX + 2*16] // (N1z, N2z, N3z, N4z)
  MULPS   XMM2, XMM7
  MOVUPS  XMM3, DQWORD PTR [EAX + 3*16] // (fD1, fD2, fD3, fD4)
  ADDPS   XMM0, XMM1
  ADDPS   XMM0, XMM2
  // XMM0 = (Dot(N1, P), Dot(N2, P), Dot(N3, P), Dot(N4, P))
  CMPPS   XMM0, XMM3, $01 // is (XMM0 <= XMM3)?
  PMOVMSKB EBX, XMM0
  //NOT      EBX
  TEST     EBX, EBX
  // end loop body
  JNZ    @@PointOutOfFaceSide
  ADD     EAX, 64
  DEC     ECX
  JNZ   @@SidePlanesLoop
  //
  // Exit after loop where point lie on Face and inside of Face borders
  MOV     EAX, $01 // Return True
  POP     EBX
  POP     ECX
  RET
  //
@@PointOutOfFaceSide:
  // Point is out of Face border, Rerutn False
  XOR     EAX, EAX
  POP     EBX
  POP     ECX
  RET  //}
  {$R+}
end;

procedure CopyRGB888toBitmap(const Src: PRGB888; const Dest: TBitmap);
var
  i, j: Integer;
  p: pRGBArray;
  PtrPage: PRGB888;
begin
  {$R-}
  Dest.PixelFormat:=pf24bit;
  PtrPage:=Src;
  for i:=0 to (Dest.Height - 1) do
    begin
      p:=Dest.ScanLine[i];
      for j:=0 to (Dest.Width - 1) do
        begin
          RGB888toTRGBTriple(PtrPage, p^[j]);
          Inc(PtrPage);
        end;
    end;
  {$R+}
end;

procedure CopyBitmapToRGB888(const Src: TBitmap; const Dest: PRGB888);
var
  i, j: Integer;
  p: pRGBArray;
  PtrPage: PRGB888;
begin
  {$R-}
  Src.PixelFormat:=pf24bit;
  PtrPage:=Dest;
  for i:=0 to (Src.Height - 1) do
    begin
      p:=Src.ScanLine[i];
      for j:=0 to (Src.Width - 1) do
        begin
          TRGBTripleToRGB888(p^[j], PtrPage);
          Inc(PtrPage);
        end;
    end;
  {$R+}
end;

procedure SumTexturesRGB(const SrcA, SrcB, Dst: PRGB888; const Count: Integer);
var
  i, r, g, b: Integer;
begin //}
  {$R-}
  if (((SrcA = nil) and (SrcB = nil)) or (Dst = nil)) then Exit;
  
  if (SrcA = nil) then
    begin
      CopyTexturesRGB(SrcB, Dst, Count);
      Exit;
    end;
  if (SrcB = nil) then
    begin
      CopyTexturesRGB(SrcA, Dst, Count);
      Exit;
    end;

  for i:=0 to (Count - 1) do
    begin
      r:=ARGB888(SrcA)[i].r + ARGB888(SrcB)[i].r;
      g:=ARGB888(SrcA)[i].g + ARGB888(SrcB)[i].g;
      b:=ARGB888(SrcA)[i].b + ARGB888(SrcB)[i].b;
      if (r > 255) then ARGB888(Dst)[i].r:=255 else ARGB888(Dst)[i].r:=r;
      if (g > 255) then ARGB888(Dst)[i].g:=255 else ARGB888(Dst)[i].g:=g;
      if (b > 255) then ARGB888(Dst)[i].b:=255 else ARGB888(Dst)[i].b:=b;
    end; //}
  {$R+}
end;

procedure CopyTexturesRGB(const Src, Dst: PRGB888; const Count: Integer);
asm
  {$R-}
  // EAX = Src, EDX = Dst; ECX = Count
  CMP     ECX, 0
  JLE   @@NoDataToCopy
  TEST    EAX, EAX
  JZ    @@NoDataToCopy
  TEST    EDX, EDX
  JZ    @@NoDataToCopy
  //
  PUSH    ESI
  PUSH    EDI
  MOV     ESI, EAX
  MOV     EDI, EDX
  LEA     ECX, [2*ECX + ECX]
  PUSH    ECX
  SHR     ECX, 2
  //
  REP     MOVSD
  //
  POP     ECX
  AND     ECX, 3
  //
  REP     MOVSB
  //
  POP     EDI
  POP     ESI
  //
@@NoDataToCopy:
  RET
  {$R+}
end;

procedure CopyLightmaps(const Src, Dst: PLightmap; const Count: Integer);
asm
  {$R-}
  // EAX = Src, EDX = Dst; ECX = Count
  CMP     ECX, 0
  JLE   @@NoDataToCopy
  TEST    EAX, EAX
  JZ    @@NoDataToCopy
  TEST    EDX, EDX
  JZ    @@NoDataToCopy
  //
  PUSH    ESI
  PUSH    EDI
  MOV     ESI, EAX
  MOV     EDI, EDX
  //
  REP     MOVSD
  //
  POP     EDI
  POP     ESI
  //
@@NoDataToCopy:
  RET
  {$R+}
end;

procedure CopyLightmapsFixExp(const Src, Dst: PLightmap; const Count: Integer);
asm
  {$R-}
  // EAX = Src, EDX = Dst; ECX = Count
  CMP     ECX, 0
  JLE   @@NoDataToCopy
  TEST    EAX, EAX
  JZ    @@NoDataToCopy
  TEST    EDX, EDX
  JZ    @@NoDataToCopy
  //
  PUSH    ESI
  PUSH    EDI
  MOV     ESI, EAX
  MOV     EDI, EDX
  //
@@CopyFixExp:
  LODSD
  ADD     EAX, $80000000
  CMP     EAX, $80000000
  JNZ   @@NonZeroLmp
  MOV     EAX, $00000000
@@NonZeroLmp:
  STOSD
  LOOP  @@CopyFixExp
  //
  POP     EDI
  POP     ESI
  //
@@NoDataToCopy:
  RET
  {$R+}
end;


procedure NearestRescaleLightmapToBitmap(const SrcData: PLightmap;
  const SrcSize: PVec2s; const DstImg: TBitmap; const isRGB: Boolean);
var
  SrcX, SrcY, DstX, DstY, SrcOffset, grey: Integer;
  ScaleX, ScaleY: Single;
  p: pRGBArray;
  lmp: PLightmap;
begin
  {$R-}
  if (SrcData = nil) or (SrcSize = nil) or (DstImg = nil) then Exit;
  if (SrcSize.x <= 0) or (SrcSize.y <= 0) then Exit;
  if (DstImg.Width <= 0) or (DstImg.Height <= 0) then Exit;
  if (DstImg.PixelFormat <> pf24bit) then Exit;

  ScaleX:=SrcSize.x/DstImg.Width;
  ScaleY:=SrcSize.y/DstImg.Height;
  //
  if (isRGB) then for DstY:=0 to (DstImg.Height - 1) do
    begin
      SrcY:=Round(DstY*ScaleY);
      p:=DstImg.ScanLine[DstY];
      if (SrcY >= SrcSize.y) then SrcY:=SrcSize.y - 1;
      //
      SrcOffset:=SrcY*SrcSize.x;
      for DstX:=0 to (DstImg.Width - 1) do
        begin
          SrcX:=Round(DstX*ScaleX);
          if (SrcX >= SrcSize.x) then SrcX:=SrcSize.x - 1;
          //
          lmp:=@ALightmap(SrcData)[SrcOffset + SrcX];
          p^[DstX].rgbtBlue:=lmp.b;
          p^[DstX].rgbtGreen:=lmp.g;
          p^[DstX].rgbtRed:=lmp.r;
        end;
    end
  else for DstY:=0 to (DstImg.Height - 1) do
    begin
      SrcY:=Round(DstY*ScaleY);
      p:=DstImg.ScanLine[DstY];
      if (SrcY >= SrcSize.y) then SrcY:=SrcSize.y - 1;
      //
      SrcOffset:=SrcY*SrcSize.x;
      for DstX:=0 to (DstImg.Width - 1) do
        begin
          SrcX:=Round(DstX*ScaleX);
          if (SrcX >= SrcSize.x) then SrcX:=SrcSize.x - 1;
          //
          lmp:=@ALightmap(SrcData)[SrcOffset + SrcX];
          grey:=128 + lmp.e*8;
          if (grey < 0) then grey:=0;
          if (grey > 255) then grey:=255;
          p^[DstX].rgbtBlue:=grey;
          p^[DstX].rgbtGreen:=grey;
          p^[DstX].rgbtRed:=grey;
        end;
    end
  {$R+}
end;

end.
