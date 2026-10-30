unit fReportPreview;

{
  TfrmReportPreview — Gelesiye Kurumsal Rapor Önizleme Penceresi
  ==============================================================
  FastReport'un gömülü TfrxPreview bileşenini kendi VCL formumuz içinde
  barındırır. Araç çubuğu tamamen Gelesiye kurumsal temasına uygundur.

  Kullanım (uPrintService içinden):
    Rpt.Preview := frmReportPreview.frxPreview;
    Rpt.PrepareReport(True);
    frmReportPreview.ShowReport(Rpt, 'Rapor Başlığı');
}

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  frxClass, frxPreview, frxExportPDF, frxExportXLSX,
  uGelesiyeTheme;

type
  TfrmReportPreview = class(TForm)
    pnlToolbar: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pnlActions: TPanel;
    btnYazdir: TButton;
    btnPDF: TButton;
    btnExcel: TButton;
    btnMaximize: TButton;
    btnKapat: TButton;
    pnlNav: TPanel;
    btnFirst: TButton;
    btnPrior: TButton;
    lblPage: TLabel;
    btnNext: TButton;
    btnLast: TButton;
    btnZoomOut: TButton;
    btnZoom100: TButton;
    btnZoomIn: TButton;
    btnZoomFit: TButton;
    pnlContainer: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolbarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolbarDblClick(Sender: TObject);
    procedure btnYazdirClick(Sender: TObject);
    procedure btnPDFClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnKapatClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPriorClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnZoom100Click(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomFitClick(Sender: TObject);
  private
    FPreview: TfrxPreview;
    FReport: TfrxReport;
    procedure OnPageChanged(Sender: TfrxPreview; PageNo: Integer);
    procedure UpdatePageLabel;
    procedure UpdateNavButtons;
    procedure UpdateMaximizeButton;
    procedure ToggleMaximize;
    procedure ApplyTheme;
    procedure StyleButton(ABtn: TButton; ABgColor, ATextColor: TColor; ABold: Boolean = True);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    { Raporu hazırlayıp önizleme penceresini gösterir.
      AReport: Dışarıdan oluşturulan ve PrepareReport çağrılmış rapor.
      ATitle: Araç çubuğunda gösterilecek rapor başlığı. }
    procedure ShowReport(AReport: TfrxReport; const ATitle: string);

    property Preview: TfrxPreview read FPreview;
  end;

var
  frmReportPreview: TfrmReportPreview;

implementation

{$R *.dfm}

{ ─────────────────────────────────────────────────────────────────────────── }
{ Oluşturma / Yıkım                                                           }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.FormCreate(Sender: TObject);
begin
  FReport := nil;
  KeyPreview := True;
  BorderStyle := bsNone;  // Windows başlık çubuğu gizlendi — kendi toolbar'ımız var
  Padding.SetBounds(1, 1, 1, 1);

  // TfrxPreview bileşenini pnlContainer içine gömülü olarak oluştur
  FPreview := TfrxPreview.Create(Self);
  FPreview.Parent := pnlContainer;
  FPreview.Align := alClient;
  FPreview.BorderStyle := bsNone;
  FPreview.BackColor := $00CBD5E1;      // Slate-300 — sayfa arkası rengi
  FPreview.OutlineVisible := False;     // Sol ağaç paneli gizle
  FPreview.ThumbnailVisible := False;   // Küçük resim panelini gizle
  FPreview.OnPageChanged := OnPageChanged;

  // Başlık çubuğu ve toolbar panellerinden formu sürükleme & çift tıklama
  pnlToolbar.OnMouseDown  := ToolbarMouseDown;
  pnlTitle.OnMouseDown    := ToolbarMouseDown;
  lblTitle.OnMouseDown    := ToolbarMouseDown;
  lblSubtitle.OnMouseDown := ToolbarMouseDown;
  pnlNav.OnMouseDown      := ToolbarMouseDown;
  lblPage.OnMouseDown     := ToolbarMouseDown;

  pnlToolbar.OnDblClick   := ToolbarDblClick;
  pnlTitle.OnDblClick     := ToolbarDblClick;
  lblTitle.OnDblClick     := ToolbarDblClick;
  lblSubtitle.OnDblClick  := ToolbarDblClick;
  pnlNav.OnDblClick       := ToolbarDblClick;

  ApplyTheme;
end;

procedure TfrmReportPreview.Paint;
begin
  inherited;
  if WindowState <> wsMaximized then
  begin
    Canvas.Pen.Color := $00334155; // Slate-700 zarif dış kenarlık
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  end;
end;

procedure TfrmReportPreview.FormDestroy(Sender: TObject);
begin
  FReport := nil;
end;

procedure TfrmReportPreview.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // Sürme gölgesi
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TfrmReportPreview.FormShow(Sender: TObject);
begin
  if Assigned(FPreview) then
  begin
    FPreview.OutlineVisible := False;
    FPreview.ThumbnailVisible := False;
    FPreview.ZoomMode := zmPageWidth;
    FPreview.SetPosition(1, 0);
  end;
  UpdateMaximizeButton;
  UpdatePageLabel;
  UpdateNavButtons;
end;

procedure TfrmReportPreview.FormResize(Sender: TObject);
begin
  UpdateMaximizeButton;
end;

procedure TfrmReportPreview.ToolbarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (WindowState <> wsMaximized) then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0); // SC_MOVE + HTCAPTION
  end;
