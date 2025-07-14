# 🚀 MultiApps Testing Suite

Suite de tests BDD complète pour un workspace monorepo contenant plusieurs applications Next.js avec des tests Playwright et Cucumber.

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
├── tests/                   # Tests BDD avec Playwright et Cucumber
│   ├── features/            # Fichiers .feature (Gherkin)
│   ├── steps/               # Step definitions TypeScript
│   ├── support/             # Configuration et utilitaires
│   └── fixtures/            # Données de test statiques
├── scripts/                 # Scripts de développement et test
├── reports/                 # Rapports de tests générés
├── cucumber.config.ts       # Configuration Cucumber
├── playwright.config.ts     # Configuration Playwright
└── tsconfig.json           # Configuration TypeScript
```

## 🎯 Applications

### 🤖 AI4Kids (port 3004)
Interface ludique pour enseigner l'IA aux enfants avec des modules interactifs.
- **Tests spécialisés** : Accessibilité enfants, contrôles parentaux, gamification
- **Features** : Mode offline, apprentissage adaptatif, support multilingue

### 💰 BudgetCron (port 3003)
Application de gestion budgétaire avec insights IA et synchronisation bancaire.
- **Tests spécialisés** : IA prédictive, sécurité financière, performance
- **Features** : Catégorisation auto, alertes temps réel, export données

### 📦 PostMath (port 3001)
Calculateur intelligent de frais d'expédition avec comparaison de transporteurs.
- **Tests spécialisés** : Multi-colis, APIs transporteurs, tarification dynamique
- **Features** : Empreinte carbone, assurance, suivi temps réel

### 🔄 UnitFlip (port 3002)
Convertisseur d'unités avancé avec explications détaillées.
- **Tests spécialisés** : Précision mathématique, unités personnalisées, performance
- **Features** : Conversions en lot, APIs externes, support international

### 🧠 MultiAI (port 3005)
Hub centralisé pour accéder à différents services d'IA.
- **Tests spécialisés** : Feature flags, intégrations API, monitoring
- **Features** : Services multiples, configuration dynamique, health checks

## 🧪 Architecture de Tests BDD

### Structure des tests
```
tests/
├── features/                # Tests Gherkin par application
│   ├── ai4kids/
│   │   └── learning-modules.feature
│   ├── multiai/
│   │   └── ai-services.feature
│   ├── budgetcron/
│   │   └── budget-management.feature
│   ├── unitflip/
│   │   └── unit-conversion.feature
│   ├── postmath/
│   │   └── shipping-calculator.feature
│   └── common/              # Tests cross-applications
│       ├── accessibility.feature
│       └── performance.feature
├── steps/                   # Step definitions TypeScript
│   ├── common.steps.ts      # Steps réutilisables
│   ├── ai4kids.steps.ts     # Steps spécifiques AI4Kids
│   └── [app].steps.ts       # Steps par application
└── support/                 # Configuration et utilitaires
    ├── world.ts             # World Cucumber + Playwright
    ├── hooks.ts             # Hooks Before/After
    ├── config.ts            # Configuration centralisée
    └── helpers.ts           # Fonctions utilitaires
```

### Types de tests inclus
- ✅ **Tests positifs** - Fonctionnalités principales
- ❌ **Tests négatifs** - Gestion d'erreurs
- ⚠️ **Tests aux limites** - Valeurs extrêmes
- 🌪️ **Tests tordus** - Cas complexes et stress
- ♿ **Tests d'accessibilité** - WCAG 2.1 AA
- ⚡ **Tests de performance** - Core Web Vitals
- 🔒 **Tests de sécurité** - Headers, XSS, CSRF
- 📱 **Tests responsive** - Mobile, tablette, desktop

## 🛠️ Installation

### Installation rapide
```bash
# Cloner le repository
git clone <repository-url>
cd multi-app-testing-suite

# Configuration automatique
npm run setup
```

### Installation manuelle
```bash
# Installation des dépendances workspace
npm install

# Build des packages partagés
npm run build:packages

# Installation de Playwright
npx playwright install

# Build du projet de tests
npm run build
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

## 🧪 Tests BDD

### Tests par type
```bash
# Tests de base
npm run test:smoke         # Tests rapides et critiques
npm run test:all           # Suite complète
npm run test:regression    # Tests de régression

# Tests par application
npm run test:ai4kids       # Tests AI4Kids
npm run test:multiai       # Tests MultiAI
npm run test:budgetcron    # Tests BudgetCron
npm run test:unitflip      # Tests UnitFlip
npm run test:postmath      # Tests PostMath

# Tests spécialisés
npm run test:performance   # Tests de performance
npm run test:accessibility # Tests d'accessibilité
npm run test:security      # Tests de sécurité
npm run test:mobile        # Tests mobile/responsive

# Tests par comportement
npm run test:positive      # Cas passants
npm run test:negative      # Cas d'erreur
npm run test:edge-case     # Cas aux limites
npm run test:twisted-case  # Cas complexes
```

### Tests par environnement
```bash
npm run test:dev           # Environnement développement
npm run test:staging       # Environnement staging
npm run test:prod          # Environnement production
```

### Modes d'exécution
```bash
npm run test:parallel      # Exécution parallèle (4 workers)
npm run test:sequential    # Exécution séquentielle
npm run test:debug         # Mode debug (headed, lent)
npm run test:fast          # Tests rapides seulement
```

