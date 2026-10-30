unit fAyarlar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, FileCtrl,
  fBase, uGelesiyeConsts, uGelesiyeTheme, uGelesiyeInterfaces, uDbFactory,
  uAyarlarViewModel, uFirmaViewModel, uBackupService, fYedekYonetimi, fDialog;

type
  TfrmAyarlar = class(TfrmBase)
    pcAyarlar: TPageControl;
    tsFirma: TTabSheet;
    grpFirma: TGroupBox;
    lblFirmaUnvan: TLabel;
    edtFirmaUnvan: TEdit;
    lblFirmaTelefon: TLabel;
    edtFirmaTelefon: TEdit;
    edtFirmaFaks: TEdit;
    lblFirmaIlIlce: TLabel;
    cmbFirmaIl: TComboBox;
    cmbFirmaIlce: TComboBox;
    lblFirmaVergi: TLabel;
    edtFirmaVergiDairesi: TEdit;
    edtFirmaVergiNo: TEdit;
    lblFirmaAdres: TLabel;
    edtFirmaAdres: TEdit;
    tsGenel: TTabSheet;
    tsYedekleme: TTabSheet;
    tsSifre: TTabSheet;
    tsAciklamalar: TTabSheet;
    pnlBottom: TPanel;
    btnKaydet: TButton;
    btnKapat: TButton;
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    grpGenel: TGroupBox;
    lblParaBirimi: TLabel;
    cmbParaBirimi: TComboBox;
    lblKapatmaEylemi: TLabel;
    cmbKapatmaEylemi: TComboBox;
    chkZebraGrid: TCheckBox;
    chkSifreKorumasi: TCheckBox;
    grpYedekleme: TGroupBox;
    lblYedekKlasoru: TLabel;
    edtYedekKlasoru: TEdit;
    btnYedekKlasoruSec: TButton;
    btnYedekKlasoruVarsayilan: TButton;
    lblOtoYedek: TLabel;
    cmbOtoYedek: TComboBox;
    lblMaksYedek: TLabel;
    cmbMaksYedek: TComboBox;
    lblSonYedekBilgi: TLabel;
    btnYedekYonetimiAc: TButton;
    grpSifre: TGroupBox;
    lblSifreBilgi: TLabel;
    lblEskiSifre: TLabel;
    edtEskiSifre: TEdit;
    lblYeniSifre: TLabel;
    edtYeniSifre: TEdit;
    lblYeniSifreTekrar: TLabel;
    edtYeniSifreTekrar: TEdit;
    btnSifreGuncelle: TButton;
    lblIslemTuru: TLabel;
    cmbIslemTuru: TComboBox;
    lbAciklamalar: TListBox;
    lblYeniAciklama: TLabel;
    edtYeniAciklama: TEdit;
    btnAciklamaEkle: TButton;
    btnSecileniSil: TButton;
    btnTumunuSil: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbFirmaIlChange(Sender: TObject);
    procedure cmbIslemTuruChange(Sender: TObject);
    procedure btnAciklamaEkleClick(Sender: TObject);
    procedure btnSecileniSilClick(Sender: TObject);
    procedure btnTumunuSilClick(Sender: TObject);
    procedure btnSifreGuncelleClick(Sender: TObject);
    procedure btnYedekKlasoruSecClick(Sender: TObject);
    procedure btnYedekKlasoruVarsayilanClick(Sender: TObject);
    procedure btnYedekYonetimiAcClick(Sender: TObject);
    procedure btnKaydetClick(Sender: TObject);
    procedure btnKapatClick(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure ApplyTheme; override;
  private
    FAyarlarVM: TAyarlarViewModel;
    FFirmaVM: TFirmaViewModel;
    procedure AciklamalariYukle;
    function GetSeciliIslemTuru: Integer;
  public
    class procedure Execute(const ATabIdx: Integer = 0);
  end;

var
  frmAyarlar: TfrmAyarlar;

implementation

{$R *.dfm}

class procedure TfrmAyarlar.Execute(const ATabIdx: Integer);
var
  F: TfrmAyarlar;
begin
  F := TfrmAyarlar.Create(Application);
  try
    if (ATabIdx >= 0) and (ATabIdx < F.pcAyarlar.PageCount) then
      F.pcAyarlar.ActivePageIndex := ATabIdx;
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TfrmAyarlar.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;
  if Assigned(pnlTitleBar) then
  begin
    pnlTitleBar.Color := Theme.HeaderModal;
    pnlTitleBar.BevelEdges := [beBottom];
    pnlTitleBar.BevelKind := bkFlat;
    pnlTitleBar.BevelOuter := bvNone;
  end;
  if Assigned(lblTitleCaption) then
    lblTitleCaption.Font.Color := Theme.HeaderModalText;
  if Assigned(btnClose) then
  begin
    btnClose.Caption := '✕';
    btnClose.Font.Color := clWhite;
  end;
  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
end;

procedure TfrmAyarlar.FormCreate(Sender: TObject);
begin
  inherited;
  ApplyTheme;
  FAyarlarVM := TAyarlarViewModel.Create(TDbFactory.GetAyarlarRepository);
  FFirmaVM := TFirmaViewModel.Create(TDbFactory.GetFirmaRepository);
end;

procedure TfrmAyarlar.FormDestroy(Sender: TObject);
begin
  FAyarlarVM.Free;
  FFirmaVM.Free;
  inherited;
end;

procedure TfrmAyarlar.FormShow(Sender: TObject);
  var
    F: IFirma;
    IlRepo: IIlIlceRepository;
    Iller: TList<string>;
    S: string;
begin
  inherited;
  FAyarlarVM.Load;

  // Firma Bilgileri
  F := FFirmaVM.AktifFirma;
  if F <> nil then
  begin
    edtFirmaUnvan.Text := F.Unvan;
    edtFirmaTelefon.Text := F.Telefon;
    edtFirmaFaks.Text := F.Faks;
    edtFirmaVergiDairesi.Text := F.VergiDairesi;
    edtFirmaVergiNo.Text := F.VergiNo;
    edtFirmaAdres.Text := F.Adres;

    // İl/İlçe Listesini Doldur
    IlRepo := TDbFactory.GetIlIlceRepository;
    Iller := IlRepo.GetIller;
    try
      cmbFirmaIl.Items.BeginUpdate;
      try
        cmbFirmaIl.Items.Clear;
        for S in Iller do
          cmbFirmaIl.Items.Add(S);
      finally
        cmbFirmaIl.Items.EndUpdate;
      end;
    finally
      Iller.Free;
    end;

    cmbFirmaIl.ItemIndex := cmbFirmaIl.Items.IndexOf(F.Il);
    cmbFirmaIlChange(nil);
    if cmbFirmaIlce.Items.Count > 0 then
      cmbFirmaIlce.ItemIndex := cmbFirmaIlce.Items.IndexOf(F.Ilce);
  end;

  // Genel Ayarlar
  cmbParaBirimi.ItemIndex := cmbParaBirimi.Items.IndexOf(FAyarlarVM.ParaBirimi);
  if cmbParaBirimi.ItemIndex = -1 then
    cmbParaBirimi.ItemIndex := 0;

  if (FAyarlarVM.KapatmaEylemi >= 0) and (FAyarlarVM.KapatmaEylemi < cmbKapatmaEylemi.Items.Count) then
    cmbKapatmaEylemi.ItemIndex := FAyarlarVM.KapatmaEylemi
  else
    cmbKapatmaEylemi.ItemIndex := 0;

  chkZebraGrid.Checked := FAyarlarVM.ZebraGrid;
  chkSifreKorumasi.Checked := FAyarlarVM.SifreKorumasi;

  // Yedekleme Ayarları
  edtYedekKlasoru.Text := TBackupService.GetBackupFolder;
  if (FAyarlarVM.OtoYedekleme >= 0) and (FAyarlarVM.OtoYedekleme < cmbOtoYedek.Items.Count) then
    cmbOtoYedek.ItemIndex := FAyarlarVM.OtoYedekleme
  else
    cmbOtoYedek.ItemIndex := 1;

  case FAyarlarVM.MaksYedekSayisi of
    5: cmbMaksYedek.ItemIndex := 0;
    10: cmbMaksYedek.ItemIndex := 1;
    20: cmbMaksYedek.ItemIndex := 2;
    50: cmbMaksYedek.ItemIndex := 3;
    0: cmbMaksYedek.ItemIndex := 4;
  else
    cmbMaksYedek.ItemIndex := 1;
  end;

  var LLastDate := TBackupService.GetLastBackupDate;
  if LLastDate > 0 then
    lblSonYedekBilgi.Caption := 'Son Yedekleme: ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', LLastDate)
  else
    lblSonYedekBilgi.Caption := 'Son Yedekleme: Henüz Alınmadı';

  // Açıklamalar
  AciklamalariYukle;
