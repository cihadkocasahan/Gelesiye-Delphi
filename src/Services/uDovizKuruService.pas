unit uDovizKuruService;

interface

uses
  System.SysUtils, System.Classes;

type
  TDovizKurlari = record
    USD: Currency;
    EUR: Currency;
    Basarili: Boolean;
    GuncellemeZamani: TDateTime;
  end;

  TDovizKurCallback = reference to procedure(const AKurlar: TDovizKurlari);

  TDovizKuruService = class
  private
    class function ParseTCMBKur(const AXml, AKod: string): Currency; static;
  public
    class function KurlariAl(out AKurlar: TDovizKurlari): Boolean; static;
    class procedure KurlariAlAsync(ACallback: TDovizKurCallback); static;
    class function FormatKurMetni(const AKurlar: TDovizKurlari): string; static;
  end;

implementation

uses
  System.Net.HttpClient;

class function TDovizKuruService.ParseTCMBKur(const AXml, AKod: string): Currency;
var
  P, P2, PVal, PEnd: Integer;
  Block, Tag, ValStr: string;
  FS: TFormatSettings;
begin
  Result := 0;
  FS := TFormatSettings.Create('en-US');
  FS.DecimalSeparator := '.';

  P := Pos('Kod="' + AKod + '"', AXml);
  if P = 0 then
    P := Pos('CurrencyCode="' + AKod + '"', AXml);
  if P = 0 then Exit;

  P2 := Pos('</Currency>', Copy(AXml, P, 1500));
  if P2 > 0 then
    Block := Copy(AXml, P, P2)
  else
    Block := Copy(AXml, P, 1500);

  // Öncelikle ForexSelling (Döviz Satış), boşsa BanknoteSelling (Efektif Satış) dene
  Tag := '<ForexSelling>';
  PVal := Pos(Tag, Block);
  if (PVal = 0) or (Pos('<ForexSelling></ForexSelling>', Block) > 0) then
  begin
    Tag := '<BanknoteSelling>';
    PVal := Pos(Tag, Block);
  end;

  if PVal > 0 then
  begin
    Inc(PVal, Length(Tag));
    PEnd := Pos('</', Copy(Block, PVal, 40));
    if PEnd > 0 then
    begin
      ValStr := Trim(Copy(Block, PVal, PEnd - 1));
      Result := StrToCurrDef(ValStr, 0, FS);
    end;
  end;
end;

class function TDovizKuruService.KurlariAl(out AKurlar: TDovizKurlari): Boolean;
var
  Client: THTTPClient;
  Resp: IHTTPResponse;
  XmlContent: string;
begin
  AKurlar.USD := 0;
  AKurlar.EUR := 0;
  AKurlar.Basarili := False;
  AKurlar.GuncellemeZamani := Now;

  try
    Client := THTTPClient.Create;
    try
      Client.ConnectionTimeout := 3500;
      Client.ResponseTimeout := 3500;
      Client.CustomHeaders['User-Agent'] := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Gelesiye/1.0';
      Resp := Client.Get('https://www.tcmb.gov.tr/kurlar/today.xml');
      if (Resp <> nil) and (Resp.StatusCode = 200) then
      begin
        XmlContent := Resp.ContentAsString(TEncoding.UTF8);
        AKurlar.USD := ParseTCMBKur(XmlContent, 'USD');
        AKurlar.EUR := ParseTCMBKur(XmlContent, 'EUR');
        AKurlar.Basarili := (AKurlar.USD > 0) and (AKurlar.EUR > 0);
      end;
    finally
      Client.Free;
    end;
  except
    // Ağ, zaman aşımı veya bağlantı hatası durumunda sessizce başarısız işaretlenir (hata fırlatılmaz)
    AKurlar.Basarili := False;
  end;

  Result := AKurlar.Basarili;
end;

class procedure TDovizKuruService.KurlariAlAsync(ACallback: TDovizKurCallback);
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      Kurlar: TDovizKurlari;
    begin
      KurlariAl(Kurlar);
      if Assigned(ACallback) then
      begin
        TThread.Queue(nil,
          procedure
          begin
            ACallback(Kurlar);
          end);
      end;
    end).Start;
end;

class function TDovizKuruService.FormatKurMetni(const AKurlar: TDovizKurlari): string;
begin
  if not AKurlar.Basarili or (AKurlar.USD <= 0) or (AKurlar.EUR <= 0) then
    Result := ''
  else
    Result := Format('💵 $ %.2f   € %.2f', [AKurlar.USD, AKurlar.EUR]);
end;

end.
