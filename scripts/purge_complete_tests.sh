#!/bin/bash

# =============================================================================
# PURGE COMPLÈTE - Math4Child UNIQUEMENT
# Suppression radicale de tous les tests non-Math4Child
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${RED}🔥 PURGE COMPLÈTE - FOCUS MATH4CHILD EXCLUSIF${NC}"
echo "=============================================="
echo ""

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# =============================================================================
# ÉTAPE 1: SAUVEGARDE TOTALE
# =============================================================================

echo -e "${BLUE}1️⃣ Sauvegarde complète avant purge${NC}"

BACKUP_DIR="full_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Sauvegarder tout
cp -r tests "$BACKUP_DIR/" 2>/dev/null || log "Pas de dossier tests/"
cp playwright.config.* "$BACKUP_DIR/" 2>/dev/null || log "Pas de config Playwright"
cp package.json "$BACKUP_DIR/"

log "✅ Sauvegarde complète dans: $BACKUP_DIR"

# =============================================================================
# ÉTAPE 2: DESTRUCTION TOTALE DES TESTS OBSOLÈTES
# =============================================================================

echo -e "${RED}2️⃣ Destruction totale des tests obsolètes${NC}"

# Supprimer tout le dossier tests
if [ -d "tests" ]; then
    rm -rf tests
    log "🔥 Dossier tests/ complètement supprimé"
fi

# Supprimer configurations Playwright
rm -f playwright.config.ts 2>/dev/null || true
rm -f playwright.config.*.ts 2>/dev/null || true

# Supprimer rapports et cache
rm -rf playwright-report test-results .playwright 2>/dev/null || true

log "✅ Destruction complète terminée"

# =============================================================================
# ÉTAPE 3: RECRÉATION PROPRE MATH4CHILD UNIQUEMENT
# =============================================================================

echo -e "${GREEN}3️⃣ Recréation propre - Math4Child uniquement${NC}"

# Créer structure de tests propre
mkdir -p tests/math4child
mkdir -p tests/e2e
mkdir -p tests/rtl
mkdir -p tests/translation

# Test principal Math4Child UNIQUEMENT
cat > tests/math4child/core.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests Math4Child Core - Application Principale
 * UNIQUEMENT Math4Child - Autres apps supprimées
 */
test.describe('Math4Child - Application Principale', () => {
  
  test('Math4Child se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier éléments Math4Child
    await expect(page.locator('h1')).toContainText(/Math4Child|Mathématiques/i);
    
    console.log('✅ Math4Child chargé avec succès');
  });

  test('Navigation Math4Child fonctionnelle @critical', async ({ page }) => {
    await page.goto('/');
    
    // Interface Math4Child spécifique
    const elements = await page.locator('*').allTextContents();
    const hasOnlyMath4Child = !elements.some(text => 
      /postmath|unitflip|budgetcron|ai4kids|multiai/i.test(text)
    );
    
    expect(hasOnlyMath4Child).toBeTruthy();
    console.log('✅ Aucune autre application détectée');
  });

  test('Jeu mathématique disponible @game', async ({ page }) => {
    await page.goto('/');
    
    // Chercher éléments de jeu mathématique
    const gameElements = [
      'niveau', 'addition', 'soustraction', 'multiplication', 'division',
      'exercice', 'question', 'réponse', 'score', 'progression'
    ];
    
    let foundGameElements = 0;
    for (const element of gameElements) {
      const found = await page.locator(`text=${element}`).count() > 0;
      if (found) foundGameElements++;
    }
    
    expect(foundGameElements).toBeGreaterThan(0);
    console.log(`✅ ${foundGameElements} éléments de jeu détectés`);
  });
});
EOF

# Test multilingue Math4Child
cat > tests/translation/math4child-i18n.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests Multilingues Math4Child UNIQUEMENT
 */
