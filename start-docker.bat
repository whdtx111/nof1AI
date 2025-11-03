@echo off
setlocal

echo ========================================
echo 启动 Docker 服务
echo ========================================
echo.

REM 检查 Docker 是否已安装
docker --version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker 未安装!
    echo.
    echo 请选择安装方式:
    echo 1. 运行 install-docker.ps1 自动安装 ^(需要管理员权限^)
    echo 2. 手动下载: https://www.docker.com/products/docker-desktop/
    echo.
    pause
    exit /b 1
)

echo [成功] Docker 已安装
docker --version
echo.

REM 检查 Docker 是否运行
docker info >nul 2>&1
if errorlevel 1 (
    echo [提示] Docker 未运行，正在尝试启动...
    echo.
    
    REM 尝试启动 Docker Desktop
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    echo 等待 Docker Desktop 启动...
    timeout /t 5 /nobreak >nul
    
    REM 等待 Docker 服务就绪
    set MAX_WAIT=60
    set WAITED=0
    
    :wait_loop
    docker info >nul 2>&1
    if not errorlevel 1 goto docker_ready
    
    if %WAITED% GEQ %MAX_WAIT% (
        echo.
        echo [错误] Docker 启动超时!
        echo 请手动启动 Docker Desktop 并重试
        pause
        exit /b 1
    )
    
    timeout /t 2 /nobreak >nul
    set /a WAITED+=2
    goto wait_loop
    
    :docker_ready
    echo.
    echo [成功] Docker 已启动!
) else (
    echo [成功] Docker 正在运行
)

echo.
echo ========================================
echo Docker 状态:
echo ========================================
docker info
echo.
echo ========================================
echo Docker 已就绪，可以运行 run.bat 启动项目
echo ========================================
pause
