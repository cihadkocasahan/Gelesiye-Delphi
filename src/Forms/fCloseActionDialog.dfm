object frmCloseActionDialog: TfrmCloseActionDialog
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Gelesiye '#8212' '#199#305'k'#305#351' Tercihi'
  ClientHeight = 236
  ClientWidth = 520
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
    Width = 518
    Height = 42
    Align = alTop
    BevelOuter = bvNone
    Color = 13795088
    ParentBackground = False
    TabOrder = 0
    OnMouseDown = pnlTitleBarMouseDown
    DesignSize = (
      518
      42)
    object lblTitleCaption: TLabel
      Left = 16
      Top = 11
      Width = 200
      Height = 19
      Caption = 'Gelesiye '#8212' '#199#305'k'#305#351' Tercihi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseDown = pnlTitleBarMouseDown
    end
    object btnClose: TButton
      Left = 478
      Top = 5
      Width = 32
      Height = 32
      Anchors = [akTop, akRight]
      Caption = #10005
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelClick
    end
  end
  object pnlCard: TPanel
    Left = 14
    Top = 54
    Width = 492
    Height = 122
    BevelEdges = [beLeft, beTop, beRight, beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object pnlIconBadge: TPanel
      Left = 14
      Top = 14
      Width = 44
      Height = 44
      BevelEdges = [beLeft, beTop, beRight, beBottom]
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = 16184552
      ParentBackground = False
      TabOrder = 1
      object lblIcon: TLabel
        Left = 0
        Top = 0
        Width = 40
        Height = 40
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = #55357#56960
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13795088
        Font.Height = -22
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 44
        ExplicitHeight = 44
      end
    end
    object lblMessage: TLabel
      Left = 70
      Top = 14
      Width = 406
      Height = 36
      AutoSize = False
      Caption = 
        'Program'#305' tamamen kapatmak m'#305', yoksa sistem tepsisine (saatin yan'#305'na' +
        ') k'#252#231#252'ltmek mi istiyorsunuz?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblSubMessage: TLabel
      Left = 70
      Top = 52
      Width = 406
      Height = 28
      AutoSize = False
      Caption = 
        'Sistem tepsisine k'#252#231#252'lt'#252'ld'#252#287#252'nde arkaplanda haz'#305'r bekler ve h'#305'zl'#305'ca a'#231#305'l'#305'r.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7105644
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object chkRemember: TCheckBox
      Left = 70
      Top = 86
      Width = 406
      Height = 22
      Caption = 'Bu se'#231'imimi hat'#305'rla (Bir daha sorma, Ayarlar'#39'dan de'#287'i'#351'tirilebilir)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2236962
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnlBottom: TPanel
    Left = 1
    Top = 183
    Width = 518
    Height = 52
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      518
      50)
    object btnMinimize: TButton
      Left = 104
      Top = 8
      Width = 168
      Height = 34
      Anchors = [akTop, akRight]
      Caption = #9660' Simgeye K'#252#231#252'lt'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnMinimizeClick
    end
    object btnExit: TButton
      Left = 280
      Top = 8
      Width = 146
      Height = 34
      Anchors = [akTop, akRight]
      Caption = #10005' Programdan '#199#305'k'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnExitClick
    end
    object btnCancel: TButton
      Left = 434
      Top = 8
      Width = 74
      Height = 34
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Vazge'#231
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
end