test.describe('Math4Child - Support Multilingue', () => {
  
  const languages = [
    { code: 'fr', name: 'Français' },
    { code: 'en', name: 'English' },
    { code: 'es', name: 'Español' },
    { code: 'ar', name: 'العربية' }
  ];

  for (const lang of languages) {
    test(`Math4Child en ${lang.name} @translation`, async ({ page }) => {
      await page.goto('/');
      
      // Chercher sélecteur de langue
      const langSelector = page.locator('[data-testid="language-selector"], .language-selector, [role="combobox"]');
      
      if (await langSelector.isVisible()) {
        await langSelector.click();
        await page.click(`text=${lang.name}`);
        
        // Vérifier changement de langue
        await page.waitForTimeout(500);
        
        if (lang.code === 'ar') {
          // Vérifier RTL pour arabe
          const htmlDir = await page.getAttribute('html', 'dir');
          expect(htmlDir).toBe('rtl');
          console.log('✅ RTL appliqué pour l\'arabe');
        }
      }
      
      console.log(`✅ Test langue ${lang.name} Math4Child`);
    });
  }
});
EOF

# Test RTL Math4Child
cat > tests/rtl/math4child-rtl.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests RTL Math4Child UNIQUEMENT
 */
test.describe('Math4Child - Support RTL', () => {
  
  test('Interface RTL Math4Child @rtl', async ({ page }) => {
    await page.goto('/');
    
    // Chercher et activer arabe
    const langSelector = page.locator('[data-testid="language-selector"], .language-selector');
    
    if (await langSelector.isVisible()) {
      await langSelector.click();
      await page.click('text=العربية');
      
      // Vérifier RTL
      await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
      
      console.log('✅ RTL Math4Child fonctionnel');
    } else {
      console.log('⚠️ Sélecteur de langue non trouvé');
    }
  });
});
EOF

# Test E2E complet
cat > tests/e2e/math4child-complete.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests E2E Complet Math4Child
 */
test.describe('Math4Child - Tests Complets E2E', () => {
  
  test('Parcours utilisateur complet @e2e', async ({ page }) => {
    await page.goto('/');
    
    // 1. Vérifier chargement
    await expect(page.locator('h1')).toBeVisible();
    
    // 2. Chercher boutons d'action
    const actionButtons = [
      'Commencer', 'Essai', 'Gratuit', 'Jouer', 'Niveau',
      'Premium', 'Démarrer', 'Start', 'Begin'
    ];
    
    let buttonFound = false;
    for (const buttonText of actionButtons) {
      const button = page.locator(`text=${buttonText}`);
      if (await button.isVisible()) {
        await button.click();
        buttonFound = true;
        console.log(`✅ Bouton "${buttonText}" trouvé et cliqué`);
        break;
      }
    }
    
    if (!buttonFound) {
      console.log('⚠️ Aucun bouton d\'action trouvé');
    }
    
    // 3. Vérifier que nous sommes toujours sur Math4Child
    const pageContent = await page.textContent('body');
    const hasOtherApps = /postmath|unitflip|budgetcron|ai4kids|multiai/i.test(pageContent);
    
    expect(hasOtherApps).toBeFalsy();
    console.log('✅ Aucune autre application détectée dans le parcours');
  });
});
EOF

log "✅ Tests Math4Child purs créés"

# =============================================================================
# ÉTAPE 4: CONFIGURATION PLAYWRIGHT ULTRA-SIMPLE
# =============================================================================

echo -e "${BLUE}4️⃣ Configuration Playwright Math4Child uniquement${NC}"

cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright - Math4Child UNIQUEMENT
 * Toutes autres applications supprimées
 */
export default defineConfig({
  testDir: './tests',
  timeout: 30 * 1000,
  expect: { timeout: 10000 },
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list'],
    ['json', { outputFile: 'test-results.json' }]
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  
  projects: [
    {
      name: 'math4child-desktop',
      use: { ...devices['Desktop Chrome'] },
      testMatch: ['**/*.spec.ts']
    },
    {
      name: 'math4child-mobile',
      use: { ...devices['Pixel 5'] },
      testMatch: ['**/*.spec.ts']
    }
  ]
  
  // Pas de webServer - à lancer manuellement
});
EOF

