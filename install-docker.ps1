# Docker Desktop 自动安装脚本
# 需要管理员权限运行

Write-Host "========================================" -ForegroundColor Green
Write-Host "Docker Desktop 安装脚本" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[错误] 此脚本需要管理员权限运行!" -ForegroundColor Red
    Write-Host "请右键点击此文件，选择'以管理员身份运行'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

# 检查是否已安装Docker
$dockerPath = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerPath) {
    Write-Host "[提示] Docker 已经安装在系统中" -ForegroundColor Green
    Write-Host "Docker 版本:" -ForegroundColor Cyan
    docker --version
    Write-Host ""
    
    $reinstall = Read-Host "是否要重新安装? (y/N)"
    if (($reinstall -ne 'y') -and ($reinstall -ne 'Y')) {
        Write-Host "保持当前安装，退出脚本" -ForegroundColor Green
        pause
        exit 0
    }
}

Write-Host "[1/4] 下载 Docker Desktop for Windows..." -ForegroundColor Cyan

$dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

try {
    # 使用 WebClient 下载
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($dockerUrl, $installerPath)
    Write-Host "下载完成!" -ForegroundColor Green
} catch {
    Write-Host "[错误] 下载失败: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "请手动下载 Docker Desktop:" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "[2/4] 安装 Docker Desktop..." -ForegroundColor Cyan
Write-Host "这可能需要几分钟时间，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

try {
    # 静默安装 Docker Desktop
    Start-Process -FilePath $installerPath -ArgumentList "install --quiet" -Wait -NoNewWindow
    Write-Host "安装完成!" -ForegroundColor Green
} catch {
    Write-Host "[错误] 安装失败: $_" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "[3/4] 清理安装文件..." -ForegroundColor Cyan
Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
Write-Host "清理完成!" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] 配置完成!" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "重要提示:" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
Write-Host "1. 需要重启计算机以完成安装" -ForegroundColor White
Write-Host "2. 重启后，启动 Docker Desktop" -ForegroundColor White
Write-Host "3. 等待 Docker Desktop 完全启动" -ForegroundColor White
Write-Host "4. 然后运行 run.bat 启动项目" -ForegroundColor White
Write-Host ""

$reboot = Read-Host "是否现在重启计算机? (y/N)"
if (($reboot -eq 'y') -or ($reboot -eq 'Y')) {
    Write-Host "正在重启..." -ForegroundColor Yellow
    Restart-Computer -Force
} else {
    Write-Host "请稍后手动重启计算机" -ForegroundColor Yellow
    pause
}
