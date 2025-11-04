# Docker Desktop 自动安装脚本
# 需要管理员权限运行

Write-Host "========================================" -ForegroundColor Green
Write-Host "Docker Desktop 安装脚本 (改进版)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 设置错误处理
$ErrorActionPreference = "Stop"

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

# 清理可能存在的旧安装文件和临时文件
Write-Host "[1/5] 清理旧文件和检查环境..." -ForegroundColor Cyan

$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"
$altInstallerPath = "$env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"

# 删除旧的安装文件
if (Test-Path $installerPath) {
    Write-Host "删除旧的安装文件..." -ForegroundColor Yellow
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
}

# 清理Docker残留
$dockerProgramData = "$env:ProgramData\Docker"
if (Test-Path $dockerProgramData) {
    Write-Host "清理Docker残留文件..." -ForegroundColor Yellow
    Remove-Item $dockerProgramData -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "环境检查完成!" -ForegroundColor Green
Write-Host ""

Write-Host "[2/5] 下载 Docker Desktop for Windows..." -ForegroundColor Cyan

$dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"

try {
    # 使用更可靠的下载方式，带进度显示
    Write-Host "正在下载... (约500MB，请耐心等待)" -ForegroundColor Yellow
    
    # 使用 Invoke-WebRequest 带进度
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $dockerUrl -OutFile $installerPath -UseBasicParsing
    $ProgressPreference = 'Continue'
    
    # 验证文件是否下载成功
    if (-not (Test-Path $installerPath)) {
        throw "下载的文件不存在"
    }
    
    $fileSize = (Get-Item $installerPath).Length / 1MB
    Write-Host "下载完成! 文件大小: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
    
    # 验证文件大小（Docker Desktop通常大于100MB）
    if ($fileSize -lt 100) {
        throw "下载的文件大小异常，可能下载不完整"
    }
    
} catch {
    Write-Host "[错误] 下载失败: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "尝试替代方案..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请选择以下方案之一:" -ForegroundColor Cyan
    Write-Host "1. 手动下载 Docker Desktop 并放到 Downloads 文件夹" -ForegroundColor White
    Write-Host "   下载地址: https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    Write-Host "2. 使用 Chocolatey 安装 (推荐)" -ForegroundColor White
    Write-Host "3. 使用 WSL2 + Docker Engine (轻量级)" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "请输入选项 (1/2/3)"
    
    if ($choice -eq "2") {
        Write-Host ""
        Write-Host "使用 Chocolatey 安装..." -ForegroundColor Cyan
        
        # 检查 Chocolatey 是否已安装
        $chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue
        
        if (-not $chocoInstalled) {
            Write-Host "正在安装 Chocolatey..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        }
        
        Write-Host "正在通过 Chocolatey 安装 Docker Desktop..." -ForegroundColor Yellow
        choco install docker-desktop -y
        
        Write-Host ""
        Write-Host "安装完成!" -ForegroundColor Green
        Write-Host "请重启计算机以完成安装" -ForegroundColor Yellow
        pause
        exit 0
        
    } elseif ($choice -eq "3") {
        Write-Host ""
        Write-Host "WSL2 + Docker Engine 安装指南:" -ForegroundColor Cyan
        Write-Host "1. 启用 WSL2: wsl --install" -ForegroundColor White
        Write-Host "2. 安装 Ubuntu: wsl --install -d Ubuntu" -ForegroundColor White
        Write-Host "3. 在 Ubuntu 中安装 Docker Engine" -ForegroundColor White
        Write-Host ""
        Write-Host "详细步骤请参考: https://docs.docker.com/engine/install/ubuntu/" -ForegroundColor Yellow
        pause
        exit 0
        
    } else {
        Write-Host ""
        Write-Host "请手动下载后重新运行此脚本" -ForegroundColor Yellow
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "[3/5] 准备安装 Docker Desktop..." -ForegroundColor Cyan

# 检查系统要求
Write-Host "检查系统要求..." -ForegroundColor Yellow

# 检查 Hyper-V
$hyperv = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
if ($hyperv -and $hyperv.State -ne "Enabled") {
    Write-Host "[警告] Hyper-V 未启用，Docker Desktop 需要 Hyper-V 或 WSL2" -ForegroundColor Yellow
    Write-Host "是否启用 Hyper-V? (需要重启) (y/N)" -ForegroundColor Cyan
    $enableHyperV = Read-Host
    if (($enableHyperV -eq 'y') -or ($enableHyperV -eq 'Y')) {
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
        Write-Host "Hyper-V 已启用，安装完成后需要重启" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "[4/5] 安装 Docker Desktop..." -ForegroundColor Cyan
Write-Host "这可能需要几分钟时间，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

try {
    # 方法1: 尝试静默安装
    Write-Host "尝试静默安装..." -ForegroundColor Yellow
    $process = Start-Process -FilePath $installerPath -ArgumentList "install","--quiet","--accept-license" -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -ne 0) {
        Write-Host "[警告] 静默安装失败 (退出码: $($process.ExitCode))" -ForegroundColor Yellow
        Write-Host "尝试交互式安装..." -ForegroundColor Yellow
        Write-Host ""
        
        # 方法2: 交互式安装
        Start-Process -FilePath $installerPath -ArgumentList "install" -Wait
    }
    
    Write-Host "安装完成!" -ForegroundColor Green
    
} catch {
    Write-Host "[错误] 安装失败: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的解决方案:" -ForegroundColor Yellow
    Write-Host "1. 确保有足够的磁盘空间 (至少10GB)" -ForegroundColor White
    Write-Host "2. 关闭杀毒软件后重试" -ForegroundColor White
    Write-Host "3. 清理临时文件: cleanmgr" -ForegroundColor White
    Write-Host "4. 使用 Chocolatey 安装 (重新运行脚本选择选项2)" -ForegroundColor White
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "[5/5] 清理安装文件..." -ForegroundColor Cyan
Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
Write-Host "清理完成!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "安装完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
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
