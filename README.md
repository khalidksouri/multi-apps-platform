# 🚀 Multi-Apps Platform

> **Plateforme multi-applications moderne** avec 5 applications Next.js dans un monorepo TypeScript, tests Playwright automatisés et packages partagés optimisés.

## 🎯 Applications

| App | Port | Description | Statut |
|-----|------|-------------|---------|
| 📦 **PostMath** | 3001 | Calculateur intelligent de frais d'expédition | ✅ Fonctionnel |
| 🔄 **UnitFlip** | 3002 | Convertisseur d'unités avancé avec explications | ✅ Fonctionnel |
| 💰 **BudgetCron** | 3003 | Gestionnaire de budget avec transactions | ✅ Fonctionnel |
| 🤖 **AI4Kids** | 3004 | Interface sécurisée pour enfants | ✅ Fonctionnel |
| 🧠 **MultiAI** | 3005 | Hub centralisé pour services IA | ✅ Fonctionnel |

## 🏗️ Architecture

```
multi-apps-platform/
├── 📱 apps/                    # Applications Next.js
│   ├── postmath/              # Calculateur d'expédition
│   ├── unitflip/              # Convertisseur d'unités
│   ├── budgetcron/            # Gestionnaire de budget
│   ├── ai4kids/               # Interface pour enfants
│   └── multiai/               # Hub services IA
├── 📦 packages/               # Packages partagés
│   ├── shared/                # Types et utilitaires TypeScript
│   └── ui/                    # Composants React réutilisables
├── 🧪 tests/                  # Tests Playwright
├── 📋 scripts/                # Scripts de développement
├── playwright.config.ts       # Configuration Playwright
└── package.json              # Configuration workspace
```

## ⚡ Démarrage Rapide

### 1. Installation
```bash
# Cloner le projet
git clone [url-du-repo]
cd multi-apps-platform

# Installer toutes les dépendances
npm install

# Builder les packages partagés
npm run build:packages
```

### 2. Développement
```bash
# Démarrer toutes les applications
npm run dev

# Ou démarrer une application spécifique
npm run dev:postmath    # Port 3001
npm run dev:unitflip    # Port 3002  
npm run dev:budgetcron  # Port 3003
npm run dev:ai4kids     # Port 3004
npm run dev:multiai     # Port 3005
```

### 3. Tests
```bash
# Tests avec interface graphique (recommandé)
npm run test:ui

# Tests en mode visible
npm run test:headed

# Tests automatiques
npm run test

# Tests par application
npm run test:postmath
npm run test:unitflip
npm run test:budgetcron
```

## 📱 Fonctionnalités des Applications

### 📦 PostMath - Calculateur d'Expédition
- **Calcul automatique** des frais d'expédition
- **Comparaison de transporteurs** (Colissimo, Chronopost, etc.)
- **Validation de formulaire** avec react-hook-form
- **Interface responsive** avec Tailwind CSS
- **Tests automatisés** des calculs et validations

**Accès** : http://localhost:3001

### 🔄 UnitFlip - Convertisseur d'Unités
- **Conversion multi-catégories** : température, longueur, poids
- **Explications mathématiques** détaillées des formules
- **Interface interactive** avec bouton d'échange d'unités
- **Conversions courantes** pré-calculées
- **Support TypeScript** avec types stricts

**Accès** : http://localhost:3002

### 💰 BudgetCron - Gestionnaire de Budget
- **Suivi des transactions** avec catégorisation
- **Statistiques financières** (solde, revenus, dépenses)
- **Ajout de transactions** avec formulaire validé
- **Interface moderne** avec indicateurs visuels
- **Formatage des devises** automatique

**Accès** : http://localhost:3003

### 🤖 AI4Kids - Interface pour Enfants
- **Interface adaptée** aux enfants
- **Design sécurisé** et éducatif
- **Base extensible** pour fonctionnalités IA
- **Architecture prête** pour contrôles parentaux

**Accès** : http://localhost:3004

### 🧠 MultiAI - Hub Services IA
- **Architecture modulaire** pour intégrer plusieurs IA
- **Interface centralisée** pour gérer les services
- **Base extensible** pour nouveaux fournisseurs
- **Configuration flexible** des APIs

**Accès** : http://localhost:3005

## 🛠️ Scripts Disponibles

### Développement
```bash
npm run dev               # Toutes les applications
npm run dev:postmath      # PostMath seulement
npm run dev:unitflip      # UnitFlip seulement
npm run dev:budgetcron    # BudgetCron seulement
npm run dev:ai4kids       # AI4Kids seulement
npm run dev:multiai       # MultiAI seulement
```

### Build et Production
```bash
npm run build             # Build complet (packages + apps)
npm run build:packages    # Build des packages partagés
npm run build:apps        # Build de toutes les applications
```

### Tests
```bash
npm run test              # Tests Playwright automatiques
npm run test:ui           # Interface graphique Playwright
npm run test:headed       # Tests visibles dans navigateur
npm run test:debug        # Mode debug Playwright
npm run test:postmath     # Tests PostMath seulement
npm run test:unitflip     # Tests UnitFlip seulement
npm run test:budgetcron   # Tests BudgetCron seulement
npm run test:ai4kids      # Tests AI4Kids seulement
npm run test:multiai      # Tests MultiAI seulement
npm run test:report       # Afficher rapport de tests
```

