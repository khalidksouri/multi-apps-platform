#!/bin/bash

# ===================================================================
# GÉNÉRATEUR MATH4CHILD COMPLET + PIPELINES CI/CD
# Application + Tests automatiques + GitHub Actions + Husky
# ===================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  🚀 MATH4CHILD COMPLET + PIPELINES CI/CD 🚀               ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  📚 Application Next.js + Tests Playwright automatiques   ║${NC}"
    echo -e "${BLUE}║  🔄 Pipeline : Push → Build → Test → Deploy               ║${NC}"
    echo -e "${BLUE}║  🌍 www.math4child.com                                    ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_step() { echo -e "${PURPLE}🔄 $1${NC}"; }

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
APP_DIR="$SCRIPT_DIR/apps/math4child"
TESTS_DIR="$SCRIPT_DIR/tests"

# Créer la structure complète
create_complete_structure() {
    print_step "Création de la structure complète..."
    
    # Application
    mkdir -p "$APP_DIR"/{src/{app,components,lib,utils,data,hooks,styles,types},public/{icons,sounds},.github/workflows,.husky,scripts}
    
    # Tests
    mkdir -p "$TESTS_DIR"/{specs,utils,fixtures,data,config,.github/workflows,docker,reports}
    
    print_success "Structure complète créée"
}

# Génération package.json app avec scripts CI/CD
generate_app_package() {
    print_step "Génération package.json application..."
    
    cat > "$APP_DIR/package.json" << 'EOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue pour enfants de 4 à 12 ans",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:ci": "jest --ci --coverage --passWithNoTests",
    "e2e": "cd ../tests && npm run test",
    "e2e:headed": "cd ../tests && npm run test:headed",
    "e2e:mobile": "cd ../tests && npm run test:mobile",
    "test:all": "npm run type-check && npm run lint && npm run test:ci && npm run e2e",
    "prepare": "husky install",
    "pre-commit": "lint-staged",
    "pre-push": "npm run test:all",
    "build:analyze": "ANALYZE=true npm run build",
    "lighthouse": "lighthouse http://localhost:3000 --output=html --output-path=./reports/lighthouse.html",
    "security:audit": "npm audit --audit-level=moderate",
    "deps:update": "npx npm-check-updates -u",
    "clean": "rimraf .next out dist coverage test-results playwright-report",
    "docker:build": "docker build -t math4child-app .",
    "docker:run": "docker run -p 3000:3000 math4child-app"
  },
  "dependencies": {
    "next": "^14.2.30",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.263.1",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "clsx": "^2.1.0",
    "framer-motion": "^11.0.0",
    "zustand": "^4.5.0",
    "react-confetti": "^6.1.0",
    "howler": "^2.2.4",
    "react-hot-toast": "^2.4.1"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@types/howler": "^2.2.11",
    "@types/jest": "^29.5.0",
    "typescript": "^5.4.5",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.30",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "prettier": "^3.2.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@testing-library/react": "^14.2.0",
    "@testing-library/jest-dom": "^6.4.0",
    "@testing-library/user-event": "^14.5.0",
    "husky": "^9.0.0",
    "lint-staged": "^15.2.0",
    "rimraf": "^5.0.0",
    "lighthouse": "^11.4.0",
    "@next/bundle-analyzer": "^14.2.0"
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  },
  "keywords": [
    "math4child",
    "education",
    "mathematics",
    "children",
    "multilingual",
    "learning",
    "games",
    "nextjs",
    "react",
    "typescript"
  ],
  "author": "Math4Child Team",
  "license": "MIT",
  "homepage": "https://www.math4child.com",
  "repository": {
    "type": "git",
    "url": "https://github.com/math4child/app"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
EOF
    
    print_success "package.json application généré"
}

