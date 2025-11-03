@echo off
setlocal

echo ========================================
echo NOF1.AI 项目构建测试
echo ========================================
echo.

cd ..

echo [测试 1/3] 生成 Prisma Client...
call npm run db:generate
if errorlevel 1 (
    echo [失败] Prisma Client 生成失败
    pause
    exit /b 1
)
echo [成功] Prisma Client 生成完成
echo.

echo [测试 2/3] 推送数据库 Schema...
call npm run db:push
if errorlevel 1 (
    echo [失败] 数据库 Schema 推送失败
    pause
    exit /b 1
)
echo [成功] 数据库 Schema 推送完成
echo.

echo [测试 3/3] 构建 Next.js 项目...
call npm run build
if errorlevel 1 (
    echo [失败] 项目构建失败
    pause
    exit /b 1
)
echo [成功] 项目构建完成
echo.

echo ========================================
echo 构建测试通过!
echo ========================================
pause