### Maintenance
```bash
npm run lint              # Vérification ESLint
npm run format            # Formatage Prettier
npm run clean             # Nettoyage des caches
```

## 🧪 Tests Automatisés

### Configuration Playwright
- **Tests E2E** pour toutes les applications
- **Cross-browser** (Chrome, Firefox, Safari)
- **Screenshots automatiques** en cas d'échec
- **Rapports HTML détaillés**
- **Mode debug interactif**

### Exemples de Tests
- ✅ Chargement des pages d'accueil
- ✅ Fonctionnalité de calcul PostMath
- ✅ Conversion d'unités UnitFlip
- ✅ Ajout de transactions BudgetCron
- ✅ Navigation et interactions

## 💻 Développement avec VS Code

### Configuration Optimale
- ✅ **IntelliSense TypeScript** parfait
- ✅ **Auto-complétion** pour tous les packages
- ✅ **Détection d'erreurs** en temps réel
- ✅ **Refactoring sécurisé** entre applications
- ✅ **Navigation rapide** dans le monorepo

### Extensions Recommandées
- TypeScript Importer
- Prettier - Code formatter
- Tailwind CSS IntelliSense
- ES7+ React/Redux/React-Native snippets
- GitLens

## 📦 Packages Partagés

### @multiapps/shared
**Types et utilitaires TypeScript partagés**
```typescript
import { formatCurrency, User, APIResponse } from '@multiapps/shared';
```

**Contenu** :
- Types d'interface utilisateur
- Types de données métier
- Utilitaires de formatage
- Helpers de génération d'ID

### @multiapps/ui
**Composants React réutilisables**
```typescript
import { Button, Card } from '@multiapps/ui';
```

**Contenu** :
- Composants Button avec variants
- Composants Card avec styling
- Base extensible pour nouveaux composants

## 🌍 Technologies Utilisées

| Technologie | Version | Usage |
|-------------|---------|-------|
| **Next.js** | ^14.0.0 | Framework React pour toutes les apps |
| **TypeScript** | ^5.0.0 | Langage principal avec types stricts |
| **Tailwind CSS** | ^3.3.0 | Styling moderne et responsive |
| **Playwright** | ^1.40.0 | Tests E2E automatisés |
| **React Hook Form** | ^7.47.0 | Gestion des formulaires |
| **npm workspaces** | - | Gestion du monorepo |

## 🔄 Workflow Git

### Branches Principales
- `main` - Code stable et testé
- `develop` - Développement en cours
- `feature/*` - Nouvelles fonctionnalités par application

### Convention de Commits
```
feat(app): description
fix(app): description
test(app): description
docs: description
```

**Exemples** :
- `feat(postmath): add real-time tracking`
- `feat(unitflip): add voice recognition`
- `fix(budgetcron): correct transaction validation`

## 🚀 Déploiement

### Prérequis
- Node.js >= 18.0.0
- npm >= 8.0.0

### Variables d'Environnement
```bash
# .env.local pour chaque application
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_APP_NAME=PostMath
```

### Build Production
```bash
# Build toutes les applications
npm run build

# Les fichiers de build sont dans apps/*/dist/
```

## 📊 Monitoring et Performance

### Métriques Surveillées
- ✅ **Build time** pour chaque application
- ✅ **Test coverage** avec Playwright
- ✅ **Bundle size** optimisation
- ✅ **TypeScript errors** zéro tolerance

### Rapports Disponibles
- Rapport Playwright HTML avec screenshots
- Métriques de build Next.js
- Analyse des bundles

## 🤝 Contribution

### Développement Local
1. **Fork** le projet
2. **Créer** une branche feature : `git checkout -b feature/ma-fonctionnalite`
3. **Développer** avec tests : `npm run test:ui`
4. **Tester** le build : `npm run build`
5. **Commit** : `git commit -m "feat(app): ma fonctionnalité"`
6. **Push** : `git push origin feature/ma-fonctionnalite`
7. **Pull Request** vers `main`

### Standards de Code
- ✅ TypeScript strict mode
- ✅ Tests Playwright pour nouvelles fonctionnalités
- ✅ Formatage Prettier automatique
- ✅ Convention de nommage cohérente

## 📄 Licence

MIT License - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👨‍💻 Auteur

**Khalid Ksouri** - [khalid_ksouri@yahoo.fr](mailto:khalid_ksouri@yahoo.fr)

---

## 🆘 Support et Debug

### Problèmes Courants

**Erreur de build TypeScript** :
```bash
npm run clean
npm install
npm run build:packages
```

**Tests Playwright qui échouent** :
```bash
npx playwright install
npm run test:ui
```

**Port déjà utilisé** :
```bash
# Changer le port dans package.json de l'app
"dev": "next dev -p 3006"
```

### Logs et Debug
- **Logs Playwright** : `reports/playwright-report/`
- **Logs Next.js** : Dans le terminal de l'app
- **Logs Build** : Fichiers `.next/` de chaque app

### Contact
- 🐛 **Issues** : Utiliser GitHub Issues
- 💬 **Questions** : Email ou discussions GitHub
- 📖 **Documentation** : Wiki du projet

---

<div align="center">

**🌟 Star ce projet si il vous a aidé ! 🌟**

[⬆ Retour en haut](#-multi-apps-platform)

</div>