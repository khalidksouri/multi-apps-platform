#!/bin/bash

# Correction rapide scripts package.json pour Math4Child
echo "🔧 Correction des scripts package.json..."

# Ajouter les scripts manquants
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// Scripts essentiels Math4Child
pkg.scripts = {
  // Scripts de base Next.js
  'dev': 'next dev',
  'build': 'next build', 
  'start': 'next start',
  'lint': 'next lint',
  'type-check': 'tsc --noEmit',
  
  // Scripts de build
  'build:web': 'next build',
  'build:capacitor': 'CAPACITOR_BUILD=true next build',
  'export': 'next export',
  
  // Scripts Capacitor
  'android:build': 'npm run build:capacitor && npx cap sync android && npx cap open android',
  'ios:build': 'npm run build:capacitor && npx cap sync ios && npx cap open ios',
  'android:dev': 'npm run build:capacitor && npx cap run android --livereload',
  'ios:dev': 'npm run build:capacitor && npx cap run ios --livereload',
  
  // Scripts de test (sans webServer pour éviter l'erreur)
  'test': 'playwright test --config=playwright.config.simple.ts',
  'test:math4child': 'playwright test --grep \"Math4Child\" --config=playwright.config.simple.ts',
  'test:mobile': 'playwright test --grep \"mobile\" --config=playwright.config.simple.ts',
  'test:rtl': 'playwright test --grep \"@rtl\" --config=playwright.config.simple.ts',
  'test:translation': 'playwright test --grep \"@translation\" --config=playwright.config.simple.ts',
  'test:headed': 'playwright test --headed --config=playwright.config.simple.ts',
  'test:ui': 'playwright test --ui --config=playwright.config.simple.ts',
  'test:report': 'playwright show-report',
  
  // Scripts de maintenance
  'clean': 'rm -rf .next out node_modules/.cache',
  'clean:all': 'npm run clean && rm -rf node_modules'
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Scripts package.json corrigés');
"

# Créer configuration Playwright simplifiée sans webServer
cat > playwright.config.simple.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

/**
 * Configuration Playwright simplifiée pour Math4Child
 * Sans webServer automatique pour éviter les conflits
 */
export default defineConfig({
  testDir: './tests',
  timeout: 30 * 1000,
  expect: { timeout: 5000 },
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list']
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  
  projects: [
    {
      name: 'math4child-desktop',
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'math4child-mobile', 
      use: { ...devices['Pixel 5'] }
    }
  ]
  
  // Pas de webServer - à lancer manuellement avec `npm run dev`
});
EOF

echo "✅ Configuration Playwright simplifiée créée"
echo ""
echo "🚀 Pour tester Math4Child maintenant :"
echo "1. Terminal 1: npm run dev"
echo "2. Terminal 2: npm run test"
echo ""
echo "📱 Ou directement:"  
echo "npm run test:math4child"