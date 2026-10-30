unit uDbFirebird;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Comp.Client,
  uGelesiyeConsts, uGelesiyeTypes, uGelesiyeInterfaces;

type
  // ===========================================================================
  // TFirebirdConnection: Firebird 2.5 / 3.0 Bağlantı Yöneticisi (IDbConnection)
  // Çok kullanıcılı ağ mimarisi için hazır altyapı
  // ===========================================================================
  TFirebirdConnection = class(TInterfacedObject, IDbConnection)
  private
    FConn: TFDConnection;
    FDriverLink: TFDPhysFBDriverLink;
    FWaitCursor: TFDGUIxWaitCursor;
  public
    constructor Create(const AHost, ADbPath, AUser, APass: string; const APort: Integer = 3050);
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

implementation

{ TFirebirdConnection }

constructor TFirebirdConnection.Create(const AHost, ADbPath, AUser, APass: string; const APort: Integer);
begin
  inherited Create;
  FDriverLink := TFDPhysFBDriverLink.Create(nil);
  FWaitCursor := TFDGUIxWaitCursor.Create(nil);
  FConn := TFDConnection.Create(nil);

  FConn.LoginPrompt := False;
  FConn.Params.DriverID := 'FB';
  FConn.Params.Database := ADbPath;
  FConn.Params.UserName := AUser;
  FConn.Params.Password := APass;
  FConn.Params.Add('Server=' + AHost);
  FConn.Params.Add('Port=' + IntToStr(APort));
  FConn.Params.Add('CharacterSet=UTF8');
end;

destructor TFirebirdConnection.Destroy;
begin
  Disconnect;
  FConn.Free;
  FWaitCursor.Free;
  FDriverLink.Free;
  inherited Destroy;
end;

procedure TFirebirdConnection.Connect;
begin
  if not FConn.Connected then
    FConn.Connected := True;
end;

procedure TFirebirdConnection.Disconnect;
begin
  if FConn.Connected then
    FConn.Connected := False;
end;

function TFirebirdConnection.IsConnected: Boolean;
begin
  Result := FConn.Connected;
end;

procedure TFirebirdConnection.StartTransaction;
begin
  if not FConn.InTransaction then
    FConn.StartTransaction;
end;

procedure TFirebirdConnection.Commit;
begin
  if FConn.InTransaction then
    FConn.Commit;
end;

procedure TFirebirdConnection.Rollback;
begin
  if FConn.InTransaction then
    FConn.Rollback;
end;

function TFirebirdConnection.GetDriverName: string;
begin
  Result := 'Firebird';
end;

end.
