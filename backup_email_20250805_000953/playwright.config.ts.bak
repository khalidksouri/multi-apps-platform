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
