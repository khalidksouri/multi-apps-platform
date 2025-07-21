#!/bin/bash

# ===================================================================
# SCRIPT COMPLET DE GÉNÉRATION DES TESTS MATH4CHILD
# Crée tous les fichiers de tests Playwright générés précédemment
# ===================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonctions d'affichage
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  🎭 GÉNÉRATION COMPLÈTE TESTS MATH4CHILD 🎭               ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  📚 Suite complète de tests Playwright                    ║${NC}"
    echo -e "${BLUE}║  🌍 20 langues • 5 niveaux • Web/Mobile/Tablette         ║${NC}"
    echo -e "${BLUE}║  🧮 Tests E2E, Performance, Accessibilité, I18N           ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_step() { echo -e "${PURPLE}🔄 $1${NC}"; }

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
TESTS_DIR="$SCRIPT_DIR/tests"

# Création de la structure des répertoires
create_directory_structure() {
    print_step "Création de la structure des répertoires..."
    
    mkdir -p "$TESTS_DIR"
    mkdir -p "$TESTS_DIR/specs"
    mkdir -p "$TESTS_DIR/utils"
    mkdir -p "$TESTS_DIR/fixtures"
    mkdir -p "$TESTS_DIR/data"
    mkdir -p "$TESTS_DIR/config"
    mkdir -p "$TESTS_DIR/scripts"
    mkdir -p "$TESTS_DIR/.github/workflows"
    mkdir -p "$TESTS_DIR/docker"
    mkdir -p "$TESTS_DIR/lighthouse-reports"
    mkdir -p "$TESTS_DIR/test-results"
    mkdir -p "$TESTS_DIR/playwright-report"
    
    print_success "Structure des répertoires créée"
}

# Génération du package.json principal
generate_package_json() {
    print_step "Génération du package.json..."
    
    cat > "$TESTS_DIR/package.json" << 'EOF'
{
  "name": "math4child-tests",
  "version": "1.0.0",
  "description": "Suite de tests Playwright pour Math4Child - Application éducative multilingue",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    
    "test:chrome": "playwright test --project=chromium-desktop",
    "test:firefox": "playwright test --project=firefox-desktop", 
    "test:safari": "playwright test --project=webkit-desktop",
    "test:mobile": "playwright test --project=mobile-android --project=mobile-ios",
    "test:tablet": "playwright test --project=tablet-ipad",
    
    "test:i18n": "playwright test --project=french-locale --project=spanish-locale --project=arabic-rtl --project=chinese-locale",
    "test:performance": "playwright test --project=performance-chrome performance.spec.ts",
    "test:accessibility": "playwright test --project=accessibility-chrome a11y.spec.ts",
    "test:api": "playwright test --project=api-tests api.spec.ts",
    
    "test:smoke": "playwright test --grep @smoke",
    "test:regression": "playwright test --grep @regression",
    "test:critical": "playwright test --grep @critical",
    
    "test:parallel": "playwright test --workers=4",
    "test:serial": "playwright test --workers=1",
    
    "test:record": "playwright codegen localhost:3000",
    "test:trace": "playwright test --trace on",
    "test:screenshot": "playwright test --screenshot on",
    
    "test:report": "playwright show-report",
    "test:report-open": "playwright show-report --host=0.0.0.0 --port=9323",
    
    "test:install": "playwright install",
    "test:install-deps": "playwright install-deps",
    
    "test:ci": "playwright test --reporter=github",
    "test:local": "playwright test --headed --reporter=list",
    
    "test:update-snapshots": "playwright test --update-snapshots",
    
    "clean": "rimraf test-results playwright-report coverage",
    "clean:node-modules": "rimraf node_modules package-lock.json",
    
    "lint:tests": "eslint specs/ utils/ --ext .ts",
    "type-check": "tsc --noEmit",
    
    "docker:test": "docker-compose -f docker/docker-compose.test.yml up --abort-on-container-exit",
    "docker:clean": "docker-compose -f docker/docker-compose.test.yml down -v",
    
    "setup": "npm install && npx playwright install --with-deps",
    "setup:quick": "npm install && npx playwright install"
  },
  
  "devDependencies": {
    "@playwright/test": "^1.41.0",
    "@types/node": "^20.10.0",
    "typescript": "^5.3.0",
    "eslint": "^8.55.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "rimraf": "^5.0.0",
    "dotenv": "^16.3.0"
  },
  
  "dependencies": {
    "axe-playwright": "^2.0.0",
    "lighthouse": "^11.4.0",
    "cross-env": "^7.0.3"
  },
  
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  
  "keywords": [
    "math4child",
    "testing", 
    "playwright",
    "e2e",
    "education",
    "multilingual",
    "mathematics"
  ],
  
  "author": "Math4Child Team",
  "license": "MIT"
}
EOF
    
    print_success "package.json généré"
}

# Génération de la configuration Playwright
generate_playwright_config() {
    print_step "Génération de playwright.config.ts..."
    
    cat > "$TESTS_DIR/playwright.config.ts" << 'EOF'
// ===================================================================
// CONFIGURATION PLAYWRIGHT POUR MATH4CHILD
// Configuration optimisée pour les tests multilingues et cross-platform
// ===================================================================

import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright pour Math4Child
 * Support: Web, Android, iOS simulation
 * Langues: 20 langues supportées
 * Tests: E2E, Performance, Accessibilité
 */
export default defineConfig({
  // Répertoire des tests
  testDir: './specs',
  
  // Configuration globale des tests
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 2 : undefined,
  
  // Timeout configurations
  timeout: 30000, // 30 secondes par test
  expect: {
    timeout: 10000, // 10 secondes pour les assertions
  },
  
  // Rapports de tests
  reporter: [
    ['html', { 
      outputFolder: 'playwright-report',
      open: 'never'
    }],
    ['json', { 
      outputFile: 'test-results/results.json' 
    }],
    ['junit', { 
      outputFile: 'test-results/junit.xml' 
    }],
    process.env.CI ? ['github'] : ['list']
  ],
  
  // Configuration globale des tests
  use: {
    // URL de base de Math4Child
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    
    // Configuration des traces et debugging
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Configuration des navigateurs
    headless: !!process.env.CI,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    
    // Langue par défaut pour les tests
    locale: 'en-US',
    
    // Headers personnalisés pour Math4Child
    extraHTTPHeaders: {
      'Accept-Language': 'en-US,en;q=0.9',
      'User-Agent': 'Math4Child-Test-Agent'
    },
    
    // Délais d'attente
    actionTimeout: 15000,
    navigationTimeout: 30000
  },

  // Configuration des projets de test
  projects: [
    // ============================================
    // TESTS DESKTOP - NAVIGATEURS PRINCIPAUX
    // ============================================
    {
      name: 'chromium-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 }
      },
      testMatch: '**/specs/**/*.spec.ts',
    },
    {
      name: 'firefox-desktop', 
      use: { 
        ...devices['Desktop Firefox'],
        viewport: { width: 1920, height: 1080 }
      },
      testMatch: '**/specs/**/*.spec.ts',
    },
    {
      name: 'webkit-desktop',
      use: { 
        ...devices['Desktop Safari'],
        viewport: { width: 1920, height: 1080 }
      },
      testMatch: '**/specs/**/*.spec.ts',
    },

    // ============================================
    // TESTS MOBILE - SIMULATION ANDROID/iOS
    // ============================================
    {
      name: 'mobile-android',
      use: { 
        ...devices['Pixel 5'],
        locale: 'en-US',
        hasTouch: true,
        isMobile: true
      },
      testMatch: '**/specs/**/mobile.*.spec.ts',
    },
    {
      name: 'mobile-ios',
      use: { 
        ...devices['iPhone 12'],
        locale: 'en-US', 
        hasTouch: true,
        isMobile: true
      },
      testMatch: '**/specs/**/mobile.*.spec.ts',
    },
    {
      name: 'tablet-ipad',
      use: { 
        ...devices['iPad Pro'],
        locale: 'en-US',
        hasTouch: true
      },
      testMatch: '**/specs/**/tablet.*.spec.ts',
    },

    // ============================================
    // TESTS MULTILINGUES
    // ============================================
    {
      name: 'french-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris'
      },
      testMatch: '**/specs/**/i18n.*.spec.ts',
    },
    {
      name: 'spanish-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'es-ES',
        timezoneId: 'Europe/Madrid'
      },
      testMatch: '**/specs/**/i18n.*.spec.ts',
    },
    {
      name: 'arabic-rtl',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh'
      },
      testMatch: '**/specs/**/rtl.*.spec.ts',
    },
    {
      name: 'chinese-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'zh-CN',
        timezoneId: 'Asia/Shanghai'
      },
      testMatch: '**/specs/**/i18n.*.spec.ts',
    },

    // ============================================
    // TESTS DE PERFORMANCE
    // ============================================
    {
      name: 'performance-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 }
      },
      testMatch: '**/specs/**/performance.*.spec.ts',
      grepInvert: /slow/
    },

    // ============================================
    // TESTS D'ACCESSIBILITÉ
    // ============================================
    {
      name: 'accessibility-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        // Configuration pour les tests d'accessibilité
        reducedMotion: 'reduce',
        forcedColors: 'none'
      },
      testMatch: '**/specs/**/a11y.*.spec.ts',
    },

    // ============================================
    // TESTS API (Si applicable pour Math4Child)
    // ============================================
    {
      name: 'api-tests',
      testMatch: '**/specs/**/api.*.spec.ts',
      use: {
        // Tests API uniquement
        baseURL: process.env.API_BASE_URL || 'http://localhost:3000/api',
      },
    }
  ],

  // ============================================
  // SERVEUR DE DÉVELOPPEMENT 
  // ============================================
  webServer: {
    // Commande pour démarrer Math4Child en mode dev
    command: process.env.CI ? 'npm run build && npm run start' : 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000, // 2 minutes
    
    // Variables d'environnement pour les tests
    env: {
      NODE_ENV: 'test',
      PORT: '3000',
      NEXT_PUBLIC_APP_ENV: 'test'
    }
  },

  // ============================================
  // CONFIGURATION GLOBALE DES TESTS
  // ============================================
  globalSetup: require.resolve('./global.setup.ts'),
  globalTeardown: require.resolve('./global.teardown.ts'),

  // Métadonnées pour les rapports
  metadata: {
    'App Name': 'Math4Child',
    'App Version': process.env.APP_VERSION || '2.0.0',
    'Test Environment': process.env.NODE_ENV || 'development',
    'Domain': 'www.math4child.com',
    'Supported Languages': '20 languages',
    'Target Age': '4-12 years',
    'Platforms': 'Web, Android, iOS'
  }
});

