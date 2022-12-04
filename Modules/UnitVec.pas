unit UnitVec;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Base Module, that contain Vector, BBOX and Ray determinate 
// and functions for work with them.

interface

uses SysUtils, Windows, Classes, Graphics, OpenGL, EXTOpengl32Glew32, Math;

const EPSILON: Single = 1E-6;
const inv16f: Single = 0.0625;
const inv255f: Single = 1.0/255.0;
const CRLF = #13#10; // = "/r + /n" // Windows OS
const LFCR = #10#13; // = "/n + /r" // Mac OS
const CR = #13; // = "/r"
const LF = #10; // = "/n" // Unix OS
const SpaceChar: Char = ' ';
const GL_CLAMP_TO_EDGE = 33071;

type AGLuint = array of GLuint;

//*****************************************************************************
type tVec2f = record
    x, y: Single;
  end;
type PVec2f = ^tVec2f;
type AVec2f = array of tVec2f;

type tVec3f = packed record
    x, y, z: Single;
  end;
type PVec3f = ^tVec3f;
type AVec3f = array of tVec3f;

type tVec3d = packed record
    x, y, z: Double;
  end;
type PVec3d = ^tVec3d;
type AVec3d = array of tVec3d;

type tBBOXf = record
    vMin, vMax: tVec3f;
  end;
type PBBOXf = ^tBBOXf;
type ABBOXf = array of tBBOXf;

// Texture Coords BBOX
type tTexBBOXf = record
    Umin, Umax, Vmin, Vmax: Single;
  end;
type PTexBBOXf = ^tTexBBOXf;

type tVec3s = record
    x, y, z: SmallInt; // int16
  end;
type PVec3s = ^tVec3s;
type AVec3s = array of tVec3s;

type tVec3b = record
    x, y, z: Byte; // int8
  end;
type PVec3b = ^tVec3b;
type AVec3b = array of tVec3b;

type tBBOXs = record
    nMin, nMax: tVec3s;
  end;
type PBBOXs = ^tBBOXs;
type ABBOXs = array of tBBOXs;

type tRay = record
    Start, Dir: tVec3f;
  end;
type PRay = ^tRay;
type ARay = array of tRay;


// for TBitmap class method "ScanLine", 24 and 32-bit pixel data version
type pRGBAArray = ^TRGBAArray;
  TRGBAArray = ARRAY[0..32767] OF tagRGBQUAD;
type pRGBArray = ^TRGBArray;
  TRGBArray = ARRAY[0..32767] OF tagRGBTriple;

type tColor4fv = array[0..3] of GLfloat;

const VEC_ORT_X: tVec3f = (x: 1; y: 0; z: 0;);
const VEC_ORT_Y: tVec3f = (x: 0; y: 1; z: 0;);
const VEC_ORT_Z: tVec3f = (x: 0; y: 0; z: 1;);

const VEC_ZERO: tVec3f = (x: 0; y: 0; z: 0);
const VEC_ONE: tVec3f = (x: 1; y: 1; z: 1);
const VEC_INF_P: tVec3f = (x: +1/0; y: +1/0; z: +1/0);
const VEC_INF_N: tVec3f = (x: -1/0; y: -1/0; z: -1/0);

//*****************************************************************************
procedure ClampToOne(const lpValue: PSingle);
procedure ClampVec3fToOne(const lpVec3f: PVec3f);
procedure ZeroFillChar(const Buffer: PByte; const SizeBuffer: Integer);

procedure SignInvertVec(const lpSrc, lpDest: PVec3f); // Vec:= Vec*(-1)
function NormalizeVec3f(const lpVec: PVec3f): Boolean; // Return False if Normal is Zero
procedure Vec3fToVec3s(const lpVec3f: PVec3f; const lpVec3s: PVec3s);

// lpDest.xyz = lpSrc.xyz*lpScale^
// lpDest.xyz = lpSrc.xyz/lpInvScale^
procedure ScaleVec(const lpSrc, lpDest: PVec3f; const lpScale: PSingle);
procedure InvScaleVec(const lpSrc, lpDest: PVec3f; const lpInvScale: PSingle);

procedure GetEdge(const VecFrom, VecTo: tVec3f; const lpEdge: PVec3f); overload;
procedure GetEdge(const VecFrom, VecTo: tVec2f; const lpEdge: PVec2f); overload;
procedure GetEdge(const VecFrom, VecTo: tVec3f; const lpEdge: PVec3f;
  const Scale: Single); overload;
procedure GetEdge(const VecFrom, VecTo: tVec2f; const lpEdge: PVec2f;
  const Scale: Single); overload;

function Dot(const vA, vB: tVec3f): Single; overload;
function Dot(const vA, vB: PVec3f): Single;  overload;
function Dot(const vA, vB: tVec3s): Integer;  overload;
function Dot(const vA: tVec3f; const vB: tVec3s): Single;  overload;
function Dot(const vA: tVec3s; const vB: tVec3f): Single;  overload;

procedure Cross(const lpLeft, lpRight, lpRes: PVec3f);
function GetNormalByEdges(const lpEdge0, lpEdge1, lpNormal: PVec3f): Boolean; // Return False if Normal is Zero

// Vector length = Sqrt(SqrLength(Vector))
function SqrLength(const Vec: tVec3f): Single; overload;
function SqrLength(const Vec: tVec3s): Integer; overload;

// return Sqr distance bewteen VecA and VecB
function SqrDistTwoVec(const lpVecA, lpVecB: tVec3f): Single;

