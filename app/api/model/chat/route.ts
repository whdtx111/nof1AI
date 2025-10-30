import { NextResponse } from 'next/server'
import { prisma } from '@/lib/db'

export const dynamic = 'force-dynamic'

export async function GET() {
  try {
    const chats = await prisma.chatHistory.findMany({
      orderBy: { createdAt: 'desc' },
      take: 50
    })
    
    return NextResponse.json(chats)
  } catch (error) {
    console.error('Error fetching chat history:', error)
    return NextResponse.json({ error: 'Failed to fetch chat history' }, { status: 500 })
  }
}