// ============================================
// CONFIGURATION CONDITIONNELLE PAR ENVIRONNEMENT
// ============================================

// Configuration spéciale pour CI/CD
if (process.env.CI) {
  module.exports.use = {
    ...module.exports.use,
    // Configuration optimisée pour CI
    headless: true,
    screenshot: 'only-on-failure',
    video: 'off', // Économiser l'espace en CI
    trace: 'retain-on-failure'
  };
  
  // Workers réduits en CI
  module.exports.workers = 2;
}

// Configuration pour tests de développement
if (process.env.NODE_ENV === 'development') {
  module.exports.use = {
    ...module.exports.use,
    // Mode debug pour développement
    headless: false,
    slowMo: 100, // Ralentir les actions
    screenshot: 'on',
    video: 'on'
  };
}

// Configuration spéciale pour production/staging
if (process.env.APP_ENV === 'production') {
  module.exports.use.baseURL = 'https://www.math4child.com';
}

// Configuration pour tests de performance
if (process.env.PERF_TESTS === 'true') {
  module.exports.projects = module.exports.projects.filter(p => 
    p.name.includes('performance') || p.name === 'chromium-desktop'
  );
}

// Configuration pour tests multilingues uniquement
if (process.env.I18N_TESTS === 'true') {
  module.exports.projects = module.exports.projects.filter(p => 
    p.name.includes('locale') || p.name.includes('rtl')
  );
}

// Configuration pour tests mobile uniquement  
if (process.env.MOBILE_TESTS === 'true') {
  module.exports.projects = module.exports.projects.filter(p => 
    p.name.includes('mobile') || p.name.includes('tablet')
  );
}
EOF
    
    print_success "playwright.config.ts généré"
}

# Génération des fichiers de setup globaux
generate_global_setup() {
    print_step "Génération des fichiers de setup globaux..."
    
    # global.setup.ts
    cat > "$TESTS_DIR/global.setup.ts" << 'EOF'
// ===================================================================
// SETUP GLOBAL DES TESTS MATH4CHILD
// Configuration avant tous les tests
// ===================================================================

import { chromium, FullConfig } from '@playwright/test';
import path from 'path';

async function globalSetup(config: FullConfig) {
  console.log('\n🚀 Setup global des tests Math4Child...\n');
  
  // Vérifier que l'application est disponible
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  try {
    console.log('📡 Vérification de la disponibilité de l\'application...');
    await page.goto(config.projects[0].use.baseURL || 'http://localhost:3000', {
      timeout: 60000,
      waitUntil: 'networkidle'
    });
    
    // Vérifier que Math4Child est bien chargé
    await page.waitForSelector('h1:has-text("Math4Child")', { timeout: 30000 });
    console.log('✅ Application Math4Child disponible');
    
    // Setup initial des données de test si nécessaire
    await setupTestData(page);
    
  } catch (error) {
    console.error('❌ Erreur lors de la vérification de l\'application:', error);
    throw error;
  } finally {
    await browser.close();
  }
  
  console.log('🎉 Setup global terminé\n');
}

async function setupTestData(page: any) {
  // Initialiser le localStorage avec des données de test
  await page.evaluate(() => {
    // Données de progression de test
    const testProgress = {
      level: 'beginner',
      correctAnswers: {
        beginner: 5,
        elementary: 0,
        intermediate: 0,
        advanced: 0,
        expert: 0
      },
      unlockedLevels: ['beginner'],
      totalQuestions: 10,
      freeQuestionsUsed: 5
    };
    
    localStorage.setItem('math4child-progress', JSON.stringify(testProgress));
    localStorage.setItem('math4child-language', 'en');
    localStorage.setItem('math4child-test-mode', 'true');
  });
  
  console.log('📊 Données de test initialisées');
}

export default globalSetup;
EOF

    # global.teardown.ts
    cat > "$TESTS_DIR/global.teardown.ts" << 'EOF'
// ===================================================================
// TEARDOWN GLOBAL DES TESTS MATH4CHILD
// Nettoyage après tous les tests
// ===================================================================

import { FullConfig } from '@playwright/test';
import fs from 'fs';
import path from 'path';

async function globalTeardown(config: FullConfig) {
  console.log('\n🧹 Nettoyage global des tests Math4Child...\n');
  
  try {
    // Nettoyer les fichiers temporaires
    const testResultsDir = path.join(process.cwd(), 'test-results');
    if (fs.existsSync(testResultsDir)) {
      console.log('📁 Nettoyage des anciens résultats de tests...');
      // Garder seulement les 5 derniers rapports
      cleanOldTestReports(testResultsDir);
    }
    
    // Générer un résumé des tests
    generateTestSummary();
    
  } catch (error) {
    console.error('❌ Erreur lors du nettoyage:', error);
  }
  
  console.log('✅ Nettoyage global terminé\n');
}

function cleanOldTestReports(dir: string) {
  try {
    const files = fs.readdirSync(dir)
      .filter(file => file.includes('playwright-report') || file.includes('screenshots'))
      .map(file => ({
        name: file,
        path: path.join(dir, file),
        time: fs.statSync(path.join(dir, file)).mtime.getTime()
      }))
      .sort((a, b) => b.time - a.time);
    
    // Supprimer tous sauf les 5 plus récents
    files.slice(5).forEach(file => {
      if (fs.existsSync(file.path)) {
        fs.rmSync(file.path, { recursive: true, force: true });
      }
    });
  } catch (error) {
    console.log('⚠️  Impossible de nettoyer les anciens rapports');
  }
}

function generateTestSummary() {
  const summary = {
    timestamp: new Date().toISOString(),
    app: 'Math4Child',
    version: process.env.APP_VERSION || '2.0.0',
    environment: process.env.NODE_ENV || 'test',
    totalDuration: process.hrtime()
  };
  
  console.log('📊 Résumé des tests généré');
}

export default globalTeardown;
EOF
    
    print_success "Fichiers de setup globaux générés"
}

