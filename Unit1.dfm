object MainForm: TMainForm
  Left = 643
  Top = 187
  Width = 720
  Height = 591
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
    532)
  PixelsPerInch = 96
  TextHeight = 16
  object LabelCameraPos: TLabel
    Left = 316
    Top = 513
    Width = 209
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Pos: (XXX,XXX; YYY,YYY; ZZZ,ZZZ)'
  end
  object LabelCameraLeafId: TLabel
    Left = 100
    Top = 513
    Width = 209
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Leaf: XXXXX, Cluster: XXXXX, Void'
  end
  object LabelStylePage: TLabel
    Left = 532
    Top = 513
    Width = 121
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Style page (0..3): 0'
  end
  object LabelCameraFPS: TLabel
    Left = 2
    Top = 513
    Width = 89
    Height = 17
    Align = alCustom
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'FPS: XXXX,X'
  end
  object LabelLDRHDR: TLabel
    Left = 652
    Top = 513
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
    Height = 513
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
        Top = 272
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
      end
      object GroupBoxFacePlane: TGroupBox
        Left = 0
        Top = 338
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
        Height = 263
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
          Hint = 'Extened name'
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
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
        end
        object EditFaceEntityClass: TStaticText
          Left = 0
          Top = 80
          Width = 174
          Height = 20
          Hint = 'Extened name'
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
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
        end
        object StaticText5: TStaticText
          Left = 0
          Top = 160
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Disp ID, pow'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object EditFaceDispID: TStaticText
          Left = 88
          Top = 160
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
          TabOrder = 13
        end
        object StaticText7: TStaticText
          Left = 0
          Top = 180
          Width = 89
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = sbsSingle
          Caption = ' Disp origin'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
        object EditFaceDispOrigin: TStaticText
          Left = 88
          Top = 180
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
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object MemoFaceVertex: TMemo
          Left = 0
          Top = 200
          Width = 172
          Height = 61
          Color = clBlack
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -13
          Font.Name = 'Script'
          Font.Style = [fsBold]
          Lines.Strings = (
            'Face vertices:')
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 16
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
          ParentShowHint = False
          ShowHint = True
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
    end
    object TabSheet3: TTabSheet
      Caption = 'Lightmaps'
      ImageIndex = 2
      object ImageLmpPreview: TImage
        Left = 4
        Top = 330
        Width = 128
        Height = 128
        OnMouseMove = ImageLmpPreviewMouseMove
      end
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
          ParentShowHint = False
          ShowHint = True
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
        OnClick = CBLmpPreviewRGBClick
      end
      object ButtonLoadLmp: TButton
        Left = 1
        Top = 210
        Width = 88
        Height = 22
        Caption = 'Load'
        Enabled = False
        TabOrder = 2
      end
      object ButtonSaveLmp: TButton
        Left = 89
        Top = 210
        Width = 88
        Height = 22
        Caption = 'Save'
        TabOrder = 3
        OnClick = ButtonSaveLmpClick
      end
      object ButtonDeleteLmp: TButton
        Left = 1
        Top = 234
        Width = 88
        Height = 22
        Caption = 'Delete'
        Enabled = False
        TabOrder = 4
      end
      object ButtonAddLmp: TButton
        Left = 89
        Top = 234
        Width = 88
        Height = 22
        Caption = 'Add'
        Enabled = False
        TabOrder = 5
      end
      object TrackBarExp: TTrackBar
        Left = 68
        Top = 286
        Width = 113
        Height = 17
        Ctl3D = False
        Max = 32
        Min = -32
        ParentCtl3D = False
        TabOrder = 6
        ThumbLength = 10
        OnChange = TrackBarExpChange
      end
      object LblLmpUserExp: TStaticText
        Left = 4
        Top = 284
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
        TabOrder = 7
      end
      object BtnLmpExpZero: TButton
        Left = 44
        Top = 286
        Width = 25
        Height = 17
        Caption = '"0"'
        TabOrder = 8
        OnClick = BtnLmpExpZeroClick
      end
      object CheckBoxModeAtlas: TCheckBox
        Left = 4
        Top = 308
        Width = 125
        Height = 17
        Caption = 'Show Atlas page'
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 9
      end
      object BtnAtlasPage: TSpinButton
        Left = 156
        Top = 308
        Width = 20
        Height = 20
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
        TabOrder = 10
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
        Left = 128
        Top = 308
        Width = 25
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
        TabOrder = 11
      end
      object EditLmpRegion: TStaticText
        Left = 4
        Top = 260
        Width = 173
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
        TabOrder = 12
      end
      object CBLmpPreviewRGB: TCheckBox
        Left = 132
        Top = 444
        Width = 97
        Height = 17
        Hint = 'RGB or EXPx8'
        Caption = 'RGB'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 13
        OnClick = CBLmpPreviewRGBClick
      end
      object EditLmpPixelR: TStaticText
        Left = 146
        Top = 360
        Width = 29
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = '0'
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 14
      end
      object StaticText4: TStaticText
        Left = 132
        Top = 360
        Width = 13
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        Caption = ' r'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 15
      end
      object StaticText1: TStaticText
        Left = 132
        Top = 380
        Width = 13
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        Caption = ' g'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
      end
      object EditLmpPixelG: TStaticText
        Left = 146
        Top = 380
        Width = 29
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = '0'
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
      object StaticText6: TStaticText
        Left = 132
        Top = 400
        Width = 13
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        Caption = ' b'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 18
      end
      object EditLmpPixelB: TStaticText
        Left = 146
        Top = 400
        Width = 29
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = '0'
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 19
      end
      object StaticText8: TStaticText
        Left = 132
        Top = 420
        Width = 13
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        Caption = ' e'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 20
      end
      object EditLmpPixelE: TStaticText
        Left = 146
        Top = 420
        Width = 31
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = '0'
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 21
      end
      object EditLmpBump: TStaticText
        Left = 88
        Top = 186
        Width = 17
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
        TabOrder = 22
      end
      object BtnLmpBump: TSpinButton
        Left = 108
        Top = 187
        Width = 20
        Height = 20
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
        TabOrder = 23
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
        OnDownClick = BtnLmpBumpDownClick
        OnUpClick = BtnLmpBumpUpClick
      end
      object StaticText3: TStaticText
        Left = 0
        Top = 186
        Width = 89
        Height = 20
        AutoSize = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = sbsSingle
        Caption = ' Bump sample'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Script'
        Font.Style = []
        ParentFont = False
        TabOrder = 24
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
        Caption = 'Load map'
        OnClick = LoadMapMenuClick
      end
      object CloseMapMenu: TMenuItem
        Caption = 'Close map'
        Enabled = False
        OnClick = CloseMapMenuClick
      end
      object SaveMapMenu: TMenuItem
        Caption = 'Save map'
        Enabled = False
        OnClick = SaveMapMenuClick
      end
      object LineSplitFileMenu: TMenuItem
        Caption = '-'
      end
      object CloseMenu: TMenuItem
        Caption = 'Exit'
        OnClick = CloseMenuClick
      end
    end
    object OptionsMenu: TMenuItem
      Caption = 'Options'
      object ResetCameraMenu: TMenuItem
        Caption = 'Reset camera'
        OnClick = ResetCameraMenuClick
      end
      object ShowOpenGLInformationMenu: TMenuItem
        Caption = 'Show OpenGL information'
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
          Caption = 'Face id'
          Enabled = False
          OnClick = GotoFaceIdSubmenuClick
        end
        object GotoVisLeafIdSubMenu: TMenuItem
          Caption = 'Vis-leaf id'
          Enabled = False
          OnClick = GotoVisLeafIdSubMenuClick
        end
        object GotoBModelIdSubMenu: TMenuItem
          Caption = 'BModel id'
          Enabled = False
          OnClick = GotoBModelIdSubMenuClick
        end
        object GotoEntTGNSubMenu: TMenuItem
          Caption = 'Entity targetname'
          Enabled = False
          OnClick = GotoEntTGNSubMenuClick
        end
      end
      object RenderMenu: TMenuItem
        Caption = 'Render'
        object WireframeEntBrushesMenu: TMenuItem
          Caption = 'Wireframe entity BModel'
          Enabled = False
          OnClick = WireframeEntBrushesMenuClick
        end
        object WireframeHighlighEntBrushesMenu: TMenuItem
          Caption = 'Wireframe highligh entity BModel'
          Enabled = False
          OnClick = WireframeHighlighEntBrushesMenuClick
        end
        object DrawFaceContourMenu: TMenuItem
          Caption = 'Draw face contour'
          Enabled = False
          OnClick = DrawFaceContourMenuClick
        end
        object RenderBBOXVisLeaf: TMenuItem
          Caption = 'Draw vis-leafs'
          OnClick = RenderBBOXVisLeafClick
        end
        object DrawTriggersMenu: TMenuItem
          Caption = 'Draw triggers'
          Checked = True
          OnClick = DrawTriggersMenuClick
        end
        object DrawEntityBrushesMenu: TMenuItem
          Caption = 'Draw entity BModel'
          Checked = True
          OnClick = DrawEntityBrushesMenuClick
        end
        object DrawDispFaceMenu: TMenuItem
          Caption = 'Draw displacement faces'
          OnClick = DrawDispFaceMenuClick
        end
        object BModelRenderColorAlphaMenu: TMenuItem
          Caption = 'BModel render color-alpha'
          Checked = True
          OnClick = BModelRenderColorAlphaMenuClick
        end
        object LmpPixelModeMenu: TMenuItem
          Caption = 'Pixelate lightmaps'
          OnClick = LmpPixelModeMenuClick
        end
        object TexPixelModeMenu: TMenuItem
          Caption = 'Pixelate textures'
          Enabled = False
          OnClick = TexPixelModeMenuClick
        end
        object DisableLightmapsMenu: TMenuItem
          Caption = 'Disable lightmaps'
          Enabled = False
          OnClick = DisableLightmapsMenuClick
        end
        object DisableTexturesMenu: TMenuItem
          Caption = 'Disable textures'
          Enabled = False
          OnClick = DisableTexturesMenuClick
        end
      end
      object SetSelectedFaceColorMenu: TMenuItem
        Caption = 'Set selected face color'
        OnClick = SetSelectedFaceColorMenuClick
      end
      object SetWireframeFaceColorMenu: TMenuItem
        Caption = 'Set wireframe highlitght color'
        Enabled = False
        OnClick = SetWireframeFaceColorMenuClick
      end
      object ShowHeaderMenu: TMenuItem
        Caption = 'Show map header'
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
    DefaultExt = 'vtf'
    Filter = 'VTF Image|*.vtf'
    Left = 72
    Top = 40
  end
  object SaveDialogTGA: TSaveDialog
    DefaultExt = 'tga'
    Filter = 'TGA 32-bit Image|*.tga'
    Left = 72
    Top = 72
  end
end
