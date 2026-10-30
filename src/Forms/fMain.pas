unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Types, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus, System.Math, Winapi.CommCtrl,
  fBase, fCariEdit, fDekontEdit, fListeToplamlari, fAyarlar, fCloseActionDialog, fYedekYonetimi,
  uGelesiyeConsts, uGelesiyeTheme, uGelesiyeTypes, uGelesiyeInterfaces, uGelesiyeEntities,
  uDbFactory, uCariListViewModel, uCariDetailViewModel, uHareketViewModel, uFirmaViewModel,
  uBackupService;

type
  TfrmMain = class(TfrmBase)
    // --- Ana Menü ---
    mmMain: TMainMenu;
    miIslemler: TMenuItem;
    miCariKartEkle: TMenuItem;
    miCariKartDegistir: TMenuItem;
    miCariKartSil: TMenuItem;
    miN2: TMenuItem;
    miCarininHareketleriniAc: TMenuItem;
    miYedek: TMenuItem;
    miYedekYonetimi: TMenuItem;
    miYedekSep1: TMenuItem;
    miYedekAl: TMenuItem;
    miYedekGeriYukle: TMenuItem;
    miAraclar: TMenuItem;
    miAciklamalar: TMenuItem;
    miSifreDegistir: TMenuItem;
    miGenelAyarlar: TMenuItem;
    miN3: TMenuItem;
    miListeToplamlari: TMenuItem;
    miHesapMakinesi: TMenuItem;
    miYardim: TMenuItem;
    miHakkinda: TMenuItem;
    miCikis: TMenuItem;
    // --- Ortak üst başlık ---
    pnlTop: TPanel;
    lblAppTitle: TLabel;
    lblFirmaBaslik: TLabel;
    btnMenu: TButton;
    btnMinimize: TButton;
    btnMaximize: TButton;
    btnCloseApp: TButton;
    pmAppMenu: TPopupMenu;
    miAppFirmaBilgileri: TMenuItem;
    miAppGenelAyarlar: TMenuItem;
    miAppSifreDegistir: TMenuItem;
    miAppAciklamalar: TMenuItem;
    miAppListeToplamlari: TMenuItem;
    miAppYazdirma: TMenuItem;
    miAppRaporCariOzet: TMenuItem;
    miAppRaporCariDetay: TMenuItem;
    miAppN1: TMenuItem;
    miAppYedekYonetimi: TMenuItem;
    miAppYedeklemeAyarlari: TMenuItem;
    miAppN2: TMenuItem;
    miAppHesapMakinesi: TMenuItem;
    miDevSeedDemo: TMenuItem;
    miDevSeedReset: TMenuItem;
    miDevSeedLoad: TMenuItem;
    miDevSeedSep: TMenuItem;
    miDevSeedBoth: TMenuItem;
    miAppHakkinda: TMenuItem;
    miAppN3: TMenuItem;
    miAppCikis: TMenuItem;
    trayGelesiye: TTrayIcon;
    pmTray: TPopupMenu;
    miTrayGoster: TMenuItem;
    miTraySep1: TMenuItem;
    miTrayYedekAl: TMenuItem;
    miTrayYedekYonetimi: TMenuItem;
    miTraySep2: TMenuItem;
    miTrayHakkinda: TMenuItem;
    miTraySep3: TMenuItem;
    miTrayCikis: TMenuItem;
    // --- Sayfa Kontrol ---
    pcPages: TPageControl;
    tsCariList: TTabSheet;
    tsHareketler: TTabSheet;
    // === Cari Liste Sayfası ===
    pnlCards: TPanel;
    cardBorclu: TPanel;
    lblCardBorcTitle: TLabel;
    valCardBorc: TLabel;
    lblCardBorcSub: TLabel;
    cardAlacakli: TPanel;
    lblCardAlacakTitle: TLabel;
    valCardAlacak: TLabel;
    lblCardAlacakSub: TLabel;
    cardNet: TPanel;
    lblCardNetTitle: TLabel;
    valCardNet: TLabel;
    lblCardNetSub: TLabel;
    cardCariSayisi: TPanel;
    lblCardCariTitle: TLabel;
    valCardCari: TLabel;
    lblCardCariSub: TLabel;
    pnlFilterBar: TPanel;
    edtAramaMetni: TEdit;
    cmbAra: TComboBox;
    cmbHesap: TComboBox;
    cmbFiltre: TComboBox;
    pnlSearchPopup: TPanel;
    pnlSearchPopupHeader: TPanel;
    lblSearchPopupTitle: TLabel;
    lblSearchPopupCount: TLabel;
    lvSearchPopup: TListView;
    btnOzet: TButton;
    btnYazdir: TButton;
    lvCariler: TListView;
    pnlBottom: TPanel;
    btnEkle: TButton;
    btnDegistir: TButton;
    btnSil: TButton;
    btnHareketler: TButton;
    // === Hareket Sayfası ===
    pnlHrkTop: TPanel;
    pnlCariKart: TPanel;
    lblHrkCariUnvan: TLabel;
    lblHrkCariIl: TLabel;
    lblHrkCariTel: TLabel;
    cardHrkBorc: TPanel;
    lblHrkBorcTitle: TLabel;
    valHrkBorc: TLabel;
    lblHrkBorcSub: TLabel;
    cardHrkAlacak: TPanel;
    lblHrkAlacakTitle: TLabel;
    valHrkAlacak: TLabel;
    lblHrkAlacakSub: TLabel;
    cardHrkBakiye: TPanel;
    lblHrkBakiyeTitle: TLabel;
    valHrkBakiye: TLabel;
    lblHrkBakiyeSub: TLabel;
    cardHrkIslem: TPanel;
    lblHrkIslemTitle: TLabel;
    valHrkIslem: TLabel;
    lblHrkIslemSub: TLabel;
    lvHareketler: TListView;
    pnlHrkBottom: TPanel;
    btnOncekiCari: TButton;
    btnSonrakiCari: TButton;
    pnlHrkBottomCenter: TPanel;
    btnHrkFisler: TButton;
    btnHrkDuzenle: TButton;
    btnHrkSil: TButton;
    btnHrkYazdir: TButton;
    lblHrkNotMetni: TLabel;
    btnCariListesi: TButton;
    pmHrkEkle: TPopupMenu;
    miHesabaBorcEkle: TMenuItem;
    miTahsilatYap: TMenuItem;
    miHesabaAlacakEkle: TMenuItem;
    miOdemeYap: TMenuItem;
    pmHrkYazdir: TPopupMenu;
    miHrkFisYazdir: TMenuItem;
    miHrkEkstreYazdir: TMenuItem;
    pmCariYazdir: TPopupMenu;
    miCariListesiYazdir: TMenuItem;
    miCariDetayYazdir: TMenuItem;
    // --- Olaylar ---
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    // Başlık Çubuğu & Pencere Kontrolleri
    procedure pnlTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlTopDblClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnCloseAppClick(Sender: TObject);
    // Cari sayfası
    procedure pnlCardsResize(Sender: TObject);
    procedure edtAramaMetniChange(Sender: TObject);
    procedure edtAramaMetniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmbAraChange(Sender: TObject);
    procedure cmbHesapChange(Sender: TObject);
    procedure cmbFiltreChange(Sender: TObject);
    procedure lvSearchPopupDblClick(Sender: TObject);
    procedure lvSearchPopupKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvSearchPopupCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvSearchPopupCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnEkleClick(Sender: TObject);
    procedure btnDegistirClick(Sender: TObject);
    procedure btnSilClick(Sender: TObject);
    procedure btnHareketlerClick(Sender: TObject);
    procedure lvCarilerDblClick(Sender: TObject);
    procedure lvCarilerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnOzetClick(Sender: TObject);
    procedure btnYazdirClick(Sender: TObject);
    procedure miCariListesiYazdirClick(Sender: TObject);
    procedure miCariDetayYazdirClick(Sender: TObject);
    procedure lvCarilerResize(Sender: TObject);
    procedure lvCarilerCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvCarilerCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvCarilerColumnClick(Sender: TObject; Column: TListColumn);
    // Hareket sayfası
    procedure btnOncekiCariClick(Sender: TObject);
    procedure btnSonrakiCariClick(Sender: TObject);
    procedure btnHrkFislerClick(Sender: TObject);
    procedure btnHrkDuzenleClick(Sender: TObject);
    procedure btnHrkSilClick(Sender: TObject);
    procedure btnHrkYazdirClick(Sender: TObject);
    procedure miHrkFisYazdirClick(Sender: TObject);
    procedure miHrkEkstreYazdirClick(Sender: TObject);
    procedure btnCariListesiClick(Sender: TObject);
    procedure pnlHrkTopResize(Sender: TObject);
    procedure lvHareketlerResize(Sender: TObject);
    procedure lvHareketlerDblClick(Sender: TObject);
    procedure miHesabaBorcEkleClick(Sender: TObject);
    procedure miTahsilatYapClick(Sender: TObject);
    procedure miHesabaAlacakEkleClick(Sender: TObject);
    procedure miOdemeYapClick(Sender: TObject);
    procedure lvHareketlerCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvHareketlerCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvHareketlerColumnClick(Sender: TObject; Column: TListColumn);
    // Menü
    procedure miCikisClick(Sender: TObject);
    procedure miHakkindaClick(Sender: TObject);
    procedure miFirmaBilgileriClick(Sender: TObject);
    procedure miAciklamalarClick(Sender: TObject);
    procedure miSifreDegistirClick(Sender: TObject);
    procedure miGenelAyarlarClick(Sender: TObject);
    procedure miYedeklemeAyarlariClick(Sender: TObject);
    procedure miHesapMakinesiClick(Sender: TObject);
    procedure miYedekAlClick(Sender: TObject);
    procedure miYedekGeriYukleClick(Sender: TObject);
    procedure miYedekYonetimiClick(Sender: TObject);
    procedure btnDevSeedDemoClick(Sender: TObject);
    procedure miDevSeedResetClick(Sender: TObject);
    procedure miDevSeedLoadClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure trayGelesiyeDblClick(Sender: TObject);
    procedure miTrayGosterClick(Sender: TObject);
    procedure miTrayCikisClick(Sender: TObject);
  private
    FForceClose: Boolean;
    FBalloonShown: Boolean;
    sbMain: TStatusBar;
    FKurMetni: string;
    FCalcHover: Boolean;
    FKurHover: Boolean;
    FtmrKur: TTimer;
    FCariListVM: TCariListViewModel;
    FFirmaVM: TFirmaViewModel;
    FHareketVM: THareketViewModel;
    FZebraAktif: Boolean;
    FSortColumn: Integer;
    FSortAsc: Boolean;
    FHrkSortColumn: Integer;
    FHrkSortAsc: Boolean;
    FOldStatusBarWndProc: TWndMethod;
    FpmCariList: TPopupMenu;
    FpmHareketList: TPopupMenu;
    procedure HideToTray;
    procedure ShowFromTray;
    procedure UpdateHeaderSortIndicators;
    procedure UpdateHrkHeaderSortIndicators;
    // Cari liste işlemleri
    procedure CariListeyiGuncelle;
    procedure SearchPopupGuncelle;
    procedure CariOzetGuncelle;
    procedure BasligiGuncelle;
    // Hareket işlemleri
    procedure HrkListeyiGuncelle;
    procedure HrkOzetGuncelle;
    procedure HrkDekontGiris(const ATur: TIslemTuru);
    procedure HrkDuzenle;
    // Navigasyon
    procedure NavigateToCariList;
    procedure NavigateToHareketler(ACariId: Integer);
    // Durum ve Kurlar
    procedure KurlariGuncelleAsync;
    procedure tmrKurTimer(Sender: TObject);
    procedure DurumCubuguGuncelle;
    procedure DurumCubuguBoyutlandir;
    procedure sbMainWindowProc(var Msg: TMessage);
    procedure sbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure sbMainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HrkNavDurumGuncelle;
    procedure FiltreleriYukle;
    procedure CreateContextMenus;
    procedure CariCtxYenileClick(Sender: TObject);
    procedure HrkCtxYenileClick(Sender: TObject);
  protected
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMDialogKey(var Msg: TCMDialogKey); message CM_DIALOGKEY;
    procedure ApplyTheme; override;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Winapi.ShellAPI, uGelesiyeVersion, fDialog, fHakkinda, uDbDemoSeedService,
  uDovizKuruService, uPrintService;

{$R *.dfm}

{ ============================================================================ }
{ Form Yaşam Döngüsü                                                          }
{ ============================================================================ }

