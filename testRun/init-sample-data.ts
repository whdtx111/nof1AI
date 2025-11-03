// 初始化示例数据脚本
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('开始初始化示例数据...')

  // 清空现有数据（可选）
  console.log('清理现有数据...')
  await prisma.chatHistory.deleteMany()
  await prisma.trade.deleteMany()
  await prisma.position.deleteMany()
  await prisma.metric.deleteMany()
  await prisma.cryptoPrice.deleteMany()

  // 创建初始加密货币价格
  console.log('创建加密货币价格数据...')
  await prisma.cryptoPrice.createMany({
    data: [
      { symbol: 'BTC/USDT', price: 50000, change24h: 2.5 },
      { symbol: 'ETH/USDT', price: 3000, change24h: 1.8 },
      { symbol: 'SOL/USDT', price: 100, change24h: -0.5 },
      { symbol: 'BNB/USDT', price: 300, change24h: 0.9 },
      { symbol: 'DOGE/USDT', price: 0.08, change24h: 3.2 },
    ]
  })

  // 创建初始账户指标
  console.log('创建账户指标数据...')
  const now = new Date()
  for (let i = 0; i < 10; i++) {
    const timestamp = new Date(now.getTime() - (9 - i) * 20000) // 每20秒一条
    const randomChange = (Math.random() - 0.5) * 100 // -50 to +50
    const accountValue = 10000 + randomChange + (i * 10)

    await prisma.metric.create({
      data: {
        accountValue,
        totalPnl: accountValue - 10000,
        totalPnlPercent: ((accountValue - 10000) / 10000) * 100,
        unrealizedPnl: randomChange * 0.5,
        realizedPnl: randomChange * 0.5,
        balance: accountValue * 0.8,
        createdAt: timestamp,
      }
    })
  }

  // 创建示例交易记录
  console.log('创建交易记录数据...')
  await prisma.trade.createMany({
    data: [
      {
        modelId: 'deepseek-v3',
        symbol: 'BTC/USDT',
        side: 'buy',
        amount: 0.1,
        price: 49500,
        totalValue: 4950,
        reasoning: '市场趋势向上，技术指标显示买入信号。突破关键阻力位，预期短期内会继续上涨。',
        status: 'executed',
        executedAt: new Date(now.getTime() - 180000),
        createdAt: new Date(now.getTime() - 180000),
      },
      {
        modelId: 'deepseek-v3',
        symbol: 'ETH/USDT',
        side: 'buy',
        amount: 1.5,
        price: 2950,
        totalValue: 4425,
        reasoning: 'ETH表现强劲，相对于BTC有超额收益。链上活动增加，基本面改善。',
        status: 'executed',
        executedAt: new Date(now.getTime() - 120000),
        createdAt: new Date(now.getTime() - 120000),
      },
      {
        modelId: 'deepseek-v3',
        symbol: 'BTC/USDT',
        side: 'sell',
        amount: 0.05,
        price: 50200,
        totalValue: 2510,
        reasoning: '部分获利了结，锁定收益。市场短期可能出现回调。',
        status: 'executed',
        executedAt: new Date(now.getTime() - 60000),
        createdAt: new Date(now.getTime() - 60000),
      },
    ]
  })

  // 创建示例聊天历史
  console.log('创建AI对话历史...')
  await prisma.chatHistory.createMany({
    data: [
      {
        modelId: 'deepseek-v3',
        role: 'user',
        content: '当前市场状况：BTC $50000 (+2.5%), ETH $3000 (+1.8%)',
        createdAt: new Date(now.getTime() - 180000),
      },
      {
        modelId: 'deepseek-v3',
        role: 'assistant',
        content: '根据当前市场分析，建议买入BTC。理由：\n1. 价格突破关键阻力位\n2. 交易量持续增加\n3. 技术指标RSI显示超买但趋势强劲\n建议买入量：0.1 BTC',
        createdAt: new Date(now.getTime() - 179000),
      },
      {
        modelId: 'deepseek-v3',
        role: 'user',
        content: 'ETH表现如何？',
        createdAt: new Date(now.getTime() - 120000),
      },
      {
        modelId: 'deepseek-v3',
        role: 'assistant',
        content: 'ETH表现强劲，相对BTC有超额收益。建议适当配置ETH以分散风险。推荐买入1.5 ETH。',
        createdAt: new Date(now.getTime() - 119000),
      },
    ]
  })

  console.log('✅ 示例数据初始化完成！')
  console.log('\n数据统计:')
  console.log(`- 加密货币价格: ${await prisma.cryptoPrice.count()} 条`)
  console.log(`- 账户指标: ${await prisma.metric.count()} 条`)
  console.log(`- 交易记录: ${await prisma.trade.count()} 条`)
  console.log(`- 对话历史: ${await prisma.chatHistory.count()} 条`)
}

main()
  .catch((e) => {
    console.error('❌ 初始化失败:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
