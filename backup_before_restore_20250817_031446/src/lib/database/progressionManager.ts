// =============================================================================
// 🧠 GESTIONNAIRE DE PROGRESSION MATH4CHILD v4.2.0
// =============================================================================
// Correction du bug des statistiques qui se réinitialisent
// =============================================================================

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

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  unlockedAt: Date;
}

export class ProgressionManager {
  private static instance: ProgressionManager;
  private userStats: UserStats;

  private constructor() {
    this.userStats = this.loadUserStats();
  }

  static getInstance(): ProgressionManager {
    if (!ProgressionManager.instance) {
      ProgressionManager.instance = new ProgressionManager();
    }
    return ProgressionManager.instance;
  }

  private loadUserStats(): UserStats {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('math4child_user_stats');
      if (saved) {
        try {
          return JSON.parse(saved);
        } catch (error) {
          console.warn('Erreur lors du chargement des stats:', error);
        }
      }
    }
    
    // Stats par défaut
    return {
      totalQuestions: 0,
      totalCorrect: 0,
      overallPrecision: 0,
      currentStreak: 0,
      bestStreak: 0,
      levelsCompleted: [],
      timeSpent: 0,
      badges: [],
      lastSession: new Date().toISOString()
    };
  }

  updateStats(levelResult: LevelResult): UserStats {
    // Mettre à jour les statistiques globales
    this.userStats.totalQuestions += levelResult.questionsAnswered;
    this.userStats.totalCorrect += levelResult.correctAnswers;
    this.userStats.overallPrecision = this.userStats.totalQuestions > 0 
      ? Math.round((this.userStats.totalCorrect / this.userStats.totalQuestions) * 100)
      : 0;

    // Gestion des séries
    if (levelResult.precision === 100) {
      this.userStats.currentStreak += 1;
      this.userStats.bestStreak = Math.max(
        this.userStats.bestStreak, 
        this.userStats.currentStreak
      );
    } else {
      this.userStats.currentStreak = 0;
    }

    // Marquer le niveau comme complété si score parfait
    if (levelResult.precision === 100 && !this.userStats.levelsCompleted.includes(levelResult.level)) {
      this.userStats.levelsCompleted.push(levelResult.level);
    }

    // Temps passé
    this.userStats.timeSpent += levelResult.timeSpent;
    this.userStats.lastSession = new Date().toISOString();

    // Vérifier les nouveaux badges
    this.checkForNewBadges();

    // Sauvegarder
    this.saveUserStats();
    
    return { ...this.userStats };
  }

  private checkForNewBadges(): void {
    const newBadges: Badge[] = [];

    // Badge première réponse
    if (this.userStats.totalQuestions === 1 && !this.hasBadge('first_answer')) {
      newBadges.push({
        id: 'first_answer',
        name: 'Premier Pas',
        description: 'Première question répondue',
        icon: '🌟',
        unlockedAt: new Date()
      });
    }

    // Badge précision parfaite
    if (this.userStats.overallPrecision === 100 && this.userStats.totalQuestions >= 10 && !this.hasBadge('perfect_precision')) {
      newBadges.push({
        id: 'perfect_precision',
        name: 'Précision Parfaite',
        description: '100% de précision sur 10+ questions',
        icon: '🎯',
        unlockedAt: new Date()
      });
    }

    // Badge série de 5
    if (this.userStats.currentStreak >= 5 && !this.hasBadge('streak_5')) {
      newBadges.push({
        id: 'streak_5',
        name: 'Série Extraordinaire',
        description: '5 exercices parfaits consécutifs',
        icon: '🔥',
        unlockedAt: new Date()
      });
    }

    // Badge explorateur (3 niveaux différents)
    if (this.userStats.levelsCompleted.length >= 3 && !this.hasBadge('explorer')) {
      newBadges.push({
        id: 'explorer',
        name: 'Explorateur Math',
        description: '3 niveaux différents complétés',
        icon: '🗺️',
        unlockedAt: new Date()
      });
    }

    // Badge champion (100 questions)
    if (this.userStats.totalQuestions >= 100 && !this.hasBadge('champion')) {
      newBadges.push({
        id: 'champion',
        name: 'Champion Math',
        description: '100 questions répondues',
        icon: '👑',
        unlockedAt: new Date()
      });
    }

    // Badge maîtrise (tous les niveaux)
    if (this.userStats.levelsCompleted.length >= 5 && !this.hasBadge('master')) {
      newBadges.push({
        id: 'master',
        name: 'Maître Mathématicien',
        description: 'Tous les niveaux maîtrisés',
        icon: '🧠',
        unlockedAt: new Date()
      });
    }

    // Ajouter les nouveaux badges
    newBadges.forEach(badge => {
      this.userStats.badges.push(badge);
      console.log(`🏆 Nouveau badge débloqué: ${badge.name}`);
    });
  }

  private hasBadge(badgeId: string): boolean {
    return this.userStats.badges.some(badge => badge.id === badgeId);
  }

  private saveUserStats(): void {
    if (typeof window !== 'undefined') {
      try {
        localStorage.setItem('math4child_user_stats', JSON.stringify(this.userStats));
      } catch (error) {
        console.warn('Erreur lors de la sauvegarde des stats:', error);
      }
    }
  }

  getUserStats(): UserStats {
    return { ...this.userStats };
  }

  getStatsForLevel(level: number): { questionsThisLevel: number; correctThisLevel: number } {
    // Pour une version future, on pourrait tracker les stats par niveau
    return {
      questionsThisLevel: 0,
      correctThisLevel: 0
    };
  }

  resetStats(): void {
    this.userStats = {
      totalQuestions: 0,
      totalCorrect: 0,
      overallPrecision: 0,
      currentStreak: 0,
      bestStreak: 0,
      levelsCompleted: [],
      timeSpent: 0,
      badges: [],
      lastSession: new Date().toISOString()
    };
    this.saveUserStats();
  }

  exportStats(): string {
    return JSON.stringify(this.userStats, null, 2);
  }

  importStats(statsJson: string): boolean {
    try {
      const importedStats = JSON.parse(statsJson);
      this.userStats = { ...this.loadUserStats(), ...importedStats };
      this.saveUserStats();
      return true;
    } catch (error) {
      console.error('Erreur lors de l\'import:', error);
      return false;
    }
  }
}

// Instance globale
export const progressionManager = ProgressionManager.getInstance();
