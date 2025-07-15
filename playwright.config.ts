import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'reports/playwright-report' }],
    ['json', { outputFile: 'reports/results.json' }]
  ],
  
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  
  projects: [
    {
      name: 'postmath',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/postmath*.spec.ts'
    },
    {
      name: 'unitflip', 
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3002' },
      testMatch: '**/unitflip*.spec.ts'
    },
    {
      name: 'budgetcron',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3003' },
      testMatch: '**/budgetcron*.spec.ts'
    },
    {
      name: 'ai4kids',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3004' },
      testMatch: '**/ai4kids*.spec.ts'
    },
    {
      name: 'multiai',
      use: { ...devices['Desktop Chrome'], baseURL: 'http://localhost:3005' },
      testMatch: '**/multiai*.spec.ts'
    }
  ]
});