// lpSrc.xyz = lpSrc.xyz + lpAdd.xzy*lpScale^
// lpSrc.xyz = lpSrc.xyz - lpSub.xzy*lpScale^
procedure AddWithScaleVec(const lpSrc, lpAdd: PVec3f; const lpScale: PSingle);
procedure SubWithScaleVec(const lpSrc, lpSub: PVec3f; const lpScale: PSingle);

// return True if equal by each components
function CompareVec(const vA, vB: tVec3f): Boolean; overload;
function CompareVec(const vA, vB: tVec3s): Boolean; overload;
function CompareVec(const vA: tVec3f; vB: tVec3s): Boolean; overload;
function CompareVec(const vA: tVec3s; vB: tVec3f): Boolean; overload;

// return True if Vector is Zero (all components is +0.0 or -0.0)
function isVec3fIsZero(const lpVec: PVec3f): Boolean;
function isVec3sIsZero(const lpVec: PVec3s): Boolean;

// for (i = 0, i < Count, i++ ) {Vertex[i].xyz += lpOffset.xyz;}
procedure TranslateVertexArray(const Vertex: AVec3f; const lpOffset: PVec3f;
  const Count: Integer); 

function FloatToStrFixed(const Value: Single): String; // 6 digits after dot

// print('(%f, %f, %f)', Vec.x, Vec.y, Vec.z);
function VecToStr(const Vec3f: tVec3f): String; overload; // 6 digits after dot
function VecToStr(const Vec3s: tVec3s): String; overload; // 6 digits after dot

// input string format: "Number Number Number" with one Space Delemiter
function StrToVec(const Str: String; const Vec: PVec3f): Boolean; // Return False if NaN


procedure GetCubeBBOXfByPosAndSize(const lpBBOXf: PBBOXf; const Pos: tVec3f; const Size: Single);
procedure GetBBOXfByPosAndSize(const lpBBOXf: PBBOXf; const Pos, Size: tVec3f);
procedure GetBBOX(const Vertex: AVec3f; const BBOX: PBBOXf;
  const CountVertex: Integer);
procedure UpdateBBOX(const lpBBOXf: PBBOXf; const lpVec3f: PVec3f);
procedure GetTexBBOX(const TexCoords: AVec2f; const TexBBOX: PTexBBOXf;
  const CountCoords: Integer);

function TestPointInBBOX(const BBOX: tBBOXf; const Point: tVec3f): Boolean;
function TestAllPointsNotInBBOX(const BBOX: PBBOXf; const Points: AVec3f;
  const Count: Integer): Boolean; overload;
function TestAllPointsNotInBBOX(const BBOX: PBBOXf; const Points: AVec3d;
  const Count: Integer): Boolean; overload;

function TestIntersectionTwoBBOX(const BBOX1, BBOX2: PBBOXf): Boolean;
function TestIntersectionTwoBBOXs(const BBOX1, BBOX2: PBBOXs): Boolean;

// PointOnRay = Ray.Start + t*Ray.Dir
procedure GetPointOnRay(const lpRay: PRay; const t: PSingle; const lpPoint: PVec3f);

// WorldPoint.i = Min.i*(1.0 - LocPoint.i) + Max.i*LocPoint.i; i = x,y,z; LocPoint.i = [0..1];
procedure MapLocalPointInBBOXf(const lpBBOXf: PBBOXf; const lpLocPoint, lpWorldPoint: PVec3f);

// NVIDIA realization:
// Majercik, Crassin, Shirley, McGuire, A Ray-Box Intersection Algorithm,
// Journal of Computer Graphics Techniques (JCGT), vol. 7, no. 3, 66–81, 2018
// http://jcgt.org/published/0007/03/04/
// Listing 1
function isNotRayIntersectionBBOX(const lpBBOXf: PBBOXf; const lpRay: PRay): Boolean;

procedure GetOriginByBBOX(const BBOX: PBBOXf; const Origin: PVec3f);
function GetCenterBBOXf(const BBOXs: tBBOXs): tVec3f;

// BBOX.Vmin.xyz += lpOffset.xyz; BBOX.Vmax.xyz += lpOffset.xyz;
procedure TranslateBBOXf(const lpBBOXf: PBBOXf; const lpOffset: PVec3f);

// Size = BBOX.Vmax - BBOX.Vmin;
procedure GetSizeBBOXs(const lpBBOX: PBBOXs; const lpSize: PVec3f);
procedure GetSizeBBOXf(const lpBBOX: PBBOXf; const lpSize: PVec3f);

//*****************************************************************************
type AByte = array of Byte;
type AInt = array of Integer;
type ADWORD = array of DWORD;
type AWORD = array of WORD;
type ASmallInt = array of SmallInt;
type AByteBool = array of ByteBool;

function ExtractOrigFileName(const FileName: String): String; // delete Ext and Dir Path

procedure DrawString3D(const Str: String; const lpPos: PVec3f; const FontSize: Integer);


implementation


procedure ClampToOne(const lpValue: PSingle);
asm
  // EAX -> lpValue
  {$R-}
  push EDX
  mov EDX, dword ptr [EAX]
  cmp EDX, $3f800000
  jle @@ExitClamp
  mov EDX, $3f800000
  mov dword ptr [EAX], EDX
@@ExitClamp:
  pop EDX
  {$R+}
end;

