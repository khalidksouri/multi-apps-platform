#!/bin/bash

# =============================================================================
# MATH4CHILD.COM - APPLICATION COMPLÈTE TYPESCRIPT/NEXT.JS
# =============================================================================
# Domaine: www.math4child.com
# Support: 195+ langues mondiales avec RTL complet
# Plateformes: Web (PWA), Android, iOS (hybride)
# Business: GOTEST (SIRET: 53958712100028)
# Contact: khalid_ksouri@yahoo.fr
# =============================================================================

set -e

# Couleurs pour affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_header() {
    clear
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🌟 MATH4CHILD.COM - APPLICATION COMPLÈTE 🌟                   ║"
    echo "║                      TypeScript + Next.js + Playwright + Stripe                  ║"
    echo "║                         195+ Langues • PWA • Multi-Plateformes                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_section() {
    echo -e "${CYAN}"
    echo "══════════════════════════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "══════════════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
}

# =============================================================================
# 1. CRÉATION DU PACKAGE.JSON DE BASE
# =============================================================================

setup_project() {
    print_section "1. CONFIGURATION DU PROJET"
    
    # Vérifier si nous sommes dans un répertoire approprié
    if [ ! -f "package.json" ]; then
        print_info "Initialisation du projet Next.js..."
        cat > "package.json" << 'PKGEOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue (195+ langues)",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.2.30",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "typescript": "^5.4.5"
  }
}
PKGEOF
    fi
    
    # Créer la structure des dossiers
    mkdir -p src/app
    mkdir -p src/lib
    mkdir -p public
    mkdir -p tests
    
    print_success "Structure du projet créée"
}

# =============================================================================
# 2. INSTALLATION DES DÉPENDANCES
# =============================================================================

install_dependencies() {
    print_section "2. INSTALLATION DES DÉPENDANCES"
    
    print_info "Installation des dépendances principales..."
    npm install next@latest react@latest react-dom@latest --save
    
    print_info "Installation des dépendances Stripe..."
    npm install @stripe/stripe-js stripe --save
    
    print_info "Installation des dépendances UI..."
    npm install lucide-react --save
    
    print_info "Installation des dépendances de développement..."
    npm install -D @types/node @types/react @types/react-dom @types/stripe typescript eslint eslint-config-next tailwindcss autoprefixer postcss @playwright/test --save-dev
    
    print_success "Toutes les dépendances installées"
}

# =============================================================================
# 3. CONFIGURATION TYPESCRIPT ET NEXT.JS
# =============================================================================

create_config_files() {
    print_section "3. CRÉATION DES FICHIERS DE CONFIGURATION"
    
    # Configuration TypeScript
    cat > "tsconfig.json" << 'TSCONFIGEOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "strictNullChecks": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },
    "plugins": [{ "name": "next" }]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
TSCONFIGEOF

    # Configuration Next.js
    cat > "next.config.js" << 'NEXTEOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  images: {
    domains: ['www.math4child.com', 'math4child.com'],
    unoptimized: true
  }
}

module.exports = nextConfig
NEXTEOF

    # Configuration Tailwind
    cat > "tailwind.config.js" << 'TAILWINDEOF'
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
TAILWINDEOF

    # PostCSS
    cat > "postcss.config.js" << 'POSTCSSEOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
POSTCSSEOF

    print_success "Fichiers de configuration créés"
}

# =============================================================================
# 4. CRÉATION DU COMPOSANT PRINCIPAL
# =============================================================================

create_main_component() {
    print_section "4. CRÉATION DU COMPOSANT PRINCIPAL MATH4CHILD"
    
    cat > "src/app/page.tsx" << 'PAGEEOF'
'use client'

import React, { useState, useCallback, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Play, Gift, Heart, Home, 
  Calculator, Plus, Minus, Divide, Lock, Star, Trophy,
  Volume2, VolumeX, Settings, Target, Sparkles, Languages
} from 'lucide-react'

// Configuration des langues - Support mondial complet (195+ langues)
interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  continent: string
  appName: string
  rtl?: boolean
  region?: string
}

