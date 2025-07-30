'use client'

import { useLanguage } from '@/contexts/LanguageContext'

export default function PricingPage() {
  const { t, isRTL } = useLanguage()
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12" dir={isRTL ? 'rtl' : 'ltr'}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            {t.choosePlan}
          </h1>
          <p className="text-xl text-gray-600">
            Plans flexibles pour tous vos besoins éducatifs
          </p>
        </div>
        
        <div className="text-center">
          <p className="text-lg text-gray-600 mb-8">
            Interface pricing complète sera disponible bientôt !
          </p>
          <a 
            href="/"
            className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg font-medium transition-colors"
          >
            Retour à l'accueil
          </a>
        </div>
      </div>
    </div>
  )
}
