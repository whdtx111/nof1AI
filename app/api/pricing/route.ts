import { NextResponse } from 'next/server'
import { prisma } from '@/lib/db'

export const dynamic = 'force-dynamic'

export async function GET() {
  try {
    const prices = await prisma.cryptoPrice.findMany()
    
    return NextResponse.json(prices)
  } catch (error) {
    console.error('Error fetching prices:', error)
    return NextResponse.json({ error: 'Failed to fetch prices' }, { status: 500 })
  }
}
