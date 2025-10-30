import ccxt from 'ccxt'

const exchange = new ccxt.binance({
  options: {
    defaultType: 'future',
  },
})

const SYMBOLS = ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT', 'DOGE/USDT']

export async function fetchCryptoPrices() {
  try {
    const tickers = await exchange.fetchTickers(SYMBOLS)
    
    return SYMBOLS.map(symbol => ({
      symbol,
      price: tickers[symbol]?.last || 0,
      change24h: tickers[symbol]?.percentage || 0,
    }))
  } catch (error) {
    console.error('Error fetching crypto prices:', error)
    // Return mock data if exchange is not available
    return [
      { symbol: 'BTC/USDT', price: 50000, change24h: 2.5 },
      { symbol: 'ETH/USDT', price: 3000, change24h: 1.8 },
      { symbol: 'SOL/USDT', price: 100, change24h: -0.5 },
      { symbol: 'BNB/USDT', price: 300, change24h: 0.9 },
      { symbol: 'DOGE/USDT', price: 0.08, change24h: 3.2 },
    ]
  }
}

export async function getCurrentPrice(symbol: string): Promise<number> {
  try {
    const ticker = await exchange.fetchTicker(symbol)
    return ticker.last || 0
  } catch (error) {
    console.error(`Error fetching price for ${symbol}:`, error)
    return 0
  }
}
