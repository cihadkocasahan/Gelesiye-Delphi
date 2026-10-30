unit uGelesiyeEntities;

interface

uses
  System.SysUtils, System.Classes,
  uGelesiyeTypes, uGelesiyeInterfaces;

type
  // ===========================================================================
  // TFirma: Firma ve Dönem Bilgisi
  // ===========================================================================
  TFirma = class(TInterfacedObject, IFirma)
  private
    FId: Integer;
    FKod: string;
    FUnvan: string;
    FDonem: Integer;
    FParaBirimi: string;
    FIsDefault: Boolean;
    FBorcLimiti: Currency;
    FTelefon: string;
    FFaks: string;
    FAdres: string;
    FIl: string;
    FIlce: string;
    FVergiDairesi: string;
    FVergiNo: string;
  public
    constructor Create;
    function GetId: Integer; procedure SetId(const AValue: Integer);
    function GetKod: string; procedure SetKod(const AValue: string);
    function GetUnvan: string; procedure SetUnvan(const AValue: string);
    function GetDonem: Integer; procedure SetDonem(const AValue: Integer);
    function GetParaBirimi: string; procedure SetParaBirimi(const AValue: string);
    function GetIsDefault: Boolean; procedure SetIsDefault(const AValue: Boolean);
    function GetBorcLimiti: Currency; procedure SetBorcLimiti(const AValue: Currency);
    function GetTelefon: string; procedure SetTelefon(const AValue: string);
    function GetFaks: string; procedure SetFaks(const AValue: string);
    function GetAdres: string; procedure SetAdres(const AValue: string);
    function GetIl: string; procedure SetIl(const AValue: string);
    function GetIlce: string; procedure SetIlce(const AValue: string);
    function GetVergiDairesi: string; procedure SetVergiDairesi(const AValue: string);
    function GetVergiNo: string; procedure SetVergiNo(const AValue: string);
  end;

  // ===========================================================================
  // TCari: Müşteri / Tedarikçi Cari Kartı
  // ===========================================================================
  TCari = class(TInterfacedObject, ICari)
  private
    FId: Integer;
    FFirmaId: Integer;
    FCariKodu: string;
    FUnvan: string;
    FYetkili: string;
    FTelefon: string;
    FGsm: string;
    FFaks: string;
    FAdres: string;
    FIl: string;
    FIlce: string;
    FVergiDairesi: string;
    FVergiNo: string;
    FEposta: string;
    FWeb: string;
    FCariLimit: Currency;
    FHesapDurumu: THesapDurumu;
    FNotlar: string;
    FKayitTarihi: TDateTime;
    FSonIslemTarihi: TDateTime;
    FToplamBorc: Currency;
    FToplamAlacak: Currency;
    FBakiye: Currency;
  public
    constructor Create;
    function GetId: Integer; procedure SetId(const AValue: Integer);
    function GetFirmaId: Integer; procedure SetFirmaId(const AValue: Integer);
    function GetCariKodu: string; procedure SetCariKodu(const AValue: string);
    function GetUnvan: string; procedure SetUnvan(const AValue: string);
    function GetYetkili: string; procedure SetYetkili(const AValue: string);
    function GetTelefon: string; procedure SetTelefon(const AValue: string);
    function GetGsm: string; procedure SetGsm(const AValue: string);
    function GetFaks: string; procedure SetFaks(const AValue: string);
    function GetAdres: string; procedure SetAdres(const AValue: string);
    function GetIl: string; procedure SetIl(const AValue: string);
    function GetIlce: string; procedure SetIlce(const AValue: string);
    function GetVergiDairesi: string; procedure SetVergiDairesi(const AValue: string);
    function GetVergiNo: string; procedure SetVergiNo(const AValue: string);
    function GetEposta: string; procedure SetEposta(const AValue: string);
    function GetWeb: string; procedure SetWeb(const AValue: string);
    function GetCariLimit: Currency; procedure SetCariLimit(const AValue: Currency);
    function GetHesapDurumu: THesapDurumu; procedure SetHesapDurumu(const AValue: THesapDurumu);
    function GetNotlar: string; procedure SetNotlar(const AValue: string);
    function GetKayitTarihi: TDateTime; procedure SetKayitTarihi(const AValue: TDateTime);
    function GetSonIslemTarihi: TDateTime; procedure SetSonIslemTarihi(const AValue: TDateTime);
    function GetToplamBorc: Currency; procedure SetToplamBorc(const AValue: Currency);
    function GetToplamAlacak: Currency; procedure SetToplamAlacak(const AValue: Currency);
    function GetBakiye: Currency; procedure SetBakiye(const AValue: Currency);
  end;

  // ===========================================================================
  // OOP Kalıtım: THareket Taban Sınıfı ve Özelleşmiş Fiş/Dekont Alt Sınıfları
  // ===========================================================================
  THareketBase = class(TInterfacedObject, IHareket)
  protected
    FId: Integer;
    FFirmaId: Integer;
    FCariId: Integer;
    FCariUnvan: string;
    FTarih: TDateTime;
    FIslemTuru: TIslemTuru;
    FAciklama: string;
    FBorc: Currency;
    FAlacak: Currency;
    FYuruyenBakiye: Currency;
  public
    constructor Create; virtual;
    function GetId: Integer; procedure SetId(const AValue: Integer);
    function GetFirmaId: Integer; procedure SetFirmaId(const AValue: Integer);
    function GetCariId: Integer; procedure SetCariId(const AValue: Integer);
    function GetCariUnvan: string; procedure SetCariUnvan(const AValue: string);
    function GetTarih: TDateTime; procedure SetTarih(const AValue: TDateTime);
    function GetIslemTuru: TIslemTuru; procedure SetIslemTuru(const AValue: TIslemTuru);
    function GetAciklama: string; procedure SetAciklama(const AValue: string);
    function GetBorc: Currency; procedure SetBorc(const AValue: Currency);
    function GetAlacak: Currency; procedure SetAlacak(const AValue: Currency);
    function GetYuruyenBakiye: Currency; procedure SetYuruyenBakiye(const AValue: Currency);
  end;

  // F5: Hesaba Borç Ekle (Müşterinin borcunu artıran dekont)
  TBorcHareketi = class(THareketBase)
  public
    constructor Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime); reintroduce;
  end;

  // F6: Tahsilat Yap (Müşteriden tahsilat yapıldığında cariyi alacaklandıran fiş)
  TTahsilatHareketi = class(THareketBase)
  public
    constructor Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime); reintroduce;
  end;

  // F7: Hesaba Alacak Ekle (Alacak Dekontu)
  TAlacakHareketi = class(THareketBase)
  public
    constructor Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime); reintroduce;
  end;

  // F8: Ödeme Yap (Bizim cariye yaptığımız ödeme dekontu)
  TOdemeHareketi = class(THareketBase)
  public
    constructor Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime); reintroduce;
  end;

  // Yıl Sonu Devir Fişi
  TDevirHareketi = class(THareketBase)
  public
    constructor Create(const ACariId: Integer; const AKapanisBakiye: Currency; const AAciklama: string; const ATarih: TDateTime); reintroduce;
  end;

