// =============================================================================
// 🎮 SYSTÈME PROGRESSION 5 NIVEAUX MATH4CHILD v4.2.0
// =============================================================================

export interface LevelConfig {
  id: number;
  name: string;
  description: string;
  requiredCorrectAnswers: number; // 100 minimum selon README.md
  operations: OperationType[];
  difficultyRange: {
    min: number;
    max: number;
  };
  unlockConditions: string[];
  rewards: Badge[];
  estimatedDuration: string;
}

export type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

// 5 NIVEAUX SELON SPÉCIFICATIONS README.md
export const MATH4CHILD_LEVELS: LevelConfig[] = [
  {
    id: 1,
    name: 'Découverte',
    description: 'Premiers pas dans les mathématiques avec l\'IA',
    requiredCorrectAnswers: 100, // Minimum selon README.md
    operations: ['addition', 'subtraction'],
    difficultyRange: { min: 1, max: 10 },
    unlockConditions: ['Inscription terminée'],
    rewards: [
      { id: 'first_steps', name: 'Premiers Pas', description: 'Premier niveau terminé', icon: '👶', rarity: 'common' },
      { id: 'ai_beginner', name: 'Apprenti IA', description: 'Interaction avec l\'IA adaptative', icon: '🤖', rarity: 'rare' }
    ],
    estimatedDuration: '1-2 semaines'
  },
  {
    id: 2,
    name: 'Exploration',
    description: 'Découverte de la multiplication avec reconnaissance manuscrite',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication'],
    difficultyRange: { min: 1, max: 50 },
    unlockConditions: ['Niveau 1 complété (100 bonnes réponses)'],
    rewards: [
      { id: 'handwriting_master', name: 'Maître Écriture', description: 'Reconnaissance manuscrite maîtrisée', icon: '✍️', rarity: 'rare' },
      { id: 'multiplication_star', name: 'Étoile Multiplication', description: 'Expert en multiplication', icon: '⭐', rarity: 'epic' }
    ],
    estimatedDuration: '2-3 semaines'
  },
  {
    id: 3,
    name: 'Maîtrise',
    description: 'Division et assistant vocal IA émotionnel',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division'],
    difficultyRange: { min: 1, max: 100 },
    unlockConditions: ['Niveau 2 complété (100 bonnes réponses)'],
    rewards: [
      { id: 'voice_commander', name: 'Commandant Vocal', description: 'Assistant vocal IA maîtrisé', icon: '🎙️', rarity: 'epic' },
      { id: 'division_expert', name: 'Expert Division', description: 'Maître de la division', icon: '➗', rarity: 'epic' }
    ],
    estimatedDuration: '3-4 semaines'
  },
  {
    id: 4,
    name: 'Excellence',
    description: 'Réalité augmentée 3D et opérations mixtes',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    difficultyRange: { min: 1, max: 500 },
    unlockConditions: ['Niveau 3 complété (100 bonnes réponses)'],
    rewards: [
      { id: 'ar_pioneer', name: 'Pionnier AR', description: 'Réalité augmentée 3D explorée', icon: '🥽', rarity: 'legendary' },
      { id: 'mixed_operations_master', name: 'Maître Opérations Mixtes', description: 'Toutes opérations maîtrisées', icon: '🎯', rarity: 'legendary' }
    ],
    estimatedDuration: '4-5 semaines'
  },
  {
    id: 5,
    name: 'Génie Mathématique',
    description: 'Toutes les innovations révolutionnaires activées',
    requiredCorrectAnswers: 100,
    operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    difficultyRange: { min: 1, max: 1000 },
    unlockConditions: ['Niveau 4 complété (100 bonnes réponses)'],
    rewards: [
      { id: 'math_genius', name: 'Génie Mathématique', description: 'Niveau maximum atteint', icon: '🧠', rarity: 'legendary' },
      { id: 'innovation_master', name: 'Maître Innovation', description: 'Toutes les 6 innovations maîtrisées', icon: '🚀', rarity: 'legendary' },
      { id: 'global_champion', name: 'Champion Mondial', description: 'Math4Child totalement maîtrisé', icon: '🏆', rarity: 'legendary' }
    ],
    estimatedDuration: '5+ semaines'
  }
];

// Utilitaires
export function getLevelById(id: number): LevelConfig | undefined {
  return MATH4CHILD_LEVELS.find(level => level.id === id);
}

export function getNextLevel(currentLevel: number): LevelConfig | undefined {
  return MATH4CHILD_LEVELS.find(level => level.id === currentLevel + 1);
}

export function isLevelUnlocked(levelId: number, userProgress: Record<number, number>): boolean {
  if (levelId === 1) return true; // Niveau 1 toujours débloqué
  
  const previousLevel = levelId - 1;
  return (userProgress[previousLevel] || 0) >= 100; // 100 bonnes réponses minimum
}

export function calculateTotalProgress(userProgress: Record<number, number>): number {
  const totalRequired = MATH4CHILD_LEVELS.length * 100; // 5 niveaux × 100 réponses
  const totalAchieved = Object.values(userProgress).reduce((sum, progress) => sum + Math.min(progress, 100), 0);
  return Math.round((totalAchieved / totalRequired) * 100);
}
