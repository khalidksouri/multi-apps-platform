// =============================================
// 📄 playwright.config.ts
// =============================================
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'reports/playwright-report' }],
    ['json', { outputFile: 'reports/playwright-results.json' }],
    ['junit', { outputFile: 'reports/junit-results.xml' }]
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
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
  webServer: [
    {
      command: 'npm run dev:postmath',
      port: 3001,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run dev:unitflip',
      port: 3002,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run dev:budgetcron',
      port: 3003,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run dev:ai4kids',
      port: 3004,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run dev:multiai',
      port: 3005,
      reuseExistingServer: !process.env.CI,
    },
  ],
  globalSetup: require.resolve('./tests/support/global-setup'),
  globalTeardown: require.resolve('./tests/support/global-teardown'),
});

// =============================================
// 📄 cucumber.js
// =============================================
const common = {
  requireModule: ['ts-node/register'],
  require: ['tests/steps/**/*.ts', 'tests/support/**/*.ts'],
  format: [
    'progress',
    'json:reports/cucumber-report.json',
    'html:reports/cucumber-report.html',
    'junit:reports/cucumber-junit.xml'
  ],
  formatOptions: {
    snippetInterface: 'async-await'
  },
  publishQuiet: true
};

module.exports = {
  default: {
    ...common,
    paths: ['tests/features/**/*.feature'],
    tags: 'not @skip'
  },
  smoke: {
    ...common,
    paths: ['tests/features/**/*.feature'],
    tags: '@smoke'
  },
  regression: {
    ...common,
    paths: ['tests/features/**/*.feature'],
    tags: 'not @skip and not @smoke'
  },
  ai4kids: {
    ...common,
    paths: ['tests/features/ai4kids/**/*.feature'],
    tags: '@ai4kids'
  },
  multiai: {
    ...common,
    paths: ['tests/features/multiai/**/*.feature'],
    tags: '@multiai'
  },
  budgetcron: {
    ...common,
    paths: ['tests/features/budgetcron/**/*.feature'],
    tags: '@budgetcron'
  },
  unitflip: {
    ...common,
    paths: ['tests/features/unitflip/**/*.feature'],
    tags: '@unitflip'
  },
  postmath: {
    ...common,
    paths: ['tests/features/postmath/**/*.feature'],
    tags: '@postmath'
  },
  performance: {
    ...common,
    paths: ['tests/features/**/*.feature'],
    tags: '@performance'
  },
  accessibility: {
    ...common,
    paths: ['tests/features/**/*.feature'],
    tags: '@accessibility'
  }
};