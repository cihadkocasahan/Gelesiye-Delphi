unit uCariListViewModel;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uGelesiyeTypes, uGelesiyeInterfaces, uBaseViewModel;

type
  TCariListViewModel = class(TBaseViewModel)
  private
    FRepo: ICariRepository;
    FCariler: TList<ICari>;
    FFiltre: TCariFiltre;
    FSeciliIndex: Integer;
    procedure ClearCariler;
  public
    constructor Create(ARepo: ICariRepository); reintroduce;
    destructor Destroy; override;

    procedure Yenile(const AFirmaId: Integer);
    procedure AramaMetniDegisti(const AText: string);
    procedure SorguTuruDegisti(const ATur: TSorguTuru);
    procedure AramaModuDegisti(const AMod: TAramaModu);
    procedure HesapDurumuFiltresiDegisti(const ADurum: THesapDurumu);
    procedure BakiyeFiltresiDegisti(const AFiltre: TBakiyeFiltresi);

    function GetSeciliCari: ICari;
    procedure SetSeciliIndex(const AIndex: Integer);
    procedure SilSeciliCari;
    function GetListeToplamlari: TBakiyeOzet;
    function GetKayitSayisi: Integer;

    property Cariler: TList<ICari> read FCariler;
    property Filtre: TCariFiltre read FFiltre;
    property SeciliIndex: Integer read FSeciliIndex write SetSeciliIndex;
    property KayitSayisi: Integer read GetKayitSayisi;
  end;

implementation

{ TCariListViewModel }

constructor TCariListViewModel.Create(ARepo: ICariRepository);
begin
  inherited Create;
  FRepo := ARepo;
  FCariler := TList<ICari>.Create;
  FSeciliIndex := -1;

  FFiltre.FirmaId := 1;
  FFiltre.AramaMetni := '';
  FFiltre.SorguTuru := stUnvan;
  FFiltre.AramaModu := amYazildigiGibi;
  FFiltre.HesapDurumu := hdTumu;
  FFiltre.BakiyeFiltresi := bfTumu;
end;

destructor TCariListViewModel.Destroy;
begin
  ClearCariler;
  FCariler.Free;
  inherited Destroy;
end;

procedure TCariListViewModel.ClearCariler;
begin
  FCariler.Clear;
end;

procedure TCariListViewModel.Yenile(const AFirmaId: Integer);
var
  NewList: TList<ICari>;
begin
  IsBusy := True;
  try
    FFiltre.FirmaId := AFirmaId;
    ClearCariler;
    NewList := FRepo.GetAll(FFiltre);
    try
      FCariler.AddRange(NewList);
    finally
      NewList.Free;
    end;

    if (FSeciliIndex < 0) or (FSeciliIndex >= FCariler.Count) then
    begin
      if FCariler.Count > 0 then
        FSeciliIndex := 0
      else
        FSeciliIndex := -1;
    end;

    NotifyDataChanged;
  finally
    IsBusy := False;
  end;
end;

procedure TCariListViewModel.AramaMetniDegisti(const AText: string);
begin
  FFiltre.AramaMetni := AText;
  Yenile(FFiltre.FirmaId);
end;

procedure TCariListViewModel.SorguTuruDegisti(const ATur: TSorguTuru);
begin
  FFiltre.SorguTuru := ATur;
  Yenile(FFiltre.FirmaId);
end;

procedure TCariListViewModel.AramaModuDegisti(const AMod: TAramaModu);
begin
  FFiltre.AramaModu := AMod;
  Yenile(FFiltre.FirmaId);
end;

procedure TCariListViewModel.HesapDurumuFiltresiDegisti(const ADurum: THesapDurumu);
begin
  FFiltre.HesapDurumu := ADurum;
  Yenile(FFiltre.FirmaId);
end;

procedure TCariListViewModel.BakiyeFiltresiDegisti(const AFiltre: TBakiyeFiltresi);
begin
  FFiltre.BakiyeFiltresi := AFiltre;
  Yenile(FFiltre.FirmaId);
end;

function TCariListViewModel.GetSeciliCari: ICari;
begin
  if (FSeciliIndex >= 0) and (FSeciliIndex < FCariler.Count) then
    Result := FCariler[FSeciliIndex]
  else
    Result := nil;
end;

procedure TCariListViewModel.SetSeciliIndex(const AIndex: Integer);
begin
  FSeciliIndex := AIndex;
end;

procedure TCariListViewModel.SilSeciliCari;
var
  Cari: ICari;
begin
  Cari := GetSeciliCari;
  if Cari <> nil then
  begin
    FRepo.Delete(Cari.Id);
    Yenile(FFiltre.FirmaId);
  end;
end;

function TCariListViewModel.GetListeToplamlari: TBakiyeOzet;
begin
  Result := FRepo.GetBakiyeOzet(FFiltre.FirmaId);
end;

function TCariListViewModel.GetKayitSayisi: Integer;
begin
  Result := FCariler.Count;
end;

end.
