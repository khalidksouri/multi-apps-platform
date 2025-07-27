import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  timeout: 120000, // Tests mobiles plus longs
  fullyParallel: false, // Éviter conflits émulateurs
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 3 : 2,
  workers: process.env.CI ? 1 : 2,
  
  // Configuration globale mobile
  use: {
    baseURL: process.env.CAPACITOR_BUILD 
      ? 'http://localhost:8100' 
      : 'http://localhost:3000',
    trace: 'on-failure',
    screenshot: 'only-on-failure', 
    video: 'retain-on-failure',
    actionTimeout: 25000,
    navigationTimeout: 35000,
  },

  projects: [
    // =============================================================================
    // 📱 TESTS NAVIGATEURS MOBILES
    // =============================================================================
    
    {
      name: 'android-chrome',
      use: { 
        ...devices['Pixel 7'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
          geolocation: { latitude: 48.8566, longitude: 2.3522 },
        }
      },
      testMatch: ['**/mobile/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    {
      name: 'android-tablet', 
      use: { 
        ...devices['Pixel Tablet'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: ['**/tablet/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    {
      name: 'iphone-safari',
      use: { 
        ...devices['iPhone 14'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
          geolocation: { latitude: 48.8566, longitude: 2.3522 },
        }
      },
      testMatch: ['**/mobile/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    {
      name: 'iphone-plus-safari',
      use: { 
        ...devices['iPhone 14 Pro Max'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: ['**/mobile/**/*.spec.ts'],
    },

    {
      name: 'ipad-safari',
      use: { 
        ...devices['iPad Pro'],
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: ['**/tablet/**/*.spec.ts', '**/shared/**/*.spec.ts'],
    },

    // =============================================================================
    // 📱 TESTS APK ANDROID NATIFS
    // =============================================================================
    
    {
      name: 'android-apk-debug',
      use: {
        ...devices['Pixel 7'],
        baseURL: 'capacitor://localhost',
        contextOptions: {
          permissions: ['geolocation', 'notifications', 'camera', 'microphone'],
          storageState: 'tests/fixtures/android-storage.json',
        }
      },
      testMatch: '**/apk/android/**/*.spec.ts',
      dependencies: ['setup-android-apk'],
    },

    {
      name: 'android-apk-release',
      use: {
        ...devices['Pixel 7'],
        baseURL: 'capacitor://localhost',
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: '**/apk/android/release/**/*.spec.ts',
      dependencies: ['setup-android-apk-release'],
    },

    // =============================================================================
    // 🍎 TESTS APP iOS NATIVES
    // =============================================================================

    {
      name: 'ios-app-debug',
      use: {
        ...devices['iPhone 14'],
        baseURL: 'capacitor://localhost',
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
          storageState: 'tests/fixtures/ios-storage.json',
        }
      },
      testMatch: '**/apk/ios/**/*.spec.ts',
      dependencies: ['setup-ios-app'],
    },

    {
      name: 'ios-app-release',
      use: {
        ...devices['iPhone 14'],
        baseURL: 'capacitor://localhost',
        contextOptions: {
          permissions: ['geolocation', 'notifications'],
        }
      },
      testMatch: '**/apk/ios/release/**/*.spec.ts',
      dependencies: ['setup-ios-app-release'],
    },

    // =============================================================================
    // 🌐 TESTS PWA
    // =============================================================================

    {
      name: 'pwa-android',
      use: {
        ...devices['Pixel 7'],
        contextOptions: {
          serviceWorkers: 'allow',
          permissions: ['notifications', 'geolocation'],
        }
      },
      testMatch: '**/pwa/**/*.spec.ts',
    },

    {
      name: 'pwa-ios',
      use: {
        ...devices['iPhone 14'],
        contextOptions: {
          serviceWorkers: 'allow',
          permissions: ['notifications', 'geolocation'],
        }
      },
      testMatch: '**/pwa/**/*.spec.ts',
    },

    // =============================================================================
    // 🔧 PROJETS DE SETUP/TEARDOWN
    // =============================================================================

    { name: 'setup-android-apk', testMatch: '**/setup/android-apk.setup.ts', teardown: 'teardown-android-apk' },
    { name: 'setup-android-apk-release', testMatch: '**/setup/android-apk-release.setup.ts', teardown: 'teardown-android-apk' },
    { name: 'setup-ios-app', testMatch: '**/setup/ios-app.setup.ts', teardown: 'teardown-ios-app' },
    { name: 'setup-ios-app-release', testMatch: '**/setup/ios-app-release.setup.ts', teardown: 'teardown-ios-app' },
    { name: 'teardown-android-apk', testMatch: '**/teardown/android-apk.teardown.ts' },
    { name: 'teardown-ios-app', testMatch: '**/teardown/ios-app.teardown.ts' },
  ],

  // =============================================================================
  // 🚀 SERVEURS DE DÉVELOPPEMENT
  // =============================================================================

  webServer: [
    {
      command: 'npm run dev',
      url: 'http://localhost:3000',
      reuseExistingServer: !process.env.CI,  
      timeout: 120000,
    },
    {
      command: 'npm run cap:serve',
      url: 'http://localhost:8100',
      reuseExistingServer: !process.env.CI,
      timeout: 180000,
      env: { CAPACITOR_BUILD: 'true' }
    }
  ],

  reporter: [
    ['html', { outputFolder: 'playwright-report-mobile', open: 'never' }],
    ['json', { outputFile: 'test-results/mobile-results.json' }],
    ['junit', { outputFile: 'test-results/mobile-junit.xml' }],
    ['line'],
    ['./tests/reporters/mobile-reporter.ts']
  ]
})
