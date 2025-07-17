#!/bin/bash

# Configuration Playwright pour multi-apps-platform

set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎭 CONFIGURATION PLAYWRIGHT E2E TESTING${NC}"
echo -e "${BLUE}=========================================${NC}"

# Créer la structure de tests
mkdir -p "$WORKSPACE_DIR/tests/e2e"
mkdir -p "$WORKSPACE_DIR/tests/config"

# Créer playwright.config.ts
cat > "$WORKSPACE_DIR/playwright.config.ts" << 'EOF'
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
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 15000,
    navigationTimeout: 30000,
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
  
  outputDir: 'test-results/artifacts',
  
  // Server de test local
  webServer: [
    {
      command: 'cd math4kids && npm start',
      url: 'http://localhost:3001',
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
    {
      command: 'cd unitflip && npm start',
      url: 'http://localhost:3002',
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
    {
      command: 'cd budgetcron && npm run serve',
      url: 'http://localhost:3003',
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
    {
      command: 'cd ai4kids && npm start',
      url: 'http://localhost:3004',
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
    {
      command: 'cd multiai && npm run dev',
      url: 'http://localhost:3005',
      reuseExistingServer: !process.env.CI,
      timeout: 120000,
    },
  ],
});
EOF

# Créer des tests d'exemple pour chaque application
cat > "$WORKSPACE_DIR/tests/e2e/math4kids.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Math4Kids Application', () => {
  test('should load homepage', async ({ page }) => {
    await page.goto('http://localhost:3001');
    await expect(page).toHaveTitle(/Math4kids/i);
    await expect(page.locator('h1')).toContainText('Bienvenue sur Math4kids');
  });

  test('should be responsive', async ({ page }) => {
    await page.goto('http://localhost:3001');
    
    // Test desktop
    await page.setViewportSize({ width: 1200, height: 800 });
    await expect(page.locator('.App-header')).toBeVisible();
    
    // Test mobile
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.locator('.App-header')).toBeVisible();
  });

  test('should have no console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    await page.goto('http://localhost:3001');
    await page.waitForLoadState('networkidle');
    
    expect(errors).toHaveLength(0);
  });
});
EOF

cat > "$WORKSPACE_DIR/tests/e2e/unitflip.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('UnitFlip Application', () => {
  test('should load homepage', async ({ page }) => {
    await page.goto('http://localhost:3002');
    await expect(page).toHaveTitle(/Unitflip/i);
    await expect(page.locator('h1')).toContainText('Bienvenue sur Unitflip');
  });

  test('should handle navigation', async ({ page }) => {
    await page.goto('http://localhost:3002');
    await expect(page.locator('.App')).toBeVisible();
  });
});
EOF

cat > "$WORKSPACE_DIR/tests/e2e/budgetcron.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('BudgetCron Application', () => {
  test('should load Vue.js application', async ({ page }) => {
    await page.goto('http://localhost:3003');
    await expect(page).toHaveTitle(/BudgetCron/i);
    await expect(page.locator('h1')).toContainText('BudgetCron');
  });

  test('should render Vue components', async ({ page }) => {
    await page.goto('http://localhost:3003');
    await expect(page.locator('#app')).toBeVisible();
  });
});
EOF

cat > "$WORKSPACE_DIR/tests/e2e/ai4kids.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('AI4Kids Application', () => {
  test('should load safely for children', async ({ page }) => {
    await page.goto('http://localhost:3004');
    await expect(page).toHaveTitle(/Ai4kids/i);
    await expect(page.locator('h1')).toContainText('Bienvenue sur Ai4kids');
  });

  test('should have child-safe content', async ({ page }) => {
    await page.goto('http://localhost:3004');
    
    // Vérifier qu'il n'y a pas de contenu inapproprié
    const content = await page.textContent('body');
    expect(content).not.toMatch(/adult|inappropriate/i);
  });
});
EOF