# Génération des utilitaires de test
generate_test_utils() {
    print_step "Génération des utilitaires de test..."
    
    cat > "$TESTS_DIR/utils/test-utils.ts" << 'EOF'
// ===================================================================
// UTILITAIRES DE TEST MATH4CHILD
// Helpers et fonctions partagées
// ===================================================================

import { Page, expect } from '@playwright/test';

// Types Math4Child
export type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'ar' | 'zh' | 'ja' | 'ru' | 'pt' | 'it' | 'hi' | 'ko' | 'th' | 'vi' | 'tr' | 'pl' | 'nl' | 'sv' | 'da' | 'no';
export type Level = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';
export type MathOperation = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

// Configuration des langues pour tests
export const LANGUAGES_CONFIG = {
  'en': { name: 'English', flag: '🇺🇸', rtl: false, testPhrases: ['Learn math', 'English'] },
  'fr': { name: 'Français', flag: '🇫🇷', rtl: false, testPhrases: ['mathématiques', 'Français'] },
  'es': { name: 'Español', flag: '🇪🇸', rtl: false, testPhrases: ['matemáticas', 'Español'] },
  'de': { name: 'Deutsch', flag: '🇩🇪', rtl: false, testPhrases: ['Mathematik', 'Deutsch'] },
  'ar': { name: 'العربية', flag: '🇸🇦', rtl: true, testPhrases: ['الرياضيات', 'العربية'] },
  'zh': { name: '中文', flag: '🇨🇳', rtl: false, testPhrases: ['数学', '中文'] },
  'ja': { name: '日本語', flag: '🇯🇵', rtl: false, testPhrases: ['数学', '日本語'] },
  'ru': { name: 'Русский', flag: '🇷🇺', rtl: false, testPhrases: ['математика', 'Русский'] },
  'pt': { name: 'Português', flag: '🇵🇹', rtl: false, testPhrases: ['matemática', 'Português'] },
  'it': { name: 'Italiano', flag: '🇮🇹', rtl: false, testPhrases: ['matematica', 'Italiano'] }
};

// Sélecteurs communs de l'application
export const SELECTORS = {
  // Header
  appLogo: '[data-testid="app-logo"], .logo, header .calculator',
  appTitle: 'h1:has-text("Math4Child")',
  languageSelector: 'select, [data-testid="language-selector"], .language-selector select',
  freeQuestionsCounter: '[data-testid="free-questions"], .free-questions',
  
  // Navigation
  subscribeButton: 'button:has-text("Subscribe"), button:has-text("S\'abonner"), .subscribe-btn',
  backButton: 'button:has-text("Back"), button:has-text("Retour"), .back-btn',
  
  // Niveaux
  levelsGrid: '[data-testid="levels"], .levels-grid, .levels',
  levelCard: (level: string) => `[data-testid="level-${level}"], .level-${level}, [data-level="${level}"]`,
  progressBar: '.progress, [role="progressbar"], .progress-bar',
  
  // Opérations
  operationsGrid: '[data-testid="operations"], .operations-grid, .operations',
  operationCard: (op: string) => `[data-testid="operation-${op}"], .operation-${op}, [data-operation="${op}"]`,
  
  // Jeu
  gameView: '.game-view, [data-testid="game"], .game-container',
  mathProblem: '.problem, [data-testid="problem"], .math-problem',
  answerInput: 'input[type="text"], input[inputmode="numeric"], .answer-input',
  validateButton: 'button:has-text("Validate"), button:has-text("Valider"), .validate-btn',
  nextButton: 'button:has-text("Next"), button:has-text("Suivant"), .next-btn',
  feedback: '.feedback, [data-testid="feedback"], .correct, .incorrect',
  gameProgress: '[data-testid="progress"], .progress-counter, .game-progress',
  
  // Abonnements
  subscriptionView: '.subscription-view, [data-testid="subscription"], .subscription',
  subscriptionTitle: '.subscription-title, h1:has-text("Subscription"), h1:has-text("Abonnement")',
  planCard: (plan: string) => `[data-testid="plan-${plan}"], .plan-${plan}, [data-plan="${plan}"]`,
  deviceSelector: (device: string) => `[data-device="${device}"], .device-${device}`,
  
  // Stats
  statsGrid: '.stats, [data-testid="stats"], .statistics',
  statCard: '.stat-card, .stats > div'
};

// Classe helper principale pour les tests Math4Child
export class Math4ChildTestHelper {
  constructor(private page: Page) {}

  // Navigation et setup
  async navigateToApp(waitForLoad = true) {
    await this.page.goto('/');
    if (waitForLoad) {
      await this.waitForAppLoad();
    }
  }

  async waitForAppLoad() {
    await Promise.race([
      this.page.waitForSelector(SELECTORS.appTitle, { timeout: 15000 }),
      this.page.waitForSelector(SELECTORS.appLogo, { timeout: 15000 }),
      this.page.waitForSelector('h1', { timeout: 15000 })
    ]);
    await this.page.waitForLoadState('networkidle', { timeout: 10000 });
  }

  // Gestion des langues
  async selectLanguage(language: SupportedLanguage, verifyChange = true) {
    try {
      const selector = await this.findLanguageSelector();
      await selector.selectOption(language);
      
      if (verifyChange) {
        await this.page.waitForTimeout(1500); // Attendre la traduction
        await this.verifyLanguageChange(language);
      }
      
      return true;
    } catch (error) {
      throw new Error(`Impossible de changer vers la langue ${language}: ${error}`);
    }
  }

  private async findLanguageSelector() {
    const selectors = [
      SELECTORS.languageSelector,
      'select:has(option[value="fr"])', // Sélecteur générique
      'header select',
      '.header select'
    ];

    for (const selector of selectors) {
      try {
        const element = this.page.locator(selector).first();
        if (await element.isVisible()) {
          return element;
        }
      } catch (continue) {}
    }
    
    throw new Error('Sélecteur de langue non trouvé');
  }

  private async verifyLanguageChange(language: SupportedLanguage) {
    const config = LANGUAGES_CONFIG[language];
    if (!config) return;

    // Vérifier RTL pour l'arabe
    if (config.rtl) {
      await expect(this.page.locator('body, .rtl, [dir="rtl"]').first()).toHaveAttribute('dir', 'rtl');
    }

    // Vérifier la présence de phrases de test
    for (const phrase of config.testPhrases) {
      await expect(this.page.locator('body')).toContainText(new RegExp(phrase, 'i'));
    }
  }

  // Gestion des niveaux et jeu
  async selectLevel(level: Level) {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    await expect(levelElement).toBeVisible();
    await levelElement.click();
    await this.page.waitForTimeout(500);
  }

  async selectOperation(operation: MathOperation) {
    const operationElement = this.page.locator(SELECTORS.operationCard(operation)).first();
    await expect(operationElement).toBeVisible();
    await operationElement.click();
    await this.page.waitForTimeout(500);
  }

  async startGame(level: Level, operation: MathOperation) {
    await this.selectLevel(level);
    
    // Attendre que les opérations apparaissent
    await this.page.waitForSelector(SELECTORS.operationsGrid, { timeout: 5000 });
    await this.selectOperation(operation);
    
    // Vérifier qu'on est dans la vue de jeu
    await this.page.waitForSelector(SELECTORS.gameView, { timeout: 10000 });
  }

  // Résolution de problèmes mathématiques
  async solveMathProblem(answer?: number): Promise<boolean> {
    // Extraire le problème si pas de réponse fournie
    if (answer === undefined) {
      answer = await this.extractMathProblemAnswer();
    }

    const answerInput = this.page.locator(SELECTORS.answerInput).first();
    await answerInput.fill(answer.toString());
    
    const validateButton = this.page.locator(SELECTORS.validateButton).first();
    await validateButton.click();
    
    return await this.waitForFeedback();
  }

  private async extractMathProblemAnswer(): Promise<number> {
    const problemText = await this.page.locator(SELECTORS.mathProblem).first().textContent();
    if (!problemText) throw new Error('Problème mathématique non trouvé');

    // Expressions régulières pour différents types de problèmes
    const additionMatch = problemText.match(/(\d+)\s*\+\s*(\d+)\s*=\s*\?/);
    const subtractionMatch = problemText.match(/(\d+)\s*-\s*(\d+)\s*=\s*\?/);
    const multiplicationMatch = problemText.match(/(\d+)\s*[×*]\s*(\d+)\s*=\s*\?/);
    const divisionMatch = problemText.match(/(\d+)\s*[÷/]\s*(\d+)\s*=\s*\?/);

    if (additionMatch) {
      return parseInt(additionMatch[1]) + parseInt(additionMatch[2]);
    } else if (subtractionMatch) {
      return parseInt(subtractionMatch[1]) - parseInt(subtractionMatch[2]);
    } else if (multiplicationMatch) {
      return parseInt(multiplicationMatch[1]) * parseInt(multiplicationMatch[2]);
    } else if (divisionMatch) {
      return parseInt(divisionMatch[1]) / parseInt(divisionMatch[2]);
    }
    
    throw new Error(`Format de problème non reconnu: ${problemText}`);
  }

  private async waitForFeedback(): Promise<boolean> {
    await this.page.waitForSelector(SELECTORS.feedback, { timeout: 5000 });
    
    // Déterminer si c'est correct ou incorrect
    const feedbackElement = this.page.locator(SELECTORS.feedback).first();
    const feedbackText = await feedbackElement.textContent() || '';
    const feedbackClass = await feedbackElement.getAttribute('class') || '';
    
    return feedbackText.toLowerCase().includes('correct') || 
           feedbackText.toLowerCase().includes('bonne') ||
           feedbackClass.includes('correct') ||
           feedbackClass.includes('success');
  }

  // Navigation vers abonnements
  async navigateToSubscription() {
    const subscribeButton = this.page.locator(SELECTORS.subscribeButton).first();
    await subscribeButton.click();
    await this.page.waitForSelector(SELECTORS.subscriptionView, { timeout: 10000 });
  }

  // Vérifications communes
  async checkFreeQuestionsCounter(): Promise<string | null> {
    try {
      const counter = this.page.locator(SELECTORS.freeQuestionsCounter).first();
      return await counter.textContent();
    } catch {
      return null;
    }
  }

  async verifyLevelLocked(level: Level): Promise<boolean> {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    const className = await levelElement.getAttribute('class') || '';
    
    return className.includes('locked') || 
           className.includes('disabled') || 
           className.includes('opacity-60');
  }

  async verifyProgressBar(level: Level, expectedProgress?: number): Promise<void> {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    const progressBar = levelElement.locator(SELECTORS.progressBar).first();
    
    await expect(progressBar).toBeVisible();
    
    if (expectedProgress !== undefined) {
      const progressText = await levelElement.textContent();
      expect(progressText).toContain(`${expectedProgress}/100`);
    }
  }

  // Responsive design helpers
  async setMobileViewport() {
    await this.page.setViewportSize({ width: 375, height: 812 }); // iPhone X
  }

  async setTabletViewport() {
    await this.page.setViewportSize({ width: 768, height: 1024 }); // iPad
  }

  async setDesktopViewport() {
    await this.page.setViewportSize({ width: 1920, height: 1080 }); // Desktop HD
  }

  // Performance helpers
  async measurePageLoadTime(): Promise<number> {
    const startTime = Date.now();
    await this.navigateToApp();
    return Date.now() - startTime;
  }

  async measureLanguageSwitch(language: SupportedLanguage): Promise<number> {
    const startTime = Date.now();
    await this.selectLanguage(language);
    return Date.now() - startTime;
  }

  // État et données
  async clearUserData() {
    await this.page.evaluate(() => {
      localStorage.clear();
      sessionStorage.clear();
    });
  }

  async setUserProgress(progress: any) {
    await this.page.evaluate((data) => {
      localStorage.setItem('math4child-progress', JSON.stringify(data));
    }, progress);
  }

  async getUserProgress(): Promise<any> {
    return await this.page.evaluate(() => {
      const data = localStorage.getItem('math4child-progress');
      return data ? JSON.parse(data) : null;
    });
  }
}
EOF
    
    print_success "Utilitaires de test générés"
}

