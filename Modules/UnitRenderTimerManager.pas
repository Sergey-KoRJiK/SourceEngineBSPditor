unit UnitRenderTimerManager;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows;

type CRenderTimerManager = class
  private
    fDeltaTime, fLastTime, fFPS: Double;
    fInitTimestamp: Double; // [seconds]
    iFrequency: Int64;
    iTmp: Int64;
    //
    function GetElaspedTime(): Double;
  public
    property ElaspedTime: Double read GetElaspedTime; // [sec]
    property DeltaTime: Double read fDeltaTime; // [sec]
    property FPS: Double read fFPS; // [1/sec]
    //
    constructor CreateManager();
    destructor DeleteManager();
    //
    procedure ResetTimer();
    procedure ResetCounter();
    //
    procedure UpdDeltaTime();
    function GetStringFPS(): String; 
  end;


implementation


constructor CRenderTimerManager.CreateManager();
begin
  {$R-}
  QueryPerformanceFrequency(Self.iFrequency);
  QueryPerformanceCounter(Self.iTmp);
  Self.fInitTimestamp:=Self.iTmp/Self.iFrequency;
  Self.fLastTime:=Self.fInitTimestamp;
  Self.fDeltaTime:=0.0;
  Self.fFPS:=0.0;
  {$R+}
end;

destructor CRenderTimerManager.DeleteManager();
begin
  {$R-}

  {$R+}
end;


function CRenderTimerManager.GetElaspedTime(): Double;
begin
  {$R-}
  QueryPerformanceCounter(Self.iTmp);
  Result:=Self.iTmp/Self.iFrequency - Self.fInitTimestamp;
  {$R+}
end;


procedure CRenderTimerManager.ResetTimer();
begin
  {$R-}
  QueryPerformanceCounter(Self.iTmp);
  Self.fLastTime:=Self.iTmp/Self.iFrequency;
  Self.fDeltaTime:=0.0;
  Self.fFPS:=0.0;
  {$R+}
end;

procedure CRenderTimerManager.ResetCounter();
begin
  {$R-}
  QueryPerformanceCounter(Self.iTmp);
  fInitTimestamp:=Self.iTmp/Self.iFrequency;
  {$R+}
end;

procedure CRenderTimerManager.UpdDeltaTime();
var
  fCurrentTime: Double;
begin
  {$R-}
  QueryPerformanceCounter(Self.iTmp);
  fCurrentTime:=Self.iTmp/Self.iFrequency;
  //
  Self.fDeltaTime:=fCurrentTime - Self.fLastTime;
  Self.fLastTime:=fCurrentTime;
  Self.fFPS:=1.0/Self.fDeltaTime;
  {$R+}
end;

function CRenderTimerManager.GetStringFPS(): String;
begin
  {$R-}
  Result:=FloatToStrF(Self.fFPS, ffFixed, 6, 1);
  {$R+}
end;

end.