cat > "$WORKSPACE_DIR/tests/e2e/multiai.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('MultiAI Application', () => {
  test('should load Next.js application', async ({ page }) => {
    await page.goto('http://localhost:3005');
    await expect(page).toHaveTitle(/MultiAI/i);
    await expect(page.locator('h1')).toContainText('MultiAI');
  });

  test('should have proper Next.js structure', async ({ page }) => {
    await page.goto('http://localhost:3005');
    await expect(page.locator('main')).toBeVisible();
  });
});
EOF

# Créer un test global pour la plateforme
cat > "$WORKSPACE_DIR/tests/e2e/platform.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

const apps = [
  { name: 'Math4Kids', url: 'http://localhost:3001', title: /Math4kids/i },
  { name: 'UnitFlip', url: 'http://localhost:3002', title: /Unitflip/i },
  { name: 'BudgetCron', url: 'http://localhost:3003', title: /BudgetCron/i },
  { name: 'AI4Kids', url: 'http://localhost:3004', title: /Ai4kids/i },
  { name: 'MultiAI', url: 'http://localhost:3005', title: /MultiAI/i },
];

test.describe('Multi-Apps Platform', () => {
  test('all applications should be accessible', async ({ page }) => {
    for (const app of apps) {
      await test.step(`Testing ${app.name}`, async () => {
        await page.goto(app.url);
        await expect(page).toHaveTitle(app.title);
        console.log(`✅ ${app.name} is accessible`);
      });
    }
  });

  test('all applications should load within timeout', async ({ page }) => {
    for (const app of apps) {
      await test.step(`Load time test for ${app.name}`, async () => {
        const start = Date.now();
        await page.goto(app.url);
        const loadTime = Date.now() - start;
        
        expect(loadTime).toBeLessThan(10000); // 10 seconds max
        console.log(`⚡ ${app.name} loaded in ${loadTime}ms`);
      });
    }
  });

  test('check for port conflicts', async ({ page }) => {
    // Vérifier que chaque port répond correctement
    const ports = [3001, 3002, 3003, 3004, 3005];
    
    for (const port of ports) {
      await test.step(`Testing port ${port}`, async () => {
        const response = await page.request.get(`http://localhost:${port}`);
        expect(response.status()).toBe(200);
      });
    }
  });
});
EOF

# Créer package.json pour Playwright
cat > "$WORKSPACE_DIR/package.json" << 'EOF'
{
  "name": "multi-apps-platform-tests",
  "version": "1.0.0",
  "description": "Tests E2E pour la plateforme multi-applications",
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    "test:report": "playwright show-report",
    "test:install": "playwright install",
    "test:codegen": "playwright codegen localhost:3001"
  },
  "devDependencies": {
    "@playwright/test": "^1.48.2",
    "@types/node": "^22.10.2",
    "typescript": "^5.7.2"
  }
}
EOF

# Créer .gitignore pour les tests
cat > "$WORKSPACE_DIR/.gitignore" << 'EOF'
node_modules/
test-results/
playwright-report/
playwright/.cache/
.env
*.log
.DS_Store
EOF

# Installer Playwright
cd "$WORKSPACE_DIR"
npm install
npx playwright install

echo -e "${GREEN}✅ Configuration Playwright terminée!${NC}"
echo ""
echo -e "${YELLOW}🎭 Commandes Playwright disponibles:${NC}"
echo "  npm test                 - Lancer tous les tests"
echo "  npm run test:headed      - Tests avec interface graphique"
echo "  npm run test:debug       - Mode debug"
echo "  npm run test:ui          - Interface utilisateur Playwright"
echo "  npm run test:report      - Voir les rapports"
echo "  npm run test:codegen     - Générateur de code"
echo ""
echo -e "${YELLOW}📋 Structure créée:${NC}"
echo "  ├── playwright.config.ts     - Configuration principale"
echo "  ├── tests/e2e/              - Tests par application"
echo "  ├── test-results/            - Résultats et artefacts"
echo "  └── package.json             - Dépendances Playwright"