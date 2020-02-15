unit UnitRayTraceOpenGL;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

interface

uses
  SysUtils, Windows, Classes, OpenGL;
  

type AGLDouble = array of GLdouble;
type tGLMatrix4d = array[0..15] of GLdouble;

const
  IdentityMatrix4d: tGLMatrix4d = (
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  );

type CRayTracer = class
  private
    ModelMatrix, ProjMatrix: tGLMatrix4d; // 4x4 GLdouble matrix
    ViewPort: array[0..3] of GLint; // list of glViewport() input variables
  public
    constructor CreateRayTracer();
    destructor DeleteRayTracer();
    //
    // ScreenX, ScreenY - "Mouse Click" integer windows display coordinates
    // in range [0..Width, 0..Height].
    // DepthZ - value of Depth Buffer from [0 to 1];
    // "DepthZ = 0" mean pixel at Near Clip Plane, at camera pos;
    // "DepthZ = 1" mead pixel at Far Clip Plane, at max render pos;
    // lpVertex3d is Pointer on first element of array[0..2] of GLdouble;
    procedure UnProjectVertex(const ScreenX, ScreenY, DepthZ: GLdouble;
      const lpVertex3d: PGLdouble);
    //
    procedure UpdateViewPort();
    procedure UpdateProjectMatrix();
    procedure UpdateModelMatrix();
  end;


implementation


constructor CRayTracer.CreateRayTracer();
begin
  {$R-}
  // Set Identity matrix
  Self.ModelMatrix:=IdentityMatrix4d;
  Self.ProjMatrix:=IdentityMatrix4d;

  // Set Identity Viewport
  Self.ViewPort[0]:=0;
  Self.ViewPort[1]:=0;
  Self.ViewPort[2]:=1;
  Self.ViewPort[3]:=1;
  {$R+}
end;

destructor CRayTracer.DeleteRayTracer();
begin
  {$R-}

  {$R+}
end;


procedure CRayTracer.UnProjectVertex(const ScreenX, ScreenY, DepthZ: GLdouble;
  const lpVertex3d: PGLdouble);
begin
  {$R-}
  gluUnProject(
    ScreenX, Self.ViewPort[3] - ScreenY - 1, DepthZ,
    @Self.ModelMatrix[0], @Self.ProjMatrix[0], @Self.ViewPort[0],
    AGLDouble(lpVertex3d)[0],
    AGLDouble(lpVertex3d)[1],
    AGLDouble(lpVertex3d)[2]);
  {$R+}
end;

procedure CRayTracer.UpdateViewPort();
begin
  {$R-}
  glGetIntegerv(GL_VIEWPORT, @Self.ViewPort[0]);
  {$R+}
end;

procedure CRayTracer.UpdateProjectMatrix();
begin
  {$R-}
  glGetDoublev(GL_PROJECTION_MATRIX, @Self.ProjMatrix[0]);
  {$R+}
end;

procedure CRayTracer.UpdateModelMatrix();
begin
  {$R-}
  glGetDoublev(GL_MODELVIEW_MATRIX, @Self.ModelMatrix[0]);
  {$R+}
end;

end.
