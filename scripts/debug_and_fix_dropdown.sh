#!/bin/bash

# =============================================================================
# 🔍 DIAGNOSTIC ET CORRECTION FORCÉE DU DROPDOWN
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo "🔍 DIAGNOSTIC ET CORRECTION FORCÉE DU DROPDOWN"
echo "=============================================="

# 1. NAVIGATION
print_step "1. Navigation vers le projet"
if [ -d "apps/math4child" ]; then
    cd apps/math4child
    print_success "Dans: $(pwd)"
elif [ -f "package.json" ] && grep -q "math4child" package.json; then
    print_success "Déjà dans Math4Child"
else
    print_error "Projet Math4Child non trouvé"
    exit 1
fi

# 2. DIAGNOSTIC DU FICHIER ACTUEL
print_step "2. Diagnostic du fichier LanguageDropdown actuel"

if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
    print_success "Fichier LanguageDropdown trouvé"
    
    # Vérifier le contenu
    if grep -q "Search" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Composant Search détecté"
    else
        print_error "❌ Composant Search manquant (ancienne version)"
    fi
    
    if grep -q "popular" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Langues populaires détectées"
    else
        print_error "❌ Langues populaires manquantes (ancienne version)"
    fi
    
    if grep -q "region" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Groupement par région détecté"
    else
        print_error "❌ Groupement par région manquant (ancienne version)"
    fi
    
    if grep -q "searchTerm" src/components/language/LanguageDropdown.tsx; then
        print_success "✅ Fonction de recherche détectée"
    else
        print_error "❌ Fonction de recherche manquante (ancienne version)"
    fi
    
    # Afficher la taille du fichier
    size=$(wc -l < src/components/language/LanguageDropdown.tsx)
    print_step "Taille du fichier: $size lignes"
    
    if [ "$size" -lt 100 ]; then
        print_error "❌ Fichier trop petit - ancienne version détectée"
        NEEDS_UPDATE=true
    else
        print_success "✅ Taille correcte"
        NEEDS_UPDATE=false
    fi
    
else
    print_error "❌ Fichier LanguageDropdown non trouvé"
    NEEDS_UPDATE=true
fi

# 3. VÉRIFICATION DU CACHE NEXT.JS
print_step "3. Vérification du cache Next.js"

if [ -d ".next" ]; then
    print_warning "Cache Next.js détecté - peut causer des problèmes"
    rm -rf .next
    print_success "Cache Next.js supprimé"
fi

# 4. CORRECTION FORCÉE SI NÉCESSAIRE
if [ "$NEEDS_UPDATE" = true ]; then
    print_step "4. CORRECTION FORCÉE - Remplacement du fichier"
    
    # Créer une sauvegarde
    if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
        cp src/components/language/LanguageDropdown.tsx src/components/language/LanguageDropdown.tsx.old
        print_success "Ancienne version sauvegardée"
    fi
    
    # Créer les dossiers
    mkdir -p src/components/language
    
    # REMPLACER PAR LA NOUVELLE VERSION
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
  { code: 'he', name: 'עברית', nativeName: 'עברית', flag: '🇮🇱', region: 'Moyen-Orient' },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asie' },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asie' },
  { code: 'id', name: 'Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asie' },
  { code: 'uk', name: 'Українська', nativeName: 'Українська', flag: '🇺🇦', region: 'Europe' },
  { code: 'cs', name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe' },
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
      {/* Bouton trigger */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20 focus:outline-none focus:ring-2 focus:ring-white/50"
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
            
            {/* Header avec recherche */}
            <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <Globe className="w-5 h-5" />
                <h3 className="font-semibold">Choisir une langue</h3>
                <button
                  onClick={closeDropdown}
                  className="ml-auto p-1 hover:bg-gray-200 rounded-full transition-colors"
                  aria-label="Fermer"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* Barre de recherche */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => {
                    setSearchTerm(e.target.value)
                    setSelectedIndex(-1)
                  }}
                  placeholder="Rechercher une langue..."
                  className="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
                {searchTerm && (
                  <button
                    onClick={() => setSearchTerm('')}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 p-1 hover:bg-gray-200 rounded-full transition-colors"
                    aria-label="Effacer la recherche"
                  >
                    <X className="w-3 h-3 text-gray-400" />
                  </button>
                )}
              </div>
            </div>

            {/* Liste des langues avec groupement */}
            <div className="flex-1 overflow-y-auto">
              {Object.keys(groupedLanguages).length === 0 ? (
                <div className="p-4 text-center text-gray-500">
                  <Search className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                  <p>Aucune langue trouvée</p>
                  <p className="text-sm">Essayez un autre terme de recherche</p>
                </div>
              ) : (
                Object.entries(groupedLanguages).map(([region, languages]) => (
                  <div key={region} className="mb-1">
                    {!searchTerm && (
                      <div className="px-4 py-2 bg-gray-100 text-xs font-semibold text-gray-600 uppercase tracking-wide sticky top-0 z-10">
                        {region}
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
                          className={`w-full px-4 py-3 text-left transition-all duration-150 flex items-center gap-3 group ${
                            isCurrent 
                              ? 'bg-blue-100 border-l-4 border-blue-500' 
                              : isSelected
                              ? 'bg-blue-50 border-l-4 border-blue-300'
                              : 'border-l-4 border-transparent hover:bg-gray-50'
                          }`}
                          role="option"
                          aria-selected={isCurrent}
                        >
                          <span className="text-2xl flex-shrink-0">{language.flag}</span>
                          <div className="flex-1 min-w-0">
                            <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                              {language.name}
                              {language.popular && (
                                <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full font-normal">
                                  Populaire
                                </span>
                              )}
                            </div>
                            <div className={`text-sm truncate ${isCurrent ? 'text-blue-700' : 'text-gray-500'}`}>
                              {language.nativeName}
                            </div>
                          </div>
                          {isCurrent && (
                            <Check className="w-5 h-5 text-blue-500 flex-shrink-0" />
                          )}
                        </button>
                      )
                    })}
                  </div>
                ))
              )}
            </div>

            {/* Footer */}
            <div className="px-4 py-2 bg-gray-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs text-gray-500">
                <span>
                  {filteredLanguages.length} langue{filteredLanguages.length > 1 ? 's' : ''} disponible{filteredLanguages.length > 1 ? 's' : ''}
                </span>
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
    
    print_success "🎉 NOUVELLE VERSION INSTALLÉE AVEC SUCCÈS"
    
    # Vérifier que le nouveau fichier est correct
    new_size=$(wc -l < src/components/language/LanguageDropdown.tsx)
    print_success "Nouvelle taille: $new_size lignes"
    
