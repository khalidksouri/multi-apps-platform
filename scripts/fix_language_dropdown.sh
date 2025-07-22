#!/bin/bash

# =============================================================================
# 🔧 CORRECTION COMPLÈTE DU LANGUAGE DROPDOWN - Math4Child
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
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}           ${CYAN}🔧 CORRECTION DROPDOWN LANGUAGE - Math4Child${NC}              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}       ${YELLOW}Toutes fonctionnalités + Intégration + Cache Fix${NC}           ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# 1. NAVIGATION ET VÉRIFICATION
check_environment() {
    print_step "1. Vérification de l'environnement"
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        print_success "Dans: $(pwd)"
    elif [ -f "package.json" ] && grep -q "math4child" package.json; then
        print_success "Déjà dans Math4Child"
    else
        print_error "Projet Math4Child non trouvé"
        exit 1
    fi
    
    # Arrêter tous les processus Next.js
    pkill -f "next dev" 2>/dev/null || true
    pkill -f "node.*next" 2>/dev/null || true
    print_success "Serveurs arrêtés"
}

# 2. SUPPRESSION COMPLÈTE DES CACHES
clear_all_caches() {
    print_step "2. Suppression complète des caches"
    
    rm -rf .next
    rm -rf node_modules/.cache
    rm -rf .swc
    rm -rf out
    rm -rf dist
    rm -rf build
    npm cache clean --force
    
    print_success "Tous les caches supprimés"
}

# 3. SAUVEGARDE ET CRÉATION DES DOSSIERS
setup_directories() {
    print_step "3. Préparation des dossiers"
    
    # Sauvegarde si le fichier existe
    if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
        cp src/components/language/LanguageDropdown.tsx src/components/language/LanguageDropdown.tsx.backup.$(date +%Y%m%d_%H%M%S)
        print_success "Ancienne version sauvegardée"
    fi
    
    mkdir -p src/components/language
    mkdir -p src/contexts
    mkdir -p src/hooks
    mkdir -p src/types
    mkdir -p src/examples
    
    print_success "Structure créée"
}

# 4. INSTALLATION DES DÉPENDANCES
install_dependencies() {
    print_step "4. Vérification des dépendances"
    
    if ! npm list lucide-react > /dev/null 2>&1; then
        print_warning "Installation de lucide-react..."
        npm install lucide-react --legacy-peer-deps --silent
    fi
    
    print_success "Dépendances vérifiées"
}

# 5. CRÉATION DU COMPOSANT COMPLET AVEC TOUTES LES FONCTIONNALITÉS
create_complete_component() {
    print_step "5. Création du composant complet avec toutes les fonctionnalités"
    
    cat > src/components/language/LanguageDropdown.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X, Check, Star, MapPin } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  region: string
  popular?: boolean
  searchTerms?: string[]
}

