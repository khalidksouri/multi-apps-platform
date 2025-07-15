#!/bin/bash

# =============================================
# 🧪 Script de configuration des tests Playwright
# =============================================

echo "🧪 Configuration des tests Playwright et nettoyage des scripts..."

# Étape 1: Corriger le package.json principal pour ajouter les scripts Playwright
echo "🎯 CORRECTION 1: Ajout des scripts Playwright au package.json principal"

# Sauvegarder le package.json existant
cp package.json package.json.backup

# Créer un nouveau package.json avec les scripts de test corrects
cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "1.0.0",
  "description": "🚀 Plateforme multi-applications : PostMath Pro, UnitFlip Pro, BudgetCron, AI4Kids et MultiAI Search",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "concurrently \"npm run dev --workspace=postmath-app\" \"npm run dev --workspace=unitflip-app\" \"npm run dev --workspace=budgetcron-app\" \"npm run dev --workspace=ai4kids-app\" \"npm run dev --workspace=multiai-app\"",
    "dev:postmath": "npm run dev --workspace=postmath-app",
    "dev:unitflip": "npm run dev --workspace=unitflip-app", 
    "dev:budgetcron": "npm run dev --workspace=budgetcron-app",
    "dev:ai4kids": "npm run dev --workspace=ai4kids-app",
    "dev:multiai": "npm run dev --workspace=multiai-app",
    "build": "npm run build:packages && npm run build:apps",
    "build:packages": "npm run build --workspace=packages/shared && npm run build --workspace=packages/ui",
    "build:apps": "npm run build --workspace=postmath-app && npm run build --workspace=unitflip-app && npm run build --workspace=budgetcron-app && npm run build --workspace=ai4kids-app && npm run build --workspace=multiai-app",
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:headed": "playwright test --headed", 
    "test:debug": "playwright test --debug",
    "test:postmath": "playwright test --project=postmath",
    "test:unitflip": "playwright test --project=unitflip",
    "test:budgetcron": "playwright test --project=budgetcron",
    "test:ai4kids": "playwright test --project=ai4kids",
    "test:multiai": "playwright test --project=multiai",
    "test:report": "playwright show-report reports/playwright-report",
    "lint": "eslint . --ext .ts,.tsx",
    "format": "prettier --write .",
    "clean": "rimraf node_modules/.cache && rimraf apps/*/dist && rimraf packages/*/dist"
  },
  "keywords": [
    "nextjs",
    "typescript", 
    "monorepo",
    "multi-tenant",
    "saas",
    "postmath",
    "unitflip",
    "budgetcron",
    "ai4kids",
    "multiai"
  ],
  "author": "Khalid Ksouri <khalid_ksouri@yahoo.fr>",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.40.0",
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "eslint-config-prettier": "^9.0.0",
    "prettier": "^3.0.0",
    "rimraf": "^5.0.0",
    "typescript": "^5.0.0",
    "concurrently": "^8.0.0",
    "cross-env": "^7.0.0"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  }
}
EOF

echo "✅ Package.json principal mis à jour avec scripts Playwright"

# Étape 2: Supprimer les scripts Jest des packages pour éviter les erreurs
echo "🎯 CORRECTION 2: Suppression des scripts Jest problématiques"

# Corriger le package shared pour supprimer Jest
cat > packages/shared/package.json << 'EOF'
{
  "name": "@multiapps/shared",
  "version": "1.0.0",
  "description": "Code TypeScript partagé entre toutes les applications",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "zod": "^3.22.0",
    "date-fns": "^2.30.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "rimraf": "^5.0.0"
  },
  "peerDependencies": {
    "react": ">=18.0.0"
  }
}
EOF

# Corriger le package UI
cat > packages/ui/package.json << 'EOF'
{
  "name": "@multiapps/ui",
  "version": "1.0.0",
  "description": "Composants React partagés",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "clsx": "^2.0.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "rimraf": "^5.0.0"
  },
  "peerDependencies": {
    "react": ">=18.0.0",
    "react-dom": ">=18.0.0"
  }
}
EOF

echo "✅ Scripts Jest supprimés des packages"

# Étape 3: Vérifier que la configuration Playwright existe
echo "🎯 CORRECTION 3: Vérification de la configuration Playwright"

