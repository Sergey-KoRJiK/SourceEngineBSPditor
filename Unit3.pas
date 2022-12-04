unit Unit3;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Unit of Ambient Tool Form

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
  StdCtrls,
  ExtCtrls,
  {}
  UnitVec,
  UnitLightmap,
  UnitVisLeaf,
  UnitLeafAmbientLight,
  UnitToneMapControl, ComCtrls;

type
  TAmbToolForm = class(TForm)
    LabelSelSample: TLabel;
    EditSelectedSampleIndex: TEdit;
    GroupBox1: TGroupBox;
    LabelColInfo: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditR0: TEdit;
    EditG0: TEdit;
    EditB0: TEdit;
    EditE0: TEdit;
    EditR1: TEdit;
    EditG1: TEdit;
    EditB1: TEdit;
    EditE1: TEdit;
    EditR3: TEdit;
    EditG3: TEdit;
    EditB5: TEdit;
    EditE3: TEdit;
    EditR4: TEdit;
    EditG4: TEdit;
    EditB4: TEdit;
    EditE4: TEdit;
    EditR5: TEdit;
    EditG5: TEdit;
    EditB3: TEdit;
    EditB2: TEdit;
    EditE2: TEdit;
    EditG2: TEdit;
    EditR2: TEdit;
    EditE5: TEdit;
    ButtonSetNewColor: TButton;
    GroupBox2: TGroupBox;
    EditLX: TEdit;
    Label1: TLabel;
    EditLY: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    EditLZ: TEdit;
    EditRX: TEdit;
    EditRY: TEdit;
    EditRZ: TEdit;
    GroupBox3: TGroupBox;
    EditFinalColor: TEdit;
    Label10: TLabel;
    ShapeFC: TShape;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    EditFC0: TEdit;
    EditFC1: TEdit;
    EditFC2: TEdit;
    EditFC3: TEdit;
    EditFC4: TEdit;
    EditFC5: TEdit;
    ShapeFC0: TShape;
    ShapeFC1: TShape;
    ShapeFC2: TShape;
    ShapeFC3: TShape;
    ShapeFC4: TShape;
    ShapeFC5: TShape;
    TrackBarX: TTrackBar;
    TrackBarY: TTrackBar;
    TrackBarZ: TTrackBar;
    ShapeC0: TShape;
    ShapeC1: TShape;
    ShapeC2: TShape;
    ShapeC3: TShape;
    ShapeC4: TShape;
    ShapeC5: TShape;
    ColorDialog1: TColorDialog;
    //
    procedure UpdateAmbVisualInfo();
    procedure ClearAmbVisualInfo();
    procedure UpdateFinalColor();
    //
    procedure FormCreate(Sender: TObject);
    procedure ButtonSetNewColorClick(Sender: TObject);
    procedure TrackBarXChange(Sender: TObject);
    procedure TrackBarYChange(Sender: TObject);
    procedure TrackBarZChange(Sender: TObject);
    procedure ShapeC0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeC1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeC2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeC3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeC4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeC5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    CurrCube: PCubeInfo;
  public
    isHDRMode: Boolean;
    isAviableHDR: Boolean;
    isAviableLDR: Boolean;
    SelectedAmbCubeIndex: Integer;
    CurrLeafId: Integer;
    CurrLeafInfo: PVisLeafInfo;
    CurrAmbList: PLeafAmbientInfo;
    //
    CameraPos: tVec3f;
    CameraDir: tVec3f;
    //
    LocalAmbientSixColor: tRenderCubeAmbientColor;
    LocalFinalAmbientColor: tVec3f;
    //
    isFirstChange: Boolean;
    isCanRenderMainForm: PBoolean;
  end;

var
  AmbToolForm: TAmbToolForm;


implementation

{$R *.dfm}


procedure TAmbToolForm.UpdateFinalColor();
var
  r, g, b: Integer;
