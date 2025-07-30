import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 3 : 2,
  workers: process.env.CI ? 2 : undefined,
  timeout: 60000,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    process.env.CI ? ['github'] : ['list']
  ],
  
  outputDir: 'test-results/',
  
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    actionTimeout: 20000,
    navigationTimeout: 45000,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    expect: {
      timeout: 15000
    }
  },

  projects: [
    {
      name: 'smoke',
      testMatch: /.*\.smoke\.spec\.ts$/,
      use: { ...devices['Desktop Chrome'] },
      retries: 1
    },
    {
      name: 'translation',
      testMatch: /.*translation.*\.spec\.ts$/,
      use: { 
        ...devices['Desktop Chrome'],
        actionTimeout: 30000
      }
    },
    {
      name: 'responsive',
      testMatch: /.*responsive.*\.spec\.ts$/,
      use: { 
        ...devices['Pixel 5'],
        actionTimeout: 25000
      }
    },
    {
      name: 'desktop',
      testMatch: /.*\.spec\.ts$/,
      testIgnore: [/.*\.smoke\.spec\.ts$/, /.*translation.*\.spec\.ts$/, /.*responsive.*\.spec\.ts$/],
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'firefox',
      testMatch: /.*\.spec\.ts$/,
      use: { 
        ...devices['Desktop Firefox'],
        actionTimeout: 30000
      }
    }
  ],

  // Serveur web conditionnel
  webServer: process.env.CI ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
    // Ignore les erreurs de serveur pour éviter les warnings
    stderr: 'ignore',
    stdout: 'ignore'
  }
});
