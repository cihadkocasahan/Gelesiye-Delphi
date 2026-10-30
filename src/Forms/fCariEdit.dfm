inherited frmCariEdit: TfrmCariEdit
  Caption = 'Cari Kart'
  ClientHeight = 450
  ClientWidth = 540
  StyleElements = [seClient, seBorder]
  ExplicitWidth = 540
  ExplicitHeight = 450
  TextHeight = 15
  inherited pnlTitleBar: TPanel
    Width = 540
    TabOrder = 2
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 540
    inherited lblTitleCaption: TLabel
      Width = 59
      Caption = 'Cari Kart'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 59
    end
    inherited btnClose: TButton
      Left = 500
      ExplicitLeft = 500
    end
  end
  inherited pnlBottom: TPanel
    Top = 400
    Width = 540
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 400
    ExplicitWidth = 540
    inherited btnKaydet: TButton
      Left = 424
      ExplicitLeft = 424
    end
  end
  object pgcMain: TPageControl
    Left = 12
    Top = 50
    Width = 516
    Height = 342
    ActivePage = tsBilgiler
    TabOrder = 1
    object tsBilgiler: TTabSheet
      Caption = 'Genel Bilgiler'
      object lblCariKodu: TLabel
        Left = 16
        Top = 18
        Width = 58
        Height = 15
        Caption = 'Cari Kodu :'
      end
      object lblKayitTarihi: TLabel
        Left = 270
        Top = 18
        Width = 44
        Height = 15
        Caption = 'Kay'#305't Tarihi :'
      end
      object lblUnvan: TLabel
        Left = 16
        Top = 50
        Width = 43
        Height = 15
        Caption = 'Unvan'#305' :'
      end
      object lblYetkili: TLabel
        Left = 16
        Top = 82
        Width = 37
        Height = 15
        Caption = 'Yetkili :'
      end
      object lblGsm: TLabel
        Left = 270
        Top = 82
        Width = 30
        Height = 15
        Caption = 'Gsm :'
      end
      object lblTelefon: TLabel
        Left = 16
        Top = 114
        Width = 45
        Height = 15
        Caption = 'Telefon :'
      end
      object lblFaks: TLabel
        Left = 270
        Top = 114
        Width = 29
        Height = 15
        Caption = 'Faks :'
      end
      object lblAdres: TLabel
        Left = 16
        Top = 146
        Width = 36
        Height = 15
        Caption = 'Adres :'
      end
      object lblIl: TLabel
        Left = 16
        Top = 178
        Width = 12
        Height = 15
        Caption = #304'l :'
      end
      object lblIlce: TLabel
        Left = 270
        Top = 178
        Width = 24
        Height = 15
        Caption = #304'l'#231'e :'
      end
      object lblVergiDairesi: TLabel
        Left = 16
        Top = 210
        Width = 46
        Height = 15
        Caption = 'V. Daire :'
      end
      object lblVergiNo: TLabel
        Left = 270
        Top = 210
        Width = 35
        Height = 15
        Caption = 'V. No :'
      end
      object lblEposta: TLabel
        Left = 16
        Top = 242
        Width = 46
        Height = 15
        Caption = 'E-Posta :'
      end
      object lblWeb: TLabel
        Left = 270
        Top = 242
        Width = 30
        Height = 15
        Caption = 'Web :'
      end
      object lblCariLimit: TLabel
        Left = 16
        Top = 284
        Width = 57
        Height = 15
        Caption = 'Cari Limit :'
      end
      object lblHesapDurumu: TLabel
        Left = 270
        Top = 284
        Width = 39
        Height = 15
        Caption = 'Hesap :'
      end
      object edtCariKodu: TEdit
        Left = 88
        Top = 14
        Width = 160
        Height = 23
        TabOrder = 0
      end
      object dtpKayitTarihi: TDateTimePicker
        Left = 320
        Top = 14
        Width = 170
        Height = 23
        Date = 46278.000000000000000000
        Time = 0.769999999996798600
        TabOrder = 1
      end
      object edtUnvan: TEdit
        Left = 88
        Top = 46
        Width = 402
        Height = 23
        TabOrder = 2
      end
      object edtYetkili: TEdit
        Left = 88
        Top = 78
        Width = 160
        Height = 23
        TabOrder = 3
      end
      object edtGsm: TEdit
        Left = 320
        Top = 78
        Width = 170
        Height = 23
        TabOrder = 4
      end
      object edtTelefon: TEdit
        Left = 88
        Top = 110
        Width = 160
        Height = 23
        TabOrder = 5
      end
      object edtFaks: TEdit
        Left = 320
        Top = 110
        Width = 170
        Height = 23
        TabOrder = 6
      end
      object edtAdres: TEdit
        Left = 88
        Top = 142
        Width = 402
        Height = 23
        TabOrder = 7
      end
      object cmbIl: TComboBox
        Left = 88
        Top = 174
        Width = 160
        Height = 23
        Style = csDropDownList
        TabOrder = 8
        OnChange = cmbIlChange
      end
      object cmbIlce: TComboBox
        Left = 320
        Top = 174
        Width = 170
        Height = 23
        Style = csDropDownList
        TabOrder = 9
      end
      object edtVergiDairesi: TEdit
        Left = 88
        Top = 206
        Width = 160
        Height = 23
        TabOrder = 10
      end
      object edtVergiNo: TEdit
        Left = 320
        Top = 206
        Width = 170
        Height = 23
        TabOrder = 11
      end
      object edtEposta: TEdit
        Left = 88
        Top = 238
        Width = 160
        Height = 23
        TabOrder = 12
      end
      object edtWeb: TEdit
        Left = 320
        Top = 238
        Width = 170
        Height = 23
        TabOrder = 13
      end
      object edtCariLimit: TEdit
        Left = 88
        Top = 280
        Width = 160
        Height = 23
        TabOrder = 14
        Text = '10.000,00'
      end
      object cmbHesapDurumu: TComboBox
        Left = 320
        Top = 280
        Width = 170
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 15
        Text = 'Aktif'
        Items.Strings = (
          'Aktif'
          'Pasif')
      end
    end
    object tsNot: TTabSheet
      Caption = 'Notlar'
      ImageIndex = 1
      object mmoNotlar: TMemo
        Left = 12
        Top = 12
        Width = 484
        Height = 285
        TabOrder = 0
      end
    end
  end
end
