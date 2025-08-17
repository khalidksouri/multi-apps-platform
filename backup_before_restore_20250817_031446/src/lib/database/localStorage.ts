// Base de données locale simple pour Math4Child v4.2.0

export interface User {
  id: string
  name: string
  email: string
  level: number
  score: number
}

export interface Progress {
  totalQuestions: number
  correctAnswers: number
  currentLevel: number
  streak: number
}

export class LocalDatabase {
  private static USER_KEY = 'math4child_user'
  private static PROGRESS_KEY = 'math4child_progress'

  static getUser(): User | null {
    try {
      const userData = localStorage.getItem(this.USER_KEY)
      return userData ? JSON.parse(userData) : null
    } catch (error) {
      console.error('Erreur lecture utilisateur:', error)
      return null
    }
  }

  static saveUser(user: User): void {
    try {
      localStorage.setItem(this.USER_KEY, JSON.stringify(user))
    } catch (error) {
      console.error('Erreur sauvegarde utilisateur:', error)
    }
  }

  static getProgress(): Progress {
    try {
      const progressData = localStorage.getItem(this.PROGRESS_KEY)
      return progressData ? JSON.parse(progressData) : {
        totalQuestions: 0,
        correctAnswers: 0,
        currentLevel: 1,
        streak: 0
      }
    } catch (error) {
      console.error('Erreur lecture progression:', error)
      return {
        totalQuestions: 0,
        correctAnswers: 0,
        currentLevel: 1,
        streak: 0
      }
    }
  }

  static saveProgress(progress: Progress): void {
    try {
      localStorage.setItem(this.PROGRESS_KEY, JSON.stringify(progress))
    } catch (error) {
      console.error('Erreur sauvegarde progression:', error)
    }
  }

  static updateProgress(isCorrect: boolean): void {
    const progress = this.getProgress()
    progress.totalQuestions++
    if (isCorrect) {
      progress.correctAnswers++
      progress.streak++
    } else {
      progress.streak = 0
    }
    this.saveProgress(progress)
  }
}
