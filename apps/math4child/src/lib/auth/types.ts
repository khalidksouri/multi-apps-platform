export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
  subscriptionType: 'free' | 'premium' | 'family' | 'ultimate';
  subscriptionExpiry?: Date;
  profile: UserProfile;
}

export interface UserProfile {
  avatarUrl?: string;
  dateOfBirth?: Date;
  language: string;
  timezone: string;
  preferences: UserPreferences;
}

export interface UserPreferences {
  soundEnabled: boolean;
  animationsEnabled: boolean;
  dailyReminders: boolean;
  weeklyReports: boolean;
}

export interface UserProgress {
  userId: string;
  levelProgress: Record<number, LevelProgress>;
  totalQuestionsAnswered: number;
  totalCorrectAnswers: number;
  streakDays: number;
  lastActiveDate: Date;
  freeQuestionsUsed: number;
  freeTrialStartDate?: Date;
}

export interface LevelProgress {
  level: number;
  operationProgress: Record<string, OperationProgress>;
  totalCorrectAnswers: number;
  isCompleted: boolean;
  completedAt?: Date;
}

export interface OperationProgress {
  operation: string;
  correctAnswers: number;
  totalAttempts: number;
  averageTime: number;
  lastAttemptDate: Date;
  bestStreak: number;
  currentStreak: number;
}

export interface Exercise {
  id: string;
  userId: string;
  level: number;
  operation: string;
  question: string;
  userAnswer: number;
  correctAnswer: number;
  isCorrect: boolean;
  timeSpent: number;
  attemptedAt: Date;
}
