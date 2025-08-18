// =============================================================================
// 🧮 GÉNÉRATEUR D'EXERCICES MATH4CHILD v4.2.0 - CORRIGÉ
// =============================================================================

import { Exercise } from '@/types'

// ✅ CORRIGÉ: Fonction avec type Exercise['type'] défini
export const generateExercise = (type: 'addition' | 'subtraction' | 'multiplication' | 'division', level: number): Exercise => {
  const operations = {
    addition: () => {
      const a = Math.floor(Math.random() * (level * 10)) + 1
      const b = Math.floor(Math.random() * (level * 10)) + 1
      return {
        question: `${a} + ${b}`,
        answer: a + b,
        operation: 'addition'
      }
    },
    subtraction: () => {
      const a = Math.floor(Math.random() * (level * 10)) + level * 5
      const b = Math.floor(Math.random() * a) + 1
      return {
        question: `${a} - ${b}`,
        answer: a - b,
        operation: 'subtraction'
      }
    },
    multiplication: () => {
      const a = Math.floor(Math.random() * level) + 1
      const b = Math.floor(Math.random() * 10) + 1
      return {
        question: `${a} × ${b}`,
        answer: a * b,
        operation: 'multiplication'
      }
    },
    division: () => {
      const b = Math.floor(Math.random() * 9) + 1
      const answer = Math.floor(Math.random() * level) + 1
      const a = b * answer
      return {
        question: `${a} ÷ ${b}`,
        answer: answer,
        operation: 'division'
      }
    }
  }

  const operation = operations[type]()
  
  // ✅ CORRIGÉ: difficulty comme string enum selon le type Exercise
  const getDifficulty = (level: number): 'easy' | 'medium' | 'hard' => {
    if (level <= 2) return 'easy'
    if (level <= 4) return 'medium'
    return 'hard'
  }

  return {
    id: `${type}_${level}_${Date.now()}_${Math.random()}`,
    type: type,  // ✅ AJOUTÉ: Propriété 'type' manquante
    question: operation.question,
    answer: operation.answer,
    level: level,
    operation: operation.operation,
    difficulty: getDifficulty(level),  // ✅ CORRIGÉ: string au lieu de number
    format: 'input' as const,
    hints: [`Réfléchis étape par étape`, `Tu peux utiliser tes doigts pour compter`],
    explanation: `Pour résoudre ${operation.question}, ${getExplanation(type, operation)}`
  }
}

// Fonction d'explication pour chaque type d'opération
const getExplanation = (type: string, operation: any): string => {
  switch (type) {
    case 'addition':
      return `tu additionnes les deux nombres ensemble.`
    case 'subtraction': 
      return `tu enlèves le deuxième nombre du premier.`
    case 'multiplication':
      return `tu multiplies les deux nombres.`
    case 'division':
      return `tu divises le premier nombre par le deuxième.`
    default:
      return `tu appliques l'opération mathématique.`
  }
}

// ✅ CORRIGÉ: Types d'exercices disponibles bien définis
export const getAvailableExerciseTypes = (): Array<'addition' | 'subtraction' | 'multiplication' | 'division'> => {
  return ['addition', 'subtraction', 'multiplication', 'division']
}

// Génération d'exercices multiples
export const generateExercises = (type: 'addition' | 'subtraction' | 'multiplication' | 'division', level: number, count: number = 1): Exercise[] => {
  const exercises: Exercise[] = []
  for (let i = 0; i < count; i++) {
    exercises.push(generateExercise(type, level))
  }
  return exercises
}

// Validation d'une réponse
export const validateAnswer = (exercise: Exercise, userAnswer: number): boolean => {
  return exercise.answer === userAnswer
}

// Export par défaut
export default {
  generateExercise,
  generateExercises,
  validateAnswer,
  getAvailableExerciseTypes
}
