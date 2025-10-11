unit UnitBSPstruct;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  Math,
  OpenGL,
  UnitUserTypes,
  UnitVec,
  UnitEntity,
  UnitDispMisc,
  Dialogs;


const
  MAP_HEADER_SIZE     = 1036; // Bytes
  MAP_MAGIC           = $50534256;
  HEADER_LUMPS        = 64;

  LUMP_ENTITIES	      =  0;
  LUMP_PLANES	        =  1;
  LUMP_TEXDATA        =	 2; // texture w&h, name, reflect
  LUMP_VERTICES	      =  3; // tVec3f
  LUMP_VISIBILITY     =	 4; // PVS & PVA
  LUMP_NODES          =  5; // node tree
  LUMP_TEXINFO        =  6; // UV matricies, texture flags
  LUMP_FACESLDR       =  7;
  LUMP_LIGHTMAPSLDR   =  8; // LDR lightmaps
  LUMP_OCCLUSION      =  9; // occ. polygons & vertices
  LUMP_LEAFS	        = 10; // leafs of node tree
  LUMP_FACEIDS	      = 11; // Hammer face ID's
  LUMP_EDGES          = 12;
  LUMP_SURFEDGES      = 13; // index of edges
  LUMP_BMODELS  	    = 14; // brush models (ent brush)
  LUMP_WORLDLIGHTLDR  = 15; // LDR worldlights
  LUMP_MARKSURFACES   = 16; // index to faces in leaf
  LUMP_MARKBRUSHES    = 17; // index to brushes in leaf
  LUMP_ORIGBRUSHES    = 18; // Hammer brush array
  LUMP_BRUSHSIDES     = 19; // Hammer brush sides
  LUMP_AREAS          = 20; // area arrays
  LUMP_AREAPORTALS    = 21; // portls between areas
  LUMP_22             = 22; // game-specific
  LUMP_23             = 23; // game-specific
  LUMP_24             = 24; // game-specific
  LUMP_25             = 25; // game-specific
  LUMP_DISPINFO       = 26; // disp sirface array
  LUMP_ORIGFACES      = 27; // brush faces before splitting
  LUMP_PHYSDISP       = 28; // disp physic collision data
  LUMP_PHYSCOLLIDE    = 29; // physic collision data
  LUMP_VERTNORMS      = 30; // tVec3f
  LUMP_VERTNORMIDS    = 31; // index to LUMP_VERTNORMS
  LUMP_DISPALPHA      = 32; // disp lightmap alphas
  LUMP_DISPVERTEX     = 33; // disp vertecies
  LUMP_DISPLUXPOS     = 34; // disp luxels positions
  LUMP_GAME           = 35; // game-specific header
  LUMP_LEAFWATERDATA  = 36; // leafs inside water
  LUMP_PRIMS          = 37; // water polygon data
  LUMP_PRIMVERT       = 38; // water polygon vertecies
  LUMP_PRIMVERTID     = 39; // index to LUMP_PRIMVERT
  LUMP_PACKFILE       = 40; // Zip file (may be LZMA)
  LUMP_CLIPPORTALVERT = 41; // clipped portal poly vertecies
  LUMP_CUBEMAPS       = 42; // env_cubemap positions
  LUMP_TEXSTRDATA     = 43; // texture name data
  LUMP_TEXSTRTABLE    = 44; // index into LUMP_TEXSTRDATA
  LUMP_OVERLAYS       = 45; // info_overlay data
  LUMP_LEAFDISTWATER  = 46; // min distance from leaf to water
  LUMP_MACROTEXINFO   = 47; // macro texture info for faces
  LUMP_DISPTRIS       = 48; // disp triangles
  LUMP_49             = 49; // game-specific
  LUMP_WATEROVERLAYS  = 50; //
  LUMP_AMBIENTIDHDR   = 51; // index to LUMP_AMBIENTHDR
  LUMP_AMBIENTIDLDR   = 52; // index to LUMP_AMBIENTLDR
  LUMP_LIGHTMAPSHDR   = 53; // HDR lightmaps
  LUMP_WORLDLIGHTHDR  = 54; // HDR worldlights
  LUMP_AMBIENTHDR     = 55; // leaf ambient lights HDR
  LUMP_AMBIENTLDR     = 56; // leaf ambient lights LDR
  LUMP_PACKFILEXBOX   = 57; // Xbox (XZip) version of packfile
  LUMP_FACESHDR       = 58; // HDR Faces
  LUMP_MAPFLAGS       = 59; // game-specific flags data
  LUMP_OVERLAYFADES   = 60; // fade distances for overlays
  LUMP_61             = 61; // game-specific
  LUMP_62             = 62; // game-specific
  LUMP_DISPBLEND      = 63; // disp multiblend (4wayblend...)

  TEXTURE_NAME_LENGTH         = 128;
  MAXLIGHTMAPS	              = 4;  // per face
  MAX_DISP_CORNER_NEIGHBORS   = 4;
  OVERLAY_BSP_FACE_COUNT      = 64;   // LUMP_OVERLAYS
  WATEROVERLAY_BSP_FACE_COUNT = 256;  // LUMP_WATEROVERLAYS


type tLumpHdr = record
    nOfs  : Integer;
    nLen  : Integer;
    nVer  : Integer;
    nFCC  : Integer;
  end; // 16 Bytes
type PLumpHdr = ^tLumpHdr;
type ALumpHdr = array of tLumpHdr;

type tMapHeader = record
    nMag  : Integer;
    nVer  : Integer;
    Lump  : array[0..HEADER_LUMPS-1] of tLumpHdr;
    nRev  : Integer;
  end; // 1036 Bytes = 4 + 4 + 1024 + 4;
type PMapHeader = ^tMapHeader;

//******************************************************************************
// Lump records
// All 3D positions in [unit]'s


// 0 LUMP_ENTITIES
const LUMP_ENTITIES_VERS: array[0..0] of Byte = (0);
// Entities declared in UnitEntity as list of tEntity


// 1 LUMP_PLANES
const LUMP_PLANES_VERS: array[0..0] of Byte = (0);
// Planes declares in UnitUserTypes as list of tPlane
const SIZEOF_PLANE = SizeOf(tPLane);


// 2 LUMP_TEXDATA
const LUMP_TEXDATA_VERS: array[0..0] of Byte = (0);
type tTexData = packed record
    vfReflect : tVec3f;
    nNameTbl  : Integer;  // index in LUMP_TEXSTRTABLE
    viSize    : tVec2i;   // width & height
    viSizeView: tVec2i;     
  end; // 32 Bytes
type PTexData = ^tTexData;
type ATexData = array of tTexData;
const SIZEOF_TEXDATA = SizeOf(tTexData);


// 3 LUMP_VERTICES
const LUMP_VERTICES_VERS: array[0..0] of Byte = (0);
// Vertex lump declare in UnitUserTypes as list of tVec3f
const SIZEOF_VERTEX = SizeOf(tVec3f);


// 4 LUMP_VISIBILITY (PVS & PAS for clusters, not leafs)
const LUMP_VISIBILITY_VERS: array[0..0] of Byte = (0);
type tVisHdr = packed record
    nClusters : Integer;  // entries in pOffsets
    vOffsets  : AVec2i;   // x -> PVS, y -> PAS
    vData     : AByte;    // PVS & PAS data set
  end;
type PVisHdr = ^tVisHdr;
// data order: nClusters -> pOffsets -> pData
// order in pData: PVS[0], PAS[0], PVS[1], PAS[1], ...
// size of pData = size(lump) - 4 - 8*nClusters


// 5 LUMP_NODES
const LUMP_NODES_VERS: array[0..0] of Byte = (0);
type tNode = packed record
    nPlaneID: Integer;
    nChilds   : array[0..1] of Integer; // -1-child for leaf
    // there are up to 32768 leafs in BSP
    // VBSP generate balanced tree, then max log2(N) search = 15
    vBBOX     : tBBOXs;
    nFaceStart: WORD;
    nFaceCount: WORD;
    nAreaID   : SmallInt; // Index in LUMP_AREAS
    Padding   : WORD;
  end;  // 32 Bytes
type PNode = ^tNode;
type ANode = array of tNode;
// nAreaID >= 0 if child leafs share same area ID, or -1
const SIZEOF_NODE = SizeOf(tNode);


// 6 LUMP_TEXINFO
const LUMP_TEXINFO_VERS: array[0..0] of Byte = (0);
type tTexInfo = packed record
    vTexST  : array[0..1] of tVec4f; // [s/t][xyz offset]
    vLmpST  : array[0..1] of tVec4f; // [s/t][xyz offset]
    nFlags  : Integer; // miptex flags + overrides
    nDataID : Integer; // Index in LUMP_TEXDATA
  end; // 72 Bytes
type PTexInfo = ^tTexInfo;
type ATexInfo = array of tTexInfo;

const
  SIZEOF_TEXINFO  = SizeOf(tTexInfo);
  // miptex flags
  SURF_LIGHT      = $0001;  // value will hold the light strength
  SURF_SKY2D      = $0002;  // don't draw, indicates we should skylight + draw 2d sky but not draw the 3D skybox
  SURF_SKY        = $0004;  // don't draw, but add to skybox
  SURF_WARP       = $0008;  // turbulent water warp
  SURF_TRANS      = $0010;  // translucent (alpha mask)
  SURF_NOPORTAL   = $0020;  // the surface can not have a portal placed on it
  SURF_TRIGGER    = $0040;  // FIXME: This is an xbox hack to work around elimination of trigger surfaces, which breaks occluders
  SURF_NODRAW     = $0080;  // don't bother referencing the texture
  SURF_HINT       = $0100;  // make a primary bsp splitter
  SURF_SKIP       = $0200;  // completely ignore, allowing non-closed brushes
  SURF_NOLIGHT    = $0400;  // Don't calculate light
  SURF_BUMPLIGHT  = $0800;  // calculate three lightmaps for the surface for bumpmapping
  SURF_NOSHADOWS  = $1000;  // Don't receive shadows
  SURF_NODECALS   = $2000;  // Don't receive decals
  SURF_NOCHOP     = $4000;  // Don't subdivide patches on this surface
  SURF_HITBOX     = $8000;  // surface is part of a hitbox

  SURFMASK_NODRAW = SURF_SKY2D or SURF_SKY or SURF_NODRAW or SURF_HINT or SURF_SKIP;


// 7 LUMP_FACESLDR
const LUMP_FACESLDR_VERS: array[0..0] of Byte = (1);
type tFace = packed record
    nPlaneID    : Word;
    bSide       : Byte;     // 1 - invert plane normal, 0 - no invert
    bNode       : Byte;     // 1 - face on Node, 0 - face in Leaf
    nSEdgeStart : Integer;  // index in LUMP_SURFEDGES
    nSEdgeCount : SmallInt; // in LUMP_SURFEDGES
    nTexID      : SmallInt; // in LUMP_TEXINFO
    nDispID     : SmallInt; // in LUMP_DISPINFO
    nFogVolID   : SmallInt; // ??? is LUMP_LEAFWATERDATA (bspfile.h)
    vStyles     : array[0..3] of Byte; // 255 for unuse
    nLightmapOfs: Integer;  // byte offset in LUMP_LUMP_LIGHTMAPS***
    fArea       : Single;   // face area [unit^2]
    vLmpMin     : tVec2i;   // lightmap bbox min
    vLmpSize    : tVec2i;   // lightmap bbox size
    nOrigFaceID : Integer;  // original face this was split from
    nPrimsCount : Word;     // in LUMP_PRIMS
    nPrimsStart : Word;     // Index in LUMP_PRIMS
    nSmooth     : DWORD;    // lightmap smoothing group
  end; // 56 Bytes
type PFace = ^tFace;
type AFace = array of tFace;
const SIZEOF_FACE = SizeOf(tFace);


// 8 LUMP_LIGHTMAPSLDR
const LUMP_LIGHTMAPSLDR_VERS: array[0..0] of Byte = (1);
// Lightmap declared in UnitUserTypes
const SIZEOF_LIGHTMAP = SizeOf(tLightmap);


// 9 LUMP_OCCLUSION
const LUMPOCCLUSION_VERS: array[0..1] of Byte = (1, 2);
type tOccluderData_V2 = packed record
    nFlags    : Integer;
    nPolyStart: Integer;  // Index in tOccluderHdr.pPolyData[]
    nPolyCount: Integer;  // in tOccluderHdr.pPolyData[]
    vBBOX     : tBBOX3f;
    nArea     : Integer;  // Index in LUMP_AREAS
  end; // 40 Bytes
type POccluderData_V2 = ^tOccluderData_V2;
type AOccluderData_V2 = array of tOccluderData_V2;

type tOccluderData_V1 = packed record
    nFlags    : Integer;
    nPolyStart: Integer; // Index in tOccluderHdr.pPolyData[]
    nPolyCount: Integer; // in tOccluderHdr.pPolyData[]
    vBBOX     : tBBOX3f;
  end; // 36 Bytes
type POccluderData_V1 = ^tOccluderData_V1;
type AOccluderData_V1 = array of tOccluderData_V1;

type tOccluderPolyData = packed record
    nVertIDStart: Integer;  // Index in tOccluderHdr.pVertID[]
    nVertIDCount: Integer;  // in tOccluderHdr.pVertID[]
    nPlaneID    : Integer;  // in LUMP_PLANES
  end; // 12 Bytes
type POccluderPolyData = ^tOccluderPolyData;
type AOccluderPolyData = array of tOccluderPolyData;

type tOccluderHdr = packed record
    nData     : Integer;
    pData     : Pointer; // nData, POccluderData V1 or V2
    nPolyData : Integer;
    pPolyData : POccluderPolyData; // nPolyData
    nVertID   : Integer;
    pVertID   : PInteger; // nVertID
  end; // size of lump
type POccluderHdr = ^tOccluderHdr;

const
  OCCLUDER_FLAGS_INACTIVE = $01;


// 10 LUMP_LEAFS
const LUMP_LEAFS_VERS: array[0..1] of Byte = (0, 1);
// version 0, BSP version 19 and lower
type tVisLeaf_v0 = packed record
    nContent  : Integer;  // OR of all brushes
    nClusterID: SmallInt; // may be < 0, then exclude from PVS
    nAreaFlags: Word;     // low 9 bits Area ID in LUMP_AREAS, high 7 bits LEAF_FLAGS_***
    vBBOX     : tBBOXs;
    nLFaceSrt : WORD;     // index in LUMP_MARKSURFACES
    nLFaceCnt : WORD;     // in LUMP_MARKSURFACES
    nLBrushSrt: WORD;     // index in LUMP_MARKBRUSHES
    nLBrushCnt: WORD;     // in LUMP_MARKBRUSHES
    nWaterID  : SmallInt; // index in LUMP_LEAFWATERDATA, or -1
    vLightCube: tCompressedLightCube; // 1 cube per leaf
    padding   : WORD;
  end; // 56 Bytes
