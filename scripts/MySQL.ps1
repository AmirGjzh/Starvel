param(
    [string]$Action = "status"
)

function Start-MySQL {
    $existing = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
    if ($existing) {
        $existing | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }
    Write-Host "`n" -NoNewline
    Write-Host " MySQL " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " Starting the server`n"
    $arguments = @(
        "--defaults-file=`"$iniFile`"",
        "--basedir=`"$mysqlDir`"",
        "--datadir=`"$dataDir`"",
        "--general-log-file=`"$logDir\general.log`"",
        "--console"
    )
    try {
        $process = Start-Process -FilePath "$binDir\mysqld.exe" `
                                 -ArgumentList $arguments `
                                 -NoNewWindow `
                                 -PassThru
        Start-Sleep -Seconds 5
        if ($process -and !$process.HasExited) {
            Write-Host "`n" -NoNewline
            Write-Host " Success " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
            Write-Host " Started successfully`n"
        } else {
            Write-Host "`n" -NoNewline
            Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
            Write-Host " Failed to start`n"
        }
    }
    catch {
        Write-Host "`n" -NoNewline
        Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Error starting the server: $($_.Exception.Message)`n"
    }
}

function Stop-MySQL {
    $processes = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
    if ($processes) {
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "`n" -NoNewline
        Write-Host " Success " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " MySQL stopped`n"
    } else {
        Write-Host "`n" -NoNewline
        Write-Host " Warning " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " No running MySQL found`n"
    }
}

function Show-Status {
    $processes = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "`n" -NoNewline
        Write-Host " On " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " MySQL is running`n"
    } else {
        Write-Host "`n" -NoNewline
        Write-Host " Off " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " MySQL is not running`n"
    }
}

$baseDir   = Split-Path $PSScriptRoot -Parent
$mysqlDir  = Join-Path $baseDir "tools\database\mysql"
$binDir    = Join-Path $mysqlDir "bin"
$logDir    = Join-Path $mysqlDir "logs"
$dataDir   = Join-Path $mysqlDir "data"
$iniFile   = Join-Path $mysqlDir "my.ini"

if (-not (Test-Path "$binDir\mysqld.exe")) {
    Write-Host "`n" -NoNewline
    Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " mysqld.exe not found`n"
    exit
}

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

switch ($Action.ToLower()) {
    "start"  { Start-MySQL }
    "stop"   { Stop-MySQL }
    "status" { Show-Status }
    default {
        Write-Host "`n" -NoNewline
        Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Invalid input`n"
        Write-Host "Usage:"
        Write-Host "  mysql start  → Start MySQL server"
        Write-Host "  mysql stop   → Stop MySQL server"
        Write-Host "  mysql status → Show current status`n"
    }
}
