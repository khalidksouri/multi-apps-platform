import Stripe from 'stripe'
import { Math4ChildPlan } from '@/types/stripe'

// Configuration Stripe
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || process.env.STRIPE_TEST_SECRET_KEY || ''

export const stripe = new Stripe(stripeSecretKey || 'sk_test_demo', {
  apiVersion: '2023-10-16',
  typescript: true,
})

// Mode démo détecté automatiquement
export const DEMO_MODE = stripeSecretKey.includes('demo') || 
                         stripeSecretKey === '' ||
                         process.env.NEXT_PUBLIC_ENABLE_STRIPE_DEMO === 'true'

// Plans Math4Child enrichis
export const MATH4CHILD_PLANS: Math4ChildPlan[] = [
  {
    id: 'basic',
    name: 'Basic',
    description: 'Idéal pour débuter l\'apprentissage mathématique',
    price: 499, // 4,99€
    currency: 'eur',
    interval: 'month',
    profiles: 1,
    features: [
      '1 profil enfant',
      '100+ exercices interactifs',
      '5 niveaux de difficulté',
      'Suivi des progrès basique',
      'Support par la communauté',
      'Accès aux modes classiques',
      'Rapports mensuels',
      'Interface multilingue'
    ]
  },
  {
    id: 'premium',
    name: 'Premium',
    description: 'La solution complète avec IA et innovations',
    price: 1499, // 14,99€
    currency: 'eur',
    interval: 'month',
    profiles: 3,
    popular: true,
    badge: 'LE PLUS CHOISI',
    features: [
      '3 profils enfants',
      '500+ exercices avancés',
      'IA Adaptative complète',
      'Reconnaissance manuscrite',
      'Assistant vocal personnalisé',
      'Tous les niveaux débloqués',
      'Statistiques avancées temps réel',
      'Support prioritaire par email',
      'Mode hors-ligne avancé',
      'Rapports détaillés parents',
      'Synchronisation multi-appareils'
    ]
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    description: 'Pour les familles nombreuses et établissements',
    price: 3999, // 39,99€
    currency: 'eur',
    interval: 'month',
    profiles: 10,
    features: [
      '10 profils enfants',
      'Exercices illimités',
      'Toutes les innovations IA',
      'Réalité Augmentée 3D complète',
      'Mode hors-ligne intégral',
      'API pour établissements scolaires',
      'Rapports personnalisés détaillés',
      'Support dédié 24/7 par téléphone',
      'Formation personnalisée incluse',
      'Accès aux versions bêta',
      'Intégration systèmes scolaires',
      'Tableau de bord administrateur',
      'Sauvegarde cloud prioritaire'
    ]
  }
]

// Fonctions utilitaires
export const getPlanById = (planId: string): Math4ChildPlan | undefined => {
  return MATH4CHILD_PLANS.find(plan => plan.id === planId)
}

export const formatPrice = (price: number, currency: string = 'eur'): string => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: currency.toUpperCase()
  }).format(price / 100)
}

export const getYearlyPrice = (monthlyPrice: number): number => {
  // Réduction de 20% pour l'abonnement annuel
  return Math.round(monthlyPrice * 12 * 0.8)
}

export const calculateDiscount = (originalPrice: number, discountPercent: number): number => {
  return Math.round(originalPrice * (1 - discountPercent / 100))
}

export const getPopularPlan = (): Math4ChildPlan | undefined => {
  return MATH4CHILD_PLANS.find(plan => plan.popular === true)
}

export const getPlansByProfileCount = (minProfiles: number): Math4ChildPlan[] => {
  return MATH4CHILD_PLANS.filter(plan => plan.profiles >= minProfiles)
}

// Configuration et logs
if (DEMO_MODE) {
  console.log('🧪 [STRIPE] Mode démo activé - Paiements simulés')
  console.log('🧪 [STRIPE] Plans disponibles:', MATH4CHILD_PLANS.map(p => `${p.name} (${p.profiles} profils)`))
} else {
  console.log('💳 [STRIPE] Mode production activé')
  console.log('💳 [STRIPE] Plans configurés:', MATH4CHILD_PLANS.length)
}
