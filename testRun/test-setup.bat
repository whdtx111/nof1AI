@echo off
setlocal

echo ========================================
echo NOF1.AI 环境测试脚本
echo ========================================
echo.

cd ..

echo [测试 1/5] 检查 Node.js 安装...
node --version >nul 2>&1
if errorlevel 1 (
    echo [失败] Node.js 未安装
    echo 请从 https://nodejs.org/ 下载安装
    pause
    exit /b 1
)
node --version
echo [成功] Node.js 已安装
echo.

echo [测试 2/5] 检查 npm 安装...
npm --version >nul 2>&1
if errorlevel 1 (
    echo [失败] npm 未安装
    pause
    exit /b 1
)
npm --version
echo [成功] npm 已安装
echo.

echo [测试 3/5] 检查 Docker 安装...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [失败] Docker 未安装
    echo 请运行 install-docker.ps1 安装 Docker
    pause
    exit /b 1
)
docker --version
echo [成功] Docker 已安装
echo.

echo [测试 4/5] 检查 Docker 运行状态...
docker info >nul 2>&1
if errorlevel 1 (
    echo [警告] Docker 未运行
    echo 请启动 Docker Desktop
    pause
    exit /b 1
)
echo [成功] Docker 正在运行
echo.

echo [测试 5/5] 检查项目依赖...
if not exist "node_modules\" (
    echo [警告] 项目依赖未安装
    echo 正在安装依赖...
    call npm install
    if errorlevel 1 (
        echo [失败] 依赖安装失败
        pause
        exit /b 1
    )
)
echo [成功] 项目依赖已安装
echo.

echo ========================================
echo 所有环境测试通过!
echo 现在可以运行 run.bat 启动项目
echo ========================================
pause