procedure ClampVec3fToOne(const lpVec3f: PVec3f);
asm
  // EAX -> lpValue
  {$R-}
  push EDX

  // Clamp X
  mov EDX, tVec3f[EAX].x
  cmp EDX, $3f800000
  jle @@ExitClampX
  mov EDX, $3f800000
  mov tVec3f[EAX].x, EDX
@@ExitClampX:

  // Clamp Y
  mov EDX, tVec3f[EAX].y
  cmp EDX, $3f800000
  jle @@ExitClampY
  mov EDX, $3f800000
  mov tVec3f[EAX].y, EDX
@@ExitClampY:

  // Clamp Z
  mov EDX, tVec3f[EAX].z
  cmp EDX, $3f800000
  jle @@ExitClampZ
  mov EDX, $3f800000
  mov tVec3f[EAX].z, EDX
@@ExitClampZ:

  pop EDX
  {$R+}
end;

procedure ZeroFillChar(const Buffer: PByte; const SizeBuffer: Integer);
asm
  // EAX -> Buffer Pointer
  // EDX -> Buffer Size in Bytes
  {$R-}
  cmp EDX, $00000000
  jle @@BadLen
  push ECX
  push EBX
  xor EBX, EBX // EBX = 0
  xor ECX, ECX // ECX = 0
  //
@@Looper:
    mov byte ptr [EAX + ECX], BL // save zero byte to array element
    inc ECX
    cmp ECX, EDX
    jl @@Looper // if ECX < SizeBuffer
  ////
  pop EBX
  pop ECX
  //
@@BadLen:
  {$R+}
end;

//*****************************************************************************
procedure GetEdge(const VecFrom, VecTo: tVec3f; const lpEdge: PVec3f); overload;
begin
  {$R-}
  lpEdge.x:=VecTo.x - VecFrom.x;
  lpEdge.y:=VecTo.y - VecFrom.y;
  lpEdge.z:=VecTo.z - VecFrom.z;
  {$R+}
end;

procedure GetEdge(const VecFrom, VecTo: tVec2f; const lpEdge: PVec2f); overload;
begin
  {$R-}
  lpEdge.x:=VecTo.x - VecFrom.x;
  lpEdge.y:=VecTo.y - VecFrom.y;
  {$R+}
end;

procedure GetEdge(const VecFrom, VecTo: tVec3f; const lpEdge: PVec3f;
  const Scale: Single); overload;
begin
  {$R-}
  lpEdge.x:=(VecTo.x - VecFrom.x)*Scale;
  lpEdge.y:=(VecTo.y - VecFrom.y)*Scale;
  lpEdge.z:=(VecTo.z - VecFrom.z)*Scale;
  {$R+}
end;

procedure GetEdge(const VecFrom, VecTo: tVec2f; const lpEdge: PVec2f;
  const Scale: Single); overload;
begin
  {$R-}
  lpEdge.x:=(VecTo.x - VecFrom.x)*Scale;
  lpEdge.y:=(VecTo.y - VecFrom.y)*Scale;
  {$R+}
end;

procedure Vec3fToVec3s(const lpVec3f: PVec3f; const lpVec3s: PVec3s);
asm
  {$R-}
  // round X component
  fld tVec3f[EAX].x
  fistp tVec3s[EDX].x
  // round Y component
  fld tVec3f[EAX].y
  fistp tVec3s[EDX].y
  // round Z component
  fld tVec3f[EAX].z
  fistp tVec3s[EDX].z
  {$R+}
end;

procedure SignInvertVec(const lpSrc, lpDest: PVec3f);
asm
  {$R-}
  // X Component
  fld tVec3f[EAX].x
  fchs // sign invert
  fstp tVec3f[EDX].x

  // Y Component
  fld tVec3f[EAX].y
  fchs // sign invert
  fstp tVec3f[EDX].y

  // Z Component
  fld tVec3f[EAX].z
  fchs // sign invert
  fstp tVec3f[EDX].z
  {$R+}
end;

procedure ScaleVec(const lpSrc, lpDest: PVec3f; const lpScale: PSingle);
asm
  {$R-}
  FLD dword ptr [ECX]
  // X Component
  FLD tVec3f[EAX].x
  FMUL st(0), st(1)
  FSTP tVec3f[EDX].x
  // Y Component
  FLD tVec3f[EAX].y
  FMUL st(0), st(1)
  FSTP tVec3f[EDX].y
  // Z Component
  FMUL tVec3f[EAX].z
  FSTP tVec3f[EDX].z
  {$R+}
end;

procedure InvScaleVec(const lpSrc, lpDest: PVec3f; const lpInvScale: PSingle);
begin
  {$R-}
  lpSrc.x:=lpDest.x/lpInvScale^;
  lpSrc.y:=lpDest.y/lpInvScale^;
  lpSrc.z:=lpDest.z/lpInvScale^;
  {$R+}
end;

function NormalizeVec3f(const lpVec: PVec3f): Boolean;
var
  tmp: GLfloat;
begin
  {$R-}
  tmp:=Sqr(lpVec.x) + Sqr(lpVec.y) + Sqr(lpVec.z);
  // 0.0 = 0x00000000; PInteger(@tmp)^ is equal c++: int i = *(int*)&x;
  if (PInteger(@tmp)^ > 0) then
    begin
      tmp:=1.0/Sqrt(tmp);
      lpVec.x:=lpVec.x*tmp;
      lpVec.y:=lpVec.y*tmp;
      lpVec.z:=lpVec.z*tmp;
      Result:=True;
    end
  else
    begin
      lpVec^:=VEC_ZERO;
      Result:=False;
    end;
  {$R+}
end;

