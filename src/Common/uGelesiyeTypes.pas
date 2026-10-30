unit uGelesiyeTypes;

interface

uses
  System.SysUtils;

type
  // İşlem Türleri
  TIslemTuru = (itBorc, itTahsilat, itAlacak, itOdeme, itDevir);

  // Filtreleme Tipleri
  THesapDurumu = (hdTumu, hdAktif, hdPasif);
  TBakiyeFiltresi = (bfTumu, bfBorclular, bfAlacaklilar, bfBakiyesiArti, bfSifirBakiye, bfLimitAsanlar);
  TSorguTuru = (stUnvan, stCariKod);
  TAramaModu = (amYazildigiGibi, amIceren);

  // Finansal Bakiye ve Cari İstatistik Özeti
  TBakiyeOzet = record
    AktifBorcluToplam: Currency;
    AktifAlacakliToplam: Currency;
    PasifBorcluToplam: Currency;
    PasifAlacakliToplam: Currency;
    GenelBorcluToplam: Currency;
    GenelAlacakliToplam: Currency;
    NetBakiye: Currency;
    // Cari İstatistik Sayıları
    ToplamCariSayisi: Integer;
    AktifCariSayisi: Integer;
    PasifCariSayisi: Integer;
    BorcluCariSayisi: Integer;
    AlacakliCariSayisi: Integer;
    SifirBakiyeCariSayisi: Integer;
  end;

  // Cari Filtreleme Parametreleri
  TCariFiltre = record
    FirmaId: Integer;
    AramaMetni: string;
    SorguTuru: TSorguTuru;
    AramaModu: TAramaModu;
    HesapDurumu: THesapDurumu;
    BakiyeFiltresi: TBakiyeFiltresi;
  end;

// Yardımcı Dönüştürme Fonksiyonları
function IslemTuruToStr(const ATur: TIslemTuru): string;
function StrToIslemTuru(const AStr: string): TIslemTuru;
function FormatPara(const AValue: Currency; const AParaBirimi: string = 'TL'): string;

implementation

uses
  uGelesiyeConsts;

function IslemTuruToStr(const ATur: TIslemTuru): string;
begin
  case ATur of
    itBorc:      Result := STR_TUR_BORC_DEKONTU;
    itTahsilat:  Result := STR_TUR_TAHSILAT;
    itAlacak:    Result := STR_TUR_ALACAK_DEKONTU;
    itOdeme:     Result := STR_TUR_ODEME;
    itDevir:     Result := STR_TUR_DEVIR;
  else
    Result := STR_TUR_BORC_DEKONTU;
  end;
end;

function StrToIslemTuru(const AStr: string): TIslemTuru;
var
  S: string;
begin
  S := Trim(AStr);
  if SameText(S, STR_TUR_BORC_DEKONTU) or SameText(S, 'BORC') then
    Result := itBorc
  else if SameText(S, STR_TUR_TAHSILAT) or SameText(S, 'TAHSILAT') then
    Result := itTahsilat
  else if SameText(S, STR_TUR_ALACAK_DEKONTU) or SameText(S, 'ALACAK') then
    Result := itAlacak
  else if SameText(S, STR_TUR_ODEME) or SameText(S, 'ODEME') then
    Result := itOdeme
  else if SameText(S, STR_TUR_DEVIR) or SameText(S, 'DEVIR') then
    Result := itDevir
  else
    Result := itBorc;
end;

function FormatPara(const AValue: Currency; const AParaBirimi: string): string;
begin
  Result := FormatFloat('#,##0.00', AValue) + ' ' + AParaBirimi;
end;

end.