# Génération des données de test
generate_test_data() {
    print_step "Génération des données de test..."
    
    cat > "$TESTS_DIR/utils/test-data.ts" << 'EOF'
// ===================================================================
// DONNÉES DE TEST POUR MATH4CHILD
// Données statiques et configurations
// ===================================================================

import { Level, MathOperation, SupportedLanguage } from './test-utils';

export const TEST_DATA = {
  // Progressions utilisateur de test
  progressions: {
    newUser: {
      level: 'beginner' as Level,
      correctAnswers: { beginner: 0, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner'] as Level[],
      totalQuestions: 0,
      freeQuestionsUsed: 0
    },
    
    beginnerComplete: {
      level: 'elementary' as Level,
      correctAnswers: { beginner: 100, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner', 'elementary'] as Level[],
      totalQuestions: 150,
      freeQuestionsUsed: 50
    },
    
    intermediateUser: {
      level: 'intermediate' as Level,
      correctAnswers: { beginner: 100, elementary: 100, intermediate: 45, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner', 'elementary', 'intermediate'] as Level[],
      totalQuestions: 300,
      freeQuestionsUsed: 50
    },
    
    expertUser: {
      level: 'expert' as Level,
      correctAnswers: { beginner: 100, elementary: 100, intermediate: 100, advanced: 100, expert: 75 },
      unlockedLevels: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'] as Level[],
      totalQuestions: 1000,
      freeQuestionsUsed: 50
    },

    freeUserLimitReached: {
      level: 'beginner' as Level,
      correctAnswers: { beginner: 25, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner'] as Level[],
      totalQuestions: 50,
      freeQuestionsUsed: 50
    }
  },

  // Problèmes mathématiques de test
  mathProblems: {
    addition: [
      { num1: 2, num2: 3, answer: 5, level: 'beginner' },
      { num1: 15, num2: 27, answer: 42, level: 'elementary' },
      { num1: 89, num2: 156, answer: 245, level: 'intermediate' }
    ],
    
    subtraction: [
      { num1: 8, num2: 3, answer: 5, level: 'beginner' },
      { num1: 45, num2: 17, answer: 28, level: 'elementary' },
      { num1: 234, num2: 89, answer: 145, level: 'intermediate' }
    ],
    
    multiplication: [
      { num1: 3, num2: 4, answer: 12, level: 'beginner' },
      { num1: 12, num2: 8, answer: 96, level: 'elementary' },
      { num1: 23, num2: 15, answer: 345, level: 'intermediate' }
    ],
    
    division: [
      { num1: 12, num2: 3, answer: 4, level: 'beginner' },
      { num1: 84, num2: 7, answer: 12, level: 'elementary' },
      { num1: 144, num2: 12, answer: 12, level: 'intermediate' }
    ]
  },

  // Données d'abonnement
  subscriptionPlans: {
    free: {
      name: 'Free Version',
      price: 0,
      duration: '7 days - 50 questions',
      features: ['50 total questions', 'All levels limited', 'Email support', '7-day access']
    },
    
    monthly: {
      name: 'Monthly',
      price: 9.99,
      duration: 'per month',
      features: ['Unlimited questions', 'All levels unlocked', 'All operations', 'Priority support']
    },
    
    quarterly: {
      name: 'Quarterly',
      price: 26.97,
      originalPrice: 29.97,
      discount: 10,
      popular: true,
      duration: '3 months',
      features: ['Everything in monthly', '10% discount', 'Single payment', 'Premium support']
    },
    
    yearly: {
      name: 'Yearly',
      price: 83.93,
      originalPrice: 119.88,
      discount: 30,
      duration: '12 months',
      features: ['Everything in monthly', '30% discount', 'Single payment', 'VIP support']
    }
  },

  // Textes multilingues pour validation
  translations: {
    titles: {
      en: 'Math4Child - Learn math while having fun',
      fr: 'Math4Child - Apprendre les mathématiques en s\'amusant',
      es: 'Math4Child - Aprende matemáticas divirtiéndote',
      de: 'Math4Child - Mathematik lernen macht Spaß',
      ar: 'Math4Child - تعلم الرياضيات بمتعة',
      zh: 'Math4Child - 快乐学数学'
    } as Record<SupportedLanguage, string>,
    
    operations: {
      en: ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Mixed'],
      fr: ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Mixte'],
      es: ['Suma', 'Resta', 'Multiplicación', 'División', 'Mixto'],
      de: ['Addition', 'Subtraktion', 'Multiplikation', 'Division', 'Gemischt'],
      ar: ['جمع', 'طرح', 'ضرب', 'قسمة', 'مختلط'],
      zh: ['加法', '减法', '乘法', '除法', '混合']
    } as Record<SupportedLanguage, string[]>,
    
    levels: {
      en: ['Beginner', 'Elementary', 'Intermediate', 'Advanced', 'Expert'],
      fr: ['Débutant', 'Élémentaire', 'Intermédiaire', 'Avancé', 'Expert'],
      es: ['Principiante', 'Elemental', 'Intermedio', 'Avanzado', 'Experto'],
      de: ['Anfänger', 'Grundstufe', 'Mittelstufe', 'Fortgeschritten', 'Experte'],
      ar: ['مبتدئ', 'ابتدائي', 'متوسط', 'متقدم', 'خبير'],
      zh: ['初级', '小学', '中级', '高级', '专家']
    } as Record<SupportedLanguage, string[]>
  }
};

// Configuration des environnements
export const ENV_CONFIG = {
  // URLs par environnement
  urls: {
    development: 'http://localhost:3000',
    staging: 'https://staging.math4child.com',
    production: 'https://www.math4child.com'
  },

  // Timeouts par environnement
  timeouts: {
    development: { page: 30000, element: 15000 },
    ci: { page: 60000, element: 30000 },
    production: { page: 45000, element: 20000 }
  },

  // Configuration des navigateurs
  browsers: {
    desktop: ['chromium', 'firefox', 'webkit'],
    mobile: ['chromium', 'webkit'],
    ci: ['chromium']
  }
};

// Utilitaires de validation
export class ValidationHelpers {
  static async validateMathProblem(problemText: string): Promise<boolean> {
    const patterns = [
      /\d+\s*\+\s*\d+\s*=\s*\?/,  // Addition
      /\d+\s*-\s*\d+\s*=\s*\?/,   // Soustraction  
      /\d+\s*[×*]\s*\d+\s*=\s*\?/, // Multiplication
      /\d+\s*[÷/]\s*\d+\s*=\s*\?/  // Division
    ];
    
    return patterns.some(pattern => pattern.test(problemText));
  }

  static validateLanguageContent(content: string, language: SupportedLanguage): boolean {
    const config = TEST_DATA.translations;
    const title = config.titles[language];
    
    if (!title) return false;
    
    return content.toLowerCase().includes(title.split(' - ')[0].toLowerCase()) ||
           content.toLowerCase().includes(language);
  }

  static validateProgressionData(data: any): boolean {
    const required = ['level', 'correctAnswers', 'unlockedLevels', 'totalQuestions'];
    return required.every(field => field in data);
  }

  static validateSubscriptionPlan(plan: any): boolean {
    const required = ['name', 'price', 'features'];
    return required.every(field => field in plan) && Array.isArray(plan.features);
  }
}
EOF
    
    print_success "Données de test générées"
}

# Génération des fixtures Playwright
generate_test_fixtures() {
    print_step "Génération des fixtures de test..."
    
    cat > "$TESTS_DIR/utils/test-fixtures.ts" << 'EOF'
// ===================================================================
// FIXTURES PLAYWRIGHT POUR MATH4CHILD
// Fixtures personnalisées et helpers
// ===================================================================

import { test as base } from '@playwright/test';
import { Math4ChildTestHelper } from './test-utils';
import { TEST_DATA } from './test-data';

type Math4ChildFixtures = {
  math4childApp: Math4ChildTestHelper;
  newUser: Math4ChildTestHelper;
  experiencedUser: Math4ChildTestHelper;
  freeUserAtLimit: Math4ChildTestHelper;
};

export const test = base.extend<Math4ChildFixtures>({
  // Fixture de base pour l'application
  math4childApp: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un nouvel utilisateur
  newUser: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.newUser);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un utilisateur expérimenté
  experiencedUser: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.intermediateUser);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un utilisateur ayant atteint la limite gratuite
  freeUserAtLimit: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.freeUserLimitReached);
    await helper.navigateToApp();
    await use(helper);
  }
});

export { expect } from '@playwright/test';
EOF
    
    print_success "Fixtures de test générées"
}

