import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  timeout: 45 * 1000, // Timeout plus généreux
  expect: { 
    timeout: 15 * 1000 // Timeout d'attente plus généreux
  },
  
  // Configuration de parallélisation
  fullyParallel: false, // Éviter les conflits
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 1, // Un seul worker pour éviter les conflits
  
  // Reporters optimisés
  reporter: [
    ['html', { 
      outputFolder: 'playwright-report',
      open: 'never' // Ne pas ouvrir automatiquement
    }],
    ['list', { printSteps: true }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }]
  ],
  
  outputDir: 'test-results',
  
  use: {
    // URL de base
    baseURL: 'http://localhost:3000',
    
    // Configuration des timeouts
    actionTimeout: 20 * 1000,
    navigationTimeout: 45 * 1000,
    
    // Captures pour le debug - optimisées
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Headers utiles
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    },
    
    // Configuration du viewport
    viewport: { width: 1280, height: 720 },
    
    // Ignorer les erreurs HTTPS en dev
    ignoreHTTPSErrors: true,
  },

  // Projets de test
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    
    // Tests mobiles (optionnel)
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
      testIgnore: '**/enhanced/**', // Ignorer les tests avancés sur mobile
    },
    
    // Tests Firefox (optionnel)
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
      testIgnore: '**/enhanced/**', // Tests basiques uniquement
    },
  ],

  // Configuration du serveur web
  webServer: {
    command: 'echo "Serveur externe requis sur http://localhost:3000"',
    url: 'http://localhost:3000',
    reuseExistingServer: true,
    timeout: 30 * 1000,
    ignoreHTTPSErrors: true,
  },
  
  // Dossiers à ignorer
  testIgnore: [
    '**/node_modules/**',
    '**/playwright-report/**',
    '**/test-results/**'
  ]
})
