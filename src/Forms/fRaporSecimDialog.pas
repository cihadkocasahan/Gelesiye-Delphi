unit fRaporSecimDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  fBase, uGelesiyeConsts, uGelesiyeTheme;

type
  TRaporSecimResult = (rsCancel, rsSeciliEkstre, rsCariOzet, rsDetayliRapor);

  TfrmRaporSecimDialog = class(TfrmBase)
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    pnlClient: TPanel;
    lblPrompt: TLabel;
    btnSeciliEkstre: TButton;
    btnCariOzet: TButton;
    btnDetayliRapor: TButton;
    pnlBottom: TPanel;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSeciliEkstreClick(Sender: TObject);
    procedure btnCariOzetClick(Sender: TObject);
    procedure btnDetayliRaporClick(Sender: TObject);
  private
    FResult: TRaporSecimResult;
  protected
    procedure ApplyTheme; override;
  public
    class function Execute(const ACariUnvan: string; AHasSeciliCari: Boolean;
      AOwner: TComponent = nil): TRaporSecimResult;
  end;

implementation

{$R *.dfm}

class function TfrmRaporSecimDialog.Execute(const ACariUnvan: string;
  AHasSeciliCari: Boolean; AOwner: TComponent): TRaporSecimResult;
var
  Dlg: TfrmRaporSecimDialog;
begin
  Dlg := TfrmRaporSecimDialog.Create(AOwner);
  try
    Dlg.btnSeciliEkstre.Enabled := AHasSeciliCari;
    if AHasSeciliCari and (ACariUnvan <> '') then
      Dlg.btnSeciliEkstre.Caption := '  '#128196' ' + ACariUnvan + ' '#8212' Hareket Ekstresi'
    else
      Dlg.btnSeciliEkstre.Caption := '  '#128196' Se'#231'ili Cari Hesap Ekstresi (Hareketler)';

    Dlg.ShowModal;
    Result := Dlg.FResult;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmRaporSecimDialog.FormCreate(Sender: TObject);
begin
  inherited;
  FResult := rsCancel;
  ApplyTheme;
end;

procedure TfrmRaporSecimDialog.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;

  if Assigned(pnlTitleBar) then
  begin
    pnlTitleBar.Color := Theme.HeaderMain;
    pnlTitleBar.BevelOuter := bvNone;
  end;

  if Assigned(lblTitleCaption) then
    lblTitleCaption.Font.Color := clWhite;

  if Assigned(btnClose) then
    btnClose.Font.Color := clWhite;

  if Assigned(pnlClient) then
  begin
    pnlClient.Color := Theme.CardBg;
  end;

  if Assigned(lblPrompt) then
    lblPrompt.Font.Color := Theme.HeaderModalText;

  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
end;

procedure TfrmRaporSecimDialog.pnlTitleBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmRaporSecimDialog.btnCloseClick(Sender: TObject);
begin
  FResult := rsCancel;
  ModalResult := mrCancel;
end;

procedure TfrmRaporSecimDialog.btnSeciliEkstreClick(Sender: TObject);
begin
  FResult := rsSeciliEkstre;
  ModalResult := mrOk;
end;

procedure TfrmRaporSecimDialog.btnCariOzetClick(Sender: TObject);
begin
  FResult := rsCariOzet;
  ModalResult := mrOk;
end;

procedure TfrmRaporSecimDialog.btnDetayliRaporClick(Sender: TObject);
begin
  FResult := rsDetayliRapor;
  ModalResult := mrOk;
end;

end.
