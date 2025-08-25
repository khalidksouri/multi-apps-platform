// Générateur d'exercices Math4Child v4.2.0 - Conforme spécifications
import type { Exercise } from '../types';

export function generateExercise(
  operation: Exercise['operation'],
  level: number,
  difficulty: Exercise['difficulty']
): Exercise {
  // Ranges selon les 5 niveaux spécifiés
  const ranges = {
    1: { min: 1, max: 20 },    // Niveau 1 - Débutant
    2: { min: 5, max: 50 },    // Niveau 2 - Apprenti  
    3: { min: 10, max: 100 },  // Niveau 3 - Maîtrise
    4: { min: 25, max: 500 },  // Niveau 4 - Excellence
    5: { min: 50, max: 1000 }  // Niveau 5 - Légende
  };

  const range = ranges[level as keyof typeof ranges] || ranges[1];
  let a: number, b: number, answer: number, question: string;

  switch (operation) {
    case 'addition':
      a = Math.floor(Math.random() * range.max) + range.min;
      b = Math.floor(Math.random() * range.max) + range.min;
      answer = a + b;
      question = `${a} + ${b} = ?`;
      break;
    
    case 'subtraction':
      a = Math.floor(Math.random() * range.max) + range.min;
      b = Math.floor(Math.random() * (a - 1)) + 1;
      answer = a - b;
      question = `${a} - ${b} = ?`;
      break;
    
    case 'multiplication':
      const multiMax = Math.min(12, Math.floor(range.max / 10));
      a = Math.floor(Math.random() * multiMax) + 1;
      b = Math.floor(Math.random() * multiMax) + 1;
      answer = a * b;
      question = `${a} × ${b} = ?`;
      break;
    
    case 'division':
      const divMax = Math.min(12, Math.floor(range.max / 10));
      b = Math.floor(Math.random() * divMax) + 1;
      answer = Math.floor(Math.random() * divMax) + 1;
      a = b * answer;
      question = `${a} ÷ ${b} = ?`;
      break;
    
    case 'mixed':
      const operations: Exercise['operation'][] = ['addition', 'subtraction', 'multiplication', 'division'];
      const randomOp = operations[Math.floor(Math.random() * operations.length)];
      return generateExercise(randomOp, level, difficulty);
    
    default:
      throw new Error(`Opération non supportée: ${operation}`);
  }

  // Points selon difficulté et niveau (système gamifié)
  const basePoints = { easy: 10, medium: 15, hard: 25 };
  const levelMultiplier = level * 2;
  const points = basePoints[difficulty] + levelMultiplier;

  // Temps limite adapté au niveau
  const baseTime = { easy: 60, medium: 45, hard: 30 };
  const timeLimit = baseTime[difficulty] - (level * 2);

  return {
    id: `${operation}-${level}-${difficulty}-${Date.now()}`,
    type: `math-${operation}`, // Type requis par spécifications
    difficulty,
    operation,
    level,
    question,
    answer,
    points,
    timeLimit: Math.max(timeLimit, 15), // Minimum 15 secondes
    createdAt: new Date()
  };
}

// 5 opérations selon spécifications exactes
export const operations = [
  { 
    key: 'addition', 
    name: 'Addition', 
    symbol: '+', 
    emoji: '➕',
    description: 'Opérations de base et complexes progressives',
    color: 'text-blue-500'
  },
  { 
    key: 'subtraction', 
    name: 'Soustraction', 
    symbol: '-', 
    emoji: '➖',
    description: 'Calculs avec nombres positifs adaptés',
    color: 'text-red-500'
  },
  { 
    key: 'multiplication', 
    name: 'Multiplication', 
    symbol: '×', 
    emoji: '✖️',
    description: 'Tables de multiplication et calculs avancés',
    color: 'text-green-500'
  },
  { 
    key: 'division', 
    name: 'Division', 
    symbol: '÷', 
    emoji: '➗',
    description: 'Division euclidienne adaptée par niveau',
    color: 'text-purple-500'
  },
  { 
    key: 'mixed', 
    name: 'Mixte', 
    symbol: '🔀', 
    emoji: '🔀',
    description: 'Combinaison intelligente de toutes les opérations',
    color: 'text-orange-500'
  }
];

// Validation progression selon spécifications (100 bonnes réponses par niveau)
export const LEVEL_REQUIREMENTS = {
  1: { correctAnswers: 100, name: '🌱 Niveau 1 - Débutant', description: 'Addition/Soustraction simples (1-20)' },
  2: { correctAnswers: 100, name: '📚 Niveau 2 - Apprenti', description: 'Reconnaissance manuscrite + Multiplication (tables)' },
  3: { correctAnswers: 100, name: '🎯 Niveau 3 - Maîtrise', description: 'Assistant vocal IA + Division (nombres entiers)' },
  4: { correctAnswers: 100, name: '🏆 Niveau 4 - Excellence', description: 'Réalité augmentée 3D + Opérations mixtes' },
  5: { correctAnswers: 100, name: '👑 Niveau 5 - Légende', description: 'Toutes innovations + Défis ultimes avancés' }
};
