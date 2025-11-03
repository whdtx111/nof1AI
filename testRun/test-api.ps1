# API 端点测试脚本

Write-Host "========================================" -ForegroundColor Green
Write-Host "NOF1.AI API 测试" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$baseUrl = "http://localhost:3000"

# 检查应用是否运行
Write-Host "[测试 1/5] 检查应用运行状态..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri $baseUrl -TimeoutSec 5 -UseBasicParsing
    Write-Host "[成功] 应用正在运行 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "[失败] 应用未运行或无响应" -ForegroundColor Red
    Write-Host "请先运行 run.bat 启动应用" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "[测试 2/5] 测试 Metrics API..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/metrics" -Method Get
    Write-Host "[成功] Metrics API 响应正常" -ForegroundColor Green
    Write-Host "返回记录数: $($response.Count)" -ForegroundColor White
} catch {
    Write-Host "[失败] Metrics API 错误: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[测试 3/5] 测试 Trades API..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/trades" -Method Get
    Write-Host "[成功] Trades API 响应正常" -ForegroundColor Green
    Write-Host "返回记录数: $($response.Count)" -ForegroundColor White
} catch {
    Write-Host "[失败] Trades API 错误: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[测试 4/5] 测试 Pricing API..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/pricing" -Method Get
    Write-Host "[成功] Pricing API 响应正常" -ForegroundColor Green
    Write-Host "返回记录数: $($response.Count)" -ForegroundColor White
} catch {
    Write-Host "[失败] Pricing API 错误: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[测试 5/5] 测试 Chat History API..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/model/chat" -Method Get
    Write-Host "[成功] Chat History API 响应正常" -ForegroundColor Green
    Write-Host "返回记录数: $($response.Count)" -ForegroundColor White
} catch {
    Write-Host "[失败] Chat History API 错误: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "API 测试完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
pause
