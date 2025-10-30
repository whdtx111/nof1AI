import ccxt from 'ccxt'
import { prisma } from '@/lib/db'

const exchange = new ccxt.binance({
  apiKey: process.env.BINANCE_API_KEY,
  secret: process.env.BINANCE_API_SECRET,
  options: {
    defaultType: 'future',
  },
})

export async function getAccountBalance() {
  try {
    const balance = await exchange.fetchBalance()
    const positions = await exchange.fetchPositions()
    
    const totalBalance = balance.total.USDT || 0
    const freeBalance = balance.free.USDT || 0
    const usedBalance = balance.used.USDT || 0
    
    let unrealizedPnl = 0
    let totalPositionValue = 0
    
    for (const position of positions) {
      if (position.contracts && position.contracts > 0) {
        unrealizedPnl += position.unrealizedPnl || 0
        totalPositionValue += Math.abs(position.notional || 0)
        
        // Update position in database
        await prisma.position.upsert({
          where: { symbol: position.symbol },
          update: {
            side: position.side || 'long',
            size: position.contracts,
            entryPrice: position.entryPrice || 0,
            currentPrice: position.markPrice || 0,
            unrealizedPnl: position.unrealizedPnl || 0,
            leverage: position.leverage || 1,
          },
          create: {
            symbol: position.symbol,
            side: position.side || 'long',
            size: position.contracts,
            entryPrice: position.entryPrice || 0,
            currentPrice: position.markPrice || 0,
            unrealizedPnl: position.unrealizedPnl || 0,
            leverage: position.leverage || 1,
          }
        })
      }
    }
    
    const totalValue = totalBalance + unrealizedPnl
    const initialCapital = 10000
    const totalPnl = totalValue - initialCapital
    const totalPnlPercent = (totalPnl / initialCapital) * 100
    
    return {
      balance: freeBalance,
      totalValue,
      totalPnl,
      totalPnlPercent,
      unrealizedPnl,
      realizedPnl: totalBalance - initialCapital,
      positions: positions.filter(p => p.contracts && p.contracts > 0)
    }
  } catch (error) {
    console.error('Error fetching account balance:', error)
    // Return mock data if exchange is not configured
    return {
      balance: 10000,
      totalValue: 10000,
      totalPnl: 0,
      totalPnlPercent: 0,
      unrealizedPnl: 0,
      realizedPnl: 0,
      positions: []
    }
  }
}
