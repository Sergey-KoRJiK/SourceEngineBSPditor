unit Unit1;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Unit of Main 3d Form
// TMainForm.Paint - Render Scence 
// TMainForm.GetRenderList - Culling pipeline (VisLeaf-Frustum and VisLeaf-Face Culling)
// TMainForm.GetFaceIndexByRay - Ray-Scence intersection pipeline by Culled from Frustum
// TMainForm.do_movement - Camera movement and test leaf bounds, get current camera leaf in
// TMainForm.ToneMapUpdate - Apply Tonemap Filter to OpenGL Textures, rebuild it for each face.
// ToneMap don't apply on Lightmaps data.

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  ComCtrls,
  {}
  OpenGL,
  EXTOpengl32Glew32,
  UnitOpenGLAdditional,
  UnitOpenGLFPSCamera,
  UnitRayTraceOpenGL,
  {}
  UnitVec,
  UnitBSPstruct,
  UnitEntity,
  UnitPlane,
  UnitTexture,
  UnitVertex,
  UnitMapHeader,
  UnitPVS,
  UnitNode,
  UnitFace,
  UnitLightmap,
  UnitVisLeaf,
  UnitMarkSurface,
  UnitEdge,
  UnitBrushModel,
  UnitDisplacement,
  UnitLeafAmbientLight,
  UnitMapFog,
  UnitToneMapControl;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    OpenDialogBsp: TOpenDialog;
    FileMenu: TMenuItem;
    OptionsMenu: TMenuItem;
    HelpMenu: TMenuItem;
    AboutMenu: TMenuItem;
    ResetCameraMenu: TMenuItem;
    OpenMapMenu: TMenuItem;
    CloseMapMenu: TMenuItem;
    WireframeRenderMenu: TMenuItem;
    ShowWorldBrushesMenu: TMenuItem;
    ShowEntBrushesMenu: TMenuItem;
    WallhackRenderModeMenu: TMenuItem;
    ShowHeaderMenu: TMenuItem;
    EnableFogMenu: TMenuItem;
    SaveDialogBsp: TSaveDialog;
    StatusBar: TStatusBar;
    ColorDialog: TColorDialog;
    SetClearColorMenu: TMenuItem;
    SetFaceDiffuseColorMenu: TMenuItem;
    SaveMapMenu: TMenuItem;
    ShowDisplacementsMenu: TMenuItem;
    RenderSubMenu: TMenuItem;
    GUIPaletteSubMenu: TMenuItem;
    SetFaceSelectedColorMenu: TMenuItem;
    SHToolMenu: TMenuItem;
    ShowFaceToolMenu: TMenuItem;
    ShowAmbToolMenu: TMenuItem;
    ShowAmbientCubeMenu: TMenuItem;
    procedure UpdateOpenGLViewport(const zFar: GLdouble);
    procedure GetFrustum();
    function isNotFaceFrustumIntersection(const lpFaceInfo: PFaceInfo): Boolean;
    function GetDispTriagFrustumIntersection(const lpDisp: PDispRenderInfo): Integer;
    function isNotFrustumBBoxIntersection(const BBOXf: tBBOXf): Boolean;
    procedure GetRenderList();
    procedure do_movement(const Offset: GLfloat);
    procedure GetMouseClickRay(const X, Y: Integer);
    procedure GetFaceIndexByRay();
    procedure GetAmbientCubeIndexByRay();
    procedure ToneMapUpdate();
    procedure ChangeLmpMode();
    //
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OpenMapMenuClick(Sender: TObject);
    procedure CloseMapMenuClick(Sender: TObject);
    procedure ResetCameraMenuClick(Sender: TObject);
    procedure ShowWorldBrushesMenuClick(Sender: TObject);
    procedure ShowEntBrushesMenuClick(Sender: TObject);
    procedure WallhackRenderModeMenuClick(Sender: TObject);
    procedure HelpMenuClick(Sender: TObject);
    procedure AboutMenuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowHeaderMenuClick(Sender: TObject);
    procedure EnableFogMenuClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SetClearColorMenuClick(Sender: TObject);
    procedure SetFaceDiffuseColorMenuClick(Sender: TObject);
    procedure SaveMapMenuClick(Sender: TObject);
    procedure ShowDisplacementsMenuClick(Sender: TObject);
    procedure WireframeRenderMenuClick(Sender: TObject);
    procedure SetFaceSelectedColorMenuClick(Sender: TObject);
    procedure ShowFaceToolMenuClick(Sender: TObject);
    procedure ShowAmbToolMenuClick(Sender: TObject);
    procedure ShowAmbientCubeMenuClick(Sender: TObject);
  private

  public
    HRC: HGLRC; // OpenGL
    TimerFrequency: Int64;
    deltaTime, lastFrame: GLfloat;
    RayTracer: CRayTracer;
    MouseRay: tRay;
    Camera: CFirtsPersonViewCamera;
    FrustumVertecies: array[0..7] of tVec3d;
    FrustumPlanes: array[0..5] of tPlane;
    FieldOfView: GLdouble;
    ClearColor: tColor4fv;
    //
    isLeftMouseClicked, isRightMouseClicked: Boolean;
    mdx, mdy: Integer; // Mouse offsets
    //
    tickCount: Integer; // Counter for wait output info
    PressedKeys: array[0..1023] of Boolean; 
    //
    StartGridLIndex, OrtsListIndex: GLuint;
    //***
    Bsp30: tMapBSP;
    isBspLoad: Boolean;
    CameraLeafId, CameraLastLeafId: Integer;
    FirstSpawnEntityId: Integer;
    lpCameraLeaf: PVisLeafInfo;
    StyleRenderIndex: Byte;
    //
    RenderFacesTrigCount: Integer;
    WorldFacesIndexToRender: AByteBool;
    EntityFacesIndexToRender: AByteBool;
    //
    RenderDispTrigCount: Integer;
    DisplamentsIndexToRender: AByteBool;
    //
    LeafIndexToRender: AByteBool;
    FaceDiffuseColor: tColor4fv;
    FaceSelectedColor: tColor4fv;
    // Render VisLeaf options
    BaseCubeLeafWireframeList: GLuint;
    ScaleForBBOX: tVec3f;
    // Fog Options
    MapFog: CFog;
    isFogAviable: Boolean;
    FogEntityId: Integer;
    // Trace by Mouse Click
    SelectedFaceIndex: Integer;
    SelectedAmbCubeIndex: Integer;
    lpCurrAmbCube: PCubeInfo;
    AmbCubeIndexToRender: array[0..MAX_AMBIENT_SAMPLES-1] of ByteBool;
    // ToneMap Options
    ToneMapScale: Single;
    isModeHDR: Boolean;
  end;

const
  MaxRender: GLdouble = 40000.0;
  LeafRenderColor: tColor4fv = (0.1, 0.1, 0.7, 7.0);
  LeafRenderColorEmpity: tColor4fv = (0.7, 0.1, 0.1, 7.0);
  AmbientCubeSelectedColor: tColor4fv = (0.1, 0.7, 0.1, 7.0);
  VmfBBOXColor: tColor4fv = (0.1, 0.7, 0.1, 7.0);
  MAX_TICKCOUNT: Integer = 20;
  //
  MFrec: GLfloat = (Pi/180.0)/4.0;
  CameraSpeed: GLfloat = 200.0;
  //
  HelpStr: String = 'Rotate Camera: Left Mouse Button' + LF +
    'Move Camera forward/backward: keys W/S' + LF +
    'Step Camera Left/Right: keys A/D' + LF +
    'Orts: red X, blue Y, green Z' + LF +
    'Select Face or Ambient Cube: Right Mouse Button' + LF +
    'Change Lightmap Style Page: key F' + LF +
    'Change Lightmap HDR\LDR Mode: key G' + LF +
    'For change ambient color click in color rect'  + LF +
    ' or directly enter value in field and press "apply"'  + LF +
    'Additional info showed in bottom Status Bar';
  AboutStr: ShortString = 'Copyright (c) 2019 Sergey-KoRJiK, Belarus' + LF +
    'github.com/Sergey-KoRJiK' + LF +
    'Source Engine BSP 3D OpenGL Lightmap Editor' + LF +
    'Program version: 1.0.4' + LF +
    'Version of you OpenGL: ';
  MainFormCaption: ShortString = ' Source Engine BSP 3D OpenGL Lightmap Editor';

