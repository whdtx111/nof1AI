@echo off
setlocal

echo ========================================
echo 初始化示例数据
echo ========================================
echo.

cd ..

echo [提示] 确保数据库已启动并已推送Schema
echo.

echo [1/2] 编译TypeScript脚本...
call npx tsx testRun\init-sample-data.ts
if errorlevel 1 (
    echo [失败] 初始化失败
    pause
    exit /b 1
)

echo.
echo [2/2] 验证数据...
echo 打开 http://localhost:3000 查看效果
echo 或运行: npm run db:studio
echo.

echo ========================================
echo 数据初始化完成！
echo ========================================
pause
