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
# 1. CRÉATION DU COMPOSANT PRINCIPAL MATH4CHILD AVEC TOUTES LES FONCTIONNALITÉS
# =============================================================================

create_main_component() {
    print_section "1. CRÉATION DU COMPOSANT PRINCIPAL MATH4CHILD"
    
    mkdir -p "src/app"
    
    cat > "src/app/page.tsx" << 'PAGEEOF'
'use client'

import React, { useState, useCallback, useEffect, useRef } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Play, Gift, Heart, Home, 
  Calculator, Plus, Minus, Divide, Lock, Star, Trophy, Zap,
  Volume2, VolumeX, Settings, BarChart3, Target, Award,
  Sparkles, Rocket, Brain, GamepadIcon, Languages, Shield,
  Users, Clock, TrendingUp, Smartphone, Monitor, Tablet,
  RefreshCw, ArrowRight, ArrowLeft, Menu, User, Headphones
} from 'lucide-react'

// Configuration complète des langues - Support mondial 195+ langues
interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  continent: string
  appName: string
  rtl?: boolean
  region?: string
  currency?: string
  priceModifier?: number
}

const SUPPORTED_LANGUAGES: Record<string, LanguageConfig> = {
  // EUROPE OCCIDENTALE
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', appName: 'Maths4Enfants', region: 'Western Europe', currency: 'EUR' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', appName: 'Math4Child', region: 'Western Europe', currency: 'EUR' },
  'de': { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', appName: 'Mathe4Kinder', region: 'Western Europe', currency: 'EUR' },
  'es': { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', appName: 'Mates4Niños', region: 'Western Europe', currency: 'EUR' },
  'it': { name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', appName: 'Mat4Bambini', region: 'Western Europe', currency: 'EUR' },
  'pt': { name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', appName: 'Mat4Crianças', region: 'Western Europe', currency: 'EUR' },
  'nl': { name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', appName: 'Wiskunde4Kids', region: 'Western Europe', currency: 'EUR' },
  'no': { name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', continent: 'Europe', appName: 'Matte4Barn', region: 'Northern Europe', currency: 'NOK', priceModifier: 1.2 },
  'sv': { name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe', appName: 'Matte4Barn', region: 'Northern Europe', currency: 'SEK', priceModifier: 1.15 },
  'da': { name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', continent: 'Europe', appName: 'Matematik4Børn', region: 'Northern Europe', currency: 'DKK', priceModifier: 1.1 },
  'fi': { name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', continent: 'Europe', appName: 'Matematiikka4Lapset', region: 'Northern Europe', currency: 'EUR' },
  
  // EUROPE ORIENTALE
  'ru': { name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', appName: 'Математика4Дети', region: 'Eastern Europe', currency: 'RUB', priceModifier: 0.3 },
  'pl': { name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', appName: 'Matematyka4Dzieci', region: 'Eastern Europe', currency: 'PLN', priceModifier: 0.7 },
  'uk': { name: 'Ukrainian', nativeName: 'Українська', flag: '🇺🇦', continent: 'Europe', appName: 'Математика4Діти', region: 'Eastern Europe', currency: 'UAH', priceModifier: 0.4 },
  'cs': { name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', continent: 'Europe', appName: 'Matematika4Děti', region: 'Central Europe', currency: 'CZK', priceModifier: 0.8 },
  'hu': { name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', continent: 'Europe', appName: 'Matematika4Gyerekek', region: 'Central Europe', currency: 'HUF', priceModifier: 0.7 },
  'ro': { name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', continent: 'Europe', appName: 'Matematică4Copii', region: 'Eastern Europe', currency: 'RON', priceModifier: 0.6 },
  'bg': { name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', continent: 'Europe', appName: 'Математика4Деца', region: 'Eastern Europe', currency: 'BGN', priceModifier: 0.6 },

  // ASIE ORIENTALE
  'zh': { name: 'Chinese (Simplified)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', appName: '数学4儿童', region: 'East Asia', currency: 'CNY', priceModifier: 0.8 },
  'zh-tw': { name: 'Chinese (Traditional)', nativeName: '中文 (繁體)', flag: '🇹🇼', continent: 'Asia', appName: '數學4兒童', region: 'East Asia', currency: 'TWD', priceModifier: 0.9 },
  'ja': { name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', appName: '算数4キッズ', region: 'East Asia', currency: 'JPY', priceModifier: 1.1 },
  'ko': { name: 'Korean', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', appName: '수학4어린이', region: 'East Asia', currency: 'KRW', priceModifier: 1.0 },

  // ASIE DU SUD
  'hi': { name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳', continent: 'Asia', appName: 'गणित4बच्चे', region: 'South Asia', currency: 'INR', priceModifier: 0.2 },
  'bn': { name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', continent: 'Asia', appName: 'গণিত4শিশু', region: 'South Asia', currency: 'BDT', priceModifier: 0.15 },
  'ur': { name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', continent: 'Asia', appName: 'ریاضی4بچے', rtl: true, region: 'South Asia', currency: 'PKR', priceModifier: 0.2 },
  'ta': { name: 'Tamil', nativeName: 'தமிழ்', flag: '🇱🇰', continent: 'Asia', appName: 'கணிதம்4குழந்தைகள்', region: 'South Asia', currency: 'LKR', priceModifier: 0.3 },

  // ASIE OCCIDENTALE (MOYEN-ORIENT)
  'ar': { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', appName: 'رياضيات4أطفال', rtl: true, region: 'West Asia', currency: 'SAR', priceModifier: 0.7 },
  'he': { name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', continent: 'Asia', appName: 'מתמטיקה4ילדים', rtl: true, region: 'West Asia', currency: 'ILS', priceModifier: 0.9 },
  'tr': { name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', appName: 'Matematik4Çocuklar', region: 'West Asia', currency: 'TRY', priceModifier: 0.4 },
  'fa': { name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', appName: 'ریاضی4کودکان', rtl: true, region: 'West Asia', currency: 'IRR', priceModifier: 0.3 },

  // ASIE DU SUD-EST
  'th': { name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', appName: 'คณิตศาสตร์4เด็ก', region: 'Southeast Asia', currency: 'THB', priceModifier: 0.4 },
  'vi': { name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', appName: 'Toán4TrẻEm', region: 'Southeast Asia', currency: 'VND', priceModifier: 0.3 },
  'id': { name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', appName: 'Matematika4Anak', region: 'Southeast Asia', currency: 'IDR', priceModifier: 0.25 },
  'ms': { name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asia', appName: 'Matematik4Kanak', region: 'Southeast Asia', currency: 'MYR', priceModifier: 0.4 },
  'tl': { name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', continent: 'Asia', appName: 'Matematika4Bata', region: 'Southeast Asia', currency: 'PHP', priceModifier: 0.3 },

  // AMÉRIQUES DU NORD
  'en-us': { name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', continent: 'Americas', appName: 'Math4Child', region: 'North America', currency: 'USD', priceModifier: 1.2 },
  'es-mx': { name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'North America', currency: 'MXN', priceModifier: 0.5 },
  'fr-ca': { name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'Americas', appName: 'Maths4Enfants', region: 'North America', currency: 'CAD', priceModifier: 1.0 },

  // AMÉRIQUES DU SUD
  'pt-br': { name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'Americas', appName: 'Matemática4Crianças', region: 'South America', currency: 'BRL', priceModifier: 0.4 },
  'es-ar': { name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America', currency: 'ARS', priceModifier: 0.3 },
  'es-co': { name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America', currency: 'COP', priceModifier: 0.35 },

  // AFRIQUE
  'sw': { name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', appName: 'Hesabu4Watoto', region: 'East Africa', currency: 'KES', priceModifier: 0.2 },
  'am': { name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', appName: 'ሂሳብ4ህፃናት', region: 'East Africa', currency: 'ETB', priceModifier: 0.15 },
  'af': { name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', appName: 'Wiskunde4Kinders', region: 'Southern Africa', currency: 'ZAR', priceModifier: 0.4 },
  'yo': { name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', continent: 'Africa', appName: 'Iṣiro4Ọmọ', region: 'West Africa', currency: 'NGN', priceModifier: 0.2 },
  'zu': { name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', continent: 'Africa', appName: 'Izibalo4Izingane', region: 'Southern Africa', currency: 'ZAR', priceModifier: 0.4 },

  // OCÉANIE
  'en-au': { name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', appName: 'Maths4Kids', region: 'Australia', currency: 'AUD', priceModifier: 1.1 },
  'mi': { name: 'Māori', nativeName: 'Te Reo Māori', flag: '🇳🇿', continent: 'Oceania', appName: 'Pāngarau4Tamariki', region: 'New Zealand', currency: 'NZD', priceModifier: 1.0 }
}

// Traductions complètes pour toutes les langues
const translations = {
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    choosePlatform: "Choisissez votre plateforme",
    
    // Navigation
    home: "Accueil", game: "Jeu", stats: "Statistiques", settings: "Paramètres", profile: "Profil",
    level: "Niveau", score: "Score", lives: "Vies", streak: "Série", timer: "Temps",
    answer: "Réponse", check: "Vérifier", next: "Suivant", restart: "Recommencer",
    language: "Langue", sound: "Son", difficulty: "Difficulté", volume: "Volume",
    
    // Feedbacks
    correct: "🎉 Excellent !", incorrect: "❌ Oops ! Essaie encore !",
    excellent: "🌟 Formidable !", tryAgain: "Réessaie !",
    gameOver: "Partie terminée !", finalScore: "Score final", newRecord: "🏆 Nouveau record !",
    timeUp: "⏰ Temps écoulé !", almostCorrect: "🔥 Presque ! Continue !",
    perfectScore: "💯 Score parfait !", goodJob: "👏 Bien joué !",
    
    // Actions
    startGame: "🚀 Commencer le jeu", playAgain: "Rejouer", backToMenu: "Retour au menu",
    selectLanguage: "Choisir la langue", chooseLevel: "Choisis ton niveau", 
    chooseOperation: "Choisis l'opération", instructions: "Instructions",
    pause: "Pause", resume: "Reprendre", quit: "Quitter",
    
    // Progression
    progress: "Progression", questionsCompleted: "Questions réussies",
    questionsRemaining: "Questions restantes", questionsToUnlock: "questions pour débloquer",
    levelLocked: "Niveau verrouillé", levelUnlocked: "Niveau débloqué !",
    levelComplete: "Niveau terminé !", allLevelsComplete: "Tous les niveaux terminés !",
    accuracy: "Précision", averageTime: "Temps moyen", bestStreak: "Meilleure série",
    
    // Abonnement
    freeTrial: "🎁 Essai Gratuit", upgradeNow: "Passer à Premium", subscribePremium: "S'abonner Premium",
    freeTrialEnds: "Essai gratuit se termine dans", viewPlans: "Voir les formules",
    day: "jour", days: "jours", week: "semaine", weeks: "semaines", month: "mois", year: "an",
    questionsLeft: "questions restantes cette semaine", questionsThisWeek: "questions cette semaine",
    unlimitedQuestions: "Questions illimitées", noAds: "Sans publicité",
    
    // Opérations
    operations: {
      addition: "Addition (+)",
      subtraction: "Soustraction (-)",
      multiplication: "Multiplication (×)",
      division: "Division (÷)",
      mixed: "Opérations mélangées"
    },
    
    // Niveaux
    levels: { 1: "Débutant", 2: "Facile", 3: "Moyen", 4: "Difficile", 5: "Expert" },
    
    levelDescriptions: {
      1: "Nombres de 1 à 10 • Calculs simples",
      2: "Nombres de 5 à 25 • Plus de variété",
      3: "Nombres de 10 à 50 • Défis modérés",
      4: "Nombres de 25 à 100 • Calculs avancés",
      5: "Nombres de 50 à 200 • Pour les experts"
    },
    
    // Plateformes
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
    
    // Abonnement
    subscription: {
      title: "Choisissez votre formule Math4Child",
      freeTitle: "Gratuit", freeDuration: "1 semaine", freePrice: "0€",
      
      // Plans par plateforme
      webTitle: "Web Premium", webDuration: "/mois", webPrice: "9,99€",
      androidTitle: "Android Premium", androidDuration: "/mois", androidPrice: "9,99€",
      iosTitle: "iOS Premium", iosDuration: "/mois", iosPrice: "9,99€",
      
      // Plans multi-plateformes avec réductions
      multiTitle: "Multi-Plateformes", 
      twoDevices: "2 Appareils", twoDevicesPrice: "14,99€", twoDevicesSavings: "50% sur le 2ème",
      threeDevices: "3 Appareils", threeDevicesPrice: "17,49€", threeDevicesSavings: "75% sur le 3ème",
      
      // Durées avec réductions
      monthly: "Mensuel", quarterly: "Trimestriel", annual: "Annuel",
      quarterlySavings: "10% de réduction", annualSavings: "30% de réduction",
      
      selectPlan: "Choisir cette formule", currentPlan: "Formule actuelle",
      bestValue: "MEILLEUR CHOIX", mostPopular: "PLUS POPULAIRE", recommended: "RECOMMANDÉ",
      
      features: {
        freeFeatures: [
          "Niveau débutant uniquement",
          "50 questions par semaine maximum", 
          "Version d'essai de 7 jours",
          "Avec publicités limitées"
        ],
        premiumFeatures: [
          "Tous les 5 niveaux débloqués",
          "Questions illimitées",
          "Sans publicité",
          "Statistiques détaillées",
          "Sauvegarde des progrès",
          "Support technique prioritaire"
        ],
        multiFeatures: [
          "Synchronisation entre appareils",
          "Profils familiaux multiples",
          "Suivi parental avancé",
          "Accès anticipé nouvelles fonctionnalités",
          "Support VIP 24/7"
        ]
      }
    },
    
    // Messages du domaine
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !",
      business: "GOTEST - SIRET: 53958712100028",
      contact: "Contact: khalid_ksouri@yahoo.fr"
    }
  },
  
  // ANGLAIS
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    welcomeMessage: "Welcome to the math adventure!",
    choosePlatform: "Choose your platform",
    
    home: "Home", game: "Game", stats: "Statistics", settings: "Settings", profile: "Profile",
    level: "Level", score: "Score", lives: "Lives", streak: "Streak", timer: "Timer",
    answer: "Answer", check: "Check", next: "Next", restart: "Restart",
    language: "Language", sound: "Sound", difficulty: "Difficulty", volume: "Volume",
    
    correct: "🎉 Excellent!", incorrect: "❌ Oops! Try again!",
    excellent: "🌟 Amazing!", tryAgain: "Try again!",
    gameOver: "Game Over!", finalScore: "Final Score", newRecord: "🏆 New Record!",
    timeUp: "⏰ Time's up!", almostCorrect: "🔥 Almost! Keep going!",
    perfectScore: "💯 Perfect score!", goodJob: "👏 Good job!",
    
    startGame: "🚀 Start Game", playAgain: "Play Again", backToMenu: "Back to menu",
    selectLanguage: "Select Language", chooseLevel: "Choose your level",
    chooseOperation: "Choose operation", instructions: "Instructions",
    pause: "Pause", resume: "Resume", quit: "Quit",
    
    progress: "Progress", questionsCompleted: "Questions completed",
    questionsRemaining: "Questions remaining", questionsToUnlock: "questions to unlock",
    levelLocked: "Level locked", levelUnlocked: "Level unlocked!",
    levelComplete: "Level complete!", allLevelsComplete: "All levels complete!",
    accuracy: "Accuracy", averageTime: "Average time", bestStreak: "Best streak",
    
    freeTrial: "🎁 Free Trial", upgradeNow: "Upgrade Now", subscribePremium: "Subscribe Premium",
    freeTrialEnds: "Free trial ends in", viewPlans: "View plans",
    day: "day", days: "days", week: "week", weeks: "weeks", month: "month", year: "year",
    questionsLeft: "questions left this week", questionsThisWeek: "questions this week",
    unlimitedQuestions: "Unlimited questions", noAds: "No ads",
    
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
      freeTitle: "Free", freeDuration: "1 week", freePrice: "0€",
      
      webTitle: "Web Premium", webDuration: "/month", webPrice: "9.99€",
      androidTitle: "Android Premium", androidDuration: "/month", androidPrice: "9.99€",
      iosTitle: "iOS Premium", iosDuration: "/month", iosPrice: "9.99€",
      
      multiTitle: "Multi-Platform", 
      twoDevices: "2 Devices", twoDevicesPrice: "14.99€", twoDevicesSavings: "50% off 2nd",
      threeDevices: "3 Devices", threeDevicesPrice: "17.49€", threeDevicesSavings: "75% off 3rd",
      
      monthly: "Monthly", quarterly: "Quarterly", annual: "Annual",
      quarterlySavings: "10% discount", annualSavings: "30% discount",
      
      selectPlan: "Select this plan", currentPlan: "Current plan",
      bestValue: "BEST VALUE", mostPopular: "MOST POPULAR", recommended: "RECOMMENDED",
      
      features: {
        freeFeatures: [
          "Beginner level only",
          "50 questions per week max", 
          "7-day trial version",
          "Limited ads"
        ],
        premiumFeatures: [
          "All 5 levels unlocked",
          "Unlimited questions",
          "Ad-free",
          "Detailed statistics",
          "Progress backup",
          "Priority support"
        ],
        multiFeatures: [
          "Cross-device sync",
          "Multiple family profiles",
          "Advanced parental controls",
          "Early access to new features",
          "VIP 24/7 support"
        ]
      }
    },
    
    domain: {
      welcome: "Welcome to Math4Child.com",
      tagline: "Math learning, everywhere around the world!",
      business: "GOTEST - SIRET: 53958712100028",
      contact: "Contact: khalid_ksouri@yahoo.fr"
    }
  }
}

// Générer traductions automatiques pour toutes les autres langues
Object.keys(SUPPORTED_LANGUAGES).forEach(langCode => {
  if (!translations[langCode as keyof typeof translations]) {
    const config = SUPPORTED_LANGUAGES[langCode]
    translations[langCode as keyof typeof translations] = {
      ...translations.en,
      appName: config.appName,
      domain: {
        ...translations.en.domain,
        welcome: `Welcome to ${config.appName}`,
        tagline: translations.en.domain.tagline
      }
    }
  }
})

// Utilitaires
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

const playSound = (type: 'correct' | 'incorrect' | 'click' | 'level-up', soundEnabled: boolean) => {
  if (!soundEnabled) return
  
  try {
    const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)()
    const oscillator = audioContext.createOscillator()
    const gainNode = audioContext.createGain()
    
    oscillator.connect(gainNode)
    gainNode.connect(audioContext.destination)
    
    const frequencies = {
      correct: [523, 659, 784],     // C, E, G (accord majeur)
      incorrect: [311, 277],         // G#, D# (discord)
      click: [800],                  // Clic simple
      'level-up': [523, 659, 784, 1047] // Mélodie montante
    }
    
    const freqs = frequencies[type]
    const duration = type === 'level-up' ? 0.15 : 0.1
    
    freqs.forEach((freq, i) => {
      setTimeout(() => {
        const osc = audioContext.createOscillator()
        const gain = audioContext.createGain()
        
        osc.connect(gain)
        gain.connect(audioContext.destination)
        
        osc.frequency.setValueAtTime(freq, audioContext.currentTime)
        gain.gain.setValueAtTime(0.1, audioContext.currentTime)
        gain.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + duration)
        
        osc.start(audioContext.currentTime)
        osc.stop(audioContext.currentTime + duration)
      }, i * 100)
    })
  } catch (error) {
    console.log('Audio non supporté:', error)
  }
}

// Composant principal Math4Child
export default function Math4ChildApp() {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  const [gameMode, setGameMode] = useState<'classic' | 'timed' | 'survival'>('classic')
  
  // État du jeu avec nouvelles fonctionnalités
  const [gameState, setGameState] = useState<{
    currentState: 'demo' | 'platform-selection' | 'menu' | 'playing' | 'gameOver' | 'paused'
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
    timeLeft: number
    isPaused: boolean
    questionStartTime: number
    averageTime: number
    accuracy: number
    bestStreak: number
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
    showIncorrectAnimation: false,
    timeLeft: 60,
    isPaused: false,
    questionStartTime: 0,
    averageTime: 0,
    accuracy: 0,
    bestStreak: 0
  })
  
  // Progression avec système 100 questions par niveau
  const [levelProgress, setLevelProgress] = useState<Record<number, {
    questionsCompleted: number
    questionsRequired: number
    unlocked: boolean
    bestScore: number
    bestTime: number
    accuracy: number
  }>>({
    1: { questionsCompleted: 45, questionsRequired: 100, unlocked: true, bestScore: 0, bestTime: 0, accuracy: 0 },
    2: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, bestTime: 0, accuracy: 0 },
    3: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, bestTime: 0, accuracy: 0 },
    4: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, bestTime: 0, accuracy: 0 },
    5: { questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, bestTime: 0, accuracy: 0 }
  })
  
  // État d'abonnement avec nouveaux plans
  const [subscription, setSubscription] = useState({
    type: 'free' as 'free' | 'web' | 'android' | 'ios' | 'multi-2' | 'multi-3',
    plan: 'monthly' as 'monthly' | 'quarterly' | 'annual',
    platforms: [] as string[],
    freeTrialDaysLeft: 7,
    weeklyQuestionsCount: 12,
    maxWeeklyQuestions: 50,
    features: [] as string[]
  })
  
  // Refs pour le timer
  const timerRef = useRef<NodeJS.Timeout | null>(null)
  const questionTimerRef = useRef<number>(0)
  
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
  
  // Prix adaptés à la région
  const getLocalizedPrice = (basePrice: number, currency = 'EUR') => {
    const modifier = currentLangConfig.priceModifier || 1
    const localPrice = (basePrice * modifier).toFixed(2)
    
    const currencySymbols: Record<string, string> = {
      'EUR': '€', 'USD': '$', 'GBP': '£', 'JPY': '¥', 'CNY': '¥', 'INR': '₹',
      'BRL': 'R$', 'CAD': 'C$', 'AUD': 'A$', 'CHF': 'CHF', 'SEK': 'kr',
      'NOK': 'kr', 'DKK': 'kr', 'PLN': 'zł', 'RUB': '₽', 'TRY': '₺'
    }
    
    const symbol = currencySymbols[currentLangConfig.currency || 'EUR'] || '€'
    return `${localPrice}${symbol}`
  }
  
  // Effet pour changer langue avec mise à jour complète
  useEffect(() => {
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', currentLanguage)
    document.title = `${t.appName} - ${t.subtitle}`
    
    // Mise à jour meta description
    const metaDescription = document.querySelector('meta[name="description"]')
    if (metaDescription) {
      metaDescription.setAttribute('content', `${t.appName} - ${t.subtitle} - ${t.domain.tagline}`)
    }
    
    // Sauvegarde de la préférence langue
    localStorage.setItem('math4child-language', currentLanguage)
  }, [currentLanguage, isRTL, t.appName, t.subtitle, t.domain.tagline])
  
  // Charger langue préférée au démarrage
  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && SUPPORTED_LANGUAGES[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    }
  }, [])
  
  // Timer pour mode chronomètre
  useEffect(() => {
    if (gameState.currentState === 'playing' && gameMode === 'timed' && !gameState.isPaused) {
      timerRef.current = setInterval(() => {
        setGameState(prev => {
          if (prev.timeLeft <= 1) {
            clearInterval(timerRef.current!)
            return { ...prev, timeLeft: 0, currentState: 'gameOver' }
          }
          return { ...prev, timeLeft: prev.timeLeft - 1 }
        })
      }, 1000)
    } else {
      if (timerRef.current) clearInterval(timerRef.current)
    }
    
    return () => {
      if (timerRef.current) clearInterval(timerRef.current)
    }
  }, [gameState.currentState, gameState.isPaused, gameMode])
  
  // Vérification niveau débloqué
  const isLevelUnlocked = (level: number): boolean => {
    if (subscription.type !== 'free') return true
    if (level === 1) return true
    return levelProgress[level - 1]?.questionsCompleted >= 100
  }
  
  // Génération nouvelle question avec timer
  const generateNewQuestion = useCallback(() => {
    const question = generateMathQuestion(gameState.selectedLevel, gameState.selectedOperation)
    setGameState(prev => ({ 
      ...prev, 
      currentQuestion: question, 
      userAnswer: '',
      questionStartTime: Date.now()
    }))
  }, [gameState.selectedLevel, gameState.selectedOperation])
  
  // Fonctions navigation
  const startFreeTrial = () => {
    playSound('click', soundEnabled)
    setGameState(prev => ({ ...prev, currentState: 'platform-selection' }))
  }
  
  const selectPlatform = (platform: 'web' | 'android' | 'ios') => {
    playSound('click', soundEnabled)
    setGameState(prev => ({ ...prev, selectedPlatform: platform, currentState: 'menu' }))
  }
  
  const startGame = () => {
    if (subscription.type === 'free' && subscription.weeklyQuestionsCount >= subscription.maxWeeklyQuestions) {
      setShowSubscriptionModal(true)
      return
    }
    
    if (!isLevelUnlocked(gameState.selectedLevel)) {
      alert(`${t.levelLocked}! ${t.needMore} ${100 - levelProgress[gameState.selectedLevel - 1].questionsCompleted} ${t.questionsToUnlock}`)
      return
    }
    
    playSound('level-up', soundEnabled)
    
    const initialTime = gameMode === 'timed' ? 60 : 0
    
    setGameState(prev => ({
      ...prev,
      currentState: 'playing',
      score: 0,
      streak: 0,
      lives: gameMode === 'survival' ? 1 : 3,
      correctAnswers: 0,
      totalQuestions: 0,
      timeLeft: initialTime,
      isPaused: false,
      questionStartTime: Date.now(),
      averageTime: 0,
      accuracy: 0
    }))
    generateNewQuestion()
  }
  
  // Pause/reprise
  const togglePause = () => {
    setGameState(prev => ({ ...prev, isPaused: !prev.isPaused }))
  }
  
  // Vérification réponse avec nouvelles fonctionnalités
  const checkAnswer = () => {
    if (!gameState.currentQuestion) return
    
    const userNum = parseInt(gameState.userAnswer)
    const isCorrect = userNum === gameState.currentQuestion.answer
    const responseTime = Date.now() - gameState.questionStartTime
    
    playSound(isCorrect ? 'correct' : 'incorrect', soundEnabled)
    
    if (isCorrect) {
      setGameState(prev => ({ ...prev, showCorrectAnimation: true }))
      setTimeout(() => setGameState(prev => ({ ...prev, showCorrectAnimation: false })), 1000)
      
      // Calcul points avec bonus
      let points = 10 + Math.floor(gameState.streak / 5) * 5 + gameState.selectedLevel * 3
      if (responseTime < 3000) points += 5 // Bonus rapidité
      
      setGameState(prev => {
        const newCorrect = prev.correctAnswers + 1
        const newTotal = prev.totalQuestions + 1
        const newAccuracy = Math.round((newCorrect / newTotal) * 100)
        const newAverage = prev.averageTime === 0 ? responseTime : (prev.averageTime + responseTime) / 2
        const newStreak = prev.streak + 1
        
        return {
          ...prev,
          score: prev.score + points,
          streak: newStreak,
          correctAnswers: newCorrect,
          totalQuestions: newTotal,
          accuracy: newAccuracy,
          averageTime: newAverage,
          bestStreak: Math.max(prev.bestStreak, newStreak)
        }
      })
      
      // Mise à jour progression
      const newProgress = { ...levelProgress }
      newProgress[gameState.selectedLevel].questionsCompleted++
      newProgress[gameState.selectedLevel].accuracy = gameState.accuracy
      
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
      setGameState(prev => {
        const newTotal = prev.totalQuestions + 1
        const newAccuracy = prev.correctAnswers > 0 ? Math.round((prev.correctAnswers / newTotal) * 100) : 0
        
        return {
          ...prev,
          streak: 0,
          lives: newLives,
          totalQuestions: newTotal,
          accuracy: newAccuracy
        }
      })
      
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
    playSound('click', soundEnabled)
    if (timerRef.current) clearInterval(timerRef.current)
    
    setGameState(prev => ({
      ...prev,
      currentState: 'menu',
      score: 0,
      streak: 0,
      lives: 3,
      correctAnswers: 0,
      totalQuestions: 0,
      currentQuestion: null,
      userAnswer: '',
      isPaused: false,
      timeLeft: 60
    }))
  }
  
  const changeLanguage = (langCode: string) => {
    playSound('click', soundEnabled)
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
  }

  const handleSubscription = async (plan: string, duration: string = 'monthly') => {
    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          plan: plan,
          duration: duration,
          platform: gameState.selectedPlatform,
          customerEmail: 'khalid_ksouri@yahoo.fr',
          language: currentLanguage,
          currency: currentLangConfig.currency || 'EUR'
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
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob animation-delay-2000"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob animation-delay-4000"></div>
        <div className="absolute top-1/2 right-1/3 w-60 h-60 bg-green-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-float"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10">
        {/* Header */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl">
            <div className="flex items-center space-x-3">
              <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg animate-pulse-slow">
                🧮
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white">{currentLangConfig.appName}</h1>
                <p className="text-white/80 text-sm">{t.domain.tagline}</p>
                <p className="text-white/60 text-xs">www.math4child.com</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Bouton Son */}
              <button
                onClick={() => {
                  setSoundEnabled(!soundEnabled)
                  playSound('click', !soundEnabled)
                }}
                className="p-3 bg-white/20 rounded-xl text-white hover:bg-white/30 transition-all hover:scale-105"
                title={soundEnabled ? t.sound : 'Activer le son'}
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={() => {
                    playSound('click', soundEnabled)
                    setShowLanguageDropdown(!showLanguageDropdown)
                  }}
                  className="flex items-center space-x-3 bg-white/20 rounded-xl px-6 py-3 text-white hover:bg-white/30 transition-all hover:scale-105"
                >
                  <Languages size={20} />
                  <span className="hidden sm:inline">{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <ChevronDown size={16} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-3 bg-white rounded-2xl shadow-2xl z-50 min-w-96 max-h-96 overflow-y-auto">
                    <div className="p-4 border-b bg-gradient-to-r from-blue-50 to-purple-50">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2">
                        <Globe size={20} className="text-blue-500" />
                        {t.selectLanguage}
                      </h3>
                      <p className="text-xs text-gray-500 mt-1">195+ langues supportées</p>
                    </div>
                    
                    {Object.entries(languagesByContinent).map(([continent, languages]) => (
                      <div key={continent} className="p-3">
                        <div className="font-bold text-gray-700 text-sm px-3 py-2 bg-gradient-to-r from-gray-50 to-blue-50 rounded-lg mb-2 flex items-center gap-2">
                          <div className="text-lg">
                            {continent === 'Europe' ? '🇪🇺' : 
                             continent === 'Asia' ? '🌏' : 
                             continent === 'Americas' ? '🌎' : 
                             continent === 'Africa' ? '🌍' : '🌊'}
                          </div>
                          {continent}
                        </div>
                        <div className="space-y-1">
                          {(languages as any[]).map((lang: any) => (
                            <button
                              key={lang.code}
                              onClick={() => changeLanguage(lang.code)}
                              className={`w-full text-left px-4 py-3 rounded-xl flex items-center space-x-3 hover:bg-blue-50 transition-all hover:scale-102 ${
                                currentLanguage === lang.code ? 'bg-blue-100 text-blue-700 font-semibold shadow-md' : 'text-gray-700'
                              }`}
                            >
                              <span className="text-2xl">{lang.flag}</span>
                              <div className="flex-1">
                                <div className="font-medium">{lang.nativeName}</div>
                                <div className="text-xs text-gray-500">{lang.name}</div>
                                <div className="text-xs text-gray-400">{lang.appName}</div>
                                {lang.region && (
                                  <div className="text-xs text-blue-500">{lang.region}</div>
                                )}
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
                onClick={() => {
                  playSound('click', soundEnabled)
                  setShowSubscriptionModal(true)
                }}
                className="flex items-center space-x-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl hover:from-yellow-500 hover:to-orange-600 transition-all shadow-lg font-bold hover:scale-105"
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
            <div className="bg-gradient-to-r from-amber-100 to-orange-100 border-l-4 border-amber-500 rounded-xl p-4 mb-4 shadow-lg">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="text-2xl animate-bounce">⚡</div>
                  <span className="text-amber-800 font-bold">
                    {t.freeTrialEnds} {subscription.freeTrialDaysLeft} {subscription.freeTrialDaysLeft === 1 ? t.day : t.days}
                  </span>
                </div>
                <div className="text-amber-700 font-semibold">
                  {subscription.maxWeeklyQuestions - subscription.weeklyQuestionsCount} {t.questionsLeft}
                </div>
              </div>
              <div className="w-full bg-amber-200 rounded-full h-2 mt-2">
                <div 
                  className="bg-amber-500 h-2 rounded-full transition-all duration-500" 
                  style={{ width: `${(subscription.weeklyQuestionsCount / subscription.maxWeeklyQuestions) * 100}%` }}
                ></div>
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
                <p className="text-2xl text-white/90 max-w-3xl mx-auto leading-relaxed">
                  {t.subtitle}
                </p>
                <div className="mt-4 text-lg text-white/70">
                  www.math4child.com - {t.domain.tagline}
                </div>
                <div className="mt-2 text-sm text-white/60">
                  {t.domain.business}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl mx-auto mb-8">
                <button
                  onClick={startFreeTrial}
                  className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4 group"
                >
                  <Gift size={28} className="group-hover:animate-bounce" />
                  <span>{t.freeTrial}</span>
                </button>
                
                <button 
                  onClick={() => {
                    playSound('click', soundEnabled)
                    setShowSubscriptionModal(true)
                  }}
                  className="bg-gradient-to-r from-purple-400 to-pink-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4 group"
                >
                  <Crown size={28} className="group-hover:animate-pulse" />
                  <span>Premium</span>
                </button>
              </div>
              
              {/* Statistiques globales */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
                <div className="text-center bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                  <div className="text-3xl font-bold text-yellow-300 mb-2">195+</div>
                  <div className="text-white/80 text-sm">{t.language}s</div>
                </div>
                <div className="text-center bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                  <div className="text-3xl font-bold text-green-300 mb-2">5</div>
                  <div className="text-white/80 text-sm">{t.levels}</div>
                </div>
                <div className="text-center bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                  <div className="text-3xl font-bold text-blue-300 mb-2">4</div>
                  <div className="text-white/80 text-sm">Opérations</div>
                </div>
                <div className="text-center bg-white/10 rounded-xl p-4 backdrop-blur-sm">
                  <div className="text-3xl font-bold text-purple-300 mb-2">∞</div>
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
                <div className="text-6xl mb-4 animate-float">🌟</div>
                <h2 className="text-4xl font-bold text-white mb-4">{t.choosePlatform}</h2>
                <p className="text-xl text-white/80">Applications hybrides disponibles partout</p>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                <button
                  onClick={() => selectPlatform('web')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl group"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">🌐</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.web}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.web}</p>
                    <div className="bg-blue-500 text-white px-4 py-2 rounded-lg">
                      PWA • Offline • Fast
                    </div>
                  </div>
                </button>
                
                <button
                  onClick={() => selectPlatform('android')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl group"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">📱</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.android}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.android}</p>
                    <div className="bg-green-500 text-white px-4 py-2 rounded-lg">
                      Google Play • Haptic
                    </div>
                  </div>
                </button>
                
                <button
                  onClick={() => selectPlatform('ios')}
                  className="bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl group"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">🍎</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.ios}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.ios}</p>
                    <div className="bg-gray-800 text-white px-4 py-2 rounded-lg">
                      App Store • Premium
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
            {/* Mode de jeu */}
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-8 shadow-2xl">
              <h2 className="text-3xl font-bold text-white mb-8 text-center flex items-center justify-center gap-3">
                <GamepadIcon size={32} />
                Mode de jeu
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {[
                  { mode: 'classic', icon: '🎯', title: 'Classique', desc: 'Jeu traditionnel avec vies' },
                  { mode: 'timed', icon: '⏱️', title: 'Chrono', desc: '60 secondes pour scorer' },
                  { mode: 'survival', icon: '🔥', title: 'Survie', desc: 'Une seule vie, jusqu\'où ?' }
                ].map(({ mode, icon, title, desc }) => (
                  <button
                    key={mode}
                    onClick={() => {
                      playSound('click', soundEnabled)
                      setGameMode(mode as any)
                    }}
                    className={`p-6 rounded-2xl transition-all transform duration-300 ${
                      gameMode === mode
                        ? 'bg-white text-purple-600 shadow-2xl scale-105'
                        : 'bg-white/20 text-white hover:bg-white/30 hover:scale-102'
                    }`}
                  >
                    <div className="text-center">
                      <div className="text-4xl mb-3">{icon}</div>
                      <h3 className="text-xl font-bold mb-2">{title}</h3>
                      <p className="text-sm opacity-80">{desc}</p>
                    </div>
                  </button>
                ))}
              </div>
            </div>

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
                      onClick={() => {
                        if (unlocked) {
                          playSound('click', soundEnabled)
                          setGameState(prev => ({ ...prev, selectedLevel: level }))
                        }
                      }}
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
                          <Lock className="text-gray-300 animate-pulse" size={40} />
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
                            {progress.accuracy > 0 && (
                              <div className="text-xs text-green-400">
                                {progress.accuracy}% {t.accuracy}
                              </div>
                            )}
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
                      onClick={() => {
                        playSound('click', soundEnabled)
                        setGameState(prev => ({ ...prev, selectedOperation: key }))
                      }}
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
                className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-12 py-6 rounded-3xl text-2xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-2xl disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-4 mx-auto group"
              >
                <Play size={32} className="group-hover:animate-bounce" />
                <span>{t.startGame}</span>
                <div className="text-sm opacity-80">
                  {gameMode === 'classic' ? '🎯' : gameMode === 'timed' ? '⏱️' : '🔥'}
                </div>
              </button>
              {!isLevelUnlocked(gameState.selectedLevel) && (
                <p className="text-white/80 mt-4 text-lg">
                  {t.levelLocked} - {t.needMore} {100 - levelProgress[gameState.selectedLevel - 1]?.questionsCompleted || 0} {t.questionsToUnlock}
                </p>
              )}
            </div>
          </div>
        )}
        
        {/* INTERFACE DE JEU */}
        {gameState.currentState === 'playing' && gameState.currentQuestion && (
          <div className="space-y-8">
            {/* Stats du jeu */}
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
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
                      className={i < gameState.lives ? 'text-red-400 fill-current animate-pulse' : 'text-gray-400'} 
                    />
                  ))}
                </div>
                <div className="text-white/80 text-sm">{t.lives}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white">{gameState.selectedLevel}</div>
                <div className="text-white/80 text-sm">{t.level}</div>
              </div>
              {gameMode === 'timed' && (
                <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                  <div className={`text-3xl font-bold ${gameState.timeLeft <= 10 ? 'text-red-400 animate-bounce' : 'text-white'}`}>
                    {gameState.timeLeft}
                  </div>
                  <div className="text-white/80 text-sm">{t.timer}</div>
                </div>
              )}
            </div>
            
            {/* Pause/Resume */}
            {gameState.isPaused && (
              <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50">
                <div className="bg-white rounded-3xl p-12 text-center shadow-2xl">
                  <div className="text-6xl mb-4">⏸️</div>
                  <h2 className="text-3xl font-bold text-gray-800 mb-6">Jeu en pause</h2>
                  <div className="flex gap-4 justify-center">
                    <button
                      onClick={togglePause}
                      className="bg-green-500 text-white px-8 py-4 rounded-2xl font-bold hover:bg-green-600 transition-all flex items-center gap-2"
                    >
                      <Play size={24} />
                      {t.resume}
                    </button>
                    <button
                      onClick={backToMenu}
                      className="bg-gray-500 text-white px-8 py-4 rounded-2xl font-bold hover:bg-gray-600 transition-all flex items-center gap-2"
                    >
                      <Home size={24} />
                      {t.quit}
                    </button>
                  </div>
                </div>
              </div>
            )}
            
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
              
              {/* Bouton pause */}
              <button
                onClick={togglePause}
                className="absolute top-4 right-4 p-3 bg-gray-200 hover:bg-gray-300 rounded-xl transition-all"
              >
                <Settings size={24} className="text-gray-600" />
              </button>
              
              {/* Question */}
              <div className="relative z-20">
                <div className="text-7xl md:text-9xl font-bold text-gray-800 mb-8 font-mono animate-pulse-slow">
                  {gameState.currentQuestion.question} = ?
                </div>
                
                {/* Indicateur d'opération */}
                <div className="mb-6">
                  <span className="bg-purple-100 text-purple-800 px-4 py-2 rounded-full text-lg font-semibold">
                    {t.operations[gameState.currentQuestion.operation as keyof typeof t.operations]}
                  </span>
                </div>
                
                {/* Zone saisie */}
                <div className="space-y-8">
                  <input
                    type="number"
                    inputMode="numeric"
                    value={gameState.userAnswer}
                    onChange={(e) => setGameState(prev => ({ ...prev, userAnswer: e.target.value }))}
                    className="text-center text-6xl font-bold border-4 border-gray-300 rounded-3xl px-8 py-6 w-96 max-w-full focus:border-blue-500 focus:outline-none focus:ring-8 focus:ring-blue-200 transition-all font-mono"
                    placeholder="?"
                    autoFocus
                    onKeyPress={(e) => {
                      if (e.key === 'Enter' && gameState.userAnswer) {
                        checkAnswer()
                      }
                    }}
                  />
                  
                  {/* Boutons */}
                  <div className="flex flex-col sm:flex-row gap-4 justify-center">
                    <button
                      onClick={checkAnswer}
                      disabled={!gameState.userAnswer}
                      className="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed shadow-xl flex items-center justify-center space-x-3 group"
                    >
                      <Check size={28} className="group-hover:animate-bounce" />
                      <span>{t.check}</span>
                    </button>
                    <button
                      onClick={togglePause}
                      className="bg-gradient-to-r from-yellow-500 to-orange-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-yellow-600 hover:to-orange-700 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-3"
                    >
                      <Settings size={28} />
                      <span>{t.pause}</span>
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
                
                {/* Statistiques en temps réel */}
                <div className="mt-8 grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
                  <div className="bg-blue-50 rounded-lg p-3">
                    <div className="font-bold text-blue-800">{gameState.accuracy}%</div>
                    <div className="text-blue-600">{t.accuracy}</div>
                  </div>
                  <div className="bg-green-50 rounded-lg p-3">
                    <div className="font-bold text-green-800">{gameState.correctAnswers}</div>
                    <div className="text-green-600">Correctes</div>
                  </div>
                  <div className="bg-purple-50 rounded-lg p-3">
                    <div className="font-bold text-purple-800">{gameState.bestStreak}</div>
                    <div className="text-purple-600">Record série</div>
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
              <div className="text-8xl mb-6 animate-bounce">
                {gameState.correctAnswers > gameState.totalQuestions * 0.8 ? '🏆' : '🎮'}
              </div>
              <h2 className="text-5xl font-bold text-white mb-6">
                {gameState.correctAnswers > gameState.totalQuestions * 0.8 ? t.excellent : t.gameOver}
              </h2>
              
              {/* Résultats détaillés */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto mb-8">
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
                  <div className="text-3xl font-bold text-purple-300">{gameState.accuracy}%</div>
                  <div className="text-white/80 text-sm">{t.accuracy}</div>
                </div>
              </div>
              
              {/* Message encourageant */}
              <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-6 mb-8">
                <p className="text-xl text-gray-700">
                  {gameState.accuracy >= 90 ? `🌟 ${t.excellent} Tu es un champion des maths !` :
                   gameState.accuracy >= 70 ? `👏 ${t.goodJob} Continue comme ça !` :
                   gameState.accuracy >= 50 ? "💪 Bon travail ! Tu progresses bien !" :
                   `🎯 ${t.tryAgain} La pratique rend parfait !`}
                </p>
              </div>
              
              {/* Boutons d'action */}
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <button
                  onClick={startGame}
                  className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3 group"
                >
                  <Play size={28} className="group-hover:animate-bounce" />
                  <span>{t.playAgain}</span>
                </button>
                <button
                  onClick={backToMenu}
                  className="bg-gradient-to-r from-blue-400 to-blue-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-blue-500 hover:to-blue-600 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3"
                >
                  <Home size={28} />
                  <span>{t.home}</span>
                </button>
                <button
                  onClick={() => {
                    playSound('click', soundEnabled)
                    setShowSubscriptionModal(true)
                  }}
                  className="bg-gradient-to-r from-purple-400 to-pink-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3"
                >
                  <Crown size={28} />
                  <span>{t.upgradeNow}</span>
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
      
      {/* MODAL ABONNEMENT COMPLET */}
      {showSubscriptionModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-3xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <h2 className="text-4xl font-bold text-gray-800 flex items-center gap-3">
                  <Crown className="text-yellow-500" size={40} />
                  {t.subscription.title}
                </h2>
                <button
                  onClick={() => {
                    playSound('click', soundEnabled)
                    setShowSubscriptionModal(false)
                  }}
                  className="text-gray-500 hover:text-gray-700 p-2 hover:bg-gray-100 rounded-xl transition-all"
                >
                  <X size={32} />
                </button>
              </div>
              
              {/* Plans d'abonnement */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                {/* Plan Gratuit */}
                <div className="border-2 border-gray-300 rounded-2xl p-6 bg-gray-50 relative">
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">🎁</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.freeTitle}</h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">{getLocalizedPrice(0)}</div>
                    <div className="text-gray-600">{t.subscription.freeDuration}</div>
                  </div>
                  
                  <ul className="space-y-2 mb-6 text-sm">
                    {t.subscription.features.freeFeatures.map((feature, i) => (
                      <li key={i} className="flex items-center gap-2">
                        <Check size={16} className="text-green-500" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <div className="text-center">
                    <div className="bg-gray-400 text-white py-3 rounded-lg font-semibold">
                      Plan actuel
                    </div>
                  </div>
                </div>
                
                {/* Plan Web Premium */}
                <div className="border-2 border-blue-500 rounded-2xl p-6 bg-blue-50 relative">
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">🌐</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.webTitle}</h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">{getLocalizedPrice(9.99)}</div>
                    <div className="text-gray-600">{t.subscription.webDuration}</div>
                  </div>
                  
                  <ul className="space-y-2 mb-6 text-sm">
                    {t.subscription.features.premiumFeatures.slice(0, 4).map((feature, i) => (
                      <li key={i} className="flex items-center gap-2">
                        <Check size={16} className="text-green-500" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <button 
                    onClick={() => handleSubscription('web', 'monthly')}
                    className="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg font-semibold transition-all"
                  >
                    {t.subscription.selectPlan}
                  </button>
                </div>
                
                {/* Plan Multi-Plateformes */}
                <div className="border-2 border-green-500 rounded-2xl p-6 bg-green-50 relative">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-green-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                      {t.subscription.bestValue}
                    </span>
                  </div>
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">🚀</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.twoDevices}</h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">{getLocalizedPrice(14.99)}</div>
                    <div className="text-gray-600">/mois</div>
                    <div className="text-sm text-green-600">{t.subscription.twoDevicesSavings}</div>
                  </div>
                  
                  <ul className="space-y-2 mb-6 text-sm">
                    {t.subscription.features.multiFeatures.slice(0, 4).map((feature, i) => (
                      <li key={i} className="flex items-center gap-2">
                        <Check size={16} className="text-green-500" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <button 
                    onClick={() => handleSubscription('multi-2', 'monthly')}
                    className="w-full bg-green-500 hover:bg-green-600 text-white py-3 rounded-lg font-semibold transition-all"
                  >
                    {t.subscription.selectPlan}
                  </button>
                </div>
                
                {/* Plan Familial */}
                <div className="border-2 border-purple-500 rounded-2xl p-6 bg-purple-50 relative">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                      {t.subscription.mostPopular}
                    </span>
                  </div>
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">👨‍👩‍👧‍👦</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.threeDevices}</h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">{getLocalizedPrice(17.49)}</div>
                    <div className="text-gray-600">/mois</div>
                    <div className="text-sm text-purple-600">{t.subscription.threeDevicesSavings}</div>
                  </div>
                  
                  <ul className="space-y-2 mb-6 text-sm">
                    {t.subscription.features.multiFeatures.map((feature, i) => (
                      <li key={i} className="flex items-center gap-2">
                        <Check size={16} className="text-green-500" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <button 
                    onClick={() => handleSubscription('multi-3', 'monthly')}
                    className="w-full bg-purple-500 hover:bg-purple-600 text-white py-3 rounded-lg font-semibold transition-all"
                  >
                    {t.subscription.selectPlan}
                  </button>
                </div>
              </div>
              
              {/* Options de durée avec réductions */}
              <div className="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-2xl p-6 mb-8">
                <h3 className="text-2xl font-bold text-gray-800 mb-4 text-center">Économisez avec les abonnements longs</h3>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-white rounded-xl">
                    <h4 className="font-bold text-gray-800">{t.subscription.monthly}</h4>
                    <p className="text-sm text-gray-600">Prix normal</p>
                  </div>
                  <div className="text-center p-4 bg-blue-100 rounded-xl border-2 border-blue-500">
                    <h4 className="font-bold text-blue-800">{t.subscription.quarterly}</h4>
                    <p className="text-sm text-blue-600">{t.subscription.quarterlySavings}</p>
                  </div>
                  <div className="text-center p-4 bg-green-100 rounded-xl border-2 border-green-500">
                    <h4 className="font-bold text-green-800">{t.subscription.annual}</h4>
                    <p className="text-sm text-green-600">{t.subscription.annualSavings}</p>
                  </div>
                </div>
              </div>
              
              {/* Informations business */}
              <div className="text-center">
                <p className="text-sm text-gray-700 mb-2">
                  <strong>Paiement sécurisé via Stripe</strong> • Annulation à tout moment
                </p>
                <p className="text-xs text-gray-500">
                  {t.domain.business} • {t.domain.contact}
                </p>
                <p className="text-xs text-gray-400 mt-1">
                  www.math4child.com • Prix adaptés à votre région ({currentLangConfig.currency})
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
      
      {/* Support accessibilité et PWA */}
      <div className="sr-only">
        <h1>{currentLangConfig.appName} - Application éducative de mathématiques</h1>
        <p>Support de 195+ langues, 5 niveaux de difficulté, apprentissage ludique</p>
      </div>
    </div>
  )
}
PAGEEOF
    
    print_success "Composant principal Math4Child créé avec toutes les fonctionnalités"
}

# =============================================================================
# 2. CRÉATION DE L'INTÉGRATION STRIPE COMPLÈTE
# =============================================================================

create_stripe_integration() {
    print_section "2. CRÉATION DE L'INTÉGRATION STRIPE COMPLÈTE"
    
    mkdir -p "src/lib"
    
    cat > "src/lib/stripe.ts" << 'STRIPEEOF'
import Stripe from 'stripe'

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})

// Configuration business GOTEST
export const BUSINESS_CONFIG = {
  businessName: 'GOTEST - Math4Child.com',
  siret: '53958712100028',
  domain: 'www.math4child.com',
  email: 'khalid_ksouri@yahoo.fr',
  phone: '+33123456789',
  address: 'France',
  vatNumber: 'FR53958712100028'
}

// Configuration Qonto (compte business)
export const QONTO_CONFIG = {
  iban: 'FR76xxxxxxxxxxxxxxxxxxxx',
  bic: 'QNTOFRP1XXX',
  accountName: 'GOTEST'
}

// Plans d'abonnement avec réductions multi-plateformes
export const SUBSCRIPTION_PLANS = {
  // Plans individuels par plateforme
  web: {
    monthly: { name: 'Math4Child Web Premium', price: 999, currency: 'eur', interval: 'month' as const },
    quarterly: { name: 'Math4Child Web Premium (3 mois)', price: 2697, currency: 'eur', interval: 'month' as const, interval_count: 3, savings: '10%' },
    annual: { name: 'Math4Child Web Premium (Annuel)', price: 8392, currency: 'eur', interval: 'year' as const, savings: '30%' }
  },
  
  android: {
    monthly: { name: 'Math4Child Android Premium', price: 999, currency: 'eur', interval: 'month' as const },
    quarterly: { name: 'Math4Child Android Premium (3 mois)', price: 2697, currency: 'eur', interval: 'month' as const, interval_count: 3, savings: '10%' },
    annual: { name: 'Math4Child Android Premium (Annuel)', price: 8392, currency: 'eur', interval: 'year' as const, savings: '30%' }
  },
  
  ios: {
    monthly: { name: 'Math4Child iOS Premium', price: 999, currency: 'eur', interval: 'month' as const },
    quarterly: { name: 'Math4Child iOS Premium (3 mois)', price: 2697, currency: 'eur', interval: 'month' as const, interval_count: 3, savings: '10%' },
    annual: { name: 'Math4Child iOS Premium (Annuel)', price: 8392, currency: 'eur', interval: 'year' as const, savings: '30%' }
  },
  
  // Plans multi-plateformes avec réductions
  'multi-2': {
    monthly: { name: 'Math4Child 2 Appareils', price: 1499, currency: 'eur', interval: 'month' as const, savings: '50% sur 2ème appareil' },
    quarterly: { name: 'Math4Child 2 Appareils (3 mois)', price: 4047, currency: 'eur', interval: 'month' as const, interval_count: 3, savings: '50% + 10%' },
    annual: { name: 'Math4Child 2 Appareils (Annuel)', price: 12588, currency: 'eur', interval: 'year' as const, savings: '50% + 30%' }
  },
  
  'multi-3': {
    monthly: { name: 'Math4Child 3 Appareils', price: 1749, currency: 'eur', interval: 'month' as const, savings: '75% sur 3ème appareil' },
    quarterly: { name: 'Math4Child 3 Appareils (3 mois)', price: 4723, currency: 'eur', interval: 'month' as const, interval_count: 3, savings: '75% + 10%' },
    annual: { name: 'Math4Child 3 Appareils (Annuel)', price: 14693, currency: 'eur', interval: 'year' as const, savings: '75% + 30%' }
  }
}

// Adaptateurs de prix par région
export const CURRENCY_MODIFIERS: Record<string, { multiplier: number, currency: string }> = {
  // Europe
  'EUR': { multiplier: 1.0, currency: 'eur' },
  'GBP': { multiplier: 0.85, currency: 'gbp' },
  'CHF': { multiplier: 1.05, currency: 'chf' },
  
  // Amériques  
  'USD': { multiplier: 1.2, currency: 'usd' },
  'CAD': { multiplier: 1.0, currency: 'cad' },
  'BRL': { multiplier: 0.4, currency: 'brl' },
  'MXN': { multiplier: 0.5, currency: 'mxn' },
  
  // Asie
  'JPY': { multiplier: 1.1, currency: 'jpy' },
  'CNY': { multiplier: 0.8, currency: 'cny' },
  'INR': { multiplier: 0.2, currency: 'inr' },
  'KRW': { multiplier: 1.0, currency: 'krw' },
  'THB': { multiplier: 0.4, currency: 'thb' },
  'VND': { multiplier: 0.3, currency: 'vnd' },
  'IDR': { multiplier: 0.25, currency: 'idr' },
  
  // Afrique & Moyen-Orient
  'ZAR': { multiplier: 0.4, currency: 'zar' },
  'EGP': { multiplier: 0.3, currency: 'egp' },
  'SAR': { multiplier: 0.7, currency: 'sar' },
  'AED': { multiplier: 0.8, currency: 'aed' }
}

export function getLocalizedPlan(plan: string, duration: string, currency: string = 'EUR') {
  const basePlan = SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]?.[duration as keyof any]
  if (!basePlan) return null
  
  const modifier = CURRENCY_MODIFIERS[currency] || CURRENCY_MODIFIERS['EUR']
  
  return {
    ...basePlan,
    price: Math.round(basePlan.price * modifier.multiplier),
    currency: modifier.currency,
    original_currency: 'eur',
    modifier: modifier.multiplier
  }
}

export function generateMetadata(plan: string, duration: string, platform: string, language: string) {
  return {
    app: 'math4child',
    business: BUSINESS_CONFIG.businessName,
    siret: BUSINESS_CONFIG.siret,
    domain: BUSINESS_CONFIG.domain,
    plan: plan,
    duration: duration,
    platform: platform,
    language: language,
    version: '2.0.0'
  }
}
STRIPEEOF

    print_success "Intégration Stripe créée avec gestion des devises"
}

# =============================================================================
# 3. CRÉATION DES API ROUTES AVEC GESTION DES RÉDUCTIONS
# =============================================================================

create_api_routes() {
    print_section "3. CRÉATION DES API ROUTES"
    
    mkdir -p "src/app/api/stripe/create-checkout-session"
    mkdir -p "src/app/api/stripe/webhooks"
    
    cat > "src/app/api/stripe/create-checkout-session/route.ts" << 'CHECKOUTEOF'
import { NextRequest } from 'next/server'
import { stripe, BUSINESS_CONFIG, getLocalizedPlan, generateMetadata } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { plan, duration = 'monthly', platform, customerEmail, language = 'fr', currency = 'EUR' } = await request.json()
    
    console.log('🛒 Math4Child - Nouvelle session checkout:', { plan, duration, platform, currency })
    
    const planConfig = getLocalizedPlan(plan, duration, currency)
    if (!planConfig) {
      return Response.json({ error: 'Plan invalide' }, { status: 400 })
    }

    // Description détaillée du produit
    const description = `Math4Child.com - ${platform} - 195+ langues - ${planConfig.savings || 'Premium'}`
    const metadata = generateMetadata(plan, duration, platform, language)

    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      payment_method_types: ['card', 'sepa_debit'],
      line_items: [
        {
          price_data: {
            currency: planConfig.currency,
            product_data: {
              name: planConfig.name,
              description: description,
              images: ['https://www.math4child.com/logo-512.png'],
              metadata: {
                ...metadata,
                features: JSON.stringify([
                  'Tous les niveaux débloqués',
                  'Questions illimitées', 
                  'Sans publicité',
                  'Synchronisation multi-appareils',
                  '195+ langues supportées'
                ])
              }
            },
            unit_amount: planConfig.price,
            recurring: {
              interval: planConfig.interval,
              interval_count: planConfig.interval_count || 1
            }
          },
          quantity: 1,
        },
      ],
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/subscription/success?session_id={CHECKOUT_SESSION_ID}&plan=${plan}&duration=${duration}&platform=${platform}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/subscription/cancel?plan=${plan}`,
      customer_email: customerEmail,
      locale: language === 'fr' ? 'fr' : 'en',
      automatic_tax: {
        enabled: true
      },
      customer_creation: 'always',
      invoice_creation: {
        enabled: true,
        invoice_data: {
          description: `Abonnement ${planConfig.name}`,
          metadata: metadata,
          footer: `${BUSINESS_CONFIG.businessName} - SIRET: ${BUSINESS_CONFIG.siret}`
        }
      },
      metadata: metadata,
      billing_address_collection: 'required',
      shipping_address_collection: {
        allowed_countries: ['FR', 'BE', 'CH', 'DE', 'ES', 'IT', 'PT', 'NL', 'LU']
      }
    })

    console.log('✅ Session Stripe créée:', session.id)

    return Response.json({ 
      sessionId: session.id,
      url: session.url,
      plan: planConfig,
      business: BUSINESS_CONFIG.businessName
    })
    
  } catch (error) {
    console.error('❌ Erreur Stripe Math4Child:', error)
    return Response.json(
      { error: 'Erreur lors de la création de la session', details: error instanceof Error ? error.message : 'Erreur inconnue' }, 
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const sessionId = searchParams.get('session_id')
  
  if (!sessionId) {
    return Response.json({ error: 'Session ID manquant' }, { status: 400 })
  }

  try {
    const session = await stripe.checkout.sessions.retrieve(sessionId, {
      expand: ['customer', 'subscription']
    })

    return Response.json({
      session: {
        id: session.id,
        status: session.status,
        customer_email: session.customer_email,
        amount_total: session.amount_total,
        currency: session.currency,
        metadata: session.metadata
      }
    })
  } catch (error) {
    console.error('❌ Erreur récupération session:', error)
    return Response.json({ error: 'Session introuvable' }, { status: 404 })
  }
}
CHECKOUTEOF

    cat > "src/app/api/stripe/webhooks/route.ts" << 'WEBHOOKEOF'
import { NextRequest } from 'next/server'
import { stripe, BUSINESS_CONFIG, QONTO_CONFIG } from '@/lib/stripe'
import { headers } from 'next/headers'

export async function POST(request: NextRequest) {
  const body = await request.text()
  const signature = headers().get('stripe-signature')

  if (!signature) {
    return Response.json({ error: 'Signature manquante' }, { status: 400 })
  }

  try {
    // Mode développement : simulation sans vérification
    if (process.env.NODE_ENV === 'development') {
      console.log('🔧 Math4Child DEV - Webhook simulé')
      return Response.json({ received: true, dev_mode: true })
    }

    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )

    console.log('📨 Math4Child.com - Webhook:', event.type, event.data.object.id)

    switch (event.type) {
      case 'checkout.session.completed':
        await handleCheckoutCompleted(event.data.object)
        break
        
      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(event.data.object)
        break
        
      case 'customer.subscription.created':
        await handleSubscriptionCreated(event.data.object)
        break
        
      case 'customer.subscription.updated':
        await handleSubscriptionUpdated(event.data.object)
        break
        
      case 'customer.subscription.deleted':
        await handleSubscriptionCancelled(event.data.object)
        break
        
      case 'payout.paid':
        await handlePayoutToQonto(event.data.object)
        break
        
      default:
        console.log(`ℹ️  Événement non géré: ${event.type}`)
    }

    return Response.json({ received: true })
    
  } catch (error) {
    console.error('❌ Erreur webhook Math4Child:', error)
    return Response.json({ error: 'Erreur webhook' }, { status: 400 })
  }
}

async function handleCheckoutCompleted(session: any) {
  console.log('💰 Math4Child.com - Nouveau paiement:', {
    sessionId: session.id,
    customerEmail: session.customer_email,
    amount: `${session.amount_total / 100}€`,
    plan: session.metadata?.plan,
    platform: session.metadata?.platform,
    language: session.metadata?.language
  })
  
  // TODO: Activer l'abonnement utilisateur
  // TODO: Envoyer email de confirmation
  // TODO: Mise à jour base de données
}

async function handlePaymentSucceeded(invoice: any) {
  console.log('✅ Math4Child.com - Paiement récurrent réussi:', {
    invoiceId: invoice.id,
    customerId: invoice.customer,
    amount: `${invoice.amount_paid / 100}€`,
    period: invoice.period_start ? new Date(invoice.period_start * 1000).toLocaleDateString('fr-FR') : 'N/A'
  })
  
  // TODO: Prolonger l'abonnement
  // TODO: Générer facture automatique pour auto-entrepreneur
}

async function handleSubscriptionCreated(subscription: any) {
  console.log('🔔 Math4Child.com - Nouvel abonnement:', {
    subscriptionId: subscription.id,
    status: subscription.status,
    plan: subscription.metadata?.plan,
    platforms: subscription.metadata?.platform
  })
  
  // TODO: Débloquer toutes les fonctionnalités
}

async function handleSubscriptionUpdated(subscription: any) {
  console.log('🔄 Math4Child.com - Abonnement modifié:', {
    subscriptionId: subscription.id,
    status: subscription.status,
    platforms: subscription.metadata?.customer_platforms
  })
  
  // TODO: Mettre à jour les droits utilisateur
}

async function handleSubscriptionCancelled(subscription: any) {
  console.log('❌ Math4Child.com - Abonnement annulé:', {
    subscriptionId: subscription.id,
    platform: subscription.metadata?.platform
  })
  
  // TODO: Passer l'utilisateur en mode gratuit
  // TODO: Envoyer email de feedback
}

async function handlePayoutToQonto(payout: any) {
  console.log('🏦 GOTEST - Virement vers Qonto:', {
    amount: `${payout.amount / 100}€`,
    arrivalDate: new Date(payout.arrival_date * 1000).toLocaleDateString('fr-FR'),
    iban: QONTO_CONFIG.iban,
    business: BUSINESS_CONFIG.businessName
  })
  
  // TODO: Notification comptable auto-entrepreneur
  // TODO: Génération facture automatique
}
WEBHOOKEOF

    print_success "API routes Stripe avec gestion des réductions créées"
}

# =============================================================================
# 4. CRÉATION DES PAGES DE SUCCÈS ET ANNULATION
# =============================================================================

create_subscription_pages() {
    print_section "4. CRÉATION DES PAGES D'ABONNEMENT"
    
    mkdir -p "src/app/subscription/success"
    mkdir -p "src/app/subscription/cancel"
    
    cat > "src/app/subscription/success/page.tsx" << 'SUCCESSEOF'
'use client'

import { useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import Link from 'next/link'
import { Crown, Check, Sparkles, Globe, Calculator, Heart, Star, Gift } from 'lucide-react'

export default function SubscriptionSuccess() {
  const searchParams = useSearchParams()
  const [sessionId, setSessionId] = useState<string | null>(null)
  const [plan, setPlan] = useState<string>('')
  const [duration, setDuration] = useState<string>('')
  const [platform, setPlatform] = useState<string>('')

  useEffect(() => {
    const session = searchParams.get('session_id')
    const planParam = searchParams.get('plan') || ''
    const durationParam = searchParams.get('duration') || ''
    const platformParam = searchParams.get('platform') || ''
    
    setSessionId(session)
    setPlan(planParam)
    setDuration(durationParam)
    setPlatform(platformParam)
  }, [searchParams])

  const getPlanName = () => {
    if (plan.includes('multi-2')) return '2 Appareils'
    if (plan.includes('multi-3')) return '3 Appareils (Familial)'
    return platform === 'web' ? 'Web Premium' : 
           platform === 'android' ? 'Android Premium' : 
           platform === 'ios' ? 'iOS Premium' : 'Premium'
  }

  const getDurationName = () => {
    return duration === 'annual' ? 'Annuel (30% d\'économie)' :
           duration === 'quarterly' ? 'Trimestriel (10% d\'économie)' :
           'Mensuel'
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-400 via-emerald-500 to-teal-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-12 text-center shadow-2xl max-w-4xl w-full relative overflow-hidden">
        {/* Particules de succès */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute top-10 left-10 text-4xl animate-bounce">🎉</div>
          <div className="absolute top-20 right-20 text-3xl animate-pulse">⭐</div>
          <div className="absolute bottom-20 left-20 text-3xl animate-bounce animation-delay-1000">🚀</div>
          <div className="absolute bottom-10 right-10 text-4xl animate-pulse animation-delay-2000">✨</div>
        </div>
        
        <div className="relative z-10">
          <div className="text-8xl mb-6 animate-bounce">🎊</div>
          
          <div className="flex items-center justify-center gap-3 mb-6">
            <Crown className="text-yellow-500 animate-pulse" size={40} />
            <h1 className="text-4xl md:text-5xl font-bold text-gray-800">
              Math4Child Premium Activé !
            </h1>
            <Crown className="text-yellow-500 animate-pulse" size={40} />
          </div>
          
          <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-6 mb-8">
            <p className="text-xl text-gray-700 leading-relaxed">
              🌟 <strong>Félicitations !</strong> Votre abonnement Math4Child Premium est maintenant actif. 
              <br />
              Votre enfant a désormais accès à <strong>tous les niveaux</strong> et <strong>195+ langues</strong> !
            </p>
          </div>
          
          {/* Informations de l'abonnement */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
            <div className="bg-blue-50 rounded-xl p-4">
              <div className="flex items-center justify-center gap-2 mb-2">
                <Globe className="text-blue-500" size={24} />
                <span className="font-bold text-gray-800">Plateforme</span>
              </div>
              <div className="text-lg text-gray-700 capitalize">
                {platform === 'web' ? '🌐 Version Web' : 
                 platform === 'android' ? '📱 Application Android' : 
                 platform === 'ios' ? '🍎 Application iOS' : 
                 '