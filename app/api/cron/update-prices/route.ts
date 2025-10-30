import { NextResponse } from 'next/server'
import { headers } from 'next/headers'
import { prisma } from '@/lib/db'
import { fetchCryptoPrices } from '@/lib/trading/pricing'

export const dynamic = 'force-dynamic'

export async function GET() {
  const headersList = await headers()
  const authorization = headersList.get('authorization')
  
  if (authorization !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    const prices = await fetchCryptoPrices()
    
    for (const price of prices) {
      await prisma.cryptoPrice.upsert({
        where: { symbol: price.symbol },
        update: {
          price: price.price,
          change24h: price.change24h,
        },
        create: {
          symbol: price.symbol,
          price: price.price,
          change24h: price.change24h,
        }
      })
    }

    return NextResponse.json({ success: true, prices })
  } catch (error) {
    console.error('Error updating prices:', error)
    return NextResponse.json({ error: 'Failed to update prices' }, { status: 500 })
  }
}
