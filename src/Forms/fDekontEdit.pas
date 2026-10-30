unit fDekontEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  fBase, fBaseEdit, uGelesiyeConsts, uGelesiyeTheme, uGelesiyeTypes, uGelesiyeInterfaces,
  uDbFactory, fDialog, uGelesiyeLang;

type
  TfrmDekontEdit = class(TfrmBaseEdit)
    pnlCard: TPanel;
    lblTarih: TLabel;
    dtpTarih: TDateTimePicker;
    lblSaat: TLabel;
    dtpSaat: TDateTimePicker;
    lblCariHesap: TLabel;
    edtCariHesap: TEdit;
    lblAciklama: TLabel;
    cmbAciklama: TComboBox;
    lblTutar: TLabel;
    edtTutar: TEdit;
  private
    FIslemTuru: TIslemTuru;
    FCariUnvan: string;
    FTutar: Currency;
    FAciklama: string;
    FIslemTarihi: TDateTime;
    FIsEdit: Boolean;
    FHareket: IHareket;
  protected
    procedure ApplyTheme; override;
    function ValidateInput: Boolean; override;
    function SaveData: Boolean; override;
    procedure LoadData; override;
  public
    constructor CreateForDekont(AOwner: TComponent; const ATur: TIslemTuru; const ACariUnvan: string); reintroduce;
    constructor CreateForEdit(AOwner: TComponent; const AHareket: IHareket; const ACariUnvan: string); reintroduce;

    property IslemTuru: TIslemTuru read FIslemTuru;
    property Tutar: Currency read FTutar;
    property Aciklama: string read FAciklama;
    property IslemTarihi: TDateTime read FIslemTarihi;
  end;

var
  frmDekontEdit: TfrmDekontEdit;

implementation

{$R *.dfm}

constructor TfrmDekontEdit.CreateForDekont(AOwner: TComponent; const ATur: TIslemTuru; const ACariUnvan: string);
begin
  inherited Create(AOwner);
  FIslemTuru := ATur;
  FCariUnvan := ACariUnvan;
  FIsEdit := False;
  FHareket := nil;
  ApplyTheme;
  LoadData;
end;

constructor TfrmDekontEdit.CreateForEdit(AOwner: TComponent; const AHareket: IHareket; const ACariUnvan: string);
begin
  inherited Create(AOwner);
  FIslemTuru := AHareket.IslemTuru;
  FCariUnvan := ACariUnvan;
  FIsEdit := True;
  FHareket := AHareket;
  ApplyTheme;
  LoadData;
end;

procedure TfrmDekontEdit.ApplyTheme;
begin
  inherited ApplyTheme;
  if Assigned(pnlCard) then
  begin
    pnlCard.Color := Theme.CardBg;
    pnlCard.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlCard.BevelKind := bkFlat;
    pnlCard.BevelOuter := bvNone;
  end;
  if Assigned(lblTitleCaption) then
    lblTitleCaption.Font.Color := clWhite;
  if Assigned(btnClose) then
    btnClose.Font.Color := clWhite;
end;

procedure TfrmDekontEdit.LoadData;
var
  TurNum: Integer;
  List: TList<string>;
  S: string;
  Prefix: string;
begin
  case FIslemTuru of
    itBorc:
      begin
        Prefix := _T(lkTurBorcDekontu);
        pnlTitleBar.Color := Theme.HeaderDekontBorc;
      end;
    itTahsilat:
      begin
        Prefix := _T(lkTurTahsilat);
        pnlTitleBar.Color := Theme.HeaderDekontTahsil;
      end;
    itAlacak:
      begin
        Prefix := _T(lkTurAlacakDekontu);
        pnlTitleBar.Color := Theme.HeaderDekontAlacak;
      end;
    itOdeme:
      begin
        Prefix := _T(lkTurOdeme);
        pnlTitleBar.Color := Theme.HeaderDekontOdeme;
      end;
    itDevir:
      begin
        Prefix := _T(lkTurDevirFisi);
        pnlTitleBar.Color := Theme.HeaderDekontDevir;
      end;
  end;

  if FIsEdit then
    SetFormTitle(Prefix + ' Düzenle ' + #8212 + ' ' + FCariUnvan)
  else
    SetFormTitle(Prefix + ' ' + #8212 + ' ' + FCariUnvan);

  lblTitleCaption.Font.Color := clWhite;
  btnClose.Font.Color := clWhite;

  cmbAciklama.Items.Clear;
  TurNum := Ord(FIslemTuru);
  List := TDbFactory.GetAyarlarRepository.GetAciklamalar(TurNum);
  try
    for S in List do
      cmbAciklama.Items.Add(S);
  finally
    List.Free;
  end;

  edtCariHesap.Text := FCariUnvan;

  if FIsEdit and (FHareket <> nil) then
  begin
    dtpTarih.Date := Trunc(FHareket.Tarih);
    dtpSaat.Time := Frac(FHareket.Tarih);
    if FHareket.Borc > 0 then
      edtTutar.Text := FormatFloat('#,##0.00', FHareket.Borc)
    else
      edtTutar.Text := FormatFloat('#,##0.00', FHareket.Alacak);
    cmbAciklama.Text := FHareket.Aciklama;
  end
  else
  begin
    dtpTarih.Date := Date;
    dtpSaat.Time := Time;
    edtTutar.Text := '0,00';
    if cmbAciklama.Items.Count > 0 then
      cmbAciklama.ItemIndex := 0;
  end;
end;

function TfrmDekontEdit.ValidateInput: Boolean;
var
  Val: Double;
  CleanStr: string;
begin
  CleanStr := Trim(edtTutar.Text);
  CleanStr := StringReplace(CleanStr, ' TL', '', [rfIgnoreCase]);
  CleanStr := StringReplace(CleanStr, '.', '', [rfReplaceAll]);
  CleanStr := StringReplace(CleanStr, ',', '.', [rfReplaceAll]);

  if not TryStrToFloat(CleanStr, Val, TFormatSettings.Invariant) or (Val <= 0) then
  begin
    ShowAppWarning(MSG_TUTAR_SIFIR_OLAMAZ, 'Geçersiz Tutar');
    edtTutar.SetFocus;
    Exit(False);
  end;

  FTutar := Val;
  FAciklama := Trim(cmbAciklama.Text);
  FIslemTarihi := Trunc(dtpTarih.Date) + Frac(dtpSaat.Time);
  Result := True;
end;

function TfrmDekontEdit.SaveData: Boolean;
begin
  Result := True;
end;

end.