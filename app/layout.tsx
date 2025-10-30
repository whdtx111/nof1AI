import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'AI Trading in Real Markets - NOF1.AI',
  description: 'The first benchmark designed to measure AI\'s investing abilities. Watch AI models trade with real capital.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="antialiased bg-black text-white min-h-screen">
        {children}
      </body>
    </html>
  )
}