type PVisLeaf_v0 = ^tVisLeaf_v0;
type AVisLeaf_v0 = array of tVisLeaf_v0;

// version 1, BSP version 20 and higher
type tVisLeaf_v1 = packed record
    nContent  : Integer;  // OR of all brushes
    nClusterID: SmallInt; // may be < 0, then exclude from PVS
    nAreaFlags: Word;     // low 9 bits Area ID in LUMP_AREAS, high 7 bits LEAF_FLAGS_***
    vBBOX     : tBBOXs;
    nLFaceSrt : WORD;     // index in LUMP_MARKSURFACES
    nLFaceCnt : WORD;     // in LUMP_MARKSURFACES
    nLBrushSrt: WORD;     // index in LUMP_MARKBRUSHES
    nLBrushCnt: WORD;     // in LUMP_MARKBRUSHES
    nWaterID  : SmallInt; // index in LUMP_LEAFWATERDATA, or -1
    padding   : WORD;
  end; // 32 Bytes
type PVisLeaf_v1 = ^tVisLeaf_v1;
type AVisLeaf_v1 = array of tVisLeaf_v1;

const
  SIZEOF_LEAF_V0      = SizeOf(tVisLeaf_v0);
  SIZEOF_LEAF_V1      = SizeOf(tVisLeaf_v1);
  LEAF_AREAID_MASK    = $01FF;  // 9 bits
  LEAF_FLAGS_MASK     = $FE00;  // 7 bits
  LEAF_FLAGS_SKY			= $0200;  // This leaf has 3D sky in its PVS
  LEAF_FLAGS_RADIAL		= $0400;	// This leaf culled away some portals due to radial vis
  LEAF_FLAGS_SKY2D		= $0800;  // This leaf has 2D sky in its PVS


// 11 LUMP_FACEIDS (also hammer face id)
const LUMP_FACEIDS_VERS: array[0..0] of Byte = (0);
// declaration is list of Word
const SIZEOF_FACEID = SizeOf(Word);


// 12 LUMP_EDGES
const LUMP_EDGES_VERS: array[0..0] of Byte = (0);
type tEdge = packed record
    v: array[0..1] of WORD;
  end; // 4 Bytes
type PEdge = ^tEdge;
type AEdge = array of tEdge;
const SIZEOF_EDGE = SizeOf(tEdge);


// 13 LUMP_SURFEDGES
const LUMP_SURFEDGES_VERS: array[0..0] of Byte = (0);
// Surfedge lump declare as array of Integer, 4 byte per entry
const SIZEOF_SURFEDGE = SizeOf(Integer);


// 14 LUMP_BMODELS (0-th is worldspawn, min count = 1)
const LUMP_BMODELS_VERS: array[0..0] of Byte = (0);
type tBModel = packed record
    vBBOX     : tBBOX3f;
    vOrigin   : tVec3f;
    nNodeStart: Integer; // index in LUMP_NODES
    nFaceStart: Integer; // index in LUMP_FACESHDR or LUMP_FACESLDR
    nFaceCount: Integer; // in LUMP_FACESHDR or LUMP_FACESLDR
  end; // 48 Bytes
type PBModel = ^tBModel;
type ABModel = array of tBModel;
const SIZEOF_BMODEL = SizeOf(tBModel);


// 15 LUMP_WORLDLIGHTLDR
const LUMP_WORLDLIGHTLDR_VERS: array[0..0] of Byte = (0);
type tWorldlight = packed record
    vOrigin   : tVec3f;
    vColor    : tVec3f;   // RGB Intencity
    vNormal   : tVec3f;   // for surf and spotlight
    nClusterID: Integer;
    nEmitType : Integer;  // WORLDLIGHT_EMIT_***
    nStyle    : Integer;
    fStopDot  : Single;   // start of penumbra for spotlight
    fStopDot2 : Single;   // end of penumbra for spotlight
    fExponent : Single;
    fRadius   : Single;   // cutoff distance
    vAttn     : tAttenuate3f; // for spotlight and point
    nFlags    : Integer;  // DWL_FLAGS_***
    nTexID    : Integer;  // Index in LUMP_TEXINFO
    nOwner    : Integer;  // entity that this light it relative to
  end; // 88 Bytes
type PWorldlight = ^tWorldlight;
type AWorldlight = array of tWorldlight;

const
  SIZEOF_WORLDLIGHT           = SizeOf(tWorldlight);
  WORLDLIGHT_EMIT_SURFACE     = 0;  // 90 degree spotlight
  WORLDLIGHT_EMIT_POINT       = 1;  // simple point light source
  WORLDLIGHT_EMIT_SPOTLIGHT   = 2;  // spotlight with penumbra
  WORLDLIGHT_EMIT_SKYLIGHT    = 3;  // directional light with no falloff (surface must trace to SKY texture)
  WORLDLIGHT_EMIT_QUAKELIGHT  = 4;  // linear falloff, non-lambertian
  WORLDLIGHT_EMIT_SKYAMBIENT  = 5;  // spherical light source with no falloff (surface must trace to SKY texture)
  DWL_FLAGS_INAMBIENTCUBE		  = $0001;	// This says that the light was put into the per-leaf ambient cubes.


// 16 LUMP_MARKSURFACES
const LUMP_MARKSURFACES_VERS: array[0..0] of Byte = (0);
// indices to faces as list of Word
const SIZEOF_MARKSURFACE = SizeOf(Word);


// 17 LUMP_MARKBRUSHES
const LUMP_MARKBRUSHES_VERS: array[0..0] of Byte = (0);
// indices to bruhes as list of Word
const SIZEOF_MARKBRUSH = SizeOf(Word);


// 18 LUMP_ORIGBRUSHES
const LUMP_ORIGBRUSHES_VERS: array[0..0] of Byte = (0);
type tBrush = packed record
    nSideStart  : Integer; // Index in LUMP_BRUSHSIDES
    nSideCount  : Integer; // in LUMP_BRUSHSIDES
    nContents   : Integer; // one of CONTENTS_***
  end; // 12 Bytes
type PBrush = ^tBrush;
type ABrush = array of tBrush;

const
  SIZEOF_BRUSH          = SizeOf(tBrush);
  CONTENTS_EMPTY			  = 0;		// No contents
  CONTENTS_SOLID			  = $1;		// an eye is never valid in a solid
  CONTENTS_WINDOW			  = $2;		// translucent, but not watery (glass)
  CONTENTS_AUX			    = $4;
  CONTENTS_GRATE			  = $8;		// alpha-tested "grate" textures.  Bullets/sight pass through, but solids don't
  CONTENTS_SLIME			  = $10;
  CONTENTS_WATER			  = $20;
  CONTENTS_BLOCKLOS		  = $40;	// block AI line of sight
  CONTENTS_OPAQUE			  = $80;	// things that cannot be seen through (may be non-solid though)
  LAST_VISIBLE_CONTENTS	= $80;
  ALL_VISIBLE_CONTENTS  = (LAST_VISIBLE_CONTENTS OR (LAST_VISIBLE_CONTENTS-1));
  CONTENTS_TESTFOGVOLUME= $100;
  CONTENTS_UNUSED			  = $200;
  CONTENTS_UNUSED6			= $400;
  CONTENTS_TEAM1			  = $800;	  // per team contents used to differentiate collisions
  CONTENTS_TEAM2			  = $1000;	// between players and objects on different teams
  // ignore CONTENTS_OPAQUE on surfaces that have SURF_NODRAW
  CONTENTS_IGNORE_NODRAW_OPAQUE	= $2000;
  // hits entities which are MOVETYPE_PUSH (doors, plats, etc.)
  CONTENTS_MOVEABLE		  = $4000;
  CONTENTS_AREAPORTAL		= $8000;
  CONTENTS_PLAYERCLIP		= $10000;
  CONTENTS_MONSTERCLIP	= $20000;

  // currents can be added to any other contents, and may be mixed
  CONTENTS_CURRENT_0		= $40000;
  CONTENTS_CURRENT_90		= $80000;
  CONTENTS_CURRENT_180	= $100000;
  CONTENTS_CURRENT_270	= $200000;
  CONTENTS_CURRENT_UP		= $400000;
  CONTENTS_CURRENT_DOWN	= $800000;

  CONTENTS_ORIGIN			  = $1000000;	// removed before bsping an entity

  CONTENTS_MONSTER		  = $2000000;	// should never be on a brush, only in game
  CONTENTS_DEBRIS			  = $4000000;
  CONTENTS_DETAIL			  = $8000000;	// brushes to be added after vis leafs
  CONTENTS_TRANSLUCENT	= $10000000;	// auto set if any surface has trans
  CONTENTS_LADDER			  = $20000000;
  CONTENTS_HITBOX			  = $40000000;	// use accurate hitboxes on trace


// 19 LUMP_BRUSHSIDES
const LUMP_BRUSHSIDES_VERS: array[0..0] of Byte = (0);
type tBrushSide = packed record
    nPlaneID  : Word;     // facing out of the leaf
    nTexID    : SmallInt; // Index in LUMP_TEXINFO
    nDispID   : SmallInt; // Index in LUMP_DISPINFO
    nBevel    : Byte;     // is the side a bevel plane?
    nThin     : Byte;     // is any edge less than step size (16 units)?
  end; // 8 Bytes
type PBrushSide = ^tBrushSide;
type ABrushSide = array of tBrushSide;
const SIZEOF_BRUSHSIDE = SizeOf(tBrushSide);


// 20 LUMP_AREAS
const LUMP_AREAS_VERS: array[0..0] of Byte = (0);
type tSwitchArea = packed record
    nAreaportalCount  : Integer; // in LUMP_AREAPORTALS
    nAreaportalStart  : Integer; // index in LUMP_AREAPORTALS
  end; // 8 Bytes
type PSwitchArea = ^tSwitchArea;
type ASwitchArea = array of tSwitchArea;
const SIZEOF_AREA = SizeOf(tSwitchArea);


// 21 LUMP_AREAPORTALS
const LUMP_AREAPORTALS_VERS: array[0..0] of Byte = (0);
type tAreaportal = packed record
    nKey      : Word; // match entity field "portanumber"
    nOtherArea: Word; // The area this portal looks into.
    nClipStart: Word; // Index in LUMP_CLIPPORTALVERT
    nClipCount: Word; // in LUMP_CLIPPORTALVERT
    nPlaneID  : Integer;
  end; // 12 Bytes
type PAreaportal = ^tAreaportal;
type AAreaportal = array of tAreaportal;
const SIZEOF_AREAPORTAL = SizeOf(tAreaportal);


// 22 - 25 Specific L4D2 Lump
// use only array of Bytes


// 26 LUMP_DISPINFO
const LUMP_DISPINFO_VERS: array[0..0] of Byte = (0);

