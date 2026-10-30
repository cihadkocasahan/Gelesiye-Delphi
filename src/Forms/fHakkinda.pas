unit fHakkinda;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Imaging.pngimage,
  fBase, uGelesiyeConsts, uGelesiyeTheme, uGelesiyeVersion;

type
  TfrmHakkinda = class(TfrmBase)
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    pnlContent: TPanel;
    pnlHeaderCard: TPanel;
    imgAppLogo: TImage;
    lblAppName: TLabel;
    lblAppDesc: TLabel;
    lblVersion: TLabel;
    pnlSlogan: TPanel;
    lblSlogan: TLabel;
    pnlDevCard: TPanel;
    lblDevHeader: TLabel;
    lblDevName: TLabel;
    lblDevRole: TLabel;
    pnlRowWP: TPanel;
    imgWP: TImage;
    lblWPTag: TLabel;
    lblWPVal: TLabel;
    btnWPAc: TSpeedButton;
    pnlRowLinkedIn: TPanel;
    imgLinkedIn: TImage;
    lblLinkedInTag: TLabel;
    lblLinkedInVal: TLabel;
    btnLinkedInAc: TSpeedButton;
    pnlRowGitHub: TPanel;
    imgGitHub: TImage;
    lblGitHubTag: TLabel;
    lblGitHubVal: TLabel;
    btnGitHubAc: TSpeedButton;
    pnlRowEmail: TPanel;
    imgEmail: TImage;
    lblEmailTag: TLabel;
    lblEmailVal: TLabel;
    btnEmailAc: TSpeedButton;
    pnlBottom: TPanel;
    lblCopyright: TLabel;
    btnKapat: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnKapatClick(Sender: TObject);
    procedure lnkWPClick(Sender: TObject);
    procedure lnkLinkedInClick(Sender: TObject);
    procedure lnkGitHubClick(Sender: TObject);
    procedure lnkEmailClick(Sender: TObject);
  private
    procedure LoadIcons;
    function FindIconFile(const AFileName: string): string;
  protected
    procedure ApplyTheme; override;
  public
    class procedure Execute(AOwner: TComponent = nil);
  end;

var
  frmHakkinda: TfrmHakkinda;

implementation

{$R *.dfm}

{ TfrmHakkinda }

class procedure TfrmHakkinda.Execute(AOwner: TComponent);
var
  Frm: TfrmHakkinda;
begin
  Frm := TfrmHakkinda.Create(AOwner);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TfrmHakkinda.FormCreate(Sender: TObject);
begin
  inherited;
  lblVersion.Caption := 'Versiyon ' + GetGelesiyeStatusBarVersion;
  LoadIcons;
end;

procedure TfrmHakkinda.FormShow(Sender: TObject);
begin
  inherited;
  ApplyTheme;
end;

function TfrmHakkinda.FindIconFile(const AFileName: string): string;
var
  AppDir: string;
begin
  AppDir := ExtractFilePath(Application.ExeName);
  // 1. exe yanı /assets/icons/
  Result := AppDir + 'assets\icons\' + AFileName;
  if FileExists(Result) then Exit;
  // 2. Proje kökü (bin/ üstü) ../assets/icons/
  Result := ExpandFileName(AppDir + '..\assets\icons\' + AFileName);
  if FileExists(Result) then Exit;
  // 3. Doğrudan exe klasörü
  Result := AppDir + AFileName;
  if FileExists(Result) then Exit;
  Result := '';
end;

procedure TfrmHakkinda.LoadIcons;
  procedure LoadToImage(AImage: TImage; const AFileName: string);
  var
    P: string;
    Png: TPngImage;
  begin
    P := FindIconFile(AFileName);
    if (P <> '') and FileExists(P) then
    begin
      Png := TPngImage.Create;
      try
        Png.LoadFromFile(P);
        AImage.Picture.Assign(Png);
      finally
        Png.Free;
      end;
    end;
  end;
begin
  LoadToImage(imgAppLogo, 'gelesiye_app_32.png');
  LoadToImage(imgWP, 'whatsapp_32.png');
  LoadToImage(imgLinkedIn, 'linkedin_32.png');
  LoadToImage(imgGitHub, 'github_32.png');
  LoadToImage(imgEmail, 'eposta_32.png');
end;

procedure TfrmHakkinda.ApplyTheme;
begin
  inherited;
  pnlTitleBar.Color := Theme.HeaderMain;
  lblTitleCaption.Font.Color := clWhite;
  btnClose.Font.Color := clWhite;

  pnlContent.Color := Theme.FormBg;
  pnlHeaderCard.Color := Theme.CardBg;
  pnlDevCard.Color := Theme.CardBg;
  pnlBottom.Color := Theme.PanelBottom;

  if TAppThemeManager.CurrentTheme = thDark then
  begin
    pnlSlogan.Color := $002B2518;
    lblSlogan.Font.Color := $00FEDBBF;
    pnlRowWP.Color := $001E2E20;
    pnlRowLinkedIn.Color := $002E241A;
    pnlRowGitHub.Color := $00262626;
    pnlRowEmail.Color := $001A202A;
  end
  else
  begin
    pnlSlogan.Color := 16773866;
    lblSlogan.Font.Color := Theme.HeaderMain;
    pnlRowWP.Color := 16645629;
    pnlRowLinkedIn.Color := 16774639;
    pnlRowGitHub.Color := 16119285;
    pnlRowEmail.Color := 16774136;
  end;

  lblAppName.Font.Color := Theme.HeaderMain;
  lblDevName.Font.Color := Theme.HeaderMain;
  lblDevRole.Font.Color := Theme.StatusTextMuted;
  lblCopyright.Font.Color := Theme.StatusTextMuted;
end;

procedure TfrmHakkinda.pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TfrmHakkinda.btnKapatClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHakkinda.lnkWPClick(Sender: TObject);
begin
  // WhatsApp web veya masaüstü uygulamasını doğrudan +905368888400 ile açar
  ShellExecute(Handle, 'open', 'https://wa.me/905368888400', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmHakkinda.lnkLinkedInClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.linkedin.com/in/cihadkocasahan/', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmHakkinda.lnkGitHubClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://github.com/cihadkocasahan', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmHakkinda.lnkEmailClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'mailto:cihadkocasahan@gmail.com', nil, nil, SW_SHOWNORMAL);
end;

end.
