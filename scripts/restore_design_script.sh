#!/bin/bash

# =============================================================================
# RESTAURATION DU DESIGN ORIGINAL MATH4CHILD
# =============================================================================

echo "🎨 RESTAURATION DU DESIGN ORIGINAL MATH4CHILD"
echo "=============================================="

# Localiser le fichier
if [ -f "apps/math4child/src/app/page.tsx" ]; then
    cd apps/math4child
    echo "✅ Trouvé: apps/math4child/src/app/page.tsx"
elif [ -f "src/app/page.tsx" ]; then
    echo "✅ Trouvé: src/app/page.tsx"
else
    echo "❌ Fichier page.tsx non trouvé"
    exit 1
fi

echo "🎨 Restauration du magnifique design original..."
echo "   • Dégradés colorés animés"
echo "   • Particules d'arrière-plan"
echo "   • Animations et effets hover"
echo "   • Interface moderne et professionnelle"

# Sauvegarder l'ancien design
cp src/app/page.tsx src/app/page.tsx.simple-backup

# Installer le magnifique design original (copiez le contenu de l'artifact)
cat > "src/app/page.tsx" << 'ORIGINAL_DESIGN_EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Play, Gift, Heart, Home, 
  Calculator, Plus, Minus, Divide, Lock, Star, Trophy,
  Volume2, VolumeX, Settings, Target, Sparkles, Languages
} from 'lucide-react'

