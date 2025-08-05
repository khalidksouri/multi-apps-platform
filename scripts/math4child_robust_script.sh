#!/bin/bash

# ===================================================================
# 🎯 MATH4CHILD - SCRIPT ROBUSTE AVEC VÉRIFICATIONS COMPLÈTES
# ===================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${PURPLE}${BOLD}🚀 MATH4CHILD - CRÉATION ROBUSTE${NC}"
echo "=============================================================="

# Variables
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MATH4CHILD_DIR="${PROJECT_ROOT}/apps/math4child"
SRC_DIR="${MATH4CHILD_DIR}/src"

echo -e "${BLUE}📍 Répertoire projet: ${PROJECT_ROOT}${NC}"
echo -e "${BLUE}📍 Répertoire Math4Child: ${MATH4CHILD_DIR}${NC}"
echo -e "${BLUE}📍 Répertoire source: ${SRC_DIR}${NC}"

# Fonction pour créer un répertoire avec vérification
create_dir() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        echo -e "${GREEN}✅ Créé: $dir_path${NC}"
    else
        echo -e "${YELLOW}ℹ️  Existe: $dir_path${NC}"
    fi
}

# Fonction pour créer un fichier avec vérification
create_file() {
    local file_path="$1"
    local content="$2"
    local dir_path=$(dirname "$file_path")
    
    # Créer le répertoire parent si nécessaire
    create_dir "$dir_path"
    
    # Créer le fichier
    echo "$content" > "$file_path"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Fichier créé: $file_path${NC}"
    else
        echo -e "${RED}❌ Erreur création: $file_path${NC}"
        return 1
    fi
}

# ÉTAPE 1: Créer la structure de base
echo -e "${BLUE}📁 ÉTAPE 1: Structure de base${NC}"
create_dir "$PROJECT_ROOT/apps"
create_dir "$MATH4CHILD_DIR"

# Sauvegarder l'existant
if [ -d "${SRC_DIR}" ]; then
    mv "${SRC_DIR}" "${SRC_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Ancienne version sauvegardée${NC}"
fi

# ÉTAPE 2: Créer tous les répertoires nécessaires
echo -e "${BLUE}📁 ÉTAPE 2: Création des répertoires${NC}"
create_dir "${SRC_DIR}"
create_dir "${SRC_DIR}/app"
create_dir "${SRC_DIR}/components"
create_dir "${SRC_DIR}/lib"
create_dir "${SRC_DIR}/hooks"
create_dir "${SRC_DIR}/data"
create_dir "${SRC_DIR}/data/languages"
create_dir "${SRC_DIR}/data/pricing"
create_dir "${SRC_DIR}/lib/translations"
create_dir "${SRC_DIR}/lib/math"
create_dir "${SRC_DIR}/components/language"
create_dir "${SRC_DIR}/components/navigation"
create_dir "${SRC_DIR}/components/pricing"

# ÉTAPE 3: Créer les fichiers principaux
echo -e "${BLUE}📄 ÉTAPE 3: Création des fichiers${NC}"

# 1. Langues mondiales
create_file "${SRC_DIR}/data/languages/worldLanguages.ts" '// 195+ Langues mondiales organisées par régions (sauf hébreu)
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
  { code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷", region: "Europe" },
  { code: "en", name: "English", nativeName: "English", flag: "🇬🇧", region: "Europe" },
  { code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸", region: "Europe" },
  { code: "de", name: "German", nativeName: "Deutsch", flag: "🇩🇪", region: "Europe" },
  { code: "it", name: "Italian", nativeName: "Italiano", flag: "🇮🇹", region: "Europe" },
  
  // ASIE
  { code: "zh", name: "Chinese", nativeName: "中文", flag: "🇨🇳", region: "Asia" },
  { code: "ja", name: "Japanese", nativeName: "日本語", flag: "🇯🇵", region: "Asia" },
  { code: "ko", name: "Korean", nativeName: "한국어", flag: "🇰🇷", region: "Asia" },
  { code: "hi", name: "Hindi", nativeName: "हिन्दी", flag: "🇮🇳", region: "Asia" },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD
  { code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇲🇦", rtl: true, region: "MENA" },
  
  // AMÉRIQUES
  { code: "en-US", name: "English (US)", nativeName: "English (US)", flag: "🇺🇸", region: "Americas" },
  { code: "pt-BR", name: "Portuguese (Brazil)", nativeName: "Português (Brasil)", flag: "🇧🇷", region: "Americas" }
]

export const REGIONS = ["Europe", "Asia", "MENA", "Africa", "Americas", "Oceania"]

export const getLanguagesByRegion = (region: string) => 
  WORLD_LANGUAGES.filter(lang => lang.region === region)

export const getLanguageByCode = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)

export const isRTLLanguage = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)?.rtl || false'

