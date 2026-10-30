object frmRaporSecimDialog: TfrmRaporSecimDialog
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Yazd'#305'rma Se'#231'ene'#287'i'
  ClientHeight = 340
  ClientWidth = 480
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
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 1
    Top = 1
    Width = 478
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 13795088
    ParentBackground = False
    TabOrder = 0
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      478
      40)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 10
      Width = 125
      Height = 19
      Caption = 'Yazd'#305'rma Se'#231'ene'#287'i'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 440
      Top = 5
      Width = 30
      Height = 30
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
    Top = 41
    Width = 478
    Height = 246
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblPrompt: TLabel
      Left = 24
      Top = 16
      Width = 237
      Height = 17
      Caption = 'Yazd'#305'rmak istedi'#287'iniz rapor format'#305'n'#305' se'#231'iniz:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnSeciliEkstre: TButton
      Left = 24
      Top = 46
      Width = 430
      Height = 54
      Caption = '  '#128196' Se'#231'ili Cari Hesap Ekstresi (Hareketler)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSeciliEkstreClick
    end
    object btnCariOzet: TButton
      Left = 24
      Top = 108
      Width = 430
      Height = 54
      Caption = '  '#128203' Cari Hesap Listesi ('#214'zet)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnCariOzetClick
    end
    object btnDetayliRapor: TButton
      Left = 24
      Top = 170
      Width = 430
      Height = 54
      Caption = '  '#128202' Hareket Detayl'#305' Cari Raporu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnDetayliRaporClick
    end
  end
  object pnlBottom: TPanel
    Left = 1
    Top = 287
    Width = 478
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    Color = 15856121
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      478
      52)
    object btnCancel: TButton
      Left = 364
      Top = 10
      Width = 90
      Height = 32
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Vazge'#231
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
