import { defineConfig, devices } from '@playwright/test'

/**
 * Configuration Playwright optimisée pour les déploiements Netlify
 * Adaptée pour le projet prismatic-sherbet-986159
 */
export default defineConfig({
  testDir: './tests/e2e',
  
  // Timeouts adaptés aux builds Netlify (plus courts)
  timeout: 20 * 1000,
  expect: { timeout: 5000 },
  
  // Configuration CI/Netlify
  fullyParallel: true,
  forbidOnly: !!process.env.NETLIFY,
  retries: process.env.NETLIFY ? 1 : 0,
  workers: process.env.NETLIFY ? 2 : undefined,
  
  // Reporters adaptés à Netlify
  reporter: [
    ['html', { 
      open: 'never',
      outputFolder: 'out/test-results' 
    }],
    process.env.NETLIFY ? ['github'] : ['list'],
    ['json', { outputFile: 'out/test-results.json' }]
  ],
  
  use: {
    // URL dynamique selon l'environnement Netlify
    baseURL: process.env.DEPLOY_PRIME_URL || 
             process.env.URL || 
             'http://localhost:3000',
    
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Headers pour les tests
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
      'User-Agent': 'Math4Child-Tests/1.0'
    },
  },

  // Projets optimisés pour différents environnements Netlify
  projects: [
    // Tests critiques pour production
    {
      name: 'netlify-critical',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/critical/*.spec.ts',
      retries: 2,
    },
    
    // Tests Stripe pour deploy-preview uniquement
    {
      name: 'netlify-stripe',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: process.env.DEPLOY_PREVIEW_URL || process.env.DEPLOY_PRIME_URL
      },
      testMatch: '**/stripe/*.spec.ts',
      // Seulement en preview, pas en production
      testIgnore: process.env.CONTEXT === 'production' ? ['**/*.spec.ts'] : [],
    },
    
    // Tests mobiles légers
    {
      name: 'netlify-mobile',
      use: { ...devices['iPhone 12'] },
      testMatch: '**/mobile/*.spec.ts',
      timeout: 15 * 1000,
    },
    
    // Tests complets (seulement localement)
    {
      name: 'local-full',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/*.spec.ts',
      testIgnore: process.env.NETLIFY ? ['**/*.spec.ts'] : [],
    },
  ],

  // Pas de serveur web sur Netlify (déjà déployé)
  webServer: process.env.NETLIFY ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: true,
    timeout: 60 * 1000,
  },
})
