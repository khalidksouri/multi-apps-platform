'use client'

import { useState, useEffect } from 'react'
import { Calculator, Globe, Star, TrendingUp, Users, Award } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'
import LanguageDropdown from '@/components/language/LanguageDropdown'
import MathGame from '@/components/math/MathGame'
import { optimalPayments } from '@/lib/optimal-payments'

export default function HomePage() {
  const [showGame, setShowGame] = useState(false)
  const languageContext = useLanguage()
  
  // Sécurité pour les contextes non définis
  const currentLanguage = languageContext?.currentLanguage || { 
    code: 'fr', 
    name: 'French', 
    nativeName: 'Français', 
    flag: '🇫🇷' 
  }
  const t = languageContext?.t || {}
  
  // Protection RTL
  const isRTL = currentLanguage.rtl || false
  
  useEffect(() => {
    // Test du système de paiements (non bloquant)
    const testPayment = async () => {
      try {
        const session = await optimalPayments.createCheckout({
          planId: 'math4child_premium',
          amount: 999,
          currency: 'EUR'
        })
        console.log('💰 Système de paiement initialisé:', session?.provider || 'default')
      } catch (error) {
        console.warn('💰 Paiement non configuré (normal en développement):', error)
      }
    }
    
    testPayment()
  }, [])

  const handleStartGame = () => {
    setShowGame(true)
  }

  const handleBackToHome = () => {
    setShowGame(false)
  }

  if (showGame) {
    return <MathGame onBack={handleBackToHome} />
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header avec navigation */}
      <header className="bg-white/10 backdrop-blur-md border-b border-white/20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <Calculator className="h-8 w-8 text-white" />
              <h1 className="text-2xl font-bold text-white" data-testid="app-title">
                Math4Child
              </h1>
            </div>
            
            <div className="flex items-center space-x-4">
              <LanguageDropdown className="w-48" />
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center">
          <h2 className="text-4xl md:text-6xl font-bold text-white mb-6">
            {(t as any)?.subtitle || "L'app éducative n°1 pour apprendre les maths en famille !"}
          </h2>
          
          <p className="text-xl text-white/90 mb-8 max-w-3xl mx-auto">
            {(t as any)?.description || "Plus de 100 000 familles nous font confiance"}
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
            <button
              onClick={handleStartGame}
              className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-lg font-semibold text-lg transition-colors duration-200 shadow-lg"
              data-testid="start-game-button"
            >
              {(t as any)?.startFree || "Commencer gratuitement"}
            </button>
            
            <div className="text-white/80">
              <span className="font-semibold">7</span>
              {(t as any)?.daysFree || " jours gratuits"}
            </div>
          </div>

          {/* Statistiques */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-16">
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Users className="h-12 w-12 text-white mx-auto mb-4" />
              <div className="text-3xl font-bold text-white">100K+</div>
              <div className="text-white/80">Familles</div>
            </div>
            
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Globe className="h-12 w-12 text-white mx-auto mb-4" />
              <div className="text-3xl font-bold text-white">195+</div>
              <div className="text-white/80">Langues</div>
            </div>
            
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Star className="h-12 w-12 text-white mx-auto mb-4" />
              <div className="text-3xl font-bold text-white">4.9</div>
              <div className="text-white/80">Note moyenne</div>
            </div>
            
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Award className="h-12 w-12 text-white mx-auto mb-4" />
              <div className="text-3xl font-bold text-white">N°1</div>
              <div className="text-white/80">App éducative</div>
            </div>
          </div>

          {/* Avantages */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <TrendingUp className="h-8 w-8 text-green-400 mb-4" />
              <h3 className="font-semibold text-white mb-2">
                {(t as any)?.competitivePrice || "Prix compétitif"}
              </h3>
              <p className="text-white/80 text-sm">
                {(t as any)?.competitivePriceDesc || "Le meilleur rapport qualité-prix"}
              </p>
              <div className="text-green-400 font-bold mt-2">
                {(t as any)?.competitivePriceStat || "50% moins cher"}
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Users className="h-8 w-8 text-blue-400 mb-4" />
              <h3 className="font-semibold text-white mb-2">
                {(t as any)?.familyManagement || "Gestion famille"}
              </h3>
              <p className="text-white/80 text-sm">
                {(t as any)?.familyManagementDesc || "Jusqu'à 5 profils enfants"}
              </p>
              <div className="text-blue-400 font-bold mt-2">
                {(t as any)?.familyManagementStat || "5 profils inclus"}
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Globe className="h-8 w-8 text-purple-400 mb-4" />
              <h3 className="font-semibold text-white mb-2">
                {(t as any)?.offlineMode || "Mode hors ligne"}
              </h3>
              <p className="text-white/80 text-sm">
                {(t as any)?.offlineModeDesc || "Continuez à apprendre sans internet"}
              </p>
              <div className="text-purple-400 font-bold mt-2">
                {(t as any)?.offlineModeStat || "100% fonctionnel"}
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <Star className="h-8 w-8 text-yellow-400 mb-4" />
              <h3 className="font-semibold text-white mb-2">
                {(t as any)?.analytics || "Analytiques avancées"}
              </h3>
              <p className="text-white/80 text-sm">
                {(t as any)?.analyticsDesc || "Suivez les progrès en détail"}
              </p>
              <div className="text-yellow-400 font-bold mt-2">
                {(t as any)?.analyticsStat || "Rapports complets"}
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