implementation

uses
  uGelesiyeConsts;

{ TFirma }

constructor TFirma.Create;
begin
  inherited Create;
  FId := 0;
  FDonem := DEF_DONEM_YILI;
  FParaBirimi := DEF_CURRENCY;
  FBorcLimiti := DEF_BORC_LIMITI;
  FIsDefault := False;
end;

function TFirma.GetId: Integer; begin Result := FId; end;
procedure TFirma.SetId(const AValue: Integer); begin FId := AValue; end;
function TFirma.GetKod: string; begin Result := FKod; end;
procedure TFirma.SetKod(const AValue: string); begin FKod := AValue; end;
function TFirma.GetUnvan: string; begin Result := FUnvan; end;
procedure TFirma.SetUnvan(const AValue: string); begin FUnvan := AValue; end;
function TFirma.GetDonem: Integer; begin Result := FDonem; end;
procedure TFirma.SetDonem(const AValue: Integer); begin FDonem := AValue; end;
function TFirma.GetParaBirimi: string; begin Result := FParaBirimi; end;
procedure TFirma.SetParaBirimi(const AValue: string); begin FParaBirimi := AValue; end;
function TFirma.GetIsDefault: Boolean; begin Result := FIsDefault; end;
procedure TFirma.SetIsDefault(const AValue: Boolean); begin FIsDefault := AValue; end;
function TFirma.GetBorcLimiti: Currency; begin Result := FBorcLimiti; end;
procedure TFirma.SetBorcLimiti(const AValue: Currency); begin FBorcLimiti := AValue; end;
function TFirma.GetTelefon: string; begin Result := FTelefon; end;
procedure TFirma.SetTelefon(const AValue: string); begin FTelefon := AValue; end;
function TFirma.GetFaks: string; begin Result := FFaks; end;
procedure TFirma.SetFaks(const AValue: string); begin FFaks := AValue; end;
function TFirma.GetAdres: string; begin Result := FAdres; end;
procedure TFirma.SetAdres(const AValue: string); begin FAdres := AValue; end;
function TFirma.GetIl: string; begin Result := FIl; end;
procedure TFirma.SetIl(const AValue: string); begin FIl := AValue; end;
function TFirma.GetIlce: string; begin Result := FIlce; end;
procedure TFirma.SetIlce(const AValue: string); begin FIlce := AValue; end;
function TFirma.GetVergiDairesi: string; begin Result := FVergiDairesi; end;
procedure TFirma.SetVergiDairesi(const AValue: string); begin FVergiDairesi := AValue; end;
function TFirma.GetVergiNo: string; begin Result := FVergiNo; end;
procedure TFirma.SetVergiNo(const AValue: string); begin FVergiNo := AValue; end;

