object MainForm: TMainForm
  Left = 548
  Top = 296
  Width = 772
  Height = 577
  Caption = 'Source Engine BSP Map Viewer'
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 499
    Width = 756
    Height = 19
    Anchors = []
    Panels = <
      item
        Text = ' FPS'
        Width = 70
      end
      item
        Text = 'Pos: (X Y Z)'
        Width = 155
      end
      item
        Text = 'Camera Leaf id:'
        Width = 120
      end
      item
        Text = 'Style page (0..3): 0'
        Width = 110
      end
      item
        Text = 'Render Triangles:'
        Width = 150
      end
      item
        Text = 'Light Mode: LDR'
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object FileMenu: TMenuItem
      Caption = 'File'
      object OpenMapMenu: TMenuItem
        Caption = 'Open BSP'
        OnClick = OpenMapMenuClick
      end
      object CloseMapMenu: TMenuItem
        Caption = 'Close BSP'
        Enabled = False
        OnClick = CloseMapMenuClick
      end
      object SaveMapMenu: TMenuItem
        Caption = 'Save BSP'
        Enabled = False
        OnClick = SaveMapMenuClick
      end
    end
    object OptionsMenu: TMenuItem
      Caption = 'Options'
      object ResetCameraMenu: TMenuItem
        Caption = 'Reset Camera'
        OnClick = ResetCameraMenuClick
      end
      object RenderSubMenu: TMenuItem
        Caption = 'Render'
        object ShowWorldBrushesMenu: TMenuItem
          Caption = 'Show World Faces'
          Checked = True
          OnClick = ShowWorldBrushesMenuClick
        end
        object ShowEntBrushesMenu: TMenuItem
          Caption = 'Show Entity Faces'
          Checked = True
          OnClick = ShowEntBrushesMenuClick
        end
        object ShowDisplacementsMenu: TMenuItem
          Caption = 'Show Displacements'
          Checked = True
          OnClick = ShowDisplacementsMenuClick
        end
        object ShowAmbientCubeMenu: TMenuItem
          Caption = 'Show Ambient Light'
          Checked = True
          OnClick = ShowAmbientCubeMenuClick
        end
        object WireframeRenderMenu: TMenuItem
          Caption = 'Wireframe Render'
          OnClick = WireframeRenderMenuClick
        end
        object WallhackRenderModeMenu: TMenuItem
          Caption = 'Wallhack Render'
          OnClick = WallhackRenderModeMenuClick
        end
        object EnableFogMenu: TMenuItem
          Caption = 'Enable Fog'
          OnClick = EnableFogMenuClick
        end
      end
      object GUIPaletteSubMenu: TMenuItem
        Caption = 'GUI Palette'
        object SetClearColorMenu: TMenuItem
          Caption = 'Set Clear Color'
          OnClick = SetClearColorMenuClick
        end
        object SetFaceDiffuseColorMenu: TMenuItem
          Caption = 'Set Face Diffuse Color'
          OnClick = SetFaceDiffuseColorMenuClick
        end
        object SetFaceSelectedColorMenu: TMenuItem
          Caption = 'Set Face Selected Color'
          OnClick = SetFaceSelectedColorMenuClick
        end
      end
      object ShowHeaderMenu: TMenuItem
        Caption = 'Show BSP Map Info'
        OnClick = ShowHeaderMenuClick
      end
      object SHToolMenu: TMenuItem
        Caption = 'Show/Hide Tools'
        object ShowFaceToolMenu: TMenuItem
          Caption = 'Show Face Tool'
          Checked = True
          OnClick = ShowFaceToolMenuClick
        end
        object ShowAmbToolMenu: TMenuItem
          Caption = 'Show Ambient Tool'
          Checked = True
          OnClick = ShowAmbToolMenuClick
        end
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
    Ctl3D = False
    Filter = 'BSP Source Map|*.bsp'
    Left = 40
    Top = 8
  end
  object SaveDialogBsp: TSaveDialog
    Ctl3D = False
    Filter = 'BSP Source Map|*.bsp'
    Left = 72
    Top = 8
  end
  object ColorDialog: TColorDialog
    Ctl3D = False
    Left = 104
    Top = 8
  end
end
