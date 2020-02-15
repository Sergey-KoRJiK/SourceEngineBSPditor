unit UnitGameLump;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  UnitVec;

type tGameLump = record
    Id: Integer;
    Flags: WORD;
    Version: WORD;
    Offset: Integer; // relative to the beginning of the BSP file
    Size: Integer; // in bytes
    // 16 bytes
  end;
type PGameLump = ^tGameLump;
type AGameLump = array of tGameLump;

const
  ID_STATIC_PROPS: Integer = 1936749168;

type tGameLumpHeader = record
    Count: Integer;
    InfoList: AGameLump;
  end;
type PGameLumpHeader = ^tGameLumpHeader;


implementation



end.
