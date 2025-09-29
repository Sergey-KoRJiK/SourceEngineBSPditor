unit UnitQueryPerformanceTimer;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes;

type CQueryPerformanceTimer = class
  private
    Frequency: Int64;
    StartPoint, EndPoint: Int64;
    MeashuredInterval: Int64;
    TimerWorkState: Boolean;
  public
    property IsTimerWork: Boolean read TimerWorkState;
    constructor CreateTimer();
    destructor DeleteTimer();
    procedure TimerStart();
    procedure TimerUpdate();
    procedure TimerStop();
    function GetStringSecInterval(): String;
    function GetStringMsInterval(): String;
    function GetStringMcsInterval(): String;
    function GetStringFPS(): String;
    function GetSecInterval(): Extended;
    function GetMsInterval(): Extended;
    function GetMcsInterval(): Extended;
  end;

implementation

const
  SecToMsScale: SmallInt = 1000;
  SecToMcsScale: Single = 1E+6;

constructor CQueryPerformanceTimer.CreateTimer();
begin
  {$R-}
  inherited;
  
  QueryPerformanceFrequency(Self.Frequency);
  Self.StartPoint:=0;
  Self.EndPoint:=0;
  Self.TimerWorkState:=False;
  {$R+}
end;

procedure CQueryPerformanceTimer.TimerStart();
begin
  {$R-}
  Self.TimerWorkState:=True;
  QueryPerformanceCounter(Self.StartPoint);
  {$R+}
end;

procedure CQueryPerformanceTimer.TimerUpdate();
begin
  {$R-}
  if (Self.TimerWorkState) then
    begin
      QueryPerformanceCounter(Self.EndPoint);
      Self.MeashuredInterval:=Self.EndPoint - Self.StartPoint;
    end;
  {$R+}
end;

procedure CQueryPerformanceTimer.TimerStop();
begin
  {$R-}
  QueryPerformanceCounter(Self.EndPoint);
  Self.MeashuredInterval:=Self.EndPoint - Self.StartPoint;
  Self.TimerWorkState:=False;
  {$R+}
end;

function CQueryPerformanceTimer.GetStringSecInterval(): String;
begin
  {$R-}
  Result:=FloatToStrF(Self.MeashuredInterval/Self.Frequency, ffFixed, 6, 4);
  {$R+}
end;

function CQueryPerformanceTimer.GetStringMsInterval(): String;
begin
  {$R-}
  Result:=FloatToStrF(SecToMsScale*(Self.MeashuredInterval/Self.Frequency), ffFixed, 6, 4);
  {$R+}
end;

function CQueryPerformanceTimer.GetStringMcsInterval(): String;
begin
  {$R-}
  Result:=FloatToStrF(SecToMcsScale*(Self.MeashuredInterval/Self.Frequency), ffFixed, 6, 4);
  {$R+}
end;

function CQueryPerformanceTimer.GetStringFPS(): String;
begin
  {$R-}
  Result:=FloatToStrF(Self.Frequency/Self.MeashuredInterval, ffFixed, 6, 1);
  {$R+}
end;

function CQueryPerformanceTimer.GetSecInterval(): Extended;
asm
  {$R-}
  //Result:=SecToMsScale*Self.MeashuredInterval/Self.Frequency;
  fild CQueryPerformanceTimer[EAX].MeashuredInterval
  fild CQueryPerformanceTimer[EAX].Frequency
  fdivp
  {$R+}
end;

function CQueryPerformanceTimer.GetMsInterval(): Extended;
asm
  {$R-}
  //Result:=SecToMsScale*Self.MeashuredInterval/Self.Frequency;
  fild CQueryPerformanceTimer[EAX].MeashuredInterval
  fimul SecToMsScale
  fild CQueryPerformanceTimer[EAX].Frequency
  fdivp
  {$R+}
end;

function CQueryPerformanceTimer.GetMcsInterval(): Extended;
asm
  {$R-}
  //Result:=SecToMsScale*Self.MeashuredInterval/Self.Frequency;
  fild CQueryPerformanceTimer[EAX].MeashuredInterval
  fmul SecToMcsScale
  fild CQueryPerformanceTimer[EAX].Frequency
  fdivp
  {$R+}
end;

destructor CQueryPerformanceTimer.DeleteTimer();
begin
  {$R-}
  inherited;
  {$R+}
end;

end.
