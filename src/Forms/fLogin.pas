unit fLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  fBase, uGelesiyeInterfaces, uDbFactory, uAyarlarViewModel, fDialog, uGelesiyeTheme;

type
  TfrmLogin = class(TfrmBase)
    pnlCard: TPanel;
    lblBaslik: TLabel;
    lblMesaj: TLabel;
    lblKalanHak: TLabel;
    edtSifre: TEdit;
    pnlBottom: TPanel;
    btnGiris: TButton;
    btnCikis: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnGirisClick(Sender: TObject);
    procedure btnCikisClick(Sender: TObject);
  protected
    procedure ApplyTheme; override;
  private
    FDenemeSayisi: Integer;
  public
    class function Execute: Boolean;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

class function TfrmLogin.Execute: Boolean;
var
  AyarRepo: IAyarlarRepository;
  SifreKorumasi: Boolean;
  F: TfrmLogin;
begin
  Result := True;
  AyarRepo := TDbFactory.GetAyarlarRepository;
  if AyarRepo = nil then Exit;

  SifreKorumasi := AyarRepo.GetAyar('SifreKorumasi', '0') = '1';

  // Şifre koruması kapalıysa doğrudan giriş ver
  if not SifreKorumasi then
    Exit(True);

  F := TfrmLogin.Create(Application);
  try
    Result := (F.ShowModal = mrOk);
  finally
    F.Free;
  end;
end;

procedure TfrmLogin.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;
  if Assigned(pnlCard) then
  begin
    pnlCard.Color := Theme.CardBg;
    pnlCard.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlCard.BevelKind := bkFlat;
    pnlCard.BevelOuter := bvNone;
  end;
  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
  if Assigned(lblBaslik) then
    lblBaslik.Font.Color := Theme.HeaderModalText;
  if Assigned(lblMesaj) then
    lblMesaj.Font.Color := Theme.StatusTextMuted;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  inherited;
  ApplyTheme;
  FDenemeSayisi := 3;
  edtSifre.Text := '';
  lblKalanHak.Caption := 'Kalan Deneme: 3';
  edtSifre.SetFocus;
end;

procedure TfrmLogin.btnGirisClick(Sender: TObject);
var
  KayitliSifre: string;
begin
  KayitliSifre := TDbFactory.GetAyarlarRepository.GetAyar('GirisSifresi', '');
  if KayitliSifre = '' then
    KayitliSifre := 'gel';

  if edtSifre.Text = KayitliSifre then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    Dec(FDenemeSayisi);
    if FDenemeSayisi <= 0 then
    begin
      ShowAppError('3 defa hatalı şifre girdiniz. Program kapatılıyor.',
        'Giriş Engellendi');
      ModalResult := mrCancel;
    end
    else
    begin
      ShowAppWarning('Hatalı şifre girdiniz! Lütfen tekrar deneyiniz.',
        'Hatalı şifre',
        Format('Kalan deneme hakkınız: %d', [FDenemeSayisi]));
      lblKalanHak.Caption := Format('Kalan Deneme: %d', [FDenemeSayisi]);
      edtSifre.SelectAll;
      edtSifre.SetFocus;
    end;
  end;
end;

procedure TfrmLogin.btnCikisClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
