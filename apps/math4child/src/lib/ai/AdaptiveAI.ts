// IA Adaptative Math4Child v4.2.0 - Innovation #1
export class AdaptiveAI {
  private userPerformance: Map<string, number[]> = new Map();
  
  analyzePerformance(userId: string, exerciseResult: {
    correct: boolean;
    timeMs: number;
    difficulty: string;
    operation: string;
  }): {
    suggestedDifficulty: 'easy' | 'medium' | 'hard';
    suggestedOperation: string;
    encouragement: string;
    adaptations: string[];
  } {
    // Récupérer historique performances
    const history = this.userPerformance.get(userId) || [];
    
    // Analyser pattern de réussite
    const recentResults = history.slice(-10);
    const successRate = recentResults.filter(r => r > 0).length / recentResults.length;
    
    // Adaptation intelligente
    let suggestedDifficulty: 'easy' | 'medium' | 'hard' = 'medium';
    let suggestedOperation = exerciseResult.operation;
    let encouragement = '';
    const adaptations: string[] = [];
    
    if (successRate > 0.8) {
      suggestedDifficulty = 'hard';
      encouragement = '🌟 Excellent ! Tu progresses rapidement !';
      adaptations.push('Augmentation difficulté', 'Nouveaux défis');
    } else if (successRate < 0.4) {
      suggestedDifficulty = 'easy';
      encouragement = '💪 Continue ! Tu vas y arriver !';
      adaptations.push('Simplification exercices', 'Support renforcé');
    } else {
      encouragement = '👍 Très bien ! Continue comme ça !';
      adaptations.push('Maintien niveau', 'Variété exercices');
    }
    
    // Temps de réponse analysis
    if (exerciseResult.timeMs > 30000) {
      adaptations.push('Plus de temps accordé');
    } else if (exerciseResult.timeMs < 5000) {
      adaptations.push('Exercices plus complexes');
    }
    
    return {
      suggestedDifficulty,
      suggestedOperation,
      encouragement,
      adaptations
    };
  }
}
