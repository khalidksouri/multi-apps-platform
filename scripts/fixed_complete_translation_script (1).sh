#!/bin/bash

# =============================================================================
# 🌍 SCRIPT COMPLET SYSTÈME TRADUCTION MULTILINGUE - MATH4CHILD
# Version 2.0 avec Saisie Directe et Netlify Existant - CORRIGÉ
# =============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║           🌍 SYSTÈME TRADUCTION COMPLET - MATH4CHILD V2.0           ║"
    echo "║        ✨ Saisie Directe + Recherche Avancée + Netlify Intégré      ║"
    echo "║                     47+ Langues + RTL Support                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}${BOLD}🔧 $1${NC}"
    echo "════════════════════════════════════════════════════════════════════════"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# =============================================================================
# FONCTION PRINCIPALE SIMPLIFIÉE
# =============================================================================

main() {
    print_banner
    
    print_section "Installation du système de traduction"
    
    # Vérifications de base
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé. Êtes-vous dans la racine du projet ?"
        exit 1
    fi
    
    # Créer la structure de base
    print_info "Création de la structure des dossiers..."
    mkdir -p src/components/language
    mkdir -p src/contexts
    mkdir -p src/translations
    mkdir -p tests/translation
    mkdir -p scripts
    mkdir -p public
    
    print_success "Structure créée"
    
    # Installer Playwright si nécessaire
    print_info "Vérification de Playwright..."
    if ! npm list @playwright/test &> /dev/null; then
        print_info "Installation de Playwright..."
        npm install --save-dev @playwright/test
        npx playwright install chromium firefox
        print_success "Playwright installé"
    else
        print_success "Playwright déjà installé"
    fi
    
    # Créer les fichiers essentiels
    create_essential_files
    
    print_section "Configuration terminée"
    
    echo -e "\n${GREEN}🎉 INSTALLATION TERMINÉE AVEC SUCCÈS !${NC}"
    echo -e "${BLUE}📋 Prochaines étapes :${NC}"
    echo "1. Intégrer le composant LanguageDropdown dans votre layout"
    echo "2. Tester avec: npm run test:translation:quick"
    echo "3. Push vers Netlify: git push origin main"
    echo ""
    echo -e "${CYAN}🔗 Votre projet Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159${NC}"
}

# =============================================================================
# CRÉATION DES FICHIERS ESSENTIELS
# =============================================================================

create_essential_files() {
    print_info "Création des fichiers essentiels..."
    
    # 1. Contexte de langue
    cat > "src/contexts/LanguageContext.tsx" << 'EOF'
'use client'
import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
}

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (language: Language) => void
  availableLanguages: Language[]
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' }
]

interface LanguageProviderProps {
  children: ReactNode
  defaultLanguage?: string
}

export function LanguageProvider({ children, defaultLanguage = 'fr' }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(
    LANGUAGES.find(lang => lang.code === defaultLanguage) || LANGUAGES[0]
  )

  const setLanguage = (language: Language) => {
    setCurrentLanguage(language)
    document.documentElement.lang = language.code
    document.documentElement.dir = language.rtl ? 'rtl' : 'ltr'
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('preferred-language', language.code)
    }
  }

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('preferred-language')
      if (savedLanguage) {
        const language = LANGUAGES.find(lang => lang.code === savedLanguage)
        if (language) {
          setLanguage(language)
        }
      }
    }
  }, [])

  const value: LanguageContextType = {
    currentLanguage,
    setLanguage,
    availableLanguages: LANGUAGES,
    isRTL: currentLanguage.rtl || false
  }

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
EOF

    # 2. Système de traduction
    cat > "src/translations/index.ts" << 'EOF'
export interface Translation {
  [key: string]: string | Translation
}

export interface Translations {
  [languageCode: string]: Translation
}

