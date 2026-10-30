inherited frmListeToplamlari: TfrmListeToplamlari
  Caption = 'Liste Toplamlar'#305
  ClientHeight = 395
  ClientWidth = 430
  Position = poOwnerFormCenter
  BorderStyle = bsNone
  TextHeight = 15
  object pnlTitleBar: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      430
      40)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 10
      Width = 107
      Height = 19
      Caption = 'Liste Toplamlar'#305
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 394
      Top = 6
      Width = 28
      Height = 28
      Anchors = [akTop, akRight]
      Caption = #10005
      TabOrder = 0
      OnClick = btnKapatClick
    end
  end
  object pnlCard: TPanel
    Left = 14
    Top = 50
    Width = 402
    Height = 280
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    object lblHeader: TLabel
      Left = 240
      Top = 10
      Width = 145
      Height = 21
      Caption = 'Liste Toplamlar'#305
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAktifBorclu: TLabel
      Left = 16
      Top = 46
      Width = 117
      Height = 15
      Caption = 'Aktif Bor'#231'lu Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAktifAlacakli: TLabel
      Left = 16
      Top = 78
      Width = 125
      Height = 15
      Caption = 'Aktif Alacakl'#305' Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPasifBorclu: TLabel
      Left = 16
      Top = 120
      Width = 117
      Height = 15
      Caption = 'Pasif Bor'#231'lu Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPasifAlacakli: TLabel
      Left = 16
      Top = 152
      Width = 125
      Height = 15
      Caption = 'Pasif Alacakl'#305' Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblGenelBorclu: TLabel
      Left = 16
      Top = 198
      Width = 122
      Height = 15
      Caption = 'Genel Bor'#231'lu Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblGenelAlacakli: TLabel
      Left = 16
      Top = 230
      Width = 130
      Height = 15
      Caption = 'Genel Alacakl'#305' Toplam'#305' ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtAktifBorclu: TEdit
      Left = 180
      Top = 42
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '0,00 TL'
    end
    object edtAktifAlacakli: TEdit
      Left = 180
      Top = 74
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '0,00 TL'
    end
    object edtPasifBorclu: TEdit
      Left = 180
      Top = 116
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '0,00 TL'
    end
    object edtPasifAlacakli: TEdit
      Left = 180
      Top = 148
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '0,00 TL'
    end
    object edtGenelBorclu: TEdit
      Left = 180
      Top = 194
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '0,00 TL'
    end
    object edtGenelAlacakli: TEdit
      Left = 180
      Top = 226
      Width = 200
      Height = 23
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = '0,00 TL'
    end
  end
  object btnKapat: TButton
    Left = 160
    Top = 345
    Width = 110
    Height = 34
    Cancel = True
    Caption = 'Kapat'
    Default = True
    TabOrder = 1
    OnClick = btnKapatClick
  end
end