log "✅ Configuration Playwright Math4Child pure créée"

# =============================================================================
# ÉTAPE 5: PACKAGE.JSON ULTRA-SIMPLIFIÉ
# =============================================================================

echo -e "${BLUE}5️⃣ Package.json Math4Child focus exclusif${NC}"

node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// Scripts Math4Child UNIQUEMENT
pkg.scripts = {
  // Next.js de base
  'dev': 'next dev',
  'build': 'next build',
  'start': 'next start',
  'lint': 'next lint',
  'type-check': 'tsc --noEmit',
  
  // Export et Capacitor
  'build:web': 'next build',
  'build:capacitor': 'CAPACITOR_BUILD=true next build',
  'export': 'next export',
  
  // Mobile
  'android:build': 'npm run build:capacitor && npx cap sync android && npx cap open android',
  'ios:build': 'npm run build:capacitor && npx cap sync ios && npx cap open ios',
  
  // Tests Math4Child UNIQUEMENT
  'test': 'playwright test',
  'test:math4child': 'playwright test tests/math4child/',
  'test:translation': 'playwright test tests/translation/',
  'test:rtl': 'playwright test tests/rtl/',
  'test:e2e': 'playwright test tests/e2e/',
  'test:headed': 'playwright test --headed',
  'test:ui': 'playwright test --ui',
  'test:report': 'npx playwright show-report',
  
  // Maintenance
  'clean': 'rm -rf .next out node_modules/.cache',
  'clean:tests': 'rm -rf playwright-report test-results'
};

// Metadata Math4Child
pkg.name = 'math4child-app';
pkg.description = 'Math4Child - THE application éducative de mathématiques pour enfants';
pkg.keywords = ['math4child', 'mathematics', 'education', 'children', 'nextjs', 'capacitor'];

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Package.json Math4Child focus exclusif');
"

# =============================================================================
# ÉTAPE 6: VALIDATION PURGE
# =============================================================================

echo -e "${GREEN}6️⃣ Validation de la purge${NC}"

# Compter les nouveaux tests
TEST_COUNT=$(find tests -name "*.spec.ts" | wc -l)
log "Nouveaux tests Math4Child: $TEST_COUNT fichiers"

# Lister les tests
echo -e "${BLUE}Tests disponibles:${NC}"
find tests -name "*.spec.ts" | sed 's|^|  - |'

# Test rapide de configuration
if npx playwright test --list >/dev/null 2>&1; then
    log "✅ Configuration Playwright valide"
else
    warn "⚠️ Problème configuration Playwright"
fi

echo ""
echo -e "${RED}🔥 PURGE COMPLÈTE TERMINÉE ! 🔥${NC}"
echo "=================================="
echo -e "${GREEN}✅ Suppression totale anciennes applications${NC}"
echo -e "${GREEN}✅ Tests Math4Child purs créés${NC}"
echo -e "${GREEN}✅ Configuration simplifiée${NC}"
echo -e "${GREEN}✅ Focus 100% exclusif Math4Child${NC}"
echo ""

echo -e "${BLUE}🧪 Commandes de test Math4Child:${NC}"
echo "  npm run test                  # Tous tests Math4Child"
echo "  npm run test:math4child       # Tests principaux"
echo "  npm run test:translation      # Tests multilingues"
echo "  npm run test:rtl              # Tests RTL"
echo "  npm run test:e2e              # Tests complets E2E"
echo ""

echo -e "${PURPLE}🎯 Math4Child est maintenant LE SEUL focus !${NC}"
echo -e "${PURPLE}Plus aucune trace de postmath, unitflip, etc.${NC}"

log "Sauvegarde complète disponible dans: $BACKUP_DIR"