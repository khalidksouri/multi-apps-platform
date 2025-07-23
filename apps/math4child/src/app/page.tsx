'use client'

import { useLanguage } from '@/contexts/LanguageContext'
import LanguageDropdown from '@/components/language/LanguageDropdown'

export default function Home() {
  const { t } = useLanguage()

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-600 to-purple-700">
      <div className="container mx-auto px-4 py-8">
        <header className="flex justify-between items-center mb-12">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center">
              <span className="text-blue-600 font-bold text-lg">M4C</span>
            </div>
            <h1 className="text-white text-2xl font-bold">
              {t('home.title', 'Math4Child')}
            </h1>
          </div>
          <LanguageDropdown className="w-64" />
        </header>
        
        <div className="text-center py-16">
          <h2 className="text-white text-5xl font-bold mb-6">
            {t('home.subtitle', 'Apprendre les mathématiques en s\'amusant')}
          </h2>
          
          <p className="text-blue-100 text-xl mb-12 max-w-2xl mx-auto">
            Une application éducative moderne avec un système de paiement optimisé.
          </p>
          
          <div className="space-x-4">
            <button className="bg-white text-blue-600 px-8 py-4 rounded-lg font-semibold hover:bg-blue-50 transition-colors">
              {t('home.startFree', 'Commencer gratuitement')}
            </button>
            <button className="border-2 border-white text-white px-8 py-4 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition-colors">
              {t('home.comparePrices', 'Voir les prix')}
            </button>
          </div>
        </div>
      </div>
    </main>
  )
}
