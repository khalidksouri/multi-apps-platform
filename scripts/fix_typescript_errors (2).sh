#!/bin/bash

# =============================================================================
# 🔧 CORRECTION DES ERREURS TYPESCRIPT MATH4CHILD
# Résolution de tous les problèmes de typage
# =============================================================================

set -e

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_ROOT/apps/math4child"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Vérifier que le projet existe
check_project() {
    if [[ ! -d "$APP_DIR" ]]; then
        error "Le projet Math4Child n'existe pas dans $APP_DIR"
    fi
    
    if [[ ! -f "$APP_DIR/src/app/page.tsx" ]]; then
        error "Le fichier page.tsx n'existe pas"
    fi
}

# Mettre à jour les types TypeScript
update_types() {
    log "🏷️ Mise à jour des types TypeScript..."
    
    cat > "$APP_DIR/src/types/global.d.ts" << 'EOF'
declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void
  }
  
  namespace NodeJS {
    interface ProcessEnv {
      NEXT_PUBLIC_BASE_URL: string
      NODE_ENV: 'development' | 'production' | 'test'
    }
  }
}

export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  countries: string[]
}

export interface Level {
  id: string
  name: string
  color: string
  range: [number, number]
  requiredAnswers: number
  description: string
}

export interface Operation {
  id: string
  name: string
  symbol: string
  color: string
}

export interface Question {
  questionText: string
  answer: number
  num1: number
  num2: number
  operation: string
}

export interface SubscriptionPlan {
  id: string
  title: string
  price: string
  duration: string
  features: string[]
  buttonText: string
  popular?: boolean
  bestValue?: boolean
  platforms: string[]
  originalPrice?: string
  discount?: string
}

export interface CountryPricing {
  currency: string
  symbol: string
  monthly: number
  quarterly: number
  yearly: number
}

export interface CorrectAnswers {
  beginner: number
  elementary: number
  intermediate: number
  advanced: number
  expert: number
}

export interface Translations {
  [key: string]: {
    [key: string]: string
  }
}

export {}
EOF

    success "Types TypeScript mis à jour"
}

