#!/bin/bash

# =============================================================================
# 🕵️ DIAGNOSTIC APPROFONDI ET REMPLACEMENT FORCÉ DU DROPDOWN
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo -e "${PURPLE}🕵️ DIAGNOSTIC APPROFONDI DU DROPDOWN${NC}"
echo "======================================"

# 1. NAVIGATION
print_step "1. Navigation et détection de tous les fichiers LanguageDropdown"

if [ -d "apps/math4child" ]; then
    cd apps/math4child
    print_success "Dans: $(pwd)"
elif [ -f "package.json" ] && grep -q "math4child" package.json; then
    print_success "Déjà dans Math4Child"
else
    print_error "Projet Math4Child non trouvé"
    exit 1
fi

# 2. RECHERCHE DE TOUS LES FICHIERS LANGUAGEDROPDOWN
print_step "2. Recherche de TOUS les fichiers LanguageDropdown dans le projet"

echo "Recherche dans tout le projet..."
find . -name "*LanguageDropdown*" -type f 2>/dev/null || true
find . -name "*language*dropdown*" -type f 2>/dev/null || true

# Rechercher aussi dans les imports
print_step "3. Recherche des imports de LanguageDropdown"
grep -r "LanguageDropdown" --include="*.tsx" --include="*.ts" --include="*.jsx" --include="*.js" . 2>/dev/null | head -10 || true

# 4. VÉRIFICATION DU CONTENU DU FICHIER ACTUEL
print_step "4. Analyse détaillée du fichier actuel"

if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
    echo "📁 Fichier trouvé: src/components/language/LanguageDropdown.tsx"
    
    # Afficher les premières lignes
    echo "🔍 Premières lignes du fichier:"
    head -10 src/components/language/LanguageDropdown.tsx
    
    echo ""
    echo "🔍 Dernières lignes du fichier:"
    tail -10 src/components/language/LanguageDropdown.tsx
    
    # Statistiques
    lines=$(wc -l < src/components/language/LanguageDropdown.tsx)
    chars=$(wc -c < src/components/language/LanguageDropdown.tsx)
    echo "📊 Statistiques: $lines lignes, $chars caractères"
    
    # Recherche de mots-clés spécifiques
    echo ""
    echo "🔍 Vérification des fonctionnalités:"
    grep -c "Search" src/components/language/LanguageDropdown.tsx || echo "❌ Search: 0 occurrences"
    grep -c "popular" src/components/language/LanguageDropdown.tsx || echo "❌ popular: 0 occurrences"
    grep -c "region" src/components/language/LanguageDropdown.tsx || echo "❌ region: 0 occurrences"
    grep -c "searchTerm" src/components/language/LanguageDropdown.tsx || echo "❌ searchTerm: 0 occurrences"
    grep -c "groupedLanguages" src/components/language/LanguageDropdown.tsx || echo "❌ groupedLanguages: 0 occurrences"
    
else
    print_error "❌ Fichier src/components/language/LanguageDropdown.tsx non trouvé"
fi

# 5. VÉRIFICATION DES AUTRES EMPLACEMENTS POSSIBLES
print_step "5. Vérification d'autres emplacements possibles"

possible_locations=(
    "components/language/LanguageDropdown.tsx"
    "src/components/LanguageDropdown.tsx"
    "components/LanguageDropdown.tsx"
    "src/language/LanguageDropdown.tsx"
    "language/LanguageDropdown.tsx"
)

for location in "${possible_locations[@]}"; do
    if [ -f "$location" ]; then
        print_warning "⚠️  Fichier alternatif trouvé: $location"
        echo "Taille: $(wc -l < "$location") lignes"
    fi
done

# 6. VÉRIFICATION DU CACHE NEXT.JS ET NODE_MODULES
print_step "6. Vérification des caches"

if [ -d ".next" ]; then
    print_warning "Cache Next.js présent"
    cache_size=$(du -sh .next | cut -f1)
    echo "Taille du cache: $cache_size"
fi

if [ -d "node_modules/.cache" ]; then
    print_warning "Cache Node.js présent"
fi

# 7. VÉRIFICATION DE L'IMPORT DANS LE LAYOUT
print_step "7. Vérification des imports dans les layouts"

layouts=(
    "src/app/layout.tsx"
    "src/app/layout.js"
    "app/layout.tsx"
    "layout.tsx"
    "src/pages/_app.tsx"
    "pages/_app.tsx"
)

for layout in "${layouts[@]}"; do
    if [ -f "$layout" ]; then
        print_success "Layout trouvé: $layout"
        echo "Imports LanguageDropdown:"
        grep -n "LanguageDropdown\|language.*Dropdown" "$layout" || echo "Aucun import trouvé"
        echo ""
    fi
done

# 8. ARRÊT FORCÉ DU SERVEUR DE DÉVELOPPEMENT
print_step "8. Arrêt forcé du serveur de développement"