procedure TfrmMain.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;

  if Assigned(pnlTop) then
  begin
    pnlTop.Color := Theme.HeaderMain;
    pnlTop.BevelEdges := [beBottom];
    pnlTop.BevelKind := bkFlat;
    pnlTop.BevelOuter := bvNone;
  end;

  if Assigned(btnMenu) then
    btnMenu.Font.Color := clWindowText;

  if Assigned(btnMinimize) then
    btnMinimize.Font.Color := clWindowText;

  if Assigned(btnMaximize) then
    btnMaximize.Font.Color := clWindowText;

  if Assigned(btnCloseApp) then
    btnCloseApp.Font.Color := Theme.CloseBtnText;

  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.FormBg;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;

  if Assigned(pnlHrkBottom) then
  begin
    pnlHrkBottom.Color := Theme.FormBg;
    pnlHrkBottom.BevelEdges := [beTop];
    pnlHrkBottom.BevelKind := bkFlat;
    pnlHrkBottom.BevelOuter := bvNone;
  end;

  if Assigned(pnlCards) then
    pnlCards.Color := Theme.FormBg;

  if Assigned(pnlFilterBar) then
    pnlFilterBar.Color := Theme.FormBg;

  if Assigned(pnlHrkTop) then
    pnlHrkTop.Color := Theme.FormBg;

  // Kart konteynerleri (Cari Liste)
  if Assigned(cardBorclu) then
  begin
    cardBorclu.Color := Theme.CardBg;
    cardBorclu.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardBorclu.BevelKind := bkFlat;
    cardBorclu.BevelOuter := bvNone;
  end;
  if Assigned(cardAlacakli) then
  begin
    cardAlacakli.Color := Theme.CardBg;
    cardAlacakli.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardAlacakli.BevelKind := bkFlat;
    cardAlacakli.BevelOuter := bvNone;
  end;
  if Assigned(cardNet) then
  begin
    cardNet.Color := Theme.CardBg;
    cardNet.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardNet.BevelKind := bkFlat;
    cardNet.BevelOuter := bvNone;
  end;
  if Assigned(cardCariSayisi) then
  begin
    cardCariSayisi.Color := Theme.CardBg;
    cardCariSayisi.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardCariSayisi.BevelKind := bkFlat;
    cardCariSayisi.BevelOuter := bvNone;
  end;

  // Kart konteynerleri (Hareketler)
  if Assigned(pnlCariKart) then
  begin
    pnlCariKart.Color := Theme.CardBg;
    pnlCariKart.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlCariKart.BevelKind := bkFlat;
    pnlCariKart.BevelOuter := bvNone;
  end;
  if Assigned(cardHrkBorc) then
  begin
    cardHrkBorc.Color := Theme.CardBg;
    cardHrkBorc.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardHrkBorc.BevelKind := bkFlat;
    cardHrkBorc.BevelOuter := bvNone;
  end;
  if Assigned(cardHrkAlacak) then
  begin
    cardHrkAlacak.Color := Theme.CardBg;
    cardHrkAlacak.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardHrkAlacak.BevelKind := bkFlat;
    cardHrkAlacak.BevelOuter := bvNone;
  end;
  if Assigned(cardHrkBakiye) then
  begin
    cardHrkBakiye.Color := Theme.CardBg;
    cardHrkBakiye.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardHrkBakiye.BevelKind := bkFlat;
    cardHrkBakiye.BevelOuter := bvNone;
  end;
  if Assigned(cardHrkIslem) then
  begin
    cardHrkIslem.Color := Theme.CardBg;
    cardHrkIslem.BevelEdges := [beTop, beBottom, beLeft, beRight];
    cardHrkIslem.BevelKind := bkFlat;
    cardHrkIslem.BevelOuter := bvNone;
  end;

  if Assigned(lblCardBorcTitle) then lblCardBorcTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblCardAlacakTitle) then lblCardAlacakTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblCardNetTitle) then lblCardNetTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblCardCariTitle) then lblCardCariTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblHrkBorcTitle) then lblHrkBorcTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblHrkAlacakTitle) then lblHrkAlacakTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblHrkBakiyeTitle) then lblHrkBakiyeTitle.Font.Color := Theme.StatusTextMuted;
  if Assigned(lblHrkIslemTitle) then lblHrkIslemTitle.Font.Color := Theme.StatusTextMuted;

  // Grid başlık rengi: CustomDraw ile üst başlık alanı renklendirmesi
  if Assigned(lvCariler) then
  begin
    lvCariler.Color := Theme.CardBg;
    lvCariler.Font.Color := Theme.StatusTextMain;
  end;
end;

procedure TfrmMain.WMNCHitTest(var Msg: TWMNCHitTest);
var
  Pt: TPoint;
  BW: Integer;
begin
  inherited;
  if WindowState = wsMaximized then
    Exit;

  Pt := ScreenToClient(Point(Msg.XPos, Msg.YPos));
  BW := 6;

  // Köşeler (öncelikli)
  if (Pt.X <= BW) and (Pt.Y <= BW) then
    Msg.Result := HTTOPLEFT
  else if (Pt.X >= ClientWidth - BW) and (Pt.Y <= BW) then
    Msg.Result := HTTOPRIGHT
  else if (Pt.X <= BW) and (Pt.Y >= ClientHeight - BW) then
    Msg.Result := HTBOTTOMLEFT
  else if (Pt.X >= ClientWidth - 20) and (Pt.Y >= ClientHeight - 20) then
    Msg.Result := HTBOTTOMRIGHT
  // Kenarlar
  else if Pt.X <= BW then
    Msg.Result := HTLEFT
  else if Pt.X >= ClientWidth - BW then
    Msg.Result := HTRIGHT
  else if Pt.Y >= ClientHeight - BW then
    Msg.Result := HTBOTTOM
  else if Pt.Y <= BW then
    Msg.Result := HTTOP
  // Header alanı: pnlTop yüksekliğindeki her yer sürüklenebilir başlık
  // Windows butonlar üzerinde HTCAPTION'ı görmezden gelir, kendi olaylarını yakalar
  else if (Pt.Y > BW) and (Pt.Y < pnlTop.Height) then
    Msg.Result := HTCAPTION;
end;

procedure TfrmMain.pnlTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (WindowState <> wsMaximized) then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0); // SC_MOVE + HTCAPTION
  end;
end;

procedure TfrmMain.pnlTopDblClick(Sender: TObject);
begin
  btnMaximizeClick(Sender);
end;

procedure TfrmMain.btnMenuClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := btnMenu.ClientToScreen(Point(0, btnMenu.Height));
  pmAppMenu.Popup(Pt.X, Pt.Y);
end;

procedure TfrmMain.btnMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TfrmMain.btnMaximizeClick(Sender: TObject);
begin
  if WindowState = wsMaximized then
  begin
    WindowState := wsNormal;
    btnMaximize.Caption := '□';
  end
  else
  begin
    WindowState := wsMaximized;
    btnMaximize.Caption := '❐';
  end;
end;

procedure TfrmMain.btnCloseAppClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  KeyPreview := True;
  FForceClose := False;
  FBalloonShown := False;
  TDbFactory.Initialize;
  FFirmaVM := TFirmaViewModel.Create(TDbFactory.GetFirmaRepository);
  FCariListVM := TCariListViewModel.Create(TDbFactory.GetCariRepository);
  TBackupService.CheckAutoBackup(True);

  lblFirmaBaslik.OnMouseDown := pnlTopMouseDown;
  lblFirmaBaslik.OnDblClick  := pnlTopDblClick;

  // Status Bar dinamik oluşturma ve paneller
  sbMain := TStatusBar.Create(Self);
  sbMain.Parent := Self;
  sbMain.SimplePanel := False;
  sbMain.Height := 28;
  sbMain.SizeGrip := True;
  sbMain.OnDrawPanel := sbMainDrawPanel;
  sbMain.OnMouseDown := sbMainMouseDown;
  sbMain.OnMouseMove := sbMainMouseMove;
  SendMessage(sbMain.Handle, WM_USER + 10, 28, 0); // SB_SETMINHEIGHT
  FOldStatusBarWndProc := sbMain.WindowProc;
  sbMain.WindowProc := sbMainWindowProc;

  // Panel 0: Cari / Hareket Durum Bilgisi
  with sbMain.Panels.Add do
  begin
    Style := psOwnerDraw;
    Alignment := taLeftJustify;
    Text := '📋 Cari Listesi';
  end;

  // Panel 1: Günlük Döviz Kurları (USD / EUR)
  with sbMain.Panels.Add do
  begin
    Style := psOwnerDraw;
    Alignment := taCenter;
    Text := '';
  end;

  // Panel 2: Hesap Makinesi Butonu
  with sbMain.Panels.Add do
  begin
    Style := psOwnerDraw;
    Alignment := taCenter;
    Text := '🧮 Hesap Makinesi';
  end;

  // Panel 3: Sürüm Bilgisi
  with sbMain.Panels.Add do
  begin
    Style := psOwnerDraw;
    Alignment := taRightJustify;
    Text := GetGelesiyeStatusBarVersion;
  end;

  // 15 dakikada bir kurları arkaplanda sessizce güncelle
  FtmrKur := TTimer.Create(Self);
  FtmrKur.Interval := 15 * 60 * 1000;
  FtmrKur.OnTimer := tmrKurTimer;
  FtmrKur.Enabled := True;

  // Geliştirici menü öğesi derleme moduna göre (Debug / Test ortamında) görünür
  {$IFDEF DEBUG}
  miDevSeedDemo.Visible := True;
  {$ELSE}
  miDevSeedDemo.Visible := (not GELESIYE_IS_RELEASE);
  {$ENDIF}

  // Başlangıç sıralama durumu (-1: doğal veri sırası)
  FSortColumn := -1;
  FSortAsc := True;
  FHrkSortColumn := -1;
  FHrkSortAsc := True;

  // Başlıklara tıklayınca sıralama olay bağlantıları
  lvCariler.OnColumnClick := lvCarilerColumnClick;
  lvHareketler.OnColumnClick := lvHareketlerColumnClick;

  DurumCubuguBoyutlandir;
  pcPages.ActivePage := tsCariList;
  DurumCubuguGuncelle;
  KurlariGuncelleAsync;

  // Son kullanılan filtre seçimlerini yükle
  FiltreleriYukle;

  // Sağ tık bağlam menülerini oluştur
  CreateContextMenus;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(trayGelesiye) then
    trayGelesiye.Visible := False;

  if Assigned(sbMain) and Assigned(FOldStatusBarWndProc) then
    sbMain.WindowProc := FOldStatusBarWndProc;
  FreeAndNil(FtmrKur);

  // Kolon genişliklerini kapat sırasında kaydet
  try
    var Repo: IAyarlarRepository := TDbFactory.GetAyarlarRepository;
    if (Repo <> nil) and (lvCariler <> nil) and (lvCariler.Columns.Count >= 6) then
    begin
      Repo.SetAyar('ui.lv_cari_kolon_genislikleri',
        IntToStr(lvCariler.Columns[0].Width) + ',' +
        IntToStr(lvCariler.Columns[1].Width) + ',' +
        IntToStr(lvCariler.Columns[2].Width) + ',' +
        IntToStr(lvCariler.Columns[3].Width) + ',' +
        IntToStr(lvCariler.Columns[4].Width) + ',' +
        IntToStr(lvCariler.Columns[5].Width));
    end;
    if (Repo <> nil) and (lvHareketler <> nil) and (lvHareketler.Columns.Count >= 6) then
    begin
      Repo.SetAyar('ui.lv_hrk_kolon_genislikleri',
        IntToStr(lvHareketler.Columns[0].Width) + ',' +
        IntToStr(lvHareketler.Columns[1].Width) + ',' +
        IntToStr(lvHareketler.Columns[2].Width) + ',' +
        IntToStr(lvHareketler.Columns[3].Width) + ',' +
        IntToStr(lvHareketler.Columns[4].Width) + ',' +
        IntToStr(lvHareketler.Columns[5].Width));
    end;
  except end;

  FreeAndNil(FHareketVM);
  FCariListVM.Free;
  FFirmaVM.Free;
  inherited;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(trayGelesiye) then
    trayGelesiye.Visible := False;
  try
    TBackupService.CheckAutoBackup(False);
  except
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  LAction: Integer;
  LRemember: Boolean;
  Res: TCloseActionResult;
  Repo: IAyarlarRepository;
begin
  if FForceClose or Application.Terminated then
  begin
    CanClose := True;
    Exit;
  end;

  LAction := 0;
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
      LAction := StrToIntDef(Repo.GetAyar('KapatmaEylemi', '0'), 0);
  except
    LAction := 0;
  end;

  case LAction of
    1: // Doğrudan Küçült
    begin
      CanClose := False;
      HideToTray;
    end;
    2: // Doğrudan Çık
    begin
      CanClose := True;
    end;
  else
    // 0: Her Seferinde Sor
    LRemember := False;
    Res := TfrmCloseActionDialog.Execute(LRemember, Self);
    case Res of
      carCancel:
      begin
        CanClose := False;
      end;
      carMinimizeToTray:
      begin
        CanClose := False;
        if LRemember then
        begin
          try
            Repo := TDbFactory.GetAyarlarRepository;
            if Repo <> nil then
              Repo.SetAyar('KapatmaEylemi', '1');
          except
          end;
        end;
        HideToTray;
      end;
      carExitApp:
      begin
        CanClose := True;
        if LRemember then
        begin
          try
            Repo := TDbFactory.GetAyarlarRepository;
            if Repo <> nil then
              Repo.SetAyar('KapatmaEylemi', '2');
          except
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.HideToTray;
begin
  Hide;
  if not FBalloonShown then
  begin
    FBalloonShown := True;
    trayGelesiye.BalloonTitle := 'Gelesiye — Basit Veresiye Takip';
    trayGelesiye.BalloonHint := 'Program sistem tepsisinde çalışmaya devam ediyor. Tekrar açmak için simgeye çift tıklayabilirsiniz.';
    trayGelesiye.BalloonFlags := bfInfo;
    trayGelesiye.ShowBalloonHint;
  end;
