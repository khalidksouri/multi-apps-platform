// Types globaux pour Math4Child

export interface User {
  id: string
  email: string
  name: string
  subscription?: Subscription
  preferences: UserPreferences
}

export interface Subscription {
  id: string
  plan: 'free' | 'premium' | 'family'
  status: 'active' | 'cancelled' | 'expired'
  provider: 'stripe' | 'paddle' | 'lemonsqueezy'
  expiresAt: Date
}

export interface UserPreferences {
  language: string
  theme: 'light' | 'dark'
  mathLevel: number
  notifications: boolean
}

export interface MathProblem {
  id: string
  type: 'addition' | 'subtraction' | 'multiplication' | 'division'
  level: number
  question: string
  answer: number
  options?: number[]
}

export interface PaymentSession {
  id: string
  provider: string
  amount: number
  currency: string
  status: 'pending' | 'completed' | 'failed'
}