{type tDispSubNeighbor = packed record
    nNeighbor     : Word; // index in LUMP_DISPINFO, 0xFFFF if no
    nOrientation  : Byte; // CCW rotation of neighbor
    nSpan         : Byte; // Where the neighbor fits onto this side of our displacement.
    nNeighborSpan : Byte; // Where we fit onto our neighbor.
  end; // ?? Bytes
type PDispSubNeighbor = ^tDispSubNeighbor;

type tDispNeighbor = array[0..1] of tDispSubNeighbor; 
type PDispNeighbor = ^tDispNeighbor;

type tDispCornerNeighbors = packed record
    vNeighbors  : array[0..3] of Word; // index in LUMP_DISPINFO
    nNeighbors  : Byte; // for vNeighbors ?
  end; // ?? Bytes
type PDispCornerNeighbors = ^tDispCornerNeighbors; //}

type tDispInfo = packed record
    vOrigin     : tVec3f;   // Disp use shifted coord system
    nVertStart  : Integer;  // index in LUMP_DISPVERTEX
    nTrigStart  : Integer;  // index in LUMP_DISPTRIS
    nPower      : Integer;
    nMinTess    : Integer;  // min tesselation allowed
    fSmthAngle  : Single;   // light smooth angle
    nContent    : Integer;  // surface content.
    nDispFace   : Word;     // index in LUMP_FACESlDR or LUMP_FACESHDR
    nAlphaStart : Integer;  // index in LUMP_DISPALPHA
    nSPosStart  : Integer;  // index in LUMP_DISPLUXPOS
    // here 46 Bytes
    reserved    : array[0..89] of Byte;
    // something wrong with declarations...
    // vEdgeNgb + vCornerNgb = 90 Bytes
    //vEdgeNgb    : array[0..3] of tDispNeighbor; // ?? Bytes
    //vCornerNgb  : array[0..3] of tDispCornerNeighbors; // ?? Bytes
    vAllowVerts : array[0..9] of DWORD; // 40 Bytes
  end; // 176 Bytes
type PDispInfo = ^tDispInfo;
type ADispInfo = array of tDispInfo;
const SIZEOF_DISPINFO = SizeOf(tDispInfo);

const
  ORIENTATION_CCW_0   = 0;
  ORIENTATION_CCW_90  = 1;
  ORIENTATION_CCW_180 = 2;
  ORIENTATION_CCW_270 = 3;
	CORNER_LOWER_LEFT   = 0;
	CORNER_UPPER_LEFT   = 1;
	CORNER_UPPER_RIGHT  = 2;
	CORNER_LOWER_RIGHT  = 3;
	NEIGHBOREDGE_LEFT   = 0;
	NEIGHBOREDGE_TOP    = 1;
	NEIGHBOREDGE_RIGHT  = 2;
	NEIGHBOREDGE_BOTTOM = 3;
	CORNER_TO_CORNER    = 0;  // Span
	CORNER_TO_MIDPOINT  = 1;  // Span
	MIDPOINT_TO_CORNER  = 2;  // Span
  CHILDNODE_UPPER_RIGHT = 0;
	CHILDNODE_UPPER_LEFT  = 1;
	CHILDNODE_LOWER_LEFT  = 2;
	CHILDNODE_LOWER_RIGHT = 3;


// 27 LUMP_ORIGFACES
const LUMP_ORIGFACES_VERS: array[0..0] of Byte = (0);
// origfaces lump declared as list of tFace
// origfaces contain brush faces, before split, same for LDR and HDR
// origfaces use V1 face version
const SIZEOF_ORIGFACE = SIZEOF_FACE;


// 28 LUMP_PHYSDISP
const LUMP_PHYSDISP_VERS: array[0..0] of Byte = (0);
// think about it as array of bytes


// 29 LUMP_PHYSCOLLIDE
const LUMP_PHYSCOLLIDE_VERS: array[0..0] of Byte = (0);
// think about it as array of bytes


// 30 LUMP_VERTNORMS
const LUMP_VERTNORMS_VERS: array[0..0] of Byte = (0);
// VertNorms lump declare in UnitUserTypes as list of tVec3f
// list compressed as unique normals, no repeats
// VertNorms is normal of neighbor face for face
const SIZEOF_VERTNORM = SizeOf(tVec3f);


// 31 LUMP_VERTNORMIDS
const LUMP_VERTNORMIDS_VERS: array[0..0] of Byte = (0);
// VertNormID lump declare as list of Word, 2 byte per entry
// total count of entries = sum of edges for all faces
// Hot to use (SaveVertexNormals(), utils/vrad/lightmap.cpp):
//  for(i,k=0, i<nFaces, i++) 
//    for(j=0, j<Face[i].nSEdgeCount, j++)
//      "neighbor face normal"[k] = VERTNORMS[VERTNORMIDS[k++]];
// then use it ... for smooth ??? idk for other ideas
// TODO: what if LUMP_FACESHDR and LUMP_FACESLDR are diff ???
const SIZEOF_VERTNORMID = SizeOf(Word);


// 32 LUMP_DISPALPHA
const LUMP_DISPALPHA_VERS: array[0..0] of Byte = (0);
// DISPALPHA is always null, VBSP set it to zero
// and in tDispInfo there are trash data !!!


// 33 LUMP_DISPVERTEX
const LUMP_DISPVERTEX_VERS: array[0..0] of Byte = (0);
type tDispVert = packed record
    v : tVec3f; // dist normal to shift origin (flat) vertex
    d : Single; // disp dist amount
    a : Single; // alpha [0..1] value of blending
  end; // 20 Bytes
type PDispVert = ^tDispVert;
type ADispVert = array of tDispVert;
// for power "p" there are "(2^p + 1)^2" disp flat vertices
const SIZEOF_DISPVERT = SizeOf(tDispVert);


// 34 LUMP_DISPLUXPOS
const LUMP_DISPLUXPOS_VERS: array[0..0] of Byte = (0);
// packed byte data:
// For each displacement
//     For each lightmap sample
//         byte for index
//          if 255, then index = next byte + 255
//         3 bytes for barycentric coordinates
// barycentric[0..1] = byte / 255.9
// i think only one purpose for that... VRAD
// utils/vbsp/disp_vbsp.cpp, CalculateLightmapSamplePositions()


// 35 LUMP_GAME
const LUMP_GAME_VERS: array[0..0] of Byte = (0);

type tGameLumpInfo = packed record
    nID   : Integer;
    nFlags: Word;
    nVer  : Word;     // version
    nFOfs : Integer;  // offset, at beginning of file
    nLen  : Integer;  // size in bytes of data
  end; // 16 Bytes
type PGameLumpInfo = ^tGameLumpInfo;
type AGameLumpInfo = array of tGameLumpInfo;

type tGameLumpHdr = packed record
    nCount: Integer; // for vLumps
    vLumps: PGameLumpInfo;
  end;
type PGameLumpHdr = ^tGameLumpHdr;
// data order: nCount -> vLumps[nCount] -> raw data of each game lump

const
  GAMELUMPID_STATICPROP   = $73707270; // "sprp"
  GAMELUMPID_DETAILPROP   = $64707270; // "dprp"
  GAMELUMPID_DETAILLDR    = $64706C74; // "dplt"
  GAMELUMPID_DETAILHDR    = $64706C68; // "dplh"
// for more gamelump declaration see gamebspfile.h


// 36 LUMP_LEAFWATERDATA
const LUMP_LEAFWATERDATA_VERS: array[0..0] of Byte = (0);
type tLeafWaterData = packed record
    fSurfZ  : Single;
    fMinZ   : Single;
    nTexID  : SmallInt; // inxed in LUMP_TEXINFOS
    padding : Word;
  end; // 12 Bytes;
type PLeafWaterData = ^tLeafWaterData;
type ALeafWaterData = array of tLeafWaterData;
const SIZEOF_LEAFWATERDATA = SizeOf(tLeafWaterData);


// 37 LUMP_PRIMS
const LUMP_PRIMS_VERS: array[0..0] of Byte = (0);
type tPrimitive = packed record
    nType     : Byte; // PRIM_TRI***
    padding   : Byte;
    nIDStart  : Word; // in LUMP_PRIMVERT or in LUMP_VERTICES ???
    nIDCount  : Word;
    nVertStart: Word; // index in LUMP_PRIMVERT
    nVertCount: Word; // in LUMP_PRIMVERT
  end; // 10 Bytes
type PPrimitive = ^tPrimitive;
type APrimitive = array of tPrimitive;
const SIZEOF_PRIM = SizeOf(tPrimitive);

const
  PRIM_TRILIST  = 0;
	PRIM_TRISTRIP = 1;


// 38 LUMP_PRIMVERT
const LUMP_PRIMVERT_VERS: array[0..0] of Byte = (0);
// declaration is array of tVec3f
const SIZEOF_PRIMVERT = SizeOf(tVec3f);


// 39 LUMP_PRIMVERTID
const LUMP_PRIMVERTID_VERS: array[0..0] of Byte = (0);
// declaration is array of Word
const SIZEOF_PRIMVERTID = SizeOf(Word);


// 40 LUMP_PACKFILE
const LUMP_PACKFILE_VERS: array[0..0] of Byte = (0);
// declaration is raw array of bytes


// 41 LUMP_CLIPPORTALVERT
const LUMP_CLIPPORTALVERT_VERS: array[0..0] of Byte = (0);
// declaration is array of tVec3f
const SIZEOF_CLIPPORTALVERT = SizeOf(tVec3f);


// 42 LUMP_CUBEMAPS
const LUMP_CUBEMAPS_VERS: array[0..0] of Byte = (0);
type tCubemapInfo = packed record
    vPos  : tVec3i;   // snaped to grid
    nSize : Integer;  // w = h = 2^(size-1), if size=0 then w=h=32
  end; //16 Bytes
type PCubemapInfo = ^tCubemapInfo;
type ACubemapInfo = array of tCubemapInfo;
// cX_Y_Z.vtf and cX_Y_Z.hdr.vtf
const SIZEOF_CUBEMAP = SizeOf(tCubemapInfo);


// 43 LUMP_TEXSTRDATA
const LUMP_TEXSTRDATA_VERS: array[0..0] of Byte = (0);
// declarations is array of char (many null-terminated strings)


// 44 LUMP_TEXSTRTABLE
const LUMP_TEXSTRTABLE_VERS: array[0..0] of Byte = (0);
// declaration is array of Integer
// offsets to LUMP_TEXSTRDATA
const SIZEOF_TEXSTRTABLE = SizeOf(Integer);


// 45 LUMP_OVERLAYS
const LUMP_OVERLAYS_VERS: array[0..0] of Byte = (0);
type tOverlayInfo = packed record
    nID     : Integer;
    nTex    : SmallInt;  // LUMP_TEXINFOS
    nCount  : Word;     // low 14 bit - face count, high - render order
    vFaces  : array[0..OVERLAY_BSP_FACE_COUNT-1] of Integer;
    vU      : array[0..1] of Single;
    vV      : array[0..1] of Single;
    vUV     : array[0..3] of tVec3f;
    vOrigin : tVec3f;
    vNorm   : tVec3f;
  end; // 352 Bytes
type POverlayInfo = ^tOverlayInfo;
type AOverlayInfo = array of tOverlayInfo;
const SIZEOF_OVERLAY = SizeOf(tOverlayInfo);

const
  OVERLAY_FACECOUNTMASK = $3FFF;
  OVERLAY_RENDERORDMASK = $C000;


// 46 LUMP_LEAFDISTWATER
const LUMP_LEAFDISTWATER_VERS: array[0..0] of Byte = (0);
// declaration is array of Word
// array size is same to LUMP_LEAFS, it's index list ???
const SIZEOF_LEAFDISTWATER = SizeOf(Word);


// 47 LUMP_MACROTEXINFO
const LUMP_MACROTEXINFO_VERS: array[0..0] of Byte = (0);
// declaration is array of Word
// index in LUMP_TEXSTRTABLE, or 0xFFFF for disable
// Nth entry = Nth face id. Macro used only by VRAD
const SIZEOF_MACROTEXINFO = SizeOf(Word);


// 48 LUMP_DISPTRIS
const LUMP_DISPTRIS_VERS: array[0..0] of Byte = (0);
// declaration is as list of Word
// for power "p" there are "2x(2^p)^2" disp flat triangles
const SIZEOF_DISPTRIS = SizeOf(Word);
const
  DISPTRI_TAG_SURFACE			= $01;
  DISPTRI_TAG_WALKABLE		= $02;
  DISPTRI_TAG_BUILDABLE		= $04;
  DISPTRI_FLAG_SURFPROP1	= $08;
  DISPTRI_FLAG_SURFPROP2  = $10;
  DISPTRI_TAG_REMOVE		  = $20;


// 49 LUMP_49
// think about it as array of bytes


// 50 LUMP_WATEROVERLAYS
const LUMP_WATEROVERLAYS_VERS: array[0..0] of Byte = (0);
type tWaterOverlayInfo = packed record
    nID     : Integer;
    nTex    : SmallInt;  // LUMP_TEXINFOS
    nCount  : Word;     // low 14 bit - face count, high - render order
    vFaces  : array[0..WATEROVERLAY_BSP_FACE_COUNT-1] of Integer;
    vU      : array[0..1] of Single;
    vV      : array[0..1] of Single;
    vUV     : array[0..3] of tVec3f;
    vOrigin : tVec3f;
    vNorm   : tVec3f;
  end; // 1120 Bytes
type PWaterOverlayInfo = ^tWaterOverlayInfo;
type AWaterOverlayInfo = array of tWaterOverlayInfo;
// same as LUMP_OVERLAYS, but diff on size of vFaces
const SIZEOF_WATEROVERLAY = SizeOf(tWaterOverlayInfo);


// 51 LUMP_AMBIENTIDHDR
const LUMP_AMBIENTIDHDR_VERS: array[0..0] of Byte = (0);
type tAmbientLightHdr = packed record
    nCount: Word; // in LUMP_AMBIENTHDR or LUMP_AMBIENTLDR
    nStart: Word; // index in LUMP_AMBIENTHDR or LUMP_AMBIENTLDR
  end; // 4 Bytes
type PAmbientLightHdr = ^tAmbientLightHdr;
type AAmbientLightHdr = array of tAmbientLightHdr;
const SIZEOF_AMBIENTID = SizeOf(tAmbientLightHdr);


// 52 LUMP_AMBIENTIDLDR
const LUMP_AMBIENTIDLDR_VERS: array[0..0] of Byte = (0);
// declaration same as tAmbientLightHdr in LUMP_AMBIENTIDHDR_VERS


// 53 LUMP_LIGHTMAPSHDR
const LUMP_LIGHTMAPSHDR_VERS: array[0..0] of Byte = (1);
// Same as 8-th LUMP_LIGHTMAPSLDR


// 54 LUMP_WORLDLIGHTHDR
const LUMP_WORLDLIGHTHDR_VERS: array[0..0] of Byte = (0);
// declaration of Worldlight same as for LUMP_WORLDLIGHTLDR (15)
// use list of tWorldlight


// 55 LUMP_AMBIENTHDR
const LUMP_AMBIENTHDR_VERS: array[0..0] of Byte = (1);
type tAmbientCube = packed record
    vLight  : tCompressedLightCube;
    vPos    : tVec4b; // xyz - relative Leaf BBOX, w - padding
  end; // 28 Bytes
type PAmbientCube = ^tAmbientCube;
type AAmbientCube = array of tAmbientCube;
const SIZEOF_AMBIENTCUBE = SizeOf(tAmbientCube);


// 56 LUMP_AMBIENTLDR
const LUMP_AMBIENTLDR_VERS: array[0..0] of Byte = (1);
// declaration same as tAmbientCube in LUMP_AMBIENTHDR


// 57 LUMP_PACKFILEXBOX
// think about it as array of bytes


// 58 LUMP_FACESHDR
const LUMP_FACESHDR_VERS: array[0..0] of Byte = (1);
// declaration same as tFace in LUMP_FACES


// 59 LUMP_MAPFLAGS
// think about it as array of bytes


// 60 LUMP_OVERLAYFADES
const LUMP_OVERLAYFADES_VERS: array[0..0] of Byte = (0);
type tOverlayFadeDist = packed record
    fMin  : Single;
    fMax  : Single;
  end; // 8 Bytes
type POverlayFadeDist = ^tOverlayFadeDist;
type AOverlayFadeDist = array of tOverlayFadeDist;
// count of entries = count of tOverlays
const SIZEOF_OVERLAYFADEDIST = SizeOf(tOverlayFadeDist);


// 61-61 game-specific
// think about it as array of bytes


// 63 LUMP_DISPBLEND (ASW, CSGO)
// think about it as array of bytes


//******************************************************************************

  { Lightmaps data struct for Face without bumpmap: | Index in Lightmap Lump array
    ##############################################################################
    Lightmaps for Style[0]                          |  0
    Lightmaps for Style[1] if aviable Style[1]      |  1*LmpArea
    Lightmaps for Style[2] if aviable Style[2]      |  2*LmpArea
    Lightmaps for Style[3] if aviable Style[3]      |  3*LmpArea


    Lightmaps data struct for Face with bumpmap:    | Index in Lightmap Lump array
    ##############################################################################
    Lightmaps for Style[0]                          |  0
    Lightmaps for Style[0] with bumpmap, page 0     |  1*LmpArea
    Lightmaps for Style[0] with bumpmap, page 1     |  2*LmpArea
    Lightmaps for Style[0] with bumpmap, page 2     |  3*LmpArea
    ##############################################################################
    Lightmaps for Style[1] if aviable Style[1]      |  4*LmpArea
    Lightmaps for Style[1] with bumpmap, page 0     |  5*LmpArea
    Lightmaps for Style[1] with bumpmap, page 1     |  6*LmpArea
    Lightmaps for Style[1] with bumpmap, page 2     |  7*LmpArea
    ##############################################################################
    Lightmaps for Style[2] if aviable Style[2]      |  8*LmpArea
    Lightmaps for Style[2] with bumpmap, page 0     |  9*LmpArea
    Lightmaps for Style[2] with bumpmap, page 1     | 10*LmpArea
    Lightmaps for Style[2] with bumpmap, page 2     | 11*LmpArea
    ##############################################################################
    Lightmaps for Style[3] if aviable Style[3]      | 12*LmpArea
    Lightmaps for Style[3] with bumpmap, page 0     | 13*LmpArea
    Lightmaps for Style[3] with bumpmap, page 1     | 14*LmpArea
    Lightmaps for Style[3] with bumpmap, page 2     | 15*LmpArea
  }

// First iteration, no styles support, no textures, no select info
// use FACEDRAW_*** for select LDR or HDR field of tFaceExt
type tFaceExt = packed record
    // can Face have diff TexInfo for HDR or LDR ???
    isNotRender : array[0..1] of ByteBool; // degenerate, or no draw flag
    isDummyLmp  : array[0..1] of ByteBool;
    isDummyTex  : array[0..1] of ByteBool;
    isBump      : array[0..1] of ByteBool;

    PlaneID     : Integer;  // -1 if plane generated
    VisLeafId   : Integer;
    VisClusterId: Integer;
    BModelId    : Integer;
    nDispId     : Integer;  // -1 if no disp
    EntityId    : Integer;
    TexInfoId   : array[0..1] of Integer;
    pTexName    : PChar;    // direct ptr to lump with text data
    pDispExt    : Pointer;

    LmpByteFirst: array[0..1] of Integer;
    LmpSz       : array[0..1] of tVec2s;  // size of non-bump region
    LmpArea     : array[0..1] of Integer; // area of non-bump region
    nStyles     : array[0..1] of Integer;
    vStyles     : array[0..1,0..3] of ShortInt;

    TexRenderId : array[0..1] of Integer; // 2D Basetexture Id
    LmpMegaId   : array[0..1] of Integer; // 2D Lightmap Megatexture Id
    LmpRegionId : array[0..1] of Integer; // per style

    iFirst      : GLint;      // both for LDR/HDR
    iCount      : GLsizei;    // both for LDR/HDR
    iLast       : GLint;
    Plane       : tPlane;
    vCenter     : tVec3f;
    //Polygon     : tPolygon3f; // Plane, Vertecies, BBOX
  end;
type PFaceExt = ^tFaceExt;
type AFaceExt = array of tFaceExt;

const
  FACEDRAW_LDR = 0;
  FACEDRAW_HDR = 1;


// there are WFaces = Worldspawn + Func_detail, and EFaces = BModel faces.
// becase LDR & HDR faces use both leafface ID for visleaf, meow think
// that both have same vertex data, disp, plane
// and may difference only in lightmap data and, maybe, texinfo?

type // Ft -> child[0]. Bk -> child[1]
  PNodeExt = ^tNodeExt;
  tNodeExt = packed record
    Plane   : tPlane; // 20 Bytes
    // if nLeafXX = $FFFF then child is Node, else - child is Leaf
    nLeafFT : Word;
    nLeafBK : Word;
    // Make Node tree as "depth-way linked list"
    NodeFT  : PNodeExt;
    NodeBK  : PNodeExt;
  end; // 32 Bytes
  ANodeExt = array of tNodeExt;

type tLeafExt = packed record
    vBBOX       : tBBOX3f;    // 24 Bytes
    nCluster    : Integer;

    // ref to Map.vLeafFaces
    WFaceFirst  : Integer;
    WFaceCount  : Integer;
    WFaceLast   : Integer;

    pAmbCubs    : AAmbientCube;
  end;
type PLeafExt = ^tLeafExt;
type ALeafExt = array of tLeafExt;

type tDispExt = record
    nPower      : Integer;
    nSize       : Integer;
    nSqrSize    : Integer;
    nTriangles  : Integer;

    iFirst      : GLint;
    iCount      : GLsizei;
    iLast       : GLint;

    vBBOX       : tBBOX3f;
    vOrigin     : tVec3f;
    vBase       : array[0..3] of tVec3f;
    vLmpUV      : array[0..1,0..3] of tVec2f;
    iBase       : Integer;
    pRefFace    : PFaceExt;
    bValid      : Boolean;
  end;
type PDispExt = ^tDispExt;
type ADispExt = array of tDispExt;


type tBModelExt = packed record
    vBBOX       : tBBOX3f;
    vOrigin     : tVec3f;
    vAngles     : tVec3f;
    vColor      : tColor4fv;
    iEntity     : Integer;
    iNodeStart  : Integer;
    EFaceFirst  : Integer;
    EFaceCount  : Integer;
    EFaceLast   : Integer;
    isTrigger   : Boolean; // Class name start at "trigger_***"
  end;
type PBModelExt = ^tBModelExt;
type ABModelExt = array of tBModelExt;


//******************************************************************************

type tMapBSP = packed record
    hdr             : tMapHeader;

    vEntities       : AEntity;
    vNodes          : ANodeExt;
    vLeafs          : ALeafExt;
    vBModels        : ABModelExt;
    vLightmaps      : array[0..1] of AByte;

    VisHdr          : tVisHdr;

    vLeafFaces      : AWord;
    vFaces          : AFaceExt; // natural-order
    vFaceVertices   : AVec3f;
    vFaceTexUV      : AVec2f;
    vFaceLmpUV      : array[0..1] of AVec2f;
    vFaceLmpCAPS    : array[0..1] of AVec4f; // vec4(LmpSize.xy, nBump, nStyles)

    vDisps          : ADispExt;
    vDispVertAlpha  : AVec4f; // XYZ = final vertices, W = disp alpha

    bLDR, bHDR      : Boolean;
    nTotalFaceVertex: Integer; // both for LDR/HDR
    nTotalDispVertex: Integer; // both for LDR/HDR

    nHeadWorldspawn : Integer; // RootNode for map
    isMapLoadOK     : Boolean;
  end;
type PMapBSP = ^tMapBSP;


procedure FreeMapBSP(const Map: PMapBSP);
function LoadBSPFromFile(const FileName: String; const Map: PMapBSP): boolean;
//function ShowLoadBSPMapError(const LoadMapErrorType: eLoadMapErrors): String;

//procedure UpdateFaceExt(const Map: PMapBSP; const FaceId: Integer);
//procedure UpdateBrushModelExt(const Map: PMapBSP; const BrushModelId: Integer);
//procedure UpdateEntityExt(const Map: PMapBSP; const EntityId: Integer);
//procedure UpdateEntityLight(const Map: PMapBSP);
//procedure RebuildEntityLightStylesList(const Map: PMapBSP);
//procedure UpdateBModelInsideVisLeaf(const Map: PMapBSP);

function UnPackPVS(
  const PackedPVS: PByte;
  const UnPackedPVS: PByteBool;
  const CountPVS, PackedSize: Integer): Integer;
function GetLeafIndexByPointAsm(const RootNodeExt: PNodeExt; const Point: tVec3f): Integer;


implementation


function UnPackPVS(
  const PackedPVS: PByte;
  const UnPackedPVS: PByteBool;
  const CountPVS, PackedSize: Integer): Integer;
const
  bitLUT: array[0..15] of Integer = (
    $00000000, $00000001, $00000100, $00000101,
    $00010000, $00010001, $00010100, $00010101,
    $01000000, $01000001, $01000100, $01000101,
    $01010000, $01010001, $01010100, $01010101
  );
var
  i, j, n: Integer;
  tmp: Byte;
  PackPtr, UnpackPtr: PByte;
begin
  {$R-}
  n:=0;
  i:=0;
  PackPtr:=Pointer(PackedPVS);
  UnpackPtr:=Pointer(UnPackedPVS);
  while (n < PackedSize) do
    begin
      if (PackPtr^ = 0) then
        begin
          Inc(PackPtr);
          Inc(i);
          if (i >= PackedSize) then
            begin
              Result:=n;
              Exit;
            end;
          j:=(PackPtr^)*8;
          if ((n + j) > CountPVS) then
            begin
              ZeroFillChar(UnpackPtr, CountPVS - n);
              Result:=CountPVS;
              Exit;
            end;
          ZeroFillChar(UnpackPtr, j);
          Inc(n, j);
          Inc(UnpackPtr, j);
        end
      else
        begin
          if ((n + 8) > CountPVS) then
            begin
              tmp:=PackPtr^;
              for j:=0 to (CountPVS - n) do
                begin
                  UnpackPtr^:=tmp and $01;
                  tmp:=tmp shr 1;
                  Inc(UnpackPtr);
                end;
              Result:=CountPVS;
              Exit;
            end
          else
            begin
              PInteger(UnpackPtr)^:=bitLUT[PackPtr^ and $0F];
              Inc(UnpackPtr, 4);
              PInteger(UnpackPtr)^:=bitLUT[(PackPtr^ shr 4) and $0F];
              Inc(UnpackPtr, 4);
            end;
          Inc(n, 8);
        end;
      Inc(PackPtr);
      Inc(i);
    end;
  Result:=n;
  {$R+}
end;


procedure FreeMapBSP(const Map: PMapBSP);
var
  i: Integer;
begin
  {$R-}
  Map.isMapLoadOK:=False;
  Map.nHeadWorldspawn:=-1;
  Map.bLDR:=False;
  Map.bHDR:=False;
  Map.nTotalFaceVertex:=0;
  Map.nTotalDispVertex:=0;

  Map.VisHdr.nClusters:=0;
  SetLength(Map.VisHdr.vOffsets, 0);  Map.VisHdr.vOffsets:=nil;
  SetLength(Map.VisHdr.vData, 0);     Map.VisHdr.vData:=nil;

  for i:=0 to (Length(Map.vEntities) - 1) do
    begin
      FreeEntity(@Map.vEntities[i]);
    end;
  for i:=0 to (Length(Map.vLeafs) - 1) do
    begin
      SetLength(Map.vLeafs[i].pAmbCubs, 0);
    end;

  SetLength(Map.vEntities, 0);      Map.vEntities:=nil;
  SetLength(Map.vNodes, 0);         Map.vNodes:=nil;
  SetLength(Map.vLeafs, 0);         Map.vLeafs:=nil;
  SetLength(Map.vBModels, 0);       Map.vBModels:=nil;
  SetLength(Map.vLightmaps[FACEDRAW_LDR], 0);  Map.vLightmaps[FACEDRAW_LDR]:=nil;
  SetLength(Map.vLightmaps[FACEDRAW_HDR], 0);  Map.vLightmaps[FACEDRAW_HDR]:=nil;

  SetLength(Map.vLeafFaces, 0);     Map.vLeafFaces:=nil;
  SetLength(Map.vFaces, 0);         Map.vFaces:=nil;
  SetLength(Map.vFaceVertices, 0);  Map.vFaceVertices:=nil;
  SetLength(Map.vFaceTexUV, 0);     Map.vFaceTexUV:=nil;
  SetLength(Map.vFaceLmpUV[FACEDRAW_LDR], 0); Map.vFaceLmpUV[FACEDRAW_LDR]:=nil;
  SetLength(Map.vFaceLmpUV[FACEDRAW_HDR], 0); Map.vFaceLmpUV[FACEDRAW_HDR]:=nil;
  SetLength(Map.vFaceLmpCAPS[FACEDRAW_LDR], 0); Map.vFaceLmpCAPS[FACEDRAW_LDR]:=nil;
  SetLength(Map.vFaceLmpCAPS[FACEDRAW_HDR], 0); Map.vFaceLmpCAPS[FACEDRAW_HDR]:=nil;

  SetLength(Map.vDisps, 0);         Map.vDisps:=nil;
  SetLength(Map.vDispVertAlpha, 0); Map.vDispVertAlpha:=nil;

  ZeroFillChar(@Map.hdr, MAP_HEADER_SIZE);
  {$R+}
end;

function isLumpCanLoad(const lump: PLumpHdr; const vers: array of Byte): Boolean;
var
  i : Integer;
begin
  {$R-}
  Result:=False;
  if (lump.nLen <= 0) then Exit;

  for i:=0 to Length(vers)-1 do
    begin
      if (vers[i] = lump.nVer) then
        begin
          Result:=True;
          Exit;
        end;
    end;
  {$R+}
end;

procedure ClearTempLumpsData(const vLumpsData: PByte);
type APByte = array of PByte;
var
  i: Integer;
begin
  {$R-}
  for i:=0 to HEADER_LUMPS-1 do
    if (APByte(vLumpsData)[i] <> nil) then SysFreeMem(APByte(vLumpsData)[i]);
  {$R+}
end;

function LoadBSPFromFile(const FileName: String; const Map: PMapBSP): boolean;
var
  i, j, k, fsz : Integer;
  MapFile   : File;
  Lumps     : array[0..HEADER_LUMPS-1] of PByte;

  nPlanes   : Integer;
  nVertices : Integer;
  nEdges    : Integer;
  nSurfEdges: Integer;
  nTexInfos : Integer;
  nLeafs    : Integer;
  nLeafFaces: Integer;
  nNodes    : Integer;
  nBModels  : Integer;
  nDisps    : Integer;
  nFacesLDR : Integer;
  nFacesHDR : Integer;
  nFaces    : Integer;
  nLmpsHDR  : Integer;
  nLmpsLDR  : Integer;

  gFaceID   : Integer;
  pfe       : PFaceExt;
  pfoLDR    : PFace;
  pfoHDR    : PFace;
  pfoRef    : PFace;
  ptexRef   : PTexInfo;
  ptexLDR   : PTexInfo;
  ptexHDR   : PTexInfo;
  EdgeIndex : Integer;
  Edge      : tEdge;
  LmpIdLDR  : Integer;
  LmpIdHDR  : Integer;
  tmpVec3f  : tVec3f;
  tmpVec2f  : tVec2f;
  pDVec     : PDispVert;
  pent      : PEntity;
begin
  {$R-}
  Result:=False;
  if (Map = nil) then Exit;

  FreeMapBSP(Map);
  ZeroFillChar(@Lumps[0], SizeOf(Lumps));

  if (FileExists(FileName) = False) then Exit;

  AssignFile(MapFile, FileName);
  Reset(MapFile, 1);

  fsz:=FileSize(MapFile);
  if (fsz < MAP_HEADER_SIZE) then
    begin
      CloseFile(MapFile);
      Exit;
    end;

  BlockRead(MapFile, Map.hdr, MAP_HEADER_SIZE);
  if (Map.hdr.nMag <> MAP_MAGIC) then
    begin
      CloseFile(MapFile);
      Exit;
    end;
  {if (GetEOFbyHeader(Map.MapHeader) < MapFileSize) then
    begin
      Map.LoadState:=erBadEOFbyHeader;
      CloseFile(MapFile);
      Exit;
    end; //}

  nPlanes   := 0;
  nVertices := 0;
  nLeafs    := 0;
  nLeafFaces:= 0;
  nNodes    := 0;
  nBModels  := 0;
  nFacesLDR := 0;
  nFacesHDR := 0;
  nFaces    := 0;
  nLmpsLDR  := 0;
  nLmpsHDR  := 0;
  nEdges    := 0;
  nSurfEdges:= 0;
  //nTexInfos := 0;

  // 1. Read Faces first. If no faces - no render, no reason load map
  // 1.1 LDR Faces
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_FACESLDR], LUMP_FACESLDR_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_FACESLDR].nOfs);
      Lumps[LUMP_FACESLDR]:=SysGetMem(Map.hdr.Lump[LUMP_FACESLDR].nLen);
      BlockRead(MapFile, Lumps[LUMP_FACESLDR]^, Map.hdr.Lump[LUMP_FACESLDR].nLen);

      nFacesLDR:=Map.hdr.Lump[LUMP_FACESLDR].nLen div SIZEOF_FACE;
      Map.bLDR:=Boolean(nFacesLDR > 0);
    end;
  // 1.2 HDR Faces
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_FACESHDR], LUMP_FACESHDR_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_FACESHDR].nOfs);
      Lumps[LUMP_FACESHDR]:=SysGetMem(Map.hdr.Lump[LUMP_FACESHDR].nLen);
      BlockRead(MapFile, Lumps[LUMP_FACESHDR]^, Map.hdr.Lump[LUMP_FACESHDR].nLen);

      nFacesHDR:=Map.hdr.Lump[LUMP_FACESHDR].nLen div SIZEOF_FACE;
      Map.bHDR:=Boolean(nFacesHDR > 0);
    end;

  // if no faces - exit
  if  ((Map.bLDR or Map.bHDR) = False) then
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // if both exists, but diff count - exit
  if  (Map.bLDR and Map.bHDR) then
    begin
      if (nFacesLDR <> nFacesHDR) then
        begin
          CloseFile(MapFile);
          ClearTempLumpsData(@Lumps[0]);
          Exit;
        end;
    end;

  // 2. Faces exists, read Vertex, Edges, SurfEdges
  // 2.1 Read Vertices
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_VERTICES], LUMP_VERTICES_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_VERTICES].nOfs);
      Lumps[LUMP_VERTICES]:=SysGetMem(Map.hdr.Lump[LUMP_VERTICES].nLen);
      BlockRead(MapFile, Lumps[LUMP_VERTICES]^, Map.hdr.Lump[LUMP_VERTICES].nLen);

      nVertices:=Map.hdr.Lump[LUMP_VERTICES].nLen div SIZEOF_VERTEX;
    end;
  // 2.2 Read Edges
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_EDGES], LUMP_EDGES_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_EDGES].nOfs);
      Lumps[LUMP_EDGES]:=SysGetMem(Map.hdr.Lump[LUMP_EDGES].nLen);
      BlockRead(MapFile, Lumps[LUMP_EDGES]^, Map.hdr.Lump[LUMP_EDGES].nLen);

      nEdges:=Map.hdr.Lump[LUMP_EDGES].nLen div SIZEOF_EDGE;
    end;
  // 2.3 Read SurfEdges
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_SURFEDGES], LUMP_SURFEDGES_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_SURFEDGES].nOfs);
      Lumps[LUMP_SURFEDGES]:=SysGetMem(Map.hdr.Lump[LUMP_SURFEDGES].nLen);
      BlockRead(MapFile, Lumps[LUMP_SURFEDGES]^, Map.hdr.Lump[LUMP_SURFEDGES].nLen);

      nSurfEdges:=Map.hdr.Lump[LUMP_SURFEDGES].nLen div SIZEOF_SURFEDGE;
    end;

  // if no vertices and connections - no render faces, exit
  if  (nVertices = 0) or (nEdges = 0) or (nSurfEdges = 0) then
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // 3. Now we have minimum to draw face - faces, vertices and edges
  // next, load & build node tree for efficient render and split world faces

  // 3.1 Read Planes (need for deal with Nodes & Leafs, help for faces)
  // if no Planes -> no Node-tree
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_PLANES], LUMP_PLANES_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_PLANES].nOfs);
      Lumps[LUMP_PLANES]:=SysGetMem(Map.hdr.Lump[LUMP_PLANES].nLen);
      BlockRead(MapFile, Lumps[LUMP_PLANES]^, Map.hdr.Lump[LUMP_PLANES].nLen);

      // fix plane axistype
      nPlanes:=Map.hdr.Lump[LUMP_PLANES].nLen div SIZEOF_PLANE;
      for i:=0 to (nPlanes - 1) do
        begin
          APlane(Lumps[LUMP_PLANES])[i].AxisType:=GetPlaneTypeByNormal(
            APlane(Lumps[LUMP_PLANES])[i].Normal
          );
        end;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // 3.2 Read TexInfos (need for lightmap UV-coords on Faces, bump or nolight)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_TEXINFO], LUMP_TEXINFO_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_TEXINFO].nOfs);
      Lumps[LUMP_TEXINFO]:=SysGetMem(Map.hdr.Lump[LUMP_TEXINFO].nLen);
      BlockRead(MapFile, Lumps[LUMP_TEXINFO]^, Map.hdr.Lump[LUMP_TEXINFO].nLen);

      nTexInfos:=Map.hdr.Lump[LUMP_TEXINFO].nLen div SIZEOF_TEXINFO;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // 3.3 Read PVS (render acceleration by leafs & PVS set)
  // if no PVS - no reason load Leafs
  // if no Leafs - no reason load Nodes and build Node tree
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_VISIBILITY], LUMP_VISIBILITY_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_VISIBILITY].nOfs);
      Lumps[LUMP_VISIBILITY]:=SysGetMem(Map.hdr.Lump[LUMP_VISIBILITY].nLen);
      BlockRead(MapFile, Lumps[LUMP_VISIBILITY]^, Map.hdr.Lump[LUMP_VISIBILITY].nLen);

      Map.VisHdr.nClusters:=PInteger(Lumps[LUMP_VISIBILITY])^;
      SetLength(Map.VisHdr.vOffsets, Map.VisHdr.nClusters);
      j:=8*Map.VisHdr.nClusters + 4;
      i:=Map.hdr.Lump[LUMP_VISIBILITY].nLen - j;
      SetLength(Map.VisHdr.vData, i);
      CopyBytes(@AByte(Lumps[LUMP_VISIBILITY])[j], @Map.VisHdr.vData[0], i);
      for i:=0 to Map.VisHdr.nClusters-1 do
        begin
          Map.VisHdr.vOffsets[i].x:=AVec2i(@AByte(Lumps[LUMP_VISIBILITY])[4])[i].x - j;
          Map.VisHdr.vOffsets[i].y:=AVec2i(@AByte(Lumps[LUMP_VISIBILITY])[4])[i].y - j;
        end;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // 3.6 Read Leafs and indecies (for render acceleration, if PVS present)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_LEAFS], LUMP_LEAFS_VERS)
    and (Map.VisHdr.nClusters > 0) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_LEAFS].nOfs);
      Lumps[LUMP_LEAFS]:=SysGetMem(Map.hdr.Lump[LUMP_LEAFS].nLen);
      BlockRead(MapFile, Lumps[LUMP_LEAFS]^, Map.hdr.Lump[LUMP_LEAFS].nLen);

      case (Map.hdr.Lump[LUMP_LEAFS].nVer) of
        0: nLeafs:=Map.hdr.Lump[LUMP_LEAFS].nLen div SIZEOF_LEAF_V0;
        1: nLeafs:=Map.hdr.Lump[LUMP_LEAFS].nLen div SIZEOF_LEAF_V1;
      end;

      // if leafs present, read indecies for faces associated to leafs
      // 3.6.1 read LEAFSURFACES
      if  isLumpCanLoad(@Map.hdr.Lump[LUMP_MARKSURFACES], LUMP_MARKSURFACES_VERS)
        and (nLeafs > 0) then
        begin
          nLeafFaces:=Map.hdr.Lump[LUMP_MARKSURFACES].nLen div SIZEOF_MARKSURFACE;
          SetLength(Map.vLeafFaces, nLeafFaces);
          Seek(MapFile, Map.hdr.Lump[LUMP_MARKSURFACES].nOfs);
          BlockRead(MapFile, Map.vLeafFaces[0], nLeafFaces*SIZEOF_MARKSURFACE);
        end;

      if (nLeafFaces = 0) then
        begin
          CloseFile(MapFile);
          ClearTempLumpsData(@Lumps[0]);
          Exit;
        end;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  // 3.7 Read Nodes (for build node-tree, log2(N) leaf search)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_NODES], LUMP_NODES_VERS)
    and (nLeafs > 0) and (nPlanes > 0)  then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_NODES].nOfs);
      Lumps[LUMP_NODES]:=SysGetMem(Map.hdr.Lump[LUMP_NODES].nLen);
      BlockRead(MapFile, Lumps[LUMP_NODES]^, Map.hdr.Lump[LUMP_NODES].nLen);

      nNodes:=Map.hdr.Lump[LUMP_NODES].nLen div SIZEOF_NODE;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;
  // now Node-tree is build

  // 3.8 Read BModels (for worldspawn Node-tree beginning and ect)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_BMODELS], LUMP_BMODELS_VERS) then
    begin
      nBModels:=Map.hdr.Lump[LUMP_BMODELS].nLen div SIZEOF_BMODEL;
      if (nBModels = 0) then
        begin
          CloseFile(MapFile);
          ClearTempLumpsData(@Lumps[0]);
          Exit;
        end;

      Seek(MapFile, Map.hdr.Lump[LUMP_BMODELS].nOfs);
      Lumps[LUMP_BMODELS]:=SysGetMem(Map.hdr.Lump[LUMP_NODES].nLen);
      BlockRead(MapFile, (Lumps[LUMP_BMODELS])^, nBModels*SIZEOF_BMODEL);

      SetLength(Map.vBModels, nBModels);
      for i:=0 to nBModels-1 do
        begin
          Map.vBModels[i].vBBOX:=ABModel(Lumps[LUMP_BMODELS])[i].vBBOX;
          Map.vBModels[i].vOrigin:=ABModel(Lumps[LUMP_BMODELS])[i].vOrigin;
          Map.vBModels[i].iNodeStart:=ABModel(Lumps[LUMP_BMODELS])[i].nNodeStart;
          Map.vBModels[i].EFaceFirst:=ABModel(Lumps[LUMP_BMODELS])[i].nFaceStart;
          Map.vBModels[i].EFaceCount:=ABModel(Lumps[LUMP_BMODELS])[i].nFaceCount;

          Map.vBModels[i].EFaceLast:=Map.vBModels[i].EFaceFirst
            + Map.vBModels[i].EFaceCount - 1;
          Map.vBModels[i].vAngles:=VEC_ZERO_3F;
          Map.vBModels[i].vColor:=WhiteColor4f;
          Map.vBModels[i].iEntity:=-1;
        end;

      Map.nHeadWorldspawn:=Map.vBModels[0].iNodeStart;
    end
  else
    begin
      CloseFile(MapFile);
      ClearTempLumpsData(@Lumps[0]);
      Exit;
    end;

  Map.isMapLoadOK:=True;
  // now all critical data is load
  // next read misc lumps, that help improve render

  // 4.1 Read EntData (player start, face entity name, bmodel conenctions
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_ENTITIES], LUMP_ENTITIES_VERS) then
    begin
      Seek(MapFile, Map.hdr.Lump[LUMP_ENTITIES].nOfs);
      Lumps[LUMP_ENTITIES]:=SysGetMem(Map.hdr.Lump[LUMP_ENTITIES].nLen);
      BlockRead(MapFile, Lumps[LUMP_ENTITIES]^, Map.hdr.Lump[LUMP_ENTITIES].nLen);

      Map.vEntities:=GetEntityList(
        Lumps[LUMP_ENTITIES],
        Map.hdr.Lump[LUMP_ENTITIES].nLen
      );
    end;

  // 4.2 Read lightmaps (if LDR or HDR faces exists)
  // (even if no TexInfos, we can compute avg lightmap and flat draw face)
  // 4.2.1 Read LDR (if FacesLDR exists)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_LIGHTMAPSLDR], LUMP_LIGHTMAPSLDR_VERS)
      and (nFacesLDR > 0) then
    begin
      nLmpsLDR:=Map.hdr.Lump[LUMP_LIGHTMAPSLDR].nLen;
      if (nLmpsLDR > 0) then
        begin
          SetLength(Map.vLightmaps[FACEDRAW_LDR], nLmpsLDR);
          Seek(MapFile, Map.hdr.Lump[LUMP_LIGHTMAPSLDR].nOfs);
          BlockRead(MapFile, Map.vLightmaps[FACEDRAW_LDR][0], nLmpsLDR);
        end;
    end;
  if (Map.bLDR) then Map.bLDR:=Boolean(nLmpsLDR > 0);
  // 4.2.2 Read HDR (if FacesHDR exists)
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_LIGHTMAPSHDR], LUMP_LIGHTMAPSHDR_VERS)
      and (nFacesHDR > 0) then
    begin
      nLmpsHDR:=Map.hdr.Lump[LUMP_LIGHTMAPSHDR].nLen;
      if (nLmpsHDR > 0) then
        begin
          SetLength(Map.vLightmaps[FACEDRAW_HDR], nLmpsHDR);
          Seek(MapFile, Map.hdr.Lump[LUMP_LIGHTMAPSHDR].nOfs);
          BlockRead(MapFile, Map.vLightmaps[FACEDRAW_HDR][0], nLmpsHDR);
        end;
    end;
  if (Map.bHDR) then Map.bHDR:=Boolean(nLmpsHDR > 0);

  // 4.3 Read displacements
  if  isLumpCanLoad(@Map.hdr.Lump[LUMP_DISPINFO], LUMP_DISPINFO_VERS)
    AND isLumpCanLoad(@Map.hdr.Lump[LUMP_DISPVERTEX], LUMP_DISPVERTEX_VERS)  then
    begin
      nDisps:=Map.hdr.Lump[LUMP_DISPINFO].nLen div SIZEOF_DISPINFO;
      if (nDisps > 0) then
        begin
          Seek(MapFile, Map.hdr.Lump[LUMP_DISPINFO].nOfs);
          Lumps[LUMP_DISPINFO]:=SysGetMem(Map.hdr.Lump[LUMP_DISPINFO].nLen);
          BlockRead(MapFile, Lumps[LUMP_DISPINFO]^, Map.hdr.Lump[LUMP_DISPINFO].nLen);

          Seek(MapFile, Map.hdr.Lump[LUMP_DISPVERTEX].nOfs);
          Lumps[LUMP_DISPVERTEX]:=SysGetMem(Map.hdr.Lump[LUMP_DISPVERTEX].nLen);
          BlockRead(MapFile, Lumps[LUMP_DISPVERTEX]^, Map.hdr.Lump[LUMP_DISPVERTEX].nLen);

          SetLength(Map.vDisps, nDisps);
          ZeroFillChar(@Map.vDisps[0], nDisps*SizeOf(tDispExt));

          InitDispTriangleIndexTable();
        end;
    end;

  // 5. Next form Ext data
  // 5.1 compute Node tree (NodeExt's)
	SetLength(Map.vNodes, nNodes);
	for i:=0 to nNodes-1 do
		begin
			// copy plane equation
			Map.vNodes[i].Plane:=APlane(Lumps[LUMP_PLANES])[
				ANode(Lumps[LUMP_NODES])[i].nPlaneID];

			// Update Front Child
			if (ANode(Lumps[LUMP_NODES])[i].nChilds[0] <= 0) then
				begin
					Map.vNodes[i].nLeafFT:=not ANode(Lumps[LUMP_NODES])[i].nChilds[0];
					Map.vNodes[i].NodeFT:=nil;
				end
			else
				begin
					Map.vNodes[i].nLeafFT:=$FFFF;
					Map.vNodes[i].NodeFT:=@Map.vNodes[ANode(Lumps[LUMP_NODES])[i].nChilds[0]];
				end;

			// UpDate Back Child
			if (ANode(Lumps[LUMP_NODES])[i].nChilds[1] <= 0) then
				begin
					Map.vNodes[i].nLeafBK:=not ANode(Lumps[LUMP_NODES])[i].nChilds[1];
					Map.vNodes[i].NodeBK:=nil;
				end
			else
				begin
					Map.vNodes[i].nLeafBK:=$FFFF;
					Map.vNodes[i].NodeBK:=@Map.vNodes[ANode(Lumps[LUMP_NODES])[i].nChilds[1]];
				end;
		end;

  // 5.1.1. Get leaf index for entity
  for i:=0 to Length(Map.vEntities)-1 do
    begin
      Map.vEntities[i].VisLeaf:=GetLeafIndexByPointAsm(
        @Map.vNodes[Map.nHeadWorldspawn],
        Map.vEntities[i].Origin
      );
    end;

  // 5.2 compute leafExt's.
  SetLength(Map.vLeafs, nLeafs);
  // leaf 0 is dummy
  ZeroFillChar(@Map.vLeafs[0], SizeOf(tLeafExt)*nLeafs);
  Map.vLeafs[0].nCluster:=-1;
	if (Map.hdr.Lump[LUMP_LEAFS].nVer = 0) then for i:=1 to nLeafs-1 do
		begin
      BBOX3sTo3f(@AVisLeaf_V0(Lumps[LUMP_LEAFS])[i].vBBOX, @Map.vLeafs[i].vBBOX);
			Map.vLeafs[i].nCluster:=AVisLeaf_V0(Lumps[LUMP_LEAFS])[i].nClusterID;

      Map.vLeafs[i].WFaceFirst:=AVisLeaf_V0(Lumps[LUMP_LEAFS])[i].nLFaceSrt;
      Map.vLeafs[i].WFaceCount:=AVisLeaf_V0(Lumps[LUMP_LEAFS])[i].nLFaceCnt;
      Map.vLeafs[i].WFaceLast:=Map.vLeafs[i].WFaceFirst + Map.vLeafs[i].WFaceCount - 1;

			// for leafs version 0 precompute ambient cube list
			{SetLength(Map.vLeafs[i].pAmbCubs, 1);
			Map.vLeafs[i].pAmbCubs[0].vLight:=AVisLeaf_V0(Lumps[LUMP_LEAFS])[i].vLightCube;
			Map.vLeafs[i].pAmbCubs[0].vPos.x:=128;
			Map.vLeafs[i].pAmbCubs[0].vPos.y:=128;
			Map.vLeafs[i].pAmbCubs[0].vPos.z:=128; //}
		end;
	if (Map.hdr.Lump[LUMP_LEAFS].nVer = 1) then for i:=1 to nLeafs-1 do
		begin
      BBOX3sTo3f(@AVisLeaf_V1(Lumps[LUMP_LEAFS])[i].vBBOX, @Map.vLeafs[i].vBBOX);
			Map.vLeafs[i].nCluster:=AVisLeaf_V1(Lumps[LUMP_LEAFS])[i].nClusterID;

      Map.vLeafs[i].WFaceFirst:=AVisLeaf_V1(Lumps[LUMP_LEAFS])[i].nLFaceSrt;
      Map.vLeafs[i].WFaceCount:=AVisLeaf_V1(Lumps[LUMP_LEAFS])[i].nLFaceCnt;
      Map.vLeafs[i].WFaceLast:=Map.vLeafs[i].WFaceFirst + Map.vLeafs[i].WFaceCount - 1;
		end;

  // 5.2.2 compute World FaceExt's per leaf
  // 5.2.2.1 estimate nTotalFaceVertex
  Map.nTotalFaceVertex:=0;
  if (Map.bLDR) then
    begin
      for i:=0 to nFacesLDR-1 do
        begin
          Inc(Map.nTotalFaceVertex, AFace(Lumps[LUMP_FACESLDR])[i].nSEdgeCount);
        end;
    end;
  if (Map.nTotalFaceVertex = 0) and (Map.bHDR) then
    begin
      for i:=0 to nFacesHDR-1 do
        begin
          Inc(Map.nTotalFaceVertex, AFace(Lumps[LUMP_FACESHDR])[i].nSEdgeCount);
        end;
    end;

  if (Map.bLDR) then
    begin
      nFaces:=nFacesLDR;
      SetLength(Map.vFaceLmpUV[FACEDRAW_LDR], Map.nTotalFaceVertex);
      SetLength(Map.vFaceLmpCAPS[FACEDRAW_LDR], Map.nTotalFaceVertex);
      ZeroFillChar(@Map.vFaceLmpUV[FACEDRAW_LDR][0], Map.nTotalFaceVertex*SizeOf(tVec2f));
      ZeroFillChar(@Map.vFaceLmpCAPS[FACEDRAW_LDR][0], Map.nTotalFaceVertex*SizeOf(tVec4f));
    end;
  if (Map.bHDR) then
    begin
      nFaces:=nFacesHDR;
      SetLength(Map.vFaceLmpUV[FACEDRAW_HDR], Map.nTotalFaceVertex);
      SetLength(Map.vFaceLmpCAPS[FACEDRAW_HDR], Map.nTotalFaceVertex);
      ZeroFillChar(@Map.vFaceLmpUV[FACEDRAW_HDR][0], Map.nTotalFaceVertex*SizeOf(tVec2f));
      ZeroFillChar(@Map.vFaceLmpCAPS[FACEDRAW_HDR][0], Map.nTotalFaceVertex*SizeOf(tVec4f));
    end;
  SetLength(Map.vFaces, nFaces);
  SetLength(Map.vFaceVertices, Map.nTotalFaceVertex);
  SetLength(Map.vFaceTexUV, Map.nTotalFaceVertex);
  ZeroFillChar(@Map.vFaceVertices[0], Map.nTotalFaceVertex*SizeOf(tVec3f));
  ZeroFillChar(@Map.vFaceTexUV[0], Map.nTotalFaceVertex*SizeOf(tVec2f));
  ZeroFillChar(@Map.vFaces[0], nFaces*SizeOf(tFaceExt));

  Map.nTotalFaceVertex:=0;
	for gFaceID:=0 to nFaces-1 do
		begin
			pfoRef:=nil;
			pfoLDR:=nil;
			pfoHDR:=nil;
			ptexRef:=nil;
			ptexLDR:=nil;
			ptexHDR:=nil;

			pfe:=@Map.vFaces[gFaceID];
      pfe.VisLeafId:=0; // Leaf 0 is always NULL
      pfe.VisClusterId:=0;
      pfe.BModelId:=-1;

			if (Map.bLDR) then
				begin
					pfoLDR:=@AFace(Lumps[LUMP_FACESLDR])[gFaceID];
					pfoRef:=pfoLDR;
				end;
			if (Map.bHDR) then
				begin
					pfoHDR:=@AFace(Lumps[LUMP_FACESHDR])[gFaceID];
					pfoRef:=pfoHDR;
				end;

      pfe.nDispId:=pfoRef.nDispID;
      pfe.pDispExt:=nil;

			pfe.isNotRender[FACEDRAW_LDR]:=True;
			pfe.isDummyLmp[FACEDRAW_LDR]:=True;
			pfe.isDummyTex[FACEDRAW_LDR]:=True;
			pfe.isBump[FACEDRAW_LDR]:=False;

			pfe.isNotRender[FACEDRAW_HDR]:=True;
			pfe.isDummyLmp[FACEDRAW_HDR]:=True;
			pfe.isDummyTex[FACEDRAW_HDR]:=True;
			pfe.isBump[FACEDRAW_HDR]:=False;

			if (Map.bLDR) then
				begin
					pfe.TexInfoId[FACEDRAW_LDR]:=pfoLDR.nTexID;
					if (pfe.TexInfoId[FACEDRAW_LDR] < nTexInfos)
						and (pfe.TexInfoId[FACEDRAW_LDR] >= 0) then
						begin
							ptexLDR:=@ATexInfo(Lumps[LUMP_TEXINFO])[pfoLDR.nTexID];
							ptexRef:=ptexLDR;
							pfe.isNotRender[FACEDRAW_LDR]:=Boolean((ptexLDR.nFlags AND SURFMASK_NODRAW) > 0);
							pfe.isBump[FACEDRAW_LDR]:=Boolean((ptexLDR.nFlags AND SURF_BUMPLIGHT) > 0);
							pfe.isDummyLmp[FACEDRAW_LDR]:=Boolean((ptexLDR.nFlags AND SURF_NOLIGHT) > 0)
								OR pfe.isNotRender[FACEDRAW_LDR] OR Boolean(pfoLDR.nLightmapOfs < 0);
						end;
				end;

			if (Map.bHDR) then
				begin
					pfe.TexInfoId[FACEDRAW_HDR]:=pfoHDR.nTexID;
					if (pfe.TexInfoId[FACEDRAW_HDR] < nTexInfos)
						and (pfe.TexInfoId[FACEDRAW_HDR] >= 0) then
						begin
							ptexHDR:=@ATexInfo(Lumps[LUMP_TEXINFO])[pfoHDR.nTexID];
							ptexRef:=ptexHDR;
							pfe.isNotRender[FACEDRAW_HDR]:=Boolean((ptexHDR.nFlags AND SURFMASK_NODRAW) > 0);
							pfe.isBump[FACEDRAW_HDR]:=Boolean((ptexHDR.nFlags AND SURF_BUMPLIGHT) > 0);
							pfe.isDummyLmp[FACEDRAW_HDR]:=Boolean((ptexHDR.nFlags AND SURF_NOLIGHT) > 0)
								OR pfe.isNotRender[FACEDRAW_HDR] OR Boolean(pfoHDR.nLightmapOfs < 0);
						end;
				end;

			pfe.PlaneID:=pfoRef.nPlaneID;
			pfe.Plane:=APlane(Lumps[LUMP_PLANES])[pfe.PlaneID];

			pfe.iCount:=pfoRef.nSEdgeCount;
			pfe.iFirst:=Map.nTotalFaceVertex;
      pfe.iLast:=pfe.iFirst + pfe.iCount - 1;
			Inc(Map.nTotalFaceVertex, pfe.iCount);

			if (pfe.isDummyLmp[FACEDRAW_LDR] = False) then
				begin
					pfe.LmpByteFirst[FACEDRAW_LDR]:=pfoLDR.nLightmapOfs;
					pfe.LmpSz[FACEDRAW_LDR].x:=pfoLDR.vLmpSize.x + 1;
					pfe.LmpSz[FACEDRAW_LDR].y:=pfoLDR.vLmpSize.y + 1;
					pfe.LmpArea[FACEDRAW_LDR]:=pfe.LmpSz[FACEDRAW_LDR].x*pfe.LmpSz[FACEDRAW_LDR].y;
					if (pfe.LmpArea[FACEDRAW_LDR] < 0)
						 or (pfe.LmpArea[FACEDRAW_LDR] > 65535) then ShowMessage(
							'Error in Face ' + IntToStr(gFaceId)
							 + ': LmpArea_LDR invalid!'
						 );
          // how much we can read lightmaps pages? from min 0 to max 4 pages
          pfe.nStyles[FACEDRAW_LDR]:=0;
          PDWORD(@pfe.vStyles[FACEDRAW_LDR][0])^:=PDWORD(@pfoLDR.vStyles[0])^;
          if (pfe.vStyles[FACEDRAW_LDR][0] >= 0) then Inc(pfe.nStyles[FACEDRAW_LDR]);
          if (pfe.vStyles[FACEDRAW_LDR][1] > 0) then Inc(pfe.nStyles[FACEDRAW_LDR]);
          if (pfe.vStyles[FACEDRAW_LDR][2] > 0) then Inc(pfe.nStyles[FACEDRAW_LDR]);
          if (pfe.vStyles[FACEDRAW_LDR][3] > 0) then Inc(pfe.nStyles[FACEDRAW_LDR]);

          pfe.isDummyLmp[FACEDRAW_LDR]:=pfe.isDummyLmp[FACEDRAW_LDR]
            or Boolean(pfe.nStyles[FACEDRAW_LDR] = 0);
				end;

			if (pfe.isDummyLmp[FACEDRAW_HDR] = False) then
				begin
					pfe.LmpByteFirst[FACEDRAW_HDR]:=pfoHDR.nLightmapOfs;
					pfe.LmpSz[FACEDRAW_HDR].x:=pfoHDR.vLmpSize.x + 1;
					pfe.LmpSz[FACEDRAW_HDR].y:=pfoHDR.vLmpSize.y + 1;
					pfe.LmpArea[FACEDRAW_HDR]:=pfe.LmpSz[FACEDRAW_HDR].x*pfe.LmpSz[FACEDRAW_HDR].y;
					if (pfe.LmpArea[FACEDRAW_HDR] < 0)
						 or (pfe.LmpArea[FACEDRAW_HDR] > 65535) then ShowMessage(
							'Error in Face ' + IntToStr(gFaceId)
							 + ': LmpArea_HDR invalid!'
						 );
          // how much we can read lightmaps pages? from min 0 to max 4 pages
          pfe.nStyles[FACEDRAW_HDR]:=0;
          PDWORD(@pfe.vStyles[FACEDRAW_HDR][0])^:=PDWORD(@pfoHDR.vStyles[0])^;
          if (pfe.vStyles[FACEDRAW_HDR][0] >= 0) then Inc(pfe.nStyles[FACEDRAW_HDR]);
          if (pfe.vStyles[FACEDRAW_HDR][1] > 0) then Inc(pfe.nStyles[FACEDRAW_HDR]);
          if (pfe.vStyles[FACEDRAW_HDR][2] > 0) then Inc(pfe.nStyles[FACEDRAW_HDR]);
          if (pfe.vStyles[FACEDRAW_HDR][3] > 0) then Inc(pfe.nStyles[FACEDRAW_HDR]);

          pfe.isDummyLmp[FACEDRAW_HDR]:=pfe.isDummyLmp[FACEDRAW_HDR]
            or Boolean(pfe.nStyles[FACEDRAW_HDR] = 0);
				end;

			// Get Vertecies, TexUV, LmpUV
      pfe.vCenter:=VEC_ZERO_3F;
			for j:=0 to (pfe.iCount - 1) do
				begin
					if ((pfoRef.nSEdgeStart + j) >= nSurfEdges) then
						begin
							ShowMessage('Error in Face ' + IntToStr(gFaceId) +
								': SurfEdge ' + IntToStr(pfoRef.nSEdgeStart + j) + ' >= '
								+ IntToStr(nSurfEdges)
							);
							Continue;
						end;

					EdgeIndex:=AInt(Lumps[LUMP_SURFEDGES])[pfoRef.nSEdgeStart + j];
					if (Abs(EdgeIndex) >= nEdges) then
						begin
							ShowMessage('Error in Face ' + IntToStr(gFaceId) +
								': |EdgeID| ' + IntToStr(Abs(EdgeIndex)) + ' >= '
								+ IntToStr(nEdges)
							);
							Continue;
						end;

					Edge:=AEdge(Lumps[LUMP_EDGES])[Abs(EdgeIndex)];
					if (EdgeIndex >= 0) then
						begin
							if (Edge.v[0] >= nVertices) then
								begin
									ShowMessage('Error in Face ' + IntToStr(gFaceId) +
										': Vertex ' + IntToStr(Edge.v[0]) +' >= '
										+ IntToStr(nVertices)
									);
									Continue;
								end;
							tmpVec3f:=AVec3f(Lumps[LUMP_VERTICES])[Edge.v[0]];
						end
					else
						begin
							if (Edge.v[1] >= nVertices) then
								begin
									ShowMessage('Error in Face ' + IntToStr(gFaceId) +
										': Vertex ' + IntToStr(Edge.v[1]) +' >= '
										+ IntToStr(nVertices)
									);
									Continue;
								end;
							tmpVec3f:=AVec3f(Lumps[LUMP_VERTICES])[Edge.v[1]];
						end;
					Map.vFaceVertices[j + pfe.iFirst]:=tmpVec3f;
          pfe.vCenter.x:=pfe.vCenter.x + tmpVec3f.x;
          pfe.vCenter.y:=pfe.vCenter.y + tmpVec3f.y;
          pfe.vCenter.z:=pfe.vCenter.z + tmpVec3f.z;

					if (ptexRef <> nil) then
						begin
							Map.vFaceTexUV[j + pfe.iFirst].x:=DotVec3f4f(tmpVec3f, ptexRef.vTexST[0]);
							Map.vFaceTexUV[j + pfe.iFirst].y:=DotVec3f4f(tmpVec3f, ptexRef.vTexST[1]);
						end;
					if (ptexLDR <> nil) and (not pfe.isDummyLmp[FACEDRAW_LDR]) then
						begin
							Map.vFaceLmpUV[FACEDRAW_LDR][j + pfe.iFirst].x:=(
                DotVec3f4f(tmpVec3f, ptexLDR.vLmpST[0]) - pfoLDR.vLmpMin.x
              );
							Map.vFaceLmpUV[FACEDRAW_LDR][j + pfe.iFirst].y:=(
                DotVec3f4f(tmpVec3f, ptexLDR.vLmpST[1]) - pfoLDR.vLmpMin.y
              );

              if (pfe.isDummyLmp[FACEDRAW_LDR] = False) then
                begin
                  Map.vFaceLmpCAPS[FACEDRAW_LDR][j + pfe.iFirst].x:=pfe.LmpSz[FACEDRAW_LDR].x;
                  Map.vFaceLmpCAPS[FACEDRAW_LDR][j + pfe.iFirst].y:=pfe.LmpSz[FACEDRAW_LDR].y;
                  if pfe.isBump[FACEDRAW_LDR]
                  then Map.vFaceLmpCAPS[FACEDRAW_LDR][j + pfe.iFirst].z:=4
                  else Map.vFaceLmpCAPS[FACEDRAW_LDR][j + pfe.iFirst].z:=1;
                  Map.vFaceLmpCAPS[FACEDRAW_LDR][j + pfe.iFirst].w:=pfe.nStyles[FACEDRAW_LDR];
                end;
						end;
					if (ptexHDR <> nil) and (not pfe.isDummyLmp[FACEDRAW_HDR]) then
						begin
							Map.vFaceLmpUV[FACEDRAW_HDR][j + pfe.iFirst].x:=(
                DotVec3f4f(tmpVec3f, ptexHDR.vLmpST[0]) - pfoHDR.vLmpMin.x
              );
							Map.vFaceLmpUV[FACEDRAW_HDR][j + pfe.iFirst].y:=(
                DotVec3f4f(tmpVec3f, ptexHDR.vLmpST[1]) - pfoHDR.vLmpMin.y
              );

              if (pfe.isDummyLmp[FACEDRAW_HDR] = False) then
                begin
                  Map.vFaceLmpCAPS[FACEDRAW_HDR][j + pfe.iFirst].x:=pfe.LmpSz[FACEDRAW_HDR].x;
                  Map.vFaceLmpCAPS[FACEDRAW_HDR][j + pfe.iFirst].y:=pfe.LmpSz[FACEDRAW_HDR].y;
                  if pfe.isBump[FACEDRAW_HDR]
                  then Map.vFaceLmpCAPS[FACEDRAW_HDR][j + pfe.iFirst].z:=4
                  else Map.vFaceLmpCAPS[FACEDRAW_HDR][j + pfe.iFirst].z:=1;
                  Map.vFaceLmpCAPS[FACEDRAW_HDR][j + pfe.iFirst].w:=pfe.nStyles[FACEDRAW_HDR];
                end;
						end;
				end;
      pfe.vCenter.x:=pfe.vCenter.x/pfe.iCount;
      pfe.vCenter.y:=pfe.vCenter.y/pfe.iCount;
      pfe.vCenter.z:=pfe.vCenter.z/pfe.iCount;

      {if (pfoRef.bSide <> 0) and (pfe.iCount > 0) then
				begin
					pfe.Plane.Normal.x:=-pfe.Plane.Normal.x;
					pfe.Plane.Normal.y:=-pfe.Plane.Normal.y;
					pfe.Plane.Normal.z:=-pfe.Plane.Normal.z;
          pfe.Plane.Dist:=DotVec3f(pfe.Plane.Normal, Map.vFaceVertices[pfe.iFirst]);
				end; //}
		end;

  // 5.3 compute VisLeaf & Cluster id for FaceExt's
  for i:=0 to nLeafs-1 do
    begin
      if   (Map.vLeafs[i].nCluster < 0)
        or (Map.vLeafs[i].WFaceFirst >= nLeafFaces)
        or (Map.vLeafs[i].WFaceLast >= nLeafFaces) then Continue;

      for j:=Map.vLeafs[i].WFaceFirst to Map.vLeafs[i].WFaceLast do
        begin
          Map.vFaces[Map.vLeafFaces[j]].VisLeafId:=i;
          Map.vFaces[Map.vLeafFaces[j]].VisClusterId:=Map.vLeafs[i].nCluster;
        end;
    end;

  // 5.4 compute BModel id for FaceExt's
  for i:=0 to nBModels-1 do
    begin
      for j:=Map.vBModels[i].EFaceFirst to Map.vBModels[i].EFaceLast do
        begin
          if (j < nFaces) and (j >= 0) then Map.vFaces[j].BModelId:=i;
        end;
    end;

  // 5.5 link entity index with bmodel, compute: angles, origin, FX Color & Alpha
  for i:=0 to nBModels-1 do
    begin
      Map.vBModels[i].iEntity:=FindEntityByBModelIndex(
        @Map.vEntities[0], Length(Map.vEntities), i
      );
      if (Map.vBModels[i].iEntity >= 0) then
        begin
          pent:=@Map.vEntities[Map.vBModels[i].iEntity];
          if (pent.isOrigin) then
            begin
              Map.vBModels[i].vOrigin:=pent.Origin;
              Map.vBModels[i].vBBOX.vMin.x:=Map.vBModels[i].vBBOX.vMin.x + pent.Origin.x;
              Map.vBModels[i].vBBOX.vMin.y:=Map.vBModels[i].vBBOX.vMin.y + pent.Origin.y;
              Map.vBModels[i].vBBOX.vMin.z:=Map.vBModels[i].vBBOX.vMin.z + pent.Origin.z;
              Map.vBModels[i].vBBOX.vMax.x:=Map.vBModels[i].vBBOX.vMax.x + pent.Origin.x;
              Map.vBModels[i].vBBOX.vMax.y:=Map.vBModels[i].vBBOX.vMax.y + pent.Origin.y;
              Map.vBModels[i].vBBOX.vMax.z:=Map.vBModels[i].vBBOX.vMax.z + pent.Origin.z;
            end;
          if (pent.isAngles) then Map.vBModels[i].vAngles:=pent.Angles;

          k:=GetPairIndexByKey(@pent.Pairs[0], pent.CountPairs, 'renderamt');
          if (k >= 0) then
            begin
              Map.vBModels[i].vColor[3]:=StrToFloatDef(pent.Pairs[k].Value, 255)/255;
            end;
          k:=GetPairIndexByKey(@pent.Pairs[0], pent.CountPairs, 'rendercolor');
          if (k >= 0) then if (StrToVec(pent.Pairs[k].Value, @tmpVec3f)) then
            begin
              Map.vBModels[i].vColor[0]:=tmpVec3f.x/255;
              Map.vBModels[i].vColor[1]:=tmpVec3f.y/255;
              Map.vBModels[i].vColor[2]:=tmpVec3f.z/255;
            end;

          Map.vBModels[i].isTrigger:=Boolean(Pos('trigger_', pent.ClassName) > 0);
        end;
    end;

  // 5.6 Compute Disp Ext's
  Map.nTotalDispVertex:=0;
  for k:=0 to nDisps-1 do
    begin
      Map.vDisps[k].bValid:=False;

      i:=ADispInfo(Lumps[LUMP_DISPINFO])[k].nDispFace;
      if (i >= nFaces) then Continue;
      Map.vDisps[k].pRefFace:=@Map.vFaces[i];
      Map.vDisps[k].pRefFace.pDispExt:=@Map.vDisps[k];

      if (Map.vDisps[k].pRefFace.iCount <> 4) then Continue;

      Map.vDisps[k].nPower:=ADispInfo(Lumps[LUMP_DISPINFO])[k].nPower;
      case (Map.vDisps[k].nPower) of
        2: Map.vDisps[k].nSize:=DISP_SIZE_BY_POWER_2;
        3: Map.vDisps[k].nSize:=DISP_SIZE_BY_POWER_3;
        4: Map.vDisps[k].nSize:=DISP_SIZE_BY_POWER_4;
      else
        Continue;
      end;

      Map.vDisps[k].vOrigin:=ADispInfo(Lumps[LUMP_DISPINFO])[k].vOrigin;

      Map.vDisps[k].nSqrSize:=Sqr(Map.vDisps[k].nSize); // vVertices size too
      Map.vDisps[k].nTriangles:=Sqr(Map.vDisps[k].nSize - 1)*2;

      Map.vDisps[k].iFirst:=Map.nTotalDispVertex;
      Map.vDisps[k].iCount:=Map.vDisps[k].nSqrSize;
      Map.vDisps[k].iLast:=Map.vDisps[k].iFirst + Map.vDisps[k].iCount - 1;
      Inc(Map.nTotalDispVertex, Map.vDisps[k].iCount);

      Map.vDisps[k].bValid:=True;
    end;

  // 5.6.1 Compute DispExt vertex data
  SetLength(Map.vDispVertAlpha, Map.nTotalDispVertex);
  ZeroFillChar(@Map.vDispVertAlpha[0], Map.nTotalDispVertex*SizeOf(tVec4f));
  for k:=0 to nDisps-1 do
    begin
      if (Map.vDisps[k].bValid = False) then Continue;

      for i:=0 to 3 do Map.vDisps[k].vBase[i]:=Map.vFaceVertices[Map.vDisps[k].pRefFace.iFirst + i];
      tmpVec2f.x:=SqrDistVec3f(Map.vDisps[k].vBase[0], Map.vDisps[k].vOrigin);
      j:=0;
      for i:=1 to 3 do
        begin
          tmpVec2f.y:=SqrDistVec3f(Map.vDisps[k].vBase[i], Map.vDisps[k].vOrigin);
          if (tmpVec2f.y < tmpVec2f.x) then
            begin
              tmpVec2f.x:=tmpVec2f.y;
              j:=i;
            end;
        end;
      for i:=0 to 3 do
        begin
          Map.vDisps[k].vBase[i]:=Map.vFaceVertices[Map.vDisps[k].pRefFace.iFirst + ((i + j) mod 4)];
        end;
      Map.vDisps[k].iBase:=j;

      for i:=FACEDRAW_LDR to FACEDRAW_HDR do
        begin
          Map.vDisps[k].vLmpUV[i][0].x:=0;
          Map.vDisps[k].vLmpUV[i][0].y:=0;

          Map.vDisps[k].vLmpUV[i][1].x:=0;
          Map.vDisps[k].vLmpUV[i][1].y:=Map.vDisps[k].pRefFace.LmpSz[i].y -1;

          Map.vDisps[k].vLmpUV[i][2].x:=Map.vDisps[k].pRefFace.LmpSz[i].x -1;
          Map.vDisps[k].vLmpUV[i][2].y:=Map.vDisps[k].pRefFace.LmpSz[i].y -1;

          Map.vDisps[k].vLmpUV[i][3].x:=Map.vDisps[k].pRefFace.LmpSz[i].x -1;
          Map.vDisps[k].vLmpUV[i][3].y:=0;
        end;

      pDVec:=@ADispVert(Lumps[LUMP_DISPVERTEX])[ADispInfo(Lumps[LUMP_DISPINFO])[k].nVertStart];
      for i:=0 to Map.vDisps[k].nSize-1 do
        for j:=0 to Map.vDisps[k].nSize-1 do
          begin
            tmpVec2f.x:=i/(Map.vDisps[k].nSize-1);
            tmpVec2f.y:=j/(Map.vDisps[k].nSize-1);

            TessellatingFlatDispPoint(
              @tmpVec2f,
              @Map.vDisps[k].vBase[0],
              @tmpVec3f
            );

            Map.vDispVertAlpha[i*Map.vDisps[k].nSize + j + Map.vDisps[k].iFirst].x:=tmpVec3f.x + pDVec.v.x*pDVec.d;
            Map.vDispVertAlpha[i*Map.vDisps[k].nSize + j + Map.vDisps[k].iFirst].y:=tmpVec3f.y + pDVec.v.y*pDVec.d;
            Map.vDispVertAlpha[i*Map.vDisps[k].nSize + j + Map.vDisps[k].iFirst].z:=tmpVec3f.z + pDVec.v.z*pDVec.d;
            Map.vDispVertAlpha[i*Map.vDisps[k].nSize + j + Map.vDisps[k].iFirst].w:=pDVec.a;

            Inc(pDVec);
          end;
      GetBBOX3f(
        @Map.vDispVertAlpha[Map.vDisps[k].iFirst],
        @Map.vDisps[k].vBBOX,
        Map.vDisps[k].iCount,
        SizeOf(tVec4f)
      );
    end;

  CloseFile(MapFile);
  ClearTempLumpsData(@Lumps[0]);
  Result:=True;
  {$R+}
end;

(*function ShowLoadBSPMapError(const LoadMapErrorType: eLoadMapErrors): String;
begin
  {$R-}
  Result:='';
  case LoadMapErrorType of
    erNoErrors : Result:='No Errors in load Map File';
    erFileNotExists : Result:='Map File Not Exists';
    erMinSize : Result:='Map File have size less then size of Header';
    erBadVersion : Result:='Map File have bad BSP version';
    erBadEOFbyHeader : Result:='Size of Map File less then contained in Header';
    erNoEntData : Result:='Map File not have Entity lump';
    erNoTextures : Result:='Map File not have Texture lump';
    erNoPlanes : Result:='Map File not have Plane lump';
    erNoVertex : Result:='Map File not have Vertex lump';
    erNoNodes : Result:='Map File not have Node lump';
    erNoLeaf : Result:='Map File not have VisLeaf lump';
    erNoTexInfos : Result:='Map File not have TexInfo lump';
    erNoFaces : Result:='Map File not have Face lump';
    erNoEdge : Result:='Map File not have Edge lump';
    erNoSurfEdge : Result:='Map File not have SurfEdge lump';
    erNoMarkSurface : Result:='Map File not have MarkSurface lump';
    erNoBrushes : Result:='Map File not have ModelBrush lump';
    erNoPVS : Result:='Map File not have PVS lump';
  end;
  {$R+}
end; // *)

(*procedure UpdateEntityLight(const Map: PMapBSP);
var
  StyleIndexList: AInt; // count if enter styles in faces
  i, j, k, PairIndex: Integer;
  lpFaceExt: PFaceExt;
  lpEntity: PEntity;
  lpLightEntity: PLightEntity;
begin
  {$R-}
  // Get total count if light entities;
  Map.CountLightEntities:=0;
  for i:=1 to (Map.CountEntities - 1) do
    begin
      if (CompareString(Map.Entities[i].ClassName, ClassNameLight, 5)) then
        begin
          Inc(Map.CountLightEntities);
        end;
    end;

  // Allocate mem for light entities and parse it.
  SetLength(Map.LightEntityList, Map.CountLightEntities);
  lpLightEntity:=@Map.LightEntityList[0];
  for i:=1 to (Map.CountEntities - 1) do
    begin
      lpEntity:=@Map.Entities[i];

      if (lpEntity.ClassName = ClassNameLight) then
        begin
          lpLightEntity.ClassName:=ClassNameLight;
          lpLightEntity.TargetName:=lpEntity.TargetName;
          lpLightEntity.Origin:=lpEntity.Origin;
          lpLightEntity.VisLeafIndex:=lpEntity.VisLeaf;
          lpLightEntity.EntityIndex:=i;

          lpLightEntity.LightStyleIndex:=NONNAMED_STYLE_INDEX;
          PairIndex:=GetPairIndexByKey(@lpEntity.Pairs[0], lpEntity.CountPairs, KeyLightStyle);
          if (PairIndex >= 0) then
            begin
              j:=StrToIntDef(lpEntity.Pairs[PairIndex].Value, -1);
              if (j < 0) then j:=-1;
              if (j > 127) then j:=-1;
              lpLightEntity.LightStyleIndex:=j;
            end;

          Inc(lpLightEntity);
          Continue;
        end;

      if (lpEntity.ClassName = ClassNameLightSpot) then
        begin
          lpLightEntity.ClassName:=ClassNameLightSpot;
          lpLightEntity.TargetName:=lpEntity.TargetName;
          lpLightEntity.Origin:=lpEntity.Origin;
          lpLightEntity.Angles:=lpEntity.Angles;
          lpLightEntity.VisLeafIndex:=lpEntity.VisLeaf;
          lpLightEntity.EntityIndex:=i;

          lpLightEntity.LightStyleIndex:=NONNAMED_STYLE_INDEX;
          PairIndex:=GetPairIndexByKey(@lpEntity.Pairs[0], lpEntity.CountPairs, KeyLightStyle);
          if (PairIndex >= 0) then
            begin
              j:=StrToIntDef(lpEntity.Pairs[PairIndex].Value, -1);
              if (j < 0) then j:=-1;
              if (j > 127) then j:=-1;
              lpLightEntity.LightStyleIndex:=j;
            end;

          Inc(lpLightEntity);
          Continue;
        end;

      if (lpEntity.ClassName = ClassNameLightEnv) then
        begin
          lpLightEntity.ClassName:=ClassNameLightEnv;
          lpLightEntity.TargetName:=lpEntity.TargetName;
          lpLightEntity.Origin:=lpEntity.Origin;
          lpLightEntity.VisLeafIndex:=lpEntity.VisLeaf;
          lpLightEntity.EntityIndex:=i;

          lpLightEntity.LightStyleIndex:=NONNAMED_STYLE_INDEX;
          PairIndex:=GetPairIndexByKey(@lpEntity.Pairs[0], lpEntity.CountPairs, KeyLightStyle);
          if (PairIndex >= 0) then
            begin
              j:=StrToIntDef(lpEntity.Pairs[PairIndex].Value, -1);
              if (j < 0) then j:=-1;
              if (j > 127) then j:=-1;
              lpLightEntity.LightStyleIndex:=j;
            end;

          Inc(lpLightEntity);
          Continue;
        end;
    end;

  // Next, find total number of unique lightstyles for Faces.
  // Ignore specific limits (32 max switchable lights and
  // that styles index start at 32 to 63). Make both case.
  SetLength(StyleIndexList, 128);
  ZeroFillChar(@StyleIndexList[0], 128*SizeOf(Integer));
  for i:=0 to (Map.CountFaces - 1) do
    begin
      lpFaceExt:=@Map.FaceExtList[i];

      if (lpFaceExt.BaseFace.nStyles[0] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[0]]);
      if (lpFaceExt.BaseFace.nStyles[1] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[1]]);
      if (lpFaceExt.BaseFace.nStyles[2] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[2]]);
      if (lpFaceExt.BaseFace.nStyles[3] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[3]]);
    end;

  // Get count of unique light styles
  Map.CountLightStyles:=0;
  for i:=0 to 127 do
    begin
      if (StyleIndexList[i] > 0) then Inc(Map.CountLightStyles);
    end;

  // set unique light styles indexes
  SetLength(Map.LightStylesList, Map.CountLightStyles);
  j:=0;
  for i:=0 to 127 do
    begin
      if (StyleIndexList[i] > 0) then
        begin
          Map.LightStylesList[j].Style:=i;
          Inc(j);
        end;
    end;

  // Next - get count of entities per style index
  ZeroFillChar(@StyleIndexList[0], 128*SizeOf(Integer));
  for i:=0 to (Map.CountLightEntities - 1) do
    begin
      lpLightEntity:=@Map.LightEntityList[i];

      if (lpLightEntity.LightStyleIndex < 0) then Continue;
      Inc(StyleIndexList[lpLightEntity.LightStyleIndex]);
    end;

  // Allocate mem with get count of entities
  for i:=0 to (Map.CountLightStyles - 1) do
    begin
      k:=StyleIndexList[Map.LightStylesList[i].Style];
      Map.LightStylesList[i].CountLightEntities:=k;
      SetLength(Map.LightStylesList[i].LightEntityList, k);
      Map.LightStylesList[i].TargetName:='';
    end;
  SetLength(StyleIndexList, 0);

  // Finally - contact entity light with LightStylesList by Style index
  for i:=0 to (Map.CountLightStyles - 1) do
    begin
      k:=0;
      for j:=0 to (Map.CountLightEntities - 1) do
        begin
          lpLightEntity:=@Map.LightEntityList[j];

          if (lpLightEntity.LightStyleIndex <> Map.LightStylesList[i].Style) then Continue;
          Map.LightStylesList[i].LightEntityList[k]:=lpLightEntity;

          if (k = 0) then Map.LightStylesList[i].TargetName:=lpLightEntity.TargetName;
          Inc(k);
        end;
    end;
  {$R+}
