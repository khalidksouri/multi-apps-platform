// Types Math4Child v4.2.0 - Révolution Éducative Mondiale

export interface User {
  id: string
  name: string
  email: string
  age: number
  level: number
  totalPoints: number
  streak: number
  profileImage?: string
  language: string
  parentalControls: boolean
}

export interface Exercise {
  id: string
  type: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed'
  level: number
  question: string
  correctAnswer: number
  options?: number[]
  difficulty: 'easy' | 'medium' | 'hard'
  timeLimit?: number
}

export interface GameMode {
  id: string
  name: string
  description: string
  icon: string
  path: string
  unlocked: boolean
  beta?: boolean
}

export interface Innovation {
  id: string
  name: string
  description: string
  icon: string
  status: 'active' | 'beta' | 'coming_soon'
  features: string[]
}

export interface SubscriptionPlan {
  id: string
  name: string
  price: number
  currency: string
  period: 'month' | 'year'
  features: string[]
  popular?: boolean
  badge?: string
  discount?: number
}

export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  regions?: string[]
}

export interface Progress {
  level: number
  correctAnswers: number
  totalAnswers: number
  accuracy: number
  timeSpent: number
  badges: Badge[]
  achievements: Achievement[]
}

export interface Badge {
  id: string
  name: string
  description: string
  icon: string
  rarity: 'common' | 'rare' | 'epic' | 'legendary'
  unlockedAt?: Date
}

export interface Achievement {
  id: string
  title: string
  description: string
  icon: string
  progress: number
  target: number
  completed: boolean
  reward?: {
    points: number
    badge?: Badge
  }
}

export interface AIFeedback {
  encouragement: string
  hints: string[]
  nextSteps: string[]
  difficulty_adjustment: 'increase' | 'decrease' | 'maintain'
}

export interface HandwritingRecognition {
  input: string
  confidence: number
  alternatives: string[]
  processed: boolean
}

export interface ARVisualization {
  type: '3d_objects' | 'animation' | 'interactive'
  objects: ARObject[]
  interactions: ARInteraction[]
}

export interface ARObject {
  id: string
  type: 'cube' | 'sphere' | 'number' | 'operation'
  position: [number, number, number]
  rotation: [number, number, number]
  scale: [number, number, number]
  color: string
  animation?: string
}

export interface ARInteraction {
  id: string
  type: 'tap' | 'drag' | 'voice'
  target: string
  action: string
  feedback: string
}