end;

procedure TfrmMain.ShowFromTray;
begin
  Show;
  WindowState := wsNormal;
  Application.BringToFront;
  BringToFront;
end;

procedure TfrmMain.trayGelesiyeDblClick(Sender: TObject);
begin
  ShowFromTray;
end;

procedure TfrmMain.miTrayGosterClick(Sender: TObject);
begin
  ShowFromTray;
end;

procedure TfrmMain.miTrayCikisClick(Sender: TObject);
begin
  FForceClose := True;
  Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FZebraAktif := TDbFactory.GetAyarlarRepository.GetAyar('ZebraGrid', '1') = '1';
  BasligiGuncelle;
  CariListeyiGuncelle;
  pnlCardsResize(Self);
  DurumCubuguBoyutlandir;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if WindowState = wsMaximized then
  begin
    if Assigned(btnMaximize) then
      btnMaximize.Caption := '❐';
    Padding.SetBounds(0, 0, 0, 0);
  end
  else
  begin
    if Assigned(btnMaximize) then
      btnMaximize.Caption := '□';
    Padding.SetBounds(1, 1, 1, 1);
  end;

  DurumCubuguBoyutlandir;
  if Assigned(sbMain) then
    sbMain.Invalidate;
  if pcPages.ActivePage = tsCariList then
  begin
    pnlCardsResize(Sender);
    lvCarilerResize(Sender);
  end
  else if pcPages.ActivePage = tsHareketler then
  begin
    pnlHrkTopResize(Sender);
    lvHareketlerResize(Sender);
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Hareket sayfasındayken
  if pcPages.ActivePage = tsHareketler then
  begin
    case Key of
      VK_ESCAPE: begin NavigateToCariList; Key := 0; end;
      VK_F4: begin HrkDuzenle; Key := 0; end;
      VK_DELETE:
        if not (ActiveControl is TCustomEdit) then
        begin
          btnHrkSilClick(Self);
          Key := 0;
        end;
      VK_F5: begin miHesabaBorcEkleClick(Self); Key := 0; end;
      VK_F6: begin miTahsilatYapClick(Self); Key := 0; end;
      VK_F7: begin miHesabaAlacakEkleClick(Self); Key := 0; end;
      VK_F8: begin miOdemeYapClick(Self); Key := 0; end;
      VK_LEFT:
        if (ssAlt in Shift) or not (ActiveControl is TCustomEdit) then
        begin
          if btnOncekiCari.Enabled then
            btnOncekiCariClick(Self);
          Key := 0;
        end;
      VK_RIGHT:
        if (ssAlt in Shift) or not (ActiveControl is TCustomEdit) then
        begin
          if btnSonrakiCari.Enabled then
            btnSonrakiCariClick(Self);
          Key := 0;
        end;
    end;
    Exit;
  end;

  // Cari sayfasındayken — Escape ile programı kapatma
  if Key = VK_ESCAPE then
    Key := 0;
end;

procedure TfrmMain.CMDialogKey(var Msg: TCMDialogKey);
begin
  if (pcPages.ActivePage = tsHareketler) and not (ActiveControl is TCustomEdit) then
  begin
    if Msg.CharCode = VK_LEFT then
    begin
      if Assigned(btnOncekiCari) and btnOncekiCari.Enabled then
        btnOncekiCariClick(Self);
      Msg.Result := 1;
      Exit;
    end
    else if Msg.CharCode = VK_RIGHT then
    begin
      if Assigned(btnSonrakiCari) and btnSonrakiCari.Enabled then
        btnSonrakiCariClick(Self);
      Msg.Result := 1;
      Exit;
    end;
  end;
  inherited;
end;

{ ============================================================================ }
{ Navigasyon                                                                   }
{ ============================================================================ }

procedure TfrmMain.NavigateToHareketler(ACariId: Integer);
begin
  FreeAndNil(FHareketVM);
  FHareketVM := THareketViewModel.Create(TDbFactory.GetHareketRepository, TDbFactory.GetCariRepository);
  FHareketVM.CariYukle(ACariId);
  pcPages.ActivePage := tsHareketler;
  HrkListeyiGuncelle;
  HrkNavDurumGuncelle;
  DurumCubuguGuncelle;
  Caption := FHareketVM.Cari.Unvan + ' — Hareketler';
  if pnlSearchPopup <> nil then pnlSearchPopup.Visible := False;
  pnlHrkTopResize(Self);
  lvHareketlerResize(Self);
end;

procedure TfrmMain.NavigateToCariList;
begin
  FreeAndNil(FHareketVM);
  pcPages.ActivePage := tsCariList;
  if pnlSearchPopup <> nil then pnlSearchPopup.Visible := False;
  CariListeyiGuncelle;
  DurumCubuguGuncelle;
  BasligiGuncelle;
end;

{ ============================================================================ }
{ Cari Liste — Veri                                                            }
{ ============================================================================ }

procedure TfrmMain.BasligiGuncelle;
var
  F: IFirma;
  FirmaUnvan: string;
begin
  F := FFirmaVM.AktifFirma;
  if (F <> nil) and (Trim(F.Unvan) <> '') then
  begin
    FirmaUnvan := F.Unvan;
    lblFirmaBaslik.Caption := F.Unvan;
  end
  else
  begin
    FirmaUnvan := '';
    lblFirmaBaslik.Caption := '';
  end;
  Caption := GetGelesiyeTitleWithVersion(FirmaUnvan);
end;

procedure TfrmMain.CariOzetGuncelle;
var
  Ozet: TBakiyeOzet;
  F: IFirma;
  FirmaId: Integer;
  NetVal: Currency;
begin
  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  Ozet := TDbFactory.GetCariRepository.GetBakiyeOzet(FirmaId);

  // Toplam alacak (müşteriler bize borçlu)
  valCardBorc.Caption := FormatFloat('#,##0.00 TL', Ozet.AktifBorcluToplam);

  // Toplam borç (biz müşterilere borçluyuz)
  valCardAlacak.Caption := FormatFloat('#,##0.00 TL', Ozet.AktifAlacakliToplam);

  // Net bakiye
  NetVal := Ozet.GenelBorcluToplam - Ozet.GenelAlacakliToplam;
  valCardNet.Caption := FormatFloat('#,##0.00 TL', Abs(NetVal));
  if NetVal > 0.001 then
  begin
    valCardNet.Font.Color := Theme.TextBorc;
    lblCardNetSub.Caption := 'Net alacak (borçlular fazla)';
  end
  else if NetVal < -0.001 then
  begin
    valCardNet.Font.Color := Theme.TextAlacak;
    lblCardNetSub.Caption := 'Net borç (alacaklılar fazla)';
  end
  else
  begin
    valCardNet.Font.Color := Theme.SifirBlack;
    lblCardNetSub.Caption := 'Dengeli durum';
  end;

  // Cari İstatistikleri (Aktif, Pasif, Borçlu, Alacaklı, Sıfır Bakiye)
  lblCardCariTitle.Caption := Format('CARİ İSTATİSTİKLERİ (%d)', [Ozet.ToplamCariSayisi]);
  valCardCari.Caption := Format('Aktif: %d    |    Pasif: %d', [Ozet.AktifCariSayisi, Ozet.PasifCariSayisi]);
  lblCardCariSub.Caption := Format('Borçlu: %d   |   Alacaklı: %d   |   Sıfır: %d',
    [Ozet.BorcluCariSayisi, Ozet.AlacakliCariSayisi, Ozet.SifirBakiyeCariSayisi]);
end;

function GetCariAyirtEdiciBilgi(const C: ICari): string;
var
  NotStr, YetkiliStr, TelStr, IlceStr: string;
  P: Integer;
