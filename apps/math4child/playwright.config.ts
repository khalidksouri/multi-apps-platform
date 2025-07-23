import { defineConfig, devices } from '@playwright/test'

/**
 * Configuration Playwright pour Math4Child
 * Tests E2E des paiements Stripe et fonctionnalités
 */
export default defineConfig({
  testDir: './tests/e2e',
  
  /* Timeout par test */
  timeout: 30 * 1000,
  
  /* Timeout d'assertion */
  expect: {
    timeout: 5000,
  },
  
  /* Configuration globale */
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  /* Reporter pour les résultats */
  reporter: [
    ['html'],
    ['list', { printSteps: true }],
    process.env.CI ? ['github'] : ['line']
  ],
  
  /* Configuration globale des tests */
  use: {
    /* URL de base pour tous les tests */
    baseURL: process.env.PLAYWRIGHT_BASE_URL || 'http://localhost:3000',
    
    /* Collecter les traces sur les échecs */
    trace: 'on-first-retry',
    
    /* Screenshots sur les échecs */
    screenshot: 'only-on-failure',
    
    /* Vidéos sur les échecs */
    video: 'retain-on-failure',
    
    /* Configuration des headers */
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
    },
  },

  /* Configuration des projets de test */
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    
    /* Tests mobiles */
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
    
    /* Tests spécifiques pour Stripe */
    {
      name: 'stripe-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: '**/stripe-*.spec.ts',
    },
    
    {
      name: 'stripe-mobile',
      use: { 
        ...devices['iPhone 12'],
      },
      testMatch: '**/stripe-*.spec.ts',
    },
  ],

  /* Serveur de développement local */
  webServer: process.env.CI ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
  
  /* Dossiers à ignorer */
  testIgnore: [
    '**/node_modules/**',
    '**/.next/**',
    '**/dist/**',
  ],
})
