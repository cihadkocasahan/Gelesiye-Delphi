#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gelesiye Otomatik Versiyon ve Derleme Yonetim Araci
- version.json uzerinden major, minor, patch, build takip eder.
- Git branch (master vs develop) ve commit hash bilgilerini okur.
- src/Common/uGelesiyeVersion.pas dosyasini olusturur/gunceller (UTF-8 BOM ile).
- Gelesiye.dproj icindeki VerInfo alanlarini gunceller.
"""

import sys
import os
import re
import json
import subprocess
import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
VERSION_FILE = os.path.join(PROJECT_ROOT, 'version.json')
VERSION_PAS_FILE = os.path.join(PROJECT_ROOT, 'src', 'Common', 'uGelesiyeVersion.pas')
DPROJ_FILE = os.path.join(PROJECT_ROOT, 'Gelesiye.dproj')
RC_FILE = os.path.join(PROJECT_ROOT, 'Gelesiye_Version.rc')
RES_FILE = os.path.join(PROJECT_ROOT, 'Gelesiye_Version.res')

def find_brcc32():
    """Embarcadero Resource Compiler brcc32.exe yolunu bulur."""
    bds = os.environ.get('BDS')
    if bds:
        p = os.path.join(bds, 'bin', 'brcc32.exe')
        if os.path.exists(p):
            return p
    candidates = [
        r'C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\brcc32.exe',
        r'C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\brcc32.exe',
        r'C:\Program Files (x86)\Embarcadero\Studio\21.0\bin\brcc32.exe',
    ]
    for c in candidates:
        if os.path.exists(c):
            return c
    import shutil
    w = shutil.which('brcc32')
    return w

def run_git_cmd(args):
    try:
        res = subprocess.run(['git'] + args, cwd=PROJECT_ROOT, capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except Exception:
        return ''

def get_git_info():
    branch = run_git_cmd(['rev-parse', '--abbrev-ref', 'HEAD']) or 'develop'
    commit = run_git_cmd(['rev-parse', '--short', 'HEAD']) or '0000000'
    status = run_git_cmd(['status', '--porcelain'])
    is_dirty = bool(status.strip())
    
    # Branch'e gore surum tipi
    is_master = (branch.lower() == 'master')
    is_develop = (branch.lower() == 'develop')
    
    if is_master:
        env_name = 'Master / Kararlı'
        tag_suffix = ''
    elif is_develop:
        env_name = 'Develop / Test'
        tag_suffix = '-dev'
    else:
        env_name = f'Branch:{branch}'
        tag_suffix = f'-{branch}'
        
    return {
        'branch': branch,
        'commit': commit + ('*' if is_dirty else ''),
        'is_master': is_master,
        'is_develop': is_develop,
        'env_name': env_name,
        'tag_suffix': tag_suffix,
        'is_dirty': is_dirty
    }

def load_version():
    if os.path.exists(VERSION_FILE):
        try:
            with open(VERSION_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception:
            pass
    return {
        'major': 1,
        'minor': 0,
        'patch': 0,
        'build': 1,
        'scheme': 'semver',
        'last_build_date': datetime.date.today().isoformat()
    }

def save_version(ver):
    with open(VERSION_FILE, 'w', encoding='utf-8') as f:
        json.dump(ver, f, indent=2, ensure_ascii=False)

def generate_rc_and_res(ver, git_info):
    """VersionMaker mantigiyla Windows Resource Script (.rc) uretir ve brcc32 ile .res derler."""
    major = ver['major']
    minor = ver['minor']
    patch = ver['patch']
    build = ver['build']
    year = datetime.date.today().year
    file_version_comma = f"{major},{minor},{patch},{build}"
    file_version_dot = f"{major}.{minor}.{patch}.{build}"
    product_version_comma = f"{major},{minor},{patch},0"
    product_version_dot = f"{major}.{minor}.{patch}"
    branch = git_info['branch']
    commit = git_info['commit']
    build_info = f"{branch}-{git_info['env_name']}"

    rc_content = f"""// Gelesiye Version Resource Script (VersionMaker format)
// Otomatik uretilmistir - el ile duzenlemeyiniz.

LANGUAGE 0, 0

