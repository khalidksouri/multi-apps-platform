// ===================================================================
// 🧮 GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES
// Génère des questions adaptées à chaque niveau et opération
// ===================================================================

import { Level, OperationType, MATH_LEVELS } from './levels';

export interface MathQuestion {
  id: string;
  level: string;
  operation: OperationType;
  question: string;
  answer: number;
  operands: number[];
  hint?: string;
  difficulty: number;
  timeLimit?: number;
}

export class QuestionGenerator {
  private static questionId = 0;

  static generateQuestion(levelId: string, operation: OperationType): MathQuestion {
    const level = MATH_LEVELS.find(l => l.id === levelId);
    if (!level) throw new Error(`Niveau ${levelId} non trouvé`);

    this.questionId++;
    const { min, max } = level.numberRange;

    switch (operation) {
      case 'addition':
        return this.generateAddition(level, this.questionId.toString());
      case 'subtraction':
        return this.generateSubtraction(level, this.questionId.toString());
      case 'multiplication':
        return this.generateMultiplication(level, this.questionId.toString());
      case 'division':
        return this.generateDivision(level, this.questionId.toString());
      case 'mixed':
        return this.generateMixed(level, this.questionId.toString());
      default:
        throw new Error(`Opération ${operation} non supportée`);
    }
  }

  private static generateAddition(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    const a = this.randomInt(min, max);
    const b = this.randomInt(min, max);
    
    return {
      id,
      level: level.id,
      operation: 'addition',
      question: `${a} + ${b} = ?`,
      answer: a + b,
      operands: [a, b],
      hint: `Compte ${a} objets, puis ajoute ${b} de plus`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty)
    };
  }

  private static generateSubtraction(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    let a = this.randomInt(min, max);
    let b = this.randomInt(min, a); // b <= a pour éviter les résultats négatifs
    
    // S'assurer que a >= b
    if (a < b) [a, b] = [b, a];
    
    return {
      id,
      level: level.id,
      operation: 'subtraction',
      question: `${a} - ${b} = ?`,
      answer: a - b,
      operands: [a, b],
      hint: `Tu as ${a} objets, enlève-en ${b}`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty)
    };
  }

  private static generateMultiplication(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    
    // Adapter les nombres pour la multiplication selon le niveau
    let maxFactor = level.difficulty <= 2 ? 10 : level.difficulty <= 3 ? 12 : 15;
    maxFactor = Math.min(maxFactor, Math.sqrt(max));
    
    const a = this.randomInt(min, Math.floor(maxFactor));
    const b = this.randomInt(min, Math.floor(maxFactor));
    
    return {
      id,
      level: level.id,
      operation: 'multiplication',
      question: `${a} × ${b} = ?`,
      answer: a * b,
      operands: [a, b],
      hint: `${a} groupes de ${b} objets chacun`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty, 'multiplication')
    };
  }

  private static generateDivision(level: Level, id: string): MathQuestion {
    const { min, max } = level.numberRange;
    
    // Générer d'abord le quotient et le diviseur
    let maxDivisor = level.difficulty <= 2 ? 10 : level.difficulty <= 3 ? 12 : 15;
    maxDivisor = Math.min(maxDivisor, Math.sqrt(max));
    
    const quotient = this.randomInt(min, Math.floor(max / maxDivisor));
    const divisor = this.randomInt(Math.max(2, min), maxDivisor);
    const dividend = quotient * divisor;
    
    return {
      id,
      level: level.id,
      operation: 'division',
      question: `${dividend} ÷ ${divisor} = ?`,
      answer: quotient,
      operands: [dividend, divisor],
      hint: `Combien de groupes de ${divisor} dans ${dividend} ?`,
      difficulty: level.difficulty,
      timeLimit: this.getTimeLimit(level.difficulty, 'division')
    };
  }

  private static generateMixed(level: Level, id: string): MathQuestion {
    const operations: OperationType[] = ['addition', 'subtraction', 'multiplication', 'division'];
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    return this.generateQuestion(level.id, randomOp);
  }

  private static randomInt(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  private static getTimeLimit(difficulty: number, operation?: OperationType): number {
    const baseTime = {
      addition: 30,
      subtraction: 35,
      multiplication: 45,
      division: 50
    };
    
    const opTime = operation ? baseTime[operation] || 30 : 30;
    return Math.max(15, opTime - (difficulty * 5)); // Plus difficile = moins de temps
  }

  // Générer une série de questions pour une session
  static generateQuestionSeries(
    levelId: string, 
    operation: OperationType, 
    count: number = 10
  ): MathQuestion[] {
    const questions: MathQuestion[] = [];
    
    for (let i = 0; i < count; i++) {
      questions.push(this.generateQuestion(levelId, operation));
    }
    
    return questions;
  }

  // Générer des questions de révision pour les niveaux déjà validés
  static generateReviewQuestions(
    completedLevels: string[], 
    count: number = 20
  ): MathQuestion[] {
    const questions: MathQuestion[] = [];
    
    completedLevels.forEach(levelId => {
      const level = MATH_LEVELS.find(l => l.id === levelId);
      if (level) {
        level.operations.forEach(operation => {
          const questionsForOp = Math.ceil(count / (completedLevels.length * level.operations.length));
          for (let i = 0; i < questionsForOp; i++) {
            questions.push(this.generateQuestion(levelId, operation));
          }
        });
      }
    });
    
    return questions.slice(0, count); // Limiter au nombre demandé
  }
}
