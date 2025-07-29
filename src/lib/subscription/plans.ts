// ===================================================================
// 💰 SYSTÈME D'ABONNEMENTS PREMIUM
// Plans compétitifs avec réductions multi-appareils
// ===================================================================

export interface Device {
  type: 'web' | 'android' | 'ios';
  name: string;
  icon: string;
  platform: string;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  description: string;
  basePrice: number; // Prix en EUR
  currency: string;
  duration: 'weekly' | 'monthly' | 'quarterly' | 'yearly';
  durationInDays: number;
  features: string[];
  profilesLimit: number;
  questionsLimit: number | 'unlimited';
  levelsAccess: string[];
  support: 'community' | 'email' | 'priority' | 'vip';
  isPopular?: boolean;
  savings?: number; // Pourcentage d'économie
  color: string;
  gradient: string;
}

export const AVAILABLE_DEVICES: Device[] = [
  {
    type: 'web',
    name: 'Web (ordinateur)',
    icon: '💻',
    platform: 'Navigateur web'
  },
  {
    type: 'android',
    name: 'Android',
    icon: '📱',
    platform: 'Google Play Store'
  },
  {
    type: 'ios',
    name: 'iOS',
    icon: '📱',
    platform: 'App Store'
  }
];

export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'trial',
    name: 'Essai Gratuit',
    description: 'Découvrez Math4Child pendant 7 jours',
    basePrice: 0,
    currency: 'EUR',
    duration: 'weekly',
    durationInDays: 7,
    features: [
      '50 questions gratuites',
      '2 profils enfants',
      'Accès niveau débutant uniquement',
      'Support communautaire',
      'Statistiques de base'
    ],
    profilesLimit: 2,
    questionsLimit: 50,
    levelsAccess: ['beginner'],
    support: 'community',
    color: '#6B7280',
    gradient: 'from-gray-400 to-gray-500'
  },
  {
    id: 'monthly',
    name: 'Mensuel',
    description: 'Parfait pour commencer',
    basePrice: 9.99,
    currency: 'EUR',
    duration: 'monthly',
    durationInDays: 30,
    features: [
      'Questions illimitées',
      '3 profils enfants',
      'Tous les 5 niveaux',
      'Toutes les opérations',
      'Support par email',
      'Statistiques détaillées',
      'Mode révision'
    ],
    profilesLimit: 3,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'email',
    color: '#3B82F6',
    gradient: 'from-blue-400 to-indigo-500'
  },
  {
    id: 'quarterly',
    name: 'Trimestriel',
    description: 'Économisez 10% sur 3 mois',
    basePrice: 26.97,
    currency: 'EUR',
    duration: 'quarterly',
    durationInDays: 90,
    features: [
      'Tout du plan mensuel',
      '5 profils enfants',
      'Support prioritaire',
      'Accès aux nouvelles fonctionnalités',
      'Défis chronométrés',
      'Rapport de progression parents',
      'Mode hors-ligne avancé'
    ],
    profilesLimit: 5,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'priority',
    savings: 10,
    isPopular: true,
    color: '#10B981',
    gradient: 'from-green-400 to-emerald-500'
  },
  {
    id: 'yearly',
    name: 'Annuel',
    description: 'Meilleure offre - Économisez 30%',
    basePrice: 83.93,
    currency: 'EUR',
    duration: 'yearly',
    durationInDays: 365,
    features: [
      'Tout du plan trimestriel',
      '10 profils enfants',
      'Support VIP 24/7',
      'Accès bêta aux nouvelles fonctionnalités',
      'Analyses IA avancées',
      'Rapports mensuels détaillés',
      'Mode multijoueur famille',
      'Jeux bonus exclusifs'
    ],
    profilesLimit: 10,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'vip',
    savings: 30,
    color: '#F59E0B',
    gradient: 'from-yellow-400 to-orange-500'
  },
  {
    id: 'premium_yearly',
    name: 'Premium Famille',
    description: 'Pour les grandes familles',
    basePrice: 149.99,
    currency: 'EUR',
    duration: 'yearly',
    durationInDays: 365,
    features: [
      '20 profils enfants',
      'Support VIP prioritaire',
      'Fonctionnalités exclusives',
      'Accès anticipé aux mises à jour',
      'Personnalisation avancée',
      'Tableau de bord parent avancé',
      'Intégration calendrier familial',
      'Certificats de réussite personnalisés'
    ],
    profilesLimit: 20,
    questionsLimit: 'unlimited',
    levelsAccess: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    support: 'vip',
    savings: 25,
    color: '#8B5CF6',
    gradient: 'from-purple-400 to-violet-500'
  }
];

// Calculateur de réductions multi-appareils
export interface DeviceDiscount {
  deviceCount: number;
  discount: number; // Pourcentage
  description: string;
}

export const MULTI_DEVICE_DISCOUNTS: DeviceDiscount[] = [
  {
    deviceCount: 1,
    discount: 0,
    description: 'Prix normal'
  },
  {
    deviceCount: 2,
    discount: 50,
    description: '50% de réduction sur le 2ème appareil'
  },
  {
    deviceCount: 3,
    discount: 75,
    description: '75% de réduction sur le 3ème appareil'
  }
];

export function calculateDevicePrice(
  basePrice: number, 
  existingDevicesCount: number
): { price: number; discount: number; savings: number } {
  const discountInfo = MULTI_DEVICE_DISCOUNTS.find(d => d.deviceCount === existingDevicesCount + 1);
  
  if (!discountInfo) {
    return { price: basePrice, discount: 0, savings: 0 };
  }
  
  const discount = discountInfo.discount;
  const discountAmount = (basePrice * discount) / 100;
  const finalPrice = basePrice - discountAmount;
  
  return {
    price: finalPrice,
    discount,
    savings: discountAmount
  };
}
