// =============================================================================
// 🧮 GÉNÉRATEUR EXERCICES MATH4CHILD v4.2.0 - 5 OPÉRATIONS
// =============================================================================

import { OperationType } from '@/lib/progression/levels'

export interface MathExercise {
  id: string;
  type: OperationType;
  level: number;
  question: string;
  answer: number;
  options?: number[]; // Pour QCM
  difficulty: number;
  operands: number[];
  operator: string;
  aiGenerated: boolean;
  estimatedTime: number; // en secondes
}

export interface GeneratorConfig {
  level: number;
  operation: OperationType;
  difficulty: number;
  count: number;
  format: 'text' | 'mcq' | 'input';
}

// GÉNÉRATEUR SELON NIVEAUX ET SPÉCIFICATIONS
export class MathExerciseGenerator {
  
  static generateExercise(config: GeneratorConfig): MathExercise {
    const { level, operation, difficulty } = config;
    
    switch (operation) {
      case 'addition':
        return this.generateAddition(level, difficulty);
      case 'subtraction':
        return this.generateSubtraction(level, difficulty);
      case 'multiplication':
        return this.generateMultiplication(level, difficulty);
      case 'division':
        return this.generateDivision(level, difficulty);
      case 'mixed':
        return this.generateMixed(level, difficulty);
      default:
        throw new Error(`Opération non supportée: ${operation}`);
    }
  }

  static generateBatch(config: GeneratorConfig): MathExercise[] {
    const exercises: MathExercise[] = [];
    
    for (let i = 0; i < config.count; i++) {
      exercises.push(this.generateExercise(config));
    }
    
    return exercises;
  }

  private static generateAddition(level: number, difficulty: number): MathExercise {
    const range = this.getRangeForLevel(level);
    const operand1 = this.randomInRange(1, range.max);
    const operand2 = this.randomInRange(1, range.max);
    const answer = operand1 + operand2;
    
    return {
      id: this.generateId(),
      type: 'addition',
      level,
      question: `${operand1} + ${operand2} = ?`,
      answer,
      difficulty,
      operands: [operand1, operand2],
      operator: '+',
      aiGenerated: true,
      estimatedTime: this.calculateEstimatedTime(level, 'addition')
    };
  }

  private static generateSubtraction(level: number, difficulty: number): MathExercise {
    const range = this.getRangeForLevel(level);
    const operand1 = this.randomInRange(range.max / 2, range.max);
    const operand2 = this.randomInRange(1, operand1); // Éviter les résultats négatifs
    const answer = operand1 - operand2;
    
    return {
      id: this.generateId(),
      type: 'subtraction',
      level,
      question: `${operand1} - ${operand2} = ?`,
      answer,
      difficulty,
      operands: [operand1, operand2],
      operator: '-',
      aiGenerated: true,
      estimatedTime: this.calculateEstimatedTime(level, 'subtraction')
    };
  }

  private static generateMultiplication(level: number, difficulty: number): MathExercise {
    const range = this.getRangeForLevel(level);
    const operand1 = this.randomInRange(1, Math.min(12, range.max)); // Tables jusqu'à 12
    const operand2 = this.randomInRange(1, Math.min(12, range.max));
    const answer = operand1 * operand2;
    
    return {
      id: this.generateId(),
      type: 'multiplication',
      level,
      question: `${operand1} × ${operand2} = ?`,
      answer,
      difficulty,
      operands: [operand1, operand2],
      operator: '×',
      aiGenerated: true,
      estimatedTime: this.calculateEstimatedTime(level, 'multiplication')
    };
  }

  private static generateDivision(level: number, difficulty: number): MathExercise {
    const range = this.getRangeForLevel(level);
    const divisor = this.randomInRange(2, Math.min(12, range.max));
    const quotient = this.randomInRange(1, Math.min(20, range.max));
    const dividend = divisor * quotient; // Assurer division exacte
    
    return {
      id: this.generateId(),
      type: 'division',
      level,
      question: `${dividend} ÷ ${divisor} = ?`,
      answer: quotient,
      difficulty,
      operands: [dividend, divisor],
      operator: '÷',
      aiGenerated: true,
      estimatedTime: this.calculateEstimatedTime(level, 'division')
    };
  }

  private static generateMixed(level: number, difficulty: number): MathExercise {
    const operations: OperationType[] = ['addition', 'subtraction', 'multiplication', 'division'];
    const randomOperation = operations[Math.floor(Math.random() * operations.length)];
    
    // Générer selon l'opération choisie aléatoirement
    const exercise = this.generateExercise({
      level,
      operation: randomOperation,
      difficulty,
      count: 1,
      format: 'input'
    });
    
    exercise.type = 'mixed';
    return exercise;
  }

  private static getRangeForLevel(level: number): { min: number; max: number } {
    switch (level) {
      case 1: return { min: 1, max: 10 };
      case 2: return { min: 1, max: 50 };
      case 3: return { min: 1, max: 100 };
      case 4: return { min: 1, max: 500 };
      case 5: return { min: 1, max: 1000 };
      default: return { min: 1, max: 10 };
    }
  }

  private static randomInRange(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  private static generateId(): string {
    return 'ex_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }

  private static calculateEstimatedTime(level: number, operation: OperationType): number {
    // Temps estimé en secondes selon niveau et opération
    const baseTime = {
      'addition': 15,
      'subtraction': 20,
      'multiplication': 25,
      'division': 30,
      'mixed': 35
    };
    
    const levelMultiplier = 1 + (level - 1) * 0.2; // Plus difficile = plus de temps
    return Math.round(baseTime[operation] * levelMultiplier);
  }
}

// Utilitaires d'export
export function generateLevelExercises(level: number, count: number = 20): MathExercise[] {
  const operations = ['addition', 'subtraction', 'multiplication', 'division', 'mixed'] as OperationType[];
  const exercises: MathExercise[] = [];
  
  // Distribuer les exercices sur toutes les opérations
  const exercisesPerOperation = Math.ceil(count / operations.length);
  
  operations.forEach(operation => {
    const config: GeneratorConfig = {
      level,
      operation,
      difficulty: level,
      count: exercisesPerOperation,
      format: 'input'
    };
    
    exercises.push(...MathExerciseGenerator.generateBatch(config));
  });
  
  // Mélanger et limiter au nombre demandé
  return exercises.sort(() => Math.random() - 0.5).slice(0, count);
}
