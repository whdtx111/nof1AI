'use client'

import { useEffect, useState } from 'react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'

interface MetricData {
  id: string
  accountValue: number
  totalPnl: number
  totalPnlPercent: number
  createdAt: string
}

export function MetricsChart() {
  const [data, setData] = useState<MetricData[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchMetrics() {
      try {
        const response = await fetch('/api/metrics')
        const metrics = await response.json()
        setData(metrics)
      } catch (error) {
        console.error('Failed to fetch metrics:', error)
      } finally {
        setLoading(false)
      }
    }

    fetchMetrics()
    const interval = setInterval(fetchMetrics, 20000) // Update every 20 seconds

    return () => clearInterval(interval)
  }, [])

  if (loading) {
    return <div className="h-96 bg-card rounded-lg animate-pulse" />
  }

  const chartData = data.map((metric) => ({
    time: new Date(metric.createdAt).toLocaleTimeString(),
    value: metric.accountValue,
  }))

  const currentValue = data[data.length - 1]?.accountValue || 10000
  const initialValue = 10000
  const totalPnl = currentValue - initialValue
  const totalPnlPercent = ((totalPnl / initialValue) * 100)

  return (
    <div className="bg-card border border-border rounded-lg p-6">
      <div className="mb-6">
        <div className="text-4xl font-bold mb-2">
          ${currentValue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
        </div>
        <div className={`text-xl ${totalPnl >= 0 ? 'text-green-500' : 'text-red-500'}`}>
          {totalPnl >= 0 ? '+' : ''}${totalPnl.toFixed(2)} ({totalPnlPercent >= 0 ? '+' : ''}{totalPnlPercent.toFixed(2)}%)
        </div>
      </div>

      <div className="h-80">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#333" />
            <XAxis 
              dataKey="time" 
              stroke="#666"
              style={{ fontSize: '12px' }}
            />
            <YAxis 
              stroke="#666"
              style={{ fontSize: '12px' }}
              domain={['dataMin - 100', 'dataMax + 100']}
            />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: '#111', 
                border: '1px solid #333',
                borderRadius: '8px'
              }}
            />
            <Line 
              type="monotone" 
              dataKey="value" 
              stroke="#10b981" 
              strokeWidth={2}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}
