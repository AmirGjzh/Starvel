@echo off
setlocal
set "NPM_BIN=%LARAVEL_ROOT%\tools\node\current\npm.cmd"
if not exist "%NPM_BIN%" (
    echo npm not found!
    exit /b 1
)
"%NPM_BIN%" %*
endlocal
