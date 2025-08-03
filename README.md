# 🎯 Math4Child - Plateforme Éducative Multilingue

> **Application éducative révolutionnaire pour l'apprentissage des mathématiques**  
> Développée par GOTEST (SIRET: 53958712100028)

[![Statut](https://img.shields.io/badge/Statut-Production%20Ready-brightgreen)](http://localhost:3001)
[![Langues](https://img.shields.io/badge/Langues-24%20Supportées-blue)](#)
[![Système de Paiement](https://img.shields.io/badge/Stripe-Intégré-purple)](#)
[![Tests](https://img.shields.io/badge/Tests-Playwright-orange)](#)

## 🚀 Vue d'ensemble

Math4Child est une application éducative complète qui révolutionne l'apprentissage des mathématiques pour les enfants. Elle combine gamification, technologie moderne et pédagogie adaptative pour créer une expérience d'apprentissage unique et engageante.

### ✨ Caractéristiques principales

- **🌍 Support multilingue** : 24 langues avec interface RTL complète
- **💳 Système de paiement** : Intégration Stripe avec plans flexibles
- **🎮 Gamification** : Badges, récompenses et défis motivants
- **📊 Analyse adaptative** : Ajustement automatique au niveau de l'enfant
- **👨‍👩‍👧‍👦 Plans famille** : Jusqu'à 6 profils enfants
- **📱 Responsive design** : Interface optimisée mobile et desktop

## 🏗️ Architecture Technique

```
apps/math4child/
├── 📁 src/
│   ├── 📁 app/                    # App Router Next.js 14
│   │   ├── 📄 layout.tsx          # Layout principal
│   │   ├── 📄 page.tsx            # Page d'accueil
│   │   └── 📁 api/                # Routes API
│   │       └── 📁 stripe/         # API Stripe
│   ├── 📁 components/             # Composants React
│   │   ├── 📁 payment/            # Système de paiement
│   │   └── 📄 LanguageSelector.tsx # Sélecteur multilingue
│   ├── 📁 hooks/                  # Hooks personnalisés
│   │   └── 📄 useTranslation.ts   # Système i18n
│   ├── 📁 types/                  # Types TypeScript
│   ├── 📁 lib/                    # Utilitaires
│   │   └── 📄 stripe.ts           # Configuration Stripe
│   └── 📄 translations.ts         # Traductions
├── 📁 scripts/                    # Scripts d'automatisation
└── 📄 package.json               # Configuration npm
```

## 🛠️ Installation et Lancement

### Prérequis
- Node.js >= 18.0.0
- npm >= 9.0.0
- Compte Stripe (pour les paiements)

### Installation rapide

```bash
# Cloner et naviguer
cd apps/math4child

# Installation des dépendances
npm install

# Configuration environnement
cp .env.example .env.local
# Éditer .env.local avec vos clés Stripe

# Lancement développement
npm run dev
```

### Scripts disponibles

```bash
# 🚀 Correction automatique des dépendances Stripe
./fix_stripe_dependencies.sh

# 🎨 Enrichissement complet (24 langues + fonctionnalités)
./enhance_math4child_full.sh

# 💳 Installation système de paiement complet
./payment_system_math4child.sh

# 🔗 Intégration avec infrastructure Stripe existante
./integrate_existing_stripe.sh

# 🔧 Correction erreurs de configuration
./fix_language_config_error.sh

# 📊 Diagnostic complet
./debug_math4child_startup.sh
```

## 🌍 Système Multilingue Avancé

### Langues supportées (24 langues)

| Région | Langues | Support RTL |
|--------|---------|-------------|
| **Europe (13)** | 🇫🇷 Français, 🇺🇸 English, 🇪🇸 Español, 🇩🇪 Deutsch, 🇮🇹 Italiano, 🇵🇹 Português, 🇳🇱 Nederlands, 🇷🇺 Русский, 🇵🇱 Polski, 🇸🇪 Svenska, 🇩🇰 Dansk, 🇳🇴 Norsk, 🇫🇮 Suomi | Non |
| **Asie (6)** | 🇨🇳 中文, 🇯🇵 日本語, 🇰🇷 한국어, 🇮🇳 हिन्दी, 🇹🇭 ไทย, 🇻🇳 Tiếng Việt | Non |
| **Moyen-Orient (4)** | 🇸🇦 العربية, 🇮🇱 עברית, 🇮🇷 فارسی, 🇵🇰 اردو | **Oui** |
| **Autres (1)** | 🇹🇷 Türkçe | Non |

### Fonctionnalités i18n

- **Persistance automatique** : Langue sauvegardée dans localStorage
- **Détection intelligente** : Langue du navigateur auto-détectée
- **Interface RTL complète** : Support droite-à-gauche
- **Sélecteur avancé** : Recherche et groupement par région
- **Fallback robuste** : Français → Anglais → Clé par défaut

## 💳 Système de Paiement Stripe

### Plans d'abonnement

| Plan | Prix | Profils | Fonctionnalités |
|------|------|---------|-----------------|
| **Gratuit** | 0€ | 1 | Exercices de base, 50 questions/semaine |
| **Premium** | 9,99€/mois | 3 | Tous exercices, questions illimitées, stats avancées |
| **Premium Annuel** | 99,99€/an | 3 | Premium + 2 mois gratuits (17% économie) |
| **Famille** | 19,99€/mois | 6 | Tableau de bord famille, mode compétition |
| **Famille Annuel** | 199,99€/an | 6 | Famille + 3 mois gratuits (25% économie) |

### Fonctionnalités paiement

- **Checkout sécurisé** : Formulaire de facturation complet
- **Méthodes de paiement** : Carte, PayPal, SEPA
- **Multi-devises** : Adaptation automatique par région
- **Essai gratuit** : 14 jours pour tous les plans payants
- **Facturation automatique** : Renouvellement transparent

## 🎮 Fonctionnalités Éducatives

### Apprentissage adaptatif
- **Niveaux dynamiques** : Débutant → Intermédiaire → Avancé → Expert → Maître
- **Algorithme d'adaptation** : Ajustement en temps réel selon les performances
- **Parcours personnalisés** : Recommandations basées sur les forces/faiblesses

### Opérations mathématiques
- ➕ **Addition** : Nombres simples aux fractions
- ➖ **Soustraction** : Avec retenues et nombres négatifs
- ✖️ **Multiplication** : Tables jusqu'aux nombres décimaux
- ➗ **Division** : Euclidienne et décimale

### Gamification
- 🏆 **Système de badges** : 50+ badges à débloquer
- 🔥 **Streaks** : Motivation par séries de réussites
- 🎯 **Défis quotidiens** : Objectifs renouvelés
- 📊 **Classements** : Compétition saine entre profils

## 🔧 Configuration et Personnalisation

### Variables d'environnement

```bash
# Application
NEXT_PUBLIC_SITE_URL=http://localhost:3001
NODE_ENV=development
PORT=3001

# Business GOTEST
BUSINESS_NAME=GOTEST
BUSINESS_SIRET=53958712100028
BUSINESS_EMAIL=khalid_ksouri@yahoo.fr

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Base de données (optionnel)
DATABASE_URL=postgresql://...

# Email (optionnel)
SMTP_HOST=smtp.gmail.com
SMTP_USER=khalid_ksouri@yahoo.fr
```

### Configuration Stripe

1. **Créer les produits dans Stripe Dashboard**
2. **Configurer les webhooks** : `${SITE_URL}/api/stripe/webhooks`
3. **Events nécessaires** :
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `checkout.session.completed`

## 🧪 Tests et Qualité

### Tests Playwright intégrés

```bash
# Installation Playwright
npm install @playwright/test

# Lancement des tests
npm run test

# Tests spécifiques
npm run test:payment    # Tests système de paiement
npm run test:i18n      # Tests multilingues
npm run test:ui        # Tests interface utilisateur
```

### Validation de code

```bash
# TypeScript
npm run type-check

# Linting
npm run lint

# Build de production
npm run build
```

## 📊 Monitoring et Analytics

### Métriques suivies
- **Temps d'engagement** par session
- **Taux de réussite** par niveau/opération
- **Progression** des utilisateurs
- **Conversion** des plans gratuits vers payants
- **Utilisation** par langue/région

### Logs structurés
- **Actions utilisateur** : Connexion, changement de langue, exercices
- **Paiements** : Tentatives, réussites, échecs
- **Erreurs** : Capture et traçabilité complète

## 🚀 Déploiement

### Environnements

| Environnement | URL | Status |
|---------------|-----|--------|
| **Développement** | http://localhost:3001 | ✅ Actif |
| **Test** | https://test.math4child.com | 🔄 En cours |
| **Production** | https://www.math4child.com | 🎯 Objectif |

### Déploiement Netlify

```bash
# Build de production
npm run build

# Déploiement automatique
git push origin main
```

### Variables de production
- Remplacer les clés Stripe test par production
- Configurer le DNS personnalisé
- Activer SSL automatique
- Configurer les redirections

## 🛡️ Sécurité

### Mesures implémentées
- **Validation d'entrées** : Sanitisation côté client et serveur
- **Protection CSRF** : Tokens sécurisés
- **Headers de sécurité** : CSP, HSTS, X-Frame-Options
- **Rate limiting** : Protection contre le spam
- **Chiffrement** : HTTPS obligatoire en production

### Données sensibles
- **Informations de paiement** : Jamais stockées (Stripe uniquement)
- **Données utilisateurs** : Chiffrées en base
- **Sessions** : JWT sécurisés avec expiration

## 🐛 Dépannage

### Problèmes courants

| Problème | Solution |
|----------|----------|
| **Erreur npm config** | `./fix_npm_config_issue.sh` |
| **Erreur SUPPORTED_LANGUAGES** | `./fix_language_config_error.sh` |
| **Dépendances Stripe manquantes** | `./fix_stripe_dependencies.sh` |
| **Build échoue** | `./debug_math4child_startup.sh` |

### Logs de diagnostic

```bash
# Logs du serveur
tail -f dev.log

# Logs Stripe
tail -f stripe-fix.log

# Logs d'intégration
tail -f integration.log
```

## 📞 Support et Contribution

### Contact GOTEST
- **Email** : khalid_ksouri@yahoo.fr
- **SIRET** : 53958712100028
- **IBAN** : FR7616958000016218830371501

### Contribution
1. Fork du repository
2. Création d'une branche feature
3. Tests complets
4. Pull request avec description détaillée

### Roadmap

#### Q1 2024
- [x] Système multilingue (24 langues)
- [x] Intégration Stripe complète
- [x] Interface responsive
- [x] Tests Playwright

#### Q2 2024
- [ ] Mode hors ligne (PWA)
- [ ] API publique pour développeurs
- [ ] Intégration IA pour personnalisation
- [ ] Application mobile native

#### Q3 2024
- [ ] Tableau de bord enseignant
- [ ] Rapports avancés parents
- [ ] Marketplace d'exercices
- [ ] Certification pédagogique

## 📄 Licences et Crédits

### Licences
- **Code source** : Propriétaire GOTEST
- **Dépendances** : Voir package.json pour licences individuelles
- **Assets éducatifs** : Créés spécifiquement pour Math4Child

### Technologies utilisées
- **Framework** : Next.js 14 (App Router)
- **UI** : React 18 + TypeScript
- **Styles** : Tailwind CSS
- **Paiements** : Stripe
- **Tests** : Playwright
- **Déploiement** : Netlify

---

## 🎯 Statut Actuel : Production Ready ✅

Math4Child est **entièrement fonctionnelle** et prête pour la production avec :

- ✅ **24 langues supportées** avec interface RTL
- ✅ **Système de paiement Stripe** opérationnel
- ✅ **Tests automatisés** complets
- ✅ **Interface responsive** optimisée
- ✅ **Documentation complète** et scripts d'automatisation
- ✅ **Sécurité robuste** et monitoring intégré

**Dernière mise à jour** : Juillet 2025  
**Version** : 2.0.0  
**Statut** : ✨ Production Ready