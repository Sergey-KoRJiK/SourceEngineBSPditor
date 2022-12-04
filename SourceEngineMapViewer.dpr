program SourceEngineMapViewer;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus
// Contain all unit modules

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  EXTOpengl32Glew32 in 'EXTOpengl32Glew32.pas',
  UnitOpenGLAdditional in 'UnitOpenGLAdditional.pas',
  UnitOpenGLFPSCamera in 'UnitOpenGLFPSCamera.pas',
  UnitVec in 'Modules\UnitVec.pas',
  UnitBSPstruct in 'Modules\UnitBSPstruct.pas',
  UnitEntity in 'Modules\UnitEntity.pas',
  UnitPlane in 'Modules\UnitPlane.pas',
  UnitTexture in 'Modules\UnitTexture.pas',
  UnitVertex in 'Modules\UnitVertex.pas',
  UnitMapHeader in 'Modules\UnitMapHeader.pas',
  UnitPVS in 'Modules\UnitPVS.pas',
  UnitNode in 'Modules\UnitNode.pas',
  UnitFace in 'Modules\UnitFace.pas',
  UnitVisLeaf in 'Modules\UnitVisLeaf.pas',
  UnitMarkSurface in 'Modules\UnitMarkSurface.pas',
  UnitEdge in 'Modules\UnitEdge.pas',
  UnitBrushModel in 'Modules\UnitBrushModel.pas',
  UnitLightmap in 'Modules\UnitLightmap.pas',
  UnitMapFog in 'Modules\UnitMapFog.pas',
  UnitRayTraceOpenGL in 'UnitRayTraceOpenGL.pas',
  Unit2 in 'Unit2.pas' {FaceToolForm},
  UnitRadianceHDR in 'Modules\UnitRadianceHDR.pas',
  UnitToneMapControl in 'UnitToneMapControl.pas',
  UnitDisplacement in 'Modules\UnitDisplacement.pas',
  UnitLeafAmbientLight in 'Modules\UnitLeafAmbientLight.pas',
  Unit3 in 'Unit3.pas' {AmbToolForm},
  UnitGameLump in 'Modules\UnitGameLump.pas';

{$R *.res}
var
  MainForm: TMainForm;
  
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
