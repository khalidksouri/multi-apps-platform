// Types partagés pour Math4Kids
export interface User {
  id: string
  name: string
  email: string
  subscription?: string
}

export interface AppConfig {
  name: string
  version: string
  apiUrl: string
}

export interface LanguageConfig {
  name: string
  flag: string
  continent: string
  appName: string
  rtl?: boolean
}

export interface MathQuestion {
  question: string
  answer: number
  operation: string
  level: number
}

export interface GameState {
  score: number
  level: number
  lives: number
  streak: number
  questionsAnswered: number
}

export interface SubscriptionPlan {
  id: string
  name: string
  price: number
  currency: string
  interval: 'month' | 'year'
  features: string[]
  stripePriceId?: string
  popular?: boolean
  savings?: string
}
