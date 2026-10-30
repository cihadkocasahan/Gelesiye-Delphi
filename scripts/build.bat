@echo off
setlocal
echo ============================================================
echo   Gelesiye Win64 (Debug) Derleme Araci
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%..\"

if not defined BDS (
    if exist "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat" (
        call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
    )
)

echo [1/2] Kaynak Dosyalari Hazirlaniyor...
if exist "%ROOT_DIR%Gelesiye.rc" (
    brcc32 "%ROOT_DIR%Gelesiye.rc" -fo"%ROOT_DIR%Gelesiye.res" >nul 2>&1
)

echo [2/2] MSBuild Win64 (Debug) Derleniyor...
msbuild "%ROOT_DIR%Gelesiye.dproj" /t:Build /p:Config=Debug /p:Platform=Win64 /nologo /v:minimal
if %errorlevel% neq 0 (
    echo.
    echo [HATA] Derleme basarisiz oldu!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [BASARILI] Gelesiye Win64 Debug basariyla derlendi!
echo Konum: bin\Debug\Gelesiye.exe
echo ============================================================