end;

procedure TfrmAyarlar.cmbFirmaIlChange(Sender: TObject);
var
  IlRepo: IIlIlceRepository;
  Ilceler: TList<string>;
  S: string;
begin
  cmbFirmaIlce.Items.Clear;
  if cmbFirmaIl.ItemIndex < 0 then Exit;

  IlRepo := TDbFactory.GetIlIlceRepository;
  Ilceler := IlRepo.GetIlceler(cmbFirmaIl.Text);
  try
    cmbFirmaIlce.Items.BeginUpdate;
    try
      for S in Ilceler do
        cmbFirmaIlce.Items.Add(S);
    finally
      cmbFirmaIlce.Items.EndUpdate;
    end;
  finally
    Ilceler.Free;
  end;
end;

function TfrmAyarlar.GetSeciliIslemTuru: Integer;
begin
  case cmbIslemTuru.ItemIndex of
    0: Result := 1; // Borç
    1: Result := 2; // Alacak
    2: Result := 3; // Tahsilat
    3: Result := 4; // Ödeme
    4: Result := 5; // Devir
  else
    Result := 0;    // Tümü
  end;
end;

procedure TfrmAyarlar.AciklamalariYukle;
var
  List: TList<string>;
  S: string;
begin
  lbAciklamalar.Items.BeginUpdate;
  try
    lbAciklamalar.Clear;
    List := FAyarlarVM.GetAciklamalar(GetSeciliIslemTuru);
    try
      for S in List do
        lbAciklamalar.Items.Add(S);
    finally
      List.Free;
    end;
  finally
    lbAciklamalar.Items.EndUpdate;
  end;