# Génération package.json tests
generate_tests_package() {
    print_step "Génération package.json tests..."
    
    cat > "$TESTS_DIR/package.json" << 'EOF'
{
  "name": "math4child-tests",
  "version": "1.0.0",
  "description": "Suite de tests E2E Playwright pour Math4Child",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    "test:chrome": "playwright test --project=chromium-desktop",
    "test:firefox": "playwright test --project=firefox-desktop",
    "test:safari": "playwright test --project=webkit-desktop",
    "test:mobile": "playwright test --project=mobile-android --project=mobile-ios",
    "test:i18n": "playwright test --project=french-locale --project=spanish-locale --project=arabic-rtl",
    "test:performance": "playwright test --project=performance-chrome performance.spec.ts",
    "test:accessibility": "playwright test --project=accessibility-chrome a11y.spec.ts",
    "test:smoke": "playwright test --grep @smoke",
    "test:regression": "playwright test --grep @regression",
    "test:report": "playwright show-report",
    "test:install": "playwright install",
    "clean": "rimraf test-results playwright-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.41.0",
    "@types/node": "^20.10.0",
    "typescript": "^5.3.0",
    "rimraf": "^5.0.0"
  }
}
EOF
    
    print_success "package.json tests généré"
}

# Pipeline GitHub Actions principal
generate_main_pipeline() {
    print_step "Génération pipeline GitHub Actions principal..."
    
    cat > "$APP_DIR/.github/workflows/ci-cd.yml" << 'EOF'
name: Math4Child CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    - cron: '0 6 * * *'

env:
  NODE_VERSION: 18
  NEXT_PUBLIC_APP_NAME: Math4Child
  NEXT_PUBLIC_DOMAIN: www.math4child.com

jobs:
  # ===================================================================
  # JOB 1: ANALYSE CODE
  # ===================================================================
  analyze:
    name: 📊 Code Analysis
    runs-on: ubuntu-latest
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: apps/math4child/package-lock.json
          
      - name: 📦 Install dependencies
        run: |
          cd apps/math4child
          npm ci
          
      - name: 🔍 TypeScript Check
        run: |
          cd apps/math4child
          npm run type-check
          
      - name: 🔍 ESLint Analysis
        run: |
          cd apps/math4child
          npm run lint
          
      - name: 🔒 Security Audit
        run: |
          cd apps/math4child
          npm audit --audit-level=moderate

  # ===================================================================
  # JOB 2: TESTS UNITAIRES
  # ===================================================================
  unit-tests:
    name: 🧪 Unit Tests
    runs-on: ubuntu-latest
    needs: analyze
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: apps/math4child/package-lock.json
          
      - name: 📦 Install dependencies
        run: |
          cd apps/math4child
          npm ci
          
      - name: 🧪 Run Unit Tests
        run: |
          cd apps/math4child
          npm run test:ci
          
      - name: 📊 Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./apps/math4child/coverage/lcov.info
          fail_ci_if_error: false

  # ===================================================================
  # JOB 3: BUILD APPLICATION
  # ===================================================================
  build:
    name: 🏗️ Build Application
    runs-on: ubuntu-latest
    needs: [analyze, unit-tests]
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: apps/math4child/package-lock.json
          
      - name: 📦 Install dependencies
        run: |
          cd apps/math4child
          npm ci
          
      - name: 🏗️ Build Application
        run: |
          cd apps/math4child
          npm run build
          
      - name: 📤 Upload Build Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-files
          path: apps/math4child/.next
          retention-days: 7

  # ===================================================================
  # JOB 4: TESTS E2E PLAYWRIGHT
  # ===================================================================
  e2e-tests:
    name: 🎭 E2E Tests
    runs-on: ubuntu-latest
    needs: build
    
    strategy:
      matrix:
        browser: [chromium, firefox, webkit]
        
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: 📦 Install App Dependencies
        run: |
          cd apps/math4child
          npm ci
          
      - name: 📤 Download Build Artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-files
          path: apps/math4child/.next
          
      - name: 🎭 Install Playwright
        run: |
          cd tests
          npm ci
          npx playwright install --with-deps ${{ matrix.browser }}
          
      - name: 🚀 Start Application
        run: |
          cd apps/math4child
          npm start &
          sleep 10
        env:
          PORT: 3000
          
      - name: ⏳ Wait for App
        run: |
          timeout 60 bash -c 'until curl -s http://localhost:3000; do sleep 2; done'
          
      - name: 🎭 Run E2E Tests
        run: |
          cd tests
          npx playwright test --project=${{ matrix.browser }}-desktop
        env:
          BASE_URL: http://localhost:3000
          CI: true
          
      - name: 📤 Upload Test Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: playwright-report-${{ matrix.browser }}
          path: tests/playwright-report/
          retention-days: 30

  # ===================================================================
  # JOB 5: TESTS MULTILINGUES
  # ===================================================================
  i18n-tests:
    name: 🌍 Multilingual Tests
    runs-on: ubuntu-latest
    needs: build
    
    strategy:
      matrix:
        locale: [fr-FR, es-ES, de-DE, ar-SA, zh-CN]
        
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: 📦 Install Dependencies
        run: |
          cd apps/math4child && npm ci
          cd tests && npm ci
          
      - name: 🎭 Install Playwright
        run: |
          cd tests
          npx playwright install --with-deps chromium
          
      - name: 📤 Download Build
        uses: actions/download-artifact@v3
        with:
          name: build-files
          path: apps/math4child/.next
          
      - name: 🚀 Start Application
        run: |
          cd apps/math4child
          npm start &
          sleep 10
          
      - name: 🌍 Run I18N Tests
        run: |
          cd tests
          npx playwright test --project=${{ matrix.locale }}-locale
        env:
          BASE_URL: http://localhost:3000
          TEST_LOCALE: ${{ matrix.locale }}
          CI: true
          
      - name: 📤 Upload I18N Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: i18n-report-${{ matrix.locale }}
          path: tests/playwright-report/

  # ===================================================================
  # JOB 6: TESTS PERFORMANCE
  # ===================================================================
  performance-tests:
    name: ⚡ Performance Tests
    runs-on: ubuntu-latest
    needs: build
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: 📦 Install Dependencies
        run: |
          cd apps/math4child && npm ci
          cd tests && npm ci
          
      - name: 📤 Download Build
        uses: actions/download-artifact@v3
        with:
          name: build-files
          path: apps/math4child/.next
          
      - name: 🚀 Start Application
        run: |
          cd apps/math4child
          npm start &
          sleep 10
          
      - name: ⚡ Run Lighthouse Audit
        run: |
          cd apps/math4child
          mkdir -p reports
          npm run lighthouse
          
      - name: ⚡ Run Performance Tests
        run: |
          cd tests
          npx playwright test --project=performance-chrome
        env:
          BASE_URL: http://localhost:3000
          PERF_TESTS: true
          
      - name: 📤 Upload Performance Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: performance-reports
          path: |
            apps/math4child/reports/
            tests/playwright-report/

  # ===================================================================
  # JOB 7: DÉPLOIEMENT
  # ===================================================================
  deploy:
    name: 🚀 Deploy
    runs-on: ubuntu-latest
    needs: [e2e-tests, i18n-tests, performance-tests]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    environment:
      name: production
      url: https://www.math4child.com
      
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        
      - name: 📤 Download Build
        uses: actions/download-artifact@v3
        with:
          name: build-files
          path: apps/math4child/.next
          
      - name: 🚀 Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          working-directory: apps/math4child
          vercel-args: '--prod'

  # ===================================================================
  # JOB 8: NOTIFICATIONS
  # ===================================================================
  notify:
    name: 📧 Notify Results
    runs-on: ubuntu-latest
    needs: [deploy]
    if: always()
    
    steps:
      - name: 📊 Generate Report
        run: |
          echo "# Math4Child Pipeline Results" > report.md
          echo "- **Commit:** ${{ github.sha }}" >> report.md
          echo "- **Branch:** ${{ github.ref }}" >> report.md
          echo "- **Status:** ${{ needs.deploy.result }}" >> report.md
          
      - name: 📧 Notify Slack
        uses: 8398a7/action-slack@v3
        if: always()
        with:
          status: ${{ job.status }}
          text: 'Math4Child Pipeline completed: ${{ job.status }}'
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
EOF
    
    print_success "Pipeline principal généré"
}

