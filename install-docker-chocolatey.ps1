# Docker Installation via Chocolatey
# Run as Administrator

Write-Host "========================================" -ForegroundColor Green
Write-Host "Docker Desktop Installation via Chocolatey" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[ERROR] Administrator privileges required!" -ForegroundColor Red
    Write-Host "Right-click this file and select 'Run as administrator'" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[Step 1/4] Cleaning up old Docker installations..." -ForegroundColor Cyan

# Stop Docker services
Stop-Service -Name "com.docker.service" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "dockerd" -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

# Clean up Docker folders
$pathsToClean = @(
    "$env:ProgramFiles\Docker",
    "$env:ProgramData\Docker",
    "$env:ProgramData\DockerDesktop",
    "$env:LOCALAPPDATA\Docker",
    "$env:APPDATA\Docker",
    "$env:USERPROFILE\.docker"
)

foreach ($path in $pathsToClean) {
    if (Test-Path $path) {
        Write-Host "Removing: $path" -ForegroundColor Yellow
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Clean temp files
Remove-Item -Path "$env:TEMP\Docker*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\DockerDesktop*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Cleanup completed!" -ForegroundColor Green
Write-Host ""

Write-Host "[Step 2/4] Checking Chocolatey..." -ForegroundColor Cyan

$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue

if (-not $chocoInstalled) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Chocolatey is already installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "[Step 3/4] Installing Docker Desktop..." -ForegroundColor Cyan
Write-Host "This may take several minutes, please wait..." -ForegroundColor Yellow
Write-Host ""

try {
    choco install docker-desktop -y --force
    Write-Host ""
    Write-Host "Docker Desktop installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative solutions:" -ForegroundColor Yellow
    Write-Host "1. Try: winget install Docker.DockerDesktop" -ForegroundColor White
    Write-Host "2. Manual download: https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    pause
    exit 1
}

Write-Host ""
Write-Host "[Step 4/4] Verification..." -ForegroundColor Cyan

# Check if Docker is installed
$dockerPath = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerPath) {
    Write-Host "Docker command found at: $($dockerPath.Source)" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Docker command not found in PATH" -ForegroundColor Yellow
    Write-Host "You may need to restart your computer" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer" -ForegroundColor White
Write-Host "2. Start Docker Desktop" -ForegroundColor White
Write-Host "3. Wait for Docker Desktop to fully start" -ForegroundColor White
Write-Host "4. Run 'docker --version' to verify" -ForegroundColor White
Write-Host "5. Run 'docker run hello-world' to test" -ForegroundColor White
Write-Host ""

$reboot = Read-Host "Restart computer now? (y/N)"
if (($reboot -eq 'y') -or ($reboot -eq 'Y')) {
    Write-Host "Restarting..." -ForegroundColor Yellow
    Restart-Computer -Force
} else {
    Write-Host "Please restart manually later" -ForegroundColor Yellow
    pause
}
