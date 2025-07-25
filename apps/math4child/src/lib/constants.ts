import React from 'react';
import { Trophy, BookOpen, Zap } from 'lucide-react';

export const FEATURES = [
  {
    id: 'competitive',
    title: 'Prix compétitifs',
    description: 'Les meilleurs tarifs du marché',
    icon: React.createElement(Trophy, { className: "w-8 h-8" }),
    stat: '60% moins cher'
  },
  {
    id: 'family',
    title: 'Gestion familiale',
    description: 'Suivez les progrès de tous vos enfants',
    icon: React.createElement(BookOpen, { className: "w-8 h-8" }),
    stat: 'Jusqu\'à 6 profils'
  },
  {
    id: 'performance',
    title: 'Performances optimales',
    description: 'Application rapide et fluide',
    icon: React.createElement(Zap, { className: "w-8 h-8" }),
    stat: 'Chargement < 2s'
  }
];
