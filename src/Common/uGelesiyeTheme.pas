unit uGelesiyeTheme;

interface

uses
  Vcl.Graphics, System.Classes, System.SysUtils;

type
  TAppTheme = (thLight, thDark);

  TThemeColors = record
    // ── Header & Başlık Renkleri ──────────────────────────────────────────────
    HeaderMain: TColor;          // Ana pencere başlık çubuğu (kurumsal mavi)
    HeaderModal: TColor;         // Modal/dialog başlık paneli
    HeaderModalText: TColor;     // Modal başlık yazı rengi
    PanelBottom: TColor;         // Alt buton paneli
    HeaderDekontBorc: TColor;
    HeaderDekontTahsil: TColor;
    HeaderDekontOdeme: TColor;
    HeaderDekontAlacak: TColor;
    HeaderDekontDevir: TColor;

    // ── Diyalog Renkleri (fDialog) ────────────────────────────────────────────
    DlgInfo: TColor;
    DlgConfirm: TColor;
    DlgWarning: TColor;
    DlgError: TColor;

    // ── Durum Çubuğu (Status Bar) ─────────────────────────────────────────────
    StatusBg: TColor;
    StatusBorder: TColor;
    StatusTextMain: TColor;
    StatusTextMuted: TColor;
    StatusTextInfo: TColor;

    // ── Zebra Grid & Liste Vurguları ──────────────────────────────────────────
    ZebraEven: TColor;
    ZebraOdd: TColor;
    BgBorc: TColor;
    BgAlacak: TColor;
    TextBorc: TColor;
    TextAlacak: TColor;
    TextOdeme: TColor;
    TextDevir: TColor;
    BorcluRed: TColor;
    AlacakliGreen: TColor;
    SifirBlack: TColor;

    // ── Genel Kart & Zemin ────────────────────────────────────────────────────
    FormBg: TColor;              // #F1F5F9  Slate-100 yumuşak zemin
    CardBg: TColor;              // #FFFFFF  Saf beyaz kart zemini
    BorderColor: TColor;         // #E2E8F0  Slate-200 ince ayırıcı çizgi
    CloseBtnText: TColor;        // X buton rengi
    AccentPrimary: TColor;       // Birincil aksan rengi (mavi)
    CardSelectedBorder: TColor;  // Seçili kart kenarlığı

    // ── Rozet (Badge) ─────────────────────────────────────────────────────────
    BadgeFreeBg: TColor;         // FREE rozeti arka plan
    BadgeFreeText: TColor;       // FREE rozeti metin
    BadgeProBg: TColor;          // PRO rozeti arka plan (mavi)
    BadgeProText: TColor;        // PRO rozeti metin (beyaz)
    BadgeCurrentBg: TColor;      // Current rozeti arka plan (yeşil)
    BadgeCurrentText: TColor;    // Current rozeti metin (beyaz)

    // ── İlerleme Çubuğu (Progress Bar) ───────────────────────────────────────
    ProgressTrack: TColor;       // Bar arka planı (boş kısım)
    ProgressHigh: TColor;        // Dolu / yüksek — yeşil
    ProgressLow: TColor;         // Düşük / uyarı — kırmızı/turuncu

    // ── Bildirim Şeridi ───────────────────────────────────────────────────────
    NotifyBg: TColor;            // Info şerit arka planı #EFF6FF
    NotifyBorder: TColor;        // Info şerit kenarlığı #BFDBFE
    NotifyText: TColor;          // Info şerit metin rengi

    // ── Toggle / Switch ───────────────────────────────────────────────────────
    ToggleOnBg: TColor;          // Açık (ON) switch — mavi
    ToggleOffBg: TColor;         // Kapalı (OFF) switch — gri

    // ── Sekme (Tab) ───────────────────────────────────────────────────────────
    TabActiveBg: TColor;         // Aktif sekme arka planı #EFF6FF
    TabActiveText: TColor;       // Aktif sekme metin rengi #2563EB

    // ── Modal ─────────────────────────────────────────────────────────────────
    ModalInputBorder: TColor;    // Input alan kenarlığı
    ModalInfoBg: TColor;         // Öneri/bilgi kutusu arka planı #F8FAFC
  end;

  TThemeChangeEvent = procedure(ATheme: TAppTheme; const AColors: TThemeColors) of object;

  TAppThemeManager = class
  private
    class var FCurrentTheme: TAppTheme;
    class var FColors: TThemeColors;
    class var FOnThemeChanged: TThemeChangeEvent;
    class procedure LoadLightTheme; static;
    class procedure LoadDarkTheme; static;
  public
    class constructor Create;
    class procedure SetTheme(const ATheme: TAppTheme); static;
    class property CurrentTheme: TAppTheme read FCurrentTheme;
    class property Colors: TThemeColors read FColors;
    class property OnThemeChanged: TThemeChangeEvent read FOnThemeChanged write FOnThemeChanged;
  end;

