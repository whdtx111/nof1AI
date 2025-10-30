import { NextResponse } from 'next/server'
import { headers } from 'next/headers'
import { runTradingAgent } from '@/lib/ai/agent'

export const dynamic = 'force-dynamic'
export const maxDuration = 60

export async function GET() {
  const headersList = await headers()
  const authorization = headersList.get('authorization')
  
  if (authorization !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    const result = await runTradingAgent()
    return NextResponse.json({ success: true, result })
  } catch (error) {
    console.error('Error executing trade:', error)
    return NextResponse.json({ error: 'Failed to execute trade' }, { status: 500 })
  }
}
