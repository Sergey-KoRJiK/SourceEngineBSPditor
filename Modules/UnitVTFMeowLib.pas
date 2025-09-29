unit UnitVTFMeowLib;

{Copyright (c) 2025 Sergey-KoRJiK, Belarus}

interface

uses
  SysUtils,
  Windows,
  Classes,
  UnitVec;

type
  AChar   = array of Char;
  ASInt8  = array of ShortInt;
  AUInt8  = array of Byte;
  ASInt16 = array of SmallInt;
  AUInt16 = array of WORD;
  ASInt32 = array of Integer;
  AUInt32 = array of DWORD;
  ASingle = array of Single;
  ABool   = array of Boolean;


type // 2-byte vector (UV88, ect)
  tVec2ub = array[0..1] of Byte; // 2 Bytes
  PVec2ub = ^tVec2ub;
  AVec2ub = array of tVec2ub;

type // 3-byte vector (RGB888, ect)
  tVec3ub = array[0..2] of Byte; // 3 Bytes
  PVec3ub = ^tVec3ub;
  AVec3ub = array of tVec3ub;

type // 4-byte vector (RGBA8888, ect)
  tVec4ub = array[0..3] of Byte; // 4 Bytes
  PVec4ub = ^tVec4ub;
  AVec4ub = array of tVec4ub;

type // 4-word signed vector (RGBA16161616, RGBA16161616F, ect)
  tVec4sw = array[0..3] of SmallInt; // 8 Bytes
  PVec4sw = ^tVec4sw;
  AVec4sw = array of tVec4sw;

type // FP32 4-vector (RGBA32323232F, ect)
  tVec4fp = array[0..3] of Single; // 16 Bytes;
  PVec4fp = ^tVec4fp;
  AVec4fp = array of tVec4fp;


// also full DXT1 block
type tDXTColorBlock = packed record
    c0, c1: Word; // WARNING: BGR565, not RGB565 !!!
    vIndex: DWORD;
  end; // 8 Bytes per 16 pixels
type PDXTColorBlock = ^tDXTColorBlock;
type ADXTColorBlock = array of tDXTColorBlock;

type tDXT3Block = packed record
    vAlphaRow4bit : array[0..3] of Word; // 8 Bytes
    rColorBlock   : tDXTColorBlock;
  end; // 16 Bytes
type PDXT3Block = ^tDXT3Block;
type ADXT3Block = array of tDXT3Block;

type tDXT5Block = packed record
    vAlphaHeader  : array[0..1] of Byte; // 2 Bytes
    vAlphaIndex   : array[0..5] of Byte; // 6 Bytes
    rColorBlock   : tDXTColorBlock;
  end; // 16 Bytes
type PDXT5Block = ^tDXT5Block;
type ADXT5Block = array of tDXT5Block;


type tVTFhdr = packed record
    cSignature    : array[0..3] of Char;
    nVersionMajor : DWORD;
    nVersionMinor : DWORD;
    szHeader      : DWORD;    // 16 byte align. Size of header + resources dict
    nWidth        : WORD;
    nHeight       : WORD;
    FLAGS32       : Integer;
    nFrames       : WORD;     // 1 for no animation
    nFirstFrame   : WORD;     // can be -1 for environment (7.4 and older)
    PADDING0      : DWORD;
    fReflectivity : array[0..2] of Single; // 0.0 .. 1.0 for VRAD
    PADDING1      : DWORD;
    fBumpmapScale : Single;
    HiResImgFormat: Integer;
    nMipmapCount  : Byte;     // 1 for no mipmap
    LoResImgFormat: Integer;  // for Thumbnail, DXT1 only
    nLoResWidth   : Byte;     // max recommended 16
    nLoResHeight  : Byte;     // max recommended 16
    // 63 Bytes;

    // 7.2+
    nDepth        : WORD;     // 1 for 2D texture
    // 65 Bytes;

    // 7.3+
    PADDING2      : array[0..2] of Byte;
    nResourceCount: DWORD;    // max 32
    PADDING3      : array[0..1] of DWORD;
    // 80 Bytes
  end;
type PVTFhdr = ^tVTFhdr;
type AVTFhdr = array of tVTFhdr;

type tVTFResourceHdr = packed record
    cTag    : array[0..2] of Char;
    FLAGS   : Byte;     // 0x02 - data can be stored in nOffset only
    nOffset : DWORD;    // offset at biginning of file
  end; //8 Bytes
type PVTFResourceHdr = ^tVTFResourceHdr;
type AVTFResourceHdr = array of tVTFResourceHdr;

type tVTFResource = packed record
    rHdr  : tVTFResourceHdr;
    nSize : Integer;
    vData : PByte;
  end; // 16 Bytes
type PVTFResource = ^tVTFResource;
type AVTFResource = array of tVTFResource;

const
  VTF_SIGNATURE   : array[0..3] of Char = 'VTF'#0;
  // min & max VTF version supported by VTFMeowLib
  VTF_VERSION_MAJOR_MIN       = 7; // min supported
  VTF_VERSION_MAJOR_MAX       = 7; // max supported
  VTF_VERSION_MINOR_MAX       = 5; // max supported
  VTF_VERSION_MINOR_DEPTH     = 2;
  VTF_VERSION_MINOR_RESOURCE  = 3;
  VTF_VERSION_MINOR_BC6H      = 6; // Strata Source

  VTF_RESOURCE_FLAG_NODATA    = $02;
  VTF_TAG_DATA_LO : array[0..2] of Char = #1#0#0;
  VTF_TAG_DATA_HI : array[0..2] of Char = '0'#0#0;
  VTF_TAG_SHEET   : array[0..2] of Char = #10#0#0;  // animated particle data
  VTF_TAG_CRC     : array[0..2] of Char = 'CRC';    // no additional data
  VTF_TAG_LOD     : array[0..2] of Char = 'LOD';    // no additional data
  VTF_TAG_TS0     : array[0..2] of Char = 'TS0';    // no additional data
  VTF_TAG_AXC     : array[0..2] of Char = 'AXC';    // Strata Source compress info
  VTF_TAG_Plus    : array[0..2] of Char = '+'#0#0;  // Strata Source Hotspot regions
  VTF_TAG_KVD     : array[0..2] of Char = 'KVD';    // KeyValue data
  // for VTF_TAG_LOD: nOffset[0] = power of two for U, [1] - power of two for V
  // VTF_TAG_TS0: Game-defined "extended" VTF flags.

  // VTF Flags
	TEXTUREFLAGS_POINTSAMPLE        = $00000001;  // pixel-art
	TEXTUREFLAGS_TRILINEAR          = $00000002;
	TEXTUREFLAGS_CLAMPS             = $00000004;
	TEXTUREFLAGS_CLAMPT             = $00000008;
	TEXTUREFLAGS_ANISOTROPIC        = $00000010;
	TEXTUREFLAGS_HINT_DXT5          = $00000020;  // for skybox with DXT5
	TEXTUREFLAGS_SRGB               = $00000040;
	TEXTUREFLAGS_NORMAL             = $00000080;
	TEXTUREFLAGS_NOMIP              = $00000100;  // mipmaps ignored for render
	TEXTUREFLAGS_NOLOD              = $00000200;  // texture resolution ignored
	TEXTUREFLAGS_ALL_MIPS           = $00000400;
	TEXTUREFLAGS_PROCEDURAL         = $00000800;
	TEXTUREFLAGS_ONEBITALPHA        = $00001000;
	TEXTUREFLAGS_EIGHTBITALPHA      = $00002000;
	TEXTUREFLAGS_ENVMAP             = $00004000;
	TEXTUREFLAGS_RENDERTARGET       = $00008000;
	TEXTUREFLAGS_DEPTHRENDERTARGET  = $00010000;
	TEXTUREFLAGS_NODEBUGOVERRIDE    = $00020000;
	TEXTUREFLAGS_SINGLECOPY	        = $00040000;
	TEXTUREFLAGS_PRE_SRGB           = $00080000;
	TEXTUREFLAGS_NODEPTHBUFFER      = $00800000;
	TEXTUREFLAGS_CLAMPU             = $02000000;
	TEXTUREFLAGS_VERTEXTEXTURE      = $04000000;
	TEXTUREFLAGS_SSBUMP             = $08000000;
	TEXTUREFLAGS_BORDER             = $20000000;

  // VTF pixel data format
	IMAGE_FORMAT_NONE               = -1;
	IMAGE_FORMAT_RGBA8888           =  0;
	IMAGE_FORMAT_ABGR8888           =  1;
	IMAGE_FORMAT_RGB888             =  2;
	IMAGE_FORMAT_BGR888             =  3;
	IMAGE_FORMAT_RGB565             =  4;
	IMAGE_FORMAT_I8                 =  5;
	IMAGE_FORMAT_IA88               =  6;
	IMAGE_FORMAT_P8                 =  7;
	IMAGE_FORMAT_A8                 =  8;
	IMAGE_FORMAT_RGB888_BLUESCREEN  =  9;
	IMAGE_FORMAT_BGR888_BLUESCREEN  = 10;
	IMAGE_FORMAT_ARGB8888           = 11;
	IMAGE_FORMAT_BGRA8888           = 12;
	IMAGE_FORMAT_DXT1               = 13;
	IMAGE_FORMAT_DXT3               = 14;
	IMAGE_FORMAT_DXT5               = 15;
	IMAGE_FORMAT_BGRX8888           = 16;
	IMAGE_FORMAT_BGR565             = 17;
	IMAGE_FORMAT_BGRX5551           = 18;
	IMAGE_FORMAT_BGRA4444           = 19;
	IMAGE_FORMAT_DXT1_ONEBITALPHA   = 20;
	IMAGE_FORMAT_BGRA5551           = 21;
	IMAGE_FORMAT_UV88               = 22;
	IMAGE_FORMAT_UVWQ8888           = 23;
	IMAGE_FORMAT_RGBA16161616F      = 24; // TODO: is  IEEE 754-2008 "half" ???
	IMAGE_FORMAT_RGBA16161616       = 25; // signed 16-bit (-32768..+32767)
	IMAGE_FORMAT_UVLX8888           = 26;
  MIN_IMAGE_FORMAT                = -1;
  MAX_IMAGE_FORMAT                = 26;

  STR_IMAGE_FORMAT: array[MIN_IMAGE_FORMAT..MAX_IMAGE_FORMAT] of String = (
    'NONE',
		'RGBA8888',
		'ABGR8888',
		'RGB888',
		'BGR888',
		'RGB565',
		'I8',
		'IA88',
		'P8',
		'A8',
		'RGB888_BLUESCREEN',
		'BGR888_BLUESCREEN',
		'ARGB8888',
		'BGRA8888',
		'DXT1',
		'DXT3',
		'DXT5',
		'BGRX8888',
		'BGR565',
		'BGRX5551',
		'BGRA4444',
		'DXT1_ONEBITALPHA',
		'BGRA5551',
		'UV88',
		'UVWQ8888',
		'RGBA16161616F',
		'RGBA16161616',
		'UVLX8888'
	);

  VTF_BITDEPTH_CHANNELS           = 0;
  VTF_BITDEPTH_PERPIXEL           = 1;
  VTF_BITDEPTH_PERCHANNEL0        = 2;
  VTF_BITDEPTH_PERCHANNEL1        = 3;
  VTF_BITDEPTH_PERCHANNEL2        = 4;
  VTF_BITDEPTH_PERCHANNEL3        = 5;
  VTF_BITDEPTH_DXT                = 6;
  VTF_BITDEPTH: array[MIN_IMAGE_FORMAT..MAX_IMAGE_FORMAT, 0..6] of Byte = (
    // IMAGE_FORMAT  :  Channels, BitsPerPixel, BitsPerChannel[0..3], isDXTn
    // use VTF_BITDEPTH_*** as index in VTF_BITDEPTH[.., index]
    // for DXTn fields BitsPerChannel[] are ignored
    {IMAGE_FORMAT_NONE}              (0,  0, 0, 0, 0, 0, Byte(False)),
    {IMAGE_FORMAT_RGBA8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_ABGR8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_RGB888}            (3, 24, 8, 8, 8, 0, Byte(False)),
    {IMAGE_FORMAT_BGR888}            (3, 24, 8, 8, 8, 0, Byte(False)),
    {IMAGE_FORMAT_RGB565}            (3, 16, 5, 6, 5, 0, Byte(False)),
    {IMAGE_FORMAT_I8}                (1,  8, 8, 0, 0, 0, Byte(False)),
    {IMAGE_FORMAT_IA88}              (2, 16, 8, 8, 0, 0, Byte(False)),
    {IMAGE_FORMAT_P8  UNSUPPORTED}   (0,  0, 0, 0, 0, 0, Byte(False)),
    {IMAGE_FORMAT_A8}                (1,  8, 8, 0, 0, 0, Byte(False)),
    {IMAGE_FORMAT_RGB888_BLUESCREEN} (3, 24, 8, 8, 8, 0, Byte(False)),
    {IMAGE_FORMAT_BGR888_BLUESCREEN} (3, 24, 8, 8, 8, 0, Byte(False)),
    {IMAGE_FORMAT_ARGB8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_BGRA8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_DXT1}              (4,  4, 0, 0, 0, 0, Byte(True)),
    {IMAGE_FORMAT_DXT3}              (4,  8, 0, 0, 0, 0, Byte(True)),
    {IMAGE_FORMAT_DXT5}              (4,  8, 0, 0, 0, 0, Byte(True)),
    {IMAGE_FORMAT_BGRX8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_BGR565}            (3, 16, 5, 6, 5, 0, Byte(False)),
    {IMAGE_FORMAT_BGRX5551}          (4, 16, 5, 5, 5, 1, Byte(False)),
    {IMAGE_FORMAT_BGRA4444}          (4, 16, 4, 4, 4, 4, Byte(False)),
    {IMAGE_FORMAT_DXT1_ONEBITALPHA}  (4,  4, 0, 0, 0, 0, Byte(True)),
    {IMAGE_FORMAT_BGRA5551}          (4, 16, 5, 5, 5, 1, Byte(False)),
    {IMAGE_FORMAT_UV88}              (2, 16, 8, 8, 0, 0, Byte(False)),
    {IMAGE_FORMAT_UVWQ8888}          (4, 32, 8, 8, 8, 8, Byte(False)),
    {IMAGE_FORMAT_RGBA16161616F}     (4, 64, 16, 16, 16, 16, Byte(False)),
    {IMAGE_FORMAT_RGBA16161616}      (4, 64, 16, 16, 16, 16, Byte(False)),
    {IMAGE_FORMAT_UVLX8888}          (4, 32, 8, 8, 8, 8, Byte(False))
  );

