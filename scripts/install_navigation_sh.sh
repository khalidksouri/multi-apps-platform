#!/bin/bash

# Sauvegarder le script d'installation dans votre répertoire
cat > install-navigation.sh << 'SCRIPT_END'
#!/bin/bash

#===============================================================================
# MATH4CHILD - INSTALLATEUR NAVIGATION COMPLET
# Script principal pour installer le système de navigation unifié
#===============================================================================

set -euo pipefail

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${CYAN}[${timestamp}] ℹ️  ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ${message}${NC}" ;;
        "STEP") echo -e "${PURPLE}[${timestamp}] 🚀 ${message}${NC}" ;;
    esac
}

show_main_banner() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║               🧭 MATH4CHILD - NAVIGATION UNIFIÉE INSTALLER                  ║
║                                                                              ║
║               Installation complète du système de navigation                ║
║               avec support multilingue et tests automatisés                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

check_prerequisites() {
    log_message "STEP" "Vérification des prérequis..."
    
    if ! command -v node &> /dev/null; then
        log_message "ERROR" "Node.js n'est pas installé"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        log_message "ERROR" "npm n'est pas installé"
        exit 1
    fi
    
    log_message "SUCCESS" "Node.js $(node --version) et npm $(npm --version) détectés"
}

find_math4child_directory() {
    log_message "STEP" "Recherche du répertoire Math4Child..."
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        log_message "SUCCESS" "Trouvé: apps/math4child"
    elif [ -f "package.json" ] && grep -q "math4child" package.json; then
        log_message "SUCCESS" "Déjà dans le répertoire Math4Child"
    else
        log_message "ERROR" "Répertoire Math4Child non trouvé"
        exit 1
    fi
}

create_navigation_files() {
    log_message "STEP" "Création des fichiers de navigation..."
    
    # Créer la structure
    mkdir -p src/components/navigation
    mkdir -p src/contexts
    mkdir -p tests
    
    # Installer Playwright si nécessaire
    if ! npm list @playwright/test >/dev/null 2>&1; then
        log_message "INFO" "Installation de Playwright..."
        npm install -D @playwright/test
        npx playwright install --with-deps
    fi
    
    # Composant Navigation principal
    cat > src/components/navigation/Navigation.tsx << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'

interface NavigationProps {
  currentLanguage?: string
  onLanguageChange?: (language: string) => void
}

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'ar', name: 'العربية', flag: '🇲🇦' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' }
]

const NAVIGATION_TRANSLATIONS = {
  fr: {
    home: 'Accueil', exercises: 'Exercices', subscription: 'Abonnement', dashboard: 'Tableau de bord',
    appTitle: 'Math4Child', appSubtitle: 'Apprendre en s\'amusant', badge: '100k+ familles', languages: 'Langues'
  },
  en: {
    home: 'Home', exercises: 'Exercises', subscription: 'Subscription', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Learn while having fun', badge: '100k+ families', languages: 'Languages'
  },
  es: {
    home: 'Inicio', exercises: 'Ejercicios', subscription: 'Suscripción', dashboard: 'Panel',
    appTitle: 'Math4Child', appSubtitle: 'Aprender divirtiéndose', badge: '100k+ familias', languages: 'Idiomas'
  },
  ar: {
    home: 'الرئيسية', exercises: 'التمارين', subscription: 'الاشتراك', dashboard: 'لوحة التحكم',
    appTitle: 'Math4Child', appSubtitle: 'التعلم مع المتعة', badge: '100k+ عائلة', languages: 'اللغات'
  },
  de: {
    home: 'Startseite', exercises: 'Übungen', subscription: 'Abonnement', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Lernen mit Spaß', badge: '100k+ Familien', languages: 'Sprachen'
  },
  it: {
    home: 'Home', exercises: 'Esercizi', subscription: 'Abbonamento', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Imparare divertendosi', badge: '100k+ famiglie', languages: 'Lingue'
  }
}

