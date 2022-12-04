unit Unit2;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Unit of Face Tool Form

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
  ExtCtrls,
  StdCtrls,
  ComCtrls,
  {}
  UnitVec,
  UnitLightmap,         
  UnitFace,
  UnitRadianceHDR,
  UnitToneMapControl;

type
  TFaceToolForm = class(TForm)
    LabelFaceIndex: TLabel;
    EditFaceIndex: TEdit;
    LabelBump: TLabel;
    EditBump: TEdit;
    LabelPlaneIndex: TLabel;
    EditPlaneIndex: TEdit;
    EditTexInfoIndex: TEdit;
    EditLeafIndex: TEdit;
    LabelLeafIndex: TLabel;
    LabelOrigFace: TLabel;
    EditOrigFace: TEdit;
    LabelEntBrush: TLabel;
    EditEntBrush: TEdit;
    LabelTexInfoIndex: TLabel;
    EditStyle0: TEdit;
    LabelStyle0: TLabel;
    LabelStyle1: TLabel;
    EditStyle1: TEdit;
    EditStyle2: TEdit;
    LabelStyle2: TLabel;
    LabelStyle3: TLabel;
    EditStyle3: TEdit;
    LabelLmpW: TLabel;
    EditLmpW: TEdit;
    EditLmpH: TEdit;
    LabelLmpH: TLabel;
    LabelLmpOffset: TLabel;
    EditLmpOffset: TEdit;
    RadioGroupLmp: TRadioGroup;
    ButtonSaveHDR: TButton;
    ButtonLoadHDR: TButton;
    OpenDialogHDR: TOpenDialog;
    SaveDialogHDR: TSaveDialog;
    GroupBoxTM: TGroupBox;
    LabelMaxIntensity: TLabel;
    EditMaxIntensity: TEdit;
    UpDownMaxIntensity: TUpDown;
    ButtonToneMap: TButton;
    LabelRatioHDR: TLabel;
    EditRatioHDR: TEdit;
    LabelDispIndex: TLabel;
    EditDispIndex: TEdit;
    GroupBox1: TGroupBox;
    LabelColInfo: TLabel;
    LabelAvg0: TLabel;
    LabelAvg1: TLabel;
    LabelAvg2: TLabel;
    LabelAvg3: TLabel;
    //
    procedure UpdateFaceVisualInfo();
    procedure ClearFaceVisualInfo();
    //
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveHDRClick(Sender: TObject);
    procedure ButtonLoadHDRClick(Sender: TObject);
    procedure UpDownMaxIntensityChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ButtonToneMapClick(Sender: TObject);
  private
    //
  public
    isHDRMode: Boolean;
    isAviableHDR: Boolean;
    isAviableLDR: Boolean;
    lpToneMapScale: PSingle;
    isNeedToneMapping: Boolean;
    FaceSelectedIndex: Integer;
    SelectedStyle: Integer;
    CurrFace: PFace;
    CurrFaceInfo: PFaceInfo;
  end;

var
  FaceToolForm: TFaceToolForm;


implementation

{$R *.dfm}


procedure TFaceToolForm.FormCreate(Sender: TObject);
begin
  {$R-}
  Self.lpToneMapScale:=nil;
  Self.isNeedToneMapping:=False;
  Self.FaceSelectedIndex:=-1;
  Self.CurrFace:=nil;
  Self.CurrFaceInfo:=nil;
  {$R+}
end;


procedure TFaceToolForm.UpdateFaceVisualInfo();
var
  i: Integer;
