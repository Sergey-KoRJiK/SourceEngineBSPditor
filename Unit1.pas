unit Unit1;

// Copyright (c) 2020-2025 Sergey-KoRJiK, Belarus

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
  ExtCtrls,
  StdCtrls,
  Grids,
  ValEdit,
  Spin,
  {}
  Math,
  OpenGL,
  UnitOpenGLext,
  UnitUserTypes,
  UnitVec,
  {}
  UnitQueryPerformanceTimer,
	UnitRenderTimerManager,
	UnitRenderingContextManager,
  UnitOpenGLFPSCamera,
	UnitShaderManager,
  UnitBufferObjectManager,
	UnitVertexBufferArrayManager,
  UnitMegatextureManager,
  UnitOpenGLErrorManager,
  {}
  UnitBSPstruct,
  UnitEntity,
  UnitDispMisc,
  UnitVTFMeowLib,
  UnitImageTGA;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    OptionsMenu: TMenuItem;
    HelpMenu: TMenuItem;
    AboutMenu: TMenuItem;
    ResetCameraMenu: TMenuItem;
    OpenDialogBsp: TOpenDialog;
    SaveDialogBsp: TSaveDialog;
    LoadMapMenu: TMenuItem;
    CloseMapMenu: TMenuItem;
    LineSplitOptionsMenu: TMenuItem;
    ShowHeaderMenu: TMenuItem;
    WireframeEntBrushesMenu: TMenuItem;
    SaveMapMenu: TMenuItem;
    ColorDialog: TColorDialog;
    SetSelectedFaceColorMenu: TMenuItem;
    LineSplitFileMenu: TMenuItem;
    OpenDialogVTF: TOpenDialog;
    SaveDialogVTF: TSaveDialog;
    RenderBBOXVisLeaf: TMenuItem;
    RenderMenu: TMenuItem;
    PanelRT: TPanel;
    LabelCameraPos: TLabel;
    LabelCameraLeafId: TLabel;
    LabelStylePage: TLabel;
    LabelCameraFPS: TLabel;
    LmpPixelModeMenu: TMenuItem;
    SetWireframeFaceColorMenu: TMenuItem;
    WireframeHighlighEntBrushesMenu: TMenuItem;
    CloseMenu: TMenuItem;
    DisableLightmapsMenu: TMenuItem;
    DisableTexturesMenu: TMenuItem;
    ShowOpenGLInformationMenu: TMenuItem;
    GotoMenu: TMenuItem;
    GotoCamPosSubMenu: TMenuItem;
    GotoFaceIdSubmenu: TMenuItem;
    GotoVisLeafIdSubMenu: TMenuItem;
    GotoBModelIdSubMenu: TMenuItem;
    GotoEntTGNSubMenu: TMenuItem;
    DrawTriggersMenu: TMenuItem;
    DrawFaceContourMenu: TMenuItem;
    TexPixelModeMenu: TMenuItem;
    DrawEntityBrushesMenu: TMenuItem;
    ShowLightStylesMenu: TMenuItem;
    SaveDialogTGA: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBoxFaceTexel: TGroupBox;
    LabelFaceTexUV: TStaticText;
    EditFaceTexUV: TStaticText;
    LabelFaceLmpUV: TStaticText;
    EditFaceLmpUV: TStaticText;
    GroupBoxFacePlane: TGroupBox;
    LabelFacePlaneX: TStaticText;
    EditFacePlaneX: TStaticText;
    LabelFacePlaneY: TStaticText;
    EditFacePlaneY: TStaticText;
    LabelFacePlaneZ: TStaticText;
    EditFacePlaneZ: TStaticText;
    LabelFacePlaneD: TStaticText;
    EditFacePlaneD: TStaticText;
    LabelFacePlaneF: TStaticText;
    EditFacePlaneF: TStaticText;
    GroupBoxFaceInfo: TGroupBox;
    LabelFaceIndex: TStaticText;
    EditFaceIndex: TStaticText;
    LabelFaceBrushIndex: TStaticText;
    EditFaceBrushIndex: TStaticText;
    LabelFacePlaneIndex: TStaticText;
    EditFacePlaneIndex: TStaticText;
    LabelFaceCountVertex: TStaticText;
    EditFaceCountVertex: TStaticText;
    LabelFaceTexInfo: TStaticText;
    EditFaceTexInfo: TStaticText;
    EditFaceEntityName: TStaticText;
    EditFaceEntityClass: TStaticText;
    TabSheet3: TTabSheet;
    GroupBoxTextureInfo: TGroupBox;
    ImagePreviewBT: TImage;
    LabelTexName: TStaticText;
    EditTexName: TStaticText;
    EditTexSize: TStaticText;
    LabelTexSize: TStaticText;
    ButtonLoadTex: TButton;
    ButtonSaveTex: TButton;
    LabeTexIndex: TStaticText;
    EditTexIndex: TStaticText;
    ButtonDeleteTex: TButton;
    GroupBoxLightmapInfo: TGroupBox;
    LabelLmpSize: TStaticText;
    EditLmpSize: TStaticText;
    LabelLmpStyle1: TStaticText;
    EditLmpStyle1: TStaticText;
    LabelLmpStyle2: TStaticText;
    EditLmpStyle2: TStaticText;
    EditLmpStyle3: TStaticText;
    LabelLmpStyle3: TStaticText;
    RadioGroupLmp: TRadioGroup;
    ButtonLoadLmp: TButton;
    ButtonSaveLmp: TButton;
    ButtonDeleteLmp: TButton;
    ButtonAddLmp: TButton;
    TabSheet4: TTabSheet;
    GroupBoxProfile: TGroupBox;
    LabelProfile1: TStaticText;
    LabelProfile2: TStaticText;
    LabelProfile3: TStaticText;
    LabelProfile4: TStaticText;
    LabelProfile5: TStaticText;
    LabelProfile6: TStaticText;
    LabelLDRHDR: TLabel;
    BModelRenderColorAlphaMenu: TMenuItem;
    EditLmpStyle0: TStaticText;
    StaticText2: TStaticText;
    TrackBarExp: TTrackBar;
    LblLmpUserExp: TStaticText;
    BtnLmpExpZero: TButton;
    CheckBoxModeAtlas: TCheckBox;
    BtnAtlasPage: TSpinButton;
    LblAtlasPage: TStaticText;
    EditLmpRegion: TStaticText;
    ImageLmpPreview: TImage;
    CBLmpPreviewRGB: TCheckBox;
    EditLmpPixelR: TStaticText;
    StaticText4: TStaticText;
    StaticText1: TStaticText;
    EditLmpPixelG: TStaticText;
    StaticText6: TStaticText;
    EditLmpPixelB: TStaticText;
    StaticText8: TStaticText;
    EditLmpPixelE: TStaticText;
    EditLmpBump: TStaticText;
    BtnLmpBump: TSpinButton;
    StaticText3: TStaticText;
    DrawDispFaceMenu: TMenuItem;
    StaticText5: TStaticText;
    EditFaceDispID: TStaticText;
    StaticText7: TStaticText;
    EditFaceDispOrigin: TStaticText;
    MemoFaceVertex: TMemo;
    function  TestRequarementExtensions(): Boolean;
    procedure InitGL();
    procedure InitOrts();
    procedure FreeOrts();
    procedure InitCube();
    procedure DrawCube(const bbox: tBBOX3f);
    procedure FreeCube();
    procedure GetVisleafRenderList();
    procedure do_movement(const Offset: GLfloat);
    procedure GetFaceIndexByRay();
    procedure UpdatePreviewLightmap();
    procedure UpdateFaceVisualInfo();
    procedure ClearFaceVisualInfo();
    procedure GenerateLightmapMegatexture();
    procedure DrawScence(Sender: TObject);
    procedure DrawAtlas(Sender: TObject);
    //
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpMenuClick(Sender: TObject);
    procedure AboutMenuClick(Sender: TObject);
    procedure ResetCameraMenuClick(Sender: TObject);
    procedure LoadMapMenuClick(Sender: TObject);
    procedure CloseMapMenuClick(Sender: TObject);
    procedure ShowHeaderMenuClick(Sender: TObject);
    procedure WireframeEntBrushesMenuClick(Sender: TObject);
    procedure SaveMapMenuClick(Sender: TObject);
    procedure SetSelectedFaceColorMenuClick(Sender: TObject);
    procedure RenderBBOXVisLeafClick(Sender: TObject);
    procedure PanelRTResize(Sender: TObject);
    procedure PanelRTMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelRTMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelRTMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LmpPixelModeMenuClick(Sender: TObject);
    procedure SetWireframeFaceColorMenuClick(Sender: TObject);
    procedure WireframeHighlighEntBrushesMenuClick(Sender: TObject);
    procedure CloseMenuClick(Sender: TObject);
    procedure DisableLightmapsMenuClick(Sender: TObject);
    procedure DisableTexturesMenuClick(Sender: TObject);
    procedure ShowOpenGLInformationMenuClick(Sender: TObject);
    procedure GotoCamPosSubMenuClick(Sender: TObject);
    procedure GotoFaceIdSubmenuClick(Sender: TObject);
    procedure GotoVisLeafIdSubMenuClick(Sender: TObject);
    procedure GotoEntTGNSubMenuClick(Sender: TObject);
    procedure DrawTriggersMenuClick(Sender: TObject);
    procedure DrawFaceContourMenuClick(Sender: TObject);
    procedure TexPixelModeMenuClick(Sender: TObject);
    procedure DrawEntityBrushesMenuClick(Sender: TObject);
    procedure BModelRenderColorAlphaMenuClick(Sender: TObject);
    procedure GotoBModelIdSubMenuClick(Sender: TObject);
    procedure TrackBarExpChange(Sender: TObject);
    procedure BtnLmpExpZeroClick(Sender: TObject);
    procedure ButtonSaveLmpClick(Sender: TObject);
    procedure BtnAtlasPageDownClick(Sender: TObject);
    procedure BtnAtlasPageUpClick(Sender: TObject);
    procedure CBLmpPreviewRGBClick(Sender: TObject);
    procedure ImageLmpPreviewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BtnLmpBumpDownClick(Sender: TObject);
    procedure BtnLmpBumpUpClick(Sender: TObject);
    procedure DrawDispFaceMenuClick(Sender: TObject);
  private
    RenderContext       : CRenderingContextManager;
    RenderTimer         : CRenderTimerManager;
    ProfileTimer        : CQueryPerformanceTimer;

    Camera              : CFirtsPersonViewCamera;
    CameraMatrix        : tMat4f;
    WorkArea            : TRect;
    RenderRange         : GLfloat;
    FaceWireframeColor  : tColor4fv;
    FACEDRAW_USER       : Integer;

    MouseRay            : tRay;
    MousePos            : TPoint;
    MouseLastPos        : TPoint;
    isLeftMouseClicked  : ByteBool;
    isRightMouseClicked : ByteBool;
    PressedKeyW         : ByteBool;
    PressedKeyS         : ByteBool;
    PressedKeyA         : ByteBool;
    PressedKeyD         : ByteBool;
    PressedKeyShift     : ByteBool;

    FacePosVBO          : GLuint;
    FaceTexVBO          : GLuint;
    FaceLmpVBO          : array[0..1] of GLuint;
    FaceLmpCapsVBO      : array[0..1] of GLuint;
    FaceVAO             : array[0..1] of GLuint;
    DispPosVBO          : GLuint;
    DispVAO             : GLuint;
    LightmapMegatexture : CMegatextureManager;
    ShaderFaces         : CShaderManager; // World & Entity Faces
    ShaderSFaces        : CShaderManager; // user-selected Face
    ShaderDisps         : CShaderManager; // Displacements

    OrtsVBO, OrtsVAO    : GLuint;
    ShaderOrts          : CShaderManager;
    CubeVBO, CubeVAO    : GLuint;
    ShaderCube          : CShaderManager;

    SelectedAtlasID     : Integer;
    AtlasVAO, AtlasVBO  : Integer;

    procedure Idle(Sender: TObject; var Done: Boolean);
  public

  end;

const
  DefaultRenderRange  : GLfloat = 65536.0*1.8;
  FieldOfView         : GLfloat = 90.0;
  MouseFreq           : GLfloat = (Pi/180.0)/4.0;
  CameraSpeed         : array[False..True] of GLfloat = (512, 10*256); // per sec
  RenderInfoDelayUpd  : GLfloat = 0.25; // seconds
  //
  ClearColor          : tColor4fv = (0.01, 0.01, 0.01, 0.0);
  LeafRenderColor     : tColor4fv = (0.1, 0.1, 0.7, 1.0);
  LeafRenderColor2    : tColor4fv = (0.1, 0.7, 0.1, 0.3);
  LeafRenderColor3    : tColor4fv = (0.7, 0.1, 0.1, 1.0);
  //
  HelpStr: String = 'Rotate Camera: Left Mouse Button' + LF +
    'Move Camera forward/backward: keys W/S' + LF +
    'Step Camera Left/Right: keys A/D' + LF +
    'Orts: red X, blue Y, green Z' + LF +
    'Select Face: Right Mouse Button' + LF +
    'Change Lightmap Style Page: key F' + LF +
    'Change LDR\HDR Faces: key H' + LF +
    'Additional info showed in bottom Status Bar';
  AboutStr: String = 'Copyright (c) 2025 Sergey-KoRJiK, Belarus' + LF +
    'github.com/Sergey-KoRJiK' + LF +
    'Source BSP Editor and Viewer' + LF +
    'Program version: 1.4.1.1' + LF +
    'Version of you OpenGL: ';
  MainFormCaption: String = 'Source BSP Editor and Viewer';