type CVTF = class
  private
    rVTFhdr       : tVTFhdr;
    bBadVTF       : Boolean;

    nHiResMegaSize: Integer;
    nHiResDataSize: Integer;
    vHiResPixels  : PByte;
    bHiResCached  : Boolean;  // if true, vHiResPixels allocated & usable
    bHiResDXTn    : Boolean;
    bHiResHDR     : Boolean;

    // for HiRes only
    iChannels     : Integer;     // all channels, 0..4
    iPixelBits    : Integer;     // total bits per pixel (avg), 0..64
    iChannel0Bits : Integer;     // (avg) bits per channel
    iChannel1Bits : Integer;
    iChannel2Bits : Integer;
    iChannel3Bits : Integer;

    nLoResMegaSize: Integer;
    nLoResDataSize: Integer;
    vLoResPixels  : PByte;    // only simple single 2D frame, 1 mipmap
    bLoResCached  : Boolean;  // if true, vLoResPixels allocated & usable
    bLoResDXTn    : Boolean;

    iFaces        : Integer;  // only for TEXTUREFLAGS_ENVMAP
    nCRC          : DWORD;    // for resource tag 'CRC'
    nULOD, nVLOD  : Byte;     // for resource tag 'LOD'
    EFLAGS        : DWORD;    // for resource tag 'TS0'
    bCRC, bLOD, bTS0: Boolean;// Resource exists flag
    bHiRes, bLoRes: Boolean;  // Resource exists flag

    // for HiRes only.
    vMipsWidth    : array[0..15] of Word;
    vMipsHeight   : array[0..15] of Word;
    vMipsDepth    : array[0..15] of Word;
    // for HiRes DXTn only, fix for tiny mipmaps
    vMipsWidthDXT : array[0..15] of Word;
    vMipsHeightDXT: array[0..15] of Word;

    vResources    : array[0..31] of tVTFResource;
    iResOffset    : Integer;
    pHiResource   : PVTFResource;
    pLoResource   : PVTFResource;

    procedure   SortAndLinkResources(const aFileSize, aResCnt: Integer);
    function    ComputeHiResDataOffset(const aMip, aFrame, aFace, aDepth: Word): Integer;
    function    GetMipsWidth  (const aMip: Integer): WORD;
    function    GetMipsHeight (const aMip: Integer): WORD;
    function    GetMipsDepth  (const aMip: Integer): WORD;
  public
    property    isBadTexture      : Boolean read bBadVTF;
    property    VTFHeader         : tVTFhdr read rVTFhdr;

    property    HiResHeight       : WORD    read rVTFhdr.nHeight;
    property    HiResWidth        : WORD    read rVTFhdr.nWidth;
    property    HiResMegasize     : Integer read nHiResMegaSize;
    property    HiResDataSize     : Integer read nHiResDataSize;
    property    isHiResCached     : Boolean read bHiResCached;
    property    isHiResDXTn       : Boolean read bHiResDXTn;
    property    isHiResHDR        : Boolean read bHiResHDR;
    property    HiResFaces        : Integer read iFaces;

    property    HiResMipWidth [const aMip: Integer]: WORD read GetMipsWidth;
    property    HiResMipHeight[const aMip: Integer]: WORD read GetMipsHeight;
    property    HiResMipDepth [const aMip: Integer]: WORD read GetMipsDepth;

    property    HiChannels        : Integer read iChannels;
    property    HiPixelBitDepth   : Integer read iPixelBits;
    property    HiChannel0Bits    : Integer read iChannel0Bits;
    property    HiChannel1Bits    : Integer read iChannel1Bits;
    property    HiChannel2Bits    : Integer read iChannel2Bits;
    property    HiChannel3Bits    : Integer read iChannel3Bits;

    property    LoResHeight       : Byte    read rVTFhdr.nLoResHeight;
    property    LoResWidth        : Byte    read rVTFhdr.nLoResWidth;
    property    LoResMegasize     : Integer read nLoResMegaSize;
    property    LoResDataSize     : Integer read nLoResDataSize;
    property    isLoResCached     : Boolean read bLoResCached;
    property    isLoResDXTn       : Boolean read bLoResDXTn;

    property    ResourceCRC       : DWORD   read nCRC;
    property    ResourceLODu      : Byte    read nULOD;
    property    ResourceLODv      : Byte    read nVLOD;
    property    ResourceExFlags   : DWORD   read EFLAGS;
    property    IsExistsCRC       : Boolean read bCRC;
    property    IsExistsUVLOD     : Boolean read bLOD;
    property    IsExistsExFlags   : Boolean read bTS0;
    property    IsExistsHiResource: Boolean read bHiRes;
    property    IsExistsLoResource: Boolean read bLoRes;

    constructor CreateTexture();
    destructor  DeleteTexture();

    procedure   Clear();
    procedure   FreeHiResolutionCache();
    procedure   FreeLoResolutionCache();

    // aLoadHiRes - load HiRes pixel data
    // aLoadLoRes - load LoRes pixel data
    // pFileSize is optional - size of opened file in bytes
    function    LoadFromFileVTF(const aFileName: String;
      const aLoadHiRes, aLoadLoRes: Boolean; const pFileSize: PInteger): Boolean;
    function    LoadFromBufferVTF(const pSrcBuf: PByte; const aBufSize: Integer;
      const aLoadHiRes, aLoadLoRes: Boolean): Boolean;

    // unpack VTF HiRes image to 2D RGBA8888 image (1 mipmap, 1 frame, 1 face, 1 depth)
    // return size of RGBA8888 buffer. pDstBuf is optional.
    // use NULL pDstBuf for compute only size for next allocate pDstBuf.
    // HDR RGBA cutted to RGBA8888 per channel
    function    UnpackHiResToRGBA8888(const aMip, aFrame, aFace, aDepth: Word;
      const pDstBuf: PByte): Integer;

    // unpack VTF HiRes as HDR image to 2D RGBA323232F (1 mipmap, 1 frame, 1 face, 1 depth)
    // RGBA16161616F unpacked from FP16 to FP32 for all 4 channels.
    // for integer RGBA16161616: [R*A / 2^14; G*A / 2^14; B*A / 2^14; 0.0]
    function    UnpackHiResHDRToRGB323232F(const aMip, aFrame, aFace, aDepth: Word;
      const pDstBuf: PByte): Integer;

    // find mipmap size with width/height that less or equal aWidth/aHeight
    // also in pW, pH, pD (optional) return size of mipmap
    function    FindNearestLowMipWidth(const aWidth: Word; const pW, pH, pD: PWord): Integer;
    function    FindNearestLowMipHeight(const aHeight: Word; const pW, pH, pD: PWord): Integer;
  end;


function  TestPowerOfTwo(const aValue: WORD): Boolean;

// Specifi function. Test division by 2 if aValue > 1.
// If aValue <= 1 then return True ALWAYS
function  TestDivByTwo(const aValue: WORD): Boolean;

