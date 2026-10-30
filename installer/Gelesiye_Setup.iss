; ==============================================================================
; Gelesiye Cari Takip Programi - Inno Setup 6 Script
; 64-bit Windows Architecture (x64)
; ==============================================================================

#ifndef MyAppName
  #define MyAppName "Gelesiye"
#endif

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0.1"
#endif

#ifndef AppVerSuffix
  #define AppVerSuffix ""
#endif

#ifndef OutputBaseFilename
  #define OutputBaseFilename "Gelesiye_Setup_x64"
#endif

#define MyAppPublisher "Gelesiye"
#define MyAppURL "https://github.com/delphi/Gelesiye"
#define MyAppExeName "Gelesiye.exe"

[Setup]
; App Identity
AppId={{D4E5F6A7-B8C9-0D1E-2F3A-4B5C6D7E8F90}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}{#AppVerSuffix}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Sürüm Takibi (Windows Program Ekle/Kaldır ve Dosya Özellikleri)
VersionInfoVersion={#MyAppVersion}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} — Basit Veresiye Takip Kurulum Paketi
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}

; Target Directory (64-bit Program Files: C:\Program Files\Gelesiye)
DefaultDirName={autopf64}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
DisableProgramGroupPage=no

; 64-bit Architecture Configuration
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; Output
OutputDir=..\releases
OutputBaseFilename={#OutputBaseFilename}
SetupIconFile=..\assets\icons\gelesiye.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern

; Uninstaller
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName} v{#MyAppVersion}{#AppVerSuffix}

; Privileges:
; lowest = Setup normal kullanici olarak baslar (UAC olmadan).
; Kullanici {autopf64} (C:\Program Files) secerse Inno Setup UAC'i
; otomatik talep eder ve admin tokenla devam eder.
; Bu sayede /ALLUSERS parametresi onceden eklenmez,
; IsAdminInstallMode ve {userappdata} her zaman dogru calisir.
PrivilegesRequired=lowest
UsedUserAreasWarning=no

; Calisan programi kapatma kontrolu
CloseApplications=yes
CloseApplicationsFilter=Gelesiye.exe
RestartApplications=no

[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
turkish.CreateDesktopIcon=Masaustu simgesi olusturulsun
english.CreateDesktopIcon=Create a desktop shortcut
turkish.CreateQuickLaunchIcon=Hizli Baslat ve Gorev Cubugu simgesi olusturulsun
english.CreateQuickLaunchIcon=Create a Quick Launch / Taskbar shortcut
turkish.LaunchProgram=Gelesiye — Basit Veresiye Takip Programi'ni Baslat
english.LaunchProgram=Launch Gelesiye — Simple Credit Manager
turkish.UserManual=Kullanim Kilavuzu (HTML)
english.UserManual=User Manual (HTML)
turkish.ExistingDbFound=Mevcut Veritabani / Kurulum Dosyasi:
english.ExistingDbFound=Existing Database / Installation File:
turkish.ExistingInstallWarning=DIKKAT: Secilen klasorde daha once kurulmus bir Gelesiye surumu ve veritabani tespit edildi!%n%n%1%n%nKurulum sirasinda mevcut veritabaniniz KORUNACAK ve uzerine YAZILMAYACAKTIR.%nAncak herhangi bir beklenmeyen veri kaybi riskine karsi kurulum yapmadan once mevcut veritabani dosyanizi baska bir konuma yedeklemeniz onemle tavsiye edilir.%n%nKuruluma devam etmek istiyor musunuz?
english.ExistingInstallWarning=WARNING: An existing installation of Gelesiye and database was detected in the selected folder!%n%n%1%n%nYour existing database will be PRESERVED and will NOT be overwritten.%nHowever, to prevent any risk of unexpected data loss, we strongly recommend backing up your existing database file to a safe location before continuing.%n%nDo you wish to proceed with the installation?

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Dirs]
Name: "{app}\data"; Permissions: users-modify
Name: "{app}\backup"; Permissions: users-modify
Name: "{app}\assets\icons"
; NOT: Quick Launch dizinleri [Code] bolumunde gercek kullanici profiline gore olusturuluyor
; Admin modunda {userappdata} yanlis profili gosterir, bu yuzden buradan kaldirildi

[Files]
; Main Executable
Source: "..\bin\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
; Icons and Assets
Source: "..\assets\icons\*"; DestDir: "{app}\assets\icons"; Flags: ignoreversion recursesubdirs createallsubdirs
; HTML Documentation / User Manual
Source: "..\docs\Gelesiye_Kilavuz.html"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Baslat Menusu (Start Menu) dogrudan kisayol
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
; Baslat Menusu Klasoru (Gelesiye klasoru altindaki program, kilavuz ve kaldir kisayolu)
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UserManual}"; Filename: "{app}\Gelesiye_Kilavuz.html"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
; Masaustu kisayolu
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
; Quick Launch: yalnizca kullanici modunda (IsAdminInstallMode=False) calisir
; Admin modunda {userappdata} system profile'i gosterir, bu yuzden check zorunlu
; [Code] bolumundeki ExecAsOriginalUser admin modunda yedek olarak devreye girer
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; Check: not IsAdminInstallMode
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; Check: not IsAdminInstallMode

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram}"; Flags: nowait postinstall skipifsilent

[Code]
const
  HWND_TOPMOST   = -1;
  HWND_NOTOPMOST = -2;
  SWP_NOSIZE     = $0001;
  SWP_NOMOVE     = $0002;
  SW_RESTORE     = 9;

function SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL;
  external 'SetWindowPos@user32.dll stdcall';

