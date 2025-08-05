# 10. Modal de pricing avec plans adaptatifs
cat > "${SRC_DIR}/components/pricing/PricingModal.tsx" << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import { X, Check, Star, Crown, Zap, Users } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'
import { getPricingForCountry, formatPrice } from '@/data/pricing/countryPricing'

interface PricingModalProps {
  onClose: () => void
}

export default function PricingModal({ onClose }: PricingModalProps) {
  const { t, language } = useLanguage()
  const [selectedPlan, setSelectedPlan] = useState('quarterly')
  const [userCountry, setUserCountry] = useState('FR')
  const [pricing, setPricing] = useState(getPricingForCountry('FR'))

  useEffect(() => {
    // Détecter le pays de l'utilisateur (simulation)
    const detectCountry = async () => {
      try {
        const response = await fetch('https://ipapi.co/json/')
        const data = await response.json()
        const country = data.country_code || 'FR'
        setUserCountry(country)
        setPricing(getPricingForCountry(country))
      } catch {
        // Fallback vers France
        setPricing(getPricingForCountry('FR'))
      }
    }
    detectCountry()
  }, [])

  const plans = [
    {
      id: 'free',
      name: t('plans.free.name') || 'Essai Gratuit',
      duration: '7 jours',
      price: 'Gratuit',
      originalPrice: null,
      discount: null,
      profiles: 1,
      questions: 50,
      features: [
        'Accès niveau 1 uniquement',
        '50 questions totales',
        '1 profil enfant',
        'Support communautaire'
      ],
      icon: Zap,
      color: 'from-gray-500 to-gray-600',
      popular: false
    },
    {
      id: 'monthly',
      name: 'Mensuel',
      duration: '/mois',
      price: formatPrice(pricing.monthly, pricing.currency, pricing.symbol),
      originalPrice: null,
      discount: null,
      profiles: 3,
      questions: 'illimitées',
      features: [
        'Accès complet 5 niveaux',
        'Questions illimitées',
        '3 profils enfants',
        'Toutes les opérations',
        'Support prioritaire'
      ],
      icon: Star,
      color: 'from-blue-500 to-blue-600',
      popular: false
    },
    {
      id: 'quarterly',
      name: 'Trimestriel',
      duration: '/3 mois',
      price: formatPrice(pricing.quarterly, pricing.currency, pricing.symbol),
      originalPrice: formatPrice(pricing.monthly * 3, pricing.currency, pricing.symbol),
      discount: '10%',
      profiles: 5,
      questions: 'illimitées',
      features: [
        'Accès complet 5 niveaux',
        'Questions illimitées',
        '5 profils enfants',
        'Mode multijoueur',
        'Défis exclusifs',
        'Statistiques avancées',
        'Support prioritaire'
      ],
      icon: Crown,
      color: 'from-purple-500 to-pink-500',
      popular: true
    },
    {
      id: 'annual',
      name: 'Annuel',
      duration: '/an',
      price: formatPrice(pricing.annual, pricing.currency, pricing.symbol),
      originalPrice: formatPrice(pricing.monthly * 12, pricing.currency, pricing.symbol),
      discount: '30%',
      profiles: 10,
      questions: 'illimitées',
      features: [
        'Accès complet 5 niveaux',
        'Questions illimitées',
        '10 profils enfants',
        'Mode multijoueur',
        'Défis exclusifs',
        'Statistiques avancées',
        'Accès anticipé nouvelles fonctionnalités',
        'Mode tournoi',
        'Support téléphonique prioritaire'
      ],
      icon: Crown,
      color: 'from-yellow-500 to-orange-500',
      popular: false
    }
  ]

  const handleSubscribe = (planId: string) => {
    // Simulation de l'abonnement
    console.log(`Abonnement au plan ${planId} pour le pays ${userCountry}`)
    // Ici, on intégrerait Stripe
    alert(`Redirection vers Stripe pour l'abonnement ${planId}`)
    onClose()
  }

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="relative p-8 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-t-3xl">
          <button
            onClick={onClose}
            className="absolute top-6 right-6 p-2 hover:bg-white/20 rounded-xl transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
          
          <div className="text-center">
            <h2 className="text-4xl font-black mb-4">
              Choisissez Votre Plan Math4Child
            </h2>
            <p className="text-xl text-blue-100 mb-6">
              Accès à 195+ langues • 5 niveaux adaptatifs • IA révolutionnaire
            </p>
            
            {/* Informations sur le pays */}
            <div className="inline-flex items-center gap-2 bg-white/20 backdrop-blur-sm px-4 py-2 rounded-full">
              <span className="text-sm">Prix adaptés pour votre région</span>
              <span className="font-bold">{userCountry}</span>
            </div>
          </div>
        </div>

        {/* Plans */}
        <div className="p-8">
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {plans.map((plan) => {
              const IconComponent = plan.icon
              const isSelected = selectedPlan === plan.id
              
              return (
                <div
                  key={plan.id}
                  className={`relative rounded-2xl border-2 transition-all duration-300 ${
                    isSelected 
                      ? 'border-blue-500 shadow-lg scale-105' 
                      : 'border-gray-200 hover:border-blue-300 hover:shadow-md'
                  } ${plan.popular ? 'ring-4 ring-purple-100' : ''}`}
                >
                  {/* Badge populaire */}
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                      <div className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                        ⭐ Le Plus Populaire
                      </div>
                    </div>
                  )}
                  
                  <div className="p-6">
                    {/* Icône et nom */}
                    <div className="text-center mb-6">
                      <div className={`inline-flex p-3 rounded-2xl bg-gradient-to-r ${plan.color} mb-4`}>
                        <IconComponent className="w-8 h-8 text-white" />
                      </div>
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                      
                      {/* Prix */}
                      <div className="mb-4">
                        <div className="flex items-center justify-center gap-2">
                          <span className="text-3xl font-black text-gray-900">
                            {plan.price}
                          </span>
                          <span className="text-gray-500">{plan.duration}</span>
                        </div>
                        
                        {plan.originalPrice && (
                          <div className="flex items-center justify-center gap-2 mt-1">
                            <span className="text-lg text-gray-500 line-through">
                              {plan.originalPrice}
                            </span>
                            <span className="bg-green-100 text-green-700 px-2 py-1 rounded-full text-sm font-bold">
                              -{plan.discount}
                            </span>
                          </div>
                        )}
                      </div>
                      
                      {/* Profils et questions */}
                      <div className="flex justify-center items-center gap-4 text-sm text-gray-600 mb-4">
                        <div className="flex items-center gap-1">
                          <Users className="w-4 h-4" />
                          <span>{plan.profiles} profil{plan.profiles > 1 ? 's' : ''}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <Zap className="w-4 h-4" />
                          <span>{plan.questions} questions</span>
                        </div>
                      </div>
                    </div>
                    
                    {/* Fonctionnalités */}
                    <div className="space-y-3 mb-6">
                      {plan.features.map((feature, index) => (
                        <div key={index} className="flex items-start gap-3">
                          <Check className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                          <span className="text-gray-700 text-sm">{feature}</span>
                        </div>
                      ))}
                    </div>
                    
                    {/* Bouton d'action */}
                    <button
                      onClick={() => handleSubscribe(plan.id)}
                      className={`w-full py-3 rounded-xl font-bold transition-all duration-200 ${
                        plan.id === 'free'
                          ? 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                          : plan.popular
                          ? 'bg-gradient-to-r from-purple-500 to-pink-500 text-white hover:shadow-lg'
                          : 'bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:shadow-lg'
                      } transform hover:scale-105`}
                    >
                      {plan.id === 'free' ? 'Essayer Gratuitement' : 'Choisir ce Plan'}
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
          
          {/* Garanties et informations */}
          <div className="mt-12 text-center">
            <div className="grid md:grid-cols-3 gap-6 mb-8">
              <div className="flex items-center justify-center gap-3">
                <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                  <Check className="w-6 h-6 text-green-600" />
                </div>
                <div className="text-left">
                  <div className="font-bold text-gray-900">Garantie 30 jours</div>
                  <div className="text-sm text-gray-600">Remboursement intégral</div>
                </div>
              </div>
              
              <div className="flex items-center justify-center gap-3">
                <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                  <Zap className="w-6 h-6 text-blue-600" />
                </div>
                <div className="text-left">
                  <div className="font-bold text-gray-900">Activation immédiate</div>
                  <div className="text-sm text-gray-600">Accès instantané</div>
                </div>
              </div>
              
              <div className="flex items-center justify-center gap-3">
                <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                  <Users className="w-6 h-6 text-purple-600" />
                </div>
                <div className="text-left">
                  <div className="font-bold text-gray-900">Support 24/7</div>
                  <div className="text-sm text-gray-600">Aide en français</div>
                </div>
              </div>
            </div>
            
            <div className="text-sm text-gray-500">
              Paiements sécurisés par Stripe • Chiffrement SSL • Conformité RGPD
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF

# 11. Configuration Tailwind avec support RTL
cat > "${MATH4CHILD_DIR}/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        'inter': ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-in': 'slideIn 0.3s ease-out',
        'bounce-gentle': 'bounceGentle 2s infinite',
        'pulse-soft': 'pulseSoft 2s infinite',
        'float': 'float 3s ease-in-out infinite',
        'glow': 'glow 2s ease-in-out infinite alternate',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideIn: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        bounceGentle: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-5px)' },
        },
        pulseSoft: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.7' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        glow: {
          '0%': { boxShadow: '0 0 20px rgba(59, 130, 246, 0.5)' },
          '100%': { boxShadow: '0 0 30px rgba(139, 92, 246, 0.8)' },
        },
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
  // Support RTL
  future: {
    hoverOnlyWhenSupported: true,
  },
}
EOF

