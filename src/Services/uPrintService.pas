unit uPrintService;

{
  TPrintService -- FastReport 6 tabanlı yazdırma servisi
  =========================================================
  Raporlar:
    1. Cari Listesi            : Filtrelenmiş cari listesi + bakiye özeti
    2. Cari Ekstre             : Tek carinin tüm hareketleri + yürüyen bakiye
    3. Hareket Dekontu / Fişi  : Tekil işlem fişi
    4. Hareket Detaylı Cari    : Tüm cariler ve altındaki hareket dökümü
}

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Math,
  Vcl.Graphics, Vcl.Forms, Vcl.Printers, uGelesiyeTypes, uGelesiyeInterfaces,
  uGelesiyeConsts, uCariListViewModel, uHareketViewModel, uFirmaViewModel,
  frxClass, frxPreview, fReportPreview;

type
  { Cari listesi veri kaynağı helper'ı }
  TCariListDataHelper = class
  private
    FList: TList<ICari>;
    FIndex: Integer;
  public
    constructor Create(AList: TList<ICari>);
    procedure OnFirst(Sender: TObject);
    procedure OnNext(Sender: TObject);
    procedure OnCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure OnGetValue(const VarName: string; var Value: Variant);
    procedure OnReportBeforePrint(Sender: TfrxReportComponent);
  end;

  { Hareket listesi veri kaynağı helper'ı }
  THareketDataHelper = class
  private
    FList: TList<IHareket>;
    FIndex: Integer;
  public
    constructor Create(AList: TList<IHareket>);
    procedure OnFirst(Sender: TObject);
    procedure OnNext(Sender: TObject);
    procedure OnCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure OnGetValue(const VarName: string; var Value: Variant);
    procedure OnReportBeforePrint(Sender: TfrxReportComponent);
  end;

  { Hareket detaylı cari raporu veri kaynağı helper'ı }
  TDetayRowType = (drtCariHeader, drtMovement, drtCariTotal, drtEmpty);

  TDetayRow = record
    RowType: TDetayRowType;
    Tarih: string;
    Tur: string;
    Aciklama: string;
    Borc: string;
    Alacak: string;
    Bakiye: string;
    IslemTuru: TIslemTuru;
    BorcVal: Currency;
    AlacakVal: Currency;
    BakiyeVal: Currency;
  end;

  TCariHareketDetayDataHelper = class
  private
    FList: TList<TDetayRow>;
    FIndex: Integer;
  public
    constructor Create(AList: TList<TDetayRow>);
    destructor Destroy; override;
    procedure OnFirst(Sender: TObject);
    procedure OnNext(Sender: TObject);
    procedure OnCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure OnGetValue(const VarName: string; var Value: Variant);
    procedure OnReportBeforePrint(Sender: TfrxReportComponent);
  end;

  { Ana yazdırma servisi }
  TPrintService = class
  private
    class function FormatPara(const AValue: Currency): string;
    class function FormatTarih(const AValue: TDateTime): string;
    class function IslemTuruStr(const ATur: TIslemTuru): string;
    class function BakiyeStr(const ABakiye: Currency): string;
    class function FormatCariUnvan(const ACari: ICari): string;
    class function GetPagePrintableWidth(APage: TfrxReportPage): Extended;
    class function CreateBaseReport(const AReportTitle: string = ''): TfrxReport;
    class function CreatePage(AReport: TfrxReport; AOrientation: TPrinterOrientation): TfrxReportPage;
    class procedure AddMemo(AParent: TfrxBand; L, T, W, H: Extended; const Txt: string; FontSize: Integer; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clNone; BottomLine: Boolean = False);
    class procedure AddCell(AParent: TfrxBand; L, T, W, H: Extended; const Txt: string; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clWhite; BorderColor: TColor = $00CBD5E1);
    class procedure AddDataCell(AParent: TfrxBand; L, T, W, H: Extended; ADS: TfrxDataSet; const AField: string; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clWhite; BorderColor: TColor = $00CBD5E1; AStretchActual: Boolean = False);
  public
    class procedure PrintCariListesi(ACariListVM: TCariListViewModel; AFirmaVM: TFirmaViewModel);
    class procedure PrintCariHareketDetayli(ACariListVM: TCariListViewModel; AFirmaVM: TFirmaViewModel);
    class procedure PrintCariEkstre(AHareketVM: THareketViewModel);
    class procedure PrintHareketDekontu(const AHareket: IHareket; const ACari: ICari; const AOncekiBakiye: Currency = 0; const ASonrakiBakiye: Currency = 0);
  end;

implementation

uses
  Winapi.Windows, uDbFactory;

{ ============================================================================ }
{ TCariListDataHelper                                                           }
{ ============================================================================ }

constructor TCariListDataHelper.Create(AList: TList<ICari>);
begin
  inherited Create;
  FList := AList;
  FIndex := 0;
end;

procedure TCariListDataHelper.OnFirst(Sender: TObject);
begin
  FIndex := 0;
end;

procedure TCariListDataHelper.OnNext(Sender: TObject);
begin
  Inc(FIndex);
end;

procedure TCariListDataHelper.OnCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := FIndex >= FList.Count;
end;

procedure TCariListDataHelper.OnGetValue(const VarName: string; var Value: Variant);
var
  C: ICari;
begin
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;
  C := FList[FIndex];
  if SameText(VarName, 'KOD') then
    Value := C.CariKodu
  else if SameText(VarName, 'UNVAN') then
    Value := TPrintService.FormatCariUnvan(C)
  else if SameText(VarName, 'NOTLAR') then
    Value := C.Notlar
  else if SameText(VarName, 'SEHIR') then
  begin
    if (C.Il <> '') and (C.Ilce <> '') then
      Value := C.Il + ' / ' + C.Ilce
    else if C.Il <> '' then
      Value := C.Il
    else
      Value := C.Ilce;
  end
  else if SameText(VarName, 'SON_ISLEM') then
  begin
    if C.SonIslemTarihi > 0 then
      Value := FormatDateTime('dd.mm.yyyy', C.SonIslemTarihi)
    else
      Value := FormatDateTime('dd.mm.yyyy', C.KayitTarihi);
  end
  else if SameText(VarName, 'BAKIYE') then
    Value := FormatFloat('#,##0.00 TL', C.Bakiye);
end;

procedure TCariListDataHelper.OnReportBeforePrint(Sender: TfrxReportComponent);
var
  M: TfrxMemoView;
  C: ICari;
begin
  if not (Sender is TfrxMemoView) then
    Exit;
  M := TfrxMemoView(Sender);
  if M.DataSet = nil then
    Exit;
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;
  C := FList[FIndex];

  if FIndex mod 2 = 1 then
    M.Color := $00F8FAFC
  else
    M.Color := clWhite;

  if SameText(M.DataField, 'BAKIYE') then
  begin
    if C.Bakiye > 0.001 then
    begin
      M.Font.Color := $001A1AD4;
      M.Font.Style := [fsBold];
    end
    else if C.Bakiye < -0.001 then
    begin
      M.Font.Color := $001B5E20;
      M.Font.Style := [fsBold];
    end
    else
    begin
      M.Font.Color := clBlack;
      M.Font.Style := [];
    end;
  end;
end;

{ ============================================================================ }
{ THareketDataHelper                                                            }
{ ============================================================================ }

constructor THareketDataHelper.Create(AList: TList<IHareket>);
begin
  inherited Create;
  FList := AList;
  FIndex := 0;
end;

procedure THareketDataHelper.OnFirst(Sender: TObject);
begin
  FIndex := 0;
end;

procedure THareketDataHelper.OnNext(Sender: TObject);
begin
  Inc(FIndex);
end;

procedure THareketDataHelper.OnCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := FIndex >= FList.Count;
end;

procedure THareketDataHelper.OnGetValue(const VarName: string; var Value: Variant);
var
  H: IHareket;
begin
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;
  H := FList[FIndex];
  if SameText(VarName, 'TARIH') then
    Value := FormatDateTime('dd.mm.yyyy HH:nn', H.Tarih)
  else if SameText(VarName, 'TUR') then
    Value := TPrintService.IslemTuruStr(H.IslemTuru)
  else if SameText(VarName, 'ACIKLAMA') then
    Value := H.Aciklama
  else if SameText(VarName, 'BORC') then
  begin
    if H.Borc > 0.001 then
      Value := FormatFloat('#,##0.00 TL', H.Borc)
    else
      Value := '';
  end
  else if SameText(VarName, 'ALACAK') then
  begin
    if H.Alacak > 0.001 then
      Value := FormatFloat('#,##0.00 TL', H.Alacak)
    else
      Value := '';
  end
  else if SameText(VarName, 'BAKIYE') then
    Value := FormatFloat('#,##0.00 TL', H.YuruyenBakiye);
end;

procedure THareketDataHelper.OnReportBeforePrint(Sender: TfrxReportComponent);
var
  M: TfrxMemoView;
  H: IHareket;
begin
  if not (Sender is TfrxMemoView) then
    Exit;
  M := TfrxMemoView(Sender);
  if M.DataSet = nil then
    Exit;
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;
  H := FList[FIndex];

  if SameText(M.DataField, 'TUR') then
  begin
    M.Font.Style := [fsBold];
    case H.IslemTuru of
      itBorc:
        M.Font.Color := $001A1AD4;
      itTahsilat:
        M.Font.Color := $0015803D;
      itAlacak:
        M.Font.Color := $004338CA;
      itOdeme:
        M.Font.Color := $000D53B7;
      itDevir:
        M.Font.Color := $007B1FA2;
    else
      M.Font.Color := clBlack;
    end;
  end
  else if SameText(M.DataField, 'BORC') then
  begin
    if H.Borc > 0.001 then
    begin
      M.Font.Color := $001A1AD4;
      M.Font.Style := [fsBold];
    end;
  end
  else if SameText(M.DataField, 'ALACAK') then
  begin
    if H.Alacak > 0.001 then
    begin
      M.Font.Color := $0015803D;
      M.Font.Style := [fsBold];
    end;
  end
  else if SameText(M.DataField, 'BAKIYE') then
  begin
    M.Font.Style := [fsBold];
    if H.YuruyenBakiye > 0.001 then
      M.Font.Color := $001A1AD4
    else if H.YuruyenBakiye < -0.001 then
      M.Font.Color := $0015803D
    else
      M.Font.Color := clBlack;
  end;
end;

{ ============================================================================ }
{ TPrintService — Yardımcı                                                     }
{ ============================================================================ }

class function TPrintService.FormatPara(const AValue: Currency): string;
begin
  Result := FormatFloat('#,##0.00 TL', AValue);
end;

class function TPrintService.FormatTarih(const AValue: TDateTime): string;
begin
  if AValue <= 0 then
    Result := '-'
  else
    Result := FormatDateTime('dd.mm.yyyy HH:nn', AValue);
end;

class function TPrintService.IslemTuruStr(const ATur: TIslemTuru): string;
begin
  case ATur of
    itBorc:
      Result := 'Bor' + #231 + ' Fi' + #351 + 'i';
    itTahsilat:
      Result := 'Tahsilat';
    itAlacak:
      Result := 'Alacak Fi' + #351 + 'i';
    itOdeme:
      Result := #214 + 'deme';
    itDevir:
      Result := 'Devir Fi' + #351 + 'i';
  else
    Result := 'Bilinmiyor';
  end;
end;

class function TPrintService.BakiyeStr(const ABakiye: Currency): string;
begin
  if ABakiye > 0.001 then
    Result := FormatPara(ABakiye) + ' Bor' + #231
  else if ABakiye < -0.001 then
    Result := FormatPara(Abs(ABakiye)) + ' Alacak'
  else
    Result := '0,00 TL';
end;

class function TPrintService.FormatCariUnvan(const ACari: ICari): string;
begin
  if ACari = nil then
    Exit('');
  if (ACari.Yetkili <> '') and (Pos(ACari.Yetkili, ACari.Unvan) = 0) then
    Result := ACari.Yetkili + ' '#8212' ' + ACari.Unvan
  else
    Result := ACari.Unvan;
end;

class function TPrintService.GetPagePrintableWidth(APage: TfrxReportPage): Extended;
var
  NetMm: Extended;
begin
  if APage.Orientation = poLandscape then
    NetMm := Max(APage.PaperWidth, APage.PaperHeight) - APage.LeftMargin - APage.RightMargin
  else
    NetMm := Min(APage.PaperWidth, APage.PaperHeight) - APage.LeftMargin - APage.RightMargin;

  // 1 mm = 96 / 25.4 = ~3.7795275591 px.
  // 4 px güvenlik marjı düşülerek yazıcı donanım marjı ve yuvarlama kaynaklı taşmalar tamamen önlenir.
  Result := (NetMm * (96.0 / 25.4)) - 4.0;
end;

class function TPrintService.CreateBaseReport(const AReportTitle: string = ''): TfrxReport;
begin
  Result := TfrxReport.Create(nil);
  Result.ShowProgress := False;
  Result.EngineOptions.PrintIfEmpty := True;
  Result.EngineOptions.DoublePass := False;
  // Kendi önizleme formumuz (frmReportPreview) kullanıldığı için
  // Modal ve Buttons ayarları artık gerekli değil — frmReportPreview.ShowReport yönetir.
  Result.PreviewOptions.Modal := False;
  if AReportTitle <> '' then
    Result.ReportOptions.Name := AReportTitle;
end;

class function TPrintService.CreatePage(AReport: TfrxReport; AOrientation: TPrinterOrientation): TfrxReportPage;
begin
  Result := TfrxReportPage.Create(AReport);
  Result.SetDefaults;
  Result.Orientation := AOrientation;
  Result.LeftMargin := 10;
  Result.RightMargin := 10;
  Result.TopMargin := 10;
  Result.BottomMargin := 10;
end;

class procedure TPrintService.AddMemo(AParent: TfrxBand; L, T, W, H: Extended; const Txt: string; FontSize: Integer; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clNone; BottomLine: Boolean = False);
var
  M: TfrxMemoView;
begin
  M := TfrxMemoView.Create(AParent);
  M.SetBounds(L, T, W, H);
  M.Text := Txt;
  M.Font.Name := 'Segoe UI';
  M.Font.Size := FontSize;
  M.Font.Color := FClr;
  if Bold then
    M.Font.Style := [fsBold];
  M.HAlign := Align;
  M.VAlign := vaCenter;
  if BgClr <> clNone then
    M.Color := BgClr;
  if BottomLine then
  begin
    M.Frame.Typ := [ftBottom];
    M.Frame.Color := $00CBD5E1;
  end;
end;

class procedure TPrintService.AddCell(AParent: TfrxBand; L, T, W, H: Extended; const Txt: string; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clWhite; BorderColor: TColor = $00CBD5E1);
var
  M: TfrxMemoView;
begin
  M := TfrxMemoView.Create(AParent);
  M.SetBounds(L, T, W, H);
  M.Text := Txt;
  M.Font.Name := 'Segoe UI';
  M.Font.Size := 8;
  M.Font.Color := FClr;
  M.Color := BgClr;
  if Bold then
    M.Font.Style := [fsBold];
  M.HAlign := Align;
  M.VAlign := vaCenter;
  M.WordWrap := True;
  M.GapX := 3;
  M.GapY := 1;
  if BorderColor <> clNone then
  begin
    M.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    M.Frame.Color := BorderColor;
  end
  else
    M.Frame.Typ := [];
end;

class procedure TPrintService.AddDataCell(AParent: TfrxBand; L, T, W, H: Extended; ADS: TfrxDataSet; const AField: string; Bold: Boolean; Align: TfrxHAlign; FClr: TColor; BgClr: TColor = clWhite; BorderColor: TColor = $00CBD5E1; AStretchActual: Boolean = False);
var
  M: TfrxMemoView;
begin
  M := TfrxMemoView.Create(AParent);
  M.SetBounds(L, T, W, H);
  M.DataSet := ADS;
  M.DataField := AField;
  M.Text := '[<' + ADS.UserName + '."' + AField + '">]';
  M.Font.Name := 'Segoe UI';
  M.Font.Size := 8;
  M.Font.Color := FClr;
  M.Color := BgClr;
  if Bold then
    M.Font.Style := [fsBold];
  M.HAlign := Align;
  M.VAlign := vaCenter;
  M.WordWrap := True;
  M.AutoWidth := False;
  if AStretchActual then
    M.StretchMode := smActualHeight
  else
    M.StretchMode := smMaxHeight;
  M.GapX := 3;
  M.GapY := 2;
  if BorderColor <> clNone then
  begin
    M.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    M.Frame.Color := BorderColor;
  end
  else
    M.Frame.Typ := [];
end;

{ ============================================================================ }
{ 1. Cari Listesi Raporu (Image 1 Referansı)                                  }
{ ============================================================================ }

class procedure TPrintService.PrintCariListesi(ACariListVM: TCariListViewModel; AFirmaVM: TFirmaViewModel);
var
  Rpt: TfrxReport;
  Page: TfrxReportPage;
  PageW: Extended;
  CKod, CUnvan, CNotlar, CSehir, CSonIslem, CBakiye: Extended;
  X0, X1, X2, X3, X4, X5: Extended;
  Ozet: TBakiyeOzet;
  FirmaUnvan, NetStr, OzetMetin: string;
  Helper: TCariListDataHelper;
  DS: TfrxUserDataSet;
  Hdr: TfrxPageHeader;
  DataBand: TfrxMasterData;
  RFtr: TfrxReportSummary;
  Ftr: TfrxPageFooter;
begin
  FirmaUnvan := '';
  if Assigned(AFirmaVM) and Assigned(AFirmaVM.AktifFirma) then
    FirmaUnvan := AFirmaVM.AktifFirma.Unvan;

  Helper := TCariListDataHelper.Create(ACariListVM.Cariler);
  Rpt := CreateBaseReport('Gelesiye — Cari Hesap Listesi');
  try
    DS := TfrxUserDataSet.Create(Rpt);
    DS.Name := 'CariDS';
    DS.UserName := 'CariDS';
    DS.RangeEnd := reLast;
    DS.Fields.Add('KOD');
    DS.Fields.Add('UNVAN');
    DS.Fields.Add('NOTLAR');
    DS.Fields.Add('SEHIR');
    DS.Fields.Add('SON_ISLEM');
    DS.Fields.Add('BAKIYE');
    DS.OnFirst := Helper.OnFirst;
    DS.OnNext := Helper.OnNext;
    DS.OnCheckEOF := Helper.OnCheckEOF;
    DS.OnGetValue := Helper.OnGetValue;
    Rpt.EnabledDataSets.Add(DS);

    Page := CreatePage(Rpt, poLandscape);
    PageW := GetPagePrintableWidth(Page);

    CKod := Round(PageW * 0.08);
    CUnvan := Round(PageW * 0.26);
    CNotlar := Round(PageW * 0.32);
    CSehir := Round(PageW * 0.13);
    CSonIslem := Round(PageW * 0.09);
    CBakiye := PageW - (CKod + CUnvan + CNotlar + CSehir + CSonIslem);

    X0 := 0;
    X1 := CKod;
    X2 := X1 + CUnvan;
    X3 := X2 + CNotlar;
    X4 := X3 + CSehir;
    X5 := X4 + CSonIslem;

    { Sayfa ve kolon başlığı (Tek PageHeader) }
    Hdr := TfrxPageHeader.Create(Page);
    Hdr.Height := 72;
    AddMemo(Hdr, 0, 0, PageW * 0.5, 22, 'CAR' + #304 + ' HESAP L' + #304 + 'STES' + #304, 12, True, haLeft, $00107FD2);
    AddMemo(Hdr, 0, 24, PageW * 0.5, 14, IntToStr(ACariListVM.KayitSayisi) + ' cari kay' + #305 + 't', 8, False, haLeft, $007B8B9E);
    AddMemo(Hdr, PageW * 0.5, 0, PageW * 0.5, 20, FirmaUnvan, 9, True, haRight, clBlack);
    AddMemo(Hdr, PageW * 0.5, 22, PageW * 0.5, 14, 'Yazd'#305'rma Tarihi ' + FormatDateTime('dd.mm.yyyy HH:nn', Now), 8, False, haRight, $007B8B9E);

    AddCell(Hdr, X0, 48, CKod, 22, 'Cari Kod', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X1, 48, CUnvan, 22, 'Cari Unvan', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X2, 48, CNotlar, 22, 'A' + #231 + #305 + 'klama / Not', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X3, 48, CSehir, 22, #350 + 'ehir / '#304 + 'l' + #231 + 'e', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X4, 48, CSonIslem, 22, 'Son '#304 + #351 + 'lem', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X5, 48, CBakiye, 22, 'Bakiye', True, haRight, clWhite, $00107FD2);

    { Veri bandı }
    DataBand := TfrxMasterData.Create(Page);
    DataBand.DataSet := DS;
    DataBand.Height := 18;
    DataBand.Stretched := True;
    Rpt.OnBeforePrint := Helper.OnReportBeforePrint;

    AddDataCell(DataBand, X0, 0, CKod, 18, DS, 'KOD', False, haLeft, clBlack);
    AddDataCell(DataBand, X1, 0, CUnvan, 18, DS, 'UNVAN', False, haLeft, clBlack, clWhite, $00CBD5E1, True);
    AddDataCell(DataBand, X2, 0, CNotlar, 18, DS, 'NOTLAR', False, haLeft, clBlack, clWhite, $00CBD5E1, True);
    AddDataCell(DataBand, X3, 0, CSehir, 18, DS, 'SEHIR', False, haLeft, clBlack);
    AddDataCell(DataBand, X4, 0, CSonIslem, 18, DS, 'SON_ISLEM', False, haLeft, clBlack);
    AddDataCell(DataBand, X5, 0, CBakiye, 18, DS, 'BAKIYE', False, haRight, clBlack);

    { Rapor özet }
    RFtr := TfrxReportSummary.Create(Page);
    RFtr.Height := 24;
    Ozet := ACariListVM.GetListeToplamlari;

    if Ozet.NetBakiye > 0.001 then
      NetStr := FormatPara(Ozet.NetBakiye) + ' Bor' + #231
    else if Ozet.NetBakiye < -0.001 then
      NetStr := FormatPara(Abs(Ozet.NetBakiye)) + ' Alacak'
    else
      NetStr := '0,00 TL';

    OzetMetin := Format('Toplam Cari: %d | Bor' + #231 + 'lu: %d (%s) | Alacakl' + #305 + ': %d (%s) | Net Bakiye: %s', [Ozet.ToplamCariSayisi, Ozet.BorcluCariSayisi, FormatPara(Ozet.GenelBorcluToplam), Ozet.AlacakliCariSayisi, FormatPara(Ozet.GenelAlacakliToplam), NetStr]);

    AddCell(RFtr, 0, 3, PageW, 18, '  ' + OzetMetin, True, haLeft, clBlack, clWhite, $00CBD5E1);

    { Sayfa footer }
    Ftr := TfrxPageFooter.Create(Page);
    Ftr.Height := 16;
    AddMemo(Ftr, 0, 2, PageW * 0.6, 12, 'Gelesiye '#8212' Cari ve Veresiye Takip Sistemi', 7, False, haLeft, $007B8B9E);
    AddMemo(Ftr, PageW * 0.6, 2, PageW * 0.4, 12, 'Sayfa [PAGE#] / [TOTALPAGES#]', 7, False, haRight, $007B8B9E);

    frmReportPreview := TfrmReportPreview.Create(nil);
    try
      Rpt.Preview := frmReportPreview.Preview;
      if Rpt.PrepareReport(True) then
        frmReportPreview.ShowReport(Rpt, 'Cari Hesap Listesi');
    finally
      FreeAndNil(frmReportPreview);
    end;
  finally
    Helper.Free;
    Rpt.Free;
  end;
end;

{ ============================================================================ }
{ 2. Cari Ekstre Raporu (Image 2 Referansı)                                    }
{ ============================================================================ }

class procedure TPrintService.PrintCariEkstre(AHareketVM: THareketViewModel);
var
  Rpt: TfrxReport;
  Page: TfrxReportPage;
  PageW: Extended;
  CTarih, CTur, CAciklama, CBorc, CAlacak, CBakiye: Extended;
  X0, X1, X2, X3, X4, X5: Extended;
  Helper: THareketDataHelper;
  DS: TfrxUserDataSet;
  Hdr: TfrxPageHeader;
  DataBand: TfrxMasterData;
  RFtr: TfrxReportSummary;
  Ftr: TfrxPageFooter;
  CariUnvanFull, TelHdr, SehirStr: string;
  BakiyeClr, NetBakiyeClr: TColor;
begin
  if (AHareketVM = nil) or (AHareketVM.Cari = nil) then
    Exit;

  Helper := THareketDataHelper.Create(AHareketVM.Hareketler);
  Rpt := CreateBaseReport('Gelesiye — Cari Hesap Ekstresi (' + AHareketVM.Cari.Unvan + ')');
  try
    DS := TfrxUserDataSet.Create(Rpt);
    DS.Name := 'HrkDS';
    DS.UserName := 'HrkDS';
    DS.RangeEnd := reLast;
    DS.Fields.Add('TARIH');
    DS.Fields.Add('TUR');
    DS.Fields.Add('ACIKLAMA');
    DS.Fields.Add('BORC');
    DS.Fields.Add('ALACAK');
    DS.Fields.Add('BAKIYE');
    DS.OnFirst := Helper.OnFirst;
    DS.OnNext := Helper.OnNext;
    DS.OnCheckEOF := Helper.OnCheckEOF;
    DS.OnGetValue := Helper.OnGetValue;
    Rpt.EnabledDataSets.Add(DS);

    Page := CreatePage(Rpt, poLandscape);
    PageW := GetPagePrintableWidth(Page);

    CTarih := Round(PageW * 0.13);
    CTur := Round(PageW * 0.12);
    CAciklama := Round(PageW * 0.45);
    CBorc := Round(PageW * 0.10);
    CAlacak := Round(PageW * 0.10);
    CBakiye := PageW - (CTarih + CTur + CAciklama + CBorc + CAlacak);

    X0 := 0;
    X1 := CTarih;
    X2 := X1 + CTur;
    X3 := X2 + CAciklama;
    X4 := X3 + CBorc;
    X5 := X4 + CAlacak;

    { Sayfa ve kolon başlığı (Tek PageHeader) }
    Hdr := TfrxPageHeader.Create(Page);
    Hdr.Height := 82;
    AddMemo(Hdr, 0, 0, PageW * 0.6, 20, 'CAR' + #304 + ' HESAP EKSTRES' + #304, 12, True, haLeft, $00107FD2);

    CariUnvanFull := FormatCariUnvan(AHareketVM.Cari);
    AddMemo(Hdr, 0, 20, PageW * 0.6, 16, 'Cari: ' + CariUnvanFull, 10, True, haLeft, clBlack);

    if AHareketVM.Cari.Gsm <> '' then
      TelHdr := AHareketVM.Cari.Gsm
    else
      TelHdr := AHareketVM.Cari.Telefon;
    SehirStr := AHareketVM.Cari.Il;
    AddMemo(Hdr, 0, 38, PageW * 0.6, 14, 'Cari Kodu: ' + AHareketVM.Cari.CariKodu + ' | Tel: ' + TelHdr + ' | '#350'ehir: ' + SehirStr, 8, False, haLeft, $007B8B9E);

    AddMemo(Hdr, PageW * 0.6, 0, PageW * 0.4, 14, 'Yazd'#305'rma: ' + FormatDateTime('dd.mm.yyyy HH:nn', Now), 8, False, haRight, $007B8B9E);
    AddMemo(Hdr, PageW * 0.6, 16, PageW * 0.4, 14, IntToStr(AHareketVM.KayitSayisi) + ' i'#351'lem kayd'#305, 8, False, haRight, $007B8B9E);

    if AHareketVM.NetBakiye > 0.001 then
      BakiyeClr := $001A1AD4
    else if AHareketVM.NetBakiye < -0.001 then
      BakiyeClr := $0015803D
    else
      BakiyeClr := clBlack;
    AddMemo(Hdr, PageW * 0.6, 34, PageW * 0.4, 16, 'G'#252'ncel Bakiye: ' + BakiyeStr(AHareketVM.NetBakiye), 9, True, haRight, BakiyeClr);

    { Kolon başlıkları }
    AddCell(Hdr, X0, 60, CTarih, 20, 'Tarih', True, haLeft, clWhite, $001E3A5F);
    AddCell(Hdr, X1, 60, CTur, 20, 'T' + #252 + 'r', True, haLeft, clWhite, $001E3A5F);
    AddCell(Hdr, X2, 60, CAciklama, 20, 'A' + #231 + #305 + 'klama', True, haLeft, clWhite, $001E3A5F);
    AddCell(Hdr, X3, 60, CBorc, 20, 'Bor' + #231, True, haRight, clWhite, $001E3A5F);
    AddCell(Hdr, X4, 60, CAlacak, 20, 'Alacak', True, haRight, clWhite, $001E3A5F);
    AddCell(Hdr, X5, 60, CBakiye, 20, 'Bakiye', True, haRight, clWhite, $001E3A5F);

    { Veri bandı }
    DataBand := TfrxMasterData.Create(Page);
    DataBand.DataSet := DS;
    DataBand.Height := 18;
    DataBand.Stretched := True;
    Rpt.OnBeforePrint := Helper.OnReportBeforePrint;

    AddDataCell(DataBand, X0, 0, CTarih, 18, DS, 'TARIH', False, haLeft, clBlack);
    AddDataCell(DataBand, X1, 0, CTur, 18, DS, 'TUR', False, haLeft, clBlack);
    AddDataCell(DataBand, X2, 0, CAciklama, 18, DS, 'ACIKLAMA', False, haLeft, clBlack, clWhite, $00CBD5E1, True);
    AddDataCell(DataBand, X3, 0, CBorc, 18, DS, 'BORC', False, haRight, clBlack);
    AddDataCell(DataBand, X4, 0, CAlacak, 18, DS, 'ALACAK', False, haRight, clBlack);
    AddDataCell(DataBand, X5, 0, CBakiye, 18, DS, 'BAKIYE', False, haRight, clBlack);

    { Özet Bandı (GENEL TOPLAMLAR tablosu) }
    RFtr := TfrxReportSummary.Create(Page);
    RFtr.Height := 20;

    AddCell(RFtr, X0, 0, X2, 20, 'GENEL TOPLAMLAR', True, haCenter, clBlack, clWhite, $00CBD5E1);
    AddCell(RFtr, X2, 0, CAciklama, 20, IntToStr(AHareketVM.Hareketler.Count) + ' Hareket', False, haCenter, $007B8B9E, clWhite, $00CBD5E1);
    AddCell(RFtr, X3, 0, CBorc, 20, FormatPara(AHareketVM.ToplamBorc), True, haRight, $001A1AD4, clWhite, $00CBD5E1);
    AddCell(RFtr, X4, 0, CAlacak, 20, FormatPara(AHareketVM.ToplamAlacak), True, haRight, $0015803D, clWhite, $00CBD5E1);

    if AHareketVM.NetBakiye > 0.001 then
      NetBakiyeClr := $001A1AD4
    else if AHareketVM.NetBakiye < -0.001 then
      NetBakiyeClr := $0015803D
    else
      NetBakiyeClr := clBlack;
    AddCell(RFtr, X5, 0, CBakiye, 20, FormatPara(Abs(AHareketVM.NetBakiye)), True, haRight, NetBakiyeClr, clWhite, $00CBD5E1);

    { Sayfa footer }
    Ftr := TfrxPageFooter.Create(Page);
    Ftr.Height := 16;
    AddMemo(Ftr, 0, 2, PageW * 0.6, 12, 'Gelesiye '#8212' Cari ve Veresiye Takip Sistemi', 7, False, haLeft, $007B8B9E);
    AddMemo(Ftr, PageW * 0.6, 2, PageW * 0.4, 12, 'Sayfa [PAGE#] / [TOTALPAGES#]', 7, False, haRight, $007B8B9E);

    frmReportPreview := TfrmReportPreview.Create(nil);
    try
      Rpt.Preview := frmReportPreview.Preview;
      if Rpt.PrepareReport(True) then
        frmReportPreview.ShowReport(Rpt, 'Cari Hesap Ekstresi — ' + AHareketVM.Cari.Unvan);
    finally
      FreeAndNil(frmReportPreview);
    end;
  finally
    Helper.Free;
    Rpt.Free;
  end;
end;

{ ============================================================================ }
{ 3. Hareket Dekontu                                                           }
{ ============================================================================ }

class procedure TPrintService.PrintHareketDekontu(const AHareket: IHareket; const ACari: ICari;
  const AOncekiBakiye: Currency; const ASonrakiBakiye: Currency);
var
  Rpt: TfrxReport;
  Page: TfrxReportPage;
  Band: TfrxReportTitle;
  M: TfrxMemoView;
  PageW: Extended;
  HeaderColor: TColor;
  LW, VW, VX, Y, RH: Extended;
  TutarLabel, TutarDeger, TelStr, IlStr: string;
  TutarRenk: TColor;
  OncekiBakiye, SonrakiBakiye, IslemEtkisi: Currency;
  OncekiRenk, SonrakiRenk: TColor;

  procedure InfoRow(const ALabel, AValue: string; Bold: Boolean = False; VClr: TColor = clBlack);
  var
    ML, MV: TfrxMemoView;
  begin
    ML := TfrxMemoView.Create(Band);
    ML.SetBounds(0, Y, LW, RH);
    ML.Text := ALabel;
    ML.Font.Name := 'Segoe UI';
    ML.Font.Size := 9;
    ML.Font.Color := $007B8B9E;
    ML.HAlign := haLeft;
    ML.VAlign := vaCenter;

    MV := TfrxMemoView.Create(Band);
    MV.SetBounds(VX, Y, VW, RH);
    MV.Text := AValue;
    MV.Font.Name := 'Segoe UI';
    MV.Font.Size := 9;
    MV.Font.Color := VClr;
    if Bold then
      MV.Font.Style := [fsBold];
    MV.HAlign := haLeft;
    MV.VAlign := vaCenter;
    MV.Frame.Typ := [ftBottom];
    MV.Frame.Color := $00CBD5E1;

    Y := Y + RH;
  end;

begin
  if (AHareket = nil) or (ACari = nil) then
    Exit;

  case AHareket.IslemTuru of
    itBorc:
      HeaderColor := $001E3A5F;
    itTahsilat:
      HeaderColor := $0015803D;
    itAlacak:
      HeaderColor := $004338CA;
    itOdeme:
      HeaderColor := $00B91C1C;
    itDevir:
      HeaderColor := $00334155;
  else
    HeaderColor := $00555555;
  end;

  case AHareket.IslemTuru of
    itBorc:
    begin
      TutarLabel := 'Bor' + #231 + ' Tutar' + #305;
      if AHareket.Borc > 0.001 then
        TutarDeger := FormatPara(AHareket.Borc)
      else
        TutarDeger := FormatPara(AHareket.Alacak);
      TutarRenk := $001A1AD4;
    end;
    itTahsilat:
    begin
      TutarLabel := 'Tahsilat Tutar' + #305;
      if AHareket.Alacak > 0.001 then
        TutarDeger := FormatPara(AHareket.Alacak)
      else
        TutarDeger := FormatPara(AHareket.Borc);
      TutarRenk := $0015803D;
    end;
    itAlacak:
    begin
      TutarLabel := 'Alacak Tutar' + #305;
      if AHareket.Alacak > 0.001 then
        TutarDeger := FormatPara(AHareket.Alacak)
      else
        TutarDeger := FormatPara(AHareket.Borc);
      TutarRenk := $004338CA;
    end;
    itOdeme:
    begin
      TutarLabel := #214 + 'deme Tutar' + #305;
      if AHareket.Borc > 0.001 then
        TutarDeger := FormatPara(AHareket.Borc)
      else
        TutarDeger := FormatPara(AHareket.Alacak);
      TutarRenk := $00B91C1C;
    end;
    itDevir:
    begin
      TutarLabel := 'Devir Tutar' + #305;
      if AHareket.Borc > 0.001 then
      begin
        TutarDeger := FormatPara(AHareket.Borc);
        TutarRenk := $001A1AD4;
      end
      else
      begin
        TutarDeger := FormatPara(AHareket.Alacak);
        TutarRenk := $0015803D;
      end;
    end;
  else
    TutarLabel := #304 + #351 + 'lem Tutar' + #305;
    if AHareket.Borc > 0.001 then
    begin
      TutarDeger := FormatPara(AHareket.Borc);
      TutarRenk := $001A1AD4;
    end
    else
    begin
      TutarDeger := FormatPara(AHareket.Alacak);
      TutarRenk := $0015803D;
    end;
  end;

  // Onceki ve Sonraki Bakiye hesaplama
  if (AOncekiBakiye <> 0) or (ASonrakiBakiye <> 0) then
  begin
    OncekiBakiye := AOncekiBakiye;
    SonrakiBakiye := ASonrakiBakiye;
  end
  else
  begin
    // Net islem etkisi: Borc artirir (+), Alacak eksiltir (-)
    if (AHareket.Borc > 0.001) and (AHareket.Alacak < 0.001) then
    begin
      if AHareket.IslemTuru in [itTahsilat, itAlacak] then
        IslemEtkisi := -AHareket.Borc
      else
        IslemEtkisi := AHareket.Borc;
    end
    else if (AHareket.Alacak > 0.001) and (AHareket.Borc < 0.001) then
    begin
      if AHareket.IslemTuru in [itBorc, itOdeme] then
        IslemEtkisi := AHareket.Alacak
      else
        IslemEtkisi := -AHareket.Alacak;
    end
    else
      IslemEtkisi := AHareket.Borc - AHareket.Alacak;

    SonrakiBakiye := AHareket.YuruyenBakiye;
    OncekiBakiye := SonrakiBakiye - IslemEtkisi;
  end;

  if OncekiBakiye > 0.001 then
    OncekiRenk := $001A1AD4
  else if OncekiBakiye < -0.001 then
    OncekiRenk := $0015803D
  else
    OncekiRenk := clBlack;

  if SonrakiBakiye > 0.001 then
    SonrakiRenk := $001A1AD4
  else if SonrakiBakiye < -0.001 then
    SonrakiRenk := $0015803D
  else
    SonrakiRenk := clBlack;

  Rpt := CreateBaseReport('Gelesiye — ' + IslemTuruStr(AHareket.IslemTuru) + ' Dekontu');
  try
    Page := CreatePage(Rpt, poPortrait);
    PageW := GetPagePrintableWidth(Page);

    Band := TfrxReportTitle.Create(Page);
    Band.Height := 430;

    LW := PageW * 0.35;
    VW := PageW * 0.65;
    VX := PageW * 0.35;
    RH := 22;

    // Başlık kutusu arka plan
    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, 0, PageW, 52);
    M.Color := HeaderColor;
    M.Frame.Typ := [];
    M.Text := '';

    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, 8, PageW, 22);
    M.Text := UpperCase(IslemTuruStr(AHareket.IslemTuru));
    M.Font.Name := 'Segoe UI';
    M.Font.Size := 14;
    M.Font.Style := [fsBold];
    M.Font.Color := clWhite;
    M.Color := HeaderColor;
    M.HAlign := haCenter;
    M.VAlign := vaCenter;

    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, 32, PageW, 16);
    M.Text := 'Gelesiye ' + #8212 + ' Cari ve Veresiye Takip';
    M.Font.Name := 'Segoe UI';
    M.Font.Size := 8;
    M.Font.Color := $00E0E8F0;
    M.Color := HeaderColor;
    M.HAlign := haCenter;

    // Bilgi alanı çerçeve (10 satır x RH + 4)
    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, 58, PageW, 10 * RH + 4);
    M.Color := clWhite;
    M.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    M.Frame.Color := $00CBD5E1;
    M.Text := '';

    // Bilgi satırları
    Y := 62;
    if ACari.Gsm <> '' then
      TelStr := ACari.Gsm
    else
      TelStr := ACari.Telefon;
    if ACari.Ilce <> '' then
      IlStr := ACari.Il + ' / ' + ACari.Ilce
    else
      IlStr := ACari.Il;

    InfoRow('Cari Unvan', ACari.Unvan, True);
    InfoRow('Cari Kodu', ACari.CariKodu);
    InfoRow('Telefon', TelStr);
    InfoRow(#350 + 'ehir / ' + #304 + 'l' + #231 + 'e', IlStr);
    InfoRow(#304 + #351 + 'lem Tarihi', FormatTarih(AHareket.Tarih));
    InfoRow(#304 + #351 + 'lem T' + #252 + 'r' + #252, IslemTuruStr(AHareket.IslemTuru));
    InfoRow('A' + #231 + #305 + 'klama', AHareket.Aciklama);
    InfoRow(#214 + 'nceki Bakiye', BakiyeStr(OncekiBakiye), True, OncekiRenk);
    InfoRow(TutarLabel, TutarDeger, True, TutarRenk);
    InfoRow('Sonraki Bakiye', BakiyeStr(SonrakiBakiye), True, SonrakiRenk);

    // Tutar kutusu (Genişletilmiş ve ortalanmış, kırpılmayı önler)
    Y := Y + 12;
    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, Y, PageW, 68);
    M.Color := $00F1F5F9;
    M.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    M.Frame.Color := $00CBD5E1;
    M.Text := '';

    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, Y + 6, PageW, 14);
    M.Text := 'TUTAR';
    M.Font.Name := 'Segoe UI';
    M.Font.Size := 8;
    M.Font.Color := $007B8B9E;
    M.Color := $00F1F5F9;
    M.HAlign := haCenter;

    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, Y + 22, PageW, 38);
    M.Text := TutarDeger;
    M.Font.Name := 'Segoe UI';
    M.Font.Size := 18;
    M.Font.Style := [fsBold];
    M.Font.Color := TutarRenk;
    M.Color := $00F1F5F9;
    M.HAlign := haCenter;
    M.VAlign := vaCenter;

    Y := Y + 78;
    M := TfrxMemoView.Create(Band);
    M.SetBounds(0, Y, PageW, 16);
    M.Text := 'Bu belge bilgi ama' + #231 + 'l' + #305 + 'd' + #305 + 'r.  ' + 'Tarih: ' + FormatDateTime('dd.mm.yyyy HH:nn', Now);
    M.Font.Name := 'Segoe UI';
    M.Font.Size := 7;
    M.Font.Color := $007B8B9E;
    M.HAlign := haCenter;
    M.VAlign := vaCenter;

    Band.Height := Y + 28;

    frmReportPreview := TfrmReportPreview.Create(nil);
    try
      Rpt.Preview := frmReportPreview.Preview;
      if Rpt.PrepareReport(True) then
        frmReportPreview.ShowReport(Rpt, IslemTuruStr(AHareket.IslemTuru) + ' Dekontu');
    finally
      FreeAndNil(frmReportPreview);
    end;
  finally
    Rpt.Free;
  end;
end;

{ ============================================================================ }
{ TCariHareketDetayDataHelper                                                   }
{ ============================================================================ }

constructor TCariHareketDetayDataHelper.Create(AList: TList<TDetayRow>);
begin
  inherited Create;
  FList := AList;
  FIndex := 0;
end;

destructor TCariHareketDetayDataHelper.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TCariHareketDetayDataHelper.OnFirst(Sender: TObject);
begin
  FIndex := 0;
end;

procedure TCariHareketDetayDataHelper.OnNext(Sender: TObject);
begin
  Inc(FIndex);
end;

procedure TCariHareketDetayDataHelper.OnCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := FIndex >= FList.Count;
end;

procedure TCariHareketDetayDataHelper.OnGetValue(const VarName: string; var Value: Variant);
var
  R: TDetayRow;
begin
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;
  R := FList[FIndex];
  if SameText(VarName, 'TARIH') then
    Value := R.Tarih
  else if SameText(VarName, 'TUR') then
    Value := R.Tur
  else if SameText(VarName, 'ACIKLAMA') then
    Value := R.Aciklama
  else if SameText(VarName, 'BORC') then
    Value := R.Borc
  else if SameText(VarName, 'ALACAK') then
    Value := R.Alacak
  else if SameText(VarName, 'BAKIYE') then
    Value := R.Bakiye;
end;

procedure TCariHareketDetayDataHelper.OnReportBeforePrint(Sender: TfrxReportComponent);
var
  M: TfrxMemoView;
  R: TDetayRow;
begin
  if not (Sender is TfrxMemoView) then
    Exit;
  M := TfrxMemoView(Sender);
  if M.DataSet = nil then
    Exit;
  if (FIndex < 0) or (FIndex >= FList.Count) then
    Exit;

  R := FList[FIndex];

  case R.RowType of
    drtCariHeader:
      begin
        M.Color := $00F8FAFC;
        M.Font.Style := [fsBold];
        if M.DataField = 'TARIH' then
          M.Font.Color := $000A78D2
        else if M.DataField = 'TUR' then
          M.Font.Color := $0064748B
        else if M.DataField = 'ACIKLAMA' then
          M.Font.Color := clBlack
        else if M.DataField = 'BAKIYE' then
        begin
          if R.BakiyeVal > 0.001 then
            M.Font.Color := $001A1AD4
          else if R.BakiyeVal < -0.001 then
            M.Font.Color := $0015803D
          else
            M.Font.Color := clBlack;
        end
        else
          M.Font.Color := clBlack;
      end;

    drtCariTotal:
      begin
        M.Color := clWhite;
        M.Font.Style := [fsBold];
        if M.DataField = 'ACIKLAMA' then
          M.Font.Color := clBlack
        else if M.DataField = 'BORC' then
          M.Font.Color := $001A1AD4
        else if M.DataField = 'ALACAK' then
          M.Font.Color := $0015803D
        else if M.DataField = 'BAKIYE' then
        begin
          if R.BakiyeVal > 0.001 then
            M.Font.Color := $001A1AD4
          else if R.BakiyeVal < -0.001 then
            M.Font.Color := $0015803D
          else
            M.Font.Color := clBlack;
        end
        else
          M.Font.Color := clBlack;
      end;

    drtEmpty:
      begin
        M.Color := clWhite;
        M.Font.Style := [fsItalic];
        M.Font.Color := $0094A3B8;
      end;

    drtMovement:
      begin
        M.Color := clWhite;
        if M.DataField = 'TUR' then
        begin
          case R.IslemTuru of
            itBorc:
              M.Font.Color := $001A1AD4;
            itTahsilat:
              M.Font.Color := $0015803D;
            itAlacak:
              M.Font.Color := $004338CA;
            itOdeme:
              M.Font.Color := $000D53B7;
            itDevir:
              M.Font.Color := $007B1FA2;
          else
            M.Font.Color := clBlack;
          end;
          M.Font.Style := [fsBold];
        end
        else if M.DataField = 'BORC' then
        begin
          if R.BorcVal > 0.001 then
          begin
            M.Font.Color := $001A1AD4;
            M.Font.Style := [fsBold];
          end
          else
          begin
            M.Font.Color := clBlack;
            M.Font.Style := [];
          end;
        end
        else if M.DataField = 'ALACAK' then
        begin
          if R.AlacakVal > 0.001 then
          begin
            M.Font.Color := $0015803D;
            M.Font.Style := [fsBold];
          end
          else
          begin
            M.Font.Color := clBlack;
            M.Font.Style := [];
          end;
        end
        else if M.DataField = 'BAKIYE' then
        begin
          if R.BakiyeVal > 0.001 then
          begin
            M.Font.Color := $001A1AD4;
            M.Font.Style := [fsBold];
          end
          else if R.BakiyeVal < -0.001 then
          begin
            M.Font.Color := $0015803D;
            M.Font.Style := [fsBold];
          end
          else
          begin
            M.Font.Color := clBlack;
            M.Font.Style := [];
          end;
        end
        else
        begin
          M.Font.Color := clBlack;
          M.Font.Style := [];
        end;
      end;
  end;
end;

{ ============================================================================ }
{ 4. Hareket Detaylı Cari Raporu (Image 4 Referansı)                           }
{ ============================================================================ }

class procedure TPrintService.PrintCariHareketDetayli(ACariListVM: TCariListViewModel; AFirmaVM: TFirmaViewModel);
var
  Rpt: TfrxReport;
  Page: TfrxReportPage;
  PageW: Extended;
  CKod, CTur, CAciklama, CBorc, CTahsilat, CBakiye: Extended;
  X0, X1, X2, X3, X4, X5: Extended;
  FirmaUnvan, CariUnvanFull, SehirStr: string;
  Rows: TList<TDetayRow>;
  Helper: TCariHareketDetayDataHelper;
  DS: TfrxUserDataSet;
  Hdr: TfrxPageHeader;
  DataBand: TfrxMasterData;
  RFtr: TfrxReportSummary;
  Ftr: TfrxPageFooter;
  C: ICari;
  H: IHareket;
  HrkList: TList<IHareket>;
  Row: TDetayRow;
  CariBorcTop, CariAlacakTop: Currency;
  GenelBorcTop, GenelAlacakTop, NetGenelTop: Currency;
  NetGenelClr: TColor;
  GenelHrkSayisi: Integer;
  HRepo: IHareketRepository;
begin
  if (ACariListVM = nil) or (ACariListVM.Cariler.Count = 0) then
    Exit;

  FirmaUnvan := '';
  if Assigned(AFirmaVM) and Assigned(AFirmaVM.AktifFirma) then
    FirmaUnvan := AFirmaVM.AktifFirma.Unvan;

  HRepo := TDbFactory.GetHareketRepository;
  Rows := TList<TDetayRow>.Create;
  GenelBorcTop := 0;
  GenelAlacakTop := 0;
  GenelHrkSayisi := 0;

  for C in ACariListVM.Cariler do
  begin
    // 1. Cari Başlık Satırı
    Row.RowType := drtCariHeader;
    Row.Tarih := C.CariKodu;
    Row.Tur := 'CAR' + #304;

    CariUnvanFull := FormatCariUnvan(C);

    SehirStr := '';
    if (C.Il <> '') and (C.Ilce <> '') then
      SehirStr := C.Il + ' / ' + C.Ilce
    else if C.Il <> '' then
      SehirStr := C.Il
    else
      SehirStr := C.Ilce;

    Row.Aciklama := CariUnvanFull;
    if SehirStr <> '' then
      Row.Aciklama := Row.Aciklama + ' (' + SehirStr + ')';

    Row.Borc := '';
    Row.Alacak := '';
    Row.Bakiye := FormatPara(C.Bakiye);
    Row.IslemTuru := itBorc;
    Row.BorcVal := 0;
    Row.AlacakVal := 0;
    Row.BakiyeVal := C.Bakiye;
    Rows.Add(Row);

    // Hareketleri çek
    HrkList := HRepo.GetByCariId(C.Id);
    try
      if (HrkList = nil) or (HrkList.Count = 0) then
      begin
        Row.RowType := drtEmpty;
        Row.Tarih := '';
        Row.Tur := '';
        Row.Aciklama := '- Bu cari hesaba ait hareket kayd'#305' bulunmamaktad'#305'r -';
        Row.Borc := '';
        Row.Alacak := '';
        Row.Bakiye := '';
        Row.BorcVal := 0;
        Row.AlacakVal := 0;
        Row.BakiyeVal := 0;
        Rows.Add(Row);
      end
      else
      begin
        CariBorcTop := 0;
        CariAlacakTop := 0;
        for H in HrkList do
        begin
          Row.RowType := drtMovement;
          Row.Tarih := FormatDateTime('dd.mm.yyyy', H.Tarih);
          Row.Tur := IslemTuruStr(H.IslemTuru);
          Row.Aciklama := H.Aciklama;
          if H.Borc > 0.001 then
          begin
            Row.Borc := FormatPara(H.Borc);
            Row.BorcVal := H.Borc;
            CariBorcTop := CariBorcTop + H.Borc;
          end
          else
          begin
            Row.Borc := '';
            Row.BorcVal := 0;
          end;

          if H.Alacak > 0.001 then
          begin
            Row.Alacak := FormatPara(H.Alacak);
            Row.AlacakVal := H.Alacak;
            CariAlacakTop := CariAlacakTop + H.Alacak;
          end
          else
          begin
            Row.Alacak := '';
            Row.AlacakVal := 0;
          end;

          Row.Bakiye := FormatPara(H.YuruyenBakiye);
          Row.BakiyeVal := H.YuruyenBakiye;
          Row.IslemTuru := H.IslemTuru;
          Rows.Add(Row);
          Inc(GenelHrkSayisi);
        end;

        // Cari Ara Toplam Satırı
        Row.RowType := drtCariTotal;
        Row.Tarih := '';
        Row.Tur := '';
        Row.Aciklama := CariUnvanFull + ' Ara Toplam'#305' (' + IntToStr(HrkList.Count) + ' Hareket)';
        Row.Borc := FormatPara(CariBorcTop);
        Row.Alacak := FormatPara(CariAlacakTop);
        Row.Bakiye := FormatPara(C.Bakiye);
        Row.BorcVal := CariBorcTop;
        Row.AlacakVal := CariAlacakTop;
        Row.BakiyeVal := C.Bakiye;
        Rows.Add(Row);

        GenelBorcTop := GenelBorcTop + CariBorcTop;
        GenelAlacakTop := GenelAlacakTop + CariAlacakTop;
      end;
    finally
      HrkList.Free;
    end;
  end;

  Helper := TCariHareketDetayDataHelper.Create(Rows);
  Rpt := CreateBaseReport('Gelesiye — Hareket Detaylı Cari Raporu');
  try
    DS := TfrxUserDataSet.Create(Rpt);
    DS.Name := 'DetayDS';
    DS.UserName := 'DetayDS';
    DS.RangeEnd := reLast;
    DS.Fields.Add('TARIH');
    DS.Fields.Add('TUR');
    DS.Fields.Add('ACIKLAMA');
    DS.Fields.Add('BORC');
    DS.Fields.Add('ALACAK');
    DS.Fields.Add('BAKIYE');
    DS.OnFirst := Helper.OnFirst;
    DS.OnNext := Helper.OnNext;
    DS.OnCheckEOF := Helper.OnCheckEOF;
    DS.OnGetValue := Helper.OnGetValue;
    Rpt.EnabledDataSets.Add(DS);

    Page := CreatePage(Rpt, poLandscape);
    PageW := GetPagePrintableWidth(Page);

    CKod := Round(PageW * 0.09);
    CTur := Round(PageW * 0.10);
    CAciklama := Round(PageW * 0.45);
    CBorc := Round(PageW * 0.12);
    CTahsilat := Round(PageW * 0.12);
    CBakiye := PageW - (CKod + CTur + CAciklama + CBorc + CTahsilat);

    X0 := 0;
    X1 := CKod;
    X2 := X1 + CTur;
    X3 := X2 + CAciklama;
    X4 := X3 + CBorc;
    X5 := X4 + CTahsilat;

    { Sayfa ve kolon başlığı (Tek PageHeader) }
    Hdr := TfrxPageHeader.Create(Page);
    Hdr.Height := 72;
    AddMemo(Hdr, 0, 0, PageW * 0.5, 22, 'HAREKET DETAYLI CAR' + #304 + ' RAPORU', 12, True, haLeft, $00107FD2);
    AddMemo(Hdr, 0, 24, PageW * 0.5, 14, IntToStr(ACariListVM.KayitSayisi) + ' cari hesap d'#246'k'#252'm'#252, 8, False, haLeft, $007B8B9E);
    AddMemo(Hdr, PageW * 0.5, 0, PageW * 0.5, 20, FirmaUnvan, 9, True, haRight, clBlack);
    AddMemo(Hdr, PageW * 0.5, 22, PageW * 0.5, 14, 'Yazd'#305'rma Tarihi ' + FormatDateTime('dd.mm.yyyy HH:nn', Now), 8, False, haRight, $007B8B9E);

    AddCell(Hdr, X0, 48, CKod, 22, 'Tarih / Kod', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X1, 48, CTur, 22, #304 + #351 + 'lem T' + #252 + 'r' + #252, True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X2, 48, CAciklama, 22, 'A' + #231 + #305 + 'klama / Cari Bilgisi', True, haLeft, clWhite, $00107FD2);
    AddCell(Hdr, X3, 48, CBorc, 22, 'Bor' + #231, True, haRight, clWhite, $00107FD2);
    AddCell(Hdr, X4, 48, CTahsilat, 22, 'Tahsilat / Alacak', True, haRight, clWhite, $00107FD2);
    AddCell(Hdr, X5, 48, CBakiye, 22, 'Bakiye', True, haRight, clWhite, $00107FD2);

    { Veri bandı }
    DataBand := TfrxMasterData.Create(Page);
    DataBand.DataSet := DS;
    DataBand.Height := 18;
    DataBand.Stretched := True;
    Rpt.OnBeforePrint := Helper.OnReportBeforePrint;

    AddDataCell(DataBand, X0, 0, CKod, 18, DS, 'TARIH', False, haLeft, clBlack);
    AddDataCell(DataBand, X1, 0, CTur, 18, DS, 'TUR', False, haLeft, clBlack);
    AddDataCell(DataBand, X2, 0, CAciklama, 18, DS, 'ACIKLAMA', False, haLeft, clBlack, clWhite, $00CBD5E1, True);
    AddDataCell(DataBand, X3, 0, CBorc, 18, DS, 'BORC', False, haRight, clBlack);
    AddDataCell(DataBand, X4, 0, CTahsilat, 18, DS, 'ALACAK', False, haRight, clBlack);
    AddDataCell(DataBand, X5, 0, CBakiye, 18, DS, 'BAKIYE', False, haRight, clBlack);

    { Rapor özet (GENEL TOPLAMLAR tablosu) }
    RFtr := TfrxReportSummary.Create(Page);
    RFtr.Height := 20;

    AddCell(RFtr, X0, 0, X2, 20, 'GENEL TOPLAMLAR', True, haCenter, clBlack, clWhite, $00CBD5E1);
    AddCell(RFtr, X2, 0, CAciklama, 20, IntToStr(ACariListVM.Cariler.Count) + ' Cari | ' + IntToStr(GenelHrkSayisi) + ' Hareket', False, haCenter, $007B8B9E, clWhite, $00CBD5E1);
    AddCell(RFtr, X3, 0, CBorc, 20, FormatPara(GenelBorcTop), True, haRight, $001A1AD4, clWhite, $00CBD5E1);
    AddCell(RFtr, X4, 0, CTahsilat, 20, FormatPara(GenelAlacakTop), True, haRight, $0015803D, clWhite, $00CBD5E1);

    NetGenelTop := GenelBorcTop - GenelAlacakTop;
    if NetGenelTop > 0.001 then
      NetGenelClr := $001A1AD4
    else if NetGenelTop < -0.001 then
      NetGenelClr := $0015803D
    else
      NetGenelClr := clBlack;
    AddCell(RFtr, X5, 0, CBakiye, 20, FormatPara(Abs(NetGenelTop)), True, haRight, NetGenelClr, clWhite, $00CBD5E1);

    { Sayfa footer }
    Ftr := TfrxPageFooter.Create(Page);
    Ftr.Height := 16;
    AddMemo(Ftr, 0, 2, PageW * 0.6, 12, 'Gelesiye '#8212' Cari ve Veresiye Takip Sistemi', 7, False, haLeft, $007B8B9E);
    AddMemo(Ftr, PageW * 0.6, 2, PageW * 0.4, 12, 'Sayfa [PAGE#] / [TOTALPAGES#]', 7, False, haRight, $007B8B9E);

    frmReportPreview := TfrmReportPreview.Create(nil);
    try
      Rpt.Preview := frmReportPreview.Preview;
      if Rpt.PrepareReport(True) then
        frmReportPreview.ShowReport(Rpt, 'Hareket Detaylı Cari Raporu');
    finally
      FreeAndNil(frmReportPreview);
    end;
  finally
    Helper.Free;
    Rpt.Free;
  end;
end;

initialization
  System.Classes.RegisterClass(TfrxUserDataSet);

finalization
  System.Classes.UnRegisterClass(TfrxUserDataSet);

end.
