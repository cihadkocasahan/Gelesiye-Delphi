@echo off
setlocal EnableDelayedExpansion
echo ============================================================
echo      GELESIYE x64 KURULUM PAKETI OLUSTURMA ARACI
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%..\"
set "ISCC_EXE=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

REM Inno Setup Compiler kontrolu
if not exist "%ISCC_EXE%" (
    echo [HATA] Inno Setup 6 bulunamadi: "%ISCC_EXE%"
    echo Lutfen Inno Setup 6 kurun veya yolu guncelleyin.
    exit /b 1
)

REM Git Cleanliness Kontrolu (Commit edilmemis degisiklik varsa durdur)
set "ALLOW_DIRTY=0"
for %%A in (%*) do (
    if "%%A"=="--allow-dirty" set "ALLOW_DIRTY=1"
)

for /f "delims=" %%B in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CURRENT_BRANCH=%%B"
if "!CURRENT_BRANCH!"=="" set "CURRENT_BRANCH=unknown"

echo ============================================================
echo [GIT] Aktif Dal (Branch): !CURRENT_BRANCH!
echo ============================================================

if "!ALLOW_DIRTY!"=="0" (
    git rev-parse --is-inside-work-tree >nul 2>&1
    if !errorlevel! equ 0 (
        for /f %%C in ('git status --porcelain 2^>nul ^| find /c /v ""') do set "GIT_DIRTY_COUNT=%%C"
        if not "!GIT_DIRTY_COUNT!"=="0" if not "!GIT_DIRTY_COUNT!"=="" (
            echo ============================================================
            echo [HATA] Calisma alaninda commit edilmemis degisiklikler var.
            echo ============================================================
            echo Setup paketi olusturulmadan once branch'in temiz ve tum kodlarin
            echo commit edilmis olmasi zorunludur. [Tespit edilen degisiklik: !GIT_DIRTY_COUNT! adet]
            echo.
            echo Degisen / Eklenen Dosyalar:
            git status --short
            echo.
            echo Lutfen once 'git commit' yapiniz veya degisiklikleri geri aliniz.
            echo Acil durumlar icin bypass: build_setup.bat --allow-dirty
            echo ============================================================
            exit /b 1
        )
    )
)

echo ============================================================
echo [1/4] Gelesiye Uygulamasi Derleniyor (Win64)...
echo ============================================================
call "%SCRIPT_DIR%build.bat" %*
if %errorlevel% neq 0 (
    echo [HATA] Ana uygulama derlemesi basarisiz oldu!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [1b/4] Release Konfigurasyonu Derleniyor (bin\Release)...
echo ============================================================
call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
msbuild "%ROOT_DIR%Gelesiye.dproj" /t:Build /p:Config=Release /p:Platform=Win64 /nologo /v:minimal
if %errorlevel% neq 0 (
    echo [HATA] Release derlemesi basarisiz oldu!
    exit /b %errorlevel%
)
echo [BASARILI] Gelesiye Win64 Release basariyla derlendi (bin\Release\Gelesiye.exe)

echo.
echo ============================================================
echo [2/4] Tum Entegrasyon ve Fonksiyonel Testler Calistiriliyor...
echo ============================================================
call "%SCRIPT_DIR%run_tests.bat"
if %errorlevel% neq 0 (
    echo [HATA] Testler basarisiz oldu! Kurulum paketi olusturulamaz.
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [3/4] Inno Setup 6 x64 Kurulum Paketi Derleniyor...
echo ============================================================
if not exist "%ROOT_DIR%releases" mkdir "%ROOT_DIR%releases"

for /f "delims=" %%I in ('python "%SCRIPT_DIR%update_version.py" --setup-flags') do set "ISCC_FLAGS=%%I"
for /f "delims=" %%I in ('python "%SCRIPT_DIR%update_version.py" --setup-outname') do set "SETUP_OUTFILE=%%I"
for /f "delims=" %%I in ('python "%SCRIPT_DIR%update_version.py" --setup-version') do set "SETUP_VER=%%I"

echo Inno Setup Parametreleri: %ISCC_FLAGS%
echo Beklenen Setup Dosyasi : releases\%SETUP_OUTFILE%.exe
echo Surum                   : %SETUP_VER%

"%ISCC_EXE%" %ISCC_FLAGS% "%ROOT_DIR%installer\Gelesiye_Setup.iss"
if %errorlevel% neq 0 (
    echo [HATA] Inno Setup derlemesi basarisiz oldu!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [4/4] Kurulum Paketi Dogrulaniyor...
echo ============================================================
if exist "%ROOT_DIR%releases\%SETUP_OUTFILE%.exe" (
    echo [BASARILI] Kurulum paketi basariyla olusturuldu!
    echo Konum: %ROOT_DIR%releases\%SETUP_OUTFILE%.exe
    for %%F in ("%ROOT_DIR%releases\%SETUP_OUTFILE%.exe") do (
        echo Boyut: %%~zF bayt
    )
) else (
    echo [HATA] releases\%SETUP_OUTFILE%.exe bulunamadi!
    exit /b 1
)

echo.
echo ============================================================
echo [TAMAMLANDI] Gelesiye x64 Setup paketi hazir!
echo ============================================================
