function Switch-Version {
    param([string]$Tool, [string]$Version)
    if ($Tool -eq "PHP") {
        $base = Join-Path $baseDir "tools\php"
        $target = Join-Path $base $Version
        $current = Join-Path $base "current"
    } else {
        $base = Join-Path $baseDir "tools\node"
        $target = Join-Path $base $Version
        $current = Join-Path $base "current"
    }
    if (-not (Test-Path $target)) {
        Write-Host "`n" -NoNewline
        Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " $Tool version $Version not found`n"
        return $false
    }
    if (Test-Path $current) { Remove-Item $current -Force -Recurse }
    New-Item -ItemType Junction -Path $current -Target $target | Out-Null

    Write-Host "`n" -NoNewline
    Write-Host " Info " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host " Switched $Tool to $Version"
    return $true
}

function Get-AvailableVersions {
    param([string]$Tool)
    $folder = if ($Tool -eq "PHP") { "tools\php" } else { "tools\node" }
    $path = Join-Path $baseDir $folder
    Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -notin @('current', 'cache') -and
            $_.Name -match '^\d+(\.\d+)*$'
        } |
        Sort-Object {
            if ($_.Name -match '^\d+$') {
                [version]("$($_.Name).0")
            } else {
                [version]$_.Name
            }
        } -Descending |
        Select-Object -ExpandProperty Name
}

function Test-Tool {
    param([string]$Name, [string]$Command)
    Write-Host "-> $Name " -NoNewline
    try {
        $output = Invoke-Expression $Command 2>&1
        if ($LASTEXITCODE -eq 0 -or $output -match "version|Version") {
            Write-Host "✅ Loaded successfully" -ForegroundColor DarkGreen
        } else {
            Write-Host "❌ Failed" -ForegroundColor DarkRed
        }
    } catch {
        Write-Host "❌ Not found / Failed" -ForegroundColor DarkRed
    }
}

$baseDir = Split-Path $PSScriptRoot -Parent
$DefaultPHP  = Get-AvailableVersions "PHP"     | Select-Object -First 1
$DefaultNode = Get-AvailableVersions "Node.js"  | Select-Object -First 1

if (-not $DefaultPHP) {
    Write-Host "`n" -NoNewline
    Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " No PHP version found in tools\php`n"
    Stop-Process -Id $PID
}

if (-not $DefaultNode) {
    Write-Host "`n" -NoNewline
    Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " No Node.js version found in tools\node`n"
    Stop-Process -Id $PID
}

Write-Host "`n" -NoNewline
Write-Host " Laravel " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
Write-Host " Starting development environment 🚀"

do {
    $foldersToCreate = @(
        "tools\node\cache",
        "tools\composer\cache",
        "tools\composer\global"
    )

    foreach ($relPath in $foldersToCreate) {
        $fullPath = Join-Path $baseDir $relPath
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        }
    }

    Write-Host "`nWhat would you like to do?"
    Write-Host "[1] Start coding"
    Write-Host "[2] Configure"
    Write-Host "[3] Exit`n"
    Write-Host "Enter your choice (1-3): " -NoNewline
    $choice = Read-Host

    if ($choice -eq "2") {
        Write-Host "`n" -NoNewline
        Write-Host " Config " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Configuring versions...`n"

        $phpVersions = Get-AvailableVersions "PHP"
        Write-Host "PHP versions available:"
        $phpVersions | ForEach-Object { Write-Host "• $_" }
        Write-Host ""
        do {
            Write-Host "Select PHP version (or press Enter for default $DefaultPHP): " -NoNewline
            $newPHP = Read-Host
            if (-not $newPHP) { $newPHP = $DefaultPHP }
            if (Switch-Version "PHP" $newPHP) { break }
        } while ($true)

        $nodeVersions = Get-AvailableVersions "Node.js"
        Write-Host "`nNode.js versions available:"
        $nodeVersions | ForEach-Object { Write-Host "• $_" }
        Write-Host ""
        do {
            Write-Host "Select Node.js version (or press Enter for default $DefaultNode): " -NoNewline
            $newNode = Read-Host
            if (-not $newNode) { $newNode = $DefaultNode }
            if (Switch-Version "Node.js" $newNode) { break }
        } while ($true)

        Write-Host "`n" -NoNewline
        Write-Host " Updated " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Configuration updated, Reloading status..."
    } elseif ($choice -eq "1") {
        Write-Host "`n" -NoNewline
        Write-Host " Tools " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Loading tools..."

        $phpCurrent = Join-Path $baseDir "tools\php\current"
        if (-not (Test-Path "$phpCurrent\php.exe")) {
            Write-Host "`n" -NoNewline
            Write-Host " Warning " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
            Write-Host " Active PHP not found"
            Switch-Version "PHP" $DefaultPHP | Out-Null
        }
        $nodeCurrent = Join-Path $baseDir "tools\node\current"
        if (-not (Test-Path "$nodeCurrent\node.exe")) {
            Write-Host "`n" -NoNewline
            Write-Host " Warning " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
            Write-Host " Active Node.js not found"
            Switch-Version "Node.js" $DefaultNode | Out-Null
        }

        $env:PATH = "$(Join-Path $baseDir 'bin');" +
                    # "$(Join-Path $baseDir 'php\current');" +
                    # "$(Join-Path $baseDir 'node\current');" +
                    # "$(Join-Path $baseDir 'composer\global\vendor\bin');" +
                    "$env:PATH"
        $env:LARAVEL_ROOT       = $baseDir
        $env:COMPOSER_HOME      = Join-Path $baseDir "tools\composer\global"
        $env:npm_config_cache   = Join-Path $baseDir "tools\node\cache"
        $env:COMPOSER_CACHE_DIR = Join-Path $baseDir "tools\composer\cache"

        Write-Host ""
        Test-Tool "PHP      "      "php --version"
        Test-Tool "Composer "      "composer --version"
        Test-Tool "Laravel  "      "laravel --version"
        Test-Tool "Node.js  "      "node --version"
        Test-Tool "NPM      "      "npm --version"

        Write-Host "`n" -NoNewline
        Write-Host " Ready " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Environment is ready, Happy coding`n"
        break
    } elseif ($choice -eq "3") {
        Write-Host "`n" -NoNewline
        Write-Host " Done " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host " Hope You enjoyed, Goodbye`n"
        Stop-Process -Id $PID
    } else {
        Write-Host "`n" -NoNewline
        Write-Host " Error " -NoNewline -ForegroundColor White -BackgroundColor DarkRed
        Write-Host " Invalid choice, Please enter 1, 2 or 3"
    }
} while ($true)
