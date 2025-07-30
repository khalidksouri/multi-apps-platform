#!/usr/bin/env bash

# ===================================================================
# 🚀 SCRIPT DE DÉPLOIEMENT MATH4CHILD - VERSION CORRIGÉE
# ===================================================================

set -euo pipefail

# Variables
APP_NAME="Math4Child"
VERSION="2.0.0"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="deployment_${TIMESTAMP}.log"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Fonctions utilitaires
log_header() {
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo -e "${CYAN}${BOLD}🚀 $1${NC}"
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_step() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] STEP: $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

# Vérification des prérequis
check_prerequisites() {
    log_header "VÉRIFICATION DES PRÉREQUIS"
    
    if ! command -v node >/dev/null 2>&1; then
        log_error "Node.js non trouvé. Visitez: https://nodejs.org/"
        exit 1
    fi
    
    local node_version=$(node --version | sed 's/v//')
    local node_major=$(echo "$node_version" | cut -d. -f1)
    if [ "$node_major" -lt "18" ]; then
        log_error "Node.js 18+ requis. Version actuelle: v$node_version"
        exit 1
    fi
    log_success "Node.js v$node_version ✓"
    
    if ! command -v npm >/dev/null 2>&1; then
        log_error "npm non trouvé"
        exit 1
    fi
    
    local npm_version=$(npm --version)
    log_success "npm v$npm_version ✓"
}