begin
  Result := '';
  if C = nil then Exit;

  NotStr := Trim(C.Notlar);
  if NotStr <> '' then
  begin
    P := Pos(#13, NotStr);
    if P > 0 then NotStr := Copy(NotStr, 1, P - 1);
    P := Pos(#10, NotStr);
    if P > 0 then NotStr := Copy(NotStr, 1, P - 1);
    NotStr := Trim(NotStr);
  end;

  YetkiliStr := Trim(C.Yetkili);
  IlceStr := Trim(C.Ilce);
  if Trim(C.Gsm) <> '' then
    TelStr := Trim(C.Gsm)
  else
    TelStr := Trim(C.Telefon);

  // Varsa Not/Açıklama, yanında kısa yetkili
  if NotStr <> '' then
  begin
    Result := NotStr;
    if (YetkiliStr <> '') and (Pos(AnsiLowerCase(YetkiliStr), AnsiLowerCase(NotStr)) = 0) and (Length(Result) < 30) then
      Result := Result + ' (' + YetkiliStr + ')';
  end
  else if YetkiliStr <> '' then
  begin
    Result := YetkiliStr;
    if (IlceStr <> '') and (Pos(AnsiLowerCase(IlceStr), AnsiLowerCase(YetkiliStr)) = 0) then
      Result := Result + ' - ' + IlceStr;
  end
  else if IlceStr <> '' then
  begin
    Result := IlceStr;
    if TelStr <> '' then
      Result := Result + ' (' + TelStr + ')';
  end
  else if TelStr <> '' then
    Result := TelStr;
end;

function GetSubItemSafe(AItem: TListItem; AIndex: Integer): string;
begin
  if (AItem <> nil) and (AIndex >= 0) and (AIndex < AItem.SubItems.Count) then
    Result := AItem.SubItems[AIndex]
  else
    Result := '';
end;

function ExtractCurrVal(const AText: string): Currency;
var
  S: string;
  I: Integer;
  Fs: TFormatSettings;
  IsNeg: Boolean;
begin
  if Trim(AText) = '' then Exit(0);
  IsNeg := Pos('-', AText) > 0;
  S := '';
  for I := 1 to Length(AText) do
  begin
    if CharInSet(AText[I], ['0'..'9', ',']) then
      S := S + AText[I];
  end;
  Fs := TFormatSettings.Create('tr-TR');
  Fs.DecimalSeparator := ',';
  Result := StrToCurrDef(S, 0, Fs);
  if IsNeg then
    Result := -Abs(Result);
end;

function ExtractDateVal(const AText: string): TDateTime;
var
  Fs: TFormatSettings;
begin
  if (AText = '') or (AText = '-') then Exit(0);
  Fs := TFormatSettings.Create('tr-TR');
  Fs.DateSeparator := '.';
  Fs.ShortDateFormat := 'dd.mm.yyyy';
  Result := StrToDateDef(AText, 0, Fs);
end;

const
  CARILER_COL_TITLES: array[0..5] of string = (
    'Cari Kod', 'Cari Unvan', 'Açıklama / Not', 'Şehir', 'Son İşlem', 'Bakiye'
  );
  HAREKETLER_COL_TITLES: array[0..5] of string = (
    'Tarih', 'Tür', 'Açıklama', 'Borç', 'Alacak', 'Bakiye'
  );

function CariListCompare(Item1, Item2: TListItem; OptionalParam: NativeInt): Integer; forward;
function HrkListCompare(Item1, Item2: TListItem; OptionalParam: NativeInt): Integer; forward;

procedure TfrmMain.CariListeyiGuncelle;
var
  F: IFirma;
  C: ICari;
  Item: TListItem;
  FirmaId: Integer;
begin
  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  lvCariler.Items.BeginUpdate;
  try
    lvCariler.Items.Clear;
    FCariListVM.Yenile(FirmaId);

    for C in FCariListVM.Cariler do
    begin
      Item := lvCariler.Items.Add;
      Item.Caption := C.CariKodu;
      Item.Data := Pointer(C.Id);

      Item.SubItems.Add(C.Unvan);
      Item.SubItems.Add(GetCariAyirtEdiciBilgi(C));
      Item.SubItems.Add(C.Il);
      if C.SonIslemTarihi > 0 then
        Item.SubItems.Add(FormatDateTime('dd.mm.yyyy', C.SonIslemTarihi))
      else
        Item.SubItems.Add('-');

      // Bakiye + Limit aşımı uyarısı
      var LBakiyeStr: string := FormatFloat('#,##0.00 TL', C.Bakiye);
      if (C.CariLimit > 0) and (C.Bakiye > C.CariLimit) then
        LBakiyeStr := #9888' ' + LBakiyeStr;  // ⚠ Limit aşıldı
      Item.SubItems.Add(LBakiyeStr);
    end;

    if (FCariListVM.SeciliIndex >= 0) and (FCariListVM.SeciliIndex < lvCariler.Items.Count) then
    begin
      lvCariler.ItemIndex := FCariListVM.SeciliIndex;
      lvCariler.Items[FCariListVM.SeciliIndex].MakeVisible(False);
    end;
  finally
    lvCariler.Items.EndUpdate;
  end;

  if FSortColumn >= 0 then
  begin
    UpdateHeaderSortIndicators;
    lvCariler.CustomSort(@CariListCompare, NativeInt(Self));
  end;

  CariOzetGuncelle;
  DurumCubuguGuncelle;
  pnlCardsResize(Self);
  lvCarilerResize(Self);
end;

procedure TfrmMain.SearchPopupGuncelle;
var
  C: ICari;
  Item: TListItem;
  AciklamaStr: string;
begin
  if (lvSearchPopup = nil) or (FCariListVM = nil) then Exit;

  lvSearchPopup.Items.BeginUpdate;
  try
    lvSearchPopup.Items.Clear;
    for C in FCariListVM.Cariler do
    begin
      Item := lvSearchPopup.Items.Add;
      Item.Caption := C.CariKodu;
      Item.Data := Pointer(C.Id);
      Item.SubItems.Add(C.Unvan);

      AciklamaStr := GetCariAyirtEdiciBilgi(C);
      Item.SubItems.Add(AciklamaStr);

      Item.SubItems.Add(FormatFloat('#,##0.00 TL', C.Bakiye));
    end;
  finally
    lvSearchPopup.Items.EndUpdate;
  end;

  lblSearchPopupCount.Caption := IntToStr(FCariListVM.Cariler.Count) + ' kayıt';

  if (Trim(edtAramaMetni.Text) <> '') and (FCariListVM.Cariler.Count > 0) then
  begin
    pnlSearchPopup.BringToFront;
    pnlSearchPopup.Visible := True;
  end
  else
  begin
    pnlSearchPopup.Visible := False;
  end;
end;

{ ============================================================================ }
{ Cari Liste — Olaylar                                                         }
{ ============================================================================ }

procedure TfrmMain.pnlCardsResize(Sender: TObject);
var
  TotalW, Margin, Gap, RemW, CardW, CurX: Integer;
begin
  if (pnlCards = nil) or (cardBorclu = nil) or (cardAlacakli = nil) or
     (cardNet = nil) or (cardCariSayisi = nil) then Exit;

  TotalW := pnlCards.ClientWidth;
  Margin := 12;
  Gap := 10;

  // 4 karta eşit paylaştırılır (3 boşluk + 2 kenar payı)
  RemW := TotalW - (Margin * 2) - (Gap * 3);
  CardW := Max(130, RemW div 4);

  // 1. Toplam Alacak (Müşteri Borcu)
  CurX := Margin;
  cardBorclu.Left := CurX;
  cardBorclu.Top := 10;
  cardBorclu.Width := CardW;
  cardBorclu.Height := 80;

  // 2. Toplam Borç (Bizim Borcumuz)
  Inc(CurX, CardW + Gap);
  cardAlacakli.Left := CurX;
  cardAlacakli.Top := 10;
  cardAlacakli.Width := CardW;
  cardAlacakli.Height := 80;

  // 3. Net Bakiye
  Inc(CurX, CardW + Gap);
  cardNet.Left := CurX;
  cardNet.Top := 10;
  cardNet.Width := CardW;
  cardNet.Height := 80;

  // 4. Toplam Cari Sayısı
  Inc(CurX, CardW + Gap);
  cardCariSayisi.Left := CurX;
  cardCariSayisi.Top := 10;
  cardCariSayisi.Width := Max(CardW, TotalW - Margin - CurX);
  cardCariSayisi.Height := 80;
end;

procedure TfrmMain.lvCarilerResize(Sender: TObject);
var
  FixedW, RemW, UnvanW, NotW: Integer;
begin
  if (lvCariler <> nil) and (lvCariler.Columns.Count >= 6) then
  begin
    // Kod (85) + Şehir (100) + Son İşlem (100) + Bakiye (130) + Kenarlık Payı (25) = 440
    FixedW := 85 + 100 + 100 + 130 + 25;
    RemW := Max(260, lvCariler.ClientWidth - FixedW);
    // Unvan %55, Açıklama / Not %45
    UnvanW := RemW * 55 div 100;
    NotW := RemW - UnvanW;
    lvCariler.Columns[1].Width := Max(180, UnvanW);
    lvCariler.Columns[2].Width := Max(140, NotW);
  end;
end;

procedure TfrmMain.edtAramaMetniChange(Sender: TObject);
begin
  if Trim(edtAramaMetni.Text) <> '' then
  begin
    FSortColumn := -1;
    UpdateHeaderSortIndicators;
  end;
  FCariListVM.AramaMetniDegisti(edtAramaMetni.Text);
  CariListeyiGuncelle;
  SearchPopupGuncelle;
end;

procedure TfrmMain.edtAramaMetniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DOWN:
    begin
      if pnlSearchPopup.Visible and (lvSearchPopup.Items.Count > 0) then
      begin
        lvSearchPopup.SetFocus;
        if lvSearchPopup.Selected = nil then
        begin
          lvSearchPopup.Selected := lvSearchPopup.Items[0];
          lvSearchPopup.ItemFocused := lvSearchPopup.Items[0];
        end;
        Key := 0;
      end;
    end;
    VK_RETURN:
    begin
      if pnlSearchPopup.Visible and (lvSearchPopup.Items.Count > 0) then
      begin
        if lvSearchPopup.Selected = nil then
          lvSearchPopup.Selected := lvSearchPopup.Items[0];
        lvSearchPopupDblClick(Self);
        Key := 0;
      end;
    end;
    VK_ESCAPE:
    begin
      if pnlSearchPopup.Visible then
      begin
        pnlSearchPopup.Visible := False;
        Key := 0;
      end;
    end;
  end;
end;

procedure TfrmMain.lvSearchPopupDblClick(Sender: TObject);
var
  SelId: Integer;
begin
  if lvSearchPopup.Selected = nil then Exit;
  SelId := Integer(lvSearchPopup.Selected.Data);
  pnlSearchPopup.Visible := False;
  NavigateToHareketler(SelId);
end;

procedure TfrmMain.lvSearchPopupKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      lvSearchPopupDblClick(Sender);
      Key := 0;
    end;
    VK_ESCAPE:
    begin
      pnlSearchPopup.Visible := False;
      edtAramaMetni.SetFocus;
      Key := 0;
    end;
    VK_UP:
    begin
      if (lvSearchPopup.Selected <> nil) and (lvSearchPopup.Selected.Index = 0) then
      begin
        edtAramaMetni.SetFocus;
        Key := 0;
      end;
    end;
  end;
end;

procedure TfrmMain.lvSearchPopupCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  if not (cdsSelected in State) then
  begin
    if Item.Index mod 2 = 1 then
      Sender.Canvas.Brush.Color := Theme.ZebraOdd
    else
      Sender.Canvas.Brush.Color := Theme.ZebraEven;
  end;
end;

procedure TfrmMain.lvSearchPopupCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  BalStr: string;
begin
  DefaultDraw := True;
  if SubItem = 3 then // Bakiye kolonu
  begin
    BalStr := Item.SubItems[2];
    if (BalStr <> '') and (BalStr <> '0,00 TL') then
    begin
      if Pos('-', BalStr) > 0 then
        Sender.Canvas.Font.Color := Theme.TextAlacak
      else
        Sender.Canvas.Font.Color := Theme.TextBorc;
      Sender.Canvas.Font.Style := [fsBold];
    end;
  end;
end;

procedure TfrmMain.cmbAraChange(Sender: TObject);
var
  Repo: IAyarlarRepository;
begin
  if cmbAra.ItemIndex = 1 then
    FCariListVM.AramaModuDegisti(amIceren)
  else
    FCariListVM.AramaModuDegisti(amYazildigiGibi);
  // Seçimi kaydet
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
      Repo.SetAyar('ui.arama_modu', IntToStr(cmbAra.ItemIndex));
  except end;
  CariListeyiGuncelle;
  SearchPopupGuncelle;
end;

procedure TfrmMain.cmbHesapChange(Sender: TObject);
var
  Repo: IAyarlarRepository;
begin
  case cmbHesap.ItemIndex of
    1: FCariListVM.HesapDurumuFiltresiDegisti(hdAktif);
    2: FCariListVM.HesapDurumuFiltresiDegisti(hdPasif);
  else
    FCariListVM.HesapDurumuFiltresiDegisti(hdTumu);
  end;
  // Seçimi kaydet
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
      Repo.SetAyar('ui.hesap_filtre', IntToStr(cmbHesap.ItemIndex));
  except end;
  CariListeyiGuncelle;
  SearchPopupGuncelle;
end;

procedure TfrmMain.cmbFiltreChange(Sender: TObject);
var
  Repo: IAyarlarRepository;
begin
  case cmbFiltre.ItemIndex of
    1: FCariListVM.BakiyeFiltresiDegisti(bfBorclular);
    2: FCariListVM.BakiyeFiltresiDegisti(bfAlacaklilar);
    3: FCariListVM.BakiyeFiltresiDegisti(bfBakiyesiArti);
    4: FCariListVM.BakiyeFiltresiDegisti(bfSifirBakiye);
    5: FCariListVM.BakiyeFiltresiDegisti(bfLimitAsanlar);
  else
    FCariListVM.BakiyeFiltresiDegisti(bfTumu);
  end;
  // Seçimi kaydet
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
      Repo.SetAyar('ui.bakiye_filtre', IntToStr(cmbFiltre.ItemIndex));
  except end;
  CariListeyiGuncelle;
  SearchPopupGuncelle;
end;

procedure TfrmMain.btnEkleClick(Sender: TObject);
var
  DetailVM: TCariDetailViewModel;
  Frm: TfrmCariEdit;
  F: IFirma;
  FirmaId: Integer;
begin
  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  DetailVM := TCariDetailViewModel.Create(TDbFactory.GetCariRepository);
  try
    DetailVM.YeniCari(FirmaId);
    Frm := TfrmCariEdit.CreateWithViewModel(Self, DetailVM);
    try
      if Frm.ShowModal = mrOk then
        CariListeyiGuncelle;
    finally
      Frm.Free;
    end;
  finally
    DetailVM.Free;
  end;
end;

procedure TfrmMain.btnDegistirClick(Sender: TObject);
var
  SelId: Integer;
  DetailVM: TCariDetailViewModel;
  Frm: TfrmCariEdit;
begin
  if lvCariler.Selected = nil then Exit;
  SelId := Integer(lvCariler.Selected.Data);

  DetailVM := TCariDetailViewModel.Create(TDbFactory.GetCariRepository);
  try
    DetailVM.MevcutCariYukle(SelId);
    Frm := TfrmCariEdit.CreateWithViewModel(Self, DetailVM);
    try
      if Frm.ShowModal = mrOk then
        CariListeyiGuncelle;
    finally
      Frm.Free;
    end;
  finally
    DetailVM.Free;
  end;
end;

procedure TfrmMain.btnSilClick(Sender: TObject);
var
  C: ICari;
begin
  C := FCariListVM.GetSeciliCari;
  if C = nil then Exit;

  if ShowAppConfirm(
    C.Unvan + ' adlı cari hesabı ve tüm hareketlerini silmek istediğinize emin misiniz?',
    'Cari Silme Onayı',
    'Bu işlem geri alınamaz.') then
  begin
    FCariListVM.SilSeciliCari;
    CariListeyiGuncelle;
  end;
end;

procedure TfrmMain.btnHareketlerClick(Sender: TObject);
var
  C: ICari;
begin
  C := FCariListVM.GetSeciliCari;
  if C = nil then Exit;
  NavigateToHareketler(C.Id);
end;

procedure TfrmMain.lvCarilerDblClick(Sender: TObject);
begin
  btnHareketlerClick(Sender);
end;

procedure TfrmMain.lvCarilerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected and (Item <> nil) then
  begin
    FCariListVM.SeciliIndex := Item.Index;
    if pnlSearchPopup <> nil then pnlSearchPopup.Visible := False;
    DurumCubuguGuncelle;
  end;
end;

procedure TfrmMain.btnOzetClick(Sender: TObject);
var
  Frm: TfrmListeToplamlari;
begin
  Frm := TfrmListeToplamlari.CreateWithData(Self, FCariListVM.GetListeToplamlari);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TfrmMain.btnYazdirClick(Sender: TObject);
var
  P: TPoint;
begin
  // Popup menyü butonun sağ alt köşesinde açılır
  P := btnYazdir.ClientToScreen(Point(0, btnYazdir.Height));
  pmCariYazdir.Popup(P.X, P.Y);
end;


procedure TfrmMain.miCariListesiYazdirClick(Sender: TObject);
begin
  TPrintService.PrintCariListesi(FCariListVM, FFirmaVM);
end;

procedure TfrmMain.miCariDetayYazdirClick(Sender: TObject);
begin
  TPrintService.PrintCariHareketDetayli(FCariListVM, FFirmaVM);
end;

{ ============================================================================ }
{ Cari Liste — CustomDraw                                                      }
{ ============================================================================ }

procedure TfrmMain.lvCarilerCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  if not (cdsSelected in State) then
  begin
    if FZebraAktif and (Item.Index mod 2 = 1) then
      Sender.Canvas.Brush.Color := Theme.ZebraOdd
    else
      Sender.Canvas.Brush.Color := Theme.ZebraEven;
  end;
end;

procedure TfrmMain.lvCarilerCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  BakiyeStr: string;
begin
  DefaultDraw := True;

  if not (cdsSelected in State) then
  begin
    if FZebraAktif and (Item.Index mod 2 = 1) then
      Sender.Canvas.Brush.Color := Theme.ZebraOdd
    else
      Sender.Canvas.Brush.Color := Theme.ZebraEven;
  end;

  // Bakiye kolonu artık SubItem = 5 (SubItems[4])
  if (SubItem = 5) and (Item.SubItems.Count >= 5) then
  begin
    BakiyeStr := Item.SubItems[4];
    if (BakiyeStr <> '') and (BakiyeStr <> '0,00 TL') then
    begin
      if Pos('-', BakiyeStr) > 0 then
      begin
        if not (cdsSelected in State) then
          Sender.Canvas.Brush.Color := Theme.BgAlacak;
        Sender.Canvas.Font.Color := Theme.TextAlacak;
      end
      else
      begin
        if not (cdsSelected in State) then
          Sender.Canvas.Brush.Color := Theme.BgBorc;
        Sender.Canvas.Font.Color := Theme.TextBorc;
      end;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else
      Sender.Canvas.Font.Color := Theme.SifirBlack;
  end;
end;

function CariListCompare(Item1, Item2: TListItem; OptionalParam: NativeInt): Integer;
var
  MainForm: TfrmMain;
  S1, S2: string;
  V1, V2: Currency;
  D1, D2: TDateTime;
begin
  MainForm := TfrmMain(OptionalParam);
  if not Assigned(MainForm) then Exit(0);

  case MainForm.FSortColumn of
    0: // Cari Kod
    begin
      S1 := Item1.Caption;
      S2 := Item2.Caption;
      Result := AnsiCompareText(S1, S2);
    end;
    1: // Cari Unvan
    begin
      S1 := GetSubItemSafe(Item1, 0);
      S2 := GetSubItemSafe(Item2, 0);
      Result := AnsiCompareText(S1, S2);
    end;
    2: // Açıklama / Not
    begin
      S1 := GetSubItemSafe(Item1, 1);
      S2 := GetSubItemSafe(Item2, 1);
      Result := AnsiCompareText(S1, S2);
    end;
    3: // Şehir
    begin
      S1 := GetSubItemSafe(Item1, 2);
      S2 := GetSubItemSafe(Item2, 2);
      Result := AnsiCompareText(S1, S2);
    end;
    4: // Son İşlem (Tarih)
    begin
      S1 := GetSubItemSafe(Item1, 3);
      S2 := GetSubItemSafe(Item2, 3);
      D1 := ExtractDateVal(S1);
      D2 := ExtractDateVal(S2);
      if D1 < D2 then Result := -1
      else if D1 > D2 then Result := 1
      else Result := 0;
    end;
    5: // Bakiye (Sayısal)
    begin
      S1 := GetSubItemSafe(Item1, 4);
      S2 := GetSubItemSafe(Item2, 4);
      V1 := ExtractCurrVal(S1);
      V2 := ExtractCurrVal(S2);
      if V1 < V2 then Result := -1
      else if V1 > V2 then Result := 1
      else Result := 0;
    end;
  else
    Result := 0;
  end;

  if not MainForm.FSortAsc then
    Result := -Result;
end;

procedure TfrmMain.UpdateHeaderSortIndicators;
var
  I: Integer;
begin
  for I := 0 to lvCariler.Columns.Count - 1 do
  begin
    if (I >= Low(CARILER_COL_TITLES)) and (I <= High(CARILER_COL_TITLES)) then
    begin
      if I = FSortColumn then
      begin
        if FSortAsc then
          lvCariler.Columns[I].Caption := CARILER_COL_TITLES[I] + ' ▲'
        else
          lvCariler.Columns[I].Caption := CARILER_COL_TITLES[I] + ' ▼';
      end
      else
        lvCariler.Columns[I].Caption := CARILER_COL_TITLES[I];
    end;
  end;
end;

procedure TfrmMain.lvCarilerColumnClick(Sender: TObject; Column: TListColumn);
var
  Repo: IAyarlarRepository;
begin
  if FSortColumn = Column.Index then
    FSortAsc := not FSortAsc
  else
  begin
    FSortColumn := Column.Index;
    FSortAsc := True;
  end;

  UpdateHeaderSortIndicators;
  lvCariler.CustomSort(@CariListCompare, NativeInt(Self));

  // Sıralama tercihini kaydet
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
    begin
      Repo.SetAyar('ui.sort_col', IntToStr(FSortColumn));
      Repo.SetAyar('ui.sort_asc', IntToStr(Ord(FSortAsc)));
    end;
  except end;
end;

function HrkListCompare(Item1, Item2: TListItem; OptionalParam: NativeInt): Integer;
var
  MainForm: TfrmMain;
  S1, S2: string;
  V1, V2: Currency;
  D1, D2: TDateTime;
begin
  MainForm := TfrmMain(OptionalParam);
  if not Assigned(MainForm) then Exit(0);

  case MainForm.FHrkSortColumn of
    0: // Tarih
    begin
      S1 := Item1.Caption;
      S2 := Item2.Caption;
      D1 := ExtractDateVal(S1);
      D2 := ExtractDateVal(S2);
      if D1 < D2 then Result := -1
      else if D1 > D2 then Result := 1
      else Result := 0;
    end;
    1: // Tür
    begin
      S1 := GetSubItemSafe(Item1, 0);
      S2 := GetSubItemSafe(Item2, 0);
      Result := AnsiCompareText(S1, S2);
    end;
    2: // Açıklama
    begin
      S1 := GetSubItemSafe(Item1, 1);
      S2 := GetSubItemSafe(Item2, 1);
      Result := AnsiCompareText(S1, S2);
    end;
    3: // Borç (Sayısal)
    begin
      S1 := GetSubItemSafe(Item1, 2);
      S2 := GetSubItemSafe(Item2, 2);
      V1 := ExtractCurrVal(S1);
      V2 := ExtractCurrVal(S2);
      if V1 < V2 then Result := -1
      else if V1 > V2 then Result := 1
      else Result := 0;
    end;
    4: // Alacak (Sayısal)
    begin
      S1 := GetSubItemSafe(Item1, 3);
      S2 := GetSubItemSafe(Item2, 3);
      V1 := ExtractCurrVal(S1);
      V2 := ExtractCurrVal(S2);
      if V1 < V2 then Result := -1
      else if V1 > V2 then Result := 1
      else Result := 0;
    end;
    5: // Bakiye (Sayısal)
    begin
      S1 := GetSubItemSafe(Item1, 4);
      S2 := GetSubItemSafe(Item2, 4);
      V1 := ExtractCurrVal(S1);
      V2 := ExtractCurrVal(S2);
      if V1 < V2 then Result := -1
      else if V1 > V2 then Result := 1
      else Result := 0;
    end;
  else
    Result := 0;
  end;

  if not MainForm.FHrkSortAsc then
    Result := -Result;
end;

procedure TfrmMain.UpdateHrkHeaderSortIndicators;
var
  I: Integer;
begin
  for I := 0 to lvHareketler.Columns.Count - 1 do
  begin
    if (I >= Low(HAREKETLER_COL_TITLES)) and (I <= High(HAREKETLER_COL_TITLES)) then
    begin
      if I = FHrkSortColumn then
      begin
        if FHrkSortAsc then
          lvHareketler.Columns[I].Caption := HAREKETLER_COL_TITLES[I] + ' ▲'
        else
          lvHareketler.Columns[I].Caption := HAREKETLER_COL_TITLES[I] + ' ▼';
      end
      else
        lvHareketler.Columns[I].Caption := HAREKETLER_COL_TITLES[I];
    end;
  end;
end;

procedure TfrmMain.lvHareketlerColumnClick(Sender: TObject; Column: TListColumn);
var
  Repo: IAyarlarRepository;
begin
  if FHrkSortColumn = Column.Index then
    FHrkSortAsc := not FHrkSortAsc
  else
  begin
    FHrkSortColumn := Column.Index;
    FHrkSortAsc := True;
  end;

  UpdateHrkHeaderSortIndicators;
  lvHareketler.CustomSort(@HrkListCompare, NativeInt(Self));

  // Sıralama tercihini kaydet
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo <> nil then
    begin
      Repo.SetAyar('ui.hrk_sort_col', IntToStr(FHrkSortColumn));
      Repo.SetAyar('ui.hrk_sort_asc', IntToStr(Ord(FHrkSortAsc)));
    end;
  except end;
end;

{ ============================================================================ }
{ Hareket Sayfası — Veri                                                       }
{ ============================================================================ }

procedure TfrmMain.HrkOzetGuncelle;
var
  BakiyeVal: Currency;
begin
  if FHareketVM = nil then Exit;

  valHrkBorc.Caption   := FormatFloat('#,##0.00 TL', FHareketVM.ToplamBorc);
  valHrkAlacak.Caption := FormatFloat('#,##0.00 TL', FHareketVM.ToplamAlacak);
  valHrkIslem.Caption  := IntToStr(FHareketVM.KayitSayisi);

  BakiyeVal := FHareketVM.NetBakiye;
  valHrkBakiye.Caption := FormatFloat('#,##0.00 TL', Abs(BakiyeVal));

  if BakiyeVal > 0.001 then
  begin
    valHrkBakiye.Font.Color := Theme.TextBorc;
    lblHrkBakiyeSub.Caption := 'Müşteri borçlu';
  end
  else if BakiyeVal < -0.001 then
  begin
    valHrkBakiye.Font.Color := Theme.TextAlacak;
    lblHrkBakiyeSub.Caption := 'Müşteri alacaklı';
  end
  else
  begin
    valHrkBakiye.Font.Color := Theme.SifirBlack;
    lblHrkBakiyeSub.Caption := 'Dengeli';
  end;
end;

procedure TfrmMain.HrkListeyiGuncelle;
var
  H: IHareket;
  Item: TListItem;
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;

  lblHrkCariUnvan.Caption := FHareketVM.Cari.Unvan;
  
  var LIlVeYetkili: string := FHareketVM.Cari.Il;
  if FHareketVM.Cari.Yetkili <> '' then
  begin
    if LIlVeYetkili <> '' then LIlVeYetkili := LIlVeYetkili + ' | ';
    LIlVeYetkili := LIlVeYetkili + 'Yetkili: ' + FHareketVM.Cari.Yetkili;
  end;
  lblHrkCariIl.Caption := LIlVeYetkili;
  
  var LIletisim: string := FHareketVM.Cari.Gsm;
  if LIletisim = '' then LIletisim := FHareketVM.Cari.Telefon;
  if FHareketVM.Cari.Eposta <> '' then
  begin
    if LIletisim <> '' then LIletisim := LIletisim + ' | ';
    LIletisim := LIletisim + FHareketVM.Cari.Eposta;
  end;
  lblHrkCariTel.Caption := LIletisim;

  lvHareketler.Items.BeginUpdate;
  try
    lvHareketler.Items.Clear;
    FHareketVM.Yenile;

    for H in FHareketVM.Hareketler do
    begin
      Item := lvHareketler.Items.Add;
      Item.Caption := FormatDateTime('dd.mm.yyyy HH:nn', H.Tarih);
      Item.Data := Pointer(H.Id);

      case H.IslemTuru of
        itBorc:      Item.SubItems.Add(STR_TUR_BORC_DEKONTU);
        itTahsilat:  Item.SubItems.Add(STR_TUR_TAHSILAT);
        itAlacak:    Item.SubItems.Add(STR_TUR_ALACAK_DEKONTU);
        itOdeme:     Item.SubItems.Add(STR_TUR_ODEME);
        itDevir:     Item.SubItems.Add('[=] ' + STR_TUR_DEVIR);
      else
        Item.SubItems.Add(IslemTuruToStr(H.IslemTuru));
      end;

      Item.SubItems.Add(H.Aciklama);

      if H.Borc > 0 then
        Item.SubItems.Add(FormatFloat('#,##0.00 TL', H.Borc))
      else
        Item.SubItems.Add('');

      if H.Alacak > 0 then
        Item.SubItems.Add(FormatFloat('#,##0.00 TL', H.Alacak))
      else
        Item.SubItems.Add('');

      Item.SubItems.Add(FormatFloat('#,##0.00 TL', H.YuruyenBakiye));
    end;
  finally
    lvHareketler.Items.EndUpdate;
  end;

  if FHrkSortColumn >= 0 then
  begin
    UpdateHrkHeaderSortIndicators;
    lvHareketler.CustomSort(@HrkListCompare, NativeInt(Self));
  end;

  if Assigned(lblHrkNotMetni) then
  begin
    if Trim(FHareketVM.Cari.Notlar) <> '' then
    begin
      lblHrkNotMetni.Caption := #128462' ' + Trim(FHareketVM.Cari.Notlar);
      lblHrkNotMetni.Hint := FHareketVM.Cari.Notlar;
    end
    else
    begin
      lblHrkNotMetni.Caption := '';
      lblHrkNotMetni.Hint := '';
    end;
  end;

  HrkOzetGuncelle;
  DurumCubuguGuncelle;
end;

{ ============================================================================ }
{ Hareket Sayfası — Olaylar                                                    }
{ ============================================================================ }

procedure TfrmMain.HrkDekontGiris(const ATur: TIslemTuru);
var
  Frm: TfrmDekontEdit;
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;

  Frm := TfrmDekontEdit.CreateForDekont(Self, ATur, FHareketVM.Cari.Unvan);
  try
    if Frm.ShowModal = mrOk then
    begin
      case ATur of
        itBorc:     FHareketVM.BorcEkle(Frm.Tutar, Frm.Aciklama, Frm.IslemTarihi);
        itTahsilat: FHareketVM.TahsilatYap(Frm.Tutar, Frm.Aciklama, Frm.IslemTarihi);
        itAlacak:   FHareketVM.AlacakEkle(Frm.Tutar, Frm.Aciklama, Frm.IslemTarihi);
        itOdeme:    FHareketVM.OdemeYap(Frm.Tutar, Frm.Aciklama, Frm.IslemTarihi);
      end;
      HrkListeyiGuncelle;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TfrmMain.btnHrkFislerClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := btnHrkFisler.ClientToScreen(Point(0, btnHrkFisler.Height));
  pmHrkEkle.Popup(Pt.X, Pt.Y);
end;

procedure TfrmMain.miHesabaBorcEkleClick(Sender: TObject);
begin
  HrkDekontGiris(itBorc);
end;

procedure TfrmMain.miTahsilatYapClick(Sender: TObject);
begin
  HrkDekontGiris(itTahsilat);
end;

procedure TfrmMain.miHesabaAlacakEkleClick(Sender: TObject);
begin
  HrkDekontGiris(itAlacak);
end;

procedure TfrmMain.miOdemeYapClick(Sender: TObject);
begin
  HrkDekontGiris(itOdeme);
end;

procedure TfrmMain.HrkDuzenle;
var
  SelH, H: IHareket;
  SelId: Integer;
  Frm: TfrmDekontEdit;
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;
  if lvHareketler.Selected = nil then Exit;

  SelId := Integer(lvHareketler.Selected.Data);
  SelH := nil;
  for H in FHareketVM.Hareketler do
  begin
    if H.Id = SelId then
    begin
      SelH := H;
      Break;
    end;
  end;
  if SelH = nil then Exit;

  if SelH.IslemTuru = itDevir then
  begin
    ShowAppWarning('Devir fişi doğrudan düzenlenemez. Cari kartından devir bakiyesini güncelleyiniz.', 'Uyarı');
    Exit;
  end;

  Frm := TfrmDekontEdit.CreateForEdit(Self, SelH, FHareketVM.Cari.Unvan);
  try
    if Frm.ShowModal = mrOk then
    begin
      FHareketVM.HareketGuncelle(SelH.Id, Frm.Tutar, Frm.Aciklama, Frm.IslemTarihi);
      HrkListeyiGuncelle;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TfrmMain.btnHrkDuzenleClick(Sender: TObject);
begin
  HrkDuzenle;
end;

procedure TfrmMain.lvHareketlerDblClick(Sender: TObject);
begin
  HrkDuzenle;
end;

procedure TfrmMain.btnHrkSilClick(Sender: TObject);
var
  SelId: Integer;
begin
  if lvHareketler.Selected = nil then Exit;
  SelId := Integer(lvHareketler.Selected.Data);

  if ShowAppConfirm(MSG_SILME_ONAY, 'Hareket Silme Onayı', 'Bu işlem geri alınamaz.') then
  begin
    FHareketVM.HareketSil(SelId);
    HrkListeyiGuncelle;
  end;
end;

procedure TfrmMain.btnOncekiCariClick(Sender: TObject);
var
  NewIdx: Integer;
begin
  if FCariListVM = nil then Exit;
  NewIdx := FCariListVM.SeciliIndex - 1;
  if NewIdx >= 0 then
  begin
    FCariListVM.SeciliIndex := NewIdx;
    NavigateToHareketler(FCariListVM.GetSeciliCari.Id);
    HrkNavDurumGuncelle;
  end;
end;

procedure TfrmMain.btnSonrakiCariClick(Sender: TObject);
var
  NewIdx: Integer;
begin
  if FCariListVM = nil then Exit;
  NewIdx := FCariListVM.SeciliIndex + 1;
  if NewIdx < FCariListVM.Cariler.Count then
  begin
    FCariListVM.SeciliIndex := NewIdx;
    NavigateToHareketler(FCariListVM.GetSeciliCari.Id);
    HrkNavDurumGuncelle;
  end;
end;

procedure TfrmMain.btnHrkYazdirClick(Sender: TObject);
var
  P: TPoint;
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;

  // Seçili hareket varsa fiş seçeneği aktif, yoksa pasif
  miHrkFisYazdir.Enabled := lvHareketler.Selected <> nil;

  P := btnHrkYazdir.ClientToScreen(Point(0, btnHrkYazdir.Height));
  pmHrkYazdir.Popup(P.X, P.Y);
end;

procedure TfrmMain.miHrkFisYazdirClick(Sender: TObject);
var
  SelH, H: IHareket;
  SelId: Integer;
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;
  if lvHareketler.Selected = nil then Exit;

  SelId := Integer(lvHareketler.Selected.Data);
  SelH := nil;
  for H in FHareketVM.Hareketler do
    if H.Id = SelId then
    begin
      SelH := H;
      Break;
    end;

  if SelH <> nil then
    TPrintService.PrintHareketDekontu(SelH, FHareketVM.Cari);
end;

procedure TfrmMain.miHrkEkstreYazdirClick(Sender: TObject);
begin
  if (FHareketVM = nil) or (FHareketVM.Cari = nil) then Exit;
  TPrintService.PrintCariEkstre(FHareketVM);
end;

procedure TfrmMain.btnCariListesiClick(Sender: TObject);
begin
  NavigateToCariList;
end;

procedure TfrmMain.pnlHrkTopResize(Sender: TObject);
var
  TotalW, Margin, Gap, CariW, RemW, CardW, CurX: Integer;
begin
  if (pnlHrkTop = nil) or (pnlCariKart = nil) or (cardHrkBorc = nil) then Exit;

  TotalW := pnlHrkTop.ClientWidth;
  Margin := 12;
  Gap := 10;

  // Cari kart genişliği: Toplam alanın %25'i civarı, min 220, max 320
  CariW := TotalW * 26 div 100;
  if CariW < 220 then CariW := 220;
  if CariW > 320 then CariW := 320;

  // Kalan alan 4 karta eşit dağıtılır
  RemW := TotalW - (Margin * 2) - CariW - (Gap * 4);
  CardW := Max(110, RemW div 4);

  // 1. Cari Kart
  CurX := Margin;
  pnlCariKart.Left := CurX;
  pnlCariKart.Top := 10;
  pnlCariKart.Width := CariW;
  pnlCariKart.Height := 80;
  if Assigned(lblHrkCariUnvan) then
    lblHrkCariUnvan.Width := CariW - 24;

  // 2. Toplam Borç Kartı
  Inc(CurX, CariW + Gap);
  cardHrkBorc.Left := CurX;
  cardHrkBorc.Top := 10;
  cardHrkBorc.Width := CardW;
  cardHrkBorc.Height := 80;

  // 3. Toplam Tahsilat Kartı
  Inc(CurX, CardW + Gap);
  cardHrkAlacak.Left := CurX;
  cardHrkAlacak.Top := 10;
  cardHrkAlacak.Width := CardW;
  cardHrkAlacak.Height := 80;

  // 4. Bakiye Kartı
  Inc(CurX, CardW + Gap);
  cardHrkBakiye.Left := CurX;
  cardHrkBakiye.Top := 10;
  cardHrkBakiye.Width := CardW;
  cardHrkBakiye.Height := 80;

  // 5. İşlem Sayısı Kartı
  Inc(CurX, CardW + Gap);
  cardHrkIslem.Left := CurX;
  cardHrkIslem.Top := 10;
  cardHrkIslem.Width := Max(CardW, TotalW - Margin - CurX);
  cardHrkIslem.Height := 80;
end;

procedure TfrmMain.lvHareketlerResize(Sender: TObject);
var
  RemW: Integer;
begin
  if (lvHareketler <> nil) and (lvHareketler.Columns.Count >= 6) then
  begin
    // Açıklama kolonu (index 2) kalan tüm genişliği kaplar
    RemW := lvHareketler.ClientWidth - (125 + 130 + 100 + 100 + 120 + 4);
    lvHareketler.Columns[2].Width := Max(200, RemW);
  end;
end;


{ ============================================================================ }
{ Hareket Sayfası — CustomDraw                                                 }
{ ============================================================================ }

procedure TfrmMain.lvHareketlerCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  if not (cdsSelected in State) then
  begin
    if FZebraAktif and (Item.Index mod 2 = 1) then
      Sender.Canvas.Brush.Color := Theme.ZebraOdd
    else
      Sender.Canvas.Brush.Color := Theme.ZebraEven;
  end;
end;

procedure TfrmMain.lvHareketlerCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  TurStr, BalStr: string;
begin
  DefaultDraw := True;

  if not (cdsSelected in State) then
  begin
    if FZebraAktif and (Item.Index mod 2 = 1) then
      Sender.Canvas.Brush.Color := Theme.ZebraOdd
    else
      Sender.Canvas.Brush.Color := Theme.ZebraEven;
  end;

  if SubItem = 1 then
  begin
    TurStr := Item.SubItems[0];
    if Pos('Borç', TurStr) > 0 then
    begin
      Sender.Canvas.Font.Color := Theme.TextBorc;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else if Pos('Tahsilat', TurStr) > 0 then
    begin
      Sender.Canvas.Font.Color := Theme.TextAlacak;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else if Pos('Alacak', TurStr) > 0 then
    begin
      Sender.Canvas.Font.Color := Theme.HeaderDekontAlacak;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else if Pos('Ödeme', TurStr) > 0 then
    begin
      Sender.Canvas.Font.Color := Theme.TextOdeme;
      Sender.Canvas.Font.Style := [fsBold];
    end
    else if Pos('Devir', TurStr) > 0 then
    begin
      Sender.Canvas.Font.Color := Theme.TextDevir;
      Sender.Canvas.Font.Style := [fsBold];
    end;
  end
  else if SubItem = 3 then
  begin
    if Item.SubItems[2] <> '' then
    begin
      if not (cdsSelected in State) then
        Sender.Canvas.Brush.Color := Theme.BgBorc;
      Sender.Canvas.Font.Color := Theme.TextBorc;
      Sender.Canvas.Font.Style := [fsBold];
    end;
  end
  else if SubItem = 4 then
  begin
    if Item.SubItems[3] <> '' then
    begin
      if not (cdsSelected in State) then
        Sender.Canvas.Brush.Color := Theme.BgAlacak;
      Sender.Canvas.Font.Color := Theme.TextAlacak;
      Sender.Canvas.Font.Style := [fsBold];
    end;
  end
  else if SubItem = 5 then
  begin
    BalStr := Item.SubItems[4];
    if (BalStr <> '') and (BalStr <> '0,00 TL') then
    begin
      if Pos('-', BalStr) > 0 then
        Sender.Canvas.Font.Color := Theme.TextAlacak
      else
        Sender.Canvas.Font.Color := Theme.TextBorc;
      Sender.Canvas.Font.Style := [fsBold];
    end;
  end;
end;

{ ============================================================================ }
{ Menü İşlemleri                                                               }
{ ============================================================================ }

{ ============================================================================ }
{ Durum Çubuğu & Navigasyon Durumu                                             }
{ ============================================================================ }

procedure TfrmMain.DurumCubuguBoyutlandir;
var
  LeftW, KurW, CalcW, VerW: Integer;
begin
  if (sbMain = nil) or (sbMain.Panels.Count < 4) then Exit;

  if Trim(FKurMetni) <> '' then
    KurW := 215
  else
    KurW := 0;

  CalcW := 145;
  VerW := 200;

  sbMain.Panels[1].Width := KurW;
  sbMain.Panels[2].Width := CalcW;
  sbMain.Panels[3].Width := VerW;

  LeftW := sbMain.ClientWidth - KurW - CalcW - VerW - 24;
  if LeftW < 200 then
    LeftW := 200;
  sbMain.Panels[0].Width := LeftW;
end;

procedure TfrmMain.sbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var
  R, BtnRect: TRect;
  DrawFlags: Cardinal;
begin
  // Modern Slate-50 / Theme.StatusBg arka plan dolgusu
  StatusBar.Canvas.Brush.Color := Theme.StatusBg;
  StatusBar.Canvas.FillRect(Rect);

  // Üst sınır çizgisi (1px Slate-200)
  StatusBar.Canvas.Pen.Color := Theme.StatusBorder;
  StatusBar.Canvas.MoveTo(Rect.Left, Rect.Top);
  StatusBar.Canvas.LineTo(Rect.Right, Rect.Top);

  // Paneller arası dikey ayrım çizgisi (genişliği 0 olan gizli paneller hariç)
  if (Panel.Width > 0) and (Panel.Index < StatusBar.Panels.Count - 1) then
  begin
    StatusBar.Canvas.Pen.Color := Theme.StatusBorder;
    StatusBar.Canvas.MoveTo(Rect.Right - 1, Rect.Top + 4);
    StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 4);
  end;

  if Panel.Width <= 0 then Exit;

  R := Rect;
  R.Top := Rect.Top + 1;

  DrawFlags := DT_SINGLELINE or DT_VCENTER;
  StatusBar.Canvas.Font.Name := 'Segoe UI';
  StatusBar.Canvas.Font.Size := 9;

  case Panel.Index of
    0:
      begin
        R.Left := Rect.Left + 12;
        DrawFlags := DrawFlags or DT_LEFT;
        StatusBar.Canvas.Font.Color := Theme.StatusTextMain;
        StatusBar.Canvas.Font.Style := [fsBold];
      end;
    1: // Döviz Kurları (USD / EUR)
      begin
        DrawFlags := DrawFlags or DT_CENTER;
        StatusBar.Canvas.Font.Color := Theme.StatusTextMain;
        if FKurHover then
        begin
          StatusBar.Canvas.Font.Style := [fsBold];
          StatusBar.Canvas.Font.Color := Theme.TextAlacak;
        end
        else
          StatusBar.Canvas.Font.Style := [];
      end;
    2: // Hesap Makinesi Butonu
      begin
        BtnRect := Rect;
        InflateRect(BtnRect, -6, -2);
        if FCalcHover then
        begin
          StatusBar.Canvas.Brush.Color := Theme.BorderColor;
          StatusBar.Canvas.Pen.Color := Theme.AccentPrimary;
        end
        else
        begin
          StatusBar.Canvas.Brush.Color := Theme.CardBg;
          StatusBar.Canvas.Pen.Color := Theme.StatusBorder;
        end;
        StatusBar.Canvas.RoundRect(BtnRect.Left, BtnRect.Top, BtnRect.Right, BtnRect.Bottom, 6, 6);

        DrawFlags := DrawFlags or DT_CENTER;
        StatusBar.Canvas.Font.Color := Theme.StatusTextMain;
        StatusBar.Canvas.Font.Style := [fsBold];
        R := BtnRect;
      end;
    3: // Sürüm
      begin
        R.Right := Rect.Right - 22; // Size grip payı
        DrawFlags := DrawFlags or DT_RIGHT;
        StatusBar.Canvas.Font.Color := Theme.StatusTextInfo;
        StatusBar.Canvas.Font.Style := [];

        // Modern 3-çizgili Size Grip Çizimi (Yalnızca pencere maksimize değilken)
        if WindowState <> wsMaximized then
        begin
          StatusBar.Canvas.Pen.Color := Theme.BorderColor;
          StatusBar.Canvas.MoveTo(Rect.Right - 4, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 6);
          StatusBar.Canvas.MoveTo(Rect.Right - 8, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 10);
          StatusBar.Canvas.MoveTo(Rect.Right - 12, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 14);

          StatusBar.Canvas.Pen.Color := clWhite;
          StatusBar.Canvas.MoveTo(Rect.Right - 5, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 7);
          StatusBar.Canvas.MoveTo(Rect.Right - 9, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 11);
          StatusBar.Canvas.MoveTo(Rect.Right - 13, Rect.Bottom - 3);
          StatusBar.Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 15);
        end;
      end;
  end;

  SetBkMode(StatusBar.Canvas.Handle, TRANSPARENT);
  DrawText(StatusBar.Canvas.Handle, PChar(Panel.Text), -1, R, DrawFlags);
