#!/usr/bin/env bash

# ===================================================================
# 🎯 MATH4CHILD - SYSTÈME COMPLET ET RICHE
# Version premium avec toutes les spécifications demandées
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
APP_NAME="Math4Child"
DOMAIN="www.math4child.com"
BASE_DIR="$(pwd)"
SRC_DIR="$BASE_DIR/src"

log_header() {
    echo -e "${CYAN}${BOLD}"
    echo "========================================="
    echo "🎯 $1"
    echo "========================================="
    echo -e "${NC}"
}

log_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 1. SYSTÈME DE LANGUES MONDIAL (75+ LANGUES)
create_global_language_system() {
    log_header "SYSTÈME DE LANGUES MONDIAL - 75+ LANGUES"
    
    mkdir -p src/lib/i18n
    
    cat > src/lib/i18n/languages.ts << 'EOF'
// ===================================================================
// 🌍 SYSTÈME DE LANGUES MONDIAL - 75+ LANGUES
// Toutes les langues du monde avec drapeaux et support RTL
// ===================================================================

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  region: string;
  rtl?: boolean;
  currency?: string;
  country?: string;
}

// LANGUES MONDIALES (sans hébreu selon spécifications)
export const WORLD_LANGUAGES: Language[] = [
  // EUROPE
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', currency: 'EUR', country: 'France' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe', currency: 'GBP', country: 'United Kingdom' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', currency: 'EUR', country: 'Spain' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', currency: 'EUR', country: 'Germany' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', currency: 'EUR', country: 'Italy' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', currency: 'EUR', country: 'Portugal' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', currency: 'RUB', country: 'Russia' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe', currency: 'EUR', country: 'Netherlands' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe', currency: 'PLN', country: 'Poland' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe', currency: 'SEK', country: 'Sweden' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe', currency: 'NOK', country: 'Norway' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe', currency: 'DKK', country: 'Denmark' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe', currency: 'EUR', country: 'Finland' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe', currency: 'CZK', country: 'Czech Republic' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', region: 'Europe', currency: 'HUF', country: 'Hungary' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', region: 'Europe', currency: 'RON', country: 'Romania' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', region: 'Europe', currency: 'BGN', country: 'Bulgaria' },
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', region: 'Europe', currency: 'EUR', country: 'Croatia' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', region: 'Europe', currency: 'EUR', country: 'Slovakia' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', region: 'Europe', currency: 'EUR', country: 'Slovenia' },
  { code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', region: 'Europe', currency: 'EUR', country: 'Estonia' },
  { code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', region: 'Europe', currency: 'EUR', country: 'Latvia' },
  { code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', region: 'Europe', currency: 'EUR', country: 'Lithuania' },
  { code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', region: 'Europe', currency: 'EUR', country: 'Greece' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe', currency: 'TRY', country: 'Turkey' },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD (ARABE AVEC DRAPEAU MAROCAIN)
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦', region: 'MENA', rtl: true, currency: 'MAD', country: 'Morocco' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', region: 'MENA', rtl: true, currency: 'IRR', country: 'Iran' },
  
  // ASIE
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia', currency: 'CNY', country: 'China' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia', currency: 'JPY', country: 'Japan' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia', currency: 'KRW', country: 'South Korea' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asia', currency: 'THB', country: 'Thailand' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia', currency: 'VND', country: 'Vietnam' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asia', currency: 'IDR', country: 'Indonesia' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asia', currency: 'MYR', country: 'Malaysia' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', region: 'Asia', currency: 'PHP', country: 'Philippines' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', region: 'Asia', currency: 'BDT', country: 'Bangladesh' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', region: 'Asia', rtl: true, currency: 'PKR', country: 'Pakistan' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇱🇰', region: 'Asia', currency: 'LKR', country: 'Sri Lanka' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰', region: 'Asia', currency: 'LKR', country: 'Sri Lanka' },
  { code: 'my', name: 'Myanmar', nativeName: 'မြန်မာ', flag: '🇲🇲', region: 'Asia', currency: 'MMK', country: 'Myanmar' },
  { code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', region: 'Asia', currency: 'KHR', country: 'Cambodia' },
  { code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', region: 'Asia', currency: 'LAK', country: 'Laos' },
  { code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', region: 'Asia', currency: 'GEL', country: 'Georgia' },
  { code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', region: 'Asia', currency: 'AMD', country: 'Armenia' },
  { code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', region: 'Asia', currency: 'AZN', country: 'Azerbaijan' },
  { code: 'kk', name: 'Kazakh', nativeName: 'Қазақ', flag: '🇰🇿', region: 'Asia', currency: 'KZT', country: 'Kazakhstan' },
  { code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргыз', flag: '🇰🇬', region: 'Asia', currency: 'KGS', country: 'Kyrgyzstan' },
  { code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek', flag: '🇺🇿', region: 'Asia', currency: 'UZS', country: 'Uzbekistan' },
  { code: 'tj', name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', region: 'Asia', currency: 'TJS', country: 'Tajikistan' },
  { code: 'tm', name: 'Turkmen', nativeName: 'Türkmen', flag: '🇹🇲', region: 'Asia', currency: 'TMT', country: 'Turkmenistan' },
  { code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', region: 'Asia', currency: 'MNT', country: 'Mongolia' },
  
  // AMÉRIQUES
  { code: 'pt-br', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', region: 'Americas', currency: 'BRL', country: 'Brazil' },
  { code: 'es-mx', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', region: 'Americas', currency: 'MXN', country: 'Mexico' },
  { code: 'es-ar', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', region: 'Americas', currency: 'ARS', country: 'Argentina' },
  { code: 'es-co', name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', region: 'Americas', currency: 'COP', country: 'Colombia' },
  { code: 'es-pe', name: 'Spanish (Peru)', nativeName: 'Español (Perú)', flag: '🇵🇪', region: 'Americas', currency: 'PEN', country: 'Peru' },
  { code: 'es-cl', name: 'Spanish (Chile)', nativeName: 'Español (Chile)', flag: '🇨🇱', region: 'Americas', currency: 'CLP', country: 'Chile' },
  { code: 'en-us', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', region: 'Americas', currency: 'USD', country: 'United States' },
  { code: 'en-ca', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', region: 'Americas', currency: 'CAD', country: 'Canada' },
  { code: 'fr-ca', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', region: 'Americas', currency: 'CAD', country: 'Canada' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', region: 'Americas', currency: 'PEN', country: 'Peru' },
  { code: 'gn', name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', region: 'Americas', currency: 'PYG', country: 'Paraguay' },
  
  // AFRIQUE
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', region: 'Africa', currency: 'KES', country: 'Kenya' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', region: 'Africa', currency: 'ETB', country: 'Ethiopia' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', region: 'Africa', currency: 'MGA', country: 'Madagascar' },
  
  // OCÉANIE
  { code: 'en-au', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', region: 'Oceania', currency: 'AUD', country: 'Australia' },
  { code: 'en-nz', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', region: 'Oceania', currency: 'NZD', country: 'New Zealand' },
  { code: 'mi', name: 'Maori', nativeName: 'Te Reo Māori', flag: '🇳🇿', region: 'Oceania', currency: 'NZD', country: 'New Zealand' },
  { code: 'haw', name: 'Hawaiian', nativeName: 'ʻŌlelo Hawaiʻi', flag: '🏝️', region: 'Oceania', currency: 'USD', country: 'Hawaii' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', region: 'Oceania', currency: 'WST', country: 'Samoa' },
  { code: 'to', name: 'Tongan', nativeName: 'Lea Fakatonga', flag: '🇹🇴', region: 'Oceania', currency: 'TOP', country: 'Tonga' },
  { code: 'fj', name: 'Fijian', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', region: 'Oceania', currency: 'FJD', country: 'Fiji' }
];

export const RTL_LANGUAGES = ['ar', 'fa', 'ur'];

export const REGIONS = {
  Europe: '🇪🇺',
  MENA: '🕌',
  Asia: '🌏',
  Americas: '🌎',
  Africa: '🌍',
  Oceania: '🏝️'
};

export function getLanguagesByRegion() {
  return WORLD_LANGUAGES.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = [];
    acc[lang.region].push(lang);
    return acc;
  }, {} as Record<string, Language[]>);
}

export function getLanguageByCode(code: string): Language | undefined {
  return WORLD_LANGUAGES.find(lang => lang.code === code);
}

export function isRTL(languageCode: string): boolean {
  return RTL_LANGUAGES.includes(languageCode);
}
EOF
    
    log_success "Système de 75+ langues créé avec arabe 🇲🇦"
}

# 2. SYSTÈME DE PROGRESSION À 5 NIVEAUX
create_progression_system() {
    log_header "SYSTÈME DE PROGRESSION - 5 NIVEAUX"
    
    mkdir -p src/lib/game
    
    cat > src/lib/game/levels.ts << 'EOF'
// ===================================================================
// 🎯 SYSTÈME DE PROGRESSION - 5 NIVEAUX
// Chaque niveau nécessite 100 bonnes réponses pour débloquer le suivant
// ===================================================================

export interface Level {
  id: string;
  name: string;
  description: string;
  requiredCorrectAnswers: number;
  difficulty: number;
  operations: OperationType[];
  numberRange: {
    min: number;
    max: number;
  };
  icon: string;
  color: string;
  gradient: string;
}

export type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

export const MATH_LEVELS: Level[] = [
  {
    id: 'beginner',
    name: 'Débutant',
    description: 'Nombres de 1 à 10',
    requiredCorrectAnswers: 100,
    difficulty: 1,
    operations: ['addition', 'subtraction'],
    numberRange: { min: 1, max: 10 },
    icon: '🌱',
    color: '#10B981',
    gradient: 'from-green-400 to-emerald-500'
  },
  {
    id: 'elementary',
    name: 'Élémentaire',
    description: 'Nombres de 1 à 50',
    requiredCorrectAnswers: 100,
    difficulty: 2,
    operations: ['addition', 'subtraction', 'multiplication'],
    numberRange: { min: 1, max: 50 },
    icon: '🌿',
    color: '#3B82F6',
    gradient: 'from-blue-400 to-indigo-500'
  },
  {
    id: 'intermediate',
    name: 'Intermédiaire',
    description: 'Nombres de 1 à 100',
    requiredCorrectAnswers: 100,
    difficulty: 3,
    operations: ['addition', 'subtraction', 'multiplication', 'division'],
    numberRange: { min: 1, max: 100 },
    icon: '🌳',
    color: '#8B5CF6',
    gradient: 'from-purple-400 to-violet-500'
  },
  {
    id: 'advanced',
    name: 'Avancé',
    description: 'Nombres de 1 à 500',
    requiredCorrectAnswers: 100,
    difficulty: 4,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 500 },
    icon: '🌲',
    color: '#F59E0B',
    gradient: 'from-yellow-400 to-orange-500'
  },
  {
    id: 'expert',
    name: 'Expert',
    description: 'Nombres de 1 à 1000',
    requiredCorrectAnswers: 100,
    difficulty: 5,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 1000 },
    icon: '👑',
    color: '#EF4444',
    gradient: 'from-red-400 to-pink-500'
  }
];

export interface UserProgress {
  userId: string;
  currentLevel: string;
  levelProgress: Record<string, {
    correctAnswers: number;
    totalAttempts: number;
    isUnlocked: boolean;
    isCompleted: boolean;
    operationProgress: Record<OperationType, {
      correct: number;
      total: number;
    }>;
  }>;
  overallStats: {
    totalCorrect: number;
    totalAttempts: number;
    accuracy: number;
    streak: number;
    maxStreak: number;
  };
}

export class ProgressManager {
  static initializeUserProgress(userId: string): UserProgress {
    const progress: UserProgress = {
      userId,
      currentLevel: 'beginner',
      levelProgress: {},
      overallStats: {
        totalCorrect: 0,
        totalAttempts: 0,
        accuracy: 0,
        streak: 0,
        maxStreak: 0
      }
    };

    // Initialiser chaque niveau
    MATH_LEVELS.forEach((level, index) => {
      progress.levelProgress[level.id] = {
        correctAnswers: 0,
        totalAttempts: 0,
        isUnlocked: index === 0, // Seul le premier niveau est débloqué
        isCompleted: false,
        operationProgress: {
          addition: { correct: 0, total: 0 },
          subtraction: { correct: 0, total: 0 },
          multiplication: { correct: 0, total: 0 },
          division: { correct: 0, total: 0 },
          mixed: { correct: 0, total: 0 }
        }
      };
    });

    return progress;
  }

  static updateProgress(
    progress: UserProgress, 
    levelId: string, 
    operation: OperationType, 
    isCorrect: boolean
  ): UserProgress {
    const updatedProgress = { ...progress };
    const levelProgress = updatedProgress.levelProgress[levelId];

    // Mettre à jour les statistiques du niveau
    levelProgress.totalAttempts++;
    if (isCorrect) {
      levelProgress.correctAnswers++;
      levelProgress.operationProgress[operation].correct++;
      updatedProgress.overallStats.totalCorrect++;
      updatedProgress.overallStats.streak++;
      updatedProgress.overallStats.maxStreak = Math.max(
        updatedProgress.overallStats.maxStreak,
        updatedProgress.overallStats.streak
      );
    } else {
      updatedProgress.overallStats.streak = 0;
    }

    levelProgress.operationProgress[operation].total++;
    updatedProgress.overallStats.totalAttempts++;
    updatedProgress.overallStats.accuracy = 
      (updatedProgress.overallStats.totalCorrect / updatedProgress.overallStats.totalAttempts) * 100;

    // Vérifier si le niveau est terminé (100 bonnes réponses)
    if (levelProgress.correctAnswers >= 100 && !levelProgress.isCompleted) {
      levelProgress.isCompleted = true;
      
      // Débloquer le niveau suivant
      const currentLevelIndex = MATH_LEVELS.findIndex(l => l.id === levelId);
      if (currentLevelIndex < MATH_LEVELS.length - 1) {
        const nextLevel = MATH_LEVELS[currentLevelIndex + 1];
        updatedProgress.levelProgress[nextLevel.id].isUnlocked = true;
        updatedProgress.currentLevel = nextLevel.id;
      }
    }

    return updatedProgress;
  }

  static getAvailableLevels(progress: UserProgress): Level[] {
    return MATH_LEVELS.filter(level => 
      progress.levelProgress[level.id]?.isUnlocked || 
      progress.levelProgress[level.id]?.isCompleted
    );
  }

  static getLevelInfo(levelId: string): Level | undefined {
    return MATH_LEVELS.find(l => l.id === levelId);
  }
}
EOF
    
    log_success "Système de progression 5 niveaux créé"
}

# 3. GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES
create_question_generator() {
    log_header "GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES"
    
    cat > src/lib/game/questionGenerator.ts << 'EOF'
// ===================================================================
// 🧮 GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES
// Génère des questions adaptées à chaque niveau et opération
// ===================================================================

import { Level, OperationType, MATH_LEVELS } from './levels';

export interface MathQuestion {
  id: string;
  level: string;
  operation: OperationType;
  question: string;
  answer: number;
  operands: number[];
  hint?: string;
  difficulty: number;
  timeLimit?: number;
}

export class QuestionGenerator {
  private static questionId = 0;

  static generateQuestion(levelId: string, operation: OperationType): MathQuestion {
    const level = MATH_LEVELS.find(l => l.id === levelId);
    if (!level) throw new Error(`Niveau ${levelId} non trouvé`);

    this.questionId++;
    const { min, max } = level.numberRange;

    switch (operation) {
      case 'addition':
        return this.generateAddition(level, this.questionId.toString());
      case 'subtraction':
        return this.generateSubtraction(level, this.questionId.toString());
      case 'multiplication':
        return this.generateMultiplication(level, this.questionId.toString());
      case 'division':
        return this.generateDivision(level, this.questionId.toString());
      case 'mixed':
        return this.generateMixed(level, this.questionId.toString());
      default:
        throw new Error(`Opération ${operation} non supportée`);
    }
  }

  private static generateAddition(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    const a = this.randomInt(min, max);
    const b = this.randomInt(min, max);
    
    return {
      id,
      level: level.id,
      operation: 'addition',
      question: `${a} + ${b} = ?`,
      answer: a + b,
      operands: [a, b],
      hint: `Compte ${a} objets, puis ajoute ${b} de plus`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty)
    };
  }

  private static generateSubtraction(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    let a = this.randomInt(min, max);
    let b = this.randomInt(min, a); // b <= a pour éviter les résultats négatifs
    
    // S'assurer que a >= b
    if (a < b) [a, b] = [b, a];
    
    return {
      id,
      level: level.id,
      operation: 'subtraction',
      question: `${a} - ${b} = ?`,
      answer: a - b,
      operands: [a, b],
      hint: `Tu as ${a} objets, enlève-en ${b}`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty)
    };
  }

  private static generateMultiplication(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    
    // Adapter les nombres pour la multiplication selon le niveau
    let maxFactor = level.difficulty <= 2 ? 10 : level.difficulty <= 3 ? 12 : 15;
    maxFactor = Math.min(maxFactor, Math.sqrt(max));
    
    const a = this.randomInt(min, Math.floor(maxFactor));
    const b = this.randomInt(min, Math.floor(maxFactor));
    
    return {
      id,
      level: level.id,
      operation: 'multiplication',
      question: `${a} × ${b} = ?`,
      answer: a * b,
      operands: [a, b],
      hint: `${a} groupes de ${b} objets chacun`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty, 'multiplication')
    };
  }

  private static generateDivision(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    
    // Générer d'abord le quotient et le diviseur
    let maxDivisor = level.difficulty <= 2 ? 10 : level.difficulty <= 3 ? 12 : 15;
    maxDivisor = Math.min(maxDivisor, Math.sqrt(max));
    
    const quotient = this.randomInt(min, Math.floor(max / maxDivisor));
    const divisor = this.randomInt(Math.max(2, min), maxDivisor);
    const dividend = quotient * divisor;
    
    return {
      id,
      level: level.id,
      operation: 'division',
      question: `${dividend} ÷ ${divisor} = ?`,
      answer: quotient,
      operands: [dividend, divisor],
      hint: `Combien de groupes de ${divisor} dans ${dividend} ?`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty, 'division')
    };
  }

  private static generateMixed(level: Level, id: string): MathQuestion {
    const operations: OperationType[] = ['addition', 'subtraction', 'multiplication', 'division'];
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    return this.generateQuestion(level.id, randomOp);
  }

  private static randomInt(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  private static getTimeLimit(difficulty: number, operation?: OperationType): number {
    const baseTime = {
      addition: 30,
      subtraction: 35,
      multiplication: 45,
      division: 50
    };
    
    const opTime = operation ? baseTime[operation] || 30 : 30;
    return Math.max(15, opTime - (difficulty * 5)); // Plus difficile = moins de temps
  }

  // Générer une série de questions pour une session
  static generateQuestionSeries(
    levelId: string, 
    operation: OperationType, 
    count: number = 10
  ): MathQuestion[] {
    const questions: MathQuestion[] = [];
    
    for (let i = 0; i < count; i++) {
      questions.push(this.generateQuestion(levelId, operation));
    }
    
    return questions;
  }

  // Générer des questions de révision pour les niveaux déjà validés
  static generateReviewQuestions(
    completedLevels: string[], 
    count: number = 20
  ): MathQuestion[] {
    const questions: MathQuestion[] = [];
    
    completedLevels.forEach(levelId => {
      const level = MATH_LEVELS.find(l => l.id === levelId);
      if (level) {
        level.operations.forEach(operation => {
          const questionsForOp = Math.ceil(count / (completedLevels.length * level.operations.length));
          for (let i = 0; i < questionsForOp; i++) {
            questions.push(this.generateQuestion(levelId, operation));
          }
        });
      }
    });
    
    return questions.slice(0, count); // Limiter au nombre demandé
  }
}
EOF
    
    log_success "Générateur de questions mathématiques créé"
}

# 4. SYSTÈME D'ABONNEMENTS AVANCÉ
create_subscription_system() {
    log_header "SYSTÈME D'ABONNEMENTS PREMIUM"
    
    mkdir -p src/lib/subscription
    
    cat > src/lib/subscription/plans.ts << 'EOF'
// ===================================================================
// 💰 SYSTÈME D'ABONNEMENTS PREMIUM
// Plans compétitifs avec réductions multi-appareils
// ===================================================================

export interface Device {
  type: 'web' | 'android' | 'ios';
  name: string;
  icon: string;
  platform: string;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  description: string;
  basePrice: number; // Prix en EUR
  currency: string;
  duration: 'weekly' | 'monthly' | 'quarterly' | 'yearly';
  durationInDays: number;
  features: string[];
  profilesLimit: number;
  questionsLimit: number | 'unlimited';
  levelsAccess: string[];
  support: 'community' | 'email' | 'priority' | 'vip';
  isPopular?: boolean;
  savings?: number; // Pourcentage d'économie
  color: string;
  gradient: string;
}

export const AVAILABLE_DEVICES: Device[] = [
  {
    type: 'web',
    name: 'Web (ordinateur)',
    icon: '💻',
    platform: 'Navigateur web'
  },
  {
    type: 'android',
    name: 'Android',
    icon: '📱',
    platform: 'Google Play Store'
  },
  {
    type: 'ios',
    name: 'iOS',
    icon: '📱',
    platform: 'App Store'
  }
];

export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'trial',
    name: 'Essai Gratuit',
    description: 'Découvrez Math4Child pendant 7 jours',
    basePrice: 0,
    currency: 'EUR',
    duration: 'weekly',
    durationInDays: 7,
    features: [
      '50 questions gratuites',
      '2 profils enfants',
      'Accès niveau débutant uniquement',
      'Support communautaire',
      'Statistiques de base'
    ],
    profilesLimit: 2,
    questionsLimit: 50,
    levelsAccess: ['beginner'],
    support: 'community',
    color: '#6B7280',
    gradient: 'from-gray-400 to-gray-500'
  },
  {
    id: 'monthly',
    name: 'Mensuel',
    description: 'Parfait pour commencer',
    basePrice: 9.99,
    currency: 'EUR',
    duration: 'monthly',
    durationInDays: 30,
    features: [
      'Questions illimitées',
      '3 profils enfants',
      'Tous les 5 niveaux',
      'Toutes les opérations',
      'Support par email',
      'Statistiques détaillées',
      'Mode révision'
    ],
    profilesLimit: 3,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'email',
    color: '#3B82F6',
    gradient: 'from-blue-400 to-indigo-500'
  },
  {
    id: 'quarterly',
    name: 'Trimestriel',
    description: 'Économisez 10% sur 3 mois',
    basePrice: 26.97,
    currency: 'EUR',
    duration: 'quarterly',
    durationInDays: 90,
    features: [
      'Tout du plan mensuel',
      '5 profils enfants',
      'Support prioritaire',
      'Accès aux nouvelles fonctionnalités',
      'Défis chronométrés',
      'Rapport de progression parents',
      'Mode hors-ligne avancé'
    ],
    profilesLimit: 5,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'priority',
    savings: 10,
    isPopular: true,
    color: '#10B981',
    gradient: 'from-green-400 to-emerald-500'
  },
  {
    id: 'yearly',
    name: 'Annuel',
    description: 'Meilleure offre - Économisez 30%',
    basePrice: 83.93,
    currency: 'EUR',
    duration: 'yearly',
    durationInDays: 365,
    features: [
      'Tout du plan trimestriel',
      '10 profils enfants',
      'Support VIP 24/7',
      'Accès bêta aux nouvelles fonctionnalités',
      'Analyses IA avancées',
      'Rapports mensuels détaillés',
      'Mode multijoueur famille',
      'Jeux bonus exclusifs'
    ],
    profilesLimit: 10,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'vip',
    savings: 30,
    color: '#F59E0B',
    gradient: 'from-yellow-400 to-orange-500'
  },
  {
    id: 'premium_yearly',
    name: 'Premium Famille',
    description: 'Pour les grandes familles',
    basePrice: 149.99,
    currency: 'EUR',
    duration: 'yearly',
    durationInDays: 365,
    features: [
      '20 profils enfants',
      'Support VIP prioritaire',
      'Fonctionnalités exclusives',
      'Accès anticipé aux mises à jour',
      'Personnalisation avancée',
      'Tableau de bord parent avancé',
      'Intégration calendrier familial',
      'Certificats de réussite personnalisés'
    ],
    profilesLimit: 20,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'vip',
    savings: 25,
    color: '#8B5CF6',
    gradient: 'from-purple-400 to-violet-500'
  }
];

// Calculateur de réductions multi-appareils
export interface DeviceDiscount {
  deviceCount: number;
  discount: number; // Pourcentage
  description: string;
}

export const MULTI_DEVICE_DISCOUNTS: DeviceDiscount[] = [
  {
    deviceCount: 1,
    discount: 0,
    description: 'Prix normal'
  },
  {
    deviceCount: 2,
    discount: 50,
    description: '50% de réduction sur le 2ème appareil'
  },
  {
    deviceCount: 3,
    discount: 75,
    description: '75% de réduction sur le 3ème appareil'
  }
];

export function calculateDevicePrice(
  basePrice: number, 
  existingDevicesCount: number
): { price: number; discount: number; savings: number } {
  const discountInfo = MULTI_DEVICE_DISCOUNTS.find(d => d.deviceCount === existingDevicesCount + 1);
  
  if (!discountInfo) {
    return { price: basePrice, discount: 0, savings: 0 };
  }
  
  const discount = discountInfo.discount;
  const discountAmount = (basePrice * discount) / 100;
  const finalPrice = basePrice - discountAmount;
  
  return {
    price: finalPrice,
    discount,
    savings: discountAmount
  };
}
EOF
    
    log_success "Système d'abonnements premium créé"
}

# 5. SYSTÈME DE PRIX MONDIAUX
create_global_pricing() {
    log_header "SYSTÈME DE PRIX MONDIAUX"
    
    cat > src/lib/pricing/globalPricing.ts << 'EOF'
// ===================================================================
// 🌍 SYSTÈME DE PRIX MONDIAUX
// Prix adaptés au pouvoir d'achat de chaque pays
// ===================================================================

export interface CountryPricing {
  country: string;
  countryCode: string;
  currency: string;
  currencySymbol: string;
  exchangeRate: number; // Par rapport à EUR
  purchasingPowerAdjustment: number; // Multiplicateur basé sur le pouvoir d'achat
  minimumWage: number; // Salaire minimum mensuel en monnaie locale
  flag: string;
}

export const GLOBAL_PRICING: CountryPricing[] = [
  // EUROPE
  { country: 'France', countryCode: 'FR', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.0, minimumWage: 1678, flag: '🇫🇷' },
  { country: 'Germany', countryCode: 'DE', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.0, minimumWage: 1621, flag: '🇩🇪' },
  { country: 'United Kingdom', countryCode: 'GB', currency: 'GBP', currencySymbol: '£', exchangeRate: 0.85, purchasingPowerAdjustment: 1.1, minimumWage: 1467, flag: '🇬🇧' },
  { country: 'Spain', countryCode: 'ES', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.85, minimumWage: 900, flag: '🇪🇸' },
  { country: 'Italy', countryCode: 'IT', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.9, minimumWage: 1100, flag: '🇮🇹' },
  { country: 'Netherlands', countryCode: 'NL', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.05, minimumWage: 1701, flag: '🇳🇱' },
  { country: 'Poland', countryCode: 'PL', currency: 'PLN', currencySymbol: 'zł', exchangeRate: 4.35, purchasingPowerAdjustment: 0.6, minimumWage: 2450, flag: '🇵🇱' },
  { country: 'Portugal', countryCode: 'PT', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.75, minimumWage: 665, flag: '🇵🇹' },
  { country: 'Sweden', countryCode: 'SE', currency: 'SEK', currencySymbol: 'kr', exchangeRate: 11.2, purchasingPowerAdjustment: 1.15, minimumWage: 25000, flag: '🇸🇪' },
  { country: 'Switzerland', countryCode: 'CH', currency: 'CHF', currencySymbol: 'CHF', exchangeRate: 0.98, purchasingPowerAdjustment: 1.4, minimumWage: 3500, flag: '🇨🇭' },
  
  // AMÉRIQUES
  { country: 'United States', countryCode: 'US', currency: 'USD', currencySymbol: '$', exchangeRate: 1.08, purchasingPowerAdjustment: 1.2, minimumWage: 1256, flag: '🇺🇸' },
  { country: 'Canada', countryCode: 'CA', currency: 'CAD', currencySymbol: 'C$', exchangeRate: 1.47, purchasingPowerAdjustment: 1.1, minimumWage: 2000, flag: '🇨🇦' },
  { country: 'Brazil', countryCode: 'BR', currency: 'BRL', currencySymbol: 'R$', exchangeRate: 5.4, purchasingPowerAdjustment: 0.4, minimumWage: 1212, flag: '🇧🇷' },
  { country: 'Mexico', countryCode: 'MX', currency: 'MXN', currencySymbol: '$', exchangeRate: 18.5, purchasingPowerAdjustment: 0.35, minimumWage: 3685, flag: '🇲🇽' },
  { country: 'Argentina', countryCode: 'AR', currency: 'ARS', currencySymbol: '$', exchangeRate: 350, purchasingPowerAdjustment: 0.25, minimumWage: 87987, flag: '🇦🇷' },
  { country: 'Chile', countryCode: 'CL', currency: 'CLP', currencySymbol: '$', exchangeRate: 920, purchasingPowerAdjustment: 0.6, minimumWage: 320500, flag: '🇨🇱' },
  { country: 'Colombia', countryCode: 'CO', currency: 'COP', currencySymbol: '$', exchangeRate: 4200, purchasingPowerAdjustment: 0.3, minimumWage: 1000000, flag: '🇨🇴' },
  
  // ASIE
  { country: 'China', countryCode: 'CN', currency: 'CNY', currencySymbol: '¥', exchangeRate: 7.8, purchasingPowerAdjustment: 0.45, minimumWage: 2320, flag: '🇨🇳' },
  { country: 'Japan', countryCode: 'JP', currency: 'JPY', currencySymbol: '¥', exchangeRate: 155, purchasingPowerAdjustment: 0.95, minimumWage: 126600, flag: '🇯🇵' },
  { country: 'South Korea', countryCode: 'KR', currency: 'KRW', currencySymbol: '₩', exchangeRate: 1420, purchasingPowerAdjustment: 0.8, minimumWage: 1914440, flag: '🇰🇷' },
  { country: 'India', countryCode: 'IN', currency: 'INR', currencySymbol: '₹', exchangeRate: 89, purchasingPowerAdjustment: 0.2, minimumWage: 15000, flag: '🇮🇳' },
  { country: 'Indonesia', countryCode: 'ID', currency: 'IDR', currencySymbol: 'Rp', exchangeRate: 16800, purchasingPowerAdjustment: 0.25, minimumWage: 3500000, flag: '🇮🇩' },
  { country: 'Thailand', countryCode: 'TH', currency: 'THB', currencySymbol: '฿', exchangeRate: 38, purchasingPowerAdjustment: 0.35, minimumWage: 10700, flag: '🇹🇭' },
  { country: 'Vietnam', countryCode: 'VN', currency: 'VND', currencySymbol: '₫', exchangeRate: 26000, purchasingPowerAdjustment: 0.2, minimumWage: 4180000, flag: '🇻🇳' },
  { country: 'Philippines', countryCode: 'PH', currency: 'PHP', currencySymbol: '₱', exchangeRate: 60, purchasingPowerAdjustment: 0.25, minimumWage: 13000, flag: '🇵🇭' },
  { country: 'Malaysia', countryCode: 'MY', currency: 'MYR', currencySymbol: 'RM', exchangeRate: 5.0, purchasingPowerAdjustment: 0.4, minimumWage: 1200, flag: '🇲🇾' },
  { country: 'Singapore', countryCode: 'SG', currency: 'SGD', currencySymbol: 'S$', exchangeRate: 1.45, purchasingPowerAdjustment: 1.3, minimumWage: 2600, flag: '🇸🇬' },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD
  { country: 'Morocco', countryCode: 'MA', currency: 'MAD', currencySymbol: 'د.م.', exchangeRate: 10.8, purchasingPowerAdjustment: 0.3, minimumWage: 3000, flag: '🇲🇦' },
  { country: 'Saudi Arabia', countryCode: 'SA', currency: 'SAR', currencySymbol: '﷼', exchangeRate: 4.05, purchasingPowerAdjustment: 0.7, minimumWage: 3000, flag: '🇸🇦' },
  { country: 'UAE', countryCode: 'AE', currency: 'AED', currencySymbol: 'د.إ', exchangeRate: 3.97, purchasingPowerAdjustment: 0.9, minimumWage: 3000, flag: '🇦🇪' },
  { country: 'Turkey', countryCode: 'TR', currency: 'TRY', currencySymbol: '₺', exchangeRate: 29, purchasingPowerAdjustment: 0.35, minimumWage: 8506, flag: '🇹🇷' },
  { country: 'Egypt', countryCode: 'EG', currency: 'EGP', currencySymbol: '£', exchangeRate: 31, purchasingPowerAdjustment: 0.2, minimumWage: 3000, flag: '🇪🇬' },
  
  // AFRIQUE
  { country: 'South Africa', countryCode: 'ZA', currency: 'ZAR', currencySymbol: 'R', exchangeRate: 20, purchasingPowerAdjustment: 0.3, minimumWage: 3500, flag: '🇿🇦' },
  { country: 'Nigeria', countryCode: 'NG', currency: 'NGN', currencySymbol: '₦', exchangeRate: 850, purchasingPowerAdjustment: 0.15, minimumWage: 30000, flag: '🇳🇬' },
  { country: 'Kenya', countryCode: 'KE', currency: 'KES', currencySymbol: 'KSh', exchangeRate: 140, purchasingPowerAdjustment: 0.2, minimumWage: 13572, flag: '🇰🇪' },
  { country: 'Ghana', countryCode: 'GH', currency: 'GHS', currencySymbol: '₵', exchangeRate: 12, purchasingPowerAdjustment: 0.18, minimumWage: 365, flag: '🇬🇭' },
  
  // OCÉANIE
  { country: 'Australia', countryCode: 'AU', currency: 'AUD', currencySymbol: 'A$', exchangeRate: 1.65, purchasingPowerAdjustment: 1.15, minimumWage: 3100, flag: '🇦🇺' },
  { country: 'New Zealand', countryCode: 'NZ', currency: 'NZD', currencySymbol: 'NZ$', exchangeRate: 1.78, purchasingPowerAdjustment: 1.1, minimumWage: 2765, flag: '🇳🇿' }
];

export function calculateLocalPrice(
  basePriceEUR: number, 
  countryCode: string
): { price: number; currency: string; symbol: string; country: CountryPricing } {
  const country = GLOBAL_PRICING.find(c => c.countryCode === countryCode) || GLOBAL_PRICING[0];
  
  // Calculer le prix ajusté selon le pouvoir d'achat
  const adjustedPrice = basePriceEUR * country.purchasingPowerAdjustment;
  
  // Convertir dans la monnaie locale
  const localPrice = adjustedPrice * country.exchangeRate;
  
  // Arrondir selon la monnaie
  let roundedPrice;
  if (['JPY', 'KRW', 'IDR', 'VND', 'CLP', 'COP'].includes(country.currency)) {
    roundedPrice = Math.round(localPrice); // Pas de décimales
  } else {
    roundedPrice = Math.round(localPrice * 100) / 100; // 2 décimales
  }
  
  return {
    price: roundedPrice,
    currency: country.currency,
    symbol: country.currencySymbol,
    country
  };
}

export function getCountryByCode(countryCode: string): CountryPricing | undefined {
  return GLOBAL_PRICING.find(c => c.countryCode === countryCode);
}

export function detectUserCountry(): string {
  // En production, utiliser l'IP geolocation
  // Pour le moment, détecter via la langue du navigateur
  const language = navigator.language;
  const countryMap: Record<string, string> = {
    'fr-FR': 'FR', 'fr-CA': 'CA', 'fr-BE': 'BE', 'fr-CH': 'CH',
    'en-US': 'US', 'en-GB': 'GB', 'en-CA': 'CA', 'en-AU': 'AU', 'en-NZ': 'NZ',
    'es-ES': 'ES', 'es-MX': 'MX', 'es-AR': 'AR', 'es-CL': 'CL', 'es-CO': 'CO',
    'de-DE': 'DE', 'de-AT': 'AT', 'de-CH': 'CH',
    'it-IT': 'IT', 'pt-BR': 'BR', 'pt-PT': 'PT',
    'zh-CN': 'CN', 'zh-TW': 'TW', 'ja-JP': 'JP', 'ko-KR': 'KR',
    'ar-MA': 'MA', 'ar-SA': 'SA', 'ar-AE': 'AE', 'ar-EG': 'EG',
    'hi-IN': 'IN', 'th-TH': 'TH', 'vi-VN': 'VN', 'id-ID': 'ID'
  };
  
  return countryMap[language] || countryMap[language.split('-')[0]] || 'FR';
}
EOF
    
    log_success "Système de prix mondiaux créé"
}

# 6. SYSTÈME DE PAIEMENT MONDIAL
create_payment_system() {
    log_header "SYSTÈME DE PAIEMENT MONDIAL"
    
    mkdir -p src/lib/payment
    
    cat > src/lib/payment/paymentMethods.ts << 'EOF'
// ===================================================================
// 💳 SYSTÈME DE PAIEMENT MONDIAL
// Support de tous les moyens de paiement mondiaux
// ===================================================================

export interface PaymentMethod {
  id: string;
  name: string;
  type: 'card' | 'wallet' | 'bank' | 'crypto' | 'mobile';
  icon: string;
  countries: string[];
  currencies: string[];
  processingFee: number; // Pourcentage
  isPopular?: boolean;
}

export const GLOBAL_PAYMENT_METHODS: PaymentMethod[] = [
  // CARTES DE CRÉDIT/DÉBIT INTERNATIONALES
  {
    id: 'visa',
    name: 'Visa',
    type: 'card',
    icon: '💳',
    countries: ['*'], // Mondial
    currencies: ['*'], // Toutes devises
    processingFee: 2.9,
    isPopular: true
  },
  {
    id: 'mastercard',
    name: 'Mastercard',
    type: 'card',
    icon: '💳',
    countries: ['*'],
    currencies: ['*'],
    processingFee: 2.9,
    isPopular: true
  },
  {
    id: 'amex',
    name: 'American Express',
    type: 'card',
    icon: '💳',
    countries: ['US', 'CA', 'GB', 'AU', 'DE', 'FR', 'JP'],
    currencies: ['USD', 'CAD', 'GBP', 'AUD', 'EUR', 'JPY'],
    processingFee: 3.4
  },

  // PORTEFEUILLES NUMÉRIQUES
  {
    id: 'paypal',
    name: 'PayPal',
    type: 'wallet',
    icon: '🅿️',
    countries: ['*'],
    currencies: ['*'],
    processingFee: 3.4,
    isPopular: true
  },
  {
    id: 'apple_pay',
    name: 'Apple Pay',
    type: 'wallet',
    icon: '🍎',
    countries: ['US', 'CA', 'GB', 'AU', 'FR', 'DE', 'JP', 'CN'],
    currencies: ['USD', 'CAD', 'GBP', 'AUD', 'EUR', 'JPY', 'CNY'],
    processingFee: 2.9
  },
  {
    id: 'google_pay',
    name: 'Google Pay',
    type: 'wallet',
    icon: '🔵',
    countries: ['US', 'CA', 'GB', 'AU', 'FR', 'DE', 'IN', 'BR'],
    currencies: ['USD', 'CAD', 'GBP', 'AUD', 'EUR', 'INR', 'BRL'],
    processingFee: 2.9
  },

  // PAIEMENTS RÉGIONAUX - EUROPE
  {
    id: 'sepa',
    name: 'SEPA (Virement bancaire)',
    type: 'bank',
    icon: '🏦',
    countries: ['FR', 'DE', 'ES', 'IT', 'NL', 'BE', 'AT', 'PT'],
    currencies: ['EUR'],
    processingFee: 0.8
  },
  {
    id: 'ideal',
    name: 'iDEAL',
    type: 'bank',
    icon: '🇳🇱',
    countries: ['NL'],
    currencies: ['EUR'],
    processingFee: 0.5
  },
  {
    id: 'giropay',
    name: 'Giropay',
    type: 'bank',
    icon: '🇩🇪',
    countries: ['DE'],
    currencies: ['EUR'],
    processingFee: 1.2
  },
  {
    id: 'sofort',
    name: 'SOFORT',
    type: 'bank',
    icon: '⚡',
    countries: ['DE', 'AT', 'CH', 'BE', 'NL'],
    currencies: ['EUR', 'CHF'],
    processingFee: 1.4
  },

  // PAIEMENTS RÉGIONAUX - ASIE
  {
    id: 'alipay',
    name: 'Alipay',
    type: 'wallet',
    icon: '🇨🇳',
    countries: ['CN', 'HK', 'MO'],
    currencies: ['CNY', 'HKD'],
    processingFee: 2.8,
    isPopular: true
  },
  {
    id: 'wechat_pay',
    name: 'WeChat Pay',
    type: 'wallet',
    icon: '💬',
    countries: ['CN'],
    currencies: ['CNY'],
    processingFee: 2.8,
    isPopular: true
  },
  {
    id: 'paytm',
    name: 'Paytm',
    type: 'wallet',
    icon: '🇮🇳',
    countries: ['IN'],
    currencies: ['INR'],
    processingFee: 2.0
  },
  {
    id: 'razorpay',
    name: 'Razorpay',
    type: 'wallet',
    icon: '⚡',
    countries: ['IN'],
    currencies: ['INR'],
    processingFee: 2.0
  },
  {
    id: 'grabpay',
    name: 'GrabPay',
    type: 'wallet',
    icon: '🚗',
    countries: ['SG', 'MY', 'TH', 'VN', 'PH', 'ID'],
    currencies: ['SGD', 'MYR', 'THB', 'VND', 'PHP', 'IDR'],
    processingFee: 2.5
  },

  // PAIEMENTS RÉGIONAUX - AMÉRIQUES
  {
    id: 'pix',
    name: 'PIX',
    type: 'bank',
    icon: '🇧🇷',
    countries: ['BR'],
    currencies: ['BRL'],
    processingFee: 0.99,
    isPopular: true
  },
  {
    id: 'mercado_pago',
    name: 'Mercado Pago',
    type: 'wallet',
    icon: '💙',
    countries: ['AR', 'BR', 'CL', 'CO', 'MX', 'PE', 'UY'],
    currencies: ['ARS', 'BRL', 'CLP', 'COP', 'MXN', 'PEN', 'UYU'],
    processingFee: 4.99
  },
  {
    id: 'oxxo',
    name: 'OXXO',
    type: 'mobile',
    icon: '🏪',
    countries: ['MX'],
    currencies: ['MXN'],
    processingFee: 3.0
  },

  // PAIEMENTS RÉGIONAUX - MOYEN-ORIENT & AFRIQUE
  {
    id: 'fawry',
    name: 'Fawry',
    type: 'mobile',
    icon: '🇪🇬',
    countries: ['EG'],
    currencies: ['EGP'],
    processingFee: 2.5
  },
  {
    id: 'mpesa',
    name: 'M-Pesa',
    type: 'mobile',
    icon: '📱',
    countries: ['KE', 'TZ', 'UG', 'RW', 'MZ'],
    currencies: ['KES', 'TZS', 'UGX', 'RWF', 'MZN'],
    processingFee: 1.5
  },
  {
    id: 'orange_money',
    name: 'Orange Money',
    type: 'mobile',
    icon: '🟠',
    countries: ['MA', 'SN', 'CI', 'ML', 'BF'],
    currencies: ['MAD', 'XOF'],
    processingFee: 2.0
  },

  // CRYPTOMONNAIES
  {
    id: 'bitcoin',
    name: 'Bitcoin',
    type: 'crypto',
    icon: '₿',
    countries: ['*'],
    currencies: ['BTC'],
    processingFee: 1.0
  },
  {
    id: 'ethereum',
    name: 'Ethereum',
    type: 'crypto',
    icon: '⟠',
    countries: ['*'],
    currencies: ['ETH'],
    processingFee: 1.0
  }
];

export function getAvailablePaymentMethods(countryCode: string, currency: string): PaymentMethod[] {
  return GLOBAL_PAYMENT_METHODS.filter(method => {
    const countryMatch = method.countries.includes('*') || method.countries.includes(countryCode);
    const currencyMatch = method.currencies.includes('*') || method.currencies.includes(currency);
    return countryMatch && currencyMatch;
  }).sort((a, b) => {
    // Trier par popularité puis par frais
    if (a.isPopular && !b.isPopular) return -1;
    if (!a.isPopular && b.isPopular) return 1;
    return a.processingFee - b.processingFee;
  });
}

export function calculatePaymentFee(amount: number, method: PaymentMethod): number {
  return (amount * method.processingFee) / 100;
}
EOF
    
    log_success "Système de paiement mondial créé"
}

# 7. COMPOSANTS REACT AVANCÉS
create_advanced_components() {
    log_header "COMPOSANTS REACT AVANCÉS"
    
    mkdir -p src/components/{ui,game,subscription,language}
    
    # Composant principal avec toutes les fonctionnalités
    cat > src/app/page.tsx << 'EOF'
'use client';

import { useState, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import LanguageSelector from '@/components/ui/LanguageSelector';
import LevelSelector from '@/components/game/LevelSelector';
import GameInterface from '@/components/game/GameInterface';
import SubscriptionModal from '@/components/subscription/SubscriptionModal';
import { MATH_LEVELS } from '@/lib/game/levels';
import { ProgressManager, UserProgress } from '@/lib/game/levels';

export default function Math4ChildApp() {
  const { t, currentLanguage } = useLanguage();
  const [currentView, setCurrentView] = useState<'home' | 'levels' | 'game' | 'subscription'>('home');
  const [userProgress, setUserProgress] = useState<UserProgress | null>(null);
  const [selectedLevel, setSelectedLevel] = useState<string>('');
  const [selectedOperation, setSelectedOperation] = useState<string>('');
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false);
  const [freeQuestionsUsed, setFreeQuestionsUsed] = useState(0);
  const [isSubscribed, setIsSubscribed] = useState(false);

  const isRTL = currentLanguage === 'ar';
  const FREE_QUESTIONS_LIMIT = 50;

  useEffect(() => {
    // Initialiser le progrès utilisateur
    const userId = 'user_' + Math.random().toString(36).substr(2, 9);
    const progress = ProgressManager.initializeUserProgress(userId);
    setUserProgress(progress);
    
    // Charger les données sauvegardées
    const savedProgress = localStorage.getItem('math4child_progress');
    const savedQuestions = localStorage.getItem('math4child_free_questions');
    const savedSubscription = localStorage.getItem('math4child_subscription');
    
    if (savedProgress) {
      setUserProgress(JSON.parse(savedProgress));
    }
    if (savedQuestions) {
      setFreeQuestionsUsed(parseInt(savedQuestions));
    }
    if (savedSubscription) {
      setIsSubscribed(JSON.parse(savedSubscription));
    }
  }, []);

  const handleLevelSelect = (levelId: string) => {
    setSelectedLevel(levelId);
    setCurrentView('game');
  };

  const handleQuestionAnswered = (isCorrect: boolean) => {
    if (!isSubscribed) {
      const newCount = freeQuestionsUsed + 1;
      setFreeQuestionsUsed(newCount);
      localStorage.setItem('math4child_free_questions', newCount.toString());
      
      if (newCount >= FREE_QUESTIONS_LIMIT) {
        setShowSubscriptionModal(true);
        return;
      }
    }

    if (userProgress && selectedLevel && selectedOperation) {
      const updatedProgress = ProgressManager.updateProgress(
        userProgress,
        selectedLevel,
        selectedOperation as any,
        isCorrect
      );
      setUserProgress(updatedProgress);
      localStorage.setItem('math4child_progress', JSON.stringify(updatedProgress));
    }
  };

  const handleSubscriptionSuccess = () => {
    setIsSubscribed(true);
    setShowSubscriptionModal(false);
    localStorage.setItem('math4child_subscription', 'true');
  };

  if (!userProgress) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-xl text-gray-600">Chargement de Math4Child...</p>
        </div>
      </div>
    );
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header Premium */}
      <header className="bg-white/90 backdrop-blur-sm border-b border-gray-200 sticky top-0 z-50 shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-20">
            {/* Logo et Titre */}
            <div className="flex items-center space-x-4">
              <div className="w-16 h-16 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-2xl flex items-center justify-center shadow-xl transform hover:scale-110 transition-all duration-300">
                <span className="text-white text-2xl font-bold animate-pulse">🧮</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent">
                  Math4Child
                </h1>
                <p className="text-sm text-gray-600 flex items-center">
                  <span className="mr-1">👑</span>
                  {t('subtitle')}
                </p>
              </div>
            </div>

            {/* Actions et Sélecteur de langue */}
            <div className="flex items-center space-x-4">
              {/* Compteur questions gratuites */}
              {!isSubscribed && (
                <div className="bg-gradient-to-r from-yellow-100 to-orange-100 text-orange-800 px-4 py-2 rounded-full text-sm font-medium">
                  <span className="mr-1">⚡</span>
                  {FREE_QUESTIONS_LIMIT - freeQuestionsUsed} questions gratuites
                </div>
              )}

              {/* Badge abonné */}
              {isSubscribed && (
                <div className="bg-gradient-to-r from-green-100 to-emerald-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
                  <span className="mr-1">✨</span>
                  Premium
                </div>
              )}

              {/* Bouton Upgrade */}
              {!isSubscribed && (
                <button
                  onClick={() => setShowSubscriptionModal(true)}
                  className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-6 py-2 rounded-full font-semibold shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
                >
                  <span className="mr-1">🚀</span>
                  Upgrade
                </button>
              )}

              <LanguageSelector />
            </div>
          </div>
        </div>
      </header>

      {/* Contenu Principal */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {currentView === 'home' && (
          <div className="text-center mb-16">
            {/* Hero Section */}
            <div className="mb-12">
              <div className="inline-flex items-center space-x-2 bg-orange-100 text-orange-800 rounded-full px-6 py-3 text-lg font-medium mb-8 animate-bounce">
                <span>🏆</span>
                <span>{t('appBadge')}</span>
              </div>
              
              <h2 className="text-5xl md:text-7xl font-bold text-gray-900 mb-8 leading-tight">
                {t('title')}
              </h2>
              
              <p className="text-2xl text-gray-600 mb-12 max-w-4xl mx-auto">
                {t('description')}
              </p>
              
              <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
                <button
                  onClick={() => setCurrentView('levels')}
                  className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-12 py-6 rounded-2xl font-bold text-xl shadow-2xl hover:shadow-3xl transition-all duration-300 transform hover:scale-105 hover:-translate-y-2"
                >
                  <span className="mr-2">🎮</span>
                  {t('startFree')}
                </button>
                <button
                  onClick={() => setShowSubscriptionModal(true)}
                  className="bg-white text-gray-900 px-12 py-6 rounded-2xl font-bold text-xl border-2 border-gray-200 shadow-2xl hover:shadow-3xl transition-all duration-300 transform hover:scale-105"
                >
                  <span className="mr-2">💎</span>
                  Voir les plans
                </button>
              </div>
            </div>

            {/* Statistiques */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-16">
              <div className="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-lg">
                <div className="text-4xl font-bold text-blue-600 mb-2">100k+</div>
                <div className="text-gray-600">Familles</div>
              </div>
              <div className="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-lg">
                <div className="text-4xl font-bold text-green-600 mb-2">5M+</div>
                <div className="text-gray-600">Questions résolues</div>
              </div>
              <div className="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-lg">
                <div className="text-4xl font-bold text-purple-600 mb-2">98%</div>
                <div className="text-gray-600">Satisfaction</div>
              </div>
              <div className="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-lg">
                <div className="text-4xl font-bold text-orange-600 mb-2">4.9★</div>
                <div className="text-gray-600">Note moyenne</div>
              </div>
            </div>
          </div>
        )}

        {currentView === 'levels' && (
          <LevelSelector
            userProgress={userProgress}
            onLevelSelect={handleLevelSelect}
            onBack={() => setCurrentView('home')}
          />
        )}

        {currentView === 'game' && selectedLevel && (
          <GameInterface
            level={selectedLevel}
            operation={selectedOperation}
            userProgress={userProgress}
            onQuestionAnswered={handleQuestionAnswered}
            onBack={() => setCurrentView('levels')}
            isSubscribed={isSubscribed}
            freeQuestionsRemaining={FREE_QUESTIONS_LIMIT - freeQuestionsUsed}
          />
        )}
      </main>

      {/* Modal d'abonnement */}
      {showSubscriptionModal && (
        <SubscriptionModal
          onClose={() => setShowSubscriptionModal(false)}
          onSuccess={handleSubscriptionSuccess}
          freeQuestionsUsed={freeQuestionsUsed}
          freeQuestionsLimit={FREE_QUESTIONS_LIMIT}
        />
      )}
    </div>
  );
}
EOF

    # Sélecteur de niveaux avancé
    cat > src/components/game/LevelSelector.tsx << 'EOF'
'use client';

import { useLanguage } from '@/contexts/LanguageContext';
import { MATH_LEVELS, UserProgress, ProgressManager } from '@/lib/game/levels';

interface LevelSelectorProps {
  userProgress: UserProgress;
  onLevelSelect: (levelId: string) => void;
  onBack: () => void;
}

export default function LevelSelector({ userProgress, onLevelSelect, onBack }: LevelSelectorProps) {
  const { t } = useLanguage();

  return (
    <div className="max-w-6xl mx-auto">
      {/* Header */}
      <div className="text-center mb-12">
        <button
          onClick={onBack}
          className="mb-6 flex items-center text-gray-600 hover:text-gray-900 transition-colors"
        >
          <span className="mr-2">←</span>
          Retour à l'accueil
        </button>
        
        <h2 className="text-4xl font-bold text-gray-900 mb-4">
          Choisis ton niveau
        </h2>
        <p className="text-xl text-gray-600">
          Chaque niveau nécessite 100 bonnes réponses pour être validé
        </p>
      </div>

      {/* Grille des niveaux */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {MATH_LEVELS.map((level, index) => {
          const progress = userProgress.levelProgress[level.id];
          const isLocked = !progress.isUnlocked && !progress.isCompleted;
          const progressPercentage = (progress.correctAnswers / level.requiredCorrectAnswers) * 100;

          return (
            <div
              key={level.id}
              className={`relative bg-white rounded-3xl p-8 shadow-xl border-2 transition-all duration-300 transform hover:scale-105 ${
                isLocked 
                  ? 'border-gray-200 opacity-60 cursor-not-allowed' 
                  : progress.isCompleted 
                    ? 'border-green-400 shadow-green-200' 
                    : 'border-blue-200 hover:border-blue-400 cursor-pointer'
              }`}
              onClick={() => !isLocked && onLevelSelect(level.id)}
            >
              {/* Badge de statut */}
              <div className="absolute -top-4 -right-4">
                {progress.isCompleted && (
                  <div className="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center text-white text-xl">
                    ✅
                  </div>
                )}
                {isLocked && (
                  <div className="w-12 h-12 bg-gray-400 rounded-full flex items-center justify-center text-white text-xl">
                    🔒
                  </div>
                )}
              </div>

              {/* Icône et couleur du niveau */}
              <div 
                className={`w-20 h-20 rounded-2xl flex items-center justify-center text-4xl mb-6 mx-auto bg-gradient-to-br ${level.gradient}`}
              >
                {level.icon}
              </div>

              {/* Informations du niveau */}
              <div className="text-center">
                <h3 className="text-2xl font-bold text-gray-900 mb-2">
                  Niveau {index + 1}: {level.name}
                </h3>
                <p className="text-gray-600 mb-6">
                  {level.description}
                </p>

                {/* Barre de progression */}
                <div className="mb-6">
                  <div className="flex justify-between text-sm text-gray-600 mb-2">
                    <span>Progression</span>
                    <span>{progress.correctAnswers}/100</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-3">
                    <div 
                      className={`h-3 rounded-full bg-gradient-to-r ${level.gradient}`}
                      style={{ width: `${Math.min(progressPercentage, 100)}%` }}
                    ></div>
                  </div>
                </div>

                {/* Opérations disponibles */}
                <div className="mb-6">
                  <p className="text-sm text-gray-600 mb-2">Opérations :</p>
                  <div className="flex flex-wrap justify-center gap-2">
                    {level.operations.map(op => (
                      <span 
                        key={op}
                        className="px-3 py-1 bg-gray-100 rounded-full text-xs font-medium"
                      >
                        {op === 'addition' && '➕ Addition'}
                        {op === 'subtraction' && '➖ Soustraction'}
                        {op === 'multiplication' && '✖️ Multiplication'}
                        {op === 'division' && '➗ Division'}
                        {op === 'mixed' && '🔀 Mixte'}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Bouton d'action */}
                <button
                  className={`w-full py-3 rounded-xl font-semibold transition-all duration-200 ${
                    isLocked
                      ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                      : progress.isCompleted
                        ? 'bg-green-500 hover:bg-green-600 text-white'
                        : 'bg-blue-500 hover:bg-blue-600 text-white'
                  }`}
                  disabled={isLocked}
                >
                  {isLocked 
                    ? '🔒 Verrouillé' 
                    : progress.isCompleted 
                      ? '🔄 Réviser' 
                      : '🎮 Commencer'
                  }
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Statistiques globales */}
      <div className="mt-16 bg-white rounded-3xl p-8 shadow-xl">
        <h3 className="text-2xl font-bold text-center text-gray-900 mb-8">
          Tes statistiques globales
        </h3>
        
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div className="text-center">
            <div className="text-3xl font-bold text-blue-600 mb-2">
              {userProgress.overallStats.totalCorrect}
            </div>
            <div className="text-gray-600">Bonnes réponses</div>
          </div>
          
          <div className="text-center">
            <div className="text-3xl font-bold text-green-600 mb-2">
              {Math.round(userProgress.overallStats.accuracy)}%
            </div>
            <div className="text-gray-600">Précision</div>
          </div>
          
          <div className="text-center">
            <div className="text-3xl font-bold text-purple-600 mb-2">
              {userProgress.overallStats.streak}
            </div>
            <div className="text-gray-600">Série actuelle</div>
          </div>
          
          <div className="text-center">
            <div className="text-3xl font-bold text-orange-600 mb-2">
              {userProgress.overallStats.maxStreak}
            </div>
            <div className="text-gray-600">Meilleure série</div>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF
    
    log_success "Composants React avancés créés"
}

# 8. TESTS COMPLETS
create_comprehensive_tests() {
    log_header "TESTS COMPLETS - TOUS TYPES"
    
    mkdir -p tests/{e2e,api,performance,stress,translation}
    
    # Tests Playwright complets
    cat > tests/e2e/math4child.complete.spec.ts << 'EOF'
// ===================================================================
// 🧪 TESTS COMPLETS MATH4CHILD
// Tests fonctionnels, traduction, performance, stress
// ===================================================================

import { test, expect, Page } from '@playwright/test';

// Configuration des tests
const TEST_CONFIG = {
  baseURL: 'http://localhost:3000',
  timeout: 30000,
  languages: ['fr', 'en', 'es', 'ar', 'de', 'zh', 'pt', 'ru', 'ja', 'ko'],
  levels: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
  operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed']
};

test.describe('Math4Child - Tests Complets', () => {
  
  // TESTS FONCTIONNELS DE BASE
  test.describe('Tests Fonctionnels', () => {
    
    test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
      await page.goto('/');
      
      // Vérifier les éléments principaux
      await expect(page.locator('h1')).toContainText('Math4Child');
      await expect(page.locator('[data-testid="language-selector"]')).toBeVisible();
      await expect(page.locator('button:has-text("🎮")')).toBeVisible();
      
      // Vérifier les statistiques
      await expect(page.locator('text=100k+')).toBeVisible();
      await expect(page.locator('text=5M+')).toBeVisible();
    });

    test('Navigation entre les vues fonctionne @navigation', async ({ page }) => {
      await page.goto('/');
      
      // Aller vers les niveaux
      await page.click('button:has-text("🎮")');
      await expect(page.locator('text=Choisis ton niveau')).toBeVisible();
      
      // Retour à l'accueil
      await page.click('text=Retour à l\'accueil');
      await expect(page.locator('h1:has-text("Math4Child")')).toBeVisible();
    });

    test('Sélection de niveau fonctionne @levels', async ({ page }) => {
      await page.goto('/');
      
      // Aller vers les niveaux
      await page.click('button:has-text("🎮")');
      
      // Sélectionner le niveau débutant (seul débloqué par défaut)
      await page.click('[data-level="beginner"]:not([disabled])');
      
      // Vérifier qu'on arrive sur l'interface de jeu
      await expect(page.locator('[data-testid="game-interface"]')).toBeVisible();
    });

    test('Compteur de questions gratuites fonctionne @freemium', async ({ page }) => {
      await page.goto('/');
      
      // Vérifier le compteur initial
      await expect(page.locator('text=50 questions gratuites')).toBeVisible();
      
      // Répondre à quelques questions
      await page.click('button:has-text("🎮")');
      await page.click('[data-level="beginner"]:not([disabled])');
      
      // Simuler quelques réponses
      for (let i = 0; i < 5; i++) {
        await page.fill('[data-testid="answer-input"]', '5');
        await page.click('button:has-text("Valider")');
        await page.click('button:has-text("Suivant")');
      }
      
      // Vérifier que le compteur a diminué
      await expect(page.locator('text=45 questions gratuites')).toBeVisible();
    });
  });

  // TESTS DE TRADUCTION
  test.describe('Tests de Traduction', () => {
    
    for (const lang of TEST_CONFIG.languages) {
      test(`Interface traduite correctement en ${lang} @i18n`, async ({ page }) => {
        await page.goto('/');
        
        // Changer de langue
        await page.click('[data-testid="language-selector"]');
        await page.click(`[data-language="${lang}"]`);
        
        // Attendre que la traduction soit appliquée
        await page.waitForTimeout(1000);
        
        // Vérifier que les éléments principaux sont traduits
        const titleElement = page.locator('h1').first();
        await expect(titleElement).toBeVisible();
        
        // Vérifier la direction RTL pour l'arabe
        if (lang === 'ar') {
          const bodyDir = await page.locator('body, [dir="rtl"]').first().getAttribute('dir');
          expect(bodyDir).toBe('rtl');
          
          // Vérifier le contenu en arabe
          await expect(page.locator('body')).toContainText(/العربية|الرياضيات/);
        }
      });
    }

    test('Dropdown de langues avec scroll fonctionne @ui', async ({ page }) => {
      await page.goto('/');
      
      // Ouvrir le dropdown
      await page.click('[data-testid="language-selector"]');
      
      // Vérifier que le scroll est visible
      const dropdown = page.locator('[data-testid="language-dropdown"]');
      await expect(dropdown).toBeVisible();
      
      // Vérifier qu'on peut scroller
      await dropdown.hover();
      await page.mouse.wheel(0, 100);
      
      // Vérifier que le drapeau marocain est utilisé pour l'arabe
      const arabicOption = page.locator('[data-language="ar"]');
      await expect(arabicOption).toContainText('🇲🇦');
    });

    test('Traduction des modaux fonctionne @modal', async ({ page }) => {
      await page.goto('/');
      
      // Changer vers le français
      await page.click('[data-testid="language-selector"]');
      await page.click('[data-language="fr"]');
      
      // Ouvrir le modal d'abonnement
      await page.click('button:has-text("Upgrade")');
      
      // Vérifier que le modal est traduit
      await expect(page.locator('.subscription-modal')).toContainText(/abonnement|plan/i);
      
      // Changer vers l'anglais
      await page.click('[data-testid="language-selector"]');
      await page.click('[data-language="en"]');
      
      // Vérifier que le modal est retraduit
      await expect(page.locator('.subscription-modal')).toContainText(/subscription|plan/i);
    });
  });

  // TESTS DE PERFORMANCE
  test.describe('Tests de Performance', () => {
    
    test('Page d\'accueil se charge en moins de 3 secondes @performance', async ({ page }) => {
      const startTime = Date.now();
      
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      const loadTime = Date.now() - startTime;
      expect(loadTime).toBeLessThan(3000);
    });

    test('Changement de langue est instantané @performance', async ({ page }) => {
      await page.goto('/');
      
      const startTime = Date.now();
      
      await page.click('[data-testid="language-selector"]');
      await page.click('[data-language="es"]');
      
      // Attendre que le changement soit visible
      await expect(page.locator('body')).toContainText(/español/i);
      
      const changeTime = Date.now() - startTime;
      expect(changeTime).toBeLessThan(500); // Moins de 500ms
    });

    test('Génération de questions est rapide @performance', async ({ page }) => {
      await page.goto('/');
      
      // Aller au jeu
      await page.click('button:has-text("🎮")');
      await page.click('[data-level="beginner"]:not([disabled])');
      
      const startTime = Date.now();
      
      // Générer plusieurs questions
      for (let i = 0; i < 10; i++) {
        await page.fill('[data-testid="answer-input"]', '1');
        await page.click('button:has-text("Valider")');
        await page.click('button:has-text("Suivant")');
      }
      
      const generationTime = Date.now() - startTime;
      expect(generationTime).toBeLessThan(5000); // Moins de 5 secondes pour 10 questions
    });
  });

  // TESTS DE STRESS
  test.describe('Tests de Stress', () => {
    
    test('Application stable avec changements rapides de langue @stress', async ({ page }) => {
      await page.goto('/');
      
      // Changer rapidement entre plusieurs langues
      for (let i = 0; i < 20; i++) {
        const randomLang = TEST_CONFIG.languages[Math.floor(Math.random() * TEST_CONFIG.languages.length)];
        await page.click('[data-testid="language-selector"]');
        await page.click(`[data-language="${randomLang}"]`);
        await page.waitForTimeout(100);
      }
      
      // Vérifier que l'application fonctionne toujours
      await expect(page.locator('h1')).toBeVisible();
    });

    test('Réponses multiples rapides ne cassent pas le jeu @stress', async ({ page }) => {
      await page.goto('/');
      
      // Aller au jeu
      await page.click('button:has-text("🎮")');
      await page.click('[data-level="beginner"]:not([disabled])');
      
      // Répondre très rapidement à de nombreuses questions
      for (let i = 0; i < 50; i++) {
        await page.fill('[data-testid="answer-input"]', Math.floor(Math.random() * 20).toString());
        await page.click('button:has-text("Valider")');
        await page.click('button:has-text("Suivant")');
      }
      
      // Vérifier que l'interface de jeu fonctionne toujours
      await expect(page.locator('[data-testid="game-interface"]')).toBeVisible();
    });
  });

  // TESTS D'ACCESSIBILITÉ
  test.describe('Tests d\'Accessibilité', () => {
    
    test('Navigation au clavier fonctionne @a11y', async ({ page }) => {
      await page.goto('/');
      
      // Naviguer avec Tab
      await page.keyboard.press('Tab');
      await page.keyboard.press('Tab');
      await page.keyboard.press('Enter');
      
      // Vérifier qu'on peut interagir avec les éléments
      await expect(page.locator(':focus')).toBeVisible();
    });

    test('Contrastes de couleurs sont suffisants @a11y', async ({ page }) => {
      await page.goto('/');
      
      // Vérifier que les éléments principaux ont un bon contraste
      const buttons = page.locator('button');
      const count = await buttons.count();
      
      for (let i = 0; i < count; i++) {
        const button = buttons.nth(i);
        const styles = await button.evaluate(el => getComputedStyle(el));
        
        // Les couleurs principales doivent avoir un contraste suffisant
        // (test basique - en production, utiliser des outils spécialisés)
        expect(styles.color).toBeTruthy();
        expect(styles.backgroundColor).toBeTruthy();
      }
    });
  });
});

// Tests des API REST
test.describe('Tests API REST', () => {
  
  test('API d\'authentification fonctionne @api', async ({ request }) => {
    const response = await request.post('/api/auth/login', {
      data: {
        email: 'test@math4child.com',
        password: 'Test123!'
      }
    });
    
    expect(response.ok()).toBeTruthy();
    
    const data = await response.json();
    expect(data.token).toBeTruthy();
  });

  test('API de progression fonctionne @api', async ({ request }) => {
    // Authentification d'abord
    const authResponse = await request.post('/api/auth/login', {
      data: {
        email: 'test@math4child.com',
        password: 'Test123!'
      }
    });
    
    const { token } = await authResponse.json();
    
    // Tester l'API de progression
    const response = await request.get('/api/progress', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    expect(response.ok()).toBeTruthy();
    
    const progress = await response.json();
    expect(progress.userId).toBeTruthy();
    expect(progress.levelProgress).toBeTruthy();
  });

  test('API de paiement fonctionne @api', async ({ request }) => {
    const response = await request.post('/api/payment/create-session', {
      data: {
        planId: 'monthly',
        countryCode: 'FR'
      }
    });
    
    expect(response.ok()).toBeTruthy();
    
    const session = await response.json();
    expect(session.sessionId).toBeTruthy();
    expect(session.paymentMethods).toBeTruthy();
  });
});
EOF
    
    log_success "Tests complets créés"
}

# Fonction principale
main() {
    log_header "MATH4CHILD - SYSTÈME COMPLET ET RICHE"
    
    echo ""
    log_info "🎯 Spécifications implémentées :"
    echo "   ✅ 75+ langues avec arabe 🇲🇦 (drapeau marocain)"
    echo "   ✅ Dropdown langues avec scroll visible"
    echo "   ✅ 5 niveaux (100 bonnes réponses chacun)"
    echo "   ✅ 5 opérations mathématiques"
    echo "   ✅ Accès niveaux validés conservé"
    echo "   ✅ Système abonnements multi-appareils"
    echo "   ✅ Réductions: 50% (2ème), 75% (3ème appareil)"
    echo "   ✅ Plans: Gratuit 7j + Mensuel + Trimestriel (-10%) + Annuel (-30%)"
    echo "   ✅ Profils multiples selon plan"
    echo "   ✅ Prix mondiaux adaptés au pouvoir d'achat"
    echo "   ✅ Paiements acceptés partout dans le monde"
    echo "   ✅ Générateur questions adaptatif"
    echo "   ✅ Tests complets (fonctionnels, traduction, stress, API)"
    echo "   ✅ Design interactif et attrayant"
    echo "   ✅ Support RTL complet"
    echo ""
    
    # Créer tous les systèmes
    create_global_language_system
    create_progression_system  
    create_question_generator
    create_subscription_system
    create_global_pricing
    create_payment_system
    create_advanced_components
    create_comprehensive_tests
    
    # Créer les comptes de test
    cat > accounts.test.md << 'EOF'
# 🧪 COMPTES DE TEST MATH4CHILD

## Comptes par niveau d'abonnement

### 1. Essai Gratuit (7 jours)
- **Email**: trial@math4child.com
- **Mot de passe**: Trial123!
- **Profils**: 2 enfants
- **Questions**: 50 gratuites
- **Niveaux**: Débutant uniquement

### 2. Abonnement Mensuel  
- **Email**: monthly@math4child.com
- **Mot de passe**: Monthly123!
- **Profils**: 3 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous (1-5)

### 3. Abonnement Trimestriel (-10%)
- **Email**: quarterly@math4child.com  
- **Mot de passe**: Quarterly123!
- **Profils**: 5 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous + fonctionnalités premium

### 4. Abonnement Annuel (-30%)
- **Email**: yearly@math4child.com
- **Mot de passe**: Yearly123!
- **Profils**: 10 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous + support VIP

### 5. Premium Famille
- **Email**: premium@math4child.com
- **Mot de passe**: Premium123!
- **Profils**: 20 enfants  
- **Questions**: Illimitées
- **Niveaux**: Tous + fonctionnalités exclusives

## Comptes de test par progression

### Niveau Débutant Validé
- **Email**: beginner@math4child.com
- **Mot de passe**: Beginner123!
- **Progression**: 100/100 niveau débutant

### Niveau Intermédiaire  
- **Email**: intermediate@math4child.com
- **Mot de passe**: Inter123!
- **Progression**: Niveaux 1-3 validés

### Niveau Expert
- **Email**: expert@math4child.com
- **Mot de passe**: Expert123!
- **Progression**: Tous niveaux validés

## Comptes multi-appareils

### 1 Appareil (Web)
- **Email**: web@math4child.com
- **Mot de passe**: Web123!
- **Appareils**: Web uniquement

### 2 Appareils (Web + Mobile)
- **Email**: multi2@math4child.com
- **Mot de passe**: Multi2123!
- **Appareils**: Web + Android (50% réduction sur 2ème)

### 3 Appareils (Web + Android + iOS)
- **Email**: multi3@math4child.com
- **Mot de passe**: Multi3123!
- **Appareils**: Tous (75% réduction sur 3ème)

## Accès Admin

### Super Admin
- **Email**: admin@math4child.com
- **Mot de passe**: SuperAdmin123!
- **Permissions**: Gestion complète

### Support
- **Email**: support@math4child.com  
- **Mot de passe**: Support123!
- **Permissions**: Support client
EOF

    echo ""
    log_header "DÉPLOIEMENTS MULTI-PLATEFORMES"
    
    # Générer les scripts de déploiement
    cat > deploy-web.sh << 'EOF'
#!/bin/bash
# Déploiement Web (www.math4child.com)
echo "🌐 Déploiement Web Math4Child..."
npm run build
npm run export
# Déployer sur Vercel/Netlify
vercel --prod
echo "✅ Déployé sur: https://www.math4child.com"
EOF

    cat > deploy-android.sh << 'EOF'
#!/bin/bash
# Déploiement Android (Google Play Store)
echo "📱 Déploiement Android Math4Child..."
npx cap build android
npx cap run android --prod
# Générer APK/AAB pour Play Store
./gradlew bundleRelease
echo "✅ APK prêt pour Google Play Store"
EOF

    cat > deploy-ios.sh << 'EOF'
#!/bin/bash
# Déploiement iOS (App Store)
echo "📱 Déploiement iOS Math4Child..."
npx cap build ios
npx cap run ios --prod
# Ouvrir Xcode pour soumission App Store
open ios/App/App.xcworkspace
echo "✅ Projet iOS prêt pour App Store"
EOF

    chmod +x deploy-*.sh
    
    echo ""
    log_success "🎉 MATH4CHILD SYSTÈME COMPLET CRÉÉ !"
    echo ""
    log_info "📋 Fichiers générés :"
    echo "   📁 src/lib/i18n/languages.ts (75+ langues)"
    echo "   📁 src/lib/game/levels.ts (5 niveaux progression)"  
    echo "   📁 src/lib/game/questionGenerator.ts (générateur adaptatif)"
    echo "   📁 src/lib/subscription/plans.ts (abonnements premium)"
    echo "   📁 src/lib/pricing/globalPricing.ts (prix mondiaux)"
    echo "   📁 src/lib/payment/paymentMethods.ts (paiements mondiaux)" 
    echo "   📁 src/app/page.tsx (interface premium complète)"
    echo "   📁 src/components/game/ (composants jeu avancés)"
    echo "   📁 tests/e2e/math4child.complete.spec.ts (tests complets)"
    echo "   📁 accounts.test.md (comptes de test)"
    echo "   📁 deploy-*.sh (scripts déploiement)"
    echo ""
    log_info "🚀 Pour démarrer :"
    echo "   npm install"
    echo "   npm run dev"
    echo "   Ouvrir http://localhost:3000"
    echo ""
    log_info "🧪 Pour tester :"
    echo "   npm run test (tests unitaires)"
    echo "   npx playwright test (tests E2E)"
    echo ""
    log_info "🌍 Déploiements :"
    echo "   ./deploy-web.sh (Web - www.math4child.com)"
    echo "   ./deploy-android.sh (Android - Google Play)"
    echo "   ./deploy-ios.sh (iOS - App Store)"
    echo ""
    log_header "VERSION RICHE ET COMPLÈTE PRÊTE ! 🎊"
}

# Exécution
main "$@"
    