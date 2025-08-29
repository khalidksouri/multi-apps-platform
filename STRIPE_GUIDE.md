# 🚀 Guide d'utilisation Stripe Math4Child v4.2.0

## 🎯 Configuration terminée

Votre intégration Stripe est maintenant complètement configurée et fonctionnelle !

## 📁 Structure créée

```
apps/math4child/
├── src/
│   ├── app/api/stripe/
│   │   ├── create-checkout-session/route.ts  # API principale checkout
│   │   └── webhooks/route.ts                 # Gestion webhooks
│   ├── pages/api/
│   │   └── payments/create-checkout.ts       # API fallback
│   ├── lib/stripe.ts                         # Configuration + plans
│   ├── types/stripe.ts                       # Types TypeScript
│   ├── hooks/useStripe.ts                    # Hooks React
│   └── components/stripe/
│       ├── StripeTestButton.tsx              # Interface de test
│       └── DemoSuccessPage.tsx               # Page succès démo
└── .env.local                                # Variables d'environnement
```

## 🧪 Tests disponibles

### Tests automatisés
```bash
./stripe_test_complete_fixed.sh
```

### Tests manuels via composant
Ajoutez dans votre page React :
```tsx
import StripeTestButton from '@/components/stripe/StripeTestButton'

export default function TestPage() {
  return <StripeTestButton />
}
```

## 💳 Plans configurés

| Plan | Prix | Profils | Caractéristiques |
|------|------|---------|------------------|
| **BASIC** | 4,99€/mois | 1 | Fonctionnalités de base |
| **PREMIUM** | 14,99€/mois | 3 | IA + Reconnaissance + Vocal |
| **ULTIMATE** | 39,99€/mois | 10 | Toutes fonctionnalités + Support 24/7 |

## 🔧 Utilisation dans votre code

### Hook useStripe
```tsx
import { useStripe } from '@/hooks/useStripe'

function MyComponent() {
  const { loading, error, createCheckoutForPlan } = useStripe()
  
  const handleSubscribe = async () => {
    await createCheckoutForPlan('premium', 'user@example.com')
  }
  
  return (
    <button onClick={handleSubscribe} disabled={loading}>
      {loading ? 'Chargement...' : 'S\'abonner Premium'}
    </button>
  )
}
```

### API directe
```javascript
const response = await fetch('/api/stripe/create-checkout-session', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    planId: 'premium',
    email: 'user@example.com'
  })
})

const data = await response.json()
if (data.success && data.url) {
  window.location.href = data.url
}
```

## 🌐 URLs importantes

| Service | URL | Description |
|---------|-----|-------------|
| **Checkout** | `/api/stripe/create-checkout-session` | Création sessions |
| **Webhooks** | `/api/stripe/webhooks` | Événements Stripe |
| **Tests** | `/api/stripe/test` | Interface de test |
| **Démo Success** | `/demo-success` | Page succès démo |

## 🔑 Variables d'environnement

Votre fichier `.env.local` a été configuré avec :
- `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` : Clé publique
- `STRIPE_SECRET_KEY` : Clé secrète  
- `STRIPE_WEBHOOK_SECRET` : Secret webhook
- `NEXT_PUBLIC_ENABLE_STRIPE_DEMO` : Mode démo

## 🎮 Mode démo vs Production

### Mode démo (actuel)
- ✅ Pas de clés Stripe requises
- ✅ Paiements simulés
- ✅ Tests complets
- ✅ Interface de développement

### Mode production
1. Obtenez vos vraies clés Stripe
2. Mettez à jour `.env.local`
3. Configurez les webhooks
4. Testez avec des cartes de test

## 💳 Cartes de test Stripe

| Numéro | CVC | Date | Résultat |
|--------|-----|------|----------|
| `4242 4242 4242 4242` | 123 | 12/34 | ✅ Succès |
| `4000 0000 0000 0002` | 123 | 12/34 | ❌ Déclinée |
| `4000 0000 0000 9995` | 123 | 12/34 | 💰 Fonds insuffisants |

## 🔔 Webhooks Stripe

Pour configurer les webhooks en production :

1. Dashboard Stripe > Developers > Webhooks
2. Endpoint URL : `https://votre-domaine.com/api/stripe/webhooks`
3. Événements à écouter :
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
   - `checkout.session.completed`

## 🚨 Sécurité

### ✅ Bonnes pratiques implémentées
- Variables d'environnement pour les clés
- Validation des signatures webhook
- Types TypeScript stricts
- Gestion d'erreurs complète

### ❌ À éviter
- Exposer les clés secrètes côté client
- Committer les clés dans Git
- Ignorer les erreurs webhook

## 🆘 Dépannage

### Erreur 308 (redirections)
- ✅ Résolu : Routes API créées

### Erreur de clés Stripe
```bash
# Vérifiez votre fichier .env.local
cat apps/math4child/.env.local

# Testez la connectivité
curl -X POST http://localhost:3000/api/stripe/create-checkout-session \
  -H "Content-Type: application/json" \
  -d '{"planId": "basic"}'
```

### Tests échoués
1. Vérifiez que le serveur tourne : `npm run dev`
2. Vérifiez les clés dans `.env.local`
3. Relancez les tests : `./stripe_test_complete_fixed.sh`

## 📞 Support

- **Documentation Stripe** : https://stripe.com/docs
- **Dashboard Test** : https://dashboard.stripe.com/test
- **Logs webhook** : Dashboard > Developers > Webhooks > [votre endpoint]

---

**🎉 Félicitations ! Votre intégration Stripe Math4Child est opérationnelle !**

Prochaine étape : Intégrez les composants dans votre interface utilisateur.
