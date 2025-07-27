import { Language, Feature, PricingPlan } from '@/types';
import { Trophy, BookOpen, Zap } from 'lucide-react';

export const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
];

export const FEATURES: Feature[] = [
  {
    id: 'premium-features',
    title: 'Fonctionnalités premium',
    description: 'Plus de 10 000 exercices personnalisés',
    icon: React.createElement(Trophy, { className: "w-8 h-8" }),
    gradient: 'from-yellow-400 to-orange-500',
    stats: '10 000+ exercices'
  },
  {
    id: 'progress-tracking',
    title: 'Suivi détaillé des progrès',
    description: 'Rapports hebdomadaires parents',
    icon: React.createElement(BookOpen, { className: "w-8 h-8" }),
    gradient: 'from-green-400 to-blue-500',
    stats: 'Rapports hebdomadaires'
  },
  {
    id: 'interactive-games',
    title: 'Jeux interactifs',
    description: '50+ mini-jeux disponibles',
    icon: React.createElement(Zap, { className: "w-8 h-8" }),
    gradient: 'from-purple-400 to-pink-500',
    stats: '50+ mini-jeux'
  }
];

export const PRICING_PLANS: Record<string, PricingPlan[]> = {
  monthly: [
    {
      id: 'famille',
      name: 'Famille',
      price: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email'],
      color: 'from-blue-500 to-blue-600'
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true,
      color: 'from-purple-500 to-purple-600'
    },
    {
      id: 'ecole',
      name: 'École',
      price: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration'],
      color: 'from-green-500 to-green-600'
    }
  ],
  quarterly: [
    {
      id: 'famille',
      name: 'Famille',
      price: 8.99,
      originalPrice: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email'],
      color: 'from-blue-500 to-blue-600'
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 17.99,
      originalPrice: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true,
      color: 'from-purple-500 to-purple-600'
    },
    {
      id: 'ecole',
      name: 'École',      
      price: 26.99,
      originalPrice: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration'],
      color: 'from-green-500 to-green-600'
    }
  ],
  annual: [
    {
      id: 'famille',
      name: 'Famille',
      price: 6.99,
      originalPrice: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email'],
      color: 'from-blue-500 to-blue-600'
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 13.99,
      originalPrice: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true,
      color: 'from-purple-500 to-purple-600'
    },
    {
      id: 'ecole',
      name: 'École',
      price: 20.99,
      originalPrice: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration'],
      color: 'from-green-500 to-green-600'
    }
  ]
};
