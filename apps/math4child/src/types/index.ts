// Types Math4Child v4.2.0 - Complets selon spécifications README.md
export interface Exercise {
  id: string;
  type: string; // Type d'exercice (requis par spécifications)
  difficulty: 'easy' | 'medium' | 'hard'; // String selon spécifications
  operation: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';
  level: number; // 1-5 selon spécifications
  question: string;
  answer: number;
  options?: number[];
  explanation?: string;
  points: number;
  timeLimit?: number;
  createdAt?: Date;
}

export interface User {
  id: string;
  name: string;
  age: number;
  level: number; // 1-5 avec validation 100 bonnes réponses
  xp: number;
  badges: Badge[];
  progress: Progress;
  preferences: UserPreferences;
  subscriptionPlan: 'basic' | 'standard' | 'premium' | 'famille' | 'ultimate';
  profilesUsed: number; // Selon plan: 1, 2, 3, 5, 10+
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  emoji: string;
  earned: boolean;
  dateEarned?: Date;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

export interface Progress {
  level: number; // 1-5 avec 100 bonnes réponses minimum par niveau
  correctAnswers: number; // Compteur pour validation niveau
  totalAnswers: number;
  streakCurrent: number;
  streakBest: number;
  operationsStats: {
    [key: string]: {
      correct: number;
      total: number;
      averageTime: number;
    };
  };
  unlockedFeatures: string[]; // Fonctionnalités débloquées par niveau
}

export interface UserPreferences {
  language: string; // 200+ langues supportées
  region: string;
  voicePersonality: 'amical' | 'enthousiaste' | 'patient'; // 3 personnalités IA
  handwritingEnabled: boolean; // Reconnaissance manuscrite
  voiceEnabled: boolean; // Assistant vocal IA
  ar3dEnabled: boolean; // Réalité augmentée 3D
  soundEnabled: boolean;
  difficulty: 'easy' | 'medium' | 'hard';
  theme: 'auto' | 'light' | 'dark';
}

export interface Language {
  code: string;
  name: string;
  flag: string; // Drapeaux spécifiques selon spécifications
  region: 'africa' | 'asia' | 'europe' | 'america' | 'middle-east' | 'oceania';
  direction: 'ltr' | 'rtl';
  nativeName: string;
}

export interface SubscriptionPlan {
  id: 'basic' | 'standard' | 'premium' | 'famille' | 'ultimate';
  name: string;
  price: number;
  currency: 'EUR';
  interval: 'monthly';
  profiles: number; // 1, 2, 3, 5, 10+ selon spécifications exactes
  features: string[];
  popular?: boolean; // Premium "LE PLUS CHOISI"
  badge?: string;
  description: string;
  innovations: string[]; // Innovations par plan
}

// Nouveaux types v4.2.0 pour détection branche
export interface BranchEnvironment {
  branch: string;
  environment: 'production' | 'staging' | 'development' | 'preview';
  apiUrl: string;
  debugEnabled: boolean;
  analyticsEnabled: boolean;
}

export interface InnovationFeature {
  id: string;
  name: string;
  emoji: string;
  description: string;
  status: 'operational' | 'beta' | 'development';
  requiredPlan: 'basic' | 'standard' | 'premium' | 'famille' | 'ultimate';
  demoAvailable: boolean;
}
