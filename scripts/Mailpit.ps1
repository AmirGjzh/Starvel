param(
    [string]$Action = "status"
)

function Start-Mailpit {
    $existing = Get-Process -Name "mailpit" -ErrorAction SilentlyContinue
    if ($existing) {
        $existing | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }
    Write-Host "`n" -NoNewline
    Write-Host " Mailpit " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " Starting the server"
    $arguments = @(
        "--database `"$dataDir\mailpit.db`"",
        "--log-file `"$logDir\mailpit.log`"",
        "--max-age 1h",
        "--max 1000"
    )
    try {
        $process = Start-Process -FilePath "$mailpitDir\mailpit.exe" `
                                 -ArgumentList $arguments `
                                 -NoNewWindow `
                                 -PassThru
        Start-Sleep -Seconds 2
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

function Stop-Mailpit {
    $processes = Get-Process -Name "mailpit" -ErrorAction SilentlyContinue
    if ($processes) {
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "`n" -NoNewline
        Write-Host " Success " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Mailpit stopped`n"
    } else {
        Write-Host "`n" -NoNewline
        Write-Host " Warning " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " No running Mailpit found`n"
    }
}

function Show-Status {
    $processes = Get-Process -Name "mailpit" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "`n" -NoNewline
        Write-Host " On " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Mailpit is running`n"
    } else {
        Write-Host "`n" -NoNewline
        Write-Host " Off " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Mailpit is not running`n"
    }
}

$baseDir    = Split-Path $PSScriptRoot -Parent
$mailpitDir = Join-Path $baseDir "tools\mailpit"
$dataDir    = Join-Path $mailpitDir "data"
$logDir    = Join-Path $mailpitDir "logs"

if (-not (Test-Path "$mailpitDir\mailpit.exe")) {
    Write-Host "`n" -NoNewline
    Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " mailpit.exe not found`n"
    exit
}

if (-not (Test-Path $dataDir)) {
    New-Item -ItemType Directory -Path $dataDir -Force | Out-Null
}

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

switch ($Action.ToLower()) {
    "start"  { Start-Mailpit }
    "stop"   { Stop-Mailpit }
    "status" { Show-Status }
    default {
        Write-Host "`n" -NoNewline
        Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Invalid input`n"
        Write-Host "Usage:"
        Write-Host "  mailpit start  → Start Mailpit server"
        Write-Host "  mailpit stop   → Stop Mailpit server"
        Write-Host "  mailpit status → Show current status`n"
    }
}
