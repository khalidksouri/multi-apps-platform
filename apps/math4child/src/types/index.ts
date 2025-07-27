export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

export interface Level {
  id: string;
  name: string;
  icon: string;
  progress: number;
  isLocked: boolean;
  requiredAnswers: number;
  currentAnswers: number;
}

export interface MathOperation {
  id: string;
  name: string;
  icon: string;
  description: string;
  color: string;
}

export interface Exercise {
  id: string;
  type: string;
  level: string;
  question: {
    num1: number;
    num2: number;
    operator: string;
    correctAnswer: number;
  };
  userAnswer?: number;
  isCorrect?: boolean;
}

export interface User {
  id?: string;
  name?: string;
  email?: string;
  subscription: {
    type: 'free' | 'monthly' | 'quarterly' | 'yearly';
    questionsUsed: number;
    questionsLimit: number;
  };
  progress: {
    currentLevel: string;
    unlockedLevels: string[];
    totalCorrectAnswers: number;
  };
}
