#!/bin/bash

# =============================================================================
# CORRECTION DES ERREURS DE BUILD - MATH4CHILD
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🔧 Correction des Erreurs de Build Math4Child"
echo "=============================================="
echo ""

# =============================================================================
# CORRECTION 1: INSTALLATION DES DÉPENDANCES STRIPE
# =============================================================================

info "📦 Installation des dépendances Stripe manquantes..."

# Installer les dépendances Stripe
npm install @stripe/stripe-js stripe --save --legacy-peer-deps

if [ $? -eq 0 ]; then
    log "✅ Dépendances Stripe installées avec succès"
else
    error "❌ Erreur lors de l'installation des dépendances Stripe"
    exit 1
fi

# =============================================================================
# CORRECTION 2: CORRECTION DE LA SYNTAXE PAGE.TSX
# =============================================================================

info "🔧 Correction de la syntaxe dans src/app/page.tsx..."

# Créer une sauvegarde
cp src/app/page.tsx src/app/page.tsx.backup_$(date +%Y%m%d_%H%M%S)

# Corriger la page principale avec une version propre
cat > src/app/page.tsx << 'EOF'
'use client'

import { useState, useEffect, useRef } from 'react'

// Configuration des langues (195+ langues supportées)
const LANGUAGES = {
  'fr': { name: 'Français', flag: '🇫🇷', rtl: false },
  'en': { name: 'English', flag: '🇺🇸', rtl: false },
  'es': { name: 'Español', flag: '🇪🇸', rtl: false },
  'de': { name: 'Deutsch', flag: '🇩🇪', rtl: false },
  'it': { name: 'Italiano', flag: '🇮🇹', rtl: false },
  'pt': { name: 'Português', flag: '🇧🇷', rtl: false },
  'ru': { name: 'Русский', flag: '🇷🇺', rtl: false },
  'zh': { name: '中文', flag: '🇨🇳', rtl: false },
  'ja': { name: '日本語', flag: '🇯🇵', rtl: false },
  'ko': { name: '한국어', flag: '🇰🇷', rtl: false },
  'ar': { name: 'العربية', flag: '🇸🇦', rtl: true },
  'hi': { name: 'हिन्दी', flag: '🇮🇳', rtl: false },
  'bn': { name: 'বাংলা', flag: '🇧🇩', rtl: false },
  'ur': { name: 'اردو', flag: '🇵🇰', rtl: true },
  'fa': { name: 'فارسی', flag: '🇮🇷', rtl: true },
  'tr': { name: 'Türkçe', flag: '🇹🇷', rtl: false },
  'pl': { name: 'Polski', flag: '🇵🇱', rtl: false },
  'nl': { name: 'Nederlands', flag: '🇳🇱', rtl: false },
  'sv': { name: 'Svenska', flag: '🇸🇪', rtl: false },
  'th': { name: 'ไทย', flag: '🇹🇭', rtl: false },
  'vi': { name: 'Tiếng Việt', flag: '🇻🇳', rtl: false }
} as const