end;

procedure TfrmReportPreview.ToolbarDblClick(Sender: TObject);
begin
  ToggleMaximize;
end;

procedure TfrmReportPreview.ToggleMaximize;
begin
  if WindowState = wsMaximized then
    WindowState := wsNormal
  else
    WindowState := wsMaximized;
  UpdateMaximizeButton;
end;

procedure TfrmReportPreview.UpdateMaximizeButton;
begin
  if Assigned(btnMaximize) then
  begin
    if WindowState = wsMaximized then
    begin
      btnMaximize.Caption := '❐';
      btnMaximize.Hint := 'Önceki Boyut';
    end
    else
    begin
      btnMaximize.Caption := '□';
      btnMaximize.Hint := 'Ekranı Kapla';
    end;
  end;
end;

procedure TfrmReportPreview.btnMaximizeClick(Sender: TObject);
begin
  ToggleMaximize;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Tema & Stil                                                                 }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.ApplyTheme;
const
  // Gelesiye kurumsal koyu navy mavi (#1E3A5F)
  CLR_TOOLBAR     = $005F3A1E;  // renk = $00BBGGRR sırası
  CLR_TOOLBAR_STR = $001E3A5F;  // Delphi TColor = BGR, bu RGB notasyonu
  CLR_NAV_BTN     = $00334155;  // Slate-800
  CLR_PRINT       = $00107FD2;  // Gelesiye mavi
  CLR_PDF         = $00B91C1C;  // Kırmızı — PDF
  CLR_EXCEL       = $00166534;  // Yeşil — Excel
  CLR_CLOSE       = $005F3A1E;  // Koyu
  CLR_TEXT_LIGHT  = $00FFFFFF;
  CLR_BG          = $00F1F5F9;  // Slate-100
begin
  // ── Form ──────────────────────────────────────────────────────────────────
  Color := CLR_BG;
  Font.Name := 'Segoe UI';
  Font.Size := 9;

  // ── Toolbar (Koyu Navy Mavi) ───────────────────────────────────────────────
  pnlToolbar.Color := $001E3A5F;
  pnlTitle.Color   := $001E3A5F;
  pnlActions.Color := $001E3A5F;
  pnlNav.Color     := $001E3A5F;

  // ── Başlık metinleri ──────────────────────────────────────────────────────
  lblTitle.Font.Color    := clWhite;
  lblTitle.Font.Style    := [fsBold];
  lblTitle.Font.Size     := 11;
  lblSubtitle.Font.Color := $009AB3C8;  // Açık mavi/gri
  lblSubtitle.Font.Size  := 8;
  lblPage.Font.Color     := clWhite;
  lblPage.Font.Style     := [fsBold];

  // ── Aksiyon Butonları ─────────────────────────────────────────────────────
  StyleButton(btnYazdir,   $00107FD2, clWhite, True);   // Mavi — Yazdır
  StyleButton(btnPDF,      $00C0392B, clWhite, True);   // Kırmızı — PDF
  StyleButton(btnExcel,    $00166534, clWhite, True);   // Yeşil — Excel
  StyleButton(btnMaximize, $00334155, clWhite, True);   // Koyu — Ekranı Kapla
  StyleButton(btnKapat,    $00475569, clWhite, False);  // Slate — Kapat

  // ── Navigasyon & Zoom Butonları ───────────────────────────────────────────
  StyleButton(btnFirst,   $00334155, clWhite, True);
  StyleButton(btnPrior,   $00334155, clWhite, True);
  StyleButton(btnNext,    $00334155, clWhite, True);
  StyleButton(btnLast,    $00334155, clWhite, True);
  StyleButton(btnZoomOut, $00334155, clWhite, True);
  StyleButton(btnZoom100, $00475569, clWhite, False);
  StyleButton(btnZoomIn,  $00334155, clWhite, True);
  StyleButton(btnZoomFit, $00475569, clWhite, False);

  // ── Rapor Kapsayıcı Panel ─────────────────────────────────────────────────
  pnlContainer.Color := $00F1F5F9;

  // ── Preview Çalışma Alanı ─────────────────────────────────────────────────
  if Assigned(FPreview) then
    FPreview.BackColor := $00CBD5E1;  // Slate-300 — sayfa arası boşluk rengi
