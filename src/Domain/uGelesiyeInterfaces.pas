unit uGelesiyeInterfaces;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uGelesiyeTypes;

type
  // İleri Bildirimler
  ICari = interface;
  IHareket = interface;
  IFirma = interface;

  // 1. Veritabanı Bağlantı ve Transaction Arayüzü (DB-Agnostic)
  IDbConnection = interface
    ['{B4A1D2E3-7890-4A1B-8C9D-E0F1A2B3C4D5}']
    procedure Connect;
    procedure Disconnect;
    function IsConnected: Boolean;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function GetDriverName: string;
  end;

  // 2. Firma Varlık Arayüzü
  IFirma = interface
    ['{F1E2D3C4-B5A6-4789-9012-3456789ABCDE}']
    function GetId: Integer;
    procedure SetId(const AValue: Integer);
    function GetKod: string;
    procedure SetKod(const AValue: string);
    function GetUnvan: string;
    procedure SetUnvan(const AValue: string);
    function GetDonem: Integer;
    procedure SetDonem(const AValue: Integer);
    function GetParaBirimi: string;
    procedure SetParaBirimi(const AValue: string);
    function GetIsDefault: Boolean;
    procedure SetIsDefault(const AValue: Boolean);
    function GetBorcLimiti: Currency;
    procedure SetBorcLimiti(const AValue: Currency);
    function GetTelefon: string;
    procedure SetTelefon(const AValue: string);
    function GetFaks: string;
    procedure SetFaks(const AValue: string);
    function GetAdres: string;
    procedure SetAdres(const AValue: string);
    function GetIl: string;
    procedure SetIl(const AValue: string);
    function GetIlce: string;
    procedure SetIlce(const AValue: string);
    function GetVergiDairesi: string;
    procedure SetVergiDairesi(const AValue: string);
    function GetVergiNo: string;
    procedure SetVergiNo(const AValue: string);

    property Id: Integer read GetId write SetId;
    property Kod: string read GetKod write SetKod;
    property Unvan: string read GetUnvan write SetUnvan;
    property Donem: Integer read GetDonem write SetDonem;
    property ParaBirimi: string read GetParaBirimi write SetParaBirimi;
    property IsDefault: Boolean read GetIsDefault write SetIsDefault;
    property BorcLimiti: Currency read GetBorcLimiti write SetBorcLimiti;
    property Telefon: string read GetTelefon write SetTelefon;
    property Faks: string read GetFaks write SetFaks;
    property Adres: string read GetAdres write SetAdres;
    property Il: string read GetIl write SetIl;
    property Ilce: string read GetIlce write SetIlce;
    property VergiDairesi: string read GetVergiDairesi write SetVergiDairesi;
    property VergiNo: string read GetVergiNo write SetVergiNo;
  end;

  // 3. Cari Varlık Arayüzü
  ICari = interface
    ['{A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D}']
    function GetId: Integer;
    procedure SetId(const AValue: Integer);
    function GetFirmaId: Integer;
    procedure SetFirmaId(const AValue: Integer);
    function GetCariKodu: string;
    procedure SetCariKodu(const AValue: string);
    function GetUnvan: string;
    procedure SetUnvan(const AValue: string);
    function GetYetkili: string;
    procedure SetYetkili(const AValue: string);
    function GetTelefon: string;
    procedure SetTelefon(const AValue: string);
    function GetGsm: string;
    procedure SetGsm(const AValue: string);
    function GetFaks: string;
    procedure SetFaks(const AValue: string);
    function GetAdres: string;
    procedure SetAdres(const AValue: string);
    function GetIl: string;
    procedure SetIl(const AValue: string);
    function GetIlce: string;
    procedure SetIlce(const AValue: string);
    function GetVergiDairesi: string;
    procedure SetVergiDairesi(const AValue: string);
    function GetVergiNo: string;
    procedure SetVergiNo(const AValue: string);
    function GetEposta: string;
    procedure SetEposta(const AValue: string);
    function GetWeb: string;
    procedure SetWeb(const AValue: string);
    function GetCariLimit: Currency;
    procedure SetCariLimit(const AValue: Currency);
    function GetHesapDurumu: THesapDurumu;
    procedure SetHesapDurumu(const AValue: THesapDurumu);
    function GetNotlar: string;
    procedure SetNotlar(const AValue: string);
    function GetKayitTarihi: TDateTime;
    procedure SetKayitTarihi(const AValue: TDateTime);
    function GetSonIslemTarihi: TDateTime;
    procedure SetSonIslemTarihi(const AValue: TDateTime);
    function GetToplamBorc: Currency;
    procedure SetToplamBorc(const AValue: Currency);
    function GetToplamAlacak: Currency;
    procedure SetToplamAlacak(const AValue: Currency);
    function GetBakiye: Currency;
    procedure SetBakiye(const AValue: Currency);

    property Id: Integer read GetId write SetId;
    property FirmaId: Integer read GetFirmaId write SetFirmaId;
    property CariKodu: string read GetCariKodu write SetCariKodu;
    property Unvan: string read GetUnvan write SetUnvan;
    property Yetkili: string read GetYetkili write SetYetkili;
    property Telefon: string read GetTelefon write SetTelefon;
    property Gsm: string read GetGsm write SetGsm;
    property Faks: string read GetFaks write SetFaks;
    property Adres: string read GetAdres write SetAdres;
    property Il: string read GetIl write SetIl;
    property Ilce: string read GetIlce write SetIlce;
    property VergiDairesi: string read GetVergiDairesi write SetVergiDairesi;
    property VergiNo: string read GetVergiNo write SetVergiNo;
    property Eposta: string read GetEposta write SetEposta;
    property Web: string read GetWeb write SetWeb;
    property CariLimit: Currency read GetCariLimit write SetCariLimit;
    property HesapDurumu: THesapDurumu read GetHesapDurumu write SetHesapDurumu;
    property Notlar: string read GetNotlar write SetNotlar;
    property KayitTarihi: TDateTime read GetKayitTarihi write SetKayitTarihi;
    property SonIslemTarihi: TDateTime read GetSonIslemTarihi write SetSonIslemTarihi;
    property ToplamBorc: Currency read GetToplamBorc write SetToplamBorc;
    property ToplamAlacak: Currency read GetToplamAlacak write SetToplamAlacak;
    property Bakiye: Currency read GetBakiye write SetBakiye;
  end;

  // 4. Cari Hareket Varlık Arayüzü
  IHareket = interface
    ['{B2C3D4E5-F6A7-4B8C-9D0E-1F2A3B4C5D6E}']
    function GetId: Integer;
    procedure SetId(const AValue: Integer);
    function GetFirmaId: Integer;
    procedure SetFirmaId(const AValue: Integer);
    function GetCariId: Integer;
    procedure SetCariId(const AValue: Integer);
    function GetCariUnvan: string;
    procedure SetCariUnvan(const AValue: string);
    function GetTarih: TDateTime;
    procedure SetTarih(const AValue: TDateTime);
    function GetIslemTuru: TIslemTuru;
    procedure SetIslemTuru(const AValue: TIslemTuru);
    function GetAciklama: string;
    procedure SetAciklama(const AValue: string);
    function GetBorc: Currency;
    procedure SetBorc(const AValue: Currency);
    function GetAlacak: Currency;
    procedure SetAlacak(const AValue: Currency);
    function GetYuruyenBakiye: Currency;
    procedure SetYuruyenBakiye(const AValue: Currency);

    property Id: Integer read GetId write SetId;
    property FirmaId: Integer read GetFirmaId write SetFirmaId;
    property CariId: Integer read GetCariId write SetCariId;
    property CariUnvan: string read GetCariUnvan write SetCariUnvan;
    property Tarih: TDateTime read GetTarih write SetTarih;
    property IslemTuru: TIslemTuru read GetIslemTuru write SetIslemTuru;
    property Aciklama: string read GetAciklama write SetAciklama;
    property Borc: Currency read GetBorc write SetBorc;
    property Alacak: Currency read GetAlacak write SetAlacak;
    property YuruyenBakiye: Currency read GetYuruyenBakiye write SetYuruyenBakiye;
  end;

  // 5. Repository Arayüzleri
  IFirmaRepository = interface
    ['{D3E4F5A6-B7C8-4D9E-0F1A-2B3C4D5E6F7A}']
    function GetAll: TList<IFirma>;
    function GetById(const AId: Integer): IFirma;
    function GetDefault: IFirma;
    procedure SetDefault(const AId: Integer);
    function Insert(const AFirma: IFirma): Integer;
    procedure Update(const AFirma: IFirma);
    procedure Delete(const AId: Integer);
    function DevirYap(const AEskiFirmaId, AYeniFirmaId: Integer; const AAktarAciklamalar: Boolean): Boolean;
  end;

  ICariRepository = interface
    ['{E4F5A6B7-C8D9-4E0F-1A2B-3C4D5E6F7A8B}']
    function GetAll(const AFiltre: TCariFiltre): TList<ICari>;
    function GetById(const AId: Integer): ICari;
    function Insert(const ACari: ICari): Integer;
    procedure Update(const ACari: ICari);
    procedure Delete(const AId: Integer);
    function GetNextCariKodu(const AFirmaId: Integer): string;
    function GetBakiyeOzet(const AFirmaId: Integer): TBakiyeOzet;
  end;

  IHareketRepository = interface
    ['{F5A6B7C8-D9E0-4F1A-2B3C-4D5E6F7A8B9C}']
    function GetByCariId(const ACariId: Integer): TList<IHareket>;
    function Insert(const AHareket: IHareket): Integer;
    procedure Update(const AHareket: IHareket);
    procedure Delete(const AId: Integer);
    function GetGenelHareketler(const AFirmaId: Integer; const ABasTarih, ABitTarih: TDateTime;
      const ATur: Integer): TList<IHareket>;
  end;

  IAyarlarRepository = interface
    ['{C7D8E9F0-1A2B-3C4D-5E6F-7A8B9C0D1E2F}']
    function GetAyar(const AAnahtar: string; const AVarsayilan: string = ''): string;
    procedure SetAyar(const AAnahtar, ADeger: string);
    function GetAciklamalar(const AIslemTuru: Integer): TList<string>;
    procedure AddAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure DeleteAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure ClearAciklamalar(const AIslemTuru: Integer);
  end;

  IIlIlceRepository = interface
    ['{A1B2C3D4-E5F6-4A5B-8C7D-9E0F1A2B3C4D}']
    function GetIller: TList<string>;
    function GetIlceler(const AIlAdi: string): TList<string>;
  end;

implementation

end.

