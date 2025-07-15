import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 30 * 1000,
  expect: { timeout: 5000 },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'test-results/html-reports' }],
    ['json', { outputFile: 'test-results/results.json' }],
  ],
  
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
  
  outputDir: 'test-results/artifacts',
  
  // Démarrer le serveur uniquement pour les tests
  webServer: process.env.CI ? undefined : {
    command: 'cd apps/postmath && npm run dev',
    url: 'http://localhost:3001/health',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
