unit uCariDetailViewModel;

interface

uses
  System.SysUtils, System.Classes,
  uGelesiyeConsts, uGelesiyeTypes, uGelesiyeInterfaces, uGelesiyeEntities, uBaseViewModel;

type
  TCariDetailViewModel = class(TBaseViewModel)
  private
    FRepo: ICariRepository;
    FCari: ICari;
    FIsNew: Boolean;
  public
    constructor Create(ARepo: ICariRepository); reintroduce;
    procedure YeniCari(const AFirmaId: Integer);
    procedure MevcutCariYukle(const ACariId: Integer);
    function Kaydet: Boolean;
    function Validate(out AErrorMessage: string): Boolean;

    property Cari: ICari read FCari;
    property IsNew: Boolean read FIsNew;
  end;

implementation

{ TCariDetailViewModel }

constructor TCariDetailViewModel.Create(ARepo: ICariRepository);
begin
  inherited Create;
  FRepo := ARepo;
  FCari := TCari.Create;
  FIsNew := True;
end;

procedure TCariDetailViewModel.YeniCari(const AFirmaId: Integer);
begin
  FCari := TCari.Create;
  FCari.FirmaId := AFirmaId;
  FCari.CariKodu := FRepo.GetNextCariKodu(AFirmaId);
  FCari.KayitTarihi := Date;
  FIsNew := True;
  NotifyDataChanged;
end;

procedure TCariDetailViewModel.MevcutCariYukle(const ACariId: Integer);
begin
  FCari := FRepo.GetById(ACariId);
  FIsNew := False;
  NotifyDataChanged;
end;

function TCariDetailViewModel.Validate(out AErrorMessage: string): Boolean;
begin
  AErrorMessage := '';
  if Trim(FCari.Unvan) = '' then
  begin
    AErrorMessage := MSG_UNVAN_BOS_OLAMAZ;
    Exit(False);
  end;

  if Trim(FCari.CariKodu) = '' then
  begin
    AErrorMessage := MSG_KOD_BOS_OLAMAZ;
    Exit(False);
  end;

  Result := True;
end;

function TCariDetailViewModel.Kaydet: Boolean;
var
  Err: string;
begin
  Result := False;
  if not Validate(Err) then
  begin
    SetLastError(Err);
    Exit;
  end;

  IsBusy := True;
  try
    if FIsNew then
      FCari.Id := FRepo.Insert(FCari)
    else
      FRepo.Update(FCari);

    Result := True;
    NotifyDataChanged;
  finally
    IsBusy := False;
  end;
end;

end.