// return data size (bytes) for 3D image with specific IMAGE_FORMAT_***,
// for DXTn used correction at tiny mipmaps (w or h below then 4 pixels);
// if aMipCount provide mipmap division less then 1x1, division stopped;
// aWidth, aHeight and aDepth must be divisable by 2 until aMipCount;
function  EstimateDataSizeMipmaps(const aWidth, aHeight, aDepth: Word; const aMipCount: Byte;
  const aImageFormat: Integer): Integer;

// Perform mipmap division for 3D image with size aWidth*aHeight*aDepth.
// if MaxMipCount > 0, then mipmap will subdivide until reach MaxMipCount.
// Return mipmap count. Any aMip*** is optional - list for fill subdivided
// mipmaps width, height and depth. aMipDXT*** for DXTn compression.
function  MipmapDivision(const aWidth, aHeight, aDepth: Word; const MaxMipCount: Byte;
  const aMipWidths, aMipHeights, aMipDXTWidths, aMipDXTHeights, aMipDepths: PWORD): Integer;

// unpack RGB565/BGR565 to RGBA8888. Alpha is not affected
procedure RGB565toRGBA8888(const pSrc565: PWord; const pDst8888: PVec4ub);
procedure BGR565toRGBA8888(const pSrc565: PWord; const pDst8888: PVec4ub);

// convert FP16 (from RGBA16161616F) to FP32.
// support Inf, NaN, +0,-0. All denormals set to zero.
procedure FP16toFP32(const pSrcFP16: PSmallInt; const pDstFP32: PSingle);


// vDstClr.rgb = (1 - vSrcClr.a)*vRefClr.rgb + vSrcClr.a*vSrcClr;
procedure MixByAlpha(const vSrcClr, vRefClr, vDstClr: PVec4ub);


implementation


function  TestPowerOfTwo(const aValue: WORD): Boolean;
begin
  {$R-}
  Result:=Boolean(aValue <> 0) and Boolean(Word(aValue AND (aValue - 1)) = 0);
  {$R+}
end;

function  TestDivByTwo(const aValue: WORD): Boolean;
begin
  {$R-}
  if (aValue > 2) then Result:=Boolean((aValue AND 1) = 0)
  else Result:=True;
  {$R+}
end;


function  EstimateDataSizeMipmaps(const aWidth, aHeight, aDepth: Word; const aMipCount: Byte;
  const aImageFormat: Integer): Integer;
var
  i, sum, mH, mW, mD, mDXTh, mDXTw: Integer;
  isDXTn: Boolean;
begin
  {$R-}
  if (aImageFormat < MIN_IMAGE_FORMAT) or (aImageFormat > MAX_IMAGE_FORMAT)
    or (aImageFormat = IMAGE_FORMAT_P8) or (aImageFormat = IMAGE_FORMAT_NONE) then
    begin
      Result:=0;
      Exit;
    end;

  if (aWidth < 1) or (aHeight < 1) or (aDepth < 1) or (aMipCount < 1) then
    begin
      Result:=0;
      Exit;
    end;

  mW:=aWidth;
  mH:=aHeight;
  mD:=aDepth;
  isDXTn:=Boolean(VTF_BITDEPTH[aImageFormat, VTF_BITDEPTH_DXT]);

  mDXTw:=mW;
  mDXTh:=mH;
  if (isDXTn) then
    begin
      if (mDXTw < 4) then mDXTw:=4;
      if (mDXTh < 4) then mDXTh:=4;
    end;

  sum:=mDXTw * mDXTh * mD;
  i:=1;

  while ( (i < aMipCount)
    and TestDivByTwo(mW) and TestDivByTwo(mH) and TestDivByTwo(mD)) do
    begin
      if (mW > 1) then mW:=mW div 2;
      if (mH > 1) then mH:=mH div 2;
      if (mD > 1) then mD:=mD div 2;

      mDXTw:=mW;
      mDXTh:=mH;
      if (isDXTn) then
        begin
          if (mDXTw < 4) then mDXTw:=4;
          if (mDXTh < 4) then mDXTh:=4;
        end;

      sum:=sum + (mDXTw * mDXTh * mD);
      Inc(i);
      if ((mW = 1) and (mH = 1) and (mD = 1)) then break;
    end;

  Result:=(sum * VTF_BITDEPTH[aImageFormat, VTF_BITDEPTH_PERPIXEL]) div 8;
  {$R+}
end;

function  MipmapDivision(const aWidth, aHeight, aDepth: Word; const MaxMipCount: Byte;
  const aMipWidths, aMipHeights, aMipDXTWidths, aMipDXTHeights, aMipDepths: PWORD): Integer;
var
  i, mH, mW, mD, mDXTh, mDXTw: Integer;
begin
  {$R-}
  if (aWidth < 1) or (aHeight < 1) or (aDepth < 1) then
    begin
      Result:=0;
      Exit;
    end;

  mW:=aWidth;
  mH:=aHeight;
  mD:=aDepth;
  mDXTw:=mW;
  mDXTh:=mH;
  if (mDXTw < 4) then mDXTw:=4;
  if (mDXTh < 4) then mDXTh:=4;

  if (aMipWidths <> nil) then AUInt16(aMipWidths)[0]:=mW;
  if (aMipHeights <> nil) then AUInt16(aMipHeights)[0]:=mH;
  if (aMipDXTWidths <> nil) then AUInt16(aMipDXTWidths)[0]:=mDXTw;
  if (aMipDXTHeights <> nil) then AUInt16(aMipDXTHeights)[0]:=mDXTh;
  if (aMipDepths <> nil) then AUInt16(aMipDepths)[0]:=mD;

  i:=1;
  while ( ((mW*mH*mD) > 1) and (i < MaxMipCount) and (i < 16)
          and TestDivByTwo(mW) and TestDivByTwo(mH) and TestDivByTwo(mD) ) do
    begin
      if (mW > 1) then mW:=mW div 2;
      if (mH > 1) then mH:=mH div 2;
      if (mD > 1) then mD:=mD div 2;

      mDXTw:=mW;
      mDXTh:=mH;
      if (mDXTw < 4) then mDXTw:=4;
      if (mDXTh < 4) then mDXTh:=4;

      if (aMipWidths <> nil) then AUInt16(aMipWidths)[i]:=mW;
      if (aMipHeights <> nil) then AUInt16(aMipHeights)[i]:=mH;
      if (aMipDXTWidths <> nil) then AUInt16(aMipDXTWidths)[i]:=mDXTw;
      if (aMipDXTHeights <> nil) then AUInt16(aMipDXTHeights)[i]:=mDXTh;
      if (aMipDepths <> nil) then AUInt16(aMipDepths)[i]:=mD;

      Inc(i);
    end;

  Result:=i;
  {$R+}
end;


procedure RGB565toRGBA8888(const pSrc565: PWord; const pDst8888: PVec4ub);
begin
  {$R-}
  pDst8888^[0]:=Byte((pSrc565^ AND $001F) shl 3);
  pDst8888^[1]:=Byte((pSrc565^ AND $07E0) shr 3);
  pDst8888^[2]:=Byte((pSrc565^ AND $F800) shr 8);
  {$R+}
end;

procedure BGR565toRGBA8888(const pSrc565: PWord; const pDst8888: PVec4ub);
begin
  {$R-}
  pDst8888^[0]:=Byte((pSrc565^ AND $F800) shr 8);
  pDst8888^[1]:=Byte((pSrc565^ AND $07E0) shr 3);
  pDst8888^[2]:=Byte((pSrc565^ AND $001F) shl 3);
  {$R+}
end;


procedure FP16toFP32(const pSrcFP16: PSmallInt; const pDstFP32: PSingle);
var
  t1, t2, t3: DWORD;
begin
  {$R-}
  t1:= pSrcFP16^ AND $7FFF;   // Non-sign bits
  t2:= pSrcFP16^ AND $8000;   // Sign bit
  t3:= pSrcFP16^ AND $7C00;   // Exponent

  t1:=t1 shl 13;              // Align mantissa on MSB
  t2:=t2 shl 16;              // Shift sign bit into position

  t1:=t1 + $38000000;         // Adjust bias

  if (t3 = 0) then t1:=0;     // Denormals-as-zero

  pDstFP32^:=t1 OR t2;       // Re-insert sign bit
  {$R+}
end;


// vDstClr.rgb = (1 - vSrcClr.a)*vRefClr.rgb + vSrcClr.a*vSrcClr;
procedure MixByAlpha(const vSrcClr, vRefClr, vDstClr: PVec4ub);
begin
  {$R-}
  vDstClr[0]:=((255 - vSrcClr[3])*vRefClr[0] + vSrcClr[3]*vSrcClr[0]) shr 8;
  vDstClr[1]:=((255 - vSrcClr[3])*vRefClr[1] + vSrcClr[3]*vSrcClr[1]) shr 8;
  vDstClr[2]:=((255 - vSrcClr[3])*vRefClr[2] + vSrcClr[3]*vSrcClr[2]) shr 8;
  vDstClr[3]:=$FF;
  {$R+}
end;

//##############################################################################
//##############################################################################
//                     BEGIN CVTF Implementation
//##############################################################################
//##############################################################################


constructor CVTF.CreateTexture();
begin
  {$R-}
  Self.vLoResPixels:=nil;
  Self.vHiResPixels:=nil;
  FillChar(Self.vResources[0], SizeOf(Self.vResources), 0);
  Self.Clear();
  {$R+}
end;

destructor  CVTF.DeleteTexture();
begin
  {$R-}
  Self.Clear();
  {$R+}
end;


function    CVTF.GetMipsWidth  (const aMip: Integer): WORD;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;
  if (aMip < 0) or (aMip > 15) then Exit;
  Result:=Self.vMipsWidth[aMip];
  {$R+}
end;

function    CVTF.GetMipsHeight (const aMip: Integer): WORD;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;
  if (aMip < 0) or (aMip > 15) then Exit;
  Result:=Self.vMipsHeight[aMip];
  {$R+}
end;

function    CVTF.GetMipsDepth  (const aMip: Integer): WORD;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;
  if (aMip < 0) or (aMip > 15) then Exit;
  Result:=Self.vMipsDepth[aMip];
  {$R+}
end;

procedure   CVTF.SortAndLinkResources(const aFileSize, aResCnt: Integer);
var
  i, j, mId: Integer;
  tmpRes: tVTFResource;
