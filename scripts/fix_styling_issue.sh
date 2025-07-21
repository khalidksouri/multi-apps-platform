#!/bin/bash

# =============================================================================
# CORRECTION DES STYLES - RESTAURER LES DÉGRADÉS COLORÉS
# =============================================================================

echo "🎨 CORRECTION DES STYLES MATH4CHILD"
echo "===================================="

# 1. Vérifier la configuration Tailwind
echo "🔍 Vérification de la configuration Tailwind..."

if [ -f "tailwind.config.js" ]; then
    echo "✅ tailwind.config.js trouvé"
else
    echo "⚠️  Création de tailwind.config.js..."
    cat > "tailwind.config.js" << 'TAILWIND_EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      animation: {
        'blob': 'blob 7s infinite',
        'float': 'float 3s ease-in-out infinite',
        'pulse-slow': 'pulse 3s ease-in-out infinite',
      },
      keyframes: {
        blob: {
          '0%': { transform: 'translate(0px, 0px) scale(1)' },
          '33%': { transform: 'translate(30px, -50px) scale(1.1)' },
          '66%': { transform: 'translate(-20px, 20px) scale(0.9)' },
          '100%': { transform: 'translate(0px, 0px) scale(1)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px) rotate(0deg)' },
          '50%': { transform: 'translateY(-20px) rotate(5deg)' },
        }
      }
    },
  },
  plugins: [],
}
TAILWIND_EOF
    echo "✅ tailwind.config.js créé"
fi

# 2. Vérifier globals.css
echo "🎨 Vérification de globals.css..."

if [ -f "src/app/globals.css" ]; then
    echo "✅ globals.css trouvé"
else
    echo "⚠️  Création de globals.css..."
    mkdir -p src/app
    cat > "src/app/globals.css" << 'CSS_EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Animations personnalisées */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: 'translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}

