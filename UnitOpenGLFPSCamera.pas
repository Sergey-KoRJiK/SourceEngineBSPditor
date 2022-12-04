unit UnitOpenGLFPSCamera;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// First Person View OpenGL Camera class

interface

uses SysUtils, Windows, Classes, OpenGL, UnitVec;

const
  DoublePi: GLFloat = Pi + Pi;
  CameraPolarAngleMax = Pi*0.5 - 1E-2;
  CameraPolarAngleMin = -Pi*0.5 + 1E-2;
  CameraUpDirection: tVec3f = (X: 0; Y: 0; Z: 1);
  AngleToRadian: GLfloat = Pi/180;
  
const
  DefaultCameraPos: tVec3f = (X: 50; Y: 50; Z: 50);
  DefaultCameraPolarAngle: GLfloat = -0.523599;
  DefaultCameraAzimutalAngle: GLfloat = 0.785398;

type CFirtsPersonViewCamera = class
  private
    CPos, CDir, CTarget: tVec3f;
    CAlpha, CBetta, CBettaSin: GLfloat;
    CDist: GLfloat; // Dist to Axis origin, CDist = Dot(CPos, CDir);
    procedure WrapCAlpha();
    procedure SetViewPosition(const Pos: tVec3f);
  public
    property AzimutalAngle: GLfloat read CAlpha;
    property PolarAngle: GLfloat read CBetta;
    property ViewPosition: tVec3f read CPos write SetViewPosition;
    property ViewDirection: tVec3f read CDir;
    property DistToAxis: GLfloat read CDist;
    //
    constructor CreateNewCamera(const Pos: tVec3f; const PolarAngle, AzimutalAngle: GLfloat);
    destructor DeleteCamera();
    //
    procedure ResetCamera(const Pos: tVec3f; const PolarAngle, AzimutalAngle: GLfloat);
    procedure StepForward(const Dist: GLfloat);
    procedure StepBackward(const Dist: GLfloat);
    procedure StepLeft(const Dist: GLfloat);
    procedure StepRight(const Dist: GLfloat);
    //
    procedure UpdateViewDirectionByMouseX(const AzimutalOffset: GLfloat);
    procedure UpdateViewDirectionByMouseY(const PolarOffset: GLfloat);
    //
    procedure gluLookAtUpdate();
  end;

implementation


constructor CFirtsPersonViewCamera.CreateNewCamera(const Pos: tVec3f;
  const PolarAngle, AzimutalAngle: GLfloat);
begin
  {$R-}
  inherited;
  
  Self.CPos:=Pos;

  Self.CAlpha:=AzimutalAngle;
  Self.WrapCAlpha();
  //
  Self.CDir.X:=-Sin(Self.CAlpha);
  Self.CDir.Y:=-Cos(Self.CAlpha);
  //
  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;

  Self.CBetta:=PolarAngle;
  if (Self.CBetta > CameraPolarAngleMax) then
    begin
      Self.CBetta:=CameraPolarAngleMax;
    end;
  if (Self.CBetta < CameraPolarAngleMin) then
    begin
      Self.CBetta:=CameraPolarAngleMin;
    end;
  //
  Self.CBettaSin:=Sin(Self.CBetta);
  Self.CDir.Z:=Self.CBettaSin/Cos(Self.CBetta);
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.WrapCAlpha();
asm
  {$R-}
  // check (abs(Angle) < 2*pi)
  push ebx
  mov ebx, CFirtsPersonViewCamera[EAX].CAlpha
  and ebx, $7FFFFFFF // get abs(Angle)
  cmp ebx, $40C90FDB // 2*pi as dword is $40C90FDB
  pop ebx
  jl @@NoWrap  // jump to exit if (abs(Angle) < 2*pi)

  // stack is null;
  fldpi
  // st0 = pi;
  fld st(0)
  // st0 = pi; st1 = pi;
  faddp st(1), st(0)
  // st0 = 2*pi;
  fld CFirtsPersonViewCamera[EAX].CAlpha
  // st0 = Angle, st1 = 2*pi;
  fprem1
  // st0 = Angle - 2*pi*N, N = (int)(Angle/(2*pi)); st1 = 2*pi;
  fstp CFirtsPersonViewCamera[EAX].CAlpha
  // st0 = 2*pi;
  fstp st(0)
  // stack is null;

@@NoWrap:
  {$R+}
end;

