// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* Opt out of parallel tests on CI. */
  workers: process.env.CI ? 1 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Base URL to use in actions like `await page.goto('/')`. */
    baseURL: 'http://localhost:3001',
    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'math4kids',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: 'http://localhost:3001'
      },
    },
    {
      name: 'unitflip',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: 'http://localhost:3002'
      },
    },
    {
      name: 'budgetcron',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: 'http://localhost:3003'
      },
    },
    {
      name: 'ai4kids',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: 'http://localhost:3004'
      },
    },
    {
      name: 'multiai',
      use: { 
        ...devices['Desktop Chrome'],
        baseURL: 'http://localhost:3005'
      },
    },
  ],

  /* Run your local dev server before starting the tests */
  webServer: [
    {
      command: 'cd /Users/khalidksouri/global-multi-apps-workspace/math4kids && npm start',
      port: 3001,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd /Users/khalidksouri/global-multi-apps-workspace/unitflip && npm start',
      port: 3002,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd /Users/khalidksouri/global-multi-apps-workspace/budgetcron && npm run dev',
      port: 3003,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd /Users/khalidksouri/global-multi-apps-workspace/ai4kids && npm start',
      port: 3004,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'cd /Users/khalidksouri/global-multi-apps-workspace/multiai && npm run dev',
      port: 3005,
      reuseExistingServer: !process.env.CI,
    },
  ],
});

// tests/example.spec.ts - Exemple de test pour toutes les applications
import { test, expect } from '@playwright/test';

test.describe('Multi-Apps Platform Tests', () => {
  
  test('Math4Kids - Page loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3001');
    await expect(page).toHaveTitle(/Math4Kids/i);
    await expect(page.locator('h1')).toContainText('Math4Kids');
  });

  test('UnitFlip - Page loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3002');
    await expect(page).toHaveTitle(/UnitFlip/i);
    await expect(page.locator('h1')).toContainText('UnitFlip');
  });

  test('BudgetCron - Page loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3003');
    await expect(page).toHaveTitle(/BudgetCron/i);
    await expect(page.locator('h1')).toContainText('BudgetCron');
  });

  test('AI4Kids - Page loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3004');
    await expect(page).toHaveTitle(/AI4Kids/i);
    await expect(page.locator('h1')).toContainText('AI4Kids');
  });

  test('MultiAI - Page loads correctly', async ({ page }) => {
    await page.goto('http://localhost:3005');
    await expect(page).toHaveTitle(/MultiAI/i);
    await expect(page.locator('h1')).toContainText('MultiAI');
  });

  test('All apps have glassmorphism design', async ({ page }) => {
    const urls = [
      'http://localhost:3001',
      'http://localhost:3002',
      'http://localhost:3004'
    ];

    for (const url of urls) {
      await page.goto(url);
      
      // Vérifier la présence de la carte glassmorphism
      const glassCard = page.locator('.glass-card');
      await expect(glassCard).toBeVisible();
      
      // Vérifier le style backdrop-filter
      const backdropFilter = await glassCard.evaluate(
        el => window.getComputedStyle(el).backdropFilter
      );
      expect(backdropFilter).toContain('blur');
    }
  });

  test('TypeScript compilation check', async ({ page }) => {
    // Ce test vérifie que les applications TypeScript n'ont pas d'erreurs
    await page.goto('http://localhost:3001');
    
    // Écouter les erreurs de la console
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });

    // Attendre que la page se charge complètement
    await page.waitForLoadState('networkidle');
    
    // Vérifier qu'il n'y a pas d'erreurs TypeScript
    const tsErrors = errors.filter(error => 
      error.includes('TypeScript') || 
      error.includes('TS') ||
      error.includes('type')
    );
    
    expect(tsErrors.length).toBe(0);
  });

  test('Responsive design check', async ({ page }) => {
    await page.goto('http://localhost:3001');
    
    // Test desktop
    await page.setViewportSize({ width: 1920, height: 1080 });
    await expect(page.locator('.glass-card')).toBeVisible();
    
    // Test mobile
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.locator('.glass-card')).toBeVisible();
    
    // Test tablet
    await page.setViewportSize({ width: 768, height: 1024 });
    await expect(page.locator('.glass-card')).toBeVisible();
  });

  test('Cross-browser compatibility', async ({ page, browserName }) => {
    await page.goto('http://localhost:3001');
    
    // Vérifier que l'application fonctionne sur tous les navigateurs
    await expect(page.locator('h1')).toBeVisible();
    await expect(page.locator('.glass-card')).toBeVisible();
    
    // Log du navigateur pour debugging
    console.log(`Test executed on: ${browserName}`);
  });

});

// tests/performance.spec.ts - Tests de performance
import { test, expect } from '@playwright/test';

test.describe('Performance Tests', () => {
  
  test('Page load performance', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('http://localhost:3001');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    
    // La page doit se charger en moins de 3 secondes
    expect(loadTime).toBeLessThan(3000);
    
    console.log(`Page loaded in ${loadTime}ms`);
  });

  test('Bundle size check', async ({ page }) => {
    await page.goto('http://localhost:3001');
    
    // Analyser les ressources chargées
    const resources = await page.evaluate(() => {
      const entries = performance.getEntriesByType('resource');
      return entries.map(entry => ({
        name: entry.name,
        size: entry.transferSize,
        type: entry.initiatorType
      }));
    });

    const jsResources = resources.filter(r => r.name.includes('.js'));
    const totalJSSize = jsResources.reduce((sum, r) => sum + (r.size || 0), 0);
    
    // Le bundle JS ne doit pas dépasser 2MB
    expect(totalJSSize).toBeLessThan(2 * 1024 * 1024);
    
    console.log(`Total JS bundle size: ${totalJSSize} bytes`);
  });

});

// package.json additions for Playwright
/*
{
  "devDependencies": {
    "@playwright/test": "^1.40.0"
  },
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:report": "playwright show-report"
  }
}
*/