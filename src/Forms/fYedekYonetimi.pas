unit fYedekYonetimi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, FileCtrl,
  fBase, uGelesiyeConsts, uGelesiyeTheme, uGelesiyeInterfaces, uDbFactory,
  uBackupService, fDialog;

type
  TfrmYedekYonetimi = class(TfrmBase)
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    pnlTop: TPanel;
    lblKonumLabel: TLabel;
    edtKonum: TEdit;
    btnKonumDegistir: TButton;
    btnKlasoruAc: TButton;
    lblIstatistik: TLabel;
    pnlBottom: TPanel;
    btnSimdiYedekAl: TButton;
    btnGeriYukle: TButton;
    btnSil: TButton;
    btnKapat: TButton;
    lvYedekler: TListView;
    btnYedekAyarlari: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnKlasoruAcClick(Sender: TObject);
    procedure btnKonumDegistirClick(Sender: TObject);
    procedure btnSimdiYedekAlClick(Sender: TObject);
    procedure btnGeriYukleClick(Sender: TObject);
    procedure btnSilClick(Sender: TObject);
    procedure btnYedekAyarlariClick(Sender: TObject);
    procedure lvYedeklerDblClick(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure ApplyTheme; override;
  private
    procedure ListeyiYukle;
    function GetSeciliYol: string;
  public
    class procedure Execute(AOwner: TComponent = nil);
  end;

implementation

uses
  fAyarlar;

{$R *.dfm}

class procedure TfrmYedekYonetimi.Execute(AOwner: TComponent);
var
  F: TfrmYedekYonetimi;
begin
  F := TfrmYedekYonetimi.Create(AOwner);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TfrmYedekYonetimi.FormCreate(Sender: TObject);
begin
  inherited;
  ApplyTheme;
end;

procedure TfrmYedekYonetimi.FormShow(Sender: TObject);
begin
  inherited;
  edtKonum.Text := TBackupService.GetBackupFolder;
  ListeyiYukle;
end;

procedure TfrmYedekYonetimi.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;

  if Assigned(pnlTitleBar) then
  begin
    pnlTitleBar.Color := Theme.HeaderModal;
    pnlTitleBar.BevelEdges := [beBottom];
    pnlTitleBar.BevelKind := bkFlat;
  end;
  if Assigned(lblTitleCaption) then
    lblTitleCaption.Font.Color := Theme.HeaderModalText;
  if Assigned(btnClose) then
    btnClose.Font.Color := clWhite;

  if Assigned(pnlTop) then
    pnlTop.Color := Theme.CardBg;

  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
end;

function TfrmYedekYonetimi.GetSeciliYol: string;
begin
  Result := '';
  if (lvYedekler.Selected <> nil) and (lvYedekler.Selected.SubItems.Count >= 3) then
    Result := lvYedekler.Selected.SubItems[2];
end;

procedure TfrmYedekYonetimi.ListeyiYukle;
var
  List: TList<TYedekDosyaBilgisi>;
  Info: TYedekDosyaBilgisi;
  Item: TListItem;
  TotalBytes: Int64;
  LastBackup: TDateTime;
  LastStr: string;
begin
  lvYedekler.Items.BeginUpdate;
  try
    lvYedekler.Items.Clear;
    TotalBytes := 0;
    List := TBackupService.GetBackupList;
    try
      for Info in List do
      begin
        TotalBytes := TotalBytes + Info.BoyutBytes;
        Item := lvYedekler.Items.Add;
        Item.Caption := Info.DosyaAdi;
        if Info.Tarih > 0 then
          Item.SubItems.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss', Info.Tarih))
        else
          Item.SubItems.Add('-');
        Item.SubItems.Add(Info.BoyutStr);
        Item.SubItems.Add(Info.TamYol);
      end;

      LastBackup := TBackupService.GetLastBackupDate;
      if LastBackup > 0 then
        LastStr := FormatDateTime('dd.mm.yyyy hh:nn', LastBackup)
      else
        LastStr := 'Henüz Alınmadı';

      lblIstatistik.Caption := Format('Toplam %d yedek dosyası | Kaplanan Alan: %s | Son Yedek: %s',
        [List.Count, TBackupService.FormatFileSize(TotalBytes), LastStr]);
    finally
      List.Free;
    end;
  finally
    lvYedekler.Items.EndUpdate;
  end;
end;

procedure TfrmYedekYonetimi.btnSimdiYedekAlClick(Sender: TObject);
var
  BPath, Err: string;
begin
  if TBackupService.BackupDatabase(BPath, Err) then
  begin
    ShowAppInfo('Yeni veritabanı yedeği başarıyla alındı.' + sLineBreak +
      'Dosya: ' + ExtractFileName(BPath), 'Yedek Alındı');
    ListeyiYukle;
  end
  else
    ShowAppError('Yedek alma işlemi başarısız oldu: ' + Err, 'Hata');
end;

procedure TfrmYedekYonetimi.btnGeriYukleClick(Sender: TObject);
var
  FilePath, Err: string;
begin
  FilePath := GetSeciliYol;
  if (FilePath = '') or not FileExists(FilePath) then
  begin
    ShowAppWarning('Lütfen listeden geri yüklenecek bir yedek dosyası seçiniz.', 'Seçim Yapılmadı');
    Exit;
  end;

  if not ShowAppConfirm(
    'Seçili yedek ("' + ExtractFileName(FilePath) + '") geri yüklenecek.' + sLineBreak +
    'Mevcut veritabanının üzerine yazılacaktır.' + sLineBreak + sLineBreak +
    'Devam etmek istiyor musunuz?', 'Yedek Geri Yükleme Onayı') then
    Exit;

  if TBackupService.RestoreDatabase(FilePath, Err) then
  begin
    ShowAppInfo('Veritabanı başarıyla geri yüklendi!' + sLineBreak +
      'Güvenlik amacıyla işlemden hemen önceki haliniz de yedeklenmiştir.',
      'Geri Yükleme Başarılı');
    ListeyiYukle;
  end
  else
    ShowAppError('Geri yükleme başarısız oldu: ' + Err, 'Geri Yükleme Hatası');
end;

procedure TfrmYedekYonetimi.btnSilClick(Sender: TObject);
var
  FilePath, Err: string;
begin
  FilePath := GetSeciliYol;
  if (FilePath = '') or not FileExists(FilePath) then
  begin
    ShowAppWarning('Lütfen silmek istediğiniz yedek dosyasını seçiniz.', 'Seçim Yapılmadı');
    Exit;
  end;

  if not ShowAppConfirm(
    'Bu yedek dosyası kalıcı olarak silinecek:' + sLineBreak +
    ExtractFileName(FilePath) + sLineBreak + sLineBreak +
    'Emin misiniz?', 'Yedek Silme Onayı') then
    Exit;

  if TBackupService.DeleteBackup(FilePath, Err) then
  begin
    ListeyiYukle;
  end
  else
    ShowAppError('Dosya silinemedi: ' + Err, 'Hata');
end;

procedure TfrmYedekYonetimi.btnKonumDegistirClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := edtKonum.Text;
  if SelectDirectory('Yedekleme Klasörünü Seçiniz', '', SelectedDir, [sdNewUI, sdNewFolder]) then
  begin
    TBackupService.SetBackupFolder(SelectedDir);
    edtKonum.Text := TBackupService.GetBackupFolder;
    ListeyiYukle;
  end;
end;

procedure TfrmYedekYonetimi.btnKlasoruAcClick(Sender: TObject);
begin
  TBackupService.OpenBackupFolderInExplorer;
end;

procedure TfrmYedekYonetimi.btnYedekAyarlariClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(1); // 1: Genel/Yedekleme sekmesi
  edtKonum.Text := TBackupService.GetBackupFolder;
  ListeyiYukle;
end;

procedure TfrmYedekYonetimi.lvYedeklerDblClick(Sender: TObject);
begin
  if lvYedekler.Selected <> nil then
    btnGeriYukleClick(Sender);
end;

procedure TfrmYedekYonetimi.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmYedekYonetimi.pnlTitleBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

end.
