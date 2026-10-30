inherited frmYedekYonetimi: TfrmYedekYonetimi
  BorderStyle = bsNone
  Caption = 'Yedek Y'#246'netim Merkezi'
  ClientHeight = 520
  ClientWidth = 720
  PopupMode = pmAuto
  Color = clWhite
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      720
      44)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 11
      Width = 168
      Height = 20
      Caption = 'Yedek Y'#246'netim Merkezi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 684
      Top = 8
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
      OnClick = btnCloseClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 44
    Width = 720
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      720
      76)
    object lblKonumLabel: TLabel
      Left = 16
      Top = 14
      Width = 104
      Height = 15
      Caption = 'Yedekleme Klas'#246'r'#252' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2236962
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIstatistik: TLabel
      Left = 16
      Top = 48
      Width = 350
      Height = 15
      Caption = 'Yedek istatistikleri y'#252'kleniyor...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7105644
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtKonum: TEdit
      Left = 126
      Top = 10
      Width = 430
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
    object btnKonumDegistir: TButton
      Left = 562
      Top = 9
      Width = 76
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'De'#287'i'#351'tir...'
      TabOrder = 1
      OnClick = btnKonumDegistirClick
    end
    object btnKlasoruAc: TButton
      Left = 642
      Top = 9
      Width = 64
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Klas'#246'r'#252' A'#231
      TabOrder = 2
      OnClick = btnKlasoruAcClick
    end
  end
  object lvYedekler: TListView
    Left = 0
    Top = 120
    Width = 720
    Height = 348
    Align = alClient
    Columns = <
      item
        Caption = 'Yedek Dosyas'#305
        Width = 260
      end
      item
        Caption = 'Yedek Tarihi'
        Width = 160
      end
      item
        Caption = 'Dosya Boyutu'
        Width = 100
      end
      item
        Caption = 'Tam Yol'
        Width = 190
      end>
    GridLines = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = lvYedeklerDblClick
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 468
    Width = 720
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      720
      52)
    object btnSimdiYedekAl: TButton
      Left = 16
      Top = 10
      Width = 136
      Height = 32
      Caption = #128190' '#350'imdi Yedek Al'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSimdiYedekAlClick
    end
    object btnGeriYukle: TButton
      Left = 158
      Top = 10
      Width = 146
      Height = 32
      Caption = #8635' Se'#231'ileni Geri Y'#252'kle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnGeriYukleClick
    end
    object btnSil: TButton
      Left = 310
      Top = 10
      Width = 100
      Height = 32
      Caption = #128465' Se'#231'ileni Sil'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnSilClick
    end
    object btnYedekAyarlari: TButton
      Left = 416
      Top = 10
      Width = 130
      Height = 32
      Caption = #9881' Yedek Ayarlar'#305'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnYedekAyarlariClick
    end
    object btnKapat: TButton
      Left = 626
      Top = 10
      Width = 80
      Height = 32
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Kapat'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnCloseClick
    end
  end
end