function Dot(const vA, vB: tVec3f): Single;  overload;
begin
  {$R-}
  Dot:=vA.x*vB.x + vA.y*vB.y + vA.z*vB.z;
  {$R+}
end;

function Dot(const vA, vB: PVec3f): Single;  overload;
begin
  {$R-}
  Dot:=vA.x*vB.x + vA.y*vB.y + vA.z*vB.z;
  {$R+}
end;

function Dot(const vA, vB: tVec3s): Integer;  overload;
begin
  {$R-}
  Dot:=vA.x*vB.x + vA.y*vB.y + vA.z*vB.z;
  {$R+}
end;

function Dot(const vA: tVec3f; const vB: tVec3s): Single;  overload;
begin
  {$R-}
  Dot:=vA.x*vB.x + vA.y*vB.y + vA.z*vB.z;
  {$R+}
end;

function Dot(const vA: tVec3s; const vB: tVec3f): Single;  overload;
begin
  {$R-}
  Dot:=vA.x*vB.x + vA.y*vB.y + vA.z*vB.z;
  {$R+}
end;


procedure Cross(const lpLeft, lpRight, lpRes: PVec3f);
begin
  {$R-}
  lpRes.x:=lpLeft.y*lpRight.z - lpLeft.z*lpRight.y;
  lpRes.y:=lpLeft.z*lpRight.x - lpLeft.x*lpRight.z;
  lpRes.z:=lpLeft.x*lpRight.y - lpLeft.y*lpRight.x;
  {$R+}
end;

function GetNormalByEdges(const lpEdge0, lpEdge1, lpNormal: PVec3f): Boolean;
var
  tmp: Single;
begin
  {$R-}
  lpNormal.x:=lpEdge0.y*lpEdge1.z - lpEdge0.z*lpEdge1.y;
  lpNormal.y:=lpEdge0.z*lpEdge1.x - lpEdge0.x*lpEdge1.z;
  lpNormal.z:=lpEdge0.x*lpEdge1.y - lpEdge0.y*lpEdge1.x;

  tmp:=Sqr(lpNormal.x) + Sqr(lpNormal.y) + Sqr(lpNormal.z);
  if (PInteger(@tmp)^ > 0) then
    begin
      tmp:=1.0/Sqrt(tmp);
      lpNormal.x:=lpNormal.x*tmp;
      lpNormal.y:=lpNormal.y*tmp;
      lpNormal.z:=lpNormal.z*tmp;
      Result:=True;
    end
  else
    begin
      lpNormal^:=VEC_ZERO;
      Result:=False;
    end;
  {$R+}
end;

function SqrLength(const Vec: tVec3f): Single; overload;
begin
  {$R-}
  SqrLength:=Sqr(Vec.x) + Sqr(Vec.y) + Sqr(Vec.z);
  {$R+}
end;

function SqrLength(const Vec: tVec3s): Integer; overload;
begin
  {$R-}
  SqrLength:=Sqr(Vec.x) + Sqr(Vec.y) + Sqr(Vec.z);
  {$R+}
end;

function SqrDistTwoVec(const lpVecA, lpVecB: tVec3f): Single;
begin
  {$R-}
  SqrDistTwoVec:=Sqr(lpVecA.x - lpVecB.x)
    + Sqr(lpVecA.y - lpVecB.y) + Sqr(lpVecA.z - lpVecB.z);
  {$R+}
end;

procedure AddWithScaleVec(const lpSrc, lpAdd: PVec3f; const lpScale: PSingle);
begin
  {$R-}
  lpSrc.x:=lpSrc.x + lpAdd.x*lpScale^;
  lpSrc.y:=lpSrc.y + lpAdd.y*lpScale^;
  lpSrc.z:=lpSrc.z + lpAdd.z*lpScale^;
  {$R+}
end;

procedure SubWithScaleVec(const lpSrc, lpSub: PVec3f; const lpScale: PSingle);
begin
  {$R-}
  lpSrc.x:=lpSrc.x - lpSub.x*lpScale^;
  lpSrc.y:=lpSrc.y - lpSub.y*lpScale^;
  lpSrc.z:=lpSrc.z - lpSub.z*lpScale^;
  {$R+}
end;

function CompareVec(const vA, vB: tVec3f): Boolean; overload;
// EAX <- vA; EDX <- vB;
// result -> EAX; Boolean = DWORD;
asm
  {$R-}
  push EBX
  mov EBX, EAX // EBX <- vA
  // compare x components
  mov EAX, DWORD PTR [EBX + 0] // vA.x
  cmp EAX, DWORD PTR [EDX + 0]
  jne @@CompareVecExitFalse
  // compare y components
  mov EAX, DWORD PTR [EBX + 4] // vA.y
  cmp EAX, DWORD PTR [EDX + 4]
  jne @@CompareVecExitFalse
  // compare z components
  mov EAX, DWORD PTR [EBX + 8] // vA.z
  cmp EAX, DWORD PTR [EDX + 8]
  jne @@CompareVecExitFalse
  // ok, vA equal vB
  mov EAX, $00000001 // store to result "TRUE" = 1
  pop EBX
  ret

  // ok, vA not equal vB
@@CompareVecExitFalse:
  xor EAX, EAX // store to result "FALSE" = 0
  pop EBX
  ret
  {$R+}
end;

