// =============================================================================
// 📝 TYPES CENTRALISÉS MATH4CHILD v4.2.0
// =============================================================================

// Re-export de tous les types
export * from './language'
export * from './subscription'

// Types généraux
export interface User {
  id: string;
  name: string;
  email?: string;
  currentLanguage: string;
  subscription?: SubscriptionStatus;
  progress: UserProgress;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserProgress {
  currentLevel: number;
  levelProgress: Record<number, number>; // niveau -> bonnes réponses
  totalCorrectAnswers: number;
  badges: Badge[];
  streakDays: number;
  lastActivity: Date;
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

// Types pour les exercices
export interface Exercise {
  id: string;
  type: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';
  level: number;
  question: string;
  correctAnswer: number;
  userAnswer?: number;
  isCorrect?: boolean;
  timeSpent?: number;
  difficulty: number;
}

export interface ExerciseSession {
  id: string;
  level: number;
  exercises: Exercise[];
  startedAt: Date;
  completedAt?: Date;
  correctAnswers: number;
  totalQuestions: number;
  averageTime: number;
}