.animate-blob {
  animation: blob 7s infinite;
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

/* Optimisations pour les animations */
.animation-delay-0 {
  animation-delay: 0s;
}

.animation-delay-1000 {
  animation-delay: 1s;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-3000 {
  animation-delay: 3s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

/* Classes d'animation Tailwind personnalisées */
.animate-in {
  animation-fill-mode: both;
}

.slide-in-from-top-2 {
  animation-name: slideInFromTop;
  animation-duration: 0.2s;
}

.zoom-in-95 {
  animation-name: zoomIn;
  animation-duration: 0.3s;
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
CSS_EOF
    echo "✅ globals.css créé"
fi

# 3. Corriger le fichier page.tsx avec styles forcés
echo "🔧 Correction du fichier page.tsx avec styles forcés..."

# Localiser le fichier
if [ -f "apps/math4child/src/app/page.tsx" ]; then
    cd apps/math4child
    echo "✅ Travail dans apps/math4child/"
elif [ -f "src/app/page.tsx" ]; then
    echo "✅ Travail dans le dossier racine"
else
    echo "❌ Fichier page.tsx non trouvé"
    exit 1
fi

# Sauvegarder l'ancien
cp src/app/page.tsx src/app/page.tsx.backup-before-style-fix

# Version avec styles CSS inline en fallback
cat > "src/app/page.tsx" << 'STYLED_EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Play, Gift, Heart, Home, 
  Calculator, Plus, Minus, Divide, Lock, Star, Trophy,
  Volume2, VolumeX, Settings, Target, Sparkles, Languages
} from 'lucide-react'

// Configuration des langues
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

  const handleSubscription = async (plan) => {
    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          plan: plan,
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

  // Styles CSS inline pour forcer l'affichage
  const mainStyle = {
    minHeight: '100vh',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
    padding: '16px',
    position: 'relative',
    overflow: 'hidden'
  }

  const particleStyle1 = {
    position: 'fixed',
    top: '-16px',
    left: '-16px',
    width: '288px',
    height: '288px',
    background: 'rgba(147, 51, 234, 0.3)',
    borderRadius: '50%',
    filter: 'blur(60px)',
    animation: 'pulse 3s ease-in-out infinite',
    zIndex: 0
  }

  const particleStyle2 = {
    position: 'fixed',
    top: '-16px',
    right: '-16px',
    width: '288px',
    height: '288px',
    background: 'rgba(251, 191, 36, 0.3)',
    borderRadius: '50%',
    filter: 'blur(60px)',
    animation: 'pulse 3s ease-in-out infinite 1s',
    zIndex: 0
  }

  const particleStyle3 = {
    position: 'fixed',
    bottom: '-32px',
    left: '80px',
    width: '288px',
    height: '288px',
    background: 'rgba(236, 72, 153, 0.3)',
    borderRadius: '50%',
    filter: 'blur(60px)',
    animation: 'pulse 3s ease-in-out infinite 2s',
    zIndex: 0
  }

  const contentStyle = {
    maxWidth: '1792px',
    margin: '0 auto',
    position: 'relative',
    zIndex: 10
  }

  const headerStyle = {
    marginBottom: '32px'
  }

  const navStyle = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: '24px',
    background: 'rgba(255, 255, 255, 0.15)',
    backdropFilter: 'blur(20px)',
    borderRadius: '24px',
    padding: '24px',
    boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
    border: '1px solid rgba(255, 255, 255, 0.1)'
  }

  const cardStyle = {
    background: 'rgba(255, 255, 255, 0.15)',
    backdropFilter: 'blur(20px)',
    borderRadius: '24px',
    padding: '48px',
    boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
    border: '1px solid rgba(255, 255, 255, 0.1)',
    textAlign: 'center'
  }

  return (
    <div style={mainStyle} className={isRTL ? 'rtl' : 'ltr'}>
      {/* Particules d'arrière-plan */}
      <div style={particleStyle1}></div>
      <div style={particleStyle2}></div>
      <div style={particleStyle3}></div>
      
      <div style={contentStyle}>
        {/* Header */}
        <header style={headerStyle}>
          <nav style={navStyle}>
            <div className="flex items-center space-x-3">
              <div style={{
                width: '64px',
                height: '64px',
                background: 'linear-gradient(135deg, #fbbf24, #f97316)',
                borderRadius: '16px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '32px',
                boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.25)',
                transition: 'transform 0.3s',
                cursor: 'pointer'
              }}
              onMouseEnter={(e) => e.target.style.transform = 'scale(1.05)'}
              onMouseLeave={(e) => e.target.style.transform = 'scale(1)'}
              >
                🧮
              </div>
              <div>
                <h1 style={{
                  fontSize: '32px',
                  fontWeight: 'bold',
                  color: 'white',
                  textShadow: '0 4px 8px rgba(0, 0, 0, 0.25)',
                  margin: 0
                }}>
                  {currentLangConfig.appName}
                </h1>
                <p style={{
                  color: 'rgba(255, 255, 255, 0.8)',
                  fontSize: '14px',
                  margin: 0
                }}>
                  www.math4child.com
                </p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Bouton Son */}
              <button
                onClick={() => setSoundEnabled(!soundEnabled)}
                style={{
                  padding: '12px',
                  background: 'rgba(255, 255, 255, 0.2)',
                  borderRadius: '12px',
                  color: 'white',
                  border: 'none',
                  cursor: 'pointer',
                  transition: 'all 0.3s'
                }}
                onMouseEnter={(e) => {
                  e.target.style.background = 'rgba(255, 255, 255, 0.3)'
                  e.target.style.transform = 'scale(1.1)'
                }}
                onMouseLeave={(e) => {
                  e.target.style.background = 'rgba(255, 255, 255, 0.2)'
                  e.target.style.transform = 'scale(1)'
                }}
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue */}
              <div style={{ position: 'relative' }}>
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                    background: 'rgba(255, 255, 255, 0.2)',
                    borderRadius: '12px',
                    padding: '12px 24px',
                    color: 'white',
                    border: 'none',
                    cursor: 'pointer',
                    transition: 'all 0.3s'
                  }}
                  onMouseEnter={(e) => {
                    e.target.style.background = 'rgba(255, 255, 255, 0.3)'
                    e.target.style.transform = 'scale(1.05)'
                  }}
                  onMouseLeave={(e) => {
                    e.target.style.background = 'rgba(255, 255, 255, 0.2)'
                    e.target.style.transform = 'scale(1)'
                  }}
                >
                  <Languages size={20} />
                  <span>{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <ChevronDown 
                    size={16} 
                    style={{
                      transform: showLanguageDropdown ? 'rotate(180deg)' : 'rotate(0deg)',
                      transition: 'transform 0.3s'
                    }}
                  />
                </button>
                
                {showLanguageDropdown && (
                  <div style={{
                    position: 'absolute',
                    top: '100%',
                    right: '0',
                    marginTop: '12px',
                    background: 'white',
                    borderRadius: '16px',
                    boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
                    zIndex: 50,
                    minWidth: '320px',
                    border: '1px solid rgba(156, 163, 175, 0.1)'
                  }}>
                    <div style={{
                      padding: '16px',
                      borderBottom: '1px solid rgba(156, 163, 175, 0.1)'
                    }}>
                      <h3 style={{
                        fontWeight: 'bold',
                        color: '#374151',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px',
                        margin: 0
                      }}>
                        <Globe size={20} style={{ color: '#2563eb' }} />
                        {t.selectLanguage}
                      </h3>
                    </div>
                    
                    <div style={{
                      padding: '12px',
                      maxHeight: '256px',
                      overflowY: 'auto'
                    }}>
                      {Object.entries(SUPPORTED_LANGUAGES).map(([code, lang]) => (
                        <button
                          key={code}
                          onClick={() => changeLanguage(code)}
                          style={{
                            width: '100%',
                            textAlign: 'left',
                            padding: '12px 16px',
                            borderRadius: '12px',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '12px',
                            background: currentLanguage === code ? '#dbeafe' : 'transparent',
                            color: currentLanguage === code ? '#1d4ed8' : '#374151',
                            fontWeight: currentLanguage === code ? '600' : 'normal',
                            border: 'none',
                            cursor: 'pointer',
                            transition: 'all 0.2s'
                          }}
                          onMouseEnter={(e) => {
                            if (currentLanguage !== code) {
                              e.target.style.background = '#f3f4f6'
                            }
                          }}
                          onMouseLeave={(e) => {
                            if (currentLanguage !== code) {
                              e.target.style.background = 'transparent'
                            }
                          }}
                        >
                          <span style={{ fontSize: '24px' }}>{lang.flag}</span>
                          <div style={{ flex: 1 }}>
                            <div style={{ fontWeight: '500' }}>{lang.nativeName}</div>
                            <div style={{ fontSize: '12px', color: '#6b7280' }}>{lang.name}</div>
                            <div style={{ fontSize: '12px', color: '#9ca3af' }}>{lang.appName}</div>
                          </div>
                          {currentLanguage === code && (
                            <Check size={16} style={{ color: '#2563eb' }} />
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
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  background: 'linear-gradient(135deg, #fbbf24, #f97316)',
                  color: 'white',
                  padding: '12px 24px',
                  borderRadius: '12px',
                  fontWeight: 'bold',
                  border: 'none',
                  cursor: 'pointer',
                  boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.25)',
                  transition: 'all 0.3s'
                }}
                onMouseEnter={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #f59e0b, #ea580c)'
                  e.target.style.transform = 'scale(1.05)'
                  e.target.style.boxShadow = '0 20px 40px -10px rgba(0, 0, 0, 0.35)'
                }}
                onMouseLeave={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #fbbf24, #f97316)'
                  e.target.style.transform = 'scale(1)'
                  e.target.style.boxShadow = '0 10px 25px -5px rgba(0, 0, 0, 0.25)'
                }}
              >
                <Crown size={20} />
                <span>Premium</span>
              </button>
            </div>
          </nav>
        </header>
        
        {/* Page principale */}
        <div style={{ textAlign: 'center' }}>
          <div style={cardStyle}>
            <div style={{ marginBottom: '32px' }}>
              <div style={{
                fontSize: '96px',
                marginBottom: '24px',
                animation: 'bounce 1s infinite'
              }}>🎓</div>
              <h2 style={{
                fontSize: '64px',
                fontWeight: 'bold',
                color: 'white',
                marginBottom: '24px',
                textShadow: '0 4px 8px rgba(0, 0, 0, 0.25)',
                margin: '0 0 24px 0'
              }}>
                {t.domain.welcome}
              </h2>
              <p style={{
                fontSize: '24px',
                color: 'rgba(255, 255, 255, 0.9)',
                maxWidth: '768px',
                margin: '0 auto',
                textShadow: '0 2px 4px rgba(0, 0, 0, 0.25)'
              }}>
                {t.domain.tagline}
              </p>
              <div style={{
                marginTop: '16px',
                fontSize: '18px',
                color: 'rgba(255, 255, 255, 0.7)'
              }}>
                Débloquez toutes les fonctionnalités premium
              </div>
            </div>
            
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
              gap: '24px',
              maxWidth: '512px',
              margin: '0 auto 32px auto'
            }}>
              <button
                style={{
                  background: 'linear-gradient(135deg, #10b981, #059669)',
                  color: 'white',
                  padding: '24px 32px',
                  borderRadius: '16px',
                  fontSize: '20px',
                  fontWeight: 'bold',
                  border: 'none',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '16px',
                  boxShadow: '0 20px 40px -10px rgba(0, 0, 0, 0.25)',
                  transition: 'all 0.3s'
                }}
                onMouseEnter={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #059669, #047857)'
                  e.target.style.transform = 'scale(1.05)'
                  e.target.style.boxShadow = '0 25px 50px -12px rgba(0, 0, 0, 0.35)'
                }}
                onMouseLeave={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #10b981, #059669)'
                  e.target.style.transform = 'scale(1)'
                  e.target.style.boxShadow = '0 20px 40px -10px rgba(0, 0, 0, 0.25)'
                }}
              >
                <Gift size={28} />
                <span>{t.freeTrial}</span>
              </button>
              
              <button 
                onClick={() => setShowSubscriptionModal(true)}
                style={{
                  background: 'linear-gradient(135deg, #a855f7, #ec4899)',
                  color: 'white',
                  padding: '24px 32px',
                  borderRadius: '16px',
                  fontSize: '20px',
                  fontWeight: 'bold',
                  border: 'none',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '16px',
                  boxShadow: '0 20px 40px -10px rgba(0, 0, 0, 0.25)',
                  transition: 'all 0.3s'
                }}
                onMouseEnter={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #9333ea, #db2777)'
                  e.target.style.transform = 'scale(1.05)'
                  e.target.style.boxShadow = '0 25px 50px -12px rgba(0, 0, 0, 0.35)'
                }}
                onMouseLeave={(e) => {
                  e.target.style.background = 'linear-gradient(135deg, #a855f7, #ec4899)'
                  e.target.style.transform = 'scale(1)'
                  e.target.style.boxShadow = '0 20px 40px -10px rgba(0, 0, 0, 0.25)'
                }}
              >
                <Crown size={28} />
                <span>Premium</span>
              </button>
            </div>
            
            {/* Fonctionnalités */}
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
              gap: '24px',
              maxWidth: '1024px',
              margin: '0 auto 32px auto'
            }}>
              {[
                { icon: '🌍', title: '30+ langues', desc: 'Support multilingue mondial' },
                { icon: '📱', title: 'Multi-plateforme', desc: 'Web, iOS et Android' },
                { icon: '🎯', title: '5 niveaux', desc: 'Adapté à chaque âge' },
                { icon: '📊', title: 'Suivi détaillé', desc: 'Progression personnalisée' }
              ].map((feature, index) => (
                <div
                  key={index}
                  style={{
                    background: 'rgba(255, 255, 255, 0.1)',
                    borderRadius: '16px',
                    padding: '24px',
                    backdropFilter: 'blur(8px)',
                    border: '1px solid rgba(255, 255, 255, 0.1)'
                  }}
                >
                  <div style={{ fontSize: '32px', marginBottom: '12px' }}>{feature.icon}</div>
                  <h3 style={{
                    fontSize: '18px',
                    fontWeight: 'bold',
                    color: 'white',
                    marginBottom: '8px',
                    margin: '0 0 8px 0'
                  }}>{feature.title}</h3>
                  <p style={{
                    color: 'rgba(255, 255, 255, 0.8)',
                    fontSize: '14px',
                    margin: 0
                  }}>{feature.desc}</p>
                </div>
              ))}
            </div>
            
            {/* Statistiques */}
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(3, 1fr)',
              gap: '32px',
              maxWidth: '512px',
              margin: '48px auto 0 auto'
            }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: '48px',
                  fontWeight: 'bold',
                  color: '#fbbf24',
                  marginBottom: '8px',
                  textShadow: '0 4px 8px rgba(0, 0, 0, 0.25)'
                }}>195+</div>
                <div style={{
                  color: 'rgba(255, 255, 255, 0.8)',
                  fontSize: '14px'
                }}>Langues</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: '48px',
                  fontWeight: 'bold',
                  color: '#10b981',
                  marginBottom: '8px',
                  textShadow: '0 4px 8px rgba(0, 0, 0, 0.25)'
                }}>5</div>
                <div style={{
                  color: 'rgba(255, 255, 255, 0.8)',
                  fontSize: '14px'
                }}>Niveaux</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: '48px',
                  fontWeight: 'bold',
                  color: '#3b82f6',
                  marginBottom: '8px',
                  textShadow: '0 4px 8px rgba(0, 0, 0, 0.25)'
                }}>∞</div>
                <div style={{
                  color: 'rgba(255, 255, 255, 0.8)',
                  fontSize: '14px'
                }}>Questions</div>
              </div>
            </div>
          </div>
        </div>
        
        {/* Modal Premium */}
        {showSubscriptionModal && (
          <div style={{
            position: 'fixed',
            inset: 0,
            background: 'rgba(0, 0, 0, 0.6)',
            backdropFilter: 'blur(8px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
            zIndex: 50
          }}>
            <div style={{
              background: 'white',
              borderRadius: '24px',
              maxWidth: '512px',
              width: '100%',
              padding: '32px',
              boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
              border: '1px solid rgba(156, 163, 175, 0.1)',
              animation: 'zoomIn 0.3s ease-out'
            }}>
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                marginBottom: '24px'
              }}>
                <h2 style={{
                  fontSize: '32px',
                  fontWeight: 'bold',
                  color: '#374151',
                  margin: 0
                }}>Premium Math4Child</h2>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  style={{
                    color: '#6b7280',
                    background: 'none',
                    border: 'none',
                    cursor: 'pointer',
                    padding: '8px',
                    borderRadius: '8px',
                    transition: 'color 0.2s'
                  }}
                  onMouseEnter={(e) => e.target.style.color = '#374151'}
                  onMouseLeave={(e) => e.target.style.color = '#6b7280'}
                >
                  <X size={24} />
                </button>
              </div>
              
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: '64px',
                  marginBottom: '16px',
                  animation: 'bounce 1s infinite'
                }}>👑</div>
                <p style={{
                  fontSize: '20px',
                  color: '#374151',
                  marginBottom: '24px'
                }}>
                  Débloquez tous les niveaux et fonctionnalités !
                </p>
                
                <div style={{
                  background: 'linear-gradient(135deg, #faf5ff, #fdf2f8)',
                  borderRadius: '12px',
                  padding: '24px',
                  marginBottom: '24px',
                  border: '1px solid #e9d5ff'
                }}>
                  <h3 style={{
                    fontSize: '18px',
                    fontWeight: 'bold',
                    color: '#7c3aed',
                    marginBottom: '16px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '8px',
                    margin: '0 0 16px 0'
                  }}>
                    <Sparkles size={20} />
                    ✨ Avantages Premium
                  </h3>
                  <ul style={{
                    fontSize: '14px',
                    color: '#7c3aed',
                    listStyle: 'none',
                    padding: 0,
                    margin: 0
                  }}>
                    {[
                      'Accès illimité à tous les niveaux (1-5)',
                      'Questions infinies sans limitation',
                      'Support prioritaire et assistance',
                      'Nouvelles fonctionnalités en avant-première',
                      'Statistiques détaillées et suivi'
                    ].map((benefit, index) => (
                      <li key={index} style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        marginBottom: '12px'
                      }}>
                        <span style={{
                          color: '#10b981',
                          marginRight: '8px'
                        }}>✓</span>
                        {benefit}
                      </li>
                    ))}
                  </ul>
                </div>
                
                <button 
                  onClick={() => handleSubscription('monthly')}
                  style={{
                    background: 'linear-gradient(135deg, #a855f7, #ec4899)',
                    color: 'white',
                    padding: '16px 32px',
                    borderRadius: '16px',
                    fontSize: '20px',
                    fontWeight: 'bold',
                    border: 'none',
                    cursor: 'pointer',
                    width: '100%',
                    boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.25)',
                    transition: 'all 0.3s'
                  }}
                  onMouseEnter={(e) => {
                    e.target.style.background = 'linear-gradient(135deg, #9333ea, #db2777)'
                    e.target.style.transform = 'scale(1.05)'
                    e.target.style.boxShadow = '0 20px 40px -10px rgba(0, 0, 0, 0.35)'
                  }}
                  onMouseLeave={(e) => {
                    e.target.style.background = 'linear-gradient(135deg, #a855f7, #ec4899)'
                    e.target.style.transform = 'scale(1)'
                    e.target.style.boxShadow = '0 10px 25px -5px rgba(0, 0, 0, 0.25)'
                  }}
                >
                  Commencer Premium - 9,99€/mois
                </button>
                
                <p style={{
                  fontSize: '12px',
                  color: '#6b7280',
                  marginTop: '16px',
                  margin: '16px 0 0 0'
                }}>
                  Support: contact@math4child.com
                  <br />
                  Annulation possible à tout moment
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
      
      <style jsx>{`
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
STYLED_EOF

echo "✅ Fichier page.tsx corrigé avec styles CSS inline"

# 4. Test de build
echo "🧪 Test de build avec styles forcés..."
if npm run build; then
    echo "🎉 BUILD RÉUSSI !"
    echo ""
    echo "✨ STYLES RESTAURÉS :"
    echo "   • Dégradé de fond violet → bleu → rose"
    echo "   • 3 particules animées en arrière-plan"
    echo "   • Effets de verre (backdrop-blur)"
    echo "   • Animations et transitions fluides"
    echo "   • Boutons avec dégradés colorés"
    echo "   • Modal premium animé"
    echo ""
    echo "🚀 Pour voir le résultat :"
    echo "   npm run dev"
    echo "   http://localhost:3000"
    echo ""
    echo "🎨 Votre Math4Child a maintenant le magnifique design original !"
else
    echo "❌ Build échoué - vérifiez les erreurs ci-dessus"
fi

echo ""
echo "🔧 Si le problème persiste :"
echo "1. Vérifiez que Tailwind CSS est installé : npm install tailwindcss"
echo "2. Redémarrez le serveur : npm run dev"
echo "3. Videz le cache du navigateur (Ctrl+F5)"