// Kolay erişim kısayolu
function Theme: TThemeColors; inline;

implementation

function Theme: TThemeColors;
begin
  Result := TAppThemeManager.Colors;
end;

{ TAppThemeManager }

class constructor TAppThemeManager.Create;
begin
  SetTheme(thLight);
end;

class procedure TAppThemeManager.LoadLightTheme;
begin
  // ── Aydınlık Modern Tema (Cockpit Tools Paleti) ───────────────────────────
  // Ana mavi aksan: #2563EB  |  Zemin: #F1F5F9  |  Kart: #FFFFFF

  // Header
  FColors.HeaderMain          := 13795088;   // #107FD2 SayeUtility Kurumsal Mavi (Ana Pencere)
  FColors.HeaderModal         := 13795088;      // #107FD2 SayeUtility Kurumsal Mavi (Modal & Dialog Başlık Paneli)
  FColors.HeaderModalText     := clWhite;        // Beyaz — renkli/koyu panel üzeri
  FColors.PanelBottom         := clWhite;        // #FFFFFF Saf Beyaz Alt Panel

  FColors.HeaderDekontBorc    := $001E3A5F;  // #1E3A5F Derin Lacivert
  FColors.HeaderDekontTahsil  := $0015803D;  // #15803D Zümrüt Yeşili
  FColors.HeaderDekontOdeme   := $00B91C1C;  // #B91C1C Kırmızı / Bordo
  FColors.HeaderDekontAlacak  := $004338CA;  // #4338CA İndigo
  FColors.HeaderDekontDevir   := $00334155;  // #334155 Koyu Slate

  // Diyaloglar
  FColors.DlgInfo             := $00EB6325;  // #2563EB Canlı Mavi
  FColors.DlgConfirm          := $00EB6325;  // #2563EB Canlı Mavi
  FColors.DlgWarning          := $001673F9;  // #F97316 Sıcak Turuncu
  FColors.DlgError            := $004444EF;  // #EF4444 Net Kırmızı

  // Status Bar
  FColors.StatusBg            := $00FCFAF8;  // #F8FAFC Slate-50
  FColors.StatusBorder        := $00F0E8E2;  // #E2E8F0 Slate-200
  FColors.StatusTextMain      := $002A170F;  // #0F172A Koyu Antrasit
  FColors.StatusTextMuted     := $008B7464;  // #64748B Slate-500
  FColors.StatusTextInfo      := $00B8A394;  // #94A3B8 Slate-400

  // Zebra Grid & Liste
  FColors.ZebraEven           := $00FFFFFF;
  FColors.ZebraOdd            := $00F9F5F1;  // #F1F5F9 Slate-100
  FColors.BgBorc              := $00FFE8E8;  // Pastel kırmızı arka plan
  FColors.BgAlacak            := $00EAFAEA;  // Pastel yeşil arka plan
  FColors.TextBorc            := $001A1AD4;
  FColors.TextAlacak          := $001B5E20;
  FColors.TextOdeme           := $000D53B7;
  FColors.TextDevir           := $007B1FA2;
  FColors.BorcluRed           := $001A1AD4;
  FColors.AlacakliGreen       := $001B5E20;
  FColors.SifirBlack          := $00212121;

  // Genel Kart & Zemin
  FColors.FormBg              := $00F9F5F1;  // #F1F5F9 Slate-100 yumuşak zemin
  FColors.CardBg              := clWhite;    // #FFFFFF Saf Beyaz Kart
  FColors.BorderColor         := $00F0E8E2;  // #E2E8F0 Slate-200 ince ayırıcı
  FColors.CloseBtnText        := $008B7464;  // #64748B Slate-500
  FColors.AccentPrimary       := $00EB6325;  // #2563EB Canlı Okyanus Mavisi
  FColors.CardSelectedBorder  := $00E8D2C7;  // #C7D2E8 Seçili kart mavi kenarlığı

  // Rozet (Badge)
  FColors.BadgeFreeBg         := $00F9F5F1;  // #F1F5F9
  FColors.BadgeFreeText       := $008B7464;  // #64748B
  FColors.BadgeProBg          := $00EB6325;  // #2563EB
  FColors.BadgeProText        := clWhite;
  FColors.BadgeCurrentBg      := $005EC522;  // #22C55E yeşil
  FColors.BadgeCurrentText    := clWhite;

  // Progress Bar
  FColors.ProgressTrack       := $00F0E8E2;  // #E2E8F0
  FColors.ProgressHigh        := $005EC522;  // #22C55E yeşil
  FColors.ProgressLow         := $001673F9;  // #F97316 turuncu-kırmızı

  // Bildirim Şeridi
  FColors.NotifyBg            := $00FFF6EF;  // #EFF6FF açık mavi
  FColors.NotifyBorder        := $00FEDBBF;  // #BFDBFE açık mavi kenarlık
  FColors.NotifyText          := $00EB6325;  // #2563EB mavi metin

  // Toggle / Switch
  FColors.ToggleOnBg          := $00EB6325;  // #2563EB mavi
  FColors.ToggleOffBg         := $00E1D5CB;  // #CBD5E1 gri

  // Sekme (Tab)
  FColors.TabActiveBg         := $00FFF6EF;  // #EFF6FF
  FColors.TabActiveText       := $00EB6325;  // #2563EB

  // Modal
  FColors.ModalInputBorder    := $00F0E8E2;  // #E2E8F0
  FColors.ModalInfoBg         := $00FCFAF8;  // #F8FAFC