1 VERSIONINFO
    FILEVERSION     {file_version_comma}
    PRODUCTVERSION  {product_version_comma}
    FILEFLAGSMASK   0x3FL
    FILEFLAGS       0x0L
    FILEOS          0x40004L
    FILETYPE        0x1L
    FILESUBTYPE     0x0L
{{
    BLOCK "StringFileInfo"
    {{
        BLOCK "041F04E6"
        {{
            VALUE "Comments", "Gelesiye — Basit Veresiye Takip Sistemi\\0"
            VALUE "CompanyName", "Gelesiye\\0"
            VALUE "FileDescription", "Gelesiye — Basit Veresiye Takip Uygulamasi\\0"
            VALUE "FileVersion", "{file_version_dot}\\0"
            VALUE "InternalName", "Gelesiye\\0"
            VALUE "LegalCopyright", "Copyright (C) {year} Gelesiye\\0"
            VALUE "OriginalFilename", "Gelesiye.exe\\0"
            VALUE "ProductName", "Gelesiye\\0"
            VALUE "ProductVersion", "{product_version_dot}\\0"
            VALUE "BuildInfo", "{build_info}\\0"
            VALUE "Hash", "{commit}\\0"
        }}
    }}
    BLOCK "VarFileInfo"
    {{
        VALUE "Translation", 0x041F, 1254
    }}
}}
"""
    try:
        with open(RC_FILE, 'w', encoding='cp1254', errors='replace') as f:
            f.write(rc_content)
        print(f"[VERSION] RC scripti olusturuldu: {RC_FILE}")
    except Exception as e:
        print(f"[WARN] RC scripti yazilamadi: {e}")
        return False

    brcc32 = find_brcc32()
    if not brcc32:
        print("[WARN] brcc32.exe bulunamadi, .res derlenemedi.")
        return False

    try:
        cmd = [brcc32, '-m', '-l1055', '-c1254', RC_FILE]
        res = subprocess.run(cmd, cwd=PROJECT_ROOT, capture_output=True, text=True)
        if res.returncode == 0:
            print(f"[VERSION] RES basariyla derlendi (brcc32): {RES_FILE}")
            return True
        else:
            print(f"[WARN] brcc32 hatasi: {res.stderr or res.stdout}")
            return False
    except Exception as e:
        print(f"[WARN] brcc32 calistirilamadi: {e}")
        return False

def update_dproj(ver, git_info):
    """
    VersionMaker mantigi: Delphi'nin kendi VerInfo ureticisini kapatir (false),
    boylece derleyici cakisma yapmaz ve kaynak Gelesiye_Version.res'ten gelir.
    """
    if not os.path.exists(DPROJ_FILE):
        return

    with open(DPROJ_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    # Delphi VerInfo_IncludeVerInfo degerini false yaparak cakisMAYI engelliyoruz
    content = re.sub(r'<VerInfo_IncludeVerInfo>true</VerInfo_IncludeVerInfo>',
                     '<VerInfo_IncludeVerInfo>false</VerInfo_IncludeVerInfo>',
                     content)

    with open(DPROJ_FILE, 'w', encoding='utf-8') as f:
        f.write(content)

def generate_version_pas(ver, git_info):
    now_str = datetime.datetime.now().strftime('%d.%m.%Y %H:%M:%S')
    major = ver['major']
    minor = ver['minor']
    patch = ver['patch']
    build = ver['build']
    ver_str = f"{major}.{minor}.{patch}"
    full_ver_str = f"{major}.{minor}.{patch}.{build}{git_info['tag_suffix']}"
    semver = f"v{major}.{minor}.{patch}{git_info['tag_suffix']}"
    
    pas_code = f"""\ufeffunit uGelesiyeVersion;

interface