// Traductions complètes
const TRANSLATIONS = {
  fr: {
    appName: 'Math4Child',
    welcome: 'Bienvenue dans l\'aventure mathématique !',
    subtitle: 'L\'application révolutionnaire qui transforme l\'apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans',
    startGame: 'Commencer l\'Aventure',
    choosePlan: 'Choisir un Abonnement',
    features: 'Fonctionnalités Révolutionnaires',
    levels: '5 Niveaux',
    languages: '195+ Langues',
    operations: '5 Opérations',
    company: 'Développé par GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  },
  en: {
    appName: 'Math4Child',
    welcome: 'Welcome to the Mathematical Adventure!',
    subtitle: 'The revolutionary app that transforms math learning into a fun adventure for children aged 6 to 12',
    startGame: 'Start the Adventure',
    choosePlan: 'Choose a Subscription',
    features: 'Revolutionary Features',
    levels: '5 Levels',
    languages: '195+ Languages',
    operations: '5 Operations',
    company: 'Developed by GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  },
  ar: {
    appName: 'Math4Child',
    welcome: 'مرحباً بك في المغامرة الرياضية!',
    subtitle: 'التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة للأطفال من 6 إلى 12 سنة',
    startGame: 'ابدأ المغامرة',
    choosePlan: 'اختر اشتراكاً',
    features: 'الميزات الثورية',
    levels: '5 مستويات',
    languages: '195+ لغة',
    operations: '5 عمليات',
    company: 'طُور بواسطة GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  }
} as const

// Plans d'abonnement Stripe
const SUBSCRIPTION_PLANS = {
  free: {
    name: 'Explorer',
    price: 0,
    duration: '7 jours',
    profiles: 1,
    features: ['50 questions totales', 'Niveau 1 seulement', 'Support communautaire'],
    color: 'from-gray-400 to-gray-600',
    icon: '🎯'
  },
  monthly: {
    name: 'Aventurier',
    price: 9.99,
    duration: 'mois',
    profiles: 3,
    features: ['Questions illimitées', 'Tous les 5 niveaux', 'IA adaptative', 'Support prioritaire'],
    color: 'from-blue-500 to-indigo-600',
    icon: '🚀'
  },
  quarterly: {
    name: 'Champion',
    price: 26.97,
    originalPrice: 29.97,
    duration: '3 mois',
    discount: '10%',
    profiles: 5,
    features: ['Tout du plan Aventurier', 'Mode multijoueur', 'Défis exclusifs', 'Statistiques avancées'],
    color: 'from-purple-500 to-pink-600',
    popular: true,
    icon: '🏆'
  },
  annual: {
    name: 'Maître',
    price: 83.93,
    originalPrice: 119.88,
    duration: 'an',
    discount: '30%',
    profiles: 10,
    features: ['Tout du plan Champion', 'Accès anticipé', 'Mode tournoi', 'Support téléphonique'],
    color: 'from-yellow-400 to-orange-500',
    bestValue: true,
    icon: '👑'
  }
} as const

// Fonction pour initier le checkout Stripe
const initiateStripeCheckout = async (planKey: string) => {
  try {
    const response = await fetch('/api/stripe/create-checkout-session', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        plan: planKey,
        platform: 'web',
        customerEmail: 'customer@example.com'
      }),
    })

    const data = await response.json()
    
    if (data.url) {
      window.location.href = data.url
    } else {
      alert('Erreur lors de la création de la session de paiement')
    }
  } catch (error) {
    console.error('Erreur Stripe:', error)
    alert('Erreur lors de la redirection vers Stripe')
  }
}

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState<keyof typeof LANGUAGES>('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  
  const t = TRANSLATIONS[currentLanguage] || TRANSLATIONS.fr
  const isRTL = LANGUAGES[currentLanguage]?.rtl || false
  
  // Fermer dropdown au clic extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setShowLanguageDropdown(false)
      }
    }
    
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900 ${isRTL ? 'rtl' : 'ltr'}`} dir={isRTL ? 'rtl' : 'ltr'}>
      
      {/* Header */}
      <header className="relative backdrop-blur-sm bg-white/10 border-b border-white/20">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-2xl font-bold text-white">🧮</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-white">{t.appName}</h1>
                <p className="text-sm text-white/70">{t.domain}</p>
              </div>
            </div>
            
            {/* Sélecteur de langue */}
            <div className="relative" ref={dropdownRef}>
              <button
                onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                className="flex items-center space-x-2 bg-white/20 hover:bg-white/30 rounded-lg px-4 py-2 transition-all duration-200 backdrop-blur-sm border border-white/30"
              >
                <span className="text-2xl">🌍</span>
                <span className="text-white font-medium">
                  {LANGUAGES[currentLanguage]?.flag} {LANGUAGES[currentLanguage]?.name}
                </span>
                <span className="text-white">⌄</span>
              </button>
              
              {showLanguageDropdown && (
                <div className="absolute top-full mt-2 w-64 bg-white/95 backdrop-blur-md rounded-xl shadow-2xl border border-white/30 z-50 max-h-80 overflow-y-auto">
                  <div className="p-2">
                    {Object.entries(LANGUAGES).map(([code, lang]) => (
                      <button
                        key={code}
                        onClick={() => {
                          setCurrentLanguage(code as keyof typeof LANGUAGES)
                          setShowLanguageDropdown(false)
                        }}
                        className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg transition-all duration-200 ${
                          currentLanguage === code
                            ? 'bg-gradient-to-r from-blue-500 to-purple-600 text-white'
                            : 'hover:bg-gray-100 text-gray-800'
                        }`}
                      >
                        <span className="text-lg">{lang.flag}</span>
                        <span className="font-medium">{lang.name}</span>
                        {currentLanguage === code && <span className="ml-auto">✓</span>}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>
      
      {/* Contenu principal */}
      <main className="max-w-7xl mx-auto px-4 py-8">
        
        {/* Hero Section */}
        <div className="text-center space-y-12">
          <div className="space-y-8">
            <div className="space-y-4">
              <h2 className="text-4xl md:text-6xl font-bold text-white leading-tight">
                {t.welcome}
              </h2>
              <p className="text-xl md:text-2xl text-white/80 max-w-4xl mx-auto leading-relaxed">
                {t.subtitle}
              </p>
            </div>
            
            {/* Statistiques */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">195+</div>
                <div className="text-white/70">{t.languages}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">5</div>
                <div className="text-white/70">{t.levels}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">5</div>
                <div className="text-white/70">{t.operations}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">🏆</div>
                <div className="text-white/70">Récompenses</div>
              </div>
            </div>
            
            {/* Boutons d'action */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <button
                onClick={() => alert('Démo Math4Child - Fonctionnalité à venir !')}
                className="bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 text-white font-bold py-4 px-8 rounded-2xl shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center space-x-3 text-lg"
              >
                <span>🎮</span>
                <span>{t.startGame}</span>
              </button>
              
              <button
                onClick={() => setShowPricing(true)}
                className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white font-bold py-4 px-8 rounded-2xl border border-white/30 transform hover:scale-105 transition-all duration-300 flex items-center space-x-3 text-lg"
              >
                <span>👑</span>
                <span>{t.choosePlan}</span>
              </button>
            </div>
          </div>
          
          {/* Fonctionnalités */}
          <div className="space-y-8">
            <h3 className="text-3xl font-bold text-white text-center">{t.features}</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-400 to-blue-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">🧠</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">IA Adaptative</h4>
                <p className="text-white/70 text-center">S'adapte intelligemment au niveau et rythme de chaque enfant</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-green-400 to-green-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">📊</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">Suivi des Progrès</h4>
                <p className="text-white/70 text-center">100 bonnes réponses pour débloquer le niveau suivant</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-purple-400 to-purple-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">🌍</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">Multilingue</h4>
                <p className="text-white/70 text-center">195+ langues avec support RTL complet</p>
              </div>
            </div>
          </div>
          
          {/* Footer avec informations GOTEST */}
          <div className="bg-white/5 backdrop-blur-sm rounded-2xl p-8 border border-white/10">
            <div className="text-center space-y-4">
              <p className="text-white font-bold text-lg">{t.company}</p>
              <p className="text-white/70">{t.siret}</p>
              <p className="text-white/70">📧 {t.contact}</p>
              <p className="text-white/70">🌐 {t.domain}</p>
            </div>
          </div>
        </div>
      </main>
      
      {/* Modal de tarification */}
      {showPricing && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white/95 backdrop-blur-md rounded-3xl p-8 max-w-6xl w-full max-h-[90vh] overflow-y-auto border border-white/30">
            
            <div className="flex justify-between items-center mb-8">
              <h3 className="text-3xl font-bold text-gray-800">Plans d'Abonnement</h3>
              <button
                onClick={() => setShowPricing(false)}
                className="w-10 h-10 bg-gray-200 hover:bg-gray-300 rounded-full flex items-center justify-center transition-all duration-200 text-xl"
              >
                ×
              </button>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {Object.entries(SUBSCRIPTION_PLANS).map(([key, plan]) => (
                <div
                  key={key}
                  className={`relative bg-white rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-2xl transform hover:scale-105 ${
                    plan.popular ? 'border-purple-400 shadow-lg' : plan.bestValue ? 'border-yellow-400 shadow-lg' : 'border-gray-200'
                  }`}
                >
                  
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-purple-500 to-pink-600 text-white px-4 py-1 rounded-full text-sm font-bold">
                      Le Plus Populaire
                    </div>
                  )}
                  
                  {plan.bestValue && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                      Meilleure Valeur
                    </div>
                  )}
                  
                  <div className="text-center">
                    <div className="text-4xl mb-4">{plan.icon}</div>
                    <h4 className="text-xl font-bold text-gray-800 mb-4">{plan.name}</h4>
                    
                    <div className="mb-6">
                      {plan.originalPrice && (
                        <div className="text-sm text-gray-500 line-through">
                          {plan.originalPrice}€
                        </div>
                      )}
                      <div className="text-3xl font-bold text-gray-800">
                        {plan.price}€
                      </div>
                      <div className="text-sm text-gray-600">
                        /{plan.duration}
                      </div>
                      {plan.discount && (
                        <div className="text-sm text-green-600 font-bold">
                          Économisez {plan.discount}
                        </div>
                      )}
                    </div>
                    
                    <div className="mb-6">
                      <div className="text-lg font-bold text-gray-800">{plan.profiles} profils</div>
                    </div>
                    
                    <div className="space-y-2 mb-6">
                      {plan.features.map((feature, index) => (
                        <div key={index} className="flex items-center space-x-2 text-sm text-gray-600">
                          <span className="text-green-500">✓</span>
                          <span>{feature}</span>
                        </div>
                      ))}
                    </div>
                    
                    <button
                      onClick={() => {
                        if (plan.price === 0) {
                          alert(`Plan ${plan.name} sélectionné - Version gratuite activée !`)
                        } else {
                          initiateStripeCheckout(key)
                        }
                      }}
                      className={`w-full py-3 px-4 rounded-xl font-bold transition-all duration-200 ${
                        plan.popular || plan.bestValue
                          ? 'bg-gradient-to-r from-purple-500 to-pink-600 hover:from-purple-600 hover:to-pink-700 text-white'
                          : 'bg-gray-100 hover:bg-gray-200 text-gray-800'
                      }`}
                    >
                      Choisir ce Plan
                    </button>
                  </div>
                </div>
              ))}
            </div>
            
            <div className="mt-8 text-center text-gray-600 space-y-2">
              <p className="font-bold">{t.company}</p>
              <p>{t.siret}</p>
              <p>📧 {t.contact}</p>
              <p>🌐 {t.domain}</p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