var
  isCanRenderMainForm: Boolean = False;

implementation


{$R *.dfm}

uses Unit2, Unit3;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  {$R-}
  Self.tickCount:=MAX_TICKCOUNT;
  Self.FieldOfView:=90.0; // Camera FOV
  Self.KeyPreview:=True;
  Self.isLeftMouseClicked:=False;
  Self.isRightMouseClicked:=False;
  //
  Self.isBspLoad:=False;
  Self.CameraLeafId:=-1;
  Self.CameraLastLeafId:=-1;
  Self.FirstSpawnEntityId:=0;
  Self.lpCameraLeaf:=nil;
  Self.SelectedFaceIndex:=-1;
  Self.SelectedAmbCubeIndex:=-1;
  Self.StyleRenderIndex:=0;
  Self.RenderFacesTrigCount:=0;
  Self.RenderDispTrigCount:=0;
  Self.lpCurrAmbCube:=nil;

  Self.isModeHDR:=False;

  // Set ToneMap Options
  Self.ToneMapScale:=1.0;

  // Set Diffuse Face Color
  Self.FaceDiffuseColor[0]:=1.0;
  Self.FaceDiffuseColor[1]:=1.0;
  Self.FaceDiffuseColor[2]:=1.0;
  Self.FaceDiffuseColor[3]:=1.0;

  // Set Face Selected Color
  Self.FaceSelectedColor[0]:=0.5;
  Self.FaceSelectedColor[1]:=0.5;
  Self.FaceSelectedColor[2]:=0.5;
  Self.FaceSelectedColor[3]:=0.3;

  // Set Clear Color
  Self.ClearColor[0]:=0.1;
  Self.ClearColor[1]:=0.1;
  Self.ClearColor[2]:=0.1;
  Self.ClearColor[3]:=1.0;

  //Self.RenderTimer:=CQueryPerformanceTimer.CreateTimer();
  QueryPerformanceFrequency(Self.TimerFrequency);
  Self.deltaTime:=0.0;
  Self.lastFrame:=0.0;
  Self.RayTracer:=CRayTracer.CreateRayTracer();
  Self.Camera:=CFirtsPersonViewCamera.CreateNewCamera(
    DefaultCameraPos,
    DefaultCameraPolarAngle,
    DefaultCameraAzimutalAngle
  );
  Self.GetFrustum();
  
  SetDCPixelFormat(Self.Canvas.Handle);
  Self.HRC:=wglCreateContext(Self.Canvas.Handle);
  wglMakeCurrent(Self.Canvas.Handle, Self.HRC);

  InitGL();
  Self.MapFog:=CFog.CreateFogDisabled();
  Self.isFogAviable:=False;
  glClearColor(
    Self.ClearColor[0],
    Self.ClearColor[1],
    Self.ClearColor[2],
    Self.ClearColor[3]
  );

  Self.StartGridLIndex:=GenListStartGrid();
  Self.OrtsListIndex:=GenListOrts();
  Self.BaseCubeLeafWireframeList:=GenListCubeWireframe();

  Self.UpdateOpenGLViewport(MaxRender);
  isCanRenderMainForm:=True;
  {$R+}
end;


procedure TMainForm.UpdateOpenGLViewport(const zFar: GLdouble);
begin
  {$R-}
  glViewport(0, 0, Self.ClientWidth, Self.ClientHeight);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(FieldOfView, Self.ClientWidth/Self.ClientHeight, 1, zFar);
  {$R+}
end;

procedure TMainForm.GetFrustum();
begin
  {$R-}
  // Get Frustum Vertecies
  Self.RayTracer.UnProjectVertex(0, 0, 0, @FrustumVertecies[0]);
  Self.RayTracer.UnProjectVertex(0, Self.ClientHeight, 0, @FrustumVertecies[1]);
  Self.RayTracer.UnProjectVertex(Self.ClientWidth, Self.ClientHeight, 0, @FrustumVertecies[2]);
  Self.RayTracer.UnProjectVertex(Self.ClientWidth, 0, 0, @FrustumVertecies[3]);
  
  Self.RayTracer.UnProjectVertex(0, 0, 1, @FrustumVertecies[4]);
  Self.RayTracer.UnProjectVertex(0, Self.ClientHeight, 1, @FrustumVertecies[5]);
  Self.RayTracer.UnProjectVertex(Self.ClientWidth, Self.ClientHeight, 1, @FrustumVertecies[6]);
  Self.RayTracer.UnProjectVertex(Self.ClientWidth, 0, 1, @FrustumVertecies[7]); //}

  // Get Frustum Planes
  // 1. Near Plane
  Self.FrustumPlanes[0].vNormal:=Self.Camera.ViewDirection;
  Self.FrustumPlanes[0].fDist:=Self.Camera.DistToAxis;
  Self.FrustumPlanes[0].AxisType:=PLANE_ANYZ;
  // 2. Far Plane
  SignInvertVec(@Self.FrustumPlanes[0].vNormal, @Self.FrustumPlanes[1].vNormal);
  Self.FrustumPlanes[1].fDist:=-(MaxRender + Self.FrustumPlanes[0].fDist);
  Self.FrustumPlanes[1].AxisType:=PLANE_ANYZ;

  // 3. Left Plane
  GetPlaneByPoints(FrustumVertecies[0],
    FrustumVertecies[3],
    FrustumVertecies[4],
    @Self.FrustumPlanes[2]);
  // 4. Right Plane
  GetPlaneByPoints(FrustumVertecies[2],
    FrustumVertecies[1],
    FrustumVertecies[6],
    @Self.FrustumPlanes[3]);

  // 5. Top Plane
  GetPlaneByPoints(FrustumVertecies[0],
    FrustumVertecies[4],
    FrustumVertecies[1],
    @Self.FrustumPlanes[4]);
  // 6. Bottom Plane
  GetPlaneByPoints(FrustumVertecies[2],
    FrustumVertecies[6],
    FrustumVertecies[3],
    @Self.FrustumPlanes[5]);
  {$R+}
end;

function TMainForm.isNotFaceFrustumIntersection(const lpFaceInfo: PFaceInfo): Boolean;
var
  i, j: Integer;
  tmpBool: Boolean;
begin
  {$R-}
  for i:=0 to 5 do
    begin
      tmpBool:=True;
      for j:=0 to (lpFaceInfo.CountVertex - 1) do
        begin
          if (isPointInFrontPlaneSpaceFull(@Self.FrustumPlanes[i],
            lpFaceInfo.Vertex[j])) then
            begin
              tmpBool:=False;
              Break;
            end;
        end;

      if (tmpBool = True) then
        begin
          Result:=True;
          Exit;
        end;
    end;
    
  Result:=False;
  {$R+}
end;

function TMainForm.GetDispTriagFrustumIntersection(const lpDisp: PDispRenderInfo): Integer;
var
  i, j: Integer;
  lpDispTrig: PDispTrig;
begin
  {$R-}
  Result:=lpDisp.CountTriangles;
  lpDispTrig:=@lpDisp.TriangleList[0];
  for i:=0 to (lpDisp.CountTriangles - 1) do
    begin
      lpDisp.TrianglesToRender[i]:=True;

      for j:=0 to 5 do
        begin
          if (isPointInFrontPlaneSpaceFull(@Self.FrustumPlanes[j],
            lpDispTrig.V0) = False) then
            begin
              if (isPointInFrontPlaneSpaceFull(@Self.FrustumPlanes[j],
                lpDispTrig.V1) = False) then
                begin
                  if (isPointInFrontPlaneSpaceFull(@Self.FrustumPlanes[j],
                    lpDispTrig.V2) = False) then
                    begin
                      lpDisp.TrianglesToRender[i]:=False;
                      Dec(Result);
                      Break;
                    end;
                end;
            end;
        end;

      Inc(lpDispTrig);
    end;
  {$R+}
