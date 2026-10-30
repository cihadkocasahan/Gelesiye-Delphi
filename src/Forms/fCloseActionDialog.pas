unit fCloseActionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  fBase, uGelesiyeConsts, uGelesiyeTheme;

type
  TCloseActionResult = (carCancel, carMinimizeToTray, carExitApp);

  TfrmCloseActionDialog = class(TfrmBase)
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    pnlCard: TPanel;
    pnlIconBadge: TPanel;
    lblIcon: TLabel;
    lblMessage: TLabel;
    lblSubMessage: TLabel;
    chkRemember: TCheckBox;
    pnlBottom: TPanel;
    btnMinimize: TButton;
    btnExit: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FResult: TCloseActionResult;
  protected
    procedure ApplyTheme; override;
  public
    class function Execute(out ARemember: Boolean; AOwner: TComponent = nil): TCloseActionResult;
  end;

implementation

{$R *.dfm}

class function TfrmCloseActionDialog.Execute(out ARemember: Boolean; AOwner: TComponent): TCloseActionResult;
var
  Dlg: TfrmCloseActionDialog;
begin
  ARemember := False;
  Dlg := TfrmCloseActionDialog.Create(AOwner);
  try
    Dlg.ShowModal;
    ARemember := Dlg.chkRemember.Checked;
    Result := Dlg.FResult;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmCloseActionDialog.FormCreate(Sender: TObject);
begin
  inherited;
  FResult := carCancel;
  ApplyTheme;
end;

procedure TfrmCloseActionDialog.ApplyTheme;
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
  begin
    btnClose.Font.Color := clWhite;
  end;

  if Assigned(pnlCard) then
  begin
    pnlCard.Color := Theme.CardBg;
    pnlCard.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlCard.BevelKind := bkFlat;
    pnlCard.BevelOuter := bvNone;
  end;

  if Assigned(pnlIconBadge) then
  begin
    pnlIconBadge.Color := Theme.StatusBg;
    pnlIconBadge.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlIconBadge.BevelKind := bkFlat;
    pnlIconBadge.BevelOuter := bvNone;
  end;

  if Assigned(lblIcon) then
    lblIcon.Font.Color := Theme.AccentPrimary;

  if Assigned(lblMessage) then
    lblMessage.Font.Color := Theme.HeaderModalText;

  if Assigned(lblSubMessage) then
    lblSubMessage.Font.Color := Theme.StatusTextInfo;

  if Assigned(chkRemember) then
    chkRemember.Font.Color := Theme.HeaderModalText;

  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
end;

procedure TfrmCloseActionDialog.pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmCloseActionDialog.btnMinimizeClick(Sender: TObject);
begin
  FResult := carMinimizeToTray;
  ModalResult := mrOk;
end;

procedure TfrmCloseActionDialog.btnExitClick(Sender: TObject);
begin
  FResult := carExitApp;
  ModalResult := mrOk;
end;

procedure TfrmCloseActionDialog.btnCancelClick(Sender: TObject);
begin
  FResult := carCancel;
  ModalResult := mrCancel;
end;

end.
