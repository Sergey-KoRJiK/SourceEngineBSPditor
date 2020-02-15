object FaceToolForm: TFaceToolForm
  Left = 1319
  Top = 297
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Face Tools'
  ClientHeight = 547
  ClientWidth = 155
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFaceIndex: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Face Index '
    Layout = tlCenter
  end
  object LabelBump: TLabel
    Left = 8
    Top = 256
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Is have Bumpmap? '
    Layout = tlCenter
  end
  object LabelPlaneIndex: TLabel
    Left = 8
    Top = 24
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Plane Index '
    Layout = tlCenter
  end
  object LabelTexInfoIndex: TLabel
    Left = 8
    Top = 40
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Tex Info Index '
    Layout = tlCenter
  end
  object LabelLeafIndex: TLabel
    Left = 8
    Top = 92
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Leaf Index '
    Layout = tlCenter
  end
  object LabelOrigFace: TLabel
    Left = 8
    Top = 74
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Brush Face Index'
    Layout = tlCenter
  end
  object LabelEntBrush: TLabel
    Left = 8
    Top = 56
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Entity Brush id'
    Layout = tlCenter
  end
  object LabelStyle0: TLabel
    Left = 8
    Top = 130
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Lightmap Style0 Index'
    Layout = tlCenter
  end
  object LabelStyle1: TLabel
    Left = 8
    Top = 146
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Lightmap Style1 Index'
    Layout = tlCenter
  end
  object LabelStyle2: TLabel
    Left = 8
    Top = 162
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Lightmap Style2 Index'
    Layout = tlCenter
  end
  object LabelStyle3: TLabel
    Left = 8
    Top = 178
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Lightmap Style3 Index'
    Layout = tlCenter
  end
  object LabelLmpW: TLabel
    Left = 8
    Top = 204
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Lightmaps Width'
    Layout = tlCenter
  end
  object LabelLmpH: TLabel
    Left = 8
    Top = 220
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Lightmaps Height'
    Layout = tlCenter
  end
  object LabelLmpOffset: TLabel
    Left = 8
    Top = 236
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Lightmaps Offset'
    Layout = tlCenter
  end
  object LabelRatioHDR: TLabel
    Left = 8
    Top = 276
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'HDR/RGB ratio'
    Layout = tlCenter
  end
  object LabelDispIndex: TLabel
    Left = 8
    Top = 108
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Displacement Id'
    Layout = tlCenter
  end
  object EditFaceIndex: TEdit
    Left = 96
    Top = 8
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    Text = 'No'
  end
  object EditBump: TEdit
    Left = 112
    Top = 256
    Width = 33
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 1
    Text = 'No'
  end
  object EditPlaneIndex: TEdit
    Left = 96
    Top = 24
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 2
    Text = 'No'
  end
  object EditTexInfoIndex: TEdit
    Left = 96
    Top = 40
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
    Text = 'No'
  end
  object EditLeafIndex: TEdit
    Left = 96
    Top = 92
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object EditOrigFace: TEdit
    Left = 96
    Top = 74
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 5
    Text = 'No'
  end
  object EditEntBrush: TEdit
    Left = 96
    Top = 56
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 6
    Text = 'is World'
  end
  object EditStyle0: TEdit
    Left = 120
    Top = 130
    Width = 30
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 7
    Text = 'No'
  end
  object EditStyle1: TEdit
    Left = 120
    Top = 146
    Width = 30
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 8
    Text = 'No'
  end
  object EditStyle2: TEdit
    Left = 120
    Top = 162
    Width = 30
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 9
    Text = 'No'
  end
  object EditStyle3: TEdit
    Left = 120
    Top = 178
    Width = 30
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 10
    Text = 'No'
  end
  object EditLmpW: TEdit
    Left = 95
    Top = 204
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 11
    Text = 'No'
  end
  object EditLmpH: TEdit
    Left = 95
    Top = 220
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 12
    Text = 'No'
  end
  object EditLmpOffset: TEdit
    Left = 95
    Top = 236
    Width = 48
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 13
    Text = 'No'
  end
  object RadioGroupLmp: TRadioGroup
    Left = 1
    Top = 296
    Width = 153
    Height = 57
    Caption = ' Save\Load Lightmaps '
    Columns = 2
    Ctl3D = False
    ItemIndex = 0
    Items.Strings = (
      'Style 0'
      'Style 1'
      'Style 2'
      'Style 3')
    ParentCtl3D = False
    TabOrder = 14
    TabStop = True
  end
  object ButtonSaveHDR: TButton
    Left = 2
    Top = 352
    Width = 73
    Height = 25
    Caption = 'Save HDR'
    Enabled = False
    TabOrder = 15
    OnClick = ButtonSaveHDRClick
  end
  object ButtonLoadHDR: TButton
    Left = 80
    Top = 352
    Width = 73
    Height = 25
    Caption = 'Load HDR'
    Enabled = False
    TabOrder = 16
    OnClick = ButtonLoadHDRClick
  end
  object GroupBoxTM: TGroupBox
    Left = 1
    Top = 488
    Width = 153
    Height = 57
    Caption = ' Scence Tone Map Control '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 17
    object LabelMaxIntensity: TLabel
      Left = 8
      Top = 16
      Width = 73
      Height = 17
      AutoSize = False
      Caption = 'Scale Intensity'
      Layout = tlCenter
    end
    object EditMaxIntensity: TEdit
      Left = 88
      Top = 16
      Width = 33
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      Text = '1,0'
    end
    object UpDownMaxIntensity: TUpDown
      Left = 120
      Top = 16
      Width = 17
      Height = 21
      Min = 2
      Position = 10
      TabOrder = 1
      OnChanging = UpDownMaxIntensityChanging
    end
    object ButtonToneMap: TButton
      Left = 8
      Top = 38
      Width = 105
      Height = 17
      Caption = 'Apply on All Faces'
      TabOrder = 2
      OnClick = ButtonToneMapClick
    end
  end
  object EditRatioHDR: TEdit
    Left = 88
    Top = 276
    Width = 60
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 18
    Text = 'No'
  end
  object EditDispIndex: TEdit
    Left = 96
    Top = 108
    Width = 49
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 19
    Text = 'No'
  end
  object GroupBox1: TGroupBox
    Left = 1
    Top = 376
    Width = 153
    Height = 108
    Caption = ' Average for Styles 0..3 '
    TabOrder = 20
    object LabelColInfo: TLabel
      Left = 2
      Top = 14
      Width = 103
      Height = 17
      AutoSize = False
      Caption = 'Format: R G B Exp'
      Layout = tlCenter
    end
    object LabelAvg0: TLabel
      Left = 4
      Top = 32
      Width = 141
      Height = 17
      AutoSize = False
      Caption = 'Style[0]: No'
      Layout = tlCenter
    end
    object LabelAvg1: TLabel
      Left = 4
      Top = 50
      Width = 141
      Height = 17
      AutoSize = False
      Caption = 'Style[1]: No'
      Layout = tlCenter
    end
    object LabelAvg2: TLabel
      Left = 4
      Top = 68
      Width = 141
      Height = 17
      AutoSize = False
      Caption = 'Style[2]: No'
      Layout = tlCenter
    end
    object LabelAvg3: TLabel
      Left = 4
      Top = 86
      Width = 141
      Height = 17
      AutoSize = False
      Caption = 'Style[3]: No'
      Layout = tlCenter
    end
  end
  object OpenDialogHDR: TOpenDialog
    Ctl3D = False
    Filter = 'Radiance HDR RGBE (*.hdr)|*.hdr'
    Left = 104
    Top = 8
  end
  object SaveDialogHDR: TSaveDialog
    Ctl3D = False
    Filter = 'Radiance HDR RGBE (*.hdr)|*.hdr'
    Left = 104
    Top = 40
  end
end
