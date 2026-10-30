unit fBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uGelesiyeTheme;

type
  TfrmBase = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ApplyAppIcon;
  protected
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
    procedure ApplyTheme; virtual;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmBase: TfrmBase;

implementation

{$R *.dfm}

constructor TfrmBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  KeyPreview := True;
  // Owner varsa owner'ın üzerinde ortala, yoksa ekran merkezi
  if (AOwner is TForm) then
    Position := poOwnerFormCenter
  else
    Position := poScreenCenter;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  // Icon.Assign burada yapılır ama Handle henüz yok olabilir;
  // CreateWnd'de WM_SETICON ile de pekiştirilir.
  if (Application <> nil) and (Application.Icon <> nil) and not Application.Icon.Empty then
    Icon.Assign(Application.Icon);

  // Merkezi Tema Yöneticisinden Renkleri Uygula
  ApplyTheme;
end;

procedure TfrmBase.DoShow;
var
  LCenterForm: TCustomForm;
begin
  inherited DoShow;

  LCenterForm := nil;
  if (Position = poOwnerFormCenter) and Assigned(Owner) and (Owner is TCustomForm) then
    LCenterForm := TCustomForm(Owner)
  else if (Position = poMainFormCenter) and Assigned(Application.MainForm) then
    LCenterForm := Application.MainForm;

  if Assigned(LCenterForm) and (WindowState <> wsMaximized) then
  begin
    Left := LCenterForm.Left + (LCenterForm.Width - Width) div 2;
    Top := LCenterForm.Top + (LCenterForm.Height - Height) div 2;
  end;
end;

procedure TfrmBase.ApplyTheme;
begin
  if BorderStyle = bsNone then
    Padding.SetBounds(1, 1, 1, 1);
  Color := Theme.FormBg;
end;

procedure TfrmBase.Paint;
begin
  inherited;
  if BorderStyle = bsNone then
  begin
    Canvas.Pen.Color := Theme.BorderColor;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
  end;
end;

procedure TfrmBase.CreateWnd;
begin
  inherited CreateWnd;
  // Handle artık geçerli, WM_SETICON ile ikonu zorla uygula
  ApplyAppIcon;
end;

procedure TfrmBase.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if BorderStyle = bsNone then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TfrmBase.ApplyAppIcon;
var
  BigIcon, SmallIcon: HICON;
begin
  if (Application = nil) or (Application.Icon = nil) or Application.Icon.Empty then
    Exit;

  // Büyük ikon (32x32 veya daha yüksek — pencere başlığı ve Alt+Tab)
  BigIcon := Application.Icon.Handle;
  SendMessage(Handle, WM_SETICON, ICON_BIG, LPARAM(BigIcon));

  // Küçük ikon (16x16 — görev çubuğu ve başlık çubuğunun sol köşesi)
  // Windows, küçük ikon için 16x16 boyutunu kendisi seçer.
  SmallIcon := CopyImage(BigIcon, IMAGE_ICON, 16, 16, LR_COPYFROMRESOURCE);
  if SmallIcon <> 0 then
  begin
    SendMessage(Handle, WM_SETICON, ICON_SMALL, LPARAM(SmallIcon));
    DestroyIcon(SmallIcon);
  end
  else
    // CopyImage başarısız olursa büyük ikonu küçük olarak da gönder
    SendMessage(Handle, WM_SETICON, ICON_SMALL, LPARAM(BigIcon));
end;

procedure TfrmBase.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (Shift = []) then
  begin
    Close;
    Key := 0;
  end;
end;

procedure TfrmBase.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and not (ActiveControl is TCustomMemo) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

end.