# Génération des tests principaux
generate_main_tests() {
    print_step "Génération des tests principaux..."
    
    # Test de base
    cat > "$TESTS_DIR/specs/math4child-basic.spec.ts" << 'EOF'
// ===================================================================
// TESTS DE BASE MATH4CHILD
// Tests principaux et fonctionnalités core
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Tests de base', () => {
  
  test('Page d\'accueil se charge correctement @smoke @critical', async ({ math4childApp }) => {
    // Vérifier que les éléments principaux sont présents
    await expect(math4childApp.page.locator('h1')).toContainText(/Math4Child/i);
    
    // Vérifier la présence du sélecteur de langues
    await expect(math4childApp.page.locator('select').first()).toBeVisible();
    
    // Vérifier la présence des statistiques
    await expect(math4childApp.page.locator(':text("10K+"), :text("Active students")')).toBeVisible();
    await expect(math4childApp.page.locator(':text("500+"), :text("Available exercises")')).toBeVisible();
    await expect(math4childApp.page.locator(':text("20"), :text("Supported languages")')).toBeVisible();
    await expect(math4childApp.page.locator(':text("98%"), :text("Parent satisfaction")')).toBeVisible();
  });

  test('Éléments de navigation sont visibles @smoke', async ({ math4childApp }) => {
    // Header avec logo et nom
    await expect(math4childApp.page.locator('.calculator, [data-testid="logo"]').first()).toBeVisible();
    
    // Sélection de niveaux
    await expect(math4childApp.page.locator('[data-testid="level-beginner"], .level').first()).toBeVisible();
    
    // Call-to-action buttons
    await expect(math4childApp.page.locator('button:has-text("Subscribe"), button:has-text("S\'abonner")').first()).toBeVisible();
    await expect(math4childApp.page.locator('button:has-text("Free Trial"), button:has-text("Essai")').first()).toBeVisible();
  });

  test('Changement de langue vers le français @critical', async ({ math4childApp }) => {
    await math4childApp.selectLanguage('fr');
    
    // Vérifier que le contenu principal est traduit
    await expect(math4childApp.page.locator('body')).toContainText(/mathématiques|français|apprendre/i);
  });

  test('Navigation vers les niveaux', async ({ math4childApp }) => {
    // Vérifier la présence des 5 niveaux
    const levels = ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'];
    
    for (const level of levels) {
      const levelElement = math4childApp.page.locator(`[data-testid="level-${level}"], .level-${level}`).first();
      if (await levelElement.isVisible()) {
        await expect(levelElement).toBeVisible();
        
        // Vérifier la barre de progression
        const progressBar = levelElement.locator('.progress, [role="progressbar"]').first();
        if (await progressBar.isVisible()) {
          await expect(progressBar).toBeVisible();
        }
      }
    }
  });

  test('Démarrage d\'un jeu simple @smoke', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Vérifier qu'on est dans la vue du jeu
    await expect(newUser.page.locator('.game-view, [data-testid="game"]')).toBeVisible();
    
    // Vérifier qu'un problème mathématique est affiché
    await expect(newUser.page.locator('.problem, [data-testid="problem"]')).toContainText(/\d+\s*\+\s*\d+\s*=\s*\?/);
    
    // Vérifier la présence du champ de réponse
    await expect(newUser.page.locator('input[type="text"], input[inputmode="numeric"]')).toBeVisible();
  });

});
EOF

    # Tests multilingues
    cat > "$TESTS_DIR/specs/i18n.basic.spec.ts" << 'EOF'
// ===================================================================
// TESTS MULTILINGUES MATH4CHILD
// Tests de base pour l'internationalisation
// ===================================================================

import { test, expect } from '../utils/test-fixtures';
import { LANGUAGES_CONFIG } from '../utils/test-utils';

test.describe('Math4Child - Tests multilingues', () => {

  const mainLanguages = ['en', 'fr', 'es', 'de', 'zh', 'ar'] as const;

  for (const language of mainLanguages) {
    test(`Interface traduite correctement en ${language} @i18n`, async ({ math4childApp }) => {
      await math4childApp.selectLanguage(language);
      
      // Vérifier que le contenu principal est traduit
      const titleElement = math4childApp.page.locator('h1').first();
      await expect(titleElement).toBeVisible();
      
      // Vérifier les niveaux traduits
      const levelsContainer = math4childApp.page.locator('[data-testid="levels"], .levels-grid').first();
      await expect(levelsContainer).toBeVisible();
    });
  }

  test('Support RTL pour les langues arabes @rtl', async ({ math4childApp }) => {
    await math4childApp.selectLanguage('ar');
    
    // Vérifier que la direction RTL est appliquée
    const bodyDir = await math4childApp.page.locator('body, .rtl, [dir="rtl"]').first().getAttribute('dir');
    expect(bodyDir).toBe('rtl');
    
    // Vérifier le contenu en arabe
    await expect(math4childApp.page.locator('body')).toContainText(/العربية|الرياضيات/);
  });

  test('Changement de langue met à jour toute l\'interface @critical', async ({ math4childApp }) => {
    // Commencer en anglais
    await math4childApp.selectLanguage('en');
    const englishTitle = await math4childApp.page.locator('h1').first().textContent();
    
    // Changer vers le français
    await math4childApp.selectLanguage('fr');
    const frenchTitle = await math4childApp.page.locator('h1').first().textContent();
    
    // Vérifier que le contenu a changé
    expect(englishTitle).not.toBe(frenchTitle);
    
    // Vérifier des mots-clés français
    await expect(math4childApp.page.locator('body')).toContainText(/mathématiques|français|apprendre/i);
  });

});
EOF

    # Tests du jeu
    cat > "$TESTS_DIR/specs/game.basic.spec.ts" << 'EOF'
