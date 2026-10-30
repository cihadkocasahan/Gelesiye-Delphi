unit fDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Math, fBase, uGelesiyeConsts, uGelesiyeTheme;

type
  TDialogType = (dtInfo, dtConfirm, dtWarning, dtError);
  TDialogButtons = (dbOk, dbYesNo, dbOkCancel);

  TfrmDialog = class(TfrmBase)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    btnClose: TButton;
    pnlClient: TPanel;
    lblIcon: TLabel;
    lblMessage: TLabel;
    lblDetail: TLabel;
    pnlBottom: TPanel;
    btnPrimary: TButton;
    btnSecondary: TButton;
    procedure pnlHeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure SetupDialog(const AMessage: string; const AType: TDialogType;
      const ATitle, ADetail: string; const AButtons: TDialogButtons);
  protected
    procedure ApplyTheme; override;
  public
    class function Execute(const AMessage: string; const AType: TDialogType;
      const ATitle: string = ''; const ADetail: string = '';
      const AButtons: TDialogButtons = dbOk; AOwner: TComponent = nil): TModalResult;
  end;

// Global Yardımcı Fonksiyonlar (ShowMessage / MessageDlg alternatifi)
function ShowAppInfo(const AMessage: string; const ATitle: string = 'Bilgilendirme'; const ADetail: string = ''): Boolean;
function ShowAppConfirm(const AMessage: string; const ATitle: string = 'İşlem Onayı'; const ADetail: string = ''): Boolean;
function ShowAppWarning(const AMessage: string; const ATitle: string = 'Uyarı'; const ADetail: string = ''): Boolean;
function ShowAppError(const AMessage: string; const ATitle: string = 'Hata'; const ADetail: string = ''): Boolean;
function ShowAppException(const E: Exception; const ATitle: string = 'Sistem Hatası'): Boolean;
function AppMessageDlg(const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons): TModalResult;

implementation

{$R *.dfm}

{ TfrmDialog }

procedure TfrmDialog.ApplyTheme;
begin
  inherited ApplyTheme;
  Color := Theme.FormBg;
  if Assigned(pnlHeader) then
  begin
    pnlHeader.Color := Theme.HeaderModal;
    pnlHeader.BevelOuter := bvNone;
  end;
  if Assigned(btnClose) then
    btnClose.Font.Color := clWhite;
  if Assigned(pnlClient) then
    pnlClient.Color := Theme.CardBg;
  if Assigned(pnlBottom) then
  begin
    pnlBottom.Color := Theme.PanelBottom;
    pnlBottom.BevelEdges := [beTop];
    pnlBottom.BevelKind := bkFlat;
    pnlBottom.BevelOuter := bvNone;
  end;
  if Assigned(lblTitle) then
    lblTitle.Font.Color := clWhite;
end;

procedure TfrmDialog.pnlHeaderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmDialog.btnCloseClick(Sender: TObject);
begin
  if btnSecondary.Visible then
    ModalResult := btnSecondary.ModalResult
  else
    ModalResult := btnPrimary.ModalResult;
end;

procedure TfrmDialog.SetupDialog(const AMessage: string; const AType: TDialogType;
  const ATitle, ADetail: string; const AButtons: TDialogButtons);
var
  R: TRect;
  MsgH, DetH, NeededH: Integer;
