unit UnitEntity;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  UnitUserTypes,
  UnitVec;

const
  MAX_KEY_SIZE =      32;
  MAX_VALUE_SIZE =    1024;

type tKeyValue = packed record
    Key   : String;
    Value : String;
  end;
type PKeyValue = ^tKeyValue;
type AKeyValue = array of tKeyValue;

type tEntity = packed record
    CountPairs: Integer;
    Pairs     : AKeyValue;
    ClassName : String;
    TargetName: String;
    Origin    : tVec3f;
    Angles    : tVec3f;
    isOrigin  : ByteBool;
    isAngles  : ByteBool;
    VisLeaf   : SmallInt;
    BModel    : Integer;  // -1 for point entities, 0 - worldspawn, 1.. - BModels
  end;
type PEntity = ^tEntity;
type AEntity = array of tEntity;


const
  KeyOrigin           = 'origin';
  KeyAngles           = 'angles';
  KeyTargetName       = 'targetname';
  KeyClassName        = 'classname';
  KeyBModel           = 'model';
  KeyWorldspawn       = 'worldspawn';
  //
  KeyLightStyle       = 'style';
  ClassNameSpawnSP    = 'info_player_start';
  ClassNameSpawnDM    = 'info_player_deathmatch';
  ClassNameSpawnCT    = 'info_player_counterterrorist';
  ClassNameSpawnT     = 'info_player_terrorist'; 
  ClassNameLight      = 'light';
  ClassNameLightSpot  = 'light_spot';
  ClassNameLightEnv   = 'light_environment';


function GetEntityList(const data: PByte; const dataSz: Integer): AEntity;
procedure FreeEntity(const Entity: PEntity);

function  GetPairIndexByKey(const Pairs: PKeyValue; const CountPairs: Integer;
  const Key: String): Integer;
function  GetPairIndexByValue(const Pairs: PKeyValue; const CountPairs: Integer;
  const Value: String): Integer;
function GetFirstPairIndexBySubValue(const Pairs: PKeyValue; const CountPairs: Integer;
  const SubValue: String): Integer;

function  FindFirstSpawnEntity(const Entities: PEntity; const Count: Integer): Integer;
function  FindEntityByClassName(const Entities: PEntity; const Count: Integer;
  const ClassNameKey: String): Integer;
function  FindEntityByTargetName(const Entities: PEntity; const Count: Integer;
  const TargetNameKey: String): Integer;
function  FindEntityByBModelIndex(const Entities: PEntity; const Count: Integer;
  const BModelIndex: Integer): Integer;


implementation


procedure ParseEntityPair(const StrPair: String; const Pair: PKeyValue);
var
  i, j, n: Integer;
  QuotesPos: array[0..3] of Integer;
begin
  {$R-}
  n:=Length(StrPair);

  j:=0;
  for i:=1 to n do
    begin
      if (StrPair[i] = '"') then Inc(j);
    end;

  if (j <> 4) then
    begin
      Pair.Key:='';
      Pair.Value:='';
    end
  else
    begin
      j:=0;
      for i:=1 to n do
        begin
          if (StrPair[i] = '"') then
            begin
              QuotesPos[j]:=i;
              Inc(j);
            end;
        end;

      if ((QuotesPos[1] - QuotesPos[0] - 1) > MAX_KEY_SIZE) then
        begin
          Pair.Key:=Copy(StrPair, QuotesPos[0] + 1, MAX_KEY_SIZE);
        end
      else
        begin
          Pair.Key:=Copy(StrPair, QuotesPos[0] + 1, QuotesPos[1] - QuotesPos[0] - 1);
        end;

      if ((QuotesPos[3] - QuotesPos[2] - 1) > MAX_VALUE_SIZE) then
        begin
          Pair.Value:=Copy(StrPair, QuotesPos[2] + 1, MAX_VALUE_SIZE);
        end
      else
        begin
          Pair.Value:=Copy(StrPair, QuotesPos[2] + 1, QuotesPos[3] - QuotesPos[2] - 1);
        end;
    end;
  {$R+}
end;

function GetEntityList(const data: PByte; const dataSz: Integer): AEntity;
var
  i, j, k, EntCnt: Integer;
  DebugStr, workData: String;
  BraCount, KetCount, RowCount: Integer;
  BraIndecies, KetIndecies, RowIndex: AInt;
  RawList: TStringList;
