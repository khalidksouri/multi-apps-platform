// =============================================================================
// 💳 PLANS D'ABONNEMENT MATH4CHILD v4.2.0 - CONFORMES SPÉCIFICATIONS
// =============================================================================

import { SubscriptionPlan } from '@/types'

export const subscriptionPlans: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    currency: 'EUR',
    period: 'month',
    profiles: 1,  // 1 profil selon spécifications
    features: [
      '1 profil utilisateur unique',
      '5 niveaux de progression',
      '100 bonnes réponses minimum par niveau',
      '5 opérations mathématiques',
      'Support communautaire'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 9.99,
    currency: 'EUR',
    period: 'month',
    profiles: 2,  // 2 profils selon spécifications
    features: [
      '2 profils utilisateur',
      'Toutes fonctionnalités BASIC',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    currency: 'EUR',
    period: 'month',
    profiles: 3,  // 3 profils selon spécifications
    popular: true,
    badge: 'LE PLUS CHOISI',
    features: [
      '3 profils utilisateur',
      'Toutes fonctionnalités STANDARD',
      'Assistant vocal IA',
      'Réalité augmentée 3D',
      'Analytics avancées',
      'Personnalisation complète'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 19.99,
    currency: 'EUR',
    period: 'month',
    profiles: 5,  // 5 profils selon spécifications
    features: [
      '5 profils utilisateur',
      'Toutes fonctionnalités PREMIUM',
      'Rapports familiaux',
      'Contrôle parental avancé',
      'Support VIP prioritaire'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 29.99,
    currency: 'EUR',
    period: 'month',
    profiles: 10,  // 10+ profils selon spécifications (minimum 10)
    features: [
      '10+ profils (sans limite)',
      'Devis personnalisé selon besoins',
      'API développeur',
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Formation équipes'
    ]
  }
]

export default subscriptionPlans
