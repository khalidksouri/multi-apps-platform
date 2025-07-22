import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },

  projects: [
    {
      name: 'chromium-optimal',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'mobile-ios-revenuecat',
      use: { 
        ...devices['iPhone 12'],
        contextOptions: {
          permissions: ['payment-handler']
        }
      },
    },
    {
      name: 'eu-paddle',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        geolocation: { latitude: 48.8566, longitude: 2.3522 },
      },
    },
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
