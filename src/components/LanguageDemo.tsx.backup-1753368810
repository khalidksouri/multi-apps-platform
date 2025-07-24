'use client'
import { useState } from 'react'
import LanguageDropdown from './language/LanguageDropdown'

interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
}

const translations: Record<string, Record<string, string>> = {
  fr: {
    appName: 'Math4Child',
    tagline: "L'app éducative n°1 pour apprendre les maths en famille !",
    startFree: 'Commencer gratuitement',
    familiesCount: '100k+ familles nous font confiance',
    features: 'Fonctionnalités principales',
    feature1: '5 niveaux de difficulté',
    feature2: 'Mode hors-ligne complet',
    feature3: 'Rapports de progression'
  },
  en: {
    appName: 'Math4Child',
    tagline: 'The #1 educational app for learning math as a family!',
    startFree: 'Start Free',
    familiesCount: '100k+ families trust us',
    features: 'Key Features',
    feature1: '5 difficulty levels',
    feature2: 'Complete offline mode',
    feature3: 'Progress reports'
  },
  es: {
    appName: 'Math4Child',
    tagline: '¡La app educativa n°1 para aprender matemáticas en familia!',
    startFree: 'Comenzar gratis',
    familiesCount: '100k+ familias confían en nosotros',
    features: 'Características principales',
    feature1: '5 niveles de dificultad',
    feature2: 'Modo sin conexión completo',
    feature3: 'Informes de progreso'
  },
  pt: {
    appName: 'Math4Child',
    tagline: 'O app educacional nº1 para aprender matemática em família!',
    startFree: 'Começar grátis',
    familiesCount: '100k+ famílias confiam em nós',
    features: 'Principais recursos',
    feature1: '5 níveis de dificuldade',
    feature2: 'Modo offline completo',
    feature3: 'Relatórios de progresso'
  },
  ar: {
    appName: 'Math4Child',
    tagline: 'تطبيق التعليم رقم 1 لتعلم الرياضيات مع العائلة!',
    startFree: 'ابدأ مجاناً',
    familiesCount: '100 ألف+ عائلة تثق بنا',
    features: 'الميزات الرئيسية',
    feature1: '5 مستويات صعوبة',
    feature2: 'وضع غير متصل كامل',
    feature3: 'تقارير التقدم'
  }
}

export default function LanguageDemo() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>({
    code: 'pt',
    name: 'Português',
    flag: '🇵🇹'
  })

  const handleLanguageChange = (language: Language) => {
    setSelectedLanguage(language)
  }

  const t = translations[selectedLanguage.code] || translations.en

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-purple-800 to-pink-700">
      <div className="container mx-auto px-4 py-8">
        {/* Header avec badge familles */}
        <div className="text-center mb-8">
          <div className="inline-block bg-white/20 backdrop-blur-sm rounded-full px-6 py-2 text-white/90 text-sm font-medium mb-6">
            {t.familiesCount}
          </div>
        </div>

        {/* Language Dropdown */}
        <div className="max-w-md mx-auto mb-8">
          <LanguageDropdown 
            onLanguageChange={handleLanguageChange}
            defaultLanguage={selectedLanguage.code}
          />
        </div>

        {/* Contenu traduit en temps réel */}
        <div 
          className="max-w-4xl mx-auto bg-white/10 backdrop-blur-sm rounded-3xl p-8 border border-white/20"
          dir={selectedLanguage.rtl ? 'rtl' : 'ltr'}
        >
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-white mb-4">
              {t.appName}
            </h1>
            <p className="text-xl text-white/90 mb-6">
              {t.tagline}
            </p>
            <button className="bg-green-500 hover:bg-green-600 text-white px-8 py-3 rounded-full font-semibold transition-colors duration-200 text-lg">
              {t.startFree}
            </button>
          </div>

          {/* Fonctionnalités */}
          <div className="mt-12">
            <h2 className="text-2xl font-bold text-white mb-6 text-center">
              {t.features}
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-white/10 rounded-2xl p-6 text-center">
                <div className="text-3xl mb-3">🎯</div>
                <p className="text-white font-medium">{t.feature1}</p>
              </div>
              <div className="bg-white/10 rounded-2xl p-6 text-center">
                <div className="text-3xl mb-3">📱</div>
                <p className="text-white font-medium">{t.feature2}</p>
              </div>
              <div className="bg-white/10 rounded-2xl p-6 text-center">
                <div className="text-3xl mb-3">📊</div>
                <p className="text-white font-medium">{t.feature3}</p>
              </div>
            </div>
          </div>

          {/* Info sur la langue sélectionnée */}
          <div className="mt-8 text-center">
            <div className="inline-flex items-center space-x-3 bg-white/20 rounded-full px-4 py-2">
              <span className="text-2xl">{selectedLanguage.flag}</span>
              <span className="text-white font-medium">
                Langue actuelle: {selectedLanguage.name}
              </span>
              {selectedLanguage.rtl && (
                <span className="text-xs bg-blue-500 text-white px-2 py-1 rounded-full">
                  RTL
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Instructions */}
        <div className="max-w-2xl mx-auto mt-8 text-center">
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
            <h3 className="text-lg font-semibold text-white mb-3">
              🎨 Fonctionnalités du composant
            </h3>
            <ul className="text-white/80 text-sm space-y-2">
              <li>✅ Scroll personnalisé visible et opérationnel</li>
              <li>✅ 47+ langues avec drapeaux</li>
              <li>✅ Support RTL pour arabe et hébreu</li>
              <li>✅ Traduction en temps réel</li>
              <li>✅ Animations fluides</li>
              <li>✅ Accessibilité complète (ARIA)</li>
              <li>✅ Responsive design</li>
              <li>✅ Fermeture automatique</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}
