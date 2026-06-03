@echo off
setlocal
set "NODE_BIN=%LARAVEL_ROOT%\tools\node\current\node.exe"
if not exist "%NODE_BIN%" (
    echo node not found!
    exit /b 1
)
"%NODE_BIN%" %*
endlocal
