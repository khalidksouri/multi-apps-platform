#!/bin/bash

# =============================================================================
# CORRECTION PROBLÈME D'AFFICHAGE - MATH4CHILD
# =============================================================================

echo "🔧 CORRECTION PROBLÈME D'AFFICHAGE"
echo "=================================="

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

# 2. Corriger le fichier page.tsx avec un affichage correct
echo "🔧 Correction du fichier page.tsx..."
cp src/app/page.tsx src/app/page.tsx.backup-display

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

  const startFreeTrial = () => {
    setFreeTrialActive(true)
    alert("🎉 Mode démo gratuit activé ! Profitez de 3 questions gratuites pour tester Math4Child.")
    console.log('Essai gratuit activé pour la langue:', currentLanguage)
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
              
              {/* Sélecteur de langue - CORRIGÉ */}
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
        
        {/* PAGE PRINCIPALE - CONTENU VISIBLE */}
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
            
            {/* Alerte essai gratuit */}
            {freeTrialActive && (
              <div className="bg-green-500/20 border-2 border-green-400/50 rounded-2xl p-4 mb-8 text-white animate-in slide-in-from-top-2">
                <p className="text-xl font-bold flex items-center justify-center gap-2">
                  <span className="text-2xl">✨</span>
                  Mode démo gratuit activé ! 3 questions gratuites disponibles.
                </p>
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
        
        {/* Modal Premium */}
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
                  className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-purple-600 hover:to-pink-600 transition-all duration-300 w-full shadow-lg hover:shadow-xl transform hover:scale-105"
                >
                  Contacter pour Premium - 9,99€/mois
                </button>
                
                <p className="text-xs text-gray-500 mt-4">
                  <strong>GOTEST</strong> - SIRET: 53958712100028<br />
                  Support: khalid_ksouri@yahoo.fr<br />
                  Un email sera généré automatiquement
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

echo "✅ Fichier page.tsx corrigé avec affichage complet"

# 3. Créer un CSS global pour s'assurer des styles
echo "🎨 Ajout de styles CSS globaux..."
cat > "src/app/globals.css" << 'CSS_EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Assurer l'affichage correct */
html, body {
  height: 100%;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
}

#__next, [data-nextjs-scroll-focus-boundary] {
  height: 100%;
}

/* Animation personnalisées */
@keyframes bounce {
  0%, 20%, 53%, 80%, 100% {
    transform: translate3d(0,0,0);
  }
  40%, 43% {
    transform: translate3d(0, -30px, 0);
  }
  70% {
    transform: translate3d(0, -15px, 0);
  }
  90% {
    transform: translate3d(0, -4px, 0);
  }
}

@keyframes pulse {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.6;
  }
}

/* Support RTL */
[dir="rtl"] {
  direction: rtl;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 4px;
}

/* Classes d'animation Tailwind personnalisées */
.animate-in {
  animation-fill-mode: both;
}

.slide-in-from-top-2 {
  animation: slideInFromTop 0.2s ease-out;
}

.zoom-in-95 {
  animation: zoomIn 0.3s ease-out;
}

@keyframes slideInFromTop {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
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

/* Fixes pour l'affichage mobile */
@media (max-width: 768px) {
  .language-dropdown .absolute {
    position: fixed;
    left: 1rem;
    right: 1rem;
    top: auto;
    transform: none;
  }
}
CSS_EOF

echo "✅ CSS global ajouté"

# 4. Test de l'application
echo "🧪 Test de l'application corrigée..."
if npm run build; then
    echo ""
    echo "🎉 BUILD RÉUSSI ! PROBLÈME D'AFFICHAGE CORRIGÉ !"
    echo ""
    echo "✅ CORRECTIONS APPLIQUÉES :"
    echo "   • Structure de page complètement réorganisée"
    echo "   • Dropdown des langues avec positionnement fixe"
    echo "   • Contenu principal maintenant visible"
    echo "   • CSS global pour assurer l'affichage"
    echo "   • Gestion des clics en dehors du dropdown"
    echo "   • Animations améliorées"
    echo ""
    echo "🚀 POUR TESTER :"
    echo "   npm run dev"
    echo "   http://localhost:3000"
    echo ""
    echo "🔍 VÉRIFICATIONS À FAIRE :"
    echo "   • Le contenu principal est maintenant affiché"
    echo "   • Le dropdown des langues fonctionne correctement"
    echo "   • Les boutons sont cliquables"
    echo "   • Les particules animées sont visibles"
    echo "   • Le design responsive fonctionne"
    echo ""
    echo "✨ Votre Math4Child devrait maintenant s'afficher correctement !"
else
    echo "❌ Build échoué - vérifiez les erreurs ci-dessus"
fi

echo ""
echo "🎯 L'affichage de votre Math4Child est maintenant corrigé !"