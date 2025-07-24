import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  // Dossier des tests
  testDir: './tests',
  
  // Timeouts
  timeout: 60 * 1000,
  expect: { timeout: 15 * 1000 },
  
  // Configuration globale
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 2 : 4,
  
  // Reporters
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['list']
  ],
  
  // Dossier de sortie
  outputDir: 'test-results',
  
  // Configuration globale des tests
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  // Projets de test
  projects: [
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },
    
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
      dependencies: ['setup'],
    },
    
    // Tests spécialisés
    {
      name: 'translation-tests',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/translation/**/*.spec.ts',
      dependencies: ['setup'],
    },
    
    {
      name: 'stripe-tests',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/stripe/**/*.spec.ts',
      dependencies: ['setup'],
    },
  ],

  // Serveur de développement
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
})
