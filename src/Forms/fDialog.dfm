object frmDialog: TfrmDialog
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #304#351'lem Onay'#305
  ClientHeight = 220
  ClientWidth = 490
  Color = 15856121
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 1
  Padding.Top = 1
  Padding.Right = 1
  Padding.Bottom = 1
  PopupMode = pmAuto
  Position = poOwnerFormCenter
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 1
    Top = 1
    Width = 488
    Height = 42
    Align = alTop
    BevelOuter = bvNone
    Color = 13795088
    ParentBackground = False
    TabOrder = 0
    OnMouseDown = pnlHeaderMouseDown
    DesignSize = (
      488
      42)
    object lblTitle: TLabel
      Left = 16
      Top = 11
      Width = 150
      Height = 19
      Caption = #304#351'lem Onay'#305
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlHeaderMouseDown
    end
    object btnClose: TButton
      Left = 448
      Top = 5
      Width = 32
      Height = 32
      Anchors = [akTop, akRight]
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object pnlClient: TPanel
    Left = 1
    Top = 43
    Width = 488
    Height = 125
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblIcon: TLabel
      Left = 20
      Top = 20
      Width = 44
      Height = 44
      Alignment = taCenter
      AutoSize = False
      Caption = #10067
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13795088
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lblMessage: TLabel
      Left = 76
      Top = 20
      Width = 392
      Height = 40
      AutoSize = False
      Caption = 'Mesaj metni buraya gelecek.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblDetail: TLabel
      Left = 76
      Top = 68
      Width = 392
      Height = 36
      AutoSize = False
      Caption = 'Detay bilgisi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7105644
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object pnlBottom: TPanel
    Left = 1
    Top = 168
    Width = 488
    Height = 51
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      488
      49)
    object btnPrimary: TButton
      Left = 264
      Top = 8
      Width = 100
      Height = 34
      Anchors = [akTop, akRight]
      Caption = 'Evet'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ModalResult = 6
      ParentFont = False
      TabOrder = 0
    end
    object btnSecondary: TButton
      Left = 374
      Top = 8
      Width = 100
      Height = 34
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Vazge'#231
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
  end
end