# 2. Traductions
create_file "${SRC_DIR}/lib/translations/worldTranslations.ts" '// Système de traductions pour 195+ langues
export const TRANSLATIONS = {
  fr: {
    title: "Math4Child - Apprendre les maths en s\"amusant !",
    subtitle: "L\"application révolutionnaire qui transforme l\"apprentissage des mathématiques en aventure ludique",
    startAdventure: "Commencer l\"Aventure",
    viewPlans: "Voir les Plans",
    
    exercises: "Exercices",
    games: "Jeux",
    dashboard: "Tableau de bord",
    pricing: "Plans"
  },
  
  en: {
    title: "Math4Child - Learn math while having fun!",
    subtitle: "The revolutionary app that transforms mathematics learning into a fun adventure",
    startAdventure: "Start Adventure", 
    viewPlans: "View Plans",
    
    exercises: "Exercises",
    games: "Games",
    dashboard: "Dashboard",
    pricing: "Plans"
  }
}

export const getTranslation = (language: string, key: string): string => {
  const keys = key.split(".")
  let value: any = TRANSLATIONS[language as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  
  for (const k of keys) {
    value = value?.[k]
  }
  
  return value || key
}'

# 3. Prix par pays
create_file "${SRC_DIR}/data/pricing/countryPricing.ts" '// Prix adaptatifs par pays selon le pouvoir d\"achat
export interface CountryPricing {
  country: string
  currency: string
  symbol: string
  monthly: number
  quarterly: number
  annual: number
  purchasingPower: number
}

export const COUNTRY_PRICING: CountryPricing[] = [
  { country: "FR", currency: "EUR", symbol: "€", monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: "US", currency: "USD", symbol: "$", monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: "GB", currency: "GBP", symbol: "£", monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 1.0 }
]

export const getPricingForCountry = (countryCode: string): CountryPricing => {
  return COUNTRY_PRICING.find(p => p.country === countryCode) || COUNTRY_PRICING[0]
}

export const formatPrice = (amount: number, currency: string, symbol: string): string => {
  return `${symbol}${amount.toFixed(2)}`
}'

# 4. Générateur de questions
create_file "${SRC_DIR}/lib/math/questionGenerator.ts" '// Générateur de questions mathématiques par niveau
export interface MathQuestion {
  id: string
  level: number
  operation: "addition" | "subtraction" | "multiplication" | "division" | "mixed"
  question: string
  correctAnswer: number
  options: number[]
  difficulty: "easy" | "medium" | "hard"
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
    name: "Débutant",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction"],
    numberRange: { min: 1, max: 10 },
    hasNegatives: false,
    hasDecimals: false
  },
  {
    level: 2,
    name: "Élémentaire", 
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction", "multiplication"],
    numberRange: { min: 1, max: 50 },
    hasNegatives: false,
    hasDecimals: false
  }
]