end;

procedure TfrmMain.DurumCubuguGuncelle;
var
  SelCari: ICari;
begin
  if (sbMain = nil) or (sbMain.Panels.Count < 4) then Exit;

  if pcPages.ActivePage = tsHareketler then
  begin
    if (FHareketVM <> nil) and (FHareketVM.Cari <> nil) then
      sbMain.Panels[0].Text := Format('📊 Hareketler — %s  •  %d hareket | Net: %s',
        [FHareketVM.Cari.Unvan, FHareketVM.KayitSayisi, FormatFloat('#,##0.00 TL', FHareketVM.NetBakiye)])
    else
      sbMain.Panels[0].Text := '📊 Hareketler';
  end
  else
  begin
    SelCari := nil;
    if FCariListVM <> nil then
      SelCari := FCariListVM.GetSeciliCari;

    if SelCari <> nil then
      sbMain.Panels[0].Text := Format('📋 Cari: %s (%s)  •  %d kayıt',
        [SelCari.Unvan, FormatFloat('#,##0.00 TL', SelCari.Bakiye), IfThen(FCariListVM <> nil, FCariListVM.KayitSayisi, 0)])
    else
    begin
      if FCariListVM <> nil then
        sbMain.Panels[0].Text := Format('📋 Cari Listesi  •  %d kayıt', [FCariListVM.KayitSayisi])
      else
        sbMain.Panels[0].Text := '📋 Cari Listesi';
    end;
  end;

  sbMain.Panels[1].Text := FKurMetni;
  sbMain.Panels[2].Text := '🧮 Hesap Makinesi';
  sbMain.Panels[3].Text := GetGelesiyeStatusBarVersion;

  if sbMain.HandleAllocated then
    sbMain.Invalidate;