end;

function TMainForm.isNotFrustumBBoxIntersection(const BBOXf: tBBOXf): Boolean;
label
  LabelBackX, LabelRightY, LabelLeftY, LabelUpZ, LabelDownZ, LabelFalseRet;
begin
  {$R-}
  // Front X, Normal = (1, 0, 0);
  if (Self.FrustumVertecies[0].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[1].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[2].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[3].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[4].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[5].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[6].x >= BBOXf.vMin.x) then goto LabelBackX;
  if (Self.FrustumVertecies[7].x < BBOXf.vMin.x) then
    begin
      Result:=True;
      Exit;
    end;

  // Back X, Normal = (-1, 0, 0):
LabelBackX:
  if (Self.FrustumVertecies[0].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[1].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[2].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[3].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[4].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[5].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[6].x <= BBOXf.vMax.x) then goto LabelRightY;
  if (Self.FrustumVertecies[7].x > BBOXf.vMax.x) then
    begin
      Result:=True;
      Exit;
    end;

  // Right Y, Normal = (0, 1, 0):
LabelRightY:
  if (Self.FrustumVertecies[0].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[1].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[2].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[3].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[4].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[5].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[6].y >= BBOXf.vMin.y) then goto LabelLeftY;
  if (Self.FrustumVertecies[7].y < BBOXf.vMin.y) then
    begin
      Result:=True;
      Exit;
    end;

  // Left Y, Normal = (0, -1, 0):
LabelLeftY:
  if (Self.FrustumVertecies[0].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[1].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[2].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[3].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[4].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[5].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[6].y <= BBOXf.vMax.y) then goto LabelDownZ;
  if (Self.FrustumVertecies[7].y > BBOXf.vMax.y) then
    begin
      Result:=True;
      Exit;
    end;

  // Down Z, Normal = (0, 0, 1):
LabelDownZ:
  if (Self.FrustumVertecies[0].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[1].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[2].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[3].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[4].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[5].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[6].z >= BBOXf.vMin.z) then goto LabelUpZ;
  if (Self.FrustumVertecies[7].z < BBOXf.vMin.z) then
    begin
      Result:=True;
      Exit;
    end;

  // Up Z, Normal = (0, 0, -1):
LabelUpZ:
  if (Self.FrustumVertecies[0].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[1].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[2].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[3].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[4].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[5].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[6].z <= BBOXf.vMax.z) then goto LabelFalseRet;
  if (Self.FrustumVertecies[7].z > BBOXf.vMax.z) then
    begin
      Result:=True;
      Exit;
    end;

LabelFalseRet:
  Result:=False;
  Exit;
  {$R+}
end;


procedure TMainForm.ToneMapUpdate();
var
  i, j: Integer;
begin
  {$R-}
  if (Self.isBspLoad = False) then Exit;

  for i:=0 to (Self.Bsp30.CountFaces - 1) do
    begin
      if (Self.Bsp30.FaceInfos[i].isValidToRender = False) then Continue;

      // Get Lightmaps pages GL
      if (Self.Bsp30.isLDR) then
        begin
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 0, @Self.ToneMapScale, False);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 1, @Self.ToneMapScale, False);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 2, @Self.ToneMapScale, False);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 3, @Self.ToneMapScale, False);
        end;
      if (Self.Bsp30.isHDR) then
        begin
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 0, @Self.ToneMapScale, True);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 1, @Self.ToneMapScale, True);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 2, @Self.ToneMapScale, True);
          CreateLightmapTexture(@Self.Bsp30.FaceInfos[i], 3, @Self.ToneMapScale, True);
        end;

      if (Self.isModeHDR) then
        begin
          Self.Bsp30.FaceInfos[i].TextureRender:=Self.Bsp30.FaceInfos[i].LmpPagesHDR[0];
          if (Self.StyleRenderIndex < Self.Bsp30.FaceInfos[i].CountLightStyles) then
            begin
              Self.Bsp30.FaceInfos[i].TextureRender:=
                Self.Bsp30.FaceInfos[i].LmpPagesHDR[Self.StyleRenderIndex];
            end;
        end
      else
        begin
          Self.Bsp30.FaceInfos[i].TextureRender:=Self.Bsp30.FaceInfos[i].LmpPages[0];
          if (Self.StyleRenderIndex < Self.Bsp30.FaceInfos[i].CountLightStyles) then
            begin
              Self.Bsp30.FaceInfos[i].TextureRender:=
                Self.Bsp30.FaceInfos[i].LmpPages[Self.StyleRenderIndex];
            end;
        end;

      j:=Self.Bsp30.FaceLump[i].DispInfoIndex;
      if (j >= 0) then
        begin
          Self.Bsp30.DispRenderInfo[j].TextureRender:=Self.Bsp30.FaceInfos[i].TextureRender;
        end;
    end;
  {$R+}
end;

procedure TMainForm.ChangeLmpMode();
var
  i: Integer;
begin
  {$R-}
  if (Self.isBspLoad = False) then
    begin
      Self.isModeHDR:=False;
      Exit;
    end;

  if (Self.isModeHDR = False) then
    begin
      for i:=0 to (Self.Bsp30.CountFaces - 1) do
        begin
          if (Self.StyleRenderIndex < Self.Bsp30.FaceInfos[i].CountLightStyles) then
            begin
              Self.Bsp30.FaceInfos[i].TextureRender:=
                Self.Bsp30.FaceInfos[i].LmpPages[Self.StyleRenderIndex];
            end;
        end;
    end
  else
    begin
      for i:=0 to (Self.Bsp30.CountFaces - 1) do
        begin
          if (Self.StyleRenderIndex < Self.Bsp30.FaceInfos[i].CountLightStyles) then
            begin
              Self.Bsp30.FaceInfos[i].TextureRender:=
                Self.Bsp30.FaceInfos[i].LmpPagesHDR[Self.StyleRenderIndex];
            end;
        end;
    end;
  {$R+}
end;


procedure TMainForm.GetRenderList();
var
  i, j, k: Integer;
  tmpVisLeafInfo: PVisLeafInfo;
  lpCurrAmbList: PLeafAmbientInfo;