begin
  {$R-}
  GetAmbientLightAtPosition(CurrAmbList, @CameraPos, @LocalAmbientSixColor);
  GetFinalAmbientLightByNormal(@LocalAmbientSixColor, @CameraDir, @LocalFinalAmbientColor);

  // Final Color
  r:=Round(LocalFinalAmbientColor.x*255);
  g:=Round(LocalFinalAmbientColor.y*255);
  b:=Round(LocalFinalAmbientColor.z*255);
  Self.EditFinalColor.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC.Brush.Color:=RGB(r, g, b);

  // Color 0
  r:=Round(LocalAmbientSixColor[0].x*255);
  g:=Round(LocalAmbientSixColor[0].y*255);
  b:=Round(LocalAmbientSixColor[0].z*255);
  Self.EditFC0.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC0.Brush.Color:=RGB(r, g, b);

  // Color 1
  r:=Round(LocalAmbientSixColor[1].x*255);
  g:=Round(LocalAmbientSixColor[1].y*255);
  b:=Round(LocalAmbientSixColor[1].z*255);
  Self.EditFC1.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC1.Brush.Color:=RGB(r, g, b);

  // Color 2
  r:=Round(LocalAmbientSixColor[2].x*255);
  g:=Round(LocalAmbientSixColor[2].y*255);
  b:=Round(LocalAmbientSixColor[2].z*255);
  Self.EditFC2.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC2.Brush.Color:=RGB(r, g, b);

  // Color 3
  r:=Round(LocalAmbientSixColor[3].x*255);
  g:=Round(LocalAmbientSixColor[3].y*255);
  b:=Round(LocalAmbientSixColor[3].z*255);
  Self.EditFC3.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC3.Brush.Color:=RGB(r, g, b);

  // Color 4
  r:=Round(LocalAmbientSixColor[4].x*255);
  g:=Round(LocalAmbientSixColor[4].y*255);
  b:=Round(LocalAmbientSixColor[4].z*255);
  Self.EditFC4.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC4.Brush.Color:=RGB(r, g, b);

  // Color 5
  r:=Round(LocalAmbientSixColor[5].x*255);
  g:=Round(LocalAmbientSixColor[5].y*255);
  b:=Round(LocalAmbientSixColor[5].z*255);
  Self.EditFC5.Text:=IntToStr(r) + ', ' + IntToStr(g) + ', ' + IntToStr(b);

  if (r > 255) then r:=255;
  if (g > 255) then g:=255;
  if (b > 255) then b:=255;
  if (r < 0) then r:=0;
  if (g < 0) then g:=0;
  if (b < 0) then b:=0;
  Self.ShapeFC5.Brush.Color:=RGB(r, g, b);
  {$R+}
end;

procedure TAmbToolForm.FormCreate(Sender: TObject);
begin
  {$R-}
  Self.SelectedAmbCubeIndex:=-1;
  Self.CurrLeafId:=-1;
  Self.CurrLeafInfo:=nil;
  Self.CurrAmbList:=nil;
  Self.CurrCube:=nil;

  Self.LocalFinalAmbientColor:=VEC_ZERO;
  Self.LocalAmbientSixColor[0]:=VEC_ZERO;
  Self.LocalAmbientSixColor[1]:=VEC_ZERO;
  Self.LocalAmbientSixColor[2]:=VEC_ZERO;
  Self.LocalAmbientSixColor[3]:=VEC_ZERO;
  Self.LocalAmbientSixColor[4]:=VEC_ZERO;
  Self.LocalAmbientSixColor[5]:=VEC_ZERO
  {$R+}
end;

