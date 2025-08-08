// ===================================================================
// SYSTÈME DE NIVEAUX MATH4CHILD
// 5 niveaux avec validation 100 bonnes réponses
// ===================================================================

export interface Level {
  id: number;
  name: string;
  displayName: string;
  description: string;
  difficulty: string;
  numberRange: [number, number];
  requiredCorrectAnswers: number;
  unlockCondition: number | null;
  emoji: string;
}

export const LEVELS: Level[] = [
  {
    id: 1,
    name: 'discovery',
    displayName: 'Découverte',
    description: 'Premiers pas avec les nombres 1-10',
    difficulty: 'Débutant',
    numberRange: [1, 10],
    requiredCorrectAnswers: 100,
    unlockCondition: null,
    emoji: '🎯'
  },
  {
    id: 2,
    name: 'exploration',
    displayName: 'Exploration', 
    description: 'Exploration des nombres 1-20',
    difficulty: 'Facile',
    numberRange: [1, 20],
    requiredCorrectAnswers: 100,
    unlockCondition: 1,
    emoji: '🚀'
  },
  {
    id: 3,
    name: 'mastery',
    displayName: 'Maîtrise',
    description: 'Maîtrise des nombres 1-50',
    difficulty: 'Intermédiaire',
    numberRange: [1, 50],
    requiredCorrectAnswers: 100,
    unlockCondition: 2,
    emoji: '⭐'
  },
  {
    id: 4,
    name: 'expert',
    displayName: 'Expert',
    description: 'Expertise avec les nombres 1-100',
    difficulty: 'Avancé',
    numberRange: [1, 100],
    requiredCorrectAnswers: 100,
    unlockCondition: 3,
    emoji: '🏆'
  },
  {
    id: 5,
    name: 'champion',
    displayName: 'Champion',
    description: 'Maîtrise complète avec nombres 1-1000+',
    difficulty: 'Maître',
    numberRange: [1, 1000],
    requiredCorrectAnswers: 100,
    unlockCondition: 4,
    emoji: '👑'
  }
];

export interface Operation {
  id: string;
  name: string;
  displayName: string;
  description: string;
  symbol: string;
  emoji: string;
}

export const OPERATIONS: Operation[] = [
  {
    id: 'addition',
    name: 'addition',
    displayName: 'Addition',
    description: 'Additionner des nombres',
    symbol: '+',
    emoji: '➕'
  },
  {
    id: 'subtraction',
    name: 'subtraction',
    displayName: 'Soustraction',
    description: 'Soustraire des nombres',
    symbol: '−',
    emoji: '➖'
  },
  {
    id: 'multiplication',
    name: 'multiplication',
    displayName: 'Multiplication',
    description: 'Multiplier des nombres',
    symbol: '×',
    emoji: '✖️'
  },
  {
    id: 'division',
    name: 'division',
    displayName: 'Division',
    description: 'Diviser des nombres',
    symbol: '÷',
    emoji: '➗'
  },
  {
    id: 'mixed',
    name: 'mixed',
    displayName: 'Mixte',
    description: 'Combinaison de toutes les opérations',
    symbol: '🎯',
    emoji: '🎯'
  }
];

export const getLevelById = (id: number): Level | undefined => {
  return LEVELS.find(level => level.id === id);
};

export const getOperationById = (id: string): Operation | undefined => {
  return OPERATIONS.find(op => op.id === id);
};

export const getUnlockedLevels = (userProgress: Record<number, number>): number[] => {
  const unlockedLevels = [1];
  
  for (let i = 2; i <= LEVELS.length; i++) {
    const previousLevel = i - 1;
    const previousLevelProgress = userProgress[previousLevel] || 0;
    
    if (previousLevelProgress >= 100) {
      unlockedLevels.push(i);
    } else {
      break;
    }
  }
  
  return unlockedLevels;
};
