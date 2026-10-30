unit uBackupService;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.DateUtils,
  System.Generics.Collections, System.Generics.Defaults, System.Types,
  Winapi.Windows, Winapi.ShellAPI,
  uGelesiyeConsts, uGelesiyeInterfaces, uDbFactory;

type
  TYedekDosyaBilgisi = record
    DosyaAdi: string;
    TamYol: string;
    Tarih: TDateTime;
    BoyutBytes: Int64;
    BoyutStr: string;
  end;

  TBackupService = class
  private
    class function GetAyarlarRepo: IAyarlarRepository;
  public
    class function GetDatabasePath: string;
    class function GetDefaultBackupFolder: string;
    class function GetBackupFolder: string;
    class procedure SetBackupFolder(const AFolder: string);
    class function FormatFileSize(const ABytes: Int64): string;
    class function GetBackupList: TList<TYedekDosyaBilgisi>;
    class function BackupDatabase(out ABackupPath: string; out AError: string): Boolean;
    class function RestoreDatabase(const ABackupPath: string; out AError: string): Boolean;
    class function DeleteBackup(const ABackupPath: string; out AError: string): Boolean;
    class procedure ApplyRetentionPolicy;
    class procedure CheckAutoBackup(const AIsStartup: Boolean);
    class function GetLastBackupDate: TDateTime;
    class procedure OpenBackupFolderInExplorer;
  end;

implementation

{ TBackupService }

class function TBackupService.GetAyarlarRepo: IAyarlarRepository;
begin
  try
    Result := TDbFactory.GetAyarlarRepository;
  except
    Result := nil;
  end;
end;

class function TBackupService.GetDatabasePath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'data\' + DEF_DB_NAME;
end;

class function TBackupService.GetDefaultBackupFolder: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'backup\';
end;

class function TBackupService.GetBackupFolder: string;
var
  CustomFolder: string;
begin
  CustomFolder := '';
  try
    var Repo := GetAyarlarRepo;
    if Repo <> nil then
      CustomFolder := Trim(Repo.GetAyar('YedekKlasoru', ''));
  except
    CustomFolder := '';
  end;

  if (CustomFolder <> '') and DirectoryExists(CustomFolder) then
  begin
    Result := IncludeTrailingPathDelimiter(CustomFolder);
    Exit;
  end;

  Result := GetDefaultBackupFolder;
end;

class procedure TBackupService.SetBackupFolder(const AFolder: string);
var
  Trimmed: string;
begin
  Trimmed := Trim(AFolder);
  if Trimmed <> '' then
    Trimmed := IncludeTrailingPathDelimiter(Trimmed);

  try
    var Repo := GetAyarlarRepo;
    if Repo <> nil then
      Repo.SetAyar('YedekKlasoru', Trimmed);
  except
  end;
end;

class function TBackupService.FormatFileSize(const ABytes: Int64): string;
begin
  if ABytes < 1024 then
    Result := Format('%d B', [ABytes])
  else if ABytes < 1024 * 1024 then
    Result := Format('%.1f KB', [ABytes / 1024])
  else
    Result := Format('%.2f MB', [ABytes / (1024 * 1024)]);
end;

class function TBackupService.GetBackupList: TList<TYedekDosyaBilgisi>;
var
  Folder: string;
  Files: TStringDynArray;
  FilePath: string;
  Info: TYedekDosyaBilgisi;
  FileAgeDt: TDateTime;
begin
  Result := TList<TYedekDosyaBilgisi>.Create;
  Folder := GetBackupFolder;
  if not DirectoryExists(Folder) then Exit;

  try
    Files := TDirectory.GetFiles(Folder, 'Gelesiye_Yedek_*.db', TSearchOption.soTopDirectoryOnly);
    for FilePath in Files do
    begin
      Info.DosyaAdi := ExtractFileName(FilePath);
      Info.TamYol := FilePath;
      if FileAge(FilePath, FileAgeDt) then
        Info.Tarih := FileAgeDt
      else
        Info.Tarih := 0;

      try
        Info.BoyutBytes := TFile.GetSize(FilePath);
      except
        Info.BoyutBytes := 0;
      end;
      Info.BoyutStr := FormatFileSize(Info.BoyutBytes);
      Result.Add(Info);
    end;

    // En yeniden en eskiye sırala (Tarihe göre azalan)
    Result.Sort(TComparer<TYedekDosyaBilgisi>.Construct(
      function(const Left, Right: TYedekDosyaBilgisi): Integer
      begin
        if Left.Tarih > Right.Tarih then Result := -1
        else if Left.Tarih < Right.Tarih then Result := 1
        else Result := 0;
      end
    ));
  except
  end;
end;

class function TBackupService.DeleteBackup(const ABackupPath: string; out AError: string): Boolean;
begin
  Result := False;
  AError := '';
  if not FileExists(ABackupPath) then
  begin
    AError := 'Silinecek dosya bulunamadı: ' + ABackupPath;
    Exit;
  end;

  try
    TFile.Delete(ABackupPath);
    Result := True;
  except
    on E: Exception do
      AError := 'Yedek silinemedi: ' + E.Message;
  end;
end;

class procedure TBackupService.ApplyRetentionPolicy;
var
  List: TList<TYedekDosyaBilgisi>;
  MaksSayisi: Integer;
  I: Integer;
  Err: string;