# 12. Configuration PostCSS
cat > "${MATH4CHILD_DIR}/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# 13#!/bin/bash

# ===================================================================
# 🎯 MATH4CHILD - APPLICATION RÉVOLUTIONNAIRE COMPLÈTE
# Basé sur README.md et spécifications détaillées
# Domaine: www.math4child.com | Développé par GOTEST
# ===================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${PURPLE}${BOLD}🚀 MATH4CHILD - CRÉATION APPLICATION RÉVOLUTIONNAIRE${NC}"
echo "=============================================================="
echo -e "${CYAN}🌍 Domaine: www.math4child.com | Développé par GOTEST${NC}"
echo ""

# Variables
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MATH4CHILD_DIR="${PROJECT_ROOT}/apps/math4child"
SRC_DIR="${MATH4CHILD_DIR}/src"

echo -e "${BLUE}🎯 SPÉCIFICATIONS DE L'APPLICATION:${NC}"
echo "  ✅ 195+ Langues mondiales (sauf hébreu)"
echo "  ✅ 5 Niveaux avec 100 bonnes réponses/niveau"
echo "  ✅ 5 Opérations: +, -, ×, ÷, mixte"
echo "  ✅ Abonnements adaptatifs par pays"
echo "  ✅ Paiements Stripe mondiaux"
echo "  ✅ Design interactif révolutionnaire"
echo "  ✅ Version premium uniquement"
echo ""

# Sauvegarder l'existant
if [ -d "${SRC_DIR}" ]; then
    mv "${SRC_DIR}" "${SRC_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Ancienne version sauvegardée${NC}"
fi

# Créer la structure complète
mkdir -p "${SRC_DIR}"/{app,components,lib,hooks,types,utils,data}
mkdir -p "${SRC_DIR}/app"/{exercises,games,dashboard,pricing,progress,subscription,auth}
mkdir -p "${SRC_DIR}/components"/{math,ui,navigation,language,pricing,auth,levels}
mkdir -p "${SRC_DIR}/lib"/{stripe,analytics,translations,auth,database}
mkdir -p "${SRC_DIR}/data"/{languages,countries,pricing}

echo -e "${GREEN}✅ Structure de répertoires créée${NC}"

# 1. Configuration des langues mondiales (195+ langues)
cat > "${SRC_DIR}/data/languages/worldLanguages.ts" << 'EOF'
// 195+ Langues mondiales organisées par régions (sauf hébreu)
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  region: string
}