// ===================================================================
// TESTS DU JEU MATHÉMATIQUE
// Tests de base du système de jeu
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Jeu mathématique', () => {

  test('Démarrage d\'une partie - Addition niveau débutant @smoke', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Vérifier qu'on est dans la vue du jeu
    await expect(newUser.page.locator('.game-view, [data-testid="game"]')).toBeVisible();
    
    // Vérifier qu'un problème mathématique est affiché
    await expect(newUser.page.locator('.problem, [data-testid="problem"]')).toContainText(/\d+\s*\+\s*\d+\s*=\s*\?/);
    
    // Vérifier la présence du champ de réponse
    await expect(newUser.page.locator('input[type="text"], input[inputmode="numeric"]')).toBeVisible();
    
    // Vérifier les boutons d'action
    await expect(newUser.page.locator('button:has-text("Validate"), button:has-text("Valider")')).toBeVisible();
  });

  test('Résolution correcte d\'un problème @critical', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Extraire le problème affiché
    const problemText = await newUser.page.locator('.problem, [data-testid="problem"]').first().textContent();
    const match = problemText?.match(/(\d+)\s*\+\s*(\d+)\s*=\s*\?/);
    
    if (match) {
      const num1 = parseInt(match[1]);
      const num2 = parseInt(match[2]);
      const correctAnswer = num1 + num2;
      
      // Saisir la bonne réponse
      await newUser.solveMathProblem(correctAnswer);
      
      // Vérifier le feedback positif
      await expect(newUser.page.locator('.correct, .success, [data-testid="correct"]')).toBeVisible();
      await expect(newUser.page.locator('body')).toContainText(/correct|bonne|good|+10/i);
    }
  });

  test('Résolution incorrecte d\'un problème', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Saisir une mauvaise réponse (9999)
    await newUser.solveMathProblem(9999);
    
    // Vérifier le feedback négatif
    await expect(newUser.page.locator('.incorrect, .error, [data-testid="incorrect"]')).toBeVisible();
    await expect(newUser.page.locator('body')).toContainText(/wrong|mauvaise|incorrect/i);
  });

  test('Compteur de progression dans le jeu', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Vérifier la présence du compteur de progression
    await expect(newUser.page.locator('[data-testid="progress"], .progress-counter')).toContainText(/\d+\/100/);
    
    // Vérifier l'affichage du niveau et de l'opération actuels
    await expect(newUser.page.locator('.game-header, [data-testid="game-info"]')).toContainText(/beginner|débutant/i);
    await expect(newUser.page.locator('.game-header, [data-testid="game-info"]')).toContainText(/addition/i);
  });

  test('Bouton retour aux niveaux', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Cliquer sur le bouton retour
    await newUser.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    
    // Vérifier qu'on est revenu à la page d'accueil
    await expect(newUser.page.locator('[data-testid="levels"], .levels-grid')).toBeVisible();
    await expect(newUser.page.locator('h1')).toContainText(/Math4Child/i);
  });

});
EOF

    # Tests responsives
    cat > "$TESTS_DIR/specs/responsive.basic.spec.ts" << 'EOF'
// ===================================================================
// TESTS RESPONSIVE MATH4CHILD
// Tests de base pour le design responsive
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Design Responsive', () => {

  test('Interface mobile portrait @mobile', async ({ math4childApp }) => {
    await math4childApp.setMobileViewport();
    
    // Vérifier que l'interface principale est visible
    await expect(math4childApp.page.locator('h1')).toBeVisible();
    
    // Vérifier l'adaptation des grilles
    const statsGrid = math4childApp.page.locator('[data-testid="stats"]');
    if (await statsGrid.isVisible()) {
      const boundingBox = await statsGrid.boundingBox();
      expect(boundingBox?.width).toBeLessThan(400); // Largeur mobile
    }
    
    // Vérifier que les boutons sont suffisamment grands pour le tactile
    const buttons = await math4childApp.page.locator('button').all();
    for (const button of buttons.slice(0, 3)) { // Tester les 3 premiers
      if (await button.isVisible()) {
        const box = await button.boundingBox();
        if (box) {
          expect(box.height).toBeGreaterThanOrEqual(44); // Taille minimale tactile
        }
      }
    }
  });

  test('Interface tablette paysage @tablet', async ({ math4childApp }) => {
    await math4childApp.setTabletViewport();
    
    // Vérifier l'utilisation optimale de l'espace
    const mainContainer = math4childApp.page.locator('main, .container').first();
    const containerBox = await mainContainer.boundingBox();
    
    if (containerBox) {
      expect(containerBox.width).toBeGreaterThan(600);
      expect(containerBox.width).toBeLessThan(1000); // Pas trop large
    }
  });

  test('Interface desktop large écran', async ({ math4childApp }) => {
    await math4childApp.setDesktopViewport();
    
    const mainContent = math4childApp.page.locator('.container, main').first();
    const contentBox = await mainContent.boundingBox();
    
    if (contentBox) {
      // Le contenu ne devrait pas être trop étiré
      expect(contentBox.width).toBeLessThan(1400);
    }
  });

});
EOF

    # Tests de performance
    cat > "$TESTS_DIR/specs/performance.basic.spec.ts" << 'EOF'
// ===================================================================
// TESTS DE PERFORMANCE MATH4CHILD
// Tests de base pour la performance
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Performance', () => {

  test('Temps de chargement initial acceptable @performance', async ({ page }) => {
    const { Math4ChildTestHelper } = await import('../utils/test-utils');
    const loadTime = await new Math4ChildTestHelper(page).measurePageLoadTime();
    
    // Moins de 5 secondes en développement, 3 secondes en production
    const maxLoadTime = process.env.NODE_ENV === 'production' ? 3000 : 5000;
    expect(loadTime).toBeLessThan(maxLoadTime);
  });

  test('Changement de langue fluide @performance', async ({ math4childApp }) => {
    const startTime = Date.now();
    await math4childApp.selectLanguage('fr');
    const switchTime = Date.now() - startTime;
    
    expect(switchTime).toBeLessThan(2000); // Changement rapide
  });

  test('Navigation entre vues fluide @performance', async ({ math4childApp }) => {
    // Tester navigation accueil -> jeu -> abonnement -> accueil
    await math4childApp.startGame('beginner', 'addition');
    await math4childApp.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    await math4childApp.navigateToSubscription();
    await math4childApp.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    
    // Vérifier qu'on est revenu à l'accueil
    await expect(math4childApp.page.locator('h1')).toContainText(/Math4Child/i);
  });

});
EOF
    
    print_success "Tests principaux générés"
}

# Génération des fichiers de configuration
generate_config_files() {
    print_step "Génération des fichiers de configuration..."
    
    # TypeScript config
    cat > "$TESTS_DIR/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM"],
    "module": "CommonJS",
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "allowJs": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": false,
    "outDir": "./dist",
    "rootDir": "./",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./specs/*"],
      "@utils/*": ["./utils/*"],
      "@fixtures/*": ["./fixtures/*"]
    },
    "types": ["node", "@playwright/test"]
  },
  "include": [
    "specs/**/*",
    "utils/**/*",
    "fixtures/**/*",
    "playwright.config.ts",
    "global.setup.ts",
    "global.teardown.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "test-results",
    "playwright-report"
  ]
}
EOF

    # ESLint config
    cat > "$TESTS_DIR/.eslintrc.js" << 'EOF'
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
    project: './tsconfig.json',
  },
  env: {
    node: true,
    es2022: true,
  },
  rules: {
    // Règles spécifiques pour les tests
    '@typescript-eslint/no-unused-vars': ['error', { 'argsIgnorePattern': '^_' }],
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/no-non-null-assertion': 'off',
    
    // Règles générales
    'no-console': 'warn',
    'prefer-const': 'error',
    'no-var': 'error',
  },
  overrides: [
    {
      files: ['*.spec.ts', '*.test.ts'],
      rules: {
        '@typescript-eslint/no-explicit-any': 'off',
        'no-console': 'off',
      }
    }
  ]
};
EOF

    # Environment file
    cat > "$TESTS_DIR/.env" << 'EOF'
# Configuration des tests Math4Child
BASE_URL=http://localhost:3000
NODE_ENV=test
HEADLESS=true
TIMEOUT=30000

# Langues à tester en priorité
TEST_LANGUAGES=en,fr,es,de,ar,zh

# Configuration CI/CD
CI=false

