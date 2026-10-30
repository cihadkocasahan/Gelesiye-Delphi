@echo off
setlocal
echo ============================================================
echo [1/3] Versiyon Guncelleniyor...
echo ============================================================
python "%~dp0update_version.py" %*
if %errorlevel% neq 0 (
    echo [HATA] Versiyon guncelleme basarisiz!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [2/3] Kodlama ve BOM Denetleniyor...
echo ============================================================
python "%~dp0check_encoding.py" --fix
if %errorlevel% neq 0 (
    echo [HATA] Kodlama hatasi tespit edildi!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [3/3] MSBuild Win64 Derleniyor...
echo ============================================================
call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
if exist "%~dp0..\Gelesiye.rc" (
    brcc32 "%~dp0..\Gelesiye.rc" -fo"%~dp0..\Gelesiye.res" >nul
)
msbuild "%~dp0..\Gelesiye.dproj" /t:Build /p:Config=Debug /p:Platform=Win64
if %errorlevel% neq 0 (
    echo [HATA] Derleme basarisiz oldu!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [BASARILI] Gelesiye Win64 basariyla derlendi! (bin\Debug\Gelesiye.exe)
echo ============================================================