begin
  {$R-}
  Result:=nil;
  if (data = nil) or (dataSz <= 0) then Exit;

  SetLength(workData, dataSz);
  for i:=1 to dataSz do
    begin
      PByte(@workData[i])^:=AByte(data)[i-1];
      if (workData[i] = #$0D) then workData[i]:=#$20;
    end;
  workData[dataSz-1]:=#$0A;

  RawList:=TStringList.Create;
  RowCount:=0;
  for i:=1 to dataSz do
    begin
      if (workData[i] = #$0A) then Inc(RowCount);
    end;

  if (RowCount <= 1) then
    begin
      RawList.Append(workData);
    end
  else
    begin
      SetLength(RowIndex, RowCount);
      j:=0;
      for i:=1 to dataSz do
        begin
          if (workData[i] = #$0A) then
            begin
              RowIndex[j]:=i;
              Inc(j);
            end;
        end;

      DebugStr:=StringReplace(
        Copy(workData, 0, RowIndex[0]), #$0A, '', [rfReplaceAll]
      );
      RawList.Append(DebugStr);
      for i:=0 to (RowCount - 1) do
        begin
          DebugStr:=StringReplace(
            Copy(workData, RowIndex[i], RowIndex[i + 1] - RowIndex[i]),
            #$0A, '', [rfReplaceAll]);
          RawList.Append(DebugStr);
        end;
      SetLength(RowIndex, 0);
    end;

  ///////////////////////////////////////////////////////


  BraCount:=0;
	KetCount:=0;
	for i:=0 to (RawList.Count - 1) do
		begin
			if (RawList.Strings[i] = '{') then Inc(BraCount);
			if (RawList.Strings[i] = '}') then Inc(KetCount);
		end;
	//if (BraCount <> KetCount) then Exit;
	EntCnt:=BraCount;
	if (KetCount > BraCount) then EntCnt:=KetCount;
	if (EntCnt = 0) then Exit;

	SetLength(Result, EntCnt);
	SetLength(BraIndecies, EntCnt);
	SetLength(KetIndecies, EntCnt);
	j:=0;
	k:=0;
	for i:=0 to (RawList.Count - 1) do
		begin
			if (RawList.Strings[i] = '{') then
				begin
					BraIndecies[j]:=i;
					Inc(j);
				end;
			if (RawList.Strings[i] = '}') then
				begin
					KetIndecies[k]:=i;
					Inc(k);
				end;
		end;

	for i:=0 to (EntCnt - 1) do
		begin
			if (BraIndecies[i] > KetIndecies[i]) then
				begin
					SetLength(Result, 0);
					SetLength(BraIndecies, 0);
					SetLength(KetIndecies, 0);
					Result:=nil;
					Exit;
				end;
		end;

	for i:=0 to (EntCnt - 1) do
		begin
			Result[i].BModel:=-1;
			Result[i].VisLeaf:=-1;
			Result[i].CountPairs:=KetIndecies[i] - BraIndecies[i] - 1;
			SetLength(Result[i].Pairs, Result[i].CountPairs);
			k:=0;
			for j:=(BraIndecies[i] + 1) to (KetIndecies[i] - 1) do
				begin
					ParseEntityPair(RawList.Strings[j], @Result[i].Pairs[k]);
					Inc(k);
				end;

			Result[i].TargetName:='';
			Result[i].ClassName:='';
			Result[i].Origin:=VEC_ZERO_3F;
      Result[i].Angles:=VEC_ZERO_3F;
      Result[i].isOrigin:=False;
      Result[i].isAngles:=False;
			for j:=0 to (Result[i].CountPairs - 1) do
				begin
					Result[i].Pairs[j].Key:=LowerCase(Result[i].Pairs[j].Key);
					if (Result[i].Pairs[j].Key = KeyClassName) then
						begin
							Result[i].ClassName:=Result[i].Pairs[j].Value;
						end;
					if (Result[i].Pairs[j].Key = KeyTargetName) then
						begin
							Result[i].TargetName:=Result[i].Pairs[j].Value;
						end;
          if (Result[i].Pairs[j].Key = KeyOrigin) then
            begin
              DebugStr:=Result[i].Pairs[j].Value;
              Result[i].isOrigin:=StrToVec(DebugStr, @Result[i].Origin);
            end;
          if (Result[i].Pairs[j].Key = KeyAngles) then
            begin
              DebugStr:=Result[i].Pairs[j].Value;
              Result[i].isAngles:=StrToVec(DebugStr, @Result[i].Angles);
            end;
          if (Result[i].Pairs[j].Key = KeyBModel) then
            begin
              DebugStr:=Result[i].Pairs[j].Value;
              Delete(DebugStr, 1, 1);
              Result[i].BModel:=StrToIntDef(DebugStr, -1);
            end;
				end;
      if (Result[i].ClassName = KeyWorldspawn) then Result[i].BModel:=0;
		end;

  RawList.Destroy;
  workData:='';
  DebugStr:='';
  {$R+}
end;

procedure FreeEntity(const Entity: PEntity);
var
  i: Integer;
begin
  {$R-}
  if (Entity = nil) then Exit;
  for i:=0 to Entity.CountPairs-1 do
    begin
      Entity.Pairs[i].Key:='';
      Entity.Pairs[i].Value:='';
    end;
  SetLength(Entity.Pairs, 0);
  Entity.Pairs:=nil;
  Entity.CountPairs:=0;

  Entity.ClassName:='';
  Entity.TargetName:='';
  Entity.isOrigin:=False;
  Entity.isAngles:=False;
  Entity.VisLeaf:=-1;
  Entity.BModel:=-1;
  {$R+}
end;


function FindFirstSpawnEntity(const Entities: PEntity; const Count: Integer): Integer;
var
  i: Integer;
begin
  {$R-}
  // First check that entities great then one
  if (Count <= 1) then
    begin
      Result:=-1;
      Exit;
    end;

  // First check player spawn
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].ClassName = ClassNameSpawnSP) then
        begin
          if (AEntity(Entities)[i].VisLeaf = 0) then Continue;
          Result:=i;
          Exit;
        end;
    end;

  // Next check DM spawn
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].ClassName = ClassNameSpawnDM) then
        begin
          if (AEntity(Entities)[i].VisLeaf = 0) then Continue;
          Result:=i;
          Exit;
        end;
    end;

  // Next check CT (CS/CSGO) spawn
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].ClassName = ClassNameSpawnCT) then
        begin
          if (AEntity(Entities)[i].VisLeaf = 0) then Continue;
          Result:=i;
          Exit;
        end;
    end;

  // Next check T (CS/CSGO) spawn
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].ClassName = ClassNameSpawnT) then
        begin
          if (AEntity(Entities)[i].VisLeaf = 0) then Continue;
          Result:=i;
          Exit;
        end;
    end;

  // if Bad then -1
  Result:=-1;
  {$R+}
