inherited frmMain: TfrmMain
  BorderStyle = bsNone
  Caption = 'Gelesiye - Cari ve Veresiye Takip'
  ClientHeight = 640
  ClientWidth = 900
  Color = 16317180
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 900
  ExplicitHeight = 640
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    Color = 13795088
    ParentBackground = False
    TabOrder = 0
    OnDblClick = pnlTopDblClick
    OnMouseDown = pnlTopMouseDown
    DesignSize = (
      900
      46)
    object lblAppTitle: TLabel
      Left = 16
      Top = 12
      Width = 230
      Height = 20
      Caption = 'GELES'#304'YE  |  Basit Veresiye Takip'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnDblClick = pnlTopDblClick
      OnMouseDown = pnlTopMouseDown
    end
    object lblFirmaBaslik: TLabel
      Left = 400
      Top = 15
      Width = 160
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnMenu: TButton
      Left = 746
      Top = 7
      Width = 34
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'Se'#231'enekler ve '#304#351'lemler Men'#252's'#252
      Caption = #9881
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnMenuClick
    end
    object btnMinimize: TButton
      Left = 786
      Top = 7
      Width = 34
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'Simge Durumuna K'#252#231#252'lt'
      Caption = #8212
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnMinimizeClick
    end
    object btnMaximize: TButton
      Left = 824
      Top = 7
      Width = 34
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'Ekran'#305' Kapla / '#214'nceki Boyut'
      Caption = #9633
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnMaximizeClick
    end
    object btnCloseApp: TButton
      Left = 862
      Top = 7
      Width = 34
      Height = 32
      Anchors = [akTop, akRight]
      Hint = 'Programdan '#199#305'k'#305#351
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnCloseAppClick
    end
  end
  object pcPages: TPageControl
    Left = 0
    Top = 46
    Width = 900
    Height = 594
    ActivePage = tsHareketler
    Align = alClient
    TabOrder = 1
    object tsCariList: TTabSheet
      Caption = 'Cari Liste'
      TabVisible = False
      object pnlCards: TPanel
        Left = 0
        Top = 0
        Width = 892
        Height = 100
        Align = alTop
        BevelOuter = bvNone
        Color = 15397110
        ParentBackground = False
        TabOrder = 0
        OnResize = pnlCardsResize
        object cardBorclu: TPanel
          Left = 12
          Top = 10
          Width = 200
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object lblCardBorcTitle: TLabel
            Left = 12
            Top = 10
            Width = 154
            Height = 12
            Caption = 'TOPLAM BOR'#199' (CAR'#304' BORCU)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valCardBorc: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1710804
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCardBorcSub: TLabel
            Left = 12
            Top = 57
            Width = 68
            Height = 12
            Caption = 'Aktif bor'#231'lu cari'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardAlacakli: TPanel
          Left = 224
          Top = 10
          Width = 200
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          object lblCardAlacakTitle: TLabel
            Left = 12
            Top = 10
            Width = 151
            Height = 12
            Caption = 'TOPLAM ALACAK (CAR'#304' ALACA'#286'I)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valCardAlacak: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1793568
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCardAlacakSub: TLabel
            Left = 12
            Top = 57
            Width = 71
            Height = 12
            Caption = 'Aktif alacakl'#305' cari'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardNet: TPanel
          Left = 436
          Top = 10
          Width = 200
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          object lblCardNetTitle: TLabel
            Left = 12
            Top = 10
            Width = 55
            Height = 12
            Caption = 'NET BAK'#304'YE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valCardNet: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 2171169
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCardNetSub: TLabel
            Left = 12
            Top = 57
            Width = 75
            Height = 12
            Caption = 'Genel net durum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardCariSayisi: TPanel
          Left = 648
          Top = 10
          Width = 200
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          object lblCardCariTitle: TLabel
            Left = 12
            Top = 10
            Width = 96
            Height = 12
            Caption = 'CAR'#304' '#304'STAT'#304'ST'#304'KLER'#304
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valCardCari: TLabel
            Left = 12
            Top = 28
            Width = 112
            Height = 17
            Caption = 'Aktif: 0  |  Pasif: 0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 2699841
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCardCariSub: TLabel
            Left = 12
            Top = 53
            Width = 158
            Height = 13
            Caption = 'Bor'#231'lu: 0  |  Alacakl'#305': 0  |  S'#305'f'#305'r: 0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 5592405
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object pnlFilterBar: TPanel
        Left = 0
        Top = 100
        Width = 892
        Height = 46
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object edtAramaMetni: TEdit
          Left = 12
          Top = 11
          Width = 420
          Height = 23
          Hint = 'Cari ad'#305' veya kodu ile ara...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TextHint = 'Cari ad'#305' veya kodu ile ara...'
          OnChange = edtAramaMetniChange
          OnKeyDown = edtAramaMetniKeyDown
        end
        object cmbAra: TComboBox
          Left = 440
          Top = 11
          Width = 130
          Height = 23
          Style = csDropDownList
          Hint = 'Arama Y'#246'ntemi (Yaz'#305'ld'#305#287#305' Gibi / '#304#231'erenleri Ara)'
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'Yaz'#305'ld'#305#287#305' Gibi'
          OnChange = cmbAraChange
          Items.Strings = (
            'Yaz'#305'ld'#305#287#305' Gibi'
            #304#231'erenleri Ara')
        end
        object cmbHesap: TComboBox
          Left = 580
          Top = 11
          Width = 110
          Height = 23
          Style = csDropDownList
          Hint = 'Hesap Durumu Filtresi (T'#252'm'#252' / Aktif / Pasif)'
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = 'T'#252'm'#252'...'
          OnChange = cmbHesapChange
          Items.Strings = (
            'T'#252'm'#252'...'
            'Aktif'
            'Pasif')
        end
        object cmbFiltre: TComboBox
          Left = 700
          Top = 11
          Width = 180
          Height = 23
          Style = csDropDownList
          Hint = 'Bakiye Filtresi'
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = 'T'#252'm'#252'...'
          OnChange = cmbFiltreChange
          Items.Strings = (
            'T'#252'm'#252'...'
            'Bor'#231'lular'
            'Alacakl'#305'lar'
            'S'#305'f'#305'r Olmayanlar'
            'Bakiyesi S'#305'f'#305'r'
            #9888' Limit A'#351'anlar')
        end
      end
      object pnlBottom: TPanel
        Left = 0
        Top = 528
        Width = 892
        Height = 56
        Align = alBottom
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        DesignSize = (
          892
          56)
        object btnEkle: TButton
          Left = 12
          Top = 10
          Width = 36
          Height = 36
          Hint = 'Yeni Cari Kart'#305' Ekle (F3)'
          Caption = #10133
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnEkleClick
        end
        object btnDegistir: TButton
          Left = 52
          Top = 10
          Width = 36
          Height = 36
          Hint = 'Se'#231'ili Cariyi D'#252'zenle (F4)'
          Caption = #9999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnDegistirClick
        end
        object btnSil: TButton
          Left = 92
          Top = 10
          Width = 36
          Height = 36
          Hint = 'Se'#231'ili Cari Kart'#305'n'#305' Sil'
          Caption = #55357#56785
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnSilClick
        end
        object btnOzet: TButton
          Left = 132
          Top = 10
          Width = 36
          Height = 36
          Hint = 'Genel Bakiye ve Cari '#214'zeti'
          Caption = #8721
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnOzetClick
        end
        object btnYazdir: TButton
          Left = 172
          Top = 10
          Width = 36
          Height = 36
          Hint = 'Yazd'#305'rma Se'#231'enekleri'
          Caption = #55357#56758
          ParentShowHint = False
          PopupMenu = pmCariYazdir
          ShowHint = True
          TabOrder = 4
          OnClick = btnYazdirClick
        end
        object btnHareketler: TButton
          Left = 652
          Top = 10
          Width = 228
          Height = 36
          Anchors = [akTop, akRight]
          Hint = 'Se'#231'ili Carinin Hareketlerini A'#231' (Enter)'
          Caption = 'Hareketler'
          Default = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = btnHareketlerClick
        end
      end
      object lvCariler: TListView
        Left = 0
        Top = 146
        Width = 892
        Height = 382
        Align = alClient
        Columns = <
          item
            Caption = 'Cari Kod'
            Width = 85
          end
          item
            Caption = 'Cari Unvan'
            Width = 240
          end
          item
            Caption = 'A'#231#305'klama / Not'
            Width = 180
          end
          item
            Caption = #350'ehir'
            Width = 100
          end
          item
            Caption = 'Son '#304#351'lem'
            Width = 100
          end
          item
            Alignment = taRightJustify
            Caption = 'Bakiye'
            Width = 130
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 3
        ViewStyle = vsReport
        OnColumnClick = lvCarilerColumnClick
        OnCustomDrawItem = lvCarilerCustomDrawItem
        OnCustomDrawSubItem = lvCarilerCustomDrawSubItem
        OnDblClick = lvCarilerDblClick
        OnResize = lvCarilerResize
        OnSelectItem = lvCarilerSelectItem
      end
      object pnlSearchPopup: TPanel
        Left = 12
        Top = 146
        Width = 660
        Height = 280
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        TabOrder = 4
        Visible = False
        object pnlSearchPopupHeader: TPanel
          Left = 0
          Top = 0
          Width = 658
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Color = 15987699
          ParentBackground = False
          TabOrder = 0
          object lblSearchPopupTitle: TLabel
            Left = 8
            Top = 6
            Width = 450
            Height = 13
            Caption = 
              'H'#305'zl'#305' Arama Sonu'#231'lar'#305' (Se'#231'mek i'#231'in Enter veya '#199'ift T'#305'k, Kapatmak i'#231'in Esc)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 4210752
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblSearchPopupCount: TLabel
            Left = 580
            Top = 6
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = '0 kay'#305't'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 7105644
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object lvSearchPopup: TListView
          Left = 0
          Top = 26
          Width = 658
          Height = 252
          Align = alClient
          BorderStyle = bsNone
          Columns = <
            item
              Caption = 'Cari Kodu'
              Width = 85
            end
            item
              Caption = 'Cari Ad'#305' / Unvan'
              Width = 240
            end
            item
              Caption = 'A'#231#305'klama / Yetkili'
              Width = 200
            end
            item
              Alignment = taRightJustify
              Caption = 'Bakiye'
              Width = 120
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          OnCustomDrawItem = lvSearchPopupCustomDrawItem
          OnCustomDrawSubItem = lvSearchPopupCustomDrawSubItem
          OnDblClick = lvSearchPopupDblClick
          OnKeyDown = lvSearchPopupKeyDown
        end
      end
    end
    object tsHareketler: TTabSheet
      Caption = 'Hareketler'
      ImageIndex = 1
      TabVisible = False
      object pnlHrkTop: TPanel
        Left = 0
        Top = 0
        Width = 892
        Height = 100
        Align = alTop
        BevelOuter = bvNone
        Color = 15397110
        ParentBackground = False
        TabOrder = 0
        OnResize = pnlHrkTopResize
        object pnlCariKart: TPanel
          Left = 12
          Top = 10
          Width = 220
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          DesignSize = (
            220
            80)
          object lblHrkCariUnvan: TLabel
            Left = 12
            Top = 8
            Width = 196
            Height = 22
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'CAR'#304' ADI'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 2699841
            Font.Height = -15
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
          end
          object lblHrkCariIl: TLabel
            Left = 12
            Top = 34
            Width = 196
            Height = 16
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
          end
          object lblHrkCariTel: TLabel
            Left = 12
            Top = 54
            Width = 196
            Height = 16
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
          end
        end
        object cardHrkBorc: TPanel
          Left = 242
          Top = 10
          Width = 145
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          object lblHrkBorcTitle: TLabel
            Left = 12
            Top = 10
            Width = 83
            Height = 12
            Caption = 'TOPLAM BOR'#199
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valHrkBorc: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1710804
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblHrkBorcSub: TLabel
            Left = 12
            Top = 57
            Width = 52
            Height = 12
            Caption = 'Bor'#231' giri'#351'leri'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardHrkAlacak: TPanel
          Left = 397
          Top = 10
          Width = 145
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          object lblHrkAlacakTitle: TLabel
            Left = 12
            Top = 10
            Width = 91
            Height = 12
            Caption = 'TOPLAM ALACAK'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valHrkAlacak: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1793568
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblHrkAlacakSub: TLabel
            Left = 12
            Top = 57
            Width = 77
            Height = 12
            Caption = 'Alacak giri'#351'leri'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardHrkBakiye: TPanel
          Left = 552
          Top = 10
          Width = 145
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          object lblHrkBakiyeTitle: TLabel
            Left = 12
            Top = 10
            Width = 33
            Height = 12
            Caption = 'BAK'#304'YE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valHrkBakiye: TLabel
            Left = 12
            Top = 28
            Width = 60
            Height = 25
            Caption = '0,00 TL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 2171169
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblHrkBakiyeSub: TLabel
            Left = 12
            Top = 57
            Width = 48
            Height = 12
            Caption = 'Net durum'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object cardHrkIslem: TPanel
          Left = 707
          Top = 10
          Width = 145
          Height = 80
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 4
          object lblHrkIslemTitle: TLabel
            Left = 12
            Top = 10
            Width = 62
            Height = 12
            Caption = #304#350'LEM SAYISI'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object valHrkIslem: TLabel
            Left = 12
            Top = 28
            Width = 10
            Height = 25
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 2699841
            Font.Height = -18
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblHrkIslemSub: TLabel
            Left = 12
            Top = 57
            Width = 59
            Height = 12
            Caption = 'Hareket kayd'#305
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 10395294
            Font.Height = -10
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object pnlHrkBottom: TPanel
        Left = 0
        Top = 528
        Width = 892
        Height = 56
        Align = alBottom
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object pnlHrkBottomCenter: TPanel
          Left = 0
          Top = 0
          Width = 892
          Height = 56
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          Padding.Left = 8
          Padding.Top = 10
          Padding.Right = 8
          Padding.Bottom = 10
          ParentBackground = False
          TabOrder = 0
          object btnCariListesi: TButton
            AlignWithMargins = True
            Left = 8
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alLeft
            Hint = 'Cari Listesine D'#246'n (Esc)'
            Cancel = True
            Caption = #8617
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = btnCariListesiClick
          end
          object btnHrkFisler: TButton
            AlignWithMargins = True
            Left = 48
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alLeft
            Hint = 'Fi'#351' Giri'#351'i Men'#252's'#252' (F5-F8)'
            Caption = '+'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnHrkFislerClick
          end
          object btnHrkDuzenle: TButton
            AlignWithMargins = True
            Left = 88
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alLeft
            Hint = 'Se'#231'ili Fi'#351'i D'#252'zenle (F4 / '#199'ift T'#305'k)'
            Caption = #9999
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btnHrkDuzenleClick
          end
          object btnHrkSil: TButton
            AlignWithMargins = True
            Left = 128
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alLeft
            Hint = 'Se'#231'ili Hareket Kayd'#305'n'#305' Sil'
            Caption = #55357#56785
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = btnHrkSilClick
          end
          object btnHrkYazdir: TButton
            AlignWithMargins = True
            Left = 168
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alLeft
            Hint = 'Yazd'#305'rma Se'#231'enekleri'
            Caption = #55357#56758
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            PopupMenu = pmHrkYazdir
            ShowHint = True
            TabOrder = 4
            OnClick = btnHrkYazdirClick
          end
          object lblHrkNotMetni: TLabel
            AlignWithMargins = True
            Left = 214
            Top = 19
            Width = 4
            Height = 15
            Margins.Left = 6
            Margins.Top = 9
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ShowHint = True
          end
          object btnSonrakiCari: TButton
            AlignWithMargins = True
            Left = 848
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 4
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Hint = 'Sonraki Cari (Sa'#287' Ok)'
            Caption = #9654
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = btnSonrakiCariClick
          end
          object btnOncekiCari: TButton
            AlignWithMargins = True
            Left = 808
            Top = 10
            Width = 36
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Hint = #214'nceki Cari (Sol Ok)'
            Caption = #9664
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = btnOncekiCariClick
          end
        end
      end
      object lvHareketler: TListView
        Left = 0
        Top = 135
        Width = 900
        Height = 449
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Tarih'
            Width = 130
          end
          item
            Caption = 'T'#252'r'
            Width = 110
          end
          item
            Caption = 'A'#231#305'klama'
            Width = 240
          end
          item
            Caption = 'Bor'#231
            Width = 100
            Alignment = taRightJustify
          end
          item
            Caption = 'Alacak'
            Width = 100
            Alignment = taRightJustify
          end
          item
            Caption = 'Bakiye'
            Width = 120
            Alignment = taRightJustify
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = lvHareketlerColumnClick
        OnCustomDrawItem = lvHareketlerCustomDrawItem
        OnCustomDrawSubItem = lvHareketlerCustomDrawSubItem
        OnDblClick = lvHareketlerDblClick
        OnResize = lvHareketlerResize
      end
    end
  end
  object mmMain: TMainMenu
    Left = 436
    Top = 267
    object miIslemler: TMenuItem
      Caption = #304#351'lemler'
      object miCariKartEkle: TMenuItem
        Caption = 'Cari Kart Ekle'
        OnClick = btnEkleClick
      end
      object miCariKartDegistir: TMenuItem
        Caption = 'Cari Kart De'#287'i'#351'tir'
        OnClick = btnDegistirClick
      end
      object miCariKartSil: TMenuItem
        Caption = 'Cari Kart Sil'
        OnClick = btnSilClick
      end
      object miN2: TMenuItem
        Caption = '-'
      end
      object miCarininHareketleriniAc: TMenuItem
        Caption = 'Cari Hareketleri'
        OnClick = btnHareketlerClick
      end
    end
    object miYedek: TMenuItem
      Caption = 'Yedek'
      object miYedekYonetimi: TMenuItem
        Caption = 'Yedek Y'#246'netim Merkezi...'
        ShortCut = 121
        OnClick = miYedekYonetimiClick
      end
      object miYedekSep1: TMenuItem
        Caption = '-'
      end
      object miYedekAl: TMenuItem
        Caption = 'H'#305'zl'#305' Veritaban'#305' Yede'#287'i Al'
        OnClick = miYedekAlClick
      end
      object miYedekGeriYukle: TMenuItem
        Caption = 'Yedekten Geri Y'#252'kle'
        OnClick = miYedekGeriYukleClick
      end
    end
    object miAraclar: TMenuItem
      Caption = 'Ara'#231'lar'
      object miAciklamalar: TMenuItem
        Caption = 'A'#231#305'klamalar'
        OnClick = miAciklamalarClick
      end
      object miSifreDegistir: TMenuItem
        Caption = #350'ifre De'#287'i'#351'tir'
        OnClick = miSifreDegistirClick
      end
      object miGenelAyarlar: TMenuItem
        Caption = 'Genel Ayarlar'
        OnClick = miGenelAyarlarClick
      end
      object miN3: TMenuItem
        Caption = '-'
      end
      object miListeToplamlari: TMenuItem
        Caption = 'Liste Toplamlar'#305
        OnClick = btnOzetClick
      end
      object miHesapMakinesi: TMenuItem
        Caption = 'Hesap Makinesi'
        OnClick = miHesapMakinesiClick
      end
    end
    object miYardim: TMenuItem
      Caption = 'Yard'#305'm'
      object miHakkinda: TMenuItem
        Caption = 'Hakk'#305'nda'
        OnClick = miHakkindaClick
      end
    end
    object miCikis: TMenuItem
      Caption = #199#305'k'#305#351
      OnClick = miCikisClick
    end
  end
  object pmHrkEkle: TPopupMenu
    AutoHotkeys = maManual
    Left = 436
    Top = 345
    object miHesabaBorcEkle: TMenuItem
      Caption = 'Bor'#231#9'F5'
      ShortCut = 116
      OnClick = miHesabaBorcEkleClick
    end
    object miTahsilatYap: TMenuItem
      Caption = 'Tahsilat'#9'F6'
      ShortCut = 117
      OnClick = miTahsilatYapClick
    end
    object miHesabaAlacakEkle: TMenuItem
      Caption = 'Alacak'#9'F7'
      ShortCut = 118
      OnClick = miHesabaAlacakEkleClick
    end
    object miOdemeYap: TMenuItem
      Caption = #214'deme'#9'F8'
      ShortCut = 119
      OnClick = miOdemeYapClick
    end
  end
  object pmHrkYazdir: TPopupMenu
    AutoHotkeys = maManual
    Left = 520
    Top = 345
    object miHrkFisYazdir: TMenuItem
      Caption = #55357#56495' Se'#231'ili '#304#351'lemin Fi'#351'i'
      OnClick = miHrkFisYazdirClick
    end
    object miHrkEkstreYazdir: TMenuItem
      Caption = #55357#56196' Cari Hesap Ekstresi'
      OnClick = miHrkEkstreYazdirClick
    end
  end
  object pmCariYazdir: TPopupMenu
    AutoHotkeys = maManual
    Left = 212
    Top = 10
    object miCariListesiYazdir: TMenuItem
      Caption = #55357#56196' Cari Listesi ('#214'zet)'
      OnClick = miCariListesiYazdirClick
    end
    object miCariDetayYazdir: TMenuItem
      Caption = #55357#56196' Hareket Detayl'#305' Cari Raporu'
      OnClick = miCariDetayYazdirClick
    end
  end
  object pmAppMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 320
    Top = 8
    object miAppFirmaBilgileri: TMenuItem
      Caption = #304#351'letme / Firma Bilgileri'
      OnClick = miFirmaBilgileriClick
    end
    object miAppGenelAyarlar: TMenuItem
      Caption = 'Genel Ayarlar'
      OnClick = miGenelAyarlarClick
    end
    object miAppSifreDegistir: TMenuItem
      Caption = 'Giri'#351' '#350'ifresini De'#287'i'#351'tir'
      OnClick = miSifreDegistirClick
    end
    object miAppAciklamalar: TMenuItem
      Caption = 'Standart A'#231#305'klama Listesi'
      OnClick = miAciklamalarClick
    end
    object miAppListeToplamlari: TMenuItem
      Caption = 'Liste Toplamlar'#305
      OnClick = btnOzetClick
    end
    object miAppYazdirma: TMenuItem
      Caption = 'Yazd'#305'rma ve Raporlar'
      object miAppRaporCariOzet: TMenuItem
        Caption = 'Cari Listesi ('#214'zet)'
        OnClick = miCariListesiYazdirClick
      end
      object miAppRaporCariDetay: TMenuItem
        Caption = 'Hareket Detayl'#305' Cari Raporu'
        OnClick = miCariDetayYazdirClick
      end
    end
    object miAppN1: TMenuItem
      Caption = '-'
    end
    object miAppYedekYonetimi: TMenuItem
      Caption = 'Yedek Y'#246'netim Merkezi...'
      OnClick = miYedekYonetimiClick
    end
    object miAppYedeklemeAyarlari: TMenuItem
      Caption = 'Yedekleme Ayarlar'#305'...'
      OnClick = miYedeklemeAyarlariClick
    end
    object miAppN2: TMenuItem
      Caption = '-'
    end
    object miAppHesapMakinesi: TMenuItem
      Caption = 'Hesap Makinesi'
      OnClick = miHesapMakinesiClick
    end
    object miDevSeedDemo: TMenuItem
      Caption = '[Geli'#351'tirici] Test Men'#252's'#252
      Visible = False
      object miDevSeedReset: TMenuItem
        Caption = 'Veritaban'#305'n'#305' S'#305'f'#305'rla (Verileri Sil)'
        OnClick = miDevSeedResetClick
      end
      object miDevSeedLoad: TMenuItem
        Caption = 'Demo Verileri Y'#252'kle'
        OnClick = miDevSeedLoadClick
      end
      object miDevSeedSep: TMenuItem
        Caption = '-'
      end
      object miDevSeedBoth: TMenuItem
        Caption = 'S'#305'f'#305'rla + Demo Veri Y'#252'kle'
        OnClick = btnDevSeedDemoClick
      end
    end
    object miAppHakkinda: TMenuItem
      Caption = 'Program Hakk'#305'nda'
      OnClick = miHakkindaClick
    end
    object miAppN3: TMenuItem
      Caption = '-'
    end
    object miAppCikis: TMenuItem
      Caption = #199#305'k'#305#351
      OnClick = miCikisClick
    end
  end
  object trayGelesiye: TTrayIcon
    Hint = 'Gelesiye '#8212' Basit Veresiye Takip'
    PopupMenu = pmTray
    Visible = True
    OnDblClick = trayGelesiyeDblClick
    Left = 240
    Top = 8
  end
  object pmTray: TPopupMenu
    Left = 180
    Top = 8
    object miTrayGoster: TMenuItem
      Caption = 'Gelesiye'#39'yi A'#231
      Default = True
      OnClick = miTrayGosterClick
    end
    object miTraySep1: TMenuItem
      Caption = '-'
    end
    object miTrayYedekAl: TMenuItem
      Caption = 'H'#305'zl'#305' Yedek Al'
      OnClick = miYedekAlClick
    end
    object miTrayYedekYonetimi: TMenuItem
      Caption = 'Yedek Y'#246'netimi...'
      OnClick = miYedekYonetimiClick
    end
    object miTraySep2: TMenuItem
      Caption = '-'
    end
    object miTrayHakkinda: TMenuItem
      Caption = 'Hakk'#305'nda...'
      OnClick = miHakkindaClick
    end
    object miTraySep3: TMenuItem
      Caption = '-'
    end
    object miTrayCikis: TMenuItem
      Caption = 'Programdan '#199#305'k'
      OnClick = miTrayCikisClick
    end
  end
end
