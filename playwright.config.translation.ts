import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/translation',
  timeout: 30000,
  retries: 1,
  workers: 1,
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure'
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: true
  }
})