begin
  {$R-}
  Self.RenderFacesTrigCount:=0;
  Self.RenderDispTrigCount:=0;
  ZeroFillChar(@Self.WorldFacesIndexToRender[0], Self.Bsp30.CountFaces);
  ZeroFillChar(@Self.EntityFacesIndexToRender[0], Self.Bsp30.CountFaces);
  ZeroFillChar(@Self.DisplamentsIndexToRender[0], Self.Bsp30.CountDispInfos);
  ZeroFillChar(@Self.AmbCubeIndexToRender[0], MAX_AMBIENT_SAMPLES);

  if (Self.ShowAmbientCubeMenu.Checked) then
    begin
      if (Self.isModeHDR = False) then
        begin
          lpCurrAmbList:=@Self.Bsp30.AmbientInfoListLDR[Self.CameraLeafId];
        end
      else
        begin
          lpCurrAmbList:=@Self.Bsp30.AmbientInfoListHDR[Self.CameraLeafId];
        end;

      AmbToolForm.CurrLeafId:=Self.CameraLeafId;
      AmbToolForm.CurrLeafInfo:=Self.lpCameraLeaf;
      AmbToolForm.isHDRMode:=Self.isModeHDR;
      AmbToolForm.CurrAmbList:=lpCurrAmbList;

      for i:=0 to (lpCurrAmbList.SampleCount - 1) do
        begin
          if (isNotFrustumBBoxIntersection(lpCurrAmbList.CubeList[i].BBOXf) = False)
          then Self.AmbCubeIndexToRender[i]:=True;
        end;
    end;

  for i:=1 to (Self.Bsp30.CountLeafs - 1) do
    begin
      // For each visible VisLeaf for Camera VisLeaf by PVS Table
      if (Self.LeafIndexToRender[i] = False) then Continue;
      tmpVisLeafInfo:=@Self.Bsp30.VisLeafInfos[i];

      // First test if VisLeaf touch Frustum
      if (isNotFrustumBBoxIntersection(tmpVisLeafInfo.BBOXf)) then Continue;

      // 1. Get visible WorldBrush Faces for tmpVisLeaf
      if (Self.ShowWorldBrushesMenu.Checked) then
        begin
          for j:=0 to (tmpVisLeafInfo.CountFaces - 1) do
            begin
              k:=tmpVisLeafInfo.FaceInfoIndex[j];

              // test if Face Polygon intersect six Frustum Polygons
              if (Self.isNotFaceFrustumIntersection(@Self.Bsp30.FaceInfos[k]) = False) then
                begin
                  Self.WorldFacesIndexToRender[k]:=True;
                  Inc(Self.RenderFacesTrigCount, Self.Bsp30.FaceInfos[k].CountTriangles);
                end;
            end;
        end;

      // 2. Get visible EntityBrush Faces
      if (Self.ShowEntBrushesMenu.Checked) then
        begin
          for j:=0 to (tmpVisLeafInfo.CountEntBrushes - 1) do
            begin
              k:=tmpVisLeafInfo.EntBrushIndex[j];

              // Entity Brush can cover more than one VisLeaf
              if (Self.EntityFacesIndexToRender[k]) then Continue;

              // test if Face Polygon intersect six Frustum Polygons
              if (Self.isNotFaceFrustumIntersection(@Self.Bsp30.FaceInfos[k]) = False) then
                begin
                  Self.EntityFacesIndexToRender[k]:=True;
                  Inc(Self.RenderFacesTrigCount, Self.Bsp30.FaceInfos[k].CountTriangles);
                end;
            end;
        end;

      // 3. Get visible Displacements
      if (Self.ShowDisplacementsMenu.Checked) then
        begin
          for j:=0 to (tmpVisLeafInfo.CountDisplaments - 1) do
            begin
              k:=tmpVisLeafInfo.DispIndex[j];

              // Displament can cover more then one VisLeaf
              if (Self.DisplamentsIndexToRender[k]) then Continue;

              // test if Displament BBOX intersect six Frustum Polygons
              if (isNotFrustumBBoxIntersection(Self.Bsp30.DispRenderInfo[k].BBOXf) = False) then
                begin
                  Self.DisplamentsIndexToRender[k]:=True;
                  Inc(Self.RenderDispTrigCount, GetDispTriagFrustumIntersection(
                    @Self.Bsp30.DispRenderInfo[k]));
                end;
            end;
        end;
    end;
  {$R+}
end;

procedure TMainForm.do_movement(const Offset: GLfloat);
var
  i, CurrClusterId: Integer;
begin
  {$R-}
  if (Self.PressedKeys[OrdW]) then Self.Camera.StepForward(Offset);
  if (Self.PressedKeys[OrdS]) then Self.Camera.StepBackward(Offset);
  if (Self.PressedKeys[OrdA]) then Self.Camera.StepLeft(Offset);
  if (Self.PressedKeys[OrdD]) then Self.Camera.StepRight(Offset);


  if (Self.isBspLoad) then
    begin
      Self.CameraLeafId:=GetLeafIndexByPoint(Self.Bsp30.NodeInfos,
        Self.Camera.ViewPosition, Self.Bsp30.RootIndex);

      if (Self.CameraLeafId <> Self.CameraLastLeafId) then
        begin
          Self.CameraLastLeafId:=Self.CameraLeafId;
          Self.SelectedAmbCubeIndex:=-1;
          Unit3.AmbToolForm.SelectedAmbCubeIndex:=-1;
          Unit3.AmbToolForm.UpdateAmbVisualInfo();

          Self.CameraLeafId:=GetLeafIndexByPoint(Self.Bsp30.NodeInfos,
            Self.Camera.ViewPosition, Self.Bsp30.RootIndex);
          Self.lpCameraLeaf:=@Self.Bsp30.VisLeafInfos[Self.CameraLeafId];
          GetSizeBBOXf(@Self.lpCameraLeaf.BBOXf, @Self.ScaleForBBOX);

          ZeroFillChar(@Self.LeafIndexToRender[0], Self.Bsp30.CountLeafs);
          ZeroFillChar(@Self.WorldFacesIndexToRender[0], Self.Bsp30.CountFaces);
          ZeroFillChar(@Self.EntityFacesIndexToRender[0], Self.Bsp30.CountFaces);
          ZeroFillChar(@Self.DisplamentsIndexToRender[0], Self.Bsp30.CountDispInfos);
          ZeroFillChar(@Self.AmbCubeIndexToRender[0], MAX_AMBIENT_SAMPLES);
          Self.RenderFacesTrigCount:=0;

          if (Self.lpCameraLeaf.isValidToRender = False) then Exit;
          for i:=1 to (Self.Bsp30.CountLeafs - 1) do
            begin
              // For each VisLeaf on Map
              CurrClusterId:=Self.Bsp30.LeafLump[i].nClusterId;
              if (Self.Bsp30.VisLeafInfos[i].isValidToRender = False) then Continue;
              if (Self.lpCameraLeaf.PVS[CurrClusterId]) then Self.LeafIndexToRender[i]:=True;
            end;
        end;

      Self.GetFrustum();
      if (Self.lpCameraLeaf.isValidToRender) then Self.GetRenderList();
    end;
  {$R+}
end;

procedure TMainForm.GetMouseClickRay(const X, Y: Integer);
var
  tmpVertex3d: array[0..2] of GLdouble;
begin
  {$R-}
  // Get Start Ray Position
  Self.RayTracer.UnProjectVertex(X, Y, 0, @tmpVertex3d[0]);
  Self.MouseRay.Start.x:=tmpVertex3d[0];
  Self.MouseRay.Start.y:=tmpVertex3d[1];
  Self.MouseRay.Start.z:=tmpVertex3d[2];

  // Get End Ray Position and calculate Ray Dir
  Self.RayTracer.UnProjectVertex(X, Y, 1, @tmpVertex3d[0]);
  Self.MouseRay.Dir.x:=tmpVertex3d[0] - Self.MouseRay.Start.x;
  Self.MouseRay.Dir.y:=tmpVertex3d[1] - Self.MouseRay.Start.y;
  Self.MouseRay.Dir.z:=tmpVertex3d[2] - Self.MouseRay.Start.z;

  // Normalize Ray Dir
  NormalizeVec3f(@Self.MouseRay.Dir);
  {$R+}
end;

procedure TMainForm.GetFaceIndexByRay();
var
  i: Integer;
  Dist, tmpDist: GLfloat;
begin
  {$R-}
  Self.SelectedFaceIndex:=-1;
  if (Self.isBspLoad = False) then Exit;

  Dist:=MaxRender + 1;

  // WorldBrush Faces
  if (Self.ShowWorldBrushesMenu.Checked) then
    begin
      for i:=0 to (Self.Bsp30.CountFaces - 1) do
        begin
          if (Self.WorldFacesIndexToRender[i] = False) then Continue;

          if (GetRayFaceIntersection(@Self.Bsp30.FaceInfos[i],
            Self.MouseRay, @tmpDist)) then
            begin
              if (tmpDist < Dist) then
                begin
                  Dist:=tmpDist;
                  Self.SelectedFaceIndex:=i;
                end;
            end;
        end;
    end;

  // EntityBrush Faces
  if (Self.ShowEntBrushesMenu.Checked) then
    begin
      for i:=0 to (Self.Bsp30.CountFaces - 1) do
        begin
          if (Self.EntityFacesIndexToRender[i] = False) then Continue;

          if (GetRayFaceIntersection(@Self.Bsp30.FaceInfos[i],
            Self.MouseRay, @tmpDist)) then
            begin
              if (tmpDist < Dist) then
                begin
                  Dist:=tmpDist;
                  Self.SelectedFaceIndex:=i;
                end;
            end;
        end;
    end;

  // Displacements Triangles
  if (Self.ShowDisplacementsMenu.Checked) then
    begin
      for i:=0 to (Self.Bsp30.CountDispInfos - 1) do
        begin
          if (Self.DisplamentsIndexToRender[i] = False) then Continue;

          if (isNotRayIntersectionBBOX(@Self.Bsp30.DispRenderInfo[i].BBOXf,
            @Self.MouseRay)) then Continue;

          if (GetRayDispIntersection(@Self.Bsp30.DispRenderInfo[i],
            Self.MouseRay, @tmpDist) >= 0) then
            begin
              if (tmpDist < Dist) then
                begin
                  Dist:=tmpDist;
                  Self.SelectedFaceIndex:=Self.Bsp30.DispInfoLump[i].MapFace;
                end;
            end;
        end;
    end;

  if (Self.SelectedFaceIndex >= 0) then
    begin
      FaceToolForm.FaceSelectedIndex:=Self.SelectedFaceIndex;
      FaceToolForm.CurrFace:=@Self.Bsp30.FaceLump[Self.SelectedFaceIndex];
      FaceToolForm.CurrFaceInfo:=@Self.Bsp30.FaceInfos[Self.SelectedFaceIndex];
      FaceToolForm.UpdateFaceVisualInfo();
    end
  else FaceToolForm.ClearFaceVisualInfo();
  {$R+}