begin
  {$R-}
  if (Self.FaceSelectedIndex < 0) then
    begin
      Self.ClearFaceVisualInfo();
      Exit;
    end;

  Self.EditFaceIndex.Text:=IntToStr(Self.FaceSelectedIndex);
  Self.EditPlaneIndex.Text:=IntToStr(Self.CurrFace.iPlane);
  Self.EditTexInfoIndex.Text:=IntToStr(Self.CurrFace.iTextureInfo);
  Self.EditLeafIndex.Text:=IntToStr(Self.CurrFaceInfo.VisLeafId);
  Self.EditOrigFace.Text:=IntToStr(Self.CurrFace.OrigFaceIndex);

  if (Self.CurrFace.DispInfoIndex < 0) then Self.EditDispIndex.Text:='No'
  else Self.EditDispIndex.Text:=IntToStr(Self.CurrFace.DispInfoIndex);

  if (Self.CurrFaceInfo.BrushId <= 0) then Self.EditEntBrush.Text:='is World'
  else Self.EditEntBrush.Text:=IntToStr(Self.CurrFaceInfo.BrushId);

  if (Self.CurrFace.nStyles[0] = 255) then
    begin
      Self.EditStyle0.Text:='No';
      Self.LabelAvg0.Caption:='No';
    end
  else
    begin
      Self.EditStyle0.Text:=IntToStr(Self.CurrFace.nStyles[0]);
      if (Self.isHDRMode = False)
      then Self.LabelAvg0.Caption:='Style[0]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmp[0])
      else Self.LabelAvg0.Caption:='Style[0]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmpHDR[0]);
    end;

  if (Self.CurrFace.nStyles[1] = 255) then
    begin
      Self.EditStyle1.Text:='No';
      Self.LabelAvg1.Caption:='No';
    end
  else
    begin
      Self.EditStyle1.Text:=IntToStr(Self.CurrFace.nStyles[1]);
      if (Self.isHDRMode = False)
      then Self.LabelAvg1.Caption:='Style[1]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmp[1])
      else Self.LabelAvg1.Caption:='Style[1]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmpHDR[1]);
    end;

  if (Self.CurrFace.nStyles[2] = 255) then
    begin
      Self.EditStyle2.Text:='No';
      Self.LabelAvg2.Caption:='No';
    end
  else
    begin
      Self.EditStyle2.Text:=IntToStr(Self.CurrFace.nStyles[2]);
      if (Self.isHDRMode = False)
      then Self.LabelAvg2.Caption:='Style[2]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmp[2])
      else Self.LabelAvg2.Caption:='Style[2]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmpHDR[2]);
    end;

  if (Self.CurrFace.nStyles[3] = 255) then
    begin
      Self.EditStyle3.Text:='No';
      Self.LabelAvg3.Caption:='No';
    end
  else
    begin
      Self.EditStyle3.Text:=IntToStr(Self.CurrFace.nStyles[3]);
      if (Self.isHDRMode = False)
      then Self.LabelAvg3.Caption:='Style[3]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmp[3])
      else Self.LabelAvg3.Caption:='Style[3]: ' + LightmapToStr(Self.CurrFaceInfo.AverageLmpHDR[3]);
    end;

  Self.RadioGroupLmp.Items.Clear;
  for i:=0 to (Self.CurrFaceInfo.CountLightStyles - 1) do
    begin
      Self.RadioGroupLmp.Items.Append('Style ' + IntToStr(i));
    end;
  Self.RadioGroupLmp.ItemIndex:=0;

  Self.EditLmpW.Text:=IntToStr(Self.CurrFaceInfo.LmpSize.X);
  Self.EditLmpH.Text:=IntToStr(Self.CurrFaceInfo.LmpSize.Y);
  Self.EditLmpOffset.Text:=IntToStr(Self.CurrFace.nLightmapOffset);
  Self.EditBump.Text:=BoolToStr(Self.CurrFaceInfo.isHaveBumpLightmap, True);

  if (Self.isHDRMode) then
    begin
      Self.EditRatioHDR.Text:=FloatToStrF(
        Self.CurrFaceInfo.StylesRatioHDR[SelectedStyle], ffFixed, 6, 6);
    end
  else
    begin
      Self.EditRatioHDR.Text:=FloatToStrF(
        Self.CurrFaceInfo.StylesRatio[SelectedStyle], ffFixed, 6, 6);
    end;

  Self.ButtonSaveHDR.Enabled:=True;
  Self.ButtonLoadHDR.Enabled:=True;
  {$R+}
end;

procedure TFaceToolForm.ClearFaceVisualInfo();
begin
  {$R-}
  Self.EditFaceIndex.Text:='No';
  Self.EditPlaneIndex.Text:='No';
  Self.EditTexInfoIndex.Text:='No';
  Self.EditLeafIndex.Text:='No';
  Self.EditOrigFace.Text:='No'; 
  Self.EditEntBrush.Text:='is World';
  Self.EditDispIndex.Text:='No';

  Self.EditStyle0.Text:='No';
  Self.EditStyle1.Text:='No';
  Self.EditStyle2.Text:='No';
  Self.EditStyle3.Text:='No';

  Self.LabelAvg0.Caption:='No';
  Self.LabelAvg1.Caption:='No';
  Self.LabelAvg2.Caption:='No';
  Self.LabelAvg3.Caption:='No';

  Self.EditLmpW.Text:='No';
  Self.EditLmpH.Text:='No';
  Self.EditLmpOffset.Text:='No';
  Self.EditBump.Text:='No';
  Self.EditRatioHDR.Text:='No';

  Self.ButtonSaveHDR.Enabled:=False;
  Self.ButtonLoadHDR.Enabled:=False;

  Self.FaceSelectedIndex:=-1;
  Self.CurrFace:=nil;
  Self.CurrFaceInfo:=nil;

  Self.RadioGroupLmp.ItemIndex:=0;
  Self.RadioGroupLmp.Items.Clear;
  {$R+}
