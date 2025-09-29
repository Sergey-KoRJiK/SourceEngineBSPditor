unit UnitQueryPerformanceProfiler;

// Copyright (c) 2022 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes;

type
  tProfileTag = array[0..15] of AnsiChar; // Null-terminated Ansi-string
  PProfileTag = ^tProfileTag;
  AProfileTag = array of tProfileTag;

type tProfileSample = packed record
    StartPoint, EndPoint: Int64;
    TagName: tProfileTag;
  end; // 32 Bytes
type PProfileSample = ^tProfileSample;
type AProfileSample = array of tProfileSample;

const
  MAX_PROFILE_STACK_SIZE = 1024;
  PROFILE_TAGNAME_NULL: tProfileTag = (
    #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
  );
  PROFILE_SAMPLE_NULL: tProfileSample = (
    StartPoint: 0; EndPoint: 0;
    TagName: (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0);
  );
  PROFILE_FLAG_CLEAR: Byte = 0;
  PROFILE_FLAG_NAMED: Byte = 1 shl 0;
  PROFILE_FLAG_USING: Byte = 1 shl 1;
  PROFILE_FLAG_CLOSE: Byte = 1 shl 2;

type CQueryPerformanceProfiler = class
  private
    Frequency: Int64;
    StackIndex: Integer;
    //
    ProfileFlags: array[0..(MAX_PROFILE_STACK_SIZE - 1)] of Byte;
    ProfileStack: array[0..(MAX_PROFILE_STACK_SIZE - 1)] of tProfileSample;
    //
  public
    property CurrentStackId: Integer read StackIndex;
    //
    constructor CreateProfiler();
    destructor DeleteProfiler();
    //
    procedure Clear();
    function FindProfileTag(const ProfileTag: PProfileTag): Integer;
    function ReserveProfileTag(const TagName: String): Integer;
  end;


function StrToProfileTag(const Src: String; const Dst: PProfileTag): Integer;


implementation


function StrToProfileTag(const Src: String; const Dst: PProfileTag): Integer;
var
  i, n: Integer;
begin
  {$R-}
  n:=Length(Src);
  if (n > 15) then n:=15;
  for i:=0 to (n - 1) do
    begin
      Dst[i]:=Src[i + 1];
    end;
  Dst[n]:=#0;
  Result:=n;
  {$R+}
end;


constructor CQueryPerformanceProfiler.CreateProfiler();
begin
  {$R-}
  inherited;

  QueryPerformanceFrequency(Self.Frequency);
  Self.Clear();
  {$R+}
end;

destructor CQueryPerformanceProfiler.DeleteProfiler();
begin
  {$R-}
  inherited;
  {$R+}
end;

procedure CQueryPerformanceProfiler.Clear();
var
  i: Integer;
begin
  {$R-}
  Self.StackIndex:=-1;
  for i:=0 to (MAX_PROFILE_STACK_SIZE - 1) do
    begin
      ProfileFlags[i]:=PROFILE_FLAG_CLEAR;
      ProfileStack[i]:=PROFILE_SAMPLE_NULL;
    end;
  {$R+}
end;

function CQueryPerformanceProfiler.FindProfileTag(
  const ProfileTag: PProfileTag): Integer;
{var
  i: Integer; //}
begin
  {$R-}

  Result:=-1;
  {$R+}
end;

function CQueryPerformanceProfiler.ReserveProfileTag(
  const TagName: String): Integer;
var
  tmpTagName: tProfileTag;
begin
  {$R-}
  Result:=-1;

  if (Self.StackIndex >= (MAX_PROFILE_STACK_SIZE - 1)) then Exit;
  if (StrToProfileTag(TagName, @tmpTagName) = 0) then Exit;
  {$R+}
end;

end.