end;

procedure TfrmReportPreview.StyleButton(ABtn: TButton; ABgColor, ATextColor: TColor; ABold: Boolean);
begin
  if not Assigned(ABtn) then Exit;
  ABtn.Font.Name  := 'Segoe UI';
  ABtn.Font.Size  := 8;
  ABtn.Font.Color := ATextColor;
  if ABold then
    ABtn.Font.Style := [fsBold]
  else
    ABtn.Font.Style := [];
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Rapor Gösterimi                                                             }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.ShowReport(AReport: TfrxReport; const ATitle: string);
var
  R: TRect;
  W, H: Integer;
begin
  if not Assigned(AReport) then Exit;

  FReport := AReport;

  lblTitle.Caption    := ATitle;
  lblSubtitle.Caption := 'Gelesiye ' + #8212 + ' Rapor ' + #214 + 'nizleme';
  Caption             := 'Gelesiye ' + #8212 + ' ' + ATitle;

  // Ekran çalışma alanına göre dengeli, geniş bir önizleme penceresi konumlandır
  if SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0) then
  begin
    W := Min(1240, R.Right - R.Left - 60);
    H := Min(860, R.Bottom - R.Top - 50);
    SetBounds(R.Left + ((R.Right - R.Left - W) div 2),
              R.Top + ((R.Bottom - R.Top - H) div 2),
              W, H);
  end;
  WindowState := wsNormal;
  UpdateMaximizeButton;

  // Sayfa bilgisi ve navigasyon güncelle
  UpdatePageLabel;
  UpdateNavButtons;

  if Assigned(FPreview) then
    FPreview.ZoomMode := zmPageWidth;

  ShowModal;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Sayfa Yardımcıları                                                          }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.OnPageChanged(Sender: TfrxPreview; PageNo: Integer);
begin
  UpdatePageLabel;
  UpdateNavButtons;
end;

procedure TfrmReportPreview.UpdatePageLabel;
var
  Cur, Total: Integer;
begin
  if not Assigned(FPreview) then Exit;
  Cur   := FPreview.PageNo;
  Total := FPreview.PageCount;
  lblPage.Caption := 'Sayfa ' + IntToStr(Cur) + ' / ' + IntToStr(Total);
end;

procedure TfrmReportPreview.UpdateNavButtons;
var
  Cur, Total: Integer;
begin
  if not Assigned(FPreview) then Exit;
  Cur   := FPreview.PageNo;
  Total := FPreview.PageCount;
  btnFirst.Enabled := Cur > 1;
  btnPrior.Enabled := Cur > 1;
  btnNext.Enabled  := Cur < Total;
  btnLast.Enabled  := Cur < Total;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Form Olayları                                                               }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        Close;
        Key := 0;
      end;
    VK_LEFT, VK_PRIOR:
      begin
        if FPreview.PageNo > 1 then FPreview.Prior;
        Key := 0;
      end;
    VK_RIGHT, VK_NEXT:
      begin
        if FPreview.PageNo < FPreview.PageCount then FPreview.Next;
        Key := 0;
      end;
    VK_HOME:
      begin
        FPreview.First;
        Key := 0;
      end;
    VK_END:
      begin
        FPreview.Last;
        Key := 0;
      end;
    Ord('P'):
      if ssCtrl in Shift then
      begin
        FPreview.Print;
        Key := 0;
      end;
  end;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Buton Olayları                                                              }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.btnYazdirClick(Sender: TObject);
