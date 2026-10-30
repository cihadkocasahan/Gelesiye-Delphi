unit uHareketViewModel;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uGelesiyeConsts, uGelesiyeTypes, uGelesiyeInterfaces, uGelesiyeEntities, uBaseViewModel;

type
  THareketViewModel = class(TBaseViewModel)
  private
    FRepo: IHareketRepository;
    FCariRepo: ICariRepository;
    FCari: ICari;
    FHareketler: TList<IHareket>;
    FToplamBorc: Currency;
    FToplamAlacak: Currency;
    FNetBakiye: Currency;
    procedure ClearHareketler;
    procedure HesaplaToplamlar;
  public
    constructor Create(AHareketRepo: IHareketRepository; ACariRepo: ICariRepository); reintroduce;
    destructor Destroy; override;

    procedure CariYukle(const ACariId: Integer);
    procedure Yenile;

    function BorcEkle(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
    function TahsilatYap(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
    function AlacakEkle(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
    function OdemeYap(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
    function HareketGuncelle(const AId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
    procedure HareketSil(const AId: Integer);
    function GetKayitSayisi: Integer;

    property Cari: ICari read FCari;
    property Hareketler: TList<IHareket> read FHareketler;
    property ToplamBorc: Currency read FToplamBorc;
    property ToplamAlacak: Currency read FToplamAlacak;
    property NetBakiye: Currency read FNetBakiye;
    property KayitSayisi: Integer read GetKayitSayisi;
  end;

implementation

{ THareketViewModel }

constructor THareketViewModel.Create(AHareketRepo: IHareketRepository; ACariRepo: ICariRepository);
begin
  inherited Create;
  FRepo := AHareketRepo;
  FCariRepo := ACariRepo;
  FHareketler := TList<IHareket>.Create;
  FCari := nil;
  FToplamBorc := 0;
  FToplamAlacak := 0;
  FNetBakiye := 0;
end;

destructor THareketViewModel.Destroy;
begin
  ClearHareketler;
  FHareketler.Free;
  inherited Destroy;
end;

procedure THareketViewModel.ClearHareketler;
begin
  FHareketler.Clear;
end;

procedure THareketViewModel.CariYukle(const ACariId: Integer);
begin
  FCari := FCariRepo.GetById(ACariId);
  Yenile;
end;

procedure THareketViewModel.Yenile;
var
  List: TList<IHareket>;
begin
  if FCari = nil then Exit;

  IsBusy := True;
  try
    ClearHareketler;
    List := FRepo.GetByCariId(FCari.Id);
    try
      FHareketler.AddRange(List);
    finally
      List.Free;
    end;
    HesaplaToplamlar;
    NotifyDataChanged;
  finally
    IsBusy := False;
  end;
end;

procedure THareketViewModel.HesaplaToplamlar;
var
  H: IHareket;
begin
  FToplamBorc := 0;
  FToplamAlacak := 0;
  for H in FHareketler do
  begin
    FToplamBorc := FToplamBorc + H.Borc;
    FToplamAlacak := FToplamAlacak + H.Alacak;
  end;
  FNetBakiye := FToplamBorc - FToplamAlacak;
end;

function THareketViewModel.BorcEkle(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
var
  H: IHareket;
begin
  Result := False;
  if (FCari = nil) or (ATutar <= 0) then Exit;

  // OOP Kalıtımlı TBorcHareketi
  H := TBorcHareketi.Create(FCari.Id, ATutar, AAciklama, ATarih);
  H.FirmaId := FCari.FirmaId;
  FRepo.Insert(H);
  Yenile;
  Result := True;
end;

function THareketViewModel.TahsilatYap(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
var
  H: IHareket;
begin
  Result := False;
  if (FCari = nil) or (ATutar <= 0) then Exit;

  // OOP Kalıtımlı TTahsilatHareketi
  H := TTahsilatHareketi.Create(FCari.Id, ATutar, AAciklama, ATarih);
  H.FirmaId := FCari.FirmaId;
  FRepo.Insert(H);
  Yenile;
  Result := True;
end;

function THareketViewModel.AlacakEkle(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
var
  H: IHareket;
begin
  Result := False;
  if (FCari = nil) or (ATutar <= 0) then Exit;

  // OOP Kalıtımlı TAlacakHareketi
  H := TAlacakHareketi.Create(FCari.Id, ATutar, AAciklama, ATarih);
  H.FirmaId := FCari.FirmaId;
  FRepo.Insert(H);
  Yenile;
  Result := True;
end;

function THareketViewModel.OdemeYap(const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
var
  H: IHareket;
begin
  Result := False;
  if (FCari = nil) or (ATutar <= 0) then Exit;

  // OOP Kalıtımlı TOdemeHareketi
  H := TOdemeHareketi.Create(FCari.Id, ATutar, AAciklama, ATarih);
  H.FirmaId := FCari.FirmaId;
  FRepo.Insert(H);
  Yenile;
  Result := True;
end;

function THareketViewModel.HareketGuncelle(const AId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime): Boolean;
var
  H, TargetH: IHareket;
begin
  Result := False;
  if (FCari = nil) or (ATutar <= 0) then Exit;

  TargetH := nil;
  for H in FHareketler do
  begin
    if H.Id = AId then
    begin
      TargetH := H;
      Break;
    end;
  end;

  if TargetH = nil then Exit;

  TargetH.Tarih := ATarih;
  TargetH.Aciklama := AAciklama;
  if TargetH.IslemTuru in [itBorc, itOdeme] then
    TargetH.Borc := ATutar
  else
    TargetH.Alacak := ATutar;

  FRepo.Update(TargetH);
  Yenile;
  Result := True;
end;

procedure THareketViewModel.HareketSil(const AId: Integer);
begin
  FRepo.Delete(AId);
  Yenile;
end;

function THareketViewModel.GetKayitSayisi: Integer;
begin
  Result := FHareketler.Count;
end;

end.
