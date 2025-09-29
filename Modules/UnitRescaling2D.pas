unit UnitRescaling2D;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  Windows,
  UnitUserTypes; 

type tRescalingInfo = packed record
    SrcWidth, SrcHeight: Integer;
    DstWidth, DstHeight: Integer;
    SrcData, DstData: PByte; // Must be allocated
  end;
type PRescalingInfo = ^tRescalingInfo;
type ARescalingInfo = array of tRescalingInfo;


function NearestRescaleValidateInfo(const lpInfo: PRescalingInfo): Boolean;

function NearestRescaleRGBA8888(const lpInfo: PRescalingInfo): Boolean;


implementation


function NearestRescaleValidateInfo(const lpInfo: PRescalingInfo): Boolean;
begin
  {$R-}
  Result:=Boolean(
    (lpInfo.SrcWidth > 0) and (lpInfo.SrcHeight > 0) and
    (lpInfo.DstWidth > 0) and (lpInfo.DstHeight > 0) and
    (lpInfo.SrcData <>  nil) and (lpInfo.DstData <> nil)
  );
  {$R+}
end;

function NearestRescaleRGBA8888(const lpInfo: PRescalingInfo): Boolean;
var
  SrcX, SrcY, DstX, DstY: Integer;
  SrcOffset, DstOffset: Integer;
  ScaleX, ScaleY: Single;
begin
  {$R-}
  if (NearestRescaleValidateInfo(lpInfo) = False) then
    begin
      Result:=False;
      Exit;
    end;

  ScaleX:=lpInfo.SrcWidth/lpInfo.DstWidth;
  ScaleY:=lpInfo.SrcHeight/lpInfo.DstHeight;
  //
  for DstY:=0 to (lpInfo.DstHeight - 1) do
    begin
      SrcY:=Round(DstY*ScaleY);
      if (SrcY >= lpInfo.SrcHeight) then SrcY:=lpInfo.SrcHeight - 1;
      //
      SrcOffset:=SrcY*lpInfo.SrcWidth;
      DstOffset:=DstY*lpInfo.DstWidth;
      for DstX:=0 to (lpInfo.DstWidth - 1) do
        begin
          SrcX:=Round(DstX*ScaleX);
          if (SrcX >= lpInfo.SrcWidth) then SrcX:=lpInfo.SrcWidth - 1;
          //
          ADWORD(lpInfo.DstData)[DstOffset + DstX]:=ADWORD(lpInfo.SrcData)[SrcOffset + SrcX];
        end;
    end;

  Result:=True;
  {$R+}
end;


end.
