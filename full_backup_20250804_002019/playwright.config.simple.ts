import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright simplifiée pour Math4Child
 * Sans webServer automatique pour éviter les conflits
 */
export default defineConfig({
  testDir: './tests',
  timeout: 30 * 1000,
  expect: { timeout: 5000 },
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list']
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
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'math4child-mobile', 
      use: { ...devices['Pixel 5'] }
    }
  ]
  
  // Pas de webServer - à lancer manuellement avec `npm run dev`
});
