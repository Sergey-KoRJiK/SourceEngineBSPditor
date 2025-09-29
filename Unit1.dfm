object MainForm: TMainForm
  Left = 473
  Top = 298
  Width = 720
  Height = 590
  Caption = 'BSP Source Viewer'
  Color = 2105376
  Constraints.MinHeight = 590
  Constraints.MinWidth = 720
  Font.Charset = ANSI_CHARSET
  Font.Color = clSilver
  Font.Height = -13
  Font.Name = 'Script'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  DesignSize = (
    704
    531)
  PixelsPerInch = 96
  TextHeight = 16
  object LabelCameraPos: TLabel
    Left = 316
    Top = 512
    Width = 209
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Pos: (XXX,XXX; YYY,YYY; ZZZ,ZZZ)'
  end
  object LabelCameraLeafId: TLabel
    Left = 100
    Top = 512
    Width = 209
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Leaf: XXXXX, Cluster: XXXXX, Void'
  end
  object LabelStylePage: TLabel
    Left = 532
    Top = 512
    Width = 121
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Style page (0..3): 0'
  end
  object LabelCameraFPS: TLabel
    Left = 2
    Top = 512
    Width = 89
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'FPS: XXXX,X'
  end
  object LabelLDRHDR: TLabel
    Left = 652
    Top = 512
    Width = 49
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'L/HDR?'
  end
  object PanelRT: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 512
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Panel Render Target'
    Color = clBlack
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'Script'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnMouseDown = PanelRTMouseDown
    OnMouseMove = PanelRTMouseMove
    OnMouseUp = PanelRTMouseUp
    OnResize = PanelRTResize
  end
  object PageControl1: TPageControl
    Left = 514
    Top = 0
    Width = 185
    Height = 512
    ActivePage = TabSheet1
    Anchors = [akTop, akRight]
    MultiLine = True
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Face'
      object GroupBoxFaceTexel: TGroupBox
        Left = 0
        Top = 168
        Width = 177
        Height = 62
        Caption = ' Pick Texel on Face '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object LabelFaceTexUV: TStaticText
          Left = 0
          Top = 20
          Width = 49
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' TexUV'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditFaceTexUV: TStaticText
          Left = 48
          Top = 20
          Width = 126
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelFaceLmpUV: TStaticText
          Left = 0
          Top = 40
          Width = 49
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' LmpUV'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object EditFaceLmpUV: TStaticText
          Left = 48
          Top = 40
          Width = 126
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
      end
      object GroupBoxFacePlane: TGroupBox
        Left = 0
        Top = 234
        Width = 177
        Height = 121
        Caption = ' Plane Equation '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object LabelFacePlaneX: TStaticText
          Left = 0
          Top = 20
          Width = 65
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Normal X'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditFacePlaneX: TStaticText
          Left = 64
          Top = 20
          Width = 110
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelFacePlaneY: TStaticText
          Left = 0
          Top = 40
          Width = 65
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Normal Y '
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object EditFacePlaneY: TStaticText
          Left = 64
          Top = 40
          Width = 110
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object LabelFacePlaneZ: TStaticText
          Left = 0
          Top = 60
          Width = 65
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Normal Z'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object EditFacePlaneZ: TStaticText
          Left = 64
          Top = 60
          Width = 110
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
        end
        object LabelFacePlaneD: TStaticText
          Left = 0
          Top = 80
          Width = 65
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Distance'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object EditFacePlaneD: TStaticText
          Left = 64
          Top = 80
          Width = 110
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 7
        end
        object LabelFacePlaneF: TStaticText
          Left = 0
          Top = 100
          Width = 65
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Pre-Flags'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object EditFacePlaneF: TStaticText
          Left = 64
          Top = 100
          Width = 110
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 9
        end
      end
      object GroupBoxFaceInfo: TGroupBox
        Left = 0
        Top = 2
        Width = 177
        Height = 161
        Caption = ' Selected Face information '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object LabelFaceIndex: TStaticText
          Left = 0
          Top = 20
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Face Index'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditFaceIndex: TStaticText
          Left = 88
          Top = 20
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelFaceBrushIndex: TStaticText
          Left = 0
          Top = 40
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Entity Brush '
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object EditFaceBrushIndex: TStaticText
          Left = 88
          Top = 40
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object LabelFacePlaneIndex: TStaticText
          Left = 0
          Top = 100
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Plane Index'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object EditFacePlaneIndex: TStaticText
          Left = 88
          Top = 100
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
        end
        object LabelFaceCountVertex: TStaticText
          Left = 0
          Top = 120
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Count vertex'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object EditFaceCountVertex: TStaticText
          Left = 88
          Top = 120
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 7
        end
        object LabelFaceTexInfo: TStaticText
          Left = 0
          Top = 140
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' TexInfo Index'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object EditFaceTexInfo: TStaticText
          Left = 88
          Top = 140
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 9
        end
        object EditFaceEntityName: TStaticText
          Left = 0
          Top = 60
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  Entity Tragetname'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 10
        end
        object EditFaceEntityClass: TStaticText
          Left = 0
          Top = 80
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  Entity Classname'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 11
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Texture'
      ImageIndex = 1
      object GroupBoxTextureInfo: TGroupBox
        Left = 0
        Top = 8
        Width = 177
        Height = 265
        Caption = 'Selected Texture '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object ImagePreviewBT: TImage
          Tag = 4
          Left = 40
          Top = 80
          Width = 128
          Height = 128
        end
        object LabelTexName: TStaticText
          Left = 0
          Top = 40
          Width = 49
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Name'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditTexName: TStaticText
          Left = 48
          Top = 40
          Width = 126
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' *** No selected ***'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object EditTexSize: TStaticText
          Left = 48
          Top = 60
          Width = 126
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 2
        end
        object LabelTexSize: TStaticText
          Left = 0
          Top = 60
          Width = 49
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Size'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object ButtonLoadTex: TButton
          Left = 1
          Top = 214
          Width = 88
          Height = 22
          Caption = 'Load'
          Enabled = False
          TabOrder = 4
        end
        object ButtonSaveTex: TButton
          Left = 89
          Top = 214
          Width = 88
          Height = 22
          Caption = 'Save'
          Enabled = False
          TabOrder = 5
        end
        object LabeTexIndex: TStaticText
          Left = 0
          Top = 20
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Texture Index'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object EditTexIndex: TStaticText
          Left = 88
          Top = 20
          Width = 87
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No Selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 7
        end
        object ButtonDeleteTex: TButton
          Left = 113
          Top = 238
          Width = 64
          Height = 22
          Caption = 'Delete'
          Enabled = False
          TabOrder = 8
        end
      end
      object GroupBoxFaceTexInfo: TGroupBox
        Left = 0
        Top = 278
        Width = 177
        Height = 203
        Caption = ' Texture Transformation '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object LabelFaceTexSx: TStaticText
          Left = 0
          Top = 20
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Sx'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditFaceTexSx: TStaticText
          Left = 24
          Top = 20
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelFaceTexSy: TStaticText
          Left = 0
          Top = 40
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Sy'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object EditFaceTexSy: TStaticText
          Left = 24
          Top = 40
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object LabelFaceTexSz: TStaticText
          Left = 0
          Top = 60
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Sz'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object EditFaceTexSz: TStaticText
          Left = 24
          Top = 60
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
        end
        object LabelFaceTexSShift: TStaticText
          Left = 0
          Top = 80
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' So'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object EditFaceTexSShift: TStaticText
          Left = 24
          Top = 80
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 7
        end
        object LabelFaceTexTx: TStaticText
          Left = 0
          Top = 100
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Tx'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object EditFaceTexTx: TStaticText
          Left = 24
          Top = 100
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 9
        end
        object LabelFaceTexTy: TStaticText
          Left = 0
          Top = 120
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Ty'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object EditFaceTexTy: TStaticText
          Left = 24
          Top = 120
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 11
        end
        object LabelFaceTexTz: TStaticText
          Left = 0
          Top = 140
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Tz'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object EditFaceTexTz: TStaticText
          Left = 24
          Top = 140
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 13
        end
        object LabelFaceTexTShift: TStaticText
          Left = 0
          Top = 160
          Width = 24
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' To'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
        object EditFaceTexTShift: TStaticText
          Left = 24
          Top = 160
          Width = 154
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 15
        end
        object LabelFaceTexFlags: TStaticText
          Left = 0
          Top = 180
          Width = 57
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Flags'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
        end
        object EditFaceTexFlags: TStaticText
          Left = 56
          Top = 180
          Width = 121
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = '  No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 17
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Lightmaps'
      ImageIndex = 2
      object GroupBoxLightmapInfo: TGroupBox
        Left = 0
        Top = 2
        Width = 177
        Height = 127
        Caption = ' Style info '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object LabelLmpSize: TStaticText
          Left = 0
          Top = 20
          Width = 41
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Size'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditLmpSize: TStaticText
          Left = 40
          Top = 20
          Width = 129
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelLmpStyle1: TStaticText
          Left = 0
          Top = 64
          Width = 17
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' 1'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object EditLmpStyle1: TStaticText
          Left = 17
          Top = 64
          Width = 152
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object LabelLmpStyle2: TStaticText
          Left = 0
          Top = 84
          Width = 17
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' 2'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object EditLmpStyle2: TStaticText
          Left = 17
          Top = 84
          Width = 152
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
        end
        object EditLmpStyle3: TStaticText
          Left = 17
          Top = 104
          Width = 152
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 6
        end
        object LabelLmpStyle3: TStaticText
          Left = 0
          Top = 104
          Width = 17
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' 3'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object EditLmpStyle0: TStaticText
          Left = 17
          Top = 40
          Width = 152
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 8
        end
        object StaticText2: TStaticText
          Left = 0
          Top = 40
          Width = 17
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' 0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
      end
      object RadioGroupLmp: TRadioGroup
        Left = 0
        Top = 128
        Width = 177
        Height = 57
        Caption = ' Style '
        Columns = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object ButtonLoadLmp: TButton
        Left = 1
        Top = 186
        Width = 88
        Height = 22
        Caption = 'Load'
        Enabled = False
        TabOrder = 2
      end
      object ButtonSaveLmp: TButton
        Left = 89
        Top = 186
        Width = 88
        Height = 22
        Caption = 'Save'
        Enabled = False
        TabOrder = 3
        OnClick = ButtonSaveLmpClick
      end
      object ButtonDeleteLmp: TButton
        Left = 1
        Top = 210
        Width = 88
        Height = 22
        Caption = 'Delete'
        Enabled = False
        TabOrder = 4
      end
      object ButtonAddLmp: TButton
        Left = 89
        Top = 210
        Width = 88
        Height = 22
        Caption = 'Add'
        Enabled = False
        TabOrder = 5
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 242
        Width = 177
        Height = 127
        Caption = ' Megatexture info '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        object StaticText1: TStaticText
          Left = 0
          Top = 20
          Width = 57
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = 'Atlas ID'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EditLmpAtlasID: TStaticText
          Left = 56
          Top = 20
          Width = 113
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object EditLmpRegion1: TStaticText
          Left = 8
          Top = 64
          Width = 161
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 2
        end
        object EditLmpRegion2: TStaticText
          Left = 8
          Top = 84
          Width = 161
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
        end
        object EditLmpRegion3: TStaticText
          Left = 8
          Top = 104
          Width = 161
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 4
        end
        object EditLmpRegion0: TStaticText
          Left = 8
          Top = 40
          Width = 161
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' No selected'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
        end
      end
      object TrackBarExp: TTrackBar
        Left = 64
        Top = 376
        Width = 113
        Height = 17
        Ctl3D = False
        Max = 32
        Min = -32
        ParentCtl3D = False
        TabOrder = 7
        ThumbLength = 10
        OnChange = TrackBarExpChange
      end
      object LblLmpUserExp: TStaticText
        Left = 0
        Top = 372
        Width = 33
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = 'Exp'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object BtnLmpExpZero: TButton
        Left = 40
        Top = 376
        Width = 25
        Height = 17
        Caption = '"0"'
        TabOrder = 9
        OnClick = BtnLmpExpZeroClick
      end
      object CheckBoxModeAtlas: TCheckBox
        Left = 0
        Top = 400
        Width = 145
        Height = 17
        Caption = 'Draw lightmap Atlas'
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 10
      end
      object StaticText3: TStaticText
        Left = 0
        Top = 420
        Width = 73
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = 'Atlas page'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
      end
      object BtnAtlasPage: TSpinButton
        Left = 112
        Top = 416
        Width = 20
        Height = 25
        Ctl3D = False
        DownGlyph.Data = {
          0E010000424D0E01000000000000360000002800000009000000060000000100
          200000000000D800000000000000000000000000000000000000008080000080
          8000008080000080800000808000008080000080800000808000008080000080
          8000008080000080800000808000000000000080800000808000008080000080
          8000008080000080800000808000000000000000000000000000008080000080
          8000008080000080800000808000000000000000000000000000000000000000
          0000008080000080800000808000000000000000000000000000000000000000
          0000000000000000000000808000008080000080800000808000008080000080
          800000808000008080000080800000808000}
        ParentCtl3D = False
        TabOrder = 12
        UpGlyph.Data = {
          0E010000424D0E01000000000000360000002800000009000000060000000100
          200000000000D800000000000000000000000000000000000000008080000080
          8000008080000080800000808000008080000080800000808000008080000080
          8000000000000000000000000000000000000000000000000000000000000080
          8000008080000080800000000000000000000000000000000000000000000080
          8000008080000080800000808000008080000000000000000000000000000080
          8000008080000080800000808000008080000080800000808000000000000080
          8000008080000080800000808000008080000080800000808000008080000080
          800000808000008080000080800000808000}
        OnDownClick = BtnAtlasPageDownClick
        OnUpClick = BtnAtlasPageUpClick
      end
      object LblAtlasPage: TStaticText
        Left = 72
        Top = 420
        Width = 33
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = ' 0'
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 13
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Misc'
      ImageIndex = 3
      object GroupBoxProfile: TGroupBox
        Left = 0
        Top = 0
        Width = 177
        Height = 145
        Caption = ' Profiling (mcs) '
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object LabelProfile1: TStaticText
          Left = 0
          Top = 20
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #1'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object LabelProfile2: TStaticText
          Left = 0
          Top = 40
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #2 '
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object LabelProfile3: TStaticText
          Left = 0
          Top = 60
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #3'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          Visible = False
        end
        object LabelProfile4: TStaticText
          Left = 0
          Top = 80
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #4'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 3
          Visible = False
        end
        object LabelProfile5: TStaticText
          Left = 0
          Top = 100
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #5'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 4
          Visible = False
        end
        object LabelProfile6: TStaticText
          Left = 0
          Top = 120
          Width = 174
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Slot #6'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 5
          Visible = False
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 12
    object FileMenu: TMenuItem
      Caption = 'File'
      object LoadMapMenu: TMenuItem
        Caption = 'Load Map'
        OnClick = LoadMapMenuClick
      end
      object CloseMapMenu: TMenuItem
        Caption = 'Close Map'
        Enabled = False
        OnClick = CloseMapMenuClick
      end
      object SaveMapMenu: TMenuItem
        Caption = 'Save Map'
        Enabled = False
        OnClick = SaveMapMenuClick
      end
      object LineSplitFileMenu: TMenuItem
        Caption = '-'
      end
      object CloseMenu: TMenuItem
        Caption = 'Close'
        OnClick = CloseMenuClick
      end
    end
    object OptionsMenu: TMenuItem
      Caption = 'Options'
      object ResetCameraMenu: TMenuItem
        Caption = 'Reset Camera'
        OnClick = ResetCameraMenuClick
      end
      object ShowOpenGLInformationMenu: TMenuItem
        Caption = 'Show OpenGL Information'
        OnClick = ShowOpenGLInformationMenuClick
      end
      object LineSplitOptionsMenu: TMenuItem
        Caption = '-'
      end
      object GotoMenu: TMenuItem
        Caption = 'Go to...'
        object GotoCamPosSubMenu: TMenuItem
          Caption = 'Coordinates'
          OnClick = GotoCamPosSubMenuClick
        end
        object GotoFaceIdSubmenu: TMenuItem
          Caption = 'Face Id'
          Enabled = False
          OnClick = GotoFaceIdSubmenuClick
        end
        object GotoVisLeafIdSubMenu: TMenuItem
          Caption = 'Visleaf Id'
          Enabled = False
          OnClick = GotoVisLeafIdSubMenuClick
        end
        object GotoBModelIdSubMenu: TMenuItem
          Caption = 'Brush Model Id'
          Enabled = False
          OnClick = GotoBModelIdSubMenuClick
        end
        object GotoEntTGNSubMenu: TMenuItem
          Caption = 'Entity Targetname'
          Enabled = False
          OnClick = GotoEntTGNSubMenuClick
        end
      end
      object RenderMenu: TMenuItem
        Caption = 'Render'
        object WireframeEntBrushesMenu: TMenuItem
          Caption = 'Wireframe Entity Brushes'
          Enabled = False
          OnClick = WireframeEntBrushesMenuClick
        end
        object WireframeHighlighEntBrushesMenu: TMenuItem
          Caption = 'Wireframe Highligh Entity Brushes'
          Enabled = False
          OnClick = WireframeHighlighEntBrushesMenuClick
        end
        object DrawFaceContourMenu: TMenuItem
          Caption = 'Draw Face Contour'
          Enabled = False
          OnClick = DrawFaceContourMenuClick
        end
        object RenderBBOXVisLeaf: TMenuItem
          Caption = 'Draw BBOX VisLeaf'
          OnClick = RenderBBOXVisLeafClick
        end
        object DrawTriggersMenu: TMenuItem
          Caption = 'Draw Triggers'
          Checked = True
          OnClick = DrawTriggersMenuClick
        end
        object DrawEntityBrushesMenu: TMenuItem
          Caption = 'Draw Entity Brushes'
          Checked = True
          OnClick = DrawEntityBrushesMenuClick
        end
        object BModelRenderColorAlphaMenu: TMenuItem
          Caption = 'BModel Render Color-Alpha'
          Checked = True
          OnClick = BModelRenderColorAlphaMenuClick
        end
        object LmpPixelModeMenu: TMenuItem
          Caption = 'Pixelate Lightmaps'
          OnClick = LmpPixelModeMenuClick
        end
        object TexPixelModeMenu: TMenuItem
          Caption = 'Pixelate Textures'
          Enabled = False
          OnClick = TexPixelModeMenuClick
        end
        object DisableLightmapsMenu: TMenuItem
          Caption = 'Disable Lightmaps'
          Enabled = False
          OnClick = DisableLightmapsMenuClick
        end
        object DisableTexturesMenu: TMenuItem
          Caption = 'Disable Textures'
          Enabled = False
          OnClick = DisableTexturesMenuClick
        end
      end
      object SetSelectedFaceColorMenu: TMenuItem
        Caption = 'Set Selected Face Color'
        OnClick = SetSelectedFaceColorMenuClick
      end
      object SetWireframeFaceColorMenu: TMenuItem
        Caption = 'Set Wireframe Highlitght Color'
        Enabled = False
        OnClick = SetWireframeFaceColorMenuClick
      end
      object ShowHeaderMenu: TMenuItem
        Caption = 'Show Header'
        OnClick = ShowHeaderMenuClick
      end
      object ShowLightStylesMenu: TMenuItem
        Caption = 'Show light styles'
        Enabled = False
      end
    end
    object HelpMenu: TMenuItem
      Caption = 'Help'
      OnClick = HelpMenuClick
    end
    object AboutMenu: TMenuItem
      Caption = 'About'
      OnClick = AboutMenuClick
    end
  end
  object OpenDialogBsp: TOpenDialog
    Filter = 'Gold Src Bsp v30|*.bsp'
    Left = 40
    Top = 8
  end
  object SaveDialogBsp: TSaveDialog
    DefaultExt = 'bsp'
    Filter = 'Gold Src Bsp v30|*.bsp'
    Left = 72
    Top = 8
  end
  object ColorDialog: TColorDialog
    Left = 104
    Top = 8
  end
  object OpenDialogVTF: TOpenDialog
    Filter = 'VTF Image|*.vtf'
    Left = 40
    Top = 40
  end
  object SaveDialogVTF: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'VTF Image|*.vtf'
    Left = 72
    Top = 40
  end
  object SaveDialogDir: TSaveDialog
    Left = 72
    Top = 72
  end
end