### Tests Playwright directs
```bash
npm run test:playwright        # Tests Playwright standard
npm run test:playwright:ui     # Interface graphique
npm run test:playwright:debug  # Mode debug
npm run test:playwright:headed # Mode visible
```

## 📊 Rapports et Monitoring

### Génération de rapports
```bash
npm run report:generate    # Rapport complet
npm run report:open        # Ouvrir rapport Playwright
npm run report:cucumber    # Ouvrir rapport Cucumber
npm run report:merge       # Fusionner tous les rapports
```

### Types de rapports générés
- **HTML** - Rapports interactifs avec screenshots
- **JSON** - Données brutes pour CI/CD
- **JUnit** - Intégration avec systèmes CI
- **Vidéos** - Enregistrements des échecs
- **Traces** - Debug détaillé des interactions

## 🏗️ Build

### Build complet
```bash
npm run build:all          # Tout le workspace
npm run build:packages     # Packages partagés seulement
npm run build:apps         # Applications seulement
```

### Build par application
```bash
npm run build --workspace=apps/postmath
npm run build --workspace=apps/unitflip
# etc.
```

## 🔧 Configuration

### Variables d'environnement (.env.test)
```bash
# URLs des applications
AI4KIDS_URL=http://localhost:3004
MULTIAI_URL=http://localhost:3005
BUDGETCRON_URL=http://localhost:3003
UNITFLIP_URL=http://localhost:3002
POSTMATH_URL=http://localhost:3001

# Configuration navigateur
BROWSER=chromium
HEADLESS=true
VIEWPORT_WIDTH=1280
VIEWPORT_HEIGHT=720

# Timeouts
TEST_TIMEOUT=60000
ACTION_TIMEOUT=30000
NAVIGATION_TIMEOUT=60000

# Features spécialisées
ENABLE_PERFORMANCE_METRICS=false
ENABLE_A11Y_CHECKS=false
ENABLE_SECURITY_CHECKS=false

# Parallélisme
PARALLEL_WORKERS=4
RETRY_COUNT=2
```

### Profils Cucumber (cucumber.config.ts)
- **default** - Configuration standard
- **smoke** - Tests rapides et critiques
- **all** - Suite complète avec retry
- **[app]** - Tests spécifiques par application
- **performance** - Tests de performance avec monitoring
- **accessibility** - Tests d'accessibilité WCAG
- **security** - Tests de sécurité avancés
- **debug** - Mode debug avec devtools

## 📱 Ports des applications

| Application | Port | URL | Status |
|------------|------|-----|--------|
| PostMath | 3001 | http://localhost:3001 | ✅ |
| UnitFlip | 3002 | http://localhost:3002 | ✅ |
| BudgetCron | 3003 | http://localhost:3003 | ✅ |
| AI4Kids | 3004 | http://localhost:3004 | ✅ |
| MultiAI | 3005 | http://localhost:3005 | ✅ |

## 🎨 Stack technologique

### Applications
- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Package Manager**: npm avec workspaces

### Tests
- **BDD Framework**: Cucumber.js
- **Test Runner**: Playwright
- **Language**: TypeScript
- **Reporting**: HTML, JSON, JUnit
- **CI/CD**: GitHub Actions ready

## 📝 Scripts disponibles

### Développement
| Script | Description |
|--------|-------------|
| `npm run dev` | Démarre toutes les apps |
| `npm run dev:[app]` | Démarre une app spécifique |
| `npm run build:all` | Build tout le workspace |
| `npm run setup` | Configuration initiale |

### Tests BDD
| Script | Description |
|--------|-------------|
| `npm run test` | Tests par défaut |
| `npm run test:smoke` | Tests smoke |
| `npm run test:[app]` | Tests par application |
| `npm run test:performance` | Tests de performance |
| `npm run test:debug` | Mode debug |

### Maintenance
| Script | Description |
|--------|-------------|
| `npm run clean` | Nettoyage complet |
| `npm run lint` | Linting du code |
| `npm run format` | Formatage du code |
| `npm run deps:update` | Mise à jour dépendances |

## 🤝 Développement

### Ajouter une nouvelle application
1. Créer le dossier dans `apps/`
2. Ajouter les scripts dans le `package.json` racine
3. Configurer les URLs dans `cucumber.config.ts` et `playwright.config.ts`
4. Créer les fichiers `.feature` dans `tests/features/[app]/`
5. Créer les step definitions dans `tests/steps/[app].steps.ts`

### Ajouter de nouveaux tests
1. Créer/modifier les fichiers `.feature` avec les scénarios Gherkin
2. Implémenter les step definitions correspondantes
3. Ajouter les données de test dans `tests/fixtures/`
4. Configurer les profils dans `cucumber.config.ts`

### Ajouter un composant partagé
1. Créer le composant dans `packages/ui/src/components/`
2. Exporter dans `packages/ui/src/index.ts`
3. Build avec `npm run build:packages`

## 📊 Métriques et KPIs

### Coverage de tests
- **Applications** : 5/5 (100%)
- **Scénarios BDD** : 300+ scénarios
- **Step definitions** : 150+ steps
- **Données de test** : 6 fichiers fixtures

### Types de tests
- **Fonctionnels** : 85%
- **Performance** : 10%
- **Accessibilité** : 3%
- **Sécurité** : 2%

### Exécution
- **Temps moyen** : 5-10 minutes (parallèle)
- **Taux de succès** : >95% 
- **Retry automatique** : 2 tentatives
- **Navigateurs** : Chrome, Firefox, Safari

## 📄 License

MIT License - Voir le fichier LICENSE pour plus de détails.