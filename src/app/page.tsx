'use client'

import { useState } from 'react'
import { comprehensiveTranslations, SUPPORTED_LANGUAGES } from '../lib/translations/comprehensive'

export default function Home() {
  const [currentLanguage, setCurrentLanguage] = useState<'fr' | 'en' | 'es' | 'ar'>('fr')
  
  const t = comprehensiveTranslations[currentLanguage]
  
  const changeLanguage = (lang: 'fr' | 'en' | 'es' | 'ar') => {
    setCurrentLanguage(lang)
    document.documentElement.lang = lang
    if (lang === 'ar') {
      document.documentElement.dir = 'rtl'
    } else {
      document.documentElement.dir = 'ltr'
    }
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 text-white">
      <div className="container mx-auto px-4 py-8">
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-4xl font-bold" data-testid="app-title">
            {t.appName}
          </h1>
          
          <select
            data-testid="language-selector"
            className="bg-white text-gray-800 px-4 py-2 rounded-lg"
            value={currentLanguage}
            onChange={(e) => changeLanguage(e.target.value as any)}
          >
            {SUPPORTED_LANGUAGES.map((lang) => (
              <option key={lang.code} value={lang.code}>
                {lang.flag} {lang.name}
              </option>
            ))}
          </select>
        </header>

        <section className="text-center mb-16">
          <h2 className="text-6xl font-bold mb-6">{t.heroTitle}</h2>
          <p className="text-xl mb-8">{t.heroSubtitle}</p>
          <p className="text-lg mb-12 opacity-90">{t.heroDescription}</p>
          
          <div className="flex justify-center gap-4">
            <button 
              className="bg-yellow-400 text-gray-800 px-8 py-4 rounded-full text-lg font-semibold hover:bg-yellow-300 transition-colors"
              data-testid="start-free"
            >
              {t.startFreeNow}
            </button>
            <button 
              className="border-2 border-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white hover:text-gray-800 transition-colors"
            >
              {t.learnMore}
            </button>
          </div>
        </section>

        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.mathGames}</h3>
          <p className="text-center mb-12">{t.chooseGame}</p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: t.puzzleMath, id: 'puzzle' },
              { name: t.memoryMath, id: 'memory' },
              { name: t.quickMath, id: 'quick' },
              { name: t.mixedExercises, id: 'mixed' }
            ].map((game) => (
              <div key={game.id} className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 text-center">
                <h4 className="text-xl font-semibold mb-4">{game.name}</h4>
                <button className="bg-green-500 text-white px-6 py-2 rounded-lg hover:bg-green-600 transition-colors">
                  {t.playNow}
                </button>
              </div>
            ))}
          </div>
        </section>

        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.choosePlan}</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
            {[
              { name: t.freePlan, price: '0€', features: ['10 questions/jour', '1 profil'] },
              { name: t.premiumPlan, price: '9.99€', features: [t.unlimitedQuestions, t.allLevels] },
              { name: t.familyPlan, price: '19.99€', features: [t.unlimitedQuestions, t.allLevels, t.multipleProfiles] }
            ].map((plan, index) => (
              <div key={index} className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 text-center">
                <h4 className="text-xl font-semibold mb-2">{plan.name}</h4>
                <div className="text-3xl font-bold mb-4">{plan.price}</div>
                <ul className="mb-6 space-y-2">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="text-sm">✓ {feature}</li>
                  ))}
                </ul>
                <button className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors w-full">
                  {t.selectPlan}
                </button>
              </div>
            ))}
          </div>
        </section>

        <footer className="text-center opacity-70">
          <p>&copy; 2024 {t.appName} - {t.appFullName}</p>
        </footer>
      </div>
    </main>
  )
}
