@echo off
setlocal
set "LARAVEL_BIN=%LARAVEL_ROOT%\tools\composer\global\vendor\bin\laravel.bat"
if not exist "%LARAVEL_BIN%" (
    echo laravel installer not found!
    exit /b 1
)
"%LARAVEL_BIN%" %*
endlocal
