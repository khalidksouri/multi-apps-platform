#!/bin/bash

# =============================================================================
# 🚀 MISE À JOUR VERS DROPDOWN AVANCÉ - Math4Child
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
    echo -e "${PURPLE}║${NC}        ${CYAN}🚀 MISE À JOUR VERS DROPDOWN AVANCÉ - Math4Child${NC}           ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}     ${YELLOW}Recherche + Régions + Scroll + Design Moderne${NC}               ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# 1. VÉRIFICATION ET NAVIGATION
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
}

# 2. SAUVEGARDE DE LA VERSION ACTUELLE
backup_current_version() {
    print_step "2. Sauvegarde de la version actuelle"
    
    if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
        cp src/components/language/LanguageDropdown.tsx src/components/language/LanguageDropdown.tsx.backup.$(date +%Y%m%d_%H%M%S)
        print_success "Version actuelle sauvegardée"
    fi
}

# 3. ARRÊT DES SERVEURS ET NETTOYAGE
clean_environment() {
    print_step "3. Nettoyage de l'environnement"
    
    # Arrêter les serveurs
    pkill -f "next dev" 2>/dev/null || true
    pkill -f "node.*next" 2>/dev/null || true
    
    # Nettoyer les caches
    rm -rf .next node_modules/.cache
    npm cache clean --force --silent
    
    print_success "Environnement nettoyé"
}

