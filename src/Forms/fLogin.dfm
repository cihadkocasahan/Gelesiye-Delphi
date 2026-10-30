inherited frmLogin: TfrmLogin
  Caption = 'Gelesiye - Giri'#351' '#350'ifresi'
  ClientHeight = 220
  ClientWidth = 380
  BorderStyle = bsNone
  Color = 16317180
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlCard: TPanel
    Left = 16
    Top = 14
    Width = 348
    Height = 146
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblBaslik: TLabel
      Left = 16
      Top = 16
      Width = 188
      Height = 17
      Caption = 'Gelesiye G'#252'venlik Do'#287'rulamas'#305
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMesaj: TLabel
      Left = 16
      Top = 44
      Width = 310
      Height = 15
      Caption = 
        'Devam etmek i'#231'in l'#252'tfen giri'#351' '#351'ifrenizi yaz'#305'n'#305'z (Varsay'#305'lan: gel):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblKalanHak: TLabel
      Left = 16
      Top = 114
      Width = 98
      Height = 15
      Caption = 'Kalan Deneme: 3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtSifre: TEdit
      Left = 16
      Top = 72
      Width = 316
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      TextHint = 'Giri'#351' '#351'ifresini giriniz'
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 172
    Width = 380
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object btnGiris: TButton
      Left = 180
      Top = 10
      Width = 90
      Height = 28
      Hint = 'Sisteme Giri'#351' Yap (Enter)'
      Caption = 'Giri'#351
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnGirisClick
    end
    object btnCikis: TButton
      Left = 278
      Top = 10
      Width = 90
      Height = 28
      Cancel = True
      Hint = 'Uygulamay'#305' Kapat (Esc)'
      Caption = #199#305'k'#305#351
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnCikisClick
    end
  end
end