function SetForegroundWindow(hWnd: HWND): BOOL;
  external 'SetForegroundWindow@user32.dll stdcall';

function BringWindowToTop(hWnd: HWND): BOOL;
  external 'BringWindowToTop@user32.dll stdcall';

procedure ShowWindow(hWnd: HWND; nCmdShow: Integer);
  external 'ShowWindow@user32.dll stdcall';

// Qiita/Windows 11 + Inno 6 icin kanitlanmis yontem:
// ShowWindow(SW_RESTORE) + TOPMOST+NOTOPMOST + Sleep(100) + ikinci SetForegroundWindow
procedure ForceSetupToForeground;
begin
  try
    if WizardForm = nil then Exit;
    ShowWindow(WizardForm.Handle, SW_RESTORE);
    BringWindowToTop(WizardForm.Handle);
    SetWindowPos(WizardForm.Handle, HWND_TOPMOST,    0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    SetForegroundWindow(WizardForm.Handle);
    SetWindowPos(WizardForm.Handle, HWND_NOTOPMOST,  0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    Sleep(100);
    SetForegroundWindow(WizardForm.Handle);
  except
  end;
end;

// Admin modunda kurulursa ExecAsOriginalUser ile PowerShell'i
// gercek kullanici kimligiyle calistirarak QL kisayollarini dogru profile yaz.
// Kullanici modunda [Icons] bölümündeki satirlar zaten hallediyor.
procedure CreateQLShortcuts;
var
  AppExe, PSScript, TempScript: string;
  ResultCode: Integer;
begin
  if not WizardIsTaskSelected('quicklaunchicon') then Exit;
  if not IsAdminInstallMode then Exit; // kullanici modunda [Icons] halletti

  AppExe := ExpandConstant('{app}\{#MyAppExeName}');

  PSScript :=
    '$appExe = ''' + AppExe + '''; ' +
    '$appDir = Split-Path $appExe; ' +
    '$sh = New-Object -ComObject WScript.Shell; ' +
    '$ql = [System.Environment]::GetFolderPath(''ApplicationData'') + ' +
    '''\Microsoft\Internet Explorer\Quick Launch''; ' +
    'if (-not (Test-Path $ql)) { New-Item -ItemType Directory -Path $ql -Force | Out-Null }; ' +
    '$lnk = $sh.CreateShortcut($ql + ''\{#MyAppName}.lnk''); ' +
    '$lnk.TargetPath = $appExe; $lnk.WorkingDirectory = $appDir; ' +
    '$lnk.IconLocation = $appExe + '','''' + 0; $lnk.Save(); ' +
    '$tb = $ql + ''\User Pinned\TaskBar''; ' +
    'if (-not (Test-Path $tb)) { New-Item -ItemType Directory -Path $tb -Force | Out-Null }; ' +
    '$lnk2 = $sh.CreateShortcut($tb + ''\{#MyAppName}.lnk''); ' +
    '$lnk2.TargetPath = $appExe; $lnk2.WorkingDirectory = $appDir; ' +
    '$lnk2.IconLocation = $appExe + '','''' + 0; $lnk2.Save();';

  TempScript := ExpandConstant('{tmp}\ql_setup.ps1');
  SaveStringToFile(TempScript, PSScript, False);

  ExecAsOriginalUser(
    'powershell.exe',
    '-NonInteractive -ExecutionPolicy Bypass -File "' + TempScript + '"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode
  );

  DeleteFile(TempScript);
end;

procedure InitializeWizard;
begin
  // NOT: Bu noktada UAC yükseltmesi tamamlanmamis olabilir.
  // Asil one getirme CurPageChanged(wpWelcome) aninda yapiliyor
  // cunku o noktada WizardForm.Handle gecerli ve UAC tamamlanmis olur.
  // Yedek olarak burada da deneriz, hata olursa except ile yutulur.
  ForceSetupToForeground;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // Her sayfa degisiminde one getir.
  // wpWelcome: UAC sonrasi ilk gosterim icin kritik.
  // Diger sayfalar: kurulum sirasinda baska pencere actiysa geri don.
  ForceSetupToForeground;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  DataDbPath: string;
  ExePath: string;
  FoundTarget: string;
  ConfirmMsg: string;
begin
  Result := True;

  // Klasor secim sayfasindan sonra mevcut kurulum ve veri kontrolu
  if CurPageID = wpSelectDir then
  begin
    DataDbPath := ExpandConstant('{app}\data\gelesiye.db');
    ExePath := ExpandConstant('{app}\{#MyAppExeName}');

    if FileExists(DataDbPath) or FileExists(ExePath) then
    begin
      if FileExists(DataDbPath) then
        FoundTarget := ExpandConstant('{cm:ExistingDbFound}') + ' ' + DataDbPath
      else
        FoundTarget := ExpandConstant('{cm:ExistingDbFound}') + ' ' + ExePath;

      ConfirmMsg := FmtMessage(ExpandConstant('{cm:ExistingInstallWarning}'), [FoundTarget]);

      if SuppressibleMsgBox(ConfirmMsg, mbConfirmation, MB_YESNO, IDNO) <> IDYES then
      begin
        Result := False;
      end;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    // Quick Launch kisayollarini gercek kullanici profiline yaz
    // (Admin modunda {userappdata} system profile'a isaret eder,
    //  SHGetFolderPath ile dogru profil alinir)
    CreateQLShortcuts;
  end;

  // Kurulum tamamlandiginda setup'i one getir
  if CurStep = ssPostInstall then
  begin
    ForceSetupToForeground;
  end;
end;
