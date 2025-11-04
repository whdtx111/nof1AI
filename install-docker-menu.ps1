# Docker Installation Menu
# Run as Administrator

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Docker Desktop Installation Menu" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[ERROR] Administrator privileges required!" -ForegroundColor Red
    Write-Host "Right-click this file and select 'Run as administrator'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "Select installation method:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Chocolatey (RECOMMENDED - Most stable)" -ForegroundColor White
Write-Host "   - Automatic cleanup" -ForegroundColor Gray
Write-Host "   - Reliable installation" -ForegroundColor Gray
Write-Host "   - Best for fixing unpacking errors" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Winget (Windows 11)" -ForegroundColor White
Write-Host "   - Fast installation" -ForegroundColor Gray
Write-Host "   - Built-in Windows package manager" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Official Installer (Updated)" -ForegroundColor White
Write-Host "   - Direct from Docker" -ForegroundColor Gray
Write-Host "   - With cleanup and verification" -ForegroundColor Gray
Write-Host ""
Write-Host "4. WSL2 + Docker Engine (Lightweight)" -ForegroundColor White
Write-Host "   - No Docker Desktop GUI" -ForegroundColor Gray
Write-Host "   - Lower resource usage" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Starting Chocolatey installation..." -ForegroundColor Cyan
        & "$PSScriptRoot\install-docker-chocolatey.ps1"
    }
    
    "2" {
        Write-Host ""
        Write-Host "Starting Winget installation..." -ForegroundColor Cyan
        & "$PSScriptRoot\install-docker-winget.ps1"
    }
    
    "3" {
        Write-Host ""
        Write-Host "Starting official installer..." -ForegroundColor Cyan
        & "$PSScriptRoot\install-docker.ps1"
    }
    
    "4" {
        Write-Host ""
        Write-Host "WSL2 + Docker Engine Installation Guide" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Step 1: Install WSL2" -ForegroundColor Yellow
        Write-Host "Run: wsl --install" -ForegroundColor White
        Write-Host ""
        
        $installWSL = Read-Host "Install WSL2 now? (y/N)"
        if ($installWSL -match '^[yY]$') {
            wsl --install
            Write-Host ""
            Write-Host "WSL2 installation started" -ForegroundColor Green
            Write-Host "Please restart your computer to complete WSL2 installation" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "After restart, run these commands in Ubuntu:" -ForegroundColor Cyan
            Write-Host "  curl -fsSL https://get.docker.com -o get-docker.sh" -ForegroundColor White
            Write-Host "  sudo sh get-docker.sh" -ForegroundColor White
            Write-Host "  sudo usermod -aG docker `$USER" -ForegroundColor White
            Write-Host ""
            
            $reboot = Read-Host "Restart now? (y/N)"
            if ($reboot -match '^[yY]$') {
                Restart-Computer -Force
            }
        } else {
            Write-Host ""
            Write-Host "Manual installation steps:" -ForegroundColor Yellow
            Write-Host "1. wsl --install" -ForegroundColor White
            Write-Host "2. Restart computer" -ForegroundColor White
            Write-Host "3. wsl --install -d Ubuntu" -ForegroundColor White
            Write-Host "4. In Ubuntu:" -ForegroundColor White
            Write-Host "   curl -fsSL https://get.docker.com -o get-docker.sh" -ForegroundColor White
            Write-Host "   sudo sh get-docker.sh" -ForegroundColor White
            Write-Host ""
        }
        pause
    }
    
    "5" {
        Write-Host ""
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
    
    default {
        Write-Host ""
        Write-Host "Invalid choice!" -ForegroundColor Red
        pause
        exit 1
    }
}