var
  LastError: GLenum;
  // use for mark leaf/faces to render, idea from Quake 1
  RenderFrameIterator   : Byte = 0;
  CameraLeafId          : Integer = 0;
  CameraLastLeafId      : Integer = 0;
  FirstSpawnEntityId    : Integer = -1;
  lpCameraLeaf          : PLeafExt = nil;
  //
  // Render VisLeaf options
  FaceOcclusion         : Boolean = False;
  // Lightmap Face options
  SelectedFaceIndex     : Integer = -1;
  SelectedStyle         : Integer = 0;
  SelectedBump          : Integer = 0;
  CurrFaceExt           : PFaceExt = nil;
  CurrTraceInfo         : tTraceInfo;
  //
  BaseThumbnailBMP      : TBitmap;
  LmpThumbnailBMP       : TBitmap;

  ClusterIndexToRender  : AByte;
  BModelIndexToRender   : AByte;
  DispIndexToRender     : AByte;
  locPVS                : array[0..65535] of ByteBool; // Clusters !!!
  //
  isBspLoad: Boolean = False;
  Map: tMapBSP;


implementation

{$R *.dfm}



procedure TMainForm.FormCreate(Sender: TObject);
var
  sLog: String;
begin
  {$R-} 
  DecimalSeparator:='.'; // for parse entity vector fields
  Self.ProfileTimer:=CQueryPerformanceTimer.CreateTimer();

  Self.Caption:=MainFormCaption;
  Self.KeyPreview:=True;
  Self.isLeftMouseClicked:=False;
  Self.isRightMouseClicked:=False;
  Self.RenderRange:=DefaultRenderRange;
  Self.OpenDialogBsp.InitialDir:=GetCurrentDir;
  Self.OpenDialogVTF.InitialDir:=GetCurrentDir;
  Self.SaveDialogBsp.InitialDir:=GetCurrentDir;
  Self.SaveDialogVTF.InitialDir:=GetCurrentDir;
  //
  Self.PressedKeyW:=False;
  Self.PressedKeyS:=False;
  Self.PressedKeyA:=False;
  Self.PressedKeyD:=False;
  Self.PressedKeyShift:=False;
  //
  Self.ClearFaceVisualInfo();
  //
  Self.FaceWireframeColor[0]:=1.0;
  Self.FaceWireframeColor[1]:=0.0;
  Self.FaceWireframeColor[2]:=0.0;
  Self.FaceWireframeColor[3]:=1.0;

  Self.DoubleBuffered:=True;
  Self.PanelRT.DoubleBuffered:=True;
  Self.PanelRT.HandleNeeded();
  Self.RenderContext:=CRenderingContextManager.CreateManager();
  if (Self.RenderContext.CreateRenderingContext(Self.PanelRT.Handle, 24) = False) then
    begin
      ShowMessage('Error create OpenGL context!');
      Self.RenderContext.DeleteRenderingContext();
      Self.RenderContext.DeleteManager();
      Self.ProfileTimer.DeleteTimer();
      Application.ShowMainForm:=False;
      Application.Terminate;
    end;
  Self.RenderContext.MakeCurrent();

  Self.WorkArea.Left:=Self.Left;
  Self.WorkArea.Top:=Self.Top;
  Self.WorkArea.Right:=Self.Width + Self.Left;
  Self.WorkArea.Bottom:=Self.Height + Self.Top;
  if (SystemParametersInfo(SPI_GETWORKAREA, 0, @Self.WorkArea, 0)) then
    begin
      Self.Left:=Self.WorkArea.Left;
      Self.Top:=Self.WorkArea.Top;
      Self.Width:=Self.WorkArea.Right - Self.Left;
      Self.Height:=Self.WorkArea.Bottom - Self.Top;
    end; //}

  // Setup OpenGL Extensions. Only after wglCreateContext work wglGetProcAddress
  LoadOpenGLExtensions();
  if (TestOpenGLVersion(1, 3)) then
    begin
      ShowMessage('Error: Current system OpenGL version: '
        + OpenGLVersionShort + '; Requarement minimum version: 1.3');
      Self.ProfileTimer.DeleteTimer();
      Application.ShowMainForm:=False;
      Application.Terminate();
    end;
  if (Self.TestRequarementExtensions() = False) then
    begin
      Self.ProfileTimer.DeleteTimer();
      Application.ShowMainForm:=False;
      Application.Terminate();
    end;
  Self.InitGL();
  glClearColor(ClearColor[0], ClearColor[1], ClearColor[2], ClearColor[3]);

  Self.InitOrts;
  Self.InitCube;
  SelectedAtlasID:=0;

  Self.Camera:=CFirtsPersonViewCamera.CreateNewCamera(
    DefaultCameraPos,
    DefaultCameraPolarAngle,
    DefaultCameraAzimutalAngle
  );
  LightmapMegatexture:=CMegatextureManager.CreateManager();

  Self.ShaderFaces:=CShaderManager.CreateManager();
  sLog:=ShaderFaces.CreateShadersAndProgram(
    'shaders/FaceVERT.cpp', '', 'shaders/FaceFRAG.cpp',
    True, False, True
  );
  ShowMessage('Shader Face Constructor Log:' + #10 + sLog);
  ShaderFaces.UseProgram;
  ShaderFaces.Uniform1i('sampler0', 0);
  ShaderFaces.Uniform3f('entOrigin', 0, 0, 0);
  ShaderFaces.Uniform3f('entAngles', 0, 0, 0);
  ShaderFaces.Uniform4f('fxColorAlpha', 1, 1, 1, 1);
  ShaderFaces.Uniform1f('fStyle', 0);
  ShaderFaces.Uniform1f('fBump', 0);
  ShaderFaces.Uniform1f('fLightmapExpShift', 0);
  ShaderFaces.FihishUseProgram;

  Self.ShaderSFaces:=CShaderManager.CreateManager();
  sLog:=ShaderSFaces.CreateShadersAndProgram(
    'shaders/SFaceVERT.cpp', '', 'shaders/SFaceFRAG.cpp',
    True, False, True
  );
  //ShowMessage('Shader SFace Constructor Log:' + #10 + sLog);
  ShaderSFaces.UseProgram;
  ShaderSFaces.Uniform3f('fOffset', 0, 0, 0);
  ShaderSFaces.Uniform4f('fSelColor', 1, 0, 0, 0.3);
  ShaderSFaces.FihishUseProgram;


  Self.ShaderDisps:=CShaderManager.CreateManager();
  sLog:=ShaderDisps.CreateShadersAndProgram(
    'shaders/DispVERT.cpp', '', 'shaders/DispFRAG.cpp',
    True, False, True
  );
  ShowMessage('Shader Disp Constructor Log:' + #10 + sLog);
  ShaderDisps.UseProgram;
  ShaderDisps.Uniform1i('sampler0', 0);
  ShaderDisps.Uniform3f('entOrigin', 0, 0, 0);
  ShaderDisps.Uniform3f('entAngles', 0, 0, 0);
  ShaderDisps.Uniform4f('TexLmp0', 0, 0, 0, 0);
  ShaderDisps.Uniform4f('TexLmp1', 0, 0, 0, 0);
  ShaderDisps.Uniform4f('TexLmp2', 0, 0, 0, 0);
  ShaderDisps.Uniform4f('TexLmp3', 0, 0, 0, 0);
  ShaderDisps.Uniform1i('iDispSize', 1);
  ShaderDisps.Uniform4f('fxColorAlpha', 1, 1, 1, 1);
  ShaderDisps.Uniform4f('fLmpCAPS', 0, 0, 0, 0);
  ShaderDisps.Uniform1f('fStyle', 0);
  ShaderDisps.Uniform1f('fBump', 0);
  ShaderDisps.Uniform1f('fLightmapExpShift', 0);
  ShaderDisps.FihishUseProgram;

  BaseThumbnailBMP:=TBitmap.Create();
  BaseThumbnailBMP.PixelFormat:=pf24bit;
  BaseThumbnailBMP.Width:=128;
  BaseThumbnailBMP.Height:=128;
  BaseThumbnailBMP.Canvas.Brush.Color:=clBlack;
  BaseThumbnailBMP.Canvas.Pen.Color:=clBlack;

  LmpThumbnailBMP:=TBitmap.Create();
  LmpThumbnailBMP.PixelFormat:=pf24bit;
  LmpThumbnailBMP.Width:=128;
  LmpThumbnailBMP.Height:=128;
  LmpThumbnailBMP.Canvas.Brush.Color:=clBlack;
  LmpThumbnailBMP.Canvas.Pen.Color:=clBlack;

  Self.PanelRTResize(Sender);
  Self.RenderTimer:=CRenderTimerManager.CreateManager();
  Application.OnIdle:=Self.Idle;
  {$R+}
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$R-}
  Self.CloseMapMenu.Click;
  LightmapMegatexture.DeleteManager();
  //BasetextureMng.DeleteManager();
  BaseThumbnailBMP.Destroy();
  LmpThumbnailBMP.Destroy();

  ShaderFaces.DeleteManager;
  ShaderSFaces.DeleteManager;
  ShaderDisps.DeleteManager;
  Self.FreeOrts();
  Self.FreeCube();

  Self.Camera.DeleteCamera();
  Self.RenderTimer.DeleteManager();

  Self.RenderContext.DeleteRenderingContext();
  Self.RenderContext.DeleteManager();

  Self.ProfileTimer.DeleteTimer();
  {$R+}
end;


function TMainForm.TestRequarementExtensions(): Boolean;
begin
  {$R-}
  if TestOpenGLVersion(3, 0) then
    begin
      ShowMessage('Minimal requairement OpenGL version 3.0!');
      Result:=False;
      Exit;
    end; //}

  Result:=True;
  {$R+}
end;

procedure TMainForm.InitGL();
begin
  {$R-}
  // Setup Variable States
  glEnable(GL_TEXTURE_2D); // Enable Textures
  glEnable(GL_DEPTH_TEST);  // Enable Depth Buffer
  glEnable(GL_CULL_FACE); // Enable Face Normal Test
  glCullFace(GL_FRONT); // which Face side render, Front or Back
  glPolygonMode(GL_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT

  glPixelStorei(GL_UNPACK_ALIGNMENT, 1); // Support load textures per byte
  glPixelStorei(GL_PACK_ALIGNMENT, 1); // Support save textures per byte

  glDepthMask(GL_TRUE); // Enable Depth Test
  glDepthFunc(GL_LEQUAL);  // type of Depth Test
  glEnable(GL_NORMALIZE); // automatic Normalize

  glShadeModel(GL_POLYGON_SMOOTH); // Interpolation color type
  // GL_FLAT - Color dont interpolated, GL_SMOOTH - linear interpolate
  // GL_POLYGON_SMOOTH

  {glAlphaFunc(GL_GEQUAL, 0.1);
  glEnable(GL_ALPHA_TEST); //}

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND); //}

  glEnable(GL_PROGRAM_POINT_SIZE);
  {$R+}
end;

procedure TMainForm.InitOrts();
const
  OrtsCountVertex   = 6;
  OrtsVertexies: array[0..(OrtsCountVertex*6)-1] of GLfloat = (
    // X Red  : Pos, Color
    0, 0, 0,  4/6, 1/6, 1/6,
    1, 0, 0,  4/6, 1/6, 1/6,

    // Y Blue : Pos, Color
    0, 0, 0,  1/6, 1/6, 4/6,
    0, 1, 0,  1/6, 1/6, 4/6,

    // Z Green: Pos, Color
    0, 0, 0,  1/6, 4/6, 1/6,
    0, 0, 1,  1/6, 4/6, 1/6
  );
var
  sLog: String;
begin
  {$R-}
  ShaderOrts:=CShaderManager.CreateManager();
  sLog:=ShaderOrts.CreateShadersAndProgram(
    'shaders/OrtsVERT.cpp', '', 'shaders/OrtsFRAG.cpp',
    True, False, True
  );
  //ShowMessage('Shader Orts Constructor Log:' + #10 + sLog);


  glGenVertexArrays(1, @OrtsVAO);
  glBindVertexArray(OrtsVAO);

  glGenBuffersARB(1, @OrtsVBO);
  glBindBufferARB(GL_ARRAY_BUFFER, OrtsVBO);
  glBufferDataARB(
    GL_ARRAY_BUFFER,
    6*6*4,
    @OrtsVertexies[0],
    GL_STATIC_DRAW
  );

  // Attrib 0 - Orts positions, 3 floats
  glEnableVertexAttribArrayARB(0);
  glVertexAttribPointerARB(0, 3, GL_FLOAT, GL_FALSE, 6*4, nil);

  // Attrib 1 - Orts colors, 3 floats
  glEnableVertexAttribArrayARB(1);
  glVertexAttribPointerARB(1, 3, GL_FLOAT, GL_FALSE, 6*4, Pointer(3*SizeOf(GLfloat)));

  glBindBufferARB(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);
  {$R+}
end;

procedure TMainForm.FreeOrts();
begin
  {$R-}
  ShaderOrts.DeleteManager;
  glDeleteVertexArrays(1, @OrtsVAO);
  glDeleteBuffersARB(1, @OrtsVBO);
  {$R+}
end;


procedure TMainForm.InitCube();
const
  CUBE_SIDE_ZP  = 0;
  CUBE_SIDE_ZN  = 1;
  CUBE_SIDE_XP  = 2;
  CUBE_SIDE_XN  = 3;
  CUBE_SIDE_YP  = 4;
  CUBE_SIDE_YN  = 5;

  CubeCountVertexes = 6*4;
  CubeVertexes: array[0..(4*CubeCountVertexes - 1)] of GLfloat = (
    // positions       Side ID (1D tex coord)
    // Up
    -1.0,  1.0,  1.0,     CUBE_SIDE_ZP,
    -1.0, -1.0,  1.0,     CUBE_SIDE_ZP,
     1.0, -1.0,  1.0,     CUBE_SIDE_ZP,
     1.0,  1.0,  1.0,     CUBE_SIDE_ZP,

    // Down
    -1.0,  1.0, -1.0,     CUBE_SIDE_ZN,
    -1.0, -1.0, -1.0,     CUBE_SIDE_ZN,
     1.0, -1.0, -1.0,     CUBE_SIDE_ZN,
     1.0,  1.0, -1.0,     CUBE_SIDE_ZN,

    // X+
     1.0, -1.0,  1.0,     CUBE_SIDE_XP,
     1.0,  1.0,  1.0,     CUBE_SIDE_XP,
     1.0,  1.0, -1.0,     CUBE_SIDE_XP,
     1.0, -1.0, -1.0,     CUBE_SIDE_XP,

    // X-
    -1.0, -1.0,  1.0,     CUBE_SIDE_XN,
    -1.0, -1.0, -1.0,     CUBE_SIDE_XN,
    -1.0,  1.0, -1.0,     CUBE_SIDE_XN,
    -1.0,  1.0,  1.0,     CUBE_SIDE_XN,

    // Y+
    -1.0,  1.0,  1.0,     CUBE_SIDE_YP,
    -1.0,  1.0, -1.0,     CUBE_SIDE_YP,
     1.0,  1.0, -1.0,     CUBE_SIDE_YP,
     1.0,  1.0,  1.0,     CUBE_SIDE_YP,

    // Y-
    -1.0, -1.0,  1.0,     CUBE_SIDE_YN,
     1.0, -1.0,  1.0,     CUBE_SIDE_YN,
     1.0, -1.0, -1.0,     CUBE_SIDE_YN,
    -1.0, -1.0, -1.0,     CUBE_SIDE_YN
  );
var
  sLog: String;
begin
  {$R-}
  ShaderCube:=CShaderManager.CreateManager();
  sLog:=ShaderCube.CreateShadersAndProgram(
    'shaders/CubeVERT.cpp', '', 'shaders/CubeFRAG.cpp',
    True, False, True
  );
  //ShowMessage('Shader Cube Constructor Log:' + #10 + sLog);

  glGenVertexArrays(1, @CubeVAO);
  glBindVertexArray(CubeVAO);

  glGenBuffersARB(1, @CubeVBO);
  glBindBufferARB(GL_ARRAY_BUFFER, CubeVBO);
  glBufferDataARB(
    GL_ARRAY_BUFFER,
    6*4*4*4,
    @CubeVertexes[0],
    GL_STATIC_DRAW
  );

  // Attrib 0 - Orts position + side ID, 4 floats
  glEnableVertexAttribArrayARB(0);
  glVertexAttribPointerARB(0, 4, GL_FLOAT, GL_FALSE, 0, nil);

  glBindBufferARB(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);
  {$R+}
end;

procedure TMainForm.DrawCube(const bbox: tBBOX3f);
{const
  vMultiFirst: array[0..5] of GLint = (0, 4, 8, 12, 16, 20);
  vMultiCount: array[0..5] of GLsizei = (4, 4, 4, 4, 4, 4);
  vElmIndices: array[0..28] of GLubyte = (
     0,  1,  2,  3,   255,
     4,  5,  6,  7,   255,
     8,  9, 10, 11,   255,
    12, 13, 14, 15,   255,
    16, 17, 18, 19,   255,
    20, 21, 22, 23
  ); //}
begin
  {$R-}
  ShaderCube.Uniform3f('bbmin',
    bbox.vMin.x+0.1,
    bbox.vMin.y+0.1,
    bbox.vMin.z+0.1
  );
  ShaderCube.Uniform3f('bbmax',
    bbox.vMax.x-0.1,
    bbox.vMax.y-0.1,
    bbox.vMax.z-0.1
  );
  glDrawArrays(GL_TRIANGLE_FAN,  0, 4);
  glDrawArrays(GL_TRIANGLE_FAN,  4, 4);
  glDrawArrays(GL_TRIANGLE_FAN,  8, 4);
  glDrawArrays(GL_TRIANGLE_FAN, 12, 4);
  glDrawArrays(GL_TRIANGLE_FAN, 16, 4);
  glDrawArrays(GL_TRIANGLE_FAN, 20, 4); //}
  //glMultiDrawArraysEXT(GL_TRIANGLE_FAN, @vMultiFirst[0], @vMultiCount[0], 6);
  {glPrimitiveRestartIndexNV(255);
  glEnable(GL_PRIMITIVE_RESTART);
  glDrawElements(GL_TRIANGLE_FAN, 29, GL_UNSIGNED_BYTE, @vElmIndices[0]);
  glDisable(GL_PRIMITIVE_RESTART); //}
  //glDrawArrays(GL_TRIANGLE_FAN, 0, 24);
  {$R+}
end;

procedure TMainForm.FreeCube();
begin
  {$R-}
  ShaderCube.DeleteManager;
  glDeleteVertexArrays(1, @CubeVAO);
  glDeleteBuffersARB(1, @CubeVBO);
  {$R+}
end;


procedure TMainForm.GetVisleafRenderList();
var
  i, j: Integer;
  s: String;
begin
  {$R-}
  if (isBspLoad) then
    begin
      CameraLeafId:=GetLeafIndexByPointAsm(
        @Map.vNodes[Map.nHeadWorldspawn],
        Self.Camera.ViewPosition
      );
      lpCameraLeaf:=@Map.vLeafs[CameraLeafId];
      FaceOcclusion:=Boolean(lpCameraLeaf.nCluster >= 0);

      if (CameraLeafId <> CameraLastLeafId) then
        begin
          s:='Leaf: ' + IntToStr(CameraLeafId)
            + ', Cluster: ' + IntToStr(lpCameraLeaf.nCluster);
          if (FaceOcclusion= False) then s:=s + ', Void';
          Self.LabelCameraLeafId.Caption:=s;

          Self.ProfileTimer.TimerStart();
          Inc(RenderFrameIterator);
          if (lpCameraLeaf.nCluster >= 0) then
            begin
              // Unpack PVS for clusters
			        UnPackPVS(
				        @Map.VisHdr.vData[Map.VisHdr.vOffsets[lpCameraLeaf.nCluster].x],
				        @locPVS[0],
				        Map.VisHdr.nClusters,
				        Length(Map.VisHdr.vData)
			        ); 
              SetBytesByBoolMask(
                @locPVS[0],
                @ClusterIndexToRender[0],
                Map.VisHdr.nClusters,
                RenderFrameIterator or ((not RenderFrameIterator) shl 8)
              );

              FillChar(BModelIndexToRender[0], Length(Map.vBModels), not RenderFrameIterator);
              BModelIndexToRender[0]:=RenderFrameIterator; // worldspawn
              if (Self.DrawEntityBrushesMenu.Checked) then for i:=1 to Length(Map.vLeafs)-1 do
                begin
                  if (ClusterIndexToRender[Map.vLeafs[i].nCluster] <> RenderFrameIterator) then Continue;
                  for j:=1 to Length(Map.vBModels)-1 do
                    begin
                      if TestIntersectionTwoBBOX3f(Map.vLeafs[i].vBBOX, Map.vBModels[j].vBBOX)
                      then BModelIndexToRender[j]:=RenderFrameIterator;
                    end;
                end; //}

              FillChar(DispIndexToRender[0], Length(Map.vDisps), not RenderFrameIterator);
              for i:=1 to Length(Map.vLeafs)-1 do
                begin
                  if (ClusterIndexToRender[Map.vLeafs[i].nCluster] <> RenderFrameIterator) then Continue;
                  for j:=0 to Length(Map.vDisps)-1 do
                    begin
                      if TestIntersectionTwoBBOX3f(Map.vLeafs[i].vBBOX, Map.vDisps[j].vBBOX)
                      then DispIndexToRender[j]:=RenderFrameIterator;
                    end;
                end; //}
            end
          else
            begin
              // Call only when camera go out from map, mean from leaf to space,
              FillChar(ClusterIndexToRender[0], Map.VisHdr.nClusters, RenderFrameIterator);
              FillChar(BModelIndexToRender[0], Length(Map.vBModels), RenderFrameIterator);
              FillChar(DispIndexToRender[0], Length(Map.vDisps), RenderFrameIterator);
            end; //}
          CameraLastLeafId:=CameraLeafId;

          Self.ProfileTimer.TimerStop();
          Self.LabelProfile1.Caption:='FaceVis ' + Self.ProfileTimer.GetStringMcsInterval();
        end;
    end;
  {$R+}
end;

procedure TMainForm.do_movement(const Offset: GLfloat);
begin
  {$R-}
  if (Self.PressedKeyW) then Self.Camera.StepForward(Offset);
  if (Self.PressedKeyS) then Self.Camera.StepBackward(Offset);
  if (Self.PressedKeyA) then Self.Camera.StepLeft(Offset);
  if (Self.PressedKeyD) then Self.Camera.StepRight(Offset);
  {$R+}
end;    

procedure TMainForm.GetFaceIndexByRay();
var
  i, j: Integer;
  Dist: Single;
  Index: Integer;
  TraceInfo: tTraceInfo;
  pfe: PFaceExt;
  ERay: tRay;
begin
  {$R-}
  SelectedFaceIndex:=-1;
  CurrFaceExt:=nil;
  if (isBspLoad = False) then Exit;

  Dist:=Self.RenderRange + 1;
  Index:=-1;
  ERay.Dir:=Self.MouseRay.Dir;
  ERay.Start.w:=Self.MouseRay.Start.w;

  Self.ProfileTimer.TimerStart();

  // World Faces
  ERay.Start.x:=Self.MouseRay.Start.x - Map.vBModels[0].vOrigin.x;
  ERay.Start.y:=Self.MouseRay.Start.y - Map.vBModels[0].vOrigin.y;
  ERay.Start.z:=Self.MouseRay.Start.z - Map.vBModels[0].vOrigin.z;

  for j:=Map.vBModels[0].EFaceFirst to Map.vBModels[0].EFaceLast do
    begin
      pfe:=@Map.vFaces[j];

      if (ClusterIndexToRender[pfe.VisClusterId] <> RenderFrameIterator) then
        if (pfe.nDispId < 0)  then Continue;
      if (pfe.isNotRender[FACEDRAW_USER]) then Continue;
      if (pfe.nDispId >= 0) and (not Self.DrawDispFaceMenu.Checked) then Continue;

      TraceInfo.t:=Dist;
      GetRayFaceIntersection_MollerTrumbore(
        @Map.vFaceVertices[pfe.iFirst], pfe.iCount,
        pfe.Plane, ERay,
        @TraceInfo
      );   
      if (TraceInfo.iTriangle < 0) then Continue;

      if (TraceInfo.t < Dist) then
        begin
          Dist:=TraceInfo.t;
          CurrTraceInfo:=TraceInfo;
          Index:=j;
        end;
    end;

  // Entity BModel Faces
  if (Self.DrawEntityBrushesMenu.Checked) then for i:=1 to Length(Map.vBModels)-1 do
    begin
      ERay.Start.x:=Self.MouseRay.Start.x - Map.vBModels[i].vOrigin.x;
      ERay.Start.y:=Self.MouseRay.Start.y - Map.vBModels[i].vOrigin.y;
      ERay.Start.z:=Self.MouseRay.Start.z - Map.vBModels[i].vOrigin.z;

      for j:=Map.vBModels[i].EFaceFirst to Map.vBModels[i].EFaceLast do
        begin
          pfe:=@Map.vFaces[j];

          if (BModelIndexToRender[i] <> RenderFrameIterator) then Continue;
          if (pfe.isNotRender[FACEDRAW_USER]) then Continue;
          if (pfe.nDispId >= 0) and (not Self.DrawDispFaceMenu.Checked) then Continue;
          if (not Self.DrawTriggersMenu.Checked) then if Map.vBModels[i].isTrigger then Continue;

          TraceInfo.t:=Dist;
          GetRayFaceIntersection_MollerTrumbore(
            @Map.vFaceVertices[pfe.iFirst], pfe.iCount,
            pfe.Plane, ERay,
            @TraceInfo
          );
          if (TraceInfo.iTriangle < 0) then Continue;

          if (TraceInfo.t < Dist) then
            begin
              Dist:=TraceInfo.t;
              CurrTraceInfo:=TraceInfo;
              Index:=j;
            end;
        end;
    end;
  SelectedFaceIndex:=Index; 

  Self.ProfileTimer.TimerStop();
  Self.LabelProfile2.Caption:='SelectF '
    + Self.ProfileTimer.GetStringMcsInterval();

  if (SelectedFaceIndex >= 0) then
    begin
      CurrFaceExt:=@Map.vFaces[SelectedFaceIndex];
      Self.UpdateFaceVisualInfo();
    end
  else
    begin
      Self.ClearFaceVisualInfo();
    end; //}
  {$R+}
end;

procedure TMainForm.GenerateLightmapMegatexture();
var
  iFace, iStyle, iBump, nBump, iLmpOfs, iHDRLDR, iVertex: Integer;
  MegaMemError: eMegaMemError;
  pfe: PFaceExt;
  fullLmpSz: tVec2s;
  RegionOffset: tVec2s;
  pde: PDispExt;
begin
  {$R-}
  if (LightmapMegatexture.AllocNewMegaTexture(@MegaMemError) = False) then
    begin
      ShowMessage(GetMegaMemErrorInfo(MegaMemError));
      LightmapMegatexture.Clear();
      Exit;
    end;

  // 1. Create dummy lightmap texture
  LightmapMegatexture.ReserveTexture(MEGATEXTURE_DUMMY_SIZE);
  LightmapMegatexture.UpdateCurrentBufferFromArray(
    MEGATEXTURE_DUMMY_MEGAID,
    MEGATEXTURE_DUMMY_REGIONID,
    @MEGATEXTURE_DUMMY_DATA[0],
    nil,
    nil
  );

  // Process LDR Face's, of Exists
  for iHDRLDR:=FACEDRAW_LDR to FACEDRAW_HDR do
    begin
      if (iHDRLDR = FACEDRAW_LDR) AND (Map.bLDR = False) then Continue;
      if (iHDRLDR = FACEDRAW_HDR) AND (Map.bHDR = False) then Continue;
      for iFace:=0 to Length(Map.vFaces)-1 do
        begin          
          pfe:=@Map.vFaces[iFace];

          if (pfe.isNotRender[iHDRLDR]) then Continue;

          if (pfe.isDummyLmp[iHDRLDR]) then
            begin
              pfe.LmpMegaId[iHDRLDR]:=MEGATEXTURE_DUMMY_MEGAID;
              pfe.LmpRegionId[iHDRLDR]:=MEGATEXTURE_DUMMY_REGIONID;
              LightmapMegatexture.UpdateTextureCoords(
                pfe.LmpMegaId[iHDRLDR],
                pfe.LmpRegionId[iHDRLDR],
                @Map.vFaceLmpUV[iHDRLDR][pfe.iFirst],
                @Map.vFaceLmpUV[iHDRLDR][pfe.iFirst],
                pfe.iCount
              );
              Continue;
            end;

          nBump:=1;
          if (pfe.isBump[iHDRLDR]) then nBump:=4;

          // with light styles and bump's
          fullLmpSz.x:=pfe.LmpSz[iHDRLDR].x*nBump;
          fullLmpSz.y:=pfe.LmpSz[iHDRLDR].y*pfe.nStyles[iHDRLDR];

          if (LightmapMegatexture.IsCanReserveTexture(fullLmpSz) = False) then
            begin
              LightmapMegatexture.UpdateTextureFromCurrentBuffer();
              if (LightmapMegatexture.AllocNewMegaTexture(@MegaMemError) = False) then
                begin
                  ShowMessage(GetMegaMemErrorInfo(MegaMemError));
                  LightmapMegatexture.Clear();
                  Exit;
                end;
            end;

          pfe.LmpMegaId[iHDRLDR]:=LightmapMegatexture.CurrentMegatextureIndex;
          pfe.LmpRegionId[iHDRLDR]:=LightmapMegatexture.ReserveTexture(fullLmpSz);
          for iStyle:=0 to pfe.nStyles[iHDRLDR]-1 do
            begin
              for iBump:=0 to nBump-1 do
                begin
                  RegionOffset.x:=pfe.LmpSz[iHDRLDR].x*iBump;
                  RegionOffset.y:=pfe.LmpSz[iHDRLDR].y*iStyle;

                  iLmpOfs:=pfe.LmpByteFirst[iHDRLDR] +
                    SIZEOF_LIGHTMAP*(iStyle*nBump + iBump)*pfe.LmpArea[iHDRLDR];

                  LightmapMegatexture.UpdateCurrentBufferFromArray(
                    pfe.LmpMegaId[iHDRLDR],
                    pfe.LmpRegionId[iHDRLDR],
                    @Map.vLightmaps[iHDRLDR][iLmpOfs],
                    @RegionOffset,
                    @pfe.LmpSz[iHDRLDR]
                  );
                end;
            end;

          // for zero lightstyle and nobump, also put region size
          LightmapMegatexture.UpdateTextureCoords(
            pfe.LmpMegaId[iHDRLDR],
            pfe.LmpRegionId[iHDRLDR],
            @Map.vFaceLmpUV[iHDRLDR][pfe.iFirst],
            @Map.vFaceLmpUV[iHDRLDR][pfe.iFirst],
            pfe.iCount
          );
          for iVertex:=pfe.iFirst to pfe.iLast do
            begin
              Map.vFaceLmpCAPS[iHDRLDR][iVertex].x:=Map.vFaceLmpCAPS[iHDRLDR][iVertex].x*MEGATEXTURE_STEP;
              Map.vFaceLmpCAPS[iHDRLDR][iVertex].y:=Map.vFaceLmpCAPS[iHDRLDR][iVertex].y*MEGATEXTURE_STEP;
            end;

          if (pfe.nDispId >= 0) then
            begin
              pde:=pfe.pDispExt;
              LightmapMegatexture.UpdateTextureCoords(
                pfe.LmpMegaId[iHDRLDR],
                pfe.LmpRegionId[iHDRLDR],
                @pde.vLmpUV[iHDRLDR][0],
                @pde.vLmpUV[iHDRLDR][0],
                4
              );
            end;
        end;
    end;

  LightmapMegatexture.UpdateTextureFromCurrentBuffer();
  LightmapMegatexture.UnbindMegatexture2D();
  {$R+}
end;


procedure TMainForm.DrawScence(Sender: TObject);
var
  i, j, k: Integer;
  pfe: PFaceExt;
  vBOrigin: PVec3f;
  vTmp4: PVec4f;
  vTmp2A, vTmp2B: PVec2f;
begin
  {$R-}
  Self.RenderTimer.UpdDeltaTime();
  do_movement(CameraSpeed[Self.PressedKeyShift]*Self.RenderTimer.DeltaTime);
  Self.Camera.CopyModelProjectMatrix(@Self.CameraMatrix[0]);

  Self.GetVisleafRenderList();
  glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);

  // World & Entity Faces
  if (isBspLoad) then if ShaderFaces.UseProgram() then
    begin
      glEnable(GL_CULL_FACE); // Enable Face Normal Test
      glCullFace(GL_FRONT); 
      glPolygonMode(GL_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT

      ShaderFaces.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);
      ShaderFaces.Uniform1f('fStyle', SelectedStyle);

      //glAlphaFunc(GL_GEQUAL, 0.0);
      LightmapMegatexture.UnbindMegatexture2D();
      glBindVertexArray(FaceVAO[FACEDRAW_USER]);

      if (Self.BModelRenderColorAlphaMenu.Checked = False)
      then ShaderFaces.Uniform4f('fxColorAlpha', 1, 1, 1, 1);

      for i:=0 to Length(Map.vBModels)-1 do
        begin
          if (i > 0) then if (Self.DrawEntityBrushesMenu.Checked = False) then Continue;
          if (BModelIndexToRender[i] <> RenderFrameIterator) then Continue;
          if (not Self.DrawTriggersMenu.Checked)
          then if Map.vBModels[i].isTrigger then Continue;

          ShaderFaces.Uniform3f('entOrigin',
            Map.vBModels[i].vOrigin.x,
            Map.vBModels[i].vOrigin.y,
            Map.vBModels[i].vOrigin.z
          );
          ShaderFaces.Uniform3f('entAngles',
            Map.vBModels[i].vAngles.x,
            Map.vBModels[i].vAngles.y,
            Map.vBModels[i].vAngles.z
          ); //}

          if (Self.BModelRenderColorAlphaMenu.Checked)
          then ShaderFaces.Uniform4f('fxColorAlpha',
            Map.vBModels[i].vColor[0],
            Map.vBModels[i].vColor[1],
            Map.vBModels[i].vColor[2],
            Map.vBModels[i].vColor[3]
          );

          for j:=Map.vBModels[i].EFaceFirst to Map.vBModels[i].EFaceLast do
            begin
              pfe:=@Map.vfaces[j];
              if (pfe.isNotRender[FACEDRAW_USER]) then Continue;
              if (pfe.nDispId >= 0) and (not Self.DrawDispFaceMenu.Checked) then Continue;
              if (i = 0) then
                if (ClusterIndexToRender[pfe.VisClusterId] <> RenderFrameIterator) then
                  if (pfe.nDispId < 0) then Continue;

              LightmapMegatexture.BindMegatexture2D(pfe.LmpMegaId[FACEDRAW_USER]);
              //glDrawArrays(GL_LINE_LOOP, pfe.iFirst, pfe.iCount);
              glDrawArrays(GL_TRIANGLE_FAN, pfe.iFirst, pfe.iCount);
            end;
        end;

      glBindVertexArray(0);
      LightmapMegatexture.UnbindMegatexture2D();
      ShaderFaces.FihishUseProgram;
    end; //}

  // Displacements
  if (isBspLoad) then if ShaderDisps.UseProgram() then
    begin
      glEnable(GL_CULL_FACE); // Enable Face Normal Test
      glCullFace(GL_FRONT);
      glPolygonMode(GL_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT

      ShaderDisps.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);
      ShaderDisps.Uniform1f('fStyle', SelectedStyle);

      //glAlphaFunc(GL_GEQUAL, 0.0);
      LightmapMegatexture.UnbindMegatexture2D();
      glBindVertexArray(DispVAO);

      ShaderDisps.Uniform3f('entOrigin',
        Map.vBModels[0].vOrigin.x,
        Map.vBModels[0].vOrigin.y,
        Map.vBModels[0].vOrigin.z
      );
      ShaderDisps.Uniform3f('entAngles',
        Map.vBModels[0].vAngles.x,
        Map.vBModels[0].vAngles.y,
        Map.vBModels[0].vAngles.z
      );

      for i:=0 to Length(Map.vDisps)-1 do
        begin
          if (not Map.vDisps[i].bValid) then Continue;
          if (DispIndexToRender[i] <> RenderFrameIterator) then Continue;

          ShaderDisps.Uniform1i('iDispSize', Map.vDisps[i].nSize);
          ShaderDisps.Uniform1i('iDispBase', Map.vDisps[i].iBase);
          ShaderDisps.Uniform1i('iBaseVertex', Map.vDisps[i].iFirst);
          vTmp4:=@Map.vFaceLmpCAPS[FACEDRAW_USER][Map.vDisps[i].pRefFace.iFirst];
          ShaderDisps.Uniform4f('fLmpCAPS', vTmp4.x, vTmp4.y, vTmp4.z, vTmp4.w);
          for j:=0 to 3 do
            begin
              k:=(j + Map.vDisps[i].iBase) mod 4;
              vTmp2A:=@Map.vFaceTexUV[Map.vDisps[i].pRefFace.iFirst + j];
              vTmp2B:=@Map.vDisps[i].vLmpUV[FACEDRAW_USER][k];
              ShaderDisps.Uniform4f('TexLmp' + IntToStr(k),
                vTmp2A.x,
                vTmp2A.y,
                vTmp2B.x,
                vTmp2B.y
              );
            end;  

          LightmapMegatexture.BindMegatexture2D(Map.vDisps[i].pRefFace.LmpMegaId[FACEDRAW_USER]);
          case (Map.vDisps[i].nPower) of
            2: glDrawElementsBaseVertex(
                GL_TRIANGLES,
                DISP_TRIG_INDEX_COUNT_POWER_2,
                GL_UNSIGNED_INT,
                @DISP_TRIG_INDEX_TABLE_POWER_2[0],
                Map.vDisps[i].iFirst
              );
            3: glDrawElementsBaseVertex(
                GL_TRIANGLES,
                DISP_TRIG_INDEX_COUNT_POWER_3,
                GL_UNSIGNED_INT,
                @DISP_TRIG_INDEX_TABLE_POWER_3[0],
                Map.vDisps[i].iFirst
              );
            4: glDrawElementsBaseVertex(
                GL_TRIANGLES,
                DISP_TRIG_INDEX_COUNT_POWER_4,
                GL_UNSIGNED_INT,
                @DISP_TRIG_INDEX_TABLE_POWER_4[0],
                Map.vDisps[i].iFirst
              );
          end;
        end;

      glBindVertexArray(0);
      LightmapMegatexture.UnbindMegatexture2D();
      ShaderDisps.FihishUseProgram;
    end; //}

  // selected face
  if (isBspLoad and (SelectedFaceIndex >= 0)) then
    begin
      if (CurrFaceExt.BModelId > 0) then if Self.DrawEntityBrushesMenu.Checked then
        begin
          if (Self.ShaderSFaces.UseProgram) then
            begin
              glDisable(GL_CULL_FACE);
              glPolygonMode(GL_FRONT_AND_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT

              vBOrigin:=@Map.vBModels[CurrFaceExt.BModelId].vOrigin;

              glBindVertexArray(FaceVAO[FACEDRAW_USER]);
              ShaderSFaces.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);
              ShaderSFaces.Uniform3f('fOffset',
                CurrFaceExt.Plane.Normal.x + vBOrigin.x,
                CurrFaceExt.Plane.Normal.y + vBOrigin.y,
                CurrFaceExt.Plane.Normal.z + vBOrigin.z,
              );

              glDrawArrays(GL_TRIANGLE_FAN, CurrFaceExt.iFirst, CurrFaceExt.iCount);

              glBindVertexArray(0);
              ShaderSFaces.FihishUseProgram;
            end;
        end;
      if (CurrFaceExt.BModelId = 0) then
        begin
          if (Self.ShaderSFaces.UseProgram) then
            begin
              glDisable(GL_CULL_FACE); 
              glPolygonMode(GL_FRONT_AND_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT

              vBOrigin:=@Map.vBModels[CurrFaceExt.BModelId].vOrigin;

              glBindVertexArray(FaceVAO[FACEDRAW_USER]);
              ShaderSFaces.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);
              ShaderSFaces.Uniform3f('fOffset',
                CurrFaceExt.Plane.Normal.x + vBOrigin.x,
                CurrFaceExt.Plane.Normal.y + vBOrigin.y,
                CurrFaceExt.Plane.Normal.z + vBOrigin.z,
              );

              glDrawArrays(GL_TRIANGLE_FAN, CurrFaceExt.iFirst, CurrFaceExt.iCount);

              glBindVertexArray(0);
              ShaderSFaces.FihishUseProgram;
            end;
        end;
    end;

  if (Self.ShaderOrts.UseProgram) then
    begin
      ShaderOrts.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);
      ShaderOrts.Uniform1f('ortscale', 50);

      glBindVertexArray(Self.OrtsVAO);
      glDrawArrays(GL_LINES, 0, 6);
      glBindVertexArray(0);

      Self.ShaderOrts.FihishUseProgram;
    end;

  if (isBspLoad) then
    begin
      glDisable(GL_CULL_FACE);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE); // GL_FILL, GL_LINE, GL_POINT

      if (Self.ShaderCube.UseProgram) then
        begin
          glBindVertexArray(Self.CubeVAO);
          ShaderCube.UniformMatrix('cameramat', False, 4, 1, @Self.CameraMatrix[0]);

          // draw map BBOX (worldspawn entity BBOX)
          ShaderCube.Uniform4f('fcolor',
            LeafRenderColor3[0], LeafRenderColor3[1], LeafRenderColor3[2], LeafRenderColor3[3]);
          Self.DrawCube(Map.vBModels[0].vBBOX);

          // draw current visleaf BBOX
          if (Self.RenderBBOXVisLeaf.Checked) and (lpCameraLeaf.nCluster >= 0) then
            begin
              ShaderCube.Uniform4f('fcolor',
                LeafRenderColor[0], LeafRenderColor[1], LeafRenderColor[2], LeafRenderColor[3]);
              Self.DrawCube(lpCameraLeaf.vBBOX);

              // draw all visible visleaf BBOX
              ShaderCube.Uniform4f('fcolor',
                LeafRenderColor2[0], LeafRenderColor2[1], LeafRenderColor2[2], LeafRenderColor2[3]);
              for i:=0 to Length(Map.vLeafs)-1 do
                begin
                   if (ClusterIndexToRender[Map.vLeafs[i].nCluster]
                        <> RenderFrameIterator) then Continue;
                   if (i = CameraLeafId) then Continue;
                   Self.DrawCube(Map.vLeafs[i].vBBOX);
                end;
            end;

          glBindVertexArray(0);
          Self.ShaderCube.FihishUseProgram;
        end;
    end;

  Self.RenderContext.SwapBuffers();
  if (Self.RenderTimer.ElaspedTime >= RenderInfoDelayUpd) then
    begin
      Self.RenderTimer.ResetCounter();
      Self.LabelCameraFPS.Caption:='FPS: ' + Self.RenderTimer.GetStringFPS();
      Self.LabelCameraPos.Caption:=VecToStr(Self.Camera.ViewPosition);
    end;
  {$R+}
end;

procedure TMainForm.DrawAtlas(Sender: TObject);
begin
  {$R-}
  Self.RenderTimer.UpdDeltaTime();
  glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);
  //glShowErrorsMessageBox;
  // Draw Atlas
  glDisable(GL_CULL_FACE); // Enable Face Normal Test
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT
  if (isBspLoad) then if ShaderFaces.UseProgram() then
    begin
      ShaderFaces.UniformMatrix('cameramat', False, 4, 1, @IdentityMat4f[0]);
      ShaderFaces.Uniform3f('entOrigin', 0, 0, 0);
      ShaderFaces.Uniform3f('entAngles', 0, 0, 0);
      ShaderFaces.Uniform4f('fxColorAlpha', 1, 1, 1, 1);
      ShaderFaces.Uniform1f('fStyle', 0);
      ShaderFaces.Uniform1f('fBump', 0);

      LightmapMegatexture.BindMegatexture2D(SelectedAtlasID);
      glBindVertexArray(AtlasVAO);
      glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
      glBindVertexArray(0);
      LightmapMegatexture.UnbindMegatexture2D();
      
      ShaderFaces.FihishUseProgram;
    end; //}
  //glShowErrorsMessageBox;
  Self.RenderContext.SwapBuffers();
  if (Self.RenderTimer.ElaspedTime >= RenderInfoDelayUpd) then
    begin
      Self.RenderTimer.ResetCounter();
      Self.LabelCameraFPS.Caption:='FPS: ' + Self.RenderTimer.GetStringFPS();
      //Self.LabelCameraPos.Caption:=VecToStr(Self.Camera.ViewPosition);
    end;
  {$R+}