end;

procedure TfrmMain.sbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P1Left, P1Right, P2Left, P2Right: Integer;
begin
  if Button <> mbLeft then Exit;
  if (sbMain = nil) or (sbMain.Panels.Count < 4) then Exit;

  P1Left := sbMain.Panels[0].Width;
  P1Right := P1Left + sbMain.Panels[1].Width;

  P2Left := P1Right;
  P2Right := P2Left + sbMain.Panels[2].Width;

  // Panel 2: Hesap Makinesi
  if (X >= P2Left) and (X < P2Right) then
  begin
    ShellExecute(Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);
    Exit;
  end;

  // Panel 1: Döviz Kurları (tıklandığında yeniden kur sorgula)
  if (sbMain.Panels[1].Width > 0) and (X >= P1Left) and (X < P1Right) then
  begin
    KurlariGuncelleAsync;
    Exit;
  end;
end;

procedure TfrmMain.sbMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  P1Left, P1Right, P2Left, P2Right: Integer;
  NewCalcHover, NewKurHover: Boolean;
begin
  if (sbMain = nil) or (sbMain.Panels.Count < 4) then Exit;

  P1Left := sbMain.Panels[0].Width;
  P1Right := P1Left + sbMain.Panels[1].Width;

  P2Left := P1Right;
  P2Right := P2Left + sbMain.Panels[2].Width;

  NewCalcHover := (X >= P2Left) and (X < P2Right);
  NewKurHover := (sbMain.Panels[1].Width > 0) and (X >= P1Left) and (X < P1Right);

  if (NewCalcHover <> FCalcHover) or (NewKurHover <> FKurHover) then
  begin
    FCalcHover := NewCalcHover;
    FKurHover := NewKurHover;
    sbMain.Invalidate;
  end;

  if (WindowState <> wsMaximized) and
     (((X >= sbMain.ClientWidth - 20) and (Y >= sbMain.ClientHeight - 20)) or
      (Y >= sbMain.ClientHeight - 6) or (X >= sbMain.ClientWidth - 6)) then
  begin
    // Grip veya alt/sağ kenar resize bölgesindeyken cursor'ı sıfırlama, Windows NCHITTEST yönetsin
    Exit;
  end;

  if FCalcHover then
  begin
    sbMain.Cursor := crHandPoint;
    sbMain.Hint := 'Windows Hesap Makinesi uygulamasını başlatmak için tıklayınız';
    sbMain.ShowHint := True;
  end
  else if FKurHover then
  begin
    sbMain.Cursor := crHandPoint;
    sbMain.Hint := 'TCMB Günlük Döviz Kurları (Yenilemek için tıklayınız)';
    sbMain.ShowHint := True;
  end
  else
  begin
    sbMain.Cursor := crDefault;
    sbMain.Hint := '';
    sbMain.ShowHint := False;
  end;
