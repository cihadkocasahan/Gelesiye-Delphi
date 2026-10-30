unit uFirmaViewModel;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uGelesiyeConsts, uGelesiyeTypes, uGelesiyeInterfaces, uGelesiyeEntities, uBaseViewModel;

type
  TFirmaViewModel = class(TBaseViewModel)
  private
    FRepo: IFirmaRepository;
    FFirmalar: TList<IFirma>;
    FAktifFirma: IFirma;
    procedure ClearFirmalar;
  public
    constructor Create(ARepo: IFirmaRepository); reintroduce;
    destructor Destroy; override;

    procedure Yenile;
    function GetDefaultFirma: IFirma;
    procedure SetDefaultFirma(const AId: Integer);
    procedure FirmaSil(const AId: Integer);
    function FirmaKaydet(const AFirma: IFirma; const AIsNew: Boolean): Boolean;
    function DevirYap(const AEskiFirmaId, AYeniFirmaId: Integer; const AAktarAciklamalar: Boolean): Boolean;

    property Firmalar: TList<IFirma> read FFirmalar;
    property AktifFirma: IFirma read FAktifFirma write FAktifFirma;
  end;

implementation

{ TFirmaViewModel }

constructor TFirmaViewModel.Create(ARepo: IFirmaRepository);
begin
  inherited Create;
  FRepo := ARepo;
  FFirmalar := TList<IFirma>.Create;
  FAktifFirma := nil;
  Yenile;
end;

destructor TFirmaViewModel.Destroy;
begin
  ClearFirmalar;
  FFirmalar.Free;
  inherited Destroy;
end;

procedure TFirmaViewModel.ClearFirmalar;
begin
  FFirmalar.Clear;
end;

procedure TFirmaViewModel.Yenile;
var
  List: TList<IFirma>;
begin
  IsBusy := True;
  try
    ClearFirmalar;
    List := FRepo.GetAll;
    try
      FFirmalar.AddRange(List);
    finally
      List.Free;
    end;

    if FAktifFirma = nil then
      FAktifFirma := FRepo.GetDefault;

    NotifyDataChanged;
  finally
    IsBusy := False;
  end;
end;

function TFirmaViewModel.GetDefaultFirma: IFirma;
begin
  Result := FRepo.GetDefault;
end;

procedure TFirmaViewModel.SetDefaultFirma(const AId: Integer);
begin
  FRepo.SetDefault(AId);
  Yenile;
end;

procedure TFirmaViewModel.FirmaSil(const AId: Integer);
begin
  FRepo.Delete(AId);
  Yenile;
end;

function TFirmaViewModel.FirmaKaydet(const AFirma: IFirma; const AIsNew: Boolean): Boolean;
begin
  if AIsNew then
    AFirma.Id := FRepo.Insert(AFirma)
  else
    FRepo.Update(AFirma);
  Yenile;
  Result := True;
end;

function TFirmaViewModel.DevirYap(const AEskiFirmaId, AYeniFirmaId: Integer; const AAktarAciklamalar: Boolean): Boolean;
begin
  Result := FRepo.DevirYap(AEskiFirmaId, AYeniFirmaId, AAktarAciklamalar);
  if Result then
    Yenile;
end;

end.
