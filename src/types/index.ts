// =============================================================================
// 📝 TYPES CONSOLIDÉS MATH4CHILD v4.2.0 - VERSION FINALE
// =============================================================================

export interface User {
  id: string;
  name: string;
  email?: string;
  level: number;
  progress: number;
  badges: Badge[];
  createdAt: Date;
  updatedAt: Date;
}

export interface Exercise {
  id: string;
  type: ExerciseType;
  level: number;
  question: string;
  answer: number | string;
  options?: string[];
  difficulty: number;
  aiGenerated: boolean;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  unlockedAt: Date;
}

export interface UserStats {
  totalQuestions: number;
  totalCorrect: number;
  overallPrecision: number;
  currentStreak: number;
  bestStreak: number;
  levelsCompleted: number[];
  timeSpent: number;
  badges: Badge[];
  lastSession: string;
}

export interface LevelResult {
  level: number;
  questionsAnswered: number;
  correctAnswers: number;
  precision: number;
  timeSpent: number;
  completed: boolean;
}

export type ExerciseType = 
  | 'addition'
  | 'subtraction'
  | 'multiplication'
  | 'division'
  | 'mixed';

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  rtl?: boolean;
}

export interface AISettings {
  adaptiveMode: boolean;
  difficultyAdjustment: 'auto' | 'manual';
  voiceEnabled: boolean;
  handwritingEnabled: boolean;
  arEnabled: boolean;
}

export interface ExerciseStats {
  level: number;
  questionsAnswered: number;
  correctAnswers: number;
  averageTime: number;
  lastPlayed: Date;
}

// Types Stripe intégrés pour éviter les conflits
export interface StripeConfig {
  publishableKey: string;
  secretKey?: string;
}

export interface PaymentIntent {
  id: string;
  amount: number;
  currency: string;
  status: string;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
}

// Types pour les traductions
export interface TranslationData {
  title: string;
  subtitle: string;
  description: string;
  features: string[];
  cta: string;
  [key: string]: string | string[];
}

export interface Translations {
  [languageCode: string]: TranslationData;
}