const
  GELESIYE_VER_MAJOR     = {major};
  GELESIYE_VER_MINOR     = {minor};
  GELESIYE_VER_PATCH     = {patch};
  GELESIYE_VER_BUILD     = {build};
  GELESIYE_VER_STRING    = '{ver_str}';
  GELESIYE_SEMVER        = '{semver}';
  GELESIYE_GIT_BRANCH    = '{git_info['branch']}';
  GELESIYE_GIT_COMMIT    = '{git_info['commit']}';
  GELESIYE_BUILD_TIME    = '{now_str}';
  GELESIYE_IS_RELEASE    = {'True' if git_info['is_master'] else 'False'};
  GELESIYE_APP_TITLE     = 'Gelesiye — Basit Veresiye Takip';

  // Geriye dönük uyumluluk sabitleri
  GELESIYE_VERSION_MAJOR = GELESIYE_VER_MAJOR;
  GELESIYE_VERSION_MINOR = GELESIYE_VER_MINOR;
  GELESIYE_VERSION_PATCH = GELESIYE_VER_PATCH;
  GELESIYE_VERSION_BUILD = GELESIYE_VER_BUILD;
  GELESIYE_VERSION_STR   = GELESIYE_SEMVER;
  GELESIYE_BUILD_FULL    = '{full_ver_str}';
  GELESIYE_BUILD_ENV     = '{git_info['env_name']}';

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
      SubBlock := '\\StringFileInfo\\041F04E6\\' + AKey;
      if VerQueryValue(VerBuf, PChar(SubBlock), ValueBuf, Len) and (Len > 0) then
        Result := PChar(ValueBuf)
      else
      begin
        // 040904E4 = English fallback
        SubBlock := '\\StringFileInfo\\040904E4\\' + AKey;
        if VerQueryValue(VerBuf, PChar(SubBlock), ValueBuf, Len) and (Len > 0) then
          Result := PChar(ValueBuf);
      end;
    end;
  finally
    FreeMem(VerBuf);
  end;
end;

end.
"""
    os.makedirs(os.path.dirname(VERSION_PAS_FILE), exist_ok=True)
    with open(VERSION_PAS_FILE, 'wb') as f:
        f.write(pas_code.encode('utf-8'))

def main():
    args = sys.argv[1:]
    ver = load_version()
    git_info = get_git_info()

    # Sadece Setup / Inno Setup derleme bilgilerini sorgulama
    if '--setup-flags' in args:
        v_str = f"{ver['major']}.{ver['minor']}.{ver['patch']}.{ver.get('build', 1)}"
        out_name = "Gelesiye_Setup_x64" if git_info['is_master'] else "Gelesiye_Setup_x64_Beta"
        sfx = "" if git_info['is_master'] else " (Beta)"
        print(f'/DMyAppVersion="{v_str}" /DOutputBaseFilename="{out_name}" /DAppVerSuffix="{sfx}"')
        return

    if '--setup-outname' in args:
        print("Gelesiye_Setup_x64" if git_info['is_master'] else "Gelesiye_Setup_x64_Beta")
        return

    if '--setup-version' in args:
        print(f"{ver['major']}.{ver['minor']}.{ver['patch']}.{ver.get('build', 1)}")
        return

    should_inc = ('--no-inc' not in args)

    if '--calver' in args:
        now = datetime.date.today()
        ver['minor'] = int(str(now.year)[2:])  # 26
        ver['patch'] = now.month               # 9
        ver['scheme'] = 'calver'
    elif '--semver' in args:
        ver['scheme'] = 'semver'

    if '--bump-major' in args:
        ver['major'] += 1
        ver['minor'] = 0
        ver['patch'] = 0
        ver['build'] = 1
        should_inc = False
    elif '--bump-minor' in args:
        ver['minor'] += 1
        ver['patch'] = 0
        ver['build'] = 1
        should_inc = False
    elif '--bump-patch' in args:
        ver['patch'] += 1
        ver['build'] = 1
        should_inc = False
    elif '--set' in args:
        idx = args.index('--set')
        if idx + 1 < len(args):
            parts = [int(p) for p in args[idx+1].split('.') if p.isdigit()]
            if len(parts) >= 1: ver['major'] = parts[0]
            if len(parts) >= 2: ver['minor'] = parts[1]
            if len(parts) >= 3: ver['patch'] = parts[2]
            if len(parts) >= 4: ver['build'] = parts[3]
            should_inc = False

    if should_inc:
        ver['build'] = ver.get('build', 0) + 1
        
    ver['last_build_date'] = datetime.date.today().isoformat()
    
    save_version(ver)
    generate_version_pas(ver, git_info)
    generate_rc_and_res(ver, git_info)
    update_dproj(ver, git_info)
    
    print(f"[VERSION] Gelesiye v{ver['major']}.{ver['minor']}.{ver['patch']}{git_info['tag_suffix']} (Build {ver['build']})")
    print(f"[VERSION] Branch: {git_info['branch']} | Commit: {git_info['commit']} | Release: {git_info['is_master']}")
    print(f"[VERSION] Generated: {VERSION_PAS_FILE}")

if __name__ == '__main__':
    main()
