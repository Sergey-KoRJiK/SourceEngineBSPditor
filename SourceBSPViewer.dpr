program SourceBSPViewer;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  UnitUserTypes in 'Modules\UnitUserTypes.pas',
  UnitVec in 'Modules\UnitVec.pas',
  UnitOpenGLext in 'Modules\UnitOpenGLext.pas',
  UnitOpenGLErrorManager in 'Modules\UnitOpenGLErrorManager.pas',
  UnitOpenGLFPSCamera in 'Modules\UnitOpenGLFPSCamera.pas',
  UnitRenderingContextManager in 'Modules\UnitRenderingContextManager.pas',
  UnitShaderManager in 'Modules\UnitShaderManager.pas',
  UnitVertexBufferArrayManager in 'Modules\UnitVertexBufferArrayManager.pas',
  UnitMegatextureManager in 'Modules\UnitMegatextureManager.pas',
  UnitQueryPerformanceTimer in 'Modules\UnitQueryPerformanceTimer.pas',
  UnitRenderTimerManager in 'Modules\UnitRenderTimerManager.pas',
  UnitBSPstruct in 'Modules\SourceBSP\UnitBSPstruct.pas',
  UnitEntity in 'Modules\SourceBSP\UnitEntity.pas',
  UnitRescaling2D in 'Modules\UnitRescaling2D.pas',
  UnitQueryPerformanceProfiler in 'Modules\UnitQueryPerformanceProfiler.pas',
  UnitImageTGA in 'Modules\UnitImageTGA.pas',
  UnitRadianceHDR in 'Modules\UnitRadianceHDR.pas',
  UnitVTFMeowLib in 'Modules\UnitVTFMeowLib.pas',
  UnitBufferObjectManager in 'Modules\UnitBufferObjectManager.pas';

{$R *.res}
var
  MainForm: TMainForm;
  
begin
  Application.Initialize;
  Application.Title := 'Source BSP Editor';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
