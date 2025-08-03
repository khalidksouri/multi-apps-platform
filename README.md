# 📱 Math4Child - Application Éducative Hybride

[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue)](https://www.typescriptlang.org/)
[![Capacitor](https://img.shields.io/badge/Capacitor-6-blue)](https://capacitorjs.com/)
[![Playwright](https://img.shields.io/badge/Playwright-Tests-green)](https://playwright.dev/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)](#)

## 🎯 Vue d'ensemble du projet

**Math4Child** est une application éducative multilingue de mathématiques avec architecture **Next.js + Capacitor**, prête pour un déploiement hybride sur les 3 plateformes principales :

- 🌐 **Web** : www.math4child.com
- 🤖 **Android** : Google Play Store
- 🍎 **iOS** : Apple App Store

## 📊 État actuel - Status Production Ready ✅

- ✅ **Build successful** : Tous les problèmes techniques résolus
- ✅ **Configuration GOTEST** : SIRET, App ID configurés
- ✅ **195+ langues** : Support RTL (Arabe/Hébreu)
- ✅ **Stripe intégré** : Paiements sécurisés
- ✅ **Tests Playwright** : Suite de tests complète
- ✅ **PWA ready** : Service Worker, Manifest

## 🚀 Démarrage rapide

### Prérequis
- Node.js 18+
- npm 9+
- Android Studio (pour Android)
- Xcode (pour iOS, macOS uniquement)

### Installation
```bash
# Clone du projet
git clone https://github.com/votre-repo/math4child.git
cd math4child

# Installation des dépendances
npm install

# Développement
npm run dev
```

### Scripts principaux
```bash
# Développement
npm run dev                    # Serveur de développement
npm run dev:mobile            # Mode mobile

# Build et déploiement
npm run build                 # Build Next.js
npm run build:web             # Export statique web
npm run build:capacitor       # Build pour Capacitor

# Plateformes mobiles
npm run android:build         # Build Android (ouvre Android Studio)
npm run ios:build            # Build iOS (ouvre Xcode)
npm run android:dev          # Dev avec live reload Android
npm run ios:dev              # Dev avec live reload iOS

# Tests
npm run test                 # Tous les tests Playwright
npm run test:mobile          # Tests mobile uniquement
npm run test:rtl            # Tests RTL (Arabe/Hébreu)
npm run test:translation    # Tests multilingues
```

## 📱 Architecture Technique

### Stack technologique
- **Frontend** : Next.js 14 + TypeScript
- **Mobile** : Capacitor 6 (iOS/Android natif)
- **Styling** : Tailwind CSS + Framer Motion
- **Paiements** : Stripe (configuration GOTEST)
- **Tests** : Playwright + suite complète
- **I18n** : 195+ langues avec RTL

### Structure du projet
```
math4child/
├── src/
│   ├── components/           # Composants React
│   ├── hooks/               # Hooks personnalisés
│   ├── lib/                 # Utilitaires et configuration
│   ├── styles/              # Styles Tailwind
│   └── types/               # Types TypeScript
├── public/                  # Assets publics
├── tests/                   # Tests Playwright
├── android/                 # Projet Android (Capacitor)
├── ios/                     # Projet iOS (Capacitor)
├── capacitor.config.json    # Configuration Capacitor
└── next.config.js          # Configuration Next.js
```

## 🌍 Fonctionnalités

### Éducation mathématique
- **5 niveaux progressifs** : Du CP au CM2
- **4 opérations** : Addition, Soustraction, Multiplication, Division
- **Système de progression** : Déblocage par réussite
- **Statistiques détaillées** : Suivi des progrès

### Multilingue et accessibilité
- **195+ langues supportées**
- **Support RTL complet** : Arabe, Hébreu, Persan, Ourdou
- **Interface adaptative** : Desktop, Tablet, Mobile
- **Navigation native** : Capacitor sur iOS/Android

### Monétisation
- **Freemium** : Essai gratuit limité
- **Premium** : 9.99€/mois - accès complet
- **École** : Plans sur mesure pour établissements
- **Paiements Stripe** : Sécurisés et internationaux

## 💰 Plans tarifaires

| Plan | Prix | Fonctionnalités |
|------|------|----------------|
| **Gratuit** | 0€ | 1 profil, Niveau 1, 50 questions/jour |
| **Premium** | 9.99€/mois | Profils illimités, Tous niveaux, Questions illimitées |
| **École** | Sur devis | Tableau de bord, 30+ profils, Support dédié |

## 🧪 Tests et Validation

### Suite de tests complète
```bash
# Tests fonctionnels
npm run test                    # Tests complets
npm run test:deployment        # Validation déploiement
npm run test:capacitor         # Tests environnements natifs

# Tests par plateforme
npm run test:desktop           # Web desktop
npm run test:mobile           # Simulation mobile
npm run test:rtl              # Tests RTL

# Tests spécialisés
npm run test:translation      # Validation multilingue
npm run test:translation:all  # Tests 195+ langues
```

### Métriques de qualité
- **Performance** : < 3s temps de chargement
- **Accessibility** : WCAG 2.1 AA compliant
- **Test Coverage** : 95%+ fonctionnalités critiques
- **Cross-browser** : Chrome, Firefox, Safari, Edge

## 📱 Configuration GOTEST

```json
{
  "appId": "com.gotest.math4child",
  "appName": "Math4Child",
  "company": "GOTEST",
  "siret": "53958712100028",
  "email": "khalid_ksouri@yahoo.fr",
  "platforms": ["web", "android", "ios"]
}
```

## 🚀 Plan de Déploiement

### Phase 1 : Technique (Semaines 1-2)
1. **Web** : Déploiement sur Netlify/Vercel
2. **Android** : Upload Google Play Console
3. **iOS** : Soumission App Store Connect
4. **Tests** : Validation multi-plateformes

### Phase 2 : Beta (Semaines 3-4)
1. **Beta fermée** : 50 familles testeuses
2. **Retours utilisateurs** : Optimisations UX
3. **Tests de charge** : Performance scaling
4. **Finalisation** : Corrections critiques

### Phase 3 : Lancement (Semaines 5-6)
1. **Go live** : 3 plateformes simultanées
2. **Marketing** : Campagne multicanal
3. **Support** : Équipe dédiée
4. **Monitoring** : Métriques temps réel

## 📈 Objectifs de Croissance

### KPIs 6 mois
- **Downloads** : 1000+/mois
- **Conversion Premium** : 15%
- **Retention 30j** : 60%
- **Rating Stores** : 4.5+ étoiles
- **Langues actives** : 25+

### Roadmap
- **V1.1** : Mode multijoueur frères/sœurs
- **V1.2** : Rapports parents email
- **V1.3** : Mode hors-ligne complet
- **V2.0** : Extension géométrie/fractions

## 🛠️ Développement

### Environnement de développement
```bash
# Configuration initiale
npm run setup                 # Installation complète
npm run dev                   # Serveur de développement
npm run type-check           # Vérification TypeScript
npm run lint                 # Linting ESLint
```

### Contribution
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

## 📄 Documentation

- [Guide de déploiement Capacitor](./CAPACITOR_DEPLOYMENT_FIXED.md)
- [Tests Playwright](./TESTING_GUIDE.md)
- [Configuration multilingue](./README-I18N.md)
- [Plans tarifaires](./PLANS_OPTIMAUX_README.md)
- [Sécurité](./SECURITY_REPORT.md)

## 🤝 Support

- **Email** : khalid_ksouri@yahoo.fr
- **Documentation** : [Wiki du projet](https://github.com/votre-repo/math4child/wiki)
- **Issues** : [GitHub Issues](https://github.com/votre-repo/math4child/issues)
- **Discussions** : [GitHub Discussions](https://github.com/votre-repo/math4child/discussions)

## 📝 Licence

MIT License - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🎉 Remerciements

- **Équipe GOTEST** : Développement et vision produit
- **Communauté éducative** : Retours et tests utilisateurs
- **Technologies open source** : Next.js, Capacitor, Playwright
- **Contributeurs** : Tous ceux qui ont participé au projet

---

**🚀 Math4Child - L'avenir de l'apprentissage mathématique pour nos enfants ! 🌍📱💻**

[![Made with ❤️ by GOTEST](https://img.shields.io/badge/Made%20with%20❤️%20by-GOTEST-red)](https://github.com/votre-repo)