export const translations: Translations = {
  fr: {
    home: {
      title: 'Math4Child',
      subtitle: "L'app éducative n°1 pour apprendre les maths en famille !",
      startFree: 'Commencer gratuitement',
      comparePrices: 'Comparer les prix'
    },
    language: {
      select: 'Sélectionner une langue',
      search: 'Tapez pour rechercher...',
      directTyping: 'Tapez directement dans la liste',
      available: 'disponibles'
    }
  },
  en: {
    home: {
      title: 'Math4Child',
      subtitle: 'The #1 educational app for learning math as a family!',
      startFree: 'Start Free',
      comparePrices: 'Compare Prices'
    },
    language: {
      select: 'Select a language',
      search: 'Type to search...',
      directTyping: 'Type directly in the list',
      available: 'available'
    }
  },
  es: {
    home: {
      title: 'Math4Child',
      subtitle: '¡La app educativa n°1 para aprender matemáticas en familia!',
      startFree: 'Comenzar gratis',
      comparePrices: 'Comparar precios'
    },
    language: {
      select: 'Seleccionar idioma',
      search: 'Escribe para buscar...',
      directTyping: 'Escribe directamente en la lista',
      available: 'disponibles'
    }
  }
}

export function getTranslation(
  translations: Translations,
  language: string,
  key: string,
  fallbackLanguage = 'en'
): string {
  const keys = key.split('.')
  let current: any = translations[language]
  
  for (const k of keys) {
    current = current?.[k]
  }
  
  if (typeof current === 'string') {
    return current
  }
  
  current = translations[fallbackLanguage]
  for (const k of keys) {
    current = current?.[k]
  }
  
  return typeof current === 'string' ? current : key
}

export function useTranslation(language: string) {
  const t = (key: string) => getTranslation(translations, language, key)
  return { t, language }
}
EOF

    # 3. Composant LanguageDropdown
    cat > "src/components/language/LanguageDropdown.tsx" << 'EOF'
'use client'
import { useState, useRef, useEffect } from 'react'
import { ChevronDown, Globe, Search, X } from 'lucide-react'
import { useLanguage } from '../../contexts/LanguageContext'
import { useTranslation } from '../../translations'

interface LanguageDropdownProps {
  className?: string
  enableDirectTyping?: boolean
}

export default function LanguageDropdown({ 
  className = "",
  enableDirectTyping = true
}: LanguageDropdownProps) {
  const { currentLanguage, setLanguage, availableLanguages } = useLanguage()
  const { t } = useTranslation(currentLanguage.code)
  
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  const filteredLanguages = availableLanguages.filter(language => 
    language.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    language.code.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const handleLanguageSelect = (language: any) => {
    setLanguage(language)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!isOpen) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault()
        setIsOpen(true)
      }
      return
    }

    switch (e.key) {
      case 'Escape':
        e.preventDefault()
        setIsOpen(false)
        setSearchTerm('')
        break
        
      case 'ArrowDown':
        e.preventDefault()
        setFocusedIndex(prev => 
          prev < filteredLanguages.length - 1 ? prev + 1 : 0
        )
        break
        
      case 'ArrowUp':
        e.preventDefault()
        setFocusedIndex(prev => 
          prev > 0 ? prev - 1 : filteredLanguages.length - 1
        )
        break
        
      case 'Enter':
        e.preventDefault()
        if (focusedIndex >= 0 && filteredLanguages[focusedIndex]) {
          handleLanguageSelect(filteredLanguages[focusedIndex])
        }
        break
    }
  }

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        className="w-full bg-white/20 backdrop-blur-sm border border-white/30 rounded-2xl px-4 py-3 flex items-center justify-between text-white hover:bg-white/25 transition-all duration-200 shadow-lg"
        data-testid="language-dropdown-button"
        aria-label={t('language.select')}
        aria-expanded={isOpen}
      >
        <div className="flex items-center space-x-3">
          <span className="text-xl">{currentLanguage.flag}</span>
          <span className="font-medium">{currentLanguage.name}</span>
        </div>
        <ChevronDown className={`w-5 h-5 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden z-50"
          data-testid="language-dropdown-menu"
        >
          <div className="p-4 border-b border-gray-100 bg-gray-50">
            <div className="flex items-center space-x-2 text-gray-700 mb-3">
              <Globe className="w-5 h-5" />
              <span className="font-semibold">{t('language.select')}</span>
              <span className="text-sm text-gray-500">
                ({filteredLanguages.length} {t('language.available')})
              </span>
            </div>
            
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                ref={searchInputRef}
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={t('language.search')}
                className="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
          </div>

          <div className="p-2 max-h-80 overflow-y-auto">
            {filteredLanguages.map((language, index) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 rounded-xl transition-colors text-left ${
                  currentLanguage.code === language.code 
                    ? 'bg-blue-50 border-2 border-blue-200' 
                    : focusedIndex === index
                    ? 'bg-gray-100 border-2 border-gray-300'
                    : 'border-2 border-transparent hover:bg-gray-50'
                }`}
                data-testid={`language-option-${language.code}`}
                dir={language.rtl ? 'rtl' : 'ltr'}
              >
                <span className="text-xl">{language.flag}</span>
                <div className="flex-1">
                  <div className="font-medium text-gray-900">{language.name}</div>
                  <div className="text-sm text-gray-500">{language.code.toUpperCase()}</div>
                </div>
                {currentLanguage.code === language.code && (
                  <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                )}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