const LANGUAGES: Language[] = [
  // ⭐ LANGUES POPULAIRES
  { 
    code: 'fr', 
    name: 'Français', 
    nativeName: 'Français', 
    flag: '🇫🇷', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['french', 'france', 'francais']
  },
  { 
    code: 'en', 
    name: 'English', 
    nativeName: 'English', 
    flag: '🇺🇸', 
    region: 'Amérique', 
    popular: true,
    searchTerms: ['anglais', 'english', 'usa', 'america']
  },
  { 
    code: 'es', 
    name: 'Español', 
    nativeName: 'Español', 
    flag: '🇪🇸', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['spanish', 'spain', 'espagne', 'espagnol']
  },
  { 
    code: 'de', 
    name: 'Deutsch', 
    nativeName: 'Deutsch', 
    flag: '🇩🇪', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['german', 'germany', 'allemand', 'allemagne']
  },
  { 
    code: 'it', 
    name: 'Italiano', 
    nativeName: 'Italiano', 
    flag: '🇮🇹', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['italian', 'italy', 'italien', 'italie']
  },
  { 
    code: 'pt', 
    name: 'Português', 
    nativeName: 'Português', 
    flag: '🇵🇹', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['portuguese', 'portugal', 'portugais', 'brasil']
  },
  
  // 🌍 AUTRES LANGUES PAR RÉGION
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', searchTerms: ['russian', 'russia', 'russe'] },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe', searchTerms: ['polish', 'poland', 'polonais'] },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe', searchTerms: ['dutch', 'netherlands', 'neerlandais'] },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe', searchTerms: ['swedish', 'sweden', 'suedois'] },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe', searchTerms: ['norwegian', 'norway', 'norvegien'] },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe', searchTerms: ['danish', 'denmark', 'danois'] },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe', searchTerms: ['finnish', 'finland', 'finlandais'] },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe', searchTerms: ['turkish', 'turkey', 'turc'] },
  { code: 'uk', name: 'Українська', nativeName: 'Українська', flag: '🇺🇦', region: 'Europe', searchTerms: ['ukrainian', 'ukraine', 'ukrainien'] },
  
  { code: 'zh', name: '中文 (简体)', nativeName: '中文', flag: '🇨🇳', region: 'Asie', searchTerms: ['chinese', 'china', 'chinois', 'mandarin'] },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie', searchTerms: ['japanese', 'japan', 'japonais'] },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie', searchTerms: ['korean', 'korea', 'coreen'] },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie', searchTerms: ['hindi', 'india', 'indien'] },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asie', searchTerms: ['thai', 'thailand', 'thailandais'] },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asie', searchTerms: ['vietnamese', 'vietnam', 'vietnamien'] },
  { code: 'id', name: 'Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asie', searchTerms: ['indonesian', 'indonesia', 'indonesien'] },
  
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Moyen-Orient', searchTerms: ['arabic', 'arab', 'arabe'] },
  { code: 'he', name: 'עברית', nativeName: 'עברית', flag: '🇮🇱', region: 'Moyen-Orient', searchTerms: ['hebrew', 'israel', 'hebreu'] },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', region: 'Moyen-Orient', searchTerms: ['persian', 'farsi', 'iran', 'persan'] },
]

