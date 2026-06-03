@echo off
setlocal
set "PHP_BIN=%LARAVEL_ROOT%\bin\php.bat"
set "COMPOSER_PHAR=%LARAVEL_ROOT%\tools\composer\composer.phar"
if not exist "%COMPOSER_PHAR%" (
    echo composer not found!
    exit /b 1
)
"%PHP_BIN%" "%COMPOSER_PHAR%" %*
endlocal
