unit UnitRenderingContextManager;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes;

type CRenderingContextManager = class
  private
    hWindowHandle: HWND;
    hDeviceContext: HDC;
    hRenderingContext: HGLRC;
    iPixelFormat: Integer;
    pfd: TPixelFormatDescriptor;
    //
    bValid: Boolean;
  public
    property IsValidRenderingContext: Boolean read bValid;
    //
    property PixelFormat: Integer read iPixelFormat;
    property WindowHandle: HWND read hWindowHandle;
    //
    constructor CreateManager();
    destructor DeleteManager();
    //
    function CreateRenderingContext(const WindowHandle: HWND;
      const DepthBits: Byte): Boolean;
    procedure MakeCurrent();
    procedure UnMakeCurrent();
    procedure SwapBuffers();
    procedure DeleteRenderingContext();
    //
    procedure ReadPixelFormatDescriptor(const ppfd: PPixelFormatDescriptor);
  end;


implementation


constructor CRenderingContextManager.CreateManager();
begin
  {$R-}
  Self.hWindowHandle:=0;
  Self.hDeviceContext:=0;
  Self.hRenderingContext:=0;
  Self.iPixelFormat:=-1;
  FillChar(Self.pfd, SizeOf(Self.pfd), 0);
  //
  Self.bValid:=False;
  {$R+}
end;

destructor CRenderingContextManager.DeleteManager();
begin
  {$R-}
  Self.DeleteRenderingContext();
  {$R+}
end;


function CRenderingContextManager.CreateRenderingContext(
  const WindowHandle: HWND; const DepthBits: Byte): Boolean;
begin
  {$R-}
  if (Self.bValid) then Self.DeleteRenderingContext();

  if (IsWindow(WindowHandle) = False) then
    begin
      Result:=False;
      Exit;
    end;
  Self.hWindowHandle:=WindowHandle;

  FillChar(Self.pfd, SizeOf(Self.pfd), 0);
  Self.pfd.nSize:=SizeOf(pfd);
  Self.pfd.nVersion:=1;
  Self.pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  Self.pfd.iPixelType:=PFD_TYPE_RGBA;
  Self.pfd.cDepthBits:=DepthBits;

  Self.hDeviceContext:=Windows.GetDC(Self.hWindowHandle);
  Self.iPixelFormat:=Windows.ChoosePixelFormat(Self.hDeviceContext, @Self.pfd);
  Windows.SetPixelFormat(Self.hDeviceContext, Self.iPixelFormat, @Self.pfd);
  Self.hRenderingContext:=Windows.wglCreateContext(Self.hDeviceContext);
  Self.bValid:=Boolean(Self.hRenderingContext <> 0);

  Result:=Self.bValid;
  {$R+}
end;

procedure CRenderingContextManager.MakeCurrent();
begin
  {$R-}
  if (Self.bValid) then
    begin
      Windows.wglMakeCurrent(Self.hDeviceContext, Self.hRenderingContext);
    end;
  {$R+}
end;

procedure CRenderingContextManager.UnMakeCurrent();
begin
  {$R-}
  Windows.wglMakeCurrent(0, 0);
  {$R+}
end;

procedure CRenderingContextManager.SwapBuffers();
begin
  {$R-}
  if (Self.bValid) then
    begin
      Windows.SwapBuffers(Self.hDeviceContext);
    end;
  {$R+}
end;

procedure CRenderingContextManager.DeleteRenderingContext();
begin
  {$R-}
  if (Self.bValid = False) then Exit;

  Self.UnMakeCurrent();
  Windows.ReleaseDC(Self.hWindowHandle, Self.hDeviceContext);
  Windows.wglDeleteContext(Self.hDeviceContext);

  Self.hWindowHandle:=0;
  Self.hDeviceContext:=0;
  Self.hRenderingContext:=0;
  Self.iPixelFormat:=-1;
  FillChar(Self.pfd, SizeOf(Self.pfd), 0);

  Self.bValid:=False;
  {$R+}
end;

procedure CRenderingContextManager.ReadPixelFormatDescriptor(
  const ppfd: PPixelFormatDescriptor);
begin
  {$R-}
  if ((Self.bValid = False) or (ppfd = nil)) then Exit;

  ppfd^:=Self.pfd;
  {$R+}
end;

end.