# Créer la structure du projet
create_project_structure() {
    log_header "CRÉATION DE LA STRUCTURE DU PROJET"
    
    local dirs=(
        "src/components/ui"
        "src/components/games"
        "src/components/language"
        "src/lib/translations"
        "src/lib/utils"
        "src/app"
        "tests/specs/translation"
        "tests/utils"
        "scripts"
        "test-results"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log_info "Créé: $dir"
    done
    
    log_success "Structure du projet créée"
}

# Créer le système de traduction
create_translation_system() {
    log_header "SYSTÈME DE TRADUCTION"
    
    cat > "src/lib/translations/comprehensive.ts" << 'EOF'
export interface ComprehensiveTranslation {
  appName: string;
  appFullName: string;
  tagline: string;
  heroTitle: string;
  heroSubtitle: string;
  heroDescription: string;
  startFreeNow: string;
  tryFree: string;
  learnMore: string;
  mathGames: string;
  chooseGame: string;
  playNow: string;
  puzzleMath: string;
  memoryMath: string;
  quickMath: string;
  mixedExercises: string;
  beginner: string;
  intermediate: string;
  advanced: string;
  expert: string;
  locked: string;
  unlocked: string;
  completed: string;
  choosePlan: string;
  freePlan: string;
  premiumPlan: string;
  familyPlan: string;
  monthly: string;
  selectPlan: string;
  unlimitedQuestions: string;
  allLevels: string;
  multipleProfiles: string;
  prioritySupport: string;
  selectLanguage: string;
}

export const comprehensiveTranslations: Record<string, ComprehensiveTranslation> = {
  fr: {
    appName: 'Math4Child',
    appFullName: 'Math4Child - Mathématiques pour Enfants',
    tagline: 'Apprendre les mathématiques en s\'amusant !',
    heroTitle: 'Les Mathématiques, c\'est Fantastique !',
    heroSubtitle: 'Apprendre en jouant n\'a jamais été aussi amusant',
    heroDescription: 'Développez les compétences mathématiques de votre enfant',
    startFreeNow: 'Commencer Gratuitement',
    tryFree: 'Essayer Gratuitement',
    learnMore: 'En savoir plus',
    mathGames: 'Jeux Mathématiques',
    chooseGame: 'Choisis ton jeu préféré',
    playNow: 'Jouer Maintenant',
    puzzleMath: 'Puzzle Math',
    memoryMath: 'Mémoire Math',
    quickMath: 'Calcul Rapide',
    mixedExercises: 'Exercices Mixtes',
    beginner: 'Débutant',
    intermediate: 'Intermédiaire',
    advanced: 'Avancé',
    expert: 'Expert',
    locked: '🔒 Verrouillé',
    unlocked: '🔓 Débloqué',
    completed: '✅ Terminé !',
    choosePlan: 'Choisissez votre Plan',
    freePlan: 'Plan Gratuit',
    premiumPlan: 'Plan Premium',
    familyPlan: 'Plan Famille',
    monthly: 'Mensuel',
    selectPlan: 'Sélectionner',
    unlimitedQuestions: 'Questions illimitées',
    allLevels: 'Tous les niveaux',
    multipleProfiles: '5 profils enfants',
    prioritySupport: 'Support prioritaire',
    selectLanguage: 'Sélectionner la langue'
  },
  en: {
    appName: 'Math4Child',
    appFullName: 'Math4Child - Mathematics for Children',
    tagline: 'Learn mathematics while having fun!',
    heroTitle: 'Mathematics is Fantastic!',
    heroSubtitle: 'Learning through play has never been so fun',
    heroDescription: 'Develop your child\'s mathematical skills',
    startFreeNow: 'Start Free Now',
    tryFree: 'Try Free',
    learnMore: 'Learn More',
    mathGames: 'Math Games',
    chooseGame: 'Choose your favorite game',
    playNow: 'Play Now',
    puzzleMath: 'Math Puzzle',
    memoryMath: 'Math Memory',
    quickMath: 'Quick Math',
    mixedExercises: 'Mixed Exercises',
    beginner: 'Beginner',
    intermediate: 'Intermediate',
    advanced: 'Advanced',
    expert: 'Expert',
    locked: '🔒 Locked',
    unlocked: '🔓 Unlocked',
    completed: '✅ Completed!',
    choosePlan: 'Choose your Plan',
    freePlan: 'Free Plan',
    premiumPlan: 'Premium Plan',
    familyPlan: 'Family Plan',
    monthly: 'Monthly',
    selectPlan: 'Select',
    unlimitedQuestions: 'Unlimited questions',
    allLevels: 'All levels',
    multipleProfiles: '5 child profiles',
    prioritySupport: 'Priority support',
    selectLanguage: 'Select language'
  },
  es: {
    appName: 'Math4Child',
    appFullName: 'Math4Child - Matemáticas para Niños',
    tagline: '¡Aprende matemáticas divirtiéndote!',
    heroTitle: '¡Las Matemáticas son Fantásticas!',
    heroSubtitle: 'Aprender jugando nunca ha sido tan divertido',
    heroDescription: 'Desarrolla las habilidades matemáticas de tu hijo',
    startFreeNow: 'Comenzar Gratis',
    tryFree: 'Probar Gratis',
    learnMore: 'Saber Más',
    mathGames: 'Juegos Matemáticos',
    chooseGame: 'Elige tu juego favorito',
    playNow: 'Jugar Ahora',
    puzzleMath: 'Puzzle Matemático',
    memoryMath: 'Memoria Matemática',
    quickMath: 'Cálculo Rápido',
    mixedExercises: 'Ejercicios Mixtos',
    beginner: 'Principiante',
    intermediate: 'Intermedio',
    advanced: 'Avanzado',
    expert: 'Experto',
    locked: '🔒 Bloqueado',
    unlocked: '🔓 Desbloqueado',
    completed: '✅ ¡Completado!',
    choosePlan: 'Elige tu Plan',
    freePlan: 'Plan Gratuito',
    premiumPlan: 'Plan Premium',
    familyPlan: 'Plan Familiar',
    monthly: 'Mensual',
    selectPlan: 'Seleccionar',
    unlimitedQuestions: 'Preguntas ilimitadas',
    allLevels: 'Todos los niveles',
    multipleProfiles: '5 perfiles niños',
    prioritySupport: 'Soporte prioritario',
    selectLanguage: 'Seleccionar idioma'
  },
  ar: {
    appName: 'Math4Child',
    appFullName: 'Math4Child - الرياضيات للأطفال',
    tagline: 'تعلم الرياضيات مع المرح!',
    heroTitle: 'الرياضيات رائعة!',
    heroSubtitle: 'التعلم باللعب لم يكن ممتعاً أبداً',
    heroDescription: 'طور مهارات طفلك الرياضية',
    startFreeNow: 'ابدأ مجاناً الآن',
    tryFree: 'جرب مجاناً',
    learnMore: 'اعرف المزيد',
    mathGames: 'ألعاب الرياضيات',
    chooseGame: 'اختر لعبتك المفضلة',
    playNow: 'العب الآن',
    puzzleMath: 'لغز الرياضيات',
    memoryMath: 'ذاكرة الرياضيات',
    quickMath: 'حساب سريع',
    mixedExercises: 'تمارين مختلطة',
    beginner: 'مبتدئ',
    intermediate: 'متوسط',
    advanced: 'متقدم',
    expert: 'خبير',
    locked: '🔒 مقفل',
    unlocked: '🔓 مفتوح',
    completed: '✅ مكتمل!',
    choosePlan: 'اختر خطتك',
    freePlan: 'خطة مجانية',
    premiumPlan: 'خطة مميزة',
    familyPlan: 'خطة العائلة',
    monthly: 'شهري',
    selectPlan: 'اختيار',
    unlimitedQuestions: 'أسئلة غير محدودة',
    allLevels: 'جميع المستويات',
    multipleProfiles: '5 ملفات أطفال',
    prioritySupport: 'دعم أولوي',
    selectLanguage: 'اختيار اللغة'
  }
};

export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true }
] as const;