begin
  ApplyTheme;

  // Başlık ve Renk ayarları
  case AType of
    dtInfo:
      begin
        pnlHeader.Color := Theme.HeaderMain; // #107FD2 SayeUtility Kurumsal Mavi
        if ATitle <> '' then lblTitle.Caption := ATitle else lblTitle.Caption := 'Bilgilendirme';
        lblIcon.Caption := 'ℹ';
        lblIcon.Font.Color := Theme.HeaderMain;
      end;
    dtConfirm:
      begin
        pnlHeader.Color := Theme.HeaderMain; // #107FD2 SayeUtility Kurumsal Mavi
        if ATitle <> '' then lblTitle.Caption := ATitle else lblTitle.Caption := 'İşlem Onayı';
        lblIcon.Caption := '❓';
        lblIcon.Font.Color := Theme.HeaderMain;
      end;
    dtWarning:
      begin
        pnlHeader.Color := $000677D9; // #D97706 Sıcak Uyarı Amber / Turuncu
        if ATitle <> '' then lblTitle.Caption := ATitle else lblTitle.Caption := 'Dikkat / Uyarı';
        lblIcon.Caption := '⚠️';
        lblIcon.Font.Color := $000677D9;
      end;
    dtError:
      begin
        pnlHeader.Color := $002626DC; // #DC2626 Canlı Hata Kırmızısı
        if ATitle <> '' then lblTitle.Caption := ATitle else lblTitle.Caption := 'Hata Oluştu';
        lblIcon.Caption := '❌';
        lblIcon.Font.Color := $002626DC;
      end;
  end;

  lblTitle.Font.Color := clWhite;
  btnClose.Font.Color := clWhite;
  Caption := lblTitle.Caption;
  lblMessage.Caption := AMessage;
  lblDetail.Caption := ADetail;

  // Metin yüksekliğini dinamik hesapla
  R := Rect(0, 0, lblMessage.Width, 0);
  DrawText(Canvas.Handle, PChar(AMessage), Length(AMessage), R, DT_CALCRECT or DT_WORDBREAK);
  MsgH := Max(32, R.Bottom - R.Top + 6);
  lblMessage.Height := MsgH;

  if Trim(ADetail) <> '' then
  begin
    lblDetail.Visible := True;
    lblDetail.Top := lblMessage.Top + MsgH + 6;
    R := Rect(0, 0, lblDetail.Width, 0);
    DrawText(Canvas.Handle, PChar(ADetail), Length(ADetail), R, DT_CALCRECT or DT_WORDBREAK);
    DetH := Max(18, R.Bottom - R.Top + 4);
    lblDetail.Height := DetH;
  end
  else
  begin
    lblDetail.Visible := False;
    DetH := 0;
  end;

  NeededH := pnlHeader.Height + pnlBottom.Height + lblMessage.Top + MsgH + DetH + 24;
  ClientHeight := Max(210, NeededH);

  // Buton düzeni
  case AButtons of
    dbYesNo:
      begin
        btnPrimary.Visible := True;
        btnPrimary.Caption := 'Evet';
        btnPrimary.ModalResult := mrYes;
        btnPrimary.Default := True;
        btnPrimary.Cancel := False;

        btnSecondary.Visible := True;
        btnSecondary.Caption := 'Vazgeç';
        btnSecondary.ModalResult := mrNo;
        btnSecondary.Cancel := True;

        btnSecondary.Left := pnlBottom.ClientWidth - btnSecondary.Width - 16;
        btnPrimary.Left := btnSecondary.Left - btnPrimary.Width - 10;
      end;

    dbOkCancel:
      begin
        btnPrimary.Visible := True;
        btnPrimary.Caption := 'Tamam';
        btnPrimary.ModalResult := mrOk;
        btnPrimary.Default := True;
        btnPrimary.Cancel := False;

        btnSecondary.Visible := True;
        btnSecondary.Caption := 'İptal';
        btnSecondary.ModalResult := mrCancel;
        btnSecondary.Cancel := True;

        btnSecondary.Left := pnlBottom.ClientWidth - btnSecondary.Width - 16;
        btnPrimary.Left := btnSecondary.Left - btnPrimary.Width - 10;
      end;

  else // dbOk
    begin
      btnPrimary.Visible := True;
      btnPrimary.Caption := 'Tamam';
      btnPrimary.ModalResult := mrOk;
      btnPrimary.Default := True;
      btnPrimary.Cancel := True;

      btnSecondary.Visible := False;
      btnPrimary.Left := pnlBottom.ClientWidth - btnPrimary.Width - 16;
    end;
  end;
end;

class function TfrmDialog.Execute(const AMessage: string; const AType: TDialogType;
  const ATitle: string; const ADetail: string; const AButtons: TDialogButtons;
  AOwner: TComponent): TModalResult;
var
  Frm: TfrmDialog;
begin
  if AOwner = nil then
    AOwner := Screen.ActiveForm;
  if AOwner = nil then
    AOwner := Application.MainForm;

  Frm := TfrmDialog.Create(AOwner);
  try
    Frm.SetupDialog(AMessage, AType, ATitle, ADetail, AButtons);
    Result := Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

// ============================================================================
// Global Helper Functions
// ============================================================================

function ShowAppInfo(const AMessage: string; const ATitle: string; const ADetail: string): Boolean;
begin
  TfrmDialog.Execute(AMessage, dtInfo, ATitle, ADetail, dbOk);
  Result := True;
end;

function ShowAppConfirm(const AMessage: string; const ATitle: string; const ADetail: string): Boolean;
begin
  Result := (TfrmDialog.Execute(AMessage, dtConfirm, ATitle, ADetail, dbYesNo) = mrYes);
end;

function ShowAppWarning(const AMessage: string; const ATitle: string; const ADetail: string): Boolean;
begin
  TfrmDialog.Execute(AMessage, dtWarning, ATitle, ADetail, dbOk);
  Result := True;
end;

function ShowAppError(const AMessage: string; const ATitle: string; const ADetail: string): Boolean;
begin
  TfrmDialog.Execute(AMessage, dtError, ATitle, ADetail, dbOk);
  Result := True;
end;

function ShowAppException(const E: Exception; const ATitle: string): Boolean;
begin
  if E <> nil then
    ShowAppError(E.Message, ATitle, '(' + E.ClassName + ')')
  else
    ShowAppError('Bilinmeyen bir hata meydana geldi.', ATitle);
  Result := True;
end;

function AppMessageDlg(const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons): TModalResult;
var
  DType: TDialogType;
  DButtons: TDialogButtons;
begin
  case ADlgType of
    mtConfirmation: DType := dtConfirm;
    mtWarning:      DType := dtWarning;
    mtError:        DType := dtError;
  else
    DType := dtInfo;
  end;

  if (mbYes in AButtons) or (mbNo in AButtons) then
    DButtons := dbYesNo
  else if (mbCancel in AButtons) then
    DButtons := dbOkCancel
  else
    DButtons := dbOk;

  Result := TfrmDialog.Execute(AMessage, DType, '', '', DButtons);
end;

end.
