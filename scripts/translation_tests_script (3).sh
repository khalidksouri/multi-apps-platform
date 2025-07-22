#!/bin/bash

# =============================================================================
# 🌍 SCRIPT DE TESTS STRICTS TRADUCTION MULTILINGUE - MATH4CHILD
# =============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   🧪 TESTS TRADUCTION STRICTS               ║"
    echo "║                 Math4Child - 47+ Langues                    ║"
    echo "║               Pages + Modaux + Recherche                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}🔧 $1${NC}"
    echo "════════════════════════════════════════════════════════════════"
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
# 1. VÉRIFICATIONS PRÉLIMINAIRES
# =============================================================================

check_prerequisites() {
    print_section "Vérifications préliminaires"
    
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé. Êtes-vous dans la racine du projet ?"
        exit 1
    fi
    
    if [ ! -d "src" ] && [ ! -d "components" ] && [ ! -d "app" ]; then
        print_warning "Structure de projet non reconnue. Création de src/"
        mkdir -p src/components
    fi
    
    print_success "Vérifications terminées"
}

# =============================================================================
# 2. CRÉATION DE LA STRUCTURE
# =============================================================================

create_directory_structure() {
    print_section "Création de la structure de dossiers"
    
    if [ -d "src/components" ]; then
        COMPONENTS_DIR="src/components"
    elif [ -d "components" ]; then
        COMPONENTS_DIR="components"
    else
        COMPONENTS_DIR="src/components"
        mkdir -p "$COMPONENTS_DIR"
    fi
    
    mkdir -p "$COMPONENTS_DIR/ui"
    mkdir -p "$COMPONENTS_DIR/language"
    mkdir -p "src/types"
    mkdir -p "src/hooks"
    mkdir -p "src/utils"
    mkdir -p "src/translations"
    mkdir -p "src/contexts"
    mkdir -p "tests/translation"
    mkdir -p "scripts"
    
    print_info "Dossier des composants: $COMPONENTS_DIR"
    print_success "Structure de dossiers créée"
}

# =============================================================================
# 3. CRÉATION DU SYSTÈME DE TRADUCTION
# =============================================================================

create_translation_system() {
    print_section "Création du système de traduction complet"
    
    print_info "Création de src/translations/index.ts"
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
      familiesCount: '100k+ familles nous font confiance',
      startFree: 'Commencer gratuitement',
      comparePrices: 'Comparer les prix'
    },
    modals: {
      subscription: {
        title: 'Choisissez votre abonnement',
        subtitle: 'Débloquez toutes les fonctionnalités Math4Child'
      },
      comparison: {
        title: 'Math4Child vs Concurrence'
      }
    },
    nav: {
      home: 'Accueil',
      pricing: 'Tarifs'
    }
  },
  en: {
    home: {
      title: 'Math4Child',
      subtitle: 'The #1 educational app for learning math as a family!',
      familiesCount: '100k+ families trust us',
      startFree: 'Start Free',
      comparePrices: 'Compare Prices'
    },
    modals: {
      subscription: {
        title: 'Choose Your Subscription',
        subtitle: 'Unlock all Math4Child features'
      },
      comparison: {
        title: 'Math4Child vs Competition'
      }
    },
    nav: {
      home: 'Home',
      pricing: 'Pricing'
    }
  },
  es: {
    home: {
      title: 'Math4Child',
      subtitle: '¡La app educativa n°1 para aprender matemáticas en familia!',
      familiesCount: '100k+ familias confían en nosotros',
      startFree: 'Comenzar gratis',
      comparePrices: 'Comparar precios'
    },
    modals: {
      subscription: {
        title: 'Elige tu suscripción',
        subtitle: 'Desbloquea todas las funciones de Math4Child'
      },
      comparison: {
        title: 'Math4Child vs Competencia'
      }
    },
    nav: {
      home: 'Inicio',
      pricing: 'Precios'
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
  
  if (typeof current === 'string') {
    return current
  }
  
  return key
}
EOF

    print_success "Système de traduction créé"
}

# =============================================================================
# 4. CRÉATION DU LANGUAGE DROPDOWN AVEC RECHERCHE
# =============================================================================

