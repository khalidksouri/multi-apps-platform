import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  timeout: 60000,
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 2,
  
  use: {
    baseURL: process.env.CAPACITOR_BUILD 
      ? 'http://localhost:8100' 
      : 'http://localhost:3000',
    trace: 'on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 15000,
    navigationTimeout: 30000,
  },

  projects: [
    // Tests Web
    {
      name: 'web-desktop',
      use: { ...devices['Desktop Chrome'] },
      testMatch: ['**/web/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    {
      name: 'web-mobile',
      use: { ...devices['Pixel 5'] },
      testMatch: ['**/web/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    // Tests mobiles navigateurs
    {
      name: 'mobile-android',
      use: { 
        ...devices['Pixel 7'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: ['**/mobile/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    {
      name: 'mobile-ios',
      use: { 
        ...devices['iPhone 14'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: ['**/mobile/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },

  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['line'],
  ]
})
