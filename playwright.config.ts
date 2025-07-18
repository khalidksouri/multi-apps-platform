import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'reports/playwright' }],
    ['json', { outputFile: 'reports/playwright/results.json' }],
    ['junit', { outputFile: 'reports/playwright/results.xml' }]
  ],
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
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
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
  webServer: [
    {
      command: 'npm run start:math4kids',
      url: 'http://localhost:3001',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run start:unitflip',
      url: 'http://localhost:3002',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run start:budgetcron',
      url: 'http://localhost:3003',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run start:ai4kids',
      url: 'http://localhost:3004',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run start:multiai',
      url: 'http://localhost:3005',
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run start:digital4kids',
      url: 'http://localhost:3006',
      reuseExistingServer: !process.env.CI,
    }
  ],
});
