// Types centralisés Math4Child v4.2.0

export interface Language {
  code: string;
  name: string;
  flag: string;
  rtl?: boolean;
  region: 'europe' | 'america' | 'asia' | 'africa' | 'oceania';
  nativeName?: string; // Ajout pour compatibilité
}

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

export interface LevelProgress {
  id: number;
  name: string;
  description: string;
  requiredCorrectAnswers: number;
  currentCorrectAnswers: number;
  unlocked: boolean;
  completed: boolean;
  operations: OperationType[];
}

export type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

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

export interface User {
  id: string;
  name: string;
  email?: string;
  currentLanguage: string;
  subscription?: SubscriptionPlan;
  progress: LevelProgress[];
}

// Types pour les statistiques utilisateur
export interface UserStats {
  totalAnswers: number;
  correctAnswers: number;
  currentStreak: number;
  bestStreak: number;
  averageTime: number;
  badges: Badge[];
  level: number;
  xp: number;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  earnedAt?: Date;
}

// Types pour la gestion des progressions
export interface UserProgress {
  [levelId: number]: number;
}

// Types pour l'IA adaptative
export interface AIAdaptation {
  difficultyAdjustment: number;
  personalizedHints: string[];
  nextRecommendedExercise: string;
  learningPattern: 'visual' | 'auditory' | 'kinesthetic' | 'mixed';
}

// Types pour les paiements
export interface PaymentInfo {
  amount: number;
  currency: string;
  planId: string;
  userId: string;
}
