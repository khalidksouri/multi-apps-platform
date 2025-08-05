// Générateur de questions mathématiques par niveau
export interface MathQuestion {
  id: string
  level: number
  operation: "addition" | "subtraction" | "multiplication" | "division" | "mixed"
  question: string
  correctAnswer: number
  options: number[]
  difficulty: "easy" | "medium" | "hard"
  points: number
}

export interface LevelConfig {
  level: number
  name: string
  requiredCorrectAnswers: number
  operations: string[]
  numberRange: { min: number; max: number }
  hasNegatives: boolean
  hasDecimals: boolean
}

export const LEVEL_CONFIGS: LevelConfig[] = [
  {
    level: 1,
    name: "Débutant",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction"],
    numberRange: { min: 1, max: 10 },
    hasNegatives: false,
    hasDecimals: false
  },
  {
    level: 2,
    name: "Élémentaire",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction", "multiplication"],
    numberRange: { min: 1, max: 50 },
    hasNegatives: false,
    hasDecimals: false
  }
]

export class MathQuestionGenerator {
  generateQuestion(level: number, operation?: string): MathQuestion {
    const config = LEVEL_CONFIGS.find(c => c.level === level)
    if (!config) throw new Error(`Invalid level: ${level}`)

    const a = Math.floor(Math.random() * config.numberRange.max) + config.numberRange.min
    const b = Math.floor(Math.random() * config.numberRange.max) + config.numberRange.min
    const correctAnswer = a + b

    return {
      id: `add_${Date.now()}_${Math.random()}`,
      level: config.level,
      operation: "addition",
      question: `${a} + ${b} = ?`,
      correctAnswer,
      options: [correctAnswer, correctAnswer + 1, correctAnswer - 1, correctAnswer + 2].sort(() => Math.random() - 0.5),
      difficulty: "easy",
      points: config.level * 10
    }
  }
}

export const mathGenerator = new MathQuestionGenerator()
