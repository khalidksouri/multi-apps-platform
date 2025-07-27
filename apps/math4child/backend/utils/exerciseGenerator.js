class ExerciseGenerator {
  static LEVEL_CONFIG = {
    beginner: { minNum: 1, maxNum: 10, operations: ['+', '-'] },
    elementary: { minNum: 1, maxNum: 50, operations: ['+', '-', '*'] },
    intermediate: { minNum: 1, maxNum: 100, operations: ['+', '-', '*', '/'] },
    advanced: { minNum: 1, maxNum: 500, operations: ['+', '-', '*', '/'] },
    expert: { minNum: 1, maxNum: 1000, operations: ['+', '-', '*', '/'] }
  };

  static generateExercise(type, level) {
    const config = this.LEVEL_CONFIG[level];
    if (!config) throw new Error(`Niveau invalide: ${level}`);

    let num1, num2, operator, correctAnswer;

    switch (type) {
      case 'addition':
        operator = '+';
        num1 = this.randomInt(config.minNum, config.maxNum);
        num2 = this.randomInt(config.minNum, config.maxNum);
        correctAnswer = num1 + num2;
        break;
      case 'subtraction':
        operator = '-';
        num1 = this.randomInt(config.minNum, config.maxNum);
        num2 = this.randomInt(config.minNum, Math.min(num1, config.maxNum));
        correctAnswer = num1 - num2;
        break;
      case 'multiplication':
        operator = '*';
        num1 = this.randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = this.randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        correctAnswer = num1 * num2;
        break;
      case 'division':
        operator = '/';
        correctAnswer = this.randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = this.randomInt(2, 12);
        num1 = correctAnswer * num2;
        break;
      case 'mixed':
        const operations = config.operations;
        const randomOp = operations[Math.floor(Math.random() * operations.length)];
        return this.generateExercise(this.operatorToType(randomOp), level);
      default:
        throw new Error(`Type d'exercice invalide: ${type}`);
    }

    return {
      type, level,
      question: { num1, num2, operator, correctAnswer },
      difficulty: this.calculateDifficulty(num1, num2, operator),
      metadata: {
        estimatedTime: this.estimateTime(num1, num2, operator),
        hints: this.generateHints(num1, num2, operator),
        explanation: this.generateExplanation(num1, num2, operator, correctAnswer)
      }
    };
  }

  static generateSession(type, level, count = 10) {
    return Array.from({length: count}, () => this.generateExercise(type, level));
  }

  static randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  static operatorToType(operator) {
    const map = { '+': 'addition', '-': 'subtraction', '*': 'multiplication', '/': 'division' };
    return map[operator] || 'addition';
  }

  static calculateDifficulty(num1, num2, operator) {
    let base = Math.max(num1, num2);
    if (operator === '*' || operator === '/') base *= 2;
    return Math.min(Math.ceil(base / 100), 10);
  }

  static estimateTime(num1, num2, operator) {
    const baseTime = { '+': 5, '-': 8, '*': 12, '/': 15 };
    const complexity = Math.max(num1, num2) > 50 ? 1.5 : 1;
    return Math.ceil(baseTime[operator] * complexity);
  }

  static generateHints(num1, num2, operator) {
    const hints = [];
    switch (operator) {
      case '+': hints.push(`Commence par ${num1}, puis ajoute ${num2}`); break;
      case '-': hints.push(`Retire ${num2} de ${num1}`); break;
      case '*': hints.push(`${num1} groupes de ${num2} objets`); break;
      case '/': hints.push(`Partage ${num1} en groupes de ${num2}`); break;
    }
    return hints;
  }

  static generateExplanation(num1, num2, operator, answer) {
    const explanations = {
      '+': `${num1} + ${num2} = ${answer} car nous ajoutons ${num2} à ${num1}`,
      '-': `${num1} - ${num2} = ${answer} car nous retirons ${num2} de ${num1}`,
      '*': `${num1} × ${num2} = ${answer} car nous répétons ${num1} un total de ${num2} fois`,
      '/': `${num1} ÷ ${num2} = ${answer} car ${num1} contient ${answer} groupes de ${num2}`
    };
    return explanations[operator] || '';
  }
}

module.exports = ExerciseGenerator;