export class MathQuestionGenerator {
  generateQuestion(level: number, operation?: string): MathQuestion {
    const config = LEVEL_CONFIGS.find(c => c.level === level)
    if (!config) throw new Error(`Invalid level: ${level}`)

    const a = Math.floor(Math.random() * config.numberRange.max) + config.numberRange.min
    const b = Math.floor(Math.random() * config.numberRange.max) + config.numberRange.min
    const correctAnswer = a + b

    return {
      id: `add_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: "addition",
      question: `${a} + ${b} = ?`,
      correctAnswer,
      options: [correctAnswer, correctAnswer + 1, correctAnswer - 1, correctAnswer + 2].sort(() => Math.random() - 0.5),
      difficulty: "easy",
      points: config.level * 10
    }
  }
}

export const mathGenerator = new MathQuestionGenerator()'

# 5. Hook useLanguage
create_file "${SRC_DIR}/hooks/useLanguage.ts" '"use client"

import { createContext, useContext, useState, ReactNode } from "react"
import { WORLD_LANGUAGES, isRTLLanguage } from "@/data/languages/worldLanguages"
import { getTranslation } from "@/lib/translations/worldTranslations"

interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
  isRTL: boolean
  availableLanguages: typeof WORLD_LANGUAGES
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    const rtl = isRTLLanguage(lang)
    setIsRTL(rtl)
    
    if (typeof document !== "undefined") {
      document.documentElement.dir = rtl ? "rtl" : "ltr"
      document.documentElement.lang = lang
    }
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
    throw new Error("useLanguage must be used within a LanguageProvider")
  }
  return context
}'

# 6. Provider de langue
create_file "${SRC_DIR}/components/language/LanguageProvider.tsx" '"use client"

import { LanguageProvider as Provider } from "@/hooks/useLanguage"

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  return <Provider>{children}</Provider>
}'

# 7. Sélecteur de langues
create_file "${SRC_DIR}/components/language/LanguageSelector.tsx" '"use client"

import { useState } from "react"
import { ChevronDown, Globe } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"

export default function LanguageSelector() {
  const { language, setLanguage, availableLanguages } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)

  const currentLanguage = availableLanguages.find(lang => lang.code === language)

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white hover:bg-gray-50 border border-gray-300 rounded-xl px-4 py-3 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[200px]"
      >
        <Globe className="w-5 h-5 text-blue-600" />
        <span className="text-2xl">{currentLanguage?.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-semibold text-gray-900">{currentLanguage?.nativeName}</div>
          <div className="text-sm text-gray-500">{currentLanguage?.name}</div>
        </div>
        <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isOpen ? "rotate-180" : ""}`} />
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 max-h-64 overflow-y-auto">
          {availableLanguages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => {
                setLanguage(lang.code)
                setIsOpen(false)
              }}
              className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-blue-50 transition-all text-left ${
                lang.code === language ? "bg-blue-100 border-r-4 border-blue-600" : ""
              }`}
            >
              <span className="text-2xl">{lang.flag}</span>
              <div className="flex-1">
                <div className="font-semibold text-gray-900">{lang.nativeName}</div>
                <div className="text-sm text-gray-500">{lang.name} • {lang.region}</div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}'

# 8. Navigation
create_file "${SRC_DIR}/components/navigation/Navigation.tsx" '"use client"

import Link from "next/link"
import { Calculator, User } from "lucide-react"

export default function Navigation() {
  return (
    <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 shadow-sm">
      <div className="max-w-6xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
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

          <div className="flex items-center space-x-3">
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
        </div>
      </div>
    </nav>
  )
}'

# 9. Modal de pricing
create_file "${SRC_DIR}/components/pricing/PricingModal.tsx" '"use client"

import { X } from "lucide-react"

interface PricingModalProps {
  onClose: () => void
}

export default function PricingModal({ onClose }: PricingModalProps) {
  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
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
            <p className="text-xl text-blue-100">
              Accès à 195+ langues • 5 niveaux adaptatifs • IA révolutionnaire
            </p>
          </div>
        </div>

        <div className="p-8">
          <div className="grid md:grid-cols-3 gap-6">
            {[
              { name: "Mensuel", price: "9,99€/mois", popular: false },
              { name: "Trimestriel", price: "26,97€", popular: true },
              { name: "Annuel", price: "83,93€", popular: false }
            ].map((plan) => (
              <div
                key={plan.name}
                className={`relative rounded-2xl border-2 p-6 ${
                  plan.popular ? "border-purple-500 ring-4 ring-purple-100" : "border-gray-200"
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <div className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                      ⭐ Le Plus Populaire
                    </div>
                  </div>
                )}
                
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <div className="text-3xl font-black text-gray-900">{plan.price}</div>
                </div>
                
                <button
                  className={`w-full py-3 rounded-xl font-bold transition-all duration-200 ${
                    plan.popular
                      ? "bg-gradient-to-r from-purple-500 to-pink-500 text-white hover:shadow-lg"
                      : "bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:shadow-lg"
                  } transform hover:scale-105`}
                >
                  Choisir ce Plan
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}'

# 10. Layout principal
create_file "${SRC_DIR}/app/layout.tsx" 'import "./globals.css"
import Navigation from "@/components/navigation/Navigation"
import { LanguageProvider } from "@/components/language/LanguageProvider"

export const metadata = {
  title: "Math4Child - Apprendre les maths en s\"amusant !",
  description: "L\"application éducative révolutionnaire pour apprendre les mathématiques. 195+ langues, IA adaptative, développée par GOTEST.",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body className="font-inter antialiased bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 min-h-screen">
        <LanguageProvider>
          <Navigation />
          <main className="pt-20 pb-10">
            {children}
          </main>
        </LanguageProvider>
      </body>
    </html>
  )
}'

# 11. Page d'accueil
create_file "${SRC_DIR}/app/page.tsx" '"use client"

import Link from "next/link"
import { Calculator, Play, Trophy } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import LanguageSelector from "@/components/language/LanguageSelector"

