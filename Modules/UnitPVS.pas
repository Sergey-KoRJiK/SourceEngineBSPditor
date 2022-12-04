unit UnitPVS;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// functions for unpack Leaf Visibility LUMP in BSP

interface

uses SysUtils, Windows, Classes, UnitVec;

const Bit4: array[0..15] of String = (
    '0 0 0 0', '0 0 0 1', '0 0 1 0', '0 0 1 1',
    '0 1 0 0', '0 1 0 1', '0 1 1 0', '0 1 1 1',
    '1 0 0 0', '1 0 0 1', '1 0 1 0', '1 0 1 1',
    '1 1 0 0', '1 1 0 1', '1 1 1 0', '1 1 1 1'
  );

type tVisOffset = record
    // at begining of lump
    OffsetPVS: Integer;
    OffsetPAS: Integer;
  end;
type PVisOffset = ^tVisOffset;
type AVisOffset = array of tVisOffset;

function ShowPVSbyte(const PVSbyte: Byte): String;
function ShowPVS(const Data: AByte; const Size: Integer): String;

function UnPackPVS(const PackedPVS: AByte; var UnPackedPVS: AByteBool;
  const CountPVS, PackedSize: Integer): Integer;

implementation

function ShowPVSbyte(const PVSbyte: Byte): String;
begin
  {$R-}
  Result:=Bit4[(PVSbyte shr 4)] + ' ' + Bit4[(PVSbyte and $0F)];
  {$R+}
end;

function ShowPVS(const Data: AByte; const Size: Integer): String;
var
  i: Integer;
begin
  {$R-}
  Result:=
    '   Count PVS bits = ' + IntToStr(Size) + CRLF +
    '   PVS bits Array data: ' + CRLF +
    '   # Leaf Index # Bit #' + CRLF;
  For i:=0 to Size-1 do
    begin
      Result:=Result + '   # ' + IntToStr(i) + ' # ' +
        ShowPVSbyte(Data[i]) + ' #'+ CRLF;
    end;
  {$R+}
end;

function UnPackPVS(const PackedPVS: AByte; var UnPackedPVS: AByteBool;
  const CountPVS, PackedSize: Integer): Integer;
var
  i, j: Integer;
begin
  {$R-}
  Result:=0;
  SetLength(UnPackedPVS, Result);

  i:=0;
  while ((i < PackedSize) and (Result <= CountPVS))do
    begin
      if (PackedPVS[i] = 0) then
        begin
          // UnPack data
          Inc(i);
          j:=0;
          while (j < PackedPVS[i]) do
            begin
              Inc(Result, 8);
              SetLength(UnPackedPVS, Result);
              UnPackedPVS[Result-1]:=ByteBool(False);
              UnPackedPVS[Result-2]:=ByteBool(False);
              UnPackedPVS[Result-3]:=ByteBool(False);
              UnPackedPVS[Result-4]:=ByteBool(False);
              UnPackedPVS[Result-5]:=ByteBool(False);
              UnPackedPVS[Result-6]:=ByteBool(False);
              UnPackedPVS[Result-7]:=ByteBool(False);
              UnPackedPVS[Result-8]:=ByteBool(False);
              Inc(j);
            end;
        end
      else
        begin
          // No need UnPack
          Inc(Result, 8);
          SetLength(UnPackedPVS, Result);
          UnPackedPVS[Result-1]:=ByteBool(((PackedPVS[i] shr 7) and $01) <> 0);
          UnPackedPVS[Result-2]:=ByteBool(((PackedPVS[i] shr 6) and $01) <> 0);
          UnPackedPVS[Result-3]:=ByteBool(((PackedPVS[i] shr 5) and $01) <> 0);
          UnPackedPVS[Result-4]:=ByteBool(((PackedPVS[i] shr 4) and $01) <> 0);
          UnPackedPVS[Result-5]:=ByteBool(((PackedPVS[i] shr 3) and $01) <> 0);
          UnPackedPVS[Result-6]:=ByteBool(((PackedPVS[i] shr 2) and $01) <> 0);
          UnPackedPVS[Result-7]:=ByteBool(((PackedPVS[i] shr 1) and $01) <> 0);
          UnPackedPVS[Result-8]:=ByteBool((PackedPVS[i] and $01) <> 0);
        end;
      Inc(i);
    end;

  SetLength(UnPackedPVS, CountPVS);
  {$R+}
end;


end.
 
