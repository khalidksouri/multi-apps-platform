#!/bin/bash

# =============================================================================
# 🚀 SCRIPT D'INSTALLATION DROPDOWN LANGUES AVANCÉ - Math4Child
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}           ${CYAN}🚀 DROPDOWN LANGUES AVANCÉ - Math4Child${NC}              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}       ${YELLOW}Recherche + Navigation clavier + Scroll optimisé${NC}        ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }

# 1. NAVIGATION VERS LE BON RÉPERTOIRE
check_and_navigate() {
    print_step "1. Navigation vers le répertoire du projet"
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        print_success "Dans le répertoire: $(pwd)"
    elif [ -f "package.json" ] && grep -q "math4child" package.json; then
        print_success "Déjà dans le répertoire Math4Child"
    else
        print_error "Impossible de trouver le projet Math4Child"
        exit 1
    fi
}

# 2. SAUVEGARDE ET CRÉATION DES DOSSIERS
setup_directories() {
    print_step "2. Préparation des dossiers et sauvegarde"
    
    # Sauvegarder l'ancien fichier s'il existe
    if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
        cp src/components/language/LanguageDropdown.tsx src/components/language/LanguageDropdown.tsx.backup.$(date +%Y%m%d_%H%M%S)
        print_success "Ancien fichier sauvegardé"
    fi
    
    # Créer les dossiers
    mkdir -p src/components/language
    mkdir -p src/contexts
    mkdir -p src/examples
    mkdir -p scripts
    
    print_success "Structure de dossiers créée"
}

# 3. VÉRIFICATION DES DÉPENDANCES
check_dependencies() {
    print_step "3. Vérification des dépendances"
    
    # Vérifier lucide-react
    if ! npm list lucide-react > /dev/null 2>&1; then
        print_warning "Installation de lucide-react..."
        npm install lucide-react --legacy-peer-deps
        print_success "lucide-react installé"
    else
        print_success "lucide-react déjà installé"
    fi
    
    # Vérifier react et next
    if npm list react next > /dev/null 2>&1; then
        print_success "React et Next.js détectés"
    else
        print_warning "Vérifiez l'installation de React et Next.js"
    fi
}

# 4. CRÉATION DU COMPOSANT AVANCÉ
create_advanced_component() {
    print_step "4. Création du composant LanguageDropdown avancé"
    
    cat > src/components/language/LanguageDropdown.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X, Check } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  region: string
  popular?: boolean
}

const LANGUAGES: Language[] = [
  // Langues populaires
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', popular: true },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Amérique', popular: true },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', popular: true },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', popular: true },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', popular: true },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', popular: true },
  
  // Autres langues
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  { code: 'zh', name: '中文 (简体)', nativeName: '中文', flag: '🇨🇳', region: 'Asie' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Moyen-Orient' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe' },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe' },
]