function CompareVec(const vA, vB: tVec3s): Boolean; overload;
// EAX <- vA; EDX <- vB;
// result -> EAX; Boolean = DWORD;
asm
  {$R-}
  push EBX
  mov EBX, EAX // EBX <- vA
  // compare x components
  mov AX, WORD PTR [EBX + 0] // vA.x
  cmp AX, WORD PTR [EDX + 0]
  jne @@CompareVecExitFalse
  // compare y components
  mov AX, WORD PTR [EBX + 2] // vA.y
  cmp AX, WORD PTR [EDX + 2]
  jne @@CompareVecExitFalse
  // compare z components
  mov AX, WORD PTR [EBX + 4] // vA.z
  cmp AX, WORD PTR [EDX + 4]
  jne @@CompareVecExitFalse
  // ok, vA equal vB
  mov EAX, $00000001 // store to result "TRUE" = 1
  pop EBX
  ret

  // ok, vA not equal vB
@@CompareVecExitFalse:
  xor EAX, EAX // store to result "FALSE" = 0
  pop EBX
  ret
  {$R+}
end;

function CompareVec(const vA: tVec3f; vB: tVec3s): Boolean; overload;
begin
  {$R-}
  CompareVec:=False;
  if (vA.x <> vB.x) then Exit;
  if (vA.y <> vB.y) then Exit;
  if (vA.z <> vB.z) then Exit;
  CompareVec:=True;
  {$R+}
end;

function CompareVec(const vA: tVec3s; vB: tVec3f): Boolean; overload;
begin
  {$R-}
  CompareVec:=False;
  if (vA.x <> vB.x) then Exit;
  if (vA.y <> vB.y) then Exit;
  if (vA.z <> vB.z) then Exit;
  CompareVec:=True;
  {$R+}
end;

function isVec3fIsZero(const lpVec: PVec3f): Boolean;
asm
  {$R-}
  push EDX
  // make accumulate non-zero bits by "OR" between XYZ components
  mov EDX, tVec3f.x
  or EDX, tVec3f.y
  or EDX, tVec3f.z
  // delete Sign bit
  and EDX, $7FFFFFFF
  // and compare all bits with zero
  xor EAX, EAX
  cmp EDX, $00000000
  setz AL
  pop EDX
  {$R+}
end;

function isVec3sIsZero(const lpVec: PVec3s): Boolean;
asm
  {$R-}
  push EDX
  // make accumulate non-zero bits by "OR" between XYZ components
  mov DX, tVec3s.x
  or DX, tVec3s.y
  or DX, tVec3s.z
  // and compare all bits with zero
  xor EAX, EAX
  cmp DX, $0000
  setz AL
  pop EDX
  {$R+}
end;

procedure TranslateVertexArray(const Vertex: AVec3f; const lpOffset: PVec3f; const Count: Integer);
var
  i: Integer;
begin
  // EAX -> Pointer on Vertex[0] (tVec3f)
  // EDX -> Pointer on tVec3f
  // ECX -> Count of Vertex
  {$R-}
  for i:=0 to (Count - 1) do
    begin
      Vertex[i].x:=Vertex[i].x + lpOffset.x;
      Vertex[i].y:=Vertex[i].y + lpOffset.y;
      Vertex[i].z:=Vertex[i].z + lpOffset.z;
    end;
  {$R+}
end;


function FloatToStrFixed(const Value: Single): String;
begin
  {$R-}
  DecimalSeparator:='.';
  Result:=FloatToStrF(Value, ffGeneral, 6, 4);
  DecimalSeparator:=',';
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

function VecToStr(const Vec3s: tVec3s): String; overload;
var
  tmpStr: String;
begin
  {$R-}
  Result:='(';
  tmpStr:=IntToStr(Vec3s.x);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=IntToStr(Vec3s.y);
  if (tmpStr[1] = '-') then Result:=Result + tmpStr + ','
  else Result:=Result + ' ' + tmpStr + ',';
  tmpStr:=IntToStr(Vec3s.z);
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
  tmp.DelimitedText:=StringReplace(Str, '.', ',', [rfReplaceAll]);
  if (tmp.Count <> 3) then
    begin
      tmp.Clear;
      tmp.Destroy;
      Exit;
    end;

  try
    Vec.x:=StrToFloat(tmp.Strings[0]);
    Vec.y:=StrToFloat(tmp.Strings[1]);
    Vec.z:=StrToFloat(tmp.Strings[2]);
  except
    tmp.Clear;
    tmp.Destroy;
    Exit;
  end;

  tmp.Clear;
  tmp.Destroy;
  StrToVec:=True;
  {$R+}
end;


procedure GetCubeBBOXfByPosAndSize(const lpBBOXf: PBBOXf; const Pos: tVec3f; const Size: Single);
begin
  {$R-}
  lpBBOXf.vMin.x:=Pos.x - Size*0.5;
  lpBBOXf.vMin.y:=Pos.y - Size*0.5;
  lpBBOXf.vMin.z:=Pos.z - Size*0.5;

  lpBBOXf.vMax.x:=Pos.x + Size*0.5;
  lpBBOXf.vMax.y:=Pos.y + Size*0.5;
  lpBBOXf.vMax.z:=Pos.z + Size*0.5;
  {$R+}
end;

procedure GetBBOXfByPosAndSize(const lpBBOXf: PBBOXf; const Pos, Size: tVec3f);
begin
  {$R-}
  lpBBOXf.vMin.x:=Pos.x - Size.x*0.5;
  lpBBOXf.vMin.y:=Pos.y - Size.y*0.5;
  lpBBOXf.vMin.z:=Pos.z - Size.z*0.5;

  lpBBOXf.vMax.x:=Pos.x + Size.x*0.5;
  lpBBOXf.vMax.y:=Pos.y + Size.y*0.5;
  lpBBOXf.vMax.z:=Pos.z + Size.z*0.5;
  {$R+}