end;

procedure RebuildEntityLightStylesList(const Map: PMapBSP);
var
  StyleIndexList: AInt; // count if enter styles in faces
  i, j, k: Integer;
  lpFaceExt: PFaceExt;
  lpLightEntity: PLightEntity;
begin
  {$R-}
  // Find total number of unique lightstyles for Faces.
  // Ignore specific limits (32 max switchable lights and
  // that styles index start at 32 to 63). Make both case.
  SetLength(StyleIndexList, 128);
  ZeroFillChar(@StyleIndexList[0], 128*SizeOf(Integer));
  for i:=0 to (Map.CountFaces - 1) do
    begin
      lpFaceExt:=@Map.FaceExtList[i];

      if (lpFaceExt.BaseFace.nStyles[0] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[0]]);
      if (lpFaceExt.BaseFace.nStyles[1] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[1]]);
      if (lpFaceExt.BaseFace.nStyles[2] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[2]]);
      if (lpFaceExt.BaseFace.nStyles[3] >= 0) then Inc(StyleIndexList[lpFaceExt.BaseFace.nStyles[3]]);
    end;

  // Get count of unique light styles
  Map.CountLightStyles:=0;
  for i:=0 to 127 do
    begin
      if (StyleIndexList[i] > 0) then Inc(Map.CountLightStyles);
    end;

  // set unique light styles indexes
  SetLength(Map.LightStylesList, Map.CountLightStyles);
  j:=0;
  for i:=0 to 127 do
    begin
      if (StyleIndexList[i] > 0) then
        begin
          Map.LightStylesList[j].Style:=i;
          Inc(j);
        end;
    end;

  // Next - get count of entities per style index
  ZeroFillChar(@StyleIndexList[0], 128*SizeOf(Integer));
  for i:=0 to (Map.CountLightEntities - 1) do
    begin
      lpLightEntity:=@Map.LightEntityList[i];

      if (lpLightEntity.LightStyleIndex < 0) then Continue;
      Inc(StyleIndexList[lpLightEntity.LightStyleIndex]);
    end;

  // Allocate mem with get count of entities
  for i:=0 to (Map.CountLightStyles - 1) do
    begin
      k:=StyleIndexList[Map.LightStylesList[i].Style];
      Map.LightStylesList[i].CountLightEntities:=k;
      SetLength(Map.LightStylesList[i].LightEntityList, k);
      Map.LightStylesList[i].TargetName:='';
    end;
  SetLength(StyleIndexList, 0);

  // Finally - contact entity light with LightStylesList by Style index
  for i:=0 to (Map.CountLightStyles - 1) do
    begin
      k:=0;
      for j:=0 to (Map.CountLightEntities - 1) do
        begin
          lpLightEntity:=@Map.LightEntityList[j];

          if (lpLightEntity.LightStyleIndex <> Map.LightStylesList[i].Style) then Continue;
          Map.LightStylesList[i].LightEntityList[k]:=lpLightEntity;

          if (k = 0) then Map.LightStylesList[i].TargetName:=lpLightEntity.TargetName;
          Inc(k);
        end;
    end;
  {$R+}