begin
  {$R-}
  // 1. move all non-data resources to beginning of list
  for i:=0 to aResCnt-2 do
    begin
      mId:=i;
      for j:=i+1 to aResCnt-1 do
        begin
          if (Self.vResources[j].rHdr.FLAGS = VTF_RESOURCE_FLAG_NODATA) then
            begin
              mId:=j;
            end;
        end;

      if (mId <> i) then
        begin
          tmpRes:=Self.vResources[i];
          Self.vResources[i]:=Self.vResources[mId];
          Self.vResources[mId]:=tmpRes;
        end;
    end;

  // 2. Compute offset, that separate non-data resources and data-resources
  Self.iResOffset:=0;
  for i:=0 to aResCnt-1 do
    begin
      if (Self.vResources[i].rHdr.FLAGS = VTF_RESOURCE_FLAG_NODATA) then
        begin
          Self.iResOffset:=i+1;
        end;
    end;

  // 3. Sort data-reources by nOffset
  for i:=Self.iResOffset to aResCnt-2 do
    begin
      mId:=i;
      for j:=i+1 to aResCnt-1 do
        begin
          if (Self.vResources[j].rHdr.nOffset < Self.vResources[mId].rHdr.nOffset) then
            begin
              mId:=j;
            end;
        end;

      if (mId <> i) then
        begin
          tmpRes:=Self.vResources[i];
          Self.vResources[i]:=Self.vResources[mId];
          Self.vResources[mId]:=tmpRes;
        end;
    end;

  for i:=Self.iResOffset to aResCnt-2 do
    begin
      Self.vResources[i].nSize:=Self.vResources[i+1].rHdr.nOffset
        - Self.vResources[i].rHdr.nOffset;
    end;
  i:=aResCnt-1;
  Self.vResources[i].nSize:=aFileSize - Integer(Self.vResources[i].rHdr.nOffset);

  for i:=0 to aResCnt-1 do
    begin
      if (Self.vResources[i].rHdr.cTag = VTF_TAG_DATA_LO) then
        begin
          Self.pLoResource:=@Self.vResources[i];
        end;
      if (Self.vResources[i].rHdr.cTag = VTF_TAG_DATA_HI) then
        begin
          Self.pHiResource:=@Self.vResources[i];
        end;
    end;
  {$R+}
end;

function    CVTF.ComputeHiResDataOffset(const aMip, aFrame, aFace, aDepth: Word): Integer;
var
  factor, sum, i, j, szMip: Integer;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;
  if (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_P8) or
     (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_NONE) then Exit;

  factor:=Self.iFaces * Self.rVTFhdr.nFrames;
  sum:=0;
  for i:=0 to Self.rVTFhdr.nMipmapCount-1 do
    begin
      // i iterate from lower mip level (nMipmapCount-1) to higher (0)
      if (i = (Self.rVTFhdr.nMipmapCount-1 -aMip)) then break;
      j:=Self.rVTFhdr.nMipmapCount-1 -i;
      if (Self.bHiResDXTn) then szMip:=vMipsWidthDXT[j]*vMipsHeightDXT[j]
      else szMip:=vMipsWidth[j]*vMipsHeight[j];
      szMip:=(szMip * vMipsDepth[j] * Self.iPixelBits) div 8;

      sum:=sum + (szMip * factor);
    end;

  if (Self.bHiResDXTn) then szMip:=vMipsWidthDXT[aMip]*vMipsHeightDXT[aMip]
  else szMip:=vMipsWidth[aMip]*vMipsHeight[aMip];
  szMip:=(szMip * Self.iPixelBits) div 8;

  sum:=sum +
    (aDepth * szMip) +
    (aFace * vMipsDepth[aMip] * szMip) +
    (aFrame * vMipsDepth[aMip] * Self.iFaces * szMip);

  Result:=sum;
  {$R+}
end;

procedure   CVTF.Clear();
var
  i: Integer;
begin
  {$R-}
  Self.bBadVTF:=True;

  FillChar(Self.rVTFhdr, SizeOf(tVTFhdr), 0);
  FillChar(Self.vMipsWidth[0], SizeOf(Self.vMipsWidth), 0);
  FillChar(Self.vMipsHeight[0], SizeOf(Self.vMipsHeight), 0);
  FillChar(Self.vMipsWidthDXT[0], SizeOf(Self.vMipsWidthDXT), 0);
  FillChar(Self.vMipsHeightDXT[0], SizeOf(Self.vMipsHeightDXT), 0);
  FillChar(Self.vMipsDepth[0], SizeOf(Self.vMipsDepth), 0);

  Self.rVTFhdr.HiResImgFormat:=IMAGE_FORMAT_NONE;
  Self.rVTFhdr.LoResImgFormat:=IMAGE_FORMAT_NONE;

  for i:=0 to 31 do
    begin
      if (Self.vResources[i].vData <> nil) then FreeMem(Self.vResources[i].vData);
    end;
  FillChar(Self.vResources[0], SizeOf(Self.vResources), 0);
  Self.pHiResource:=nil;
  Self.pLoResource:=nil;
  Self.iResOffset:=0;

  Self.nHiResMegaSize:=0;
  Self.nHiResDataSize:=0;
  Self.bHiResCached:=False;
  if (Self.vHiResPixels <> nil) then FreeMem(Self.vHiResPixels);
  Self.vHiResPixels:=nil;
  Self.bHiResDXTn:=False;

  Self.iChannels:=0;
  Self.iPixelBits:=0;
  Self.iChannel0Bits:=0;
  Self.iChannel1Bits:=0;
  Self.iChannel2Bits:=0;
  Self.iChannel3Bits:=0;
  Self.iFaces:=0;

  Self.nLoResMegaSize:=0;
  Self.nLoResDataSize:=0;
  Self.bLoResCached:=False;
  if (Self.vLoResPixels <> nil) then FreeMem(Self.vLoResPixels);
  Self.vLoResPixels:=nil;
  Self.bLoResDXTn:=False;
  Self.bHiRes:=False;

  Self.nCRC:=0;
  Self.nULOD:=0;
  Self.nVLOD:=0;
  Self.EFLAGS:=0;
  Self.bCRC:=False;
  Self.bLOD:=False;
  Self.bTS0:=False;
  Self.bHiRes:=False;
  Self.bLoRes:=False;
  {$R+}
end;

procedure   CVTF.FreeHiResolutionCache();
begin
  {$R-}
  Self.bHiResCached:=False;
  if (Self.vHiResPixels <> nil) then FreeMem(Self.vHiResPixels);
  Self.vHiResPixels:=nil;
  if (Self.pHiResource <> nil) then Self.pHiResource.vData:=nil;
  {$R+}
end;

procedure   CVTF.FreeLoResolutionCache();
begin
  {$R-}
  Self.bLoResCached:=False;
  if (Self.vLoResPixels <> nil) then FreeMem(Self.vLoResPixels);
  Self.vLoResPixels:=nil;
  if (Self.pLoResource <> nil) then Self.pLoResource.vData:=nil;
  {$R+}
end;


function    CVTF.LoadFromFileVTF(const aFileName: String;
  const aLoadHiRes, aLoadLoRes: Boolean; const pFileSize: PInteger): Boolean;
var
  i, fsz, tmp, currFileOffset: Integer;
  FileVTF: File;
