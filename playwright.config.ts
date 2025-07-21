import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['junit', { outputFile: 'junit-results.xml' }],
    process.env.CI ? ['github'] : ['line']
  ],
  
  use: {
    baseURL: process.env.TEST_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
    
    // Headers pour simulation Capacitor
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8'
    }
  },

  projects: [
    // Tests Desktop - Configuration complète
    {
      name: 'desktop-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 }
      },
    },
    
    {
      name: 'desktop-firefox',
      use: { 
        ...devices['Desktop Firefox'],
        viewport: { width: 1920, height: 1080 }
      },
    },
    
    {
      name: 'desktop-safari',
      use: { 
        ...devices['Desktop Safari'],
        viewport: { width: 1920, height: 1080 }
      },
    },
    
    // Tests Mobile - Simulation Capacitor
    {
      name: 'mobile-android',
      use: { 
        ...devices['Pixel 5'],
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'android',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 Math4Child/2.0.0 Capacitor'
        }
      },
    },
    
    {
      name: 'mobile-ios',
      use: { 
        ...devices['iPhone 13'],
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'ios',
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) Math4Child/2.0.0 Capacitor'
        }
      },
    },
    
    // Tests Tablet
    {
      name: 'tablet-ipad',
      use: { 
        ...devices['iPad Pro'],
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'ios'
        }
      },
    },
    
    // Tests RTL spécifiques
    {
      name: 'rtl-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh'
      },
    },
    
    {
      name: 'rtl-mobile',
      use: { 
        ...devices['Pixel 5'],
        locale: 'ar-SA',
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'android'
        }
      },
    },
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