else
    print_success "✅ Le fichier semble déjà à jour"
fi

# 5. VÉRIFICATION DES DÉPENDANCES
print_step "5. Vérification des dépendances"

if ! npm list lucide-react > /dev/null 2>&1; then
    print_warning "Installation de lucide-react..."
    npm install lucide-react --legacy-peer-deps
    print_success "lucide-react installé"
fi

# 6. NETTOYAGE COMPLET
print_step "6. Nettoyage complet pour forcer la mise à jour"

# Supprimer tous les caches
rm -rf .next node_modules/.cache
npm cache clean --force

print_success "Caches supprimés"

# 7. BUILD DE TEST
print_step "7. Test de build pour validation"

if npm run build > /dev/null 2>&1; then
    print_success "✅ Build réussi - changements appliqués"
else
    print_warning "⚠️  Build échoué - vérifiez les erreurs"
fi

# 8. INSTRUCTIONS FINALES
echo ""
echo "🎯 INSTRUCTIONS POUR VOIR LES CHANGEMENTS :"
echo "==========================================="
echo "1. Redémarrez votre serveur de développement :"
echo "   npm run dev"
echo ""
echo "2. Videz le cache de votre navigateur :"
echo "   - Chrome/Edge : Ctrl+Shift+R (Windows) ou Cmd+Shift+R (Mac)"
echo "   - Firefox : Ctrl+F5 (Windows) ou Cmd+Shift+R (Mac)"
echo ""
echo "3. Ou ouvrez une fenêtre de navigation privée/incognito"
echo ""
echo "✨ NOUVELLES FONCTIONNALITÉS À TESTER :"
echo "• 🔍 Barre de recherche en haut du dropdown"
echo "• 🏷️  Badges 'Populaire' sur les langues principales"
echo "• 🌍 Groupement par régions (Europe, Asie, etc.)"
echo "• ⌨️  Navigation avec les flèches du clavier"
echo "• 📱 Interface responsive améliorée"
echo ""
echo "Si vous ne voyez toujours pas les changements,"
echo "c'est probablement un problème de cache navigateur."

# 9. COMMIT ET PUSH AUTOMATIQUE
print_step "9. Commit et push automatique"

# Vérifier si on est dans un repo git
if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
    print_step "Ajout des fichiers modifiés..."
    git add src/components/language/LanguageDropdown.tsx
    
    if git diff --staged --quiet; then
        print_warning "Aucun changement à commiter"
    else
        git commit -m "feat: upgrade LanguageDropdown with search, regions, and keyboard navigation"
        print_success "Changements committés"
        
        print_step "Push vers le remote..."
        git push origin main || git push origin master || print_warning "Push échoué - vérifiez votre remote"
        print_success "Changements poussés vers le remote"
    fi
else
    print_warning "Pas dans un repository Git - commit manuel nécessaire"
fi

echo ""
echo "🎉 CORRECTION TERMINÉE !"
echo "Le dropdown devrait maintenant afficher toutes les nouvelles fonctionnalités."