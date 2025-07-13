# 🚀 MultiApps Workspace

Workspace monorepo contenant plusieurs applications Next.js avec des packages partagés et des tests Playwright.

## 📁 Structure du projet

```
├── apps/                     # Applications Next.js
│   ├── ai4kids/             # Interface IA pour enfants (port 3004)
│   ├── budgetcron/          # Gestion budgétaire (port 3003)
│   ├── postmath/            # Calculateur d'expédition (port 3001)
│   ├── unitflip/            # Convertisseur d'unités (port 3002)
│   └── multiai/             # Hub services IA (port 3005)
├── packages/                # Packages partagés
│   ├── shared/              # Types TypeScript partagés
│   └── ui/                  # Composants React réutilisables
├── tests/                   # Tests Playwright E2E
├── scripts/                 # Scripts de développement
└── playwright.config.ts     # Configuration Playwright
```

## 🎯 Applications

### 🤖 AI4Kids (port 3004)
Interface ludique pour enseigner l'IA aux enfants avec des modules interactifs.

### 💰 BudgetCron (port 3003)
Application de gestion budgétaire avec insights IA et synchronisation bancaire.

### 📦 PostMath (port 3001)
Calculateur intelligent de frais d'expédition avec comparaison de transporteurs.

### 🔄 UnitFlip (port 3002)
Convertisseur d'unités avancé avec explications détaillées.

### 🧠 MultiAI (port 3005)
Hub centralisé pour accéder à différents services d'IA.

## 🛠️ Installation

### Installation rapide
```bash
# Cloner le repository
git clone <repository-url>
cd multiapps-workspace

# Script de configuration automatique
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Installation manuelle
```bash
# Installation des dépendances racine
npm install

# Installation des dépendances des packages
cd packages/shared && npm install && cd ../..
cd packages/ui && npm install && cd ../..

# Installation des dépendances des apps
cd apps/ai4kids && npm install && cd ../..
cd apps/budgetcron && npm install && cd ../..
cd apps/postmath && npm install && cd ../..
cd apps/unitflip && npm install && cd ../..
cd apps/multiai && npm install && cd ../..

# Build des packages
npm run build:packages

# Installation de Playwright
npx playwright install
```

## 🚀 Développement

### Démarrer toutes les applications
```bash
npm run dev
```

### Démarrer une application spécifique
```bash
npm run dev:postmath    # Port 3001
npm run dev:unitflip    # Port 3002
npm run dev:budgetcron  # Port 3003
npm run dev:ai4kids     # Port 3004
npm run dev:multiai     # Port 3005
```

### Utiliser le script de développement
```bash
./scripts/dev-all.sh
```

## 🏗️ Build

### Build de tout
```bash
npm run build
```

### Build des packages seulement
```bash
npm run build:packages
```

### Build d'une app spécifique
```bash
npm run build:postmath
npm run build:unitflip
# etc.
```

### Script de build complet
```bash
./scripts/build-all.sh
```

## 🧪 Tests

### Tests Playwright
```bash
# Tous les tests
npm run test

# Tests avec interface
npm run test:ui

# Tests en mode headed
npm run test:headed

# Tests spécifiques
npm run test:postmath
```

### Script de tests complet
```bash
./scripts/test-all.sh
```

## 📦 Packages partagés

### @multiapps/shared
Types TypeScript partagés entre toutes les applications :
- Types API (Shipping, Budget, etc.)
- Interfaces de données
- Types de réponses

### @multiapps/ui
Composants React réutilisables :
- Button avec variants et états de chargement
- Input avec icônes et validation
- Card avec différents paddings
- Select avec options
- Modal responsive

## 🎨 Stack technologique

- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Testing**: Playwright
- **Package Manager**: npm avec workspaces
- **Monorepo**: npm workspaces

## 📝 Scripts disponibles

| Script | Description |
|--------|-------------|
| `npm run dev` | Démarre toutes les apps |
| `npm run build` | Build tout le projet |
| `npm run test` | Lance les tests Playwright |
| `npm run lint` | Lint toutes les apps |
| `./scripts/setup.sh` | Configuration initiale |
| `./scripts/dev-all.sh` | Démarrage avec concurrently |
| `./scripts/test-all.sh` | Tests complets |
| `./scripts/build-all.sh` | Build complet |

## 🔧 Configuration

### Playwright
Configuré pour tester toutes les applications avec :
- Tests sur Chrome, Firefox, Safari
- Tests mobiles
- Serveurs de développement automatiques
- Rapports HTML

### TypeScript
- Configuration partagée avec `tsconfig.base.json`
- Path mapping pour les packages
- Mode strict activé

### Tailwind CSS
- Configuration partagée entre toutes les apps
- Classes utilitaires personnalisées
- Design system cohérent

## 📱 Ports des applications

| Application | Port | URL |
|------------|------|-----|
| PostMath | 3001 | http://localhost:3001 |
| UnitFlip | 3002 | http://localhost:3002 |
| BudgetCron | 3003 | http://localhost:3003 |
| AI4Kids | 3004 | http://localhost:3004 |
| MultiAI | 3005 | http://localhost:3005 |

## 🤝 Développement

### Ajouter une nouvelle application
1. Créer le dossier dans `apps/`
2. Ajouter les scripts dans le `package.json` racine
3. Configurer le port dans `playwright.config.ts`
4. Ajouter les tests dans `tests/features/`

### Ajouter un composant partagé
1. Créer le composant dans `packages/ui/src/components/`
2. Exporter dans `packages/ui/src/index.ts`
3. Build le package avec `npm run build`

### Ajouter des types partagés
1. Ajouter les types dans `packages/shared/src/index.ts`
2. Build le package avec `npm run build`

## 📄 License

MIT