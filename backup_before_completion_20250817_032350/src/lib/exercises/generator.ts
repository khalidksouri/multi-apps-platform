// =============================================================================
// 🧮 MOTEUR D'EXERCICES MATH4CHILD v4.2.0
// =============================================================================

export interface MathExercise {
  id: string;
  question: string;
  answer: number;
  operation: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';
  level: number;
  difficulty: number;
  hints: string[];
  visualAid?: string;
  timeLimit?: number;
  points: number;
}

export interface ExerciseConfig {
  level: number;
  operation: string;
  difficulty: number;
  count: number;
  format: 'multiple_choice' | 'input' | 'visual';
}

export class MathExerciseGenerator {
  
  static generateBatch(config: ExerciseConfig): MathExercise[] {
    const exercises: MathExercise[] = [];
    
    for (let i = 0; i < config.count; i++) {
      const exercise = this.generateSingle(config);
      exercises.push(exercise);
    }
    
    return exercises;
  }
  
  static generateSingle(config: ExerciseConfig): MathExercise {
    const { level, operation, difficulty } = config;
    
    // Adaptation selon le niveau (1-5)
    const ranges = this.getLevelRanges(level);
    
    switch (operation) {
      case 'addition':
        return this.generateAddition(ranges, difficulty);
      case 'subtraction':
        return this.generateSubtraction(ranges, difficulty);
      case 'multiplication':
        return this.generateMultiplication(ranges, difficulty);
      case 'division':
        return this.generateDivision(ranges, difficulty);
      case 'mixed':
        return this.generateMixed(ranges, difficulty);
      default:
        return this.generateAddition(ranges, difficulty);
    }
  }
  
  private static getLevelRanges(level: number) {
    const levelConfig = {
      1: { min: 1, max: 10, complex: false },
      2: { min: 1, max: 20, complex: false },
      3: { min: 1, max: 50, complex: true },
      4: { min: 1, max: 100, complex: true },
      5: { min: 1, max: 1000, complex: true }
    };
    
    return levelConfig[level] || levelConfig[1];
  }
  
  private static generateAddition(ranges: any, difficulty: number): MathExercise {
    const a = Math.floor(Math.random() * ranges.max) + ranges.min;
    const b = Math.floor(Math.random() * ranges.max) + ranges.min;
    const answer = a + b;
    
    return {
      id: `add_${Date.now()}_${Math.random()}`,
      question: `${a} + ${b} = ?`,
      answer,
      operation: 'addition',
      level: ranges.max <= 10 ? 1 : ranges.max <= 20 ? 2 : ranges.max <= 50 ? 3 : ranges.max <= 100 ? 4 : 5,
      difficulty,
      hints: [
        `Commence par compter ${a}`,
        `Puis ajoute ${b} de plus`,
        `Tu peux utiliser tes doigts pour t'aider`
      ],
      visualAid: `🟦`.repeat(a) + ` + ` + `🟩`.repeat(b),
      timeLimit: 30,
      points: difficulty * 10
    };
  }
  
  private static generateSubtraction(ranges: any, difficulty: number): MathExercise {
    const a = Math.floor(Math.random() * ranges.max) + ranges.min;
    const b = Math.floor(Math.random() * a) + 1; // b toujours plus petit que a
    const answer = a - b;
    
    return {
      id: `sub_${Date.now()}_${Math.random()}`,
      question: `${a} - ${b} = ?`,
      answer,
      operation: 'subtraction',
      level: ranges.max <= 10 ? 1 : ranges.max <= 20 ? 2 : ranges.max <= 50 ? 3 : ranges.max <= 100 ? 4 : 5,
      difficulty,
      hints: [
        `Commence avec ${a}`,
        `Enlève ${b}`,
        `Compte à rebours si nécessaire`
      ],
      visualAid: `🟦`.repeat(a) + ` - ` + `❌`.repeat(b),
      timeLimit: 45,
      points: difficulty * 15
    };
  }
  
  private static generateMultiplication(ranges: any, difficulty: number): MathExercise {
    const a = Math.floor(Math.random() * Math.min(ranges.max / 2, 12)) + 1;
    const b = Math.floor(Math.random() * Math.min(ranges.max / 2, 12)) + 1;
    const answer = a * b;
    
    return {
      id: `mul_${Date.now()}_${Math.random()}`,
      question: `${a} × ${b} = ?`,
      answer,
      operation: 'multiplication',
      level: ranges.max <= 10 ? 1 : ranges.max <= 20 ? 2 : ranges.max <= 50 ? 3 : ranges.max <= 100 ? 4 : 5,
      difficulty,
      hints: [
        `Pense aux tables de multiplication`,
        `${a} fois ${b}`,
        `Tu peux additionner ${a} + ${a} + ... (${b} fois)`
      ],
      visualAid: `[${`🟦 `.repeat(a)}] × ${b}`,
      timeLimit: 60,
      points: difficulty * 20
    };
  }
  
