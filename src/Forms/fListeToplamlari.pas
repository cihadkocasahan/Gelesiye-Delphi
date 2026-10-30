unit fListeToplamlari;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  fBase, uGelesiyeTypes, uGelesiyeConsts, uGelesiyeTheme;

type
  TfrmListeToplamlari = class(TfrmBase)
    pnlTitleBar: TPanel;
    lblTitleCaption: TLabel;
    btnClose: TButton;
    pnlCard: TPanel;
    lblHeader: TLabel;
    lblAktifBorclu: TLabel;
    edtAktifBorclu: TEdit;
    lblAktifAlacakli: TLabel;
    edtAktifAlacakli: TEdit;
    lblPasifBorclu: TLabel;
    edtPasifBorclu: TEdit;
    lblPasifAlacakli: TLabel;
    edtPasifAlacakli: TEdit;
    lblGenelBorclu: TLabel;
    edtGenelBorclu: TEdit;
    lblGenelAlacakli: TLabel;
    edtGenelAlacakli: TEdit;
    btnKapat: TButton;
    procedure btnKapatClick(Sender: TObject);
    procedure pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure ApplyTheme; override;
  public
    constructor CreateWithData(AOwner: TComponent; const AOzet: TBakiyeOzet); reintroduce;
  end;

var
  frmListeToplamlari: TfrmListeToplamlari;

implementation

{$R *.dfm}

procedure TfrmListeToplamlari.ApplyTheme;
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
    btnClose.Font.Color := clWhite;
  end;
  if Assigned(pnlCard) then
  begin
    pnlCard.Color := Theme.CardBg;
    pnlCard.BevelEdges := [beTop, beBottom, beLeft, beRight];
    pnlCard.BevelKind := bkFlat;
    pnlCard.BevelOuter := bvNone;
  end;
  // Bakiye etiket renkleri — tema tokenları ile
  if Assigned(lblHeader) then
    lblHeader.Font.Color := Theme.HeaderModalText;
  if Assigned(lblAktifBorclu) then  lblAktifBorclu.Font.Color  := Theme.TextAlacak;
  if Assigned(lblAktifAlacakli) then lblAktifAlacakli.Font.Color := Theme.TextAlacak;
  if Assigned(lblPasifBorclu) then  lblPasifBorclu.Font.Color  := Theme.TextBorc;
  if Assigned(lblPasifAlacakli) then lblPasifAlacakli.Font.Color := Theme.TextBorc;
  if Assigned(lblGenelBorclu) then  lblGenelBorclu.Font.Color  := Theme.StatusTextMuted;
  if Assigned(lblGenelAlacakli) then lblGenelAlacakli.Font.Color := Theme.StatusTextMuted;
end;


constructor TfrmListeToplamlari.CreateWithData(AOwner: TComponent; const AOzet: TBakiyeOzet);
begin
  BorderStyle := bsNone;
  inherited Create(AOwner);
  ApplyTheme;
  edtAktifBorclu.Text := FormatFloat('#,##0.00 TL', AOzet.AktifBorcluToplam);
  edtAktifAlacakli.Text := FormatFloat('#,##0.00 TL', AOzet.AktifAlacakliToplam);
  edtPasifBorclu.Text := FormatFloat('#,##0.00 TL', AOzet.PasifBorcluToplam);
  edtPasifAlacakli.Text := FormatFloat('#,##0.00 TL', AOzet.PasifAlacakliToplam);
  edtGenelBorclu.Text := FormatFloat('#,##0.00 TL', AOzet.GenelBorcluToplam);
  edtGenelAlacakli.Text := FormatFloat('#,##0.00 TL', AOzet.GenelAlacakliToplam);
end;

procedure TfrmListeToplamlari.btnKapatClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmListeToplamlari.pnlTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

end.
