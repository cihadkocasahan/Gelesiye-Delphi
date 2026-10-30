unit uDbDemoSeedService;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDbFactory, uDbDemoSeed;

type
  TDbDemoSeedService = class
  public
    class function ResetData(const AFirmaId: Integer = 1): Boolean; static;
    class function SeedDemoData(const AFirmaId: Integer = 1): Boolean; static;
    class function ResetAndSeedDemoData(const AFirmaId: Integer = 1): Boolean; static;
  end;

implementation

class function TDbDemoSeedService.ResetData(const AFirmaId: Integer): Boolean;
var
  Conn: TFDConnection;
begin
  try
    Conn := TDbFactory.GetFDConnection;
    if Conn = nil then Exit(False);
    Conn.StartTransaction;
    try
      Conn.ExecSQL('DELETE FROM HAREKETLER WHERE FIRMA_ID = :FID', [AFirmaId]);
      Conn.ExecSQL('DELETE FROM CARILER WHERE FIRMA_ID = :FID', [AFirmaId]);
      Conn.Commit;
    except
      Conn.Rollback;
      raise;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

class function TDbDemoSeedService.SeedDemoData(const AFirmaId: Integer): Boolean;
var
  Conn: TFDConnection;
begin
  try
    Conn := TDbFactory.GetFDConnection;
    if Conn = nil then Exit(False);
    uDbDemoSeed.SeedDemoData(Conn, True);
    Result := True;
  except
    Result := False;
  end;
end;

class function TDbDemoSeedService.ResetAndSeedDemoData(const AFirmaId: Integer): Boolean;
begin
  Result := ResetData(AFirmaId) and SeedDemoData(AFirmaId);
end;

end.