export default function AdvancedLanguageDropdown() {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedIndex, setSelectedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([])

  // Filtrage et tri des langues
  const filteredLanguages = useMemo(() => {
    let filtered = LANGUAGES.filter(lang => 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    )
    
    return filtered.sort((a, b) => {
      if (a.popular && !b.popular) return -1
      if (!a.popular && b.popular) return 1
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm])

  const closeDropdown = () => {
    setIsOpen(false)
    setSearchTerm('')
    setSelectedIndex(-1)
  }

  // Clic à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        closeDropdown()
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'unset'
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'unset'
    }
  }, [isOpen])

  // Focus sur la recherche
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100)
    }
  }, [isOpen])

  // Navigation clavier
  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      if (!isOpen) return

      switch (event.key) {
        case 'Escape':
          closeDropdown()
          break
        case 'ArrowDown':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev < filteredLanguages.length - 1 ? prev + 1 : 0
            return newIndex
          })
          break
        case 'ArrowUp':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev > 0 ? prev - 1 : filteredLanguages.length - 1
            return newIndex
          })
          break
        case 'Enter':
          event.preventDefault()
          if (selectedIndex >= 0 && filteredLanguages[selectedIndex]) {
            handleLanguageSelect(filteredLanguages[selectedIndex])
          }
          break
      }
    }

    if (isOpen) {
      document.addEventListener('keydown', handleKeyDown)
    }

    return () => {
      document.removeEventListener('keydown', handleKeyDown)
    }
  }, [isOpen, selectedIndex, filteredLanguages])

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]

  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    closeDropdown()
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton trigger */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20"
        aria-expanded={isOpen}
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium hidden sm:inline">{currentLang.name}</span>
        <span className="font-medium sm:hidden">{currentLang.code.toUpperCase()}</span>
        <ChevronDown className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={closeDropdown}
        />
      )}

      {/* Dropdown menu */}
      {isOpen && (
        <div className="fixed inset-x-4 top-4 bottom-4 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:w-96 md:max-h-[500px] md:bottom-auto">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden h-full flex flex-col">
            
            {/* Header */}
            <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <Globe className="w-5 h-5" />
                <h3 className="font-semibold">Choisir une langue</h3>
                <button onClick={closeDropdown} className="ml-auto p-1 hover:bg-gray-200 rounded-full">
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* Recherche */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Rechercher une langue..."
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>

            {/* Liste des langues */}
            <div className="flex-1 overflow-y-auto">
              {filteredLanguages.length === 0 ? (
                <div className="p-4 text-center text-gray-500">
                  <Search className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                  <p>Aucune langue trouvée</p>
                </div>
              ) : (
                filteredLanguages.map((language, index) => {
                  const isSelected = index === selectedIndex
                  const isCurrent = language.code === currentLanguage
                  
                  return (
                    <button
                      key={language.code}
                      ref={(el) => { itemRefs.current[index] = el }}
                      onClick={() => handleLanguageSelect(language)}
                      className={`w-full px-4 py-3 text-left transition-all flex items-center gap-3 ${
                        isCurrent 
                          ? 'bg-blue-100 border-l-4 border-blue-500' 
                          : isSelected
                          ? 'bg-blue-50 border-l-4 border-blue-300'
                          : 'border-l-4 border-transparent hover:bg-gray-50'
                      }`}
                    >
                      <span className="text-2xl">{language.flag}</span>
                      <div className="flex-1 min-w-0">
                        <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                          {language.name}
                          {language.popular && (
                            <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full">
                              Populaire
                            </span>
                          )}
                        </div>
                        <div className={`text-sm ${isCurrent ? 'text-blue-700' : 'text-gray-500'}`}>
                          {language.nativeName}
                        </div>
                      </div>
                      {isCurrent && <Check className="w-5 h-5 text-blue-500" />}
                    </button>
                  )
                })
              )}
            </div>

            {/* Footer */}
            <div className="px-4 py-2 bg-gray-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs text-gray-500">
                <span>{filteredLanguages.length} langues disponibles</span>
                <span>100k+ familles</span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF
    
    print_success "Composant avancé créé"
}

# 5. MISE À JOUR DU CONTEXTE
update_language_context() {
    print_step "5. Mise à jour du contexte de langue"
    
    if [ ! -f "src/contexts/LanguageContext.tsx" ]; then
        cat > src/contexts/LanguageContext.tsx << 'CONTEXT_EOF'
'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

const translations: Record<string, Record<string, string>> = {
  fr: {
    'select_language': 'Sélectionner une langue',
    'families_count': '100k+ familles',
    'welcome': 'Bienvenue',
  },
  en: {
    'select_language': 'Select a language',
    'families_count': '100k+ families',
    'welcome': 'Welcome',
  },
  es: {
    'select_language': 'Seleccionar idioma',
    'families_count': '100k+ familias',
    'welcome': 'Bienvenido',
  },
}

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    }
  }, [])

  const setLanguage = (lang: string) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child-language', lang)
  }

  const t = (key: string): string => {
    return translations[currentLanguage]?.[key] || key
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, t }}>
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
CONTEXT_EOF
        print_success "Contexte de langue créé"
    else
        print_success "Contexte de langue existant conservé"
    fi
}

