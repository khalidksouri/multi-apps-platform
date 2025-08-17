import { Exercise } from '@/types'

export const generateExercise = (type: Exercise['type'], level: number): Exercise => {
  const baseId = `${type}_${level}_${Date.now()}`
  
  switch (type) {
    case 'addition':
      return generateAddition(baseId, level)
    case 'subtraction':
      return generateSubtraction(baseId, level)
    case 'multiplication':
      return generateMultiplication(baseId, level)
    case 'division':
      return generateDivision(baseId, level)
    case 'mixed':
      return generateMixed(baseId, level)
    default:
      return generateAddition(baseId, level)
  }
}

const generateAddition = (id: string, level: number): Exercise => {
  const max = Math.min(10 * level, 100)
  const a = Math.floor(Math.random() * max) + 1
  const b = Math.floor(Math.random() * max) + 1
  
  return {
    id,
    type: 'addition',
    level,
    question: `${a} + ${b} = ?`,
    correctAnswer: a + b,
    options: generateOptions(a + b),
    difficulty: level <= 2 ? 'easy' : level <= 4 ? 'medium' : 'hard',
    timeLimit: 30000 + (level * 10000)
  }
}

const generateSubtraction = (id: string, level: number): Exercise => {
  const max = Math.min(10 * level, 100)
  const a = Math.floor(Math.random() * max) + 10
  const b = Math.floor(Math.random() * (a - 1)) + 1
  
  return {
    id,
    type: 'subtraction',
    level,
    question: `${a} - ${b} = ?`,
    correctAnswer: a - b,
    options: generateOptions(a - b),
    difficulty: level <= 2 ? 'easy' : level <= 4 ? 'medium' : 'hard',
    timeLimit: 30000 + (level * 10000)
  }
}

const generateMultiplication = (id: string, level: number): Exercise => {
  const max = Math.min(level + 2, 12)
  const a = Math.floor(Math.random() * max) + 1
  const b = Math.floor(Math.random() * max) + 1
  
  return {
    id,
    type: 'multiplication',
    level,
    question: `${a} × ${b} = ?`,
    correctAnswer: a * b,
    options: generateOptions(a * b),
    difficulty: level <= 2 ? 'easy' : level <= 4 ? 'medium' : 'hard',
    timeLimit: 45000 + (level * 10000)
  }
}

const generateDivision = (id: string, level: number): Exercise => {
  const max = Math.min(level + 2, 12)
  const b = Math.floor(Math.random() * max) + 1
  const result = Math.floor(Math.random() * max) + 1
  const a = b * result
  
  return {
    id,
    type: 'division',
    level,
    question: `${a} ÷ ${b} = ?`,
    correctAnswer: result,
    options: generateOptions(result),
    difficulty: level <= 2 ? 'easy' : level <= 4 ? 'medium' : 'hard',
    timeLimit: 60000 + (level * 10000)
  }
}

const generateMixed = (id: string, level: number): Exercise => {
  const types: Exercise['type'][] = ['addition', 'subtraction', 'multiplication', 'division']
  const randomType = types[Math.floor(Math.random() * types.length)]
  return generateExercise(randomType, level)
}

const generateOptions = (correct: number): number[] => {
  const options = [correct]
  
  while (options.length < 4) {
    const option = correct + Math.floor(Math.random() * 20) - 10
    if (option > 0 && !options.includes(option)) {
      options.push(option)
    }
  }
  
  return options.sort(() => Math.random() - 0.5)
}
