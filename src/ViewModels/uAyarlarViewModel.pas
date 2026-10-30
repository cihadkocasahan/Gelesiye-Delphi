unit uAyarlarViewModel;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uGelesiyeInterfaces;

type
  TAyarlarViewModel = class
  private
    FRepo: IAyarlarRepository;
    FParaBirimi: string;
    FZebraGrid: Boolean;
    FOtoYedekleme: Integer;
    FYedekKlasoru: string;
    FMaksYedekSayisi: Integer;
    FKapatmaEylemi: Integer;
    FSifreKorumasi: Boolean;
    FGirisSifresi: string;
  public
    constructor Create(ARepo: IAyarlarRepository);
    destructor Destroy; override;

    procedure Load;
    procedure Save;

    // Şifre Yönetimi
    function ChangePassword(const AEskiSifre, AYeniSifre, AYeniSifreTekrar: string;
      out AError: string): Boolean;
    function VerifyPassword(const ASifre: string): Boolean;

    // Açıklama Yönetimi
    function GetAciklamalar(const AIslemTuru: Integer): TList<string>;
    procedure AddAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure DeleteAciklama(const AIslemTuru: Integer; const AAciklama: string);
    procedure ClearAciklamalar(const AIslemTuru: Integer);

    // Genel Ayar Özellikleri
    property ParaBirimi: string read FParaBirimi write FParaBirimi;
    property ZebraGrid: Boolean read FZebraGrid write FZebraGrid;
    property OtoYedekleme: Integer read FOtoYedekleme write FOtoYedekleme;
    property YedekKlasoru: string read FYedekKlasoru write FYedekKlasoru;
    property MaksYedekSayisi: Integer read FMaksYedekSayisi write FMaksYedekSayisi;
    property KapatmaEylemi: Integer read FKapatmaEylemi write FKapatmaEylemi;

    // Güvenlik Özellikleri
    property SifreKorumasi: Boolean read FSifreKorumasi write FSifreKorumasi;
  end;

implementation

constructor TAyarlarViewModel.Create(ARepo: IAyarlarRepository);
begin
  inherited Create;
  FRepo := ARepo;
  Load;
end;

destructor TAyarlarViewModel.Destroy;
begin
  inherited Destroy;
end;

procedure TAyarlarViewModel.Load;
begin
  if FRepo = nil then Exit;

  FParaBirimi := FRepo.GetAyar('ParaBirimi', 'TL');
  FZebraGrid := FRepo.GetAyar('ZebraGrid', '1') = '1';
  FOtoYedekleme := StrToIntDef(FRepo.GetAyar('OtoYedekleme', '1'), 1);
  FYedekKlasoru := FRepo.GetAyar('YedekKlasoru', '');
  FMaksYedekSayisi := StrToIntDef(FRepo.GetAyar('MaksYedekSayisi', '10'), 10);
  FKapatmaEylemi := StrToIntDef(FRepo.GetAyar('KapatmaEylemi', '0'), 0);

  FSifreKorumasi := FRepo.GetAyar('SifreKorumasi', '0') = '1';
  FGirisSifresi := FRepo.GetAyar('GirisSifresi', '');
end;

procedure TAyarlarViewModel.Save;
begin
  if FRepo = nil then Exit;

  FRepo.SetAyar('ParaBirimi', Trim(FParaBirimi));
  if FZebraGrid then
    FRepo.SetAyar('ZebraGrid', '1')
  else
    FRepo.SetAyar('ZebraGrid', '0');

  FRepo.SetAyar('OtoYedekleme', IntToStr(FOtoYedekleme));
  FRepo.SetAyar('YedekKlasoru', Trim(FYedekKlasoru));
  FRepo.SetAyar('MaksYedekSayisi', IntToStr(FMaksYedekSayisi));
  FRepo.SetAyar('KapatmaEylemi', IntToStr(FKapatmaEylemi));

  if FSifreKorumasi then
    FRepo.SetAyar('SifreKorumasi', '1')
  else
    FRepo.SetAyar('SifreKorumasi', '0');

  FRepo.SetAyar('GirisSifresi', FGirisSifresi);
end;

function TAyarlarViewModel.ChangePassword(const AEskiSifre, AYeniSifre,
  AYeniSifreTekrar: string; out AError: string): Boolean;
var
  MevcutSifre: string;
begin
  Result := False;
  AError := '';

  MevcutSifre := FGirisSifresi;
  if MevcutSifre = '' then
  begin
    // Henüz şifre kaydedilmediyse varsayılan şifre 'gel'dir.
    // Kullanıcı ilk değiştirmede eski şifreyi boş bırakabilir veya 'gel' yazabilir.
    if (AEskiSifre <> '') and (AEskiSifre <> 'gel') then
    begin
      AError := 'Mevcut program şifreniz hatalı! (Varsayılan şifre: gel)';
      Exit;
    end;
  end
  else
  begin
    if AEskiSifre <> MevcutSifre then
    begin
      AError := 'Mevcut program şifreniz hatalı!';
      Exit;
    end;
  end;

  if Trim(AYeniSifre) = '' then
  begin
    AError := 'Yeni şifre boş bırakılamaz!';
    Exit;
  end;

  if AYeniSifre <> AYeniSifreTekrar then
  begin
    AError := 'Yeni şifre ve tekrarı birbiriyle uyuşmuyor!';
    Exit;
  end;

  FGirisSifresi := AYeniSifre;
  FSifreKorumasi := True;
  Save;
  Result := True;
end;

function TAyarlarViewModel.VerifyPassword(const ASifre: string): Boolean;
var
  HedefSifre: string;
begin
  if not FSifreKorumasi then
    Result := True
  else
  begin
    HedefSifre := FGirisSifresi;
    if HedefSifre = '' then
      HedefSifre := 'gel';
    Result := (ASifre = HedefSifre);
  end;
end;

function TAyarlarViewModel.GetAciklamalar(const AIslemTuru: Integer): TList<string>;
begin
  if FRepo <> nil then
    Result := FRepo.GetAciklamalar(AIslemTuru)
  else
    Result := TList<string>.Create;
end;

procedure TAyarlarViewModel.AddAciklama(const AIslemTuru: Integer; const AAciklama: string);
begin
  if FRepo <> nil then
    FRepo.AddAciklama(AIslemTuru, AAciklama);
end;

procedure TAyarlarViewModel.DeleteAciklama(const AIslemTuru: Integer; const AAciklama: string);
begin
  if FRepo <> nil then
    FRepo.DeleteAciklama(AIslemTuru, AAciklama);
end;

procedure TAyarlarViewModel.ClearAciklamalar(const AIslemTuru: Integer);
begin
  if FRepo <> nil then
    FRepo.ClearAciklamalar(AIslemTuru);
end;

end.