end;

function GetPairIndexByKey(const Pairs: PKeyValue; const CountPairs: Integer;
  const Key: String): Integer;
var
  i: Integer;
begin
  {$R-}
  for i:=0 to (CountPairs - 1) do
    begin
      if (AKeyValue(Pairs)[i].Key = LowerCase(Key)) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

function GetPairIndexByValue(const Pairs: PKeyValue; const CountPairs: Integer;
  const Value: String): Integer;
var
  i: Integer;
begin
  {$R-}
  for i:=0 to (CountPairs - 1) do
    begin
      if (AKeyValue(Pairs)[i].Value = Value) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

function GetFirstPairIndexBySubValue(const Pairs: PKeyValue; const CountPairs: Integer;
  const SubValue: String): Integer;
var
  i: Integer;
begin
  {$R-}
  for i:=0 to (CountPairs - 1) do
    begin
      if (Pos(SubValue, AKeyValue(Pairs)[i].Value) > 0) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

function FindEntityByClassName(const Entities: PEntity; const Count: Integer;
  const ClassNameKey: String): Integer;
var
  i: Integer;
begin
  {$R-}
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].ClassName = LowerCase(ClassNameKey)) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

function FindEntityByTargetName(const Entities: PEntity; const Count: Integer;
  const TargetNameKey: String): Integer;
var
  i: Integer;
begin
  {$R-}
  for i:=1 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].TargetName = LowerCase(TargetNameKey)) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

function FindEntityByBModelIndex(const Entities: PEntity; const Count: Integer;
  const BModelIndex: Integer): Integer;
var
  i: Integer;
begin
  {$R-}
  if (BModelIndex < 0) then
    begin
      // it's point entity
      Result:=-1;
      Exit;
    end;

  for i:=0 to (Count - 1) do
    begin
      if (AEntity(Entities)[i].BModel = BModelIndex) then
        begin
          Result:=i;
          Exit;
        end;
    end;
  Result:=-1;
  {$R+}
end;

end.
