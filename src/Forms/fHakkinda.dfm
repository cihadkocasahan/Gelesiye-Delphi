inherited frmHakkinda: TfrmHakkinda
  BorderStyle = bsNone
  Caption = 'Hakk'#305'nda'
  ClientHeight = 580
  ClientWidth = 460
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 1976606
    ParentBackground = False
    TabOrder = 0
    OnMouseDown = pnlTitleBarMouseDown
    object lblTitleCaption: TLabel
      Left = 16
      Top = 10
      Width = 60
      Height = 20
      Caption = 'Hakk'#305'nda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 416
      Top = 4
      Width = 36
      Height = 32
      Cursor = crHandPoint
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnKapatClick
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 40
    Width = 460
    Height = 492
    Align = alClient
    BevelOuter = bvNone
    Color = 16317180
    ParentBackground = False
    TabOrder = 1
    object pnlHeaderCard: TPanel
      Left = 16
      Top = 12
      Width = 428
      Height = 84
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object imgAppLogo: TImage
        Left = 16
        Top = 16
        Width = 52
        Height = 52
        Center = True
        Proportional = True
        Transparent = True
      end
      object lblAppName: TLabel
        Left = 80
        Top = 12
        Width = 79
        Height = 28
        Caption = 'Gelesiye'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 988970
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblAppDesc: TLabel
        Left = 80
        Top = 40
        Width = 209
        Height = 15
        Caption = 'Basit Veresiye Takip'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4868682
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblVersion: TLabel
        Left = 80
        Top = 58
        Width = 145
        Height = 15
        Caption = 'Versiyon 1.0.0 (Win64) - 2026'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlSlogan: TPanel
      Left = 16
      Top = 104
      Width = 428
      Height = 52
      BevelOuter = bvNone
      Color = 16773866
      ParentBackground = False
      TabOrder = 1
      object lblSlogan: TLabel
        Left = 12
        Top = 8
        Width = 404
        Height = 36
        Alignment = taCenter
        AutoSize = False
        Caption = 
          '"Verme veresiye beklersin gelesiye,'#13#10'madem verdin veresiye sana laz'#305'm Gelesiye!"'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 988970
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        WordWrap = True
      end
    end
    object pnlDevCard: TPanel
      Left = 16
      Top = 164
      Width = 428
      Height = 316
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object lblDevHeader: TLabel
        Left = 16
        Top = 14
        Width = 63
        Height = 13
        Caption = 'GEL'#304#350'T'#304'R'#304'C'#304
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 15426341
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDevName: TLabel
        Left = 16
        Top = 30
        Width = 148
        Height = 23
        Caption = 'Cihad Koca'#351'ahan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1976606
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDevRole: TLabel
        Left = 16
        Top = 54
        Width = 148
        Height = 15
        Caption = 'Senior Software Developer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6974058
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object pnlRowWP: TPanel
        Left = 16
        Top = 80
        Width = 396
        Height = 50
        BevelOuter = bvNone
        Color = 16645629
        ParentBackground = False
        TabOrder = 0
        object imgWP: TImage
          Left = 12
          Top = 9
          Width = 32
          Height = 32
          Center = True
          Proportional = True
          Transparent = True
        end
        object lblWPTag: TLabel
          Left = 56
          Top = 8
          Width = 55
          Height = 13
          Caption = 'WhatsApp'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2478886
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblWPVal: TLabel
          Left = 56
          Top = 24
          Width = 114
          Height = 17
          Cursor = crHandPoint
          Caption = '+90 536 888 84 00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1976606
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkWPClick
        end
        object btnWPAc: TSpeedButton
          Left = 304
          Top = 11
          Width = 80
          Height = 28
          Cursor = crHandPoint
          Caption = 'Mesaj At'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2478886
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkWPClick
        end
      end
      object pnlRowLinkedIn: TPanel
        Left = 16
        Top = 138
        Width = 396
        Height = 50
        BevelOuter = bvNone
        Color = 16774639
        ParentBackground = False
        TabOrder = 1
        object imgLinkedIn: TImage
          Left = 12
          Top = 9
          Width = 32
          Height = 32
          Center = True
          Proportional = True
          Transparent = True
        end
        object lblLinkedInTag: TLabel
          Left = 56
          Top = 8
          Width = 44
          Height = 13
          Caption = 'LinkedIn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12739594
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblLinkedInVal: TLabel
          Left = 56
          Top = 24
          Width = 188
          Height = 17
          Cursor = crHandPoint
          Caption = 'linkedin.com/in/cihadkocasahan'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12739594
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkLinkedInClick
        end
        object btnLinkedInAc: TSpeedButton
          Left = 304
          Top = 11
          Width = 80
          Height = 28
          Cursor = crHandPoint
          Caption = 'Profili A'#231
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12739594
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkLinkedInClick
        end
      end
      object pnlRowGitHub: TPanel
        Left = 16
        Top = 196
        Width = 396
        Height = 50
        BevelOuter = bvNone
        Color = 16119285
        ParentBackground = False
        TabOrder = 2
        object imgGitHub: TImage
          Left = 12
          Top = 9
          Width = 32
          Height = 32
          Center = True
          Proportional = True
          Transparent = True
        end
        object lblGitHubTag: TLabel
          Left = 56
          Top = 8
          Width = 37
          Height = 13
          Caption = 'GitHub'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2368548
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblGitHubVal: TLabel
          Left = 56
          Top = 24
          Width = 146
          Height = 17
          Cursor = crHandPoint
          Caption = 'github.com/cihadkocasahan'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2368548
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkGitHubClick
        end
        object btnGitHubAc: TSpeedButton
          Left = 304
          Top = 11
          Width = 80
          Height = 28
          Cursor = crHandPoint
          Caption = 'Sayfay'#305' A'#231
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2368548
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkGitHubClick
        end
      end
      object pnlRowEmail: TPanel
        Left = 16
        Top = 254
        Width = 396
        Height = 50
        BevelOuter = bvNone
        Color = 16774136
        ParentBackground = False
        TabOrder = 3
        object imgEmail: TImage
          Left = 12
          Top = 9
          Width = 32
          Height = 32
          Center = True
          Proportional = True
          Transparent = True
        end
        object lblEmailTag: TLabel
          Left = 56
          Top = 8
          Width = 39
          Height = 13
          Caption = 'E-Posta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3488746
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblEmailVal: TLabel
          Left = 56
          Top = 24
          Width = 153
          Height = 17
          Cursor = crHandPoint
          Caption = 'cihadkocasahan@gmail.com'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3488746
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkEmailClick
        end
        object btnEmailAc: TSpeedButton
          Left = 304
          Top = 11
          Width = 80
          Height = 28
          Cursor = crHandPoint
          Caption = 'E-Posta Yaz'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3488746
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkEmailClick
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 532
    Width = 460
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object lblCopyright: TLabel
      Left = 16
      Top = 16
      Width = 205
      Height = 15
      Caption = #169' 2026 Gelesiye. T'#252'm Haklar'#305' Sakl'#305'd'#305'r.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnKapat: TButton
      Left = 356
      Top = 8
      Width = 88
      Height = 32
      Cursor = crHandPoint
      Cancel = True
      Caption = 'Kapat'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnKapatClick
    end
  end
end