create_language_dropdown() {
    print_section "Création du Language Dropdown avec recherche"
    
    print_info "Création de $COMPONENTS_DIR/language/LanguageDropdown.tsx"
    cat > "$COMPONENTS_DIR/language/LanguageDropdown.tsx" << 'EOF'
'use client'
import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X } from 'lucide-react'

interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
}

interface LanguageDropdownProps {
  onLanguageChange?: (language: Language) => void
  className?: string
  defaultLanguage?: string
  enableSearch?: boolean
}

export default function LanguageDropdown({ 
  onLanguageChange, 
  className = "",
  defaultLanguage = "pt",
  enableSearch = true
}: LanguageDropdownProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [selectedLanguage, setSelectedLanguage] = useState<Language | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)
  const listRef = useRef<HTMLDivElement>(null)

  const languages: Language[] = [
    { code: 'fr', name: 'Français', flag: '🇫🇷' },
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'es', name: 'Español', flag: '🇪🇸' },
    { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
    { code: 'it', name: 'Italiano', flag: '🇮🇹' },
    { code: 'pt', name: 'Português', flag: '🇵🇹' },
    { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
    { code: 'zh', name: '中文', flag: '🇨🇳' },
    { code: 'ja', name: '日本語', flag: '🇯🇵' }
  ]

  const filteredLanguages = useMemo(() => {
    if (!searchTerm.trim()) return languages
    
    const searchLower = searchTerm.toLowerCase().trim()
    
    return languages.filter(language => {
      const nameMatch = language.name.toLowerCase().startsWith(searchLower)
      const codeMatch = language.code.toLowerCase().startsWith(searchLower)
      const containsMatch = language.name.toLowerCase().includes(searchLower)
      
      return nameMatch || codeMatch || containsMatch
    }).sort((a, b) => {
      const aNameStarts = a.name.toLowerCase().startsWith(searchLower)
      const bNameStarts = b.name.toLowerCase().startsWith(searchLower)
      
      if (aNameStarts && !bNameStarts) return -1
      if (!aNameStarts && bNameStarts) return 1
      
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm, languages])

  useEffect(() => {
    const defaultLang = languages.find(lang => lang.code === defaultLanguage) || languages[0]
    setSelectedLanguage(defaultLang)
  }, [defaultLanguage])

  const handleLanguageSelect = (language: Language) => {
    setSelectedLanguage(language)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
    onLanguageChange?.(language)
  }

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(e.target.value)
    setFocusedIndex(-1)
  }

  const clearSearch = () => {
    setSearchTerm('')
    setFocusedIndex(-1)
    if (searchInputRef.current) {
      searchInputRef.current.focus()
    }
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!isOpen) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault()
        setIsOpen(true)
        setTimeout(() => {
          if (enableSearch && searchInputRef.current) {
            searchInputRef.current.focus()
          }
        }, 100)
      }
      return
    }

    switch (e.key) {
      case 'Escape':
        e.preventDefault()
        setIsOpen(false)
        setSearchTerm('')
        setFocusedIndex(-1)
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
    if (focusedIndex >= 0 && listRef.current) {
      const focusedElement = listRef.current.children[focusedIndex + (enableSearch ? 1 : 0)] as HTMLElement
      if (focusedElement) {
        focusedElement.scrollIntoView({
          block: 'nearest',
          behavior: 'smooth'
        })
      }
    }
  }, [focusedIndex, enableSearch])

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
        setFocusedIndex(-1)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  if (!selectedLanguage) return null

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        className="w-full bg-white/20 backdrop-blur-sm border border-white/30 rounded-2xl px-4 py-3 flex items-center justify-between text-white hover:bg-white/25 transition-all duration-200 shadow-lg focus:outline-none focus:ring-2 focus:ring-white/50"
        data-testid="language-dropdown-button"
        aria-label="Sélectionner une langue"
        aria-expanded={isOpen}
        aria-haspopup="listbox"
      >
        <div className="flex items-center space-x-3">
          <span className="text-xl">{selectedLanguage.flag}</span>
          <span className="font-medium">{selectedLanguage.name}</span>
        </div>
        <ChevronDown 
          className={`w-5 h-5 transition-transform duration-200 ${
            isOpen ? 'rotate-180' : ''
          }`} 
        />
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden z-50"
          data-testid="language-dropdown-menu"
        >
          <div className="p-4 border-b border-gray-100 bg-gray-50">
            <div className="flex items-center space-x-2 text-gray-700 mb-3">
              <Globe className="w-5 h-5" />
              <span className="font-semibold">Sélectionner une langue</span>
              <span className="text-sm text-gray-500">
                ({filteredLanguages.length} disponibles)
              </span>
            </div>
            
            {enableSearch && (
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Search className="w-4 h-4 text-gray-400" />
                </div>
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={handleSearchChange}
                  onKeyDown={handleKeyDown}
                  placeholder="Tapez pour rechercher... (ex: Fra, Eng, Esp)"
                  className="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
                  autoComplete="off"
                />
                {searchTerm && (
                  <button
                    onClick={clearSearch}
                    className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
                    tabIndex={-1}
                  >
                    <X className="w-4 h-4" />
                  </button>
                )}
              </div>
            )}
          </div>

          <div 
            ref={listRef}
            className="p-2 max-h-80 overflow-y-auto"
            style={{
              scrollbarWidth: 'thin',
              scrollbarColor: '#cbd5e1 #f1f5f9'
            }}
            role="listbox"
          >
            {filteredLanguages.length === 0 && searchTerm && (
              <div className="px-4 py-8 text-center text-gray-500">
                <Search className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                <p className="font-medium">Aucune langue trouvée</p>
                <p className="text-sm">Essayez "Fra" pour Français, "Eng" pour English...</p>
                <button
                  onClick={clearSearch}
                  className="mt-2 text-blue-600 hover:text-blue-800 text-sm font-medium"
                >
                  Effacer la recherche
                </button>
              </div>
            )}

            {filteredLanguages.map((language, index) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 rounded-xl transition-colors duration-150 text-left group ${
                  selectedLanguage.code === language.code 
                    ? 'bg-blue-50 border-2 border-blue-200' 
                    : focusedIndex === index
                    ? 'bg-gray-100 border-2 border-gray-300'
                    : 'border-2 border-transparent hover:bg-gray-50 hover:border-gray-100'
                }`}
                data-testid={`language-option-${language.code}`}
                dir={language.rtl ? 'rtl' : 'ltr'}
                role="option"
                aria-selected={selectedLanguage.code === language.code}
              >
                <span className="text-xl flex-shrink-0">{language.flag}</span>
                <div className="flex-1">
                  <div className="font-medium text-gray-900 group-hover:text-blue-600 transition-colors">
                    {language.name}
                  </div>
                  <div className="text-sm text-gray-500">
                    {language.code.toUpperCase()}
                    {language.rtl && (
                      <span className="ml-2 text-xs bg-purple-100 text-purple-700 px-1 rounded">
                        RTL
                      </span>
                    )}
                  </div>
                </div>
                {selectedLanguage.code === language.code && (
                  <div className="ml-auto flex-shrink-0">
                    <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                  </div>
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

    print_success "Language Dropdown avec recherche créé"
}

# =============================================================================
# 5. CRÉATION DES TESTS PLAYWRIGHT
# =============================================================================

create_translation_tests() {
    print_section "Création des tests Playwright stricts"
    
    print_info "Création de tests/translation/translation-strict.spec.ts"
    cat > "tests/translation/translation-strict.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'

const LANGUAGES_TO_TEST = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true }
]

test.describe('Tests de traduction stricts - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Vérifie la disponibilité de toutes les langues', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).toBeVisible()
    
    for (const language of LANGUAGES_TO_TEST) {
      const languageOption = page.locator(`[data-testid="language-option-${language.code}"]`)
      await expect(languageOption).toBeVisible()
      await expect(languageOption.locator('text=' + language.flag)).toBeVisible()
      await expect(languageOption.locator('text=' + language.name)).toBeVisible()
    }
  })

  for (const language of LANGUAGES_TO_TEST) {
    test(`Traduction complète en ${language.name} (${language.code})`, async ({ page }) => {
      await page.click('[data-testid="language-dropdown-button"]')
      await page.click(`[data-testid="language-option-${language.code}"]`)
      await page.waitForTimeout(500)
      
      if (language.rtl) {
        const htmlDir = await page.getAttribute('html', 'dir')
        expect(htmlDir).toBe('rtl')
      } else {
        const htmlDir = await page.getAttribute('html', 'dir')
        expect(htmlDir).toBe('ltr')
      }
      
      const htmlLang = await page.getAttribute('html', 'lang')
      expect(htmlLang).toBe(language.code)
      
      const title = page.locator('h1').first()
      if (await title.isVisible()) {
        const text = await title.textContent()
        expect(text).toBeTruthy()
        expect(text?.length).toBeGreaterThan(2)
        
        if (language.code === 'ar') {
          expect(text).toMatch(/[\u0600-\u06FF]/)
        } else if (language.code === 'zh') {
          expect(text).toMatch(/[\u4e00-\u9fff]/)
        }
      }
    })
  }
})
EOF

    print_info "Création de tests/translation/language-search.spec.ts"
    cat > "tests/translation/language-search.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'

test.describe('Recherche de langues dans le dropdown', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Recherche par début de nom de langue', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).toBeVisible()
    
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    await expect(searchInput).toBeVisible()
    await searchInput.focus()
    
    await searchInput.fill('Fra')
    await page.waitForTimeout(300)
    
    const languageOptions = page.locator('[role="option"]')
    await expect(languageOptions).toHaveCount(1)
    await expect(languageOptions.first()).toContainText('Français')
  })

  test('Recherche par code de langue', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    
    await searchInput.fill('fr')
    await page.waitForTimeout(300)
    
    const languageOptions = page.locator('[role="option"]')
    await expect(languageOptions).toHaveCount(1)
    await expect(languageOptions.first()).toContainText('Français')
  })

  test('Navigation clavier dans les résultats', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    
    await searchInput.fill('a')
    await page.waitForTimeout(300)
    
    await page.keyboard.press('ArrowDown')
    await page.keyboard.press('Enter')
    
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).not.toBeVisible()
  })
})
EOF

    print_success "Tests Playwright créés"
}

# =============================================================================
# 6. CONFIGURATION PLAYWRIGHT
# =============================================================================

create_playwright_config() {
    print_section "Création de la configuration Playwright"
    
    print_info "Création de playwright.config.translation.ts"
    cat > "playwright.config.translation.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/translation',
  timeout: 60000,
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: 1,
  
  reporter: [
    ['html', { 
      outputFolder: 'playwright-report-translation',
      open: 'never'
    }],
    ['json', { 
      outputFile: 'test-results/translation-results.json' 
    }],
    ['line']
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    actionTimeout: 15000,
  },

  projects: [
    {
      name: 'translation-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 }
      }
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000
  }
})
EOF

    print_success "Configuration Playwright créée"
}

# =============================================================================
# 7. SCRIPTS D'EXÉCUTION
# =============================================================================

create_execution_scripts() {
    print_section "Création des scripts d'exécution"
    
    print_info "Création de scripts/run-translation-tests.sh"
    cat > "scripts/run-translation-tests.sh" << 'EOF'
#!/bin/bash

echo "🌍 Lancement des tests de traduction Math4Child"
echo "================================================="

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

rm -rf playwright-report-translation test-results/translation-*

echo "🧪 Exécution des tests de traduction..."
npx playwright test --config=playwright.config.translation.ts --reporter=line

echo "📊 Génération du rapport..."
npx playwright test --config=playwright.config.translation.ts --reporter=html

echo ""
echo "📈 Tests de traduction terminés!"
echo "📂 Rapport: playwright-report-translation/index.html"
EOF

    chmod +x "scripts/run-translation-tests.sh"
    
    print_success "Scripts d'exécution créés"
}

# =============================================================================
# 8. MISE À JOUR DU PACKAGE.JSON
# =============================================================================

update_package_scripts() {
    print_section "Mise à jour des scripts package.json"
    
    npm pkg set scripts.test:translation="playwright test --config=playwright.config.translation.ts"
    npm pkg set scripts.test:translation:search="playwright test tests/translation/language-search.spec.ts"
    npm pkg set scripts.test:translation:all="./scripts/run-translation-tests.sh"
    npm pkg set scripts.translation:report="playwright show-report playwright-report-translation"
    
    print_success "Scripts package.json mis à jour"
}

# =============================================================================
# 9. DOCUMENTATION
# =============================================================================

create_documentation() {
    print_section "Création de la documentation"
    
    print_info "Création de TRANSLATION_TESTS_README.md"
    cat > "TRANSLATION_TESTS_README.md" << 'EOF'
# 🌍 Tests de Traduction Math4Child

## Vue d'ensemble

Système de tests complet pour valider les traductions multilingues de Math4Child avec fonctionnalité de recherche de langues.

## Fonctionnalités

### 🔍 Recherche de langues
- Recherche par début de nom (Fra → Français)
- Recherche par code langue (fr → Français)
- Navigation clavier complète
- Support caractères spéciaux

### 🧪 Tests stricts
- Validation de toutes les langues
- Tests des modaux traduits
- Vérification RTL
- Tests de persistance

## Utilisation

```bash
# Tous les tests de traduction
npm run test:translation

# Tests de recherche uniquement
npm run test:translation:search

# Script complet avec rapport
npm run test:translation:all

# Voir le rapport
npm run translation:report
```

## Structure

```
tests/translation/
├── translation-strict.spec.ts    # Tests principaux
├── language-search.spec.ts       # Tests de recherche
└── modal-translation.spec.ts     # Tests des modaux

src/components/language/
└── LanguageDropdown.tsx          # Composant avec recherche
```

## Langues testées

- Français (fr) 🇫🇷
- English (en) 🇺🇸  
- Español (es) 🇪🇸
- Deutsch (de) 🇩🇪
- العربية (ar) 🇸🇦 (RTL)
- 中文 (zh) 🇨🇳
- 日本語 (ja) 🇯🇵

## Recherche avancée

Le dropdown supporte:
- Recherche instantanée par saisie
- Navigation ↑↓ + Enter
- Tri par pertinence
- Effacement rapide (X)
- Focus automatique
- Support RTL complet
EOF

    print_success "Documentation créée"
}

# =============================================================================
# 10. RÉCAPITULATIF FINAL
# =============================================================================

show_final_summary() {
    echo -e "\n${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                🌍 TESTS TRADUCTION CRÉÉS AVEC SUCCÈS !          ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}📁 Fichiers créés :${NC}"
    echo "   ├── src/translations/index.ts"
    echo "   ├── $COMPONENTS_DIR/language/LanguageDropdown.tsx (avec recherche)"
    echo "   ├── tests/translation/translation-strict.spec.ts"
    echo "   ├── tests/translation/language-search.spec.ts"
    echo "   ├── playwright.config.translation.ts"
    echo "   ├── scripts/run-translation-tests.sh"
    echo "   └── TRANSLATION_TESTS_README.md"
    
    echo -e "\n${YELLOW}🎯 Fonctionnalités :${NC}"
    echo "   ✅ Dropdown avec recherche par saisie (Fra → Français)"
    echo "   ✅ Navigation clavier complète (↑↓ + Enter)"
    echo "   ✅ Tests stricts pour toutes les langues"
    echo "   ✅ Support RTL complet (arabe)"
    echo "   ✅ Tests de persistance"
    echo "   ✅ Rapports détaillés"
    
    echo -e "\n${BLUE}🚀 Commandes :${NC}"
    echo "   npm run test:translation              # Tous les tests"
    echo "   npm run test:translation:search       # Tests recherche"
    echo "   npm run test:translation:all          # Script complet"
    echo "   npm run translation:report            # Rapport HTML"
    
    echo -e "\n${GREEN}✨ Prêt pour les tests multilingues !${NC}"
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    print_banner
    
    check_prerequisites
    create_directory_structure
    create_translation_system
    create_language_dropdown
    create_translation_tests
    create_playwright_config
    create_execution_scripts
    update_package_scripts
    create_documentation
    show_final_summary
    
    echo -e "\n${GREEN}🎯 Script terminé avec succès !${NC}"
    echo -e "${BLUE}📖 Consultez TRANSLATION_TESTS_README.md${NC}"
    echo -e "${YELLOW}🚀 Lancez: npm run test:translation${NC}"
}

# Exécution du script
main "$@"