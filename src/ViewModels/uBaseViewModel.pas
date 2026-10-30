unit uBaseViewModel;

interface

uses
  System.SysUtils, System.Classes;

type
  TBaseViewModel = class(TInterfacedObject)
  private
    FIsBusy: Boolean;
    FLastError: string;
    FOnDataChanged: TNotifyEvent;
    FOnStateChanged: TNotifyEvent;
  protected
    procedure SetIsBusy(const AValue: Boolean); virtual;
    procedure SetLastError(const AValue: string); virtual;
    procedure NotifyDataChanged; virtual;
  public
    constructor Create; virtual;
    property IsBusy: Boolean read FIsBusy write SetIsBusy;
    property LastError: string read FLastError;
    property OnDataChanged: TNotifyEvent read FOnDataChanged write FOnDataChanged;
    property OnStateChanged: TNotifyEvent read FOnStateChanged write FOnStateChanged;
  end;

implementation

{ TBaseViewModel }

constructor TBaseViewModel.Create;
begin
  inherited Create;
  FIsBusy := False;
  FLastError := '';
end;

procedure TBaseViewModel.SetIsBusy(const AValue: Boolean);
begin
  if FIsBusy <> AValue then
  begin
    FIsBusy := AValue;
    if Assigned(FOnStateChanged) then
      FOnStateChanged(Self);
  end;
end;

procedure TBaseViewModel.SetLastError(const AValue: string);
begin
  FLastError := AValue;
  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self);
end;

procedure TBaseViewModel.NotifyDataChanged;
begin
  if Assigned(FOnDataChanged) then
    FOnDataChanged(Self);
end;

end.
