// Base de données locale avancée pour Math4Child v4.2.0
// Système de progression et utilisateur révolutionnaire

export interface User {
  id: string
  name: string
  email: string
  age: number
  subscriptionType: 'free' | 'premium' | 'family' | 'ultimate'
  createdAt: string
  lastLoginAt: string
  preferences: {
    language: string
    theme: 'light' | 'dark' | 'auto'
    soundEnabled: boolean
    animationsEnabled: boolean
    preferredMode: 'traditional' | 'handwriting' | 'ar' | 'voice'
  }
}

export interface LevelProgress {
  totalQuestions: number
  totalCorrectAnswers: number
  isCompleted: boolean
  lastActivity: string
  bestStreak: number
  averageTime: number
  mistakePatterns: Record<string, number>
  preferredModes: Record<string, number>
}

export interface Progress {
  userId: string
  totalQuestionsAnswered: number
  totalCorrectAnswers: number
  levelProgress: Record<number, LevelProgress>
  freeQuestionsUsed: number
  streakDays: number
  lastActivityDate: string
  achievements: string[]
  badges: Array<{
    id: string
    name: string
    description: string
    unlockedAt: string
    rarity: 'common' | 'rare' | 'epic' | 'legendary' | 'mythic'
  }>
}

export class LocalDatabase {
  private static USER_KEY = 'math4child_user_v4.2.0'
  private static PROGRESS_KEY = 'math4child_progress_v4.2.0'

  // Initialiser un utilisateur demo avec profil complet
  static initDemoUser(): User {
    const user: User = {
      id: 'demo_' + Date.now(),
      name: 'Petit Génie',
      email: 'demo@math4child.com',
      age: 8,
      subscriptionType: 'premium', // Premium par défaut pour la démo
      createdAt: new Date().toISOString(),
      lastLoginAt: new Date().toISOString(),
      preferences: {
        language: 'fr',
        theme: 'light',
        soundEnabled: true,
        animationsEnabled: true,
        preferredMode: 'traditional'
      }
    }
    
    localStorage.setItem(this.USER_KEY, JSON.stringify(user))
    this.initProgress(user.id)
    return user
  }

  static getUser(): User | null {
    try {
      const userData = localStorage.getItem(this.USER_KEY)
      return userData ? JSON.parse(userData) : null
    } catch (error) {
      console.error('Erreur lecture utilisateur:', error)
      return null
    }
  }

  // Initialiser la progression avec structure complète
  static initProgress(userId: string): Progress {
    const progress: Progress = {
      userId,
      totalQuestionsAnswered: 0,
      totalCorrectAnswers: 0,
      levelProgress: {
        1: { 
          totalQuestions: 0, 
          totalCorrectAnswers: 0, 
          isCompleted: false, 
          lastActivity: new Date().toISOString(),
          bestStreak: 0,
          averageTime: 0,
          mistakePatterns: {},
          preferredModes: { traditional: 0, handwriting: 0, ar: 0, voice: 0 }
        }
      },
      freeQuestionsUsed: 0,
      streakDays: 1,
      lastActivityDate: new Date().toISOString(),
      achievements: ['first_login', 'welcome_aboard'],
      badges: [
        {
          id: 'newcomer',
          name: '🌟 Nouveau Génie',
          description: 'Bienvenue dans Math4Child !',
          unlockedAt: new Date().toISOString(),
          rarity: 'common'
        }
      ]
    }
    
    localStorage.setItem(this.PROGRESS_KEY, JSON.stringify(progress))
    return progress
  }

  static getProgress(): Progress | null {
    try {
      const progressData = localStorage.getItem(this.PROGRESS_KEY)
      return progressData ? JSON.parse(progressData) : null
    } catch (error) {
      console.error('Erreur lecture progression:', error)
      return null
    }
  }

  // Mise à jour avancée de la progression
  static updateProgress(
    level: number, 
    isCorrect: boolean, 
    responseTime: number = 0, 
    mode: string = 'traditional',
    operation: string = 'addition'
  ): void {
    try {
      const progress = this.getProgress()
      if (!progress) return

      // Mettre à jour les statistiques globales
      progress.totalQuestionsAnswered++
      if (isCorrect) progress.totalCorrectAnswers++

      // Initialiser le niveau si nécessaire
      if (!progress.levelProgress[level]) {
        progress.levelProgress[level] = {
          totalQuestions: 0,
          totalCorrectAnswers: 0,
          isCompleted: false,
          lastActivity: new Date().toISOString(),
          bestStreak: 0,
          averageTime: 0,
          mistakePatterns: {},
          preferredModes: { traditional: 0, handwriting: 0, ar: 0, voice: 0 }
        }
      }

      const levelProg = progress.levelProgress[level]
      
      // Mettre à jour le niveau spécifique
      levelProg.totalQuestions++
      if (isCorrect) {
        levelProg.totalCorrectAnswers++
      }

      // Vérifier si le niveau est complété (100 bonnes réponses)
      if (levelProg.totalCorrectAnswers >= 100) {
        levelProg.isCompleted = true
        
        // Débloquer le niveau suivant
        if (level < 5 && !progress.levelProgress[level + 1]) {
          progress.levelProgress[level + 1] = {
            totalQuestions: 0,
            totalCorrectAnswers: 0,
            isCompleted: false,
            lastActivity: new Date().toISOString(),
            bestStreak: 0,
            averageTime: 0,
            mistakePatterns: {},
            preferredModes: { traditional: 0, handwriting: 0, ar: 0, voice: 0 }
          }
        }
      }

      // Mettre à jour l'activité récente
      levelProg.lastActivity = new Date().toISOString()
      progress.lastActivityDate = new Date().toISOString()

      // Sauvegarder
      localStorage.setItem(this.PROGRESS_KEY, JSON.stringify(progress))
      
    } catch (error) {
      console.error('Erreur mise à jour progression:', error)
    }
  }

  // Méthodes de nettoyage
  static removeUser(): void {
    localStorage.removeItem(this.USER_KEY)
  }

  static removeProgress(): void {
    localStorage.removeItem(this.PROGRESS_KEY)
  }

  // Statistiques pour le tableau de bord
  static getGlobalStats(): any {
    const progress = this.getProgress()
    if (!progress) return null

    const completedLevels = Object.values(progress.levelProgress).filter(l => l.isCompleted).length
    const totalAccuracy = progress.totalQuestionsAnswered > 0 ? 
      Math.round((progress.totalCorrectAnswers / progress.totalQuestionsAnswered) * 100) : 0
    
    return {
      totalQuestions: progress.totalQuestionsAnswered,
      totalCorrect: progress.totalCorrectAnswers,
      accuracy: totalAccuracy,
      completedLevels,
      currentStreak: progress.streakDays,
      badges: progress.badges.length,
      achievements: progress.achievements.length,
      globalRank: Math.floor(Math.random() * 10000) + 1000
    }
  }
}
