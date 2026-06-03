@echo off
setlocal
set "NPX_BIN=%LARAVEL_ROOT%\tools\node\current\npx.cmd"
if not exist "%NPX_BIN%" (
    echo npx not found!
    exit /b 1
)
"%NPX_BIN%" %*
endlocal
