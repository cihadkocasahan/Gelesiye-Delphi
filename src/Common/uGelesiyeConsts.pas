unit uGelesiyeConsts;

interface

const
  // Uygulama Kimlik Sabitleri
  APP_NAME              = 'Gelesiye';
  APP_TITLE             = 'Gelesiye — Basit Veresiye Takip';
  APP_DESCRIPTION       = 'Basit Veresiye Takip';

  // Veritabanı ve Tablo Sabitleri
  DEF_DB_NAME           = 'gelesiye.db';
  DEF_CURRENCY          = 'TL';
  DEF_BORC_LIMITI       = 10000.0;
  DEF_DONEM_YILI        = 2026;

  // İşlem Türü Tanımları (Gelesiye Standart)
  STR_TUR_BORC_DEKONTU  = 'Borç Dekontu';
  STR_TUR_TAHSILAT      = 'Tahsilat';
  STR_TUR_ALACAK_DEKONTU= 'Alacak Dekontu';
  STR_TUR_ODEME         = 'Ödeme';
  STR_TUR_DEVIR         = 'Devir Fişi';

  // Hesap Durumları
  STR_DURUM_AKTIF       = 'Aktif';
  STR_DURUM_PASIF       = 'Pasif';

  // Hata ve Bilgi Mesajları
  MSG_UNVAN_BOS_OLAMAZ  = 'Cari unvanı boş bırakılamaz!';
  MSG_KOD_BOS_OLAMAZ    = 'Cari kodu boş bırakılamaz!';
  MSG_TUTAR_SIFIR_OLAMAZ= 'İşlem tutarı 0''dan büyük olmalıdır!';
  MSG_SILME_ONAY        = 'Seçili kaydı silmek istediğinize emin misiniz?';
  MSG_DEVIR_BASARILI     = 'Yıl sonu devir işlemi başarıyla tamamlandı.';

  // Arayüz Renkleri (Zebra ve Giriş/Çıkış Vurguları)
  COLOR_ZEBRA_EVEN      = $00FFFFFF; // Beyaz
  COLOR_ZEBRA_ODD       = $00F6F8F9; // Açık ferah gri (Zebra)
  COLOR_BG_BORC         = $00E8ECFF; // Açık pastel kırmızı (Borç / Giriş arka planı)
  COLOR_BG_ALACAK       = $00EAF7EA; // Açık pastel yeşil (Tahsilat / Çıkış arka planı)
  COLOR_TEXT_BORC       = $001A1AD4; // Canlı kırmızı metin (Borç)
  COLOR_TEXT_ALACAK     = $001B5E20; // Canlı yeşil metin (Tahsilat / Alacak)
  COLOR_TEXT_ODEME      = $000D53B7; // Sıcak koyu ton (Ödeme)
  COLOR_TEXT_DEVIR      = $007B1FA2; // Mor ton (Devir)
  COLOR_BORCLU_RED      = $001A1AD4; // Kırmızımsı (Müşteri borçlu)
  COLOR_ALACAKLI_GREEN  = $001B5E20; // Yeşilimsi (Müşteri alacaklı)
  COLOR_SIFIR_BLACK     = $00212121;

  // Arayüz Başlık ve Pencere Renkleri (Modern SaaS / Clean White & Slate Paleti)
  COLOR_HEADER_MAIN         = 13795088;  // #107FD2 SayeUtility Kurumsal Canlı Mavi (Ana Pencere)
  COLOR_HEADER_MODAL        = $00FFFFFF; // #FFFFFF Modern Temiz Beyaz Kart Başlığı
  COLOR_HEADER_TEXT         = $000F172A; // #0F172A Koyu Antrasit / Slate-900 Başlık Metni
  COLOR_PANEL_BOTTOM        = $00FFFFFF; // #FFFFFF Saf Beyaz Alt Panel (Asla Pembe Değil)
  COLOR_BORDER_LIGHT        = $00E2E8F0; // #E2E8F0 1px İnce Ayırıcı Sınır Çizgisi
  COLOR_ACCENT_PRIMARY      = $00C78402; // #0284C7 Canlı Okyanus Mavisi (Primary Butonlar)

  // Dekont İşlem Metin Renkleri (fDekontEdit - Beyaz Zemin Üzerinde Net Vurgu)
  COLOR_HEADER_DEKONT_BORC  = $001E3A5F; // #1E3A5F Derin Lacivert (Borç Dekontu)
  COLOR_HEADER_DEKONT_TAHSIL= $0015803D; // #15803D Zümrüt Yeşili (Tahsilat - Para Girişi)
  COLOR_HEADER_DEKONT_ODEME = $00B91C1C; // #B91C1C Kırmızı / Bordo (Ödeme - Para Çıkışı)
  COLOR_HEADER_DEKONT_ALACAK= $004338CA; // #4338CA İndigo (Alacak Dekontu)
  COLOR_HEADER_DEKONT_DEVIR = $00334155; // #334155 Koyu Slate (Devir Fişi)

  // Diyalog Başlık ve İkon Renkleri (fDialog)
  COLOR_HEADER_DLG_INFO     = $00C78402; // #0284C7 Canlı Okyanus Mavisi
  COLOR_HEADER_DLG_CONFIRM  = $00C78402; // #0284C7 Canlı Mavi (İşlem Onayı)
  COLOR_HEADER_DLG_WARNING  = $000677D9; // #D97706 Sıcak Amber / Turuncu
  COLOR_HEADER_DLG_ERROR    = $002626DC; // #DC2626 Net Kırmızı

  // Durum Çubuğu Renkleri (fMain Status Bar)
  COLOR_STATUSBAR_BG        = $00F8FAFC; // #F8FAFC Slate-50 Zemin Dolgusu
  COLOR_STATUSBAR_BORDER    = $00E2E8F0; // #E2E8F0 Slate-200 Sınır ve Ayırıcı Çizgiler
  COLOR_STATUSBAR_TEXT_MAIN = $000F172A; // #0F172A Koyu Antrasit Başlık Metni
  COLOR_STATUSBAR_TEXT_MUTED= $00475569; // #475569 Slate-600 Sayaç / Ara Metin
  COLOR_STATUSBAR_TEXT_INFO = $0064748B; // #64748B Slate-500 Sürüm Bilgi Metni

implementation

end.
