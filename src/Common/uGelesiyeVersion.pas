unit uGelesiyeVersion;

interface

const
  GELESIYE_VER_MAJOR     = 1;
  GELESIYE_VER_MINOR     = 0;
  GELESIYE_VER_PATCH     = 0;
  GELESIYE_VER_BUILD     = 3;
  GELESIYE_VER_STRING    = '1.0.0';
  GELESIYE_SEMVER        = 'v1.0.0';
  GELESIYE_GIT_BRANCH    = 'master';
  GELESIYE_GIT_COMMIT    = 'fef3422';
  GELESIYE_BUILD_TIME    = '31.10.2026 02:17:55';
  GELESIYE_IS_RELEASE    = True;
  GELESIYE_APP_TITLE     = 'Gelesiye — Basit Veresiye Takip';

  // Geriye dönük uyumluluk sabitleri
  GELESIYE_VERSION_MAJOR = GELESIYE_VER_MAJOR;
  GELESIYE_VERSION_MINOR = GELESIYE_VER_MINOR;
  GELESIYE_VERSION_PATCH = GELESIYE_VER_PATCH;
  GELESIYE_VERSION_BUILD = GELESIYE_VER_BUILD;
  GELESIYE_VERSION_STR   = GELESIYE_SEMVER;
  GELESIYE_BUILD_FULL    = '1.0.0.3';
  GELESIYE_BUILD_ENV     = 'Master / Kararlı';

function GetGelesiyeTitleWithVersion(const AFirmaUnvan: string = ''): string;
function GetGelesiyeStatusBarVersion: string;
function GetGelesiyeFullVersionInfo: string;
function GetExeResourceVersionInfo(const AKey: string): string;

implementation

uses
  Winapi.Windows,
  System.SysUtils;

function GetGelesiyeTitleWithVersion(const AFirmaUnvan: string = ''): string;
var
  Baslik: string;
begin
  if Trim(AFirmaUnvan) <> '' then
    Baslik := 'Gelesiye - ' + AFirmaUnvan
  else
    Baslik := 'Gelesiye — Basit Veresiye Takip';

  if GELESIYE_IS_RELEASE then
    Result := Format('%s [%s]', [Baslik, GELESIYE_SEMVER])
  else
    Result := Format('%s [%s - b%d #%s]', [Baslik, GELESIYE_SEMVER, GELESIYE_VER_BUILD, GELESIYE_GIT_COMMIT]);
end;

function GetGelesiyeStatusBarVersion: string;
begin
  if GELESIYE_IS_RELEASE then
    Result := Format('  %s (Kararlı)', [GELESIYE_SEMVER])
  else
    Result := Format('  %s (b%d | %s)', [GELESIYE_SEMVER, GELESIYE_VER_BUILD, GELESIYE_GIT_COMMIT]);
end;

function GetGelesiyeFullVersionInfo: string;
begin
  Result := Format('Gelesiye %s (Build %d, Branch: %s, Commit: %s, Derleme: %s)', [
    GELESIYE_SEMVER, GELESIYE_VER_BUILD, GELESIYE_GIT_BRANCH, GELESIYE_GIT_COMMIT, GELESIYE_BUILD_TIME
  ]);
end;

function GetExeResourceVersionInfo(const AKey: string): string;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  ValueBuf: Pointer;
  Len: UINT;
  SubBlock: string;
begin
  Result := '';
  FileName := ParamStr(0);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize = 0 then Exit;

  GetMem(VerBuf, InfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
    begin
      // 041F04E6 = Turkish (041F) CP 1254 (04E6)
      SubBlock := '\StringFileInfo\041F04E6\' + AKey;
      if VerQueryValue(VerBuf, PChar(SubBlock), ValueBuf, Len) and (Len > 0) then
        Result := PChar(ValueBuf)
      else
      begin
        // 040904E4 = English fallback
        SubBlock := '\StringFileInfo\040904E4\' + AKey;
        if VerQueryValue(VerBuf, PChar(SubBlock), ValueBuf, Len) and (Len > 0) then
          Result := PChar(ValueBuf);
      end;
    end;
  finally
    FreeMem(VerBuf);
  end;
end;

end.
