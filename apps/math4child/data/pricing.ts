export interface PricingPlan {
  id: string;
  name: string;
  profiles: number;
  price: {
    monthly: string;
    quarterly: string;
    yearly: string;
  };
  originalPrice?: {
    quarterly?: string;
    yearly?: string;
  };
  discount?: {
    quarterly?: string;
    yearly?: string;
  };
  features: string[];
  popular?: boolean;
}

export const pricingPlans: PricingPlan[] = [
  {
    id: 'free',
    name: 'Gratuit',
    profiles: 1,
    price: {
      monthly: '0€',
      quarterly: '0€', 
      yearly: '0€'
    },
    features: [
      '1 profil enfant',
      '50 questions total',
      'Niveaux 1-2 seulement',
      'Accès 7 jours',
      'Toutes opérations de base'
    ]
  },
  {
    id: 'premium',
    name: 'Premium',
    profiles: 3, // CORRIGÉ: 3 profils au lieu de 5
    price: {
      monthly: '9.99€',
      quarterly: '26.97€',
      yearly: '83.93€'
    },
    originalPrice: {
      quarterly: '29.97€',
      yearly: '119.88€'
    },
    discount: {
      quarterly: '10%',
      yearly: '30%'
    },
    features: [
      '3 profils enfants + 2 parents', // CORRIGÉ
      'Questions illimitées',
      'Tous les 5 niveaux',
      'Toutes les opérations',
      'Statistiques détaillées',
      'Support prioritaire'
    ],
    popular: true
  },
  {
    id: 'family',
    name: 'Famille',
    profiles: 5, // CORRIGÉ: 5 profils au lieu de 8
    price: {
      monthly: '14.99€',
      quarterly: '40.47€', 
      yearly: '125.93€'
    },
    originalPrice: {
      quarterly: '44.97€',
      yearly: '179.88€'
    },
    discount: {
      quarterly: '10%',
      yearly: '30%'
    },
    features: [
      '5 profils enfants + 2 parents', // CORRIGÉ
      'Questions illimitées',
      'Tous les 5 niveaux',
      'Toutes les opérations',
      'Rapports parents détaillés',
      'Contrôle parental avancé',
      'Mode hors-ligne',
      'Support premium 24/7'
    ]
  }
];
