import { defineConfig, devices } from '@playwright/test'

// Applications disponibles (math4child au lieu de postmath)
const availableApps = []
const appsToCheck = ['math4child', 'unitflip', 'budgetcron', 'ai4kids', 'multiai']

console.log('🔍 Vérification des applications disponibles...')
for (const app of appsToCheck) {
  try {
    require('fs').accessSync(`apps/${app}`, require('fs').constants.F_OK)
    availableApps.push(app)
    console.log(`✅ ${app}: Trouvée`)
  } catch (e) {
    console.log(`⚠️ ${app}: Non trouvée, ignorée dans les tests`)
  }
}

console.log(`📊 Applications disponibles pour les tests: ${availableApps.join(', ')}`)

export default defineConfig({
  testDir: './tests/specs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'translation',
      testMatch: '**/translation/**/*.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'rtl',
      testMatch: '**/rtl/**/*.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'apps',
      testMatch: '**/apps/**/*.spec.ts',
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  // Configuration adaptative - démarre math4child en priorité
  webServer: availableApps.includes('math4child') ? [
    {
      command: 'cd apps/math4child && npm run dev',
      port: 3001,
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
  ] : [],
})