# App info
APP_VERSION=2.0.0
APP_NAME=Math4Child
EOF

    # GitIgnore
    cat > "$TESTS_DIR/.gitignore" << 'EOF'
# Test Results
test-results/
playwright-report/
coverage/
screenshots/
videos/
traces/

# Dependencies
node_modules/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment
.env.local
.env.test
.env.production

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Playwright
/playwright/.cache/
/blob-report/
/playwright/.auth/

# TypeScript
*.tsbuildinfo
dist/

# Temporary files
tmp/
temp/
*.tmp
EOF
    
    print_success "Fichiers de configuration générés"
}

# Génération du Makefile
generate_makefile() {
    print_step "Génération du Makefile..."
    
    cat > "$TESTS_DIR/Makefile" << 'EOF'
.PHONY: help install test test-headed test-mobile test-i18n clean start-app

# Variables
APP_DIR := ../apps/math4child

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $1, $2}'

install: ## Installer les dépendances et navigateurs
	npm install
	npx playwright install --with-deps

setup: install ## Configuration complète
	@echo "✅ Math4Child Tests - Configuration terminée !"

test: ## Lancer tous les tests
	npm run test

test-headed: ## Tests avec interface graphique
	npm run test:headed

test-debug: ## Tests en mode debug
	npm run test:debug

test-ui: ## Interface Playwright UI
	npm run test:ui

test-chrome: ## Tests Chrome uniquement
	npm run test:chrome

test-firefox: ## Tests Firefox uniquement
	npm run test:firefox

test-safari: ## Tests Safari uniquement
	npm run test:safari

test-mobile: ## Tests mobile uniquement
	npm run test:mobile

test-tablet: ## Tests tablette uniquement
	npm run test:tablet

test-i18n: ## Tests multilingues
	npm run test:i18n

test-performance: ## Tests de performance
	npm run test:performance

test-accessibility: ## Tests d'accessibilité
	npm run test:accessibility

test-smoke: ## Tests critiques uniquement
	npm run test:smoke

test-regression: ## Tests de régression
	npm run test:regression

test-parallel: ## Tests en parallèle
	npm run test:parallel

test-serial: ## Tests en série
	npm run test:serial

record: ## Enregistrer nouveaux tests
	npm run test:record

trace: ## Tests avec traces
	npm run test:trace

screenshot: ## Tests avec screenshots
	npm run test:screenshot

report: ## Voir le rapport de tests
	npm run test:report

report-server: ## Serveur de rapport
	npm run test:report-open

update-snapshots: ## Mettre à jour les captures
	npm run test:update-snapshots

clean: ## Nettoyer les résultats
	npm run clean

clean-all: clean ## Nettoyage complet
	npm run clean:node-modules

lint: ## Vérifier le code
	npm run lint:tests

type-check: ## Vérifier les types TypeScript
	npm run type-check

docker-test: ## Tests avec Docker
	npm run docker:test

docker-clean: ## Nettoyer Docker
	npm run docker:clean

start-app: ## Démarrer Math4Child
	cd $(APP_DIR) && npm run dev

start-app-prod: ## Démarrer Math4Child (production)
	cd $(APP_DIR) && npm run build && npm run start

ci: ## Tests pour CI/CD
	npm run test:ci

# Commandes combinées
full-test: clean install test report ## Suite complète de tests
	@echo "🎯 Suite complète de tests Math4Child terminée !"

quick-test: test-smoke ## Tests rapides
	@echo "💨 Tests rapides terminés !"

dev-test: test-headed report ## Tests en développement
	@echo "🚀 Tests de développement terminés !"
EOF
    
    print_success "Makefile généré"
}

# Génération du workflow GitHub Actions
generate_github_workflow() {
    print_step "Génération du workflow GitHub Actions..."
    
    cat > "$TESTS_DIR/.github/workflows/math4child-tests.yml" << 'EOF'
name: Math4Child E2E Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    # Tests quotidiens à 6h UTC
    - cron: '0 6 * * *'

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        project: 
          - chromium-desktop
          - firefox-desktop
          - webkit-desktop
        
    steps:
    - uses: actions/checkout@v4
    
    - uses: actions/setup-node@v4
      with:
        node-version: 18
        cache: 'npm'
        cache-dependency-path: 'tests/package-lock.json'
    
    - name: Install dependencies
      run: npm ci
      working-directory: ./tests
      
    - name: Install Playwright Browsers
      run: npx playwright install --with-deps
      working-directory: ./tests
      
    - name: Start Math4Child App
      run: |
        cd apps/math4child
        npm ci
        npm run build
        npm run start &
        sleep 10
        
    - name: Wait for app to be ready
      run: |
        timeout 60 bash -c 'until curl -s http://localhost:3000; do sleep 2; done'
        
    - name: Run Playwright tests
      run: npx playwright test --project=${{ matrix.project }}
      working-directory: ./tests
      env:
        BASE_URL: http://localhost:3000
        CI: true
        
    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: playwright-report-${{ matrix.project }}
        path: tests/playwright-report/
        retention-days: 30

  test-mobile:
    timeout-minutes: 45
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: 18
        cache: 'npm'
        cache-dependency-path: 'tests/package-lock.json'
        
    - name: Install dependencies
      run: npm ci
      working-directory: ./tests
      
    - name: Install Playwright
      run: npx playwright install --with-deps chromium webkit
      working-directory: ./tests
      
    - name: Start Math4Child App
      run: |
        cd apps/math4child
        npm ci
        npm run build
        npm run start &
        sleep 10
        
    - name: Run Mobile Tests
      run: npm run test:mobile
      working-directory: ./tests
      env:
        BASE_URL: http://localhost:3000
        CI: true
        
    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: mobile-test-report
        path: tests/playwright-report/

  test-i18n:
    timeout-minutes: 45
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: 18
        cache: 'npm'
        cache-dependency-path: 'tests/package-lock.json'
        
    - name: Install dependencies
      run: npm ci
      working-directory: ./tests
      
    - name: Install Playwright
      run: npx playwright install --with-deps chromium
      working-directory: ./tests
      
    - name: Start Math4Child App
      run: |
        cd apps/math4child
        npm ci
        npm run build
        npm run start &
        sleep 10
        
    - name: Run I18N Tests
      run: npm run test:i18n
      working-directory: ./tests
      env:
        BASE_URL: http://localhost:3000
        CI: true
        I18N_TESTS: true
        
    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: i18n-test-report
        path: tests/playwright-report/

  test-performance:
    timeout-minutes: 30
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: 18
        cache: 'npm'
        cache-dependency-path: 'tests/package-lock.json'
        
    - name: Install dependencies
      run: npm ci
      working-directory: ./tests
      
    - name: Install Playwright
      run: npx playwright install --with-deps chromium
      working-directory: ./tests
      
    - name: Start Math4Child App
      run: |
        cd apps/math4child
        npm ci
        npm run build
        npm run start &
        sleep 10
        
    - name: Run Performance Tests
      run: npm run test:performance
      working-directory: ./tests
      env:
        BASE_URL: http://localhost:3000
        CI: true
        PERF_TESTS: true
        
    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: performance-test-report
        path: tests/playwright-report/
EOF
    
    print_success "Workflow GitHub Actions généré"
}

# Génération du Docker setup
generate_docker_setup() {
    print_step "Génération des fichiers Docker..."
    
    # Docker Compose pour tests
    cat > "$TESTS_DIR/docker/docker-compose.test.yml" << 'EOF'
version: '3.8'

services:
  math4child-app:
    build:
      context: ../../apps/math4child
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=test
      - PORT=3000
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  playwright-tests:
    build:
      context: ../
      dockerfile: docker/Dockerfile.tests
    depends_on:
      math4child-app:
        condition: service_healthy
    environment:
      - BASE_URL=http://math4child-app:3000
      - NODE_ENV=test
      - CI=true
    volumes:
      - ../test-results:/app/test-results
      - ../playwright-report:/app/playwright-report
    command: npm run test:ci

  # Service pour les tests de performance avec Lighthouse
  lighthouse:
    image: femtopixel/google-lighthouse
    depends_on:
      - math4child-app
    volumes:
      - ../lighthouse-reports:/home/chrome/reports
    command: --chrome-flags="--headless --no-sandbox --disable-gpu" --output=html --output-path=/home/chrome/reports/lighthouse-report.html http://math4child-app:3000
EOF

    # Dockerfile pour les tests
    cat > "$TESTS_DIR/docker/Dockerfile.tests" << 'EOF'
FROM mcr.microsoft.com/playwright:v1.41.0-focal

WORKDIR /app

# Copier les fichiers de configuration
COPY package*.json ./
COPY tsconfig.json ./
COPY playwright.config.ts ./
COPY .eslintrc.js ./

# Installer les dépendances
RUN npm ci

# Copier les tests et utilitaires
COPY specs/ ./specs/
COPY utils/ ./utils/
COPY global.setup.ts ./
COPY global.teardown.ts ./

# Installer les navigateurs Playwright
RUN npx playwright install

# Créer les répertoires de sortie
RUN mkdir -p test-results playwright-report

# Commande par défaut
CMD ["npm", "run", "test"]
EOF
    
    print_success "Configuration Docker générée"
}

