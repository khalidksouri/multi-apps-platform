// Plans d'abonnement MATH4CHILD - Conformité EXACTE aux spécifications
export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  features: string[];
  popular?: boolean;
  badge?: string;
}

// Plans conformes aux spécifications EXACTES
export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    profiles: 1, // 1 profil selon spécifications
    features: [
      '1 profil utilisateur unique',
      '5 niveaux de progression',
      '100 bonnes réponses minimum par niveau',
      '5 opérations mathématiques',
      'Support communautaire',
      'Accès version gratuite 1 semaine'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD', 
    price: 9.99,
    profiles: 2, // 2 profils selon spécifications
    features: [
      '2 profils utilisateur',
      'Toutes fonctionnalités BASIC',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Support prioritaire',
      'Statistiques détaillées'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    profiles: 3, // 3 profils selon spécifications
    popular: true, // LE PLUS CHOISI selon spécifications
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
    profiles: 5, // 5 profils selon spécifications
    features: [
      '5 profils utilisateur',
      'Toutes fonctionnalités PREMIUM',
      'Rapports familiaux complets',
      'Contrôle parental avancé',
      'Support VIP prioritaire',
      'Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 29.99, // Prix de base, devis selon besoins
    profiles: 10, // 10+ profils minimum selon spécifications
    features: [
      '10+ profils utilisateur (sans limite)',
      'Devis personnalisé selon besoins client',
      'API développeur complète',
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Formation équipes incluse',
      'SLA personnalisé garanti'
    ]
  }
];

// Contacts autorisés UNIQUEMENT
export const AUTHORIZED_CONTACTS = {
  support: 'support@math4child.com',
  commercial: 'commercial@math4child.com',
  domain: 'www.math4child.com'
};

// Éléments STRICTEMENT INTERDITS - NE JAMAIS afficher
export const FORBIDDEN_ELEMENTS = [
  'GOTEST',
  '53958712100028', 
  'gotesttech@gmail.com',
  'Spécifications primordiales',
  'Tarification compétitive selon spécifications'
];
