import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure'
  },

  projects: [
    {
      name: 'chromium-desktop',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox-desktop',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit-desktop',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-android',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-ios',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'french-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris'
      },
    },
    {
      name: 'arabic-rtl',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh'
      },
    },
    {
      name: 'performance-chrome',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'accessibility-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        reducedMotion: 'reduce'
      },
    }
  ],

  webServer: {
    command: 'cd ../apps/math4child && npm run start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
});
