#!/bin/bash
# =============================================
# 📄 scripts/setup-local.sh - Setup immédiat sans Docker
# =============================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Emojis
CHECK="✅"
ROCKET="🚀"
GEAR="⚙️"
INFO="ℹ️"

print_step() {
    echo -e "${BLUE}${GEAR} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_info() {
    echo -e "${YELLOW}${INFO} $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE} ${ROCKET} Setup Rapide Multi-Apps Platform${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Vérifier qu'on est dans la racine
if [ ! -f "package.json" ]; then
    print_error "Exécutez ce script depuis la racine du projet"
    exit 1
fi

# Créer la structure de base
print_step "Création de la structure du workspace..."
mkdir -p {apps,packages,scripts,logs,reports,coverage,test-results,data/sqlite,.cache,tmp}
touch data/sqlite/.gitkeep logs/.gitkeep reports/.gitkeep

# Créer package.json racine s'il n'existe pas
if [ ! -f "package.json" ]; then
    print_step "Création du package.json racine..."
    cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "1.0.0",
  "description": "Workspace multi-applications avec TypeScript et Playwright",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "concurrently \"npm run dev:postmath\" \"npm run dev:unitflip\" \"npm run dev:budgetcron\" \"npm run dev:ai4kids\" \"npm run dev:multiai\"",
    "dev:postmath": "cd apps/postmath && npm run dev",
    "dev:unitflip": "cd apps/unitflip && npm run dev",
    "dev:budgetcron": "cd apps/budgetcron && npm run dev",
    "dev:ai4kids": "cd apps/ai4kids && npm run dev",
    "dev:multiai": "cd apps/multiai && npm run dev",
    "build": "npm run build:packages && npm run build:apps",
    "build:packages": "npm run build -w packages/shared -w packages/ui",
    "build:apps": "npm run build -w apps/postmath -w apps/unitflip -w apps/budgetcron -w apps/ai4kids -w apps/multiai",
    "test": "npm run test:unit && npm run test:integration",
    "test:unit": "vitest run",
    "test:integration": "vitest run --config vitest.integration.config.ts",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:security": "./scripts/validate-security.sh",
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "type-check": "tsc --noEmit",
    "clean": "rm -rf node_modules/.cache packages/*/dist apps/*/dist apps/*/.next",
    "setup": "./scripts/dev-setup.sh"
  },
  "devDependencies": {
    "@playwright/test": "^1.45.0",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "concurrently": "^8.2.0",
    "eslint": "^8.57.0",
    "eslint-plugin-security": "^3.0.0",
    "typescript": "^5.4.0",
    "vitest": "^1.6.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
EOF
fi

# Créer .env de développement
if [ ! -f ".env" ]; then
    print_step "Création du fichier .env..."
    cat > .env << 'EOF'
# Configuration développement local
NODE_ENV=development

# Base de données SQLite
DATABASE_URL=file:./data/sqlite/dev.db

# Cache en mémoire
REDIS_URL=memory://localhost

# Sécurité
JWT_SECRET=dev-jwt-secret-$(date +%s)
ENCRYPTION_KEY=dev-encryption-key-$(date +%s)

# Ports des applications
POSTMATH_PORT=3001
UNITFLIP_PORT=3002
BUDGETCRON_PORT=3003
AI4KIDS_PORT=3004
MULTIAI_PORT=3005

# URLs des applications
POSTMATH_URL=http://localhost:3001
UNITFLIP_URL=http://localhost:3002
BUDGETCRON_URL=http://localhost:3003
AI4KIDS_URL=http://localhost:3004
MULTIAI_URL=http://localhost:3005

# Logs
LOG_LEVEL=info
LOG_DIR=./logs

# Features
ENABLE_METRICS=true
ENABLE_HEALTH_CHECKS=true

# Mode développement local
USE_SQLITE=true
USE_MEMORY_CACHE=true
SKIP_DOCKER=true
EOF
fi

# Créer tsconfig.json racine
if [ ! -f "tsconfig.json" ]; then
    print_step "Création du tsconfig.json..."
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@multiapps/shared": ["./packages/shared/src"],
      "@multiapps/ui": ["./packages/ui/src"]
    }
  },
  "include": [
    "**/*.ts",
    "**/*.tsx",
    "**/*.js",
    "**/*.jsx"
  ],
  "exclude": [
    "node_modules",
    "dist",
    ".next",
    "coverage",
    "test-results"
  ]
}
EOF
fi

# Créer .eslintrc.js
if [ ! -f ".eslintrc.js" ]; then
    print_step "Création de la configuration ESLint..."
    cat > .eslintrc.js << 'EOF'
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:security/recommended',
  ],
  plugins: [
    '@typescript-eslint',
    'security',
  ],
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
    'security/detect-object-injection': 'error',
    'security/detect-non-literal-regexp': 'error',
    'security/detect-unsafe-regex': 'error',
  },
  env: {
    node: true,
    browser: true,
    es2022: true,
  },
  ignorePatterns: [
    'node_modules/',
    'dist/',
    '.next/',
    'coverage/',
    'test-results/',
  ],
};
EOF
fi

