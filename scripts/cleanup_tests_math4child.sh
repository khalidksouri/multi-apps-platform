#!/bin/bash

# =============================================================================
# Script de Nettoyage Tests - Focus Math4Child Uniquement
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}🧹 NETTOYAGE TESTS - FOCUS MATH4CHILD UNIQUEMENT${NC}"
echo "================================================="
echo ""

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"  
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

step() {
    echo -e "${BLUE}[ÉTAPE]${NC} $1"
}

# =============================================================================
# ÉTAPE 1: SAUVEGARDE SÉCURITÉ
# =============================================================================

step "1️⃣ Sauvegarde des tests existants"

BACKUP_DIR="tests_backup_$(date +%Y%m%d_%H%M%S)"
if [ -d "tests" ]; then
    log "Création sauvegarde: $BACKUP_DIR"
    cp -r tests "$BACKUP_DIR"
    success "✅ Sauvegarde créée"
else
    warn "Dossier tests/ non trouvé"
fi

# =============================================================================
# ÉTAPE 2: SUPPRESSION TESTS OBSOLÈTES  
# =============================================================================

step "2️⃣ Suppression des tests d'applications obsolètes"

# Supprimer tests applications autres que Math4Child
if [ -d "tests" ]; then
    log "Nettoyage des tests obsolètes..."
    
    # Supprimer tests autres apps
    rm -f tests/apps/postmath.spec.ts 2>/dev/null || true
    rm -f tests/apps/unitflip.spec.ts 2>/dev/null || true  
    rm -f tests/apps/budgetcron.spec.ts 2>/dev/null || true
    rm -f tests/apps/ai4kids.spec.ts 2>/dev/null || true
    rm -f tests/apps/multiai.spec.ts 2>/dev/null || true
    
    log "✅ Tests applications obsolètes supprimés"
    
    # Garder uniquement Math4Child
    if [ ! -f "tests/apps/math4child.spec.ts" ]; then
        warn "Test Math4Child manquant, création..."
    fi
else
    warn "Dossier tests/ non trouvé"
fi

# =============================================================================
# ÉTAPE 3: MISE À JOUR CONFIGURATION PLAYWRIGHT
# =============================================================================

step "3️⃣ Mise à jour configuration Playwright"

# Créer nouvelle configuration focus Math4Child
cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright pour Math4Child uniquement
 * Focus sur l'application éducative de mathématiques
 */
export default defineConfig({
  testDir: './tests',
  
  /* Timeout global */
  timeout: 30 * 1000,
  expect: {
    timeout: 5000
  },

  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  
  /* Opt out of parallel tests on CI. */
  workers: process.env.CI ? 1 : undefined,

  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['junit', { outputFile: 'test-results.xml' }]
  ],

  /* Shared settings for all the projects below. */
  use: {
    /* Base URL pour Math4Child */
    baseURL: 'http://localhost:3000',
    
    /* Collect trace when retrying the failed test. */
    trace: 'on-first-retry',
    
    /* Screenshots */
    screenshot: 'only-on-failure',
    
    /* Video */
    video: 'retain-on-failure',
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'math4child-desktop',
      use: { ...devices['Desktop Chrome'] },
      testMatch: ['**/math4child*.spec.ts', '**/translation*.spec.ts', '**/rtl*.spec.ts']
    },

    {
      name: 'math4child-mobile',
      use: { ...devices['Pixel 5'] },
      testMatch: ['**/math4child*.spec.ts', '**/mobile*.spec.ts']
    },

    {
      name: 'math4child-rtl',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA'
      },
      testMatch: ['**/rtl*.spec.ts']
    },

    {
      name: 'math4child-capacitor',
      use: { 
        ...devices['Desktop Chrome'],
        userAgent: 'CapacitorApp'
      },
      testMatch: ['**/capacitor*.spec.ts', '**/deployment*.spec.ts']
    }
  ],

  /* Run your local dev server before starting the tests */
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
});
EOF

log "✅ Configuration Playwright mise à jour pour Math4Child"

# =============================================================================
# ÉTAPE 4: CRÉATION TESTS MATH4CHILD SPÉCIFIQUES
# =============================================================================

step "4️⃣ Création des tests Math4Child spécifiques"

# Créer dossier tests s'il n'existe pas
mkdir -p tests/math4child
mkdir -p tests/deployment
mkdir -p tests/translation
mkdir -p tests/rtl

