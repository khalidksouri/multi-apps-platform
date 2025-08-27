// Plans d'abonnement MATH4CHILD - Conformité EXACTE aux spécifications
export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  features: string[];
  popular?: boolean;
  badge?: string;
  description?: string;
}

// Plans conformes aux spécifications EXACTES - 5 plans requis
export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 0, // Prix variable selon pays et pouvoir d'achat
    profiles: 1, // 1 profil selon spécifications
    description: '1 Profil',
    features: [
      '1 profil utilisateur unique',
      '5 niveaux de progression', 
      '100 bonnes réponses minimum par niveau pour débloquer suivant',
      '5 opérations mathématiques (Addition, Soustraction, Division, Multiplication, Mixte)',
      'Support communautaire',
      'Version gratuite 1 semaine (50 questions total)',
      'Accès Web OU Android OU iOS'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 0, // Prix variable selon pays et pouvoir d'achat
    profiles: 2, // 2 profils selon spécifications
    description: '2 Profils',
    features: [
      '2 profils utilisateur',
      'Toutes fonctionnalités BASIC',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Support prioritaire',
      'Statistiques détaillées',
      '50% réduction deuxième device',
      '75% réduction troisième device'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 0, // Prix variable selon pays et pouvoir d'achat  
    profiles: 3, // 3 profils selon spécifications
    popular: true, // LE PLUS CHOISI selon spécifications
    badge: 'LE PLUS CHOISI',
    description: '3 Profils',
    features: [
      '3 profils utilisateur',
      'Toutes fonctionnalités STANDARD',
      'Assistant vocal IA complet',
      'Réalité augmentée 3D',
      'Analytics avancées',
      'Personnalisation complète',
      'Réductions trimestrielles (10%) et annuelles (30%)'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 0, // Prix variable selon pays et pouvoir d'achat
    profiles: 5, // 5 profils selon spécifications
    description: '5 Profils',
    features: [
      '5 profils utilisateur',
      'Toutes fonctionnalités PREMIUM',
      'Rapports familiaux complets',
      'Contrôle parental avancé',
      'Support VIP prioritaire 24h/24',
      'Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 0, // Devis personnalisé selon besoins client
    profiles: 10, // 10+ profils minimum selon spécifications (sans limite max)
    description: '10+ Profils (Sans Limite)',
    features: [
      '10+ profils utilisateur (sans limitation maximum)',
      'Devis personnalisé selon besoins client',
      'API développeur complète', 
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Formation équipes incluse',
      'SLA personnalisé garanti'
    ]
  }
];

// Contacts autorisés UNIQUEMENT selon spécifications
export const AUTHORIZED_CONTACTS = {
  support: 'support@math4child.com',
  commercial: 'commercial@math4child.com', 
  domain: 'www.math4child.com'
};

// Éléments STRICTEMENT INTERDITS - NE JAMAIS afficher selon spécifications
export const FORBIDDEN_ELEMENTS = [
// Élément supprimé - non conforme aux spécifications MATH4CHILD
// Élément supprimé - non conforme aux spécifications MATH4CHILD
// Élément supprimé - non conforme aux spécifications MATH4CHILD
// Élément supprimé - non conforme aux spécifications MATH4CHILD
// Élément supprimé - non conforme aux spécifications MATH4CHILD
];

// Configuration langues selon spécifications
export const LANGUAGE_CONFIG = {
  // Arabe avec drapeaux spécifiques selon spécifications
  arabic_africa: { flag: '🇲🇦', region: 'Afrique' },
  arabic_middle_east: { flag: '🇵🇸', region: 'Moyen-Orient & Golf' },
  
  // Restriction selon spécifications  
  excluded_languages: ['hebrew'], // Hébreu exclu
  
  // Traduction complète requise
  full_translation: true,
  scroll_dropdown: true,
  no_duplication: true // Français pour tous pays francophones, etc.
};

export default SUBSCRIPTION_PLANS;