end;

procedure GetBBOX(const Vertex: AVec3f; const BBOX: PBBOXf;
  const CountVertex: Integer);
var
  i: Integer;
begin
  {$R-}
  if (CountVertex <= 0) then Exit;
  BBOX.vMin:=Vertex[0];
  BBOX.vMax:=Vertex[0];

  for i:=1 to (CountVertex - 1) do
    begin
      if (Vertex[i].x < BBOX.vMin.x) then BBOX.vMin.x:=Vertex[i].x;
      if (Vertex[i].y < BBOX.vMin.y) then BBOX.vMin.y:=Vertex[i].y;
      if (Vertex[i].z < BBOX.vMin.z) then BBOX.vMin.z:=Vertex[i].z;

      if (Vertex[i].x > BBOX.vMax.x) then BBOX.vMax.x:=Vertex[i].x;
      if (Vertex[i].y > BBOX.vMax.y) then BBOX.vMax.y:=Vertex[i].y;
      if (Vertex[i].z > BBOX.vMax.z) then BBOX.vMax.z:=Vertex[i].z;
    end;
  {$R+}
end;

procedure UpdateBBOX(const lpBBOXf: PBBOXf; const lpVec3f: PVec3f);
begin
  {$R-}
  if (lpVec3f.x < lpBBOXf.vMin.x) then lpBBOXf.vMin.x:=lpVec3f.x;
  if (lpVec3f.y < lpBBOXf.vMin.y) then lpBBOXf.vMin.y:=lpVec3f.y;
  if (lpVec3f.z < lpBBOXf.vMin.z) then lpBBOXf.vMin.z:=lpVec3f.z;

  if (lpVec3f.x > lpBBOXf.vMax.x) then lpBBOXf.vMax.x:=lpVec3f.x;
  if (lpVec3f.y > lpBBOXf.vMax.y) then lpBBOXf.vMax.y:=lpVec3f.y;
  if (lpVec3f.z > lpBBOXf.vMax.z) then lpBBOXf.vMax.z:=lpVec3f.z;
  {$R+}
end;


procedure GetTexBBOX(const TexCoords: AVec2f; const TexBBOX: PTexBBOXf;
  const CountCoords: Integer);
var
  i: Integer;
begin
  {$R-}
  TexBBOX.Umin:=TexCoords[0].x;
  TexBBOX.Umax:=TexCoords[0].x;
  TexBBOX.Vmin:=TexCoords[0].y;
  TexBBOX.Vmax:=TexCoords[0].y;
  if (CountCoords = 1) then Exit;
  for i:=1 to CountCoords-1 do
    begin
      if (TexCoords[i].x < TexBBOX.Umin) then TexBBOX.Umin:=TexCoords[i].x;
      if (TexCoords[i].x > TexBBOX.Umax) then TexBBOX.Umax:=TexCoords[i].x;

      if (TexCoords[i].y < TexBBOX.Vmin) then TexBBOX.Vmin:=TexCoords[i].y;
      if (TexCoords[i].y > TexBBOX.Vmax) then TexBBOX.Vmax:=TexCoords[i].y;
    end;
  {$R+}
end;

function TestPointInBBOX(const BBOX: tBBOXf; const Point: tVec3f): Boolean;
begin
  {$R-}
  TestPointInBBOX:=False;
  if (Point.x < BBOX.vMin.x) then Exit;
  if (Point.y < BBOX.vMin.y) then Exit;
  if (Point.z < BBOX.vMin.z) then Exit;

  if (Point.x > BBOX.vMax.x) then Exit;
  if (Point.y > BBOX.vMax.y) then Exit;
  if (Point.z > BBOX.vMax.z) then Exit;
  TestPointInBBOX:=True;
  {$R+}
end;

function TestAllPointsNotInBBOX(const BBOX: PBBOXf; const Points: AVec3f;
  const Count: Integer): Boolean;
var
  i: Integer;
begin
  {$R-}
  TestAllPointsNotInBBOX:=False;
  for i:=0 to Count-1 do
    begin
      if (Points[i].x > BBOX.vMin.x) then Exit;
      if (Points[i].y > BBOX.vMin.y) then Exit;
      if (Points[i].z > BBOX.vMin.z) then Exit;

      if (Points[i].x < BBOX.vMax.x) then Exit;
      if (Points[i].y < BBOX.vMax.y) then Exit;
      if (Points[i].z < BBOX.vMax.z) then Exit;
    end;
  TestAllPointsNotInBBOX:=True;
  {$R+}
end;

function TestAllPointsNotInBBOX(const BBOX: PBBOXf; const Points: AVec3d;
  const Count: Integer): Boolean;
var
  i: Integer;
begin
  {$R-}
  TestAllPointsNotInBBOX:=False;
  for i:=0 to Count-1 do
    begin
      if (Points[i].x > BBOX.vMin.x) then Exit;
      if (Points[i].y > BBOX.vMin.y) then Exit;
      if (Points[i].z > BBOX.vMin.z) then Exit;

      if (Points[i].x < BBOX.vMax.x) then Exit;
      if (Points[i].y < BBOX.vMax.y) then Exit;
      if (Points[i].z < BBOX.vMax.z) then Exit;
    end;
  TestAllPointsNotInBBOX:=True;
  {$R+}
end;