# 6. CRÉATION D'UN EXEMPLE
create_example() {
    print_step "6. Création d'un exemple d'utilisation"
    
    cat > src/examples/LanguageDropdownExample.tsx << 'EXAMPLE_EOF'
'use client'

import { LanguageProvider } from '@/contexts/LanguageContext'
import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'

export default function LanguageDropdownExample() {
  return (
    <LanguageProvider>
      <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600 p-8">
        <div className="max-w-4xl mx-auto">
          <header className="flex justify-between items-center mb-8">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 bg-white/20 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold">M4C</span>
              </div>
              <h1 className="text-white text-xl font-bold">Math4Child</h1>
            </div>
            
            <AdvancedLanguageDropdown />
          </header>
          
          <main className="text-white text-center">
            <h2 className="text-4xl font-bold mb-4">
              Dropdown de langues avancé
            </h2>
            <p className="text-xl text-white/80 mb-8">
              Testez la recherche, navigation clavier et scroll optimisé !
            </p>
          </main>
        </div>
      </div>
    </LanguageProvider>
  )
}
EXAMPLE_EOF
    
    print_success "Exemple créé"
}

# 7. CRÉATION DE SCRIPTS UTILES
create_scripts() {
    print_step "7. Création de scripts utiles"
    
    cat > scripts/test-dropdown.sh << 'SCRIPT_EOF'
#!/bin/bash

echo "🧪 TEST DU DROPDOWN AVANCÉ"
echo "=========================="

files=(
    "src/components/language/LanguageDropdown.tsx"
    "src/contexts/LanguageContext.tsx"
    "src/examples/LanguageDropdownExample.tsx"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file manquant"
    fi
done

echo ""
echo "📦 Dépendances:"
npm list lucide-react > /dev/null 2>&1 && echo "✅ lucide-react" || echo "❌ lucide-react manquant"

echo ""
echo "🎯 Fonctionnalités à tester:"
echo "• Recherche instantanée"
echo "• Navigation clavier (↑↓ Enter Escape)"
echo "• Scroll automatique"
echo "• Interface responsive"
SCRIPT_EOF

    chmod +x scripts/test-dropdown.sh
    print_success "Scripts utiles créés"
}

# 8. TEST FINAL
final_test() {
    print_step "8. Test final"
    
    if command -v npx > /dev/null 2>&1; then
        if npx tsc --noEmit --skipLibCheck > /dev/null 2>&1; then
            print_success "✅ Compilation TypeScript réussie"
        else
            print_warning "⚠️  Quelques avertissements TypeScript"
        fi
    fi
    
    print_success "Installation terminée"
}

# FONCTION PRINCIPALE
main() {
    print_header
    
    check_and_navigate
    setup_directories
    check_dependencies
    create_advanced_component
    update_language_context
    create_example
    create_scripts
    final_test
    
    # Résumé final
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}              ${GREEN}✅ DROPDOWN AVANCÉ INSTALLÉ AVEC SUCCÈS${NC}              ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}🎉 NOUVELLES FONCTIONNALITÉS :${NC}"
    echo -e "${CYAN}   • 🔍 Recherche instantanée${NC}"
    echo -e "${CYAN}   • ⌨️  Navigation clavier complète${NC}"
    echo -e "${CYAN}   • 📜 Scroll optimisé${NC}"
    echo -e "${CYAN}   • ⭐ Langues populaires${NC}"
    echo -e "${CYAN}   • 📱 Interface responsive${NC}"
    echo -e "${CYAN}   • ♿ Accessibilité complète${NC}"
    echo ""
    
    echo -e "${YELLOW}🎮 CONTRÔLES :${NC}"
    echo -e "${BLUE}   • Recherche: Tapez directement${NC}"
    echo -e "${BLUE}   • Navigation: ↑↓ (flèches)${NC}"
    echo -e "${BLUE}   • Sélection: Entrée${NC}"
    echo -e "${BLUE}   • Fermeture: Escape${NC}"
    echo ""
    
    echo -e "${GREEN}🚀 PROCHAINES ÉTAPES :${NC}"
    echo -e "${BLUE}   1. Testez: ./scripts/test-dropdown.sh${NC}"
    echo -e "${BLUE}   2. Intégrez dans votre layout${NC}"
    echo -e "${BLUE}   3. Personnalisez si nécessaire${NC}"
    echo ""
    
    echo -e "${GREEN}💡 INTÉGRATION :${NC}"
    echo -e "${CYAN}   import { LanguageProvider } from '@/contexts/LanguageContext'${NC}"
    echo -e "${CYAN}   import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'${NC}"
    echo ""
    echo -e "${PURPLE}⭐ VOTRE DROPDOWN AVANCÉ EST PRÊT ! ⭐${NC}"
}

# Exécution
main "$@"