export default function Navigation({ currentLanguage = 'fr', onLanguageChange }: NavigationProps) {
  const pathname = usePathname()
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false)
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const t = (key: string) => {
    return NAVIGATION_TRANSLATIONS[currentLanguage as keyof typeof NAVIGATION_TRANSLATIONS]?.[key as keyof typeof NAVIGATION_TRANSLATIONS['fr']] || 
           NAVIGATION_TRANSLATIONS['fr'][key as keyof typeof NAVIGATION_TRANSLATIONS['fr']] || key
  }

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]
  const isRTL = currentLanguage === 'ar'

  const navigationItems = [
    { href: '/', label: t('home'), icon: '🏠' },
    { href: '/exercises', label: t('exercises'), icon: '🧮' },
    { href: '/subscription', label: t('subscription'), icon: '💎' },
    { href: '/dashboard', label: t('dashboard'), icon: '📊' }
  ]

  const isActiveRoute = (href: string) => {
    if (href === '/') return pathname === '/'
    return pathname.startsWith(href)
  }

  if (!mounted) return null

  return (
    <header className="bg-white/95 backdrop-blur-sm shadow-lg border-b border-gray-200 sticky top-0 z-50" dir={isRTL ? 'rtl' : 'ltr'}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <Link href="/" className="flex items-center space-x-4 hover:opacity-80 transition-opacity">
            <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-105 transition-transform">
              <span className="text-white text-xl font-bold">M4C</span>
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">{t('appTitle')}</h1>
              <div className="flex items-center space-x-2">
                <span className="bg-orange-100 text-orange-800 text-xs px-2 py-1 rounded-full font-medium">{t('badge')}</span>
                <span className="text-green-600 text-sm font-medium hidden sm:inline">{t('appSubtitle')}</span>
              </div>
            </div>
          </Link>

          <nav className="hidden md:flex items-center space-x-6">
            {navigationItems.map((item) => (
              <Link key={item.href} href={item.href} className={`flex items-center space-x-2 px-3 py-2 rounded-lg font-medium transition-all duration-200 ${
                isActiveRoute(item.href) ? 'bg-blue-100 text-blue-700 shadow-sm' : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'
              }`}>
                <span className="text-lg">{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            ))}
          </nav>

          <div className="flex items-center space-x-4">
            <div className="relative">
              <button onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)} className="flex items-center space-x-2 bg-gray-50 hover:bg-gray-100 px-3 py-2 rounded-lg border border-gray-200 transition-colors">
                <span className="text-lg">{currentLang.flag}</span>
                <span className="text-sm font-medium text-gray-700 hidden sm:inline">{currentLang.name}</span>
                <svg className="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {isLanguageDropdownOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                  <div className="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b border-gray-100">{t('languages')}</div>
                  {LANGUAGES.map((language) => (
                    <button key={language.code} onClick={() => { onLanguageChange?.(language.code); setIsLanguageDropdownOpen(false) }} className={`w-full flex items-center space-x-3 px-3 py-2 text-left hover:bg-gray-50 transition-colors ${currentLanguage === language.code ? 'bg-blue-50 text-blue-700' : 'text-gray-700'}`}>
                      <span className="text-lg">{language.flag}</span>
                      <span className="font-medium">{language.name}</span>
                      {currentLanguage === language.code && <span className="ml-auto text-blue-500">✓</span>}
                    </button>
                  ))}
                </div>
              )}
            </div>

            <button onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)} className="md:hidden flex items-center justify-center w-10 h-10 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors" aria-label="Menu mobile">
              <svg className="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                {isMobileMenuOpen ? (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>
          </div>
        </div>

        {isMobileMenuOpen && (
          <div className="md:hidden border-t border-gray-200 py-4">
            <nav className="space-y-2">
              {navigationItems.map((item) => (
                <Link key={item.href} href={item.href} onClick={() => setIsMobileMenuOpen(false)} className={`flex items-center space-x-3 px-3 py-3 rounded-lg font-medium transition-all duration-200 ${
                  isActiveRoute(item.href) ? 'bg-blue-100 text-blue-700 shadow-sm' : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'
                }`}>
                  <span className="text-xl">{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </nav>
          </div>
        )}
      </div>

      {(isLanguageDropdownOpen || isMobileMenuOpen) && (
        <div className="fixed inset-0 z-40" onClick={() => { setIsLanguageDropdownOpen(false); setIsMobileMenuOpen(false) }} />
      )}
    </header>
  )
}
EOF

    # Contexte de langue
    cat > src/contexts/LanguageContext.tsx << 'EOF'
'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (language: string) => void
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage) setCurrentLanguage(savedLanguage)
  }, [])

  const setLanguage = (language: string) => {
    setCurrentLanguage(language)
    if (mounted) localStorage.setItem('math4child-language', language)
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, isRTL: currentLanguage === 'ar' }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) throw new Error('useLanguage must be used within a LanguageProvider')
  return context
}
EOF

    log_message "SUCCESS" "Fichiers de navigation créés"
}