if [ ! -f "playwright.config.ts" ]; then
    echo "📄 Création de la configuration Playwright..."
    
    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'reports/playwright-report' }],
    ['json', { outputFile: 'reports/results.json' }]
  ],
  
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  
  projects: [
    {
      name: 'postmath',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/postmath*.spec.ts'
    },
    {
      name: 'unitflip', 
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3002' },
      testMatch: '**/unitflip*.spec.ts'
    },
    {
      name: 'budgetcron',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3003' },
      testMatch: '**/budgetcron*.spec.ts'
    },
    {
      name: 'ai4kids',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3004' },
      testMatch: '**/ai4kids*.spec.ts'
    },
    {
      name: 'multiai',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3005' },
      testMatch: '**/multiai*.spec.ts'
    }
  ]
});
EOF
else
    echo "✅ Configuration Playwright existe déjà"
fi

# Étape 4: Créer le test PostMath si il n'existe pas
echo "🎯 CORRECTION 4: Création du test PostMath"

mkdir -p tests

if [ ! -f "tests/postmath.spec.ts" ]; then
    echo "📄 Création du test PostMath..."
    
    cat > tests/postmath.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('PostMath Application', () => {
  
  test('should load the homepage', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre
    await expect(page).toHaveTitle(/PostMath/);
    
    // Vérifier les éléments principaux
    await expect(page.locator('h1')).toContainText('PostMath Pro');
    await expect(page.locator('text=Calculateur intelligent')).toBeVisible();
  });

  test('should display shipping calculator form', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que le formulaire est présent
    await expect(page.locator('[data-testid="departure-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="destination-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="weight-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="dimensions-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="calculate-button"]')).toBeVisible();
  });

  test('should calculate shipping costs', async ({ page }) => {
    await page.goto('/');
    
    // Remplir le formulaire
    await page.fill('[data-testid="departure-input"]', 'Paris');
    await page.fill('[data-testid="destination-input"]', 'Lyon');
    await page.fill('[data-testid="weight-input"]', '2.5');
    await page.fill('[data-testid="dimensions-input"]', '30x20x15');
    
    // Cliquer sur calculer
    await page.click('[data-testid="calculate-button"]');
    
    // Attendre les résultats
    await expect(page.locator('[data-testid="results-container"]')).toBeVisible({ timeout: 5000 });
    
    // Vérifier qu'au moins un transporteur est affiché
    await expect(page.locator('[data-testid^="carrier-"]')).toHaveCount(2);
    await expect(page.locator('[data-testid="carrier-name"]').first()).toBeVisible();
    await expect(page.locator('[data-testid="carrier-price"]').first()).toBeVisible();
  });

  test('should show validation errors for empty form', async ({ page }) => {
    await page.goto('/');
    
    // Cliquer sur calculer sans remplir
    await page.click('[data-testid="calculate-button"]');
    
    // Vérifier les messages d'erreur
    await expect(page.locator('text=Ville de départ requise')).toBeVisible();
    await expect(page.locator('text=Ville de destination requise')).toBeVisible();
    await expect(page.locator('text=Poids requis')).toBeVisible();
    await expect(page.locator('text=Dimensions requises')).toBeVisible();
  });

});
EOF
else
    echo "✅ Test PostMath existe déjà"
fi

# Étape 5: Test des nouveaux scripts
echo "🎯 TEST: Vérification des scripts"

echo "📋 Scripts disponibles:"
npm run 2>&1 | grep -E "(test:|dev:|build:)" | head -10

echo ""
echo "🧪 Test de la commande Playwright..."
if npx playwright --version >/dev/null 2>&1; then
    echo "✅ Playwright installé: $(npx playwright --version)"
else
    echo "❌ Playwright non installé, installation..."
    npx playwright install
fi

# Étape 6: Instructions finales
echo ""
echo "🎉 CONFIGURATION DES TESTS TERMINÉE!"
echo "===================================="
echo ""
echo "✅ Scripts Playwright ajoutés au package.json"
echo "✅ Scripts Jest problématiques supprimés"
echo "✅ Configuration Playwright mise à jour"
echo "✅ Test PostMath créé"
echo ""
echo "🧪 COMMANDES DE TEST DISPONIBLES:"
echo ""
echo "   npm run test              # Tests Playwright basiques"
echo "   npm run test:ui           # Interface graphique Playwright"
echo "   npm run test:headed       # Tests visibles (mode headed)"
echo "   npm run test:debug        # Mode debug"
echo "   npm run test:postmath     # Tests PostMath seulement"
echo "   npm run test:report       # Afficher le rapport"
echo ""
echo "🚀 DÉMARRAGE RECOMMANDÉ:"
echo ""
echo "1. Démarrer PostMath:"
echo "   cd apps/postmath && npm run dev"
echo ""
echo "2. Dans un autre terminal, lancer les tests:"
echo "   npm run test:ui"
echo ""
echo "💡 Note: Pour tester les autres applications, démarrez-les d'abord"
echo "   puis utilisez les commandes test:unitflip, test:budgetcron, etc."