begin
  {$R-}
  Result:=False;
  //currFileOffset:=0;

  if (aFileName = '') then Exit;
  if (not FileExists(aFileName)) then Exit;

  Self.Clear();

  AssignFile(FileVTF, aFileName);
  Reset(FileVTF, 1);
  fsz:=FileSize(FileVTF);
  if (pFileSize <> nil) then pFileSize^:=fsz;

  // 63 is min VTF header size (ver. 7.0-7.1)
  if (fsz < 63) then
    begin
      if (fsz > 0) then BlockRead(FileVTF, Self.rVTFhdr, fsz);
      CloseFile(FileVTF);
      Exit;
    end;

  BlockRead(FileVTF, Self.rVTFhdr, 63);
  currFileOffset:=63;

  if (Self.rVTFhdr.cSignature <> VTF_SIGNATURE) or
     (Self.rVTFhdr.nVersionMajor < VTF_VERSION_MAJOR_MIN) or
     (Self.rVTFhdr.nVersionMajor > VTF_VERSION_MAJOR_MAX) or
     (Self.rVTFhdr.nVersionMinor > VTF_VERSION_MINOR_MAX) then
    begin
      CloseFile(FileVTF);
      Exit;
    end;

  if (Self.rVTFhdr.nMipmapCount = 0) or
     (Self.rVTFhdr.nFrames = 0) or
     (Self.rVTFhdr.nWidth = 0) or (Self.rVTFhdr.nHeight = 0) then
    begin
      CloseFile(FileVTF);
      Exit;
    end;

  if (Self.rVTFhdr.HiResImgFormat < MIN_IMAGE_FORMAT) or
     (Self.rVTFhdr.HiResImgFormat > MAX_IMAGE_FORMAT) or
     (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_P8) then
    begin
      CloseFile(FileVTF);
      Exit;
    end;

  if (Self.rVTFhdr.nVersionMinor >= VTF_VERSION_MINOR_DEPTH) then
    begin
      if ((fsz >= 65) and (Self.rVTFhdr.szHeader >= 65)) then
        begin
          BlockRead(FileVTF, Self.rVTFhdr.nDepth, 2);
          currFileOffset:=65;
          if (Self.rVTFhdr.nDepth = 0) then
            begin
              CloseFile(FileVTF);
              Exit;
            end;
        end
      else
        begin
          Self.rVTFhdr.nDepth:=0;
          if (fsz > 63) then BlockRead(FileVTF, Self.rVTFhdr.nDepth, 1);
          CloseFile(FileVTF);
          Exit;
        end;
    end
  else Self.rVTFhdr.nDepth:=1;

  if (Self.rVTFhdr.nVersionMinor >= VTF_VERSION_MINOR_RESOURCE) then
    begin
      if ((fsz >= 80) and (Self.rVTFhdr.szHeader >= 80)) then
        begin
          BlockRead(FileVTF, Self.rVTFhdr.PADDING2[0], 15);
          tmp:=(fsz - 80) div SizeOf(tVTFResourceHdr);
          if (DWORD(tmp) > Self.rVTFhdr.nResourceCount) then tmp:=Self.rVTFhdr.nResourceCount;
          if (tmp > 32) then tmp:=32;
          // now tmp equal count of resource headers, possible to read

          for i:=0 to tmp-1 do
            begin
              BlockRead(FileVTF, Self.vResources[i].rHdr, SizeOf(tVTFResourceHdr));
            end;

          // analise resource offsets for data-resource
          // if great or equal file size - exit
          for i:=0 to tmp-1 do
            begin
              if (Self.vResources[i].rHdr.FLAGS = VTF_RESOURCE_FLAG_NODATA) then Continue;
              if (Self.vResources[i].rHdr.nOffset >= DWORD(fsz)) then
                begin
                  CloseFile(FileVTF);
                  Exit;
                end;
            end;

          // Perform sorting resource headers by offsets,
          // and next - compute resource sizes
          Self.SortAndLinkResources(fsz, tmp);

          // if filesize less then need for resorce headers - exit
          if (DWORD(tmp) < Self.rVTFhdr.nResourceCount) then
            begin
              CloseFile(FileVTF);
              Exit;
            end;
          // if resource more then 32 - exit
          if (Self.rVTFhdr.nResourceCount > 32) then
            begin
              CloseFile(FileVTF);
              Exit;
            end;

          // at normal VTF file, tmp must equal Self.rVTFhdr.nResourceCount
          currFileOffset:=80 + tmp*SizeOf(tVTFResourceHdr);
        end
      else
        begin
          // no resources for 7.3+ -> no pixel data
          BlockRead(FileVTF, Self.rVTFhdr.PADDING2[0], fsz - currFileOffset);
          CloseFile(FileVTF);
          Exit;
        end;
    end
  else Self.rVTFhdr.nResourceCount:=0;
  // now all header data loaded (and resource headers (sorted))

  Self.nLoResMegaSize:=Self.rVTFhdr.nLoResWidth * Self.rVTFhdr.nLoResHeight;
  Self.nLoResDataSize:=EstimateDataSizeMipmaps(
    Self.rVTFhdr.nLoResWidth, Self.rVTFhdr.nLoResHeight, 1,
    1,
    Self.rVTFhdr.LoResImgFormat
  );
  Self.bLoResDXTn:=Boolean(VTF_BITDEPTH[Self.rVTFhdr.LoResImgFormat, VTF_BITDEPTH_DXT]);

  //  Channels, total bits per pixel, bits per channel, HiRes DXTn flag
  Self.iChannels:=    VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_CHANNELS];
  Self.iPixelBits:=   VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERPIXEL];
  Self.iChannel0Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL0];
  Self.iChannel1Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL1];
  Self.iChannel2Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL2];
  Self.iChannel3Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL3];
  Self.bHiResDXTn:=   Boolean(VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_DXT]);

  // Special fast flags
  Self.bHiResHDR:=(Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_RGBA16161616) or
    (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_RGBA16161616F);

  Self.nHiResMegaSize:=Self.rVTFhdr.nWidth*Self.rVTFhdr.nHeight;
  MipmapDivision(
    Self.rVTFhdr.nWidth, Self.rVTFhdr.nHeight, Self.rVTFhdr.nDepth,
    Self.rVTFhdr.nMipmapCount,
    @Self.vMipsWidth[0], @Self.vMipsHeight[0],
    @Self.vMipsWidthDXT[0], @Self.vMipsHeightDXT[0],
    @Self.vMipsDepth[0]
  );

  // now estimate data size w\o face count
  Self.nHiResDataSize:=EstimateDataSizeMipmaps(
    Self.rVTFhdr.nWidth, Self.rVTFhdr.nHeight, Self.rVTFhdr.nDepth,
    Self.rVTFhdr.nMipmapCount,
    Self.rVTFhdr.HiResImgFormat
  ) * Self.rVTFhdr.nFrames;

  // VTF support or animate or envmap. Both animate envmap unsupported
  Self.iFaces:=1;
  if ((TEXTUREFLAGS_ENVMAP AND Self.rVTFhdr.FLAGS32) <> 0) then
    begin
      Self.iFaces:=6;
      case (Self.rVTFhdr.nVersionMinor) of
        1, 2: Self.iFaces:=7; // non-resource
        3, 4: begin
            tmp:=Self.pHiResource.nSize div Self.nHiResDataSize;
            if (tmp > 6) then Self.iFaces:=7;
          end;
        // for 7.5 spheremap is redundant (7'th face id)
      end;
      Self.nHiResDataSize:=Self.nHiResDataSize * Self.iFaces;
    end;

  // now we can allocate memory, copy pixel data.
  if (Self.rVTFhdr.nVersionMinor < VTF_VERSION_MINOR_RESOURCE) then
    begin
      // 1. Read LoRes thumbnail
      // header always aligned to 16 byte -> align currFileOffset
      currFileOffset:=(currFileOffset + 15) and $FFFFFFF0;
      Seek(FileVTF, currFileOffset);
      tmp:=fsz - currFileOffset;
      if (tmp >= Self.nLoResDataSize) then
        begin
          if (Self.nLoResDataSize > 0) and (aLoadLoRes) then
            begin
              GetMem(Self.vLoResPixels, Self.nLoResDataSize);
              if (Self.vLoResPixels = nil) then
                begin
                  Self.Clear();
                  CloseFile(FileVTF);
                  raise Exception.Create('VTF ERROR: out of memory! (read LoRes-data)');
                  Exit;
                end;
              //FillChar(Self.vLoResPixels^, Self.nLoResDataSize, $00);
              BlockRead(FileVTF, Self.vLoResPixels^, Self.nLoResDataSize);
              Self.bLoResCached:=True;
            end
          else Seek(FileVTF, currFileOffset + Self.nLoResDataSize);
          currFileOffset:=currFileOffset + Self.nLoResDataSize;

          // 2. Read HiRes data
          tmp:=fsz - currFileOffset;
          if (Self.nHiResDataSize > 0) and (aLoadHiRes) and (tmp >= Self.nHiResDataSize) then
            begin
              GetMem(Self.vHiResPixels, Self.nHiResDataSize);
              if (Self.vHiResPixels = nil) then
                begin
                  Self.Clear();
                  CloseFile(FileVTF);
                  raise Exception.Create('VTF ERROR: out of memory! (read HiRes-data)');
                  Exit;
                end;
              //FillChar(Self.vHiResPixels^, Self.nHiResDataSize, $00);
              BlockRead(FileVTF, Self.vHiResPixels^, Self.nHiResDataSize);
              Self.bHiResCached:=True;
            end
        end;
    end
  else
    begin
      // For 7.3+ search for resources.
      // 1) read lo-res if exists
      if (Self.pLoResource <> nil) then
        begin
          tmp:=fsz - Integer(Self.pLoResource.rHdr.nOffset);
          Self.bLoRes:=Boolean((tmp >= Self.nLoResDataSize) and (Self.nLoResDataSize > 0));
          if (Self.bLoRes and aLoadLoRes) then
            begin
              GetMem(Self.vLoResPixels, Self.nLoResDataSize);
              if (Self.vLoResPixels = nil) then
                begin
                  CloseFile(FileVTF);
                  raise Exception.Create('VTF ERROR: out of memory! (read LoRes-data)');
                  Exit;
                end;
              Seek(FileVTF, Self.pLoResource.rHdr.nOffset);
              BlockRead(FileVTF, Self.vLoResPixels^, Self.nLoResDataSize);
              Self.bLoResCached:=True;
            end;
        end;
      // 2) read hi-res if exists
      if (Self.pHiResource <> nil) then
        begin
          tmp:=fsz - Integer(Self.pHiResource.rHdr.nOffset);
          Self.bHiRes:=Boolean((tmp >= Self.nHiResDataSize) and (Self.nHiResDataSize > 0));
          if (Self.bHiRes and aLoadHiRes) then
            begin
              GetMem(Self.vHiResPixels, Self.nHiResDataSize);
              if (Self.vHiResPixels = nil) then
                begin
                  CloseFile(FileVTF);
                  raise Exception.Create('VTF ERROR: out of memory! (read HiRes-data)');
                  Exit;
                end;
              Seek(FileVTF, Self.pHiResource.rHdr.nOffset);
              BlockRead(FileVTF, Self.vHiResPixels^, Self.nHiResDataSize);
              Self.bHiResCached:=True;
            end;
        end;

      for i:=0 to Self.rVTFhdr.nResourceCount-1 do
        begin
          // CRC
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_CRC) then
            begin
              Self.nCRC:=Self.vResources[i].rHdr.nOffset;
              Self.bCRC:=True;
              Continue;
            end;

          // UV LOD
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_LOD) then
            begin
              Self.nULOD:=AUInt8(@Self.vResources[i].rHdr.nOffset)[0];
              Self.nVLOD:=AUInt8(@Self.vResources[i].rHdr.nOffset)[1];
              Self.bLOD:=True;
              Continue;
            end;

          // Extend FLAGS
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_TS0) then
            begin
              Self.EFLAGS:=Self.vResources[i].rHdr.nOffset;
              Self.bTS0:=True;
              Continue;
            end;

          // other resource
          if (Self.vResources[i].nSize > 0) then
            begin
              GetMem(Self.vResources[i].vData, Self.vResources[i].nSize);
              if (Self.vResources[i].vData = nil) then
                begin
                  CloseFile(FileVTF);
                  raise Exception.Create('VTF ERROR: out of memory! (read other resource)');
                  Exit;
                end;

              Seek(FileVTF, Self.vResources[i].rHdr.nOffset);
              BlockRead(FileVTF, Self.vResources[i].vData^, Self.vResources[i].nSize);
            end;
        end;
    end;

  CloseFile(FileVTF);
  Self.bBadVTF:=False;
  Result:=True;
  {$R+}
end;

function    CVTF.LoadFromBufferVTF(const pSrcBuf: PByte; const aBufSize: Integer;
  const aLoadHiRes, aLoadLoRes: Boolean): Boolean;
var
  i, tmp, currBufOffset: Integer;
  SeekedPtr: PByte;
