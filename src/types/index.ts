// =============================================================================
// 📝 TYPES CENTRALISÉS MATH4CHILD v4.2.0
// =============================================================================

// Types pour les langues (200+ supportées selon README.md)
export interface Language {
  code: string;
  name: string;
  flag: string;
  rtl?: boolean;
  region: 'europe' | 'america' | 'asia' | 'africa' | 'oceania';
}

// Types pour les abonnements (5 plans selon README.md)
export interface SubscriptionPlan {
  id: 'basic' | 'standard' | 'premium' | 'famille' | 'ultimate';
  name: string;
  price: number;
  profiles: number;
  popular?: boolean;
  features: string[];
  badge?: string;
  currency: string;
}

// Types pour la progression (5 niveaux selon README.md)
export interface LevelProgress {
  id: number;
  name: string;
  description: string;
  requiredCorrectAnswers: 100; // Minimum selon README.md
  currentCorrectAnswers: number;
  unlocked: boolean;
  completed: boolean;
  operations: OperationType[];
}

// Types pour les opérations (5 selon README.md)
export type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

// Types pour les exercices
export interface Exercise {
  id: string;
  type: OperationType;
  level: number;
  question: string;
  correctAnswer: number;
  userAnswer?: number;
  isCorrect?: boolean;
  timeSpent?: number;
  difficulty: number;
  aiAdaptation?: AIAdaptation;
}

// Types pour l'IA adaptative
export interface AIAdaptation {
  difficultyAdjustment: number;
  personalizedHints: string[];
  nextRecommendedExercise: string;
  learningPattern: 'visual' | 'auditory' | 'kinesthetic' | 'mixed';
}

// Types pour les innovations technologiques
export interface VoiceAssistant {
  enabled: boolean;
  language: string;
  recognition: boolean;
  synthesis: boolean;
}

export interface HandwritingRecognition {
  enabled: boolean;
  accuracy: number;
  supportedAlphabets: string[];
}

export interface AugmentedReality {
  enabled: boolean;
  deviceCompatible: boolean;
  currentScene?: string;
}

// Types pour l'utilisateur
export interface User {
  id: string;
  name: string;
  email?: string;
  currentLanguage: string;
  subscription?: SubscriptionStatus;
  progress: UserProgress;
  preferences: UserPreferences;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserProgress {
  currentLevel: number;
  levelProgress: Record<number, LevelProgress>;
  totalCorrectAnswers: number;
  badges: Badge[];
  streakDays: number;
  lastActivity: Date;
}

export interface UserPreferences {
  voiceAssistant: VoiceAssistant;
  handwritingRecognition: HandwritingRecognition;
  augmentedReality: AugmentedReality;
  theme: 'light' | 'dark' | 'auto';
  sounds: boolean;
  animations: boolean;
}

export interface SubscriptionStatus {
  planId: string;
  status: 'active' | 'inactive' | 'trial' | 'cancelled';
  platform: 'web' | 'android' | 'ios';
  expiresAt: Date;
  trialUsed: boolean;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  unlockedAt: Date;
}

// Types pour les paiements
export interface PaymentInfo {
  planId: string;
  amount: number;
  currency: string;
  interval: 'monthly' | 'quarterly' | 'yearly';
  discount?: number;
  platform: 'web' | 'android' | 'ios';
}
