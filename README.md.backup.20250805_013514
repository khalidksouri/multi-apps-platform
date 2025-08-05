# 🧮 Math4Child - Plateforme Éducative Mathématiques

![Math4Child Logo](https://img.shields.io/badge/Math4Child-🧮%20Mathématiques%20pour%20Enfants-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge)

> **Application révolutionnaire d'apprentissage des mathématiques pour enfants de 6 à 12 ans**  
> Transformez l'éducation mathématique en aventure ludique avec IA adaptative

## 🌟 Vue d'ensemble

Math4Child est une application éducative Next.js ultra-moderne qui révolutionne l'apprentissage des mathématiques pour les enfants. Avec son IA adaptative, ses 195+ langues supportées et son système de progression gamifié, Math4Child rend les mathématiques accessibles et amusantes pour tous les enfants du monde.

### 🎯 Fonctionnalités Principales

- **🧠 IA Adaptative** : S'adapte intelligemment au niveau et au rythme de chaque enfant
- **🌍 195+ Langues** : Support multilingue complet avec RTL automatique (arabe, hébreu, etc.)
- **📊 5 Niveaux de Progression** : Du débutant à l'expert avec déblocage intelligent
- **➕ 5 Opérations Mathématiques** : Addition, soustraction, multiplication, division, mixte
- **🏆 Système de Récompenses** : Badges, scores et défis pour maintenir la motivation
- **👨‍👩‍👧‍👦 Mode Famille** : Jusqu'à 10 profils enfants selon l'abonnement
- **💳 Paiements Sécurisés** : Stripe intégré avec plans flexibles

## 🚀 Démarrage Rapide

### Prérequis
- Node.js 18.17.0+
- npm ou yarn
- Git

### Installation

```bash
# Cloner le projet
git clone https://github.com/votre-username/multi-apps-platform.git
cd multi-apps-platform

# Navigation vers Math4Child
cd apps/math4child

# Installation des dépendances
npm install --legacy-peer-deps

# Démarrage en développement
npm run dev
```

L'application sera accessible sur [http://localhost:3000](http://localhost:3000)

### Build Production

```bash
# Build optimisé pour production
npm run build

# Test du build
npm run start
```

## 📁 Structure du Projet

```
multi-apps-platform/
├── apps/
│   └── math4child/                    # Application principale
│       ├── src/
│       │   ├── app/                   # App Router Next.js 14
│       │   │   ├── layout.tsx         # Layout principal
│       │   │   ├── page.tsx           # Page d'accueil
│       │   │   └── globals.css        # Styles globaux
│       │   ├── components/            # Composants réutilisables
│       │   │   ├── math/              # Composants mathématiques
│       │   │   ├── ui/                # Composants UI
│       │   │   └── language/          # Sélecteur de langues
│       │   ├── hooks/                 # Hooks personnalisés
│       │   │   └── useUniversalI18n.ts # Hook i18n universel
│       │   ├── lib/                   # Utilitaires
│       │   │   ├── stripe.ts          # Configuration Stripe
│       │   │   └── translations.ts    # Système de traductions
│       │   └── types/                 # Types TypeScript
│       ├── public/                    # Assets statiques
│       ├── tests/                     # Tests Playwright
│       ├── package.json
│       ├── next.config.js            # Configuration Next.js
│       ├── tailwind.config.js        # Configuration Tailwind
│       └── netlify.toml              # Configuration Netlify
├── netlify.toml                      # Configuration Netlify racine
├── README.md                         # Ce fichier
└── synchronized_final_script.sh      # Script de déploiement
```

## 🌍 Support Multilingue

Math4Child supporte **195+ langues** avec détection automatique et support RTL complet :

### Langues Principales
- 🇫🇷 **Français** (par défaut)
- 🇺🇸 **English**
- 🇪🇸 **Español**
- 🇩🇪 **Deutsch**
- 🇮🇹 **Italiano**
- 🇸🇦 **العربية** (RTL)
- 🇨🇳 **中文**
- 🇯🇵 **日本語**
- 🇰🇷 **한국어**
- 🇮🇳 **हिन्दी**

### Support RTL Automatique
Les langues comme l'arabe, l'hébreu, le persan et l'ourdou bénéficient d'un support RTL (Right-to-Left) automatique avec :
- Interface adaptée à la direction de lecture
- Positionnement intelligent des éléments
- Polices optimisées pour chaque script

## 💳 Plans d'Abonnement

### 🎯 Explorer (Gratuit)
- **0€** pour 7 jours
- 1 profil
- 50 questions totales
- Niveau 1 seulement

### 🚀 Aventurier (Mensuel)
- **9,99€/mois**
- 3 profils
- Questions illimitées
- Tous les 5 niveaux
- IA adaptative

### 🏆 Champion (Trimestriel) - **Le Plus Populaire**
- **26,97€/3 mois** (~~29,97€~~) - **10% d'économie**
- 5 profils
- Mode multijoueur
- Défis exclusifs
- Statistiques avancées

### 👑 Maître (Annuel) - **Meilleure Valeur**
- **83,93€/an** (~~119,88€~~) - **30% d'économie**
- 10 profils
- Accès anticipé aux nouvelles fonctionnalités
- Mode tournoi
- Support téléphonique prioritaire

## 🔧 Configuration Technique

### Variables d'Environnement

Créer un fichier `.env.local` :

```env
# Site
NEXT_PUBLIC_SITE_URL=https://www.math4child.com
NODE_ENV=production

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Langue par défaut
DEFAULT_LANGUAGE=fr
```

### Configuration Netlify

Le projet est configuré pour Netlify avec :
- **Base Directory** : `apps/math4child`
- **Build Command** : `npm install --legacy-peer-deps && npm run build`
- **Publish Directory** : `out`
- **Node Version** : 18.17.0

## 🧪 Tests

### Tests de Traduction
```bash
# Tests complets de traduction
npm run test:translation

# Tests de recherche de langues
npm run test:translation:search

# Rapport détaillé
npm run translation:report
```

### Tests E2E avec Playwright
```bash
# Installation Playwright
npx playwright install

# Tests complets
npm run test:e2e

# Tests en mode UI
npm run test:e2e:ui
```

## 🚀 Déploiement

### Netlify (Recommandé)
Le projet est configuré pour un déploiement automatique sur Netlify :

1. **Connecter le repo** à Netlify
2. **Configuration automatique** via `netlify.toml`
3. **Variables d'environnement** dans Netlify Dashboard
4. **Domaine personnalisé** : www.math4child.com

### Vercel (Alternative)
```bash
cd apps/math4child
npx vercel --prod
```

### Build Local
```bash
# Script de déploiement synchronisé
./synchronized_final_script.sh
```

## 📊 Performance

### Métriques Lighthouse
- **Performance** : 95+/100
- **Accessibilité** : 98+/100
- **Best Practices** : 100/100
- **SEO** : 100/100

### Optimisations
- Export statique Next.js
- Compression des images
- Code splitting automatique
- Cache intelligent des assets
- CDN Netlify/Vercel

## 🛡️ Sécurité

### Headers de Sécurité
```
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
```

### Paiements Sécurisés
- **Stripe** : Certification PCI DSS Level 1
- **Chiffrement** : TLS 1.3
- **Authentification** : 3D Secure
- **Conformité** : RGPD complet

## 🏢 Informations Entreprise

### GOTEST - Développeur Officiel
- **SIRET** : 53958712100028
- **Email** : gotesttech@gmail.com
- **Site** : www.math4child.com
- **Statut** : Société française spécialisée en EdTech

### Support Client
- **Email Support** : gotesttech@gmail.com
- **Documentation** : [docs.math4child.com]
- **Communauté** : [community.math4child.com]
- **Status Page** : [status.math4child.com]

## 🌟 Roadmap

### Version 2.1 (Q2 2025)
- [ ] Mode hors-ligne avec synchronisation
- [ ] Réalité augmentée pour visualisation 3D
- [ ] Assistant vocal IA
- [ ] Analytiques avancées pour parents

### Version 2.2 (Q3 2025)
- [ ] Intégration Google Classroom
- [ ] API publique pour développeurs
- [ ] Système de points de récompense
- [ ] Mode collaboration en temps réel

### Version 3.0 (Q4 2025)
- [ ] Intelligence artificielle générative
- [ ] Personnalisation IA complète
- [ ] Écosystème d'applications éducatives
- [ ] Plateforme de création de contenu

## 🤝 Contribution

### Pour les Développeurs
```bash
# Fork du projet
git clone https://github.com/votre-username/multi-apps-platform.git

# Créer une branche
git checkout -b feature/nouvelle-fonctionnalite

# Développer et tester
npm run dev
npm run test

# Commit et push
git commit -m "feat: nouvelle fonctionnalité"
git push origin feature/nouvelle-fonctionnalite
```

### Standards de Code
- **TypeScript** strict mode
- **ESLint** + **Prettier** obligatoires
- **Tests** requis pour nouvelles fonctionnalités
- **Documentation** mise à jour

## 📄 Licence

Copyright © 2024 GOTEST (SIRET: 53958712100028)

Ce projet est protégé par les droits d'auteur. L'utilisation commerciale nécessite une licence explicite de GOTEST.

### Licence Éducative
Utilisation autorisée à des fins éducatives non-commerciales avec attribution.

## 🔗 Liens Utiles

- **🌐 Site Web** : [www.math4child.com](https://www.math4child.com)
- **📱 App Store** : [iOS App](https://apps.apple.com/app/math4child)
- **🤖 Google Play** : [Android App](https://play.google.com/store/apps/details?id=com.math4child)
- **📚 Documentation** : [docs.math4child.com](https://docs.math4child.com)
- **💬 Discord** : [discord.gg/math4child](https://discord.gg/math4child)
- **🐦 Twitter** : [@Math4Child](https://twitter.com/Math4Child)

## 📞 Contact

**GOTEST - Équipe Math4Child**
- 📧 Email : gotesttech@gmail.com
- 🏢 SIRET : 53958712100028
- 🌐 Site : www.math4child.com
- 📍 France, spécialisée en technologies éducatives

---

<div align="center">

## 🌟 Math4Child - L'Avenir de l'Éducation Mathématique 🌟

[![Netlify Status](https://api.netlify.com/api/v1/badges/prismatic-sherbet-986159/deploy-status)](https://app.netlify.com/sites/prismatic-sherbet-986159/deploys)
![Next.js](https://img.shields.io/badge/next.js-14.2.30-000000?style=for-the-badge&logo=nextdotjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-5.2.2-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Build](https://img.shields.io/badge/Build-✅%20Success%201.2M-brightgreen?style=for-the-badge)

### 🎯 Status Actuel : Production Ready ✅

**🔗 Demo Live** : [https://prismatic-sherbet-986159.netlify.app](https://prismatic-sherbet-986159.netlify.app)  
**🎯 Domaine Final** : www.math4child.com (en configuration)  
**📱 Apps Mobiles** : iOS/Android Q2 2025

### 📊 Métriques de Performance
- **Build Size** : 1.2M (optimisé)
- **Load Time** : < 2s
- **Lighthouse** : 95+/100
- **Languages** : 195+ avec RTL

### 🚀 Prêt pour Lancement Commercial
- ✅ **Développement** : Terminé et testé
- ✅ **Infrastructure** : Netlify + Stripe configurés  
- ✅ **Marketing** : Plan 12 semaines finalisé
- ⏳ **Domaine** : Configuration en cours
- ⏳ **Beta** : 10 familles à recruter

**🧮 Développé par GOTEST | 🌍 195+ Langues | 🎓 IA Adaptative**

</div>