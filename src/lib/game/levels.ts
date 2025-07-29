// ===================================================================
// 🎯 SYSTÈME DE PROGRESSION - 5 NIVEAUX
// Chaque niveau nécessite 100 bonnes réponses pour débloquer le suivant
// ===================================================================

export interface Level {
  id: string;
  name: string;
  description: string;
  requiredCorrectAnswers: number;
  difficulty: number;
  operations: OperationType[];
  numberRange: {
    min: number;
    max: number;
  };
  icon: string;
  color: string;
  gradient: string;
}

export type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

export const MATH_LEVELS: Level[] = [
  {
    id: 'beginner',
    name: 'Débutant',
    description: 'Nombres de 1 à 10',
    requiredCorrectAnswers: 100,
    difficulty: 1,
    operations: ['addition', 'subtraction'],
    numberRange: { min: 1, max: 10 },
    icon: '🌱',
    color: '#10B981',
    gradient: 'from-green-400 to-emerald-500'
  },
  {
    id: 'elementary',
    name: 'Élémentaire',
    description: 'Nombres de 1 à 50',
    requiredCorrectAnswers: 100,
    difficulty: 2,
    operations: ['addition', 'subtraction', 'multiplication'],
    numberRange: { min: 1, max: 50 },
    icon: '🌿',
    color: '#3B82F6',
    gradient: 'from-blue-400 to-indigo-500'
  },
  {
    id: 'intermediate',
    name: 'Intermédiaire',
    description: 'Nombres de 1 à 100',
    requiredCorrectAnswers: 100,
    difficulty: 3,
    operations: ['addition', 'subtraction', 'multiplication', 'division'],
    numberRange: { min: 1, max: 100 },
    icon: '🌳',
    color: '#8B5CF6',
    gradient: 'from-purple-400 to-violet-500'
  },
  {
    id: 'advanced',
    name: 'Avancé',
    description: 'Nombres de 1 à 500',
    requiredCorrectAnswers: 100,
    difficulty: 4,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 500 },
    icon: '🌲',
    color: '#F59E0B',
    gradient: 'from-yellow-400 to-orange-500'
  },
  {
    id: 'expert',
    name: 'Expert',
    description: 'Nombres de 1 à 1000',
    requiredCorrectAnswers: 100,
    difficulty: 5,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    numberRange: { min: 1, max: 1000 },
    icon: '👑',
    color: '#EF4444',
    gradient: 'from-red-400 to-pink-500'
  }
];

export interface UserProgress {
  userId: string;
  currentLevel: string;
  levelProgress: Record<string, {
    correctAnswers: number;
    totalAttempts: number;
    isUnlocked: boolean;
    isCompleted: boolean;
    operationProgress: Record<OperationType, {
      correct: number;
      total: number;
    }>;
  }>;
  overallStats: {
    totalCorrect: number;
    totalAttempts: number;
    accuracy: number;
    streak: number;
    maxStreak: number;
  };
}

export class ProgressManager {
  static initializeUserProgress(userId: string): UserProgress {
    const progress: UserProgress = {
      userId,
      currentLevel: 'beginner',
      levelProgress: {},
      overallStats: {
        totalCorrect: 0,
        totalAttempts: 0,
        accuracy: 0,
        streak: 0,
        maxStreak: 0
      }
    };

    // Initialiser chaque niveau
    MATH_LEVELS.forEach((level, index) => {
      progress.levelProgress[level.id] = {
        correctAnswers: 0,
        totalAttempts: 0,
        isUnlocked: index === 0, // Seul le premier niveau est débloqué
        isCompleted: false,
        operationProgress: {
          addition: { correct: 0, total: 0 },
          subtraction: { correct: 0, total: 0 },
          multiplication: { correct: 0, total: 0 },
          division: { correct: 0, total: 0 },
          mixed: { correct: 0, total: 0 }
        }
      };
    });

    return progress;
  }

  static updateProgress(
    progress: UserProgress, 
    levelId: string, 
    operation: OperationType, 
    isCorrect: boolean
  ): UserProgress {
    const updatedProgress = { ...progress };
    const levelProgress = updatedProgress.levelProgress[levelId];

    // Mettre à jour les statistiques du niveau
    levelProgress.totalAttempts++;
    if (isCorrect) {
      levelProgress.correctAnswers++;
      levelProgress.operationProgress[operation].correct++;
      updatedProgress.overallStats.totalCorrect++;
      updatedProgress.overallStats.streak++;
      updatedProgress.overallStats.maxStreak = Math.max(
        updatedProgress.overallStats.maxStreak,
        updatedProgress.overallStats.streak
      );
    } else {
      updatedProgress.overallStats.streak = 0;
    }

    levelProgress.operationProgress[operation].total++;
    updatedProgress.overallStats.totalAttempts++;
    updatedProgress.overallStats.accuracy = 
      (updatedProgress.overallStats.totalCorrect / updatedProgress.overallStats.totalAttempts) * 100;

    // Vérifier si le niveau est terminé (100 bonnes réponses)
    if (levelProgress.correctAnswers >= 100 && !levelProgress.isCompleted) {
      levelProgress.isCompleted = true;
      
      // Débloquer le niveau suivant
      const currentLevelIndex = MATH_LEVELS.findIndex(l => l.id === levelId);
      if (currentLevelIndex < MATH_LEVELS.length - 1) {
        const nextLevel = MATH_LEVELS[currentLevelIndex + 1];
        updatedProgress.levelProgress[nextLevel.id].isUnlocked = true;
        updatedProgress.currentLevel = nextLevel.id;
      }
    }

    return updatedProgress;
  }

  static getAvailableLevels(progress: UserProgress): Level[] {
    return MATH_LEVELS.filter(level => 
      progress.levelProgress[level.id]?.isUnlocked || 
      progress.levelProgress[level.id]?.isCompleted
    );
  }

  static getLevelInfo(levelId: string): Level | undefined {
    return MATH_LEVELS.find(l => l.id === levelId);
  }
}
