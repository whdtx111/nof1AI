import { generateText } from 'ai'
import { createDeepSeek } from '@ai-sdk/deepseek'
import { prisma } from '@/lib/db'
import { getAccountBalance } from '@/lib/trading/account'
import { fetchCryptoPrices } from '@/lib/trading/pricing'
import { executeBuy, executeSell } from '@/lib/trading/execute'
import { z } from 'zod'

const deepseek = createDeepSeek({
  apiKey: process.env.DEEPSEEK_API_KEY,
})

const TRADING_PROMPT = `You are an expert cryptocurrency trader managing a $10,000 portfolio.

Your goal is to maximize returns while managing risk effectively.

Available cryptocurrencies: BTC/USDT, ETH/USDT, SOL/USDT, BNB/USDT, DOGE/USDT

Rules:
1. Only trade futures contracts on Binance
2. Consider market trends, volatility, and risk management
3. Use proper position sizing (don't risk more than 5% per trade)
4. Provide clear reasoning for every decision
5. You can choose to hold (do nothing) if market conditions aren't favorable

Analyze the current market state and decide on your next action.`

export async function runTradingAgent() {
  const modelId = 'deepseek-v3'
  
  try {
    // Get current account state
    const accountData = await getAccountBalance()
    const prices = await fetchCryptoPrices()
    
    // Get recent trades
    const recentTrades = await prisma.trade.findMany({
      where: { modelId },
      orderBy: { createdAt: 'desc' },
      take: 5,
    })
    
    const marketContext = `
Current Account Status:
- Balance: $${accountData.balance.toFixed(2)}
- Total Value: $${accountData.totalValue.toFixed(2)}
- Total P&L: $${accountData.totalPnl.toFixed(2)} (${accountData.totalPnlPercent.toFixed(2)}%)
- Unrealized P&L: $${accountData.unrealizedPnl.toFixed(2)}

Current Prices:
${prices.map(p => `- ${p.symbol}: $${p.price.toFixed(2)} (${p.change24h >= 0 ? '+' : ''}${p.change24h.toFixed(2)}%)`).join('\n')}

Current Positions:
${accountData.positions.length > 0 
  ? accountData.positions.map(p => `- ${p.symbol}: ${p.contracts} contracts @ $${p.entryPrice?.toFixed(2)} (PnL: $${p.unrealizedPnl?.toFixed(2)})`).join('\n')
  : '- No open positions'}

Recent Trades:
${recentTrades.length > 0 
  ? recentTrades.map(t => `- ${t.side.toUpperCase()} ${t.amount} ${t.symbol} @ $${t.price.toFixed(2)}`).join('\n')
  : '- No recent trades'}

What's your next move? You can:
1. Buy a cryptocurrency (specify symbol and amount)
2. Sell a cryptocurrency (specify symbol and amount)  
3. Hold (do nothing)

Provide your decision and reasoning.`

    // Call AI to make decision
    const response = await generateText({
      model: deepseek('deepseek-chat'),
      prompt: `${TRADING_PROMPT}\n\n${marketContext}`,
      maxTokens: 1000,
    })
    
    // Save chat history
    await prisma.chatHistory.create({
      data: {
        modelId,
        role: 'user',
        content: marketContext,
      }
    })
    
    await prisma.chatHistory.create({
      data: {
        modelId,
        role: 'assistant',
        content: response.text,
      }
    })
    
    // Parse decision (simplified - in real implementation would use structured output)
    const decision = response.text.toLowerCase()
    
    if (decision.includes('buy') && decision.includes('btc')) {
      // Example: extract amount and execute buy
      await executeBuy('BTC/USDT', 0.01, response.text)
    } else if (decision.includes('sell') && decision.includes('btc')) {
      await executeSell('BTC/USDT', 0.01, response.text)
    }
    
    return {
      decision: response.text,
      accountData,
    }
  } catch (error) {
    console.error('Error running trading agent:', error)
    throw error
  }
}
