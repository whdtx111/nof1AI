# 🔧 NOF1.AI 安装指南

本文档提供详细的安装步骤和故障排除指南。

## 📋 目录

1. [系统要求](#系统要求)
2. [安装步骤](#安装步骤)
3. [Docker安装](#docker安装)
4. [环境配置](#环境配置)
5. [数据库初始化](#数据库初始化)
6. [故障排除](#故障排除)

## 系统要求

### 最低配置
- **操作系统**: Windows 10/11 (64-bit)
- **CPU**: 2核心
- **内存**: 4GB RAM
- **硬盘**: 10GB 可用空间

### 推荐配置
- **操作系统**: Windows 11 (64-bit)
- **CPU**: 4核心+
- **内存**: 8GB+ RAM
- **硬盘**: 20GB+ 可用空间 (SSD)

### 软件要求
- Node.js 20.x 或更高版本
- Docker Desktop (最新版本)
- PowerShell 5.1 或更高版本

## 安装步骤

### 步骤 1: 安装 Node.js

1. 访问 [Node.js 官网](https://nodejs.org/)
2. 下载 LTS 版本 (推荐 20.x)
3. 运行安装程序
4. 验证安装:
   ```powershell
   node --version
   npm --version
   ```

### 步骤 2: 安装 Docker

#### 方法 A: 使用自动安装脚本 (推荐)

1. 右键点击 `install-docker.ps1`
2. 选择"以管理员身份运行"
3. 按照提示操作
4. 安装完成后重启计算机

#### 方法 B: 手动安装

1. 访问 [Docker Desktop 下载页](https://www.docker.com/products/docker-desktop/)
2. 下载 Windows 版本
3. 运行安装程序
4. 启用 WSL 2 (如果提示)
5. 重启计算机
6. 启动 Docker Desktop

### 步骤 3: 克隆/下载项目

```powershell
# 如果使用 Git
git clone <repository-url>
cd nof1AI

# 或直接解压下载的ZIP文件
```

### 步骤 4: 安装项目依赖

```powershell
npm install
```

### 步骤 5: 配置环境变量

1. 复制环境变量模板:
   ```powershell
   copy .env.example .env.local
   ```

2. 编辑 `.env.local` 文件，填入您的配置:
   ```env
   DATABASE_URL="postgresql://nof1ai:nof1ai_password@localhost:5432/nof1ai?schema=public"
   DEEPSEEK_API_KEY="your-key-here"
   BINANCE_API_KEY="your-key-here"
   BINANCE_API_SECRET="your-secret-here"
   CRON_SECRET="random-secure-string"
   NEXT_PUBLIC_APP_URL="http://localhost:3000"
   ```

   **注意**: 
   - 如果没有API密钥，可以使用测试值
   - `CRON_SECRET` 可以是任意随机字符串

### 步骤 6: 启动项目

#### 快速启动 (推荐)

直接双击 `run.bat` 文件

#### 手动启动

```powershell
# 1. 启动 Docker (如果未运行)
.\start-docker.bat

# 2. 启动 PostgreSQL
docker compose up -d postgres

# 3. 等待数据库就绪 (约10秒)
timeout /t 10

# 4. 生成 Prisma Client
npm run db:generate

# 5. 初始化数据库
npm run db:push

# 6. 启动应用
npm run dev
```

### 步骤 7: 验证安装

1. 打开浏览器访问: http://localhost:3000
2. 应该看到 NOF1.AI 主页
3. 运行测试脚本验证:
   ```powershell
   .\testRun\test-setup.bat
   ```

## Docker 安装

### Docker Desktop 配置

安装后需要配置 Docker Desktop:

1. **WSL 2 后端** (推荐)
   - 设置 > General > Use WSL 2 based engine

2. **资源分配**
   - 设置 > Resources
   - CPU: 最少 2 核心
   - 内存: 最少 4GB

3. **文件共享**
   - 设置 > Resources > File Sharing
   - 添加项目目录

### 验证 Docker 安装

```powershell
# 检查 Docker 版本
docker --version

# 检查 Docker 运行状态
docker info

# 测试 Docker
docker run hello-world
```

## 环境配置

### 获取 API 密钥

#### DeepSeek API Key

1. 访问 [DeepSeek Platform](https://platform.deepseek.com/)
2. 注册/登录账户
3. 创建新的 API Key
4. 复制密钥到 `.env.local`

#### Binance API Key

1. 访问 [Binance](https://www.binance.com/)
2. 登录账户
3. API Management > Create API
4. 启用 "Enable Spot & Margin Trading"
5. 复制 API Key 和 Secret 到 `.env.local`

**⚠️ 安全提示**:
- 不要分享你的 API 密钥
- 使用 IP 白名单限制
- 定期更换密钥
- 仅用于测试账户

### 环境变量详解

| 变量名 | 说明 | 是否必需 | 默认值 |
|--------|------|----------|--------|
| DATABASE_URL | PostgreSQL 连接字符串 | ✅ 是 | - |
| DEEPSEEK_API_KEY | DeepSeek AI API 密钥 | ❌ 否 | 使用模拟数据 |
| BINANCE_API_KEY | Binance API 密钥 | ❌ 否 | 使用模拟数据 |
| BINANCE_API_SECRET | Binance API 密钥 | ❌ 否 | 使用模拟数据 |
| CRON_SECRET | Cron 任务认证密钥 | ✅ 是 | - |
| NEXT_PUBLIC_APP_URL | 应用访问 URL | ✅ 是 | - |

## 数据库初始化

### 使用 Prisma

```powershell
# 生成 Prisma Client
npm run db:generate

# 推送 Schema 到数据库
npm run db:push

# 打开 Prisma Studio (数据库GUI)
npm run db:studio
```

### 手动初始化

如果自动初始化失败，可以手动执行:

```powershell
# 进入 PostgreSQL 容器
docker exec -it nof1ai-postgres psql -U nof1ai -d nof1ai

# 执行 SQL (如需要)
# ...

# 退出
\q
```

## 故障排除

### 问题 1: Docker 无法启动

**症状**: 运行 `docker info` 报错

**解决方案**:
1. 检查 Docker Desktop 是否已启动
2. 检查 WSL 2 是否已安装和启用
3. 重启 Docker Desktop
4. 重启计算机

### 问题 2: 端口被占用

**症状**: `Error: Port 3000/5432 already in use`

**解决方案**:
```powershell
# 查找占用端口的进程
netstat -ano | findstr :3000
netstat -ano | findstr :5432

# 结束进程 (替换 PID)
taskkill /PID <进程ID> /F

# 或修改 docker-compose.yml 中的端口映射
```

### 问题 3: 数据库连接失败

**症状**: `Error: Can't reach database server`

**解决方案**:
1. 检查 PostgreSQL 容器状态:
   ```powershell
   docker ps | findstr postgres
   ```

2. 查看容器日志:
   ```powershell
   docker logs nof1ai-postgres
   ```

3. 重启容器:
   ```powershell
   docker compose restart postgres
   ```

4. 检查 `.env.local` 中的 `DATABASE_URL`

### 问题 4: Prisma Client 生成失败

**症状**: `Error: Cannot find module '@prisma/client'`

**解决方案**:
```powershell
# 清理并重新生成
rmdir /s /q node_modules\.prisma
npm run db:generate
```

### 问题 5: 构建失败

**症状**: 编译错误或类型错误

**解决方案**:
```powershell
# 清理缓存
rmdir /s /q .next
rmdir /s /q node_modules

# 重新安装
npm install

# 重新生成 Prisma Client
npm run db:generate

# 重新构建
npm run build
```

### 问题 6: 应用无响应

**症状**: 浏览器无法访问 http://localhost:3000

**解决方案**:
1. 检查应用是否正在运行
2. 查看控制台是否有错误
3. 检查防火墙设置
4. 尝试使用 `127.0.0.1:3000` 而不是 `localhost:3000`

### 问题 7: Docker 权限问题

**症状**: `permission denied` 或 `access denied`

**解决方案**:
1. 以管理员身份运行 PowerShell
2. 检查 Docker Desktop 设置中的文件共享权限
3. 重启 Docker Desktop

## 🆘 获取帮助

如果以上方法都无法解决问题:

1. **运行诊断脚本**:
   ```powershell
   .\testRun\test-setup.bat
   ```

2. **查看日志**:
   - Docker: `docker compose logs`
   - 应用: 查看终端输出
   - 浏览器: F12 > Console

3. **清理并重新开始**:
   ```powershell
   # 停止所有容器
   docker compose down -v
   
   # 清理项目
   rmdir /s /q .next node_modules
   
   # 重新开始
   npm install
   .\run.bat
   ```

## ✅ 安装完成检查清单

- [ ] Node.js 已安装并可用
- [ ] Docker Desktop 已安装并运行
- [ ] 项目依赖已安装
- [ ] `.env.local` 已配置
- [ ] PostgreSQL 容器运行正常
- [ ] Prisma Client 已生成
- [ ] 数据库 Schema 已推送
- [ ] 应用可通过浏览器访问
- [ ] 所有测试脚本通过

完成以上检查后，您的 NOF1.AI 平台应该已经成功安装并运行！