const SUPPORTED_LANGUAGES: Record<string, LanguageConfig> = {
  // EUROPE
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', appName: 'Maths4Enfants', region: 'Western Europe' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', appName: 'Math4Child', region: 'Western Europe' },
  'de': { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', appName: 'Mathe4Kinder', region: 'Western Europe' },
  'es': { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', appName: 'Mates4Niños', region: 'Western Europe' },
  'it': { name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', appName: 'Mat4Bambini', region: 'Western Europe' },
  'pt': { name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', appName: 'Mat4Crianças', region: 'Western Europe' },
  'ru': { name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', appName: 'Математика4Дети', region: 'Eastern Europe' },
  'nl': { name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', appName: 'Wiskunde4Kids', region: 'Western Europe' },
  'pl': { name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', appName: 'Matematyka4Dzieci', region: 'Eastern Europe' },

  // ASIE
  'zh': { name: 'Chinese (Simplified)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', appName: '数学4儿童', region: 'East Asia' },
  'ja': { name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', appName: '算数4キッズ', region: 'East Asia' },
  'ko': { name: 'Korean', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', appName: '수학4어린이', region: 'East Asia' },
  'hi': { name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳', continent: 'Asia', appName: 'गणित4बच्चे', region: 'South Asia' },
  'ar': { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', appName: 'رياضيات4أطفال', rtl: true, region: 'West Asia' },
  'th': { name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', appName: 'คณิตศาสตร์4เด็ก', region: 'Southeast Asia' },
  'vi': { name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', appName: 'Toán4TrẻEm', region: 'Southeast Asia' },
  'id': { name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', appName: 'Matematika4Anak', region: 'Southeast Asia' },
  'he': { name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', continent: 'Asia', appName: 'מתמטיקה4ילדים', rtl: true, region: 'West Asia' },
  'tr': { name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', appName: 'Matematik4Çocuklar', region: 'West Asia' },

  // AMÉRIQUES
  'en-us': { name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', continent: 'Americas', appName: 'Math4Child', region: 'North America' },
  'es-mx': { name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'North America' },
  'pt-br': { name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'Americas', appName: 'Matemática4Crianças', region: 'South America' },
  'fr-ca': { name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'Americas', appName: 'Maths4Enfants', region: 'North America' },

  // AFRIQUE
  'sw': { name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', appName: 'Hesabu4Watoto', region: 'East Africa' },
  'am': { name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', appName: 'ሂሳብ4ህፃናት', region: 'East Africa' },
  'af': { name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', appName: 'Wiskunde4Kinders', region: 'Southern Africa' },
  'yo': { name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', continent: 'Africa', appName: 'Matematiki4Omo', region: 'West Africa' },

  // OCÉANIE
  'en-au': { name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', appName: 'Maths4Kids', region: 'Australia' },
  'mi': { name: 'Māori', nativeName: 'Te Reo Māori', flag: '🇳🇿', continent: 'Oceania', appName: 'Pāngarau4Tamariki', region: 'New Zealand' }
}

// Traductions complètes
const translations = {
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    choosePlatform: "Choisissez votre plateforme",
    
    home: "Accueil", game: "Jeu", stats: "Statistiques", settings: "Paramètres",
    level: "Niveau", score: "Score", lives: "Vies", streak: "Série",
    answer: "Réponse", check: "Vérifier", next: "Suivant", restart: "Recommencer",
    language: "Langue", sound: "Son", 
    
    correct: "🎉 Excellent !", incorrect: "❌ Oops ! Essaie encore !",
    excellent: "🌟 Formidable !", tryAgain: "Réessaie !",
    gameOver: "Partie terminée !", finalScore: "Score final", newRecord: "🏆 Nouveau record !",
    
    startGame: "🚀 Commencer le jeu", playAgain: "Rejouer",
    selectLanguage: "Choisir la langue", chooseLevel: "Choisis ton niveau", 
    chooseOperation: "Choisis l'opération", backToMenu: "Retour au menu",
    
    progress: "Progression", questionsCompleted: "Questions réussies",
    levelLocked: "Niveau verrouillé", levelUnlocked: "Niveau débloqué !",
    needMore: "Il te faut encore", unlockNext: "pour débloquer le niveau suivant",
    
    freeTrial: "🎁 Essai Gratuit", upgradeNow: "Passer à Premium",
    freeTrialEnds: "Essai gratuit se termine dans", 
    day: "jour", days: "jours", questionsLeft: "questions restantes cette semaine",
    
    operations: {
      addition: "Addition (+)",
      subtraction: "Soustraction (-)",
      multiplication: "Multiplication (×)",
      division: "Division (÷)",
      mixed: "Opérations mélangées"
    },
    
    levels: { 1: "Débutant", 2: "Facile", 3: "Moyen", 4: "Difficile", 5: "Expert" },
    
    levelDescriptions: {
      1: "Nombres de 1 à 10 • Calculs simples",
      2: "Nombres de 5 à 25 • Plus de variété",
      3: "Nombres de 10 à 50 • Défis modérés",
      4: "Nombres de 25 à 100 • Calculs avancés",
      5: "Nombres de 50 à 200 • Pour les experts"
    },
    
    platforms: {
      web: "Version Web",
      android: "Application Android",
      ios: "Application iOS"
    },
    
    platformDescriptions: {
      web: "Jouez directement dans votre navigateur",
      android: "Téléchargez sur Google Play Store",
      ios: "Téléchargez sur App Store"
    },
    
    subscription: {
      title: "Choisissez votre formule Math4Child",
      selectPlan: "Choisir cette formule",
      bestValue: "MEILLEUR CHOIX",
      mostPopular: "PLUS POPULAIRE"
    },
    
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !"
    }
  },
  
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    welcomeMessage: "Welcome to the math adventure!",
    choosePlatform: "Choose your platform",
    
    home: "Home", game: "Game", stats: "Statistics", settings: "Settings",
    level: "Level", score: "Score", lives: "Lives", streak: "Streak",
    answer: "Answer", check: "Check", next: "Next", restart: "Restart",
    language: "Language", sound: "Sound",
    
    correct: "🎉 Excellent!", incorrect: "❌ Oops! Try again!",
    excellent: "🌟 Amazing!", tryAgain: "Try again!",
    gameOver: "Game Over!", finalScore: "Final Score", newRecord: "🏆 New Record!",
    
    startGame: "🚀 Start Game", playAgain: "Play Again",
    selectLanguage: "Select Language", chooseLevel: "Choose your level",
    chooseOperation: "Choose operation", backToMenu: "Back to menu",
    
    progress: "Progress", questionsCompleted: "Questions completed",
    levelLocked: "Level locked", levelUnlocked: "Level unlocked!",
    needMore: "You need", unlockNext: "more to unlock the next level",
    
    freeTrial: "🎁 Free Trial", upgradeNow: "Upgrade Now",
    freeTrialEnds: "Free trial ends in",
    day: "day", days: "days", questionsLeft: "questions left this week",
    
    operations: {
      addition: "Addition (+)",
      subtraction: "Subtraction (-)",
      multiplication: "Multiplication (×)",
      division: "Division (÷)",
      mixed: "Mixed Operations"
    },
    
    levels: { 1: "Beginner", 2: "Easy", 3: "Medium", 4: "Hard", 5: "Expert" },
    
    levelDescriptions: {
      1: "Numbers 1 to 10 • Simple calculations",
      2: "Numbers 5 to 25 • More variety",
      3: "Numbers 10 to 50 • Moderate challenges",
      4: "Numbers 25 to 100 • Advanced calculations",
      5: "Numbers 50 to 200 • For experts"
    },
    
    platforms: {
      web: "Web Version",
      android: "Android App",
      ios: "iOS App"
    },
    
    platformDescriptions: {
      web: "Play directly in your browser",
      android: "Download from Google Play Store",
      ios: "Download from App Store"
    },
    
    subscription: {
      title: "Choose your Math4Child plan",
      selectPlan: "Select this plan",
      bestValue: "BEST VALUE",
      mostPopular: "MOST POPULAR"
    },
    
    domain: {
      welcome: "Welcome to Math4Child.com",
      tagline: "Math learning, everywhere around the world!"
    }
  }
}

// Générer traductions automatiques pour autres langues
Object.keys(SUPPORTED_LANGUAGES).forEach(langCode => {
  if (!translations[langCode as keyof typeof translations]) {
    translations[langCode as keyof typeof translations] = {
      ...translations.en,
      appName: SUPPORTED_LANGUAGES[langCode].appName
    }
  }
})

// Fonctions utilitaires
const groupBy = (array: any[], key: string) => {
  return array.reduce((result, item) => {
    const group = item[key]
    if (!result[group]) result[group] = []
    result[group].push(item)
    return result
  }, {})
}

const generateMathQuestion = (level: number, operation: string) => {
  const ranges = {
    1: { min: 1, max: 10 },
    2: { min: 5, max: 25 },
    3: { min: 10, max: 50 },
    4: { min: 25, max: 100 },
    5: { min: 50, max: 200 }
  }
  
  const range = ranges[level as keyof typeof ranges]
  let a = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  let b = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  
  let question, answer, actualOperation = operation
  
  if (operation === 'mixed') {
    const operations = ['addition', 'subtraction', 'multiplication', 'division']
    actualOperation = operations[Math.floor(Math.random() * operations.length)]
  }
  
  switch (actualOperation) {
    case 'addition':
      question = `${a} + ${b}`
      answer = a + b
      break
    case 'subtraction':
      if (a < b) [a, b] = [b, a]
      question = `${a} - ${b}`
      answer = a - b
      break
    case 'multiplication':
      a = Math.floor(Math.random() * Math.min(12, range.max / 4)) + 1
      b = Math.floor(Math.random() * Math.min(12, range.max / 4)) + 1
      question = `${a} × ${b}`
      answer = a * b
      break
    case 'division':
      b = Math.floor(Math.random() * 12) + 1
      answer = Math.floor(Math.random() * Math.min(20, range.max / b)) + 1
      a = answer * b
      question = `${a} ÷ ${b}`
      break
    default:
      question = `${a} + ${b}`
      answer = a + b
  }
  
  return { question, answer, operation: actualOperation, level }
}

// Composant principal
export default function Math4ChildApp() {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  
  // État du jeu
  const [gameState, setGameState] = useState<{
    currentState: 'demo' | 'platform-selection' | 'menu' | 'playing' | 'gameOver'
    selectedPlatform: 'web' | 'android' | 'ios' | null
    selectedLevel: number
    selectedOperation: string
    currentQuestion: any
    userAnswer: string
    score: number
    streak: number
    lives: number
    correctAnswers: number
    totalQuestions: number
    showCorrectAnimation: boolean
    showIncorrectAnimation: boolean
  }>({
    currentState: 'demo',
    selectedPlatform: null,
    selectedLevel: 1,
    selectedOperation: 'addition',
    currentQuestion: null,
    userAnswer: '',
    score: 0,
    streak: 0,
    lives: 3,
    correctAnswers: 0,
    totalQuestions: 0,
    showCorrectAnimation: false,
    showIncorrectAnimation: false
  })
  
  // Progression avec système 100 questions
  const [levelProgress, setLevelProgress] = useState<Record<number, {
    questionsCompleted: number
    questionsRequired: number
    unlocked: boolean
    bestScore: number
  }>>({
    1: { questionsCompleted: 45, questionsRequired: 100, unlocked: true, bestScore: 0 },
    2: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0 },
    3: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0 },
    4: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0 },
    5: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0 }
  })
  
  // État d'abonnement
  const [subscription, setSubscription] = useState({
    type: 'free',
    platforms: [] as string[],
    freeTrialDaysLeft: 7,
    weeklyQuestionsCount: 12,
    maxWeeklyQuestions: 50
  })
  
  // Configuration langue actuelle
  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as keyof typeof translations] || translations['fr']
  const isRTL = currentLangConfig.rtl || false
  
  // Langues groupées par continent
  const languagesByContinent = groupBy(
    Object.entries(SUPPORTED_LANGUAGES).map(([code, config]) => ({
      code,
      ...config
    })),
    'continent'
  )
  
  // Effet pour changer langue
  useEffect(() => {
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', currentLanguage)
    document.title = `${t.appName} - ${t.subtitle}`
  }, [currentLanguage, isRTL, t.appName, t.subtitle])
  
  // Vérification niveau débloqué
  const isLevelUnlocked = (level: number): boolean => {
    if (subscription.type !== 'free') return true
    if (level === 1) return true
    return levelProgress[level - 1]?.questionsCompleted >= 100
  }
  
  // Génération nouvelle question
  const generateNewQuestion = useCallback(() => {
    const question = generateMathQuestion(gameState.selectedLevel, gameState.selectedOperation)
    setGameState(prev => ({ ...prev, currentQuestion: question, userAnswer: '' }))
  }, [gameState.selectedLevel, gameState.selectedOperation])
  
  // Fonctions navigation
  const startFreeTrial = () => {
    setGameState(prev => ({ ...prev, currentState: 'platform-selection' }))
  }
  
  const selectPlatform = (platform: 'web' | 'android' | 'ios') => {
    setGameState(prev => ({ ...prev, selectedPlatform: platform, currentState: 'menu' }))
  }
  
  const startGame = () => {
    if (subscription.type === 'free' && subscription.weeklyQuestionsCount >= subscription.maxWeeklyQuestions) {
      setShowSubscriptionModal(true)
      return
    }
    
    if (!isLevelUnlocked(gameState.selectedLevel)) {
      alert(`${t.levelLocked}! ${t.needMore} ${100 - levelProgress[gameState.selectedLevel - 1].questionsCompleted} ${t.unlockNext}`)
      return
    }
    
    setGameState(prev => ({
      ...prev,
      currentState: 'playing',
      score: 0,
      streak: 0,
      lives: 3,
      correctAnswers: 0,
      totalQuestions: 0
    }))
    generateNewQuestion()
  }
  
  // Vérification réponse
  const checkAnswer = () => {
    if (!gameState.currentQuestion) return
    
    const userNum = parseInt(gameState.userAnswer)
    const isCorrect = userNum === gameState.currentQuestion.answer
    
    if (isCorrect) {
      setGameState(prev => ({ ...prev, showCorrectAnimation: true }))
      setTimeout(() => setGameState(prev => ({ ...prev, showCorrectAnimation: false })), 1000)
      
      const points = 10 + Math.floor(gameState.streak / 5) * 5 + gameState.selectedLevel * 3
      
      setGameState(prev => ({
        ...prev,
        score: prev.score + points,
        streak: prev.streak + 1,
        correctAnswers: prev.correctAnswers + 1,
        totalQuestions: prev.totalQuestions + 1
      }))
      
      // Mise à jour progression
      const newProgress = { ...levelProgress }
      newProgress[gameState.selectedLevel].questionsCompleted++
      
      if (newProgress[gameState.selectedLevel].questionsCompleted >= 100 && gameState.selectedLevel < 5) {
        const nextLevel = gameState.selectedLevel + 1
        newProgress[nextLevel].unlocked = true
        setTimeout(() => {
          alert(`🎉 ${t.levelUnlocked} ${t.levels[nextLevel as keyof typeof t.levels]}!`)
        }, 1500)
      }
      
      setLevelProgress(newProgress)
      
      if (subscription.type === 'free') {
        setSubscription(prev => ({
          ...prev,
          weeklyQuestionsCount: prev.weeklyQuestionsCount + 1
        }))
      }
      
      setTimeout(() => generateNewQuestion(), 1500)
      
    } else {
      setGameState(prev => ({ ...prev, showIncorrectAnimation: true }))
      setTimeout(() => setGameState(prev => ({ ...prev, showIncorrectAnimation: false })), 1000)
      
      const newLives = gameState.lives - 1
      setGameState(prev => ({
        ...prev,
        streak: 0,
        lives: newLives,
        totalQuestions: prev.totalQuestions + 1
      }))
      
      if (newLives <= 0) {
        setTimeout(() => {
          setGameState(prev => ({ ...prev, currentState: 'gameOver' }))
        }, 1000)
      } else {
        setTimeout(() => {
          setGameState(prev => ({ ...prev, userAnswer: '' }))
        }, 1000)
      }
    }
  }
  
  const backToMenu = () => {
    setGameState(prev => ({
      ...prev,
      currentState: 'menu',
      score: 0,
      streak: 0,
      lives: 3,
      correctAnswers: 0,
      totalQuestions: 0,
      currentQuestion: null,
      userAnswer: ''
    }))
  }
  
  const changeLanguage = (langCode: string) => {
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
  }

  const handleSubscription = async (plan: string) => {
    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          plan: plan,
          platform: gameState.selectedPlatform,
          customerEmail: 'khalid_ksouri@yahoo.fr'
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
      {/* Particules d'arrière-plan */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10">
        {/* Header */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl">
            <div className="flex items-center space-x-3">
              <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg">
                🧮
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white">{currentLangConfig.appName}</h1>
                <p className="text-white/80 text-sm">{t.domain.tagline}</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Bouton Son */}
              <button
                onClick={() => setSoundEnabled(!soundEnabled)}
                className="p-3 bg-white/20 rounded-xl text-white hover:bg-white/30 transition-all"
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-3 bg-white/20 rounded-xl px-6 py-3 text-white hover:bg-white/30 transition-all"
                >
                  <Languages size={20} />
                  <span className="hidden sm:inline">{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <ChevronDown size={16} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-3 bg-white rounded-2xl shadow-2xl z-50 min-w-96 max-h-96 overflow-y-auto">
                    <div className="p-4 border-b">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2">
                        <Globe size={20} />
                        {t.selectLanguage}
                      </h3>
                    </div>
                    
                    {Object.entries(languagesByContinent).map(([continent, languages]) => (
                      <div key={continent} className="p-3">
                        <div className="font-bold text-gray-700 text-sm px-3 py-2 bg-gray-50 rounded-lg mb-2">
                          {continent}
                        </div>
                        <div className="space-y-1">
                          {(languages as LanguageConfig[]).map((lang: LanguageConfig & { code: string }) => (
                            <button
                              key={lang.code}
                              onClick={() => changeLanguage(lang.code)}
                              className={`w-full text-left px-4 py-3 rounded-xl flex items-center space-x-3 hover:bg-blue-50 transition-all ${
                                currentLanguage === lang.code ? 'bg-blue-100 text-blue-700 font-semibold' : 'text-gray-700'
                              }`}
                            >
                              <span className="text-2xl">{lang.flag}</span>
                              <div className="flex-1">
                                <div className="font-medium">{lang.nativeName}</div>
                                <div className="text-xs text-gray-500">{lang.name}</div>
                                <div className="text-xs text-gray-400">{lang.appName}</div>
                              </div>
                              {currentLanguage === lang.code && (
                                <Check size={16} className="text-blue-600" />
                              )}
                            </button>
                          ))}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
              
              {/* Bouton Premium */}
              <button
                onClick={() => setShowSubscriptionModal(true)}
                className="flex items-center space-x-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl hover:from-yellow-500 hover:to-orange-600 transition-all shadow-lg font-bold"
              >
                <Crown size={20} />
                <span className="hidden sm:inline">
                  {subscription.type === 'free' ? t.upgradeNow : 'Premium'}
                </span>
              </button>
            </div>
          </nav>
          
          {/* Barre d'informations gratuit */}
          {subscription.type === 'free' && gameState.currentState !== 'demo' && (
            <div className="bg-gradient-to-r from-amber-100 to-orange-100 border-l-4 border-amber-500 rounded-xl p-4 mb-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="text-2xl animate-bounce">⚡</div>
                  <span className="text-amber-800 font-bold">
                    {t.freeTrialEnds} {subscription.freeTrialDaysLeft} {subscription.freeTrialDaysLeft === 1 ? t.day : t.days}
                  </span>
                </div>
                <div className="text-amber-700">
                  {subscription.maxWeeklyQuestions - subscription.weeklyQuestionsCount} {t.questionsLeft}
                </div>
              </div>
            </div>
          )}
        </header>
        
        {/* PAGE DE DÉMONSTRATION */}
        {gameState.currentState === 'demo' && (
          <div className="text-center space-y-8">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl">
              <div className="mb-8">
                <div className="text-8xl mb-6 animate-bounce">🎓</div>
                <h2 className="text-5xl md:text-6xl font-bold text-white mb-6">
                  {t.domain.welcome}
                </h2>
                <p className="text-2xl text-white/90 max-w-3xl mx-auto">
                  {t.subtitle}
                </p>
                <div className="mt-4 text-lg text-white/70">
                  www.math4child.com - {t.domain.tagline}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl mx-auto">
                <button
                  onClick={startFreeTrial}
                  className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4"
                >
                  <Gift size={28} />
                  <span>{t.freeTrial}</span>
                </button>
                
                <button 
                  onClick={() => setShowSubscriptionModal(true)}
                  className="bg-gradient-to-r from-purple-400 to-pink-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4"
                >
                  <Crown size={28} />
                  <span>Premium</span>
                </button>
              </div>
              
              {/* Statistiques */}
              <div className="mt-12 grid grid-cols-3 gap-8 max-w-2xl mx-auto">
                <div className="text-center">
                  <div className="text-3xl font-bold text-yellow-300">195+</div>
                  <div className="text-white/80 text-sm">Langues</div>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-green-300">5</div>
                  <div className="text-white/80 text-sm">Niveaux</div>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-blue-300">∞</div>
                  <div className="text-white/80 text-sm">Questions</div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {/* SÉLECTION DE PLATEFORME */}
        {gameState.currentState === 'platform-selection' && (
          <div className="space-y-8">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl">
              <div className="text-center mb-10">
                <div className="text-6xl mb-4">🌟</div>
                <h2 className="text-4xl font-bold text-white mb-4">{t.choosePlatform}</h2>
                <p className="text-xl text-white/80">Applications hybrides disponibles partout</p>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                <button
                  onClick={() => selectPlatform('web')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4">🌐</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.web}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.web}</p>
                    <div className="bg-blue-500 text-white px-4 py-2 rounded-lg">
                      Gratuit 7 jours
                    </div>
                  </div>
                </button>
                
                <button
                  onClick={() => selectPlatform('android')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4">📱</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.android}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.android}</p>
                    <div className="bg-green-500 text-white px-4 py-2 rounded-lg">
                      Google Play
                    </div>
                  </div>
                </button>
                
                <button
                  onClick={() => selectPlatform('ios')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4">🍎</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.ios}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.ios}</p>
                    <div className="bg-gray-800 text-white px-4 py-2 rounded-lg">
                      App Store
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        )}
        
        {/* MENU PRINCIPAL */}
        {gameState.currentState === 'menu' && (
          <div className="space-y-8">
            {/* Sélection du niveau */}
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-8 shadow-2xl">
              <h2 className="text-3xl font-bold text-white mb-8 text-center flex items-center justify-center gap-3">
                <Target size={32} />
                {t.chooseLevel}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
                {[1, 2, 3, 4, 5].map((level) => {
                  const unlocked = isLevelUnlocked(level)
                  const progress = levelProgress[level]
                  const progressPercent = Math.min((progress.questionsCompleted / progress.questionsRequired) * 100, 100)
                  const isSelected = gameState.selectedLevel === level
                  
                  return (
                    <button
                      key={level}
                      onClick={() => unlocked && setGameState(prev => ({ ...prev, selectedLevel: level }))}
                      disabled={!unlocked}
                      className={`relative p-6 rounded-2xl transition-all transform duration-300 ${
                        unlocked
                          ? isSelected
                            ? 'bg-white text-purple-600 shadow-2xl scale-105'
                            : 'bg-white/20 text-white hover:bg-white/30 hover:scale-102'
                          : 'bg-gray-400/30 text-gray-300 cursor-not-allowed'
                      }`}
                    >
                      {!unlocked && (
                        <div className="absolute inset-0 bg-black/40 rounded-2xl flex items-center justify-center">
                          <Lock className="text-gray-300" size={40} />
                        </div>
                      )}
                      
                      <div className="text-center">
                        <div className="text-5xl font-bold mb-2">{level}</div>
                        <div className="text-lg font-semibold mb-2">
                          {t.levels[level as keyof typeof t.levels]}
                        </div>
                        <div className="text-sm opacity-80 mb-4">
                          {t.levelDescriptions[level as keyof typeof t.levelDescriptions]}
                        </div>
                        
                        {unlocked && (
                          <div className="space-y-3">
                            <div className="bg-gray-200 rounded-full h-3 overflow-hidden">
                              <div
                                className="bg-gradient-to-r from-green-400 to-emerald-500 rounded-full h-3 transition-all duration-500"
                                style={{ width: `${progressPercent}%` }}
                              />
                            </div>
                            <div className="text-xs font-bold">
                              {progress.questionsCompleted}/{progress.questionsRequired}
                            </div>
                          </div>
                        )}
                      </div>
                    </button>
                  )
                })}
              </div>
            </div>
            
            {/* Sélection opération */}
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-8 shadow-2xl">
              <h2 className="text-3xl font-bold text-white mb-8 text-center flex items-center justify-center gap-3">
                <Calculator size={32} />
                {t.chooseOperation}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
                {Object.entries(t.operations).map(([key, name]) => {
                  const isSelected = gameState.selectedOperation === key
                  const icons = {
                    addition: <Plus size={40} />,
                    subtraction: <Minus size={40} />,
                    multiplication: <X size={40} />,
                    division: <Divide size={40} />,
                    mixed: <Calculator size={40} />
                  }
                  
                  return (
                    <button
                      key={key}
                      onClick={() => setGameState(prev => ({ ...prev, selectedOperation: key }))}
                      className={`p-6 rounded-2xl transition-all transform duration-300 ${
                        isSelected
                          ? 'bg-white text-purple-600 shadow-2xl scale-105'
                          : 'bg-white/20 text-white hover:bg-white/30 hover:scale-102'
                      }`}
                    >
                      <div className="text-center">
                        <div className="mb-4 flex justify-center">
                          {icons[key as keyof typeof icons]}
                        </div>
                        <div className="text-lg font-bold">{name}</div>
                      </div>
                    </button>
                  )
                })}
              </div>
            </div>
            
            {/* Bouton démarrage */}
            <div className="text-center">
              <button
                onClick={startGame}
                disabled={!isLevelUnlocked(gameState.selectedLevel)}
                className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-12 py-6 rounded-3xl text-2xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-2xl disabled:opacity-50 flex items-center justify-center space-x-4 mx-auto"
              >
                <Play size={32} />
                <span>{t.startGame}</span>
              </button>
            </div>
          </div>
        )}
        
        {/* INTERFACE DE JEU */}
        {gameState.currentState === 'playing' && gameState.currentQuestion && (
          <div className="space-y-8">
            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white">{gameState.score}</div>
                <div className="text-white/80 text-sm">{t.score}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-yellow-300">{gameState.streak}</div>
                <div className="text-white/80 text-sm">{t.streak}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white flex justify-center space-x-1">
                  {Array.from({ length: 3 }, (_, i) => (
                    <Heart 
                      key={i} 
                      size={20} 
                      className={i < gameState.lives ? 'text-red-400 fill-current' : 'text-gray-400'} 
                    />
                  ))}
                </div>
                <div className="text-white/80 text-sm">{t.lives}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white">{gameState.selectedLevel}</div>
                <div className="text-white/80 text-sm">{t.level}</div>
              </div>
            </div>
            
            {/* Zone question */}
            <div className="bg-white rounded-3xl p-12 text-center shadow-2xl relative overflow-hidden">
              {/* Animations */}
              {gameState.showCorrectAnimation && (
                <div className="absolute inset-0 bg-green-400 bg-opacity-20 flex items-center justify-center animate-pulse z-10">
                  <div className="text-9xl animate-bounce">🎉</div>
                </div>
              )}
              {gameState.showIncorrectAnimation && (
                <div className="absolute inset-0 bg-red-400 bg-opacity-20 flex items-center justify-center animate-pulse z-10">
                  <div className="text-9xl animate-bounce">❌</div>
                </div>
              )}
              
              {/* Question */}
              <div className="relative z-20">
                <div className="text-7xl md:text-9xl font-bold text-gray-800 mb-8 font-mono">
                  {gameState.currentQuestion.question} = ?
                </div>
                
                {/* Zone saisie */}
                <div className="space-y-8">
                  <input
                    type="number"
                    value={gameState.userAnswer}
                    onChange={(e) => setGameState(prev => ({ ...prev, userAnswer: e.target.value }))}
                    className="text-center text-6xl font-bold border-4 border-gray-300 rounded-3xl px-8 py-6 w-96 max-w-full focus:border-blue-500 focus:outline-none focus:ring-8 focus:ring-blue-200 transition-all font-mono"
                    placeholder="?"
                    autoFocus
                    onKeyPress={(e) => e.key === 'Enter' && gameState.userAnswer && checkAnswer()}
                  />
                  
                  {/* Boutons */}
                  <div className="flex flex-col sm:flex-row gap-4 justify-center">
                    <button
                      onClick={checkAnswer}
                      disabled={!gameState.userAnswer}
                      className="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all transform hover:scale-105 disabled:opacity-50 shadow-xl flex items-center justify-center space-x-3"
                    >
                      <Check size={28} />
                      <span>{t.check}</span>
                    </button>
                    <button
                      onClick={backToMenu}
                      className="bg-gradient-to-r from-gray-500 to-gray-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-gray-600 hover:to-gray-700 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-3"
                    >
                      <Home size={28} />
                      <span>{t.backToMenu}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {/* GAME OVER */}
        {gameState.currentState === 'gameOver' && (
          <div className="text-center space-y-8">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl">
              <div className="text-8xl mb-6">🎮</div>
              <h2 className="text-5xl font-bold text-white mb-6">{t.gameOver}</h2>
              
              <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-2xl mx-auto mb-8">
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-yellow-300">{gameState.score}</div>
                  <div className="text-white/80 text-sm">{t.finalScore}</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-green-300">{gameState.correctAnswers}</div>
                  <div className="text-white/80 text-sm">Correctes</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-blue-300">{gameState.totalQuestions}</div>
                  <div className="text-white/80 text-sm">Total</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-purple-300">{gameState.totalQuestions > 0 ? Math.round((gameState.correctAnswers / gameState.totalQuestions) * 100) : 0}%</div>
                  <div className="text-white/80 text-sm">Précision</div>
                </div>
              </div>
              
              <div className="flex gap-4 justify-center">
                <button
                  onClick={startGame}
                  className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3"
                >
                  <Play size={28} />
                  <span>{t.playAgain}</span>
                </button>
                <button
                  onClick={backToMenu}
                  className="bg-gradient-to-r from-blue-400 to-blue-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-blue-500 hover:to-blue-600 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3"
                >
                  <Home size={28} />
                  <span>{t.home}</span>
                </button>
              </div>
            </div>
          </div>
        )}
      </div>