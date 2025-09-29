unit UnitUserTypes;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  Windows;

type tColor4fv = array[0..3] of Single;

type tVec2f = packed record
    x, y: Single;
  end;
type PVec2f = ^tVec2f;
type AVec2f = array of tVec2f;

// BSP Vertex def too
type tVec3f = packed record
    x, y, z: Single;
  end;
type PVec3f = ^tVec3f;
type AVec3f = array of tVec3f;

type tVec4f = packed record
  case Byte of
    0: (Vec3f: tVec3f; pad: DWORD;);
    1: (x, y, z, w: Single;);
    2: (v: array[0..3] of Single;);
  end;
type PVec4f = ^tVec4f;
type AVec4f = array of tVec4f;


type tMat3f = array[0..8] of Single;
type PMat3f = ^tMat3f;

type tMat4f = array[0..15] of Single;
type PMat4f = ^tMat4f;

type tLightmapBSP = packed record
    r, g, b: Byte;
    e: ShortInt;
  end; // 4 Bytes
type PLightmapBSP = ^tLightmapBSP;
type ALightmapBSP = array of tLightmapBSP;

// !!! not BSP format !!!
// exponent shifted up by 128, for glTexImage2D as RGBA8888 [0..255]
type tLightmap = packed record
    r, g, b, e: Byte;
  end;
type PLightmap = ^tLightmap;
type ALightmap = array of tLightmap;

type tCompressedLightCube = array[0..5] of tLightmapBSP; // 24 Bytes
type PCompressedLightCube = ^tCompressedLightCube;
type ACompressedLightCube = array of tCompressedLightCube;

// 1 / (c + l * dist + q * dist^2)
type tAttenuate3f = packed record
    c, l, q: Single;
  end; // 12 Bytes
type PAttenuate3f = ^tAttenuate3f;
type AAttenuate3f = array of tAttenuate3f;


type tBBOX3f = packed record
    vMin, vMax: tVec3f;
  end;
type PBBOX3f = ^tBBOX3f;
type ABBOX3f = array of tBBOX3f;

type tBBOX4f = packed record
    vMin, vMax: tVec4f;
  end;
type PBBOX4f = ^tBBOX4f;
type ABBOX4f = array of tBBOX4f;

type tTexBBOXf = packed record
    vMin, vMax: tVec2f;
  end;
type PTexBBOXf = ^tTexBBOXf;

type tVec2b = packed record
    x, y: Byte;
  end; // 2 Bytes
type PVec2b = ^tVec2b;
type AVec2b = array of tVec2b;

type tVec2s = packed record
    x, y: SmallInt;
  end; // 4 Bytes
type PVec2s = ^tVec2s;
type AVec2s = array of tVec2s;

type tVec2i = packed record
    x, y: Integer;
  end; // 8 Bytes
type PVec2i = ^tVec2i;
type AVec2i = array of tVec2i;

type tVec3b = packed record
    x, y, z: Byte;
  end; // 3 Bytes
type PVec3b = ^tVec3b;
type AVec3b = array of tVec3b;

type tVec3s = packed record
    x, y, z: SmallInt;
  end; // 6 Bytes
type PVec3s = ^tVec3s;
type AVec3s = array of tVec3s;

type tVec3i = packed record
    x, y, z: Integer;
  end; // 12 Bytes
type PVec3i = ^tVec3i;
type AVec3i = array of tVec3i;

type tVec4b = packed record
    x, y, z, w: Byte;
  end; // 4 Bytes
type PVec4b = ^tVec4b;
type AVec4b = ^tVec4b;

type tBBOXs = packed record
    nMin, nMax: tVec3s;
  end;
type PBBOXs = ^tBBOXs;
type ABBOXs = array of tBBOXs;

type tRay = packed record
    Start, Dir: tVec4f; // Dir must be normalized
  end; // 32 Bytes
type PRay = ^tRay;
type ARay = array of tRay;

// Plane equation dot(Normal, PointOnPlane) = Dist
type tPlane = record
    Normal: tVec3f;
    Dist: Single;
    AxisType: Integer;
  end; // 20 Bytes
type PPlane = ^tPlane;
type APlane = array of tPlane;

// Each row is 16-bytes full XMM-register
type tPlanePacket = packed record
    Nx: array[0..3] of Single;
    Ny: array[0..3] of Single;
    Nz: array[0..3] of Single;
    fD: array[0..3] of Single;
  end; // 64 Bytes
type PPlanePacket = ^tPlanePacket;
type APlanePacket = array of tPlanePacket;

type tPolygon3f = packed record
    // Plane section:
    Plane         : tPlane; 
    Center        : tVec4f;
    // Vertex section:
    CountVertecies: Integer;
    CountTriangles: Integer;// = CountVertecies - 2
    Vertecies     : AVec4f; // size = CountVertecies
    // Edge section:
    CountPackets  : Integer;
    CountPlanes   : Integer;  // Count of non-colinears planes
    SidePlanes    : APlanePacket; // size = Ceil(CountVertecies/4)

    padding       : Integer;
  end; // 64 Bytes
