// cucumber.config.ts - Configuration complète pour le workspace multi-applications
import { defineConfig } from '@cucumber/cucumber';
import * as path from 'path';

export default defineConfig({
  // =============================================
  // CONFIGURATION DE BASE
  // =============================================
  
  // Chemins vers les fichiers features (Gherkin)
  features: [
    'tests/features/**/*.feature'
  ],
  
  // Chemins vers les step definitions (TypeScript)
  glue: [
    'tests/steps/**/*.ts',
    'tests/support/**/*.ts'
  ],
  
  // Support TypeScript
  requireModule: ['ts-node/register'],
  require: [
    'tests/support/world.ts',
    'tests/support/hooks.ts'
  ],
  
  // =============================================
  // PROFILS D'EXÉCUTION
  // =============================================
  
  profiles: {
    // Profil par défaut - Tous les tests
    default: {
      tags: 'not @skip and not @wip',
      parallel: 2,
      retry: 1,
      retryTagFilter: '@flaky',
      timeout: 30000
    },
    
    // Exécution complète - tous les tests
    all: {
      tags: 'not @skip',
      parallel: 4,
      retry: 2,
      timeout: 60000,
      worldParameters: {
        screenshot: 'on-failure',
        video: 'retain-on-failure'
      }
    },
    
    // Tests de smoke - rapides et critiques
    smoke: {
      tags: '@smoke',
      parallel: 2,
      retry: 1,
      timeout: 30000,
      failFast: true
    },
    
    // =============================================
    // PROFILS PAR APPLICATION (WORKSPACE)
    // =============================================
    
    ai4kids: {
      tags: '@ai4kids',
      features: ['tests/features/ai4kids/*.feature'],
      parallel: 2,
      retry: 1,
      worldParameters: {
        baseUrl: 'http://localhost:3004',
        appName: 'AI4Kids',
        workspacePath: 'apps/ai4kids'
      }
    },
    
    multiai: {
      tags: '@multiai',
      features: ['tests/features/multiai/*.feature'],
      parallel: 2,
      retry: 2,
      worldParameters: {
        baseUrl: 'http://localhost:3005',
        appName: 'MultiAI',
        workspacePath: 'apps/multiai'
      }
    },
    
    budgetcron: {
      tags: '@budgetcron',
      features: ['tests/features/budgetcron/*.feature'],
      parallel: 2,
      retry: 1,
      worldParameters: {
        baseUrl: 'http://localhost:3003',
        appName: 'BudgetCron',
        workspacePath: 'apps/budgetcron'
      }
    },
    
    unitflip: {
      tags: '@unitflip',
      features: ['tests/features/unitflip/*.feature'],
      parallel: 3,
      retry: 1,
      worldParameters: {
        baseUrl: 'http://localhost:3002',
        appName: 'UnitFlip',
        workspacePath: 'apps/unitflip'
      }
    },
    
    postmath: {
      tags: '@postmath',
      features: ['tests/features/postmath/*.feature'],
      parallel: 2,
      retry: 2,
      worldParameters: {
        baseUrl: 'http://localhost:3001',
        appName: 'Postmath',
        workspacePath: 'apps/postmath'
      }
    },
    
    // =============================================
    // PROFILS PAR TYPE DE TEST
    // =============================================
    
    positive: {
      tags: '@positive and not @slow',
      parallel: 4,
      retry: 1,
      timeout: 30000
    },
    
    negative: {
      tags: '@negative',
      parallel: 3,
      retry: 2,
      timeout: 45000
    },
    
    'edge-case': {
      tags: '@edge-case',
      parallel: 2,
      retry: 2,
      timeout: 60000
    },
    
    'twisted-case': {
      tags: '@twisted-case',
      parallel: 1,
      retry: 3,
      timeout: 90000
    },
    
    // =============================================
    // PROFILS SPÉCIALISÉS
    // =============================================
    
    performance: {
      tags: '@performance',
      parallel: 1,
      retry: 1,
      timeout: 120000,
      worldParameters: {
        enablePerformanceMetrics: true,
        performanceThresholds: {
          pageLoad: 3000,
          interaction: 1000,
          apiResponse: 2000
        }
      }
    },
    
    accessibility: {
      tags: '@accessibility or @a11y',
      parallel: 2,
      retry: 1,
      timeout: 45000,
      worldParameters: {
        enableA11yChecks: true,
        a11yStandard: 'WCAG21AA'
      }
    },
    
    security: {
      tags: '@security',
      parallel: 1,
      retry: 1,
      timeout: 90000,
      worldParameters: {
        enableSecurityChecks: true,
        validateCsp: true,
        checkXss: true
      }
    },
    
    mobile: {
      tags: '@mobile',
      parallel: 2,
      retry: 2,
      timeout: 45000,
      worldParameters: {
        deviceType: 'mobile',
        viewport: { width: 375, height: 667 }
      }
    },
    
    tablet: {
      tags: '@mobile or @responsive',
      parallel: 2,
      retry: 1,
      timeout: 45000,
      worldParameters: {
        deviceType: 'tablet',
        viewport: { width: 768, height: 1024 }
      }
    },
    
    // =============================================
    // PROFILS PAR ENVIRONNEMENT
    // =============================================
    
    dev: {
      tags: '@smoke',
      parallel: 2,
      retry: 1,
      timeout: 30000,
      worldParameters: {
        environment: 'development',
        debug: true,
        slowMo: 100
      }
    },
    
    staging: {
      tags: 'not @skip and not @prod-only',
      parallel: 3,
      retry: 2,
      timeout: 60000,
      worldParameters: {
        environment: 'staging',
        baseUrl: process.env.STAGING_URL || 'https://staging.example.com'
      }
    },
    
    prod: {
      tags: '@smoke or @critical',
      parallel: 1,
      retry: 3,
      timeout: 45000,
      worldParameters: {
        environment: 'production',
        baseUrl: process.env.PROD_URL || 'https://example.com',
        readOnly: true
      }
    },
    
    // =============================================
    // PROFILS UTILITAIRES
    // =============================================
    
    debug: {
      tags: '@debug',
      parallel: 1,
      retry: 0,
      timeout: 300000, // 5 minutes pour debug
      failFast: true,
      worldParameters: {
        debug: true,
        headless: false,
        slowMo: 500,
        devtools: true
      }
    },
    
    regression: {
      tags: '@smoke or @critical or @regression',
      parallel: 4,
      retry: 2,
      timeout: 60000
    },
    
    nightly: {
      tags: 'not @skip',
      parallel: 6,
      retry: 3,
      timeout: 120000,
      worldParameters: {
        fullSuite: true,
        generateDetailedReport: true
      }
    },
    
    // Tests séquentiels (pour les cas qui ne peuvent pas être parallélisés)
    sequential: {
      tags: '@sequential',
      parallel: 1,
      retry: 2,
      timeout: 90000
    },
    
    // Tests rapides seulement
    fast: {
      tags: 'not @slow and not @twisted-case',
      parallel: 6,
      retry: 1,
      timeout: 20000
    }
  },
  
  // =============================================
  // CONFIGURATION DES RAPPORTS
  // =============================================
  
  format: [
    // Affichage en console
    'progress-bar',
    
    // Rapports pour CI/CD
    'json:reports/cucumber-report.json',
    'html:reports/cucumber-report.html',
    'junit:reports/cucumber-junit.xml',
    
    // Rapport personnalisé (si vous avez un formatter custom)
    // 'custom-formatter:reports/custom-report.json'
  ],
  
  // Options de formatage
  formatOptions: {
    snippetInterface: 'async-await',
    printAttachments: false,
    colorsEnabled: true,
    theme: 'hierarchy'
  },
  
  // =============================================
  // PARAMÈTRES GLOBAUX DU WORLD (WORKSPACE)
  // =============================================
  
  worldParameters: {
    // URLs de base par défaut
    baseUrl: process.env.BASE_URL || 'http://localhost',
    
    // Configuration du navigateur
    browser: process.env.BROWSER || 'chromium',
    headless: process.env.HEADLESS !== 'false',
    slowMo: parseInt(process.env.SLOW_MO || '0'),
    
    // Timeouts
    timeout: parseInt(process.env.TEST_TIMEOUT || '30000'),
    actionTimeout: parseInt(process.env.ACTION_TIMEOUT || '10000'),
    navigationTimeout: parseInt(process.env.NAVIGATION_TIMEOUT || '30000'),
    
    // Configuration des captures
    screenshot: process.env.SCREENSHOT || 'on-failure',
    video: process.env.VIDEO || 'retain-on-failure',
    trace: process.env.TRACE || 'on-first-retry',
    
    // Viewport par défaut
    viewport: {
      width: parseInt(process.env.VIEWPORT_WIDTH || '1280'),
      height: parseInt(process.env.VIEWPORT_HEIGHT || '720')
    },
    
    // Configuration workspace
    workspace: {
      root: process.cwd(),
      appsPath: 'apps',
      packagesPath: 'packages',
      testsPath: 'tests',
      reportsPath: 'reports'
    },
    
    // Configuration des données de test
    testDataPath: 'tests/fixtures',
    generateTestData: process.env.GENERATE_TEST_DATA === 'true',
    
    // Configuration de logging
    logLevel: process.env.LOG_LEVEL || 'info',
    enableConsoleCapture: process.env.CAPTURE_CONSOLE === 'true',
    
    // Configuration de performance
    enablePerformanceMetrics: false,
    performanceThresholds: {
      pageLoad: 5000,
      interaction: 2000,
      apiResponse: 3000
    },
    
    // Configuration d'accessibilité
    enableA11yChecks: false,
    a11yStandard: 'WCAG21AA',
    
    // Configuration mobile
    deviceEmulation: false,
    touchEnabled: false,
    
    // URLs spécifiques par application (workspace)
    urls: {
      ai4kids: process.env.AI4KIDS_URL || 'http://localhost:3004',
      multiai: process.env.MULTIAI_URL || 'http://localhost:3005',
      budgetcron: process.env.BUDGETCRON_URL || 'http://localhost:3003',
      unitflip: process.env.UNITFLIP_URL || 'http://localhost:3002',
      postmath: process.env.POSTMATH_URL || 'http://localhost:3001'
    },
    
    // Chemins workspace par application
    workspacePaths: {
      ai4kids: 'apps/ai4kids',
      multiai: 'apps/multiai',
      budgetcron: 'apps/budgetcron',
      unitflip: 'apps/unitflip',
      postmath: 'apps/postmath'
    },
    
    // Commandes workspace
    startCommands: {
      ai4kids: 'cd apps/ai4kids && npm run dev',
      multiai: 'cd apps/multiai && npm run dev',
      budgetcron: 'cd apps/budgetcron && npm run dev',
      unitflip: 'cd apps/unitflip && npm run dev',
      postmath: 'cd apps/postmath && npm run dev'
    },
    
    // Build commands workspace
    buildCommands: {
      packages: 'npm run build:packages',
      ai4kids: 'cd apps/ai4kids && npm run build',
      multiai: 'cd apps/multiai && npm run build',
      budgetcron: 'cd apps/budgetcron && npm run build',
      unitflip: 'cd apps/unitflip && npm run build',
      postmath: 'cd apps/postmath && npm run build'
    }
  },
  
  // =============================================
  // CONFIGURATION AVANCÉE
  // =============================================
  
  // Ordre d'exécution des tests
  order: 'defined', // ou 'random' pour randomiser
  
  // Gestion des échecs
  failFast: false,
  strict: true, // Échec si steps non définis
  
  // Configuration du retry
  retryTagFilter: '@flaky or @unstable',
  
  // Plugins (si vous en utilisez)
  // plugins: ['cucumber-plugin-name'],
  
  // Configuration pour l'environnement CI
  ...(process.env.CI && {
    parallel: parseInt(process.env.CI_PARALLEL || '2'),
    retry: parseInt(process.env.CI_RETRY || '3'),
    format: [
      'progress',
      'json:reports/cucumber-report.json',
      'junit:reports/cucumber-junit.xml'
    ]
  })
});