end;

procedure TMainForm.Idle(Sender: TObject; var Done: Boolean);
begin
  {$R-}
  Done:=False;
  if (Self.CheckBoxModeAtlas.Checked) then DrawAtlas(Sender)
  else Self.DrawScence(Sender);
  {$R+}
end; 

procedure TMainForm.PanelRTResize(Sender: TObject);
begin
  {$R-}
  if (Self.Camera <> nil) then
    begin
      Self.Camera.SetProjMatrix(
        Self.PanelRT.ClientWidth,
        Self.PanelRT.ClientHeight,
        FieldOfView,
        Self.RenderRange
      );
      Self.Camera.glViewPortUpdate();
    end;
  {$R+}
end;

procedure TMainForm.PanelRTMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {$R-}
  Self.MousePos.X:=X;
  Self.MousePos.Y:=Y;

  if (mbLeft = Button) then Self.isLeftMouseClicked:=True;
  if (mbRight = Button) then
    begin
      Self.isRightMouseClicked:=True;
      Self.Camera.GetTraceLineByMouseClick(Self.MousePos, @Self.MouseRay);
      Self.GetFaceIndexByRay();
    end; //}
  {$R+}
end;

procedure TMainForm.PanelRTMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {$R-}
  Self.MousePos.X:=X;
  Self.MousePos.Y:=Y;
  if (Self.isLeftMouseClicked) then
    begin
      if (Self.MousePos.X <> Self.MouseLastPos.X) then
        begin
          // MouseFreq -> [radian / pixel]
          // (X - Self.mdx) -> [pixel]
          // (X - Self.mdx)*MouseFreq -> [pixel]*[radian / pixel] -> [radian]
          Self.Camera.UpDateViewDirectionByMouseX((Self.MousePos.X - Self.MouseLastPos.X)*MouseFreq);
        end; //}
      if (Self.MousePos.Y <> Self.MouseLastPos.Y) then
        begin
          Self.Camera.UpDateViewDirectionByMouseY(-(Self.MouseLastPos.Y - Self.MousePos.Y)*MouseFreq);
        end; //}
    end;
  Self.MouseLastPos:=Self.MousePos;
  {$R+}