export default function AdvancedLanguageDropdown() {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedIndex, setSelectedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const buttonRef = useRef<HTMLButtonElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)
  const listRef = useRef<HTMLDivElement>(null)
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([])

  // 🔍 FILTRAGE INTELLIGENT AVEC RECHERCHE ÉTENDUE
  const filteredLanguages = useMemo(() => {
    if (!searchTerm.trim()) return LANGUAGES
    
    const searchLower = searchTerm.toLowerCase().trim()
    
    let filtered = LANGUAGES.filter(lang => {
      // Recherche dans le nom
      const nameMatch = lang.name.toLowerCase().includes(searchLower)
      // Recherche dans le nom natif
      const nativeMatch = lang.nativeName.toLowerCase().includes(searchLower)
      // Recherche dans le code
      const codeMatch = lang.code.toLowerCase().includes(searchLower)
      // Recherche dans les termes étendus
      const termsMatch = lang.searchTerms?.some(term => 
        term.toLowerCase().includes(searchLower)
      )
      
      return nameMatch || nativeMatch || codeMatch || termsMatch
    })
    
    // 📊 TRI INTELLIGENT : populaires d'abord, puis alphabétique
    return filtered.sort((a, b) => {
      // Langues populaires en premier
      if (a.popular && !b.popular) return -1
      if (!a.popular && b.popular) return 1
      
      // Correspondance exacte au début en premier
      const aStartsWith = a.name.toLowerCase().startsWith(searchLower)
      const bStartsWith = b.name.toLowerCase().startsWith(searchLower)
      if (aStartsWith && !bStartsWith) return -1
      if (!aStartsWith && bStartsWith) return 1
      
      // Puis alphabétique
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm])

  // 🌍 GROUPEMENT PAR RÉGION INTELLIGENT
  const groupedLanguages = useMemo(() => {
    const groups: { [region: string]: Language[] } = {}
    
    filteredLanguages.forEach(lang => {
      if (!groups[lang.region]) {
        groups[lang.region] = []
      }
      groups[lang.region].push(lang)
    })
    
    // Ordre des régions avec priorité
    const regionOrder = ['Europe', 'Amérique', 'Asie', 'Moyen-Orient', 'Afrique', 'Océanie']
    const sortedGroups: { [region: string]: Language[] } = {}
    
    regionOrder.forEach(region => {
      if (groups[region]) {
        sortedGroups[region] = groups[region]
      }
    })
    
    // Ajouter les régions restantes
    Object.keys(groups).forEach(region => {
      if (!sortedGroups[region]) {
        sortedGroups[region] = groups[region]
      }
    })
    
    return sortedGroups
  }, [filteredLanguages])

  const closeDropdown = () => {
    setIsOpen(false)
    setSearchTerm('')
    setSelectedIndex(-1)
  }

  // 👆 GESTION DU CLIC EXTÉRIEUR
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        closeDropdown()
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
      // Bloquer le scroll du body
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'unset'
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'unset'
    }
  }, [isOpen])

  // 🔍 FOCUS AUTOMATIQUE SUR LA RECHERCHE
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100)
    }
  }, [isOpen])

  // ⌨️ NAVIGATION CLAVIER COMPLÈTE
  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      if (!isOpen) return

      switch (event.key) {
        case 'Escape':
          closeDropdown()
          buttonRef.current?.focus()
          break
        
        case 'ArrowDown':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev < filteredLanguages.length - 1 ? prev + 1 : 0
            scrollToItem(newIndex)
            return newIndex
          })
          break
        
        case 'ArrowUp':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev > 0 ? prev - 1 : filteredLanguages.length - 1
            scrollToItem(newIndex)
            return newIndex
          })
          break
        
        case 'Enter':
          event.preventDefault()
          if (selectedIndex >= 0 && filteredLanguages[selectedIndex]) {
            handleLanguageSelect(filteredLanguages[selectedIndex])
          }
          break
        
        case 'Home':
          event.preventDefault()
          setSelectedIndex(0)
          scrollToItem(0)
          break
        
        case 'End':
          event.preventDefault()
          const lastIndex = filteredLanguages.length - 1
          setSelectedIndex(lastIndex)
          scrollToItem(lastIndex)
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

  // 📜 SCROLL AUTOMATIQUE VERS L'ÉLÉMENT SÉLECTIONNÉ
  const scrollToItem = (index: number) => {
    if (itemRefs.current[index]) {
      itemRefs.current[index]?.scrollIntoView({
        behavior: 'smooth',
        block: 'nearest',
      })
    }
  }

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]

  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    closeDropdown()
    
    // 📱 Feedback haptic sur mobile
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
  }

  const clearSearch = () => {
    setSearchTerm('')
    setSelectedIndex(-1)
    searchInputRef.current?.focus()
  }

  const getRegionIcon = (region: string) => {
    const icons = {
      'Europe': '🇪🇺',
      'Amérique': '🌎',
      'Asie': '🌏',
      'Moyen-Orient': '🕌',
      'Afrique': '🌍',
      'Océanie': '🏝️'
    }
    return icons[region as keyof typeof icons] || '🌐'
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* 🎯 BOUTON TRIGGER AVEC INDICATEUR VISUEL */}
      <button
        ref={buttonRef}
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20 focus:outline-none focus:ring-2 focus:ring-white/50 relative group"
        aria-expanded={isOpen}
        aria-haspopup="listbox"
        aria-label={`Langue actuelle: ${currentLang.name}. Cliquer pour changer`}
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium hidden sm:inline">{currentLang.name}</span>
        <span className="font-medium sm:hidden">{currentLang.code.toUpperCase()}</span>
        <ChevronDown 
          className={`w-4 h-4 transition-transform duration-200 ${
            isOpen ? 'rotate-180' : ''
          }`} 
        />
        
        {/* 🔴 INDICATEUR VISUEL DE NOUVEAUTÉ */}
        <div className="absolute -top-1 -right-1 w-3 h-3 bg-gradient-to-r from-green-400 to-blue-500 rounded-full animate-pulse shadow-lg">
          <div className="absolute inset-0 bg-white rounded-full animate-ping opacity-40"></div>
        </div>
      </button>

      {/* 🌫️ OVERLAY AVEC BLUR */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={closeDropdown}
        />
      )}

      {/* 📱 DROPDOWN MENU RESPONSIVE */}
      {isOpen && (
        <div className="fixed inset-x-4 top-4 bottom-4 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:w-96 md:max-h-[500px] md:bottom-auto">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden h-full flex flex-col">
            
            {/* 🎨 HEADER AVEC GRADIENT ET RECHERCHE */}
            <div className="px-4 py-3 bg-gradient-to-r from-blue-50 via-purple-50 to-pink-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <div className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-blue-600" />
                  <Star className="w-4 h-4 text-yellow-500 animate-pulse" />
                </div>
                <h3 className="font-semibold text-blue-900">
                  🌟 Nouveau Dropdown - Choisir une langue
                </h3>
                <button
                  onClick={closeDropdown}
                  className="ml-auto p-1 hover:bg-gray-200 rounded-full transition-colors"
                  aria-label="Fermer"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* 🔍 BARRE DE RECHERCHE AMÉLIORÉE */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-blue-500" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => {
                    setSearchTerm(e.target.value)
                    setSelectedIndex(-1)
                  }}
                  placeholder="🔍 Recherche intelligente : 'fr', 'english', '中文', 'арабский'..."
                  className="w-full pl-10 pr-10 py-3 border-2 border-blue-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white shadow-sm placeholder-gray-500"
                />
                {searchTerm && (
                  <button
                    onClick={clearSearch}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 p-1 hover:bg-blue-100 rounded-full transition-colors"
                    aria-label="Effacer la recherche"
                  >
                    <X className="w-3 h-3 text-blue-500" />
                  </button>
                )}
              </div>
              
              {/* 📊 COMPTEUR DE RÉSULTATS */}
              <div className="mt-2 text-xs text-blue-600 bg-blue-100 px-2 py-1 rounded flex items-center gap-1">
                <MapPin className="w-3 h-3" />
                {filteredLanguages.length} langue{filteredLanguages.length !== 1 ? 's' : ''} trouvée{filteredLanguages.length !== 1 ? 's' : ''}
                {searchTerm && ` pour "${searchTerm}"`}
              </div>
            </div>

            {/* 📜 LISTE AVEC GROUPEMENT PAR RÉGION ET SCROLL VISIBLE */}
            <div 
              ref={listRef}
              className="flex-1 overflow-y-auto"
              style={{
                scrollbarWidth: 'thin',
                scrollbarColor: '#3b82f6 #e2e8f0'
              }}
            >
              {Object.keys(groupedLanguages).length === 0 ? (
                <div className="p-6 text-center text-gray-500">
                  <Search className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                  <p className="font-semibold">Aucune langue trouvée</p>
                  <p className="text-sm">Essayez: "français", "english", "中文", "العربية"</p>
                </div>
              ) : (
                Object.entries(groupedLanguages).map(([region, languages]) => (
                  <div key={region} className="mb-2">
                    {/* 🌍 EN-TÊTE DE RÉGION AVEC ICÔNE */}
                    {!searchTerm && (
                      <div className="px-4 py-3 bg-gradient-to-r from-gray-100 to-gray-50 text-sm font-bold text-gray-700 uppercase tracking-wide sticky top-0 z-10 border-l-4 border-blue-500 flex items-center gap-2">
                        <span className="text-lg">{getRegionIcon(region)}</span>
                        {region}
                        <span className="ml-auto text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">
                          {languages.length}
                        </span>
                      </div>
                    )}
                    
                    {/* 🌐 LISTE DES LANGUES */}
                    {languages.map((language) => {
                      const flatIndex = filteredLanguages.indexOf(language)
                      const isSelected = flatIndex === selectedIndex
                      const isCurrent = language.code === currentLanguage
                      
                      return (
                        <button
                          key={language.code}
                          ref={(el) => {
                            itemRefs.current[flatIndex] = el
                          }}
                          onClick={() => handleLanguageSelect(language)}
                          className={`w-full px-4 py-4 text-left transition-all duration-150 flex items-center gap-3 group ${
                            isCurrent 
                              ? 'bg-gradient-to-r from-blue-100 to-purple-100 border-l-4 border-blue-500 shadow-sm' 
                              : isSelected
                              ? 'bg-gradient-to-r from-blue-50 to-purple-50 border-l-4 border-blue-300'
                              : 'border-l-4 border-transparent hover:bg-gradient-to-r hover:from-gray-50 hover:to-gray-100 hover:border-l-4 hover:border-gray-300'
                          }`}
                          role="option"
                          aria-selected={isCurrent}
                        >
                          <span className="text-2xl flex-shrink-0">{language.flag}</span>
                          <div className="flex-1 min-w-0">
                            <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                              {language.name}
                              {language.popular && (
                                <span className="inline-flex items-center gap-1 text-xs bg-gradient-to-r from-yellow-100 to-orange-200 text-orange-800 px-2 py-1 rounded-full font-semibold border border-orange-300">
                                  ⭐ Populaire
                                </span>
                              )}
                            </div>
                            <div className={`text-sm truncate ${isCurrent ? 'text-blue-700' : 'text-gray-500'}`}>
                              {language.nativeName}
                            </div>
                          </div>
                          {isCurrent && (
                            <div className="flex items-center gap-1">
                              <Check className="w-5 h-5 text-blue-500" />
                              <span className="text-xs bg-blue-500 text-white px-2 py-1 rounded-full">
                                Actuelle
                              </span>
                            </div>
                          )}
                        </button>
                      )
                    })}
                  </div>
                ))
              )}
            </div>

            {/* 🎯 FOOTER AVEC STATISTIQUES */}
            <div className="px-4 py-3 bg-gradient-to-r from-green-50 to-blue-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs">
                <span className="text-green-700 font-semibold flex items-center gap-1">
                  <Star className="w-3 h-3" />
                  Nouveau design 2024
                </span>
                <span className="text-blue-600">
                  🌟 {filteredLanguages.length} langues • 100k+ familles
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* 🎨 STYLES CSS POUR LE SCROLLBAR VISIBLE */}
      <style jsx>{`
        .overflow-y-auto::-webkit-scrollbar {
          width: 8px;
        }
        
        .overflow-y-auto::-webkit-scrollbar-track {
          background: #e2e8f0;
          border-radius: 4px;
        }
        
        .overflow-y-auto::-webkit-scrollbar-thumb {
          background: linear-gradient(135deg, #3b82f6, #8b5cf6);
          border-radius: 4px;
          box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .overflow-y-auto::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(135deg, #2563eb, #7c3aed);
        }
      `}</style>
    </div>
  )
}
EOF
    
    print_success "Composant complet créé avec toutes les fonctionnalités"
}