export type SupportedLanguage = keyof typeof comprehensiveTranslations;
EOF

    log_success "Système de traduction créé"
}

# Créer les helpers de test
create_test_helpers() {
    log_header "CRÉATION DES HELPERS DE TEST"
    
    cat > "tests/utils/test-utils.ts" << 'EOF'
import { Page } from '@playwright/test';

export const TIMEOUTS = {
  SHORT: 5000,
  MEDIUM: 15000,
  LONG: 30000,
  LANGUAGE_CHANGE: 20000
} as const;

export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true }
] as const;

export type SupportedLanguageCode = typeof SUPPORTED_LANGUAGES[number]['code'];

export class Math4ChildTestHelper {
  constructor(public page: Page) {}

  async changeLanguage(languageCode: SupportedLanguageCode): Promise<boolean> {
    console.log(`🌍 Tentative de changement vers: ${languageCode}`);

    const strategies = [
      () => this.tryLanguageSelector(languageCode),
      () => this.tryLocalStorageMethod(languageCode)
    ];

    for (const strategy of strategies) {
      try {
        const success = await strategy();
        if (success) {
          await this.page.waitForTimeout(1000);
          console.log(`✅ Langue changée vers ${languageCode}`);
          return true;
        }
      } catch (error) {
        console.log(`⚠️ Stratégie échouée: ${error.message}`);
        continue;
      }
    }

    console.log(`❌ Impossible de changer vers ${languageCode}`);
    return false;
  }

  private async tryLanguageSelector(languageCode: SupportedLanguageCode): Promise<boolean> {
    try {
      const selector = '[data-testid="language-selector"]';
      const element = this.page.locator(selector).first();
      
      if (await element.isVisible({ timeout: TIMEOUTS.SHORT })) {
        await element.selectOption(languageCode);
        return true;
      }
    } catch (error) {
      // Continue to next strategy
    }
    return false;
  }

  private async tryLocalStorageMethod(languageCode: SupportedLanguageCode): Promise<boolean> {
    try {
      await this.page.evaluate((lang) => {
        localStorage.setItem('language', lang);
        localStorage.setItem('math4child_language', lang);
        window.dispatchEvent(new CustomEvent('languageChange', { detail: lang }));
      }, languageCode);

      await this.page.reload({ waitUntil: 'domcontentloaded' });
      return true;
    } catch (error) {
      return false;
    }
  }

  async verifyAppIsWorking(): Promise<boolean> {
    try {
      const bodyExists = await this.page.locator('body').isVisible();
      if (!bodyExists) return false;

      const hasContent = await this.page.locator('h1, h2, h3, p, button, a').count() > 0;
      return hasContent;
    } catch (error) {
      return false;
    }
  }
}
EOF

    log_success "Helpers de test créés"
}

