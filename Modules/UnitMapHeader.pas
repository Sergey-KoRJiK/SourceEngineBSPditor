unit UnitMapHeader;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec;

const
  MapSignature: Integer = $50534256;
  // support only 2013 BSP 
  MapVersionMin: Integer = 20;
  MapVersionMax: Integer = 21;

const HEADER_LUMPS =      64; 

const LUMP_ENTITIES	= 	  0;
const LUMP_PLANES	= 		  1;
const LUMP_TEXTURES =		  2;
const LUMP_VERTICES	= 	  3;
const LUMP_VISIBILITY	=	  4;
const LUMP_NODES =  			5;
const LUMP_TEXINFO =  		6;
const LUMP_FACES =  			7;
const LUMP_LEAVES	=   		10;
const LUMP_MARKSURFACES	= 16;
const LUMP_EDGES =  			12;
const LUMP_SURFEDGES =  	13;
const LUMP_BRUSHES	=   	14;

// disp lumps
const LUMP_DISPINFO  = 26;
const LUMP_DISP_VERTS = 33;
const LUMP_DISP_LIGHTMAPS = 34;

// light lump
const LUMP_LIGHTING	=                   8;
const LUMP_LIGHTING_HDR =               53;
const LUMP_WORLDLIGHTS =                15;
const LUMP_WORLDLIGHTS_HDR =            54;
const LUMP_LEAF_AMBIENT_LIGHTING_HDR =  55;
const LUMP_LEAF_AMBIENT_LIGHTING =      56;
const LUMP_LEAF_AMBIENT_INDEX_HDR =     51;
const LUMP_LEAF_AMBIENT_INDEX =         52;

// game lump
const LUMP_GAME_LUMP =    35;

//*****************************************************************************
type tInfoLump = record
    nOffset: Integer;
    nLength: Integer;
    Version: Integer;
    FourCC: Integer;
  end;

//*****************************************************************************
const MAP_HEADER_SIZE = 1036; // Bytes

type tMapHeader = record
    Signature: Integer;
    nVersion: Integer;
    LumpsInfo: array[0..HEADER_LUMPS-1] of tInfoLump;
    Reversion: Integer;
  end;

function ShowMapHeaderInfo(const MapHeader: tMapHeader): String;
procedure SaveMapHeaderToTextFile(const FileName: String; const Header: tMapHeader);

// Get Max size of BSP by Lump's offset and length
function GetEOFbyHeader(const Header: tMapHeader): Integer;

implementation

function ShowMapHeaderInfo(const MapHeader: tMapHeader): String;
  function ShowElement(const IntoLump: tInfoLump; const Size: Integer): String;
  begin
    {$R-}
    if (Size > 0) then
      begin
        Result:='   ' +
          IntToHex(IntoLump.nOffset, 8) + '    #   ' +
          IntToStr(IntoLump.nLength) + '/' +
          IntToStr(IntoLump.nLength div Size) + CRLF;
      end
    else
      begin
        Result:='   ' +
          IntToHex(IntoLump.nOffset, 8) + '    #   ' +
          IntToStr(IntoLump.nLength) + CRLF;
      end;
    {$R+}
  end;
begin
  {$R-}
  // It's good render in txt notepad application,
  // but bad render in ShowMessage Dialog on this application. Need fix it.
  with MapHeader do
    begin
      Result:=
      'Size of Header = 1036 bytes' + CRLF +
      'Version of BSP = ' + IntToStr(nVersion) + CRLF +
      '####################################################' + CRLF +
      '# Lump type     #  Offset (hex) # Size/Count (dec) #' + CRLF +
      '####################################################' + CRLF +
      '# ENTITIES      #' + ShowElement(LumpsInfo[LUMP_ENTITIES], 0) +
      '# PLANES        #' + ShowElement(LumpsInfo[LUMP_PLANES], 20) +
      '# TEXTURES      #' + ShowElement(LumpsInfo[LUMP_TEXTURES], 0) +
      '# VERTICES      #' + ShowElement(LumpsInfo[LUMP_VERTICES], 12) +
      '# VISIBILITY    #' + ShowElement(LumpsInfo[LUMP_VISIBILITY], 0) +
      '# NODES         #' + ShowElement(LumpsInfo[LUMP_NODES], 24) +
      '# TEXINFO       #' + ShowElement(LumpsInfo[LUMP_TEXINFO], 40) +
      '# FACES         #' + ShowElement(LumpsInfo[LUMP_FACES], 20) +
      '# LIGHTING      #' + ShowElement(LumpsInfo[LUMP_LIGHTING], 3) +
      '# LIGHTING HDR  #' + ShowElement(LumpsInfo[LUMP_LIGHTING_HDR], 3) +
      '# LEAVES        #' + ShowElement(LumpsInfo[LUMP_LEAVES], 28) +
      '# MARKSURFACES  #' + ShowElement(LumpsInfo[LUMP_MARKSURFACES], 2) +
      '# EDGES         #' + ShowElement(LumpsInfo[LUMP_EDGES], 4) +
      '# SURFEDGES     #' + ShowElement(LumpsInfo[LUMP_SURFEDGES], 4) +
      '# BRUSHES       #' + ShowElement(LumpsInfo[LUMP_BRUSHES], 64) +
      '# DISPINFOS     #' + ShowElement(LumpsInfo[LUMP_DISPINFO], 176) +
      '# DISPVERTEX    #' + ShowElement(LumpsInfo[LUMP_DISP_VERTS], 20) +
      '# DISPLIGHTMAP  #' + ShowElement(LumpsInfo[LUMP_DISP_LIGHTMAPS], 0) +
      '# AMBIENT LDR   #' + ShowElement(LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING], 28) +
      '# AMBIENT HDR   #' + ShowElement(LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR], 28) +
      '# AMB INDEX LDR #' + ShowElement(LumpsInfo[LUMP_LEAF_AMBIENT_INDEX], 4) +
      '# AMB INDEX HDR #' + ShowElement(LumpsInfo[LUMP_LEAF_AMBIENT_INDEX_HDR], 4) +
      '####################################################';
    end;
  {$R+}
end;

procedure SaveMapHeaderToTextFile(const FileName: String; const Header: tMapHeader);
var
  HeaderFile: TextFile;
begin
  {$R-}
  AssignFile(HeaderFile, FileName);
  Rewrite(HeaderFile);

  Writeln(HeaderFile, ShowMapHeaderInfo(Header));

  CloseFile(HeaderFile);
  {$R+}
end;

function GetEOFbyHeader(const Header: tMapHeader): Integer;
var
  i, tmp: Integer;
begin
  {$R-}
  Result:=0;
  for i:=0 to HEADER_LUMPS-1 do
    begin
      tmp:=Header.LumpsInfo[i].nOffset + Header.LumpsInfo[i].nLength;
      if tmp>Result then Result:=tmp;
    end;
  {$R+}
end;

end.
 
