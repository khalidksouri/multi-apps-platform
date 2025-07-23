'use client'

import { useLanguage } from '@/contexts/LanguageContext'
import LanguageDropdown from '@/components/language/LanguageDropdown'

export default function Home() {
  const { currentLanguage, t } = useLanguage()

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-600 to-purple-700">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
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
        
        {/* Hero Section */}
        <div className="text-center py-16">
          <h2 className="text-white text-5xl font-bold mb-6">
            {t('home.subtitle', 'Apprendre les mathématiques en s\'amusant')}
          </h2>
          
          <p className="text-blue-100 text-xl mb-12 max-w-2xl mx-auto">
            Une application éducative moderne avec un système de paiement optimisé 
            et support multilingue complet.
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
        
        {/* Features */}
        <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 text-white">
            <h3 className="text-xl font-semibold mb-3">🎯 Apprentissage ciblé</h3>
            <p className="text-blue-100">
              Exercices adaptés au niveau de chaque enfant pour un apprentissage optimal.
            </p>
          </div>
          
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 text-white">
            <h3 className="text-xl font-semibold mb-3">🌍 Multilingue</h3>
            <p className="text-blue-100">
              Interface disponible en plusieurs langues pour une accessibilité maximale.
            </p>
          </div>
          
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 text-white">
            <h3 className="text-xl font-semibold mb-3">💳 Paiements flexibles</h3>
            <p className="text-blue-100">
              Système de paiement optimisé avec plusieurs options disponibles.
            </p>
          </div>
        </div>
        
        {/* Status Info */}
        <div className="mt-16 text-center text-white/80">
          <p className="text-sm">
            Build version: 2.0.0 | Current language: {currentLanguage}
          </p>
        </div>
      </div>
    </main>
  )
}
