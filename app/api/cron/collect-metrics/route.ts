import { NextResponse } from 'next/server'
import { headers } from 'next/headers'
import { prisma } from '@/lib/db'
import { getAccountBalance } from '@/lib/trading/account'

export const dynamic = 'force-dynamic'

export async function GET() {
  const headersList = await headers()
  const authorization = headersList.get('authorization')
  
  if (authorization !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    const accountData = await getAccountBalance()
    
    await prisma.metric.create({
      data: {
        accountValue: accountData.totalValue,
        totalPnl: accountData.totalPnl,
        totalPnlPercent: accountData.totalPnlPercent,
        unrealizedPnl: accountData.unrealizedPnl,
        realizedPnl: accountData.realizedPnl,
        balance: accountData.balance,
      }
    })

    return NextResponse.json({ success: true, data: accountData })
  } catch (error) {
    console.error('Error collecting metrics:', error)
    return NextResponse.json({ error: 'Failed to collect metrics' }, { status: 500 })
  }
}