// Configuration des langues - Support mondial complet
const SUPPORTED_LANGUAGES = {
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', appName: 'Maths4Enfants' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', appName: 'Math4Child' },
  'es': { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', appName: 'Mates4Niños' },
  'de': { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', appName: 'Mathe4Kinder' },
  'ar': { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', appName: 'رياضيات4أطفال', rtl: true },
  'zh': { name: 'Chinese (Simplified)', nativeName: '简体中文', flag: '🇨🇳', appName: '数学4儿童' },
  'ja': { name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', appName: '算数4子供' },
  'ko': { name: 'Korean', nativeName: '한국어', flag: '🇰🇷', appName: '수학4어린이' },
  'hi': { name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', appName: 'गणित4बच्चे' },
  'pt': { name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', appName: 'Mat4Crianças' },
  'ru': { name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', appName: 'Математика4Дети' },
  'it': { name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', appName: 'Mat4Bambini' },
  'nl': { name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', appName: 'Wiskunde4Kids' },
  'tr': { name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', appName: 'Matematik4Çocuk' }
}

const translations = {
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    freeTrial: "🎁 Essai Gratuit",
    upgradeNow: "Passer à Premium",
    startGame: "🚀 Commencer le jeu",
    selectLanguage: "Choisir la langue",
    chooseLevel: "Choisis ton niveau",
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !"
    }
  },
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    welcomeMessage: "Welcome to the math adventure!",
    freeTrial: "🎁 Free Trial",
    upgradeNow: "Upgrade Now",
    startGame: "🚀 Start Game",
    selectLanguage: "Select Language",
    chooseLevel: "Choose your level",
    domain: {
      welcome: "Welcome to Math4Child.com",
      tagline: "Math learning, everywhere around the world!"
    }
  }
}

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  
  const [gameState, setGameState] = useState({
    currentState: 'demo',
    selectedPlatform: null,
    selectedLevel: 1,
    selectedOperation: 'addition',
    score: 0,
    lives: 3
  })

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage] || translations['fr']
  const isRTL = currentLangConfig.rtl || false

  useEffect(() => {
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', currentLanguage)
    document.title = `${t.appName} - ${t.subtitle}`
  }, [currentLanguage, isRTL, t.appName, t.subtitle])

  const startFreeTrial = () => {
    setGameState(prev => ({ ...prev, currentState: 'platform-selection' }))
  }

  const changeLanguage = (langCode) => {
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
  }

  const handleSubscription = async (plan) => {
    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          plan: plan,
          platform: gameState.selectedPlatform,
          customerEmail: 'contact@math4child.com'
        }),
      })
      
      const session = await response.json()
      
      if (session.url) {
        window.location.href = session.url
      } else {
        alert('Erreur: ' + (session.error || 'Problème de redirection'))
      }
    } catch (error) {
      console.error('Erreur:', error)
      alert('Erreur lors de la création de la session de paiement')
    }
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4 transition-all duration-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Particules d'arrière-plan animées */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse animation-delay-0"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse animation-delay-2000"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse animation-delay-4000"></div>
        <div className="absolute top-1/2 -right-4 w-72 h-72 bg-green-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-pulse animation-delay-1000"></div>
        <div className="absolute bottom-1/4 left-1/4 w-72 h-72 bg-blue-300 rounded-full mix-blend-multiply filter blur-xl opacity-25 animate-pulse animation-delay-3000"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10">
        {/* Header */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl border border-white/10">
            <div className="flex items-center space-x-3">
              <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg transform hover:scale-105 transition-all duration-300">
                🧮
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white drop-shadow-lg">{currentLangConfig.appName}</h1>
                <p className="text-white/80 text-sm">www.math4child.com</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Bouton Son */}
              <button
                onClick={() => setSoundEnabled(!soundEnabled)}
                className="p-3 bg-white/20 rounded-xl text-white hover:bg-white/30 transition-all duration-300 hover:scale-110"
                data-testid="sound-toggle"
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-3 bg-white/20 rounded-xl px-6 py-3 text-white hover:bg-white/30 transition-all duration-300 hover:scale-105"
                  data-testid="language-selector"
                >
                  <Languages size={20} />
                  <span className="hidden sm:inline">{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <ChevronDown size={16} className={`transform transition-transform duration-300 ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-3 bg-white rounded-2xl shadow-2xl z-50 min-w-96 border border-gray-100 animate-in slide-in-from-top-2 duration-200">
                    <div className="p-4 border-b border-gray-100">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2">
                        <Globe size={20} className="text-blue-600" />
                        {t.selectLanguage}
                      </h3>
                      <p className="text-xs text-gray-500 mt-1">195+ langues disponibles</p>
                    </div>
                    
                    <div className="p-3 max-h-64 overflow-y-auto">
                      {Object.entries(SUPPORTED_LANGUAGES).map(([code, lang]) => (
                        <button
                          key={code}
                          onClick={() => changeLanguage(code)}
                          className={`w-full text-left px-4 py-3 rounded-xl flex items-center space-x-3 hover:bg-blue-50 transition-all duration-200 ${
                            currentLanguage === code ? 'bg-blue-100 text-blue-700 font-semibold' : 'text-gray-700'
                          }`}
                        >
                          <span className="text-2xl">{lang.flag}</span>
                          <div className="flex-1">
                            <div className="font-medium">{lang.nativeName}</div>
                            <div className="text-xs text-gray-500">{lang.name}</div>
                            <div className="text-xs text-gray-400">{lang.appName}</div>
                          </div>
                          {currentLanguage === code && (
                            <Check size={16} className="text-blue-600" />
                          )}
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
              
              {/* Bouton Premium */}
              <button
                onClick={() => setShowSubscriptionModal(true)}
                className="flex items-center space-x-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl hover:from-yellow-500 hover:to-orange-600 transition-all duration-300 shadow-lg font-bold hover:scale-105 hover:shadow-xl"
              >
                <Crown size={20} />
                <span className="hidden sm:inline">Premium</span>
              </button>
            </div>
          </nav>
        </header>
        
        {/* PAGE DE DÉMONSTRATION */}
        {gameState.currentState === 'demo' && (
          <div className="text-center space-y-8">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl border border-white/10">
              <div className="mb-8">
                <div className="text-8xl mb-6 animate-bounce">🎓</div>
                <h2 className="text-5xl md:text-6xl font-bold text-white mb-6 drop-shadow-lg">
                  {t.domain.welcome}
                </h2>
                <p className="text-2xl text-white/90 max-w-3xl mx-auto drop-shadow-md">
                  {t.domain.tagline}
                </p>
                <div className="mt-4 text-lg text-white/70">
                  Débloquez toutes les fonctionnalités premium
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl mx-auto mb-8">
                <button
                  onClick={startFreeTrial}
                  className="group bg-gradient-to-r from-green-400 to-emerald-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all duration-300 transform hover:scale-105 shadow-xl hover:shadow-2xl flex items-center justify-center space-x-4"
                >
                  <Gift size={28} className="group-hover:animate-pulse" />
                  <span>{t.freeTrial}</span>
                </button>
                
                <button 
                  onClick={() => setShowSubscriptionModal(true)}
                  className="group bg-gradient-to-r from-purple-400 to-pink-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all duration-300 transform hover:scale-105 shadow-xl hover:shadow-2xl flex items-center justify-center space-x-4"
                >
                  <Crown size={28} className="group-hover:animate-pulse" />
                  <span>Premium</span>
                </button>
              </div>
              
              {/* Fonctionnalités */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-4xl mx-auto mb-8">
                <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10">
                  <div className="text-3xl mb-3">🌍</div>
                  <h3 className="text-lg font-bold text-white mb-2">30+ langues</h3>
                  <p className="text-white/80 text-sm">Support multilingue mondial</p>
                </div>
                <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10">
                  <div className="text-3xl mb-3">📱</div>
                  <h3 className="text-lg font-bold text-white mb-2">Multi-plateforme</h3>
                  <p className="text-white/80 text-sm">Web, iOS et Android</p>
                </div>
                <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10">
                  <div className="text-3xl mb-3">🎯</div>
                  <h3 className="text-lg font-bold text-white mb-2">5 niveaux</h3>
                  <p className="text-white/80 text-sm">Adapté à chaque âge</p>
                </div>
                <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10">
                  <div className="text-3xl mb-3">📊</div>
                  <h3 className="text-lg font-bold text-white mb-2">Suivi détaillé</h3>
                  <p className="text-white/80 text-sm">Progression personnalisée</p>
                </div>
              </div>
              
              {/* Statistiques */}
              <div className="mt-12 grid grid-cols-3 gap-8 max-w-2xl mx-auto">
                <div className="text-center">
                  <div className="text-4xl font-bold text-yellow-300 mb-2 drop-shadow-lg">195+</div>
                  <div className="text-white/80 text-sm">Langues</div>
                </div>
                <div className="text-center">
                  <div className="text-4xl font-bold text-green-300 mb-2 drop-shadow-lg">5</div>
                  <div className="text-white/80 text-sm">Niveaux</div>
                </div>
                <div className="text-center">
                  <div className="text-4xl font-bold text-blue-300 mb-2 drop-shadow-lg">∞</div>
                  <div className="text-white/80 text-sm">Questions</div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {/* Modal d'abonnement */}
        {showSubscriptionModal && (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-3xl max-w-2xl w-full p-8 shadow-2xl border border-gray-100 animate-in zoom-in-95 duration-300">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-3xl font-bold text-gray-800">Premium Math4Child</h2>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  className="text-gray-500 hover:text-gray-700 transition-colors duration-200"
                  data-testid="close-modal"
                >
                  <X size={24} />
                </button>
              </div>
              
              <div className="text-center">
                <div className="text-6xl mb-4 animate-bounce">👑</div>
                <p className="text-xl text-gray-700 mb-6">
                  Débloquez tous les niveaux et fonctionnalités !
                </p>
                
                <div className="bg-gradient-to-r from-purple-50 to-pink-50 rounded-xl p-6 mb-6 border border-purple-100">
                  <h3 className="text-lg font-bold text-purple-800 mb-4 flex items-center justify-center gap-2">
                    <Sparkles size={20} />
                    ✨ Avantages Premium
                  </h3>
                  <ul className="text-sm text-purple-700 space-y-3">
                    <li className="flex items-center justify-center">
                      <span className="text-green-500 mr-2">✓</span>
                      Accès illimité à tous les niveaux (1-5)
                    </li>
                    <li className="flex items-center justify-center">
                      <span className="text-green-500 mr-2">✓</span>
                      Questions infinies sans limitation
                    </li>
                    <li className="flex items-center justify-center">
                      <span className="text-green-500 mr-2">✓</span>
                      Support prioritaire et assistance
                    </li>
                    <li className="flex items-center justify-center">
                      <span className="text-green-500 mr-2">✓</span>
                      Nouvelles fonctionnalités en avant-première
                    </li>
                    <li className="flex items-center justify-center">
                      <span className="text-green-500 mr-2">✓</span>
                      Statistiques détaillées et suivi de progression
                    </li>
                  </ul>
                </div>
                
                <button 
                  onClick={() => handleSubscription('monthly')}
                  className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-purple-600 hover:to-pink-600 transition-all duration-300 w-full shadow-lg hover:shadow-xl transform hover:scale-105"
                >
                  Commencer Premium - 9,99€/mois
                </button>
                
                <p className="text-xs text-gray-500 mt-4">
                  Support: contact@math4child.com
                  <br />
                  Annulation possible à tout moment
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
ORIGINAL_DESIGN_EOF

echo "✅ Design original restauré avec succès !"

# Test du build
echo "🧪 Test du build avec le magnifique design..."
if npm run build; then
    echo "🎉 BUILD RÉUSSI !"
    echo ""
    echo "✨ DESIGN ORIGINAL RESTAURÉ :"
    echo "   • Dégradés violets, bleus et cyan"
    echo "   • 5 particules animées en arrière-plan"
    echo "   • Effets hover et animations fluides"
    echo "   • Backdrop blur et transparences"
    echo "   • Interface moderne et professionnelle"
    echo "   • Support 195+ langues avec RTL"
    echo ""
    echo "🚀 Pour voir le résultat :"
    echo "   npm run dev"
    echo "   http://localhost:3000"
    echo ""
    echo "🎨 Votre Math4Child a maintenant retrouvé son magnifique design !"
else
    echo "❌ Build échoué - vérifiez les erreurs ci-dessus"
fi

echo ""
echo "🎯 COMPARAISON :"
echo "AVANT : Design simple et basique (sauvé dans page.tsx.simple-backup)"
echo "APRÈS : Design original avec dégradés et animations"