end;

procedure TFaceToolForm.ButtonSaveHDRClick(Sender: TObject);
begin
  {$R-}
  if (Self.FaceSelectedIndex < 0) then Exit;
  if (Self.RadioGroupLmp.ItemIndex >= Self.CurrFaceInfo.CountLightStyles) then Exit;

  if (Self.SaveDialogHDR.Execute) then
    begin
      if (Self.isHDRMode) then
        begin
          case (Self.RadioGroupLmp.ItemIndex) of
            0:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[0]
                );
            1:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[1]
                );
            2:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[2]
                );
            3:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[3]
                );
          end;
        end
      else
        begin
          case (Self.RadioGroupLmp.ItemIndex) of
            0:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[0]
                );
            1:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[1]
                );
            2:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[2]
                );
            3:  SaveToHDRFile(
                  Self.SaveDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[3]
                );
          end;
        end;
    end;
  {$R+}
end;

procedure TFaceToolForm.ButtonLoadHDRClick(Sender: TObject);
var
  isLoaded: eLoadStateHDR;
  tmp: DWORD;
begin
  {$R-}
  if (Self.FaceSelectedIndex < 0) then Exit;
  if (Self.RadioGroupLmp.ItemIndex >= Self.CurrFaceInfo.CountLightStyles) then Exit;
  if (Self.RadioGroupLmp.ItemIndex < 0) then Exit;

  if (Self.OpenDialogHDR.Execute) then
    begin
      isLoaded:=hdrOK;
      if (Self.isHDRMode) then
        begin
          case (Self.RadioGroupLmp.ItemIndex) of
            0:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[0]
                );
            1:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[1]
                );
            2:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[2]
                );
            3:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmapHDR[3]
                );
          end;
        end
      else
        begin
          case (Self.RadioGroupLmp.ItemIndex) of
            0:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[0]
                );
            1:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[1]
                );
            2:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[2]
                );
            3:  isLoaded:=LoadFromHDRFile(
                  Self.OpenDialogHDR.FileName,
                  Self.CurrFaceInfo.LmpSize.X,
                  Self.CurrFaceInfo.LmpSize.Y,
                  Self.CurrFaceInfo.lpFirstLightmap[3]
                );
          end;
        end;

      if (isLoaded <> hdrOK) then
        begin
          ShowMessage(ShowLoadHDRError(isLoaded));
        end
      else
        begin
          CreateLightmapTexture(
            Self.CurrFaceInfo,
            Self.RadioGroupLmp.ItemIndex,
            Self.lpToneMapScale,
            isHDRMode
          );
          if (Self.isHDRMode) then
            begin
              GetAverageRGBExp32(
                Self.CurrFaceInfo.lpFirstLightmapHDR[Self.RadioGroupLmp.ItemIndex],
                @Self.CurrFaceInfo.AverageLmpHDR[Self.RadioGroupLmp.ItemIndex],
                Self.CurrFaceInfo.LmpSize
              );
              tmp:=DWORD(Self.CurrFaceInfo.lpFirstLightmapHDR[0]) - (DWORD(Self.RadioGroupLmp.ItemIndex) + 1);
              PLightmapColor(tmp)^:=Self.CurrFaceInfo.AverageLmpHDR[Self.RadioGroupLmp.ItemIndex];
            end
          else
            begin
              GetAverageRGBExp32(
                Self.CurrFaceInfo.lpFirstLightmap[Self.RadioGroupLmp.ItemIndex],
                @Self.CurrFaceInfo.AverageLmp[Self.RadioGroupLmp.ItemIndex],
                Self.CurrFaceInfo.LmpSize
              );
              tmp:=DWORD(Self.CurrFaceInfo.lpFirstLightmap[0]) - (DWORD(Self.RadioGroupLmp.ItemIndex) + 1);
              PLightmapColor(tmp)^:=Self.CurrFaceInfo.AverageLmp[Self.RadioGroupLmp.ItemIndex];
            end;
          UpdateFaceRatio(Self.CurrFaceInfo, Self.isAviableHDR, Self.isAviableLDR);
          Self.UpdateFaceVisualInfo();
        end;
    end;
  {$R+}
end;

procedure TFaceToolForm.UpDownMaxIntensityChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  {$R-}
  Self.lpToneMapScale^:=Self.UpDownMaxIntensity.Position*0.1;
  Self.EditMaxIntensity.Text:=FloatToStrF(Self.lpToneMapScale^, ffFixed, 3, 1);
  {$R+}
end;

procedure TFaceToolForm.ButtonToneMapClick(Sender: TObject);
begin
  {$R-}
  Self.isNeedToneMapping:=True;
  {$R+}
end;

end.