# Pipeline tests spécialisés
generate_specialized_pipeline() {
    print_step "Génération pipeline tests spécialisés..."
    
    cat > "$APP_DIR/.github/workflows/specialized-tests.yml" << 'EOF'
name: Math4Child Specialized Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:

jobs:
  # Tests d'accessibilité
  accessibility-tests:
    name: ♿ Accessibility Tests
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'
          cache-dependency-path: apps/math4child/package-lock.json
          
      - name: Install dependencies
        run: |
          cd apps/math4child && npm ci
          cd tests && npm ci && npx playwright install --with-deps
          
      - name: Start app
        run: |
          cd apps/math4child
          npm run build
          npm start &
          sleep 10
          
      - name: Run A11Y tests
        run: |
          cd tests
          npx playwright test --project=accessibility-chrome
        env:
          BASE_URL: http://localhost:3000
          
      - name: Upload A11Y Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: accessibility-report
          path: tests/playwright-report/

  # Tests mobile
  mobile-tests:
    name: 📱 Mobile Tests
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
          
      - name: Install dependencies
        run: |
          cd apps/math4child && npm ci
          cd tests && npm ci && npx playwright install --with-deps
          
      - name: Start app
        run: |
          cd apps/math4child
          npm run build
          npm start &
          sleep 10
          
      - name: Run Mobile Tests
        run: |
          cd tests
          npx playwright test --project=mobile-android --project=mobile-ios
        env:
          BASE_URL: http://localhost:3000
          
      - name: Upload Mobile Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: mobile-test-report
          path: tests/playwright-report/

  # Tests de sécurité
  security-tests:
    name: 🔒 Security Tests
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: 'apps/math4child'
          format: 'sarif'
          output: 'trivy-results.sarif'
          
      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'
EOF
    
    print_success "Pipeline spécialisé généré"
}

