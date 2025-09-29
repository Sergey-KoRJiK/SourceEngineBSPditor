unit UnitImageTGA;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  UnitUserTypes,
  UnitVec;

// For exporting lightmap megatextures and basetextures
// need only support True-color 24/32 bit
type tSimpleHeaderTGA = packed record
    LengthID      : Byte; // 0x00 for less size
    ColorMapType  : Byte; // 0x00 for true-color 24/32 bit
    ImageType     : Byte; // 0x02 for true-color (0x0A for RLE per row)
    ColorMapLump  : array[0..4] of Byte; // ColorMap properties, zero (unused)
    StartX        : SmallInt; // 0
    StartY        : SmallInt; // 0
    Width         : SmallInt;
    Height        : SmallInt;
    PixelDepthBit : Byte; // 24 or 32 for True-color image (RGB or RGBA)
    Flags         : Byte; // 0x20; bits 0..3 = alpha channel depth, bit 5..6 - data order XY
  end; // 18 Bytes
type PSimpleHeaderTGA = ^tSimpleHeaderTGA;
type ASimpleHeaderTGA = array of tSimpleHeaderTGA;

const
  TGA_MAX_SIZE  = 1024; // 4 MBytes of max alloc size

type CImageManagerTGA = class
  private
    rHeader: tSimpleHeaderTGA;
    iCountPixels: Integer;
    iPixelDataSize: Integer;
    lpPixelData: AByte;
    bAlphaChannel: Boolean;
  public
    property Width: SmallInt read rHeader.Width;
    property Height: SmallInt read rHeader.Height;
    property Area: Integer read iCountPixels;
    property IsTransparent: Boolean read bAlphaChannel;
    //
    constructor CreateManager();
    destructor DeleteManager();
    //
    procedure Clear();
    // Reserve image (allocate memory) and set TGA header, if input size is valid
    function  ReserveImage(const Width, Height: SmallInt; const bTransparent: Boolean): Boolean;
    procedure ClearImage(const FillColor: tRGBA8888);
    //
    procedure CopyFromRGBA(const lpSrc: PRGBA8888);
    procedure CopyFromRGB(const lpSrc: PRGB888; const Alpha: Byte);
    //
    procedure SaveToFile(const FileName: String);
  end;


implementation


constructor CImageManagerTGA.CreateManager();
begin
  {$R-}
  Self.lpPixelData:=nil;
  Self.Clear();
  {$R+}
end;

destructor CImageManagerTGA.DeleteManager();
begin
  {$R-}
  Self.Clear();
  {$R+}
end;

procedure CImageManagerTGA.Clear();
begin
  {$R-}
  ZeroFillChar(@Self.rHeader, SizeOf(tSimpleHeaderTGA));
  Self.rHeader.ImageType:=2;
  Self.rHeader.PixelDepthBit:=24;
  Self.rHeader.Flags:=$20;
  Self.bAlphaChannel:=False;
  Self.iCountPixels:=0;
  Self.iPixelDataSize:=0;
  SetLength(Self.lpPixelData, 0);
  {$R+}
end;

function CImageManagerTGA.ReserveImage(
  const Width, Height: SmallInt; const bTransparent: Boolean): Boolean;
begin
  {$R-}
  if ((Width <= 0) or (Height <=0) or (Width > TGA_MAX_SIZE) or (Height > TGA_MAX_SIZE)) then
    begin
      Result:=False;
      Exit;
    end;

  Self.Clear();
  Self.rHeader.Width:=Width;
  Self.rHeader.Height:=Height;
  Self.bAlphaChannel:=bTransparent;
  Self.rHeader.PixelDepthBit:=24;
  if (Self.bAlphaChannel) then Self.rHeader.PixelDepthBit:=32;
  Self.iCountPixels:=Self.rHeader.Width*Self.rHeader.Height;
  Self.iPixelDataSize:=Self.iCountPixels*(Self.rHeader.PixelDepthBit shr 3);
  SetLength(Self.lpPixelData, Self.iPixelDataSize);

  Result:=True;
  {$R+}
end;

procedure CImageManagerTGA.ClearImage(const FillColor: tRGBA8888);
var
  i: Integer;
  tmpRGB888: tRGB888;
begin
  {$R-}
  if (Self.iPixelDataSize = 0) then Exit;
  if (Self.bAlphaChannel) then
    begin
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGBA8888(@Self.lpPixelData[0])[i]:=FillColor;
        end;
    end
  else
    begin
      tmpRGB888.r:=FillColor.r;
      tmpRGB888.g:=FillColor.g;
      tmpRGB888.b:=FillColor.b;
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGB888(@Self.lpPixelData[0])[i]:=tmpRGB888;
        end;
    end;
  {$R+}
end;

procedure CImageManagerTGA.CopyFromRGBA(const lpSrc: PRGBA8888);
var
  i: Integer;
begin
  {$R-}
  if ((Self.iPixelDataSize = 0) or (lpSrc = nil)) then Exit;
  if (Self.bAlphaChannel) then
    begin
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGBA8888(@Self.lpPixelData[0])[i]:=ARGBA8888(lpSrc)[i];
        end;
    end
  else
    begin
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGB888(@Self.lpPixelData[0])[i].r:=ARGBA8888(lpSrc)[i].r;
          ARGB888(@Self.lpPixelData[0])[i].g:=ARGBA8888(lpSrc)[i].g;
          ARGB888(@Self.lpPixelData[0])[i].b:=ARGBA8888(lpSrc)[i].b;
        end;
    end;
  {$R+}
end;

procedure CImageManagerTGA.CopyFromRGB(const lpSrc: PRGB888; const Alpha: Byte);
var
  i: Integer;
begin
  {$R-}
  if ((Self.iPixelDataSize = 0) or (lpSrc = nil)) then Exit;
  if (Self.bAlphaChannel) then
    begin
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGBA8888(@Self.lpPixelData[0])[i].r:=ARGB888(lpSrc)[i].r;
          ARGBA8888(@Self.lpPixelData[0])[i].g:=ARGB888(lpSrc)[i].g;
          ARGBA8888(@Self.lpPixelData[0])[i].b:=ARGB888(lpSrc)[i].b;
          ARGBA8888(@Self.lpPixelData[0])[i].a:=Alpha;
        end;
    end
  else
    begin
      for i:=0 to (Self.iCountPixels - 1) do
        begin
          ARGB888(@Self.lpPixelData[0])[i]:=ARGB888(lpSrc)[i];
        end;
    end;
  {$R+}
end;

procedure CImageManagerTGA.SaveToFile(const FileName: String);
var
  TGAFile: File;
begin
  {$R-}
  if ((FileName = '') or (Self.iPixelDataSize = 0)) then Exit;
  AssignFile(TGAFile, FileName);
  Rewrite(TGAFile, 1);

  BlockWrite(TGAFile, Self.rHeader, SizeOf(tSimpleHeaderTGA));
  BlockWrite(TGAFile, Self.lpPixelData[0], Self.iPixelDataSize);

  CloseFile(TGAFile);
  {$R+}
end;

end.