end;

procedure TMainForm.GetAmbientCubeIndexByRay();
var
  i: Integer;
  CurrAmbList: PLeafAmbientInfo;
  Dist, tmpDist: GLfloat;
begin
  {$R-}
  Self.SelectedAmbCubeIndex:=-1;
  Self.lpCurrAmbCube:=nil;
  if (Self.isBspLoad = False) then Exit;
  if (Self.ShowAmbientCubeMenu.Checked = False) then Exit;

  if (Self.isModeHDR) then
    begin
      CurrAmbList:=@Self.Bsp30.AmbientInfoListHDR[Self.CameraLeafId];
    end
  else
    begin
      CurrAmbList:=@Self.Bsp30.AmbientInfoListLDR[Self.CameraLeafId];
    end;

  Dist:=MaxRender + 1;
  for i:=0 to (CurrAmbList.SampleCount - 1) do
    begin
      if (Self.AmbCubeIndexToRender[i] = False) then Continue;

      if (isNotRayIntersectionBBOX(@CurrAmbList.CubeList[i].BBOXf,
        @Self.MouseRay)) then Continue; //}

      tmpDist:=SqrDistTwoVec(
        CurrAmbList.CubeList[i].Position,
        Self.Camera.ViewPosition
      );
      if ((tmpDist < Sqr(Dist)) and (tmpDist > Sqr(AmbientCubeSize))) then
        begin
          Dist:=Sqrt(tmpDist);
          Self.SelectedAmbCubeIndex:=i;
        end;
    end;

  if (Self.SelectedAmbCubeIndex >= 0) then
    begin
      lpCurrAmbCube:=@CurrAmbList.CubeList[Self.SelectedAmbCubeIndex];
      AmbToolForm.SelectedAmbCubeIndex:=Self.SelectedAmbCubeIndex;
      //
      AmbToolForm.CurrLeafId:=Self.CameraLeafId;
      AmbToolForm.CurrLeafInfo:=Self.lpCameraLeaf;
      AmbToolForm.isHDRMode:=Self.isModeHDR;
      AmbToolForm.CurrAmbList:=CurrAmbList;
      AmbToolForm.UpdateAmbVisualInfo();
    end
  else AmbToolForm.ClearAmbVisualInfo();
  {$R+}
end;



procedure TMainForm.FormPaint(Sender: TObject);
var
  i: Integer;
  currentFrame: Int64;
  tmp: GLfloat;
