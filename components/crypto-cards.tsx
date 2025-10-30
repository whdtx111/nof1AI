import { prisma } from '@/lib/db'

const cryptoSymbols = [
  { symbol: 'BTC/USDT', name: 'Bitcoin', icon: '₿' },
  { symbol: 'ETH/USDT', name: 'Ethereum', icon: 'Ξ' },
  { symbol: 'SOL/USDT', name: 'Solana', icon: '◎' },
  { symbol: 'BNB/USDT', name: 'BNB', icon: '⬡' },
  { symbol: 'DOGE/USDT', name: 'Dogecoin', icon: 'Ð' },
]

export async function CryptoCards() {
  const prices = await prisma.cryptoPrice.findMany({
    where: {
      symbol: {
        in: cryptoSymbols.map(c => c.symbol)
      }
    }
  })

  const priceMap = new Map(prices.map(p => [p.symbol, p]))

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4 mb-12">
      {cryptoSymbols.map((crypto) => {
        const priceData = priceMap.get(crypto.symbol)
        const price = priceData?.price || 0
        const change = priceData?.change24h || 0
        const isPositive = change >= 0

        return (
          <div 
            key={crypto.symbol}
            className="bg-card border border-border rounded-lg p-4 hover:border-green-500/50 transition-colors"
          >
            <div className="flex items-center justify-between mb-2">
              <div className="flex items-center gap-2">
                <span className="text-2xl">{crypto.icon}</span>
                <div>
                  <h3 className="font-semibold">{crypto.name}</h3>
                  <p className="text-xs text-gray-500">{crypto.symbol.split('/')[0]}</p>
                </div>
              </div>
            </div>
            <div className="mt-3">
              <p className="text-xl font-bold">
                ${price.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
              </p>
              <p className={`text-sm ${isPositive ? 'text-green-500' : 'text-red-500'}`}>
                {isPositive ? '+' : ''}{change.toFixed(2)}%
              </p>
            </div>
          </div>
        )
      })}
    </div>
  )
}