end;

procedure TfrmAyarlar.cmbIslemTuruChange(Sender: TObject);
begin
  AciklamalariYukle;
end;

procedure TfrmAyarlar.btnAciklamaEkleClick(Sender: TObject);
var
  Yeni: string;
begin
  Yeni := Trim(edtYeniAciklama.Text);
  if Yeni = '' then Exit;

  FAyarlarVM.AddAciklama(GetSeciliIslemTuru, Yeni);
  edtYeniAciklama.Text := '';
  AciklamalariYukle;
end;

procedure TfrmAyarlar.btnSecileniSilClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := lbAciklamalar.ItemIndex;
  if Idx < 0 then Exit;

  FAyarlarVM.DeleteAciklama(GetSeciliIslemTuru, lbAciklamalar.Items[Idx]);
  AciklamalariYukle;
end;

procedure TfrmAyarlar.btnTumunuSilClick(Sender: TObject);
begin
  if lbAciklamalar.Count = 0 then Exit;

  if ShowAppConfirm('Bu kategorideki tüm açıklamalar silinecek. Emin misiniz?',
    'Açıklamaları Sil') then
  begin
    FAyarlarVM.ClearAciklamalar(GetSeciliIslemTuru);
    AciklamalariYukle;
  end;
end;

procedure TfrmAyarlar.btnSifreGuncelleClick(Sender: TObject);
var
  Err: string;
