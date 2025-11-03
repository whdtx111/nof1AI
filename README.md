# 🤖 NOF1.AI - AI Trading Platform

这是 [nof1.ai](https://nof1.ai/) 的完整复刻版本，一个基于AI的加密货币交易平台。

## ✨ 功能特点

- 🔄 **实时交易**: 通过Binance API进行真实的加密货币交易
- 📊 **实时仪表盘**: 美观的实时图表展示账户表现
- 🧠 **AI决策**: 使用DeepSeek模型进行交易决策
- 💹 **多资产支持**: 支持 BTC, ETH, SOL, BNB, DOGE 交易
- 📈 **性能追踪**: 详细的指标、交易历史和盈亏追踪
- 🔍 **完全透明**: 每个决策、提示和推理都被记录和可见
- ⚡ **自动化**: 每20秒收集指标，每3分钟执行交易

## 🏗️ 技术栈

- **框架**: Next.js 15 (App Router + Turbopack)
- **AI SDK**: Vercel AI SDK + DeepSeek
- **数据库**: PostgreSQL + Prisma ORM
- **交易**: CCXT (Binance)
- **图表**: Recharts + shadcn/ui
- **样式**: Tailwind CSS v4
- **容器**: Docker + Docker Compose

## 📋 前置要求

- Node.js 20+ 
- Docker Desktop (用于运行PostgreSQL)
- Binance API密钥 (可选，用于实盘交易)
- DeepSeek API密钥 (可选，用于AI决策)

## 🚀 快速开始

### 方法一：一键启动 (推荐)

1. **双击运行** `run.bat`
   - 脚本会自动检查环境
   - 启动PostgreSQL数据库
   - 初始化数据库表
   - 启动Next.js开发服务器

2. **访问应用**: http://localhost:3000

### 方法二：手动启动

```bash
# 1. 安装依赖
npm install

# 2. 配置环境变量
# 复制 .env.example 到 .env.local 并填写

# 3. 启动 PostgreSQL
docker compose up -d postgres

# 4. 生成 Prisma Client
npm run db:generate

# 5. 推送数据库 Schema
npm run db:push

# 6. 启动应用
npm run dev
```

## ⚙️ 环境变量配置

创建 `.env.local` 文件：

```env
# 数据库连接
DATABASE_URL="postgresql://nof1ai:nof1ai_password@localhost:5432/nof1ai?schema=public"

# DeepSeek AI (可选)
DEEPSEEK_API_KEY="your-deepseek-api-key"

# Binance API (可选，用于实盘交易)
BINANCE_API_KEY="your-binance-api-key"
BINANCE_API_SECRET="your-binance-api-secret"

# Cron任务认证
CRON_SECRET="your-secure-random-string"

# 应用URL
NEXT_PUBLIC_APP_URL="http://localhost:3000"
```

## 🐳 Docker 使用

### 仅数据库模式 (开发推荐)

```bash
# 启动PostgreSQL
docker compose up -d postgres

# 查看日志
docker compose logs -f postgres

# 停止
docker compose down
```

### 完整生产模式

```bash
# 构建并启动所有服务
docker compose --profile production up -d

# 或使用便捷脚本
docker-start-all.bat
```

### 带数据库管理工具

```bash
# 启动PostgreSQL + pgAdmin
docker compose --profile tools up -d

# pgAdmin访问地址: http://localhost:5050
# 用户名: admin@nof1ai.local
# 密码: admin
```

## 🧪 测试

我们在 `testRun` 文件夹提供了完整的测试脚本：

```bash
# 测试环境配置
testRun\test-setup.bat

# 测试数据库连接
testRun\test-database.bat

# 测试项目构建
testRun\test-build.bat

# 测试API端点 (需要应用运行)
powershell -ExecutionPolicy Bypass -File testRun\test-api.ps1
```

## 📁 项目结构

````
nof1AI/
├── app/                    # Next.js App Router
│   ├── api/               # API路由
│   │   ├── cron/         # 定时任务端点
│   │   ├── metrics/      # 指标数据API
│   │   ├── pricing/      # 价格数据API
│   │   └── trades/       # 交易数据API
│   ├── globals.css       # 全局样式
│   ├── layout.tsx        # 根布局
│   └── page.tsx          # 首页
├── components/            # React组件
│   ├── ui/               # UI基础组件
│   ├── crypto-cards.tsx  # 加密货币价格卡片
│   ├── header.tsx        # 页头
│   ├── metrics-chart.tsx # 账户价值图表
│   └── models-view.tsx   # 模型和交易历史
├── lib/                   # 工具库
│   ├── ai/               # AI相关
│   │   └── agent.ts      # 交易Agent
│   ├── trading/          # 交易功能
│   │   ├── account.ts    # 账户管理
│   │   ├── execute.ts    # 交易执行
│   │   └── pricing.ts    # 价格获取
│   ├── db.ts             # Prisma客户端
│   └── utils.ts          # 工具函数
├── prisma/                # Prisma配置
│   └── schema.prisma     # 数据库模型
├── testRun/              # 测试脚本
├── docker-compose.yml    # Docker编排
├── Dockerfile            # Docker镜像
└── run.bat               # 一键启动脚本
```

## 📊 数据库模型

- **Metric**: 账户指标（余额、盈亏等）
- **Trade**: 交易记录
- **ChatHistory**: AI对话历史
- **Position**: 持仓信息
- **CryptoPrice**: 加密货币价格

## 🔧 开发命令

```bash
# 开发模式
npm run dev

# 生产构建
npm run build

# 启动生产服务器
npm run start

# 代码检查
npm run lint

# Prisma相关
npm run db:generate    # 生成Prisma Client
npm run db:push        # 推送Schema到数据库
npm run db:studio      # 打开Prisma Studio
```

## 🚨 常见问题

### Docker相关

**Q: Docker未安装怎么办？**

A: 运行 `install-docker.ps1` (需管理员权限) 或手动下载：
   https://www.docker.com/products/docker-desktop/

**Q: Docker启动失败？**

A: 运行 `start-docker.bat` 检查Docker状态

### 数据库相关

**Q: 数据库连接失败？**

A: 
1. 确保Docker正在运行
2. 运行 `testRun\test-database.bat` 检查数据库状态
3. 检查 `.env.local` 中的 `DATABASE_URL`

### API相关

**Q: 没有DeepSeek API Key？**

A: 系统会使用模拟数据，不影响功能测试

**Q: 没有Binance API Key？**

A: 系统会返回模拟交易数据，用于演示

## 📝 API端点

- `GET /api/metrics` - 获取账户指标
- `GET /api/trades` - 获取交易历史
- `GET /api/pricing` - 获取加密货币价格
- `GET /api/model/chat` - 获取AI对话历史
- `GET /api/cron/collect-metrics` - 收集指标 (需要认证)
- `GET /api/cron/update-prices` - 更新价格 (需要认证)
- `GET /api/cron/execute-trade` - 执行交易 (需要认证)

## 🎯 待办事项

- [ ] 添加更多AI模型支持
- [ ] 实现风险管理功能
- [ ] 添加回测功能
- [ ] 实现多用户支持
- [ ] 添加更多技术指标

## ⚠️ 免责声明

本项目仅用于教育和研究目的。加密货币交易具有高风险，可能导致资金损失。使用本软件进行实盘交易需自行承担风险。

## 📄 许可证

MIT License

## 🙏 致谢

- [nof1.ai](https://nof1.ai/) - 原始项目灵感
- [SnowingFox/open-nof1.ai](https://github.com/SnowingFox/open-nof1.ai) - 参考实现

## 📞 支持

如有问题，请查看：
1. 运行 `testRun\test-setup.bat` 检查环境
2. 查看 `env-setup.txt` 了解配置说明
3. 检查项目日志
