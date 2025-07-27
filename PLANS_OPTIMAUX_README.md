# Plans d'abonnement optimaux Math4Child

Ce fichier documente les modifications apportées pour implémenter les plans optimaux de Math4Child.

## 🎯 Plans implémentés

### Gratuit (0€)
- 1 profil enfant
- Accès Niveau 1 seulement
- 10 exercices par jour
- Suivi de base des progrès

### Famille (6.99€/mois) - ⭐ POPULAIRE
- 5 profils enfants
- Tous les niveaux 1 → 5
- Exercices illimités
- Statistiques par opération
- Rapports de progression

### Premium (4.99€/mois)
- 2 profils enfants
- Tous les niveaux + exercices bonus
- Mode révision niveaux validés
- Défis chronométrés
- Analyse détaillée des erreurs

### École (24.99€/mois)
- 30 profils élèves
- Gestion par niveaux (1 à 5)
- Tableau de bord enseignant
- Support pédagogique dédié

## 📁 Fichiers modifiés/créés

- `apps/math4child/src/types/pricing.ts` - Types TypeScript
- `apps/math4child/src/lib/constants.ts` - Configuration des plans
- `apps/math4child/src/components/pricing/PricingComponent.tsx` - Composant React
- `apps/math4child/src/utils/pricingHelper.ts` - Utilitaires
- `tests/e2e/optimal-plans.spec.ts` - Tests Playwright

## 🔧 Utilisation

### Intégrer le composant dans votre page
```typescript
import { PricingComponent } from '@/components/pricing/PricingComponent';

const handlePlanSelect = async (planId: string, period: string) => {
  // Logique de sélection de plan
  console.log(`Plan sélectionné: ${planId}, Période: ${period}`);
};

export default function PricingPage() {
  return <PricingComponent onPlanSelect={handlePlanSelect} />;
}
```

### Lancer les tests
```bash
npm run test:optimal-plans
```

## 💰 Structure tarifaire

| Plan | Mensuel | Trimestriel | Annuel |
|------|---------|-------------|--------|
| Gratuit | 0€ | 0€ | 0€ |
| Famille | 6.99€ | 18.87€ (-37%) | 58.32€ (-51%) |
| Premium | 4.99€ | 13.47€ (-36%) | 41.94€ (-50%) |
| École | 24.99€ | 67.47€ (-25%) | 209.93€ (-42%) |

## 🎨 Personnalisation

Le composant utilise Tailwind CSS et peut être personnalisé via les props et les classes CSS.

## 🧪 Tests

Les tests Playwright couvrent :
- Affichage des 4 plans
- Changement de période
- Sélection de plans
- Vérification des fonctionnalités
- Tests d'accessibilité

## 🔄 Mise à jour

Pour modifier les prix ou fonctionnalités, éditez le fichier `apps/math4child/src/lib/constants.ts`.