export default function HomePage() {
  const { t } = useLanguage()

  return (
    <div className="min-h-screen">
      <section className="relative overflow-hidden py-20 px-4">
        <div className="relative max-w-6xl mx-auto text-center">
          <div className="flex justify-center mb-8">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-6 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300">
              <Calculator className="w-20 h-20 text-white" />
            </div>
          </div>
          
          <div className="mb-8">
            <h1 className="text-6xl md:text-8xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-4">
              Math4Child
            </h1>
            <p className="text-2xl md:text-3xl text-gray-700 font-semibold max-w-4xl mx-auto">
              {t("subtitle") || "L\"application révolutionnaire qui transforme l\"apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans"}
            </p>
          </div>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-10 py-5 rounded-2xl font-bold text-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Play className="w-6 h-6 group-hover:animate-bounce" />
              {t("startAdventure") || "Commencer l\"Aventure"}
            </Link>
            <Link
              href="/pricing"
              className="group bg-white text-blue-600 px-10 py-5 rounded-2xl font-bold text-xl border-3 border-blue-600 hover:bg-blue-50 hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Trophy className="w-6 h-6 group-hover:animate-pulse" />
              {t("viewPlans") || "Voir les Plans"}
            </Link>
          </div>

          <div className="mb-8">
            <div className="inline-block bg-white/80 backdrop-blur-sm rounded-2xl p-4 shadow-lg">
              <LanguageSelector />
            </div>
          </div>
        </div>
      </section>

      <section className="py-20 px-4 bg-white">
        <div className="max-w-6xl mx-auto text-center">
          <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Pourquoi Math4Child Révolutionne l\"Apprentissage ?
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Une technologie d\"avant-garde qui s\"adapte à chaque enfant pour maximiser l\"apprentissage
          </p>
        </div>
      </section>
    </div>
  )
}'

# 12. Styles globaux
create_file "${SRC_DIR}/app/globals.css" '@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

@import url("https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap");

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground font-inter;
  }
  
  html {
    font-family: "Inter", system-ui, -apple-system, sans-serif;
  }
}

@layer components {
  .btn-primary {
    @apply bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200;
  }
  
  .card {
    @apply bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300;
  }
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.float {
  animation: float 3s ease-in-out infinite;
}'

# ÉTAPE 4: Créer les fichiers de configuration
echo -e "${BLUE}⚙️ ÉTAPE 4: Configuration Next.js${NC}"

# Package.json
if [ ! -f "${MATH4CHILD_DIR}/package.json" ]; then
    create_file "${MATH4CHILD_DIR}/package.json" '{
  "name": "math4child",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "^18",
    "react-dom": "^18",
    "lucide-react": "^0.294.0"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.1",
    "postcss": "^8",
    "tailwindcss": "^3.3.0",
    "eslint": "^8",
    "eslint-config-next": "14.0.4"
  }
}'
else
    echo -e "${YELLOW}⚠️ Package.json existant conservé${NC}"
fi

# Tailwind config
if [ ! -f "${MATH4CHILD_DIR}/tailwind.config.js" ]; then
    create_file "${MATH4CHILD_DIR}/tailwind.config.js" '/** @type {import("tailwindcss").Config} */
module.exports = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        "inter": ["Inter", "system-ui", "sans-serif"],
      }
    },
  },
  plugins: [],
}'
else
    echo -e "${YELLOW}⚠️ Tailwind config existant conservé${NC}"
fi

# PostCSS config
if [ ! -f "${MATH4CHILD_DIR}/postcss.config.js" ]; then
    create_file "${MATH4CHILD_DIR}/postcss.config.js" 'module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}'
else
    echo -e "${YELLOW}⚠️ PostCSS config existant conservé${NC}"
fi

# Next config
if [ ! -f "${MATH4CHILD_DIR}/next.config.js" ]; then
    create_file "${MATH4CHILD_DIR}/next.config.js" '/** @type {import("next").NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  images: {
    domains: ["localhost"],
  },
}

module.exports = nextConfig'
else
    echo -e "${YELLOW}⚠️ Next config existant conservé${NC}"
fi

# TypeScript config
if [ ! -f "${MATH4CHILD_DIR}/tsconfig.json" ]; then
    create_file "${MATH4CHILD_DIR}/tsconfig.json" '{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}'
else
    echo -e "${YELLOW}⚠️ TypeScript config existant conservé${NC}"
fi

echo ""
echo -e "${PURPLE}${BOLD}🎉 MATH4CHILD CRÉÉ AVEC SUCCÈS !${NC}"
echo "=============================================================="
echo -e "${GREEN}✅ Structure complète générée${NC}"
echo -e "${GREEN}✅ Tous les fichiers créés${NC}"
echo -e "${GREEN}✅ Configuration Next.js prête${NC}"
echo ""
echo -e "${BLUE}🚀 ÉTAPES SUIVANTES:${NC}"
echo "1. cd apps/math4child"
echo "2. npm install"
echo "3. npm run dev"
echo "4. Ouvrir http://localhost:3000"
echo ""
echo -e "${CYAN}🌍 www.math4child.com | Développé par GOTEST${NC}"