begin
  {$R-}
  QueryPerformanceCounter(currentFrame);
  tmp:=currentFrame/Self.TimerFrequency;
  deltaTime:=tmp - lastFrame;
  lastFrame:=tmp;              

  Self.do_movement(CameraSpeed*deltaTime);
  Self.Camera.gluLookAtUpdate;
  Self.RayTracer.UpdateModelMatrix();
  glClear(glBufferClearBits);

  if (Self.isBspLoad) then
    begin
      glColor4fv(@Self.FaceDiffuseColor[0]);
      if (Self.WireframeRenderMenu.Checked) then glPolygonMode(GL_BACK, GL_LINE);

      // Render World Brush Faces
      if (Self.ShowWorldBrushesMenu.Checked) then
        begin
          for i:=0 to (Self.Bsp30.CountFaces - 1) do
            begin
              if (Self.WorldFacesIndexToRender[i] = False) then Continue;
              RenderFace(@Self.Bsp30.FaceInfos[i]);
            end; //}
        end;
        
      // Render EntBrush Faces
      if (Self.ShowEntBrushesMenu.Checked) then
        begin
          for i:=0 to (Self.Bsp30.CountFaces - 1) do
            begin
              if (Self.EntityFacesIndexToRender[i] = False) then Continue;
              RenderFace(@Self.Bsp30.FaceInfos[i]);
            end; //}
        end;

      // Render Displacements
      if (Self.ShowDisplacementsMenu.Checked) then
        begin
          for i:=0 to (Self.Bsp30.CountDispInfos - 1) do
            begin
              if (Self.DisplamentsIndexToRender[i] = False) then Continue;
              RenderDisplament(@Self.Bsp30.DispRenderInfo[i]);
            end;
        end;

      if (Self.WireframeRenderMenu.Checked) then glPolygonMode(GL_BACK, GL_FILL);
      glBindTexture(GL_TEXTURE_2D, 0);

      // Render Leaf Ambient
      if (Self.ShowAmbientCubeMenu.Checked) then
        begin
          if (Self.isModeHDR = False) then
            begin
              RenderAmbientCubeList(
                @Self.Bsp30.AmbientInfoListLDR[Self.CameraLeafId],
                @Self.AmbCubeIndexToRender[0]
              );
            end
          else
            begin
              RenderAmbientCubeList(
                @Self.Bsp30.AmbientInfoListHDR[Self.CameraLeafId],
                @Self.AmbCubeIndexToRender[0]
              );
            end;
        end;

      // Render Selected Leaf Cube
      if (Self.SelectedAmbCubeIndex >= 0) then
        begin
          glPushMatrix();
          glTranslatef(
            Self.lpCurrAmbCube.BBOXf.vMin.x - 1,
            Self.lpCurrAmbCube.BBOXf.vMin.y - 1,
            Self.lpCurrAmbCube.BBOXf.vMin.z - 1
          );
          glScalef(
            AmbientCubeSize + 2,
            AmbientCubeSize + 2,
            AmbientCubeSize + 2
          );

          glColor4fv(@AmbientCubeSelectedColor[0]);
          glCallList(Self.BaseCubeLeafWireframeList);
          glPopMatrix();
        end;

      // Render Selected Face
      if (Self.SelectedFaceIndex >= 0) then
        begin
          glPushMatrix();
          glTranslatef(
            Self.Bsp30.FaceInfos[Self.SelectedFaceIndex].Plane.vNormal.x,
            Self.Bsp30.FaceInfos[Self.SelectedFaceIndex].Plane.vNormal.y,
            Self.Bsp30.FaceInfos[Self.SelectedFaceIndex].Plane.vNormal.z);
          RenderSelectedFace(@Self.Bsp30.FaceInfos[Self.SelectedFaceIndex],
            Self.FaceSelectedColor);
          glPopMatrix();
        end;

      // Render "Camera VisLeaf"
      if (Self.CameraLeafId > 0) then
        begin
          glPushMatrix();
          glTranslatef(
            Self.lpCameraLeaf.BBOXf.vMin.x,
            Self.lpCameraLeaf.BBOXf.vMin.y,
            Self.lpCameraLeaf.BBOXf.vMin.z
          );
          glScalef(
            Self.ScaleForBBOX.x,
            Self.ScaleForBBOX.y,
            Self.ScaleForBBOX.z
          );

          if (Self.lpCameraLeaf.isValidToRender) then glColor4fv(@LeafRenderColor[0])
          else glColor4fv(@LeafRenderColorEmpity[0]);

          glCallList(Self.BaseCubeLeafWireframeList);
          glPopMatrix();
        end;

      // Render Global Map WorldBrush BBOX (total Hammer vmf Map BBOX)
      glPushMatrix();
      glTranslatef(
        Self.Bsp30.ModelLump[0].vMin.x,
        Self.Bsp30.ModelLump[0].vMin.y,
        Self.Bsp30.ModelLump[0].vMin.z
      );
      glScalef(
        Self.Bsp30.ScaleForMapBBOX.x,
        Self.Bsp30.ScaleForMapBBOX.y,
        Self.Bsp30.ScaleForMapBBOX.z
      );
      glColor4fv(@VmfBBOXColor[0]);

      glCallList(Self.BaseCubeLeafWireframeList);
      glPopMatrix();
    end;

  // Render Help Orts and Grid at center of Scence
  glCallList(Self.OrtsListIndex);
  glCallList(Self.StartGridLIndex);

  if (isCanRenderMainForm) then
    begin
      InvalidateRect(Self.Handle, nil, False);
      SwapBuffers(Self.Canvas.Handle);
    end
  else
    begin
      Self.Canvas.Font.Height:=24;
      Self.Canvas.TextOut((Self.ClientWidth div 2) - 200, (Self.ClientHeight div 2) - 20,
        'CLICK ON FORM FOR ACTIVE RENDER SCENCE');
    end;

  //Self.RenderTimer.TimerStop;
  Dec(Self.tickCount);
  if (Self.tickCount <= 0) then
    begin
      Self.tickCount:=MAX_TICKCOUNT;

      Self.StatusBar.Panels.Items[0].Text:=' FPS '
        + FloatToStrF(1/deltaTime, ffFixed, 6, 1);
      Self.StatusBar.Panels.Items[1].Text:=VecToStr(Self.Camera.ViewPosition);
      if (Self.isBspLoad) then
        begin
          Self.StatusBar.Panels.Items[2].Text:='Camera in Leaf: '
            + IntToStr(Self.CameraLeafId);
          Self.StatusBar.Panels.Items[4].Text:='Render Triangles: '
            + IntToStr(Self.RenderFacesTrigCount + Self.RenderDispTrigCount);
        end;
      Self.StatusBar.Update;

      if (Assigned(FaceToolForm)) then
        begin
          //FaceToolForm.UpdateFaceVisualInfo();
          FaceToolForm.Update();

          if (FaceToolForm.isNeedToneMapping) then
            begin
              FaceToolForm.isNeedToneMapping:=False;
              Self.ToneMapUpdate();
            end;
        end;

      if (Assigned(AmbToolForm)) then
        begin
          AmbToolForm.Update();

          AmbToolForm.CameraPos:=Self.Camera.ViewPosition;
          AmbToolForm.CameraDir:=Self.Camera.ViewDirection;
          if (Self.isBspLoad) then
            begin
              if (Self.lpCameraLeaf.isValidToRender) then
                AmbToolForm.UpdateFinalColor();
            end;
        end;
    end;
  {$R+}
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  {$R-}
  Self.UpdateOpenGLViewport(MaxRender);
  Self.RayTracer.UpdateViewPort();
  Self.RayTracer.UpdateProjectMatrix();
  {$R+}
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {$R-}
  if (mbLeft = Button) then Self.isLeftMouseClicked:=True;
  if (mbRight = Button) then
    begin
      Self.isRightMouseClicked:=True;
      Self.GetMouseClickRay(X, Y);
      if (Self.ShowAmbientCubeMenu.Checked) then
        begin
          Self.GetAmbientCubeIndexByRay();
          if (Self.SelectedAmbCubeIndex <= 0) then Self.GetFaceIndexByRay();
        end
      else
        begin
          Self.GetFaceIndexByRay();
        end;
    end;
  {$R+}
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  isViewDirChanged: Boolean;
begin
  {$R-}
  if (Self.isLeftMouseClicked) then
    begin
      isViewDirChanged:=False;
      if (X <> Self.mdx) then
        begin
          Self.Camera.UpDateViewDirectionByMouseX((X - Self.mdx)*MFrec);
          isViewDirChanged:=True;
        end;
      if (Y <> Self.mdy) then
        begin
          Self.Camera.UpDateViewDirectionByMouseY((Self.mdy - Y)*MFrec);
          isViewDirChanged:=True;
        end;

      if (isViewDirChanged) then
        begin
          Self.GetFrustum();
          if (Self.isBspLoad) then
            begin
              if (Self.lpCameraLeaf.isValidToRender) then Self.GetRenderList();
            end;
          if (Self.MapFog.Enable) then
            begin
              Self.MapFog.UpdateColorByViewDir(Self.Camera.ViewDirection);
            end;
        end;
    end;
  Self.mdx:=X;
  Self.mdy:=Y;
  {$R+}
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {$R-}
  if (mbLeft = Button) then Self.isLeftMouseClicked:=False;
  if (mbRight = Button) then Self.isRightMouseClicked:=False;
  {$R+}
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$R-}
  if (Key < 1024) then Self.PressedKeys[Ord(Key)]:=True;

  if (Self.isBspLoad = False) then Exit;

  if (Ord(Key) = OrdF) then
    begin
      Inc(Self.StyleRenderIndex);
      if (Self.StyleRenderIndex > 3) then Self.StyleRenderIndex:=0;
      Unit2.FaceToolForm.SelectedStyle:=Self.StyleRenderIndex;

      Self.ChangeLmpMode();
      Self.StatusBar.Panels.Items[3].Text:='Style page: '
        + IntToStr(Self.StyleRenderIndex);
    end;

  if (Ord(Key) = OrdG) then
    begin
      Self.isModeHDR:=not (Self.isModeHDR);
      if (Self.Bsp30.isHDR = False) then Self.isModeHDR:=False;
      if (Self.Bsp30.isLDR = False) then Self.isModeHDR:=True;
      Unit2.FaceToolForm.isHDRMode:=Self.isModeHDR;
      Unit3.AmbToolForm.isHDRMode:=Self.isModeHDR;

      Self.SelectedAmbCubeIndex:=-1;
      Self.lpCurrAmbCube:=nil;
      Unit3.AmbToolForm.SelectedAmbCubeIndex:=-1;
      Unit3.AmbToolForm.UpdateAmbVisualInfo();

      Self.ChangeLmpMode();
      if (Self.isModeHDR) then Self.StatusBar.Panels.Items[5].Text:='Light Mode: HDR'
      else Self.StatusBar.Panels.Items[5].Text:='Light Mode: LDR';

      Unit2.FaceToolForm.UpdateFaceVisualInfo();
      Unit3.AmbToolForm.UpdateAmbVisualInfo();
    end;
  {$R+}  
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$R-}
  if (Key < 1024) then Self.PressedKeys[Ord(Key)]:=False;
  {$R+}
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
  {$R-}
  if (isCanRenderMainForm = False) then
    begin
      isCanRenderMainForm:=True;
      Self.Paint();
    end;
  {$R+}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  {$R-}
  if (Assigned(FaceToolForm) = False) then
    begin
      FaceToolForm:=Unit2.TFaceToolForm.Create(Self);
    end;
  FaceToolForm.Show;
  FaceToolForm.Update;

  FaceToolForm.lpToneMapScale:=@Self.ToneMapScale;

  if (Assigned(AmbToolForm) = False) then
    begin
      AmbToolForm:=Unit3.TAmbToolForm.Create(Self);
    end;
  AmbToolForm.Show;
  AmbToolForm.Update;
  AmbToolForm.isCanRenderMainForm:=@isCanRenderMainForm;
  {$R+}
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  {$R-}
  if (Assigned(FaceToolForm)) then
    begin
      FaceToolForm.Hide;
    end;

  if (Assigned(AmbToolForm)) then
    begin
      AmbToolForm.Hide;
    end;
  {$R+}
end;



