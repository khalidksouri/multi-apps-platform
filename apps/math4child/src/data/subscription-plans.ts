// Plans d'abonnement Math4Child v4.2.0 - Conformes spécifications README.md
import type { SubscriptionPlan } from '../types';

export const subscriptionPlans: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    currency: 'EUR',
    interval: 'monthly',
    profiles: 1, // 1 profil selon spécifications exactes
    description: '1 Profil',
    features: [
      '👤 1 profil utilisateur unique et personnalisé',
      '🎯 5 niveaux de progression complète et structurée',
      '✅ 100 bonnes réponses minimum par niveau (validation stricte)',
      '🧮 5 opérations mathématiques (Addition, Soustraction, Multiplication, Division, Mixte)',
      '💬 Support communautaire actif et bienveillant'
    ],
    innovations: ['Progression gamifiée', 'Interface adaptative']
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 9.99,
    currency: 'EUR',
    interval: 'monthly',
    profiles: 2, // 2 profils selon spécifications exactes
    description: '2 Profils',
    features: [
      '👥 2 profils utilisateur distincts et configurables',
      '🚀 Toutes fonctionnalités BASIC incluses sans restriction',
      '🧠 IA Adaptative avancée et personnalisée par profil',
      '✏️ Reconnaissance manuscrite complète avec feedback IA',
      '📊 Statistiques détaillées et analytics approfondies',
      '🆘 Support prioritaire garanti sous 24h'
    ],
    innovations: ['IA Adaptative', 'Reconnaissance manuscrite', 'Analytics avancées']
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    currency: 'EUR',
    interval: 'monthly',
    profiles: 3, // 3 profils selon spécifications exactes
    description: '3 Profils',
    popular: true, // LE PLUS CHOISI selon spécifications
    badge: 'LE PLUS CHOISI', // Badge exact selon README.md
    features: [
      '👨‍👩‍👧‍👦 3 profils utilisateur familiaux coordonnés',
      '🎉 Toutes fonctionnalités STANDARD incluses intégralement',
      '🎙️ Assistant vocal IA complet avec 3 personnalités distinctes',
      '🥽 Réalité augmentée 3D mathématique immersive',
      '📈 Analytics avancées détaillées avec insights',
      '🎨 Personnalisation complète interface et expérience'
    ],
    innovations: ['Assistant vocal IA', 'Réalité augmentée 3D', 'Personnalisation complète']
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 19.99,
    currency: 'EUR',
    interval: 'monthly',
    profiles: 5, // 5 profils selon spécifications exactes
    description: '5 Profils',
    features: [
      '👪 5 profils utilisateur pour toute la famille élargie',
      '🎊 Toutes fonctionnalités PREMIUM incluses sans limite',
      '👨‍👩‍👧‍👦 Rapports familiaux complets et détaillés',
      '🔒 Contrôle parental avancé et sécurisé',
      '🌟 Support VIP prioritaire 24h/24 avec dédiés'
    ],
    innovations: ['Contrôle parental', 'Rapports familiaux', 'Support VIP']
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 0, // Sur devis selon spécifications
    currency: 'EUR',
    interval: 'monthly',
    profiles: 999, // 10+ profils (sans limite) selon spécifications
    description: '10+ Profils (Sans Limite)',
    features: [
      '🏫 10+ profils (sans limitation maximale)',
      '📋 Devis personnalisé selon besoins spécifiques clients',
      '⚙️ API développeur complète et documentée',
      '🎓 Fonctionnalités école/institution avancées',
      '👨‍💼 Support dédié 24/7 avec account manager attitré',
      '🎯 Formation équipes incluse avec certification'
    ],
    innovations: ['API développeur', 'Fonctionnalités institutionnelles', 'Support dédié']
  }
];

// Validation des plans selon spécifications strictes
export function validatePlanProfiles(planId: string): number {
  const plan = subscriptionPlans.find(p => p.id === planId);
  if (!plan) throw new Error('Plan non trouvé');
  
  // Validation stricte selon README.md
  const expectedProfiles = {
    basic: 1,
    standard: 2, 
    premium: 3,
    famille: 5,
    ultimate: 999
  };
  
  if (plan.profiles !== expectedProfiles[planId as keyof typeof expectedProfiles]) {
    throw new Error(`Plan ${planId}: nombre de profils incorrect`);
  }
  
  return plan.profiles;
}

// Premium "LE PLUS CHOISI" selon spécifications
export function getPopularPlan(): SubscriptionPlan {
  const premium = subscriptionPlans.find(p => p.popular);
  if (!premium || premium.id !== 'premium') {
    throw new Error('Premium doit être "LE PLUS CHOISI"');
  }
  return premium;
}