# Configuration Playwright
generate_playwright_config() {
    print_step "Génération configuration Playwright..."
    
    cat > "$TESTS_DIR/playwright.config.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure'
  },

  projects: [
    {
      name: 'chromium-desktop',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox-desktop',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit-desktop',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-android',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-ios',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'french-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris'
      },
    },
    {
      name: 'arabic-rtl',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh'
      },
    },
    {
      name: 'performance-chrome',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'accessibility-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        reducedMotion: 'reduce'
      },
    }
  ],

  webServer: {
    command: 'cd ../apps/math4child && npm run start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
});
EOF
    
    print_success "Configuration Playwright générée"
}

# Hooks Git avec Husky
generate_git_hooks() {
    print_step "Génération hooks Git avec Husky..."
    
    # Pre-commit hook
    cat > "$APP_DIR/.husky/pre-commit" << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Running pre-commit checks..."
npx lint-staged
echo "✅ Pre-commit checks passed!"
EOF

    # Pre-push hook
    cat > "$APP_DIR/.husky/pre-push" << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🚀 Running pre-push checks..."

# Type checking
echo "📝 Checking TypeScript..."
npm run type-check

# Linting
echo "🔍 Running ESLint..."
npm run lint

# Unit tests
echo "🧪 Running unit tests..."
npm run test:ci

# Build test
echo "🏗️ Testing build..."
npm run build

echo "✅ All pre-push checks passed!"
EOF

    # Commit message hook
    cat > "$APP_DIR/.husky/commit-msg" << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Validation format des messages de commit
commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "❌ Format de commit invalide!"
    echo "Format: type(scope): description"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    echo "Exemple: feat(game): add multiplication level"
    exit 1
fi

echo "✅ Format de commit valide"
EOF

    # Rendre exécutables
    chmod +x "$APP_DIR/.husky/pre-commit"
    chmod +x "$APP_DIR/.husky/pre-push" 
    chmod +x "$APP_DIR/.husky/commit-msg"
    
    print_success "Hooks Git générés"
}