# Corriger le composant principal avec les types appropriés
fix_main_component() {
    log "⚛️ Correction du composant principal avec types TypeScript..."
    
    cat > "$APP_DIR/src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react';
import { ChevronDown, Star, Play, Users, Trophy, Zap, Globe, Smartphone, BookOpen, BarChart3, Heart, ArrowRight, ArrowLeft, Calculator, Target, Award, Lock, Check, Crown, Shield } from 'lucide-react';
import type { Language, Level, Operation, Question, SubscriptionPlan, CountryPricing, CorrectAnswers, Translations } from '@/types/global';

const Math4ChildProduction = () => {
  // États principaux avec types appropriés
  const [currentLanguage, setCurrentLanguage] = useState<string>('fr');
  const [currentCountry, setCurrentCountry] = useState<string>('FR');
  const [showLanguageDropdown, setShowLanguageDropdown] = useState<boolean>(false);
  const [currentView, setCurrentView] = useState<string>('home');
  const [selectedLevel, setSelectedLevel] = useState<string>('');
  const [selectedOperation, setSelectedOperation] = useState<string>('');
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null);
  const [userAnswer, setUserAnswer] = useState<string>('');
  const [score, setScore] = useState<number>(0);
  const [streak, setStreak] = useState<number>(0);
  const [questionsAnswered, setQuestionsAnswered] = useState<number>(0);
  const [correctAnswers, setCorrectAnswers] = useState<CorrectAnswers>({
    beginner: 0, 
    elementary: 0, 
    intermediate: 0, 
    advanced: 0, 
    expert: 0
  });
  const [unlockedLevels, setUnlockedLevels] = useState<string[]>(['beginner']);
  const [lives, setLives] = useState<number>(3);
  const [feedback, setFeedback] = useState<string>('');
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [freeQuestionsLeft, setFreeQuestionsLeft] = useState<number>(50);
  const [userSubscriptions, setUserSubscriptions] = useState<string[]>([]);

  // Configuration des langues mondiales
  const worldLanguages: Language[] = [
    { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', countries: ['FR', 'BE', 'CH', 'CA'] },
    { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', countries: ['US', 'UK', 'CA', 'AU'] },
    { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', countries: ['ES', 'MX', 'AR', 'CO'] },
    { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', countries: ['DE', 'AT', 'CH'] },
    { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', countries: ['IT', 'CH'] },
    { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', countries: ['PT', 'BR'] },
    { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', countries: ['RU', 'BY', 'KZ'] },
    { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', countries: ['NL', 'BE'] },
    { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', countries: ['PL'] },
    { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', countries: ['SE'] },
    { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳', countries: ['CN', 'TW', 'SG'] },
    { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', countries: ['JP'] },
    { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', countries: ['KR'] },
    { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', countries: ['IN'] },
    { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', countries: ['SA', 'EG', 'AE'] },
    { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', countries: ['TH'] },
    { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', countries: ['VN'] },
    { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', countries: ['ID'] },
    { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', countries: ['MY'] },
    { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇹🇿', countries: ['TZ', 'KE'] }
  ];

  // Configuration des monnaies
  const countryPricing: Record<string, CountryPricing> = {
    FR: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    US: { currency: 'USD', symbol: '$', monthly: 9.99, quarterly: 26.97, yearly: 69.93 },
    DE: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    UK: { currency: 'GBP', symbol: '£', monthly: 7.49, quarterly: 20.22, yearly: 52.44 },
    ES: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    JP: { currency: 'JPY', symbol: '¥', monthly: 1449, quarterly: 3912, yearly: 10143 },
    CN: { currency: 'CNY', symbol: '¥', monthly: 35.99, quarterly: 97.17, yearly: 251.93 },
    IN: { currency: 'INR', symbol: '₹', monthly: 399, quarterly: 1077, yearly: 2793 },
    BR: { currency: 'BRL', symbol: 'R$', monthly: 25.99, quarterly: 70.17, yearly: 181.93 },
    AU: { currency: 'AUD', symbol: 'A$', monthly: 14.99, quarterly: 40.47, yearly: 104.93 }
  };

  // Système de traductions complet
  const translations: Translations = {
    fr: {
      appName: 'Math4Child',
      tagline: 'Apprendre les maths en s\'amusant !',
      home: 'Accueil',
      game: 'Jeu',
      levels: 'Niveaux',
      subscription: 'Abonnement',
      back: 'Retour',
      heroTitle: 'Math4Child',
      heroSubtitle: 'L\'application éducative n°1 pour apprendre les mathématiques',
      heroDescription: 'Domaine officiel: www.math4child.com - Application hybride disponible sur Web, Android et iOS',
      startFree: 'Essai gratuit (7 jours)',
      viewPlans: 'Voir les abonnements',
      freeWeekTrial: 'Essai gratuit d\'une semaine',
      questionsRemaining: 'questions restantes',
      chooseLevel: 'Choisissez votre niveau',
      levelProgression: 'Progression des niveaux',
      needCorrectAnswers: 'bonnes réponses requises pour débloquer',
      currentProgress: 'Progression actuelle',
      locked: 'Verrouillé',
      unlocked: 'Débloqué',
      beginner: 'Débutant (4-6 ans)',
      elementary: 'Élémentaire (6-8 ans)', 
      intermediate: 'Intermédiaire (8-10 ans)',
      advanced: 'Avancé (10-12 ans)',
      expert: 'Expert (12+ ans)',
      chooseOperation: 'Choisissez votre opération',
      addition: 'Addition (+)',
      subtraction: 'Soustraction (-)',
      multiplication: 'Multiplication (×)',
      division: 'Division (÷)',
      mixed: 'Exercices mixtes',
      question: 'Question',
      yourAnswer: 'Votre réponse',
      validate: 'Valider',
      next: 'Suivant',
      correct: 'Correct !',
      incorrect: 'Incorrect',
      theAnswerWas: 'La réponse était',
      score: 'Score',
      streak: 'Série',
      lives: 'Vies',
      gameOver: 'Jeu terminé !',
      finalScore: 'Score final',
      playAgain: 'Rejouer',
      subscriptionTitle: 'Choisissez votre abonnement',
      subscriptionSubtitle: 'Débloquez toutes les fonctionnalités sur une plateforme',
      multiDeviceDiscount: 'Réductions multi-plateformes disponibles',
      freeTrialTitle: 'Essai gratuit',
      monthlyTitle: 'Mensuel',
      quarterlyTitle: 'Trimestriel',
      yearlyTitle: 'Annuel',
      freeTrialFeatures: 'Essai d\'une semaine - 50 questions',
      monthlyFeatures: 'Accès complet - Une plateforme',
      quarterlyFeatures: 'Accès complet - 10% de réduction',
      yearlyFeatures: 'Accès complet - 30% de réduction',
      multiDeviceOffer: 'Deuxième plateforme à -50%, troisième à -75%',
      choosePlan: 'Choisir ce plan',
      popular: 'Populaire',
      bestValue: 'Meilleur rapport qualité-prix',
      recommended: 'Recommandé',
      webVersion: 'Version Web',
      androidVersion: 'Version Android',
      iosVersion: 'Version iOS',
      features: 'Fonctionnalités',
      allLevels: 'Tous les 5 niveaux',
      allOperations: 'Toutes les opérations',
      unlimitedQuestions: 'Questions illimitées',
      progressTracking: 'Suivi des progrès',
      multipleProfiles: 'profils multiples',
      prioritySupport: 'Support prioritaire',
      localPricing: 'Prix adaptés au pouvoir d\'achat local',
      paymentMethods: 'Tous types de paiements acceptés',
      subscriptionRequired: 'Abonnement requis',
      trialExpired: 'Essai gratuit expiré',
      upgradeNow: 'Mettre à niveau maintenant',
      availableLanguages: 'langues disponibles',
      scrollToExplore: 'Faites défiler pour explorer'
    },
    
    en: {
      appName: 'Math4Child',
      tagline: 'Learn math while having fun!',
      home: 'Home',
      game: 'Game',
      levels: 'Levels',
      subscription: 'Subscription',
      back: 'Back',
      heroTitle: 'Math4Child',
      heroSubtitle: 'The #1 educational app for learning mathematics',
      heroDescription: 'Official domain: www.math4child.com - Hybrid app available on Web, Android and iOS',
      startFree: 'Free trial (7 days)',
      viewPlans: 'View subscriptions',
      freeWeekTrial: 'One week free trial',
      questionsRemaining: 'questions remaining',
      chooseLevel: 'Choose your level',
      levelProgression: 'Level progression',
      needCorrectAnswers: 'correct answers required to unlock',
      currentProgress: 'Current progress',
      locked: 'Locked',
      unlocked: 'Unlocked',
      beginner: 'Beginner (4-6 years)',
      elementary: 'Elementary (6-8 years)',
      intermediate: 'Intermediate (8-10 years)',
      advanced: 'Advanced (10-12 years)',
      expert: 'Expert (12+ years)',
      chooseOperation: 'Choose your operation',
      addition: 'Addition (+)',
      subtraction: 'Subtraction (-)',
      multiplication: 'Multiplication (×)',
      division: 'Division (÷)',
      mixed: 'Mixed exercises',
      question: 'Question',
      yourAnswer: 'Your answer',
      validate: 'Validate',
      next: 'Next',
      correct: 'Correct!',
      incorrect: 'Incorrect',
      theAnswerWas: 'The answer was',
      score: 'Score',
      streak: 'Streak',
      lives: 'Lives',
      gameOver: 'Game over!',
      finalScore: 'Final score',
      playAgain: 'Play again',
      subscriptionTitle: 'Choose your subscription',
      subscriptionSubtitle: 'Unlock all features on one platform',
      multiDeviceDiscount: 'Multi-platform discounts available',
      freeTrialTitle: 'Free trial',
      monthlyTitle: 'Monthly',
      quarterlyTitle: 'Quarterly',
      yearlyTitle: 'Yearly',
      choosePlan: 'Choose this plan',
      popular: 'Popular',
      bestValue: 'Best value',
      features: 'Features',
      allLevels: 'All 5 levels',
      allOperations: 'All operations',
      unlimitedQuestions: 'Unlimited questions',
      progressTracking: 'Progress tracking',
      multipleProfiles: 'multiple profiles',
      prioritySupport: 'Priority support',
      localPricing: 'Pricing adapted to local purchasing power',
      paymentMethods: 'All payment types accepted',
      subscriptionRequired: 'Subscription required',
      trialExpired: 'Free trial expired',
      upgradeNow: 'Upgrade now',
      availableLanguages: 'available languages',
      scrollToExplore: 'Scroll to explore',
      freeTrialFeatures: 'One week trial - 50 questions',
      monthlyFeatures: 'Full access - One platform',
      quarterlyFeatures: 'Full access - 10% discount',
      yearlyFeatures: 'Full access - 30% discount',
      multiDeviceOffer: 'Second platform -50%, third -75%',
      recommended: 'Recommended',
      webVersion: 'Web Version',
      androidVersion: 'Android Version',
      iosVersion: 'iOS Version'
    }
  };

  // Fonction de traduction avec types appropriés
  const t = (key: string): string => {
    const lang = translations[currentLanguage as keyof typeof translations] || translations.fr;
    return lang[key] || translations.fr[key] || key;
  };

  // Configuration des niveaux avec progression
  const levels: Level[] = [
    { 
      id: 'beginner', 
      name: t('beginner'), 
      color: 'bg-green-500', 
      range: [1, 10],
      requiredAnswers: 100,
      description: 'Nombres 1-10'
    },
    { 
      id: 'elementary', 
      name: t('elementary'), 
      color: 'bg-blue-500', 
      range: [1, 50],
      requiredAnswers: 100,
      description: 'Nombres 1-50'
    },
    { 
      id: 'intermediate', 
      name: t('intermediate'), 
      color: 'bg-purple-500', 
      range: [1, 100],
      requiredAnswers: 100,
      description: 'Nombres 1-100'
    },
    { 
      id: 'advanced', 
      name: t('advanced'), 
      color: 'bg-red-500', 
      range: [1, 500],
      requiredAnswers: 100,
      description: 'Nombres 1-500'
    },
    { 
      id: 'expert', 
      name: t('expert'), 
      color: 'bg-gray-800', 
      range: [1, 1000],
      requiredAnswers: 100,
      description: 'Nombres 1-1000'
    }
  ];

  // Configuration des opérations
  const operations: Operation[] = [
    { id: 'addition', name: t('addition'), symbol: '+', color: 'bg-green-500' },
    { id: 'subtraction', name: t('subtraction'), symbol: '-', color: 'bg-blue-500' },
    { id: 'multiplication', name: t('multiplication'), symbol: '×', color: 'bg-purple-500' },
    { id: 'division', name: t('division'), symbol: '÷', color: 'bg-red-500' },
    { id: 'mixed', name: t('mixed'), symbol: '?', color: 'bg-gray-600' }
  ];

  // Configuration des abonnements
  const getSubscriptionPlans = (): SubscriptionPlan[] => {
    const country = countryPricing[currentCountry] || countryPricing.US;
    
    return [
      {
        id: 'free-trial',
        title: t('freeTrialTitle'),
        price: `${t('freeWeekTrial')}`,
        duration: '7 jours',
        features: [
          '50 questions totales',
          'Tous les niveaux',
          'Toutes les opérations',
          'Une seule plateforme'
        ],
        buttonText: t('choosePlan'),
        popular: false,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'monthly',
        title: t('monthlyTitle'),
        price: `${country.symbol}${country.monthly}`,
        duration: '/mois',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `10 ${t('multipleProfiles')}`,
          t('progressTracking')
        ],
        buttonText: t('choosePlan'),
        popular: true,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'quarterly',
        title: t('quarterlyTitle'),
        price: `${country.symbol}${country.quarterly}`,
        originalPrice: `${country.symbol}${(country.monthly * 3).toFixed(2)}`,
        duration: '/3 mois',
        discount: '10%',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `15 ${t('multipleProfiles')}`,
          t('progressTracking'),
          t('prioritySupport')
        ],
        buttonText: t('choosePlan'),
        popular: false,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'yearly',
        title: t('yearlyTitle'),
        price: `${country.symbol}${country.yearly}`,
        originalPrice: `${country.symbol}${(country.monthly * 12).toFixed(2)}`,
        duration: '/an',
        discount: '30%',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `25 ${t('multipleProfiles')}`,
          t('progressTracking'),
          t('prioritySupport'),
          'Accès beta features'
        ],
        buttonText: t('choosePlan'),
        popular: false,
        bestValue: true,
        platforms: ['web', 'android', 'ios']
      }
    ];
  };

  // Générateur d'opérations mathématiques
  const generateQuestion = (): Question | null => {
    const level = levels.find(l => l.id === selectedLevel);
    const operation = operations.find(op => op.id === selectedOperation);
    
    if (!level || !operation) return null;

    const [min, max] = level.range;
    let num1: number, num2: number, answer: number, questionText: string;

    const maxNum = Math.min(max, level.id === 'beginner' ? 10 : level.id === 'elementary' ? 20 : max);

    switch (operation.id) {
      case 'addition':
        num1 = Math.floor(Math.random() * maxNum) + min;
        num2 = Math.floor(Math.random() * maxNum) + min;
        answer = num1 + num2;
        questionText = `${num1} + ${num2} = ?`;
        break;
        
      case 'subtraction':
        num1 = Math.floor(Math.random() * maxNum) + min;
        num2 = Math.floor(Math.random() * num1) + 1;
        answer = num1 - num2;
        questionText = `${num1} - ${num2} = ?`;
        break;
        
      case 'multiplication':
        const multMax = level.id === 'beginner' ? 5 : level.id === 'elementary' ? 10 : 12;
        num1 = Math.floor(Math.random() * multMax) + 1;
        num2 = Math.floor(Math.random() * multMax) + 1;
        answer = num1 * num2;
        questionText = `${num1} × ${num2} = ?`;
        break;
        
      case 'division':
        const divMax = level.id === 'beginner' ? 5 : level.id === 'elementary' ? 10 : 12;
        answer = Math.floor(Math.random() * divMax) + 1;
        num2 = Math.floor(Math.random() * divMax) + 1;
        num1 = answer * num2;
        questionText = `${num1} ÷ ${num2} = ?`;
        break;
        
      default:
        return null;
    }

    return { questionText, answer, num1, num2, operation: operation.id };
  };

  // Validation et progression
  const validateAnswer = (): void => {
    if (!currentQuestion) return;
    
    const userNum = parseInt(userAnswer);
    const correct = userNum === currentQuestion.answer;
    
    setIsCorrect(correct);
    
    if (correct) {
      setScore(score + 10);
      setStreak(streak + 1);
      setFeedback(t('correct'));
      
      const newCorrectAnswers = { ...correctAnswers };
      (newCorrectAnswers as any)[selectedLevel]++;
      setCorrectAnswers(newCorrectAnswers);
      
      if ((newCorrectAnswers as any)[selectedLevel] >= 100) {
        const currentLevelIndex = levels.findIndex(l => l.id === selectedLevel);
        if (currentLevelIndex < levels.length - 1) {
          const nextLevel = levels[currentLevelIndex + 1];
          if (!unlockedLevels.includes(nextLevel.id)) {
            setUnlockedLevels([...unlockedLevels, nextLevel.id]);
            setFeedback(`${t('correct')} 🎉 Niveau ${nextLevel.name} débloqué !`);
          }
        }
      }
    } else {
      setLives(lives - 1);
      setStreak(0);
      setFeedback(`${t('incorrect')} ${t('theAnswerWas')} ${currentQuestion.answer}`);
    }
    
    setQuestionsAnswered(questionsAnswered + 1);
    
    if (freeQuestionsLeft > 0) {
      setFreeQuestionsLeft(freeQuestionsLeft - 1);
    }
  };

  // Question suivante
  const nextQuestion = (): void => {
    if (freeQuestionsLeft <= 0 && userSubscriptions.length === 0) {
      alert(t('subscriptionRequired'));
      setCurrentView('subscription');
      return;
    }
    
    if (lives <= 0) {
      alert(`${t('gameOver')} ${t('finalScore')}: ${score}`);
      setCurrentView('levels');
      return;
    }
    
    const question = generateQuestion();
    if (question) {
      setCurrentQuestion(question);
      setUserAnswer('');
      setFeedback('');
      setIsCorrect(null);
    }
  };

  // Démarrer le jeu
  const startGame = (): void => {
    if (freeQuestionsLeft <= 0 && userSubscriptions.length === 0) {
      alert(t('subscriptionRequired'));
      setCurrentView('subscription');
      return;
    }
    
    const question = generateQuestion();
    if (question) {
      setCurrentQuestion(question);
      setCurrentView('game');
      setQuestionsAnswered(0);
      setScore(0);
      setStreak(0);
      setLives(3);
      setFeedback('');
      setIsCorrect(null);
      setUserAnswer('');
    }
  };

  // Gestion du changement de langue
  const handleLanguageChange = (langCode: string): void => {
    setCurrentLanguage(langCode);
    setShowLanguageDropdown(false);
    
    const language = worldLanguages.find(l => l.code === langCode);
    if (language && language.countries.length > 0) {
      setCurrentCountry(language.countries[0]);
    }
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child-language', langCode);
      localStorage.setItem('math4child-country', currentCountry);
    }
    
    const rtlLanguages = ['ar', 'fa', 'ur'];
    if (typeof document !== 'undefined') {
      document.documentElement.dir = rtlLanguages.includes(langCode) ? 'rtl' : 'ltr';
    }
  };

  // Gestion des achats d'abonnement
  const handleSubscriptionPurchase = (planId: string, platform: string): void => {
    alert(`Achat simulé: ${planId} pour ${platform}`);
    
    let discount = 0;
    if (userSubscriptions.length === 1) discount = 50;
    if (userSubscriptions.length === 2) discount = 75;
    
    setUserSubscriptions([...userSubscriptions, platform]);
    setFreeQuestionsLeft(999999);
  };

  // Initialisation
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLang = localStorage.getItem('math4child-language') || 'fr';
      const savedCountry = localStorage.getItem('math4child-country') || 'FR';
      setCurrentLanguage(savedLang);
      setCurrentCountry(savedCountry);
      
      const rtlLanguages = ['ar', 'fa', 'ur'];
      if (document) {
        document.documentElement.dir = rtlLanguages.includes(savedLang) ? 'rtl' : 'ltr';
      }
    }
  }, []);

  // Rendu conditionnel des vues
  const renderCurrentView = () => {
    switch (currentView) {
      case 'levels':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-6xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-12">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">{t('chooseLevel')}</h1>
                <p className="text-lg text-gray-600">{t('levelProgression')}</p>
                <div className="mt-4 text-sm text-blue-600">
                  {freeQuestionsLeft > 0 ? `${freeQuestionsLeft} ${t('questionsRemaining')}` : t('subscriptionRequired')}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {levels.map((level, index) => {
                  const isUnlocked = unlockedLevels.includes(level.id);
                  const progress = (correctAnswers as any)[level.id] || 0;
                  
                  return (
                    <div 
                      key={level.id}
                      onClick={() => {
                        if (isUnlocked) {
                          setSelectedLevel(level.id);
                          setCurrentView('operations');
                        }
                      }}
                      className={`cursor-pointer group bg-white rounded-2xl p-6 shadow-lg transition-all duration-300 border-2 ${
                        isUnlocked 
                          ? 'hover:shadow-2xl transform hover:-translate-y-2 border-gray-100 hover:border-blue-300' 
                          : 'opacity-60 cursor-not-allowed border-gray-200'
                      }`}
                    >
                      <div className={`w-16 h-16 ${isUnlocked ? level.color : 'bg-gray-400'} rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg ${isUnlocked ? 'group-hover:scale-110' : ''} transition-transform relative`}>
                        {isUnlocked ? (
                          <span className="text-white font-bold text-xl">{index + 1}</span>
                        ) : (
                          <Lock className="w-8 h-8 text-white" />
                        )}
                      </div>
                      
                      <h3 className="text-xl font-bold text-center text-gray-900 mb-2">{level.name}</h3>
                      <p className="text-center text-gray-600 text-sm mb-4">{level.description}</p>
                      
                      <div className="mb-4">
                        <div className="flex justify-between text-xs text-gray-500 mb-1">
                          <span>{progress}/100</span>
                          <span>{isUnlocked ? t('unlocked') : t('locked')}</span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className={`${level.color} h-2 rounded-full transition-all duration-500`}
                            style={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                          ></div>
                        </div>
                      </div>
                      
                      {!isUnlocked && (
                        <p className="text-center text-xs text-gray-500">
                          {100 - ((correctAnswers as any)[levels[index - 1]?.id] || 0)} {t('needCorrectAnswers')}
                        </p>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        );

      case 'operations':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-4xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('levels')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <h1 className="text-4xl font-bold text-center mb-12 text-gray-900">
                {t('chooseOperation')}
              </h1>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {operations.map((operation) => (
                  <div 
                    key={operation.id}
                    onClick={() => {
                      setSelectedOperation(operation.id);
                      startGame();
                    }}
                    className="cursor-pointer group bg-white rounded-2xl p-6 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100"
                  >
                    <div className={`w-16 h-16 ${operation.color} rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg group-hover:scale-110 transition-transform`}>
                      <span className="text-white font-bold text-2xl">{operation.symbol}</span>
                    </div>
                    <h3 className="text-xl font-bold text-center text-gray-900">{operation.name}</h3>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      case 'game':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-2xl mx-auto px-4">
              <div className="bg-white rounded-2xl p-8 shadow-xl">
                <div className="flex justify-between items-center mb-8">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-blue-600">{score}</div>
                    <div className="text-sm text-gray-600">{t('score')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-green-600">{streak}</div>
                    <div className="text-sm text-gray-600">{t('streak')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-red-600">{lives}</div>
                    <div className="text-sm text-gray-600">{t('lives')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-lg font-bold text-purple-600">{(correctAnswers as any)[selectedLevel]}/100</div>
                    <div className="text-sm text-gray-600">Progression</div>
                  </div>
                </div>

                <div className="text-center mb-8">
                  <h2 className="text-6xl font-bold text-gray-900 mb-6">
                    {currentQuestion?.questionText}
                  </h2>
                  
                  <input
                    type="number"
                    value={userAnswer}
                    onChange={(e) => setUserAnswer(e.target.value)}
                    placeholder={t('yourAnswer')}
                    className="text-3xl text-center border-2 border-gray-300 rounded-xl px-6 py-4 w-64 focus:border-blue-500 focus:outline-none"
                    onKeyPress={(e) => {
                      if (e.key === 'Enter' && userAnswer && !isCorrect) {
                        validateAnswer();
                      }
                    }}
                  />
                </div>

                {feedback && (
                  <div className={`text-center mb-6 p-4 rounded-xl ${
                    isCorrect 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-red-100 text-red-800'
                  }`}>
                    <div className="text-xl font-bold">{feedback}</div>
                  </div>
                )}

                <div className="flex justify-center space-x-4">
                  {!feedback ? (
                    <button
                      onClick={validateAnswer}
                      disabled={!userAnswer}
                      className="bg-blue-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {t('validate')}
                    </button>
                  ) : (
                    <button
                      onClick={nextQuestion}
                      className="bg-green-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-green-700"
                    >
                      {t('next')}
                    </button>
                  )}
                  
                  <button
                    onClick={() => setCurrentView('operations')}
                    className="bg-gray-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-gray-700"
                  >
                    {t('back')}
                  </button>
                </div>

                {freeQuestionsLeft <= 50 && (
                  <div className="text-center mt-6 p-3 bg-yellow-100 rounded-lg">
                    <span className="text-yellow-800 font-medium">
                      {freeQuestionsLeft} {t('questionsRemaining')}
                    </span>
                  </div>
                )}
              </div>
            </div>
          </div>
        );

      case 'subscription':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-7xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-16">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">{t('subscriptionTitle')}</h1>
                <p className="text-xl text-gray-600 mb-4">{t('subscriptionSubtitle')}</p>
                <p className="text-lg text-blue-600">{t('multiDeviceDiscount')}</p>
                <div className="text-sm text-gray-500 mt-2">
                  {t('localPricing')} - {t('paymentMethods')}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                {getSubscriptionPlans().map((plan) => (
                  <div 
                    key={plan.id}
                    className={`relative bg-white rounded-3xl p-6 shadow-xl transition-all duration-300 transform hover:scale-105 border-2 ${
                      plan.popular ? 'ring-4 ring-blue-200 ring-opacity-50 border-blue-300' : 
                      plan.bestValue ? 'ring-4 ring-green-200 ring-opacity-50 border-green-300' : 
                      'border-gray-200'
                    }`}
                  >
                    {plan.popular && (
                      <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-bold shadow-lg">
                          ⭐ {t('popular')}
                        </div>
                      </div>
                    )}
                    
                    {plan.bestValue && (
                      <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <div className="bg-gradient-to-r from-green-600 to-emerald-600 text-white px-4 py-2 rounded-full text-sm font-bold shadow-lg">
                          💎 {t('bestValue')}
                        </div>
                      </div>
                    )}
                    
                    <div className="text-center mb-6">
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.title}</h3>
                      <div className="mb-2">
                        <span className="text-3xl font-bold text-blue-600">{plan.price}</span>
                        <span className="text-gray-600 text-sm">{plan.duration}</span>
                      </div>
                      
                      {plan.originalPrice && (
                        <div className="text-center">
                          <span className="text-sm text-gray-500 line-through">{plan.originalPrice}</span>
                          <span className="text-green-600 text-sm font-bold ml-2">-{plan.discount}</span>
                        </div>
                      )}
                    </div>
                    
                    <ul className="space-y-3 mb-8">
                      {plan.features.map((feature, index) => (
                        <li key={index} className="flex items-start">
                          <Check className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                          <span className="text-gray-700 text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>
                    
                    <button 
                      onClick={() => {
                        alert(`Sélection du plan: ${plan.title}`);
                      }}
                      className={`w-full py-3 rounded-xl font-bold text-lg transition-all duration-300 ${
                        plan.popular || plan.bestValue
                          ? 'bg-gradient-to-r from-blue-600 to-purple-600 text-white shadow-lg hover:shadow-xl transform hover:scale-105' 
                          : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                      }`}
                    >
                      {plan.buttonText}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      default: // home
        return (
          <div>
            <section className="py-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
              <div className="max-w-7xl mx-auto text-center">
                <div className="inline-flex items-center px-4 py-2 rounded-full bg-gradient-to-r from-blue-100 to-purple-100 text-blue-800 text-sm font-semibold mb-8 shadow-sm">
                  <Globe className="w-4 h-4 mr-2" />
                  {worldLanguages.length}+ langues supportées dans le monde entier
                </div>

                <h1 className="text-5xl md:text-7xl font-bold mb-8 leading-tight">
                  <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                    {t('heroTitle')}
                  </span>
                </h1>
                
                <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-4xl mx-auto">
                  {t('heroSubtitle')}
                </p>
                
                <p className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto">
                  {t('heroDescription')}
                </p>
                
                <div className="bg-gradient-to-r from-green-100 to-blue-100 rounded-2xl p-6 mb-12 max-w-md mx-auto">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{t('freeWeekTrial')}</h3>
                  <div className="text-3xl font-bold text-green-600 mb-2">{freeQuestionsLeft}/50</div>
                  <p className="text-sm text-gray-600">{t('questionsRemaining')}</p>
                  <div className="w-full bg-gray-200 rounded-full h-2 mt-3">
                    <div 
                      className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full transition-all duration-500"
                      style={{ width: `${(freeQuestionsLeft / 50) * 100}%` }}
                    ></div>
                  </div>
                </div>
                
                <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
                  <button 
                    onClick={() => setCurrentView('levels')}
                    className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Play className="w-6 h-6 mr-3" />
                    {t('startFree')}
                    <ArrowRight className="w-5 h-5 ml-2 group-hover:translate-x-1 transition-transform" />
                  </button>
                  
                  <button 
                    onClick={() => setCurrentView('subscription')}
                    className="group bg-white text-gray-800 px-8 py-4 rounded-xl font-bold text-lg border-2 border-gray-200 hover:border-blue-300 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Crown className="w-6 h-6 mr-3 text-blue-600" />
                    {t('viewPlans')}
                  </button>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-4xl mx-auto mb-16">
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-blue-600 mb-2">{worldLanguages.length}+</div>
                    <div className="text-gray-600 font-medium">Langues</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-green-600 mb-2">5</div>
                    <div className="text-gray-600 font-medium">Niveaux</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-purple-600 mb-2">5</div>
                    <div className="text-gray-600 font-medium">Opérations</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-red-600 mb-2">3</div>
                    <div className="text-gray-600 font-medium">Plateformes</div>
                  </div>
                </div>

                <div className="bg-white rounded-2xl p-8 shadow-xl max-w-4xl mx-auto">
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">{t('levelProgression')}</h3>
                  <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                    {levels.map((level, index) => {
                      const isUnlocked = unlockedLevels.includes(level.id);
                      const progress = (correctAnswers as any)[level.id] || 0;
                      
                      return (
                        <div key={level.id} className="text-center">
                          <div className={`w-12 h-12 ${isUnlocked ? level.color : 'bg-gray-300'} rounded-full flex items-center justify-center mb-2 mx-auto`}>
                            {isUnlocked ? (
                              <span className="text-white font-bold">{index + 1}</span>
                            ) : (
                              <Lock className="w-6 h-6 text-white" />
                            )}
                          </div>
                          <div className="text-sm font-medium text-gray-900 mb-1">{level.name.split(' ')[0]}</div>
                          <div className="text-xs text-gray-500">{progress}/100</div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </section>

            <section className="py-20 bg-white">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 className="text-4xl font-bold text-center mb-16 text-gray-900">{t('features')}</h2>
                
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  {[
                    { 
                      icon: <Target className="w-8 h-8" />, 
                      title: "Système de Progression", 
                      description: "5 niveaux adaptatifs avec déblocage progressif",
                      color: 'from-blue-400 to-blue-600' 
                    },
                    { 
                      icon: <Calculator className="w-8 h-8" />, 
                      title: "Opérations Mathématiques", 
                      description: "Addition, soustraction, multiplication, division et exercices mixtes",
                      color: 'from-green-400 to-green-600' 
                    },
                    { 
                      icon: <Globe className="w-8 h-8" />, 
                      title: "Langues Mondiales", 
                      description: "20+ langues avec support RTL pour l'arabe",
                      color: 'from-purple-400 to-purple-600' 
                    },
                    { 
                      icon: <Crown className="w-8 h-8" />, 
                      title: "Réductions Multi-plateformes", 
                      description: "2ème plateforme -50%, 3ème plateforme -75%",
                      color: 'from-orange-400 to-orange-600' 
                    },
                    { 
                      icon: <Shield className="w-8 h-8" />, 
                      title: "Pricing Localisé", 
                      description: "Prix adaptés au pouvoir d'achat de chaque région",
                      color: 'from-red-400 to-red-600' 
                    },
                    { 
                      icon: <Smartphone className="w-8 h-8" />, 
                      title: "Application Hybride", 
                      description: "Disponible sur Web, Android et iOS",
                      color: 'from-indigo-400 to-indigo-600' 
                    }
                  ].map((feature, index) => (
                    <div key={index} className="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 border border-gray-100">
                      <div className={`w-16 h-16 bg-gradient-to-r ${feature.color} rounded-2xl flex items-center justify-center mb-6 shadow-lg group-hover:scale-110 transition-transform text-white`}>
                        {feature.icon}
                      </div>
                      <h3 className="text-2xl font-bold text-gray-900 mb-4">{feature.title}</h3>
                      <p className="text-gray-600 leading-relaxed">{feature.description}</p>
                    </div>
                  ))}
                </div>
              </div>
            </section>

            <section className="py-20 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600">
              <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                  Prêt pour l'aventure mathématique ?
                </h2>
                <p className="text-xl text-blue-100 mb-12 max-w-2xl mx-auto">
                  Commencez avec 50 questions gratuites et découvrez pourquoi Math4Child est l'application préférée des familles.
                </p>
                
                <div className="flex flex-col sm:flex-row gap-6 justify-center">
                  <button 
                    onClick={() => setCurrentView('levels')}
                    className="bg-white text-blue-600 px-8 py-4 rounded-xl font-bold text-lg shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300"
                  >
                    {t('startFree')}
                  </button>
                  <button 
                    onClick={() => setCurrentView('subscription')}
                    className="bg-transparent border-2 border-white text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-white hover:text-blue-600 transition-all duration-300"
                  >
                    {t('viewPlans')}
                  </button>
                </div>
              </div>
            </section>
          </div>
        );
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      <header className="bg-white/90 backdrop-blur-sm shadow-lg sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-20">
            <div 
              onClick={() => setCurrentView('home')}
              className="flex items-center space-x-4 cursor-pointer"
            >
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <span className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  {t('appName')}
                </span>
                <div className="text-xs text-gray-500 font-medium">www.math4child.com</div>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              <nav className="hidden md:flex space-x-8">
                <button 
                  onClick={() => setCurrentView('home')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('home')}
                </button>
                <button 
                  onClick={() => setCurrentView('levels')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('game')}
                </button>
                <button 
                  onClick={() => setCurrentView('subscription')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('subscription')}
                </button>
              </nav>
              
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-2 px-4 py-2 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 transition-all shadow-sm"
                >
                  <span className="text-xl">{worldLanguages.find(l => l.code === currentLanguage)?.flag}</span>
                  <span className="hidden sm:inline font-medium">{worldLanguages.find(l => l.code === currentLanguage)?.name}</span>
                  <ChevronDown className="w-4 h-4 text-gray-500" />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-2xl border border-gray-100 z-50">
                    <div className="p-3 border-b border-gray-100 bg-gray-50 rounded-t-xl">
                      <div className="text-xs text-gray-600 text-center font-medium">
                        {worldLanguages.length} {t('availableLanguages')}
                      </div>
                    </div>
                    
                    <div className="max-h-80 overflow-y-auto scrollbar-thin scrollbar-thumb-blue-300 scrollbar-track-gray-100">
                      <div className="p-2">
                        {worldLanguages.map((lang) => (
                          <button
                            onClick={() => handleLanguageChange(lang.code)}
                            className={`w-full flex items-center space-x-3 px-3 py-2 hover:bg-blue-50 transition-colors rounded-lg ${
                              currentLanguage === lang.code ? 'bg-blue-50 border-r-4 border-blue-500' : ''
                            }`}
                          >
                            <span className="text-lg">{lang.flag}</span>
                            <div className="text-left flex-1">
                              <div className="font-medium text-gray-900 text-sm">{lang.name}</div>
                              <div className="text-xs text-gray-500">{lang.nativeName}</div>
                            </div>
                            {currentLanguage === lang.code && <Check className="w-4 h-4 text-blue-500" />}
                          </button>
                        ))}
                      </div>
                    </div>
                    
                    <div className="p-2 border-t border-gray-100 bg-gray-50 rounded-b-xl">
                      <div className="text-xs text-gray-500 text-center">
                        <span className="inline-flex items-center">
                          <span className="mr-1">↕️</span>
                          {t('scrollToExplore')}
                        </span>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {renderCurrentView()}
    </div>
  );
};

export default Math4ChildProduction;
EOF

    success "Composant principal corrigé avec types TypeScript"
}

# Test de compilation
test_typescript() {
    log "🧪 Test de compilation TypeScript..."
    
    cd "$APP_DIR"
    
    # Type checking
    npm run type-check
    
    if [[ $? -eq 0 ]]; then
        success "✅ Type checking réussi !"
    else
        error "❌ Erreurs TypeScript détectées"
    fi
    
    # Build test
    npm run build
    
    if [[ $? -eq 0 ]]; then
        success "✅ Build réussi !"
        echo ""
        echo -e "${BLUE}🎉 Math4Child est maintenant prêt avec TypeScript corrigé !${NC}"
        echo -e "${GREEN}🚀 Lancez: npm run dev${NC}"
    else
        error "❌ Build échoué"
    fi
    
    cd - > /dev/null
}

# Fonction principale
main() {
    echo ""
    echo -e "${BLUE}=================================================================${NC}"
    echo -e "${BLUE}🔧 CORRECTION DES ERREURS TYPESCRIPT MATH4CHILD${NC}"
    echo -e "${BLUE}=================================================================${NC}"
    echo ""
    
    log "🎯 Correction de tous les problèmes de typage..."
    
    check_project
    update_types
    fix_main_component
    test_typescript
    
    echo ""
    echo -e "${GREEN}=================================================================${NC}"
    echo -e "${GREEN}✅ TOUTES LES ERREURS TYPESCRIPT ONT ÉTÉ CORRIGÉES !${NC}"
    echo -e "${GREEN}=================================================================${NC}"
    echo ""
    echo -e "${BLUE}🎯 Corrections appliquées:${NC}"
    echo -e "   ✅ Types d'interfaces complètes"
    echo -e "   ✅ Typage des fonctions et paramètres"
    echo -e "   ✅ Gestion des états avec types appropriés"
    echo -e "   ✅ Protection contre null/undefined"
    echo -e "   ✅ Index signatures pour les objets dynamiques"
    echo -e "   ✅ Types génériques pour les traductions"
    echo ""
    echo -e "${GREEN}🚀 Math4Child TypeScript est maintenant parfaitement typé !${NC}"
}

# Exécution
main "$@"
                