procedure CFirtsPersonViewCamera.SetViewPosition(const Pos: tVec3f);
begin
  {$R-}
  Self.CPos:=Pos;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.ResetCamera(const Pos: tVec3f;
  const PolarAngle, AzimutalAngle: GLfloat);
begin
  {$R-}
  Self.CPos:=Pos;

  Self.CAlpha:=AzimutalAngle;
  Self.WrapCAlpha();
  //
  Self.CDir.X:=-Sin(Self.CAlpha);
  Self.CDir.Y:=-Cos(Self.CAlpha);
  //
  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;

  Self.CBetta:=PolarAngle;
  if (Self.CBetta > CameraPolarAngleMax) then
    begin
      Self.CBetta:=CameraPolarAngleMax;
    end;
  if (Self.CBetta < CameraPolarAngleMin) then
    begin
      Self.CBetta:=CameraPolarAngleMin;
    end;
  //
  Self.CBettaSin:=Sin(Self.CBetta);
  Self.CDir.Z:=Self.CBettaSin/Cos(Self.CBetta);
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.StepForward(const Dist: GLfloat);
begin
  {$R-}
  Self.CPos.X:=Self.CPos.X + Self.CDir.X*Dist;
  Self.CPos.Y:=Self.CPos.Y + Self.CDir.Y*Dist;
  Self.CPos.Z:=Self.CPos.Z + Self.CBettaSin*Dist;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.StepBackward(const Dist: GLfloat);
begin
  {$R-}
  Self.CPos.X:=Self.CPos.X - Self.CDir.X*Dist;
  Self.CPos.Y:=Self.CPos.Y - Self.CDir.Y*Dist;
  Self.CPos.Z:=Self.CPos.Z - Self.CBettaSin*Dist;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.StepLeft(const Dist: GLfloat);
begin
  {$R-}
  Self.CPos.X:=Self.CPos.X - Self.CDir.Y*Dist;
  Self.CPos.Y:=Self.CPos.Y + Self.CDir.X*Dist;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  {$R+}
end;

procedure CFirtsPersonViewCamera.StepRight(const Dist: GLfloat);
begin
  {$R-}
  Self.CPos.X:=Self.CPos.X + Self.CDir.Y*Dist;
  Self.CPos.Y:=Self.CPos.Y - Self.CDir.X*Dist;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  {$R+}
end;

procedure CFirtsPersonViewCamera.UpdateViewDirectionByMouseX(const AzimutalOffset: GLfloat);
begin
  {$R-}
  Self.CAlpha:=Self.CAlpha + AzimutalOffset;
  Self.WrapCAlpha();

  Self.CDir.X:=-Sin(Self.CAlpha);
  Self.CDir.Y:=-Cos(Self.CAlpha);

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;

  Self.CTarget.X:=Self.CPos.X + Self.CDir.X;
  Self.CTarget.Y:=Self.CPos.Y + Self.CDir.Y;
  {$R+}
end;

procedure CFirtsPersonViewCamera.UpdateViewDirectionByMouseY(const PolarOffset: GLfloat);
begin
  // compiler moved EAX to EDX
  {$R-}
  Self.CBetta:=Self.CBetta + PolarOffset;
  if (Self.CBetta > CameraPolarAngleMax) then
    begin
      Self.CBetta:=CameraPolarAngleMax;
    end;
  if (Self.CBetta < CameraPolarAngleMin) then
    begin
      Self.CBetta:=CameraPolarAngleMin;
    end;

  Self.CBettaSin:=Sin(Self.CBetta);
  Self.CDir.Z:=Self.CBettaSin/Cos(Self.CBetta);
  Self.CTarget.Z:=Self.CPos.Z + Self.CDir.Z;

  Self.CDist:=Self.CPos.x*Self.CDir.x + Self.CPos.y*Self.CDir.y +
    Self.CPos.z*Self.CDir.z;
  {$R+}
end;

procedure CFirtsPersonViewCamera.gluLookAtUpdate();
begin
  {$R-}
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  gluLookAt(
    Self.CPos.X, Self.CPos.Y, Self.CPos.Z,
    Self.CTarget.X, Self.CTarget.Y, Self.CTarget.Z,
    CameraUpDirection.X, CameraUpDirection.Y, CameraUpDirection.Z
  );
  {$R+}
end;

destructor CFirtsPersonViewCamera.DeleteCamera();
begin
  {$R-}
  inherited;
  {$R+}
end;

end.
