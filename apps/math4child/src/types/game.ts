export type MathLevel = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';
export type MathOperation = 'addition' | 'subtraction' | 'multiplication' | 'division';

export interface MathQuestion {
  id: string;
  question: string;
  answer: number;
  operation: MathOperation;
  level: MathLevel;
  difficulty: number;
}

export interface GameState {
  score: number;
  lives: number;
  streak: number;
  currentQuestion: MathQuestion | null;
  questionsAnswered: number;
}

export interface UserProgress {
  currentLevel: MathLevel;
  unlockedLevels: MathLevel[];
  totalCorrect: number;
  totalQuestions: number;
  accuracy: number;
}
