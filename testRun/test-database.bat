@echo off
setlocal

echo ========================================
echo NOF1.AI 数据库连接测试
echo ========================================
echo.

cd ..

echo [测试 1/4] 检查 Docker 运行状态...
docker info >nul 2>&1
if errorlevel 1 (
    echo [失败] Docker 未运行
    pause
    exit /b 1
)
echo [成功] Docker 正在运行
echo.

echo [测试 2/4] 启动 PostgreSQL 容器...
docker compose up -d postgres
if errorlevel 1 (
    echo [失败] 无法启动 PostgreSQL
    pause
    exit /b 1
)
echo [成功] PostgreSQL 已启动
echo.

echo [测试 3/4] 等待数据库就绪...
timeout /t 10 /nobreak >nul
echo.

echo [测试 4/4] 测试数据库连接...
docker exec nof1ai-postgres pg_isready -U nof1ai >nul 2>&1
if errorlevel 1 (
    echo [失败] 数据库连接失败
    echo 正在查看容器日志...
    docker logs nof1ai-postgres --tail 20
    pause
    exit /b 1
)
echo [成功] 数据库连接正常
echo.

echo ========================================
echo 数据库测试通过!
echo ========================================
echo.
echo 容器状态:
docker ps --filter name=nof1ai-postgres
echo.
pause
