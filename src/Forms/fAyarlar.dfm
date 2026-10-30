inherited frmAyarlar: TfrmAyarlar
  BorderStyle = bsNone
  Caption = 'Ayarlar'
  ClientHeight = 530
  ClientWidth = 530
  Color = clWhite
  PopupMode = pmAuto
  StyleElements = [seFont, seClient, seBorder]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 530
  ExplicitHeight = 530
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      530
      40)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 10
      Width = 51
      Height = 20
      Caption = 'Ayarlar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 494
      Top = 6
      Width = 28
      Height = 28
      Anchors = [akTop, akRight]
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6583371
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnKapatClick
    end
  end
  object pcAyarlar: TPageControl
    Left = 0
    Top = 40
    Width = 530
    Height = 442
    ActivePage = tsFirma
    Align = alClient
    TabOrder = 0
    object tsFirma: TTabSheet
      Caption = #304#351'letme / Firma'
      object grpFirma: TGroupBox
        Left = 16
        Top = 14
        Width = 490
        Height = 360
        Caption = 'Firma Bilgileri  '
        TabOrder = 0
        object lblFirmaUnvan: TLabel
          Left = 24
          Top = 32
          Width = 76
          Height = 15
          Caption = 'Firma '#220'nvan'#305' :'
        end
        object lblFirmaTelefon: TLabel
          Left = 24
          Top = 72
          Width = 45
          Height = 15
          Caption = 'Telefon :'
        end
        object lblFirmaIlIlce: TLabel
          Left = 24
          Top = 112
          Width = 41
          Height = 15
          Caption = #304'l / '#304'l'#231'e :'
        end
        object lblFirmaVergi: TLabel
          Left = 24
          Top = 152
          Width = 73
          Height = 15
          Caption = 'Vergi D. / No :'
        end
        object lblFirmaAdres: TLabel
          Left = 24
          Top = 192
          Width = 36
          Height = 15
          Caption = 'Adres :'
        end
        object edtFirmaUnvan: TEdit
          Left = 140
          Top = 28
          Width = 320
          Height = 23
          TabOrder = 0
        end
        object edtFirmaTelefon: TEdit
          Left = 140
          Top = 68
          Width = 150
          Height = 23
          TabOrder = 1
        end
        object edtFirmaFaks: TEdit
          Left = 310
          Top = 68
          Width = 150
          Height = 23
          TabOrder = 2
        end
        object cmbFirmaIl: TComboBox
          Left = 140
          Top = 108
          Width = 150
          Height = 23
          Style = csDropDownList
          TabOrder = 3
          OnChange = cmbFirmaIlChange
        end
        object cmbFirmaIlce: TComboBox
          Left = 310
          Top = 108
          Width = 150
          Height = 23
          Style = csDropDownList
          TabOrder = 4
        end
        object edtFirmaVergiDairesi: TEdit
          Left = 140
          Top = 148
          Width = 150
          Height = 23
          TabOrder = 5
        end
        object edtFirmaVergiNo: TEdit
          Left = 310
          Top = 148
          Width = 150
          Height = 23
          TabOrder = 6
        end
        object edtFirmaAdres: TEdit
          Left = 140
          Top = 188
          Width = 320
          Height = 23
          TabOrder = 7
        end
      end
    end
    object tsGenel: TTabSheet
      Caption = 'Genel Ayarlar'
      object grpGenel: TGroupBox
        Left = 16
        Top = 14
        Width = 490
        Height = 360
        Caption = '  Program Genel Ayarlar'#305'  '
        TabOrder = 0
        object lblParaBirimi: TLabel
          Left = 24
          Top = 36
          Width = 63
          Height = 15
          Caption = 'Para Birimi :'
        end
        object lblKapatmaEylemi: TLabel
          Left = 24
          Top = 80
          Width = 148
          Height = 15
          Caption = 'Pencere Kapat'#305'ld'#305#287#305'nda (X) :'
        end
        object cmbParaBirimi: TComboBox
          Left = 180
          Top = 32
          Width = 140
          Height = 23
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = 'TL'
          Items.Strings = (
            'TL'
            'USD'
            'EUR'
            'GBP')
        end
        object cmbKapatmaEylemi: TComboBox
          Left = 180
          Top = 76
          Width = 260
          Height = 23
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 1
          Text = 'Her Seferinde Sor'
          Items.Strings = (
            'Her Seferinde Sor'
            'Sistem Tepsisine (Saatin Yan'#305'na) K'#252#231#252'lt'
            'Programdan Tamamen '#199#305'k')
        end
        object chkZebraGrid: TCheckBox
          Left = 24
          Top = 130
          Width = 360
          Height = 20
          Caption = 'Tablolarda zebra (sat'#305'r renklendirme) stilini aktif et'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object chkSifreKorumasi: TCheckBox
          Left = 24
          Top = 168
          Width = 380
          Height = 20
          Caption = 'Program ba'#351'lang'#305'c'#305'nda g'#252'venlik '#351'ifresi sor (Varsay'#305'lan: gel)'
          TabOrder = 3
        end
      end
    end
    object tsYedekleme: TTabSheet
      Caption = 'Yedekleme'
      object grpYedekleme: TGroupBox
        Left = 16
        Top = 14
        Width = 490
        Height = 360
        Caption = '  Veritaban'#305' Yedekleme Se'#231'enekleri  '
        TabOrder = 0
        object lblYedekKlasoru: TLabel
          Left = 20
          Top = 32
          Width = 98
          Height = 15
          Caption = 'Yedekleme Klas'#246'r'#252' :'
        end
        object lblOtoYedek: TLabel
          Left = 20
          Top = 100
          Width = 145
          Height = 15
          Caption = 'Otomatik Yedekleme Aral'#305#287#305' :'
        end
        object lblMaksYedek: TLabel
          Left = 20
          Top = 145
          Width = 127
          Height = 15
          Caption = 'Saklanacak Yedek Say'#305's'#305' :'
        end
        object lblSonYedekBilgi: TLabel
          Left = 20
          Top = 200
          Width = 250
          Height = 15
          Caption = 'Son Yedekleme: -'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 7105644
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object edtYedekKlasoru: TEdit
          Left = 20
          Top = 54
          Width = 320
          Height = 23
          ReadOnly = True
          TabOrder = 0
        end
        object btnYedekKlasoruSec: TButton
          Left = 348
          Top = 53
          Width = 60
          Height = 25
          Caption = 'G'#246'zat...'
          TabOrder = 1
          OnClick = btnYedekKlasoruSecClick
        end
        object btnYedekKlasoruVarsayilan: TButton
          Left = 412
          Top = 53
          Width = 66
          Height = 25
          Caption = 'Varsay'#305'lan'
          TabOrder = 2
          OnClick = btnYedekKlasoruVarsayilanClick
        end
        object cmbOtoYedek: TComboBox
          Left = 180
          Top = 96
          Width = 260
          Height = 23
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 3
          Text = 'Her Program Kapan'#305#351#305'nda ('#214'nerilen)'
          Items.Strings = (
            'Yedekleme Yok (Yaln'#305'zca Manuel)'
            'Her Program Kapan'#305#351#305'nda ('#214'nerilen)'
            'G'#252'nde 1 Kez (G'#252'n'#252'n ilk kapan'#305#351#305'nda)'
            'Haftada 1 Kez'
            'Her Program A'#231#305'l'#305#351#305'nda')
        end
        object cmbMaksYedek: TComboBox
          Left = 180
          Top = 141
          Width = 260
          Height = 23
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 4
          Text = 'Son 10 Yedek ('#214'nerilen)'
          Items.Strings = (
            'Son 5 Yedek'
            'Son 10 Yedek ('#214'nerilen)'
            'Son 20 Yedek'
            'Son 50 Yedek'
            'T'#252'm'#252'n'#252' Sakla (S'#305'n'#305'rs'#305'z)')
        end
        object btnYedekYonetimiAc: TButton
          Left = 20
          Top = 235
          Width = 220
          Height = 32
          Caption = #128190' Yedek Y'#246'netim Merkezini A'#231'...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = btnYedekYonetimiAcClick
        end
      end
    end
    object tsSifre: TTabSheet
      Caption = #350'ifre De'#287'i'#351'tir'
      ImageIndex = 1
      object grpSifre: TGroupBox
        Left = 16
        Top = 14
        Width = 490
        Height = 260
        Caption = '  Giri'#351' '#350'ifresi '#304#351'lemleri  '
        TabOrder = 0
        object lblSifreBilgi: TLabel
          Left = 20
          Top = 30
          Width = 430
          Height = 36
          AutoSize = False
          Caption = 
            'Program giri'#351'inde kullan'#305'lacak '#351'ifreyi buradan de'#287'i'#351'tirebilirsin' +
            'iz. (Varsay'#305'lan '#351'ifre "gel"dir. '#304'lk '#351'ifre de'#287'i'#351'ikli'#287'inde eski '#351'i' +
            'freyi bo'#351' b'#305'rakabilir veya "gel" yazabilirsiniz.)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object lblEskiSifre: TLabel
          Left = 20
          Top = 84
          Width = 72
          Height = 15
          Caption = 'Mevcut '#350'ifre :'
        end
        object lblYeniSifre: TLabel
          Left = 20
          Top = 124
          Width = 54
          Height = 15
          Caption = 'Yeni '#350'ifre :'
        end
        object lblYeniSifreTekrar: TLabel
          Left = 20
          Top = 164
          Width = 97
          Height = 15
          Caption = 'Yeni '#350'ifre (Tekrar) :'
        end
        object edtEskiSifre: TEdit
          Left = 140
          Top = 80
          Width = 200
          Height = 23
          PasswordChar = '*'
          TabOrder = 0
        end
        object edtYeniSifre: TEdit
          Left = 140
          Top = 120
          Width = 200
          Height = 23
          PasswordChar = '*'
          TabOrder = 1
        end
        object edtYeniSifreTekrar: TEdit
          Left = 140
          Top = 160
          Width = 200
          Height = 23
          PasswordChar = '*'
          TabOrder = 2
        end
        object btnSifreGuncelle: TButton
          Left = 140
          Top = 202
          Width = 140
          Height = 30
          Caption = #350'ifreyi G'#252'ncelle'
          TabOrder = 3
          OnClick = btnSifreGuncelleClick
        end
      end
    end
    object tsAciklamalar: TTabSheet
      Caption = 'A'#231#305'klamalar'
      ImageIndex = 2
      object lblIslemTuru: TLabel
        Left = 16
        Top = 14
        Width = 62
        Height = 15
        Caption = #304#351'lem T'#252'r'#252' :'
      end
      object lblYeniAciklama: TLabel
        Left = 16
        Top = 330
        Width = 80
        Height = 15
        Caption = 'Yeni A'#231#305'klama :'
      end
      object cmbIslemTuru: TComboBox
        Left = 90
        Top = 10
        Width = 220
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Bor'#231' Dekontu'
        OnChange = cmbIslemTuruChange
        Items.Strings = (
          'Bor'#231' Dekontu'
          'Alacak Dekontu'
          'Tahsilat Dekontu'
          #214'deme Dekontu'
          'Devir'
          'T'#252'm A'#231#305'klamalar')
      end
      object lbAciklamalar: TListBox
        Left = 16
        Top = 42
        Width = 490
        Height = 276
        ItemHeight = 15
        TabOrder = 1
      end
      object edtYeniAciklama: TEdit
        Left = 108
        Top = 326
        Width = 296
        Height = 23
        TabOrder = 2
      end
      object btnAciklamaEkle: TButton
        Left = 412
        Top = 325
        Width = 94
        Height = 25
        Caption = 'Ekle'
        TabOrder = 3
        OnClick = btnAciklamaEkleClick
      end
      object btnSecileniSil: TButton
        Left = 16
        Top = 360
        Width = 110
        Height = 28
        Caption = 'Se'#231'ileni Sil'
        TabOrder = 4
        OnClick = btnSecileniSilClick
      end
      object btnTumunuSil: TButton
        Left = 136
        Top = 360
        Width = 110
        Height = 28
        Caption = 'T'#252'm'#252'n'#252' Sil'
        TabOrder = 5
        OnClick = btnTumunuSilClick
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 482
    Width = 530
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object btnKaydet: TButton
      Left = 326
      Top = 10
      Width = 94
      Height = 28
      Caption = 'Kaydet'
      Default = True
      TabOrder = 0
      OnClick = btnKaydetClick
    end
    object btnKapat: TButton
      Left = 426
      Top = 10
      Width = 94
      Height = 28
      Cancel = True
      Caption = 'Kapat'
      TabOrder = 1
      OnClick = btnKapatClick
    end
  end
end
