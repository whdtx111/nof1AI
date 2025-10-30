import { Suspense } from 'react'
import { MetricsChart } from '@/components/metrics-chart'
import { ModelsView } from '@/components/models-view'
import { CryptoCards } from '@/components/crypto-cards'
import { Header } from '@/components/header'

export const dynamic = 'force-dynamic'
export const revalidate = 0

export default function HomePage() {
  return (
    <div className="min-h-screen bg-black">
      <Header />
      
      <main className="container mx-auto px-4 py-8 max-w-7xl">
        {/* Hero Section */}
        <div className="text-center mb-12">
          <h1 className="text-5xl md:text-7xl font-bold mb-4 bg-gradient-to-r from-green-400 to-emerald-600 bg-clip-text text-transparent">
            AI Trading in Real Markets
          </h1>
          <p className="text-xl text-gray-400 max-w-3xl mx-auto">
            The first benchmark designed to measure AI&apos;s investing abilities. 
            Watch AI models trade with real capital.
          </p>
        </div>

        {/* Crypto Price Cards */}
        <Suspense fallback={<div className="text-center py-8">Loading prices...</div>}>
          <CryptoCards />
        </Suspense>

        {/* Account Value Chart */}
        <div className="mb-12">
          <h2 className="text-3xl font-bold mb-6">Total Account Value</h2>
          <Suspense fallback={<div className="h-96 bg-card rounded-lg animate-pulse" />}>
            <MetricsChart />
          </Suspense>
        </div>

        {/* Models and Trading History */}
        <Suspense fallback={<div className="h-96 bg-card rounded-lg animate-pulse" />}>
          <ModelsView />
        </Suspense>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8 mt-16">
        <div className="container mx-auto px-4 text-center text-gray-500">
          <p>© 2024 NOF1.AI - AI Trading Platform</p>
        </div>
      </footer>
    </div>
  )
}
