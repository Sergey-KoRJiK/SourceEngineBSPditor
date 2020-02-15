object AmbToolForm: TAmbToolForm
  Left = 1482
  Top = 299
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Ambient lighting Tool'
  ClientHeight = 512
  ClientWidth = 216
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
  object LabelSelSample: TLabel
    Left = 40
    Top = 8
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Selected Sample '
    Layout = tlCenter
  end
  object EditSelectedSampleIndex: TEdit
    Left = 128
    Top = 8
    Width = 41
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    Text = 'No'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 201
    Height = 169
    Caption = ' Lightmap Ambient Color '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object LabelColInfo: TLabel
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      AutoSize = False
      Caption = '    Face     |    R  |  G   |  B  | Exp |'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(  1,  0,  0)'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 8
      Top = 50
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( -1,  0,  0)'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 8
      Top = 68
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(  0,  1,  0)'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 8
      Top = 122
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(  0,  0, -1)'
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 8
      Top = 104
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(  0,  0,  1)'
      Layout = tlCenter
    end
    object Label7: TLabel
      Left = 8
      Top = 86
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(  0, -1,  0)'
      Layout = tlCenter
    end
    object ShapeC0: TShape
      Left = 166
      Top = 32
      Width = 27
      Height = 19
      Brush.Color = clBlack
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC0MouseDown
    end
    object ShapeC1: TShape
      Left = 166
      Top = 50
      Width = 27
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC1MouseDown
    end
    object ShapeC2: TShape
      Left = 166
      Top = 68
      Width = 27
      Height = 19
      Brush.Color = clSilver
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC2MouseDown
    end
    object ShapeC3: TShape
      Left = 166
      Top = 86
      Width = 27
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC3MouseDown
    end
    object ShapeC4: TShape
      Left = 166
      Top = 104
      Width = 27
      Height = 19
      Brush.Color = clBlack
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC4MouseDown
    end
    object ShapeC5: TShape
      Left = 166
      Top = 122
      Width = 27
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
      OnMouseDown = ShapeC5MouseDown
    end
    object EditR0: TEdit
      Left = 64
      Top = 32
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = '255'
    end
    object EditG0: TEdit
      Left = 88
      Top = 32
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = '255'
    end
    object EditB0: TEdit
      Left = 112
      Top = 32
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      Text = '255'
    end
    object EditE0: TEdit
      Left = 136
      Top = 32
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
      Text = '255'
    end
    object EditR1: TEdit
      Left = 64
      Top = 50
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 4
      Text = '255'
    end
    object EditG1: TEdit
      Left = 88
      Top = 50
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 5
      Text = '255'
    end
    object EditB1: TEdit
      Left = 112
      Top = 50
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 6
      Text = '255'
    end
    object EditE1: TEdit
      Left = 136
      Top = 50
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 7
      Text = '255'
    end
    object EditR3: TEdit
      Left = 64
      Top = 86
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 8
      Text = '255'
    end
    object EditG3: TEdit
      Left = 88
      Top = 86
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 9
      Text = '255'
    end
    object EditB5: TEdit
      Left = 112
      Top = 86
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 10
      Text = '255'
    end
    object EditE3: TEdit
      Left = 136
      Top = 86
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 11
      Text = '255'
    end
    object EditR4: TEdit
      Left = 64
      Top = 104
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 12
      Text = '255'
    end
    object EditG4: TEdit
      Left = 88
      Top = 104
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 13
      Text = '255'
    end
    object EditB4: TEdit
      Left = 112
      Top = 104
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 14
      Text = '255'
    end
    object EditE4: TEdit
      Left = 136
      Top = 104
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 15
      Text = '255'
    end
    object EditR5: TEdit
      Left = 64
      Top = 122
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 16
      Text = '255'
    end
    object EditG5: TEdit
      Left = 88
      Top = 122
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 17
      Text = '255'
    end
    object EditB3: TEdit
      Left = 112
      Top = 122
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 18
      Text = '255'
    end
    object EditB2: TEdit
      Left = 112
      Top = 68
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 19
      Text = '255'
    end
    object EditE2: TEdit
      Left = 136
      Top = 68
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 20
      Text = '255'
    end
    object EditG2: TEdit
      Left = 88
      Top = 68
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 21
      Text = '255'
    end
    object EditR2: TEdit
      Left = 64
      Top = 68
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 22
      Text = '255'
    end
    object EditE5: TEdit
      Left = 136
      Top = 122
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 23
      Text = '255'
    end
    object ButtonSetNewColor: TButton
      Left = 24
      Top = 144
      Width = 121
      Height = 20
      Caption = 'Apply color changes'
      TabOrder = 24
      OnClick = ButtonSetNewColorClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 208
    Width = 201
    Height = 137
    Caption = ' Relative Sample Position '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 17
      Height = 17
      AutoSize = False
      Caption = ' X'
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 8
      Top = 56
      Width = 17
      Height = 17
      AutoSize = False
      Caption = ' Y'
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 8
      Top = 96
      Width = 17
      Height = 17
      AutoSize = False
      Caption = ' Z'
      Layout = tlCenter
    end
    object EditLX: TEdit
      Left = 24
      Top = 16
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = '255'
    end
    object EditLY: TEdit
      Left = 24
      Top = 56
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = '255'
    end
    object EditLZ: TEdit
      Left = 24
      Top = 96
      Width = 25
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      Text = '255'
    end
    object EditRX: TEdit
      Left = 72
      Top = 16
      Width = 89
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 3
      Text = '255'
    end
    object EditRY: TEdit
      Left = 72
      Top = 56
      Width = 89
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 4
      Text = '255'
    end
    object EditRZ: TEdit
      Left = 72
      Top = 96
      Width = 89
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 5
      Text = '255'
    end
    object TrackBarX: TTrackBar
      Left = 2
      Top = 36
      Width = 196
      Height = 17
      Max = 255
      PageSize = 1
      TabOrder = 6
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarXChange
    end
    object TrackBarY: TTrackBar
      Left = 2
      Top = 76
      Width = 196
      Height = 17
      Max = 255
      PageSize = 1
      TabOrder = 7
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarYChange
    end
    object TrackBarZ: TTrackBar
      Left = 2
      Top = 116
      Width = 196
      Height = 17
      Max = 255
      PageSize = 1
      TabOrder = 8
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarZChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 352
    Width = 201
    Height = 153
    Caption = ' Ambient Light in camera pos '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    object Label10: TLabel
      Left = 16
      Top = 16
      Width = 41
      Height = 19
      AutoSize = False
      Caption = 'cam dir'
      Layout = tlCenter
      WordWrap = True
    end
    object ShapeFC: TShape
      Left = 134
      Top = 16
      Width = 62
      Height = 19
      Brush.Color = clBlack
      Pen.Style = psClear
      Pen.Width = 0
    end
    object Label11: TLabel
      Left = 8
      Top = 40
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( 1,  0,  0)'
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 8
      Top = 58
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '(-1,  0,  0)'
      Layout = tlCenter
    end
    object Label13: TLabel
      Left = 8
      Top = 76
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( 0,  1,  0)'
      Layout = tlCenter
    end
    object Label14: TLabel
      Left = 8
      Top = 94
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( 0, -1,  0)'
      Layout = tlCenter
    end
    object Label15: TLabel
      Left = 8
      Top = 112
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( 0,  0,  1)'
      Layout = tlCenter
    end
    object Label16: TLabel
      Left = 8
      Top = 130
      Width = 49
      Height = 17
      AutoSize = False
      Caption = '( 0,  0, -1)'
      Layout = tlCenter
    end
    object ShapeFC0: TShape
      Left = 134
      Top = 40
      Width = 62
      Height = 19
      Brush.Color = clBlack
      Pen.Style = psClear
      Pen.Width = 0
    end
    object ShapeFC1: TShape
      Left = 134
      Top = 58
      Width = 62
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
    end
    object ShapeFC2: TShape
      Left = 134
      Top = 76
      Width = 62
      Height = 19
      Brush.Color = clSilver
      Pen.Style = psClear
      Pen.Width = 0
    end
    object ShapeFC3: TShape
      Left = 134
      Top = 94
      Width = 62
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
    end
    object ShapeFC4: TShape
      Left = 134
      Top = 112
      Width = 62
      Height = 19
      Brush.Color = clBlack
      Pen.Style = psClear
      Pen.Width = 0
    end
    object ShapeFC5: TShape
      Left = 134
      Top = 130
      Width = 62
      Height = 19
      Brush.Color = clGray
      Pen.Style = psClear
      Pen.Width = 0
    end
    object EditFinalColor: TEdit
      Left = 56
      Top = 16
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      Text = '255, 255, 255'
    end
    object EditFC0: TEdit
      Left = 56
      Top = 40
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 1
      Text = '255, 255, 255'
    end
    object EditFC1: TEdit
      Left = 56
      Top = 58
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 2
      Text = '255, 255, 255'
    end
    object EditFC2: TEdit
      Left = 56
      Top = 76
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 3
      Text = '255, 255, 255'
    end
    object EditFC3: TEdit
      Left = 56
      Top = 94
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 4
      Text = '255, 255, 255'
    end
    object EditFC4: TEdit
      Left = 56
      Top = 112
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 5
      Text = '255, 255, 255'
    end
    object EditFC5: TEdit
      Left = 56
      Top = 130
      Width = 73
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 6
      Text = '255, 255, 255'
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = False
    Left = 8
  end
end
