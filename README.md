# 🎯 Multi-Apps Platform - GOTEST (Hybrides)

> **Plateforme d'applications hybrides - Web + Android + iOS**

[![Next.js](https://img.shields.io/badge/Next.js-14.0-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)
[![Capacitor](https://img.shields.io/badge/Capacitor-6.0-blue)](https://capacitorjs.com/)

## 🏗️ Structure du Projet

```
multi-apps-platform/
├── apps/
│   ├── math4child/          # 🎯 Application éducative principale
│   ├── unitflip/            # 🔄 Convertisseur d'unités (hybride)
│   ├── budgetcron/          # 💰 Gestionnaire de budget (hybride)
│   ├── ai4kids/             # 🎨 Application éducative (hybride)
│   └── multiai/             # 🤖 Plateforme de recherche (hybride)
├── README.md               # Documentation principale (ce fichier)
└── .gitignore             # Règles d'exclusion globales
```

## 📱 Applications Hybrides

**Toutes les applications sont maintenant hybrides (Web + Android + iOS) !**

| Application | Description | Technologies | App ID |
|-------------|-------------|-------------|---------|
| **Math4Child** | App éducative de mathématiques | Next.js + Capacitor | com.gotest.math4child |
| **UnitFlip** | Convertisseur d'unités universel | Next.js + Capacitor | com.gotest.unitflip |
| **BudgetCron** | Gestionnaire de budget personnel | Next.js + Capacitor | com.gotest.budgetcron |
| **AI4Kids** | Application éducative interactive | Next.js + Capacitor | com.gotest.ai4kids |
| **MultiAI** | Plateforme de recherche multi-moteurs | Next.js + Capacitor | com.gotest.multiai |

## 🚀 Démarrage Rapide

### Installation globale
```bash
# Installer les dépendances pour toutes les applications
npm install

# Ou individuellement pour chaque app
cd apps/math4child && npm install
cd apps/unitflip && npm install
cd apps/budgetcron && npm install
cd apps/ai4kids && npm install
cd apps/multiai && npm install
```

### Développement Web
```bash
# Démarrer une application spécifique en mode web
cd apps/math4child && npm run dev    # http://localhost:3000
cd apps/unitflip && npm run dev      # http://localhost:3000
cd apps/budgetcron && npm run dev    # http://localhost:3000
cd apps/ai4kids && npm run dev       # http://localhost:3000
cd apps/multiai && npm run dev       # http://localhost:3000
```

### Développement Mobile (Live Reload)
```bash
cd apps/[app-name]

# Android (avec live reload)
npm run dev:android

# iOS (macOS uniquement, avec live reload)
npm run dev:ios
```

## 📱 Déploiement Mobile (Toutes les Apps)

### Configuration initiale (une seule fois par app)
```bash
cd apps/[app-name]

# Ajouter les plateformes
npm run cap:add:android    # Android
npm run cap:add:ios        # iOS (macOS uniquement)
```

### Build et déploiement
```bash
cd apps/[app-name]

# Build web
npm run build:web

# Build mobile
npm run build:capacitor

# Déployer Android (ouvre Android Studio)
npm run deploy:android

# Déployer iOS (ouvre Xcode)
npm run deploy:ios
```

## 🔧 Configuration GOTEST

- **Company** : GOTEST
- **SIRET** : 53958712100028
- **Toutes les apps** : Support Web + Android + iOS
- **App IDs** : com.gotest.[app-name]

## ✨ Fonctionnalités Hybrides

### Chaque application dispose de :
- 🌐 **Version Web** : Déploiement sur Vercel/Netlify
- 🤖 **Application Android** : APK natif via Capacitor
- 🍎 **Application iOS** : App native via Capacitor
- ⚡ **Performance optimisée** : Next.js 14 + export statique pour mobile
- 📱 **Interface adaptive** : Design responsive et tactile
- 🧪 **Tests multi-plateformes** : Playwright pour toutes les plateformes

## 🎯 Architecture Unifiée

Chaque application suit la même structure hybride :
```
apps/[app-name]/
├── src/
│   ├── app/                    # Pages Next.js App Router
│   ├── components/             # Composants React
│   ├── hooks/                  # Hooks personnalisés
│   ├── lib/                    # Utilitaires
│   └── types/                  # Types TypeScript
├── public/                     # Assets statiques
├── package.json               # Scripts hybrides
├── next.config.js             # Configuration hybride Next.js
├── capacitor.config.ts        # Configuration mobile
├── tsconfig.json              # Configuration TypeScript
└── README.md                  # Documentation spécifique
```

## 🧪 Tests et Qualité

```bash
cd apps/[app-name]

# Tests complets
npm run test

# Vérification TypeScript
npm run type-check

# Linting
npm run lint

# Diagnostic Capacitor
npm run cap:doctor
```

## 🚀 Scripts Disponibles (Identiques pour toutes les apps)

### Développement
- `npm run dev` - Développement web
- `npm run dev:android` - Live reload Android
- `npm run dev:ios` - Live reload iOS

### Build
- `npm run build:web` - Build web standard
- `npm run build:capacitor` - Build pour mobile
- `npm run build:android` - Build + sync Android
- `npm run build:ios` - Build + sync iOS

### Déploiement
- `npm run deploy:web` - Déploiement web
- `npm run deploy:android` - Déploiement Android
- `npm run deploy:ios` - Déploiement iOS

### Capacitor
- `npm run cap:add:android` - Ajouter plateforme Android
- `npm run cap:add:ios` - Ajouter plateforme iOS
- `npm run cap:sync` - Synchroniser les plateformes
- `npm run cap:doctor` - Diagnostic Capacitor

## 📊 Applications Supprimées

Les applications suivantes ont été supprimées :
- ❌ **apps/postmath** (supprimée sur demande)
- ❌ **math4child-optimal** (supprimée, fonctionnalités intégrées dans math4child)

## 🌍 Déploiement Web

### Vercel (Recommandé)
```bash
cd apps/[app-name]
npm run build:web
# Connecter le repo GitHub à Vercel
```

### Netlify
```bash
cd apps/[app-name]
npm run build:web
# Build directory: .next
```

## 📱 Publication Mobile

### Google Play Store
```bash
cd apps/[app-name]
npm run deploy:android
# Suivre les étapes dans Android Studio
```

### Apple App Store
```bash
cd apps/[app-name]
npm run deploy:ios
# Suivre les étapes dans Xcode (macOS uniquement)
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Tester sur les 3 plateformes (web + mobile)
4. Commit les changements (`git commit -m 'feat: add amazing-feature'`)
5. Push vers la branche (`git push origin feature/amazing-feature`)
6. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

---

<div align="center">

**Multi-Apps Platform GOTEST** - *Plateforme d'applications hybrides innovantes*

[![GOTEST](https://img.shields.io/badge/Made%20by-GOTEST-blue)](https://gotest.fr)
[![SIRET](https://img.shields.io/badge/SIRET-53958712100028-green)](https://www.infogreffe.fr)

*Développé avec ❤️ en France*

</div>
