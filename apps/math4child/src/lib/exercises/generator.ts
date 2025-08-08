// ===================================================================
// GÉNÉRATEUR D'EXERCICES MATH4CHILD
// Génération intelligente selon niveau et opération
// ===================================================================

import { Level, Operation } from './levels';

export interface Exercise {
  id: string;
  level: number;
  operation: string;
  question: {
    num1: number;
    num2: number;
    operator: string;
    display: string;
  };
  correctAnswer: number;
  possibleAnswers: number[];
  difficulty: number;
  estimatedTime: number;
  hint?: string;
}

export class ExerciseGenerator {
  static generateExercise(level: Level, operation: Operation): Exercise {
    const [min, max] = level.numberRange;
    
    switch (operation.id) {
      case 'addition':
        return this.generateAddition(level, min, max);
      case 'subtraction':
        return this.generateSubtraction(level, min, max);
      case 'multiplication':
        return this.generateMultiplication(level, min, max);
      case 'division':
        return this.generateDivision(level, min, max);
      case 'mixed':
        return this.generateMixed(level, min, max);
      default:
        return this.generateAddition(level, min, max);
    }
  }
  
  private static generateAddition(level: Level, min: number, max: number): Exercise {
    const num1 = this.randomBetween(min, Math.floor(max * 0.7));
    const num2 = this.randomBetween(min, max - num1);
    const correctAnswer = num1 + num2;
    
    return {
      id: this.generateId(),
      level: level.id,
      operation: 'addition',
      question: {
        num1,
        num2,
        operator: '+',
        display: `${num1} + ${num2} = ?`
      },
      correctAnswer,
      possibleAnswers: this.generateChoices(correctAnswer),
      difficulty: this.calculateDifficulty(num1, num2, 'addition'),
      estimatedTime: 30,
      hint: `Additionne ${num1} et ${num2}`
    };
  }
  
  private static generateSubtraction(level: Level, min: number, max: number): Exercise {
    const num1 = this.randomBetween(Math.floor(max * 0.3), max);
    const num2 = this.randomBetween(min, num1);
    const correctAnswer = num1 - num2;
    
    return {
      id: this.generateId(),
      level: level.id,
      operation: 'subtraction',
      question: {
        num1,
        num2,
        operator: '−',
        display: `${num1} − ${num2} = ?`
      },
      correctAnswer,
      possibleAnswers: this.generateChoices(correctAnswer),
      difficulty: this.calculateDifficulty(num1, num2, 'subtraction'),
      estimatedTime: 35,
      hint: `Retire ${num2} de ${num1}`
    };
  }
  
  private static generateMultiplication(level: Level, min: number, max: number): Exercise {
    const maxFactor = level.id <= 2 ? 5 : level.id <= 3 ? 10 : 12;
    const num1 = this.randomBetween(min, Math.min(maxFactor, max));
    const num2 = this.randomBetween(min, Math.min(maxFactor, max));
    const correctAnswer = num1 * num2;
    
    return {
      id: this.generateId(),
      level: level.id,
      operation: 'multiplication',
      question: {
        num1,
        num2,
        operator: '×',
        display: `${num1} × ${num2} = ?`
      },
      correctAnswer,
      possibleAnswers: this.generateChoices(correctAnswer),
      difficulty: this.calculateDifficulty(num1, num2, 'multiplication'),
      estimatedTime: 45,
      hint: `${num1} fois ${num2}`
    };
  }
  
  private static generateDivision(level: Level, min: number, max: number): Exercise {
    const quotient = this.randomBetween(min, Math.min(12, max));
    const divisor = this.randomBetween(2, Math.min(10, max));
    const num1 = quotient * divisor;
    
    return {
      id: this.generateId(),
      level: level.id,
      operation: 'division',
      question: {
        num1,
        num2: divisor,
        operator: '÷',
        display: `${num1} ÷ ${divisor} = ?`
      },
      correctAnswer: quotient,
      possibleAnswers: this.generateChoices(quotient),
      difficulty: this.calculateDifficulty(num1, divisor, 'division'),
      estimatedTime: 50,
      hint: `Combien de fois ${divisor} rentre dans ${num1} ?`
    };
  }
  
  private static generateMixed(level: Level, min: number, max: number): Exercise {
    const operations = ['addition', 'subtraction', 'multiplication', 'division'];
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    const operation = { id: randomOp, name: randomOp } as Operation;
    
    return this.generateExercise(level, operation);
  }
  
  private static randomBetween(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
  
  private static generateChoices(correctAnswer: number): number[] {
    const choices = [correctAnswer];
    
    while (choices.length < 4) {
      const variation = Math.floor(Math.random() * 10) - 5;
      const wrongAnswer = Math.max(0, correctAnswer + variation);
      
      if (!choices.includes(wrongAnswer)) {
        choices.push(wrongAnswer);
      }
    }
    
    return this.shuffleArray(choices);
  }
  
  private static shuffleArray<T>(array: T[]): T[] {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
  }
  
  private static calculateDifficulty(num1: number, num2: number, operation: string): number {
    let difficulty = 1;
    
    if (operation === 'multiplication' || operation === 'division') {
      difficulty += 1;
    }
    
    if (Math.max(num1, num2) > 50) {
      difficulty += 1;
    }
    
    if (Math.max(num1, num2) > 100) {
      difficulty += 1;
    }
    
    return Math.min(difficulty, 5);
  }
  
  private static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}