end;

procedure TfrmMain.sbMainWindowProc(var Msg: TMessage);
var
  Pt: TPoint;
  BW: Integer;
begin
  if (Msg.Msg = WM_NCHITTEST) and (WindowState <> wsMaximized) then
  begin
    Pt := sbMain.ScreenToClient(Point(TWMNCHitTest(Msg).XPos, TWMNCHitTest(Msg).YPos));
    BW := 6;
    // Sağ alt köşe (grip bölgesi 20x20)
    if (Pt.X >= sbMain.ClientWidth - 20) and (Pt.Y >= sbMain.ClientHeight - 20) then
    begin
      Msg.Result := HTTRANSPARENT;
      Exit;
    end
    // Alt kenar (BW = 6)
    else if Pt.Y >= sbMain.ClientHeight - BW then
    begin
      Msg.Result := HTTRANSPARENT;
      Exit;
    end
    // Sağ kenar (BW = 6)
    else if Pt.X >= sbMain.ClientWidth - BW then
    begin
      Msg.Result := HTTRANSPARENT;
      Exit;
    end;
  end;
  FOldStatusBarWndProc(Msg);
end;

procedure TfrmMain.KurlariGuncelleAsync;
begin
  TDovizKuruService.KurlariAlAsync(
    procedure(const AKurlar: TDovizKurlari)
    begin
      FKurMetni := TDovizKuruService.FormatKurMetni(AKurlar);
      DurumCubuguBoyutlandir;
      DurumCubuguGuncelle;
    end);
end;

procedure TfrmMain.tmrKurTimer(Sender: TObject);
begin
  KurlariGuncelleAsync;
end;

procedure TfrmMain.HrkNavDurumGuncelle;
var
  Idx, Cnt: Integer;
begin
  if (FCariListVM = nil) or (FCariListVM.Cariler = nil) then
  begin
    btnOncekiCari.Enabled := False;
    btnSonrakiCari.Enabled := False;
    Exit;
  end;

  Idx := FCariListVM.SeciliIndex;
  Cnt := FCariListVM.Cariler.Count;

  btnOncekiCari.Enabled := (Idx > 0);
  btnSonrakiCari.Enabled := (Idx >= 0) and (Idx < Cnt - 1);

  if Idx > 0 then
    btnOncekiCari.Hint := 'Önceki Cari (Sol Ok): ' + FCariListVM.Cariler[Idx - 1].Unvan
  else
    btnOncekiCari.Hint := 'İlk caridesiniz (Önceki cari yok)';

  if (Idx >= 0) and (Idx < Cnt - 1) then
    btnSonrakiCari.Hint := 'Sonraki Cari (Sağ Ok): ' + FCariListVM.Cariler[Idx + 1].Unvan
  else
    btnSonrakiCari.Hint := 'Son caridesiniz (Sonraki cari yok)';
end;

procedure TfrmMain.FiltreleriYukle;
var
  Repo: IAyarlarRepository;
  BakiyeIdx, HesapIdx, AraIdx: Integer;
  SortCol, SortAsc, HrkSortCol, HrkSortAsc: Integer;
  CariWidths, HrkWidths: string;
  Parts: TArray<string>;
  I, W: Integer;
begin
  try
    Repo := TDbFactory.GetAyarlarRepository;
    if Repo = nil then Exit;

    BakiyeIdx  := StrToIntDef(Repo.GetAyar('ui.bakiye_filtre', '0'), 0);
    HesapIdx   := StrToIntDef(Repo.GetAyar('ui.hesap_filtre',  '0'), 0);
    AraIdx     := StrToIntDef(Repo.GetAyar('ui.arama_modu',    '0'), 0);
    SortCol    := StrToIntDef(Repo.GetAyar('ui.sort_col',      '-1'), -1);
    SortAsc    := StrToIntDef(Repo.GetAyar('ui.sort_asc',       '1'),  1);
    HrkSortCol := StrToIntDef(Repo.GetAyar('ui.hrk_sort_col', '-1'), -1);
    HrkSortAsc := StrToIntDef(Repo.GetAyar('ui.hrk_sort_asc',  '1'),  1);
    CariWidths := Repo.GetAyar('ui.lv_cari_kolon_genislikleri', '');
    HrkWidths  := Repo.GetAyar('ui.lv_hrk_kolon_genislikleri',  '');

    // Bakiye filtresi
    if (BakiyeIdx >= 0) and (BakiyeIdx < cmbFiltre.Items.Count) then
    begin
      cmbFiltre.ItemIndex := BakiyeIdx;
      cmbFiltreChange(cmbFiltre);
    end;

    // Hesap durumu filtresi
    if (HesapIdx >= 0) and (HesapIdx < cmbHesap.Items.Count) then
    begin
      cmbHesap.ItemIndex := HesapIdx;
      cmbHesapChange(cmbHesap);
    end;

    // Arama modu
    if (AraIdx >= 0) and (AraIdx < cmbAra.Items.Count) then
    begin
      cmbAra.ItemIndex := AraIdx;
      cmbAraChange(cmbAra);
    end;

    // Cari liste sıralama
    FSortColumn := SortCol;
    FSortAsc    := (SortAsc <> 0);
    if FSortColumn >= 0 then
    begin
      UpdateHeaderSortIndicators;
      lvCariler.CustomSort(@CariListCompare, NativeInt(Self));
    end;

    // Hareket liste sıralama
    FHrkSortColumn := HrkSortCol;
    FHrkSortAsc    := (HrkSortAsc <> 0);

    // Cari liste kolon genişlikleri
    if (CariWidths <> '') and (lvCariler <> nil) and (lvCariler.Columns.Count >= 6) then
    begin
      Parts := CariWidths.Split([',']);
      if Length(Parts) >= 6 then
        for I := 0 to 5 do
        begin
          W := StrToIntDef(Trim(Parts[I]), 0);
          if W > 20 then
            lvCariler.Columns[I].Width := W;
        end;
    end;

    // Hareket liste kolon genişlikleri
    if (HrkWidths <> '') and (lvHareketler <> nil) and (lvHareketler.Columns.Count >= 6) then
    begin
      Parts := HrkWidths.Split([',']);
      if Length(Parts) >= 6 then
        for I := 0 to 5 do
        begin
          W := StrToIntDef(Trim(Parts[I]), 0);
          if W > 20 then
            lvHareketler.Columns[I].Width := W;
        end;
    end;
  except end;