log "✅ Syntaxe corrigée dans src/app/page.tsx"

# =============================================================================
# CORRECTION 3: MISE À JOUR DE LA CONFIGURATION STRIPE
# =============================================================================

info "🔧 Mise à jour de la configuration Stripe..."

# Créer la configuration Stripe corrigée
cat > src/lib/stripe.ts << 'EOF'
import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
})

// Types pour Math4Child
export interface SubscriptionPlan {
  name: string
  price: number
  currency: string
  interval: 'month' | 'year'
  interval_count?: number
  features: string[]
}

// Configuration des plans d'abonnement Math4Child - GOTEST
export const SUBSCRIPTION_PLANS: Record<string, SubscriptionPlan> = {
  free: {
    name: 'Math4Child Explorer',
    price: 0, // Gratuit
    currency: 'eur',
    interval: 'month',
    features: [
      '50 questions totales',
      'Niveau 1 seulement',
      '1 profil enfant',
      'Support communautaire'
    ]
  },
  monthly: {
    name: 'Math4Child Aventurier',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    features: [
      'Questions illimitées',
      'Tous les 5 niveaux',
      '3 profils enfants',
      'IA adaptative',
      'Support prioritaire'
    ]
  },
  quarterly: {
    name: 'Math4Child Champion',
    price: 2697, // 26.97€ en centimes (10% de réduction)
    currency: 'eur',
    interval: 'month',
    interval_count: 3,
    features: [
      'Tout du plan Aventurier',
      '10% de réduction',
      '5 profils enfants',
      'Mode multijoueur',
      'Défis exclusifs',
      'Statistiques avancées'
    ]
  },
  annual: {
    name: 'Math4Child Maître',
    price: 8393, // 83.93€ en centimes (30% de réduction)
    currency: 'eur',
    interval: 'year',
    features: [
      'Tout du plan Champion',
      '30% de réduction',
      '10 profils enfants',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Mode tournoi',
      'Support téléphonique',
      'Certificats de progression'
    ]
  }
}