procedure TMainForm.OpenMapMenuClick(Sender: TObject);
begin
  {$R-}
  isCanRenderMainForm:=False;
  if (Self.OpenDialogBsp.Execute) then
    begin
      Self.isBspLoad:=LoadBSP30FromFile(Self.OpenDialogBsp.FileName, Self.Bsp30);
      if (Self.isBspLoad = False) then
        begin
          ShowMessage('Error load Map: ' + LF
            + ShowLoadBSPMapError(Self.Bsp30.LoadState)
          );
          FreeMapBSP(Self.Bsp30);
        end
      else
        begin
          Self.Caption:=Self.OpenDialogBsp.FileName;

          Self.OpenMapMenu.Enabled:=False;
          Self.CloseMapMenu.Enabled:=True;
          Self.SaveMapMenu.Enabled:=True;

          Self.FirstSpawnEntityId:=FindFirstSpawnEntity(Self.Bsp30.Entities,
            Self.Bsp30.CountEntities);
          if (Self.FirstSpawnEntityId >= 1) then
            begin
              Self.Camera.ResetCamera(
                Self.Bsp30.Entities[Self.FirstSpawnEntityId].Origin,
                Self.Bsp30.Entities[Self.FirstSpawnEntityId].Angles.x*AngleToRadian,
                Self.Bsp30.Entities[Self.FirstSpawnEntityId].Angles.y*AngleToRadian - Pi/2
              );
            end;

          Self.CameraLeafId:=0;
          Self.lpCameraLeaf:=@Self.Bsp30.VisLeafInfos[0];

          SetLength(Self.WorldFacesIndexToRender, Self.Bsp30.CountFaces);
          SetLength(Self.EntityFacesIndexToRender, Self.Bsp30.CountFaces);
          SetLength(Self.DisplamentsIndexToRender, Self.Bsp30.CountDispInfos);
          SetLength(Self.LeafIndexToRender, Self.Bsp30.CountLeafs);
          ZeroFillChar(@Self.AmbCubeIndexToRender[0], MAX_AMBIENT_SAMPLES);

          Self.FogEntityId:=FindEntityByClassName(
            Self.Bsp30.Entities,
            Self.Bsp30.CountEntities,
            ClassNameFog
          );
          if (Self.FogEntityId > 1) then
            begin
              Self.isFogAviable:=Self.MapFog.UpdateFogByEntity(
                Self.Bsp30.Entities[Self.FogEntityId]
              );
              Self.MapFog.UpdateColorByViewDir(Self.Camera.ViewDirection);
            end
          else Self.isFogAviable:=False;

          Self.isModeHDR:=False;
          if (Self.Bsp30.isLDR = False) then Self.isModeHDR:=Self.Bsp30.isHDR;
          Unit2.FaceToolForm.isHDRMode:=Self.isModeHDR;
          Unit2.FaceToolForm.isAviableHDR:=Self.Bsp30.isHDR;
          Unit2.FaceToolForm.isAviableLDR:=Self.Bsp30.isLDR;
          Unit2.FaceToolForm.SelectedStyle:=Self.StyleRenderIndex;
          Unit3.AmbToolForm.isHDRMode:=Self.isModeHDR;

          // Make Render List
          Self.ToneMapUpdate();
          Self.ChangeLmpMode();
          
          if (Self.isModeHDR) then Self.StatusBar.Panels.Items[5].Text:='Light Mode: HDR'
          else Self.StatusBar.Panels.Items[5].Text:='Light Mode: LDR';
        end;
    end;
  {$R+}
end;

procedure TMainForm.CloseMapMenuClick(Sender: TObject);
begin
  {$R-}
  Self.isBspLoad:=False;
  Self.Caption:=MainFormCaption;

  Self.OpenMapMenu.Enabled:=True;
  Self.CloseMapMenu.Enabled:=False;
  Self.SaveMapMenu.Enabled:=False;

  FreeMapBSP(Self.Bsp30);
  SetLength(Self.WorldFacesIndexToRender, 0);
  SetLength(Self.EntityFacesIndexToRender, 0);
  SetLength(Self.DisplamentsIndexToRender, 0);
  SetLength(Self.LeafIndexToRender, 0);
  ZeroFillChar(@Self.AmbCubeIndexToRender[0], MAX_AMBIENT_SAMPLES);

  Self.CameraLeafId:=-1;
  Self.CameraLastLeafId:=-1;
  Self.FirstSpawnEntityId:=0;
  Self.MapFog.Enable:=False;
  Self.FogEntityId:=-1;
  Self.SelectedFaceIndex:=-1;
  Self.SelectedAmbCubeIndex:=-1;
  Self.StyleRenderIndex:=0;
  Self.RenderFacesTrigCount:=0;
  Self.RenderDispTrigCount:=0;
  Self.isModeHDR:=False;
  Self.lpCurrAmbCube:=nil;
  Self.lpCameraLeaf:=nil;

  Unit2.FaceToolForm.ClearFaceVisualInfo();
  Unit3.AmbToolForm.ClearAmbVisualInfo();
  {$R+}
end;

procedure TMainForm.SaveMapMenuClick(Sender: TObject);
var
  MapFile: File;
  i, j, k: Integer;
begin
  {$R-}
  if (Self.isBspLoad = False) then Exit;

  isCanRenderMainForm:=False;
  if (Self.SaveDialogBsp.Execute) then
    begin
      AssignFile(MapFile, Self.SaveDialogBsp.FileName);
      Rewrite(MapFile, 1);

      Seek(MapFile, 0);
      BlockWrite(MapFile, (@Self.Bsp30.FileRawData[0])^, Self.Bsp30.MapFileSize);

      if (Self.Bsp30.isLDR) then
        begin
          // Save LDR Lightmaps
          Seek(MapFile, Self.Bsp30.MapHeader.LumpsInfo[LUMP_LIGHTING].nOffset);
          BlockWrite(MapFile, (@Self.Bsp30.LightingLump[0])^,
            Self.Bsp30.MapHeader.LumpsInfo[LUMP_LIGHTING].nLength);

          // Save LDR Ambient light
          for i:=0 to (Self.Bsp30.CountLeafs - 1) do
            begin
              k:=Self.Bsp30.AmbientInfoListLDR[i].FirstSampleIndex;
              for j:=0 to (Self.Bsp30.AmbientInfoListLDR[i].SampleCount - 1) do
                begin
                  Self.Bsp30.LeafAmbientListLDR[j + k].colors:=
                    Self.Bsp30.AmbientInfoListLDR[i].CubeList[j].RawColor;
                  Self.Bsp30.LeafAmbientListLDR[j + k].x:=
                    Self.Bsp30.AmbientInfoListLDR[i].CubeList[j].RawPosition.x;
                  Self.Bsp30.LeafAmbientListLDR[j + k].y:=
                    Self.Bsp30.AmbientInfoListLDR[i].CubeList[j].RawPosition.y;
                  Self.Bsp30.LeafAmbientListLDR[j + k].z:=
                    Self.Bsp30.AmbientInfoListLDR[i].CubeList[j].RawPosition.z;
                end;
            end;
          Seek(MapFile, Self.Bsp30.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING].nOffset);
          BlockWrite(MapFile, (@Self.Bsp30.LeafAmbientListLDR[0])^,
            Self.Bsp30.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING].nLength);
        end;
      if (Self.Bsp30.isHDR) then
        begin
          // Save HDR Lightmaps
          Seek(MapFile, Self.Bsp30.MapHeader.LumpsInfo[LUMP_LIGHTING_HDR].nOffset);
          BlockWrite(MapFile, (@Self.Bsp30.LightingHDRLump[0])^,
            Self.Bsp30.MapHeader.LumpsInfo[LUMP_LIGHTING_HDR].nLength);

          // Save HDR Ambient light
          for i:=0 to (Self.Bsp30.CountLeafs - 1) do
            begin
              k:=Self.Bsp30.AmbientInfoListHDR[i].FirstSampleIndex;
              for j:=0 to (Self.Bsp30.AmbientInfoListHDR[i].SampleCount - 1) do
                begin
                  Self.Bsp30.LeafAmbientListHDR[j + k].colors:=
                    Self.Bsp30.AmbientInfoListHDR[i].CubeList[j].RawColor;
                  Self.Bsp30.LeafAmbientListHDR[j + k].x:=
                    Self.Bsp30.AmbientInfoListHDR[i].CubeList[j].RawPosition.x;
                  Self.Bsp30.LeafAmbientListHDR[j + k].y:=
                    Self.Bsp30.AmbientInfoListHDR[i].CubeList[j].RawPosition.y;
                  Self.Bsp30.LeafAmbientListHDR[j + k].z:=
                    Self.Bsp30.AmbientInfoListHDR[i].CubeList[j].RawPosition.z;
                end;
            end;
          Seek(MapFile, Self.Bsp30.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR].nOffset);
          BlockWrite(MapFile, (@Self.Bsp30.LeafAmbientListHDR[0])^,
            Self.Bsp30.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR].nLength);
        end;

      CloseFile(MapFile);
    end;
  {$R+}