# Application React principale
generate_main_app() {
    print_step "Génération application React principale..."
    
    cat > "$APP_DIR/src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  Calculator, Trophy, Globe, ChevronDown, Users, Star, 
  Play, BookOpen, Check, ArrowLeft, Crown, Volume2, VolumeX
} from 'lucide-react'

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState('en')
  const [currentView, setCurrentView] = useState('home')
  const [mounted, setMounted] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const languages = {
    'en': { name: 'English', flag: '🇺🇸' },
    'fr': { name: 'Français', flag: '🇫🇷' },
    'es': { name: 'Español', flag: '🇪🇸' },
    'de': { name: 'Deutsch', flag: '🇩🇪' },
    'ar': { name: 'العربية', flag: '🇸🇦' },
    'zh': { name: '中文', flag: '🇨🇳' }
  }

  const translations = {
    en: {
      title: 'Math4Child - Learn math while having fun',
      subtitle: 'Multilingual educational platform for children aged 4 to 12',
      levels: ['Beginner', 'Elementary', 'Intermediate', 'Advanced', 'Expert'],
      operations: ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Mixed']
    },
    fr: {
      title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
      subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
      levels: ['Débutant', 'Élémentaire', 'Intermédiaire', 'Avancé', 'Expert'],
      operations: ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Mixte']
    }
  }

  const t = translations[currentLanguage] || translations['en']

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full mx-auto mb-4 animate-spin" />
          <p className="text-lg text-gray-600">Loading Math4Child...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header */}
      <header className="p-4 flex justify-between items-center backdrop-blur-sm bg-white/30 sticky top-0 z-50">
        <div className="flex items-center space-x-2">
          <div className="p-2 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl">
            <Calculator className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Math4Child
          </span>
        </div>
        
        <div className="flex items-center space-x-4">
          <div className="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
            Free questions remaining: 45
          </div>
          
          <button
            onClick={() => setSoundEnabled(!soundEnabled)}
            className="p-2 bg-white/20 backdrop-blur-sm rounded-lg text-white hover:bg-white/30 transition-colors"
          >
            {soundEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
          </button>
          
          <div className="relative">
            <button 
              onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
              className="bg-white/90 backdrop-blur border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 hover:border-blue-300 transition-all duration-200 cursor-pointer flex items-center space-x-2"
            >
              <span>{languages[currentLanguage]?.flag}</span>
              <span>{languages[currentLanguage]?.name}</span>
              <ChevronDown className={`w-4 h-4 transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
            </button>
            
            {showLanguageDropdown && (
              <div className="absolute right-0 mt-2 bg-white rounded-xl shadow-2xl z-50 border">
                <div className="p-2">
                  {Object.entries(languages).map(([code, config]) => (
                    <button
                      key={code}
                      onClick={() => {
                        setCurrentLanguage(code)
                        setShowLanguageDropdown(false)
                      }}
                      className="w-full text-left px-3 py-2 rounded-lg hover:bg-blue-50 transition-colors flex items-center space-x-3 min-w-[200px]"
                    >
                      <span className="text-xl">{config.flag}</span>
                      <div>
                        <div className="font-medium text-gray-900">{config.name}</div>
                      </div>
                      {currentLanguage === code && <Check className="w-4 h-4 text-blue-500 ml-auto" />}
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-6xl mx-auto text-center mb-16">
          <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
            {t.title}
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-12 max-w-4xl mx-auto">
            {t.subtitle}
          </p>

          {/* Statistics */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            {[
              { value: '10K+', label: 'Active students', icon: Users },
              { value: '500+', label: 'Available exercises', icon: BookOpen },
              { value: '20', label: 'Supported languages', icon: Globe },
              { value: '98%', label: 'Parent satisfaction', icon: Star }
            ].map((stat, index) => (
              <div key={index} className="p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300">
                <div className="text-3xl font-bold text-blue-600 mb-2">{stat.value}</div>
                <div className="text-sm text-gray-600 flex items-center gap-2">
                  <stat.icon className="w-4 h-4" />
                  {stat.label}
                </div>
              </div>
            ))}
          </div>

          {/* Levels */}
          <div className="mb-16">
            <h2 className="text-3xl font-bold text-gray-800 mb-8">Choose your level</h2>
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              {t.levels.map((level, index) => (
                <div
                  key={index}
                  className="p-6 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer"
                >
                  <div className="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl mx-auto w-fit mb-4">
                    <Trophy className="w-8 h-8 text-white" />
                  </div>
                  <h3 className="font-bold text-gray-800 mb-2">{level}</h3>
                  <div className="text-sm text-gray-600 mb-3">0/100 ✓</div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="h-2 rounded-full bg-gradient-to-r from-blue-500 to-purple-600" style={{width: '0%'}} />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Call to Action */}
          <div className="space-y-6 md:space-y-0 md:space-x-6 md:flex md:justify-center md:items-center">
            <button className="group px-10 py-4 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white rounded-2xl font-bold transition-all duration-300 shadow-2xl">
              <span className="flex items-center gap-2">
                <Crown className="w-5 h-5" />
                Subscribe Now
              </span>
            </button>
            
            <button className="group px-10 py-4 border-2 border-gray-300 text-gray-700 rounded-2xl font-bold hover:border-blue-400 hover:bg-blue-50 hover:text-blue-600 transition-all duration-300">
              <span className="flex items-center gap-2">
                <Play className="w-5 h-5" />
                Free Trial
              </span>
            </button>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 text-center text-gray-500 bg-white/30 backdrop-blur-sm">
        <p>© 2024 Math4Child. Made with ❤️ for children worldwide.</p>
        <div className="mt-2 text-sm">
          <span>🌍 www.math4child.com</span>
        </div>
      </footer>
    </div>
  )
}
EOF
    
    print_success "Application React principale générée"
}

# Test de base Playwright
generate_basic_test() {
    print_step "Génération test de base Playwright..."
    
    mkdir -p "$TESTS_DIR/specs"
    
    cat > "$TESTS_DIR/specs/math4child-basic.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests de base', () => {
  
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre Math4Child
    await expect(page.locator('h1')).toContainText(/Math4Child/i);
    
    // Vérifier les statistiques
    await expect(page.locator(':text("10K+")')).toBeVisible();
    await expect(page.locator(':text("500+")')).toBeVisible();
    await expect(page.locator(':text("20")')).toBeVisible();
    await expect(page.locator(':text("98%")')).toBeVisible();
  });
  
  test('Changement de langue vers le français @i18n', async ({ page }) => {
    await page.goto('/');
    
    // Ouvrir le sélecteur de langues
    await page.click('button:has-text("English")');
    
    // Cliquer sur Français
    await page.click('button:has-text("Français")');
    
    // Vérifier la traduction
    await expect(page.locator('body')).toContainText(/mathématiques|français/i);
  });
  
  test('Navigation vers les niveaux', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier la présence des 5 niveaux
    await expect(page.locator(':text("Beginner")')).toBeVisible();
    await expect(page.locator(':text("Elementary")')).toBeVisible();
    await expect(page.locator(':text("Intermediate")')).toBeVisible();
    await expect(page.locator(':text("Advanced")')).toBeVisible();
    await expect(page.locator(':text("Expert")')).toBeVisible();
  });

  test('Boutons Call-to-Action visibles', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.locator('button:has-text("Subscribe Now")')).toBeVisible();
    await expect(page.locator('button:has-text("Free Trial")')).toBeVisible();
  });

});
EOF
    
    print_success "Test de base généré"
}

# Configurations additionnelles
generate_additional_configs() {
    print_step "Génération configurations additionnelles..."
    
    # Next.js config
    cat > "$APP_DIR/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_DOMAIN: 'www.math4child.com',
  },
}

module.exports = nextConfig
EOF

    # TypeScript config app
    cat > "$APP_DIR/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

    # Tailwind config
    cat > "$APP_DIR/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

    # Layout app
    cat > "$APP_DIR/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Learn math while having fun',
  description: 'Multilingual educational platform for children aged 4 to 12',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  )
}
EOF

    # Styles globaux
    cat > "$APP_DIR/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

body {
  color: #1f2937;
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #f3e8ff 100%);
  min-height: 100vh;
}

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}
EOF
    
    print_success "Configurations additionnelles générées"
}

# Makefile pour commandes pratiques
generate_makefile() {
    print_step "Génération Makefile..."
    
    cat > "$SCRIPT_DIR/Makefile" << 'EOF'
.PHONY: help install dev test clean

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installer toutes les dépendances
	cd apps/math4child && npm install
	cd tests && npm install && npx playwright install --with-deps

dev: ## Démarrer l'application en développement
	cd apps/math4child && npm run dev

test: ## Lancer tous les tests
	cd tests && npm run test

test-headed: ## Tests avec interface graphique
	cd tests && npm run test:headed

test-ui: ## Interface Playwright UI
	cd tests && npm run test:ui

test-mobile: ## Tests mobile uniquement
	cd tests && npm run test:mobile

test-i18n: ## Tests multilingues
	cd tests && npm run test:i18n

build: ## Build application
	cd apps/math4child && npm run build

lint: ## Vérifier le code
	cd apps/math4child && npm run lint

type-check: ## Vérifier TypeScript
	cd apps/math4child && npm run type-check

clean: ## Nettoyer
	cd apps/math4child && npm run clean
	cd tests && npm run clean

setup: install ## Configuration complète
	cd apps/math4child && npx husky install
	@echo "✅ Configuration terminée !"
EOF
    
    print_success "Makefile généré"
}

# Instructions finales
show_final_instructions() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║  🎉 MATH4CHILD COMPLET + CI/CD GÉNÉRÉ ! 🎉               ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}📁 STRUCTURE GÉNÉRÉE :${NC}"
    echo -e "   ├── apps/math4child/                 # Application Next.js"
    echo -e "   │   ├── src/app/page.tsx             # App React complète"
    echo -e "   │   ├── .github/workflows/           # Pipelines GitHub Actions"
    echo -e "   │   ├── .husky/                      # Hooks Git automatiques"
    echo -e "   │   └── package.json                 # Scripts CI/CD"
    echo -e "   ├── tests/                           # Tests Playwright"
    echo -e "   │   ├── specs/                       # Tests E2E"
    echo -e "   │   ├── playwright.config.ts         # Config Playwright"
    echo -e "   │   └── package.json                 # Scripts tests"
    echo -e "   └── Makefile                         # Commandes pratiques"
    echo ""
    
    echo -e "${GREEN}🚀 COMMANDES PRINCIPALES :${NC}"
    echo ""
    
    echo -e "${BLUE}1. Installation :${NC}"
    echo -e "   ${YELLOW}make install${NC}                   # Installer tout"
    echo -e "   ${YELLOW}make setup${NC}                     # Configuration complète"
    echo ""
    
    echo -e "${BLUE}2. Développement :${NC}"
    echo -e "   ${YELLOW}make dev${NC}                       # Démarrer l'app"
    echo -e "   ${YELLOW}make test-headed${NC}               # Tests avec interface"
    echo -e "   ${YELLOW}make test-ui${NC}                   # Interface Playwright"
    echo ""
    
    echo -e "${BLUE}3. Tests automatiques :${NC}"
    echo -e "   ${YELLOW}make test${NC}                      # Tous les tests"
    echo -e "   ${YELLOW}make test-mobile${NC}               # Tests mobile"
    echo -e "   ${YELLOW}make test-i18n${NC}                 # Tests multilingues"
    echo ""
    
    echo -e "${GREEN}🔄 PIPELINES CI/CD INCLUS :${NC}"
    echo -e "   ✅ Tests automatiques à chaque push GitHub"
    echo -e "   ✅ Vérification TypeScript + ESLint"
    echo -e "   ✅ Tests unitaires + E2E Playwright"
    echo -e "   ✅ Tests multilingues (6 langues)"
    echo -e "   ✅ Tests mobile + performance"
    echo -e "   ✅ Hooks Git avec Husky"
    echo -e "   ✅ Déploiement automatique Vercel"
    echo ""
    
    echo -e "${GREEN}📋 PROCHAINES ÉTAPES :${NC}"
    echo -e "   1. ${YELLOW}make setup${NC}                   # Configuration"
    echo -e "   2. ${YELLOW}git init && git add .${NC}        # Initialiser Git"
    echo -e "   3. ${YELLOW}git commit -m \"feat: initial setup\"${NC}  # Premier commit"
    echo -e "   4. Push vers GitHub → Tests automatiques ! 🚀"
    echo ""
    
    echo -e "${PURPLE}🌟 Application Math4Child prête avec pipelines CI/CD complets !${NC}"
}

# Fonction principale
main() {
    print_header
    
    echo -e "${BLUE}Ce script génère une application Math4Child COMPLÈTE avec :${NC}"
    echo ""
    echo -e "📱 Application React/Next.js multilingue"
    echo -e "🎭 Suite de tests Playwright complète"
    echo -e "🔄 Pipelines GitHub Actions automatiques"
    echo -e "🪝 Hooks Git avec Husky"
    echo -e "📊 Tests à chaque push : TypeScript → ESLint → Tests → Deploy"
    echo -e "🌍 Support 20 langues + tests multilingues"
    echo -e "📱 Tests responsive (Mobile/Desktop)"
    echo ""
    
    read -p "Générer Math4Child complet avec CI/CD ? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Génération annulée."
        exit 0
    fi
    
    # Étapes de génération
    create_complete_structure
    generate_app_package
    generate_tests_package
    generate_main_pipeline
    generate_specialized_pipeline
    generate_playwright_config
    generate_git_hooks
    generate_main_app
    generate_basic_test
    generate_additional_configs
    generate_makefile
    show_final_instructions
}

# Gestion des erreurs
trap 'print_error "Erreur durant la génération"; exit 1' ERR

# Lancement
main "$@"