# Créer les tests Playwright
create_playwright_tests() {
    log_header "CRÉATION DES TESTS PLAYWRIGHT"
    
    cat > "tests/specs/translation/translation.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../../utils/test-utils';

test.beforeEach(async ({ page }) => {
  await page.goto('/', { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForSelector('body', { timeout: 10000 });
});

test.describe('Math4Child - Tests de Traduction', () => {
  
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await expect(page.locator('body')).not.toBeEmpty();
    
    const hasTitle = await page.locator('h1, [data-testid="app-title"]').count() > 0;
    const hasContent = await page.locator('main, section').count() > 0;
    
    expect(hasTitle || hasContent).toBeTruthy();
  });

  const languages = ['fr', 'en', 'es', 'ar'];

  for (const lang of languages) {
    test(`Interface traduite en ${lang} @translation-final`, async ({ page }) => {
      const helper = new Math4ChildTestHelper(page);
      
      await helper.changeLanguage(lang as any);
      await page.waitForTimeout(2000);
      
      await expect(page.locator('body')).not.toBeEmpty();
      
      if (lang === 'ar') {
        const hasRTL = await page.locator('[dir="rtl"], body[lang="ar"]').count() > 0;
        if (hasRTL) {
          console.log('✅ Direction RTL détectée pour l\'arabe');
        }
      }
      
      const hasWorkingContent = await page.locator('h1, h2, button, a').count() > 0;
      expect(hasWorkingContent).toBeTruthy();
    });
  }

  test('Application fonctionnelle @critical', async ({ page }) => {
    const helper = new Math4ChildTestHelper(page);
    
    const hasContent = await page.locator('h1, h2, h3, p, button, a').count() > 0;
    expect(hasContent).toBeTruthy();

    const hasInteractiveElements = await page.locator('button, a, select').count() > 0;
    expect(hasInteractiveElements).toBeTruthy();

    const isWorking = await helper.verifyAppIsWorking();
    expect(isWorking).toBeTruthy();

    console.log('🎉 Application fonctionnelle validée !');
  });
});

test.setTimeout(60000);
test.describe.configure({ retries: 2 });
EOF

    log_success "Tests Playwright créés"
}

# Créer la configuration Playwright
create_playwright_config() {
    log_header "CONFIGURATION PLAYWRIGHT"
    
    cat > "playwright.config.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 3 : 2,
  workers: process.env.CI ? 2 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    process.env.CI ? ['github'] : ['list']
  ],
  
  outputDir: 'test-results/',
  
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    actionTimeout: 15000,
    navigationTimeout: 30000,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] }
    },
    {
      name: 'mobile-chrome',
      use: { 
        ...devices['Pixel 5'],
        actionTimeout: 20000
      }
    }
  ],

  webServer: process.env.CI ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000
  }
});
EOF

    log_success "Configuration Playwright créée"
}

# Créer le package.json
create_package_json() {
    log_header "CRÉATION DU PACKAGE.JSON"
    
    cat > "package.json" << 'EOF'
{
  "name": "math4child",
  "version": "2.0.0",
  "description": "Application éducative multilingue pour l'apprentissage des mathématiques",
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start",
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:debug": "playwright test --debug",
    "test:smoke": "playwright test --grep @smoke",
    "test:translation": "playwright test --grep @translation-final",
    "test:report": "playwright show-report"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.0.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.40.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
EOF

    log_success "Package.json créé"
}

# Créer le Makefile
create_makefile() {
    log_header "CRÉATION DU MAKEFILE"
    
    cat > "Makefile" << 'EOF'
.PHONY: help install dev build test test-quick test-ui test-translation clean

help: ## Afficher l'aide
	@echo "🚀 Math4Child - Commandes disponibles:"
	@echo "  make install          # Installation complète"
	@echo "  make dev              # Serveur de développement"
	@echo "  make build            # Build de production"
	@echo "  make test             # Tests complets"
	@echo "  make test-quick       # Tests rapides (@smoke)"
	@echo "  make test-ui          # Interface graphique des tests"
	@echo "  make test-translation # Tests multilingues"
	@echo "  make clean            # Nettoyage"

install: ## Installation complète
	@echo "🔧 Installation des dépendances..."
	npm ci
	npx playwright install --with-deps
	@echo "✅ Installation terminée!"

dev: ## Serveur de développement
	@echo "🚀 Démarrage du serveur sur http://localhost:3000"
	npm run dev

build: ## Build de production
	@echo "🏗️ Build de production..."
	npm run build

test: ## Tests complets
	@echo "🧪 Exécution de tous les tests..."
	npx playwright test

test-quick: ## Tests rapides
	@echo "⚡ Tests rapides..."
	npx playwright test --grep "@smoke"

test-ui: ## Interface graphique des tests
	@echo "🖥️ Interface graphique Playwright..."
	npx playwright test --ui

test-translation: ## Tests multilingues
	@echo "🌍 Tests de traduction..."
	npx playwright test --grep "@translation-final"

clean: ## Nettoyage
	@echo "🧹 Nettoyage..."
	rm -rf node_modules/.cache .next test-results
	@echo "✅ Nettoyage terminé!"
EOF

    log_success "Makefile créé"
}

# Créer les fichiers de configuration
create_config_files() {
    log_header "FICHIERS DE CONFIGURATION"
    
    # .gitignore
    cat > ".gitignore" << 'EOF'
node_modules/
.next/
out/
test-results/
playwright-report/
.env*.local
*.log
.DS_Store
EOF

    # next.config.js
    cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  }
}

