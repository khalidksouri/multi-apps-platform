# 🧪 Tests de Paiement Stripe - Math4Child

Cette documentation explique comment utiliser la page de test des paiements Stripe.

## 🚀 Accès

Rendez-vous sur : `http://localhost:3000/stripe-test`

## 💳 Cartes de Test Stripe

### Scénarios de Test Disponibles

| Numéro de Carte | Scénario | Description |
|----------------|----------|-------------|
| `4242 4242 4242 4242` | ✅ Succès | Paiement réussi |
| `4000 0000 0000 0002` | ❌ Déclinée | Carte déclinée |
| `4000 0000 0000 9995` | 💸 Fonds insuffisants | Solde insuffisant |
| `4000 0000 0000 0069` | ⏰ Expirée | Carte expirée |
| `4000 0000 0000 0127` | 🔒 CVC incorrect | Code de sécurité invalide |
| `4000 0000 0000 0119` | 🔄 Processus échoué | Erreur de traitement |

### Informations Complémentaires pour les Tests

- **Date d'expiration** : N'importe quelle date future (ex: 12/25)
- **CVC** : N'importe quel nombre à 3 chiffres (ex: 123)  
- **Nom** : N'importe quel nom
- **Code postal** : N'importe quel code postal valide

## 📋 Plans de Test

### Plans Disponibles

1. **Plan Famille** (Populaire)
   - Mensuel : €6.99/mois
   - Annuel : €59.90/an (soit €4.99/mois)
   - 5 profils enfant, Questions illimitées, Support prioritaire

2. **Plan Premium**
   - Mensuel : €4.99/mois  
   - Annuel : €39.90/an (soit €3.33/mois)
   - 2 profils enfant, Questions illimitées, Mode hors-ligne

3. **Plan École**
   - Mensuel : €24.99/mois
   - Annuel : €199.90/an (soit €16.66/mois)
   - 30 élèves, Tableau de bord professeur, Rapports détaillés

## 🧪 Comment Tester

1. **Choisir un plan** et un **scénario de test**
2. **Cliquer** sur le bouton de test correspondant
3. **Redirection** automatique vers Stripe Checkout (nouvel onglet)
4. **Utiliser** les numéros de carte ci-dessus
5. **Observer** le comportement selon le scénario choisi

## 🔍 Que Vérifier

- ✅ Redirection correcte vers Stripe
- ✅ Gestion des erreurs de paiement  
- ✅ Page de succès après paiement
- ✅ Interface responsive sur mobile
- ✅ Copie des numéros de carte
- ✅ Toggle mensuel/annuel

## 🛠️ Configuration Technique

### Variables d'Environnement

```bash
# .env.local
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
NEXT_PUBLIC_BASE_URL=http://localhost:3000
```

### API Endpoints

- `POST /api/stripe/create-checkout-session` - Créer une session de paiement
- `GET /api/stripe/create-checkout-session` - Vérifier l'état de l'API

### Mode Développement

En mode développement (`NODE_ENV=development`), l'API simule les réponses Stripe sans effectuer de vrais appels API.

## 🧪 Tests Automatisés

Lancer les tests Playwright :

```bash
npx playwright test tests/stripe/stripe-payment.spec.ts
```

## 🚨 Important

- **Mode Test Uniquement** - Aucun paiement réel n'est effectué
- **Cartes Fictives** - Utilisez uniquement les numéros fournis par Stripe
- **Développement** - Cette page n'est disponible qu'en mode développement

## 📞 Support

En cas de problème avec les tests de paiement, vérifiez :

1. Configuration des variables d'environnement
2. Connexion internet stable
3. Console du navigateur pour les erreurs JavaScript
4. Logs du serveur Next.js