begin
  {$R-}
  Result:=False;
  if (pSrcBuf = nil) or (aBufSize <= 0) then Exit;

  //currBufOffset:=0;
  SeekedPtr:=pSrcBuf;

  Self.Clear();

  // 63 is min VTF header size (ver. 7.0-7.1)
  if (aBufSize < 63) then
    begin
      CopyBytes(SeekedPtr, @Self.rVTFhdr, aBufSize);
      Exit;
    end;

  CopyBytes(SeekedPtr, @Self.rVTFhdr, 63); Inc(SeekedPtr, 63);
  currBufOffset:=63;  

  if (Self.rVTFhdr.cSignature <> VTF_SIGNATURE) or
     (Self.rVTFhdr.nVersionMajor < VTF_VERSION_MAJOR_MIN) or
     (Self.rVTFhdr.nVersionMajor > VTF_VERSION_MAJOR_MAX) or
     (Self.rVTFhdr.nVersionMinor > VTF_VERSION_MINOR_MAX) then Exit;

  if (Self.rVTFhdr.nMipmapCount = 0) or
     (Self.rVTFhdr.nFrames = 0) or
     (Self.rVTFhdr.nWidth = 0) or (Self.rVTFhdr.nHeight = 0) then Exit;

  if (Self.rVTFhdr.HiResImgFormat < MIN_IMAGE_FORMAT) or
     (Self.rVTFhdr.HiResImgFormat > MAX_IMAGE_FORMAT) or
     (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_P8) then Exit;

  if (Self.rVTFhdr.nVersionMinor >= VTF_VERSION_MINOR_DEPTH) then
    begin
      if ((aBufSize >= 65) and (Self.rVTFhdr.szHeader >= 65)) then
        begin
          CopyBytes(SeekedPtr, @Self.rVTFhdr.nDepth, 2); Inc(SeekedPtr, 2);
          currBufOffset:=65;
          if (Self.rVTFhdr.nDepth = 0) then Exit;
        end
      else
        begin
          Self.rVTFhdr.nDepth:=0;
          if (aBufSize > 63) then CopyBytes(SeekedPtr, @Self.rVTFhdr.nDepth, 1);
          Exit;
        end;
    end
  else Self.rVTFhdr.nDepth:=1;

  if (Self.rVTFhdr.nVersionMinor >= VTF_VERSION_MINOR_RESOURCE) then
    begin
      if ((aBufSize >= 80) and (Self.rVTFhdr.szHeader >= 80)) then
        begin
          CopyBytes(SeekedPtr, @Self.rVTFhdr.PADDING2[0], 15); Inc(SeekedPtr, 15);
          tmp:=(aBufSize - 80) div SizeOf(tVTFResourceHdr);
          if (DWORD(tmp) > Self.rVTFhdr.nResourceCount) then tmp:=Self.rVTFhdr.nResourceCount;
          if (tmp > 32) then tmp:=32;
          // now tmp equal count of resource headers, possible to read

          for i:=0 to tmp-1 do
            begin
              CopyBytes(SeekedPtr, @Self.vResources[i].rHdr, SizeOf(tVTFResourceHdr));
              Inc(SeekedPtr, SizeOf(tVTFResourceHdr));
            end;

          // analise resource offsets for data-resource
          // if great or equal file size - exit
          for i:=0 to tmp-1 do
            begin
              if (Self.vResources[i].rHdr.FLAGS = VTF_RESOURCE_FLAG_NODATA) then Continue;
              if (Self.vResources[i].rHdr.nOffset >= DWORD(aBufSize)) then Exit;
            end;

          // Perform sorting resource headers by offsets,
          // and next - compute resource sizes
          Self.SortAndLinkResources(aBufSize, tmp);

          // if filesize less then need for resorce headers - exit
          if (DWORD(tmp) < Self.rVTFhdr.nResourceCount) then Exit;
          // if resource more then 32 - exit
          if (Self.rVTFhdr.nResourceCount > 32) then Exit;

          // at normal VTF file, tmp must equal Self.rVTFhdr.nResourceCount
          currBufOffset:=80 + tmp*SizeOf(tVTFResourceHdr);
        end
      else
        begin
          // no resources for 7.3+ -> no pixel data
          CopyBytes(SeekedPtr, @Self.rVTFhdr.PADDING2[0], aBufSize - currBufOffset);
          Exit;
        end;
    end
  else Self.rVTFhdr.nResourceCount:=0;
  // now all header data loaded (and resource headers (sorted))

  Self.nLoResMegaSize:=Self.rVTFhdr.nLoResWidth * Self.rVTFhdr.nLoResHeight;
  Self.nLoResDataSize:=EstimateDataSizeMipmaps(
    Self.rVTFhdr.nLoResWidth, Self.rVTFhdr.nLoResHeight, 1,
    1,
    Self.rVTFhdr.LoResImgFormat
  );
  Self.bLoResDXTn:=Boolean(VTF_BITDEPTH[Self.rVTFhdr.LoResImgFormat, VTF_BITDEPTH_DXT]);

  //  Channels, total bits per pixel, bits per channel, HiRes DXTn flag
  Self.iChannels:=    VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_CHANNELS];
  Self.iPixelBits:=   VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERPIXEL];
  Self.iChannel0Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL0];
  Self.iChannel1Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL1];
  Self.iChannel2Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL2];
  Self.iChannel3Bits:=VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_PERCHANNEL3];
  Self.bHiResDXTn:=   Boolean(VTF_BITDEPTH[Self.rVTFhdr.HiResImgFormat, VTF_BITDEPTH_DXT]);

  // Special fast flags
  Self.bHiResHDR:=(Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_RGBA16161616) or
    (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_RGBA16161616F);

  Self.nHiResMegaSize:=Self.rVTFhdr.nWidth*Self.rVTFhdr.nHeight;
  MipmapDivision(
    Self.rVTFhdr.nWidth, Self.rVTFhdr.nHeight, Self.rVTFhdr.nDepth,
    Self.rVTFhdr.nMipmapCount,
    @Self.vMipsWidth[0], @Self.vMipsHeight[0],
    @Self.vMipsWidthDXT[0], @Self.vMipsHeightDXT[0],
    @Self.vMipsDepth[0]
  );

  // now estimate data size w\o face count
  Self.nHiResDataSize:=EstimateDataSizeMipmaps(
    Self.rVTFhdr.nWidth, Self.rVTFhdr.nHeight, Self.rVTFhdr.nDepth,
    Self.rVTFhdr.nMipmapCount,
    Self.rVTFhdr.HiResImgFormat
  ) * Self.rVTFhdr.nFrames;

  // VTF support or animate or envmap. Both animate envmap unsupported
  Self.iFaces:=1;
  if ((TEXTUREFLAGS_ENVMAP AND Self.rVTFhdr.FLAGS32) <> 0) then
    begin
      Self.iFaces:=6;
      case (Self.rVTFhdr.nVersionMinor) of
        1, 2: Self.iFaces:=7; // non-resource
        3, 4: begin
            tmp:=Self.pHiResource.nSize div Self.nHiResDataSize;
            if (tmp > 6) then Self.iFaces:=7;
          end;
        // for 7.5 spheremap is redundant (7'th face id)
      end;
      Self.nHiResDataSize:=Self.nHiResDataSize * Self.iFaces;
    end;

  // now we can allocate memory, copy pixel data.
  if (Self.rVTFhdr.nVersionMinor < VTF_VERSION_MINOR_RESOURCE) then
    begin
      // 1. Read LoRes thumbnail
      // header always aligned to 16 byte -> align currFileOffset
      currBufOffset:=(currBufOffset + 15) and $FFFFFFF0;
      SeekedPtr:=pSrcBuf; Inc(SeekedPtr, currBufOffset);
      tmp:=aBufSize - currBufOffset;
      if (tmp >= Self.nLoResDataSize) then
        begin
          if (Self.nLoResDataSize > 0) and (aLoadLoRes) then
            begin
              GetMem(Self.vLoResPixels, Self.nLoResDataSize);
              if (Self.vLoResPixels = nil) then
                begin
                  Self.Clear();
                  raise Exception.Create('VTF ERROR: out of memory! (read LoRes-data)');
                  Exit;
                end;
              //FillChar(Self.vLoResPixels^, Self.nLoResDataSize, $00);
              CopyBytes(SeekedPtr, Self.vLoResPixels, Self.nLoResDataSize);
              Inc(SeekedPtr, Self.nLoResDataSize);
              Self.bLoResCached:=True;
            end
          else
            begin
              SeekedPtr:=pSrcBuf; Inc(SeekedPtr, currBufOffset + Self.nLoResDataSize);
            end;
          currBufOffset:=currBufOffset + Self.nLoResDataSize;

          // 2. Read HiRes data
          tmp:=aBufSize - currBufOffset;
          if (Self.nHiResDataSize > 0) and (aLoadHiRes) and (tmp >= Self.nHiResDataSize) then
            begin
              GetMem(Self.vHiResPixels, Self.nHiResDataSize);
              if (Self.vHiResPixels = nil) then
                begin
                  Self.Clear();
                  raise Exception.Create('VTF ERROR: out of memory! (read HiRes-data)');
                  Exit;
                end;
              //FillChar(Self.vHiResPixels^, Self.nHiResDataSize, $00);
              CopyBytes(SeekedPtr, Self.vHiResPixels, Self.nHiResDataSize);
              //Inc(SeekedPtr, Self.nHiResDataSize);
              Self.bHiResCached:=True;
            end
        end;
    end
  else
    begin
      // For 7.3+ search for resources.
      // 1) read lo-res if exists
      if (Self.pLoResource <> nil) then
        begin
          tmp:=aBufSize - Integer(Self.pLoResource.rHdr.nOffset);
          Self.bLoRes:=Boolean((tmp >= Self.nLoResDataSize) and (Self.nLoResDataSize > 0));
          if (Self.bLoRes and aLoadLoRes) then
            begin
              GetMem(Self.vLoResPixels, Self.nLoResDataSize);
              if (Self.vLoResPixels = nil) then
                begin
                  raise Exception.Create('VTF ERROR: out of memory! (read LoRes-data)');
                  Exit;
                end;
              SeekedPtr:=pSrcBuf; Inc(SeekedPtr, Self.pLoResource.rHdr.nOffset);
              CopyBytes(SeekedPtr, Self.vLoResPixels, Self.nLoResDataSize);
              Self.bLoResCached:=True;
            end;
        end;
      // 2) read hi-res if exists
      if (Self.pHiResource <> nil) then
        begin
          tmp:=aBufSize - Integer(Self.pHiResource.rHdr.nOffset);
          Self.bHiRes:=Boolean((tmp >= Self.nHiResDataSize) and (Self.nHiResDataSize > 0));
          if (Self.bHiRes and aLoadHiRes) then
            begin
              GetMem(Self.vHiResPixels, Self.nHiResDataSize);
              if (Self.vHiResPixels = nil) then
                begin
                  raise Exception.Create('VTF ERROR: out of memory! (read HiRes-data)');
                  Exit;
                end;
              SeekedPtr:=pSrcBuf; Inc(SeekedPtr, Self.pHiResource.rHdr.nOffset);
              CopyBytes(SeekedPtr, Self.vHiResPixels, Self.nHiResDataSize);
              Self.bHiResCached:=True;
            end;
        end;

      for i:=0 to Self.rVTFhdr.nResourceCount-1 do
        begin
          // CRC
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_CRC) then
            begin
              Self.nCRC:=Self.vResources[i].rHdr.nOffset;
              Self.bCRC:=True;
              Continue;
            end;

          // UV LOD
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_LOD) then
            begin
              Self.nULOD:=AUInt8(@Self.vResources[i].rHdr.nOffset)[0];
              Self.nVLOD:=AUInt8(@Self.vResources[i].rHdr.nOffset)[1];
              Self.bLOD:=True;
              Continue;
            end;

          // Extend FLAGS
          if (Self.vResources[i].rHdr.cTag = VTF_TAG_TS0) then
            begin
              Self.EFLAGS:=Self.vResources[i].rHdr.nOffset;
              Self.bTS0:=True;
              Continue;
            end;

          // other resource
          if (Self.vResources[i].nSize > 0) then
            begin
              GetMem(Self.vResources[i].vData, Self.vResources[i].nSize);
              if (Self.vResources[i].vData = nil) then
                begin
                  raise Exception.Create('VTF ERROR: out of memory! (read other resource)');
                  Exit;
                end;

              SeekedPtr:=pSrcBuf; Inc(SeekedPtr, Self.vResources[i].rHdr.nOffset);
              CopyBytes(SeekedPtr, Self.vResources[i].vData, Self.vResources[i].nSize);
              //Inc(SeekedPtr, Self.vResources[i].nSize);
            end;
        end;
    end;

  Self.bBadVTF:=False;
  Result:=True;
  {$R+}