# 4. REMPLACEMENT PAR LA VERSION AVANCÉE
install_advanced_version() {
    print_step "4. Installation de la version avancée"
    
    cat > src/components/language/LanguageDropdown.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X, Check, Star, MapPin, Sparkles } from 'lucide-react'
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
  // ⭐ LANGUES POPULAIRES avec badges
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
    searchTerms: ['anglais', 'english', 'usa', 'america', 'united states']
  },
  { 
    code: 'es', 
    name: 'Español', 
    nativeName: 'Español', 
    flag: '🇪🇸', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['spanish', 'spain', 'espagne', 'espagnol', 'castilian']
  },
  { 
    code: 'de', 
    name: 'Deutsch', 
    nativeName: 'Deutsch', 
    flag: '🇩🇪', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['german', 'germany', 'allemand', 'allemagne', 'deutschland']
  },
  { 
    code: 'it', 
    name: 'Italiano', 
    nativeName: 'Italiano', 
    flag: '🇮🇹', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['italian', 'italy', 'italien', 'italie', 'italia']
  },
  { 
    code: 'pt', 
    name: 'Português', 
    nativeName: 'Português', 
    flag: '🇵🇹', 
    region: 'Europe', 
    popular: true,
    searchTerms: ['portuguese', 'portugal', 'portugais', 'brasil', 'brazil']
  },
  
  // 🌍 EUROPE
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', searchTerms: ['russian', 'russia', 'russe', 'russie'] },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe', searchTerms: ['polish', 'poland', 'polonais', 'pologne'] },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe', searchTerms: ['dutch', 'netherlands', 'neerlandais', 'holland'] },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe', searchTerms: ['swedish', 'sweden', 'suedois', 'suede'] },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe', searchTerms: ['norwegian', 'norway', 'norvegien', 'norvege'] },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe', searchTerms: ['danish', 'denmark', 'danois', 'danemark'] },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe', searchTerms: ['finnish', 'finland', 'finlandais', 'finlande'] },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe', searchTerms: ['turkish', 'turkey', 'turc', 'turquie'] },
  { code: 'uk', name: 'Українська', nativeName: 'Українська', flag: '🇺🇦', region: 'Europe', searchTerms: ['ukrainian', 'ukraine', 'ukrainien'] },
  { code: 'cs', name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe', searchTerms: ['czech', 'czechia', 'tcheque'] },
  { code: 'hu', name: 'Magyar', nativeName: 'Magyar', flag: '🇭🇺', region: 'Europe', searchTerms: ['hungarian', 'hungary', 'hongrois', 'hongrie'] },
  { code: 'ro', name: 'Română', nativeName: 'Română', flag: '🇷🇴', region: 'Europe', searchTerms: ['romanian', 'romania', 'roumain', 'roumanie'] },
  { code: 'bg', name: 'Български', nativeName: 'Български', flag: '🇧🇬', region: 'Europe', searchTerms: ['bulgarian', 'bulgaria', 'bulgare', 'bulgarie'] },
  { code: 'hr', name: 'Hrvatski', nativeName: 'Hrvatski', flag: '🇭🇷', region: 'Europe', searchTerms: ['croatian', 'croatia', 'croate', 'croatie'] },
  { code: 'sk', name: 'Slovenčina', nativeName: 'Slovenčina', flag: '🇸🇰', region: 'Europe', searchTerms: ['slovak', 'slovakia', 'slovaque', 'slovaquie'] },
  { code: 'el', name: 'Ελληνικά', nativeName: 'Ελληνικά', flag: '🇬🇷', region: 'Europe', searchTerms: ['greek', 'greece', 'grec', 'grece'] },
  
  // 🌏 ASIE
  { code: 'zh', name: '中文 (简体)', nativeName: '中文', flag: '🇨🇳', region: 'Asie', searchTerms: ['chinese', 'china', 'chinois', 'mandarin', 'simplified'] },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie', searchTerms: ['japanese', 'japan', 'japonais', 'nippon'] },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie', searchTerms: ['korean', 'korea', 'coreen', 'coree'] },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie', searchTerms: ['hindi', 'india', 'indien', 'inde'] },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asie', searchTerms: ['thai', 'thailand', 'thailandais', 'thailande'] },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asie', searchTerms: ['vietnamese', 'vietnam', 'vietnamien'] },
  { code: 'id', name: 'Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asie', searchTerms: ['indonesian', 'indonesia', 'indonesien'] },
  { code: 'ms', name: 'Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asie', searchTerms: ['malay', 'malaysia', 'malaisie'] },
  
  // 🕌 MOYEN-ORIENT
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Moyen-Orient', searchTerms: ['arabic', 'arab', 'arabe'] },
  { code: 'he', name: 'עברית', nativeName: 'עברית', flag: '🇮🇱', region: 'Moyen-Orient', searchTerms: ['hebrew', 'israel', 'hebreu'] },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', region: 'Moyen-Orient', searchTerms: ['persian', 'farsi', 'iran', 'persan'] },
  
  // 🌎 AMÉRIQUE  
  { code: 'pt-br', name: 'Português (Brasil)', nativeName: 'Português', flag: '🇧🇷', region: 'Amérique', searchTerms: ['brazilian', 'brasil', 'bresil'] },
  { code: 'es-mx', name: 'Español (México)', nativeName: 'Español', flag: '🇲🇽', region: 'Amérique', searchTerms: ['mexican', 'mexico', 'mexique'] },
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

  // 🔍 FILTRAGE INTELLIGENT AVANCÉ
  const filteredLanguages = useMemo(() => {
    if (!searchTerm.trim()) return LANGUAGES
    
    const searchLower = searchTerm.toLowerCase().trim()
    
    let filtered = LANGUAGES.filter(lang => {
      // Recherche dans le nom principal
      const nameMatch = lang.name.toLowerCase().includes(searchLower)
      // Recherche dans le nom natif
      const nativeMatch = lang.nativeName.toLowerCase().includes(searchLower)
      // Recherche dans le code de langue
      const codeMatch = lang.code.toLowerCase().includes(searchLower)
      // Recherche dans les termes étendus
      const termsMatch = lang.searchTerms?.some(term => 
        term.toLowerCase().includes(searchLower)
      )
      
      return nameMatch || nativeMatch || codeMatch || termsMatch
    })
    
    // 📊 TRI INTELLIGENT : populaires d'abord, correspondance exacte, puis alphabétique
    return filtered.sort((a, b) => {
      // 1. Langues populaires en premier
      if (a.popular && !b.popular) return -1
      if (!a.popular && b.popular) return 1
      
      // 2. Correspondance exacte au début du nom
      const aStartsWith = a.name.toLowerCase().startsWith(searchLower)
      const bStartsWith = b.name.toLowerCase().startsWith(searchLower)
      if (aStartsWith && !bStartsWith) return -1
      if (!aStartsWith && bStartsWith) return 1
      
      // 3. Correspondance exacte du code
      const aCodeExact = a.code.toLowerCase() === searchLower
      const bCodeExact = b.code.toLowerCase() === searchLower
      if (aCodeExact && !bCodeExact) return -1
      if (!aCodeExact && bCodeExact) return 1
      
      // 4. Ordre alphabétique
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
      {/* 🎯 BOUTON TRIGGER AVEC INDICATEURS VISUELS */}
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
        
        {/* 🔴 INDICATEUR VISUEL DE NOUVELLE VERSION */}
        <div className="absolute -top-1 -right-1 w-3 h-3 bg-gradient-to-r from-green-400 to-blue-500 rounded-full animate-pulse shadow-lg">
          <div className="absolute inset-0 bg-white rounded-full animate-ping opacity-40"></div>
        </div>
        
        {/* ⭐ BADGE "NOUVEAU" */}
        <div className="absolute -top-2 -left-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white text-xs px-1.5 py-0.5 rounded-full font-bold animate-bounce">
          NEW
        </div>
      </button>

      {/* 🌫️ OVERLAY AVEC BLUR */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={closeDropdown}
        />
      )}

      {/* 📱 DROPDOWN MENU ULTRA-MODERNE */}
      {isOpen && (
        <div className="fixed inset-x-4 top-4 bottom-4 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:w-96 md:max-h-[600px] md:bottom-auto">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden h-full flex flex-col backdrop-blur-lg">
            
            {/* 🎨 HEADER AVEC GRADIENT ET RECHERCHE */}
            <div className="px-4 py-3 bg-gradient-to-r from-blue-50 via-purple-50 to-pink-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <div className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-blue-600" />
                  <Sparkles className="w-4 h-4 text-yellow-500 animate-pulse" />
                </div>
                <h3 className="font-semibold text-blue-900 flex items-center gap-2">
                  🌟 Nouveau Dropdown Avancé
                  <span className="text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">
                    v2.0
                  </span>
                </h3>
                <button
                  onClick={closeDropdown}
                  className="ml-auto p-1 hover:bg-gray-200 rounded-full transition-colors"
                  aria-label="Fermer"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* 🔍 BARRE DE RECHERCHE INTELLIGENTE */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-blue-500 animate-pulse" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => {
                    setSearchTerm(e.target.value)
                    setSelectedIndex(-1)
                  }}
                  placeholder="🔍 Recherche intelligente: 'fr', 'english', '中文', 'العربية', 'deutschland'..."
                  className="w-full pl-10 pr-10 py-3 border-2 border-blue-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white shadow-sm placeholder-gray-500 transition-all duration-200"
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
              
              {/* 📊 COMPTEUR DE RÉSULTATS AVEC ANIMATION */}
              <div className="mt-2 text-xs text-blue-600 bg-blue-100 px-2 py-1 rounded flex items-center gap-1 transition-all duration-200">
                <MapPin className="w-3 h-3" />
                <span className="font-semibold">
                  {filteredLanguages.length} langue{filteredLanguages.length !== 1 ? 's' : ''} trouvée{filteredLanguages.length !== 1 ? 's' : ''}
                </span>
                {searchTerm && (
                  <span className="text-blue-800">
                    pour "{searchTerm}"
                  </span>
                )}
              </div>
            </div>

            {/* 📜 LISTE AVEC GROUPEMENT AVANCÉ ET SCROLL VISIBLE */}
            <div 
              ref={listRef}
              className="flex-1 overflow-y-auto custom-scrollbar"
              style={{
                scrollbarWidth: 'thin',
                scrollbarColor: '#3b82f6 #e2e8f0'
              }}
            >
              {Object.keys(groupedLanguages).length === 0 ? (
                <div className="p-6 text-center text-gray-500">
                  <Search className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                  <p className="font-semibold">Aucune langue trouvée</p>
                  <p className="text-sm">Essayez: "français", "english", "中文", "العربية", "deutschland"</p>
                </div>
              ) : (
                Object.entries(groupedLanguages).map(([region, languages]) => (
                  <div key={region} className="mb-2">
                    {/* 🌍 EN-TÊTE DE RÉGION AVEC ICÔNE ET ANIMATION */}
                    {!searchTerm && (
                      <div className="px-4 py-3 bg-gradient-to-r from-gray-100 to-gray-50 text-sm font-bold text-gray-700 uppercase tracking-wide sticky top-0 z-10 border-l-4 border-blue-500 flex items-center gap-2 hover:from-blue-50 hover:to-purple-50 transition-all duration-200">
                        <span className="text-lg animate-bounce">{getRegionIcon(region)}</span>
                        <span className="flex-1">{region}</span>
                        <span className="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full font-normal">
                          {languages.length} langue{languages.length !== 1 ? 's' : ''}
                        </span>
                      </div>
                    )}
                    
                    {/* 🌐 LISTE DES LANGUES AVEC DESIGN MODERNE */}
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
                          className={`w-full px-4 py-4 text-left transition-all duration-200 flex items-center gap-3 group hover:shadow-sm ${
                            isCurrent 
                              ? 'bg-gradient-to-r from-blue-100 via-purple-100 to-pink-100 border-l-4 border-blue-500 shadow-md' 
                              : isSelected
                              ? 'bg-gradient-to-r from-blue-50 via-purple-50 to-pink-50 border-l-4 border-blue-300 shadow-sm'
                              : 'border-l-4 border-transparent hover:bg-gradient-to-r hover:from-gray-50 hover:to-blue-50 hover:border-l-4 hover:border-gray-300'
                          }`}
                          role="option"
                          aria-selected={isCurrent}
                        >
                          <span className="text-2xl flex-shrink-0 group-hover:scale-110 transition-transform duration-200">
                            {language.flag}
                          </span>
                          <div className="flex-1 min-w-0">
                            <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                              {language.name}
                              {language.popular && (
                                <span className="inline-flex items-center gap-1 text-xs bg-gradient-to-r from-yellow-100 to-orange-200 text-orange-800 px-2 py-1 rounded-full font-semibold border border-orange-300 animate-pulse">
                                  <Star className="w-3 h-3" />
                                  Populaire
                                </span>
                              )}
                            </div>
                            <div className={`text-sm truncate ${isCurrent ? 'text-blue-700' : 'text-gray-500'} transition-colors duration-200`}>
                              {language.nativeName}
                            </div>
                          </div>
                          {isCurrent && (
                            <div className="flex items-center gap-1 animate-pulse">
                              <Check className="w-5 h-5 text-blue-500" />
                              <span className="text-xs bg-blue-500 text-white px-2 py-1 rounded-full font-semibold">
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

            {/* 🎯 FOOTER AVEC STATISTIQUES ET ANIMATION */}
            <div className="px-4 py-3 bg-gradient-to-r from-green-50 to-blue-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs">
                <span className="text-green-700 font-semibold flex items-center gap-1">
                  <Sparkles className="w-3 h-3 animate-spin" />
                  Design Moderne 2024
                </span>
                <span className="text-blue-600 font-medium">
                  🌟 {filteredLanguages.length} langues • 100k+ familles • v2.0
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* 🎨 STYLES CSS PERSONNALISÉS POUR SCROLLBAR VISIBLE */}
      <style jsx>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 8px;
        }
        
        .custom-scrollbar::-webkit-scrollbar-track {
          background: linear-gradient(135deg, #e2e8f0, #f1f5f9);
          border-radius: 4px;
        }
        
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: linear-gradient(135deg, #3b82f6, #8b5cf6, #ec4899);
          border-radius: 4px;
          box-shadow: inset 0 1px 3px rgba(0,0,0,0.2);
          border: 1px solid rgba(255,255,255,0.2);
        }
        
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(135deg, #2563eb, #7c3aed, #db2777);
          box-shadow: inset 0 1px 5px rgba(0,0,0,0.3);
        }
        
        .custom-scrollbar::-webkit-scrollbar-thumb:active {
          background: linear-gradient(135deg, #1d4ed8, #6d28d9, #be185d);
        }
      `}</style>
    </div>
  )
}
EOF
    
    print_success "Version avancée installée avec toutes les fonctionnalités"
}

# 5. TEST DE VALIDATION
validate_installation() {
    print_step "5. Validation de l'installation"
    
    # Vérifier la présence des fonctionnalités
    if grep -q "searchTerms" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Recherche intelligente"
    else
        print_error "❌ Recherche intelligente manquante"
    fi
    
    if grep -q "groupedLanguages" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Groupement par région"
    else
        print_error "❌ Groupement par région manquant"
    fi
    
    if grep -q "popular" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Badges populaires"
    else
        print_error "❌ Badges populaires manquants"
    fi
    
    if grep -q "custom-scrollbar" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Scroll personnalisé"
    else
        print_error "❌ Scroll personnalisé manquant"
    fi
    
    # Compter les lignes
    lines=$(wc -l < src/components/language/LanguageDropdown.tsx)
    if [ "$lines" -gt 400 ]; then
        print_success "✅ Version complète ($lines lignes)"
    else
        print_warning "⚠️  Version potentiellement incomplète ($lines lignes)"
    fi
}

# 6. CRÉATION D'UN SCRIPT DE TEST
create_validation_script() {
    print_step "6. Création du script de validation"
    
    mkdir -p scripts
    
    cat > scripts/test-advanced-features.sh << 'EOF'
#!/bin/bash

echo "🧪 TEST DES FONCTIONNALITÉS AVANCÉES"
echo "===================================="

echo ""
echo "🔍 Recherche intelligente à tester:"
echo "• Tapez 'fr' → Trouve Français"
echo "• Tapez 'eng' ou 'english' → Trouve English" 
echo "• Tapez 'chin' ou 'chinese' → Trouve 中文"
echo "• Tapez 'germ' ou 'deutschland' → Trouve Deutsch"
echo "• Tapez 'arab' ou 'العربية' → Trouve العربية"
echo ""

echo "🌍 Groupement par région à vérifier:"
echo "• Section Europe 🇪🇺 avec compteur"
echo "• Section Asie 🌏 avec compteur"
echo "• Section Moyen-Orient 🕌 avec compteur"
echo "• Section Amérique 🌎 avec compteur"
echo ""

echo "⭐ Badges populaires à voir:"
echo "• Français - Badge 'Populaire'"
echo "• English - Badge 'Populaire'"
echo "• Español - Badge 'Populaire'"
echo "• Deutsch - Badge 'Populaire'"
echo "• Italiano - Badge 'Populaire'"
echo "• Português - Badge 'Populaire'"
echo ""

echo "📜 Scroll visible à vérifier:"
echo "• Barre de défilement colorée (bleu/violet/rose)"
echo "• Hover effect sur la scrollbar"
echo "• Scroll automatique vers sélection"
echo ""

echo "⌨️ Navigation clavier:"
echo "• ↑↓ : Naviguer"
echo "• Enter : Sélectionner"
echo "• Escape : Fermer"
echo "• Home/End : Premier/Dernier"
echo ""

echo "🎨 Éléments visuels modernes:"
echo "• Point vert clignotant sur bouton"
echo "• Badge 'NEW' orange sur bouton"
echo "• Header avec gradient bleu/violet/rose"
echo "• Footer avec stats animées"
echo "• Icônes animées (bounce, pulse, spin)"
echo ""

echo "✨ Si vous voyez tous ces éléments = VERSION AVANCÉE OK ✨"
echo "❌ Si certains manquent = Videz le cache navigateur !"
EOF

    chmod +x scripts/test-advanced-features.sh
    
    print_success "Script de validation créé"
}

# 7. INSTRUCTIONS FINALES
show_final_instructions() {
    print_step "7. Instructions finales"
    
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}              ${GREEN}✅ MISE À JOUR VERS VERSION AVANCÉE TERMINÉE${NC}            ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}🎉 NOUVELLES FONCTIONNALITÉS AJOUTÉES :${NC}"
    echo -e "${CYAN}   🔍 Recherche intelligente avec termes étendus${NC}"
    echo -e "${CYAN}   🌍 Groupement par région avec icônes animées${NC}"
    echo -e "${CYAN}   ⭐ Badges populaires avec animations${NC}"
    echo -e "${CYAN}   📜 Scroll visible avec gradient coloré${NC}"
    echo -e "${CYAN}   🎨 Design moderne avec animations${NC}"
    echo -e "${CYAN}   ⌨️ Navigation clavier complète${NC}"
    echo -e "${CYAN}   📱 Interface responsive optimisée${NC}"
    echo -e "${CYAN}   🔴 Indicateurs visuels sur le bouton${NC}"
    echo ""
    
    echo -e "${YELLOW}🚨 ÉTAPES OBLIGATOIRES MAINTENANT :${NC}"
    echo -e "${BLUE}   1. 🔄 Redémarrer: npm run dev${NC}"
    echo -e "${BLUE}   2. 🧹 Vider cache: Ctrl+Shift+R ou mode incognito${NC}"
    echo -e "${BLUE}   3. 🧪 Tester: ./scripts/test-advanced-features.sh${NC}"
    echo ""
    
    echo -e "${GREEN}🎯 ÉLÉMENTS À VÉRIFIER VISUELLEMENT :${NC}"
    echo -e "${CYAN}   • Point vert clignotant + badge 'NEW' sur bouton${NC}"
    echo -e "${CYAN}   • Barre de recherche avec placeholder détaillé${NC}"
    echo -e "${CYAN}   • Sections de région avec emojis et compteurs${NC}"
    echo -e "${CYAN}   • Badges 'Populaire' jaunes/oranges animés${NC}"
    echo -e "${CYAN}   • Scrollbar colorée (bleu/violet/rose)${NC}"
    echo -e "${CYAN}   • Header et footer avec gradients${NC}"
    echo ""
    
    echo -e "${PURPLE}⭐ VOTRE DROPDOWN EST MAINTENANT EN VERSION AVANCÉE ! ⭐${NC}"
}

# FONCTION PRINCIPALE
main() {
    print_header
    
    check_environment
    backup_current_version
    clean_environment
    install_advanced_version
    validate_installation
    create_validation_script
    show_final_instructions
}

# Exécution
main "$@"