begin
  if not FAyarlarVM.ChangePassword(edtEskiSifre.Text, edtYeniSifre.Text,
    edtYeniSifreTekrar.Text, Err) then
  begin
    ShowAppWarning(Err, 'Şifre Güncelleme');
    Exit;
  end;

  ShowAppInfo('Program şifreniz başarıyla güncellendi.', 'Şifre Güncellendi');
  edtEskiSifre.Text := '';
  edtYeniSifre.Text := '';
  edtYeniSifreTekrar.Text := '';
end;

procedure TfrmAyarlar.btnYedekKlasoruSecClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := edtYedekKlasoru.Text;
  if SelectDirectory('Yedekleme Klasörünü Seçiniz', '', SelectedDir, [sdNewUI, sdNewFolder]) then
    edtYedekKlasoru.Text := SelectedDir;
end;

procedure TfrmAyarlar.btnYedekKlasoruVarsayilanClick(Sender: TObject);
begin
  edtYedekKlasoru.Text := TBackupService.GetDefaultBackupFolder;
end;

procedure TfrmAyarlar.btnYedekYonetimiAcClick(Sender: TObject);
begin
  TfrmYedekYonetimi.Execute(Self);
  edtYedekKlasoru.Text := TBackupService.GetBackupFolder;
  var LLastDate := TBackupService.GetLastBackupDate;
  if LLastDate > 0 then
    lblSonYedekBilgi.Caption := 'Son Yedekleme: ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', LLastDate)
  else
    lblSonYedekBilgi.Caption := 'Son Yedekleme: Henüz Alınmadı';
end;

procedure TfrmAyarlar.btnKaydetClick(Sender: TObject);
var
  F: IFirma;
begin
  // Firma bilgilerini kaydet
  F := FFirmaVM.AktifFirma;
  if F <> nil then
  begin
    F.Unvan := Trim(edtFirmaUnvan.Text);
    F.Telefon := Trim(edtFirmaTelefon.Text);
    F.Faks := Trim(edtFirmaFaks.Text);
    F.Il := Trim(cmbFirmaIl.Text);
    F.Ilce := Trim(cmbFirmaIlce.Text);
    F.VergiDairesi := Trim(edtFirmaVergiDairesi.Text);
    F.VergiNo := Trim(edtFirmaVergiNo.Text);
    F.Adres := Trim(edtFirmaAdres.Text);
    FFirmaVM.FirmaKaydet(F, False);
  end;

  // Genel ayarları kaydet
  FAyarlarVM.ParaBirimi := cmbParaBirimi.Text;
  FAyarlarVM.KapatmaEylemi := cmbKapatmaEylemi.ItemIndex;
  FAyarlarVM.ZebraGrid := chkZebraGrid.Checked;
  FAyarlarVM.SifreKorumasi := chkSifreKorumasi.Checked;

  // Yedekleme ayarlarını kaydet
  FAyarlarVM.OtoYedekleme := cmbOtoYedek.ItemIndex;
  FAyarlarVM.YedekKlasoru := Trim(edtYedekKlasoru.Text);
  case cmbMaksYedek.ItemIndex of
    0: FAyarlarVM.MaksYedekSayisi := 5;
    1: FAyarlarVM.MaksYedekSayisi := 10;
    2: FAyarlarVM.MaksYedekSayisi := 20;
    3: FAyarlarVM.MaksYedekSayisi := 50;
    4: FAyarlarVM.MaksYedekSayisi := 0;
  else
    FAyarlarVM.MaksYedekSayisi := 10;
  end;
  TBackupService.SetBackupFolder(FAyarlarVM.YedekKlasoru);

  FAyarlarVM.Save;
  ModalResult := mrOk;
end;

procedure TfrmAyarlar.btnKapatClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmAyarlar.pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

end.
