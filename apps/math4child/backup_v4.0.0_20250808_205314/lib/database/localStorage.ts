// ===================================================================
// BASE DE DONNÉES LOCALE MATH4CHILD
// Simulation base de données avec localStorage
// ===================================================================

import { User, UserProgress, Exercise } from '../auth/types';

const STORAGE_KEYS = {
  USER: 'math4child_user',
  PROGRESS: 'math4child_progress',
  EXERCISES: 'math4child_exercises',
  SETTINGS: 'math4child_settings'
};

export class LocalDatabase {
  static saveUser(user: User): void {
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(user));
    }
  }
  
  static getUser(): User | null {
    if (typeof window === 'undefined') return null;
    
    const userData = localStorage.getItem(STORAGE_KEYS.USER);
    if (!userData) return null;
    
    try {
      const user = JSON.parse(userData);
      if (user.createdAt) user.createdAt = new Date(user.createdAt);
      if (user.subscriptionExpiry) user.subscriptionExpiry = new Date(user.subscriptionExpiry);
      return user;
    } catch {
      return null;
    }
  }
  
  static removeUser(): void {
    if (typeof window !== 'undefined') {
      localStorage.removeItem(STORAGE_KEYS.USER);
      localStorage.removeItem(STORAGE_KEYS.PROGRESS);
      localStorage.removeItem(STORAGE_KEYS.EXERCISES);
    }
  }
  
  static saveProgress(progress: UserProgress): void {
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEYS.PROGRESS, JSON.stringify(progress));
    }
  }
  
  static getProgress(): UserProgress | null {
    if (typeof window === 'undefined') return null;
    
    const progressData = localStorage.getItem(STORAGE_KEYS.PROGRESS);
    if (!progressData) return null;
    
    try {
      const progress = JSON.parse(progressData);
      if (progress.lastActiveDate) progress.lastActiveDate = new Date(progress.lastActiveDate);
      if (progress.freeTrialStartDate) progress.freeTrialStartDate = new Date(progress.freeTrialStartDate);
      
      Object.values(progress.levelProgress || {}).forEach((level: any) => {
        if (level.completedAt) level.completedAt = new Date(level.completedAt);
        Object.values(level.operationProgress || {}).forEach((op: any) => {
          if (op.lastAttemptDate) op.lastAttemptDate = new Date(op.lastAttemptDate);
        });
      });
      
      return progress;
    } catch {
      return null;
    }
  }
  
  static saveExercise(exercise: Exercise): void {
    if (typeof window !== 'undefined') {
      const exercises = this.getExercises();
      exercises.push(exercise);
      localStorage.setItem(STORAGE_KEYS.EXERCISES, JSON.stringify(exercises));
    }
  }
  
  static getExercises(): Exercise[] {
    if (typeof window === 'undefined') return [];
    
    const exercisesData = localStorage.getItem(STORAGE_KEYS.EXERCISES);
    if (!exercisesData) return [];
    
    try {
      const exercises = JSON.parse(exercisesData);
      return exercises.map((ex: any) => ({
        ...ex,
        attemptedAt: new Date(ex.attemptedAt)
      }));
    } catch {
      return [];
    }
  }
  
  static initDemoUser(): User {
    const demoUser: User = {
      id: 'demo-user-' + Date.now(),
      email: 'demo@math4child.com',
      name: 'Utilisateur Démo',
      createdAt: new Date(),
      subscriptionType: 'free',
      profile: {
        language: 'fr',
        timezone: 'Europe/Paris',
        preferences: {
          soundEnabled: true,
          animationsEnabled: true,
          dailyReminders: true,
          weeklyReports: true
        }
      }
    };
    
    const demoProgress: UserProgress = {
      userId: demoUser.id,
      levelProgress: {},
      totalQuestionsAnswered: 0,
      totalCorrectAnswers: 0,
      streakDays: 0,
      lastActiveDate: new Date(),
      freeQuestionsUsed: 0,
      freeTrialStartDate: new Date()
    };
    
    this.saveUser(demoUser);
    this.saveProgress(demoProgress);
    
    return demoUser;
  }
  
  static canAnswerQuestion(progress: UserProgress): boolean {
    const user = this.getUser();
    if (!user) return false;
    
    if (user.subscriptionType !== 'free') return true;
    
    const trialStart = progress.freeTrialStartDate || new Date();
    const daysSinceStart = Math.floor((Date.now() - trialStart.getTime()) / (1000 * 60 * 60 * 24));
    
    if (daysSinceStart > 7) return false;
    
    return progress.freeQuestionsUsed < 50;
  }
}
