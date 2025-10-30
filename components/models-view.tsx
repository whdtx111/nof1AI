'use client'

import { useEffect, useState } from 'react'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'

interface Trade {
  id: string
  symbol: string
  side: string
  amount: number
  price: number
  totalValue: number
  reasoning: string
  status: string
  createdAt: string
}

interface ChatMessage {
  id: string
  role: string
  content: string
  createdAt: string
}

export function ModelsView() {
  const [trades, setTrades] = useState<Trade[]>([])
  const [chats, setChats] = useState<ChatMessage[]>([])

  useEffect(() => {
    async function fetchData() {
      try {
        const [tradesRes, chatsRes] = await Promise.all([
          fetch('/api/trades'),
          fetch('/api/model/chat')
        ])
        const tradesData = await tradesRes.json()
        const chatsData = await chatsRes.json()
        setTrades(tradesData)
        setChats(chatsData)
      } catch (error) {
        console.error('Failed to fetch data:', error)
      }
    }

    fetchData()
    const interval = setInterval(fetchData, 30000) // Update every 30 seconds

    return () => clearInterval(interval)
  }, [])

  return (
    <div className="bg-card border border-border rounded-lg p-6">
      <h2 className="text-2xl font-bold mb-6">DeepSeek Model</h2>
      
      <Tabs defaultValue="trades" className="w-full">
        <TabsList className="grid w-full grid-cols-2 mb-6">
          <TabsTrigger value="trades">Trades</TabsTrigger>
          <TabsTrigger value="reasoning">Reasoning</TabsTrigger>
        </TabsList>
        
        <TabsContent value="trades" className="space-y-4">
          {trades.length === 0 ? (
            <div className="text-center py-8 text-gray-500">No trades yet</div>
          ) : (
            trades.map((trade) => (
              <div key={trade.id} className="border border-border rounded-lg p-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <span className={`px-3 py-1 rounded text-sm font-semibold ${
                      trade.side === 'buy' ? 'bg-green-500/20 text-green-500' : 'bg-red-500/20 text-red-500'
                    }`}>
                      {trade.side.toUpperCase()}
                    </span>
                    <span className="font-bold">{trade.symbol}</span>
                  </div>
                  <span className="text-sm text-gray-500">
                    {new Date(trade.createdAt).toLocaleString()}
                  </span>
                </div>
                <div className="grid grid-cols-3 gap-4 text-sm mb-3">
                  <div>
                    <span className="text-gray-500">Amount:</span>
                    <span className="ml-2 font-semibold">{trade.amount}</span>
                  </div>
                  <div>
                    <span className="text-gray-500">Price:</span>
                    <span className="ml-2 font-semibold">${trade.price.toFixed(2)}</span>
                  </div>
                  <div>
                    <span className="text-gray-500">Total:</span>
                    <span className="ml-2 font-semibold">${trade.totalValue.toFixed(2)}</span>
                  </div>
                </div>
                <div className="text-sm text-gray-400">
                  <span className="text-gray-500">Reasoning:</span>
                  <p className="mt-1">{trade.reasoning}</p>
                </div>
              </div>
            ))
          )}
        </TabsContent>
        
        <TabsContent value="reasoning" className="space-y-4">
          {chats.length === 0 ? (
            <div className="text-center py-8 text-gray-500">No reasoning data yet</div>
          ) : (
            chats.map((chat) => (
              <div key={chat.id} className="border border-border rounded-lg p-4">
                <div className="flex items-center justify-between mb-2">
                  <span className={`px-3 py-1 rounded text-sm font-semibold ${
                    chat.role === 'assistant' ? 'bg-blue-500/20 text-blue-500' : 'bg-gray-500/20 text-gray-400'
                  }`}>
                    {chat.role.toUpperCase()}
                  </span>
                  <span className="text-sm text-gray-500">
                    {new Date(chat.createdAt).toLocaleString()}
                  </span>
                </div>
                <div className="text-sm whitespace-pre-wrap">{chat.content}</div>
              </div>
            ))
          )}
        </TabsContent>
      </Tabs>
    </div>
  )
}
