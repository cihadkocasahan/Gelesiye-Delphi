unit uGelesiyeLang;

interface

uses
  System.SysUtils, System.Classes;

type
  TAppLanguage = (langTR, langEN);

  TLangKey = (
    // İşlem Türleri
    lkTurBorcDekontu,
    lkTurTahsilat,
    lkTurAlacakDekontu,
    lkTurOdeme,
    lkTurDevirFisi,

    // Hesap Durumları
    lkDurumAktif,
    lkDurumPasif,

    // Doğrulama ve Uyarı Mesajları
    lkMsgUnvanBosOlamaz,
    lkMsgKodBosOlamaz,
    lkMsgTutarSifirOlamaz,
    lkMsgSilmeOnay,
    lkMsgDevirBasarili,

    // Standart Butonlar
    lkBtnKaydet,
    lkBtnVazgec,
    lkBtnKapat,
    lkBtnSil,
    lkBtnYeni,
    lkBtnDegistir,
    lkBtnHareketler,
    lkBtnEvet,
    lkBtnIptal,

    // Form Başlıkları
    lkTitleCariKartEkle,
    lkTitleCariKartDuzenle,
    lkTitleAyarlar,
    lkTitleListeToplamlari,
    lkTitleGuvenlikDogrulamasi,
    lkTitleFirmaBilgileri,

    // Diyalog Başlıkları
    lkDlgBilgilendirme,
    lkDlgIslemOnayi,
    lkDlgUyari,
    lkDlgHata,

    // Durum Çubuğu
    lkStatusCariListe,
    lkStatusHareketler,
    lkStatusKayit,
    lkStatusHareket
  );

  TLangChangeEvent = procedure(ALang: TAppLanguage) of object;

  TLangManager = class
  private
    class var FCurrentLang: TAppLanguage;
    class var FStrings: array[TLangKey] of string;
    class var FOnLangChanged: TLangChangeEvent;
    class procedure LoadTR; static;
    class procedure LoadEN; static;
  public
    class constructor Create;
    class procedure SetLanguage(const ALang: TAppLanguage); static;
    class function Get(const AKey: TLangKey): string; static; inline;
    class function FormatStr(const AKey: TLangKey; const Args: array of const): string; static;
    class property CurrentLanguage: TAppLanguage read FCurrentLang;
    class property OnLangChanged: TLangChangeEvent read FOnLangChanged write FOnLangChanged;
  end;

// Global i18n yardımcı fonksiyonları
function _T(const AKey: TLangKey): string; inline;
function _TFmt(const AKey: TLangKey; const Args: array of const): string;

implementation

function _T(const AKey: TLangKey): string;
begin
  Result := TLangManager.Get(AKey);
end;

function _TFmt(const AKey: TLangKey; const Args: array of const): string;
begin
  Result := TLangManager.FormatStr(AKey, Args);
end;

{ TLangManager }

class constructor TLangManager.Create;
begin
  SetLanguage(langTR);
end;

class procedure TLangManager.LoadTR;
begin
  FStrings[lkTurBorcDekontu]          := 'Borç Dekontu';
  FStrings[lkTurTahsilat]             := 'Tahsilat';
  FStrings[lkTurAlacakDekontu]        := 'Alacak Dekontu';
  FStrings[lkTurOdeme]                := 'Ödeme';
  FStrings[lkTurDevirFisi]            := 'Devir Fişi';

  FStrings[lkDurumAktif]              := 'Aktif';
  FStrings[lkDurumPasif]              := 'Pasif';

  FStrings[lkMsgUnvanBosOlamaz]       := 'Cari unvanı boş bırakılamaz!';
  FStrings[lkMsgKodBosOlamaz]         := 'Cari kodu boş bırakılamaz!';
  FStrings[lkMsgTutarSifirOlamaz]     := 'İşlem tutarı 0''dan büyük olmalıdır!';
  FStrings[lkMsgSilmeOnay]            := 'Seçili kaydı silmek istediğinize emin misiniz?';
  FStrings[lkMsgDevirBasarili]        := 'Yıl sonu devir işlemi başarıyla tamamlandı.';

  FStrings[lkBtnKaydet]               := 'Kaydet';
  FStrings[lkBtnVazgec]               := 'Vazgeç';
  FStrings[lkBtnKapat]                := 'Kapat';
  FStrings[lkBtnSil]                  := 'Sil';
  FStrings[lkBtnYeni]                 := 'Yeni';
  FStrings[lkBtnDegistir]             := 'Değiştir';
  FStrings[lkBtnHareketler]            := 'Hareketler';
  FStrings[lkBtnEvet]                 := 'Evet';
  FStrings[lkBtnIptal]                := 'İptal';

  FStrings[lkTitleCariKartEkle]       := 'Cari Kart Ekle';
  FStrings[lkTitleCariKartDuzenle]    := 'Cari Kart Düzenle';
  FStrings[lkTitleAyarlar]            := 'Ayarlar';
  FStrings[lkTitleListeToplamlari]    := 'Liste Toplamları';
  FStrings[lkTitleGuvenlikDogrulamasi]:= 'Gelesiye Güvenlik Doğrulaması';
  FStrings[lkTitleFirmaBilgileri]     := 'Firma Bilgileri';

  FStrings[lkDlgBilgilendirme]        := 'Bilgilendirme';
  FStrings[lkDlgIslemOnayi]           := 'İşlem Onayı';
  FStrings[lkDlgUyari]                := 'Dikkat / Uyarı';
  FStrings[lkDlgHata]                 := 'Hata Oluştu';

  FStrings[lkStatusCariListe]         := '📋 Cari Liste';
  FStrings[lkStatusHareketler]        := '📊 Hareketler';
  FStrings[lkStatusKayit]             := 'kayıt';
  FStrings[lkStatusHareket]           := 'hareket';
