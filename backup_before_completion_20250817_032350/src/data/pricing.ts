export interface PricingPlan {
  id: string
  name: string
  description: string
  price: {
    monthly: number
    quarterly: number
    yearly: number
  }
  features: string[]
  popular?: boolean
  color: string
  icon: string
}

export const pricingPlans: PricingPlan[] = [
  {
    id: 'basic',
    name: 'Basique',
    description: 'Parfait pour débuter avec Math4Child',
    price: {
      monthly: 9.99,
      quarterly: 24.99,
      yearly: 79.99
    },
    features: [
      '🧮 Exercices de base',
      '📊 Suivi des progrès',
      '🎯 3 niveaux de difficulté',
      '🌍 Support multilingue',
      '📱 Accès mobile'
    ],
    color: 'blue',
    icon: '🌟'
  },
  {
    id: 'premium',
    name: 'Premium',
    description: 'L\'expérience complète Math4Child',
    price: {
      monthly: 19.99,
      quarterly: 49.99,
      yearly: 159.99
    },
    features: [
      '🧠 IA Adaptative complète',
      '✍️ Reconnaissance manuscrite',
      '🎙️ Assistant vocal',
      '📈 Analyses avancées',
      '👨‍👩‍👧‍👦 Comptes famille (5)',
      '🎨 Personnalisation',
      '📞 Support prioritaire'
    ],
    popular: true,
    color: 'purple',
    icon: '🚀'
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    description: 'Toute la puissance révolutionnaire',
    price: {
      monthly: 39.99,
      quarterly: 99.99,
      yearly: 319.99
    },
    features: [
      '🥽 Réalité Augmentée 3D',
      '🧠 IA Ultra-Adaptative',
      '✍️ Reconnaissance avancée',
      '🎙️ Assistant vocal émotionnel',
      '👨‍👩‍👧‍👦 Comptes illimités',
      '🏫 Fonctionnalités école',
      '📊 Tableaux de bord enseignant',
      '🔧 API développeur',
      '🎯 Support dédié 24/7'
    ],
    color: 'gold',
    icon: '👑'
  }
]

export const getDiscountedPrice = (basePrice: number, discount: number): number => {
  return basePrice * (1 - discount / 100)
}

export const formatPrice = (price: number): string => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price)
}