  private static generateDivision(ranges: any, difficulty: number): MathExercise {
    const b = Math.floor(Math.random() * 10) + 2; // Diviseur entre 2 et 11
    const quotient = Math.floor(Math.random() * 10) + 1;
    const a = b * quotient; // S'assurer que la division est exacte
    
    return {
      id: `div_${Date.now()}_${Math.random()}`,
      question: `${a} ÷ ${b} = ?`,
      answer: quotient,
      operation: 'division',
      level: ranges.max <= 10 ? 1 : ranges.max <= 20 ? 2 : ranges.max <= 50 ? 3 : ranges.max <= 100 ? 4 : 5,
      difficulty,
      hints: [
        `Combien de fois ${b} rentre dans ${a} ?`,
        `Pense aux tables de multiplication`,
        `${b} × ? = ${a}`
      ],
      visualAid: `${a} ÷ ${b} = ${quotient}`,
      timeLimit: 90,
      points: difficulty * 25
    };
  }
  
  private static generateMixed(ranges: any, difficulty: number): MathExercise {
    const operations = ['addition', 'subtraction', 'multiplication', 'division'];
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    
    const config = { level: ranges.max <= 10 ? 1 : 5, operation: randomOp, difficulty, count: 1, format: 'input' as const };
    return this.generateSingle(config);
  }
}

// =============================================================================
// 🤖 IA ADAPTATIVE MATH4CHILD
// =============================================================================

export interface StudentProfile {
  id: string;
  name: string;
  age: number;
  currentLevel: number;
  strengths: string[];
  weaknesses: string[];
  learningStyle: 'visual' | 'auditory' | 'kinesthetic' | 'mixed';
  averageTime: number;
  accuracy: number;
  streak: number;
}

export class AdaptiveAI {
  
  static adaptDifficulty(profile: StudentProfile, recentPerformance: any[]): number {
    let baseDifficulty = profile.currentLevel;
    
    // Analyser les performances récentes
    const recentAccuracy = recentPerformance.length > 0 
      ? recentPerformance.reduce((sum, p) => sum + (p.correct ? 1 : 0), 0) / recentPerformance.length
      : 0.5;
    
    const avgTime = recentPerformance.length > 0
      ? recentPerformance.reduce((sum, p) => sum + p.timeSpent, 0) / recentPerformance.length
      : 30;
    
    // Adaptation basée sur la précision
    if (recentAccuracy > 0.9) {
      baseDifficulty += 0.5; // Augmenter la difficulté
    } else if (recentAccuracy < 0.6) {
      baseDifficulty -= 0.3; // Diminuer la difficulté
    }
    
    // Adaptation basée sur le temps
    if (avgTime < profile.averageTime * 0.7) {
      baseDifficulty += 0.2; // Trop rapide, augmenter
    } else if (avgTime > profile.averageTime * 1.5) {
      baseDifficulty -= 0.2; // Trop lent, diminuer
    }
    
    return Math.max(1, Math.min(5, baseDifficulty));
  }
  
  static generatePersonalizedExercise(profile: StudentProfile, recentPerformance: any[]): MathExercise {
    const adaptedDifficulty = this.adaptDifficulty(profile, recentPerformance);
    
    // Choisir l'opération basée sur les faiblesses
    let operation = 'mixed';
    if (profile.weaknesses.includes('addition')) operation = 'addition';
    else if (profile.weaknesses.includes('multiplication')) operation = 'multiplication';
    
    const config: ExerciseConfig = {
      level: profile.currentLevel,
      operation,
      difficulty: adaptedDifficulty,
      count: 1,
      format: profile.learningStyle === 'visual' ? 'visual' : 'input'
    };
    
    return MathExerciseGenerator.generateSingle(config);
  }
  
  static analyzeProgress(profile: StudentProfile, exercises: any[]): {
    recommendation: string;
    nextLevel: boolean;
    focusAreas: string[];
  } {
    const accuracy = exercises.reduce((sum, ex) => sum + (ex.correct ? 1 : 0), 0) / exercises.length;
    const avgTime = exercises.reduce((sum, ex) => sum + ex.timeSpent, 0) / exercises.length;
    
    let recommendation = '';
    let nextLevel = false;
    const focusAreas: string[] = [];
    
    if (accuracy >= 0.85 && avgTime <= profile.averageTime) {
      recommendation = '🎉 Excellent ! Tu es prêt pour le niveau suivant !';
      nextLevel = true;
    } else if (accuracy >= 0.7) {
      recommendation = '👍 Bon travail ! Continue à t\'entraîner.';
    } else {
      recommendation = '💪 N\'abandonne pas ! Concentre-toi sur tes points faibles.';
      
      // Identifier les domaines à améliorer
      const operationStats = exercises.reduce((stats, ex) => {
        stats[ex.operation] = stats[ex.operation] || { correct: 0, total: 0 };
        stats[ex.operation].total++;
        if (ex.correct) stats[ex.operation].correct++;
        return stats;
      }, {});
      
      Object.entries(operationStats).forEach(([op, stats]: [string, any]) => {
        if (stats.correct / stats.total < 0.6) {
          focusAreas.push(op);
        }
      });
    }
    
    return { recommendation, nextLevel, focusAreas };
  }
}