# 6. MISE À JOUR DU CONTEXTE
update_context() {
    print_step "6. Mise à jour du contexte de langue"
    
    cat > src/contexts/LanguageContext.tsx << 'EOF'
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
    'welcome': 'Bienvenue', 
    'select_language': 'Choisir une langue',
    'math_learning': 'Apprentissage des mathématiques',
    'families_trust': '100k+ familles nous font confiance'
  },
  en: { 
    'welcome': 'Welcome', 
    'select_language': 'Choose a language',
    'math_learning': 'Math learning',
    'families_trust': '100k+ families trust us'
  },
  es: { 
    'welcome': 'Bienvenido', 
    'select_language': 'Elegir idioma',
    'math_learning': 'Aprendizaje matemático',
    'families_trust': '100k+ familias confían en nosotros'
  },
  de: { 
    'welcome': 'Willkommen', 
    'select_language': 'Sprache wählen',
    'math_learning': 'Mathematik lernen',
    'families_trust': '100k+ Familien vertrauen uns'
  },
  it: { 
    'welcome': 'Benvenuto', 
    'select_language': 'Scegli lingua',
    'math_learning': 'Apprendimento matematico',
    'families_trust': '100k+ famiglie si fidano di noi'
  },
  pt: { 
    'welcome': 'Bem-vindo', 
    'select_language': 'Escolher idioma',
    'math_learning': 'Aprendizagem matemática',
    'families_trust': '100k+ famílias confiam em nós'
  },
}

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  useEffect(() => {
    // Charger la langue sauvegardée
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    } else {
      // Détecter la langue du navigateur
      const browserLang = navigator.language.split('-')[0]
      if (translations[browserLang]) {
        setCurrentLanguage(browserLang)
      }
    }
  }, [])

  const setLanguage = (lang: string) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child-language', lang)
    
    // Log pour debug
    console.log('🌍 Langue changée vers:', lang)
    
    // Feedback haptic
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
  }

  const t = (key: string): string => {
    return translations[currentLanguage]?.[key] || translations['en']?.[key] || key
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
EOF
    
    print_success "Contexte mis à jour avec debug logs"
}