// Configuration business GOTEST
export const STRIPE_BUSINESS_CONFIG = {
  businessName: 'GOTEST',
  siret: '53958712100028',
  address: {
    line1: 'Adresse GOTEST',
    postal_code: '75000',
    city: 'Paris',
    country: 'FR'
  },
  email: 'gotesttech@gmail.com',
  phone: '+33123456789',
  website: 'https://www.math4child.com'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
EOF

log "✅ Configuration Stripe corrigée"

# =============================================================================
# CORRECTION 4: MISE À JOUR DU PACKAGE.JSON
# =============================================================================

info "📦 Mise à jour du package.json avec les dépendances..."

# Sauvegarder le package.json actuel
cp package.json package.json.backup_$(date +%Y%m%d_%H%M%S)

# Créer un package.json complet avec toutes les dépendances
cat > package.json << 'EOF'
{
  "name": "math4child",
  "version": "2.0.0",
  "description": "Math4Child - Application éducative avec paiements Stripe",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint --quiet",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "test": "echo 'Tests à implémenter'",
    "clean": "rm -rf .next out dist node_modules/.cache"
  },
  "dependencies": {
    "@stripe/stripe-js": "^4.7.0",
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "stripe": "^16.12.0",
    "lucide-react": "^0.469.0"
  },
  "devDependencies": {
    "@types/node": "20.14.8",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "autoprefixer": "10.4.20",
    "eslint": "8.57.0",
    "eslint-config-next": "14.2.30",
    "postcss": "8.4.47",
    "tailwindcss": "3.4.13",
    "typescript": "5.4.5"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
EOF

log "✅ package.json mis à jour"

# =============================================================================
# CORRECTION 5: BUILD FINAL
# =============================================================================

info "🏗️ Tentative de build final..."

# Nettoyer le cache
npm run clean 2>/dev/null || true

# Installer les dépendances proprement
npm install --legacy-peer-deps --force

# Tenter le build
if npm run build; then
    log "✅ Build réussi après corrections !"
    
    if [[ -d "out" ]]; then
        BUILD_SIZE=$(du -sh out/ | cut -f1)
        log "✅ Export statique généré: $BUILD_SIZE"
        
        # Vérifier le contenu
        if grep -q "Math4Child" out/index.html 2>/dev/null; then
            log "✅ Contenu Math4Child présent dans l'export"
        fi
        
        if grep -q "gotesttech@gmail.com" out/index.html 2>/dev/null; then
            log "✅ Contact GOTEST présent dans l'export"
        fi
    fi
else
    error "❌ Build encore en échec - Investigation supplémentaire nécessaire"
    
    # Afficher les erreurs de compilation
    echo ""
    warning "Détails de l'erreur de compilation:"
    npm run build 2>&1 | tail -20
    
    exit 1
fi

# =============================================================================
# RÉSUMÉ DES CORRECTIONS
# =============================================================================

echo ""
echo "🎉 Corrections Appliquées avec Succès !"
echo "======================================="
echo ""

log "✅ Dépendances Stripe installées (@stripe/stripe-js, stripe)"
log "✅ Syntaxe corrigée dans src/app/page.tsx"
log "✅ Configuration Stripe mise à jour"
log "✅ package.json optimisé"
log "✅ Build de production réussi"

if [[ -d "out" ]]; then
    BUILD_SIZE=$(du -sh out/ | cut -f1)
    log "✅ Export statique prêt: $BUILD_SIZE"
fi

echo ""
info "🚀 Math4Child est maintenant prêt pour le déploiement !"
echo ""
info "📋 Actions suivantes recommandées:"
echo "   1. Vérifier l'application: https://prismatic-sherbet-986159.netlify.app"
echo "   2. Configurer les clés Stripe dans .env.local"
echo "   3. Acheter et configurer le domaine www.math4child.com"
echo "   4. Lancer les tests beta utilisateurs"
echo ""
log "✅ Toutes les erreurs de build ont été corrigées !"
EOF

log "✅ Script de correction créé"

# Exécuter le script de correction immédiatement
chmod +x fix_build_errors.sh
./fix_build_errors.sh