update_layout() {
    log_message "STEP" "Mise à jour du layout..."
    
    # Sauvegarder l'ancien layout
    if [ -f "src/app/layout.tsx" ]; then
        cp src/app/layout.tsx src/app/layout.tsx.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    cat > src/app/layout.tsx << 'EOF'
'use client'

import { ReactNode } from 'react'
import { LanguageProvider } from '@/contexts/LanguageContext'
import Navigation from '@/components/navigation/Navigation'
import { useLanguage } from '@/contexts/LanguageContext'
import './globals.css'

function LayoutContent({ children }: { children: ReactNode }) {
  const { currentLanguage, setLanguage } = useLanguage()

  return (
    <html lang={currentLanguage}>
      <head>
        <title>Math4Child - Application Éducative</title>
        <meta name="description" content="Application révolutionnaire pour l'apprentissage des mathématiques" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>
        <Navigation currentLanguage={currentLanguage} onLanguageChange={setLanguage} />
        <main className="min-h-[calc(100vh-80px)]">{children}</main>
        <footer className="bg-gray-900 text-white py-8">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div className="flex items-center justify-center space-x-2 mb-4">
              <div className="w-8 h-8 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-sm font-bold">M4C</span>
              </div>
              <span className="text-xl font-bold">Math4Child</span>
            </div>
            <p className="text-gray-400 mb-4">Application éducative révolutionnaire pour l'apprentissage des mathématiques</p>
            <div className="flex items-center justify-center space-x-6 text-sm text-gray-400">
              <span>© 2024 Math4Child</span><span>•</span><span>100k+ familles font confiance</span><span>•</span><span>Support multilingue</span>
            </div>
          </div>
        </footer>
      </body>
    </html>
  )
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <LanguageProvider>
      <LayoutContent>{children}</LayoutContent>
    </LanguageProvider>
  )
}
EOF

    # Mettre à jour tsconfig.json pour le path alias
    if [ -f "tsconfig.json" ]; then
        if ! grep -q '"@/\*"' tsconfig.json; then
            cp tsconfig.json tsconfig.json.backup
            node -e "
                const fs = require('fs');
                const tsconfig = JSON.parse(fs.readFileSync('tsconfig.json', 'utf8'));
                tsconfig.compilerOptions = tsconfig.compilerOptions || {};
                tsconfig.compilerOptions.baseUrl = '.';
                tsconfig.compilerOptions.paths = tsconfig.compilerOptions.paths || {};
                tsconfig.compilerOptions.paths['@/*'] = ['./src/*'];
                fs.writeFileSync('tsconfig.json', JSON.stringify(tsconfig, null, 2));
            "
        fi
    fi
    
    log_message "SUCCESS" "Layout mis à jour"
}