end;

procedure TMainForm.PanelRTMouseUp(Sender: TObject; Button: TMouseButton;
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
  if (Key = Byte('W')) then Self.PressedKeyW:=True;
  if (Key = Byte('S')) then Self.PressedKeyS:=True;
  if (Key = Byte('A')) then Self.PressedKeyA:=True;
  if (Key = Byte('D')) then Self.PressedKeyD:=True;
  if (Key = KEYBOARD_SHIFT) then Self.PressedKeyShift:=True;

  if (isBspLoad = False) then Exit;

  if (Key = Byte('F')) then
    begin
      Inc(SelectedStyle);
      if (SelectedStyle > 3) then SelectedStyle:=0;

      Self.LabelStylePage.Caption:='Style page (0..3): '
        + IntToStr(SelectedStyle);
    end;
  if (Key = Byte('H')) then
    begin
      FACEDRAW_USER:=(FACEDRAW_USER + 1) AND $01;
      if (Map.bLDR = False) then FACEDRAW_USER:=FACEDRAW_HDR;
      if (Map.bHDR = False) then FACEDRAW_USER:=FACEDRAW_LDR;
      case (FACEDRAW_USER) of
        FACEDRAW_LDR: Self.LabelLDRHDR.Caption:='LDR';
        FACEDRAW_HDR: Self.LabelLDRHDR.Caption:='HDR';
      end;
      Self.UpdateFaceVisualInfo();
    end;
  {$R+}
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$R-}
  if (Key = Byte('W')) then Self.PressedKeyW:=False;
  if (Key = Byte('S')) then Self.PressedKeyS:=False;
  if (Key = Byte('A')) then Self.PressedKeyA:=False;
  if (Key = Byte('D')) then Self.PressedKeyD:=False;
  if (Key = KEYBOARD_SHIFT) then Self.PressedKeyShift:=False;
  {$R+}