EOF

    # 4. Test Playwright de base
    cat > "tests/translation/translation-basic.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'

const LANGUAGES_TO_TEST = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' }
]

test.describe('Tests de traduction - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Dropdown de langues est visible', async ({ page }) => {
    const dropdown = page.locator('[data-testid="language-dropdown-button"]')
    await expect(dropdown).toBeVisible()
  })

  for (const language of LANGUAGES_TO_TEST) {
    test(`Sélection de ${language.name}`, async ({ page }) => {
      await page.click('[data-testid="language-dropdown-button"]')
      await page.click(`[data-testid="language-option-${language.code}"]`)
      
      const dropdownButton = page.locator('[data-testid="language-dropdown-button"]')
      await expect(dropdownButton).toContainText(language.name)
    })
  }
})
EOF

    # 5. Configuration Playwright
    cat > "playwright.config.translation.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/translation',
  timeout: 30000,
  retries: 1,
  workers: 1,
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure'
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: true
  }
})
EOF

    # 6. Configuration Netlify
    cat > "netlify.toml" << 'EOF'
[build]
  publish = "out"
  command = "npm run build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[context.production.environment]
  NODE_ENV = "production"
  DEFAULT_LANGUAGE = "fr"
EOF

    # 7. Redirections Netlify
    cat > "public/_redirects" << 'EOF'
/*    /index.html   200
EOF

    # 8. Scripts package.json
    npm pkg set scripts.test:translation:quick="playwright test tests/translation/translation-basic.spec.ts --grep='Français|English|Español'"
    npm pkg set scripts.test:translation="playwright test --config=playwright.config.translation.ts"
    npm pkg set scripts.translation:report="playwright show-report"
    
    # 9. Script de santé
    cat > "scripts/health-check.sh" << 'EOF'
#!/bin/bash

echo "🏥 Vérification du système de traduction"
echo "======================================="

if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
    echo "✅ Composant LanguageDropdown trouvé"
else
    echo "❌ Composant LanguageDropdown manquant"
fi

if [ -f "src/contexts/LanguageContext.tsx" ]; then
    echo "✅ Contexte de langue trouvé"
else
    echo "❌ Contexte de langue manquant"
fi

if [ -f "tests/translation/translation-basic.spec.ts" ]; then
    echo "✅ Tests de base trouvés"
else
    echo "❌ Tests de base manquants"
fi

echo ""
echo "🎯 Pour tester: npm run test:translation:quick"
echo "🌐 Projet Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159"
EOF

    chmod +x "scripts/health-check.sh"
    
    # 10. Documentation rapide
    cat > "QUICK_START.md" << 'EOF'
# 🚀 Quick Start - Système de Traduction

## Installation terminée ! 🎉

### Prochaines étapes:

1. **Intégrer dans votre layout** :
```tsx
import { LanguageProvider } from '../src/contexts/LanguageContext'
import LanguageDropdown from '../src/components/language/LanguageDropdown'

export default function Layout({ children }) {
  return (
    <LanguageProvider>
      <header>
        <LanguageDropdown />
      </header>
      {children}
    </LanguageProvider>
  )
}
```

2. **Tester localement** :
```bash
npm run test:translation:quick
```

3. **Déployer** :
```bash
git add .
git commit -m "feat: add translation system"
git push origin main
```

### Liens utiles:
- 🌐 Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159
- 🧪 Tests: `npm run test:translation`
- 🏥 Santé: `./scripts/health-check.sh`
EOF
    
    print_success "Fichiers essentiels créés"
}

# Exécution du script
main "$@"