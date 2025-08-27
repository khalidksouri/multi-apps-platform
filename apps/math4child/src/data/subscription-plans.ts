// Plans d'abonnement Math4Child - Conformes aux spécifications EXACTES
export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  features: string[];
  popular?: boolean;
  badge?: string;
  description: string;
}

// 5 Plans EXACTS selon spécifications
export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    profiles: 1, // 1 profil selon spécifications EXACTES
    description: '1 Profil',
    features: [
      '✓ 1 profil utilisateur unique',
      '✓ 5 niveaux de progression',
      '✓ 100 bonnes réponses minimum par niveau',
      '✓ 5 opérations mathématiques',
      '✓ Version gratuite 1 semaine (50 questions)',
      '✓ Support communautaire'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 9.99,
    profiles: 2, // 2 profils selon spécifications EXACTES
    description: '2 Profils',
    features: [
      '✓ 2 profils utilisateur',
      '✓ Toutes fonctionnalités BASIC',
      '✓ IA Adaptative avancée',
      '✓ Reconnaissance manuscrite',
      '✓ Support prioritaire',
      '✓ 50% réduction 2ème device'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    profiles: 3, // 3 profils selon spécifications EXACTES
    popular: true, // LE PLUS CHOISI selon spécifications
    badge: 'LE PLUS CHOISI',
    description: '3 Profils',
    features: [
      '✓ 3 profils utilisateur',
      '✓ Toutes fonctionnalités STANDARD',
      '✓ Assistant vocal IA',
      '✓ Réalité augmentée 3D',
      '✓ Analytics avancées',
      '✓ Réductions: 10% (3 mois), 30% (annuel)'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 19.99,
    profiles: 5, // 5 profils selon spécifications EXACTES
    description: '5 Profils',
    features: [
      '✓ 5 profils utilisateur',
      '✓ Toutes fonctionnalités PREMIUM',
      '✓ Rapports familiaux complets',
      '✓ Contrôle parental avancé',
      '✓ Support VIP 24h/24',
      '✓ Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 29.99,
    profiles: 10, // 10+ profils selon spécifications EXACTES
    description: '10+ Profils (Sans Limite)',
    features: [
      '✓ 10+ profils (sans limitation maximum)',
      '✓ Devis personnalisé selon besoins',
      '✓ API développeur complète',
      '✓ Fonctionnalités école/institution',
      '✓ Support dédié 24/7',
      '✓ Formation équipes incluse'
    ]
  }
];

// Contacts AUTORISÉS uniquement
export const CONTACTS = {
  support: 'support@math4child.com',
  commercial: 'commercial@math4child.com',
  domain: 'www.math4child.com'
};