end;


procedure TMainForm.UpdatePreviewLightmap();
var
  lmpOfs, nBump: Integer;
begin
  {$R-}
  Self.ImageLmpPreview.Picture:=nil;
  if (isBspLoad = False) then Exit;
  if SelectedFaceIndex < 0 then Exit;
  if (Self.RadioGroupLmp.ItemIndex < 0) then Exit;

  nBump:=1;
  if (CurrFaceExt.isBump[FACEDRAW_USER]) then nBump:=4;
  LmpOfs:=CurrFaceExt.LmpByteFirst[FACEDRAW_USER] +
    SIZEOF_LIGHTMAP*(Self.RadioGroupLmp.ItemIndex*nBump + SelectedBump)
    *CurrFaceExt.LmpArea[FACEDRAW_USER];

  NearestRescaleLightmapToBitmap(
    @Map.vLightmaps[FACEDRAW_USER][LmpOfs],
    @CurrFaceExt.LmpSz[FACEDRAW_USER],
    LmpThumbnailBMP,
    Self.CBLmpPreviewRGB.Checked
  );
  Self.ImageLmpPreview.Canvas.Draw(0, 0, LmpThumbnailBMP);
  {$R+}
end;

procedure TMainForm.UpdateFaceVisualInfo();
var
  i: Integer;
  pent: PEntity;
  subreg: tSubRegion;