function TestIntersectionTwoBBOX(const BBOX1, BBOX2: PBBOXf): Boolean;
begin
  {$R-}
  TestIntersectionTwoBBOX:=False;
  if ((BBOX1.vMax.x < BBOX2.vMin.x) or (BBOX1.vMin.x > BBOX2.vMax.x)) then Exit;
  if ((BBOX1.vMax.y < BBOX2.vMin.y) or (BBOX1.vMin.y > BBOX2.vMax.y)) then Exit;
  if ((BBOX1.vMax.z < BBOX2.vMin.z) or (BBOX1.vMin.z > BBOX2.vMax.z)) then Exit;
  TestIntersectionTwoBBOX:=True;
  {$R+}
end;

function TestIntersectionTwoBBOXs(const BBOX1, BBOX2: PBBOXs): Boolean;
begin
  {$R-}
  TestIntersectionTwoBBOXs:=False;
  if ((BBOX1.nMax.x < BBOX2.nMin.x) or (BBOX1.nMin.x > BBOX2.nMax.x)) then Exit;
  if ((BBOX1.nMax.y < BBOX2.nMin.y) or (BBOX1.nMin.y > BBOX2.nMax.y)) then Exit;
  if ((BBOX1.nMax.z < BBOX2.nMin.z) or (BBOX1.nMin.z > BBOX2.nMax.z)) then Exit;
  TestIntersectionTwoBBOXs:=True;
  {$R+}
end;

procedure GetPointOnRay(const lpRay: PRay; const t: PSingle; const lpPoint: PVec3f);
asm
  {$R-}
  fld dword ptr [EDX]
  //
  fld st
  fmul tRay[EAX].Dir.x
  fadd tRay[EAX].Start.x
  fstp tVec3f[ECX].x
  //
  fld st
  fmul tRay[EAX].Dir.y
  fadd tRay[EAX].Start.y
  fstp tVec3f[ECX].y
  //
  fmul tRay[EAX].Dir.z
  fadd tRay[EAX].Start.z
  fstp tVec3f[ECX].z
  {$R+}
end;

procedure MapLocalPointInBBOXf(const lpBBOXf: PBBOXf; const lpLocPoint, lpWorldPoint: PVec3f);
begin
  {$R-}
  // lpLocPoint.xyz = [0..1]
  // Map X Component
  lpWorldPoint.x:=lpBBOXf.vMin.x*(1.0 - lpLocPoint.x) + lpBBOXf.vMax.x*lpLocPoint.x;

  // Map Y Component
  lpWorldPoint.y:=lpBBOXf.vMin.y*(1.0 - lpLocPoint.y) + lpBBOXf.vMax.y*lpLocPoint.y;

  // Map Z Component
  lpWorldPoint.z:=lpBBOXf.vMin.z*(1.0 - lpLocPoint.z) + lpBBOXf.vMax.z*lpLocPoint.z;
  {$R+}
end;

function isNotRayIntersectionBBOX(const lpBBOXf: PBBOXf; const lpRay: PRay): Boolean;
var
  t0, t1, tmin, tmax: tVec3f;
  g_min, g_max: Single;
begin
  {$R-}
  // NVIDIA realization:
  // Majercik, Crassin, Shirley, McGuire, A Ray-Box Intersection Algorithm,
  // Journal of Computer Graphics Techniques (JCGT), vol. 7, no. 3, 66–81, 2018
  // http://jcgt.org/published/0007/03/04/
  // Listing 1:
  (*
  bool slabs(vec3 p0, vec3 p1, vec3 rayOrigin, vec3 invRaydir) {
    vec3 t0 = (p0 - rayOrigin) * invRaydir;
    vec3 t1 = (p1 - rayOrigin) * invRaydir;
    vec3 tmin = min(t0,t1), tmax = max(t0,t1);
    return max_component(tmin) <= min_component(tmax);
  }
  *)

  if (TestPointInBBOX(lpBBOXf^, lpRay.Start)) then
    begin
      Result:=False;
      Exit;
    end;

  t0.x:=(lpBBOXf.vMin.x - lpRay.Start.x)/lpRay.Dir.x;
  t0.y:=(lpBBOXf.vMin.y - lpRay.Start.y)/lpRay.Dir.y;
  t0.z:=(lpBBOXf.vMin.z - lpRay.Start.z)/lpRay.Dir.z;

  t1.x:=(lpBBOXf.vMax.x - lpRay.Start.x)/lpRay.Dir.x;
  t1.y:=(lpBBOXf.vMax.y - lpRay.Start.y)/lpRay.Dir.y;
  t1.z:=(lpBBOXf.vMax.z - lpRay.Start.z)/lpRay.Dir.z;

  if (t0.x < t1.x) then
    begin
      tmin.x:=t0.x;
      tmax.x:=t1.x;
    end
  else
    begin
      tmin.x:=t1.x;
      tmax.x:=t0.x;
    end;

  if (t0.y < t1.y) then
    begin
      tmin.y:=t0.y;
      tmax.y:=t1.y;
    end
  else
    begin
      tmin.y:=t1.y;
      tmax.y:=t0.y;
    end;

  if (t0.z < t1.z) then
    begin
      tmin.z:=t0.z;
      tmax.z:=t1.z;
    end
  else
    begin
      tmin.z:=t1.z;
      tmax.z:=t0.z;
    end;

  if (tmax.x < tmax.y) then
    begin
      if (tmax.x < tmax.z) then g_min:=tmax.x else g_min:=tmax.z;
    end
  else
    begin
      if (tmax.y < tmax.z) then g_min:=tmax.y else g_min:=tmax.z;
    end;

  if (tmin.x > tmin.y) then
    begin
      if (tmin.x > tmin.z) then g_max:=tmin.x else g_max:=tmin.z;
    end
  else
    begin
      if (tmin.y > tmin.z) then g_max:=tmin.y else g_max:=tmin.z;
    end;

  Result:=(g_max > g_min);
  {$R+}