procedure TAmbToolForm.UpdateAmbVisualInfo();
begin
  {$R-}
  if (Self.SelectedAmbCubeIndex < 0) then
    begin
      Self.ClearAmbVisualInfo();
      Exit;
    end;

  Self.EditSelectedSampleIndex.Text:=IntToStr(Self.SelectedAmbCubeIndex);
  Self.CurrCube:=@Self.CurrAmbList.CubeList[Self.SelectedAmbCubeIndex];

  Self.EditE0.Text:=IntToStr(Self.CurrCube.RawColor[0].e);
  Self.EditE1.Text:=IntToStr(Self.CurrCube.RawColor[1].e);
  Self.EditE2.Text:=IntToStr(Self.CurrCube.RawColor[2].e);
  Self.EditE3.Text:=IntToStr(Self.CurrCube.RawColor[3].e);
  Self.EditE4.Text:=IntToStr(Self.CurrCube.RawColor[4].e);
  Self.EditE5.Text:=IntToStr(Self.CurrCube.RawColor[5].e);

  Self.EditR0.Text:=IntToStr(Self.CurrCube.RawColor[0].r);
  Self.EditR1.Text:=IntToStr(Self.CurrCube.RawColor[1].r);
  Self.EditR2.Text:=IntToStr(Self.CurrCube.RawColor[2].r);
  Self.EditR3.Text:=IntToStr(Self.CurrCube.RawColor[3].r);
  Self.EditR4.Text:=IntToStr(Self.CurrCube.RawColor[4].r);
  Self.EditR5.Text:=IntToStr(Self.CurrCube.RawColor[5].r);

  Self.EditG0.Text:=IntToStr(Self.CurrCube.RawColor[0].g);
  Self.EditG1.Text:=IntToStr(Self.CurrCube.RawColor[1].g);
  Self.EditG2.Text:=IntToStr(Self.CurrCube.RawColor[2].g);
  Self.EditG3.Text:=IntToStr(Self.CurrCube.RawColor[3].g);
  Self.EditG4.Text:=IntToStr(Self.CurrCube.RawColor[4].g);
  Self.EditG5.Text:=IntToStr(Self.CurrCube.RawColor[5].g);

  Self.EditB0.Text:=IntToStr(Self.CurrCube.RawColor[0].b);
  Self.EditB1.Text:=IntToStr(Self.CurrCube.RawColor[1].b);
  Self.EditB2.Text:=IntToStr(Self.CurrCube.RawColor[2].b);
  Self.EditB3.Text:=IntToStr(Self.CurrCube.RawColor[3].b);
  Self.EditB4.Text:=IntToStr(Self.CurrCube.RawColor[4].b);
  Self.EditB5.Text:=IntToStr(Self.CurrCube.RawColor[5].b);

  Self.ShapeC0.Brush.Color:=RGB(
    Self.CurrCube.RawColor[0].r,
    Self.CurrCube.RawColor[0].g,
    Self.CurrCube.RawColor[0].b
  );

  Self.ShapeC1.Brush.Color:=RGB(
    Self.CurrCube.RawColor[1].r,
    Self.CurrCube.RawColor[1].g,
    Self.CurrCube.RawColor[1].b
  );

  Self.ShapeC2.Brush.Color:=RGB(
    Self.CurrCube.RawColor[2].r,
    Self.CurrCube.RawColor[2].g,
    Self.CurrCube.RawColor[2].b
  );

  Self.ShapeC3.Brush.Color:=RGB(
    Self.CurrCube.RawColor[3].r,
    Self.CurrCube.RawColor[3].g,
    Self.CurrCube.RawColor[3].b
  );

  Self.ShapeC4.Brush.Color:=RGB(
    Self.CurrCube.RawColor[4].r,
    Self.CurrCube.RawColor[4].g,
    Self.CurrCube.RawColor[4].b
  );

  Self.ShapeC5.Brush.Color:=RGB(
    Self.CurrCube.RawColor[5].r,
    Self.CurrCube.RawColor[5].g,
    Self.CurrCube.RawColor[5].b
  );

  Self.isFirstChange:=True;
  Self.TrackBarX.Position:=Self.CurrCube.RawPosition.x;
  Self.EditLX.Text:=IntToStr(Self.CurrCube.RawPosition.x);
  Self.EditRX.Text:=FloatToStrF(Self.CurrCube.Position.x, ffFixed, 6, 6);

  Self.TrackBarY.Position:=Self.CurrCube.RawPosition.y;
  Self.EditLY.Text:=IntToStr(Self.CurrCube.RawPosition.y);
  Self.EditRY.Text:=FloatToStrF(Self.CurrCube.Position.y, ffFixed, 6, 6);

  Self.TrackBarZ.Position:=Self.CurrCube.RawPosition.z;
  Self.EditLZ.Text:=IntToStr(Self.CurrCube.RawPosition.z);
  Self.EditRZ.Text:=FloatToStrF(Self.CurrCube.Position.z, ffFixed, 6, 6);
  {$R+}
