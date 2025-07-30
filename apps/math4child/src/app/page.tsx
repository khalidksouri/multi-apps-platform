'use client'

import { useLanguage } from '@/contexts/LanguageContext'
import LanguageSelector from '@/components/language/LanguageSelector'

export default function Home() {
  const { currentLanguage, t, isRTL } = useLanguage()
  
  return (
    <main 
      className={`min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 text-white`}
      dir={isRTL ? 'rtl' : 'ltr'}
      lang={currentLanguage}
    >
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-4xl font-bold" data-testid="app-title">
            {t.appName}
          </h1>
          <LanguageSelector />
        </header>

        {/* Hero Section */}
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

        {/* Games Section */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.mathGames}</h3>
          <p className="text-center mb-12">{t.chooseGame}</p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: t.puzzleMath, icon: '🧩', level: t.beginner },
              { name: t.memoryMath, icon: '🧠', level: t.intermediate },
              { name: t.quickMath, icon: '⚡', level: t.advanced },
              { name: t.mixedExercises, icon: '🎯', level: t.expert }
            ].map((game, index) => (
              <div 
                key={index} 
                className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 hover:bg-opacity-30 transition-all cursor-pointer"
                data-testid={`game-${index}`}
              >
                <div className="text-4xl mb-4">{game.icon}</div>
                <h4 className="text-xl font-semibold mb-2">{game.name}</h4>
                <p className="text-sm opacity-75">{game.level}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Pricing Link */}
        <section className="text-center">
          <h3 className="text-3xl font-bold mb-4">{t.choosePlan}</h3>
          <a 
            href="/pricing"
            className="bg-purple-500 hover:bg-purple-600 text-white px-8 py-4 rounded-full text-lg font-semibold transition-colors inline-block"
            data-testid="pricing-link"
          >
            {t.pricing}
          </a>
        </section>

        {/* RTL Indicator */}
        {isRTL && (
          <div className="fixed bottom-4 left-4 bg-black bg-opacity-50 text-white px-3 py-1 rounded-lg text-sm">
            RTL Mode ✓
          </div>
        )}
      </div>
    </main>
  )
}
