inherited frmDekontEdit: TfrmDekontEdit
  Caption = 'Dekont'
  ClientHeight = 300
  ClientWidth = 440
  TextHeight = 15
  inherited pnlTitleBar: TPanel
    Width = 440
    inherited lblTitleCaption: TLabel
      Caption = 'Yeni Dekont'
    end
    inherited btnClose: TButton
      Left = 400
    end
  end
  inherited pnlBottom: TPanel
    Top = 250
    Width = 440
    inherited btnKaydet: TButton
      Left = 324
    end
  end
  object pnlCard: TPanel
    Left = 16
    Top = 56
    Width = 408
    Height = 180
    BevelKind = bkNone
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblTarih: TLabel
      Left = 16
      Top = 18
      Width = 32
      Height = 15
      Caption = 'Tarih :'
    end
    object lblSaat: TLabel
      Left = 216
      Top = 18
      Width = 28
      Height = 15
      Caption = 'Saat :'
    end
    object lblCariHesap: TLabel
      Left = 16
      Top = 54
      Width = 63
      Height = 15
      Caption = 'Cari Hesap :'
    end
    object lblAciklama: TLabel
      Left = 16
      Top = 96
      Width = 54
      Height = 15
      Caption = 'A'#231#305'klama :'
    end
    object lblTutar: TLabel
      Left = 16
      Top = 136
      Width = 33
      Height = 15
      Caption = 'Tutar :'
    end
    object dtpTarih: TDateTimePicker
      Left = 90
      Top = 14
      Width = 110
      Height = 23
      Date = 46278.000000000000000000
      Time = 0.765000000000000000
      TabOrder = 0
    end
    object dtpSaat: TDateTimePicker
      Left = 254
      Top = 14
      Width = 138
      Height = 23
      Date = 46278.000000000000000000
      Time = 0.765000000000000000
      Kind = dtkTime
      TabOrder = 1
    end
    object edtCariHesap: TEdit
      Left = 90
      Top = 50
      Width = 302
      Height = 23
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object cmbAciklama: TComboBox
      Left = 90
      Top = 92
      Width = 302
      Height = 23
      TabOrder = 3
    end
    object edtTutar: TEdit
      Left = 90
      Top = 132
      Width = 302
      Height = 25
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '0,00'
    end
  end
end