create_tests() {
    log_message "STEP" "Création des tests..."
    
    cat > tests/navigation.spec.ts << 'EOF'
import { test, expect } from '@playwright/test'

test.describe('Math4Child Navigation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000')
  })

  test('should display navigation header', async ({ page }) => {
    await expect(page.locator('div:has-text("M4C")')).toBeVisible()
    await expect(page.locator('h1:has-text("Math4Child")')).toBeVisible()
  })

  test('should navigate between pages', async ({ page }) => {
    await page.click('text=Exercices')
    await expect(page).toHaveURL(/exercises/)
    
    await page.click('h1:has-text("Math4Child")')
    await expect(page).toHaveURL('http://localhost:3000/')
  })

  test('should change language', async ({ page }) => {
    await page.click('button:has(text("🇫🇷"))')
    await page.click('text=English')
    await expect(page.locator('text=Exercises')).toBeVisible()
  })
})
EOF

    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  retries: 0,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
EOF

    cat > test-navigation.sh << 'EOF'
#!/bin/bash
set -e

echo "🧪 Test Navigation Math4Child"
echo "============================="

if ! curl -s http://localhost:3000 > /dev/null; then
    echo "❌ Serveur non démarré. Lancez 'npm run dev' d'abord."
    exit 1
fi

echo "✅ Serveur détecté"
npx playwright test tests/navigation.spec.ts --project=chromium
echo "🎉 Tests terminés !"
EOF

    chmod +x test-navigation.sh

    # Mettre à jour package.json
    if [ -f "package.json" ]; then
        node -e "
            const fs = require('fs');
            const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
            pkg.scripts = pkg.scripts || {};
            pkg.scripts['test:navigation'] = 'playwright test tests/navigation.spec.ts';
            pkg.scripts['test:navigation:ui'] = 'playwright test tests/navigation.spec.ts --ui';
            fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
        "
    fi
    
    log_message "SUCCESS" "Tests créés"
}

show_final_report() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                        🎉 INSTALLATION RÉUSSIE !                             ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}🧭 NAVIGATION INSTALLÉE :${NC}"
    echo "   ✅ Composant Navigation responsive"
    echo "   ✅ Support 6 langues (FR, EN, ES, AR, DE, IT)" 
    echo "   ✅ Support RTL pour l'arabe"
    echo "   ✅ Menu mobile avec animations"
    echo "   ✅ Persistance des préférences"
    echo "   ✅ Tests automatisés Playwright"
    echo ""
    echo -e "${YELLOW}🚀 PROCHAINES ÉTAPES :${NC}"
    echo "   1. npm run dev                    # Démarrer le serveur"
    echo "   2. ./test-navigation.sh           # Tester la navigation"
    echo "   3. http://localhost:3000          # Voir le résultat"
    echo ""
    echo -e "${CYAN}🧪 TESTS DISPONIBLES :${NC}"
    echo "   • npm run test:navigation         # Tests automatisés"
    echo "   • npm run test:navigation:ui      # Interface de test"
    echo ""
    echo -e "${GREEN}✨ Votre navigation Math4Child est prête !${NC}"
}

main() {
    show_main_banner
    
    echo -e "${BLUE}🎯 FONCTIONNALITÉS QUI SERONT INSTALLÉES :${NC}"
    echo "   🧭 Navigation responsive (desktop + mobile)"
    echo "   🌍 Support multilingue (6 langues)"
    echo "   🔄 Support RTL pour l'arabe"
    echo "   📱 Menu mobile avec animations"
    echo "   🎯 Indicateur de page active"
    echo "   💾 Sauvegarde des préférences"
    echo "   ♿ Accessibilité complète"
    echo "   🧪 Tests Playwright automatisés"
    echo ""
    
    echo -e "${YELLOW}Voulez-vous continuer l'installation ? (y/N)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Installation annulée."
        exit 0
    fi
    
    check_prerequisites
    find_math4child_directory
    create_navigation_files
    update_layout
    create_tests
    show_final_report
}

trap 'log_message "ERROR" "Installation interrompue"; exit 1' ERR
main "$@"
SCRIPT_END

chmod +x install-navigation.sh

echo "🎉 Script d'installation créé : install-navigation.sh"
echo ""
echo "Pour installer la navigation Math4Child :"
echo "  ./install-navigation.sh"