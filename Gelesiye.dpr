program Gelesiye;

uses
  Winapi.Windows, Vcl.Forms,
  uGelesiyeConsts in 'src\Common\uGelesiyeConsts.pas',
  uGelesiyeTypes in 'src\Common\uGelesiyeTypes.pas',
  uGelesiyeVersion in 'src\Common\uGelesiyeVersion.pas',
  uGelesiyeTheme in 'src\Common\uGelesiyeTheme.pas',
  uGelesiyeLang in 'src\Common\uGelesiyeLang.pas',
  uGelesiyeInterfaces in 'src\Domain\uGelesiyeInterfaces.pas',
  uGelesiyeEntities in 'src\Domain\uGelesiyeEntities.pas',
  uDbSQLite in 'src\Data\uDbSQLite.pas',
  uDbIlIlceSeed in 'src\Data\uDbIlIlceSeed.pas',
  uDbDemoSeed in 'src\Data\uDbDemoSeed.pas',
  uDbFirebird in 'src\Data\uDbFirebird.pas',
  uDbFactory in 'src\Data\uDbFactory.pas',
  uBaseViewModel in 'src\ViewModels\uBaseViewModel.pas',
  uCariListViewModel in 'src\ViewModels\uCariListViewModel.pas',
  uCariDetailViewModel in 'src\ViewModels\uCariDetailViewModel.pas',
  uHareketViewModel in 'src\ViewModels\uHareketViewModel.pas',
  uFirmaViewModel in 'src\ViewModels\uFirmaViewModel.pas',
  uAyarlarViewModel in 'src\ViewModels\uAyarlarViewModel.pas',
  fBase in 'src\Forms\fBase.pas' {frmBase},
  fBaseEdit in 'src\Forms\fBaseEdit.pas' {frmBaseEdit},
  fMain in 'src\Forms\fMain.pas' {frmMain},
  fCariEdit in 'src\Forms\fCariEdit.pas' {frmCariEdit},
  fDekontEdit in 'src\Forms\fDekontEdit.pas' {frmDekontEdit},
  fListeToplamlari in 'src\Forms\fListeToplamlari.pas' {frmListeToplamlari},
  fAyarlar in 'src\Forms\fAyarlar.pas' {frmAyarlar},
  fLogin in 'src\Forms\fLogin.pas' {frmLogin},
  fDialog in 'src\Forms\fDialog.pas' {frmDialog},
  fCloseActionDialog in 'src\Forms\fCloseActionDialog.pas' {frmCloseActionDialog},
  fRaporSecimDialog in 'src\Forms\fRaporSecimDialog.pas' {frmRaporSecimDialog},
  fYedekYonetimi in 'src\Forms\fYedekYonetimi.pas' {frmYedekYonetimi},
  fHakkinda in 'src\Forms\fHakkinda.pas' {frmHakkinda},
  fReportPreview in 'src\Forms\fReportPreview.pas' {frmReportPreview},
  uBackupService in 'src\Services\uBackupService.pas',
  uDbDemoSeedService in 'src\Services\uDbDemoSeedService.pas',
  uDovizKuruService in 'src\Services\uDovizKuruService.pas',
  uPrintService in 'src\Services\uPrintService.pas';

{$R *.res}
{$R 'Gelesiye_Version.res'}
{$R 'Gelesiye.manifest.res'}

var
  FMutex: THandle;
  FHwnd: HWND;

begin
  // Tek kopya koruması: aynı anda sadece bir Gelesiye instance'ı çalışabilir
  FMutex := CreateMutex(nil, True, 'GelesiyeCariTakip_SingleInstance_Mutex');
  if (FMutex <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    // Zaten açık olan pencereyi bul ve öne getir
    FHwnd := FindWindow(nil, 'Gelesiye — Basit Veresiye Takip');
    if FHwnd = 0 then
      FHwnd := FindWindowEx(0, 0, 'TfrmMain', nil);
    if FHwnd <> 0 then
    begin
      if IsIconic(FHwnd) then
        ShowWindow(FHwnd, SW_RESTORE);
      SetForegroundWindow(FHwnd);
    end;
    CloseHandle(FMutex);
    Exit;
  end;

  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := 'Gelesiye — Basit Veresiye Takip';

    // MAINICON kaynağından ikonu açıkça yükle (tüm formlara yayılır)
    Application.Icon.LoadFromResourceName(HInstance, 'MAINICON');

    if not TfrmLogin.Execute then
      Exit;

    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    if FMutex <> 0 then
      CloseHandle(FMutex);
  end;
end.
