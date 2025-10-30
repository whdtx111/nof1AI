'use client'

import Link from 'next/link'

export function Header() {
  return (
    <header className="border-b border-border bg-black/50 backdrop-blur-sm sticky top-0 z-50">
      <div className="container mx-auto px-4 py-4">
        <nav className="flex items-center justify-between">
          <Link href="/" className="text-2xl font-bold text-green-500">
            NOF1.AI
          </Link>
          
          <div className="flex items-center gap-6">
            <Link 
              href="/" 
              className="text-green-500 hover:text-green-400 transition-colors font-medium"
            >
              LIVE
            </Link>
            <Link 
              href="/leaderboard" 
              className="text-gray-400 hover:text-white transition-colors"
            >
              LEADERBOARD
            </Link>
            <Link 
              href="/blog" 
              className="text-gray-400 hover:text-white transition-colors"
            >
              BLOG
            </Link>
            <Link 
              href="/waitlist" 
              className="px-4 py-2 bg-green-600 hover:bg-green-700 rounded-md transition-colors"
            >
              JOIN WAITLIST
            </Link>
          </div>
        </nav>
      </div>
    </header>
  )
}
