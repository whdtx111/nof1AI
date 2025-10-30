import ccxt from 'ccxt'
import { prisma } from '@/lib/db'

const exchange = new ccxt.binance({
  apiKey: process.env.BINANCE_API_KEY,
  secret: process.env.BINANCE_API_SECRET,
  options: {
    defaultType: 'future',
  },
})

export async function executeBuy(symbol: string, amount: number, reasoning: string) {
  const modelId = 'deepseek-v3'
  
  try {
    // Get current price
    const ticker = await exchange.fetchTicker(symbol)
    const price = ticker.last || 0
    const totalValue = amount * price
    
    // Create order
    const order = await exchange.createMarketBuyOrder(symbol, amount)
    
    // Save trade to database
    const trade = await prisma.trade.create({
      data: {
        modelId,
        symbol,
        side: 'buy',
        amount,
        price,
        totalValue,
        reasoning,
        status: 'executed',
        executedAt: new Date(),
      }
    })
    
    return { success: true, trade, order }
  } catch (error: any) {
    console.error('Error executing buy order:', error)
    
    // Save failed trade
    await prisma.trade.create({
      data: {
        modelId,
        symbol,
        side: 'buy',
        amount,
        price: 0,
        totalValue: 0,
        reasoning,
        status: 'failed',
        error: error.message,
      }
    })
    
    return { success: false, error: error.message }
  }
}

export async function executeSell(symbol: string, amount: number, reasoning: string) {
  const modelId = 'deepseek-v3'
  
  try {
    // Get current price
    const ticker = await exchange.fetchTicker(symbol)
    const price = ticker.last || 0
    const totalValue = amount * price
    
    // Create order
    const order = await exchange.createMarketSellOrder(symbol, amount)
    
    // Save trade to database
    const trade = await prisma.trade.create({
      data: {
        modelId,
        symbol,
        side: 'sell',
        amount,
        price,
        totalValue,
        reasoning,
        status: 'executed',
        executedAt: new Date(),
      }
    })
    
    return { success: true, trade, order }
  } catch (error: any) {
    console.error('Error executing sell order:', error)
    
    // Save failed trade
    await prisma.trade.create({
      data: {
        modelId,
        symbol,
        side: 'sell',
        amount,
        price: 0,
        totalValue: 0,
        reasoning,
        status: 'failed',
        error: error.message,
      }
    })
    
    return { success: false, error: error.message }
  }
}
