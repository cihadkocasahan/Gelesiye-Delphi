object frmReportPreview: TfrmReportPreview
  Left = 0
  Top = 0
  Caption = 'Gelesiye Rapor '#214'nizleme'
  ClientHeight = 800
  ClientWidth = 1180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  BorderStyle = bsNone
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = 2235947
    ParentBackground = False
    TabOrder = 0
    object pnlTitle: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      Color = 2235947
      ParentBackground = False
      TabOrder = 0
      object lblTitle: TLabel
        Left = 16
        Top = 10
        Width = 160
        Height = 20
        Caption = 'Cari Hesap Ekstresi'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSubtitle: TLabel
        Left = 16
        Top = 32
        Width = 175
        Height = 13
        Caption = 'Gelesiye '#8212' Rapor '#214'nizleme'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10855845
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlActions: TPanel
      Left = 750
      Top = 0
      Width = 430
      Height = 56
      Align = alRight
      BevelOuter = bvNone
      Color = 2235947
      ParentBackground = False
      TabOrder = 1
      object btnYazdir: TButton
        Left = 8
        Top = 11
        Width = 84
        Height = 34
        Caption = 'Yazd'#305'r'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnYazdirClick
      end
      object btnPDF: TButton
        Left = 98
        Top = 11
        Width = 82
        Height = 34
        Caption = 'PDF '#304'ndir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnPDFClick
      end
      object btnExcel: TButton
        Left = 186
        Top = 11
        Width = 90
        Height = 34
        Caption = 'Excel '#304'ndir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnExcelClick
      end
      object btnMaximize: TButton
        Left = 282
        Top = 11
        Width = 42
        Height = 34
        Caption = '[+]'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ShowHint = True
        Hint = 'Ekran'#305' Kapla'
        TabOrder = 3
        OnClick = btnMaximizeClick
      end
      object btnKapat: TButton
        Left = 330
        Top = 11
        Width = 88
        Height = 34
        Caption = #10005' Kapat'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ShowHint = True
        Hint = 'Kapat (Esc)'
        TabOrder = 4
        OnClick = btnKapatClick
      end
    end
    object pnlNav: TPanel
      Left = 320
      Top = 0
      Width = 490
      Height = 56
      Align = alClient
      BevelOuter = bvNone
      Color = 2235947
      ParentBackground = False
      TabOrder = 2
      object lblPage: TLabel
        Left = 82
        Top = 20
        Width = 76
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = 'Sayfa 1 / 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnFirst: TButton
        Left = 8
        Top = 14
        Width = 32
        Height = 28
        Caption = '|<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnFirstClick
      end
      object btnPrior: TButton
        Left = 44
        Top = 14
        Width = 34
        Height = 28
        Caption = '<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnPriorClick
      end
      object btnNext: TButton
        Left = 162
        Top = 14
        Width = 34
        Height = 28
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnNextClick
      end
      object btnLast: TButton
        Left = 200
        Top = 14
        Width = 32
        Height = 28
        Caption = '>|'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btnLastClick
      end
      object btnZoomOut: TButton
        Left = 246
        Top = 14
        Width = 32
        Height = 28
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = btnZoomOutClick
      end
      object btnZoom100: TButton
        Left = 282
        Top = 14
        Width = 46
        Height = 28
        Caption = '100%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnZoom100Click
      end
      object btnZoomIn: TButton
        Left = 332
        Top = 14
        Width = 32
        Height = 28
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = btnZoomInClick
      end
      object btnZoomFit: TButton
        Left = 370
        Top = 14
        Width = 112
        Height = 28
        Caption = 'Geni'#351'li'#287'e S'#305#287'd'#305'r'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = btnZoomFitClick
      end
    end
  end
  object pnlContainer: TPanel
    Left = 0
    Top = 56
    Width = 1180
    Height = 744
    Align = alClient
    BevelOuter = bvNone
    Color = 15856113
    ParentBackground = False
    TabOrder = 1
  end
end
