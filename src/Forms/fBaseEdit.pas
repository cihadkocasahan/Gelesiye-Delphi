unit fBaseEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  fBase, uGelesiyeTheme;

type
  TfrmBaseEdit = class(TfrmBase)
    pnlBottom: TPanel;
    btnVazgec: TButton;
    btnKaydet: TButton;
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    procedure btnVazgecClick(Sender: TObject);
    procedure btnKaydetClick(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure ApplyTheme; override;
    function ValidateInput: Boolean; virtual;
    function SaveData: Boolean; virtual;
    procedure LoadData; virtual;
    procedure SetFormTitle(const ATitle: string);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmBaseEdit: TfrmBaseEdit;

implementation

{$R *.dfm}

constructor TfrmBaseEdit.Create(AOwner: TComponent);
begin
  BorderStyle := bsNone;
  inherited Create(AOwner);
  ApplyTheme;
end;

procedure TfrmBaseEdit.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;
  if Assigned(pnlTitleBar) then
  begin
    pnlTitleBar.Color := Theme.HeaderModal;
    pnlTitleBar.BevelEdges := [beBottom];
    pnlTitleBar.BevelKind := bkFlat;
    pnlTitleBar.BevelOuter := bvNone;
  end;
  if Assigned(lblTitleCaption) then
    lblTitleCaption.Font.Color := Theme.HeaderModalText;
  if Assigned(btnClose) then
  begin
    btnClose.Caption := '✕';
    btnClose.Font.Color := clWhite;  // Beyaz — tüm modal başlıklar renkli/koyu
  end;
  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
end;

procedure TfrmBaseEdit.SetFormTitle(const ATitle: string);
begin
  Caption := ATitle;
  lblTitleCaption.Caption := ATitle;
end;

procedure TfrmBaseEdit.pnlTitleBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0); // SC_MOVE + HTCAPTION
  end;
end;

procedure TfrmBaseEdit.btnVazgecClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBaseEdit.btnKaydetClick(Sender: TObject);
begin
  if not ValidateInput then
    Exit;

  if SaveData then
    ModalResult := mrOk;
end;

function TfrmBaseEdit.ValidateInput: Boolean;
begin
  Result := True;
end;

function TfrmBaseEdit.SaveData: Boolean;
begin
  Result := True;
end;

procedure TfrmBaseEdit.LoadData;
begin
end;

end.