type PPolygon3f = ^tPolygon3f;
type APolygon3f = array of tPolygon3f;


type tTraceInfo = packed record
    Point: tVec4f;  // Intersection point
    t: Single;      // ray value of intersection point
    u, v: Single;   // barycentric coordinates of intersection point
    iTriangle: Integer;     // Triangle id of Face polygon
  end; // 32 Bytes
type PTraceInfo = ^tTraceInfo;
type ATraceInfo = array of tTraceInfo;


type tRGB888 = packed record
    r, g, b: Byte;
  end;
type PRGB888 = ^tRGB888;
type ARGB888 = array of tRGB888;

type tRGBA8888 = packed record
    r, g, b, a: Byte;
  end;
type PRGBA8888 = ^tRGBA8888;
type ARGBA8888 = array of tRGBA8888;


type tPixelIndexes = Array[0..32767] of Byte;
type PPixelIndexes = ^tPixelIndexes;

type pRGBArray = ^TRGBArray;
  TRGBArray = ARRAY[0..32767] OF TRGBTriple;

type pRGBAArray = ^TRGBAArray;
  TRGBAArray = ARRAY[0..32767] OF TRGBQuad;


type PByteBool = ^ByteBool;

type APointer = array of Pointer;
type AByte = array of Byte;
type AInt = array of Integer;
type ASingle = array of Single;
type ADWORD = array of DWORD;
type AWORD = array of WORD;
type ASmallInt = array of SmallInt;
type AByteBool = array of ByteBool;
type AString = array of String;

const
  inv16: Single = 0.0625;
  inv255: Single = 1.0/255.0;
  CR = #$0D; // = "/r"
  LF = #$0A; // = "/n" 
  KEYBOARD_SHIFT = $10;
  //
  FLOAT32_INF_POSITIVE: Single = +1/0;
  FLOAT32_INF_NEGATIVE: Single = -1/0;
  VEC_ORT_X: tVec3f = (x: 1; y: 0; z: 0;);
  VEC_ORT_Y: tVec3f = (x: 0; y: 1; z: 0;);
  VEC_ORT_Z: tVec3f = (x: 0; y: 0; z: 1;);
  VEC_ZERO_2F: tVec2f = (x: 0; y: 0);
  VEC_ZERO_3F: tVec3f = (x: 0; y: 0; z: 0);
  VEC_ZERO_4F: tVec4f = (x: 0; y: 0; z: 0; w: 0);
  VEC_ONE: tVec3f = (x: 1; y: 1; z: 1);
  VEC_INF_P: tVec3f = (x: +1/0; y: +1/0; z: +1/0);
  VEC_INF_N: tVec3f = (x: -1/0; y: -1/0; z: -1/0);
  //
  VEC_ZERO_2B: tVec2b = (x: 0; y: 0);
  VEC2B_ORT_X: tVec2b = (x: 1; y: 0);
  VEC2B_ORT_Y: tVec2b = (x: 0; y: 1);
  //
  VEC_ZERO_2S: tVec2s = (x: 0; y: 0);
  //
  BBOX_ZERO_4F: tBBOX4f = (vMin: (x: 0; y: 0; z: 0; w: 0); vMax: (x: 0; y: 0; z: 0; w: 0));
  TEX_BBOX_ZERO: tTexBBOXf = (vMin: (x: 0; y: 0); vMax: (x: 0; y: 0));
  //
  RGB888_BLACK: tRGB888 = (r:   0; g:   0; b:   0);
  RGB888_WHITE: tRGB888 = (r: 255; g: 255; b: 255);
  RGBA8888_BLACK: tRGBA8888 = (r:   0; g:   0; b:   0; a: 255);
  RGBA8888_WHITE: tRGBA8888 = (r: 255; g: 255; b: 255; a: 255);
  RGBA8888_BLACK_TRANSPARENT: tRGBA8888 = (r:   0; g:   0; b:   0; a:   0);
  //
  //
  WhiteColor4f: tColor4fv = (1.0, 1.0, 1.0, 1.0);
  BlackColor4f: tColor4fv = (0.0, 0.0, 0.0, 1.0);
  RedColor4f: tColor4fv = (0.8, 0.1, 0.1, 0.5);
  PinkColor4f: tColor4fv = (1.0, 0.0, 1.0, 0.5);
  //
  ZerosMat3f: tMat3f = (
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0
  );
  ZerosMat4f: tMat4f = (
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0
  );
  IdentityMat3f: tMat3f = (
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0
  );
  IdentityMat4f: tMat4f = (
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  );
  // Plane axis type
  PLANE_X =      0;
  PLANE_Y =      1;
  PLANE_Z =      2;
  PLANE_ANY_X =  3;
  PLANE_ANY_Y =  4;
  PLANE_ANY_Z =  5;
  //
  PLANEBSP_NULL: tPlane = (
    Normal: (x: 0.0; y: 0.0; z: 0.0);
    Dist: 0.0;
    AxisType: PLANE_ANY_Z
  );


implementation


end.