begin
  if Assigned(FPreview) then
    FPreview.Print;
end;

procedure TfrmReportPreview.btnPDFClick(Sender: TObject);
var
  Filter: TfrxPDFExport;
  Dlg: TSaveDialog;
begin
  if not Assigned(FPreview) or not Assigned(FReport) then Exit;

  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title   := 'PDF Olarak Kaydet';
    Dlg.Filter  := 'PDF Belgesi (*.pdf)|*.pdf';
    Dlg.DefaultExt := 'pdf';
    Dlg.FileName := lblTitle.Caption;
    Dlg.Options  := Dlg.Options + [ofOverwritePrompt, ofPathMustExist];
    if not Dlg.Execute(Handle) then Exit;

    Filter := TfrxPDFExport.Create(nil);
    try
      Filter.FileName       := Dlg.FileName;
      Filter.ShowDialog     := False;
      Filter.ShowProgress   := False;
      Filter.OpenAfterExport := False;
      Filter.Author          := 'Gelesiye';
      Filter.Subject         := lblTitle.Caption;
      FPreview.Export(Filter);
    finally
      Filter.Free;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmReportPreview.btnExcelClick(Sender: TObject);
var
  Filter: TfrxXLSXExport;
  Dlg: TSaveDialog;
begin
  if not Assigned(FPreview) or not Assigned(FReport) then Exit;

  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title      := 'Excel Olarak Kaydet';
    Dlg.Filter     := 'Excel Çalışma Kitabı (*.xlsx)|*.xlsx';
    Dlg.DefaultExt := 'xlsx';
    Dlg.FileName   := lblTitle.Caption;
    Dlg.Options    := Dlg.Options + [ofOverwritePrompt, ofPathMustExist];
    if not Dlg.Execute(Handle) then Exit;

    Filter := TfrxXLSXExport.Create(nil);
    try
      Filter.FileName           := Dlg.FileName;
      Filter.ShowDialog         := False;
      Filter.ShowProgress       := False;
      Filter.OpenAfterExport    := False;
      Filter.Wysiwyg            := False;  // Daha temiz Excel çıktısı için
      FPreview.Export(Filter);
    finally
      Filter.Free;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmReportPreview.btnKapatClick(Sender: TObject);
begin
  Close;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Navigasyon Butonları                                                        }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.btnFirstClick(Sender: TObject);
begin
  if Assigned(FPreview) then FPreview.First;
end;

procedure TfrmReportPreview.btnPriorClick(Sender: TObject);
begin
  if Assigned(FPreview) then FPreview.Prior;
end;

procedure TfrmReportPreview.btnNextClick(Sender: TObject);
begin
  if Assigned(FPreview) then FPreview.Next;
end;

procedure TfrmReportPreview.btnLastClick(Sender: TObject);
begin
  if Assigned(FPreview) then FPreview.Last;
end;

{ ─────────────────────────────────────────────────────────────────────────── }
{ Zoom Butonları                                                              }
{ ─────────────────────────────────────────────────────────────────────────── }

procedure TfrmReportPreview.btnZoomOutClick(Sender: TObject);
begin
  if not Assigned(FPreview) then Exit;
  FPreview.ZoomMode := zmDefault;
  FPreview.Zoom := Max(0.25, FPreview.Zoom - 0.25);
end;

procedure TfrmReportPreview.btnZoom100Click(Sender: TObject);
begin
  if not Assigned(FPreview) then Exit;
  FPreview.ZoomMode := zmDefault;
  FPreview.Zoom := 1.0;
end;

procedure TfrmReportPreview.btnZoomInClick(Sender: TObject);
begin
  if not Assigned(FPreview) then Exit;
  FPreview.ZoomMode := zmDefault;
  FPreview.Zoom := Min(4.0, FPreview.Zoom + 0.25);
end;

procedure TfrmReportPreview.btnZoomFitClick(Sender: TObject);
begin
  if Assigned(FPreview) then
    FPreview.ZoomMode := zmPageWidth;
end;

end.