end;

class procedure TAppThemeManager.LoadDarkTheme;
begin
  // ── Gece / Karanlık Tema ──────────────────────────────────────────────────
  FColors.HeaderMain          := $003B291E;  // Slate-800
  FColors.HeaderModal         := $00222222;
  FColors.HeaderModalText     := clWhite;
  FColors.PanelBottom         := $00222222;
  FColors.HeaderDekontBorc    := $000D93C5;  // #C5930D açık mavi
  FColors.HeaderDekontTahsil  := $00AC6F86;
  FColors.HeaderDekontOdeme   := $00A5A5FC;
  FColors.HeaderDekontAlacak  := $00FEC7D2;
  FColors.HeaderDekontDevir   := $00E1D5CB;

  FColors.DlgInfo             := $00805302;
  FColors.DlgConfirm          := $003B291E;
  FColors.DlgWarning          := $00055FA8;
  FColors.DlgError            := $001E1EAF;

  FColors.StatusBg            := $001F1F1F;
  FColors.StatusBorder        := $00333333;
  FColors.StatusTextMain      := $00F0E8E2;  // #E2E8F0
  FColors.StatusTextMuted     := $00B8A394;  // #94A3B8
  FColors.StatusTextInfo      := $008B7464;  // #64748B

  FColors.ZebraEven           := $00242424;
  FColors.ZebraOdd            := $001C1C1C;
  FColors.BgBorc              := $002A1A1A;
  FColors.BgAlacak            := $001A2A1A;
  FColors.TextBorc            := $006B6BFF;
  FColors.TextAlacak          := $0052C41A;
  FColors.TextOdeme           := $0040A9FF;
  FColors.TextDevir           := $00B37FEB;
  FColors.BorcluRed           := $006B6BFF;
  FColors.AlacakliGreen       := $0052C41A;
  FColors.SifirBlack          := $00D9D9D9;

  FColors.FormBg              := $00181818;
  FColors.CardBg              := $00222222;
  FColors.BorderColor         := $003A3A3A;
  FColors.CloseBtnText        := $00B8A394;  // #94A3B8
  FColors.AccentPrimary       := $00F8BD38;  // #38BDF8 Açık Mavi
  FColors.CardSelectedBorder  := $00804000;  // Koyu mavi kenarlık

  FColors.BadgeFreeBg         := $00333333;
  FColors.BadgeFreeText       := $00B8A394;
  FColors.BadgeProBg          := $00804000;
  FColors.BadgeProText        := clWhite;
  FColors.BadgeCurrentBg      := $00228844;
  FColors.BadgeCurrentText    := clWhite;

  FColors.ProgressTrack       := $00333333;
  FColors.ProgressHigh        := $0052C41A;
  FColors.ProgressLow         := $001E1EAF;

  FColors.NotifyBg            := $00222233;
  FColors.NotifyBorder        := $00444466;
  FColors.NotifyText          := $00F8BD38;

  FColors.ToggleOnBg          := $00F8BD38;
  FColors.ToggleOffBg         := $00444444;

  FColors.TabActiveBg         := $00222233;
  FColors.TabActiveText       := $00F8BD38;

  FColors.ModalInputBorder    := $003A3A3A;
  FColors.ModalInfoBg         := $001F1F1F;
end;

class procedure TAppThemeManager.SetTheme(const ATheme: TAppTheme);
begin
  FCurrentTheme := ATheme;
  case ATheme of
    thLight: LoadLightTheme;
    thDark:  LoadDarkTheme;
  end;

  if Assigned(FOnThemeChanged) then
    FOnThemeChanged(FCurrentTheme, FColors);
end;

end.