# Tuer tous les processus Next.js
pkill -f "next dev" 2>/dev/null || true
pkill -f "next start" 2>/dev/null || true
pkill -f "node.*next" 2>/dev/null || true

print_success "Serveurs Next.js arrêtés"

# 9. SUPPRESSION COMPLÈTE DE TOUS LES CACHES
print_step "9. Suppression complète de tous les caches"

rm -rf .next
rm -rf node_modules/.cache
rm -rf .swc
rm -rf out
rm -rf dist
rm -rf build

# Cache npm
npm cache clean --force

# Cache du système (si sur Mac/Linux)
if [ -d "$HOME/.npm" ]; then
    npm cache verify
fi

print_success "Tous les caches supprimés"

# 10. REMPLACEMENT FORCÉ DU FICHIER AVEC UNE VERSION TRÈS VISIBLE
print_step "10. REMPLACEMENT FORCÉ avec version de test très visible"

# Créer le dossier
mkdir -p src/components/language

# Créer une version avec des éléments très visibles pour s'assurer du changement
cat > src/components/language/LanguageDropdown.tsx << 'EOF'
'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X, Check, Star } from 'lucide-react'
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
  // Langues populaires avec badge
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', popular: true },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Amérique', popular: true },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', popular: true },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', popular: true },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', popular: true },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', popular: true },
  
  // Autres langues par région
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  { code: 'zh', name: '中文 (简体)', nativeName: '中文', flag: '🇨🇳', region: 'Asie' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Moyen-Orient' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
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

  // Grouper par région
  const groupedLanguages = useMemo(() => {
    const groups: { [region: string]: Language[] } = {}
    filteredLanguages.forEach(lang => {
      if (!groups[lang.region]) {
        groups[lang.region] = []
      }
      groups[lang.region].push(lang)
    })
    return groups
  }, [filteredLanguages])

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
            if (itemRefs.current[newIndex]) {
              itemRefs.current[newIndex]?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
            }
            return newIndex
          })
          break
        case 'ArrowUp':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev > 0 ? prev - 1 : filteredLanguages.length - 1
            if (itemRefs.current[newIndex]) {
              itemRefs.current[newIndex]?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
            }
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
    
    // Feedback haptic sur mobile
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton trigger avec indicateur visuel de mise à jour */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20 focus:outline-none focus:ring-2 focus:ring-white/50 relative"
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
        {/* Indicateur visuel que c'est la nouvelle version */}
        <div className="absolute -top-1 -right-1 w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
      </button>

      {/* Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={closeDropdown}
        />
      )}

      {/* Dropdown menu avec header très visible */}
      {isOpen && (
        <div className="fixed inset-x-4 top-4 bottom-4 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:w-96 md:max-h-[500px] md:bottom-auto">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden h-full flex flex-col">
            
            {/* Header avec recherche - VERSION NOUVELLE TRÈS VISIBLE */}
            <div className="px-4 py-3 bg-gradient-to-r from-green-50 to-blue-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <div className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-blue-600" />
                  <Star className="w-4 h-4 text-yellow-500" />
                </div>
                <h3 className="font-semibold text-blue-900">🔍 Nouvelle Version - Rechercher une langue</h3>
                <button
                  onClick={closeDropdown}
                  className="ml-auto p-1 hover:bg-gray-200 rounded-full transition-colors"
                  aria-label="Fermer"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* Barre de recherche TRÈS VISIBLE */}
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
                  placeholder="🔍 Tapez pour rechercher (ex: 'fr', 'english', '中文')..."
                  className="w-full pl-10 pr-10 py-3 border-2 border-blue-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white shadow-sm"
                />
                {searchTerm && (
                  <button
                    onClick={() => setSearchTerm('')}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 p-1 hover:bg-blue-100 rounded-full transition-colors"
                    aria-label="Effacer la recherche"
                  >
                    <X className="w-3 h-3 text-blue-500" />
                  </button>
                )}
              </div>
              
              {/* Compteur de résultats */}
              <div className="mt-2 text-xs text-blue-600 bg-blue-100 px-2 py-1 rounded">
                {filteredLanguages.length} langue{filteredLanguages.length !== 1 ? 's' : ''} trouvée{filteredLanguages.length !== 1 ? 's' : ''}
              </div>
            </div>

            {/* Liste des langues avec groupement TRÈS VISIBLE */}
            <div className="flex-1 overflow-y-auto">
              {Object.keys(groupedLanguages).length === 0 ? (
                <div className="p-6 text-center text-gray-500">
                  <Search className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                  <p className="font-semibold">Aucune langue trouvée</p>
                  <p className="text-sm">Essayez un autre terme de recherche</p>
                </div>
              ) : (
                Object.entries(groupedLanguages).map(([region, languages]) => (
                  <div key={region} className="mb-2">
                    {!searchTerm && (
                      <div className="px-4 py-3 bg-gradient-to-r from-gray-100 to-gray-50 text-sm font-bold text-gray-700 uppercase tracking-wide sticky top-0 z-10 border-l-4 border-blue-500">
                        🌍 {region}
                      </div>
                    )}
                    
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
                              ? 'bg-blue-100 border-l-4 border-blue-500 shadow-sm' 
                              : isSelected
                              ? 'bg-blue-50 border-l-4 border-blue-300'
                              : 'border-l-4 border-transparent hover:bg-gray-50 hover:border-l-4 hover:border-gray-300'
                          }`}
                          role="option"
                          aria-selected={isCurrent}
                        >
                          <span className="text-2xl flex-shrink-0">{language.flag}</span>
                          <div className="flex-1 min-w-0">
                            <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                              {language.name}
                              {language.popular && (
                                <span className="inline-flex items-center gap-1 text-xs bg-gradient-to-r from-green-100 to-green-200 text-green-800 px-2 py-1 rounded-full font-semibold border border-green-300">
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

            {/* Footer avec indication de nouvelle version */}
            <div className="px-4 py-3 bg-gradient-to-r from-green-50 to-blue-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs">
                <span className="text-green-700 font-semibold">
                  ✨ Nouvelle version avec recherche
                </span>
                <span className="text-blue-600">
                  🌟 {filteredLanguages.length} langues • 100k+ familles
                </span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

print_success "🎉 NOUVELLE VERSION ULTRA-VISIBLE INSTALLÉE"

# 11. VÉRIFICATION DU CONTEXTE DE LANGUE
print_step "11. Vérification du contexte de langue"

if [ ! -f "src/contexts/LanguageContext.tsx" ]; then
    print_warning "Contexte de langue manquant - création..."
    mkdir -p src/contexts
    
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
  fr: { 'welcome': 'Bienvenue' },
  en: { 'welcome': 'Welcome' },
  es: { 'welcome': 'Bienvenido' },
  pt: { 'welcome': 'Bem-vindo' },
  de: { 'welcome': 'Willkommen' },
  it: { 'welcome': 'Benvenuto' },
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
    console.log('🌍 Langue changée vers:', lang) // Debug
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
    
    print_success "Contexte de langue créé avec logs de debug"
fi

# 12. INSTALLATION DES DÉPENDANCES
print_step "12. Vérification des dépendances"

if ! npm list lucide-react > /dev/null 2>&1; then
    print_warning "Installation de lucide-react..."
    npm install lucide-react --legacy-peer-deps
fi

# 13. REDÉMARRAGE FORCÉ
print_step "13. INSTRUCTIONS DE REDÉMARRAGE"

echo ""
echo "🎯 ÉTAPES OBLIGATOIRES POUR VOIR LES CHANGEMENTS :"
echo "================================================"
echo ""
echo "1. 🔄 REDÉMARREZ votre serveur de développement :"
echo "   npm run dev"
echo ""
echo "2. 🧹 VIDEZ COMPLÈTEMENT le cache de votre navigateur :"
echo "   • Chrome/Edge: Outils développeur (F12) > Application > Storage > Clear storage"
echo "   • Firefox: F12 > Storage > Clear all"
echo "   • Ou utilisez Ctrl+Shift+Del pour tout effacer"
echo ""
echo "3. 🔄 Rechargez avec Ctrl+Shift+R (ou Cmd+Shift+R sur Mac)"
echo ""
echo "4. 🕵️ Ou ouvrez une fenêtre de navigation privée/incognito"
echo ""
echo "✨ CHANGEMENTS TRÈS VISIBLES À RECHERCHER :"
echo "• 🟢 Point vert clignotant sur le bouton de langue"
echo "• 🔍 Barre de recherche bleue avec placeholder détaillé"
echo "• ⭐ Badges 'Populaire' verts avec étoiles"
echo "• 🌍 Sections de régions avec emojis"
echo "• 🎨 En-tête et pied de page colorés (vert/bleu)"
echo ""
echo "Si vous ne voyez PAS ces éléments, c'est un problème de cache navigateur."

# 14. AFFICHAGE DU CONTENU DU FICHIER POUR CONFIRMATION
print_step "14. Confirmation du nouveau contenu"

echo "🔍 Vérification des nouvelles fonctionnalités dans le fichier:"
grep -c "Point vert clignotant" src/components/language/LanguageDropdown.tsx || echo "❌ Indicateur vert: non trouvé"
grep -c "Nouvelle Version" src/components/language/LanguageDropdown.tsx || echo "❌ Header nouvelle version: non trouvé"
grep -c "Populaire" src/components/language/LanguageDropdown.tsx || echo "❌ Badges populaire: non trouvé"
grep -c "region" src/components/language/LanguageDropdown.tsx || echo "❌ Groupement région: non trouvé"

lines=$(wc -l < src/components/language/LanguageDropdown.tsx)
print_success "Taille finale: $lines lignes (devrait être >200)"

echo ""
echo "🎉 REMPLACEMENT FORCÉ TERMINÉ !"
echo "Le nouveau dropdown a des éléments TRÈS visibles pour confirmer le changement."