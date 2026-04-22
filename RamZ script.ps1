#Requires -Version 5.1

# Get the directory where THIS script is located
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $scriptPath "Ramz Config.ps1"

if (-not (Test-Path $configFile)) {
    Write-Host "ERROR: Configuration file not found at: $configFile" -ForegroundColor Red
    exit 1
}

try {
    # Dot-source the config file (note the dot-space!)
    . $configFile
}
catch {
    Write-Host "ERROR: Failed to load configuration: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Colors for output
$ForegroundColor = "White"

function Write-Status {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Red
}

# Validation checks
function Test-Dependency {
    param([string]$Path, [string]$Name)
    if (-not (Test-Path $Path)) {
        Write-Error "ERROR: $Name not found!"
        Write-Error "Expected at: $Path"
        return $false
    }
    return $true
}

# Check if drive is already mounted by AIM
function Test-DriveMounted {
    param([string]$DriveLetter)
    # Check if AIM recognizes this drive as a RAM disk
    $result = & $AIMLL -l -m $DriveLetter 2>&1 | Out-String
    return ($result -match $DriveLetter)
}

function Remove-Drive {
    param([string]$DriveLetter)
    & $AIMLL -d -m $DriveLetter 2>&1 | Out-Null
    return ($LASTEXITCODE -eq 0)
}

# Main execution
try {
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "  $GAMETITLE - RAM Disk Launcher (AIM)" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    
    # Check dependencies
    if (-not (Test-Dependency $AIMLL "AIM Toolkit")) {
        exit 1
    }
    if (-not (Test-Dependency $7Z "7-Zip")) {
        exit 1
    }
    if (-not (Test-Dependency $GAMEARCHIVE "Game archive")) {
        exit 1
    }
    
    # Clean up existing drive if present
    if (Test-DriveMounted $GAMEDISK) {
        Write-Warning "WARNING: Drive $GAMEDISK was already mounted. Cleaning up..."
        Remove-Drive $GAMEDISK
    }
    
    # Create RAM disk
    Write-Status "[1/3] Creating $RAMSIZE RAM disk at $GAMEDISK..."
    & $AIMLL -a -t vm -s $RAMSIZE -m $GAMEDISK -p "/fs:ntfs /q /y" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create RAM disk. Do you have enough RAM?"
    }
    
    # Extract game (blocks until complete, hidden window)
    Write-Status "[2/3] Extracting game to RAM disk..."
    Start-Process $7Z -ArgumentList "x `"$GAMEARCHIVE`" -o`"$EXTRACTPATH`" -y -r -bb0" -Wait -WindowStyle Hidden
    if ($LASTEXITCODE -ne 0) {
        throw "Extraction failed!"
    }
    
    # Verify executable exists
    if (-not (Test-Path $GAMEEXE)) {
        throw "Game executable not found after extraction! Expected at: $GAMEEXE"
    }
    
    # Launch game
    Write-Status "[3/3] Launching $GAMETITLE..."
    
    $gameProcess = Start-Process $GAMEEXE -PassThru -WindowStyle Normal -WorkingDirectory $EXTRACTPATH
	if (-not $gameProcess) {
        throw "Game failed to launch!"
    }
    Start-Sleep -Seconds 3  # Wait for initialization
    
    # Verify it launched
    if (-not $gameProcess) {
        throw "Game failed to launch!"
    }
    
    Write-Status "Waiting for game to exit..."
    $gameProcess | Wait-Process
    
    Write-Status "Game closed."
    
}
catch {
    Write-Error "ERROR: $($_.Exception.Message)"
    exit 1
}
finally {
    # Always cleanup, even if error occurred
    Write-Status "Cleaning up..."
    
    # Remove RAM disk
    try {
        if (Remove-Drive $GAMEDISK) {
            Write-Status "RAM disk removed successfully."
        }
        else {
            Write-Warning "WARNING: Could not remove RAM disk automatically."
            Write-Warning "Please restart your computer or use AIM GUI to remove $GAMEDISK."
        }
    }
    catch {
        Write-Warning "Cleanup failed: $($_.Exception.Message)"
    }
    
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "  Cleanup complete!" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    
    # Wait for user to see message
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
