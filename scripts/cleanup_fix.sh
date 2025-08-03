#!/bin/bash

# Correction rapide pour finir le nettoyage
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Finalisation du nettoyage Math4Child...${NC}"

# Supprimer tests obsolètes
echo -e "${GREEN}Suppression tests obsolètes...${NC}"
rm -f tests/apps/postmath.spec.ts 2>/dev/null || true
rm -f tests/apps/unitflip.spec.ts 2>/dev/null || true  
rm -f tests/apps/budgetcron.spec.ts 2>/dev/null || true
rm -f tests/apps/ai4kids.spec.ts 2>/dev/null || true
rm -f tests/apps/multiai.spec.ts 2>/dev/null || true

# Mise à jour package.json pour Math4Child focus
echo -e "${GREEN}Mise à jour package.json...${NC}"
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.name = 'math4child-app';
pkg.description = 'Math4Child - Application éducative de mathématiques pour enfants';

pkg.scripts = {
  ...pkg.scripts,
  'test': 'playwright test',
  'test:math4child': 'playwright test --grep \"Math4Child\"',
  'test:mobile': 'playwright test --project=math4child-mobile || playwright test --grep \"mobile\"',
  'test:rtl': 'playwright test --grep \"@rtl\"',
  'test:translation': 'playwright test --grep \"@translation\"',
  'test:capacitor': 'playwright test --grep \"capacitor|deployment\"'
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

# Créer configuration Playwright simplifiée
echo -e "${GREEN}Configuration Playwright Math4Child...${NC}"
cat > playwright.config.ts << 'EOFCONFIG'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30 * 1000,
  expect: { timeout: 5000 },
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'math4child',
      use: { ...devices['Desktop Chrome'] }
    }
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
EOFCONFIG

echo -e "${GREEN}✅ Nettoyage terminé !${NC}"
echo -e "${BLUE}🧪 Testez maintenant: npm run test${NC}"