end;

function    CVTF.UnpackHiResToRGBA8888(const aMip, aFrame, aFace, aDepth: Word;
  const pDstBuf: PByte): Integer;
var
  i, j, w, h, x, y, k: Integer;
  dataOffset, pixels: Integer;
  // dataSize: Integer;
  ptrSrc: PByte;
  s: Word;
  //
  nBlockX, nBlockY, dstOffset: Integer;
  ptrBlock: PByte;
  cid, bitmask, alphaRow, alphamask: DWORD;
  cLUT: array[0..3] of tVec4ub;
  aLUT: array[0..7] of Byte;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;

  if (Self.bHiResCached = False) or
     (aMip >= Self.rVTFhdr.nMipmapCount) or
     (aFrame >= Self.rVTFhdr.nFrames) or
     (aFace >= Self.iFaces) or
     (aDepth >= Self.vMipsDepth[aMip]) then Exit;

  w:=Self.vMipsWidth[aMip];
  h:=Self.vMipsHeight[aMip];

  pixels:=w*h;
  //dataSize:=(pixels * Self.iPixelBits) div 8;
  Result:=pixels*4; // x4 for RGBA8888

  if (pDstBuf = nil) then Exit; // only compute memory size required for pDstBuf

  dataOffset:=Self.ComputeHiResDataOffset(aMip, aFrame, aFace, aDepth);
  ptrSrc:=@AUInt8(Self.vHiResPixels)[dataOffset];

  if (Self.bHiResDXTn = False) then
    begin
      // non-DXTn data

      case (Self.rVTFhdr.HiResImgFormat) of
        IMAGE_FORMAT_RGBA8888,
        IMAGE_FORMAT_UVLX8888,
        IMAGE_FORMAT_UVWQ8888           : begin
            // just copy as is (as 4-bytes)
            for i:=0 to pixels-1 do AVec4ub(pDstBuf)[i]:=AVec4ub(ptrSrc)[i];
          end;
        IMAGE_FORMAT_ABGR8888           : begin 
            // copy with swap
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][3]:=AVec4ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][2]:=AVec4ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][1]:=AVec4ub(ptrSrc)[i][2];
                AVec4ub(pDstBuf)[i][0]:=AVec4ub(ptrSrc)[i][3];
              end;
          end;
        IMAGE_FORMAT_RGB888             : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AVec3ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec3ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][2]:=AVec3ub(ptrSrc)[i][2];
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_BGR888             : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][2]:=AVec3ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec3ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][0]:=AVec3ub(ptrSrc)[i][2];
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_I8                 : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AUInt8(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][1]:=AUInt8(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][2]:=AUInt8(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_IA88               : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AVec2ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec2ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][2]:=AVec2ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][3]:=AVec2ub(ptrSrc)[i][1];
              end;
          end;
        IMAGE_FORMAT_A8                 : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=0;
                AVec4ub(pDstBuf)[i][1]:=0;
                AVec4ub(pDstBuf)[i][2]:=0;
                AVec4ub(pDstBuf)[i][3]:=AUInt8(ptrSrc)[i];
              end;
          end;
        IMAGE_FORMAT_RGB888_BLUESCREEN  : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AVec3ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec3ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][2]:=AVec3ub(ptrSrc)[i][2];
                if (AVec4ub(pDstBuf)[i][0] = 0) and
                   (AVec4ub(pDstBuf)[i][1] = 0) and
                   (AVec4ub(pDstBuf)[i][2] = $FF)
                then AVec4ub(pDstBuf)[i][3]:=0
                else AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_BGR888_BLUESCREEN  : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][2]:=AVec3ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec3ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][0]:=AVec3ub(ptrSrc)[i][2];
                if (AVec4ub(pDstBuf)[i][0] = 0) and
                   (AVec4ub(pDstBuf)[i][1] = 0) and
                   (AVec4ub(pDstBuf)[i][2] = $FF)
                then AVec4ub(pDstBuf)[i][3]:=0
                else AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_ARGB8888           : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AVec4ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][1]:=AVec4ub(ptrSrc)[i][2];
                AVec4ub(pDstBuf)[i][2]:=AVec4ub(ptrSrc)[i][3];
                AVec4ub(pDstBuf)[i][3]:=AVec4ub(ptrSrc)[i][0];
              end;
          end;
        IMAGE_FORMAT_BGRA8888,
        IMAGE_FORMAT_BGRX8888           : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][2]:=AVec4ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec4ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][0]:=AVec4ub(ptrSrc)[i][2];
                AVec4ub(pDstBuf)[i][3]:=AVec4ub(ptrSrc)[i][3];
              end; //}
          end;
        IMAGE_FORMAT_UV88               : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=AVec2ub(ptrSrc)[i][0];
                AVec4ub(pDstBuf)[i][1]:=AVec2ub(ptrSrc)[i][1];
                AVec4ub(pDstBuf)[i][2]:=0;
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        // next: Packed formats
        IMAGE_FORMAT_RGB565             : begin 
            for i:=0 to pixels-1 do
              begin
                s:=AUInt16(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][0]:=Byte((s AND $001F) shl 3);
                AVec4ub(pDstBuf)[i][1]:=Byte((s AND $07E0) shr 3);
                AVec4ub(pDstBuf)[i][2]:=Byte((s AND $F800) shr 8);
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_BGR565             : begin 
            for i:=0 to pixels-1 do
              begin
                s:=AUInt16(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][2]:=Byte((s AND $001F) shl 3);
                AVec4ub(pDstBuf)[i][1]:=Byte((s AND $07E0) shr 3);
                AVec4ub(pDstBuf)[i][0]:=Byte((s AND $F800) shr 8);
                AVec4ub(pDstBuf)[i][3]:=$FF;
              end;
          end;
        IMAGE_FORMAT_BGRX5551,
        IMAGE_FORMAT_BGRA5551           : begin
            for i:=0 to pixels-1 do
              begin
                s:=AUInt16(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][2]:=Byte((s AND $001F) shl 3);
                AVec4ub(pDstBuf)[i][1]:=Byte((s AND $03E0) shr 2);
                AVec4ub(pDstBuf)[i][0]:=Byte((s AND $7C00) shr 7);
                AVec4ub(pDstBuf)[i][3]:=Byte((s AND $1000) shr 15);
              end;
          end;
        IMAGE_FORMAT_BGRA4444           : begin 
            for i:=0 to pixels-1 do
              begin
                s:=AUInt16(ptrSrc)[i];
                AVec4ub(pDstBuf)[i][0]:=Byte((s AND $000F) shl 4);
                AVec4ub(pDstBuf)[i][1]:=Byte((s AND $00F0)      );
                AVec4ub(pDstBuf)[i][2]:=Byte((s AND $0F00) shr 4);
                AVec4ub(pDstBuf)[i][3]:=Byte((s AND $F000) shr 8);
              end;
          end;

        // For HDR recommended use HDR version of function
        IMAGE_FORMAT_RGBA16161616F      : begin
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=Byte(AVec4sw(ptrSrc)[i][0] shr 8);
                AVec4ub(pDstBuf)[i][1]:=Byte(AVec4sw(ptrSrc)[i][1] shr 8);
                AVec4ub(pDstBuf)[i][2]:=Byte(AVec4sw(ptrSrc)[i][2] shr 8);
                AVec4ub(pDstBuf)[i][3]:=Byte(AVec4sw(ptrSrc)[i][3] shr 8);
              end;
          end; 
        IMAGE_FORMAT_RGBA16161616       : begin 
            for i:=0 to pixels-1 do
              begin
                AVec4ub(pDstBuf)[i][0]:=Byte(AVec4sw(ptrSrc)[i][0] shr 8);
                AVec4ub(pDstBuf)[i][1]:=Byte(AVec4sw(ptrSrc)[i][1] shr 8);
                AVec4ub(pDstBuf)[i][2]:=Byte(AVec4sw(ptrSrc)[i][2] shr 8);
                AVec4ub(pDstBuf)[i][3]:=Byte(AVec4sw(ptrSrc)[i][3] shr 8);
              end;
          end; 
      end; // End of case
    end
  else
    begin
      // for DXTn data
      nBlockX:=w div 4;
      nBlockY:=h div 4;
      cLUT[0][3]:=$FF;
      cLUT[1][3]:=$FF;
      cLUT[2][3]:=$FF;
      cLUT[3][3]:=$FF;
      ptrBlock:=ptrSrc;

      case (Self.rVTFhdr.HiResImgFormat) of
        IMAGE_FORMAT_DXT1,
        IMAGE_FORMAT_DXT1_ONEBITALPHA               : begin
            for y:=0 to nBlockY-1 do for x:=0 to nBlockX-1 do
              begin
                BGR565toRGBA8888(@PDXTColorBlock(ptrBlock).c0, @cLUT[0]);
                BGR565toRGBA8888(@PDXTColorBlock(ptrBlock).c1, @cLUT[1]);
                bitmask:=PDXTColorBlock(ptrBlock).vIndex;

                if (PDXTColorBlock(ptrBlock).c0 > PDXTColorBlock(ptrBlock).c1) then
                  begin
                    // 4-color index map. No alpha
                    cLUT[2][0]:=(2*cLUT[0][0] + 1*cLUT[1][0] + 1) div 3;
                    cLUT[2][1]:=(2*cLUT[0][1] + 1*cLUT[1][1] + 1) div 3;
                    cLUT[2][2]:=(2*cLUT[0][2] + 1*cLUT[1][2] + 1) div 3;

                    cLUT[3][0]:=(1*cLUT[0][0] + 2*cLUT[1][0] + 1) div 3;
                    cLUT[3][1]:=(1*cLUT[0][1] + 2*cLUT[1][1] + 1) div 3;
                    cLUT[3][2]:=(1*cLUT[0][2] + 2*cLUT[1][2] + 1) div 3;
                    cLUT[3][3]:=$FF;
                  end
                else
                  begin
                    // 3-color index map + alpha
                    cLUT[2][0]:=(cLUT[0][0] + cLUT[1][0]) div 2;
                    cLUT[2][1]:=(cLUT[0][1] + cLUT[1][1]) div 2;
                    cLUT[2][2]:=(cLUT[0][2] + cLUT[1][2]) div 2;

                    cLUT[3][0]:=0;
                    cLUT[3][1]:=0;
                    cLUT[3][2]:=0;
                    cLUT[3][3]:=0;
                  end;

                k:=0;
                for j:=0 to 3 do for i:=0 to 3 do
                  begin
                    if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                      begin
                        cid:=(bitmask AND (3 shl k)) shr k;
                        dstOffset:=(y*4 + j)*w + (x*4 + i);
                        AVec4ub(pDstBuf)[dstOffset]:=cLUT[cid];
                      end;
                    Inc(k, 2);
                  end;
                           
                Inc(ptrBlock, SizeOf(tDXTColorBlock));
              end;
          end;
        IMAGE_FORMAT_DXT3               : begin
            for y:=0 to nBlockY-1 do for x:=0 to nBlockX-1 do
              begin
                BGR565toRGBA8888(@PDXT3Block(ptrBlock).rColorBlock.c0, @cLUT[0]);
                BGR565toRGBA8888(@PDXT3Block(ptrBlock).rColorBlock.c1, @cLUT[1]);
                bitmask:=PDXT3Block(ptrBlock).rColorBlock.vIndex;

                // 4-color index map
                cLUT[2][0]:=(2*cLUT[0][0] + 1*cLUT[1][0] + 1) div 3;
                cLUT[2][1]:=(2*cLUT[0][1] + 1*cLUT[1][1] + 1) div 3;
                cLUT[2][2]:=(2*cLUT[0][2] + 1*cLUT[1][2] + 1) div 3;

                cLUT[3][0]:=(1*cLUT[0][0] + 2*cLUT[1][0] + 1) div 3;
                cLUT[3][1]:=(1*cLUT[0][1] + 2*cLUT[1][1] + 1) div 3;
                cLUT[3][2]:=(1*cLUT[0][2] + 2*cLUT[1][2] + 1) div 3;

                // Color part
                k:=0;
                for j:=0 to 3 do for i:=0 to 3 do
                  begin
                    if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                      begin
                        cid:=(bitmask AND (3 shl k)) shr k;
                        dstOffset:=(y*4 + j)*w + (x*4 + i);
                        AVec4ub(pDstBuf)[dstOffset]:=cLUT[cid];
                      end;
                    Inc(k, 2);
                  end;

                // Alpha part
                for j:=0 to 3 do
                  begin
                    alphaRow:=PDXT3Block(ptrBlock).vAlphaRow4bit[j];
                    for i:=0 to 3 do
                      begin
                        if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                          begin
                            dstOffset:=(y*4 + j)*w + (x*4 + i);
                            
                            AVec4ub(pDstBuf)[dstOffset][3]:=alphaRow and $0F;
                            AVec4ub(pDstBuf)[dstOffset][3]:=
                              AVec4ub(pDstBuf)[dstOffset][3] OR
                              (AVec4ub(pDstBuf)[dstOffset][3] shl 4);
                          end;

                        alphaRow:=alphaRow shr 4;
                      end;
                  end;
                           
                Inc(ptrBlock, SizeOf(tDXT3Block));
              end;
          end;
        IMAGE_FORMAT_DXT5               : begin
            for y:=0 to nBlockY-1 do for x:=0 to nBlockX-1 do
              begin
                BGR565toRGBA8888(@PDXT5Block(ptrBlock).rColorBlock.c0, @cLUT[0]);
                BGR565toRGBA8888(@PDXT5Block(ptrBlock).rColorBlock.c1, @cLUT[1]);
                bitmask:=PDXT5Block(ptrBlock).rColorBlock.vIndex;

                // 4-color index map
                cLUT[2][0]:=(2*cLUT[0][0] + 1*cLUT[1][0] + 1) div 3;
                cLUT[2][1]:=(2*cLUT[0][1] + 1*cLUT[1][1] + 1) div 3;
                cLUT[2][2]:=(2*cLUT[0][2] + 1*cLUT[1][2] + 1) div 3;

                cLUT[3][0]:=(1*cLUT[0][0] + 2*cLUT[1][0] + 1) div 3;
                cLUT[3][1]:=(1*cLUT[0][1] + 2*cLUT[1][1] + 1) div 3;
                cLUT[3][2]:=(1*cLUT[0][2] + 2*cLUT[1][2] + 1) div 3;

                // Color part
                k:=0;
                for j:=0 to 3 do for i:=0 to 3 do
                  begin
                    if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                      begin
                        cid:=(bitmask AND (3 shl k)) shr k;
                        dstOffset:=(y*4 + j)*w + (x*4 + i);
                        AVec4ub(pDstBuf)[dstOffset]:=cLUT[cid];
                      end;
                    Inc(k, 2);
                  end;

                // alpha color map
                aLUT[0]:=PDXT5Block(ptrBlock).vAlphaHeader[0];
                aLUT[1]:=PDXT5Block(ptrBlock).vAlphaHeader[1];
                if (aLUT[0] > aLUT[1]) then
                  begin
                    // 8 alpha
                    for i:=1 to 6 do
                      begin
                        j:=( (7-i)*aLUT[0] + i*aLUT[1] + 3) div 7;
                        if (j > 255) then j:=255;
                        aLUT[i+1]:=j;
                      end;
                  end
                else
                  begin
                    // 6+2 alpha
                    for i:=1 to 4 do
                      begin
                        j:=( (5-i)*aLUT[0] + i*aLUT[1] + 2) div 5;
                        if (j > 255) then j:=255;
                        aLUT[i+1]:=j;
                      end;
                    aLUT[6]:=0;
                    aLUT[7]:=$FF;
                  end;

                // Alpha part, first 3 bytes
                alphamask:=PDWORD(@PDXT5Block(ptrBlock).vAlphaIndex[0])^;
                for j:=0 to 1 do for i:=0 to 3 do
                  begin
                    if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                      begin
                        dstOffset:=(y*4 + j)*w + (x*4 + i);
                        AVec4ub(pDstBuf)[dstOffset][3]:=aLUT[alphamask and $07];
                      end;
                    alphamask:=alphamask shr 3;
                  end;
                // last 3 bytes
                alphamask:=PDWORD(@PDXT5Block(ptrBlock).vAlphaIndex[3])^;
                for j:=2 to 3 do for i:=0 to 3 do
                  begin
                    if (((x*4 + i) < w) AND ((y*4 + j) < h)) then
                      begin
                        dstOffset:=(y*4 + j)*w + (x*4 + i);
                        AVec4ub(pDstBuf)[dstOffset][3]:=aLUT[alphamask and $07];
                      end;
                    alphamask:=alphamask shr 3;
                  end;
                           
                Inc(ptrBlock, SizeOf(tDXT3Block));
              end;
          end;
      end;
    end;
  {$R+}
