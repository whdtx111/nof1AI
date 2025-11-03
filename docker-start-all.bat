@echo off
setlocal

echo ========================================
echo NOF1.AI Docker 完整启动脚本
echo ========================================
echo.

echo [1/3] 启动 Docker 服务...
call start-docker.bat
if errorlevel 1 (
    echo [错误] Docker 启动失败
    pause
    exit /b 1
)

echo.
echo [2/3] 启动所有容器...
docker compose up -d
if errorlevel 1 (
    echo [错误] 容器启动失败
    pause
    exit /b 1
)

echo.
echo [3/3] 等待服务就绪...
timeout /t 10 /nobreak >nul

echo.
echo ========================================
echo 容器状态:
echo ========================================
docker compose ps
echo.

echo ========================================
echo 所有服务已启动!
echo ========================================
echo.
echo 访问地址: http://localhost:3000
echo.
pause