end; //*)


function GetLeafIndexByPointAsm(const RootNodeExt: PNodeExt; const Point: tVec3f): Integer;
asm
  {$R-}
  // EAX = RootNodeExt; EDX = Point; Result to EAX (AX)
  PUSH    EDX
  FLD     tVec3f[EDX].x
  FLD     tVec3f[EDX].y
  FLD     tVec3f[EDX].z
  // FPU x87 Stack = st0..i (i from 0 to 7) = (st0 = ..., st1 = ..., ... ect.):
  // st0..2 = (Point.z, Point.y, Point.x)
  //
@@LoopLeaf:
  TEST    EAX, EAX
  JZ    @@NullExit
  //
  // Plane-Point test part, N = Normal (Nx = Normal.x, ... ect.), P = Point:
  FLD     tNodeExt[EAX].Plane.Dist
  FLD     tNodeExt[EAX].Plane.Normal.x  // st0..4 = (Nx, Dist, Pz, Py, Px)
  FMUL    ST(0), ST(4)
  FLD     tNodeExt[EAX].Plane.Normal.y  // st0..5 = (Ny, Nx*Px, Dist, Pz, Py, Px)
  FMUL    ST(0), ST(4)
  FLD     tNodeExt[EAX].Plane.Normal.z  // st0..6 = (Nz, Ny*Py, Nx*Px, Dist, Pz, Py, Px)
  FMUL    ST(0), ST(4)
  FADDP   ST(1), ST(0)
  FADDP   ST(1), ST(0)                  // st0..4 = (DotVec(N, P), Dist, Pz, Py, Px)
  FCOMIP  ST(0), ST(1)
  FSTP    ST(0)                         // st0..2 = (Pz, Py, Px)
  // EFLAGS: if (DotVec(N, P) >= Dist) then CF = 0 (cc=AE), else CF = 1 (cc=B).
  // if (CF = 0) then "Point in Front part of plane space or lie on plane",
  // else "Point in Back part of plane space". Normal of plane look to Front space.
  //
  JB    @@BackPlanePart
  // Front plane part + point on plane
  MOV      DX, tNodeExt[EAX].nLeafFT
  CMP      DX, $FFFF
  JNZ    @@ChildIsLeaf
  // Front is Node
  MOV     EAX, tNodeExt[EAX].NodeFT
  JMP   @@LoopLeaf
@@BackPlanePart:
  // Back plane part
  MOV      DX, tNodeExt[EAX].nLeafBK
  CMP      DX, $FFFF
  JNZ    @@ChildIsLeaf
  // Back is Node
  MOV     EAX, tNodeExt[EAX].NodeBK
  JMP   @@LoopLeaf

@@ChildIsLeaf:
  // Child is Leaf
  MOVZX   EAX, DX
  POP     EDX
  FSTP    ST(0)
  FSTP    ST(0)
  FSTP    ST(0)
  RET
@@NullExit:
  XOR     EAX, EAX
  {$R+}
end; //*)

end.