{ TCari }

constructor TCari.Create;
begin
  inherited Create;
  FId := 0;
  FFirmaId := 0;
  FCariLimit := DEF_BORC_LIMITI;
  FHesapDurumu := hdAktif;
  FKayitTarihi := Date;
  FSonIslemTarihi := Date;
  FToplamBorc := 0;
  FToplamAlacak := 0;
  FBakiye := 0;
end;

function TCari.GetId: Integer; begin Result := FId; end;
procedure TCari.SetId(const AValue: Integer); begin FId := AValue; end;
function TCari.GetFirmaId: Integer; begin Result := FFirmaId; end;
procedure TCari.SetFirmaId(const AValue: Integer); begin FFirmaId := AValue; end;
function TCari.GetCariKodu: string; begin Result := FCariKodu; end;
procedure TCari.SetCariKodu(const AValue: string); begin FCariKodu := AValue; end;
function TCari.GetUnvan: string; begin Result := FUnvan; end;
procedure TCari.SetUnvan(const AValue: string); begin FUnvan := AValue; end;
function TCari.GetYetkili: string; begin Result := FYetkili; end;
procedure TCari.SetYetkili(const AValue: string); begin FYetkili := AValue; end;
function TCari.GetTelefon: string; begin Result := FTelefon; end;
procedure TCari.SetTelefon(const AValue: string); begin FTelefon := AValue; end;
function TCari.GetGsm: string; begin Result := FGsm; end;
procedure TCari.SetGsm(const AValue: string); begin FGsm := AValue; end;
function TCari.GetFaks: string; begin Result := FFaks; end;
procedure TCari.SetFaks(const AValue: string); begin FFaks := AValue; end;
function TCari.GetAdres: string; begin Result := FAdres; end;
procedure TCari.SetAdres(const AValue: string); begin FAdres := AValue; end;
function TCari.GetIl: string; begin Result := FIl; end;
procedure TCari.SetIl(const AValue: string); begin FIl := AValue; end;
function TCari.GetIlce: string; begin Result := FIlce; end;
procedure TCari.SetIlce(const AValue: string); begin FIlce := AValue; end;
function TCari.GetVergiDairesi: string; begin Result := FVergiDairesi; end;
procedure TCari.SetVergiDairesi(const AValue: string); begin FVergiDairesi := AValue; end;
function TCari.GetVergiNo: string; begin Result := FVergiNo; end;
procedure TCari.SetVergiNo(const AValue: string); begin FVergiNo := AValue; end;
function TCari.GetEposta: string; begin Result := FEposta; end;
procedure TCari.SetEposta(const AValue: string); begin FEposta := AValue; end;
function TCari.GetWeb: string; begin Result := FWeb; end;
procedure TCari.SetWeb(const AValue: string); begin FWeb := AValue; end;
function TCari.GetCariLimit: Currency; begin Result := FCariLimit; end;
procedure TCari.SetCariLimit(const AValue: Currency); begin FCariLimit := AValue; end;
function TCari.GetHesapDurumu: THesapDurumu; begin Result := FHesapDurumu; end;
procedure TCari.SetHesapDurumu(const AValue: THesapDurumu); begin FHesapDurumu := AValue; end;
function TCari.GetNotlar: string; begin Result := FNotlar; end;
procedure TCari.SetNotlar(const AValue: string); begin FNotlar := AValue; end;
function TCari.GetKayitTarihi: TDateTime; begin Result := FKayitTarihi; end;
procedure TCari.SetKayitTarihi(const AValue: TDateTime); begin FKayitTarihi := AValue; end;
function TCari.GetSonIslemTarihi: TDateTime; begin Result := FSonIslemTarihi; end;
procedure TCari.SetSonIslemTarihi(const AValue: TDateTime); begin FSonIslemTarihi := AValue; end;
function TCari.GetToplamBorc: Currency; begin Result := FToplamBorc; end;
procedure TCari.SetToplamBorc(const AValue: Currency); begin FToplamBorc := AValue; end;
function TCari.GetToplamAlacak: Currency; begin Result := FToplamAlacak; end;
procedure TCari.SetToplamAlacak(const AValue: Currency); begin FToplamAlacak := AValue; end;
function TCari.GetBakiye: Currency; begin Result := FBakiye; end;
procedure TCari.SetBakiye(const AValue: Currency); begin FBakiye := AValue; end;

