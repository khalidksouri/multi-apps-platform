import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright pour Math4Child v4.2.0
 * Conforme aux spécifications README.md
 */
export default defineConfig({
  testDir: './tests',
  timeout: 90000, // Timeout plus long pour les tests de conformité
  expect: {
    timeout: 15000 // Timeout plus long pour les assertions
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 3 : 1, // Plus de retry pour la CI
  workers: process.env.CI ? 2 : 4,
  reporter: [
    ['html', { outputFolder: 'test-results/html-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['line'],
    ['junit', { outputFile: 'test-results/junit.xml' }]
  ],
  
  outputDir: 'test-results/artifacts',
  
  use: {
    // Configuration selon README.md pour Math4Child
    baseURL: 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 30000,
    navigationTimeout: 90000,
    
    // Headers pour conformité Math4Child
    extraHTTPHeaders: {
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8,ar;q=0.7'
    }
  },

  projects: [
    // Tests principaux - Conformité README.md
    {
      name: 'math4child-conformity',
      testMatch: '**/e2e/math4child.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
    
    // Tests de traduction - 200+ langues
    {
      name: 'translation-200-languages', 
      testMatch: '**/e2e/translation.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
    
    // Tests de performance
    {
      name: 'performance-stress',
      testMatch: '**/stress/load.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
    
    // Tests mobile - Applications hybrides
    {
      name: 'mobile-hybrid',
      use: { ...devices['Pixel 5'] },
    },
    
    // Tests Safari - Compatibilité
    {
      name: 'safari-compatibility',
      use: { ...devices['Desktop Safari'] },
    },
  ],

  // Configuration du serveur selon README.md
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
    env: {
      // Variables d'environnement conformes README.md
      NEXT_PUBLIC_APP_NAME: 'Math4Child',
      NEXT_PUBLIC_APP_VERSION: '4.2.0',
      NEXT_PUBLIC_DOMAIN: 'www.math4child.com',
      NEXT_PUBLIC_SUPPORT_EMAIL: 'support@math4child.com',
      NEXT_PUBLIC_COMMERCIAL_EMAIL: 'commercial@math4child.com'
    }
  },

  // Configuration globale pour Math4Child
  globalSetup: require.resolve('./tests/utils/global-setup.ts'),
  globalTeardown: require.resolve('./tests/utils/global-teardown.ts'),
});