export const WORLD_LANGUAGES: Language[] = [
  // EUROPE
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe' },
  { code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', region: 'Europe' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', region: 'Europe' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', region: 'Europe' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', region: 'Europe' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', region: 'Europe' },
  
  // ASIE
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asia' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asia' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asia' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', region: 'Asia' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', region: 'Asia' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', rtl: true, region: 'Asia' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', rtl: true, region: 'Asia' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳', region: 'Asia' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', region: 'Asia' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', region: 'Asia' },
  { code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', region: 'Asia' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', region: 'Asia' },
  { code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', region: 'Asia' },
  { code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳', region: 'Asia' },
  { code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰', region: 'Asia' },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD (Arabe avec drapeau marocain)
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦', rtl: true, region: 'MENA' },
  
  // AFRIQUE
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', region: 'Africa' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', region: 'Africa' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', region: 'Africa' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', region: 'Africa' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', region: 'Africa' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', region: 'Africa' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', region: 'Africa' },
  
  // AMÉRIQUES
  { code: 'en-US', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', region: 'Americas' },
  { code: 'pt-BR', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', region: 'Americas' },
  { code: 'es-MX', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', region: 'Americas' },
  { code: 'es-AR', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', region: 'Americas' },
  { code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', region: 'Americas' },
  { code: 'fr-CA', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', region: 'Americas' },
  
  // OCÉANIE
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', region: 'Oceania' },
  { code: 'en-NZ', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', region: 'Oceania' },
  
  // Plus de langues européennes
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', region: 'Europe' },
  { code: 'sr', name: 'Serbian', nativeName: 'Српски', flag: '🇷🇸', region: 'Europe' },
  { code: 'bs', name: 'Bosnian', nativeName: 'Bosanski', flag: '🇧🇦', region: 'Europe' },
  { code: 'mk', name: 'Macedonian', nativeName: 'Македонски', flag: '🇲🇰', region: 'Europe' },
  { code: 'sq', name: 'Albanian', nativeName: 'Shqip', flag: '🇦🇱', region: 'Europe' },
  { code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', region: 'Europe' },
  { code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', region: 'Europe' },
  { code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', region: 'Europe' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', region: 'Europe' },
  { code: 'mt', name: 'Maltese', nativeName: 'Malti', flag: '🇲🇹', region: 'Europe' },
  { code: 'is', name: 'Icelandic', nativeName: 'Íslenska', flag: '🇮🇸', region: 'Europe' },
  { code: 'ga', name: 'Irish', nativeName: 'Gaeilge', flag: '🇮🇪', region: 'Europe' },
  { code: 'cy', name: 'Welsh', nativeName: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', region: 'Europe' },
  { code: 'eu', name: 'Basque', nativeName: 'Euskera', flag: '🇪🇸', region: 'Europe' },
  { code: 'ca', name: 'Catalan', nativeName: 'Català', flag: '🇪🇸', region: 'Europe' },
  { code: 'gl', name: 'Galician', nativeName: 'Galego', flag: '🇪🇸', region: 'Europe' },
  
  // Plus de langues asiatiques
  { code: 'my', name: 'Burmese', nativeName: 'မြန်မာ', flag: '🇲🇲', region: 'Asia' },
  { code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', region: 'Asia' },
  { code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', region: 'Asia' },
  { code: 'ne', name: 'Nepali', nativeName: 'नेपाली', flag: '🇳🇵', region: 'Asia' },
  { code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', region: 'Asia' },
  { code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', region: 'Asia' },
  { code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', region: 'Asia' },
  { code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', region: 'Asia' },
  { code: 'kk', name: 'Kazakh', nativeName: 'Қазақ', flag: '🇰🇿', region: 'Asia' },
  { code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргыз', flag: '🇰🇬', region: 'Asia' },
  { code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek', flag: '🇺🇿', region: 'Asia' },
  { code: 'tk', name: 'Turkmen', nativeName: 'Türkmen', flag: '🇹🇲', region: 'Asia' },
  { code: 'tg', name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', region: 'Asia' },
  
  // Langues africaines supplémentaires
  { code: 'rw', name: 'Kinyarwanda', nativeName: 'Ikinyarwanda', flag: '🇷🇼', region: 'Africa' },
  { code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', region: 'Africa' },
  { code: 'sn', name: 'Shona', nativeName: 'chiShona', flag: '🇿🇼', region: 'Africa' },
  { code: 'ny', name: 'Chichewa', nativeName: 'Chichewa', flag: '🇲🇼', region: 'Africa' },
  { code: 'st', name: 'Sesotho', nativeName: 'Sesotho', flag: '🇱🇸', region: 'Africa' },
  { code: 'tn', name: 'Setswana', nativeName: 'Setswana', flag: '🇧🇼', region: 'Africa' },
  { code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', region: 'Africa' },
  { code: 'ss', name: 'Swati', nativeName: 'siSwati', flag: '🇸🇿', region: 'Africa' },
  { code: 've', name: 'Venda', nativeName: 'Tshivenḓa', flag: '🇿🇦', region: 'Africa' },
  { code: 'ts', name: 'Tsonga', nativeName: 'Xitsonga', flag: '🇿🇦', region: 'Africa' },
  { code: 'nr', name: 'Ndebele', nativeName: 'isiNdebele', flag: '🇿🇦', region: 'Africa' },
  
  // Plus de langues des Amériques
  { code: 'qu', name: 'Quechua', nativeName: 'Runa Simi', flag: '🇵🇪', region: 'Americas' },
  { code: 'gn', name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', region: 'Americas' },
  { code: 'ay', name: 'Aymara', nativeName: 'Aymar aru', flag: '🇧🇴', region: 'Americas' },
  { code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl ayisyen', flag: '🇭🇹', region: 'Americas' }
]

export const REGIONS = [
  'Europe',
  'Asia', 
  'MENA',
  'Africa',
  'Americas',
  'Oceania'
]

export const getLanguagesByRegion = (region: string) => 
  WORLD_LANGUAGES.filter(lang => lang.region === region)

export const getLanguageByCode = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)

export const isRTLLanguage = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)?.rtl || false
EOF

# 2. Traductions mondiales
cat > "${SRC_DIR}/lib/translations/worldTranslations.ts" << 'EOF'
// Système de traductions pour 195+ langues
export const TRANSLATIONS = {
  fr: {
    // Page d'accueil
    title: 'Math4Child - Apprendre les maths en s\'amusant !',
    subtitle: 'L\'application révolutionnaire qui transforme l\'apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans',
    startAdventure: 'Commencer l\'Aventure',
    viewPlans: 'Voir les Plans',
    
    // Navigation
    exercises: 'Exercices',
    games: 'Jeux',
    dashboard: 'Tableau de bord',
    pricing: 'Plans',
    progress: 'Progrès',
    subscription: 'Abonnement',
    
    // Fonctionnalités
    features: {
      aiAdaptive: {
        title: 'IA Adaptative',
        description: 'S\'adapte intelligemment au niveau et au rythme de chaque enfant'
      },
      multiLanguage: {
        title: '195+ Langues',
        description: 'Support multilingue complet avec RTL automatique'
      },
      fiveLevels: {
        title: '5 Niveaux',
        description: 'Progression gamifiée du débutant à l\'expert'
      },
      fiveOperations: {
        title: '5 Opérations',
        description: 'Addition, soustraction, multiplication, division, mixte'
      },
      familyMode: {
        title: 'Mode Famille',
        description: 'Jusqu\'à 10 profils enfants avec suivi parental'
      },
      motivation: {
        title: 'Motivation',
        description: 'Système de récompenses et défis pour maintenir l\'engagement'
      }
    },
    
    // Niveaux
    levels: {
      beginner: 'Débutant',
      elementary: 'Élémentaire', 
      intermediate: 'Intermédiaire',
      advanced: 'Avancé',
      expert: 'Expert'
    },
    
    // Opérations
    operations: {
      addition: 'Addition',
      subtraction: 'Soustraction',
      multiplication: 'Multiplication',
      division: 'Division',
      mixed: 'Mixte'
    },
    
    // Plans d'abonnement
    plans: {
      free: {
        name: 'Essai Gratuit',
        duration: '7 jours',
        price: 'Gratuit',
        questions: '50 questions totales',
        profiles: '1 profil'
      },
      monthly: {
        name: 'Mensuel',
        price: '9,99€/mois',
        profiles: '3 profils',
        features: 'Accès complet'
      },
      quarterly: {
        name: 'Trimestriel',
        price: '26,97€ (10% de réduction)',
        profiles: '5 profils',
        popular: 'Le plus populaire'
      },
      annual: {
        name: 'Annuel',
        price: '83,93€ (30% de réduction)',
        profiles: '10 profils',
        bestValue: 'Meilleure valeur'
      }
    }
  },
  
  en: {
    title: 'Math4Child - Learn math while having fun!',
    subtitle: 'The revolutionary app that transforms mathematics learning into a fun adventure for children aged 6 to 12',
    startAdventure: 'Start Adventure',
    viewPlans: 'View Plans',
    
    exercises: 'Exercises',
    games: 'Games', 
    dashboard: 'Dashboard',
    pricing: 'Plans',
    progress: 'Progress',
    subscription: 'Subscription',
    
    features: {
      aiAdaptive: {
        title: 'Adaptive AI',
        description: 'Intelligently adapts to each child\'s level and pace'
      },
      multiLanguage: {
        title: '195+ Languages',
        description: 'Complete multilingual support with automatic RTL'
      },
      fiveLevels: {
        title: '5 Levels',
        description: 'Gamified progression from beginner to expert'
      },
      fiveOperations: {
        title: '5 Operations',
        description: 'Addition, subtraction, multiplication, division, mixed'
      },
      familyMode: {
        title: 'Family Mode',
        description: 'Up to 10 child profiles with parental tracking'
      },
      motivation: {
        title: 'Motivation',
        description: 'Reward system and challenges to maintain engagement'
      }
    },
    
    levels: {
      beginner: 'Beginner',
      elementary: 'Elementary',
      intermediate: 'Intermediate', 
      advanced: 'Advanced',
      expert: 'Expert'
    },
    
    operations: {
      addition: 'Addition',
      subtraction: 'Subtraction',
      multiplication: 'Multiplication',
      division: 'Division',
      mixed: 'Mixed'
    },
    
    plans: {
      free: {
        name: 'Free Trial',
        duration: '7 days',
        price: 'Free',
        questions: '50 total questions',
        profiles: '1 profile'
      },
      monthly: {
        name: 'Monthly',
        price: '$9.99/month',
        profiles: '3 profiles',
        features: 'Full access'
      },
      quarterly: {
        name: 'Quarterly',
        price: '$26.97 (10% off)',
        profiles: '5 profiles',
        popular: 'Most popular'
      },
      annual: {
        name: 'Annual',
        price: '$83.93 (30% off)',
        profiles: '10 profiles',
        bestValue: 'Best value'
      }
    }
  },
  
  ar: {
    title: 'Math4Child - تعلم الرياضيات بالمتعة!',
    subtitle: 'التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة للأطفال من سن 6 إلى 12 سنة',
    startAdventure: 'ابدأ المغامرة',
    viewPlans: 'عرض الخطط',
    
    exercises: 'التمارين',
    games: 'الألعاب',
    dashboard: 'لوحة التحكم',
    pricing: 'الخطط',
    progress: 'التقدم',
    subscription: 'الاشتراك',
    
    features: {
      aiAdaptive: {
        title: 'ذكاء اصطناعي تكيفي',
        description: 'يتكيف بذكاء مع مستوى ووتيرة كل طفل'
      },
      multiLanguage: {
        title: '195+ لغة',
        description: 'دعم متعدد اللغات الكامل مع RTL التلقائي'
      },
      fiveLevels: {
        title: '5 مستويات',
        description: 'تقدم تلعيبي من المبتدئ إلى الخبير'
      },
      fiveOperations: {
        title: '5 عمليات',
        description: 'الجمع، الطرح، الضرب، القسمة، مختلط'
      },
      familyMode: {
        title: 'وضع العائلة',
        description: 'حتى 10 ملفات شخصية للأطفال مع تتبع الوالدين'
      },
      motivation: {
        title: 'التحفيز',
        description: 'نظام مكافآت وتحديات للحفاظ على الانخراط'
      }
    },
    
    levels: {
      beginner: 'مبتدئ',
      elementary: 'ابتدائي',
      intermediate: 'متوسط',
      advanced: 'متقدم',
      expert: 'خبير'
    },
    
    operations: {
      addition: 'الجمع',
      subtraction: 'الطرح',
      multiplication: 'الضرب',
      division: 'القسمة',
      mixed: 'مختلط'
    },
    
    plans: {
      free: {
        name: 'تجربة مجانية',
        duration: '7 أيام',
        price: 'مجاني',
        questions: '50 سؤال إجمالي',
        profiles: 'ملف شخصي واحد'
      },
      monthly: {
        name: 'شهري',
        price: '9.99€/شهر',
        profiles: '3 ملفات شخصية',
        features: 'وصول كامل'
      },
      quarterly: {
        name: 'ربع سنوي',
        price: '26.97€ (خصم 10%)',
        profiles: '5 ملفات شخصية',
        popular: 'الأكثر شعبية'
      },
      annual: {
        name: 'سنوي',
        price: '83.93€ (خصم 30%)',
        profiles: '10 ملفات شخصية',
        bestValue: 'أفضل قيمة'
      }
    }
  }
  
  // Les autres traductions seront générées automatiquement par l'IA
}

export const getTranslation = (language: string, key: string): string => {
  const keys = key.split('.')
  let value: any = TRANSLATIONS[language as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  
  for (const k of keys) {
    value = value?.[k]
  }
  
  return value || key
}
EOF

# 3. Configuration des prix par pays
cat > "${SRC_DIR}/data/pricing/countryPricing.ts" << 'EOF'
// Prix adaptatifs par pays selon le pouvoir d'achat
export interface CountryPricing {
  country: string
  currency: string
  symbol: string
  monthly: number
  quarterly: number
  annual: number
  purchasingPower: number // Facteur de pouvoir d'achat
}

export const COUNTRY_PRICING: CountryPricing[] = [
  // Europe - Prix de base
  { country: 'FR', currency: 'EUR', symbol: '€', monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: 'DE', currency: 'EUR', symbol: '€', monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: 'ES', currency: 'EUR', symbol: '€', monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 0.9 },
  { country: 'IT', currency: 'EUR', symbol: '€', monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 0.9 },
  { country: 'GB', currency: 'GBP', symbol: '£', monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 1.0 },
  { country: 'CH', currency: 'CHF', symbol: 'CHF', monthly: 10.99, quarterly: 29.67, annual: 92.32, purchasingPower: 1.1 },
  { country: 'NO', currency: 'NOK', symbol: 'kr', monthly: 99, quarterly: 267, annual: 831, purchasingPower: 1.2 },
  { country: 'SE', currency: 'SEK', symbol: 'kr', monthly: 99, quarterly: 267, annual: 831, purchasingPower: 1.0 },
  { country: 'DK', currency: 'DKK', symbol: 'kr', monthly: 69, quarterly: 186, annual: 580, purchasingPower: 1.0 },
  
  // Amériques
  { country: 'US', currency: 'USD', symbol: '$', monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: 'CA', currency: 'CAD', symbol: 'C$', monthly: 12.99, quarterly: 35.07, annual: 109.11, purchasingPower: 0.95 },
  { country: 'MX', currency: 'MXN', symbol: '$', monthly: 149, quarterly: 402, annual: 1251, purchasingPower: 0.4 },
  { country: 'BR', currency: 'BRL', symbol: 'R$', monthly: 29.99, quarterly: 80.97, annual: 251.93, purchasingPower: 0.35 },
  { country: 'AR', currency: 'ARS', symbol: '$', monthly: 999, quarterly: 2697, annual: 8393, purchasingPower: 0.15 },
  { country: 'CL', currency: 'CLP', symbol: '$', monthly: 7999, quarterly: 21597, annual: 67144, purchasingPower: 0.6 },
  { country: 'CO', currency: 'COP', symbol: '$', monthly: 39999, quarterly: 107997, annual: 335972, purchasingPower: 0.3 },
  
  // Asie
  { country: 'JP', currency: 'JPY', symbol: '¥', monthly: 1099, quarterly: 2967, annual: 9232, purchasingPower: 0.9 },
  { country: 'KR', currency: 'KRW', symbol: '₩', monthly: 11999, quarterly: 32397, annual: 100772, purchasingPower: 0.8 },
  { country: 'CN', currency: 'CNY', symbol: '¥', monthly: 59.99, quarterly: 161.97, annual: 503.93, purchasingPower: 0.5 },
  { country: 'IN', currency: 'INR', symbol: '₹', monthly: 499, quarterly: 1347, annual: 4193, purchasingPower: 0.25 },
  { country: 'ID', currency: 'IDR', symbol: 'Rp', monthly: 149999, quarterly: 404997, annual: 1259372, purchasingPower: 0.2 },
  { country: 'TH', currency: 'THB', symbol: '฿', monthly: 299, quarterly: 807, annual: 2512, purchasingPower: 0.4 },
  { country: 'VN', currency: 'VND', symbol: '₫', monthly: 229999, quarterly: 620997, annual: 1931972, purchasingPower: 0.15 },
  { country: 'MY', currency: 'MYR', symbol: 'RM', monthly: 39.99, quarterly: 107.97, annual: 335.72, purchasingPower: 0.5 },
  { country: 'SG', currency: 'SGD', symbol: 'S$', monthly: 12.99, quarterly: 35.07, annual: 109.11, purchasingPower: 1.0 },
  { country: 'PH', currency: 'PHP', symbol: '₱', monthly: 499, quarterly: 1347, annual: 4193, purchasingPower: 0.3 },
  
  // Moyen-Orient & Afrique du Nord
  { country: 'AE', currency: 'AED', symbol: 'د.إ', monthly: 36.99, quarterly: 99.87, annual: 310.72, purchasingPower: 0.8 },
  { country: 'SA', currency: 'SAR', symbol: 'ر.س', monthly: 37.49, quarterly: 101.22, annual: 314.94, purchasingPower: 0.7 },
  { country: 'EG', currency: 'EGP', symbol: 'ج.م', monthly: 199.99, quarterly: 539.97, annual: 1679.34, purchasingPower: 0.2 },
  { country: 'MA', currency: 'MAD', symbol: 'د.م.', monthly: 99.99, quarterly: 269.97, annual: 839.34, purchasingPower: 0.3 },
  { country: 'DZ', currency: 'DZD', symbol: 'د.ج', monthly: 1299, quarterly: 3507, annual: 10911, purchasingPower: 0.2 },
  { country: 'TN', currency: 'TND', symbol: 'د.ت', monthly: 29.99, quarterly: 80.97, annual: 251.93, purchasingPower: 0.25 },
  
  // Afrique
  { country: 'ZA', currency: 'ZAR', symbol: 'R', monthly: 149.99, quarterly: 404.97, annual: 1259.34, purchasingPower: 0.4 },
  { country: 'NG', currency: 'NGN', symbol: '₦', monthly: 3999, quarterly: 10797, annual: 33594, purchasingPower: 0.15 },
  { country: 'KE', currency: 'KES', symbol: 'KSh', monthly: 999, quarterly: 2697, annual: 8393, purchasingPower: 0.2 },
  { country: 'GH', currency: 'GHS', symbol: '₵', monthly: 59.99, quarterly: 161.97, annual: 503.93, purchasingPower: 0.2 },
  { country: 'ET', currency: 'ETB', symbol: 'Br', monthly: 499, quarterly: 1347, annual: 4193, purchasingPower: 0.1 },
  
  // Océanie
  { country: 'AU', currency: 'AUD', symbol: 'A$', monthly: 14.99, quarterly: 40.47, annual: 125.93, purchasingPower: 0.95 },
  { country: 'NZ', currency: 'NZD', symbol: 'NZ$', monthly: 15.99, quarterly: 43.17, annual: 134.33, purchasingPower: 0.9 },
  
  // Europe de l'Est
  { country: 'PL', currency: 'PLN', symbol: 'zł', monthly: 39.99, quarterly: 107.97, annual: 335.72, purchasingPower: 0.6 },
  { country: 'CZ', currency: 'CZK', symbol: 'Kč', monthly: 229, quarterly: 618, annual: 1923, purchasingPower: 0.7 },
  { country: 'HU', currency: 'HUF', symbol: 'Ft', monthly: 3299, quarterly: 8907, annual: 27711, purchasingPower: 0.6 },
  { country: 'RO', currency: 'RON', symbol: 'lei', monthly: 44.99, quarterly: 121.47, annual: 377.93, purchasingPower: 0.5 },
  { country: 'BG', currency: 'BGN', symbol: 'лв', monthly: 17.99, quarterly: 48.57, annual: 151.13, purchasingPower: 0.4 },
  { country: 'HR', currency: 'HRK', symbol: 'kn', monthly: 67.99, quarterly: 183.57, annual: 571.13, purchasingPower: 0.7 },
  { country: 'SK', currency: 'EUR', symbol: '€', monthly: 7.99, quarterly: 21.57, annual: 67.13, purchasingPower: 0.8 },
  { country: 'SI', currency: 'EUR', symbol: '€', monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 0.85 },
  
  // Pays CIS
  { country: 'RU', currency: 'RUB', symbol: '₽', monthly: 599, quarterly: 1617, annual: 5033, purchasingPower: 0.3 },
  { country: 'UA', currency: 'UAH', symbol: '₴', monthly: 249, quarterly: 672, annual: 2092, purchasingPower: 0.2 },
  { country: 'BY', currency: 'BYN', symbol: 'Br', monthly: 24.99, quarterly: 67.47, annual: 209.93, purchasingPower: 0.25 },
  { country: 'KZ', currency: 'KZT', symbol: '₸', monthly: 3999, quarterly: 10797, annual: 33594, purchasingPower: 0.3 }
]

export const getPricingForCountry = (countryCode: string): CountryPricing => {
  return COUNTRY_PRICING.find(p => p.country === countryCode) || COUNTRY_PRICING[0]
}

export const formatPrice = (amount: number, currency: string, symbol: string): string => {
  if (currency === 'JPY' || currency === 'KRW' || currency === 'VND' || currency === 'IDR') {
    return `${symbol}${Math.round(amount).toLocaleString()}`
  }
  return `${symbol}${amount.toFixed(2)}`
}
EOF

# 4. Générateur de questions mathématiques par niveau
cat > "${SRC_DIR}/lib/math/questionGenerator.ts" << 'EOF'
// Générateur de questions mathématiques par niveau
export interface MathQuestion {
  id: string
  level: number
  operation: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed'
  question: string
  correctAnswer: number
  options: number[]
  difficulty: 'easy' | 'medium' | 'hard'
  points: number
}

export interface LevelConfig {
  level: number
  name: string
  requiredCorrectAnswers: number
  operations: string[]
  numberRange: { min: number; max: number }
  hasNegatives: boolean
  hasDecimals: boolean
}

export const LEVEL_CONFIGS: LevelConfig[] = [
  {
    level: 1,
    name: 'Débutant',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction'],
    numberRange: { min: 1, max: 10 },
    hasNegatives: false,
    hasDecimals: false
  },
  {
    level: 2,
    name: 'Élémentaire',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication'],
    numberRange: { min: 1, max: 50 },
    hasNegatives: false,
    hasDecimals: false
  },
  {
    level: 3,
    name: 'Intermédiaire',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division'],
    numberRange: { min: 1, max: 100 },
    hasNegatives: true,
    hasDecimals: false
  },
  {
    level: 4,
    name: 'Avancé',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 500 },
    hasNegatives: true,
    hasDecimals: true
  },
  {
    level: 5,
    name: 'Expert',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 1000 },
    hasNegatives: true,
    hasDecimals: true
  }
]

export class MathQuestionGenerator {
  private generateRandomNumber(min: number, max: number, allowDecimals: boolean = false): number {
    if (allowDecimals && Math.random() > 0.7) {
      return Math.round((Math.random() * (max - min) + min) * 10) / 10
    }
    return Math.floor(Math.random() * (max - min + 1)) + min
  }

  private generateAddition(config: LevelConfig): MathQuestion {
    const a = this.generateRandomNumber(config.numberRange.min, config.numberRange.max, config.hasDecimals)
    const b = this.generateRandomNumber(config.numberRange.min, config.numberRange.max, config.hasDecimals)
    const correctAnswer = Math.round((a + b) * 10) / 10

    return {
      id: `add_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: 'addition',
      question: `${a} + ${b} = ?`,
      correctAnswer,
      options: this.generateOptions(correctAnswer, config),
      difficulty: this.getDifficulty(config.level),
      points: config.level * 10
    }
  }

  private generateSubtraction(config: LevelConfig): MathQuestion {
    let a = this.generateRandomNumber(config.numberRange.min, config.numberRange.max, config.hasDecimals)
    let b = this.generateRandomNumber(config.numberRange.min, config.numberRange.max, config.hasDecimals)
    
    // S'assurer que a >= b si pas de négatifs autorisés
    if (!config.hasNegatives && a < b) {
      [a, b] = [b, a]
    }
    
    const correctAnswer = Math.round((a - b) * 10) / 10

    return {
      id: `sub_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: 'subtraction',
      question: `${a} - ${b} = ?`,
      correctAnswer,
      options: this.generateOptions(correctAnswer, config),
      difficulty: this.getDifficulty(config.level),
      points: config.level * 10
    }
  }

  private generateMultiplication(config: LevelConfig): MathQuestion {
    const maxRange = Math.min(config.numberRange.max, config.level <= 2 ? 12 : 50)
    const a = this.generateRandomNumber(1, maxRange, false)
    const b = this.generateRandomNumber(1, maxRange, false)
    const correctAnswer = a * b

    return {
      id: `mul_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: 'multiplication',
      question: `${a} × ${b} = ?`,
      correctAnswer,
      options: this.generateOptions(correctAnswer, config),
      difficulty: this.getDifficulty(config.level),
      points: config.level * 15
    }
  }

  private generateDivision(config: LevelConfig): MathQuestion {
    const divisor = this.generateRandomNumber(2, Math.min(config.numberRange.max, 20), false)
    const quotient = this.generateRandomNumber(1, Math.min(config.numberRange.max / divisor, 50), config.hasDecimals)
    const dividend = divisor * quotient
    const correctAnswer = Math.round(quotient * 10) / 10

    return {
      id: `div_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: 'division',
      question: `${dividend} ÷ ${divisor} = ?`,
      correctAnswer,
      options: this.generateOptions(correctAnswer, config),
      difficulty: this.getDifficulty(config.level),
      points: config.level * 20
    }
  }

  private generateMixed(config: LevelConfig): MathQuestion {
    const operations = ['addition', 'subtraction', 'multiplication', 'division']
    const randomOp = operations[Math.floor(Math.random() * operations.length)]
    
    switch (randomOp) {
      case 'addition': return this.generateAddition(config)
      case 'subtraction': return this.generateSubtraction(config)
      case 'multiplication': return this.generateMultiplication(config)
      case 'division': return this.generateDivision(config)
      default: return this.generateAddition(config)
    }
  }

  private generateOptions(correctAnswer: number, config: LevelConfig): number[] {
    const options = [correctAnswer]
    const variance = Math.max(1, Math.floor(correctAnswer * 0.3))
    
    while (options.length < 4) {
      const wrongAnswer = correctAnswer + this.generateRandomNumber(-variance, variance, config.hasDecimals)
      if (wrongAnswer !== correctAnswer && !options.includes(wrongAnswer) && wrongAnswer >= 0) {
        options.push(Math.round(wrongAnswer * 10) / 10)
      }
    }
    
    return options.sort(() => Math.random() - 0.5)
  }

  private getDifficulty(level: number): 'easy' | 'medium' | 'hard' {
    if (level <= 2) return 'easy'
    if (level <= 4) return 'medium'
    return 'hard'
  }

  public generateQuestion(level: number, operation?: string): MathQuestion {
    const config = LEVEL_CONFIGS.find(c => c.level === level)
    if (!config) throw new Error(`Invalid level: ${level}`)

    const availableOps = operation ? [operation] : config.operations
    const selectedOp = availableOps[Math.floor(Math.random() * availableOps.length)]

    switch (selectedOp) {
      case 'addition': return this.generateAddition(config)
      case 'subtraction': return this.generateSubtraction(config)
      case 'multiplication': return this.generateMultiplication(config)
      case 'division': return this.generateDivision(config)
      case 'mixed': return this.generateMixed(config)
      default: return this.generateAddition(config)
    }
  }

  public generateQuestionSet(level: number, count: number = 10, operation?: string): MathQuestion[] {
    const questions: MathQuestion[] = []
    for (let i = 0; i < count; i++) {
      questions.push(this.generateQuestion(level, operation))
    }
    return questions
  }
}

export const mathGenerator = new MathQuestionGenerator()
EOF

# 5. Layout principal avec navigation
cat > "${SRC_DIR}/app/layout.tsx" << 'EOF'
import './globals.css'
import Navigation from '@/components/navigation/Navigation'
import { LanguageProvider } from '@/components/language/LanguageProvider'

export const metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant !',
  description: 'L\'application éducative révolutionnaire pour apprendre les mathématiques. 195+ langues, IA adaptative, développée par GOTEST.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, jeux éducatifs, GOTEST',
  authors: [{ name: 'GOTEST', url: 'https://www.math4child.com' }],
  creator: 'GOTEST',
  publisher: 'GOTEST',
  robots: 'index, follow',
  openGraph: {
    title: 'Math4Child - Révolution Éducative',
    description: 'Apprendre les mathématiques n\'a jamais été aussi amusant !',
    url: 'https://www.math4child.com',
    siteName: 'Math4Child',
    images: [{
      url: '/og-image.jpg',
      width: 1200,
      height: 630,
    }],
    locale: 'fr_FR',
    type: 'website',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#667eea" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body className="font-inter antialiased bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 min-h-screen">
        <LanguageProvider>
          <Navigation />
          <main className="pt-20 pb-10">
            {children}
          </main>
          
          {/* Footer */}
          <footer className="bg-white border-t border-gray-200 py-8 px-4">
            <div className="max-w-6xl mx-auto text-center">
              <div className="flex items-center justify-center mb-4">
                <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-2 rounded-xl mr-3">
                  <span className="text-white font-bold text-lg">M4C</span>
                </div>
                <div>
                  <h3 className="font-bold text-xl bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                    Math4Child
                  </h3>
                  <p className="text-sm text-gray-500">by GOTEST</p>
                </div>
              </div>
              
              <div className="grid md:grid-cols-3 gap-8 text-sm text-gray-600 mb-6">
                <div>
                  <h4 className="font-semibold mb-2">Produit</h4>
                  <ul className="space-y-1">
                    <li>Exercices</li>
                    <li>Jeux éducatifs</li>
                    <li>Suivi des progrès</li>
                    <li>195+ Langues</li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold mb-2">Support</h4>
                  <ul className="space-y-1">
                    <li>Centre d'aide</li>
                    <li>Contact: gotesttech@gmail.com</li>
                    <li>Guides parents</li>
                    <li>FAQ</li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold mb-2">Entreprise</h4>
                  <ul className="space-y-1">
                    <li>GOTEST (SIRET: 53958712100028)</li>
                    <li>www.math4child.com</li>
                    <li>Politique de confidentialité</li>
                    <li>Conditions d'utilisation</li>
                  </ul>
                </div>
              </div>
              
              <div className="border-t border-gray-200 pt-6">
                <p className="text-gray-500">
                  © 2024 GOTEST. Tous droits réservés. Math4Child est une marque déposée.
                </p>
              </div>
            </div>
          </footer>
        </LanguageProvider>
      </body>
    </html>
  )
}
EOF

# 7. Styles globaux avec support RTL
cat > "${SRC_DIR}/app/globals.css" << 'EOF'
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground font-inter;
  }
  
  html {
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
  }
}

@layer components {
  .btn-primary {
    @apply bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200;
  }
  
  .btn-secondary {
    @apply bg-white text-blue-600 px-6 py-3 rounded-xl font-semibold border-2 border-blue-600 hover:bg-blue-50 transition-all duration-200;
  }
  
  .card {
    @apply bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300;
  }
  
  .card-gradient {
    @apply bg-gradient-to-br from-white to-blue-50 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300;
  }
  
  .input-field {
    @apply w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200;
  }
  
  .glass-morphism {
    @apply bg-white/20 backdrop-blur-lg border border-white/30;
  }
}

/* Animations */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.5); }
  50% { box-shadow: 0 0 30px rgba(139, 92, 246, 0.8); }
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInScale {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.float {
  animation: float 3s ease-in-out infinite;
}

.glow {
  animation: glow 2s ease-in-out infinite;
}

.slide-in-up {
  animation: slideInUp 0.6s ease-out forwards;
}

.fade-in-scale {
  animation: fadeInScale 0.5s ease-out forwards;
}

/* RTL Support */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .flex {
  flex-direction: row-reverse;
}

[dir="rtl"] .space-x-2 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-x-reverse: 1;
  margin-left: calc(0.5rem * var(--tw-space-x-reverse));
  margin-right: calc(0.5rem * calc(1 - var(--tw-space-x-reverse)));
}

[dir="rtl"] .text-left {
  text-align: right;
}

[dir="rtl"] .text-right {
  text-align: left;
}

[dir="rtl"] .pl-4 {
  padding-left: 0;
  padding-right: 1rem;
}

[dir="rtl"] .pr-4 {
  padding-right: 0;
  padding-left: 1rem;
}

[dir="rtl"] .ml-4 {
  margin-left: 0;
  margin-right: 1rem;
}

[dir="rtl"] .mr-4 {
  margin-right: 0;
  margin-left: 1rem;
}

/* Scrollbar personnalisé */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, #3b82f6, #8b5cf6);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(180deg, #2563eb, #7c3aed);
}

/* Loading spinner */
.spinner {
  border: 3px solid #f3f4f6;
  border-top: 3px solid #3b82f6;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Mobile optimizations */
@media (max-width: 640px) {
  .text-6xl {
    font-size: 3rem;
    line-height: 1;
  }
  
  .text-8xl {
    font-size: 4rem;
    line-height: 1;
  }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .auto-dark {
    @apply bg-gray-900 text-white;
  }
}

/* Print styles */
@media print {
  .no-print {
    display: none !important;
  }
}

/* Focus styles for accessibility */
.focus-visible:focus {
  @apply outline-none ring-2 ring-blue-500 ring-offset-2;
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .btn-primary {
    @apply border-2 border-black;
  }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  .float,
  .glow,
  .slide-in-up,
  .fade-in-scale {
    animation: none;
  }
  
  .transition-all {
    transition: none;
  }
}
EOF

# 8. Composants principaux
echo -e "${BLUE}🔧 Création des composants principaux...${NC}"

# Hook pour la gestion des langues
mkdir -p "${SRC_DIR}/hooks"
cat > "${SRC_DIR}/hooks/useLanguage.ts" << 'EOF'
'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { WORLD_LANGUAGES, getLanguageByCode, isRTLLanguage } from '@/data/languages/worldLanguages'
import { getTranslation } from '@/lib/translations/worldTranslations'

interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
  isRTL: boolean
  availableLanguages: typeof WORLD_LANGUAGES
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguageState] = useState('fr')
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    // Détecter la langue du navigateur
    const browserLang = navigator.language.split('-')[0]
    const supportedLang = WORLD_LANGUAGES.find(lang => 
      lang.code.startsWith(browserLang)
    )?.code || 'fr'
    
    setLanguageState(supportedLang)
    setIsRTL(isRTLLanguage(supportedLang))
    
    // Mettre à jour la direction du document
    document.documentElement.dir = isRTLLanguage(supportedLang) ? 'rtl' : 'ltr'
    document.documentElement.lang = supportedLang
  }, [])

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    const rtl = isRTLLanguage(lang)
    setIsRTL(rtl)
    
    // Mettre à jour la direction du document
    document.documentElement.dir = rtl ? 'rtl' : 'ltr'
    document.documentElement.lang = lang
    
    // Sauvegarder dans localStorage
    localStorage.setItem('math4child-language', lang)
  }

  const t = (key: string): string => {
    return getTranslation(language, key)
  }

  return (
    <LanguageContext.Provider value={{
      language,
      setLanguage,
      t,
      isRTL,
      availableLanguages: WORLD_LANGUAGES
    }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
EOF

# Provider de langue
cat > "${SRC_DIR}/components/language/LanguageProvider.tsx" << 'EOF'
'use client'

import { LanguageProvider as Provider } from '@/hooks/useLanguage'

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  return <Provider>{children}</Provider>
}
EOF

# Sélecteur de langues avancé
cat > "${SRC_DIR}/components/language/LanguageSelector.tsx" << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'
import { ChevronDown, Search, Globe } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'
import { REGIONS, getLanguagesByRegion } from '@/data/languages/worldLanguages'

export default function LanguageSelector() {
  const { language, setLanguage, availableLanguages, isRTL } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedRegion, setSelectedRegion] = useState<string>('all')
  const dropdownRef = useRef<HTMLDivElement>(null)

  const currentLanguage = availableLanguages.find(lang => lang.code === language)

  // Fermer le dropdown quand on clique ailleurs
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filtrer les langues
  const filteredLanguages = availableLanguages.filter(lang => {
    const matchesSearch = lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesRegion = selectedRegion === 'all' || lang.region === selectedRegion
    return matchesSearch && matchesRegion
  })

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white hover:bg-gray-50 border border-gray-300 rounded-xl px-4 py-3 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[200px]"
        dir={isRTL ? 'rtl' : 'ltr'}
      >
        <Globe className="w-5 h-5 text-blue-600" />
        <span className="text-2xl">{currentLanguage?.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-semibold text-gray-900">{currentLanguage?.nativeName}</div>
          <div className="text-sm text-gray-500">{currentLanguage?.name}</div>
        </div>
        <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 max-h-96 overflow-hidden">
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100">
            <div className="relative mb-3">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            
            {/* Filtres par région */}
            <div className="flex flex-wrap gap-2">
              <button
                onClick={() => setSelectedRegion('all')}
                className={`px-3 py-1 rounded-full text-sm transition-all ${
                  selectedRegion === 'all' 
                    ? 'bg-blue-600 text-white' 
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                Toutes
              </button>
              {REGIONS.map(region => (
                <button
                  key={region}
                  onClick={() => setSelectedRegion(region)}
                  className={`px-3 py-1 rounded-full text-sm transition-all ${
                    selectedRegion === region 
                      ? 'bg-blue-600 text-white' 
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {region}
                </button>
              ))}
            </div>
          </div>

          {/* Liste des langues avec scroll */}
          <div className="max-h-64 overflow-y-auto">
            {filteredLanguages.length === 0 ? (
              <div className="p-4 text-center text-gray-500">
                Aucune langue trouvée
              </div>
            ) : (
              filteredLanguages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => handleLanguageSelect(lang.code)}
                  className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-blue-50 transition-all text-left ${
                    lang.code === language ? 'bg-blue-100 border-r-4 border-blue-600' : ''
                  }`}
                  dir={lang.rtl ? 'rtl' : 'ltr'}
                >
                  <span className="text-2xl">{lang.flag}</span>
                  <div className="flex-1">
                    <div className="font-semibold text-gray-900">{lang.nativeName}</div>
                    <div className="text-sm text-gray-500">{lang.name} • {lang.region}</div>
                  </div>
                  {lang.rtl && (
                    <span className="text-xs bg-purple-100 text-purple-700 px-2 py-1 rounded-full">
                      RTL
                    </span>
                  )}
                  {lang.code === language && (
                    <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                  )}
                </button>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="p-3 border-t border-gray-100 bg-gray-50 text-center">
            <p className="text-xs text-gray-500">
              195+ langues supportées • Traduction native • Support RTL
            </p>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

# 9. Navigation avec menu responsive
cat > "${SRC_DIR}/components/navigation/Navigation.tsx" << 'EOF'
'use client'

import Link from 'next/link'
import { useState } from 'react'
import { Calculator, Menu, X, Home, BookOpen, Gamepad2, BarChart3, CreditCard, User } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false)
  const { t, isRTL } = useLanguage()

  const navItems = [
    { 
      href: '/', 
      label: t('home') || 'Accueil', 
      desc: 'Page principale', 
      icon: Home 
    },
    { 
      href: '/exercises', 
      label: t('exercises') || 'Exercices', 
      desc: 'Pratiquer les maths', 
      icon: BookOpen 
    },
    { 
      href: '/games', 
      label: t('games') || 'Jeux', 
      desc: 'Apprendre en jouant', 
      icon: Gamepad2 
    },
    { 
      href: '/dashboard', 
      label: t('dashboard') || 'Tableau de bord', 
      desc: 'Suivre les progrès', 
      icon: BarChart3 
    },
    { 
      href: '/pricing', 
      label: t('pricing') || 'Plans', 
      desc: 'Choisir un abonnement', 
      icon: CreditCard 
    },
  ]

  return (
    <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 shadow-sm">
      <div className="max-w-6xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-3 hover:scale-105 transition-transform">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-2 rounded-xl shadow-lg">
              <Calculator className="w-7 h-7 text-white" />
            </div>
            <div>
              <span className="font-black text-2xl bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Math4Child
              </span>
              <div className="text-xs text-gray-500 font-medium">by GOTEST</div>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center space-x-2">
            {navItems.map((item) => {
              const IconComponent = item.icon
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className="group flex items-center gap-2 px-4 py-2 rounded-xl hover:bg-blue-50 transition-all duration-200"
                >
                  <IconComponent className="w-4 h-4 text-blue-600 group-hover:scale-110 transition-transform" />
                  <div>
                    <div className="text-sm font-semibold text-gray-700 group-hover:text-blue-600 transition-colors">
                      {item.label}
                    </div>
                    <div className="text-xs text-gray-500 opacity-0 group-hover:opacity-100 transition-opacity">
                      {item.desc}
                    </div>
                  </div>
                </Link>
              )
            })}
          </div>

          {/* Actions Desktop */}
          <div className="hidden lg:flex items-center space-x-3">
            <button className="flex items-center gap-2 px-4 py-2 text-gray-600 hover:text-blue-600 transition-colors">
              <User className="w-4 h-4" />
              <span className="text-sm font-medium">Se connecter</span>
            </button>
            <Link
              href="/pricing"
              className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-xl font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200"
            >
              Essai Gratuit
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="lg:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            {isOpen ? (
              <X className="w-6 h-6 text-gray-600" />
            ) : (
              <Menu className="w-6 h-6 text-gray-600" />
            )}
          </button>
        </div>

        {/* Mobile Navigation */}
        {isOpen && (
          <div className="lg:hidden py-4 border-t border-gray-200 bg-white/95 backdrop-blur-sm">
            <div className="space-y-2">
              {navItems.map((item) => {
                const IconComponent = item.icon
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-blue-50 transition-all"
                    onClick={() => setIsOpen(false)}
                  >
                    <IconComponent className="w-5 h-5 text-blue-600" />
                    <div>
                      <div className="font-semibold text-gray-700">{item.label}</div>
                      <div className="text-sm text-gray-500">{item.desc}</div>
                    </div>
                  </Link>
                )
              })}
              
              {/* Actions Mobile */}
              <div className="pt-4 mt-4 border-t border-gray-200 space-y-3">
                <button 
                  className="flex items-center gap-3 w-full px-4 py-3 text-gray-600 hover:bg-gray-50 rounded-xl transition-all"
                  onClick={() => setIsOpen(false)}
                >
                  <User className="w-5 h-5" />
                  <span className="font-medium">Se connecter</span>
                </button>
                <Link
                  href="/pricing"
                  className="block bg-gradient-to-r from-blue-600 to-purple-600 text-white text-center px-6 py-3 rounded-xl font-semibold mx-4"
                  onClick={() => setIsOpen(false)}
                >
                  Essai Gratuit (7 jours)
                </Link>
              </div>
            </div>
          </div>
        )}
      </div>
    </nav>
  )
}
EOF

# 6. Page d'accueil révolutionnaire
cat > "${SRC_DIR}/app/page.tsx" << 'EOF'
'use client'

import Link from 'next/link'
import { useState, useEffect } from 'react'
import { Calculator, Globe, TrendingUp, Award, Users, Zap, Play, BookOpen, Trophy, Star } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageSelector from '@/components/language/LanguageSelector'
import PricingModal from '@/components/pricing/PricingModal'

export default function HomePage() {
  const [showPricing, setShowPricing] = useState(false)
  const [stats, setStats] = useState({ users: 0, questions: 0, countries: 0 })
  const { t, language } = useLanguage()

  // Animation des statistiques
  useEffect(() => {
    const timer = setInterval(() => {
      setStats(prev => ({
        users: Math.min(prev.users + 47, 125847),
        questions: Math.min(prev.questions + 1247, 8547293),
        countries: Math.min(prev.countries + 1, 67)
      }))
    }, 50)

    const timeout = setTimeout(() => clearInterval(timer), 3000)
    return () => {
      clearInterval(timer)
      clearTimeout(timeout)
    }
  }, [])

  return (
    <div className="min-h-screen" dir={language === 'ar' ? 'rtl' : 'ltr'}>
      {/* Hero Section avec animations */}
      <section className="relative overflow-hidden py-20 px-4">
        {/* Background animation */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-blue-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-pulse"></div>
        </div>

        <div className="relative max-w-6xl mx-auto text-center">
          {/* Logo animé */}
          <div className="flex justify-center mb-8">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-6 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300 float">
              <Calculator className="w-20 h-20 text-white" />
            </div>
          </div>
          
          {/* Titre principal avec animation */}
          <div className="mb-8">
            <h1 className="text-6xl md:text-8xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-4 animate-pulse">
              Math4Child
            </h1>
            <div className="flex items-center justify-center gap-2 mb-4">
              <span className="bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-sm font-bold">
                🌟 #1 App Éducative
              </span>
              <span className="bg-green-400 text-green-900 px-3 py-1 rounded-full text-sm font-bold">
                ✨ 195+ Langues
              </span>
            </div>
            <p className="text-2xl md:text-3xl text-gray-700 font-semibold max-w-4xl mx-auto">
              {t('subtitle')}
            </p>
          </div>
          
          {/* Statistiques animées */}
          <div className="grid grid-cols-3 gap-6 max-w-2xl mx-auto mb-12">
            <StatCard number={stats.users.toLocaleString()} label="Familles utilisatrices" icon="👨‍👩‍👧‍👦" />
            <StatCard number={stats.questions.toLocaleString()} label="Questions résolues" icon="🧮" />
            <StatCard number={stats.countries} label="Pays actifs" icon="🌍" />
          </div>
          
          {/* Boutons d'action principaux */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-10 py-5 rounded-2xl font-bold text-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Play className="w-6 h-6 group-hover:animate-bounce" />
              {t('startAdventure')}
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="group bg-white text-blue-600 px-10 py-5 rounded-2xl font-bold text-xl border-3 border-blue-600 hover:bg-blue-50 hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Trophy className="w-6 h-6 group-hover:animate-pulse" />
              {t('viewPlans')}
            </button>
          </div>

          {/* Sélecteur de langues avec style amélioré */}
          <div className="mb-8">
            <div className="inline-block bg-white/80 backdrop-blur-sm rounded-2xl p-4 shadow-lg">
              <LanguageSelector />
            </div>
          </div>

          {/* Badges de confiance */}
          <div className="flex flex-wrap justify-center gap-4 mb-8">
            <TrustBadge icon="🏆" text="Récompensé UNESCO" />
            <TrustBadge icon="🔒" text="Sécurisé RGPD" />
            <TrustBadge icon="⭐" text="Note 4.9/5" />
            <TrustBadge icon="👨‍👩‍👧‍👦" text="Approuvé Parents" />
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités Révolutionnaires */}
      <section className="py-20 px-4 bg-white relative overflow-hidden">
        <div className="absolute inset-0">
          <div className="absolute top-20 left-10 w-32 h-32 bg-blue-200 rounded-full opacity-20 animate-ping"></div>
          <div className="absolute bottom-20 right-10 w-24 h-24 bg-purple-200 rounded-full opacity-20 animate-ping delay-1000"></div>
        </div>
        
        <div className="relative max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Pourquoi Math4Child Révolutionne l'Apprentissage ?
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Une technologie d'avant-garde qui s'adapte à chaque enfant pour maximiser l'apprentissage
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <FeatureCard
              icon={<TrendingUp className="w-12 h-12" />}
              title={t('features.aiAdaptive.title')}
              description={t('features.aiAdaptive.description')}
              color="from-green-500 to-emerald-500"
              delay="0"
            />
            <FeatureCard
              icon={<Globe className="w-12 h-12" />}
              title={t('features.multiLanguage.title')}
              description={t('features.multiLanguage.description')}
              color="from-blue-500 to-cyan-500"
              delay="200"
            />
            <FeatureCard
              icon={<Award className="w-12 h-12" />}
              title={t('features.fiveLevels.title')}
              description={t('features.fiveLevels.description')}
              color="from-purple-500 to-pink-500"
              delay="400"
            />
            <FeatureCard
              icon={<Calculator className="w-12 h-12" />}
              title={t('features.fiveOperations.title')}
              description={t('features.fiveOperations.description')}
              color="from-orange-500 to-red-500"
              delay="600"
            />
            <FeatureCard
              icon={<Users className="w-12 h-12" />}
              title={t('features.familyMode.title')}
              description={t('features.familyMode.description')}
              color="from-indigo-500 to-purple-500"
              delay="800"
            />
            <FeatureCard
              icon={<Zap className="w-12 h-12" />}
              title={t('features.motivation.title')}
              description={t('features.motivation.description')}
              color="from-yellow-500 to-orange-500"
              delay="1000"
            />
          </div>
        </div>
      </section>

      {/* Section Niveaux de Progression */}
      <section className="py-20 px-4 bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              5 Niveaux de Progression Adaptatifs
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Chaque niveau nécessite 100 bonnes réponses pour débloquer le suivant. 
              Accès permanent aux niveaux validés.
            </p>
          </div>
          
          <div className="grid md:grid-cols-5 gap-6">
            {[1, 2, 3, 4, 5].map((level, index) => (
              <LevelCard
                key={level}
                level={level}
                name={t(`levels.${['beginner', 'elementary', 'intermediate', 'advanced', 'expert'][index]}`)}
                progress={level <= 2 ? 100 : level === 3 ? 65 : 0}
                isUnlocked={level <= 3}
                delay={index * 200}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Section Opérations Mathématiques */}
      <section className="py-20 px-4 bg-white">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              5 Opérations Mathématiques Complètes
            </h2>
          </div>
          
          <div className="grid md:grid-cols-5 gap-6">
            {[
              { op: 'addition', symbol: '+', color: 'from-green-400 to-blue-500' },
              { op: 'subtraction', symbol: '−', color: 'from-blue-400 to-purple-500' },
              { op: 'multiplication', symbol: '×', color: 'from-purple-400 to-pink-500' },
              { op: 'division', symbol: '÷', color: 'from-pink-400 to-red-500' },
              { op: 'mixed', symbol: '∞', color: 'from-red-400 to-orange-500' }
            ].map((operation, index) => (
              <OperationCard
                key={operation.op}
                operation={operation.op}
                symbol={operation.symbol}
                name={t(`operations.${operation.op}`)}
                color={operation.color}
                delay={index * 150}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Section Témoignages */}
      <section className="py-20 px-4 bg-gradient-to-br from-purple-50 to-pink-50">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Ce que Disent les Familles
            </h2>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <TestimonialCard
              name="Marie Dubois"
              country="🇫🇷 France"
              text="Mon fils de 8 ans adore Math4Child ! Il a progressé de 3 niveaux en 2 mois. L'IA s'adapte parfaitement à son rythme."
              rating={5}
            />
            <TestimonialCard
              name="Ahmed Al-Rashid"
              country="🇲🇦 Maroc"
              text="تطبيق رائع! ابنتي تتعلم الرياضيات باللغة العربية والفرنسية. الدعم متعدد اللغات مذهل."
              rating={5}
            />
            <TestimonialCard
              name="Sarah Johnson"
              country="🇺🇸 USA"
              text="Best math app ever! My twins love the family mode. The progress tracking helps me understand their strengths."
              rating={5}
            />
          </div>
        </div>
      </section>

      {/* Section CTA Final */}
      <section className="py-20 px-4 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 relative overflow-hidden">
        <div className="absolute inset-0">
          <div className="absolute top-0 left-0 w-full h-full bg-black opacity-10"></div>
          <div className="absolute -top-20 -left-20 w-40 h-40 bg-white rounded-full opacity-10 animate-pulse"></div>
          <div className="absolute -bottom-20 -right-20 w-60 h-60 bg-white rounded-full opacity-10 animate-pulse delay-1000"></div>
        </div>
        
        <div className="relative max-w-4xl mx-auto text-center">
          <h2 className="text-5xl font-black text-white mb-6">
            Prêt à Révolutionner l'Apprentissage ?
          </h2>
          <p className="text-2xl text-blue-100 mb-8">
            Rejoins des milliers d'enfants qui transforment déjà leurs mathématiques en aventures !
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-8">
            <Link 
              href="/exercises"
              className="group bg-white text-blue-600 px-10 py-5 rounded-2xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <BookOpen className="w-6 h-6 group-hover:animate-bounce" />
              Essayer Gratuitement (7 jours)
            </Link>
            <Link 
              href="/dashboard"
              className="group bg-blue-700 text-white px-10 py-5 rounded-2xl font-bold text-xl hover:bg-blue-800 transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <TrendingUp className="w-6 h-6 group-hover:animate-pulse" />
              Voir le Tableau de Bord
            </Link>
          </div>
          
          <div className="text-white/80 text-sm">
            🚀 Lancement commercial imminent • www.math4child.com • Développé par GOTEST
          </div>
        </div>
      </section>

      {/* Modal de Pricing */}
      {showPricing && (
        <PricingModal onClose={() => setShowPricing(false)} />
      )}
    </div>
  )
}

// Composants auxiliaires
function StatCard({ number, label, icon }: { number: string; label: string; icon: string }) {
  return (
    <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300">
      <div className="text-3xl mb-2">{icon}</div>
      <div className="text-3xl font-black text-blue-600 mb-1">{number}</div>
      <div className="text-sm text-gray-600">{label}</div>
    </div>
  )
}

function TrustBadge({ icon, text }: { icon: string; text: string }) {
  return (
    <div className="flex items-center gap-2 bg-white/60 backdrop-blur-sm px-4 py-2 rounded-full text-sm font-medium text-gray-700">
      <span className="text-lg">{icon}</span>
      {text}
    </div>
  )
}

function FeatureCard({ icon, title, description, color, delay }: {
  icon: React.ReactNode
  title: string
  description: string
  color: string
  delay: string
}) {
  return (
    <div 
      className="group bg-gradient-to-br from-white to-blue-50 p-8 rounded-3xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:scale-105 border border-blue-100"
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className={`bg-gradient-to-r ${color} p-4 rounded-2xl w-fit mb-6 group-hover:animate-pulse`}>
        <div className="text-white">
          {icon}
        </div>
      </div>
      <h3 className="text-2xl font-bold mb-4 group-hover:text-blue-600 transition-colors">{title}</h3>
      <p className="text-gray-600 group-hover:text-gray-700 transition-colors">{description}</p>
    </div>
  )
}

function LevelCard({ level, name, progress, isUnlocked, delay }: {
  level: number
  name: string
  progress: number
  isUnlocked: boolean
  delay: number
}) {
  return (
    <div 
      className={`relative p-6 rounded-2xl shadow-lg transition-all duration-500 transform hover:scale-105 ${
        isUnlocked 
          ? 'bg-gradient-to-br from-green-400 to-blue-500 text-white' 
          : 'bg-gray-200 text-gray-500'
      }`}
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className="text-center">
        <div className="text-4xl font-black mb-2">
          {isUnlocked ? '✅' : '🔒'} {level}
        </div>
        <h3 className="font-bold text-lg mb-3">{name}</h3>
        
        {/* Barre de progression */}
        <div className="w-full bg-white/30 rounded-full h-2 mb-2">
          <div 
            className="bg-white h-2 rounded-full transition-all duration-1000"
            style={{ width: `${progress}%` }}
          ></div>
        </div>
        <div className="text-sm opacity-80">
          {progress === 100 ? 'Complété !' : `${progress}/100 bonnes réponses`}
        </div>
      </div>
    </div>
  )
}

function OperationCard({ operation, symbol, name, color, delay }: {
  operation: string
  symbol: string
  name: string
  color: string
  delay: number
}) {
  return (
    <Link
      href={`/exercises?operation=${operation}`}
      className={`group block p-8 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:scale-105 bg-gradient-to-br ${color} text-white`}
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className="text-center">
        <div className="text-6xl font-black mb-4 group-hover:animate-bounce">
          {symbol}
        </div>
        <h3 className="font-bold text-xl mb-2">{name}</h3>
        <div className="text-sm opacity-80">
          Cliquer pour commencer
        </div>
      </div>
    </Link>
  )
}

function TestimonialCard({ name, country, text, rating }: {
  name: string
  country: string
  text: string
  rating: number
}) {
  return (
    <div className="bg-white p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300">
      <div className="flex items-center mb-4">
        {[...Array(rating)].map((_, i) => (
          <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
        ))}
      </div>
      <p className="text-gray-600 mb-6 italic">"{text}"</p>
      <div className="flex items-center">
        <div className="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-white font-bold mr-4">
          {name[0]}
        </div>
        <div>
          <div className="font-bold">{name}</div>
          <div className="text-sm text-gray-500">{country}</div>
        </div>
      </div>
    </div>
  )
}
EOF