begin
  {$R-}
  ClearFaceVisualInfo;
  if (isBspLoad = False) then Exit;

  if SelectedFaceIndex < 0 then Exit;

  Self.EditFaceIndex.Caption:=IntToStr(SelectedFaceIndex);
  Self.EditFaceBrushIndex.Caption:=IntToStr(CurrFaceExt.BModelId);

  if (CurrFaceExt.BModelId >= 0) then if (Map.vBModels[CurrFaceExt.BModelId].iEntity >= 0) then
    begin
      pent:=@Map.vEntities[Map.vBModels[CurrFaceExt.BModelId].iEntity];
      Self.EditFaceEntityName.Caption:=pent.TargetName;
      Self.EditFaceEntityName.Hint:=pent.TargetName;
      Self.EditFaceEntityClass.Caption:=pent.ClassName;
      Self.EditFaceEntityClass.Hint:=pent.ClassName;
    end;

  Self.EditFacePlaneIndex.Caption:=IntToStr(CurrFaceExt.PlaneID);
  Self.EditFaceCountVertex.Caption:=IntToStr(CurrFaceExt.iCount);
  Self.EditFaceTexInfo.Caption:=IntToStr(CurrFaceExt.TexInfoId[FACEDRAW_USER]);
  Self.EditFaceDispID.Caption:=IntToStr(CurrFaceExt.nDispId);
  if (CurrFaceExt.pDispExt <> nil) then
    begin
      Self.EditFaceDispID.Caption:=Self.EditFaceDispID.Caption
        + ', ' + IntToStr(PDispExt(CurrFaceExt.pDispExt).nPower);
      Self.EditFaceDispOrigin.Caption:=IntToStr(PDispExt(CurrFaceExt.pDispExt).iBase);
      Self.EditFaceDispOrigin.Hint:=Self.EditFaceDispOrigin.Caption;
    end;

  Self.EditFacePlaneX.Caption:=FloatToStr(CurrFaceExt.Plane.Normal.x);
  Self.EditFacePlaneY.Caption:=FloatToStr(CurrFaceExt.Plane.Normal.y);
  Self.EditFacePlaneZ.Caption:=FloatToStr(CurrFaceExt.Plane.Normal.z);
  Self.EditFacePlaneD.Caption:=FloatToStr(CurrFaceExt.Plane.Dist);
  Self.EditFacePlaneF.Caption:=PlaneTypeToStrExt(CurrFaceExt.Plane.AxisType);
  Self.EditFacePlaneX.Hint:=Self.EditFacePlaneX.Caption;
  Self.EditFacePlaneY.Hint:=Self.EditFacePlaneY.Caption;
  Self.EditFacePlaneZ.Hint:=Self.EditFacePlaneZ.Caption;
  Self.EditFacePlaneD.Hint:=Self.EditFacePlaneD.Caption;

  Self.EditLmpSize.Caption:=IntToStr(CurrFaceExt.LmpSz[FACEDRAW_USER].x)
    + 'x' + IntToStr(CurrFaceExt.LmpSz[FACEDRAW_USER].y);
  if (CurrFaceExt.isBump[FACEDRAW_USER]) then Self.EditLmpSize.Caption:=
    Self.EditLmpSize.Caption + '; isBump';
  Self.EditLmpStyle0.Caption:=IntToStr(CurrFaceExt.vStyles[FACEDRAW_USER][0]);
  Self.EditLmpStyle1.Caption:=IntToStr(CurrFaceExt.vStyles[FACEDRAW_USER][1]);
  Self.EditLmpStyle2.Caption:=IntToStr(CurrFaceExt.vStyles[FACEDRAW_USER][2]);
  Self.EditLmpStyle3.Caption:=IntToStr(CurrFaceExt.vStyles[FACEDRAW_USER][3]);
  Self.EditLmpStyle0.Hint:=Self.EditLmpStyle0.Caption;
  Self.EditLmpStyle1.Hint:=Self.EditLmpStyle1.Caption;
  Self.EditLmpStyle2.Hint:=Self.EditLmpStyle2.Caption;
  Self.EditLmpStyle3.Hint:=Self.EditLmpStyle3.Caption;

  if (CurrFaceExt.vStyles[FACEDRAW_USER][0] >= 0) then
    begin
      subreg:=Self.LightmapMegatexture.TextureRegion[
        CurrFaceExt.LmpMegaID[FACEDRAW_USER],
        CurrFaceExt.LmpRegionID[FACEDRAW_USER]
      ];
      Self.EditLmpRegion.Caption:=
        IntToStr(CurrFaceExt.LmpMegaID[FACEDRAW_USER]) +
        ' (' + IntToStr(subreg.bMin.x) + ',' + IntToStr(subreg.bMin.y) + ') ('
        + IntToStr(subreg.bMax.x + 1) + ',' + IntToStr(subreg.bMax.y + 1) + ')';
    end;

  for i:=0 to CurrFaceExt.nStyles[FACEDRAW_USER]-1 do
    begin
      Self.RadioGroupLmp.Items.Append(
        IntToStr(CurrFaceExt.vStyles[FACEDRAW_USER][i])
      );
    end;
  Self.RadioGroupLmp.ItemIndex:=0;

  Self.MemoFaceVertex.Clear;
  for i:=0 to CurrFaceExt.iCount-1 do
    begin
      Self.MemoFaceVertex.Lines.Append(
        VecToStr(Map.vFaceVertices[CurrFaceExt.iFirst + i])
      );
    end;

  SelectedBump:=0;
  Self.EditLmpBump.Caption:=' 0';
  Self.UpdatePreviewLightmap;
  {$R+}
end;

procedure TMainForm.ClearFaceVisualInfo();
begin
  {$R-}
  Self.EditFaceIndex.Caption:='';
  Self.EditFaceBrushIndex.Caption:='';
  Self.EditFaceEntityName.Caption:=' Entity Targetname';
  Self.EditFaceEntityClass.Caption:=' Entity Classname';
  Self.EditFacePlaneIndex.Caption:='';
  Self.EditFaceCountVertex.Caption:='';
  Self.EditFaceTexInfo.Caption:='';
  Self.EditFaceDispID.Caption:='';
  Self.EditFaceDispOrigin.Caption:='';

  Self.EditFacePlaneX.Caption:='';
  Self.EditFacePlaneY.Caption:='';
  Self.EditFacePlaneZ.Caption:='';
  Self.EditFacePlaneD.Caption:='';
  Self.EditFacePlaneF.Caption:='';

  Self.EditTexIndex.Caption:='';
  Self.EditTexName.Caption:='';
  Self.EditTexSize.Caption:='';
  Self.ImagePreviewBT.Canvas.Brush.Color:=clBlack;
  Self.ImagePreviewBT.Canvas.FillRect(Self.ImagePreviewBT.Canvas.ClipRect);

  Self.EditLmpSize.Caption:='';
  Self.EditLmpStyle0.Caption:='';
  Self.EditLmpStyle1.Caption:='';
  Self.EditLmpStyle2.Caption:='';
  Self.EditLmpStyle3.Caption:='';

  Self.EditFaceTexUV.Caption:='';
  Self.EditFaceLmpUV.Caption:='';

  Self.EditLmpRegion.Caption:='';
  Self.ImageLmpPreview.Picture:=nil;
  Self.EditLmpPixelR.Caption:='';
  Self.EditLmpPixelG.Caption:='';
  Self.EditLmpPixelB.Caption:='';
  Self.EditLmpPixelE.Caption:='';

  SelectedBump:=0;
  Self.EditLmpBump.Caption:='';

  Self.MemoFaceVertex.Clear;

  Self.RadioGroupLmp.Items.Clear();
  Self.Update();
  {$R+}
end;


procedure TMainForm.LoadMapMenuClick(Sender: TObject);
const
  AtlasVertexData: array[0..(((3 + 2 + 2 + 4)*4) - 1)] of GLfloat = (
    // Positions      TexCoords   LmpCoord    LmpCAPS
    -1.0, -1.0, 0.0,  0.0, 1.0,   0.0, 1.0,   0, 0, 0, 0, // Bottom Right
    -1.0,  1.0, 0.0,  0.0, 0.0,   0.0, 0.0,   0, 0, 0, 0, // Bottom Left
     1.0,  1.0, 0.0,  1.0, 0.0,   1.0, 0.0,   0, 0, 0, 0, // Top Left
     1.0, -1.0, 0.0,  1.0, 1.0,   1.0, 1.0,   0, 0, 0, 0  // Top Right
  );
