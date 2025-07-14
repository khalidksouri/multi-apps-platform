// playwright.config.ts - Configuration complète Playwright pour workspace
import { defineConfig, devices } from '@playwright/test';
import * as path from 'path';

/**
 * Configuration Playwright pour les tests BDD multi-applications workspace
 * @see https://playwright.dev/docs/test-configuration
 */
export default defineConfig({
  // =============================================
  // CONFIGURATION DE BASE
  // =============================================
  
  // Répertoire des tests
  testDir: './tests',
  
  // Pattern des fichiers de test (inclut les .feature via Cucumber)
  testMatch: [
    '**/*.spec.ts',
    '**/*.test.ts',
    '**/*.feature' // Support des fichiers Gherkin
  ],
  
  // Configuration globale d'exécution
  fullyParallel: true,
  forbidOnly: !!process.env.CI, // Interdire .only() en CI
  retries: process.env.CI ? 3 : 1, // Plus de retry en CI
  workers: process.env.CI ? 2 : undefined, // Limiter les workers en CI
  
  // =============================================
  // CONFIGURATION DES RAPPORTS
  // =============================================
  
  reporter: [
    // En local
    ...(!process.env.CI ? [
      ['list'],
      ['html', { open: 'never', outputFolder: 'reports/playwright-report' }]
    ] : []),
    
    // En CI
    ...(process.env.CI ? [
      ['github'],
      ['html', { outputFolder: 'reports/playwright-report' }],
      ['junit', { outputFile: 'reports/playwright-junit.xml' }],
      ['json', { outputFile: 'reports/playwright-report.json' }]
    ] : [])
  ],
  
  // =============================================
  // CONFIGURATION GLOBALE D'UTILISATION
  // =============================================
  
  use: {
    // URL de base
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    
    // Timeouts
    actionTimeout: parseInt(process.env.ACTION_TIMEOUT || '30000'),
    navigationTimeout: parseInt(process.env.NAVIGATION_TIMEOUT || '60000'),
    
    // Captures et traces
    trace: process.env.TRACE || 'on-first-retry',
    screenshot: process.env.SCREENSHOT || 'only-on-failure',
    video: process.env.VIDEO || 'retain-on-failure',
    
    // Configuration du navigateur
    headless: process.env.HEADLESS !== 'false',
    slowMo: parseInt(process.env.SLOW_MO || '0'),
    
    // Viewport par défaut
    viewport: {
      width: parseInt(process.env.VIEWPORT_WIDTH || '1280'),
      height: parseInt(process.env.VIEWPORT_HEIGHT || '720')
    },
    
    // Ignorer les erreurs HTTPS en développement
    ignoreHTTPSErrors: process.env.NODE_ENV === 'development',
    
    // Locale et timezone
    locale: 'fr-FR',
    timezoneId: 'Europe/Paris',
    
    // Configuration des permissions
    permissions: ['geolocation', 'notifications'],
    
    // Headers personnalisés
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8'
    }
  },

  // =============================================
  // PROJETS PAR NAVIGATEUR ET TYPE DE TEST
  // =============================================

  projects: [
    // =============================================
    // TESTS DESKTOP - NAVIGATEURS PRINCIPAUX
    // =============================================
    
    {
      name: 'chromium-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        channel: 'chrome' // Utiliser Chrome stable
      },
      testMatch: ['**/*.feature', '**/*.spec.ts'],
      dependencies: []
    },
    
    {
      name: 'firefox-desktop',
      use: { ...devices['Desktop Firefox'] },
      testMatch: ['**/*.feature', '**/*.spec.ts']
    },
    
    {
      name: 'webkit-desktop',
      use: { ...devices['Desktop Safari'] },
      testMatch: ['**/*.feature', '**/*.spec.ts']
    },
    
    // =============================================
    // TESTS MOBILE - SMARTPHONES
    // =============================================
    
    {
      name: 'mobile-chrome',
      use: { 
        ...devices['Pixel 5'],
        hasTouch: true,
        isMobile: true
      },
      testMatch: ['**/mobile/**/*.feature', '**/*mobile*.spec.ts'],
      testIgnore: ['**/desktop-only/**']
    },
    
    {
      name: 'mobile-safari',
      use: { 
        ...devices['iPhone 12'],
        hasTouch: true,
        isMobile: true
      },
      testMatch: ['**/mobile/**/*.feature', '**/*mobile*.spec.ts'],
      testIgnore: ['**/desktop-only/**']
    },
    
    {
      name: 'mobile-samsung',
      use: { 
        ...devices['Galaxy S9+'],
        hasTouch: true,
        isMobile: true
      },
      testMatch: ['**/mobile/**/*.feature']
    },
    
    // =============================================
    // TESTS TABLETTE
    // =============================================
    
    {
      name: 'tablet-ipad',
      use: { 
        ...devices['iPad Pro'],
        hasTouch: true,
        isMobile: false
      },
      testMatch: ['**/tablet/**/*.feature', '**/*responsive*.feature']
    },
    
    {
      name: 'tablet-android',
      use: { 
        ...devices['Galaxy Tab S4'],
        hasTouch: true,
        isMobile: false
      },
      testMatch: ['**/tablet/**/*.feature']
    },
    
    // =============================================
    // TESTS SPÉCIALISÉS - ACCESSIBILITÉ
    // =============================================
    
    {
      name: 'accessibility-tests',
      use: { 
        ...devices['Desktop Chrome'],
        // Configuration spéciale pour l'accessibilité
        colorScheme: 'light',
        reducedMotion: 'reduce',
        forcedColors: 'none',
        // Zoom élevé pour tester la lisibilité
        deviceScaleFactor: 2
      },
      testMatch: [
        '**/*a11y*.feature',
        '**/*accessibility*.feature',
        '**/*accessible*.spec.ts'
      ]
    },
    
    {
      name: 'accessibility-dark-mode',
      use: { 
        ...devices['Desktop Chrome'],
        colorScheme: 'dark',
        reducedMotion: 'reduce'
      },
      testMatch: ['**/*a11y*.feature']
    },
    
    // =============================================
    // TESTS DE PERFORMANCE
    // =============================================
    
    {
      name: 'performance-tests',
      use: {
        ...devices['Desktop Chrome'],
        // Métriques de performance activées
        launchOptions: {
          args: [
            '--enable-precise-memory-info',
            '--enable-gpu-benchmarking',
            '--enable-threaded-compositing'
          ]
        }
      },
      testMatch: [
        '**/*performance*.feature',
        '**/*perf*.spec.ts'
      ]
    },
    
    {
      name: 'performance-slow-network',
      use: {
        ...devices['Desktop Chrome'],
        // Simulation réseau lent
        launchOptions: {
          args: ['--enable-precise-memory-info']
        }
      },
      testMatch: ['**/*performance*.feature']
    },
    
    // =============================================
    // TESTS DE SÉCURITÉ
    // =============================================
    
    {
      name: 'security-tests',
      use: {
        ...devices['Desktop Chrome'],
        // Configuration sécurisée
        bypassCSP: false,
        javaScriptEnabled: true,
        // Headers de sécurité
        extraHTTPHeaders: {
          'X-Frame-Options': 'DENY',
          'X-Content-Type-Options': 'nosniff'
        }
      },
      testMatch: [
        '**/*security*.feature',
        '**/*sec*.spec.ts'
      ]
    },
    
    // =============================================
    // TESTS EDGE CASES - NAVIGATEURS ALTERNATIFS
    // =============================================
    
    {
      name: 'edge-chromium',
      use: { 
        ...devices['Desktop Chrome'],
        channel: 'msedge'
      },
      testMatch: ['**/*edge-case*.feature']
    },
    
    // =============================================
    // TESTS DE RÉGRESSION
    // =============================================
    
    {
      name: 'regression-suite',
      use: { ...devices['Desktop Chrome'] },
      testMatch: [
        '**/*smoke*.feature',
        '**/*critical*.feature',
        '**/*regression*.feature'
      ],
      dependencies: [] // Pas de dépendances, exécution indépendante
    },
    
    // =============================================
    // TESTS EN MODE DEBUG
    // =============================================
    
    {
      name: 'debug',
      use: {
        ...devices['Desktop Chrome'],
        headless: false,
        slowMo: 1000,
        launchOptions: {
          devtools: true,
          args: ['--start-maximized']
        }
      },
      testMatch: ['**/*debug*.feature'],
      fullyParallel: false // Mode séquentiel pour debug
    }
  ],

  // =============================================
  // CONFIGURATION DES SERVEURS DE TEST (WORKSPACE)
  // =============================================

  webServer: [
    // Serveur AI4Kids - Structure workspace
    {
      command: 'cd apps/ai4kids && npm run dev',
      port: 3004,
      timeout: 120000, // Plus de temps pour Next.js
      reuseExistingServer: !process.env.CI,
      env: {
        NODE_ENV: 'test',
        PORT: '3004',
        NEXT_TELEMETRY_DISABLED: '1'
      },
      cwd: process.cwd()
    },
    
    // Serveur MultiAI - Structure workspace
    {
      command: 'cd apps/multiai && npm run dev',
      port: 3005,
      timeout: 120000,
      reuseExistingServer: !process.env.CI,
      env: {
        NODE_ENV: 'test',
        PORT: '3005',
        NEXT_TELEMETRY_DISABLED: '1'
      },
      cwd: process.cwd()
    },
    
    // Serveur BudgetCron - Structure workspace
    {
      command: 'cd apps/budgetcron && npm run dev',
      port: 3003,
      timeout: 120000,
      reuseExistingServer: !process.env.CI,
      env: {
        NODE_ENV: 'test',
        PORT: '3003',
        NEXT_TELEMETRY_DISABLED: '1',
        DATABASE_URL: 'mongodb://localhost:27017/budgetcron_test'
      },
      cwd: process.cwd()
    },
    
    // Serveur UnitFlip - Structure workspace
    {
      command: 'cd apps/unitflip && npm run dev',
      port: 3002,
      timeout: 120000,
      reuseExistingServer: !process.env.CI,
      env: {
        NODE_ENV: 'test',
        PORT: '3002',
        NEXT_TELEMETRY_DISABLED: '1'
      },
      cwd: process.cwd()
    },
    
    // Serveur Postmath - Structure workspace
    {
      command: 'cd apps/postmath && npm run dev',
      port: 3001,
      timeout: 120000,
      reuseExistingServer: !process.env.CI,
      env: {
        NODE_ENV: 'test',
        PORT: '3001',
        NEXT_TELEMETRY_DISABLED: '1'
      },
      cwd: process.cwd()
    }
  ],

  // =============================================
  // CONFIGURATION AVANCÉE
  // =============================================

  // Répertoires de sortie
  outputDir: 'test-results/',
  
  // Timeout global des tests
  timeout: parseInt(process.env.TEST_TIMEOUT || '60000'),
  
  // Timeout d'attente des fixtures
  expect: {
    timeout: parseInt(process.env.EXPECT_TIMEOUT || '10000'),
    // Seuils de performance personnalisés
    toHaveScreenshot: { 
      threshold: 0.2,
      mode: 'percent'
    },
    toMatchSnapshot: {
      threshold: 0.2,
      mode: 'percent'
    }
  },
  
  // Configuration globale des fixtures
  globalSetup: process.env.GLOBAL_SETUP ? 'tests/support/global-setup.ts' : undefined,
  globalTeardown: process.env.GLOBAL_TEARDOWN ? 'tests/support/global-teardown.ts' : undefined,
  
  // Métadonnées du projet workspace
  metadata: {
    project: 'Multi-Application Workspace Test Suite',
    version: process.env.npm_package_version || '1.0.0',
    environment: process.env.NODE_ENV || 'test',
    workspace: 'monorepo',
    timestamp: new Date().toISOString(),
    apps: {
      ai4kids: 'http://localhost:3004',
      multiai: 'http://localhost:3005',
      budgetcron: 'http://localhost:3003',
      unitflip: 'http://localhost:3002',
      postmath: 'http://localhost:3001'
    }
  }
});