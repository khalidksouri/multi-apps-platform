'use client'

import React, { useState } from 'react'

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [isDropdownOpen, setIsDropdownOpen] = useState(false)

  const languages = [
    { code: 'fr', name: 'Français', flag: '🇫🇷' },
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'es', name: 'Español', flag: '🇪🇸' }
  ]

  const translations = {
    fr: {
      title: 'Math4Child',
      subtitle: 'Apprendre les mathématiques en s\'amusant',
      startFree: 'Commencer gratuitement',
      comparePrices: 'Voir les prix',
      description: 'Une application éducative moderne avec un système de paiement optimisé.'
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Learn mathematics while having fun',
      startFree: 'Start for free',
      comparePrices: 'Compare prices',
      description: 'A modern educational application with an optimized payment system.'
    },
    es: {
      title: 'Math4Child',
      subtitle: 'Aprende matemáticas divirtiéndote',
      startFree: 'Empezar gratis',
      comparePrices: 'Comparar precios',
      description: 'Una aplicación educativa moderna con un sistema de pago optimizado.'
    }
  }

  const t = translations[currentLang] || translations.fr
  const currentLanguage = languages.find(lang => lang.code === currentLang) || languages[0]

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
              {t.title}
            </h1>
          </div>
          
          {/* Language Selector */}
          <div className="relative">
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <span className="text-lg">{currentLanguage.flag}</span>
              <span className="text-sm font-medium text-gray-700">{currentLanguage.name}</span>
              <span className="text-sm">▼</span>
            </button>

            {isDropdownOpen && (
              <div className="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg z-50">
                {languages.map((language) => (
                  <button
                    key={language.code}
                    onClick={() => {
                      setCurrentLang(language.code)
                      setIsDropdownOpen(false)
                    }}
                    className={`w-full flex items-center space-x-3 px-4 py-3 text-left hover:bg-blue-50 transition-colors ${
                      currentLang === language.code ? 'bg-blue-100 text-blue-700 font-medium' : 'text-gray-700'
                    }`}
                  >
                    <span className="text-xl">{language.flag}</span>
                    <span className="text-sm font-medium">{language.name}</span>
                  </button>
                ))}
              </div>
            )}
          </div>
        </header>
        
        {/* Hero Section */}
        <div className="text-center py-16">
          <h2 className="text-white text-5xl font-bold mb-6">
            {t.subtitle}
          </h2>
          
          <p className="text-blue-100 text-xl mb-12 max-w-2xl mx-auto">
            {t.description}
          </p>
          
          <div className="space-x-4">
            <button className="bg-white text-blue-600 px-8 py-4 rounded-lg font-semibold hover:bg-blue-50 transition-colors">
              {t.startFree}
            </button>
            <button className="border-2 border-white text-white px-8 py-4 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition-colors">
              {t.comparePrices}
            </button>
          </div>
        </div>

        {/* Features Section */}
        <div className="grid md:grid-cols-3 gap-8 mt-16">
          <div className="text-center">
            <div className="text-6xl mb-4">🧮</div>
            <h3 className="text-white text-xl font-bold mb-2">Mathématiques</h3>
            <p className="text-blue-100">Exercices adaptés à chaque niveau</p>
          </div>
          <div className="text-center">
            <div className="text-6xl mb-4">🎮</div>
            <h3 className="text-white text-xl font-bold mb-2">Ludique</h3>
            <p className="text-blue-100">Apprendre en s'amusant</p>
          </div>
          <div className="text-center">
            <div className="text-6xl mb-4">💳</div>
            <h3 className="text-white text-xl font-bold mb-2">Paiement Optimal</h3>
            <p className="text-blue-100">Système de paiement multi-provider</p>
          </div>
        </div>

        {/* Footer */}
        <footer className="mt-16 text-center text-blue-100">
          <p>© 2024 Math4Child - Application éducative moderne</p>
          <p className="mt-2">✅ Déployé avec succès sur Netlify</p>
        </footer>
      </div>
    </main>
  )
}