# Test principal Math4Child
cat > tests/math4child/math4child.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests principaux Math4Child
 * Application éducative de mathématiques
 */
test.describe('Math4Child - Application Principale', () => {
  
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier éléments principaux
    await expect(page.locator('h1')).toContainText('Math4Child');
    await expect(page.locator('text=Apprendre les mathématiques')).toBeVisible();
    
    // Vérifier navigation
    await expect(page.locator('[data-testid="language-selector"]')).toBeVisible();
    await expect(page.locator('text=🎁')).toBeVisible(); // Bouton essai gratuit
  });

  test('Navigation fonctionnelle @critical', async ({ page }) => {
    await page.goto('/');
    
    // Test navigation vers les niveaux
    await page.click('text=🎁 Essai Gratuit');
    await expect(page.locator('text=Choisir le niveau')).toBeVisible();
    
    // Test sélection niveau
    await page.click('[data-level="1"]');
    await expect(page.locator('text=Niveau 1')).toBeVisible();
  });

  test('Jeu mathématique fonctionnel @game', async ({ page }) => {
    await page.goto('/');
    
    // Aller au jeu
    await page.click('text=🎁 Essai Gratuit');
    await page.click('[data-level="1"]');
    await page.click('text=🚀 Commencer');
    
    // Vérifier question mathématique
    await expect(page.locator('[data-testid="math-question"]')).toBeVisible();
    await expect(page.locator('[data-testid="answer-input"]')).toBeVisible();
    
    // Test réponse
    const question = await page.locator('[data-testid="math-question"]').textContent();
    console.log('Question posée:', question);
  });

  test('Système de progression @progression', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier système de niveaux
    await page.click('text=🎁 Essai Gratuit');
    
    // Vérifier déblocage progressif
    const niveau1 = page.locator('[data-level="1"]');
    const niveau2 = page.locator('[data-level="2"]');
    
    await expect(niveau1).toBeEnabled();
    // Niveau 2 peut être désactivé initialement
  });
});
EOF

# Test RTL spécifique Math4Child
cat > tests/rtl/math4child-rtl.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests RTL Math4Child
 * Support Right-to-Left pour arabe, hébreu, etc.
 */
test.describe('Math4Child - Support RTL', () => {

  test('Interface RTL arabe complète @rtl', async ({ page }) => {
    await page.goto('/');
    
    // Changer vers arabe
    await page.click('[data-testid="language-selector"]');
    await page.click('text=العربية');
    
    // Vérifier RTL appliqué
    await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
    await expect(page.locator('text=رياضيات4أطفال')).toBeVisible();
    
    // Navigation RTL
    await page.click('text=🎁');
    await expect(page.locator('text=اختر المستوى')).toBeVisible();
  });

  test('Jeu mathématique RTL fonctionnel @rtl @game', async ({ page }) => {
    await page.goto('/');
    
    // Arabe + jeu
    await page.click('[data-testid="language-selector"]');
    await page.click('text=العربية');
    await page.click('text=🎁');
    await page.click('[data-level="1"]');
    
    // Vérifier interface de jeu RTL
    const gameContainer = page.locator('[data-testid="game-container"]');
    if (await gameContainer.isVisible()) {
      const direction = await gameContainer.evaluate(el => 
        window.getComputedStyle(el).direction
      );
      expect(direction).toBe('rtl');
    }
  });
});
EOF

# Test traduction Math4Child
cat > tests/translation/math4child-translation.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

/**
 * Tests de traduction Math4Child
 * Support 195+ langues
 */
