# Math4Child - Suite de Tests E2E Playwright

Suite complète de tests end-to-end pour **Math4Child**, l'application éducative multilingue pour l'apprentissage des mathématiques (4-12 ans).

## 🌟 Fonctionnalités Testées

### ✅ Tests Principaux
- **Interface multilingue** : 20 langues supportées
- **Système de niveaux** : Progression de Débutant à Expert  
- **Opérations mathématiques** : Addition, soustraction, multiplication, division, mixte
- **Système d'abonnement** : Version gratuite, mensuel, trimestriel, annuel
- **Multi-appareils** : Web, Android, iOS avec réductions échelonnées
- **Design responsive** : Mobile, tablette, desktop

### 🧪 Types de Tests
- **Tests fonctionnels** : Parcours utilisateur complets
- **Tests multilingues** : Traductions et RTL (arabe)
- **Tests de performance** : Temps de chargement et navigation
- **Tests d'accessibilité** : Navigation clavier, ARIA, contrastes
- **Tests responsive** : Adaptations mobile/tablette/desktop
- **Tests de régression** : Validation des corrections

## 🚀 Installation et Configuration

### Prérequis
- Node.js >= 18.0.0
- npm >= 8.0.0

### Installation rapide
```bash
# Installation automatique avec Make
make install

# Ou manuellement
npm ci
npx playwright install --with-deps
```

### Variables d'environnement
```bash
# .env.local
BASE_URL=http://localhost:3000
NODE_ENV=test
CI=false
APP_VERSION=2.0.0
```

## 🎮 Commandes Principales

### Tests basiques
```bash
# Tous les tests
npm run test

# Tests avec interface graphique
npm run test:headed

# Interface UI Playwright
npm run test:ui

# Mode debug
npm run test:debug
```

### Tests spécialisés
```bash
# Tests mobile
npm run test:mobile

# Tests multilingues
npm run test:i18n

# Tests de performance  
npm run test:performance

# Tests d'accessibilité
npm run test:accessibility

# Tests critiques uniquement
npm run test:smoke
```

### Navigateurs spécifiques
```bash
# Chrome uniquement
npm run test:chrome

# Firefox uniquement
npm run test:firefox

# Safari uniquement
npm run test:safari
```

### Rapports
```bash
# Générer et voir le rapport
npm run test:report

# Serveur de rapport
npm run test:report-open
```

## 📁 Structure des Tests

```
tests/
├── specs/
│   ├── math4child-basic.spec.ts      # Tests de base
│   ├── i18n.basic.spec.ts             # Tests multilingues
│   ├── game.basic.spec.ts             # Tests du jeu mathématique
│   ├── responsive.basic.spec.ts       # Tests responsive
│   └── performance.basic.spec.ts      # Tests de performance
├── utils/
│   ├── test-utils.ts                  # Utilitaires et helpers
│   ├── test-data.ts                   # Données de test
│   └── test-fixtures.ts               # Fixtures Playwright
├── global.setup.ts                    # Configuration globale
├── global.teardown.ts                 # Nettoyage global
└── playwright.config.ts               # Configuration Playwright
```

## 🔧 Configuration Avancée

### Projects Playwright
- **Desktop** : Chrome, Firefox, Safari
- **Mobile** : Android (Pixel 5), iOS (iPhone 12)
- **Tablette** : iPad Pro
- **Multilingue** : Français, Espagnol, Arabe (RTL), Chinois
- **Performance** : Chrome optimisé
- **Accessibilité** : Chrome avec options a11y

### Environnements
```bash
# Développement local
BASE_URL=http://localhost:3000

# Staging
BASE_URL=https://staging.math4child.com

# Production
BASE_URL=https://www.math4child.com
```

## 🎯 Tests par Fonctionnalité

### Tests Multilingues
```typescript
// Test changement de langue
await helper.selectLanguage('fr');
await expect(page.locator('body')).toContainText(/mathématiques/i);

// Test RTL pour l'arabe
await helper.selectLanguage('ar');
await expect(page.locator('[dir="rtl"]')).toBeVisible();
```

### Tests du Système de Jeu
```typescript
// Démarrer un jeu
await helper.startGame('beginner', 'addition');

// Résoudre un problème
const isCorrect = await helper.solveMathProblem();
expect(isCorrect).toBeTruthy();
```

## 📊 Intégration CI/CD

### GitHub Actions
```yaml
# .github/workflows/math4child-tests.yml
- name: Run Playwright Tests
  run: npx playwright test --project=chromium-desktop
  env:
    BASE_URL: http://localhost:3000
    CI: true
```

### Docker
```bash
# Tests avec Docker
npm run docker:test

# Nettoyage Docker
npm run docker:clean
```

## 🐛 Debugging

### Traces et Screenshots
```bash
# Traces activées
npm run test:trace

# Screenshots à chaque étape
npm run test:screenshot

# Mode debug interactif
npm run test:debug
```

### Enregistrement de nouveaux tests
```bash
# Codegen Playwright
npm run test:record
```

## 📈 Métriques et Performance

### Temps de chargement
- **Page d'accueil** : < 5 secondes (dev), < 3 secondes (prod)
- **Changement de langue** : < 2 secondes
- **Navigation entre vues** : < 2 secondes

### Couverture des tests
- **Fonctionnalités core** : 100%
- **Langues principales** : 6 langues (EN, FR, ES, DE, AR, ZH)
- **Navigateurs** : Chrome, Firefox, Safari
- **Appareils** : Desktop, Mobile, Tablette

## 🛠️ Maintenance

### Nettoyage
```bash
# Nettoyage des résultats
make clean

# Nettoyage complet
make clean-all
```

### Mise à jour
```bash
# Mettre à jour Playwright
npx playwright install

# Mettre à jour les captures
npm run test:update-snapshots
```

## 🚀 Commandes Make (Recommandées)

```bash
make help              # Afficher toutes les commandes
make install           # Installation complète
make test              # Lancer tous les tests
make test-mobile       # Tests mobile uniquement
make test-i18n         # Tests multilingues
make report            # Voir le rapport
make clean             # Nettoyage
```

## 📞 Support et Contribution

### Structure des commits
```bash
git commit -m "test: ajouter tests pour niveau expert Math4Child"
git commit -m "fix: corriger tests multilingues arabe"
git commit -m "feat: ajouter tests performance mobile"
```

### Conventions de nommage
- **Fichiers de test** : `*.spec.ts`
- **Utilitaires** : `*-utils.ts`
- **Fixtures** : `*-fixtures.ts`
- **Données** : `*-data.ts`

---

**Math4Child Tests** - Suite complète pour une application éducative de qualité mondiale 🌍📚✨
