unit uDbSQLite;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.DateUtils, System.Generics.Collections,
  System.JSON, System.IOUtils,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  uGelesiyeConsts, uGelesiyeTypes, uGelesiyeInterfaces, uGelesiyeEntities;

type
  // ===========================================================================
  // TSQLiteConnection: SQLite Bağlantı Yöneticisi (IDbConnection)
  // ===========================================================================
  TSQLiteConnection = class(TInterfacedObject, IDbConnection)
  private
    FConn: TFDConnection;
    FDriverLink: TFDPhysSQLiteDriverLink;
    FWaitCursor: TFDGUIxWaitCursor;
    FDbPath: string;
    procedure EnsureSchema;
  public
    constructor Create(const ADbPath: string = '');
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    function IsConnected: Boolean;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function GetDriverName: string;

    property Connection: TFDConnection read FConn;
  end;

  // ===========================================================================
  // TSQLiteFirmaRepository: Firma ve Dönem İşlemleri
  // ===========================================================================
  TSQLiteFirmaRepository = class(TInterfacedObject, IFirmaRepository)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function GetAll: TList<IFirma>;
    function GetById(const AId: Integer): IFirma;
    function GetDefault: IFirma;
    procedure SetDefault(const AId: Integer);
    function Insert(const AFirma: IFirma): Integer;
    procedure Update(const AFirma: IFirma);
    procedure Delete(const AId: Integer);
    function DevirYap(const AEskiFirmaId, AYeniFirmaId: Integer; const AAktarAciklamalar: Boolean): Boolean;
  end;

  // ===========================================================================
  // TSQLiteCariRepository: Cari Hesap CRUD ve Sorgulama
  // ===========================================================================
  TSQLiteCariRepository = class(TInterfacedObject, ICariRepository)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function GetAll(const AFiltre: TCariFiltre): TList<ICari>;
    function GetById(const AId: Integer): ICari;
    function Insert(const ACari: ICari): Integer;
    procedure Update(const ACari: ICari);
    procedure Delete(const AId: Integer);
    function GetNextCariKodu(const AFirmaId: Integer): string;
    function GetBakiyeOzet(const AFirmaId: Integer): TBakiyeOzet;
  end;

  // ===========================================================================
  // TSQLiteHareketRepository: Fiş/Hareket CRUD ve Ekstre
  // ===========================================================================
  TSQLiteHareketRepository = class(TInterfacedObject, IHareketRepository)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function GetByCariId(const ACariId: Integer): TList<IHareket>;
    function Insert(const AHareket: IHareket): Integer;
    procedure Update(const AHareket: IHareket);
    procedure Delete(const AId: Integer);
    function GetGenelHareketler(const AFirmaId: Integer; const ABasTarih, ABitTarih: TDateTime;
      const ATur: Integer): TList<IHareket>;
  end;

  // ===========================================================================
  // TSQLiteAyarlarRepository: Genel Ayarlar ve Açıklama Şablonları
  // ===========================================================================
  TSQLiteAyarlarRepository = class(TInterfacedObject, IAyarlarRepository)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function GetAyar(const AAnahtar: string; const AVarsayilan: string = ''): string;
    procedure SetAyar(const AAnahtar, ADeger: string);
    function GetAciklamalar(const AIslemTuru: Integer): TList<string>;
    procedure AddAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure DeleteAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure ClearAciklamalar(const AIslemTuru: Integer);
  end;

  // ===========================================================================
  // TSQLiteIlIlceRepository: İl ve İlçe Listeleri
  // ===========================================================================
  TSQLiteIlIlceRepository = class(TInterfacedObject, IIlIlceRepository)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function GetIller: TList<string>;
    function GetIlceler(const AIlAdi: string): TList<string>;
  end;

implementation

uses
  uDbIlIlceSeed;

{ TSQLiteConnection }

constructor TSQLiteConnection.Create(const ADbPath: string);
var
  AppDir: string;
begin
  inherited Create;
  FDriverLink := TFDPhysSQLiteDriverLink.Create(nil);
  FWaitCursor := TFDGUIxWaitCursor.Create(nil);
  FConn := TFDConnection.Create(nil);

  if ADbPath <> '' then
    FDbPath := ADbPath
  else
  begin
    AppDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
    FDbPath := AppDir + 'data\' + DEF_DB_NAME;
  end;

  ForceDirectories(ExtractFilePath(FDbPath));

  FConn.LoginPrompt := False;
  FConn.Params.DriverID := 'SQLite';
  FConn.Params.Database := FDbPath;
  FConn.Params.Add('OpenMode=CreateUTF8');
  FConn.Params.Add('LockingMode=Normal');
  FConn.Params.Add('Synchronous=Normal');

  Connect;
  EnsureSchema;
end;

destructor TSQLiteConnection.Destroy;
begin
  Disconnect;
  FConn.Free;
  FWaitCursor.Free;
  FDriverLink.Free;
  inherited Destroy;
end;

procedure TSQLiteConnection.Connect;
begin
  if not FConn.Connected then
    FConn.Connected := True;
end;

procedure TSQLiteConnection.Disconnect;
begin
  if FConn.Connected then
    FConn.Connected := False;
end;

function TSQLiteConnection.IsConnected: Boolean;
begin
  Result := FConn.Connected;
end;

procedure TSQLiteConnection.StartTransaction;
begin
  if not FConn.InTransaction then
    FConn.StartTransaction;
end;

procedure TSQLiteConnection.Commit;
begin
  if FConn.InTransaction then
    FConn.Commit;
end;

procedure TSQLiteConnection.Rollback;
begin
  if FConn.InTransaction then
    FConn.Rollback;
end;

function TSQLiteConnection.GetDriverName: string;
begin
  Result := 'SQLite';
end;