begin
  MaksSayisi := 10;
  try
    var Repo := GetAyarlarRepo;
    if Repo <> nil then
      MaksSayisi := StrToIntDef(Repo.GetAyar('MaksYedekSayisi', '10'), 10);
  except
    MaksSayisi := 10;
  end;

  // 0 veya negatif ise sınırsız saklama
  if MaksSayisi <= 0 then Exit;

  List := GetBackupList;
  try
    // Liste en yeniden en eskiye sıralı
    if List.Count > MaksSayisi then
    begin
      for I := MaksSayisi to List.Count - 1 do
      begin
        DeleteBackup(List[I].TamYol, Err);
      end;
    end;
  finally
    List.Free;
  end;
end;

class function TBackupService.GetLastBackupDate: TDateTime;
var
  DateStr: string;
  Fs: TFormatSettings;
begin
  Result := 0;
  try
    var Repo := GetAyarlarRepo;
    if Repo <> nil then
    begin
      DateStr := Repo.GetAyar('SonYedekTarihi', '');
      if DateStr <> '' then
      begin
        Fs := TFormatSettings.Create('tr-TR');
        Result := StrToDateTimeDef(DateStr, 0, Fs);
      end;
    end;
  except
    Result := 0;
  end;
end;

class function TBackupService.BackupDatabase(out ABackupPath: string; out AError: string): Boolean;
var
  SrcDb, DestFolder, TargetFile, Timestamp: string;
  Fs: TFormatSettings;
begin
  Result := False;
  AError := '';
  ABackupPath := '';

  SrcDb := GetDatabasePath;
  if not FileExists(SrcDb) then
  begin
    AError := 'Kaynak veritabanı bulunamadı: ' + SrcDb;
    Exit;
  end;

  DestFolder := GetBackupFolder;
  try
    ForceDirectories(DestFolder);
    Timestamp := FormatDateTime('yyyy-mm-dd_hhnnss', Now);
    TargetFile := DestFolder + 'Gelesiye_Yedek_' + Timestamp + '.db';

    // Dosyayı güvenle kopyala
    TFile.Copy(SrcDb, TargetFile, True);
    ABackupPath := TargetFile;
    Result := True;

    // Son yedekleme zamanını kaydet
    try
      var Repo := GetAyarlarRepo;
      if Repo <> nil then
      begin
        Fs := TFormatSettings.Create('tr-TR');
        Repo.SetAyar('SonYedekTarihi', DateTimeToStr(Now, Fs));
      end;
    except
    end;

    // Fazla yedekleri otomatik temizle
    ApplyRetentionPolicy;
  except
    on E: Exception do
      AError := 'Yedekleme hatası: ' + E.Message;
  end;
end;

class function TBackupService.RestoreDatabase(const ABackupPath: string; out AError: string): Boolean;
var
  TargetDb, SafetyBackup: string;
begin
  Result := False;
  AError := '';

  if not FileExists(ABackupPath) then
  begin
    AError := 'Geri yüklenecek yedek dosyası bulunamadı: ' + ABackupPath;
    Exit;
  end;

  TargetDb := GetDatabasePath;
  SafetyBackup := ChangeFileExt(TargetDb, '_onceki_guvenlik.db');

  try
    // Önce mevcut bağlantıyı kapat
    TDbFactory.Finalize;

    // Geri yükleme öncesi mevcut veritabanını güvenlik için yedekle
    if FileExists(TargetDb) then
    begin
      try
        TFile.Copy(TargetDb, SafetyBackup, True);
      except
      end;
    end;

    // Dosyayı geri yükle
    TFile.Copy(ABackupPath, TargetDb, True);

    // Bağlantıyı yeniden başlat
    TDbFactory.Initialize;
    Result := True;
  except
    on E: Exception do
    begin
      AError := 'Geri yükleme hatası: ' + E.Message;
      // Geri alma dene
      if FileExists(SafetyBackup) then
      begin
        try
          TFile.Copy(SafetyBackup, TargetDb, True);
          TDbFactory.Initialize;
        except
        end;
      end;
    end;
  end;
end;

class procedure TBackupService.CheckAutoBackup(const AIsStartup: Boolean);
var
  OtoVal: Integer;
  BPath, Err: string;
  LastBackup: TDateTime;
begin
  try
    var Repo := GetAyarlarRepo;
    if Repo = nil then Exit;

    OtoVal := StrToIntDef(Repo.GetAyar('OtoYedekleme', '1'), 1);
    // 0: Kapalı / Yalnızca Manuel
    if OtoVal = 0 then Exit;

    case OtoVal of
      1: // Her Program Kapanışında
      begin
        if not AIsStartup then
          BackupDatabase(BPath, Err);
      end;

      2: // Günde 1 Kez (Günün ilk kapanışında / açılışında)
      begin
        LastBackup := GetLastBackupDate;
        if (LastBackup = 0) or (DateOf(LastBackup) <> DateOf(Now)) then
        begin
          if not AIsStartup then
            BackupDatabase(BPath, Err);
        end;
      end;

      3: // Haftada 1 Kez
      begin
        LastBackup := GetLastBackupDate;
        if (LastBackup = 0) or (DaysBetween(Now, LastBackup) >= 7) then
        begin
          if not AIsStartup then
            BackupDatabase(BPath, Err);
        end;
      end;

      4: // Her Program Açılışında
      begin
        if AIsStartup then
          BackupDatabase(BPath, Err);
      end;
    end;
  except
    // Otomatik yedekleme hataları program akışını durdurmaz
  end;
end;

class procedure TBackupService.OpenBackupFolderInExplorer;
var
  Folder: string;
begin
  Folder := GetBackupFolder;
  ForceDirectories(Folder);
  ShellExecute(0, 'open', PChar(Folder), nil, nil, SW_SHOWNORMAL);
end;

end.
