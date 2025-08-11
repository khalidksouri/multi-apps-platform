"use client"

import Link from 'next/link'
import { ArrowLeft } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'
import { UniversalLanguageSelector } from '@/components/language/UniversalLanguageSelector'
import { PricingPlans } from '@/components/subscription/PricingPlans'

export default function PricingPage() {
  const { t, isRTL } = useLanguage()

  const handleSelectPlan = (planId: string, interval: string) => {
    console.log('🛒 [PRICING] Plan sélectionné:', planId, interval)
    // Ici on redirigerait vers Stripe Checkout
    alert(`Plan ${planId} sélectionné pour ${interval}. Redirection vers Stripe...`)
  }

  return (
    <div className={`min-h-screen bg-gray-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header NETTOYÉ */}
      <header className="bg-white border-b border-gray-200 p-6">
        <div className="flex justify-between items-center max-w-7xl mx-auto">
          <div className="flex items-center gap-4">
            <Link 
              href="/"
              className="flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors"
            >
              <ArrowLeft size={20} />
              Retour à l'accueil
            </Link>
            <div className="flex items-center gap-4">
              <div className="text-2xl">🧮</div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math4Child v4.2.0</h1>
                <p className="text-gray-600 text-sm">Plans d'abonnement</p>
              </div>
            </div>
          </div>
          
          <UniversalLanguageSelector />
        </div>
      </header>

      {/* Contenu principal */}
      <main>
        <PricingPlans onSelectPlan={handleSelectPlan} />
      </main>

      {/* Footer NETTOYÉ */}
      <footer className="bg-gray-900 text-white py-8">
        <div className="max-w-7xl mx-auto px-6 text-center">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="text-2xl">🧮</div>
            <span className="text-xl font-bold">Math4Child v4.2.0</span>
          </div>
          <p className="mb-2">Révolution Éducative Mondiale</p>
          <div className="space-y-1 text-sm text-gray-400">
            <p>📧 <strong>Support :</strong> support@math4child.com</p>
            <p>💼 <strong>Commercial :</strong> commercial@math4child.com</p>
            <p>🌐 <strong>Site web :</strong> www.math4child.com</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
