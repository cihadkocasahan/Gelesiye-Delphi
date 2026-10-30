inherited frmBaseEdit: TfrmBaseEdit
  BorderStyle = bsNone
  Caption = 'Kay'#305't D'#252'zenle'
  ClientHeight = 391
  ClientWidth = 500
  Color = clWhite
  PopupMode = pmAuto
  StyleElements = [seClient, seBorder]
  ExplicitWidth = 500
  ExplicitHeight = 391
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 40
    Cursor = crSizeAll
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      500
      40)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 9
      Width = 91
      Height = 19
      Cursor = crSizeAll
      Caption = 'Kay'#305't D'#252'zenle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 460
      Top = 4
      Width = 32
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'Kapat (Esc)'
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 341
    Width = 500
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 400
    DesignSize = (
      500
      50)
    object btnVazgec: TButton
      Left = 16
      Top = 10
      Width = 100
      Height = 32
      Cancel = True
      Hint = #304'ptal Et ve Kapat (Esc)'
      Caption = #10005' Vazge'#231
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnVazgecClick
    end
    object btnKaydet: TButton
      Left = 384
      Top = 10
      Width = 100
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'De'#287'i'#351'iklikleri Kaydet (Enter)'
      Caption = #62654' Kaydet'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnKaydetClick
    end
  end
end
