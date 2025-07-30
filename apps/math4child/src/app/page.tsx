'use client'

import { useTranslation } from '@/hooks/useTranslation'
import { LanguageSelector } from '@/components/LanguageSelector'
import { Play, Users, Award, Globe, BookOpen, Calculator, Target, Sparkles } from 'lucide-react'

export default function HomePage() {
  const { t, currentLanguage, isRTL, totalLanguages, getRTLLanguages } = useTranslation()
  const rtlLanguages = getRTLLanguages()

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        {/* Header avec logo et sélecteur de langue */}
        <header className="flex justify-between items-center mb-12">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <Calculator className="w-6 h-6 text-white" />
            </div>
            <h1 className="text-4xl font-bold text-white">
              {t('appName')}
            </h1>
          </div>
          
          {/* Sélecteur de langue avancé */}
          <LanguageSelector className="min-w-[200px]" />
        </header>

        {/* Hero Section */}
        <main className="text-center mb-16">
          <div className="bg-white/10 backdrop-blur-sm rounded-3xl p-12 max-w-4xl mx-auto border border-white/20">
            {/* Badge */}
            <div className="inline-flex items-center bg-green-500/20 text-green-100 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <Award className="w-4 h-4 mr-2" />
              {t('badge')}
            </div>

            <h2 className="text-5xl font-bold text-white mb-6">
              {t('tagline')}
            </h2>
            
            <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
              {t('welcomeMessage')}
            </p>
            
            {/* Boutons d'action */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-8">
              <button className="flex items-center bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-full font-semibold transition-all duration-200 text-lg shadow-lg hover:scale-105">
                <Play className="w-5 h-5 mr-2" />
                {t('startLearning')}
              </button>
              
              <button className="flex items-center bg-white/20 hover:bg-white/30 text-white px-8 py-4 rounded-full font-semibold transition-all duration-200 text-lg border border-white/30">
                <BookOpen className="w-5 h-5 mr-2" />
                {t('viewPlans')}
              </button>
            </div>
            
            <div className="flex items-center justify-center text-white/80 text-lg">
              <Users className="w-5 h-5 mr-2" />
              {t('familiesCount')}
            </div>
          </div>
        </main>

        {/* Fonctionnalités */}
        <section className="mb-16">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 text-center border border-white/20">
              <div className="w-16 h-16 bg-blue-500/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Target className="w-8 h-8 text-blue-200" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">Apprentissage Adaptatif</h3>
              <p className="text-white/80">S'adapte au niveau de chaque enfant pour un apprentissage optimal</p>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 text-center border border-white/20">
              <div className="w-16 h-16 bg-purple-500/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Globe className="w-8 h-8 text-purple-200" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">Support Multilingue</h3>
              <p className="text-white/80">{totalLanguages} langues supportées avec interface RTL</p>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 text-center border border-white/20">
              <div className="w-16 h-16 bg-green-500/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Sparkles className="w-8 h-8 text-green-200" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">Gamification</h3>
              <p className="text-white/80">Récompenses, badges et défis pour motiver l'apprentissage</p>
            </div>
          </div>
        </section>

        {/* Stats linguistiques */}
        <section className="mb-16">
          <div className="bg-white/5 backdrop-blur-sm rounded-3xl p-8 max-w-4xl mx-auto border border-white/10">
            <h3 className="text-2xl font-bold text-white mb-6 text-center">Couverture Linguistique Mondiale</h3>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              <div className="text-center">
                <div className="text-3xl font-bold text-white">13</div>
                <div className="text-white/70">Langues Européennes</div>
                <div className="text-white/50 text-sm">🇪🇺 Europe</div>
              </div>
              
              <div className="text-center">
                <div className="text-3xl font-bold text-white">6</div>
                <div className="text-white/70">Langues Asiatiques</div>
                <div className="text-white/50 text-sm">🌏 Asie</div>
              </div>
              
              <div className="text-center">
                <div className="text-3xl font-bold text-white">{rtlLanguages.length}</div>
                <div className="text-white/70">Langues RTL</div>
                <div className="text-white/50 text-sm">🕌 Moyen-Orient</div>
              </div>
              
              <div className="text-center">
                <div className="text-3xl font-bold text-white">{totalLanguages}</div>
                <div className="text-white/70">Total Langues</div>
                <div className="text-white/50 text-sm">🌍 Mondial</div>
              </div>
            </div>
          </div>
        </section>

        {/* Info sur la langue actuelle */}
        <section className="text-center">
          <div className="inline-flex items-center space-x-4 bg-white/10 backdrop-blur-sm rounded-full px-6 py-3 border border-white/20">
            <span className="text-3xl">{currentLanguage.flag}</span>
            <div className="text-left">
              <div className="text-white font-medium">
                Langue: {currentLanguage.name}
              </div>
              <div className="text-white/70 text-sm">
                Code: {currentLanguage.code.toUpperCase()} 
                {currentLanguage.region && ` • ${currentLanguage.region}`}
              </div>
            </div>
            {isRTL && (
              <span className="text-xs bg-blue-500 text-white px-3 py-1 rounded-full font-medium">
                RTL
              </span>
            )}
          </div>
        </section>

        {/* Footer avec debug info */}
        <footer className="mt-16 text-center">
          <div className="bg-black/20 backdrop-blur-sm rounded-2xl p-6 max-w-2xl mx-auto border border-white/10">
            <div className="text-white/60 text-sm space-y-1">
              <p>🎯 Math4Child - Application éducative mondiale</p>
              <p>📱 Interface adaptative avec support RTL complet</p>
              <p>🌍 Langue détectée: {currentLanguage.code} | Direction: {isRTL ? 'RTL' : 'LTR'}</p>
              <p>✨ Version enrichie avec {totalLanguages} langues supportées</p>
            </div>
          </div>
        </footer>
      </div>
    </div>
  )
}
