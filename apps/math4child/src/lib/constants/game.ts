import type { MathLevel, MathOperation } from '@/types/game';

export const MATH_LEVELS: Record<MathLevel, { name: string; difficulty: number; range: [number, number] }> = {
  beginner: { name: 'Débutant', difficulty: 1, range: [1, 10] },
  elementary: { name: 'Élémentaire', difficulty: 2, range: [1, 50] },
  intermediate: { name: 'Intermédiaire', difficulty: 3, range: [1, 100] },
  advanced: { name: 'Avancé', difficulty: 4, range: [1, 500] },
  expert: { name: 'Expert', difficulty: 5, range: [1, 1000] }
};

export const MATH_OPERATIONS: Record<MathOperation, { symbol: string; name: string }> = {
  addition: { symbol: '+', name: 'Addition' },
  subtraction: { symbol: '-', name: 'Soustraction' },
  multiplication: { symbol: '×', name: 'Multiplication' },
  division: { symbol: '÷', name: 'Division' }
};

export const POINTS_PER_CORRECT = 10;
export const LIVES_COUNT = 3;
export const QUESTIONS_PER_SESSION = 10;
