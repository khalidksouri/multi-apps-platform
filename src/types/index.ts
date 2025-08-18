// =============================================================================
// 🧠 TYPES MATH4CHILD v4.2.0 - COMPLETS ET CORRIGÉS
// =============================================================================

// Types pour l'internationalisation
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  regions: string[]  // Corrigé: tableau de régions
  rtl?: boolean
}

// Types pour les exercices - INTERFACE COMPLÈTE CORRIGÉE
export interface Exercise {
  id: string
  type: string  // ✅ AJOUTÉ: Propriété 'type' manquante
  question: string
  answer: number
  level: number
  operation: string
  difficulty: 'easy' | 'medium' | 'hard'  // ✅ CORRIGÉ: string enum au lieu de number
  format: 'multiple_choice' | 'input' | 'drag_drop'
  options?: number[]
  hints?: string[]
  explanation?: string
}

// Alias pour compatibilité
export interface MathExercise extends Exercise {}

// Types pour les plans d'abonnement
export interface SubscriptionPlan {
  id: string
  name: string
  price: number
  currency: string
  period: string
  profiles: number  // OBLIGATOIRE selon spécifications
  popular?: boolean
  badge?: string
  features: string[]
}

// Types pour la progression
export interface ProgressLevel {
  id: number
  name: string
  description: string
  requiredCorrectAnswers: number
  operations: string[]
  difficultyRange: {
    min: number
    max: number
  }
  unlockConditions: string[]
  rewards: Reward[]
  estimatedDuration: string
}

export interface Reward {
  id: string
  name: string
  description: string
  icon: string
  rarity: 'common' | 'rare' | 'epic' | 'legendary'
}

// Types pour l'IA adaptative
export interface AIPersonality {
  name: string
  voice: string
  responses: {
    greeting: string
    hint: string
    success: string
    struggle: string
    motivation: string
  }
}

// Types pour la reconnaissance vocale
export interface VoiceMessage {
  id: string
  text: string
  type: 'user' | 'assistant'
  timestamp: number
  emotion?: string
  confidence?: number
}

export interface VoiceState {
  isListening: boolean
  isProcessing: boolean
  isSpeaking: boolean
  currentPhrase: string
  recognitionConfidence: number
  conversationHistory: ConversationEntry[]
}

export interface ConversationEntry {
  timestamp: number
  speaker: 'user' | 'assistant'
  message: string
  emotion?: string
  intent?: string
}

// Types pour la reconnaissance manuscrite
export interface Point {
  x: number
  y: number
  timestamp?: number
}

export interface Stroke {
  points: Point[]
  color?: string
  width?: number
}

export interface Recognition {
  character: string
  confidence: number
  alternatives: { character: string; confidence: number }[]
}
