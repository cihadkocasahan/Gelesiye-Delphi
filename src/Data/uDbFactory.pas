unit uDbFactory;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uGelesiyeInterfaces, uDbSQLite;

type
  TDbProviderType = (dpSQLite, dpFirebird);

  TDbFactory = class
  private
    class var FConnection: IDbConnection;
    class var FFDConnection: TFDConnection;
    class var FFirmaRepo: IFirmaRepository;
    class var FCariRepo: ICariRepository;
    class var FHareketRepo: IHareketRepository;
    class var FAyarlarRepo: IAyarlarRepository;
    class var FIlIlceRepo: IIlIlceRepository;
    class var FProviderType: TDbProviderType;
  public
    class procedure Initialize(const AProvider: TDbProviderType = dpSQLite; const ACustomPath: string = '');
    class procedure Finalize;

    class function GetConnection: IDbConnection;
    class function GetFDConnection: TFDConnection;
    class function GetFirmaRepository: IFirmaRepository;
    class function GetCariRepository: ICariRepository;
    class function GetHareketRepository: IHareketRepository;
    class function GetAyarlarRepository: IAyarlarRepository;
    class function GetIlIlceRepository: IIlIlceRepository;
  end;

implementation

{ TDbFactory }

class procedure TDbFactory.Initialize(const AProvider: TDbProviderType; const ACustomPath: string);
var
  SQLiteConn: TSQLiteConnection;
begin
  Finalize;
  FProviderType := AProvider;

  case AProvider of
    dpSQLite:
    begin
      SQLiteConn := TSQLiteConnection.Create(ACustomPath);
      FConnection := SQLiteConn;
      FFDConnection := SQLiteConn.Connection;
      FFirmaRepo := TSQLiteFirmaRepository.Create(SQLiteConn.Connection);
      FCariRepo := TSQLiteCariRepository.Create(SQLiteConn.Connection);
      FHareketRepo := TSQLiteHareketRepository.Create(SQLiteConn.Connection);
      FAyarlarRepo := TSQLiteAyarlarRepository.Create(SQLiteConn.Connection);
      FIlIlceRepo := TSQLiteIlIlceRepository.Create(SQLiteConn.Connection);
    end;
    dpFirebird:
    begin
      // Firebird bağlantı parametreleri gerektiğinde buraya eklenir
      raise Exception.Create('Firebird sağlayıcısı için bağlantı parametreleri girilmelidir.');
    end;
  end;
end;

class procedure TDbFactory.Finalize;
begin
  FIlIlceRepo := nil;
  FAyarlarRepo := nil;
  FHareketRepo := nil;
  FCariRepo := nil;
  FFirmaRepo := nil;
  FFDConnection := nil;
  if FConnection <> nil then
  begin
    FConnection.Disconnect;
    FConnection := nil;
  end;
end;

class function TDbFactory.GetConnection: IDbConnection;
begin
  if FConnection = nil then
    Initialize;
  Result := FConnection;
end;

class function TDbFactory.GetFDConnection: TFDConnection;
begin
  if FFDConnection = nil then
    Initialize;
  Result := FFDConnection;
end;

class function TDbFactory.GetFirmaRepository: IFirmaRepository;
begin
  if FFirmaRepo = nil then
    Initialize;
  Result := FFirmaRepo;
end;

class function TDbFactory.GetCariRepository: ICariRepository;
begin
  if FCariRepo = nil then
    Initialize;
  Result := FCariRepo;
end;

class function TDbFactory.GetHareketRepository: IHareketRepository;
begin
  if FHareketRepo = nil then
    Initialize;
  Result := FHareketRepo;
end;

class function TDbFactory.GetAyarlarRepository: IAyarlarRepository;
begin
  if FAyarlarRepo = nil then
    Initialize;
  Result := FAyarlarRepo;
end;

class function TDbFactory.GetIlIlceRepository: IIlIlceRepository;
begin
  if FIlIlceRepo = nil then
    Initialize;
  Result := FIlIlceRepo;
end;

initialization

finalization
  TDbFactory.Finalize;

end.