# 7. INTÉGRATION DANS LE LAYOUT PRINCIPAL
integrate_in_layout() {
    print_step "7. Intégration dans le layout principal"
    
    # Vérifier et mettre à jour le layout
    if [ -f "src/app/layout.tsx" ]; then
        print_warning "Mise à jour du layout existant..."
        
        # Créer une sauvegarde
        cp src/app/layout.tsx src/app/layout.tsx.backup.$(date +%Y%m%d_%H%M%S)
        
        # Ajouter l'import du provider si pas déjà présent
        if ! grep -q "LanguageProvider" src/app/layout.tsx; then
            sed -i.bak '1i\
import { LanguageProvider } from "@/contexts/LanguageContext"
' src/app/layout.tsx
            
            print_success "Import LanguageProvider ajouté au layout"
        fi
    fi
    
    # Créer une page d'exemple
    cat > src/examples/LanguageDropdownDemo.tsx << 'EOF'
'use client'

import { LanguageProvider, useLanguage } from '@/contexts/LanguageContext'
import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'
import { Globe, Users, Star } from 'lucide-react'

function DemoContent() {
  const { currentLanguage, t } = useLanguage()

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600">
      {/* Header avec dropdown intégré */}
      <header className="p-6">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <span className="text-white font-bold text-lg">M4C</span>
            </div>
            <div>
              <h1 className="text-white text-xl font-bold">Math4Child</h1>
              <p className="text-white/70 text-sm">
                {t('math_learning')} • Langue: {currentLanguage.toUpperCase()}
              </p>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="hidden md:flex items-center gap-2 text-white/80 bg-white/10 px-3 py-2 rounded-lg backdrop-blur-sm">
              <Users className="w-4 h-4" />
              <span className="text-sm">{t('families_trust')}</span>
            </div>
            {/* 🌟 NOUVEAU DROPDOWN INTÉGRÉ */}
            <AdvancedLanguageDropdown />
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-6 pb-12">
        <div className="max-w-4xl mx-auto text-center">
          <div className="mb-8">
            <h2 className="text-4xl md:text-6xl font-bold text-white mb-4">
              {t('welcome')} !
            </h2>
            <p className="text-xl text-white/80 mb-8">
              🌟 Nouveau dropdown avec recherche intelligente, groupement par région et scroll visible !
            </p>
          </div>

          {/* Fonctionnalités */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Globe className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">20+ langues</div>
              <div className="text-white/80">Avec recherche intelligente</div>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Star className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">Scroll visible</div>
              <div className="text-white/80">Barre de défilement stylisée</div>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Users className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">
                {currentLanguage.toUpperCase()}
              </div>
              <div className="text-white/80">Langue actuelle</div>
            </div>
          </div>

          {/* Instructions */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
            <h3 className="text-2xl font-bold text-white mb-6">
              🎮 Testez maintenant !
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-left">
              <div className="space-y-3">
                <h4 className="font-semibold text-white text-lg">🔍 Recherche intelligente :</h4>
                <ul className="text-white/80 space-y-2">
                  <li>• Tapez "fr" → Français</li>
                  <li>• Tapez "eng" → English</li>
                  <li>• Tapez "chinese" → 中文</li>
                  <li>• Tapez "арабский" → العربية</li>
                </ul>
              </div>
              
              <div className="space-y-3">
                <h4 className="font-semibold text-white text-lg">⌨️ Navigation clavier :</h4>
                <ul className="text-white/80 space-y-2">
                  <li>• ↑↓ : Naviguer dans la liste</li>
                  <li>• Enter : Sélectionner</li>
                  <li>• Escape : Fermer</li>
                  <li>• Home/End : Premier/Dernier</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}

export default function LanguageDropdownDemo() {
  return (
    <LanguageProvider>
      <DemoContent />
    </LanguageProvider>
  )
}
EOF
    
    print_success "Page de démonstration créée"
}

# 8. CRÉATION D'UN SCRIPT DE TEST
create_test_script() {
    print_step "8. Création d'un script de test"
    
    mkdir -p scripts
    
    cat > scripts/test-dropdown-fix.sh << 'EOF'
#!/bin/bash

echo "🧪 TEST DU DROPDOWN CORRIGÉ"
echo "=========================="

# Vérifier les fichiers créés
files=(
    "src/components/language/LanguageDropdown.tsx"
    "src/contexts/LanguageContext.tsx" 
    "src/examples/LanguageDropdownDemo.tsx"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
        lines=$(wc -l < "$file")
        echo "   └── $lines lignes"
    else
        echo "❌ $file manquant"
    fi
done

echo ""
echo "🔍 Vérification des fonctionnalités:"

if grep -q "groupedLanguages" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Groupement par région"
else
    echo "❌ Groupement par région manquant"
fi

if grep -q "searchTerms" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Recherche intelligente"
else
    echo "❌ Recherche intelligente manquante"
fi

if grep -q "scrollbar" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Scroll visible et stylisé"
else
    echo "❌ Scroll visible manquant"
fi

if grep -q "Populaire" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Badges populaires"
else
    echo "❌ Badges populaires manquants"
fi

echo ""
echo "📦 Dépendances:"
npm list lucide-react > /dev/null 2>&1 && echo "✅ lucide-react" || echo "❌ lucide-react manquant"

echo ""
echo "🎯 Nouvelles fonctionnalités testables:"
echo "• 🔍 Recherche étendue avec termes multiples"
echo "• 🌍 Groupement par région avec icônes"
echo "• ⭐ Langues populaires avec badges"
echo "• 📜 Scroll visible avec style gradient"
echo "• ⌨️ Navigation clavier complète"
echo "• 📱 Interface responsive améliorée"
echo "• 🎨 Design moderne avec gradients"
echo ""
echo "🚀 Pour tester: npm run dev puis aller sur la page"
EOF

    chmod +x scripts/test-dropdown-fix.sh
    
    print_success "Script de test créé"
}

# 9. INSTRUCTIONS FINALES
show_completion_summary() {
    print_step "9. Résumé final"
    
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}                ${GREEN}✅ CORRECTION COMPLÈTE TERMINÉE${NC}                    ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}🎉 NOUVELLES FONCTIONNALITÉS AJOUTÉES :${NC}"
    echo -e "${CYAN}   ✅ Groupement par région avec icônes${NC}"
    echo -e "${CYAN}   ✅ Recherche intelligente étendue${NC}"
    echo -e "${CYAN}   ✅ Scroll visible et stylisé${NC}"
    echo -e "${CYAN}   ✅ Badges populaires animés${NC}"
    echo -e "${CYAN}   ✅ Navigation clavier complète${NC}"
    echo -e "${CYAN}   ✅ Interface moderne avec gradients${NC}"
    echo -e "${CYAN}   ✅ Responsive design amélioré${NC}"
    echo -e "${CYAN}   ✅ Feedback haptic mobile${NC}"
    echo ""
    
    echo -e "${YELLOW}🎮 CONTRÔLES DE TEST :${NC}"
    echo -e "${BLUE}   • Recherche: 'fr', 'english', '中文', 'арабский'${NC}"
    echo -e "${BLUE}   • Clavier: ↑↓ Enter Escape Home End${NC}"
    echo -e "${BLUE}   • Scroll: Barre visible avec gradient${NC}"
    echo -e "${BLUE}   • Régions: Europe, Asie, Moyen-Orient${NC}"
    echo ""
    
    echo -e "${GREEN}🚀 ÉTAPES SUIVANTES :${NC}"
    echo -e "${BLUE}   1. Redémarrez: npm run dev${NC}"
    echo -e "${BLUE}   2. Videz le cache navigateur: Ctrl+Shift+R${NC}"
    echo -e "${BLUE}   3. Testez: ./scripts/test-dropdown-fix.sh${NC}"
    echo -e "${BLUE}   4. Page demo: /examples/LanguageDropdownDemo${NC}"
    echo ""
    
    echo -e "${PURPLE}⭐ DROPDOWN LANGUAGE CORRIGÉ ET AMÉLIORÉ ! ⭐${NC}"
}

# FONCTION PRINCIPALE
main() {
    print_header
    
    check_environment
    clear_all_caches
    setup_directories
    install_dependencies
    create_complete_component
    update_context
    integrate_in_layout
    create_test_script
    show_completion_summary
}

# Exécution
main "$@"