end;

procedure TMainForm.ResetCameraMenuClick(Sender: TObject);
begin
  {$R-}
  if (Self.isBspLoad) then
    begin
      if (Self.FirstSpawnEntityId >= 1) then
        begin
          Self.Camera.ResetCamera(
            Self.Bsp30.Entities[Self.FirstSpawnEntityId].Origin,
            Self.Bsp30.Entities[Self.FirstSpawnEntityId].Angles.x*AngleToRadian,
            Self.Bsp30.Entities[Self.FirstSpawnEntityId].Angles.y*AngleToRadian - Pi/2
          );
        end
      else
        begin
          Self.Camera.ResetCamera(
            DefaultCameraPos,
            DefaultCameraPolarAngle,
            DefaultCameraAzimutalAngle
          );
        end;
    end
  else
    begin
      Self.Camera.ResetCamera(
        DefaultCameraPos,
        DefaultCameraPolarAngle,
        DefaultCameraAzimutalAngle
      );
    end;
  {$R+}
end;

procedure TMainForm.ShowWorldBrushesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowWorldBrushesMenu.Checked:=not Self.ShowWorldBrushesMenu.Checked;
  Self.GetRenderList();
  {$R+}
end;

procedure TMainForm.ShowEntBrushesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowEntBrushesMenu.Checked:=not Self.ShowEntBrushesMenu.Checked;
  Self.GetRenderList();
  {$R+}
end;

procedure TMainForm.ShowDisplacementsMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowDisplacementsMenu.Checked:=not Self.ShowDisplacementsMenu.Checked;
  Self.GetRenderList();
  {$R+}
end;

procedure TMainForm.ShowAmbientCubeMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowAmbientCubeMenu.Checked:=not Self.ShowAmbientCubeMenu.Checked;
  Self.GetRenderList();
  {$R+}
end;

procedure TMainForm.WireframeRenderMenuClick(Sender: TObject);
begin
  {$R-}
  Self.WireframeRenderMenu.Checked:=not Self.WireframeRenderMenu.Checked;
  {$R+}
end;

procedure TMainForm.WallhackRenderModeMenuClick(Sender: TObject);
begin
  {$R-}
  if (Self.WallhackRenderModeMenu.Checked) then
    begin
      // Disable WallHack mode
      Self.WallhackRenderModeMenu.Checked:=False;
      Self.FaceDiffuseColor[3]:=1.0;
    end
  else
    begin
      // Enable WallHack mode
      Self.WallhackRenderModeMenu.Checked:=True;
      Self.FaceDiffuseColor[3]:=0.5;
    end;
  {$R+}
end;

procedure TMainForm.EnableFogMenuClick(Sender: TObject);
begin
  {$R-}
  Self.EnableFogMenu.Checked:=not Self.EnableFogMenu.Checked;

  if (Self.EnableFogMenu.Checked and Self.isFogAviable) then Self.MapFog.Enable:=True
  else Self.MapFog.Enable:=False;
  {$R+}
end;


procedure TMainForm.ShowHeaderMenuClick(Sender: TObject);
begin
  {$R-}
  if (Self.isBspLoad) then
    begin
      ShowMessage('Size of Map = ' + IntToStr(Self.Bsp30.MapFileSize) + ' Bytes;' + LF
        + ShowMapHeaderInfo(Self.Bsp30.MapHeader) + LF
        + 'Entities (with "worldspawn") = ' + IntToStr(Self.Bsp30.CountEntities) + LF
        + 'Count Clusters = ' + IntToStr(Self.Bsp30.CountClusters) + LF
        + 'is Fog Aviable: ' + BoolToStr(Self.isFogAviable, True)
      );
    end;
  {$R+}
end;

procedure TMainForm.SetClearColorMenuClick(Sender: TObject);
begin
  {$R-}
  isCanRenderMainForm:=False;
  if (Self.ColorDialog.Execute) then
    begin
      Self.ClearColor[0]:=GetRValue(Self.ColorDialog.Color)/255;
      Self.ClearColor[1]:=GetGValue(Self.ColorDialog.Color)/255;
      Self.ClearColor[2]:=GetBValue(Self.ColorDialog.Color)/255;

      glClearColor(
        Self.ClearColor[0],
        Self.ClearColor[1],
        Self.ClearColor[2],
        Self.ClearColor[3]
      );
    end;
  {$R+}
end;

procedure TMainForm.SetFaceDiffuseColorMenuClick(Sender: TObject);
begin
  {$R-}
  isCanRenderMainForm:=False;
  if (Self.ColorDialog.Execute) then
    begin
      Self.FaceDiffuseColor[0]:=GetRValue(Self.ColorDialog.Color)/255;
      Self.FaceDiffuseColor[1]:=GetGValue(Self.ColorDialog.Color)/255;
      Self.FaceDiffuseColor[2]:=GetBValue(Self.ColorDialog.Color)/255;
    end;
  {$R+}
end;

procedure TMainForm.SetFaceSelectedColorMenuClick(Sender: TObject);
begin
  {$R-}
  isCanRenderMainForm:=False;
  if (Self.ColorDialog.Execute) then
    begin
      Self.FaceSelectedColor[0]:=GetRValue(Self.ColorDialog.Color)/255;
      Self.FaceSelectedColor[1]:=GetGValue(Self.ColorDialog.Color)/255;
      Self.FaceSelectedColor[2]:=GetBValue(Self.ColorDialog.Color)/255;
      Self.FaceSelectedColor[3]:=0.3;
    end;
  {$R+}
end;

procedure TMainForm.ShowFaceToolMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowFaceToolMenu.Checked:=not Self.ShowFaceToolMenu.Checked;
  if (Self.ShowFaceToolMenu.Checked) then Unit2.FaceToolForm.Show()
  else Unit2.FaceToolForm.Hide();
  {$R+}
end;

procedure TMainForm.ShowAmbToolMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ShowAmbToolMenu.Checked:=not Self.ShowAmbToolMenu.Checked;
  if (Self.ShowAmbToolMenu.Checked) then Unit3.AmbToolForm.Show()
  else Unit3.AmbToolForm.Hide();
  {$R+}
end;


procedure TMainForm.HelpMenuClick(Sender: TObject);
begin
  {$R-}
  ShowMessage(HelpStr);
  {$R+}
end;

procedure TMainForm.AboutMenuClick(Sender: TObject);
begin
  {$R-}
  ShowMessage(AboutStr + Opengl.glGetString(GL_VERSION));
  {$R+}
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$R-}
  isCanRenderMainForm:=False;
  if (Self.isBspLoad) then
    begin
      FreeMapBSP(Self.Bsp30);
      SetLength(Self.WorldFacesIndexToRender, 0);
      SetLength(Self.EntityFacesIndexToRender, 0);
      SetLength(Self.DisplamentsIndexToRender, 0);
      SetLength(Self.LeafIndexToRender, 0);
    end;

  glDeleteLists(Self.OrtsListIndex, 1);
  glDeleteLists(Self.StartGridLIndex, 1);
  glDeleteLists(Self.BaseCubeLeafWireframeList, 1);

  //Self.RenderTimer.DeleteTimer();
  Self.RayTracer.DeleteRayTracer();
  Self.Camera.DeleteCamera();
  Self.MapFog.DeleteFog();
  wglDeleteContext(Self.HRC);
  {$R+}
end;

end.
