'use client'

import React, { useState, useEffect } from 'react'
import { Sparkles, BookOpen, Calculator, Trophy, Globe, ChevronDown } from 'lucide-react'

// Types pour les langues supportées
type SupportedLanguage = 'fr' | 'en'

interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  appName: string
}

// Configuration des langues
const SUPPORTED_LANGUAGES: Record<SupportedLanguage, LanguageConfig> = {
  fr: {
    name: 'French',
    nativeName: 'Français',
    flag: '🇫🇷',
    appName: 'Math4Child'
  },
  en: {
    name: 'English',
    nativeName: 'English',
    flag: '🇺🇸',
    appName: 'Math4Child'
  }
}

// Traductions
const translations: Record<SupportedLanguage, any> = {
  fr: {
    title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
    subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
    features: {
      interactive: 'Apprentissage interactif',
      multilingual: 'Support multilingue',
      progress: 'Suivi des progrès',
      games: 'Jeux éducatifs'
    },
    cta: {
      freeTrial: 'Essai Gratuit 7 Jours',
      subscribe: 'S\'abonner - 9.99€/mois',
      demo: 'Voir la Démo'
    }
  },
  en: {
    title: 'Math4Child - Learn math while having fun',
    subtitle: 'Multilingual educational platform for children aged 4 to 12',
    features: {
      interactive: 'Interactive Learning',
      multilingual: 'Multilingual Support',
      progress: 'Progress Tracking',
      games: 'Educational Games'
    },
    cta: {
      freeTrial: '7-Day Free Trial',
      subscribe: 'Subscribe - $9.99/month',
      demo: 'View Demo'
    }
  }
}

export default function PageFallback() {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('fr')
  const [freeTrialActive, setFreeTrialActive] = useState(false)

  // Correction TypeScript : typage explicite pour éviter l'erreur d'index
  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage as SupportedLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as SupportedLanguage] || translations['fr']

  const startFreeTrial = () => {
    setFreeTrialActive(true)
    // Redirection vers la page d'inscription ou logique d'essai gratuit
    console.log('Démarrage de l\'essai gratuit')
  }

  const handleSubscribe = () => {
    // Redirection vers Stripe ou logique d'abonnement
    console.log('Redirection vers l\'abonnement')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header avec sélecteur de langue */}
      <header className="p-4 flex justify-between items-center">
        <div className="flex items-center space-x-2">
          <Calculator className="w-8 h-8 text-blue-600" />
          <span className="text-xl font-bold text-gray-800">{currentLangConfig.appName}</span>
        </div>
        
        <div className="relative">
          <select 
            value={currentLanguage}
            onChange={(e) => setCurrentLanguage(e.target.value as SupportedLanguage)}
            className="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-2 pr-8 text-sm font-medium text-gray-700 hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            {Object.entries(SUPPORTED_LANGUAGES).map(([code, config]) => (
              <option key={code} value={code}>
                {config.flag} {config.nativeName}
              </option>
            ))}
          </select>
          <ChevronDown className="absolute right-2 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
        </div>
      </header>

      {/* Contenu principal */}
      <main className="container mx-auto px-4 py-16 text-center">
        {/* Hero Section */}
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-800 mb-6">
            {t.title}
          </h1>
          <p className="text-xl md:text-2xl text-gray-600 mb-12">
            {t.subtitle}
          </p>

          {/* Features Grid */}
          <div className="grid md:grid-cols-4 gap-8 mb-16">
            <div className="p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <BookOpen className="w-12 h-12 text-blue-600 mx-auto mb-4" />
              <h3 className="font-semibold text-gray-800 mb-2">{t.features.interactive}</h3>
            </div>
            <div className="p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <Globe className="w-12 h-12 text-green-600 mx-auto mb-4" />
              <h3 className="font-semibold text-gray-800 mb-2">{t.features.multilingual}</h3>
            </div>
            <div className="p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <Trophy className="w-12 h-12 text-yellow-600 mx-auto mb-4" />
              <h3 className="font-semibold text-gray-800 mb-2">{t.features.progress}</h3>
            </div>
            <div className="p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <Sparkles className="w-12 h-12 text-purple-600 mx-auto mb-4" />
              <h3 className="font-semibold text-gray-800 mb-2">{t.features.games}</h3>
            </div>
          </div>

          {/* Call to Action */}
          <div className="space-y-4 md:space-y-0 md:space-x-4 md:flex md:justify-center">
            <button
              onClick={startFreeTrial}
              className={`px-8 py-4 rounded-xl font-semibold text-white transition-all transform hover:scale-105 ${
                freeTrialActive 
                  ? 'bg-green-600 hover:bg-green-700' 
                  : 'bg-blue-600 hover:bg-blue-700'
              }`}
            >
              {freeTrialActive ? '✅ Essai Activé!' : t.cta.freeTrial}
            </button>
            
            <button
              onClick={handleSubscribe}
              className="px-8 py-4 bg-purple-600 text-white rounded-xl font-semibold hover:bg-purple-700 transition-all transform hover:scale-105"
            >
              {t.cta.subscribe}
            </button>
            
            <button className="px-8 py-4 border-2 border-gray-300 text-gray-700 rounded-xl font-semibold hover:border-gray-400 hover:bg-gray-50 transition-all">
              {t.cta.demo}
            </button>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 text-center text-gray-500">
        <p>&copy; 2024 {currentLangConfig.appName}. Made with ❤️ for children.</p>
      </footer>
    </div>
  )
}