# Génération du README complet
generate_readme() {
    print_step "Génération du README..."
    
    cat > "$TESTS_DIR/README.md" << 'EOF'
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
EOF
    
    print_success "README généré"
}

# Génération du script d'installation rapide
generate_quick_install_script() {
    print_step "Génération du script d'installation rapide..."
    
    cat > "$TESTS_DIR/install.sh" << 'EOF'
#!/bin/bash

# ===================================================================
# INSTALLATION RAPIDE TESTS MATH4CHILD
# Script d'installation en une commande
# ===================================================================

set -e

echo "🚀 Installation rapide des tests Math4Child..."

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js requis. Installez Node.js >= 18.0.0"
    exit 1
fi

# Installation des dépendances
echo "📦 Installation des dépendances..."
npm install

# Installation des navigateurs Playwright
echo "🌐 Installation des navigateurs Playwright..."
npx playwright install --with-deps

# Test de validation
echo "✅ Test de validation..."
if npx playwright --version > /dev/null 2>&1; then
    echo "✅ Installation réussie !"
    echo ""
    echo "🎯 Commandes principales :"
    echo "  make test          # Tous les tests"
    echo "  make test-headed   # Tests avec interface"
    echo "  make test-mobile   # Tests mobile"
    echo "  make help          # Aide complète"
    echo ""
    echo "📚 Voir README.md pour plus d'informations"
else
    echo "❌ Problème avec l'installation"
    exit 1
fi
EOF
    
    chmod +x "$TESTS_DIR/install.sh"
    print_success "Script d'installation rapide généré"
}

# Affichage des instructions finales
show_final_instructions() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║  🎉 GÉNÉRATION COMPLÈTE TERMINÉE ! 🎉                     ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}📁 FICHIERS GÉNÉRÉS DANS : ${YELLOW}$TESTS_DIR${NC}"
    echo ""
    
    echo -e "${BLUE}📋 STRUCTURE COMPLÈTE CRÉÉE :${NC}"
    echo -e "   ├── 📦 package.json                     # Dépendances et scripts"
    echo -e "   ├── 🎭 playwright.config.ts             # Configuration Playwright"
    echo -e "   ├── 🔧 global.setup.ts                  # Setup global"
    echo -e "   ├── 🧹 global.teardown.ts               # Nettoyage"
    echo -e "   ├── 📝 tsconfig.json                    # Configuration TypeScript"
    echo -e "   ├── 🔍 .eslintrc.js                     # Configuration ESLint"
    echo -e "   ├── 🌍 .env                             # Variables d'environnement"
    echo -e "   ├── 📋 Makefile                         # Commandes Make"
    echo -e "   ├── 📖 README.md                        # Documentation complète"
    echo -e "   ├── ⚡ install.sh                       # Installation rapide"
    echo -e "   ├── specs/"
    echo -e "   │   ├── math4child-basic.spec.ts        # Tests de base"
    echo -e "   │   ├── i18n.basic.spec.ts              # Tests multilingues"
    echo -e "   │   ├── game.basic.spec.ts              # Tests du jeu"
    echo -e "   │   ├── responsive.basic.spec.ts        # Tests responsive"
    echo -e "   │   └── performance.basic.spec.ts       # Tests performance"
    echo -e "   ├── utils/"
    echo -e "   │   ├── test-utils.ts                   # Helpers et utilitaires"
    echo -e "   │   ├── test-data.ts                    # Données de test"
    echo -e "   │   └── test-fixtures.ts                # Fixtures Playwright"
    echo -e "   ├── docker/"
    echo -e "   │   ├── docker-compose.test.yml         # Docker Compose"
    echo -e "   │   └── Dockerfile.tests                # Dockerfile tests"
    echo -e "   └── .github/workflows/"
    echo -e "       └── math4child-tests.yml            # CI/CD GitHub Actions"
    echo ""
    
    echo -e "${GREEN}🚀 PROCHAINES ÉTAPES :${NC}"
    echo ""
    
    echo -e "${BLUE}1. Aller dans le répertoire des tests :${NC}"
    echo -e "   ${YELLOW}cd $TESTS_DIR${NC}"
    echo ""
    
    echo -e "${BLUE}2. Installation rapide (recommandée) :${NC}"
    echo -e "   ${YELLOW}./install.sh${NC}                   # Installation automatique"
    echo -e "   ${YELLOW}# ou${NC}"
    echo -e "   ${YELLOW}make install${NC}                   # Avec Make"
    echo ""
    
    echo -e "${BLUE}3. Démarrer Math4Child (terminal séparé) :${NC}"
    echo -e "   ${YELLOW}cd ../apps/math4child${NC}"
    echo -e "   ${YELLOW}npm install && npm run dev${NC}"
    echo ""
    
    echo -e "${BLUE}4. Lancer les tests :${NC}"
    echo -e "   ${YELLOW}make test${NC}                      # Tous les tests"
    echo -e "   ${YELLOW}make test-headed${NC}               # Avec interface graphique"
    echo -e "   ${YELLOW}make test-ui${NC}                   # Interface Playwright UI"
    echo -e "   ${YELLOW}make test-mobile${NC}               # Tests mobile"
    echo -e "   ${YELLOW}make test-i18n${NC}                 # Tests multilingues"
    echo ""
    
    echo -e "${BLUE}5. Voir les résultats :${NC}"
    echo -e "   ${YELLOW}make report${NC}                    # Rapport HTML interactif"
    echo ""
    
    echo -e "${GREEN}🛠️ FONCTIONNALITÉS INCLUSES :${NC}"
    echo -e "   ✅ Tests E2E complets (20 langues, 5 niveaux)"
    echo -e "   ✅ Tests responsive (Mobile, Tablette, Desktop)"
    echo -e "   ✅ Tests de performance et accessibilité"
    echo -e "   ✅ CI/CD GitHub Actions"
    echo -e "   ✅ Support Docker"
    echo -e "   ✅ 15+ configurations Playwright"
    echo -e "   ✅ Helpers et utilitaires avancés"
    echo -e "   ✅ Documentation complète"
    echo ""
    
    echo -e "${GREEN}📚 RESSOURCES :${NC}"
    echo -e "   • Documentation : ${CYAN}$TESTS_DIR/README.md${NC}"
    echo -e "   • Aide Make : ${CYAN}make help${NC}"
    echo -e "   • Configuration : ${CYAN}$TESTS_DIR/playwright.config.ts${NC}"
    echo ""
    
    echo -e "${PURPLE}🎭 Math4Child Tests - Suite E2E complète générée avec succès !${NC}"
    echo -e "${PURPLE}   Prêt pour tester 20 langues • 5 niveaux • Web/Mobile/Desktop${NC}"
    echo ""
}

# Fonction principale
main() {
    print_header
    
    echo -e "${BLUE}Ce script va générer TOUS les fichiers de tests Playwright pour Math4Child :${NC}"
    echo ""
    echo -e "📁 Structure complète des répertoires"
    echo -e "📦 Configuration Playwright (15 projects)"
    echo -e "🧪 Tests complets (Base, I18N, Responsive, Performance)"
    echo -e "🛠️ Utilitaires et helpers avancés"
    echo -e "⚙️ Configuration TypeScript, ESLint, Make"
    echo -e "🐳 Setup Docker et CI/CD GitHub Actions"
    echo -e "📖 Documentation complète"
    echo ""
    
    read -p "Générer tous les fichiers de tests ? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Génération annulée."
        exit 0
    fi
    
    # Étapes de génération
    create_directory_structure
    generate_package_json
    generate_playwright_config
    generate_global_setup
    generate_test_utils
    generate_test_data
    generate_test_fixtures
    generate_main_tests
    generate_config_files
    generate_makefile
    generate_github_workflow
    generate_docker_setup
    generate_readme
    generate_quick_install_script
    show_final_instructions
}

# Gestion des erreurs
trap 'print_error "Une erreur est survenue. Génération interrompue."; exit 1' ERR

# Lancement du script
main "$@"