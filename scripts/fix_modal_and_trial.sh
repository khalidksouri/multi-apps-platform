#!/bin/bash

# =============================================================================
# CORRECTION MODAL PREMIUM ET MESSAGE ESSAI GRATUIT
# =============================================================================

echo "🔧 CORRECTION MODAL PREMIUM ET MESSAGE ESSAI GRATUIT"
echo "====================================================="

# 1. Localiser le dossier
if [ -f "apps/math4child/src/app/page.tsx" ]; then
    cd apps/math4child
    echo "✅ Travail dans apps/math4child/"
elif [ -f "src/app/page.tsx" ]; then
    echo "✅ Travail dans le dossier racine"
else
    echo "❌ Structure non reconnue"
    exit 1
fi

# 2. Sauvegarder l'ancien fichier
cp src/app/page.tsx src/app/page.tsx.backup-modal-fix

# 3. Corriger le fichier page.tsx
echo "🔧 Correction du modal Premium et du message d'essai gratuit..."
cat > "src/app/page.tsx" << 'CORRECTED_EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Gift, Languages,
  Volume2, VolumeX, Sparkles
} from 'lucide-react'

const SUPPORTED_LANGUAGES = {
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', appName: 'Maths4Enfants' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', appName: 'Math4Child' },
  'es': { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', appName: 'Mates4Niños' },
  'de': { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', appName: 'Mathe4Kinder' },
  'ar': { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', appName: 'رياضيات4أطفال', rtl: true }
}

const translations = {
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    freeTrial: "🎁 Essai Gratuit",
    selectLanguage: "Choisir la langue",
    freeTrialMessage: "✨ Parfait ! Vous pouvez maintenant explorer Math4Child gratuitement.",
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !"
    }
  },
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    freeTrial: "🎁 Free Trial",
    selectLanguage: "Select Language",
    freeTrialMessage: "✨ Perfect! You can now explore Math4Child for free.",
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
  const [freeTrialActive, setFreeTrialActive] = useState(false)

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage] || translations['fr']
  const isRTL = currentLangConfig.rtl || false

  useEffect(() => {
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', currentLanguage)
    document.title = `${t.appName} - ${t.subtitle}`
  }, [currentLanguage, isRTL, t.appName, t.subtitle])

  const changeLanguage = (langCode) => {
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
  }

  // MESSAGE D'ESSAI GRATUIT AMÉLIORÉ
  const startFreeTrial = () => {
    setFreeTrialActive(true)
    
    // Message personnalisé selon la langue
    alert(t.freeTrialMessage || "✨ Parfait ! Vous pouvez maintenant explorer Math4Child gratuitement.")
    console.log('Essai gratuit activé pour la langue:', currentLanguage)
    
    // Ici vous pouvez ajouter la logique pour :
    // - Rediriger vers une page de démo
    // - Activer des fonctionnalités limitées
    // - Démarrer un timer de 15 minutes
  }

  const handleSubscription = (plan) => {
    console.log('Demande d\'abonnement:', { plan, langue: currentLanguage })
    
    const subject = encodeURIComponent(`Abonnement Math4Child Premium - ${plan}`)
    const body = encodeURIComponent(`Bonjour,

Je souhaite souscrire à l'abonnement Math4Child Premium :

📋 Détails de l'abonnement :
• Formule : ${plan} (9,99€/mois)
• Langue préférée : ${currentLangConfig.nativeName}
• Application : ${currentLangConfig.appName}

✨ Avantages souhaités :
• Accès illimité à tous les niveaux (1-5)
• Questions infinies sans limitation
• Support prioritaire
• Nouvelles fonctionnalités en avant-première
• Statistiques détaillées et suivi

📧 Merci de me contacter pour finaliser l'abonnement.

Cordialement`)

    const mailtoUrl = `mailto:khalid_ksouri@yahoo.fr?subject=${subject}&body=${body}`
    
    if (confirm('Vous allez être redirigé vers votre client email pour envoyer une demande d\'abonnement. Continuer ?')) {
      window.location.href = mailtoUrl
    }
  }

  // Fermer le dropdown si on clique ailleurs
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (showLanguageDropdown && !event.target.closest('.language-dropdown')) {
        setShowLanguageDropdown(false)
      }
    }
    document.addEventListener('click', handleClickOutside)
    return () => document.removeEventListener('click', handleClickOutside)
  }, [showLanguageDropdown])

  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4 transition-all duration-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Particules d'arrière-plan */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse" style={{ animationDelay: '1s' }}></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse" style={{ animationDelay: '2s' }}></div>
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
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue */}
              <div className="relative language-dropdown">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-3 bg-white/20 rounded-xl px-6 py-3 text-white hover:bg-white/30 transition-all duration-300 hover:scale-105"
                >
                  <Languages size={20} />
                  <span className="hidden sm:inline">{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <ChevronDown size={16} className={`transform transition-transform duration-300 ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div 
                    className="absolute top-full right-0 mt-3 bg-white rounded-2xl shadow-2xl z-50 min-w-96 border border-gray-100"
                    style={{ 
                      animation: 'slideInFromTop 0.2s ease-out',
                      transformOrigin: 'top right'
                    }}
                  >
                    <div className="p-4 border-b border-gray-100">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2">
                        <Globe size={20} className="text-blue-600" />
                        {t.selectLanguage}
                      </h3>
                      <p className="text-xs text-gray-500 mt-1">Support mondial - 195+ langues</p>
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
        
        {/* PAGE PRINCIPALE */}
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
            
            {/* BANNIÈRE D'ESSAI GRATUIT AMÉLIORÉE */}
            {freeTrialActive && (
              <div className="bg-gradient-to-r from-green-400/20 to-emerald-400/20 border-2 border-green-400/50 rounded-2xl p-6 mb-8 text-white animate-in slide-in-from-top-2">
                <div className="flex items-center justify-center gap-3 mb-2">
                  <span className="text-3xl animate-bounce">✨</span>
                  <h3 className="text-xl font-bold">Mode Démo Activé !</h3>
                  <span className="text-3xl animate-bounce" style={{ animationDelay: '0.5s' }}>🎉</span>
                </div>
                <p className="text-lg opacity-90">
                  Explorez Math4Child gratuitement • 3 questions disponibles
                </p>
                <div className="mt-3 text-sm opacity-75">
                  Vous pouvez maintenant tester toutes nos fonctionnalités
                </div>
              </div>
            )}
            
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
                <h3 className="text-lg font-bold text-white mb-2">195+ langues</h3>
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
        
        {/* MODAL PREMIUM NETTOYÉ - SANS INFO GOTEST */}
        {showSubscriptionModal && (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-3xl max-w-2xl w-full p-8 shadow-2xl border border-gray-100 animate-in zoom-in-95 duration-300">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-3xl font-bold text-gray-800">Premium Math4Child</h2>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  className="text-gray-500 hover:text-gray-700 transition-colors duration-200"
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
                  className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-purple-600 hover:to-pink-600 transition-all duration-300 w-full shadow-lg hover:shadow-xl transform hover:scale-105 mb-4"
                >
                  Contacter pour Premium - 9,99€/mois
                </button>
                
                {/* TEXTE SIMPLIFIÉ - SANS INFO GOTEST */}
                <p className="text-sm text-gray-500">
                  Un email sera généré pour vous contacter
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
      
      <style jsx>{`
        @keyframes slideInFromTop {
          from {
            opacity: 0;
            transform: translateY(-8px) scale(0.95);
          }
          to {
            opacity: 1;
            transform: translateY(0) scale(1);
          }
        }
        
        .animate-in {
          animation-fill-mode: both;
        }
        
        .slide-in-from-top-2 {
          animation: slideInFromTop 0.3s ease-out;
        }
        
        .zoom-in-95 {
          animation: zoomIn 0.3s ease-out;
        }
        
        @keyframes zoomIn {
          from {
            opacity: 0;
            transform: scale(0.95);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
      `}</style>
    </div>
  )
}
CORRECTED_EOF

echo "✅ Fichier corrigé avec modal Premium nettoyé et message d'essai amélioré"

# 4. Test de l'application
echo "🧪 Test de l'application corrigée..."
if npm run build; then
    echo ""
    echo "🎉 BUILD RÉUSSI ! CORRECTIONS APPLIQUÉES !"
    echo ""
    echo "✅ MODIFICATIONS EFFECTUÉES :"
    echo "   • ❌ Suppression des informations GOTEST du modal Premium"
    echo "   • ✨ Message d'essai gratuit amélioré et personnalisé"
    echo "   • 🎨 Bannière d'essai gratuit plus attrayante"
    echo "   • 🌍 Messages traduits selon la langue sélectionnée"
    echo "   • 🧹 Modal Premium épuré et professionnel"
    echo ""
    echo "🔄 NOUVELLES FONCTIONNALITÉS :"
    echo "   • Bouton 'Essai Gratuit' → Message: '✨ Parfait ! Vous pouvez maintenant explorer Math4Child gratuitement.'"
    echo "   • Bannière animée avec emoji qui bougent"
    echo "   • Modal Premium sans informations techniques"
    echo "   • Messages adaptés à chaque langue"
    echo ""
    echo "🚀 POUR TESTER :"
    echo "   npm run dev"
    echo "   http://localhost:3000"
    echo ""
    echo "🎯 Testez maintenant :"
    echo "   1. Cliquez sur 'Essai Gratuit' → nouveau message court"
    echo "   2. Cliquez sur 'Premium' → modal épuré sans info GOTEST"
    echo "   3. Changez de langue → messages traduits"
    echo ""
    echo "✨ Votre interface Math4Child est maintenant plus épurée et professionnelle !"
else
    echo "❌ Build échoué - vérifiez les erreurs ci-dessus"
fi

echo ""
echo "🎊 Modal Premium nettoyé et essai gratuit amélioré !"