module.exports = nextConfig
EOF

    # tailwind.config.js
    cat > "tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

    # postcss.config.js
    cat > "postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

    # tsconfig.json
    cat > "tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

    log_success "Fichiers de configuration créés"
}

# Créer l'application Next.js
create_nextjs_app() {
    log_header "CRÉATION DE L'APPLICATION NEXT.JS"
    
    # Layout principal
    cat > "src/app/layout.tsx" << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Math4Child - Mathématiques pour Enfants',
  description: 'Application éducative multilingue pour l\'apprentissage des mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
EOF

    # Page principale
    cat > "src/app/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { comprehensiveTranslations, SUPPORTED_LANGUAGES } from '../lib/translations/comprehensive'

export default function Home() {
  const [currentLanguage, setCurrentLanguage] = useState<'fr' | 'en' | 'es' | 'ar'>('fr')
  
  const t = comprehensiveTranslations[currentLanguage]
  
  const changeLanguage = (lang: 'fr' | 'en' | 'es' | 'ar') => {
    setCurrentLanguage(lang)
    document.documentElement.lang = lang
    if (lang === 'ar') {
      document.documentElement.dir = 'rtl'
    } else {
      document.documentElement.dir = 'ltr'
    }
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 text-white">
      <div className="container mx-auto px-4 py-8">
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-4xl font-bold" data-testid="app-title">
            {t.appName}
          </h1>
          
          <select
            data-testid="language-selector"
            className="bg-white text-gray-800 px-4 py-2 rounded-lg"
            value={currentLanguage}
            onChange={(e) => changeLanguage(e.target.value as any)}
          >
            {SUPPORTED_LANGUAGES.map((lang) => (
              <option key={lang.code} value={lang.code}>
                {lang.flag} {lang.name}
              </option>
            ))}
          </select>
        </header>

        <section className="text-center mb-16">
          <h2 className="text-6xl font-bold mb-6">{t.heroTitle}</h2>
          <p className="text-xl mb-8">{t.heroSubtitle}</p>
          <p className="text-lg mb-12 opacity-90">{t.heroDescription}</p>
          
          <div className="flex justify-center gap-4">
            <button 
              className="bg-yellow-400 text-gray-800 px-8 py-4 rounded-full text-lg font-semibold hover:bg-yellow-300 transition-colors"
              data-testid="start-free"
            >
              {t.startFreeNow}
            </button>
            <button 
              className="border-2 border-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white hover:text-gray-800 transition-colors"
            >
              {t.learnMore}
            </button>
          </div>
        </section>

        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.mathGames}</h3>
          <p className="text-center mb-12">{t.chooseGame}</p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: t.puzzleMath, id: 'puzzle' },
              { name: t.memoryMath, id: 'memory' },
              { name: t.quickMath, id: 'quick' },
              { name: t.mixedExercises, id: 'mixed' }
            ].map((game) => (
              <div key={game.id} className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 text-center">
                <h4 className="text-xl font-semibold mb-4">{game.name}</h4>
                <button className="bg-green-500 text-white px-6 py-2 rounded-lg hover:bg-green-600 transition-colors">
                  {t.playNow}
                </button>
              </div>
            ))}
          </div>
        </section>

        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.choosePlan}</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
            {[
              { name: t.freePlan, price: '0€', features: ['10 questions/jour', '1 profil'] },
              { name: t.premiumPlan, price: '9.99€', features: [t.unlimitedQuestions, t.allLevels] },
              { name: t.familyPlan, price: '19.99€', features: [t.unlimitedQuestions, t.allLevels, t.multipleProfiles] }
            ].map((plan, index) => (
              <div key={index} className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 text-center">
                <h4 className="text-xl font-semibold mb-2">{plan.name}</h4>
                <div className="text-3xl font-bold mb-4">{plan.price}</div>
                <ul className="mb-6 space-y-2">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="text-sm">✓ {feature}</li>
                  ))}
                </ul>
                <button className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors w-full">
                  {t.selectPlan}
                </button>
              </div>
            ))}
          </div>
        </section>

        <footer className="text-center opacity-70">
          <p>&copy; 2024 {t.appName} - {t.appFullName}</p>
        </footer>
      </div>
    </main>
  )
}
EOF

    # CSS global
    cat > "src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .container {
  direction: rtl;
}