end;


//*****************************************************************************


function ExtractOrigFileName(const FileName: String): String;
var
  dotPos, n: Integer;
begin
  {$R-}
  n:=Length(FileName);
  if (n = 0) then Exit;
  dotPos:=n+1;
  while (dotPos > 2) do
    begin
      Dec(dotPos);
      if (FileName[dotPos] = '.') then Break;
    end;
  if (dotPos > n) then
    begin
      Result:=FileName;
      Exit;
    end
  else
    begin
      Result:=Copy(FileName, 1, dotPos-1);
    end;
  {$R+}
end;

procedure TranslateBBOXf(const lpBBOXf: PBBOXf; const lpOffset: PVec3f);
asm
  // EAX -> Pointer on tBBOXf
  // EAX -> Pointer on tVec3f
  {$R-}
  fld tVec3f[EDX].z
  fld tVec3f[EDX].y
  fld tVec3f[EDX].x
  // st0..2 = lpOffset.xyz;

  // 1. Translate nMin Vector
  // 1.1. Correct X Component
  fld tBBOXf[EAX].vMin.x
  // st0 = nMix.x; st1..3 = lpOffset.xyz;
  fadd st(0), st(1)
  fstp tBBOXf[EAX].vMin.x
  // 1.2. Correct Y Component
  fld tBBOXf[EAX].vMin.y
  fadd st(0), st(2)
  fstp tBBOXf[EAX].vMin.y
  // 1.3. Correct Z Component
  fld tBBOXf[EAX].vMin.z
  fadd st(0), st(3)
  fstp tBBOXf[EAX].vMin.z
  // st0..2 = lpOffset.xyz;

  // 2. Translate nMax Vector
  // 2.1. Correct X Component
  fadd tBBOXf[EAX].vMax.x
  fstp tBBOXf[EAX].vMax.x
  // st0..1 = lpOffset.yz;
  // 2.2. Correct Y Component
  fadd tBBOXf[EAX].vMax.y
  fstp tBBOXf[EAX].vMax.y
  // st0 = lpOffset.z;
  // 2.3. Correct Z Component
  fadd tBBOXf[EAX].vMax.z
  fstp tBBOXf[EAX].vMax.z
  // BBOX Translate Complite
  {$R+}
end;

procedure GetOriginByBBOX(const BBOX: PBBOXf; const Origin: PVec3f);
begin
  {$R-}
  Origin.x:=(BBOX.vMin.x + BBOX.vMax.x)*0.5;
  Origin.y:=(BBOX.vMin.y + BBOX.vMax.y)*0.5;
  Origin.z:=(BBOX.vMin.z + BBOX.vMax.z)*0.5;
  {$R+}
end;

function GetCenterBBOXf(const BBOXs: tBBOXs): tVec3f;
begin
  {$R-}
  Result.x:=(BBOXs.nMax.x + BBOXs.nMin.x)*0.5;
  Result.y:=(BBOXs.nMax.y + BBOXs.nMin.y)*0.5;
  Result.z:=(BBOXs.nMax.z + BBOXs.nMin.z)*0.5;
  {$R+}
end;

procedure GetSizeBBOXs(const lpBBOX: PBBOXs; const lpSize: PVec3f);
begin
  {$R-}
  lpSize.x:=(lpBBOX.nMax.x - lpBBOX.nMin.x);
  lpSize.y:=(lpBBOX.nMax.y - lpBBOX.nMin.y);
  lpSize.z:=(lpBBOX.nMax.z - lpBBOX.nMin.z);
  {$R+}
end;

procedure GetSizeBBOXf(const lpBBOX: PBBOXf; const lpSize: PVec3f);
begin
  {$R-}
  lpSize.x:=(lpBBOX.vMax.x - lpBBOX.vMin.x);
  lpSize.y:=(lpBBOX.vMax.y - lpBBOX.vMin.y);
  lpSize.z:=(lpBBOX.vMax.z - lpBBOX.vMin.z);
  {$R+}
end;

procedure DrawString3D(const Str: String; const lpPos: PVec3f; const FontSize: Integer);
var
  TextBmp: TBitmap;
begin
  {$R-}
  //glBlendFunc(GL_ONE_MINUS_SRC_ALPHA, GL_SRC_COLOR);
  glRasterPos3fv(@lpPos.x);        // place text position

  // loop all characters in the string
  TextBmp:=TBitmap.Create();
  TextBmp.PixelFormat:=pf8bit;
  TextBmp.Canvas.Font.Size:=FontSize;
  TextBmp.Height:=TextBmp.Canvas.TextHeight(Str);
  TextBmp.Width:=TextBmp.Canvas.TextWidth(Str);
  TextBmp.Canvas.TextOut(0, 0, Str);

  glDrawPixels(
    TextBmp.Width,
    TextBmp.Height,
    GL_LUMINANCE,
    GL_UNSIGNED_BYTE,
    TextBmp.ScanLine[TextBmp.Height - 1]
  );

  TextBmp.Destroy();
  //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  {$R+}
end;

end.