{ THareketBase }

constructor THareketBase.Create;
begin
  inherited Create;
  FId := 0;
  FFirmaId := 0;
  FCariId := 0;
  FTarih := Now;
  FBorc := 0;
  FAlacak := 0;
  FYuruyenBakiye := 0;
end;

function THareketBase.GetId: Integer; begin Result := FId; end;
procedure THareketBase.SetId(const AValue: Integer); begin FId := AValue; end;
function THareketBase.GetFirmaId: Integer; begin Result := FFirmaId; end;
procedure THareketBase.SetFirmaId(const AValue: Integer); begin FFirmaId := AValue; end;
function THareketBase.GetCariId: Integer; begin Result := FCariId; end;
procedure THareketBase.SetCariId(const AValue: Integer); begin FCariId := AValue; end;
function THareketBase.GetCariUnvan: string; begin Result := FCariUnvan; end;
procedure THareketBase.SetCariUnvan(const AValue: string); begin FCariUnvan := AValue; end;
function THareketBase.GetTarih: TDateTime; begin Result := FTarih; end;
procedure THareketBase.SetTarih(const AValue: TDateTime); begin FTarih := AValue; end;
function THareketBase.GetIslemTuru: TIslemTuru; begin Result := FIslemTuru; end;
procedure THareketBase.SetIslemTuru(const AValue: TIslemTuru); begin FIslemTuru := AValue; end;
function THareketBase.GetAciklama: string; begin Result := FAciklama; end;
procedure THareketBase.SetAciklama(const AValue: string); begin FAciklama := AValue; end;
function THareketBase.GetBorc: Currency; begin Result := FBorc; end;
procedure THareketBase.SetBorc(const AValue: Currency); begin FBorc := AValue; end;
function THareketBase.GetAlacak: Currency; begin Result := FAlacak; end;
procedure THareketBase.SetAlacak(const AValue: Currency); begin FAlacak := AValue; end;
function THareketBase.GetYuruyenBakiye: Currency; begin Result := FYuruyenBakiye; end;
procedure THareketBase.SetYuruyenBakiye(const AValue: Currency); begin FYuruyenBakiye := AValue; end;

{ TBorcHareketi }

constructor TBorcHareketi.Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime);
begin
  inherited Create;
  FCariId := ACariId;
  FIslemTuru := itBorc;
  FBorc := ATutar;
  FAlacak := 0;
  FAciklama := AAciklama;
  FTarih := ATarih;
end;

{ TTahsilatHareketi }

constructor TTahsilatHareketi.Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime);
begin
  inherited Create;
  FCariId := ACariId;
  FIslemTuru := itTahsilat;
  FBorc := 0;
  FAlacak := ATutar;
  FAciklama := AAciklama;
  FTarih := ATarih;
end;

{ TAlacakHareketi }

constructor TAlacakHareketi.Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime);
begin
  inherited Create;
  FCariId := ACariId;
  FIslemTuru := itAlacak;
  FBorc := 0;
  FAlacak := ATutar;
  FAciklama := AAciklama;
  FTarih := ATarih;
end;

{ TOdemeHareketi }

constructor TOdemeHareketi.Create(const ACariId: Integer; const ATutar: Currency; const AAciklama: string; const ATarih: TDateTime);
begin
  inherited Create;
  FCariId := ACariId;
  FIslemTuru := itOdeme;
  FBorc := ATutar;
  FAlacak := 0;
  FAciklama := AAciklama;
  FTarih := ATarih;
end;

{ TDevirHareketi }

constructor TDevirHareketi.Create(const ACariId: Integer; const AKapanisBakiye: Currency; const AAciklama: string; const ATarih: TDateTime);
begin
  inherited Create;
  FCariId := ACariId;
  FIslemTuru := itDevir;
  FAciklama := AAciklama;
  FTarih := ATarih;
  if AKapanisBakiye >= 0 then
  begin
    FBorc := AKapanisBakiye;
    FAlacak := 0;
  end
  else
  begin
    FBorc := 0;
    FAlacak := -AKapanisBakiye;
  end;
end;

end.
