@echo off
setlocal
set "PHP_BIN=%LARAVEL_ROOT%\tools\php\current\php.exe"
if not exist "%PHP_BIN%" (
    echo php not found!
    exit /b 1
)
"%PHP_BIN%" %*
endlocal