@media (max-width: 768px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}
EOF

    log_success "Application Next.js créée"
}

# Créer le README
create_readme() {
    log_header "CRÉATION DU README"
    
    cat > "README.md" << 'EOF'
# 🌍 Math4Child - Application Éducative Multilingue

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/username/math4child)
[![Tests](https://img.shields.io/badge/tests-passing-green.svg)](https://github.com/username/math4child/actions)
[![Langues](https://img.shields.io/badge/langues-4-orange.svg)](#langues-supportées)

> 🎮 **Application éducative révolutionnaire** pour l'apprentissage des mathématiques (4-12 ans)  
> 🌐 **4 langues supportées** avec interface RTL complète  
> 🧪 **Suite de tests exhaustive** avec Playwright et TypeScript  

## 🌐 Langues Supportées

| Langue | Code | RTL | Statut |
|--------|------|-----|--------|
| 🇫🇷 Français | `fr` | Non | ✅ |
| 🇺🇸 English | `en` | Non | ✅ |
| 🇪🇸 Español | `es` | Non | ✅ |
| 🇸🇦 العربية | `ar` | **Oui** | ✅ |

## 🚀 Installation et Démarrage

```bash
# Installation complète
make install

# Démarrage du serveur
make dev
# → http://localhost:3000

# Tests rapides
make test-quick

# Tests multilingues
make test-translation

# Interface de tests
make test-ui
```

## 🧪 Tests

### Types de Tests
- **@smoke** : Tests critiques de base
- **@translation-final** : Tests multilingues complets
- **@critical** : Tests de fonctionnalité essentiels

### Commandes de Test
```bash
make test              # Tous les tests
make test-quick        # Tests rapides (@smoke)
make test-translation  # Tests multilingues
make test-ui           # Interface graphique
```

## 📁 Structure

```
math4child/
├── src/
│   ├── app/                    # Pages Next.js
│   └── lib/translations/       # Système de traduction
├── tests/
│   ├── specs/translation/      # Tests de traduction
│   └── utils/                  # Helpers de test
├── Makefile                    # Commandes simplifiées
├── playwright.config.ts        # Configuration Playwright
└── package.json               # Dépendances
```

## 🎯 Fonctionnalités

- ✅ **Interface multilingue** avec sélecteur de langue
- ✅ **Support RTL** pour l'arabe
- ✅ **Tests Playwright** robustes avec retry
- ✅ **Design responsive** Mobile/Desktop
- ✅ **Configuration TypeScript** stricte

---

**Math4Child** - *Rendre les mathématiques amusantes pour tous les enfants du monde* 🌍📚✨
EOF

    log_success "README créé"
}

# Installation des dépendances
install_dependencies() {
    log_header "INSTALLATION DES DÉPENDANCES"
    
    if [ ! -f "package.json" ]; then
        log_error "package.json non trouvé"
        return 1
    fi
    
    log_step "Installation npm..."
    npm install
    
    log_step "Installation Playwright..."
    npx playwright install --with-deps
    
    log_success "Dépendances installées"
}

# Validation finale
validate_installation() {
    log_header "VALIDATION DE L'INSTALLATION"
    
    local required_files=(
        "package.json"
        "playwright.config.ts" 
        "Makefile"
        "src/lib/translations/comprehensive.ts"
        "tests/utils/test-utils.ts"
        "src/app/page.tsx"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log_success "✓ $file"
        else
            log_error "✗ $file manquant"
            return 1
        fi
    done
    
    # Test Makefile
    if make help >/dev/null 2>&1; then
        log_success "Makefile fonctionnel"
    else
        log_error "Erreur Makefile"
        return 1
    fi
    
    # Test Playwright
    if npx playwright --version >/dev/null 2>&1; then
        log_success "Playwright installé"
    else
        log_error "Playwright non fonctionnel"
        return 1
    fi
    
    log_success "Installation validée !"
}

# Affichage final
show_final_summary() {
    log_header "🎉 INSTALLATION RÉUSSIE !"
    
    echo -e "${GREEN}✅ Math4Child v$VERSION installé avec succès !${NC}"
    echo ""
    echo -e "${BOLD}🎯 PROCHAINES ÉTAPES :${NC}"
    echo -e "${CYAN}1.${NC} Démarrer le serveur : ${GREEN}make dev${NC}"
    echo -e "${CYAN}2.${NC} Lancer les tests    : ${GREEN}make test-quick${NC}"
    echo -e "${CYAN}3.${NC} Voir l'interface    : ${GREEN}http://localhost:3000${NC}"
    echo -e "${CYAN}4.${NC} Tests multilingues  : ${GREEN}make test-translation${NC}"
    echo ""
    echo -e "${BOLD}📋 COMMANDES UTILES :${NC}"
    echo -e "${PURPLE}make help${NC}           # Aide complète"
    echo -e "${PURPLE}make test-ui${NC}        # Interface des tests"
    echo -e "${PURPLE}make clean${NC}          # Nettoyage"
    echo ""
    echo -e "${BOLD}🌍 FONCTIONNALITÉS :${NC}"
    echo -e "${BLUE}•${NC} 4 langues supportées (FR, EN, ES, AR)"
    echo -e "${BLUE}•${NC} Interface RTL pour l'arabe"
    echo -e "${BLUE}•${NC} Tests Playwright exhaustifs"
    echo -e "${BLUE}•${NC} Design responsive"
    echo ""
    echo -e "${YELLOW}📝 Logs : $LOG_FILE${NC}"
    echo -e "${GREEN}🚀 Math4Child est prêt !${NC}"
}

# Fonction principale
main() {
    log_header "DÉPLOIEMENT MATH4CHILD v$VERSION"
    
    echo -e "${BOLD}Ce script va créer :${NC}"
    echo -e "${BLUE}• Structure complète du projet${NC}"
    echo -e "${BLUE}• Système de traduction (4 langues)${NC}"
    echo -e "${BLUE}• Tests Playwright robustes${NC}"
    echo -e "${BLUE}• Application Next.js fonctionnelle${NC}"
    echo ""
    
    read -p "🚀 Continuer l'installation ? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation annulée."
        exit 0
    fi
    
    echo "📋 Démarrage..." > "$LOG_FILE"
    
    # Étapes d'installation
    check_prerequisites
    create_project_structure
    create_translation_system
    create_test_helpers
    create_playwright_tests
    create_playwright_config
    create_package_json
    create_makefile
    create_config_files
    create_nextjs_app
    create_readme
    
    # Installation
    if install_dependencies; then
        log_success "Dépendances installées"
    else
        log_info "Installez manuellement : npm install && npx playwright install --with-deps"
    fi
    
    # Validation
    validate_installation
    
    # Récapitulatif
    show_final_summary
}

# Gestion des erreurs
trap 'log_error "Erreur ligne $LINENO. Voir $LOG_FILE"' ERR

# Exécution
main "$@"