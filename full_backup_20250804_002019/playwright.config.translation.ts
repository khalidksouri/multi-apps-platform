import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/translation',
  timeout: 90000,
  expect: { timeout: 15000 },
  
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 2,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report/translation' }],
    ['json', { outputFile: 'test-results/translation/results.json' }],
    ['list']
  ],
  
  outputDir: 'test-results/translation',
  
  use: {
    baseURL: 'http://localhost:3000',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
    actionTimeout: 20000,
  },

  projects: [
    {
      name: 'translation-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris'
      },
    },
    {
      name: 'translation-mobile',
      use: { 
        ...devices['iPhone 12'],
        locale: 'fr-FR',
      },
    }
  ],

  webServer: {
    command: 'echo "Serveur à démarrer manuellement sur http://localhost:3000"',
    url: 'http://localhost:3000',
    reuseExistingServer: true,
    timeout: 5000
  },
});