begin
  {$R-}
  if (Self.OpenDialogBsp.Execute) then
    begin
      isBspLoad:=LoadBSPFromFile(Self.OpenDialogBsp.FileName, @Map);
      if (isBspLoad = False) then
        begin
          {ShowMessage('Error load Map: ' + LF
            + ShowLoadBSPMapError(Map.LoadState)
          ); //}
          ShowMessage('Error load Map!');
          FreeMapBSP(@Map);
        end
      else
        begin
          Self.LoadMapMenu.Enabled:=False;
          Self.CloseMapMenu.Enabled:=True;
          Self.SaveMapMenu.Enabled:=True;
          Self.GotoFaceIdSubmenu.Enabled:=True;
          Self.GotoVisLeafIdSubMenu.Enabled:=True;
          Self.GotoBModelIdSubMenu.Enabled:=True;
          Self.GotoEntTGNSubMenu.Enabled:=True;
          Self.Caption:=Self.OpenDialogBsp.FileName;
          Self.SelectedAtlasID:=0;
          Self.LblAtlasPage.Caption:=' 0';
          Self.DrawTriggersMenu.Checked:=False;

          FirstSpawnEntityId:=FindFirstSpawnEntity(@Map.vEntities[0], Length(Map.vEntities));
          if (FirstSpawnEntityId >= 1) then
            begin
              Self.Camera.ResetCamera(
                Map.vEntities[FirstSpawnEntityId].Origin,
                Map.vEntities[FirstSpawnEntityId].Angles.x*AngleToRadian,
                Map.vEntities[FirstSpawnEntityId].Angles.y*AngleToRadian - Pi/2
              );
            end;

          SetLength(ClusterIndexToRender, Map.VisHdr.nClusters);
          SetLength(BModelIndexToRender, Length(Map.vBModels));
          SetLength(DispIndexToRender, Length(Map.vDisps));
          FillChar(ClusterIndexToRender[0], Map.VisHdr.nClusters, not RenderFrameIterator);
          FillChar(BModelIndexToRender[0], Length(Map.vBModels), not RenderFrameIterator);
          FillChar(DispIndexToRender[0], Length(Map.vDisps), not RenderFrameIterator);

          //Self.GenerateBasetextures();
          Self.GenerateLightmapMegatexture();

          // generate face draw data
          // load face vertex data
          glGenBuffersARB(1, @FacePosVBO);
          glBindBufferARB(GL_ARRAY_BUFFER, FacePosVBO);
          glBufferDataARB(
            GL_ARRAY_BUFFER,
            Length(Map.vFaceVertices)*SizeOf(tVec3f),
            @Map.vFaceVertices[0],
            GL_STATIC_DRAW
          );
          glBindBufferARB(GL_ARRAY_BUFFER, 0);

          // load face TexUV data
          glGenBuffersARB(1, @FaceTexVBO);
          glBindBufferARB(GL_ARRAY_BUFFER, FaceTexVBO);
          glBufferDataARB(
            GL_ARRAY_BUFFER,
            Length(Map.vFaceTexUV)*SizeOf(tVec2f),
            @Map.vFaceTexUV[0],
            GL_STATIC_DRAW
          );
          glBindBufferARB(GL_ARRAY_BUFFER, 0);

          // load atlas Vertex data
          glGenBuffersARB(1, @AtlasVBO);
          glBindBufferARB(GL_ARRAY_BUFFER, AtlasVBO);
          glBufferDataARB(
            GL_ARRAY_BUFFER,
            SizeOf(AtlasVertexData),
            @AtlasVertexData[0],
            GL_STATIC_DRAW
          );     
          glGenVertexArrays(1, @AtlasVAO);
		      glBindVertexArray(AtlasVAO);
          glBindBufferARB(GL_ARRAY_BUFFER, AtlasVBO);
          // Attrib 0 - Atlas positions, 3 floats
		      glEnableVertexAttribArrayARB(0);
		      glVertexAttribPointerARB(0, 3, GL_FLOAT, GL_FALSE, (3+2+2+4)*4, nil);
		      // Attrib 1 - Atlas Tex UV, 2 floats
		      glEnableVertexAttribArrayARB(1);
		      glVertexAttribPointerARB(1, 2, GL_FLOAT, GL_FALSE, (3+2+2+4)*4, Pointer(3*4));
		      // Attrib 2 - Atlas Lmp UV, 2 floats
		      glEnableVertexAttribArrayARB(2);
		      glVertexAttribPointerARB(2, 2, GL_FLOAT, GL_FALSE, (3+2+2+4)*4, Pointer((3+2)*4));
		      // Attrib 3 - Atlas Lmp CAPS, 4 floats
		      glEnableVertexAttribArrayARB(3);
		      glVertexAttribPointerARB(3, 4, GL_FLOAT, GL_FALSE, (3+2+2+4)*4, Pointer((3+2+2)*4));
          //
          glBindBufferARB(GL_ARRAY_BUFFER, 0);
          glBindVertexArray(0);

          // load face LDR LmpUV data, if exists, and create VAO
          if (Map.bLDR) then
            begin
              // LDR LmpUV
              Self.FACEDRAW_USER:=FACEDRAW_LDR;
              glGenBuffersARB(1, @FaceLmpVBO[FACEDRAW_LDR]);
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpVBO[FACEDRAW_LDR]);
              glBufferDataARB(
                GL_ARRAY_BUFFER,
                Length(Map.vFaceLmpUV[FACEDRAW_LDR])*SizeOf(tVec2f),
                @Map.vFaceLmpUV[FACEDRAW_LDR][0],
                GL_STATIC_DRAW
              );
              glBindBufferARB(GL_ARRAY_BUFFER, 0);

              // LDR LmpCAPS
              glGenBuffersARB(1, @FaceLmpCapsVBO[FACEDRAW_LDR]);
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpCapsVBO[FACEDRAW_LDR]);
              glBufferDataARB(
                GL_ARRAY_BUFFER,
                Length(Map.vFaceLmpCAPS[FACEDRAW_LDR])*SizeOf(tVec4f),
                @Map.vFaceLmpCAPS[FACEDRAW_LDR][0],
                GL_STATIC_DRAW
              );
              glBindBufferARB(GL_ARRAY_BUFFER, 0);

              // Create LDR VAO
              glGenVertexArrays(1, @FaceVAO[FACEDRAW_LDR]);
              glBindVertexArray(FaceVAO[FACEDRAW_LDR]);

              // Attrib 0 - Face positions, 3 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FacePosVBO);
              glEnableVertexAttribArrayARB(0);
              glVertexAttribPointerARB(0, 3, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(0, 0);

              // Attrib 1 - Face TexUV, 2 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceTexVBO);
              glEnableVertexAttribArrayARB(1);
              glVertexAttribPointerARB(1, 2, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(1, 0);

              // Attrib 2 - Face LmpUV, 2 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpVBO[FACEDRAW_LDR]);
              glEnableVertexAttribArrayARB(2);
              glVertexAttribPointerARB(2, 2, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(2, 0);

              // Attrib 3 - Face LmpCAPS, 4 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpCapsVBO[FACEDRAW_LDR]);
              glEnableVertexAttribArrayARB(3);
              glVertexAttribPointerARB(3, 4, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(2, 0);

              glBindBufferARB(GL_ARRAY_BUFFER, 0);
              glBindVertexArray(0);

              Self.LabelLDRHDR.Caption:='LDR';
            end;
          // load face HDR LmpUV data, if exists, and create VAO
          if (Map.bHDR) then
            begin
              // HDR LmpUV
              Self.FACEDRAW_USER:=FACEDRAW_HDR;
              glGenBuffersARB(1, @FaceLmpVBO[FACEDRAW_HDR]);
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpVBO[FACEDRAW_HDR]);
              glBufferDataARB(
                GL_ARRAY_BUFFER,
                Length(Map.vFaceLmpUV[FACEDRAW_HDR])*SizeOf(tVec2f),
                @Map.vFaceLmpUV[FACEDRAW_HDR][0],
                GL_STATIC_DRAW
              );
              glBindBufferARB(GL_ARRAY_BUFFER, 0);

              // HDR LmpCAPS
              glGenBuffersARB(1, @FaceLmpCapsVBO[FACEDRAW_HDR]);
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpCapsVBO[FACEDRAW_HDR]);
              glBufferDataARB(
                GL_ARRAY_BUFFER,
                Length(Map.vFaceLmpCAPS[FACEDRAW_HDR])*SizeOf(tVec4f),
                @Map.vFaceLmpCAPS[FACEDRAW_HDR][0],
                GL_STATIC_DRAW
              );
              glBindBufferARB(GL_ARRAY_BUFFER, 0);

              // Create HDR VAO
              glGenVertexArrays(1, @FaceVAO[FACEDRAW_HDR]);
              glBindVertexArray(FaceVAO[FACEDRAW_HDR]);

              // Attrib 0 - Face positions, 3 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FacePosVBO);
              glEnableVertexAttribArrayARB(0);
              glVertexAttribPointerARB(0, 3, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(0, 0);

              // Attrib 1 - Face TexUV, 2 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceTexVBO);
              glEnableVertexAttribArrayARB(1);
              glVertexAttribPointerARB(1, 2, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(1, 0);

              // Attrib 2 - Face LmpUV, 2 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpVBO[FACEDRAW_HDR]);
              glEnableVertexAttribArrayARB(2);
              glVertexAttribPointerARB(2, 2, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(2, 0);

              // Attrib 3 - Face LmpCAPS, 4 floats
              glBindBufferARB(GL_ARRAY_BUFFER, FaceLmpCapsVBO[FACEDRAW_HDR]);
              glEnableVertexAttribArrayARB(3);
              glVertexAttribPointerARB(3, 4, GL_FLOAT, GL_FALSE, 0, nil);
              //glVertexAttribDivisorARB(2, 0);

              glBindBufferARB(GL_ARRAY_BUFFER, 0);
              glBindVertexArray(0);
              Self.LabelLDRHDR.Caption:='HDR';
            end;

          // generate displacement draw data
          // load disp vertex-alpha data
          glGenBuffersARB(1, @DispPosVBO);
          glBindBufferARB(GL_ARRAY_BUFFER, DispPosVBO);
          glBufferDataARB(
            GL_ARRAY_BUFFER,
            Length(Map.vDispVertAlpha)*SizeOf(tVec4f),
            @Map.vDispVertAlpha[0],
            GL_STATIC_DRAW
          );
          glBindVertexArray(0);

          // Create Disp VAO
          glGenVertexArrays(1, @DispVAO);
          glBindVertexArray(DispVAO);

          // Attrib 0 - Disp positions-alphas, 4 floats
          glBindBufferARB(GL_ARRAY_BUFFER, DispPosVBO);
          glEnableVertexAttribArrayARB(0);
          glVertexAttribPointerARB(0, 4, GL_FLOAT, GL_FALSE, 0, nil);
          //glVertexAttribDivisorARB(0, 0);

          glBindBufferARB(GL_ARRAY_BUFFER, 0);
          glBindVertexArray(0);
        end;
    end;
  {$R+}
end;

procedure TMainForm.CloseMapMenuClick(Sender: TObject);
begin
  {$R-}
  Self.Camera.ResetCamera(
    DefaultCameraPos,
    DefaultCameraPolarAngle,
    DefaultCameraAzimutalAngle
  );

  isBspLoad:=False;
  Self.Caption:=MainFormCaption;

  Self.LoadMapMenu.Enabled:=True;
  Self.SaveMapMenu.Enabled:=False;
  Self.CloseMapMenu.Enabled:=False;
  Self.GotoFaceIdSubmenu.Enabled:=False;
  Self.GotoVisLeafIdSubMenu.Enabled:=False;
  Self.GotoBModelIdSubMenu.Enabled:=False;
  Self.GotoEntTGNSubMenu.Enabled:=False;
  Self.SelectedAtlasID:=0;
  Self.LblAtlasPage.Caption:=' 0';

  FreeMapBSP(@Map);
  glDeleteVertexArrays(1, @FaceVAO[FACEDRAW_LDR]);
  glDeleteVertexArrays(1, @FaceVAO[FACEDRAW_HDR]);
  glDeleteVertexArrays(1, @AtlasVAO);
  glDeleteVertexArrays(1, @DispVAO);
  glDeleteBuffersARB(1, @FacePosVBO);
  glDeleteBuffersARB(1, @FaceTexVBO);
  glDeleteBuffersARB(1, @FaceLmpVBO[FACEDRAW_LDR]);
  glDeleteBuffersARB(1, @FaceLmpVBO[FACEDRAW_HDR]);
  glDeleteBuffersARB(1, @FaceLmpCapsVBO[FACEDRAW_LDR]);
  glDeleteBuffersARB(1, @FaceLmpCapsVBO[FACEDRAW_HDR]);
  glDeleteBuffersARB(1, @AtlasVBO);
  glDeleteBuffersARB(1, @DispPosVBO);

  CameraLeafId:=0;
  CameraLastLeafId:=0;
  FirstSpawnEntityId:=0;
  SelectedFaceIndex:=-1;
  SelectedStyle:=0;
  SelectedBump:=0;
  lpCameraLeaf:=nil;
  CurrFaceExt:=nil;
  SetLength(Unit1.ClusterIndexToRender, 0);
  SetLength(Unit1.BModelIndexToRender, 0);
  SetLength(Unit1.DispIndexToRender, 0);

  Self.LabelCameraLeafId.Caption:='No map load';
  Self.LabelStylePage.Caption:='Style page (0..3): 0';
  Self.ClearFaceVisualInfo();

  LightmapMegatexture.Clear();
  //BasetextureMng.Clear();
  {$R+}
end;

procedure TMainForm.SaveMapMenuClick(Sender: TObject);
begin
  {$R-}
  if (isBspLoad = False) then Exit;

  {if (Self.SaveDialogBsp.Execute) then
    begin
      SaveBSP30ToFile(Self.SaveDialogBsp.FileName, @Map);
    end; //}
  {$R+}
end;

procedure TMainForm.ResetCameraMenuClick(Sender: TObject);
begin
  {$R-}
  if (isBspLoad) then
    begin
      if (FirstSpawnEntityId >= 1) then
        begin
          Self.Camera.ResetCamera(
            Map.vEntities[FirstSpawnEntityId].Origin,
            Map.vEntities[FirstSpawnEntityId].Angles.x*AngleToRadian,
            Map.vEntities[FirstSpawnEntityId].Angles.y*AngleToRadian - Pi/2
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

procedure TMainForm.ShowHeaderMenuClick(Sender: TObject);
begin
  {$R-}
  {if (isBspLoad) then
    begin
      ShowMessage(ShowMapHeaderInfo(Map.MapHeader) + LF
        + 'Count textures: ' + IntToStr(Map.TextureLump.nCountTextures) + LF
        + 'Entities (with "worldspawn"): ' + IntToStr(Map.CountEntities) + LF
        + 'Count VisLeafs with PVS: ' + IntToStr(Map.CountVisLeafWithPVS) + LF
        + 'Max count vertecies per Face: ' + IntToStr(Map.MaxVerteciesPerFace) + LF
        + 'Avg count vertecies per Face: '
          + FloatToStrF(Map.AvgVerteciesPerFace/Map.CountFaces, ffFixed, 2, 2) + LF
        + 'Total Face triangles on Map: ' + IntToStr(Map.TotalTrianglesCount) + LF
        + 'Count generated ' + IntToStr(MEGATEXTURE_SIZE) + 'x'
          + IntToStr(MEGATEXTURE_SIZE)
          + ' Lightmap 2D Megatextures: '
          + IntToStr(LightmapMegatexture.CountMegatextures) + LF
        + 'Max lightmap size in Megatexture: '
          + IntToStr(LightmapMegatexture.MaxRegionSizeX) + 'x'
          + IntToStr(LightmapMegatexture.MaxRegionSizeY) + LF
        + 'Max possible lightmap size on map: '
          + IntToStr(Map.MaxLightmapSize.x) + 'x' + IntToStr(Map.MaxLightmapSize.y)
      );
    end; //}

  if (isBspLoad) then
    begin
      ShowMessage(
          'Entities (with "worldspawn"): ' + IntToStr(Length(Map.vEntities)) + LF
        + 'Lightmap 1024x1024 Megatextures: ' + IntToStr(LightmapMegatexture.CountMegatextures) + LF
        + 'Lightmap textures: ' + IntToStr(LightmapMegatexture.TotalInsertedTextures) + LF
        + 'Total face vertices: ' + IntToStr(Map.nTotalFaceVertex) + LF
        + 'is LDR lightmaps: ' + BoolToStr(Map.bLDR) + LF
        + 'is HDR lightmaps: ' + BoolToStr(Map.bHDR) + LF
      );
    end;
  {$R+}
end;

procedure TMainForm.ShowOpenGLInformationMenuClick(Sender: TObject);
begin
  {$R-}
  ShowMessage(
    'GL_VERSION: ' + OpenGLVersion + LF +
    'GL_VENDOR: ' + OpenGLVendor + LF +
    'GL_RENDERER: ' + OpenGLRenderer + LF +
    'GL_EXTENSIONS: ' + LF + OpenGLExtArbList
  );
  {$R+}
end;

procedure TMainForm.WireframeEntBrushesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.WireframeEntBrushesMenu.Checked:=not Self.WireframeEntBrushesMenu.Checked;
  {$R+}
end;

procedure TMainForm.WireframeHighlighEntBrushesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.WireframeHighlighEntBrushesMenu.Checked:=not Self.WireframeHighlighEntBrushesMenu.Checked;
  {$R+}
end;

procedure TMainForm.DrawFaceContourMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DrawFaceContourMenu.Checked:=not Self.DrawFaceContourMenu.Checked;
  {$R+}
end;


procedure TMainForm.SetSelectedFaceColorMenuClick(Sender: TObject);
begin
  {$R-}
  if (Self.ColorDialog.Execute) and (Self.ShaderSFaces.UseProgram) then
    begin
      Self.ShaderSFaces.Uniform4f('fSelColor',
        GetRValue(Self.ColorDialog.Color)*inv255,
        GetGValue(Self.ColorDialog.Color)*inv255,
        GetBValue(Self.ColorDialog.Color)*inv255,
        0.3
      );
      Self.ShaderSFaces.FihishUseProgram;
    end;
  {$R+}
end;

procedure TMainForm.SetWireframeFaceColorMenuClick(Sender: TObject);
begin
  {$R-}
  Self.ColorDialog.Color:=RGB(
    Round(Self.FaceWireframeColor[0]*255),
    Round(Self.FaceWireframeColor[1]*255),
    Round(Self.FaceWireframeColor[2]*255)
  );
  if (Self.ColorDialog.Execute) then
    begin
      Self.FaceWireframeColor[0]:=GetRValue(Self.ColorDialog.Color)*inv255;
      Self.FaceWireframeColor[1]:=GetGValue(Self.ColorDialog.Color)*inv255;
      Self.FaceWireframeColor[2]:=GetBValue(Self.ColorDialog.Color)*inv255;
    end;
  {$R+}
end;

procedure TMainForm.RenderBBOXVisLeafClick(Sender: TObject);
begin
  {$R-}
  Self.RenderBBOXVisLeaf.Checked:=not Self.RenderBBOXVisLeaf.Checked;
  {$R+}
end;

procedure TMainForm.DrawTriggersMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DrawTriggersMenu.Checked:=not Self.DrawTriggersMenu.Checked;
  SelectedFaceIndex:=-1;
  CurrFaceExt:=nil;
  Self.ClearFaceVisualInfo();
  {$R+}
end;

procedure TMainForm.DrawEntityBrushesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DrawEntityBrushesMenu.Checked:=not Self.DrawEntityBrushesMenu.Checked;
  SelectedFaceIndex:=-1;
  CurrFaceExt:=nil;
  Self.ClearFaceVisualInfo();
  {$R+}
end;

procedure TMainForm.DrawDispFaceMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DrawDispFaceMenu.Checked:=not Self.DrawDispFaceMenu.Checked;
  SelectedFaceIndex:=-1;
  CurrFaceExt:=nil;
  Self.ClearFaceVisualInfo();
  {$R+}
end;

procedure TMainForm.BModelRenderColorAlphaMenuClick(Sender: TObject);
begin
  {$R-}
  Self.BModelRenderColorAlphaMenu.Checked:=not Self.BModelRenderColorAlphaMenu.Checked;
  {$R+}
end;


procedure TMainForm.LmpPixelModeMenuClick(Sender: TObject);
begin
  {$R-}
  LightmapMegatexture.SetFiltrationMode(Self.LmpPixelModeMenu.Checked);
  Self.LmpPixelModeMenu.Checked:=not Self.LmpPixelModeMenu.Checked;
  {$R+}
end;

procedure TMainForm.TexPixelModeMenuClick(Sender: TObject);
begin
  {$R-}
  //BasetextureMng.SetFiltrationMode(Self.TexPixelModeMenu.Checked);
  Self.TexPixelModeMenu.Checked:=not Self.TexPixelModeMenu.Checked;
  {$R+}
end;

procedure TMainForm.DisableLightmapsMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DisableLightmapsMenu.Checked:=not Self.DisableLightmapsMenu.Checked;
  {$R+}
end;

procedure TMainForm.DisableTexturesMenuClick(Sender: TObject);
begin
  {$R-}
  Self.DisableTexturesMenu.Checked:=not Self.DisableTexturesMenu.Checked;
  {$R+}
end;


procedure TMainForm.GotoCamPosSubMenuClick(Sender: TObject);
var
  tmpVec: tVec3f;
begin
  {$R-}
  if (StrToVec(InputBox('Go to...', 'Position [X Y Z]', '0 0 0'), @tmpVec)) then
    begin
      Self.Camera.ViewPosition:=tmpVec;
    end;
  {$R+}
end;

procedure TMainForm.GotoFaceIdSubmenuClick(Sender: TObject);
var
  tmpFaceId: Integer;
  tmpVec: tVec3f;
  pfe: PFaceExt;
begin
  {$R-}
  if (Unit1.isBspLoad = False) then Exit;

  tmpFaceId:=StrToIntDef(InputBox('Go to...', 'Face ID (0..)', '0'), -1);
  if (tmpFaceId > 0) and (tmpFaceId < Length(Map.vFaces)) then
    begin
      pfe:=@Map.vFaces[tmpFaceId];
      tmpVec.x:=pfe.vCenter.x + pfe.Plane.Normal.x;
      tmpVec.y:=pfe.vCenter.y + pfe.Plane.Normal.y;
      tmpVec.z:=pfe.vCenter.z + pfe.Plane.Normal.z;
      Self.Camera.ViewPosition:=tmpVec;
    end
  else ShowMessage('Invalid Face ID input, must be [0..Faces-1]!');
  {$R+}
end;

procedure TMainForm.GotoVisLeafIdSubMenuClick(Sender: TObject);
var
  tmpVisLeafId: Integer;
  tmpVec: tVec3f; //}
begin
  {$R-}
  if (Unit1.isBspLoad = False) then Exit;

  tmpVisLeafId:=StrToIntDef(InputBox('Go to...', 'VisLeaf ID (1..)', '0'), -1);
  if (tmpVisLeafId > 0) and (tmpVisLeafId < Length(Map.vLeafs)) then
    begin
      GetCenterBBOX3f(Map.vLeafs[tmpVisLeafId].vBBOX, @tmpVec);
      Self.Camera.ViewPosition:=tmpVec;
    end
  else ShowMessage('Invalid VisLeaf ID input, must be [1..Leafs-1]!');
  {$R+}
end;

procedure TMainForm.GotoBModelIdSubMenuClick(Sender: TObject);
var
  tmpBModelId: Integer;
begin
  {$R-}
  if (Unit1.isBspLoad = False) then Exit;

  tmpBModelId:=StrToIntDef(InputBox('Go to...', 'BModel ID (1..)', '1'), -1);
  if (tmpBModelId > 0) and (tmpBModelId < Length(Map.vBModels)) then
    begin
      Self.Camera.ViewPosition:=Map.vBModels[tmpBModelId].vOrigin;
    end
  else ShowMessage('Invalid BModel ID input, must be [1..BModels-1]!');
  {$R+}
end;


procedure TMainForm.GotoEntTGNSubMenuClick(Sender: TObject);
var
  tmpTGN: String;
  EntId: Integer;
begin
  {$R-}
  if (isBspLoad = False) then Exit;

  tmpTGN:=InputBox('Go to...', 'Entity targetname', '');
  if (tmpTGN <> '') then
    begin
      EntId:=FindEntityByTargetName(
        @Map.vEntities[0],
        Length(Map.vEntities),
        tmpTGN
      );
      if ((EntId > 0) and (EntId < Length(Map.vEntities))) then
        begin
          Self.Camera.ResetCamera(
            Map.vEntities[EntId].Origin,
            Map.vEntities[EntId].Angles.x*AngleToRadian,
            Map.vEntities[EntId].Angles.y*AngleToRadian - Pi/2
          );
        end;
    end;
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

procedure TMainForm.CloseMenuClick(Sender: TObject);
begin
  {$R-}
  Self.Close();
  {$R+}
end;

procedure TMainForm.TrackBarExpChange(Sender: TObject);
var
  expofs: Single;
begin
  {$R-}
  if (Self.ShaderFaces.UseProgram) then
    begin
      expofs:=Self.TrackBarExp.Position*0.1/(TrackBarExp.Max - TrackBarExp.Min);
      Self.ShaderFaces.Uniform1f('fLightmapExpShift', expofs);
      Self.ShaderFaces.FihishUseProgram;
    end;
  {$R+}
end;

procedure TMainForm.BtnLmpExpZeroClick(Sender: TObject);
begin
  {$R-}
  Self.TrackBarExp.Position:=0;
  {$R+}
end;

procedure TMainForm.ButtonSaveLmpClick(Sender: TObject);
var
  Targa: CImageManagerTGA;
  lmpOfs: Integer;
begin
  {$R-}
  if (isBspLoad = False) then Exit;
  if (Unit1.SelectedFaceIndex < 0) then Exit;

  if (Self.RadioGroupLmp.ItemIndex < 0)
    or (Self.RadioGroupLmp.ItemIndex >= CurrFaceExt.nStyles[FACEDRAW_USER])
    then Exit;

  if (Self.SaveDialogTGA.Execute) then
    begin
      lmpOfs:=CurrFaceExt.LmpByteFirst[FACEDRAW_USER];
      if (CurrFaceExt.isBump[FACEDRAW_USER])
      then lmpOfs:=lmpOfs + 4*SIZEOF_LIGHTMAP*Self.RadioGroupLmp.ItemIndex*CurrFaceExt.LmpArea[FACEDRAW_USER]
      else lmpOfs:=lmpOfs + 1*SIZEOF_LIGHTMAP*Self.RadioGroupLmp.ItemIndex*CurrFaceExt.LmpArea[FACEDRAW_USER];

      lmpOfs:=lmpOfs + SIZEOF_LIGHTMAP*SelectedBump*CurrFaceExt.LmpArea[FACEDRAW_USER];

      Targa:=CImageManagerTGA.CreateManager;
      Targa.ReserveImage(
        CurrFaceExt.LmpSz[FACEDRAW_USER].x,
        CurrFaceExt.LmpSz[FACEDRAW_USER].y,
        True
      );

      Targa.CopyFromRGBA(@Map.vLightmaps[FACEDRAW_USER][lmpOfs]);
      Targa.SaveToFile(Self.SaveDialogTGA.FileName);

      Targa.DeleteManager;
    end;
  {$R+}
end;

procedure TMainForm.BtnAtlasPageDownClick(Sender: TObject);
begin
  {$R-}
  Dec(Self.SelectedAtlasID);
  if (Self.SelectedAtlasID < 0) then Self.SelectedAtlasID:=0;

  Self.LblAtlasPage.Caption:=IntToStr(Self.SelectedAtlasID);
  {$R+}
end;

procedure TMainForm.BtnAtlasPageUpClick(Sender: TObject);
begin
  {$R-}
  Inc(Self.SelectedAtlasID);
  if (Self.SelectedAtlasID >= Self.LightmapMegatexture.CountMegatextures)
  then Self.SelectedAtlasID:=Self.LightmapMegatexture.CountMegatextures-1;
  if (Self.SelectedAtlasID < 0) then Self.SelectedAtlasID:=0;

  Self.LblAtlasPage.Caption:=IntToStr(Self.SelectedAtlasID);
  {$R+}
end;

procedure TMainForm.CBLmpPreviewRGBClick(Sender: TObject);
begin
  {$R-}
  Self.UpdatePreviewLightmap;
  {$R+}
end;

procedure TMainForm.ImageLmpPreviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  lmpColor: TColor;
begin
  {$R-}
  if (Self.ImageLmpPreview.Picture = nil) then Exit;

  lmpColor:=Self.ImageLmpPreview.Canvas.Pixels[X, Y];
  if (Self.CBLmpPreviewRGB.Checked) then
    begin
      Self.EditLmpPixelR.Caption:=IntToStr(GetRValue(lmpColor));
      Self.EditLmpPixelG.Caption:=IntToStr(GetRValue(lmpColor));
      Self.EditLmpPixelB.Caption:=IntToStr(GetRValue(lmpColor));
      Self.EditLmpPixelE.Caption:=' - ';
    end
  else
    begin
      Self.EditLmpPixelR.Caption:=' - ';
      Self.EditLmpPixelG.Caption:=' - ';
      Self.EditLmpPixelB.Caption:=' - ';
      Self.EditLmpPixelE.Caption:=IntToStr((GetRValue(lmpColor) - 128) div 8);
    end;
  {$R+}
end;

procedure TMainForm.BtnLmpBumpDownClick(Sender: TObject);
begin
  {$R-}
  if (isBspLoad = False) then Exit;
  if (Unit1.SelectedFaceIndex < 0) then Exit;

  Dec(SelectedBump);
  if (SelectedBump < 0) then SelectedBump:=0;

  Self.EditLmpBump.Caption:=IntToStr(SelectedBump);
  Self.UpdatePreviewLightmap;
  {$R+}
end;

procedure TMainForm.BtnLmpBumpUpClick(Sender: TObject);
var
  nBump: Integer;
begin
  {$R-}
  if (isBspLoad = False) then Exit;
  if (Unit1.SelectedFaceIndex < 0) then Exit;

  Inc(SelectedBump);

  nBump:=1;
  if (CurrFaceExt.isBump[FACEDRAW_USER]) then nBump:=4;
  if (SelectedBump >= nBump) then SelectedBump:=nBump-1;

  Self.EditLmpBump.Caption:=IntToStr(SelectedBump);
  Self.UpdatePreviewLightmap;
  {$R+}
end;

end.