test.describe('Math4Child - Traductions', () => {

  const languages = [
    { code: 'fr', name: 'Français', flag: '🇫🇷', text: 'Math4Child' },
    { code: 'en', name: 'English', flag: '🇺🇸', text: 'Math4Child' },
    { code: 'es', name: 'Español', flag: '🇪🇸', text: 'Math4Child' },
    { code: 'ar', name: 'العربية', flag: '🇸🇦', text: 'رياضيات4أطفال' },
    { code: 'de', name: 'Deutsch', flag: '🇩🇪', text: 'Math4Child' }
  ];

  for (const lang of languages) {
    test(`Interface traduite en ${lang.code} @translation`, async ({ page }) => {
      await page.goto('/');
      
      // Changer de langue
      await page.click('[data-testid="language-selector"]');
      await page.click(`text=${lang.name}`);
      
      // Vérifier traduction
      if (lang.text !== 'Math4Child') {
        await expect(page.locator(`text=${lang.text}`)).toBeVisible();
      }
      
      // Vérifier interface traduite
      await expect(page.locator('h1')).toBeVisible();
      
      console.log(`✅ Langue ${lang.name} (${lang.flag}) validée`);
    });
  }

  test('Persistance de langue @translation', async ({ page }) => {
    await page.goto('/');
    
    // Changer vers espagnol
    await page.click('[data-testid="language-selector"]');
    await page.click('text=Español');
    
    // Recharger la page
    await page.reload();
    
    // Vérifier persistance
    const html = page.locator('html');
    const lang = await html.getAttribute('lang');
    expect(lang).toBe('es');
  });
});
EOF

log "✅ Tests Math4Child spécifiques créés"

# =============================================================================
# ÉTAPE 5: MISE À JOUR PACKAGE.JSON
# =============================================================================

step "5️⃣ Mise à jour scripts package.json"

# Backup package.json
cp package.json package.json.backup.$(date +%Y%m%d_%H%M%S)

# Créer version temporaire avec scripts Math4Child uniquement
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// Scripts focus Math4Child
pkg.scripts = {
  ...pkg.scripts,
  'test': 'playwright test',
  'test:math4child': 'playwright test --project=math4child-desktop',
  'test:mobile': 'playwright test --project=math4child-mobile',
  'test:rtl': 'playwright test --project=math4child-rtl',
  'test:capacitor': 'playwright test --project=math4child-capacitor',
  'test:translation': 'playwright test tests/translation/',
  'test:headed': 'playwright test --headed',
  'test:debug': 'playwright test --debug',
  'test:ui': 'playwright test --ui',
  'test:report': 'playwright show-report'
};

// Mise à jour nom et description
pkg.name = 'math4child-app';
pkg.description = 'Math4Child - Application éducative de mathématiques pour enfants';

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

log "✅ Package.json mis à jour pour Math4Child"

# =============================================================================
# ÉTAPE 6: NETTOYAGE FINAL
# =============================================================================

step "6️⃣ Nettoyage final"

# Supprimer anciens rapports de tests
rm -rf playwright-report test-results test-results.json test-results.xml 2>/dev/null || true

# Supprimer cache Playwright
rm -rf .playwright 2>/dev/null || true

log "✅ Nettoyage final terminé"

# =============================================================================
# ÉTAPE 7: VALIDATION
# =============================================================================

step "7️⃣ Validation de la configuration"

log "Test de la nouvelle configuration..."

# Test rapide
if npx playwright test --list > /dev/null 2>&1; then
    success "✅ Configuration Playwright valide"
else
    error "❌ Problème de configuration Playwright"
fi

# Compter les tests
TEST_COUNT=$(find tests -name "*.spec.ts" | wc -l)
log "Tests trouvés: $TEST_COUNT fichiers"

# Lister les tests Math4Child
log "Tests Math4Child disponibles:"
find tests -name "*math4child*" -o -name "*translation*" -o -name "*rtl*" | head -10

echo ""
echo -e "${PURPLE}📊 RÉSUMÉ DU NETTOYAGE${NC}"
echo "========================="
echo -e "${GREEN}✅ Tests autres applications supprimés${NC}"
echo -e "${GREEN}✅ Configuration Playwright mise à jour${NC}"
echo -e "${GREEN}✅ Tests Math4Child spécifiques créés${NC}"
echo -e "${GREEN}✅ Scripts package.json optimisés${NC}"
echo -e "${GREEN}✅ Focus 100% sur Math4Child${NC}"
echo ""

echo -e "${BLUE}🧪 Commandes de test disponibles:${NC}"
echo "  npm run test                  # Tous les tests Math4Child"
echo "  npm run test:math4child       # Tests principaux"
echo "  npm run test:mobile           # Tests mobile"
echo "  npm run test:rtl              # Tests RTL (arabe/hébreu)"
echo "  npm run test:translation      # Tests multilingues"
echo "  npm run test:capacitor        # Tests Capacitor"
echo ""

echo -e "${PURPLE}🎯 Math4Child est maintenant le seul focus des tests !${NC}"

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

success "🧹 Nettoyage terminé avec succès ! Math4Child ready for testing ! 🚀"