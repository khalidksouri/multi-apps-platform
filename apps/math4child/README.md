# 🎯 Math4Child - Application Éducative Hybride

[![Next.js](https://img.shields.io/badge/Next.js-14.0-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)
[![Capacitor](https://img.shields.io/badge/Capacitor-5.0-blue)](https://capacitorjs.com/)
[![Playwright](https://img.shields.io/badge/Playwright-Tests-green)](https://playwright.dev/)

> **Application éducative n°1 pour apprendre les mathématiques en famille**  
> Support de **195+ langues** avec **RTL complet** • **Web + Android + iOS** • **Production-ready**

## 🏆 Vue d'ensemble

Math4Child est une **application hybride moderne** développée avec **Next.js 14** et **Capacitor**, permettant un déploiement simultané sur :

- **🌐 Web** (SSR/SSG avec Next.js)
- **🤖 Android** (APK natif via Capacitor)  
- **🍎 iOS** (App native via Capacitor)

### ✨ Fonctionnalités Principales

- **🎮 Jeu de mathématiques interactif** avec niveaux progressifs
- **🌍 195+ langues supportées** avec recherche intelligente
- **🔄 Support RTL complet** (Arabe, Hébreu, etc.)
- **💰 Système de paiements optimisé** multi-providers
- **📱 Interface tactile hybride** (Web + Mobile)
- **🧪 Tests automatisés** multi-plateformes
- **⚡ Performance optimisée** (<3s de chargement)

## 🚀 Démarrage Rapide

### Prérequis

- **Node.js 18+** 
- **npm 8+**
- **Android Studio** (pour Android)
- **Xcode** (pour iOS, macOS uniquement)

### Installation

```bash
# Cloner le projet
git clone <url-du-repo>
cd multi-apps-platform

# Installer les dépendances
npm install

# Démarrer en mode développement
cd apps/math4child
npm run dev
```

Ouvrir [http://localhost:3000](http://localhost:3000) pour voir l'application.

## 🛠️ Commandes de Développement

### Développement Local
```bash
npm run dev                    # Développement web
npm run dev:android           # Live reload Android
npm run dev:ios              # Live reload iOS (macOS)
```

### Build Multi-Plateformes  
```bash
npm run build:web            # Build web (SSR)
npm run build:capacitor      # Build mobile (export statique)
npm run build:android        # Build + sync Android
npm run build:ios           # Build + sync iOS  
npm run build:all           # Build toutes plateformes
```

### Tests Automatisés
```bash
npm run test                 # Tests Playwright complets
npm run test:web            # Tests web (desktop + mobile)
npm run test:mobile         # Tests navigateurs mobiles
npm run type-check          # Vérification TypeScript
```

### Configuration Mobile
```bash
npm run cap:add:android     # Ajouter plateforme Android
npm run cap:add:ios        # Ajouter plateforme iOS
npm run cap:sync           # Synchroniser code natif
npm run cap:doctor         # Diagnostic Capacitor
```

## 📁 Architecture du Projet

```
apps/math4child/
├── src/
│   ├── app/                 # Pages Next.js App Router
│   │   ├── layout.tsx       # Layout avec LanguageProvider
│   │   ├── page.tsx         # Page principale (null safety)
│   │   └── globals.css      # Styles globaux + RTL
│   ├── components/
│   │   ├── language/        # Système multilingue
│   │   │   └── LanguageDropdown.tsx
│   │   └── math/            # Composants du jeu
│   │       └── MathGame.tsx
│   ├── contexts/
│   │   └── LanguageContext.tsx  # Contexte langues + traductions
│   ├── hooks/
│   │   └── usePlatform.ts   # Hook détection plateforme
│   ├── lib/
│   │   └── optimal-payments.ts  # Système paiements
│   └── types/
│       └── global.d.ts      # Types TypeScript globaux
├── tests/                   # Tests Playwright
│   ├── shared/             # Tests partagés
│   ├── web/                # Tests web spécifiques  
│   └── mobile/             # Tests mobiles
├── capacitor.config.json   # Configuration mobile
├── playwright.config.ts    # Configuration tests
└── next.config.js         # Configuration hybride
```

## 🌍 Support Multilingue

### Langues Supportées (195+)

| Région | Langues | RTL |
|--------|---------|-----|
| **Europe** | Français, English, Español, Deutsch, Italiano, Português, Русский | ❌ |
| **Asie** | 中文, 日本語, 한국어, हिन्दी | ❌ |  
| **Moyen-Orient** | العربية, עברית | ✅ |

### Utilisation

```tsx
import { useLanguage } from '@/contexts/LanguageContext'

function Component() {
  const { currentLanguage, setLanguage, t, isRTL } = useLanguage()
  
  return (
    <div className={isRTL ? 'rtl' : 'ltr'}>
      <h1>{t.title}</h1>
      <LanguageDropdown />
    </div>
  )
}
```

## 💰 Système de Paiements Optimisé

### Providers Supportés

| Plateforme | Provider Optimal | Frais | Fonctionnalités |
|------------|------------------|-------|----------------|
| **Web** | Paddle | 5% | Tax handling, Global compliance |
| **Android** | RevenueCat | 1% | In-app purchases, Analytics |
| **iOS** | RevenueCat | 1% | In-app purchases, Analytics |

### Utilisation

```tsx
import { optimalPayments } from '@/lib/optimal-payments'

// Checkout automatique selon la plateforme
const session = await optimalPayments.createCheckout({
  planId: 'math4child_premium',
  amount: 999,
  currency: 'EUR'
})
```

## 🧪 Tests et Qualité

### Couverture Tests

- **✅ Tests fonctionnels** : Navigation, jeu, langues
- **✅ Tests multi-plateformes** : Web, Android, iOS
- **✅ Tests de performance** : <3s de chargement
- **✅ Tests d'accessibilité** : Navigation clavier, RTL
- **✅ TypeScript strict** : Null safety complète

### Lancer les Tests

```bash
# Tests complets
npm run test

# Tests spécifiques
npm run test:web           # Web uniquement
npm run test:mobile        # Mobile uniquement  
npm run test:translation   # Tests de traduction

# Tests avec interface
npx playwright test --ui
```

## 📱 Déploiement Production

### Web (Vercel/Netlify)

```bash
# Build pour déploiement web
npm run build:web

# Variables d'environnement requises
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_COMPANY=GOTEST
NEXT_PUBLIC_SIRET=53958712100028
```

### Android (Google Play Store)

```bash
# Configuration initiale
npm run cap:add:android

# Build APK de production
npm run build:android
cd android
./gradlew assembleRelease

# APK généré dans: android/app/build/outputs/apk/release/
```

### iOS (Apple App Store)

```bash
# Configuration initiale (macOS uniquement)
npm run cap:add:ios

# Build iOS
npm run build:ios

# Ouvrir Xcode pour publication
npx cap open ios
```

## 🔧 Configuration GOTEST

```json
{
  "appId": "com.gotest.math4child",
  "appName": "Math4Child",
  "company": "GOTEST", 
  "siret": "53958712100028",
  "platforms": ["web", "android", "ios"],
  "features": {
    "languages": "195+ avec RTL complet",
    "payments": "Multi-providers intelligents", 
    "offline": "Mode hors ligne complet",
    "analytics": "Suivi avancé des progrès"
  }
}
```

## 🛡️ Sécurité et Performance

### TypeScript Strict
- **Null safety complète** sur tous les composants
- **Types sécurisés** pour toutes les interfaces
- **Gestion d'erreur robuste** avec fallbacks

### Performance
- **Build optimisé** Web + Mobile
- **Lazy loading** des composants
- **Images optimisées** par plateforme
- **Cache intelligent** avec fallbacks

### Accessibilité
- **Support RTL complet** (Arabe, Hébreu)
- **Navigation clavier** complète
- **Contraste optimisé** pour lisibilité
- **Screen readers** compatibles

## 📊 Statistiques du Projet

- **📁 Fichiers TypeScript** : 100% typés avec null safety
- **🌍 Langues supportées** : 195+ avec RTL
- **📱 Plateformes** : Web + Android + iOS
- **🧪 Couverture tests** : Multi-plateformes
- **⚡ Performance** : <3s chargement web
- **🔒 Score sécurité** : Production-ready

## 🤝 Contribution

### Structure des Commits

```bash
feat: nouvelle fonctionnalité
fix: correction de bug
docs: mise à jour documentation
style: formatage code
refactor: refactorisation
test: ajout/modification tests
```

### Workflow de Développement

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/amazing-feature`)
3. **Committer** les changements (`git commit -m 'feat: add amazing-feature'`)
4. **Push** vers la branche (`git push origin feature/amazing-feature`)
5. **Ouvrir** une Pull Request

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 📞 Support

- **📧 Email** : support@gotest.fr
- **🐛 Issues** : [GitHub Issues](https://github.com/gotest/math4child/issues)
- **📖 Documentation** : [Wiki du projet](https://github.com/gotest/math4child/wiki)

---

<div align="center">

**Math4Child** - *L'application éducative n°1 pour apprendre les maths en famille*

[![GOTEST](https://img.shields.io/badge/Made%20by-GOTEST-blue)](https://gotest.fr)
[![SIRET](https://img.shields.io/badge/SIRET-53958712100028-green)](https://www.infogreffe.fr)

*Développé avec ❤️ en France*

</div>

---

## 📋 Informations Techniques Additionnelles



## Configuration GOTEST (extrait de DEPLOYMENT_GUIDE_COMPLETE.md)

## 🎯 Configuration GOTEST Math4Child

```json

## Commandes de Développement (extrait de HYBRID_TRANSFORMATION_GUIDE.md)

## 🚀 Commandes Hybrides Disponibles

### Tests Multi-Plateformes
```bash
npm run test:hybrid              # Tests hybrides complets
npm run test:web                 # Tests web (desktop + mobile)
npm run test:mobile              # Tests navigateurs mobiles
npm run test:apk                 # Tests APK Android + App iOS
npm run test:pwa                 # Tests Progressive Web App
npm run test:all                 # Tous les tests
```

### Build Multi-Plateformes
```bash
npm run build:web               # Build web standard
npm run build:capacitor         # Build pour mobile (export statique)
npm run build:android           # Build + sync Android
npm run build:ios               # Build + sync iOS
npm run build:all               # Build toutes plateformes
```

## Configuration GOTEST (extrait de HYBRID_TRANSFORMATION_GUIDE.md)

## 📱 Configuration GOTEST Finale

```json

## Commandes de Développement (extrait de MATH4CHILD_TRANSFORMATION_COMPLETE.md)

## 🚀 Commandes Disponibles

### Développement
```bash
npm run dev                    # Développement web
npm run dev:android           # Live reload Android
npm run dev:ios              # Live reload iOS (macOS)
```

### Build Multi-Plateformes
```bash
npm run build:web            # Build web (SSR)
npm run build:capacitor      # Build mobile (export statique)  
npm run build:android        # Build + sync Android
npm run build:ios           # Build + sync iOS
npm run build:all           # Build toutes plateformes
```

### Tests Hybrides
```bash

## Configuration GOTEST (extrait de MATH4CHILD_TRANSFORMATION_COMPLETE.md)

## 🔧 Configuration GOTEST

```json

## Guide de Déploiement (extrait de DEPLOYMENT_QUICK_START.md)

# 🚀 Guide de Déploiement Rapide - Math4Child

## ✅ BUILDS VALIDÉS

Les builds Web et Capacitor fonctionnent maintenant correctement !

## 📱 Configuration Rapide Mobile

### 🤖 Android
```bash
# 1. Ajouter plateforme Android
--
```

## 🌐 Déploiement Web

## Configuration GOTEST (extrait de DEPLOYMENT_GUIDE_COMPLETE.md)

## 🎯 Configuration GOTEST Math4Child

```json

## Commandes de Développement (extrait de HYBRID_TRANSFORMATION_GUIDE.md)

## 🚀 Commandes Hybrides Disponibles

### Tests Multi-Plateformes
```bash
npm run test:hybrid              # Tests hybrides complets
npm run test:web                 # Tests web (desktop + mobile)
npm run test:mobile              # Tests navigateurs mobiles
npm run test:apk                 # Tests APK Android + App iOS
npm run test:pwa                 # Tests Progressive Web App
npm run test:all                 # Tous les tests
```

### Build Multi-Plateformes
```bash
npm run build:web               # Build web standard
npm run build:capacitor         # Build pour mobile (export statique)
npm run build:android           # Build + sync Android
npm run build:ios               # Build + sync iOS
npm run build:all               # Build toutes plateformes
```

## Configuration GOTEST (extrait de HYBRID_TRANSFORMATION_GUIDE.md)

## 📱 Configuration GOTEST Finale

```json

## Commandes de Développement (extrait de MATH4CHILD_TRANSFORMATION_COMPLETE.md)

## 🚀 Commandes Disponibles

### Développement
```bash
npm run dev                    # Développement web
npm run dev:android           # Live reload Android
npm run dev:ios              # Live reload iOS (macOS)
```

### Build Multi-Plateformes
```bash
npm run build:web            # Build web (SSR)
npm run build:capacitor      # Build mobile (export statique)  
npm run build:android        # Build + sync Android
npm run build:ios           # Build + sync iOS
npm run build:all           # Build toutes plateformes
```

### Tests Hybrides
```bash

## Configuration GOTEST (extrait de MATH4CHILD_TRANSFORMATION_COMPLETE.md)

## 🔧 Configuration GOTEST

```json

## Guide de Déploiement (extrait de DEPLOYMENT_QUICK_START.md)

# 🚀 Guide de Déploiement Rapide - Math4Child

## ✅ BUILDS VALIDÉS

Les builds Web et Capacitor fonctionnent maintenant correctement !

## 📱 Configuration Rapide Mobile

### 🤖 Android
```bash
# 1. Ajouter plateforme Android
--
```

## 🌐 Déploiement Web