# Créer configuration Playwright
if [ ! -f "playwright.config.ts" ]; then
    print_step "Création de la configuration Playwright..."
    cat > playwright.config.ts << 'EOF'
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
    ['html', { outputFolder: 'test-results/html-report' }],
    ['json', { outputFile: 'test-results/results.json' }],
  ],
  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
  outputDir: 'test-results/',
});
EOF
fi

# Créer .gitignore
if [ ! -f ".gitignore" ]; then
    print_step "Création du .gitignore..."
    cat > .gitignore << 'EOF'
# Dépendances
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build
dist/
build/
.next/
out/

# Environment
.env
.env.local
.env.production
.env.test

# Cache
.cache/
.npm/
.yarn/
.pnp/

# Logs
logs/
*.log

# Tests
coverage/
test-results/
playwright-report/
*.lcov

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Database
data/sqlite/*.db
data/sqlite/*.db-*

# Temporary
tmp/
temp/

# Docker
docker-compose.override.yml
EOF
fi

# Créer structure d'exemple pour une app
print_step "Création d'une application d'exemple (postmath)..."
mkdir -p apps/postmath/src
cat > apps/postmath/package.json << 'EOF'
{
  "name": "@multiapps/postmath",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest",
    "test:unit": "vitest run"
  },
  "dependencies": {
    "fastify": "^4.28.0"
  },
  "devDependencies": {
    "tsx": "^4.7.0",
    "typescript": "^5.4.0",
    "vitest": "^1.6.0"
  }
}
EOF

cat > apps/postmath/src/index.ts << 'EOF'
import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

fastify.get('/', async (request, reply) => {
  return { message: 'Postmath API is running!', timestamp: new Date().toISOString() };
});

fastify.get('/health', async (request, reply) => {
  return { status: 'healthy', service: 'postmath' };
});

const start = async () => {
  try {
    const port = parseInt(process.env.POSTMATH_PORT || '3001');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`🚀 Postmath server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
EOF

# Créer package partagé d'exemple
print_step "Création d'un package partagé d'exemple..."
mkdir -p packages/shared/src
cat > packages/shared/package.json << 'EOF'
{
  "name": "@multiapps/shared",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "test": "vitest"
  },
  "devDependencies": {
    "typescript": "^5.4.0",
    "vitest": "^1.6.0"
  }
}
EOF

cat > packages/shared/src/index.ts << 'EOF'
export const utils = {
  formatDate: (date: Date): string => {
    return date.toISOString().split('T')[0];
  },
  
  generateId: (): string => {
    return Math.random().toString(36).substr(2, 9);
  },
  
  delay: (ms: number): Promise<void> => {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
};

export type ApiResponse<T = any> = {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
};

export const createApiResponse = <T>(
  success: boolean,
  data?: T,
  error?: string
): ApiResponse<T> => ({
  success,
  data,
  error,
  timestamp: new Date().toISOString(),
});
EOF

cat > packages/shared/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules", "**/*.test.ts"]
}
EOF

# Créer exemple de test E2E
print_step "Création d'un test E2E d'exemple..."
mkdir -p tests/e2e
cat > tests/e2e/postmath.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Postmath Application', () => {
  test('should display welcome message', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que la page se charge
    await expect(page).toHaveTitle(/Postmath/i);
    
    // Vérifier la présence du message de bienvenue
    await expect(page.locator('text=Postmath API is running')).toBeVisible();
  });

  test('should have healthy status endpoint', async ({ request }) => {
    const response = await request.get('/health');
    expect(response.ok()).toBeTruthy();
    
    const data = await response.json();
    expect(data.status).toBe('healthy');
    expect(data.service).toBe('postmath');
  });
});
EOF

# Installation des dépendances
print_step "Installation des dépendances..."
if command -v npm >/dev/null; then
    npm install
    print_success "Dépendances installées"
else
    print_error "npm non trouvé. Installez Node.js : brew install node"
    exit 1
fi

# Installation de Playwright
print_step "Installation de Playwright..."
npx playwright install --with-deps

# Build des packages
print_step "Build des packages partagés..."
cd packages/shared && npm run build && cd ../..

print_success "Setup terminé !"
echo ""
echo -e "${BLUE}🚀 Workspace Multi-Apps Platform configuré !${NC}"
echo ""
echo -e "${YELLOW}Prochaines étapes :${NC}"
echo -e "  1. ${GREEN}npm run dev${NC} - Démarrer toutes les applications"
echo -e "  2. ${GREEN}npm run test:e2e${NC} - Lancer les tests E2E"
echo -e "  3. ${GREEN}npm run lint${NC} - Vérifier le code"
echo ""
echo -e "${YELLOW}URLs disponibles :${NC}"
echo -e "  • Postmath: ${GREEN}http://localhost:3001${NC}"
echo -e "  • Tests E2E: ${GREEN}npm run test:e2e:ui${NC}"
echo ""
echo -e "${BLUE}📁 Structure créée :${NC}"
echo -e "  ├── apps/postmath/ (exemple d'application)"
echo -e "  ├── packages/shared/ (utilitaires partagés)"
echo -e "  ├── tests/e2e/ (tests Playwright)"
echo -e "  └── Configuration complète TypeScript + ESLint"
echo ""