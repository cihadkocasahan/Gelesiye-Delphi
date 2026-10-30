@echo off
setlocal
echo ============================================================
echo [1/2] Gelesiye Testleri Derleniyor...
echo ============================================================
call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
if not exist "%~dp0..\dcu\Win64\Debug" mkdir "%~dp0..\dcu\Win64\Debug"
dcc64 -B -Q -E"%~dp0..\bin" -NU"%~dp0..\dcu\Win64\Debug" -I"%~dp0..\src\Common";"%~dp0..\src\Domain";"%~dp0..\src\Data";"%~dp0..\src\ViewModels";"%~dp0..\src\Services" -U"%~dp0..\src\Common";"%~dp0..\src\Domain";"%~dp0..\src\Data";"%~dp0..\src\ViewModels";"%~dp0..\src\Services";"c:\program files (x86)\embarcadero\studio\23.0\lib\Win64\release" "%~dp0..\tests\GelesiyeTests.dpr"
if %errorlevel% neq 0 (
    echo [HATA] Test derlemesi basarisiz!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [2/2] Testler Calistiriliyor...
echo ============================================================
"%~dp0..\bin\GelesiyeTests.exe"
if %errorlevel% neq 0 (
    echo [HATA] Testler basarisiz oldu!
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo [BASARILI] Tum Gelesiye testleri basariyla gecti!
echo ============================================================