procedure TSQLiteConnection.EnsureSchema;
begin
  // Tabloları oluştur
  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS FIRMALAR (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  KOD TEXT NOT NULL,' +
    '  UNVAN TEXT NOT NULL,' +
    '  DONEM INTEGER DEFAULT 2026,' +
    '  PARA_BIRIMI TEXT DEFAULT ''TL'',' +
    '  IS_DEFAULT INTEGER DEFAULT 0,' +
    '  BORC_LIMITI REAL DEFAULT 10000.0,' +
    '  TELEFON TEXT,' +
    '  FAKS TEXT,' +
    '  ADRES TEXT,' +
    '  IL TEXT,' +
    '  ILCE TEXT,' +
    '  VERGI_DAIRESI TEXT,' +
    '  VERGI_NO TEXT' +
    ');'
  );

  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS CARILER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  FIRMA_ID INTEGER NOT NULL,' +
    '  CARI_KODU TEXT NOT NULL,' +
    '  UNVAN TEXT NOT NULL,' +
    '  YETKILI TEXT,' +
    '  TELEFON TEXT,' +
    '  GSM TEXT,' +
    '  FAKS TEXT,' +
    '  ADRES TEXT,' +
    '  IL TEXT,' +
    '  ILCE TEXT,' +
    '  VERGI_DAIRESI TEXT,' +
    '  VERGI_NO TEXT,' +
    '  EPOSTA TEXT,' +
    '  WEB TEXT,' +
    '  CARI_LIMIT REAL DEFAULT 10000.0,' +
    '  HESAP_DURUMU INTEGER DEFAULT 1,' + // 1: Aktif, 2: Pasif
    '  NOTLAR TEXT,' +
    '  KAYIT_TARIHI TEXT,' +
    '  IS_DELETED INTEGER DEFAULT 0' +
    ');'
  );

  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS HAREKETLER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  FIRMA_ID INTEGER NOT NULL,' +
    '  CARI_ID INTEGER NOT NULL,' +
    '  TARIH TEXT NOT NULL,' +
    '  ISLEM_TURU INTEGER NOT NULL,' +
    '  ACIKLAMA TEXT,' +
    '  BORC REAL DEFAULT 0,' +
    '  ALACAK REAL DEFAULT 0,' +
    '  IS_DELETED INTEGER DEFAULT 0' +
    ');'
  );

  // İndeksler
  FConn.ExecSQL('CREATE INDEX IF NOT EXISTS IDX_CARILER_FIRMA ON CARILER (FIRMA_ID, IS_DELETED);');
  FConn.ExecSQL('CREATE INDEX IF NOT EXISTS IDX_HAREKETLER_CARI ON HAREKETLER (CARI_ID, IS_DELETED);');

  // Ayarlar Tablosu
  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS AYARLAR (' +
    '  ANAHTAR TEXT PRIMARY KEY,' +
    '  DEGER TEXT' +
    ');'
  );

  // Açıklama Şablonları Tablosu
  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS ACIKLAMALAR (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  ISLEM_TURU INTEGER NOT NULL,' +
    '  ACIKLAMA TEXT NOT NULL' +
    ');'
  );

  FConn.ExecSQL('CREATE INDEX IF NOT EXISTS IDX_ACIKLAMALAR_TUR ON ACIKLAMALAR (ISLEM_TURU);');

  // İller Tablosu
  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS ILLER (' +
    '  ID INTEGER PRIMARY KEY,' +
    '  AD TEXT NOT NULL' +
    ');'
  );

  // İlçeler Tablosu
  FConn.ExecSQL(
    'CREATE TABLE IF NOT EXISTS ILCELER (' +
    '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  IL_ID INTEGER NOT NULL,' +
    '  AD TEXT NOT NULL' +
    ');'
  );

  FConn.ExecSQL('CREATE INDEX IF NOT EXISTS IDX_ILCELER_IL ON ILCELER (IL_ID);');

  // İller ve İlçeler Tohumlaması (Yoksa otomatik yükle)
  if FConn.ExecSQLScalar('SELECT COUNT(*) FROM ILLER') = 0 then
    SeedIlIlce(FConn);

  // Varsayılan Firma Tohumlaması (Yoksa oluştur)
  if FConn.ExecSQLScalar('SELECT COUNT(*) FROM FIRMALAR') = 0 then
  begin
    FConn.ExecSQL(
      'INSERT INTO FIRMALAR (KOD, UNVAN, DONEM, PARA_BIRIMI, IS_DEFAULT, BORC_LIMITI) ' +
      'VALUES (''Frm1'', ''TEST (Varsayılan)'', 2026, ''TL'', 1, 10000.0);'
    );
  end;

  // Varsayılan Açıklamaları Tohumla
  if FConn.ExecSQLScalar('SELECT COUNT(*) FROM ACIKLAMALAR') = 0 then
  begin
    // Borç Dekontu (1)
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (1, ''Mal Alımı'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (1, ''Hizmet Bedeli'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (1, ''Veresiye Satış'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (1, ''Fatura Bedeli'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (1, ''Kırtasiye Alımı'');');

    // Alacak Dekontu (2)
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (2, ''Mal İadesi'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (2, ''İskonto Bedeli'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (2, ''Düzeltme Fişi'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (2, ''Fatura İadesi'');');

    // Tahsilat (3)
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (3, ''Nakit Tahsilat'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (3, ''Kredi Kartı ile Tahsilat'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (3, ''Banka Havalesi / EFT'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (3, ''Çek ile Tahsilat'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (3, ''Senet ile Tahsilat'');');

    // Ödeme (4)
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (4, ''Nakit Ödeme'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (4, ''Banka Havalesi / EFT'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (4, ''Kredi Kartı ile Ödeme'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (4, ''Çek ile Ödeme'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (4, ''Senet ile Ödeme'');');

    // Devir (5)
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (5, ''Devir Bakiyesi'');');
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (5, ''Devir Fişi'');');
  end;

  // Varsayılan E-Posta ve Genel Ayarlar
  if FConn.ExecSQLScalar('SELECT COUNT(*) FROM AYARLAR') = 0 then
  begin
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SmtpHost'', ''smtp.gmail.com'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SmtpPort'', ''587'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SmtpSSL'', ''1'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SenderEmail'', '''');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SenderTitle'', ''Örnek Ticaret'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SmtpUser'', '''');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SmtpPassword'', '''');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''ParaBirimi'', ''TL'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''ZebraGrid'', ''1'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''SifreKorumasi'', ''0'');');
    FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (''GirisSifresi'', '''');');
  end;
end;

{ TSQLiteFirmaRepository }

constructor TSQLiteFirmaRepository.Create(AConn: TFDConnection);
begin
  inherited Create;
  FConn := AConn;
end;

function TSQLiteFirmaRepository.GetAll: TList<IFirma>;
var
  Qry: TFDQuery;
  F: IFirma;
begin
  Result := TList<IFirma>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT * FROM FIRMALAR ORDER BY ID';
    Qry.Open;
    while not Qry.Eof do
    begin
      F := TFirma.Create;
      F.Id := Qry.FieldByName('ID').AsInteger;
      F.Kod := Qry.FieldByName('KOD').AsString;
      F.Unvan := Qry.FieldByName('UNVAN').AsString;
      F.Donem := Qry.FieldByName('DONEM').AsInteger;
      F.ParaBirimi := Qry.FieldByName('PARA_BIRIMI').AsString;
      F.IsDefault := Qry.FieldByName('IS_DEFAULT').AsInteger = 1;
      F.BorcLimiti := Qry.FieldByName('BORC_LIMITI').AsCurrency;
      F.Telefon := Qry.FieldByName('TELEFON').AsString;
      F.Faks := Qry.FieldByName('FAKS').AsString;
      F.Adres := Qry.FieldByName('ADRES').AsString;
      F.Il := Qry.FieldByName('IL').AsString;
      F.Ilce := Qry.FieldByName('ILCE').AsString;
      F.VergiDairesi := Qry.FieldByName('VERGI_DAIRESI').AsString;
      F.VergiNo := Qry.FieldByName('VERGI_NO').AsString;
      Result.Add(F);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteFirmaRepository.GetById(const AId: Integer): IFirma;
var
  Qry: TFDQuery;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT * FROM FIRMALAR WHERE ID = :ID';
    Qry.ParamByName('ID').AsInteger := AId;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TFirma.Create;
      Result.Id := Qry.FieldByName('ID').AsInteger;
      Result.Kod := Qry.FieldByName('KOD').AsString;
      Result.Unvan := Qry.FieldByName('UNVAN').AsString;
      Result.Donem := Qry.FieldByName('DONEM').AsInteger;
      Result.ParaBirimi := Qry.FieldByName('PARA_BIRIMI').AsString;
      Result.IsDefault := Qry.FieldByName('IS_DEFAULT').AsInteger = 1;
      Result.BorcLimiti := Qry.FieldByName('BORC_LIMITI').AsCurrency;
      Result.Telefon := Qry.FieldByName('TELEFON').AsString;
      Result.Faks := Qry.FieldByName('FAKS').AsString;
      Result.Adres := Qry.FieldByName('ADRES').AsString;
      Result.Il := Qry.FieldByName('IL').AsString;
      Result.Ilce := Qry.FieldByName('ILCE').AsString;
      Result.VergiDairesi := Qry.FieldByName('VERGI_DAIRESI').AsString;
      Result.VergiNo := Qry.FieldByName('VERGI_NO').AsString;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteFirmaRepository.GetDefault: IFirma;
var
  Qry: TFDQuery;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT * FROM FIRMALAR ORDER BY IS_DEFAULT DESC, ID ASC LIMIT 1';
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TFirma.Create;
      Result.Id := Qry.FieldByName('ID').AsInteger;
      Result.Kod := Qry.FieldByName('KOD').AsString;
      Result.Unvan := Qry.FieldByName('UNVAN').AsString;
      Result.Donem := Qry.FieldByName('DONEM').AsInteger;
      Result.ParaBirimi := Qry.FieldByName('PARA_BIRIMI').AsString;
      Result.IsDefault := Qry.FieldByName('IS_DEFAULT').AsInteger = 1;
      Result.BorcLimiti := Qry.FieldByName('BORC_LIMITI').AsCurrency;
      Result.Telefon := Qry.FieldByName('TELEFON').AsString;
      Result.Faks := Qry.FieldByName('FAKS').AsString;
      Result.Adres := Qry.FieldByName('ADRES').AsString;
      Result.Il := Qry.FieldByName('IL').AsString;
      Result.Ilce := Qry.FieldByName('ILCE').AsString;
      Result.VergiDairesi := Qry.FieldByName('VERGI_DAIRESI').AsString;
      Result.VergiNo := Qry.FieldByName('VERGI_NO').AsString;
    end;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteFirmaRepository.SetDefault(const AId: Integer);
begin
  FConn.ExecSQL('UPDATE FIRMALAR SET IS_DEFAULT = 0');
  FConn.ExecSQL('UPDATE FIRMALAR SET IS_DEFAULT = 1 WHERE ID = ' + IntToStr(AId));
end;

function TSQLiteFirmaRepository.Insert(const AFirma: IFirma): Integer;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'INSERT INTO FIRMALAR (KOD, UNVAN, DONEM, PARA_BIRIMI, IS_DEFAULT, BORC_LIMITI, TELEFON, FAKS, ADRES, IL, ILCE, VERGI_DAIRESI, VERGI_NO) ' +
      'VALUES (:KOD, :UNVAN, :DONEM, :PARA_BIRIMI, :IS_DEFAULT, :BORC_LIMITI, :TELEFON, :FAKS, :ADRES, :IL, :ILCE, :VERGI_DAIRESI, :VERGI_NO);';
    Qry.ParamByName('KOD').AsString := AFirma.Kod;
    Qry.ParamByName('UNVAN').AsString := AFirma.Unvan;
    Qry.ParamByName('DONEM').AsInteger := AFirma.Donem;
    Qry.ParamByName('PARA_BIRIMI').AsString := AFirma.ParaBirimi;
    Qry.ParamByName('IS_DEFAULT').AsInteger := Ord(AFirma.IsDefault);
    Qry.ParamByName('BORC_LIMITI').AsCurrency := AFirma.BorcLimiti;
    Qry.ParamByName('TELEFON').AsString := AFirma.Telefon;
    Qry.ParamByName('FAKS').AsString := AFirma.Faks;
    Qry.ParamByName('ADRES').AsString := AFirma.Adres;
    Qry.ParamByName('IL').AsString := AFirma.Il;
    Qry.ParamByName('ILCE').AsString := AFirma.Ilce;
    Qry.ParamByName('VERGI_DAIRESI').AsString := AFirma.VergiDairesi;
    Qry.ParamByName('VERGI_NO').AsString := AFirma.VergiNo;
    Qry.ExecSQL;
    Result := FConn.GetLastAutoGenValue('');
    AFirma.Id := Result;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteFirmaRepository.Update(const AFirma: IFirma);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'UPDATE FIRMALAR SET KOD = :KOD, UNVAN = :UNVAN, DONEM = :DONEM, PARA_BIRIMI = :PARA_BIRIMI, ' +
      'IS_DEFAULT = :IS_DEFAULT, BORC_LIMITI = :BORC_LIMITI, TELEFON = :TELEFON, FAKS = :FAKS, ' +
      'ADRES = :ADRES, IL = :IL, ILCE = :ILCE, VERGI_DAIRESI = :VERGI_DAIRESI, VERGI_NO = :VERGI_NO ' +
      'WHERE ID = :ID';
    Qry.ParamByName('ID').AsInteger := AFirma.Id;
    Qry.ParamByName('KOD').AsString := AFirma.Kod;
    Qry.ParamByName('UNVAN').AsString := AFirma.Unvan;
    Qry.ParamByName('DONEM').AsInteger := AFirma.Donem;
    Qry.ParamByName('PARA_BIRIMI').AsString := AFirma.ParaBirimi;
    Qry.ParamByName('IS_DEFAULT').AsInteger := Ord(AFirma.IsDefault);
    Qry.ParamByName('BORC_LIMITI').AsCurrency := AFirma.BorcLimiti;
    Qry.ParamByName('TELEFON').AsString := AFirma.Telefon;
    Qry.ParamByName('FAKS').AsString := AFirma.Faks;
    Qry.ParamByName('ADRES').AsString := AFirma.Adres;
    Qry.ParamByName('IL').AsString := AFirma.Il;
    Qry.ParamByName('ILCE').AsString := AFirma.Ilce;
    Qry.ParamByName('VERGI_DAIRESI').AsString := AFirma.VergiDairesi;
    Qry.ParamByName('VERGI_NO').AsString := AFirma.VergiNo;
    Qry.ExecSQL;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteFirmaRepository.Delete(const AId: Integer);
begin
  FConn.ExecSQL('DELETE FROM HAREKETLER WHERE FIRMA_ID = ' + IntToStr(AId));
  FConn.ExecSQL('DELETE FROM CARILER WHERE FIRMA_ID = ' + IntToStr(AId));
  FConn.ExecSQL('DELETE FROM FIRMALAR WHERE ID = ' + IntToStr(AId));
end;

function TSQLiteFirmaRepository.DevirYap(const AEskiFirmaId, AYeniFirmaId: Integer; const AAktarAciklamalar: Boolean): Boolean;
var
  QryCariler: TFDQuery;
  OldCariId, NewCariId: Integer;
  Bakiye: Currency;
  NowIso: string;
begin
  FConn.StartTransaction;
  QryCariler := TFDQuery.Create(nil);
  try
    NowIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    QryCariler.Connection := FConn;
    QryCariler.SQL.Text := 'SELECT * FROM CARILER WHERE FIRMA_ID = :FID AND IS_DELETED = 0';
    QryCariler.ParamByName('FID').AsInteger := AEskiFirmaId;
    QryCariler.Open;

    while not QryCariler.Eof do
    begin
      OldCariId := QryCariler.FieldByName('ID').AsInteger;

      // Eski carinin kapanış bakiyesini hesapla
      Bakiye := FConn.ExecSQLScalar(
        'SELECT COALESCE(SUM(BORC),0) - COALESCE(SUM(ALACAK),0) FROM HAREKETLER ' +
        'WHERE CARI_ID = ' + IntToStr(OldCariId) + ' AND IS_DELETED = 0'
      );

      // Yeni firmada cariyi aç
      FConn.ExecSQL(
        'INSERT INTO CARILER (FIRMA_ID, CARI_KODU, UNVAN, YETKILI, TELEFON, GSM, FAKS, ADRES, IL, ILCE, VERGI_DAIRESI, VERGI_NO, EPOSTA, WEB, CARI_LIMIT, HESAP_DURUMU, NOTLAR, KAYIT_TARIHI) ' +
        'VALUES (:FID, :KOD, :UNVAN, :YETKILI, :TEL, :GSM, :FAKS, :ADRES, :IL, :ILCE, :VD, :VN, :MAIL, :WEB, :LIMIT, :DURUM, :NOTLAR, :TARIH)',
        [AYeniFirmaId,
         QryCariler.FieldByName('CARI_KODU').AsString,
         QryCariler.FieldByName('UNVAN').AsString,
         QryCariler.FieldByName('YETKILI').AsString,
         QryCariler.FieldByName('TELEFON').AsString,
         QryCariler.FieldByName('GSM').AsString,
         QryCariler.FieldByName('FAKS').AsString,
         QryCariler.FieldByName('ADRES').AsString,
         QryCariler.FieldByName('IL').AsString,
         QryCariler.FieldByName('ILCE').AsString,
         QryCariler.FieldByName('VERGI_DAIRESI').AsString,
         QryCariler.FieldByName('VERGI_NO').AsString,
         QryCariler.FieldByName('EPOSTA').AsString,
         QryCariler.FieldByName('WEB').AsString,
         QryCariler.FieldByName('CARI_LIMIT').AsCurrency,
         QryCariler.FieldByName('HESAP_DURUMU').AsInteger,
         QryCariler.FieldByName('NOTLAR').AsString,
         NowIso]
      );
      NewCariId := FConn.GetLastAutoGenValue('');

      // Sıfırdan farklı bakiye varsa Devir Fişi olarak kaydet
      if Abs(Bakiye) > 0.001 then
      begin
        if Bakiye > 0 then
        begin
          FConn.ExecSQL(
            'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK) ' +
            'VALUES (:FID, :CID, :TARIH, :TUR, :ACIKLAMA, :BORC, 0)',
            [AYeniFirmaId, NewCariId, NowIso, Ord(itDevir), STR_TUR_DEVIR, Bakiye]
          );
        end
        else
        begin
          FConn.ExecSQL(
            'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK) ' +
            'VALUES (:FID, :CID, :TARIH, :TUR, :ACIKLAMA, 0, :ALACAK)',
            [AYeniFirmaId, NewCariId, NowIso, Ord(itDevir), STR_TUR_DEVIR, -Bakiye]
          );
        end;
      end;

      QryCariler.Next;
    end;

    FConn.Commit;
    Result := True;
  except
    FConn.Rollback;
    raise;
  end;
  QryCariler.Free;
end;

{ TSQLiteCariRepository }

constructor TSQLiteCariRepository.Create(AConn: TFDConnection);
begin
  inherited Create;
  FConn := AConn;
end;

function TSQLiteCariRepository.GetAll(const AFiltre: TCariFiltre): TList<ICari>;
var
  Qry: TFDQuery;
  Sql: string;
  C: ICari;
  Borc, Alacak, Bakiye: Currency;
  SearchTerm: string;
begin
  Result := TList<ICari>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Sql :=
      'SELECT c.*, ' +
      '  COALESCE(SUM(h.BORC), 0) AS TOPLAM_BORC, ' +
      '  COALESCE(SUM(h.ALACAK), 0) AS TOPLAM_ALACAK, ' +
      '  COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0) AS BAKIYE, ' +
      '  MAX(h.TARIH) AS SON_ISLEM_TARIHI ' +
      'FROM CARILER c ' +
      'LEFT JOIN HAREKETLER h ON (c.ID = h.CARI_ID AND h.IS_DELETED = 0) ' +
      'WHERE c.FIRMA_ID = :FID AND c.IS_DELETED = 0 ';

    if AFiltre.HesapDurumu = hdAktif then
      Sql := Sql + 'AND c.HESAP_DURUMU = 1 '
    else if AFiltre.HesapDurumu = hdPasif then
      Sql := Sql + 'AND c.HESAP_DURUMU = 2 ';

    if Trim(AFiltre.AramaMetni) <> '' then
    begin
      if AFiltre.AramaModu = amIceren then
        SearchTerm := '%' + AFiltre.AramaMetni + '%'
      else
        SearchTerm := AFiltre.AramaMetni + '%';

      if AFiltre.SorguTuru = stCariKod then
        Sql := Sql + 'AND c.CARI_KODU LIKE :SEARCH '
      else
        Sql := Sql + 'AND (c.UNVAN LIKE :SEARCH OR c.NOTLAR LIKE :SEARCH OR c.YETKILI LIKE :SEARCH) ';
    end;

    Sql := Sql + 'GROUP BY c.ID ';

    // Bakiye Filtresi
    if AFiltre.BakiyeFiltresi = bfBorclular then
      Sql := Sql + 'HAVING (COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) > 0.001 '
    else if AFiltre.BakiyeFiltresi = bfAlacaklilar then
      Sql := Sql + 'HAVING (COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) < -0.001 '
    else if AFiltre.BakiyeFiltresi = bfBakiyesiArti then
      Sql := Sql + 'HAVING ABS(COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) > 0.001 '
    else if AFiltre.BakiyeFiltresi = bfSifirBakiye then
      Sql := Sql + 'HAVING ABS(COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) <= 0.001 '
    else if AFiltre.BakiyeFiltresi = bfLimitAsanlar then
      Sql := Sql + 'HAVING (COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) > c.CARI_LIMIT ';

    if Trim(AFiltre.AramaMetni) <> '' then
    begin
      Sql := Sql +
        'ORDER BY ' +
        '  CASE ' +
        '    WHEN LOWER(c.UNVAN) = LOWER(:EXACT) THEN 1 ' +
        '    WHEN LOWER(c.CARI_KODU) = LOWER(:EXACT) THEN 2 ' +
        '    WHEN LOWER(c.UNVAN) LIKE LOWER(:START) THEN 3 ' +
        '    WHEN LOWER(c.CARI_KODU) LIKE LOWER(:START) THEN 4 ' +
        '    ELSE 5 ' +
        '  END ASC, ' +
        '  c.UNVAN COLLATE NOCASE ASC;';
    end
    else
      Sql := Sql + 'ORDER BY c.UNVAN COLLATE NOCASE ASC;';

    Qry.SQL.Text := Sql;
    Qry.ParamByName('FID').AsInteger := AFiltre.FirmaId;
    if Trim(AFiltre.AramaMetni) <> '' then
    begin
      Qry.ParamByName('SEARCH').AsString := SearchTerm;
      Qry.ParamByName('EXACT').AsString := Trim(AFiltre.AramaMetni);
      Qry.ParamByName('START').AsString := Trim(AFiltre.AramaMetni) + '%';
    end;

    Qry.Open;
    while not Qry.Eof do
    begin
      C := TCari.Create;
      C.Id := Qry.FieldByName('ID').AsInteger;
      C.FirmaId := Qry.FieldByName('FIRMA_ID').AsInteger;
      C.CariKodu := Qry.FieldByName('CARI_KODU').AsString;
      C.Unvan := Qry.FieldByName('UNVAN').AsString;
      C.Yetkili := Qry.FieldByName('YETKILI').AsString;
      C.Telefon := Qry.FieldByName('TELEFON').AsString;
      C.Gsm := Qry.FieldByName('GSM').AsString;
      C.Faks := Qry.FieldByName('FAKS').AsString;
      C.Adres := Qry.FieldByName('ADRES').AsString;
      C.Il := Qry.FieldByName('IL').AsString;
      C.Ilce := Qry.FieldByName('ILCE').AsString;
      C.VergiDairesi := Qry.FieldByName('VERGI_DAIRESI').AsString;
      C.VergiNo := Qry.FieldByName('VERGI_NO').AsString;
      C.Eposta := Qry.FieldByName('EPOSTA').AsString;
      C.Web := Qry.FieldByName('WEB').AsString;
      C.CariLimit := Qry.FieldByName('CARI_LIMIT').AsCurrency;
      if Qry.FieldByName('HESAP_DURUMU').AsInteger = 2 then
        C.HesapDurumu := hdPasif
      else
        C.HesapDurumu := hdAktif;
      C.Notlar := Qry.FieldByName('NOTLAR').AsString;
      C.KayitTarihi := StrToDateTimeDef(Qry.FieldByName('KAYIT_TARIHI').AsString, Date);
      if not Qry.FieldByName('SON_ISLEM_TARIHI').IsNull then
        C.SonIslemTarihi := StrToDateTimeDef(Qry.FieldByName('SON_ISLEM_TARIHI').AsString, C.KayitTarihi)
      else
        C.SonIslemTarihi := C.KayitTarihi;

      Borc := Qry.FieldByName('TOPLAM_BORC').AsCurrency;
      Alacak := Qry.FieldByName('TOPLAM_ALACAK').AsCurrency;
      Bakiye := Qry.FieldByName('BAKIYE').AsCurrency;

      C.ToplamBorc := Borc;
      C.ToplamAlacak := Alacak;
      C.Bakiye := Bakiye;

      Result.Add(C);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteCariRepository.GetById(const AId: Integer): ICari;
var
  Qry: TFDQuery;
begin
  Result := nil;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'SELECT c.*, ' +
      '  COALESCE(SUM(h.BORC), 0) AS TOPLAM_BORC, ' +
      '  COALESCE(SUM(h.ALACAK), 0) AS TOPLAM_ALACAK, ' +
      '  COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0) AS BAKIYE ' +
      'FROM CARILER c ' +
      'LEFT JOIN HAREKETLER h ON (c.ID = h.CARI_ID AND h.IS_DELETED = 0) ' +
      'WHERE c.ID = :ID AND c.IS_DELETED = 0 ' +
      'GROUP BY c.ID;';
    Qry.ParamByName('ID').AsInteger := AId;
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      Result := TCari.Create;
      Result.Id := Qry.FieldByName('ID').AsInteger;
      Result.FirmaId := Qry.FieldByName('FIRMA_ID').AsInteger;
      Result.CariKodu := Qry.FieldByName('CARI_KODU').AsString;
      Result.Unvan := Qry.FieldByName('UNVAN').AsString;
      Result.Yetkili := Qry.FieldByName('YETKILI').AsString;
      Result.Telefon := Qry.FieldByName('TELEFON').AsString;
      Result.Gsm := Qry.FieldByName('GSM').AsString;
      Result.Faks := Qry.FieldByName('FAKS').AsString;
      Result.Adres := Qry.FieldByName('ADRES').AsString;
      Result.Il := Qry.FieldByName('IL').AsString;
      Result.Ilce := Qry.FieldByName('ILCE').AsString;
      Result.VergiDairesi := Qry.FieldByName('VERGI_DAIRESI').AsString;
      Result.VergiNo := Qry.FieldByName('VERGI_NO').AsString;
      Result.Eposta := Qry.FieldByName('EPOSTA').AsString;
      Result.Web := Qry.FieldByName('WEB').AsString;
      Result.CariLimit := Qry.FieldByName('CARI_LIMIT').AsCurrency;
      if Qry.FieldByName('HESAP_DURUMU').AsInteger = 2 then
        Result.HesapDurumu := hdPasif
      else
        Result.HesapDurumu := hdAktif;
      Result.Notlar := Qry.FieldByName('NOTLAR').AsString;
      Result.KayitTarihi := StrToDateTimeDef(Qry.FieldByName('KAYIT_TARIHI').AsString, Date);
      Result.ToplamBorc := Qry.FieldByName('TOPLAM_BORC').AsCurrency;
      Result.ToplamAlacak := Qry.FieldByName('TOPLAM_ALACAK').AsCurrency;
      Result.Bakiye := Qry.FieldByName('BAKIYE').AsCurrency;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteCariRepository.Insert(const ACari: ICari): Integer;
var
  Qry: TFDQuery;
  DurumInt: Integer;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'INSERT INTO CARILER (FIRMA_ID, CARI_KODU, UNVAN, YETKILI, TELEFON, GSM, FAKS, ADRES, IL, ILCE, VERGI_DAIRESI, VERGI_NO, EPOSTA, WEB, CARI_LIMIT, HESAP_DURUMU, NOTLAR, KAYIT_TARIHI) ' +
      'VALUES (:FID, :KOD, :UNVAN, :YETKILI, :TEL, :GSM, :FAKS, :ADRES, :IL, :ILCE, :VD, :VN, :MAIL, :WEB, :LIMIT, :DURUM, :NOTLAR, :TARIH);';
    Qry.ParamByName('FID').AsInteger := ACari.FirmaId;
    Qry.ParamByName('KOD').AsString := ACari.CariKodu;
    Qry.ParamByName('UNVAN').AsString := ACari.Unvan;
    Qry.ParamByName('YETKILI').AsString := ACari.Yetkili;
    Qry.ParamByName('TEL').AsString := ACari.Telefon;
    Qry.ParamByName('GSM').AsString := ACari.Gsm;
    Qry.ParamByName('FAKS').AsString := ACari.Faks;
    Qry.ParamByName('ADRES').AsString := ACari.Adres;
    Qry.ParamByName('IL').AsString := ACari.Il;
    Qry.ParamByName('ILCE').AsString := ACari.Ilce;
    Qry.ParamByName('VD').AsString := ACari.VergiDairesi;
    Qry.ParamByName('VN').AsString := ACari.VergiNo;
    Qry.ParamByName('MAIL').AsString := ACari.Eposta;
    Qry.ParamByName('WEB').AsString := ACari.Web;
    Qry.ParamByName('LIMIT').AsCurrency := ACari.CariLimit;
    if ACari.HesapDurumu = hdPasif then DurumInt := 2 else DurumInt := 1;
    Qry.ParamByName('DURUM').AsInteger := DurumInt;
    Qry.ParamByName('NOTLAR').AsString := ACari.Notlar;
    Qry.ParamByName('TARIH').AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', ACari.KayitTarihi);
    Qry.ExecSQL;
    Result := FConn.GetLastAutoGenValue('');
    ACari.Id := Result;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteCariRepository.Update(const ACari: ICari);
var
  Qry: TFDQuery;
  DurumInt: Integer;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'UPDATE CARILER SET CARI_KODU = :KOD, UNVAN = :UNVAN, YETKILI = :YETKILI, TELEFON = :TEL, ' +
      'GSM = :GSM, FAKS = :FAKS, ADRES = :ADRES, IL = :IL, ILCE = :ILCE, VERGI_DAIRESI = :VD, ' +
      'VERGI_NO = :VN, EPOSTA = :MAIL, WEB = :WEB, CARI_LIMIT = :LIMIT, HESAP_DURUMU = :DURUM, ' +
      'NOTLAR = :NOTLAR WHERE ID = :ID;';
    Qry.ParamByName('ID').AsInteger := ACari.Id;
    Qry.ParamByName('KOD').AsString := ACari.CariKodu;
    Qry.ParamByName('UNVAN').AsString := ACari.Unvan;
    Qry.ParamByName('YETKILI').AsString := ACari.Yetkili;
    Qry.ParamByName('TEL').AsString := ACari.Telefon;
    Qry.ParamByName('GSM').AsString := ACari.Gsm;
    Qry.ParamByName('FAKS').AsString := ACari.Faks;
    Qry.ParamByName('ADRES').AsString := ACari.Adres;
    Qry.ParamByName('IL').AsString := ACari.Il;
    Qry.ParamByName('ILCE').AsString := ACari.Ilce;
    Qry.ParamByName('VD').AsString := ACari.VergiDairesi;
    Qry.ParamByName('VN').AsString := ACari.VergiNo;
    Qry.ParamByName('MAIL').AsString := ACari.Eposta;
    Qry.ParamByName('WEB').AsString := ACari.Web;
    Qry.ParamByName('LIMIT').AsCurrency := ACari.CariLimit;
    if ACari.HesapDurumu = hdPasif then DurumInt := 2 else DurumInt := 1;
    Qry.ParamByName('DURUM').AsInteger := DurumInt;
    Qry.ParamByName('NOTLAR').AsString := ACari.Notlar;
    Qry.ExecSQL;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteCariRepository.Delete(const AId: Integer);
begin
  // Soft delete
  FConn.ExecSQL('UPDATE CARILER SET IS_DELETED = 1 WHERE ID = ' + IntToStr(AId));
  FConn.ExecSQL('UPDATE HAREKETLER SET IS_DELETED = 1 WHERE CARI_ID = ' + IntToStr(AId));
end;

function TSQLiteCariRepository.GetNextCariKodu(const AFirmaId: Integer): string;
var
  MaxVal: Integer;
begin
  MaxVal := FConn.ExecSQLScalar(
    'SELECT COALESCE(MAX(CAST(CARI_KODU AS INTEGER)), 0) FROM CARILER WHERE FIRMA_ID = ' + IntToStr(AFirmaId)
  );
  Result := Format('%.5d', [MaxVal + 1]);
end;

function TSQLiteCariRepository.GetBakiyeOzet(const AFirmaId: Integer): TBakiyeOzet;
var
  Qry: TFDQuery;
  Bakiye: Currency;
  Durum: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'SELECT c.HESAP_DURUMU, ' +
      '  (COALESCE(SUM(h.BORC), 0) - COALESCE(SUM(h.ALACAK), 0)) AS BAKIYE ' +
      'FROM CARILER c ' +
      'LEFT JOIN HAREKETLER h ON (c.ID = h.CARI_ID AND h.IS_DELETED = 0) ' +
      'WHERE c.FIRMA_ID = :FID AND c.IS_DELETED = 0 ' +
      'GROUP BY c.ID, c.HESAP_DURUMU;';
    Qry.ParamByName('FID').AsInteger := AFirmaId;
    Qry.Open;
    while not Qry.Eof do
    begin
      Durum := Qry.FieldByName('HESAP_DURUMU').AsInteger;
      Bakiye := Qry.FieldByName('BAKIYE').AsCurrency;

      Inc(Result.ToplamCariSayisi);
      if Durum = 1 then
        Inc(Result.AktifCariSayisi)
      else
        Inc(Result.PasifCariSayisi);

      if Bakiye > 0.001 then
      begin
        // Borçlu
        Inc(Result.BorcluCariSayisi);
        Result.GenelBorcluToplam := Result.GenelBorcluToplam + Bakiye;
        if Durum = 1 then
          Result.AktifBorcluToplam := Result.AktifBorcluToplam + Bakiye
        else
          Result.PasifBorcluToplam := Result.PasifBorcluToplam + Bakiye;
      end
      else if Bakiye < -0.001 then
      begin
        // Alacaklı
        Inc(Result.AlacakliCariSayisi);
        Result.GenelAlacakliToplam := Result.GenelAlacakliToplam + (-Bakiye);
        if Durum = 1 then
          Result.AktifAlacakliToplam := Result.AktifAlacakliToplam + (-Bakiye)
        else
          Result.PasifAlacakliToplam := Result.PasifAlacakliToplam + (-Bakiye);
      end
      else
        Inc(Result.SifirBakiyeCariSayisi);

      Qry.Next;
    end;
    Result.NetBakiye := Result.GenelBorcluToplam - Result.GenelAlacakliToplam;
  finally
    Qry.Free;
  end;
end;

{ TSQLiteHareketRepository }

constructor TSQLiteHareketRepository.Create(AConn: TFDConnection);
begin
  inherited Create;
  FConn := AConn;
end;

function TSQLiteHareketRepository.GetByCariId(const ACariId: Integer): TList<IHareket>;
var
  Qry: TFDQuery;
  H: IHareket;
  RunningBal: Currency;
  Borc, Alacak: Currency;
begin
  Result := TList<IHareket>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'SELECT h.*, c.UNVAN AS CARI_UNVAN FROM HAREKETLER h ' +
      'INNER JOIN CARILER c ON h.CARI_ID = c.ID ' +
      'WHERE h.CARI_ID = :CID AND h.IS_DELETED = 0 ' +
      'ORDER BY h.TARIH ASC, h.ID ASC;';
    Qry.ParamByName('CID').AsInteger := ACariId;
    Qry.Open;

    RunningBal := 0;
    while not Qry.Eof do
    begin
      H := THareketBase.Create;
      H.Id := Qry.FieldByName('ID').AsInteger;
      H.FirmaId := Qry.FieldByName('FIRMA_ID').AsInteger;
      H.CariId := Qry.FieldByName('CARI_ID').AsInteger;
      H.CariUnvan := Qry.FieldByName('CARI_UNVAN').AsString;
      H.Tarih := StrToDateTimeDef(Qry.FieldByName('TARIH').AsString, Now);
      H.IslemTuru := TIslemTuru(Qry.FieldByName('ISLEM_TURU').AsInteger);
      H.Aciklama := Qry.FieldByName('ACIKLAMA').AsString;
      Borc := Qry.FieldByName('BORC').AsCurrency;
      Alacak := Qry.FieldByName('ALACAK').AsCurrency;
      H.Borc := Borc;
      H.Alacak := Alacak;

      RunningBal := RunningBal + (Borc - Alacak);
      H.YuruyenBakiye := RunningBal;

      Result.Add(H);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteHareketRepository.Insert(const AHareket: IHareket): Integer;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK) ' +
      'VALUES (:FID, :CID, :TARIH, :TUR, :ACIKLAMA, :BORC, :ALACAK);';
    Qry.ParamByName('FID').AsInteger := AHareket.FirmaId;
    Qry.ParamByName('CID').AsInteger := AHareket.CariId;
    Qry.ParamByName('TARIH').AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', AHareket.Tarih);
    Qry.ParamByName('TUR').AsInteger := Ord(AHareket.IslemTuru);
    Qry.ParamByName('ACIKLAMA').AsString := AHareket.Aciklama;
    Qry.ParamByName('BORC').AsCurrency := AHareket.Borc;
    Qry.ParamByName('ALACAK').AsCurrency := AHareket.Alacak;
    Qry.ExecSQL;
    Result := FConn.GetLastAutoGenValue('');
    AHareket.Id := Result;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteHareketRepository.Update(const AHareket: IHareket);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text :=
      'UPDATE HAREKETLER SET TARIH = :TARIH, ISLEM_TURU = :TUR, ACIKLAMA = :ACIKLAMA, ' +
      'BORC = :BORC, ALACAK = :ALACAK WHERE ID = :ID;';
    Qry.ParamByName('ID').AsInteger := AHareket.Id;
    Qry.ParamByName('TARIH').AsString := FormatDateTime('yyyy-mm-dd hh:nn:ss', AHareket.Tarih);
    Qry.ParamByName('TUR').AsInteger := Ord(AHareket.IslemTuru);
    Qry.ParamByName('ACIKLAMA').AsString := AHareket.Aciklama;
    Qry.ParamByName('BORC').AsCurrency := AHareket.Borc;
    Qry.ParamByName('ALACAK').AsCurrency := AHareket.Alacak;
    Qry.ExecSQL;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteHareketRepository.Delete(const AId: Integer);
begin
  FConn.ExecSQL('UPDATE HAREKETLER SET IS_DELETED = 1 WHERE ID = ' + IntToStr(AId));
end;

function TSQLiteHareketRepository.GetGenelHareketler(const AFirmaId: Integer; const ABasTarih, ABitTarih: TDateTime;
  const ATur: Integer): TList<IHareket>;
var
  Qry: TFDQuery;
  H: IHareket;
  Sql: string;
begin
  Result := TList<IHareket>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Sql :=
      'SELECT h.*, c.UNVAN AS CARI_UNVAN FROM HAREKETLER h ' +
      'INNER JOIN CARILER c ON h.CARI_ID = c.ID ' +
      'WHERE h.FIRMA_ID = :FID AND h.IS_DELETED = 0 ' +
      'AND h.TARIH >= :BAS AND h.TARIH <= :BIT ';

    if ATur >= 0 then
      Sql := Sql + 'AND h.ISLEM_TURU = ' + IntToStr(ATur) + ' ';

    Sql := Sql + 'ORDER BY h.TARIH DESC, h.ID DESC;';

    Qry.SQL.Text := Sql;
    Qry.ParamByName('FID').AsInteger := AFirmaId;
    Qry.ParamByName('BAS').AsString := FormatDateTime('yyyy-mm-dd 00:00:00', ABasTarih);
    Qry.ParamByName('BIT').AsString := FormatDateTime('yyyy-mm-dd 23:59:59', ABitTarih);
    Qry.Open;

    while not Qry.Eof do
    begin
      H := THareketBase.Create;
      H.Id := Qry.FieldByName('ID').AsInteger;
      H.FirmaId := Qry.FieldByName('FIRMA_ID').AsInteger;
      H.CariId := Qry.FieldByName('CARI_ID').AsInteger;
      H.CariUnvan := Qry.FieldByName('CARI_UNVAN').AsString;
      H.Tarih := StrToDateTimeDef(Qry.FieldByName('TARIH').AsString, Now);
      H.IslemTuru := TIslemTuru(Qry.FieldByName('ISLEM_TURU').AsInteger);
      H.Aciklama := Qry.FieldByName('ACIKLAMA').AsString;
      H.Borc := Qry.FieldByName('BORC').AsCurrency;
      H.Alacak := Qry.FieldByName('ALACAK').AsCurrency;
      Result.Add(H);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

{ TSQLiteAyarlarRepository }

constructor TSQLiteAyarlarRepository.Create(AConn: TFDConnection);
begin
  inherited Create;
  FConn := AConn;
end;

function TSQLiteAyarlarRepository.GetAyar(const AAnahtar: string; const AVarsayilan: string): string;
var
  Qry: TFDQuery;
begin
  Result := AVarsayilan;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT DEGER FROM AYARLAR WHERE ANAHTAR = :K;';
    Qry.ParamByName('K').AsString := AAnahtar;
    Qry.Open;
    if not Qry.IsEmpty and not Qry.FieldByName('DEGER').IsNull then
      Result := Qry.FieldByName('DEGER').AsString;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteAyarlarRepository.SetAyar(const AAnahtar, ADeger: string);
begin
  FConn.ExecSQL('INSERT INTO AYARLAR (ANAHTAR, DEGER) VALUES (:K, :V) ' +
                'ON CONFLICT(ANAHTAR) DO UPDATE SET DEGER = :V;', [AAnahtar, ADeger]);
end;

function TSQLiteAyarlarRepository.GetAciklamalar(const AIslemTuru: Integer): TList<string>;
var
  Qry: TFDQuery;
begin
  Result := TList<string>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    if AIslemTuru > 0 then
    begin
      Qry.SQL.Text := 'SELECT ACIKLAMA FROM ACIKLAMALAR WHERE ISLEM_TURU = :T ORDER BY ACIKLAMA ASC;';
      Qry.ParamByName('T').AsInteger := AIslemTuru;
    end
    else
      Qry.SQL.Text := 'SELECT DISTINCT ACIKLAMA FROM ACIKLAMALAR ORDER BY ACIKLAMA ASC;';
    Qry.Open;
    while not Qry.Eof do
    begin
      Result.Add(Qry.FieldByName('ACIKLAMA').AsString);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

procedure TSQLiteAyarlarRepository.AddAciklama(const AIslemTuru: Integer; const AAciklama: string);
var
  Trimmed: string;
begin
  Trimmed := Trim(AAciklama);
  if Trimmed = '' then Exit;

  // Çift kaydı engelle
  if FConn.ExecSQLScalar('SELECT COUNT(*) FROM ACIKLAMALAR WHERE ISLEM_TURU = :T AND ACIKLAMA = :A;',
    [AIslemTuru, Trimmed]) = 0 then
  begin
    FConn.ExecSQL('INSERT INTO ACIKLAMALAR (ISLEM_TURU, ACIKLAMA) VALUES (:T, :A);',
      [AIslemTuru, Trimmed]);
  end;
end;

procedure TSQLiteAyarlarRepository.DeleteAciklama(const AIslemTuru: Integer; const AAciklama: string);
begin
  if AIslemTuru > 0 then
    FConn.ExecSQL('DELETE FROM ACIKLAMALAR WHERE ISLEM_TURU = :T AND ACIKLAMA = :A;',
      [AIslemTuru, Trim(AAciklama)])
  else
    FConn.ExecSQL('DELETE FROM ACIKLAMALAR WHERE ACIKLAMA = :A;', [Trim(AAciklama)]);
end;

procedure TSQLiteAyarlarRepository.ClearAciklamalar(const AIslemTuru: Integer);
begin
  if AIslemTuru > 0 then
    FConn.ExecSQL('DELETE FROM ACIKLAMALAR WHERE ISLEM_TURU = :T;', [AIslemTuru])
  else
    FConn.ExecSQL('DELETE FROM ACIKLAMALAR;');
end;

{ TSQLiteIlIlceRepository }

constructor TSQLiteIlIlceRepository.Create(AConn: TFDConnection);
begin
  inherited Create;
  FConn := AConn;
end;

function TSQLiteIlIlceRepository.GetIller: TList<string>;
var
  Qry: TFDQuery;
begin
  Result := TList<string>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT AD FROM ILLER ORDER BY AD';
    Qry.Open;
    while not Qry.Eof do
    begin
      Result.Add(Qry.FieldByName('AD').AsString);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

function TSQLiteIlIlceRepository.GetIlceler(const AIlAdi: string): TList<string>;
var
  Qry: TFDQuery;
begin
  Result := TList<string>.Create;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 
      'SELECT C.AD FROM ILCELER C ' +
      'JOIN ILLER I ON I.ID = C.IL_ID ' +
      'WHERE I.AD = :IL_ADI ' +
      'ORDER BY C.AD';
    Qry.ParamByName('IL_ADI').AsString := AIlAdi;
    Qry.Open;
    while not Qry.Eof do
    begin
      Result.Add(Qry.FieldByName('AD').AsString);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

end.