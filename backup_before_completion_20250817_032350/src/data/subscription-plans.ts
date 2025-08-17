import { SubscriptionPlan } from '@/types'

export const subscriptionPlans: SubscriptionPlan[] = [
  {
    id: 'gratuit',
    name: 'GRATUIT',
    price: 0,
    currency: 'EUR',
    period: 'month',
    features: [
      '1 semaine d\'accès',
      '50 questions maximum',
      'Mode classique uniquement',
      'Support communautaire'
    ]
  },
  {
    id: 'basic',
    name: 'BASIC',
    price: 9.99,
    currency: 'EUR',
    period: 'month',
    features: [
      'Accès illimité niveau 1-2',
      'Mode classique + manuscrit',
      '3 langues au choix',
      'Support email'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 19.99,
    currency: 'EUR',
    period: 'month',
    features: [
      'Accès tous niveaux',
      'Tous les modes d\'exercices',
      '50 langues incluses',
      'Dashboard parental',
      'Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 29.99,
    currency: 'EUR',
    period: 'month',
    popular: true,
    badge: 'LE PLUS CHOISI',
    features: [
      '🚀 TOUTES les innovations',
      '🧠 IA Adaptative complète',
      '🥽 Réalité Augmentée 3D',
      '🌍 200+ langues',
      '📊 Analytics avancés',
      '🎮 Gamification complète',
      '👨‍👩‍👧‍👦 Dashboard famille',
      '🆘 Support 24/7'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 0, // Prix sur devis
    currency: 'EUR',
    period: 'month',
    features: [
      'Solution institutionnelle',
      'Nombre d\'utilisateurs illimité',
      'Intégrations sur mesure',
      'Formation équipes',
      'Support dédié',
      'SLA garanti'
    ]
  }
]
