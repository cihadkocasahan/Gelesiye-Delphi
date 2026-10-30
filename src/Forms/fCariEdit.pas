unit fCariEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  fBase, fBaseEdit, uGelesiyeTypes, uGelesiyeInterfaces, uCariDetailViewModel,
  uDbFactory, fDialog, uGelesiyeLang;

type
  TfrmCariEdit = class(TfrmBaseEdit)
    pgcMain: TPageControl;
    tsBilgiler: TTabSheet;
    tsNot: TTabSheet;
    lblCariKodu: TLabel;
    edtCariKodu: TEdit;
    lblKayitTarihi: TLabel;
    dtpKayitTarihi: TDateTimePicker;
    lblUnvan: TLabel;
    edtUnvan: TEdit;
    lblYetkili: TLabel;
    edtYetkili: TEdit;
    lblGsm: TLabel;
    edtGsm: TEdit;
    lblTelefon: TLabel;
    edtTelefon: TEdit;
    lblFaks: TLabel;
    edtFaks: TEdit;
    lblAdres: TLabel;
    edtAdres: TEdit;
    lblIl: TLabel;
    cmbIl: TComboBox;
    lblIlce: TLabel;
    cmbIlce: TComboBox;
    lblVergiDairesi: TLabel;
    edtVergiDairesi: TEdit;
    lblVergiNo: TLabel;
    edtVergiNo: TEdit;
    lblEposta: TLabel;
    edtEposta: TEdit;
    lblWeb: TLabel;
    edtWeb: TEdit;
    lblCariLimit: TLabel;
    edtCariLimit: TEdit;
    lblHesapDurumu: TLabel;
    cmbHesapDurumu: TComboBox;
    mmoNotlar: TMemo;
    procedure cmbIlChange(Sender: TObject);
  private
    FViewModel: TCariDetailViewModel;
  protected
    function ValidateInput: Boolean; override;
    function SaveData: Boolean; override;
    procedure LoadData; override;
  public
    constructor CreateWithViewModel(AOwner: TComponent; AViewModel: TCariDetailViewModel); reintroduce;
  end;

var
  frmCariEdit: TfrmCariEdit;

implementation

{$R *.dfm}

constructor TfrmCariEdit.CreateWithViewModel(AOwner: TComponent; AViewModel: TCariDetailViewModel);
begin
  inherited Create(AOwner);
  FViewModel := AViewModel;
  LoadData;
end;

procedure TfrmCariEdit.cmbIlChange(Sender: TObject);
var
  IlRepo: IIlIlceRepository;
  Ilceler: TList<string>;
  S: string;
begin
  cmbIlce.Items.Clear;
  if cmbIl.ItemIndex < 0 then Exit;

  IlRepo := TDbFactory.GetIlIlceRepository;
  if IlRepo = nil then Exit;

  Ilceler := IlRepo.GetIlceler(cmbIl.Text);
  try
    cmbIlce.Items.BeginUpdate;
    try
      for S in Ilceler do
        cmbIlce.Items.Add(S);
    finally
      cmbIlce.Items.EndUpdate;
    end;
  finally
    Ilceler.Free;
  end;
end;

procedure TfrmCariEdit.LoadData;
var
  C: ICari;
  IlRepo: IIlIlceRepository;
  Iller: TList<string>;
  S: string;
  Frm: IFirma;
begin
  if FViewModel = nil then Exit;
  C := FViewModel.Cari;
  if C = nil then Exit;

  if FViewModel.IsNew then
    SetFormTitle(_T(lkTitleCariKartEkle))
  else
    SetFormTitle(_T(lkTitleCariKartDuzenle) + ' ' + #8212 + ' ' + C.Unvan);

  edtCariKodu.Text := C.CariKodu;
  dtpKayitTarihi.Date := C.KayitTarihi;
  edtUnvan.Text := C.Unvan;
  edtYetkili.Text := C.Yetkili;
  edtGsm.Text := C.Gsm;
  edtTelefon.Text := C.Telefon;
  edtFaks.Text := C.Faks;
  edtAdres.Text := C.Adres;

  IlRepo := TDbFactory.GetIlIlceRepository;
  if IlRepo <> nil then
  begin
    Iller := IlRepo.GetIller;
    try
      cmbIl.Items.BeginUpdate;
      try
        cmbIl.Items.Clear;
        for S in Iller do
          cmbIl.Items.Add(S);
      finally
        cmbIl.Items.EndUpdate;
      end;
    finally
      Iller.Free;
    end;
  end;

  if FViewModel.IsNew then
  begin
    Frm := TDbFactory.GetFirmaRepository.GetDefault;
    if Frm <> nil then
    begin
      C.Il := Frm.Il;
      C.Ilce := Frm.Ilce;
    end;
  end;

  cmbIl.ItemIndex := cmbIl.Items.IndexOf(C.Il);
  cmbIlChange(nil);
  if cmbIlce.Items.Count > 0 then
    cmbIlce.ItemIndex := cmbIlce.Items.IndexOf(C.Ilce);

  edtVergiDairesi.Text := C.VergiDairesi;
  edtVergiNo.Text := C.VergiNo;
  edtEposta.Text := C.Eposta;
  edtWeb.Text := C.Web;
  edtCariLimit.Text := FormatFloat('#,##0.00', C.CariLimit);

  if C.HesapDurumu = hdPasif then
    cmbHesapDurumu.ItemIndex := 1
  else
    cmbHesapDurumu.ItemIndex := 0;

  mmoNotlar.Text := C.Notlar;
end;

function TfrmCariEdit.ValidateInput: Boolean;
var
  Err: string;
  C: ICari;
  LimitVal: Double;
  LimitStr: string;
begin
  C := FViewModel.Cari;
  C.CariKodu := Trim(edtCariKodu.Text);
  C.Unvan := Trim(edtUnvan.Text);
  C.Yetkili := Trim(edtYetkili.Text);
  C.Gsm := Trim(edtGsm.Text);
  C.Telefon := Trim(edtTelefon.Text);
  C.Faks := Trim(edtFaks.Text);
  C.Adres := Trim(edtAdres.Text);
  C.Il := Trim(cmbIl.Text);
  C.Ilce := Trim(cmbIlce.Text);
  C.VergiDairesi := Trim(edtVergiDairesi.Text);
  C.VergiNo := Trim(edtVergiNo.Text);
  C.Eposta := Trim(edtEposta.Text);
  C.Web := Trim(edtWeb.Text);
  C.KayitTarihi := dtpKayitTarihi.Date;
  C.Notlar := mmoNotlar.Text;

  LimitStr := Trim(edtCariLimit.Text);
  LimitStr := StringReplace(LimitStr, ' TL', '', [rfIgnoreCase]);
  LimitStr := StringReplace(LimitStr, '.', '', [rfReplaceAll]);   // binlik ayırıcı
  LimitStr := StringReplace(LimitStr, ',', '.', [rfReplaceAll]);  // ondalık virgül → nokta
  if TryStrToFloat(LimitStr, LimitVal, TFormatSettings.Invariant) then
    C.CariLimit := LimitVal
  else
    C.CariLimit := 10000.0;

  if cmbHesapDurumu.ItemIndex = 1 then
    C.HesapDurumu := hdPasif
  else
    C.HesapDurumu := hdAktif;

  Result := FViewModel.Validate(Err);
  if not Result then
    ShowAppWarning(Err, 'Geçersiz Bilgi');
end;

function TfrmCariEdit.SaveData: Boolean;
begin
  Result := FViewModel.Kaydet;
end;

end.