end;

{ ============================================================================ }
{ Menü İşlemleri                                                               }
{ ============================================================================ }

procedure TfrmMain.miFirmaBilgileriClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(0);
  if (FFirmaVM <> nil) and (lblFirmaBaslik <> nil) then
  begin
    FFirmaVM.Yenile;
    if FFirmaVM.AktifFirma <> nil then
      lblFirmaBaslik.Caption := FFirmaVM.AktifFirma.Unvan;
  end;
end;

procedure TfrmMain.miAciklamalarClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(4);
  FZebraAktif := TDbFactory.GetAyarlarRepository.GetAyar('ZebraGrid', '1') = '1';
  lvCariler.Repaint;
end;

procedure TfrmMain.miSifreDegistirClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(3);
end;

procedure TfrmMain.miGenelAyarlarClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(1);
  if (FFirmaVM <> nil) and (lblFirmaBaslik <> nil) then
  begin
    FFirmaVM.Yenile;
    if FFirmaVM.AktifFirma <> nil then
      lblFirmaBaslik.Caption := FFirmaVM.AktifFirma.Unvan;
  end;
  FZebraAktif := TDbFactory.GetAyarlarRepository.GetAyar('ZebraGrid', '1') = '1';
  lvCariler.Repaint;
end;

procedure TfrmMain.miYedeklemeAyarlariClick(Sender: TObject);
begin
  TfrmAyarlar.Execute(2);
end;

procedure TfrmMain.miCikisClick(Sender: TObject);
begin
  FForceClose := True;
  Close;
end;

procedure TfrmMain.miYedekYonetimiClick(Sender: TObject);
begin
  TfrmYedekYonetimi.Execute(Self);
  CariListeyiGuncelle;
end;

procedure TfrmMain.miHakkindaClick(Sender: TObject);
begin
  TfrmHakkinda.Execute(Self);
end;

procedure TfrmMain.miHesapMakinesiClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.miYedekAlClick(Sender: TObject);
var
  BPath, Err: string;
begin
  if TBackupService.BackupDatabase(BPath, Err) then
    TfrmDialog.Execute('Veritabanı yedeği başarıyla alındı!', dtInfo,
      'Yedek Alma Başarılı', 'Yedek Dosyası: ' + BPath, dbOk, Self)
  else
    TfrmDialog.Execute('Yedekleme başarısız oldu.', dtError,
      'Yedekleme Hatası', Err, dbOk, Self);
end;

procedure TfrmMain.miYedekGeriYukleClick(Sender: TObject);
var
  Dlg: TOpenDialog;
  Err: string;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Title := 'Geri Yüklenecek Veritabanı Yedeğini Seçiniz';
    Dlg.InitialDir := TBackupService.GetBackupFolder;
    Dlg.Filter := 'Gelesiye Yedek Dosyaları (*.db)|*.db|Tüm Dosyalar (*.*)|*.*';
    if Dlg.Execute then
    begin
      if ShowAppConfirm(
        'Seçilen yedek mevcut veritabanının üzerine yazılacak.',
        'Yedek Geri Yükleme Onayı',
        'Bu işlem geri alınamaz. Devam etmek istiyor musunuz?') then
      begin
        if TBackupService.RestoreDatabase(Dlg.FileName, Err) then
        begin
          TfrmDialog.Execute('Veritabanı başarıyla geri yüklendi!', dtInfo,
            'Geri Yükleme Başarılı', '', dbOk, Self);
          CariListeyiGuncelle;
        end
        else
          TfrmDialog.Execute('Geri yükleme başarısız oldu.', dtError,
            'Geri Yükleme Hatası', Err, dbOk, Self);
      end;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmMain.btnDevSeedDemoClick(Sender: TObject);
var
  F: IFirma;
  FirmaId: Integer;
begin
  if not ShowAppConfirm(
    'Mevcut veritabanındaki tüm cari ve hareket kayıtları sıfırlanıp,' + sLineBreak +
    'yerine 6 adet gerçekçi örnek cari ve hareketleri yüklenecektir.',
    'Geliştirici Araçları — Sıfırla + Demo Veri Yükle',
    'Bu işlem sadece geliştirme ve test ortamı içindir. Devam edilsin mi?') then
    Exit;

  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  if TDbDemoSeedService.ResetAndSeedDemoData(FirmaId) then
  begin
    NavigateToCariList;
    CariListeyiGuncelle;
    ShowAppInfo('Veritabanı sıfırlandı ve 25 adet örnek cari ve hareket kayıtları yüklendi.',
      'Demo Veriler Yüklendi', 'Develop/Test veri hazırlığı tamamlandı.');
  end
  else
    ShowAppError('Demo veriler yüklenirken bir hata oluştu.', 'Hata');
end;

procedure TfrmMain.miDevSeedResetClick(Sender: TObject);
var
  F: IFirma;
  FirmaId: Integer;
begin
  if not ShowAppConfirm(
    'Mevcut veritabanındaki tüm cari ve hareket kayıtları kalıcı olarak silinecektir.' + sLineBreak +
    'Yeni demo veri yüklenmeyecek — veritabanı boş kalacaktır.',
    'Geliştirici Araçları — Veritabanını Sıfırla',
    'Bu işlem geri alınamaz. Devam edilsin mi?') then
    Exit;

  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  if TDbDemoSeedService.ResetData(FirmaId) then
  begin
    NavigateToCariList;
    CariListeyiGuncelle;
    ShowAppInfo('Tüm cari ve hareket kayıtları silindi. Veritabanı boş.',
      'Veritabanı Sıfırlandı', 'Develop/Test: Temiz başlangıç hazır.');
  end
  else
    ShowAppError('Sıfırlama işlemi sırasında bir hata oluştu.', 'Hata');
end;

procedure TfrmMain.miDevSeedLoadClick(Sender: TObject);
var
  F: IFirma;
  FirmaId: Integer;
begin
  if not ShowAppConfirm(
    'Mevcut veritabanına 25 adet örnek cari ve hareketler eklenecektir.' + sLineBreak +
    'Mevcut kayıtlar silinmeyecek — üstüne ekleme yapılacaktır.',
    'Geliştirici Araçları — Demo Veri Yükle',
    'Bu işlem sadece geliştirme ve test ortamı içindir. Devam edilsin mi?') then
    Exit;

  F := FFirmaVM.AktifFirma;
  FirmaId := IfThen(F <> nil, F.Id, 1);

  if TDbDemoSeedService.SeedDemoData(FirmaId) then
  begin
    NavigateToCariList;
    CariListeyiGuncelle;
    ShowAppInfo('25 adet örnek cari ve hareket kaydı mevcut veritabanına eklendi.',
      'Demo Veriler Yüklendi', 'Develop/Test veri hazırlığı tamamlandı.');
  end
  else
    ShowAppError('Demo veriler yüklenirken bir hata oluştu.', 'Hata');
end;

{ ============================================================================ }
{ Sağ Tık Bağlam Menüleri                                                       }
{ ============================================================================ }

procedure TfrmMain.CreateContextMenus;

  function MakeItem(AOwner: TPopupMenu; const ACaption: string;
    AOnClick: TNotifyEvent; AParent: TMenuItem = nil): TMenuItem;
  begin
    Result := TMenuItem.Create(AOwner);
    Result.Caption := ACaption;
    Result.OnClick := AOnClick;
    if AParent <> nil then
      AParent.Add(Result)
    else
      AOwner.Items.Add(Result);
  end;

  function MakeSep(AOwner: TPopupMenu; AParent: TMenuItem = nil): TMenuItem;
  begin
    Result := TMenuItem.Create(AOwner);
    Result.Caption := '-';
    if AParent <> nil then
      AParent.Add(Result)
    else
      AOwner.Items.Add(Result);
  end;

var
  SubMenu: TMenuItem;
begin
  // ── Cari Listesi Sağ Tık Menüsü ──
  FpmCariList := TPopupMenu.Create(Self);
  FpmCariList.AutoHotkeys := maManual;

  MakeItem(FpmCariList, 'Hareketler (Hesap Ekstresi)'#9'Enter', btnHareketlerClick);
  MakeSep(FpmCariList);

  // İşlem Ekle alt menüsü
  SubMenu := TMenuItem.Create(FpmCariList);
  SubMenu.Caption := #304#351'lem Ekle';
  FpmCariList.Items.Add(SubMenu);

  MakeItem(FpmCariList, 'Bor' + #231 + ' Fişi'#9'F5',   miHesabaBorcEkleClick, SubMenu);
  MakeItem(FpmCariList, 'Tahsilat'#9'F6',                 miTahsilatYapClick, SubMenu);
  MakeItem(FpmCariList, 'Alacak Dekontu'#9'F7',           miHesabaAlacakEkleClick, SubMenu);
  MakeItem(FpmCariList, #214'deme'#9'F8',                  miOdemeYapClick, SubMenu);

  MakeSep(FpmCariList);
  MakeItem(FpmCariList, 'Cari Kart' + #305 + ' D' + #252 + 'zenle'#9'F4', btnDegistirClick);
  MakeItem(FpmCariList, 'Cari Kart' + #305 + ' Sil'#9'Del', btnSilClick);

  MakeSep(FpmCariList);
  MakeItem(FpmCariList, 'Yeni Cari Ekle'#9'F3', btnEkleClick);
  MakeItem(FpmCariList, 'Liste Toplamlar' + #305, btnOzetClick);

  MakeSep(FpmCariList);
  // Yazdır alt menüsü
  SubMenu := TMenuItem.Create(FpmCariList);
  SubMenu.Caption := 'Yazd' + #305 + 'r';
  FpmCariList.Items.Add(SubMenu);

  MakeItem(FpmCariList, 'Cari Listesi (' + #214 + 'zet)', miCariListesiYazdirClick, SubMenu);
  MakeItem(FpmCariList, 'Hareket Detayl' + #305 + ' Cari Raporu', miCariDetayYazdirClick, SubMenu);

  MakeSep(FpmCariList);
  MakeItem(FpmCariList, 'Listeyi Yenile', CariCtxYenileClick);

  lvCariler.PopupMenu := FpmCariList;

  // ── Hareket Listesi Sağ Tık Menüsü ──
  FpmHareketList := TPopupMenu.Create(Self);
  FpmHareketList.AutoHotkeys := maManual;

  MakeItem(FpmHareketList, 'Makbuz / Dekont Yazd' + #305 + 'r', miHrkFisYazdirClick);
  MakeItem(FpmHareketList, #304#351'lemi D' + #252 + 'zenle'#9'F4', btnHrkDuzenleClick);
  MakeItem(FpmHareketList, #304#351'lemi Sil'#9'Del', btnHrkSilClick);

  MakeSep(FpmHareketList);

  // Yeni İşlem Ekle alt menüsü
  SubMenu := TMenuItem.Create(FpmHareketList);
  SubMenu.Caption := 'Yeni ' + #304#351 + 'lem Ekle';
  FpmHareketList.Items.Add(SubMenu);

  MakeItem(FpmHareketList, 'Bor' + #231 + ' Fi' + #351 + 'i'#9'F5', miHesabaBorcEkleClick, SubMenu);
  MakeItem(FpmHareketList, 'Tahsilat'#9'F6', miTahsilatYapClick, SubMenu);
  MakeItem(FpmHareketList, 'Alacak Dekontu'#9'F7', miHesabaAlacakEkleClick, SubMenu);
  MakeItem(FpmHareketList, #214'deme'#9'F8', miOdemeYapClick, SubMenu);

  MakeSep(FpmHareketList);
  MakeItem(FpmHareketList, 'Cari Hesap Ekstresi Yazd' + #305 + 'r', miHrkEkstreYazdirClick);

  MakeSep(FpmHareketList);
  MakeItem(FpmHareketList, 'Listeyi Yenile', HrkCtxYenileClick);

  lvHareketler.PopupMenu := FpmHareketList;
end;

procedure TfrmMain.CariCtxYenileClick(Sender: TObject);
begin
  CariListeyiGuncelle;
end;

procedure TfrmMain.HrkCtxYenileClick(Sender: TObject);
begin
  if FHareketVM <> nil then
    HrkListeyiGuncelle;
end;

end.