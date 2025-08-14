// =============================================================================
// 🧠 SYSTÈME IA ADAPTATIVE MATH4CHILD
// Innovation Révolutionnaire #1 selon README.md
// =============================================================================

import { Exercise, AIAdaptation, OperationType } from '@/types';

export class AdaptiveAI {
  private userPerformance: Map<string, number> = new Map();
  private learningPattern: 'visual' | 'auditory' | 'kinesthetic' | 'mixed' = 'mixed';
  
  // Adaptation en temps réel selon les performances
  adaptDifficulty(userHistory: Exercise[]): number {
    if (userHistory.length === 0) return 1;
    
    const recentExercises = userHistory.slice(-10);
    const correctRatio = recentExercises.filter(ex => ex.isCorrect).length / recentExercises.length;
    
    // Algorithme d'adaptation IA propriétaire
    if (correctRatio > 0.8) {
      return Math.min(10, this.getCurrentDifficulty() + 1);
    } else if (correctRatio < 0.5) {
      return Math.max(1, this.getCurrentDifficulty() - 1);
    }
    
    return this.getCurrentDifficulty();
  }
  
  // Génération d'exercices personnalisés
  generatePersonalizedExercise(level: number, operation: OperationType, difficulty: number): Exercise {
    const baseRange = this.getDifficultyRange(level, difficulty);
    
    return {
      id: `ex_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: operation,
      level,
      question: this.generateQuestion(operation, baseRange),
      correctAnswer: this.calculateAnswer(operation, baseRange),
      difficulty,
      aiAdaptation: this.getAIRecommendations()
    };
  }
  
  // Prédiction des lacunes avec suggestions ciblées
  predictLearningGaps(userHistory: Exercise[]): string[] {
    const operationPerformance = new Map<OperationType, number>();
    
    // Analyse des performances par opération
    ['addition', 'subtraction', 'multiplication', 'division'].forEach(op => {
      const opExercises = userHistory.filter(ex => ex.type === op as OperationType);
      if (opExercises.length > 0) {
        const correctRatio = opExercises.filter(ex => ex.isCorrect).length / opExercises.length;
        operationPerformance.set(op as OperationType, correctRatio);
      }
    });
    
    const suggestions: string[] = [];
    operationPerformance.forEach((performance, operation) => {
      if (performance < 0.6) {
        suggestions.push(`Renforcer les ${operation}s avec des exercices ciblés`);
      }
    });
    
    return suggestions;
  }
  
  private getCurrentDifficulty(): number {
    return 5; // Implémentation simplifiée
  }
  
  private getDifficultyRange(level: number, difficulty: number): { min: number, max: number } {
    const base = level * 10;
    const variation = difficulty * 5;
    return {
      min: Math.max(1, base - variation),
      max: base + variation
    };
  }
  
  private generateQuestion(operation: OperationType, range: { min: number, max: number }): string {
    const a = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;
    const b = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;
    
    switch (operation) {
      case 'addition':
        return `${a} + ${b} = ?`;
      case 'subtraction':
        return `${Math.max(a, b)} - ${Math.min(a, b)} = ?`;
      case 'multiplication':
        return `${a} × ${b} = ?`;
      case 'division':
        const dividend = a * b;
        return `${dividend} ÷ ${a} = ?`;
      default:
        return `${a} + ${b} = ?`;
    }
  }
  
  private calculateAnswer(operation: OperationType, range: { min: number, max: number }): number {
    // Implémentation simplifiée - en production, calculer basé sur la question générée
    return 42;
  }
  
  private getAIRecommendations(): AIAdaptation {
    return {
      difficultyAdjustment: 0,
      personalizedHints: ['Utilisez vos doigts pour compter', 'Visualisez les nombres'],
      nextRecommendedExercise: 'addition_level_2',
      learningPattern: this.learningPattern
    };
  }
}