end;

procedure TAmbToolForm.ClearAmbVisualInfo();
begin
  {$R-}
  Self.SelectedAmbCubeIndex:=-1;
  Self.CurrLeafId:=-1;
  Self.CurrLeafInfo:=nil;
  Self.CurrAmbList:=nil;
  Self.CurrCube:=nil;

  Self.EditSelectedSampleIndex.Text:='No';

  Self.LocalFinalAmbientColor:=VEC_ZERO;
  Self.LocalAmbientSixColor[0]:=VEC_ZERO;
  Self.LocalAmbientSixColor[1]:=VEC_ZERO;
  Self.LocalAmbientSixColor[2]:=VEC_ZERO;
  Self.LocalAmbientSixColor[3]:=VEC_ZERO;
  Self.LocalAmbientSixColor[4]:=VEC_ZERO;
  Self.LocalAmbientSixColor[5]:=VEC_ZERO;
  {$R+}
end;

procedure TAmbToolForm.ButtonSetNewColorClick(Sender: TObject);
var
  tmp: Integer;
  errFlag: Boolean;
  tmpVec: tVec3f;
begin
  {$R-}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;
  errFlag:=False;
  
  // Red
  tmp:=StrToIntDef(Self.EditR0.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR0.Color:=clRed; errFlag:=True; end
  else begin Self.EditR0.Color:=clWhite; Self.CurrCube.RawColor[0].r:=tmp; end;

  tmp:=StrToIntDef(Self.EditR1.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR1.Color:=clRed; errFlag:=True; end
  else begin Self.EditR1.Color:=clWhite; Self.CurrCube.RawColor[1].r:=tmp; end;

  tmp:=StrToIntDef(Self.EditR2.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR2.Color:=clRed; errFlag:=True; end
  else begin Self.EditR2.Color:=clWhite; Self.CurrCube.RawColor[2].r:=tmp; end;

  tmp:=StrToIntDef(Self.EditR3.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR3.Color:=clRed; errFlag:=True; end
  else begin Self.EditR3.Color:=clWhite; Self.CurrCube.RawColor[3].r:=tmp; end;

  tmp:=StrToIntDef(Self.EditR4.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR4.Color:=clRed; errFlag:=True; end
  else begin Self.EditR4.Color:=clWhite; Self.CurrCube.RawColor[4].r:=tmp; end;

  tmp:=StrToIntDef(Self.EditR5.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditR5.Color:=clRed; errFlag:=True; end
  else begin Self.EditR5.Color:=clWhite; Self.CurrCube.RawColor[5].r:=tmp; end;

  // Green
  tmp:=StrToIntDef(Self.EditG0.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG0.Color:=clRed; errFlag:=True; end
  else begin Self.EditG0.Color:=clWhite; Self.CurrCube.RawColor[0].g:=tmp; end;

  tmp:=StrToIntDef(Self.EditG1.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG1.Color:=clRed; errFlag:=True; end
  else begin Self.EditG1.Color:=clWhite; Self.CurrCube.RawColor[1].g:=tmp; end;

  tmp:=StrToIntDef(Self.EditG2.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG2.Color:=clRed; errFlag:=True; end
  else begin Self.EditG2.Color:=clWhite; Self.CurrCube.RawColor[2].g:=tmp; end;

  tmp:=StrToIntDef(Self.EditG3.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG3.Color:=clRed; errFlag:=True; end
  else begin Self.EditG3.Color:=clWhite; Self.CurrCube.RawColor[3].g:=tmp; end;

  tmp:=StrToIntDef(Self.EditG4.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG4.Color:=clRed; errFlag:=True; end
  else begin Self.EditG4.Color:=clWhite; Self.CurrCube.RawColor[4].g:=tmp; end;

  tmp:=StrToIntDef(Self.EditG5.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditG5.Color:=clRed; errFlag:=True; end
  else begin Self.EditG5.Color:=clWhite; Self.CurrCube.RawColor[5].g:=tmp; end;

  // Blue
  tmp:=StrToIntDef(Self.EditB0.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB0.Color:=clRed; errFlag:=True; end
  else begin Self.EditB0.Color:=clWhite; Self.CurrCube.RawColor[0].b:=tmp; end;

  tmp:=StrToIntDef(Self.EditB1.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB1.Color:=clRed; errFlag:=True; end
  else begin Self.EditB1.Color:=clWhite; Self.CurrCube.RawColor[1].b:=tmp; end;

  tmp:=StrToIntDef(Self.EditB2.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB2.Color:=clRed; errFlag:=True; end
  else begin Self.EditB2.Color:=clWhite; Self.CurrCube.RawColor[2].b:=tmp; end;

  tmp:=StrToIntDef(Self.EditB3.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB3.Color:=clRed; errFlag:=True; end
  else begin Self.EditB3.Color:=clWhite; Self.CurrCube.RawColor[3].b:=tmp; end;

  tmp:=StrToIntDef(Self.EditB4.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB4.Color:=clRed; errFlag:=True; end
  else begin Self.EditB4.Color:=clWhite; Self.CurrCube.RawColor[4].b:=tmp; end;

  tmp:=StrToIntDef(Self.EditB5.Text, -1000);
  if ((tmp < 0) or (tmp > 255)) then begin Self.EditB5.Color:=clRed; errFlag:=True; end
  else begin Self.EditB5.Color:=clWhite; Self.CurrCube.RawColor[5].b:=tmp; end;

  // Exp
  tmp:=StrToIntDef(Self.EditE0.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE0.Color:=clRed; errFlag:=True; end
  else begin Self.EditE0.Color:=clWhite; Self.CurrCube.RawColor[0].e:=tmp; end;

  tmp:=StrToIntDef(Self.EditE1.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE1.Color:=clRed; errFlag:=True; end
  else begin Self.EditE1.Color:=clWhite; Self.CurrCube.RawColor[1].e:=tmp; end;

  tmp:=StrToIntDef(Self.EditE2.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE2.Color:=clRed; errFlag:=True; end
  else begin Self.EditE2.Color:=clWhite; Self.CurrCube.RawColor[2].e:=tmp; end;

  tmp:=StrToIntDef(Self.EditE3.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE3.Color:=clRed; errFlag:=True; end
  else begin Self.EditE3.Color:=clWhite; Self.CurrCube.RawColor[3].e:=tmp; end;

  tmp:=StrToIntDef(Self.EditE4.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE4.Color:=clRed; errFlag:=True; end
  else begin Self.EditE4.Color:=clWhite; Self.CurrCube.RawColor[4].e:=tmp; end;

  tmp:=StrToIntDef(Self.EditE5.Text, -1000);
  if ((tmp < -127) or (tmp > 128)) then begin Self.EditE5.Color:=clRed; errFlag:=True; end
  else begin Self.EditE5.Color:=clWhite; Self.CurrCube.RawColor[5].e:=tmp; end;

  if (errFlag) then ShowMessage('Some field is invalid (red), fix it!')
  else
    begin
      for tmp:=0 to 5 do
        begin
          RGBExpToVec3f(@Self.CurrCube.RawColor[tmp], @tmpVec);
          ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
          ClampVec3fToOne(@tmpVec);
          Self.CurrCube.RenderColor[tmp]:=tmpVec;
        end;

      Self.ShapeC0.Brush.Color:=RGB(
        Self.CurrCube.RawColor[0].r,
        Self.CurrCube.RawColor[0].g,
        Self.CurrCube.RawColor[0].b
      );

      Self.ShapeC1.Brush.Color:=RGB(
        Self.CurrCube.RawColor[1].r,
        Self.CurrCube.RawColor[1].g,
        Self.CurrCube.RawColor[1].b
      );

      Self.ShapeC2.Brush.Color:=RGB(
        Self.CurrCube.RawColor[2].r,
        Self.CurrCube.RawColor[2].g,
        Self.CurrCube.RawColor[2].b
      );

      Self.ShapeC3.Brush.Color:=RGB(
        Self.CurrCube.RawColor[3].r,
        Self.CurrCube.RawColor[3].g,
        Self.CurrCube.RawColor[3].b
      );

      Self.ShapeC4.Brush.Color:=RGB(
        Self.CurrCube.RawColor[4].r,
        Self.CurrCube.RawColor[4].g,
        Self.CurrCube.RawColor[4].b
      );

      Self.ShapeC5.Brush.Color:=RGB(
        Self.CurrCube.RawColor[5].r,
        Self.CurrCube.RawColor[5].g,
        Self.CurrCube.RawColor[5].b
      );
    end;
  {$R+}
end;

procedure TAmbToolForm.TrackBarXChange(Sender: TObject);
var
  tmp: Single;
begin
    {$R-}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;  
  if (Self.isFirstChange) then
    begin
      Self.isFirstChange:=False;
      Exit;
    end;

  Self.CurrCube.RawPosition.x:=Self.TrackBarX.Position;
  if (Self.CurrCube.RawPosition.x < 0) then Self.CurrCube.RawPosition.x:=0;
  if (Self.CurrCube.RawPosition.x > 255) then Self.CurrCube.RawPosition.x:=255;

  tmp:=Self.CurrCube.RawPosition.x*inv255f;
  Self.CurrCube.Position.x:=Self.CurrLeafInfo.BBOXf.vMin.x*(1.0 - tmp)
    + Self.CurrLeafInfo.BBOXf.vMax.x*(tmp);

  GetCubeBBOXfByPosAndSize(
    @Self.CurrCube.BBOXf,
    Self.CurrCube.Position,
    AmbientCubeSize
  );

  Self.EditLX.Text:=IntToStr(Self.CurrCube.RawPosition.x);
  Self.EditRX.Text:=FloatToStrF(Self.CurrCube.Position.x, ffFixed, 6, 6);
  {$R+}
end;

procedure TAmbToolForm.TrackBarYChange(Sender: TObject);
var
  tmp: Single;
begin
    {$R-}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;
  if (Self.isFirstChange) then
    begin
      Self.isFirstChange:=False;
      Exit;
    end;

  Self.CurrCube.RawPosition.y:=Self.TrackBarY.Position;
  if (Self.CurrCube.RawPosition.y < 0) then Self.CurrCube.RawPosition.y:=0;
  if (Self.CurrCube.RawPosition.y > 255) then Self.CurrCube.RawPosition.y:=255;

  tmp:=Self.CurrCube.RawPosition.y*inv255f;
  Self.CurrCube.Position.y:=Self.CurrLeafInfo.BBOXf.vMin.y*(1.0 - tmp)
    + Self.CurrLeafInfo.BBOXf.vMax.y*(tmp);

  GetCubeBBOXfByPosAndSize(
    @Self.CurrCube.BBOXf,
    Self.CurrCube.Position,
    AmbientCubeSize
  );

  Self.EditLY.Text:=IntToStr(Self.CurrCube.RawPosition.y);
  Self.EditRY.Text:=FloatToStrF(Self.CurrCube.Position.y, ffFixed, 6, 6);
  {$R+}
end;

procedure TAmbToolForm.TrackBarZChange(Sender: TObject);
var
  tmp: Single;
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;
  if (Self.isFirstChange) then
    begin
      Self.isFirstChange:=False;
      Exit;
    end;

  Self.CurrCube.RawPosition.z:=Self.TrackBarZ.Position;
  if (Self.CurrCube.RawPosition.z < 0) then Self.CurrCube.RawPosition.z:=0;
  if (Self.CurrCube.RawPosition.z > 255) then Self.CurrCube.RawPosition.z:=255;

  tmp:=Self.CurrCube.RawPosition.z*inv255f;
  Self.CurrCube.Position.z:=Self.CurrLeafInfo.BBOXf.vMin.z*(1.0 - tmp)
    + Self.CurrLeafInfo.BBOXf.vMax.z*(tmp);

  GetCubeBBOXfByPosAndSize(
    @Self.CurrCube.BBOXf,
    Self.CurrCube.Position,
    AmbientCubeSize
  );

  Self.EditLZ.Text:=IntToStr(Self.CurrCube.RawPosition.z);
  Self.EditRZ.Text:=FloatToStrF(Self.CurrCube.Position.z, ffFixed, 6, 6);
  {$R-}
end;

procedure TAmbToolForm.ShapeC0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  isCanRenderMainForm^:=False;
  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC0.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[0].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[0].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[0].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE0.Text:=IntToStr(Self.CurrCube.RawColor[0].e);
      Self.EditR0.Text:=IntToStr(Self.CurrCube.RawColor[0].r);
      Self.EditG0.Text:=IntToStr(Self.CurrCube.RawColor[0].g);
      Self.EditB0.Text:=IntToStr(Self.CurrCube.RawColor[0].b);
    end;
  {$R-}
end;

procedure TAmbToolForm.ShapeC1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  isCanRenderMainForm^:=False;
  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC1.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[1].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[1].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[1].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE1.Text:=IntToStr(Self.CurrCube.RawColor[1].e);
      Self.EditR1.Text:=IntToStr(Self.CurrCube.RawColor[1].r);
      Self.EditG1.Text:=IntToStr(Self.CurrCube.RawColor[1].g);
      Self.EditB1.Text:=IntToStr(Self.CurrCube.RawColor[1].b);
    end;
  {$R-}
end;

procedure TAmbToolForm.ShapeC2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  isCanRenderMainForm^:=False;
  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC2.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[2].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[2].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[2].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE2.Text:=IntToStr(Self.CurrCube.RawColor[2].e);
      Self.EditR2.Text:=IntToStr(Self.CurrCube.RawColor[2].r);
      Self.EditG2.Text:=IntToStr(Self.CurrCube.RawColor[2].g);
      Self.EditB2.Text:=IntToStr(Self.CurrCube.RawColor[2].b);
    end;
  {$R-}
end;

procedure TAmbToolForm.ShapeC3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  isCanRenderMainForm^:=False;
  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC3.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[3].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[3].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[3].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE3.Text:=IntToStr(Self.CurrCube.RawColor[3].e);
      Self.EditR3.Text:=IntToStr(Self.CurrCube.RawColor[3].r);
      Self.EditG3.Text:=IntToStr(Self.CurrCube.RawColor[3].g);
      Self.EditB3.Text:=IntToStr(Self.CurrCube.RawColor[3].b);
    end;
  {$R-}
end;

procedure TAmbToolForm.ShapeC4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  isCanRenderMainForm^:=False;
  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC4.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[4].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[4].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[4].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE4.Text:=IntToStr(Self.CurrCube.RawColor[4].e);
      Self.EditR4.Text:=IntToStr(Self.CurrCube.RawColor[4].r);
      Self.EditG4.Text:=IntToStr(Self.CurrCube.RawColor[4].g);
      Self.EditB4.Text:=IntToStr(Self.CurrCube.RawColor[4].b);
    end;
  {$R-}
end;

procedure TAmbToolForm.ShapeC5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$R+}
  if (Self.SelectedAmbCubeIndex < 0) then Exit;

  if (Self.ColorDialog1.Execute) then
    begin
      Self.ShapeC5.Brush.Color:=Self.ColorDialog1.Color;
      Self.CurrCube.RawColor[5].r:=GetRValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[5].g:=GetGValue(Self.ColorDialog1.Color);
      Self.CurrCube.RawColor[5].b:=GetBValue(Self.ColorDialog1.Color);

      Self.EditE5.Text:=IntToStr(Self.CurrCube.RawColor[5].e);
      Self.EditR5.Text:=IntToStr(Self.CurrCube.RawColor[5].r);
      Self.EditG5.Text:=IntToStr(Self.CurrCube.RawColor[5].g);
      Self.EditB5.Text:=IntToStr(Self.CurrCube.RawColor[5].b);
    end;
  {$R-}
end;

end.
