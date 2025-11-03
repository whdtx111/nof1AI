# ⚡ NOF1.AI 快速启动指南

这是最简单的启动方式，5分钟内让项目运行起来！

## 📋 前提检查

在开始之前，确认以下内容：

- ✅ Node.js 已安装 (运行 `node --version` 检查)
- ✅ 项目文件已下载到本地
- ✅ 已在项目目录打开命令行

## 🚀 三步启动

### 步骤 1: 安装Docker (如果还没有)

**选项 A: 自动安装 (推荐)**
```powershell
# 右键点击 install-docker.ps1
# 选择"以管理员身份运行"
# 按照提示完成安装并重启电脑
```

**选项 B: 手动安装**
1. 访问 https://www.docker.com/products/docker-desktop/
2. 下载 Docker Desktop for Windows
3. 安装并重启电脑
4. 启动 Docker Desktop

### 步骤 2: 配置环境

双击打开 `.env.local` 文件 (如果没有，复制 `.env.example`)

最小配置 (用于测试):
```env
DATABASE_URL="postgresql://nof1ai:nof1ai_password@localhost:5432/nof1ai?schema=public"
DEEPSEEK_API_KEY="sk-test"
BINANCE_API_KEY="test"
BINANCE_API_SECRET="test"
CRON_SECRET="test-secret-12345"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
```

### 步骤 3: 启动项目

**最简单的方式** - 双击运行 `run.bat` ✨

脚本会自动:
1. 检查环境
2. 启动数据库
3. 初始化数据库表
4. 启动应用

等待看到:
```
✓ Ready in XXms
○ Local: http://localhost:3000
```

然后打开浏览器访问 **http://localhost:3000**

## 🎉 完成！

你应该能看到NOF1.AI的主页，包括:
- 顶部导航栏
- 加密货币价格卡片
- 账户价值图表
- 交易历史和AI对话

## 🐛 遇到问题？

### 问题 1: Docker未运行

**错误信息**: `Docker is not running`

**解决方案**:
1. 启动 Docker Desktop
2. 等待Docker完全启动 (任务栏图标显示正常)
3. 重新运行 `run.bat`

### 问题 2: 端口被占用

**错误信息**: `Port 3000 already in use`

**解决方案**:
```powershell
# 查找占用端口的进程
netstat -ano | findstr :3000

# 结束该进程 (替换<PID>为实际进程ID)
taskkill /PID <PID> /F
```

### 问题 3: 数据库连接失败

**错误信息**: `Can't reach database`

**解决方案**:
```bash
# 检查数据库容器状态
docker ps | findstr postgres

# 如果没有运行，手动启动
docker compose up -d postgres

# 等待10秒让数据库就绪
timeout /t 10

# 重新运行应用
npm run dev
```

### 问题 4: 依赖安装问题

**错误信息**: `Cannot find module...`

**解决方案**:
```bash
# 清理并重新安装
rmdir /s /q node_modules
npm install

# 重新生成Prisma Client
npm run db:generate
```

## 🧪 测试功能

启动成功后，可以运行测试脚本验证:

```bash
# 测试环境
.\testRun\test-setup.bat

# 测试数据库
.\testRun\test-database.bat

# 测试API (需要应用运行中)
powershell -ExecutionPolicy Bypass -File .\testRun\test-api.ps1
```

## 📊 添加示例数据

如果你看到空白的图表和表格，运行:

```bash
# 初始化示例数据
npx tsx testRun\init-sample-data.ts

# 刷新浏览器
```

## 🔄 停止项目

- 在命令行中按 `Ctrl + C` 停止应用
- 运行 `docker compose down` 停止数据库

## 📚 更多帮助

- 查看完整文档: `README.md`
- 详细安装指南: `INSTALL.md`
- 项目状态: `PROJECT-STATUS.md`
- 运行测试脚本文件夹: `testRun/`

## 💡 小贴士

1. **首次运行可能较慢**: 需要下载Docker镜像
2. **使用测试API密钥**: 适合演示，不会进行真实交易
3. **查看日志**: 在命令行中可以看到详细的运行日志
4. **热重载**: 修改代码后自动刷新，无需重启

---

**就这么简单！** 如果还有问题，查看 `INSTALL.md` 获取更详细的故障排除指南。
