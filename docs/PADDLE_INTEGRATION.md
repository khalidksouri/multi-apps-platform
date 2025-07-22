# 🚀 Intégration Paddle pour Math4Child

## 📋 Vue d'ensemble

Cette intégration ajoute le support complet de Paddle comme provider de paiement pour Math4Child, avec :
- Plans mensuels, trimestriels et annuels
- Interface utilisateur avec sélecteur d'intervalle
- API routes sécurisées
- Tests automatisés

## 🏗️ Architecture

```
src/
├── lib/paddle/
│   ├── plans.ts          # Configuration des plans
│   └── checkout.ts       # Logique de checkout
├── components/pricing/
│   ├── PricingComponent.tsx   # Composant principal
│   ├── IntervalSelector.tsx   # Sélecteur d'intervalle
│   └── PlanCard.tsx          # Carte de plan
├── types/
│   └── paddle.ts         # Types TypeScript
└── [app|pages]/api/payments/
    └── create-checkout    # API de création de checkout
```

## 🔧 Configuration

### 1. Variables d'environnement
```bash
PADDLE_API_KEY=your_paddle_api_key
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token
NEXT_PUBLIC_APP_URL=https://www.math4child.com
```

### 2. IDs des produits Paddle
Remplacez les IDs factices dans `src/lib/paddle/plans.ts` par vos vrais IDs Paddle :
```typescript
priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p7r' // ← Remplacer
```

## 🚀 Utilisation

### Dans votre composant de pricing
```typescript
import { PricingComponent } from '@/components/pricing/PricingComponent'

export default function PricingPage() {
  const handlePlanSelect = async (planType: string, interval: string) => {
    // Votre logique de sélection de plan
  }

  return <PricingComponent onPlanSelect={handlePlanSelect} />
}
```

## 🧪 Tests

```bash
# Lancer tous les tests
npm run test:e2e

# Tests Paddle uniquement
npm run test:paddle
```

## 📊 Plans disponibles

| Plan | Mensuel | Trimestriel | Annuel |
|------|---------|-------------|--------|
| Famille | 6.99€ | 18.87€ (-10%) | 58.32€ (-30%) |
| Premium | 4.99€ | 13.47€ (-10%) | 41.94€ (-30%) |
| École | 24.99€ | 67.47€ (-10%) | 209.93€ (-30%) |

## 🔒 Sécurité

- ✅ Validation côté serveur
- ✅ Webhooks sécurisés
- ✅ Gestion des erreurs
- ✅ Types TypeScript stricts

## 🛠️ Maintenance

### Mise à jour des prix
1. Modifier `src/lib/paddle/plans.ts`
2. Mettre à jour les tests
3. Tester en développement

### Ajout d'un nouveau plan
1. Ajouter dans `PADDLE_PLANS`
2. Créer le produit dans Paddle
3. Mettre à jour l'interface utilisateur