end;

class procedure TLangManager.LoadEN;
begin
  FStrings[lkTurBorcDekontu]          := 'Debit Voucher';
  FStrings[lkTurTahsilat]             := 'Collection';
  FStrings[lkTurAlacakDekontu]        := 'Credit Voucher';
  FStrings[lkTurOdeme]                := 'Payment';
  FStrings[lkTurDevirFisi]            := 'Transfer Slip';

  FStrings[lkDurumAktif]              := 'Active';
  FStrings[lkDurumPasif]              := 'Passive';

  FStrings[lkMsgUnvanBosOlamaz]       := 'Account title cannot be empty!';
  FStrings[lkMsgKodBosOlamaz]         := 'Account code cannot be empty!';
  FStrings[lkMsgTutarSifirOlamaz]     := 'Amount must be greater than zero!';
  FStrings[lkMsgSilmeOnay]            := 'Are you sure you want to delete the selected record?';
  FStrings[lkMsgDevirBasarili]        := 'Year-end balance transfer completed successfully.';

  FStrings[lkBtnKaydet]               := 'Save';
  FStrings[lkBtnVazgec]               := 'Cancel';
  FStrings[lkBtnKapat]                := 'Close';
  FStrings[lkBtnSil]                  := 'Delete';
  FStrings[lkBtnYeni]                 := 'New';
  FStrings[lkBtnDegistir]             := 'Edit';
  FStrings[lkBtnHareketler]            := 'Transactions';
  FStrings[lkBtnEvet]                 := 'Yes';
  FStrings[lkBtnIptal]                := 'Cancel';

  FStrings[lkTitleCariKartEkle]       := 'Add Account';
  FStrings[lkTitleCariKartDuzenle]    := 'Edit Account';
  FStrings[lkTitleAyarlar]            := 'Settings';
  FStrings[lkTitleListeToplamlari]    := 'List Totals';
  FStrings[lkTitleGuvenlikDogrulamasi]:= 'Security Verification';
  FStrings[lkTitleFirmaBilgileri]     := 'Company Info';

  FStrings[lkDlgBilgilendirme]        := 'Information';
  FStrings[lkDlgIslemOnayi]           := 'Confirmation';
  FStrings[lkDlgUyari]                := 'Warning';
  FStrings[lkDlgHata]                 := 'Error';

  FStrings[lkStatusCariListe]         := '📋 Account List';
  FStrings[lkStatusHareketler]        := '📊 Transactions';
  FStrings[lkStatusKayit]             := 'records';
  FStrings[lkStatusHareket]           := 'transactions';
end;

class procedure TLangManager.SetLanguage(const ALang: TAppLanguage);
begin
  FCurrentLang := ALang;
  case ALang of
    langTR: LoadTR;
    langEN: LoadEN;
  end;

  if Assigned(FOnLangChanged) then
    FOnLangChanged(FCurrentLang);
end;

class function TLangManager.Get(const AKey: TLangKey): string;
begin
  Result := FStrings[AKey];
end;

class function TLangManager.FormatStr(const AKey: TLangKey; const Args: array of const): string;
begin
  Result := Format(FStrings[AKey], Args);
end;

end.