end;

function    CVTF.UnpackHiResHDRToRGB323232F(const aMip, aFrame, aFace, aDepth: Word;
  const pDstBuf: PByte): Integer;
var
  i: Integer;
  dataOffset, pixels: Integer;
  ptrSrc: PByte;
  sc: Single;
begin
  {$R-}
  Result:=0;
  if (Self.bBadVTF) then Exit;

  if (Self.bHiResCached = False) or
     (aMip >= Self.rVTFhdr.nMipmapCount) or
     (aFrame >= Self.rVTFhdr.nFrames) or
     (aFace >= Self.iFaces) or
     (aDepth >= Self.vMipsDepth[aMip]) then Exit;

  if (Self.rVTFhdr.HiResImgFormat <> IMAGE_FORMAT_RGBA16161616) and
     (Self.rVTFhdr.HiResImgFormat <> IMAGE_FORMAT_RGBA16161616F) then Exit;

  pixels:=Self.vMipsWidth[aMip]*Self.vMipsHeight[aMip];
  Result:=pixels*16; // x16 for RGBA32323232F

  if (pDstBuf = nil) then Exit; // only compute memory size required for pDstBuf

  dataOffset:=Self.ComputeHiResDataOffset(aMip, aFrame, aFace, aDepth);
  ptrSrc:=@AUInt8(Self.vHiResPixels)[dataOffset];

  if (Self.rVTFhdr.HiResImgFormat = IMAGE_FORMAT_RGBA16161616) then
    begin
      for i:=0 to pixels-1 do
        begin
          sc:=AVec4sw(ptrSrc)[i][3] / 4194304;
          AVec4fp(pDstBuf)[i][0]:=AVec4sw(ptrSrc)[i][0] * sc;
          AVec4fp(pDstBuf)[i][1]:=AVec4sw(ptrSrc)[i][1] * sc;
          AVec4fp(pDstBuf)[i][2]:=AVec4sw(ptrSrc)[i][2] * sc;
          AVec4fp(pDstBuf)[i][3]:=1.0;
        end;
    end
  else
    begin
      for i:=0 to pixels-1 do
        begin
          FP16toFP32(@AVec4sw(ptrSrc)[i][0], @AVec4fp(pDstBuf)[i][0]);
          FP16toFP32(@AVec4sw(ptrSrc)[i][1], @AVec4fp(pDstBuf)[i][1]);
          FP16toFP32(@AVec4sw(ptrSrc)[i][2], @AVec4fp(pDstBuf)[i][2]);
          FP16toFP32(@AVec4sw(ptrSrc)[i][3], @AVec4fp(pDstBuf)[i][3]);
        end;
    end;

  {$R+}
end;

function    CVTF.FindNearestLowMipWidth(const aWidth: Word; const pW, pH, pD: PWord): Integer;
var
  i: Integer;
begin
  {$R-}
  Result:=-1;
  if (Self.bBadVTF) then Exit;

  Result:=Self.rVTFhdr.nMipmapCount-1;
  for i:=0 to Self.rVTFhdr.nMipmapCount-1 do
    begin
      if (Self.vMipsWidth[i] <= aWidth) then
        begin
          Result:=i;
          Break;
        end;
    end;

  if (pW <> nil) then pW^:=Self.vMipsWidth[Result];
  if (pH <> nil) then pH^:=Self.vMipsHeight[Result];
  if (pD <> nil) then pD^:=Self.vMipsDepth[Result];
  {$R+}
end;

function    CVTF.FindNearestLowMipHeight(const aHeight: Word; const pW, pH, pD: PWord): Integer;
var
  i: Integer;
begin
  {$R-}
  Result:=-1;
  if (Self.bBadVTF) then Exit;

  Result:=Self.rVTFhdr.nMipmapCount-1;
  for i:=0 to Self.rVTFhdr.nMipmapCount-1 do
    begin
      if (Self.vMipsHeight[i] <= aHeight) then
        begin
          Result:=i;
          Break;
        end;
    end;

  if (pW <> nil) then pW^:=Self.vMipsWidth[Result];
  if (pH <> nil) then pH^:=Self.vMipsHeight[Result];
  if (pD <> nil) then pD^:=Self.vMipsDepth[Result];
  {$R+}
end;

//##############################################################################
//##############################################################################
//                       END CVTF Implementation
//##############################################################################
//##############################################################################

end.
