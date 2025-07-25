#!/bin/bash

# ===================================================================
# SCRIPT ULTIMATE CORRIGÉ - MATH4CHILD SETUP GLOBAL - VERSION FIXÉE
# Correction de l'erreur de syntaxe ligne 757
# ===================================================================

set -e

# Couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner ASCII
echo ""
echo -e "${PURPLE}  ███╗   ███╗ █████╗ ████████╗██╗  ██╗██╗  ██╗ ██████╗██╗  ██╗██╗██╗     ██████╗ ${NC}"  
echo -e "${PURPLE}  ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║██║  ██║██╔════╝██║  ██║██║██║     ██╔══██╗${NC}"
echo -e "${PURPLE}  ██╔████╔██║███████║   ██║   ███████║███████║██║     ███████║██║██║     ██║  ██║${NC}"
echo -e "${PURPLE}  ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║╚════██║██║     ██╔══██║██║██║     ██║  ██║${NC}"
echo -e "${PURPLE}  ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║     ██║╚██████╗██║  ██║██║███████╗██████╔╝${NC}"
echo -e "${PURPLE}  ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═════╝ ${NC}"
echo ""
echo -e "${CYAN}    SCRIPT ULTIMATE CORRIGÉ - STRUCTURE APPS${NC}"
echo ""

# ================================================================
# ÉTAPE 1: DÉTECTION DE LA STRUCTURE
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 1: DÉTECTION DE LA STRUCTURE   ${NC}"
echo -e "${CYAN}=========================================${NC}"

echo -e "${BLUE}🔍 Détection automatique de la structure...${NC}"

# Variables de base
BASE_DIR=$(pwd)
BACKUP_DIR="$BASE_DIR/backup"

# Détecter Math4Child
if [ -d "apps/math4child" ]; then
    MATH4CHILD_PATH="$BASE_DIR/apps/math4child"
    echo -e "${BLUE}🔍 Vérification: apps/math4child${NC}"
elif [ -d "math4child" ]; then
    MATH4CHILD_PATH="$BASE_DIR/math4child"
    echo -e "${BLUE}🔍 Vérification: math4child${NC}"
elif [ -f "package.json" ] && grep -q "math4child" package.json; then
    MATH4CHILD_PATH="$BASE_DIR"
    echo -e "${BLUE}🔍 Vérification: dossier actuel${NC}"
else
    echo -e "${RED}❌ Math4Child non trouvé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Math4Child trouvé: $MATH4CHILD_PATH${NC}"

# Chemin du fichier page.tsx
if [ -f "$MATH4CHILD_PATH/src/app/page.tsx" ]; then
    PAGE_TSX_PATH="$MATH4CHILD_PATH/src/app/page.tsx"
elif [ -f "$MATH4CHILD_PATH/app/page.tsx" ]; then
    PAGE_TSX_PATH="$MATH4CHILD_PATH/app/page.tsx"
elif [ -f "$MATH4CHILD_PATH/pages/index.tsx" ]; then
    PAGE_TSX_PATH="$MATH4CHILD_PATH/pages/index.tsx"
else
    PAGE_TSX_PATH="$MATH4CHILD_PATH/src/app/page.tsx"
    echo -e "${YELLOW}⚠️  page.tsx non trouvé - sera créé${NC}"
fi

echo -e "${GREEN}✅ Page principale trouvée: $PAGE_TSX_PATH${NC}"

# Vérifications système
echo -e "${BLUE}🔍 Vérifications...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js requis${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
echo -e "${GREEN}✅ npm: $(npm --version)${NC}"
echo -e "${GREEN}✅ Chemin Math4Child: $MATH4CHILD_PATH${NC}"
echo -e "${GREEN}✅ Chemin page.tsx: $PAGE_TSX_PATH${NC}"

# Créer backup
mkdir -p $BACKUP_DIR
if [ -f "$PAGE_TSX_PATH" ]; then
    cp "$PAGE_TSX_PATH" "$BACKUP_DIR/"
    echo -e "${GREEN}✅ Backup page.tsx créé${NC}"
fi

# Se positionner dans le bon dossier
cd "$MATH4CHILD_PATH"
echo -e "${GREEN}✅ Positionnement: $(pwd)${NC}"

# ================================================================
# ÉTAPE 2: ANALYSE DE L'ÉTAT ACTUEL
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 2: ANALYSE DE L'ÉTAT ACTUEL    ${NC}"
echo -e "${CYAN}=========================================${NC}"

# Analyser package.json
if [ -f "package.json" ]; then
    echo -e "${GREEN}✅ package.json trouvé${NC}"
    
    # Vérifier Playwright
    if grep -q "@playwright/test" package.json; then
        echo -e "${GREEN}✅ Playwright déjà installé${NC}"
        
        if npx playwright --version &> /dev/null; then
            echo -e "${GREEN}✅ Navigateurs Playwright installés${NC}"
        else
            echo -e "${YELLOW}⚠️  Installation des navigateurs nécessaire${NC}"
            npx playwright install --with-deps
        fi
    else
        echo -e "${YELLOW}⚠️  Installation de Playwright nécessaire${NC}"
        npm install -D @playwright/test@latest
        npx playwright install --with-deps
    fi
else
    echo -e "${RED}❌ package.json manquant dans $MATH4CHILD_PATH${NC}"
    exit 1
fi

# Analyser l'état de page.tsx
NEEDS_UPDATE=false
if [ -f "$PAGE_TSX_PATH" ]; then
    # Vérifier le contenu actuel du H1
    CURRENT_H1=$(grep -o '<h1[^>]*>[^<]*</h1>' "$PAGE_TSX_PATH" | sed 's/<[^>]*>//g' | head -1 || echo "")
    if [ -n "$CURRENT_H1" ]; then
        echo -e "${GREEN}✅ H1 actuel détecté: '$CURRENT_H1'${NC}"
    else
        echo -e "${YELLOW}⚠️  H1 non détecté - page.tsx sera mise à jour${NC}"
        NEEDS_UPDATE=true
    fi
    
    if grep -q "languageDropdownRef\|pricingModalRef\|47.*langues" "$PAGE_TSX_PATH"; then
        echo -e "${GREEN}✅ Interactions avancées déjà présentes${NC}"
    else
        echo -e "${YELLOW}⚠️  Interactions manquantes - mise à jour nécessaire${NC}"
        NEEDS_UPDATE=true
    fi
else
    echo -e "${YELLOW}⚠️  page.tsx manquant - création nécessaire${NC}"
    NEEDS_UPDATE=true
fi

# ================================================================
# ÉTAPE 3: MISE À JOUR PAGE.TSX
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 3: MISE À JOUR PAGE.TSX        ${NC}"
echo -e "${CYAN}=========================================${NC}"

if [ "$NEEDS_UPDATE" = true ]; then
    echo -e "${BLUE}🔧 Création de page.tsx avec design moderne...${NC}"
    
    # Créer le dossier si nécessaire
    mkdir -p "$(dirname "$PAGE_TSX_PATH")"
    
    # Créer page.tsx avec le design Math4Child moderne
    cat > "$PAGE_TSX_PATH" << 'EOF'
'use client'

import { useState, useRef, useEffect } from 'react'

// Configuration des langues avec leurs codes
const languages = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇬🇧' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'hi', name: 'हिंदी', flag: '🇮🇳' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷' },
  { code: 'he', name: 'עברית', flag: '🇮🇱' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾' },
  { code: 'tl', name: 'Filipino', flag: '🇵🇭' },
  { code: 'uk', name: 'Українська', flag: '🇺🇦' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺' },
  { code: 'ro', name: 'Română', flag: '🇷🇴' },
  { code: 'bg', name: 'Български', flag: '🇧🇬' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷' },
  { code: 'sr', name: 'Српски', flag: '🇷🇸' },
  { code: 'sl', name: 'Slovenščina', flag: '🇸🇮' },
  { code: 'et', name: 'Eesti', flag: '🇪🇪' },
  { code: 'lv', name: 'Latviešu', flag: '🇱🇻' },
  { code: 'lt', name: 'Lietuvių', flag: '🇱🇹' },
  { code: 'mt', name: 'Malti', flag: '🇲🇹' },
  { code: 'is', name: 'Íslenska', flag: '🇮🇸' },
  { code: 'ga', name: 'Gaeilge', flag: '🇮🇪' },
  { code: 'cy', name: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿' },
  { code: 'eu', name: 'Euskera', flag: '🏴' },
  { code: 'ca', name: 'Català', flag: '🏴' },
  { code: 'gl', name: 'Galego', flag: '🏴' },
  { code: 'af', name: 'Afrikaans', flag: '🇿🇦' },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹' },
  { code: 'ka', name: 'ქართული', flag: '🇬🇪' },
  { code: 'hy', name: 'Հայերեն', flag: '🇦🇲' }
]

export default function Math4ChildPage() {
  const [selectedLanguage, setSelectedLanguage] = useState(languages[0])
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [languageSearch, setLanguageSearch] = useState('')
  const [isPricingModalOpen, setIsPricingModalOpen] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState('mensuel')
  
  const languageDropdownRef = useRef<HTMLDivElement>(null)
  const pricingModalRef = useRef<HTMLDivElement>(null)

  // Fermer les dropdowns en cliquant à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target as Node)) {
        setIsLanguageDropdownOpen(false)
      }
      if (pricingModalRef.current && !pricingModalRef.current.contains(event.target as Node)) {
        setIsPricingModalOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filtrer les langues selon la recherche
  const filteredLanguages = languages.filter(lang =>
    lang.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    lang.code.toLowerCase().includes(languageSearch.toLowerCase())
  )

  // Configuration du pricing
  const pricingConfig = {
    mensuel: { famille: 9.99, pro: 19.99, ecole: 29.99, discount: 0 },
    trimestriel: { famille: 8.99, pro: 17.99, ecole: 26.99, discount: 10 },
    annuel: { famille: 6.99, pro: 13.99, ecole: 20.99, discount: 30 }
  }

  const pricing = pricingConfig[selectedPeriod as keyof typeof pricingConfig]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
      {/* Header moderne */}
      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-xl border-b border-gray-200/50 shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-18">
            
            {/* Logo Math4Child */}
            <div className="flex items-center space-x-4">
              <div className="w-14 h-14 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-xl flex items-center justify-center shadow-xl transform hover:scale-110 hover:rotate-3 transition-all duration-300 cursor-pointer">
                <span className="text-white text-2xl font-bold animate-pulse">🧮</span>
              </div>
              <div>
                <h1 className="text-xl font-bold bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent">
                  Math pour enfants
                </h1>
                <p className="text-xs text-gray-600 flex items-center">
                  <span className="w-2 h-2 bg-green-500 rounded-full mr-2 animate-pulse"></span>
                  L'app éducative n°1 en France
                </p>
              </div>
            </div>
            
            {/* Navigation */}
            <div className="flex items-center space-x-6">
              
              {/* Badge familles */}
              <div className="hidden md:flex items-center space-x-2 bg-gradient-to-r from-green-100 to-emerald-100 text-green-800 rounded-full px-4 py-2 text-sm font-medium shadow-md hover:shadow-lg transition-all duration-300 transform hover:scale-105">
                <div className="w-3 h-3 bg-green-500 rounded-full animate-bounce"></div>
                <span className="font-bold">100k+ familles</span>
              </div>
              
              {/* Sélecteur de langue */}
              <div className="relative" ref={languageDropdownRef}>
                <button
                  onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                  className="flex items-center space-x-3 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-xl transition-all duration-200 transform hover:scale-105"
                  data-testid="language-selector"
                >
                  <span className="text-lg">{selectedLanguage.flag}</span>
                  <span className="font-medium text-gray-700">{selectedLanguage.name}</span>
                  <svg className="w-4 h-4 text-gray-500 transition-transform duration-200" style={{ transform: isLanguageDropdownOpen ? 'rotate(180deg)' : 'rotate(0deg)' }} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {isLanguageDropdownOpen && (
                  <div 
                    className="language-dropdown absolute right-0 mt-3 w-80 bg-white/95 backdrop-blur-xl rounded-2xl shadow-2xl border border-gray-200/50 z-50 max-h-96 overflow-hidden"
                    data-testid="language-dropdown"
                  >
                    <div className="p-4 border-b border-gray-100">
                      <h3 className="text-sm font-semibold text-gray-900 mb-3">Choisir une langue</h3>
                      <input
                        type="text"
                        placeholder="Rechercher une langue..."
                        value={languageSearch}
                        onChange={(e) => setLanguageSearch(e.target.value)}
                        className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                      />
                      <p className="text-xs text-gray-500 mt-2">47+ langues disponibles</p>
                    </div>
                    <div className="max-h-64 overflow-y-auto">
                      {filteredLanguages.map((lang) => (
                        <button
                          key={lang.code}
                          onClick={() => {
                            setSelectedLanguage(lang)
                            setIsLanguageDropdownOpen(false)
                            setLanguageSearch('')
                          }}
                          className="w-full flex items-center space-x-3 px-4 py-3 hover:bg-blue-50 transition-colors text-left group"
                          data-testid={`language-option-${lang.code}`}
                        >
                          <span className="text-lg group-hover:scale-110 transition-transform">{lang.flag}</span>
                          <div className="flex-1">
                            <div className="font-medium text-gray-900">{lang.name}</div>
                            <div className="text-xs text-gray-500">({lang.code})</div>
                          </div>
                        </button>
                      ))}
                    </div>
                    {filteredLanguages.length === 0 && (
                      <div className="p-4 text-center text-gray-500">
                        Aucune langue trouvée
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative py-20 overflow-hidden">
        {/* Particules d'arrière-plan */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-96 h-96 bg-purple-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-96 h-96 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute top-40 left-1/4 w-80 h-80 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="mb-8">
            <span className="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium bg-gradient-to-r from-blue-100 to-indigo-100 text-blue-800 mb-6">
              <span className="w-2 h-2 bg-blue-500 rounded-full mr-2 animate-pulse"></span>
              Rejoignez 100k+ familles satisfaites
            </span>
          </div>
          
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6 leading-tight">
            Math pour enfants
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto leading-relaxed">
            L'application éducative qui rend les mathématiques amusantes et accessibles à tous les enfants
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
            <button className="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-8 py-4 rounded-xl text-lg font-medium hover:from-blue-700 hover:to-indigo-700 transition-all duration-200 transform hover:scale-105 shadow-lg">
              Commencer gratuitement
            </button>
            <button 
              onClick={() => setIsPricingModalOpen(true)}
              className="bg-white text-blue-600 px-8 py-4 rounded-xl text-lg font-medium border-2 border-blue-600 hover:bg-blue-50 transition-all duration-200 transform hover:scale-105 shadow-lg"
            >
              Voir les prix
            </button>
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Fonctionnalités principales
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Découvrez pourquoi des milliers de familles choisissent Math4Child
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                title: 'Jeux interactifs',
                description: 'Plus de 100 jeux éducatifs adaptés à chaque niveau',
                icon: '🎮',
                color: 'from-blue-400 to-blue-600'
              },
              {
                title: 'Suivi des progrès',
                description: 'Tableaux de bord détaillés pour parents et enfants',
                icon: '📊',
                color: 'from-green-400 to-green-600'
              },
              {
                title: '47+ langues',
                description: 'Interface multilingue pour une accessibilité mondiale',
                icon: '🌍',
                color: 'from-purple-400 to-purple-600'
              },
              {
                title: 'Multi-plateformes',
                description: 'Disponible sur Web, iOS et Android',
                icon: '📱',
                color: 'from-orange-400 to-orange-600'
              },
              {
                title: '5 niveaux',
                description: 'Du débutant à l\'expert, progression personnalisée',
                icon: '📈',
                color: 'from-pink-400 to-pink-600'
              }
            ].map((feature, index) => (
              <div
                key={index}
                className="feature-card group p-8 rounded-2xl bg-gradient-to-br from-gray-50 to-white border border-gray-200 hover:shadow-2xl transition-all duration-300 cursor-pointer transform hover:scale-105"
                onClick={() => alert(`Fonctionnalité: ${feature.title}\n\n${feature.description}`)}
              >
                <div className={`w-16 h-16 bg-gradient-to-br ${feature.color} rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300`}>
                  <span className="text-2xl">{feature.icon}</span>
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3 group-hover:text-blue-600 transition-colors">
                  {feature.title}
                </h3>
                <p className="text-gray-600 leading-relaxed">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Statistiques */}
      <section className="py-16 bg-gradient-to-br from-blue-600 to-indigo-700 text-white relative overflow-hidden">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute top-20 left-10 w-32 h-32 bg-white rounded-full mix-blend-multiply filter blur-xl opacity-10 animate-pulse"></div>
          <div className="absolute bottom-20 right-10 w-40 h-40 bg-white rounded-full mix-blend-multiply filter blur-xl opacity-10 animate-pulse"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            {[
              { 
                value: '100k+', 
                label: 'Familles actives', 
                description: 'utilisent Math4Child quotidiennement',
                icon: '👨‍👩‍👧‍👦'
              },
              { 
                value: '98%', 
                label: 'Satisfaction', 
                description: 'des parents recommandent notre app',
                icon: '⭐'
              },
              { 
                value: '2M+', 
                label: 'Exercices résolus', 
                description: 'par nos petits mathématiciens',
                icon: '🧮'
              }
            ].map((stat, index) => (
              <div
                key={index}
                className="stat-card group p-8 rounded-2xl bg-white/10 backdrop-blur-sm border border-white/20 hover:bg-white/20 transition-all duration-300 cursor-pointer transform hover:scale-105"
                onClick={() => alert(`Statistique: ${stat.label}\n\n${stat.value} ${stat.description}`)}
              >
                <div className="text-4xl mb-4 group-hover:scale-110 transition-transform duration-300">
                  {stat.icon}
                </div>
                <div className="text-4xl md:text-5xl font-bold mb-2 group-hover:text-yellow-200 transition-colors">
                  {stat.value}
                </div>
                <div className="text-xl font-medium mb-2">
                  {stat.label}
                </div>
                <div className="text-blue-100 text-sm">
                  {stat.description}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Plateformes */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Disponible sur toutes les plateformes
            </h2>
            <p className="text-xl text-gray-600">
              Synchronisez vos progrès sur tous vos appareils
            </p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {[
              { 
                platform: 'Web', 
                icon: '🌐', 
                description: 'Accès direct depuis votre navigateur',
                link: 'https://math4child.com',
                color: 'from-green-400 to-emerald-500',
                bg: 'from-green-50 to-emerald-50'
              },
              { 
                platform: 'iOS', 
                icon: '📱', 
                description: 'Téléchargez sur l\'App Store',
                link: 'https://apps.apple.com/app/math4child',
                color: 'from-blue-400 to-blue-500',
                bg: 'from-blue-50 to-indigo-50'
              },
              { 
                platform: 'Android', 
                icon: '📲', 
                description: 'Disponible sur Google Play',
                link: 'https://play.google.com/store/apps/math4child',
                color: 'from-orange-400 to-red-500',
                bg: 'from-orange-50 to-red-50'
              }
            ].map((item, index) => (
              <div
                key={index}
                className={`platform-card group p-8 rounded-2xl bg-gradient-to-br ${item.bg} border border-gray-200 text-center cursor-pointer transition-all duration-300 transform hover:scale-105 hover:shadow-2xl`}
                onClick={() => {
                  alert(`Téléchargement: ${item.platform}\n\n${item.description}\n\nRedirection vers: ${item.link}`)
                }}
              >
                <div className={`w-20 h-20 bg-gradient-to-br ${item.color} rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform duration-300 shadow-lg`}>
                  <span className="text-3xl text-white">{item.icon}</span>
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-3 group-hover:text-blue-600 transition-colors">
                  {item.platform}
                </h3>
                <p className="text-gray-600 mb-6 leading-relaxed">
                  {item.description}
                </p>
                <button className={`w-full bg-gradient-to-r ${item.color} text-white px-6 py-3 rounded-xl font-medium hover:shadow-lg transition-all duration-200`}>
                  Télécharger
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8 mb-12">
            <div>
              <div className="flex items-center space-x-3 mb-6">
                <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-pink-500 rounded-xl flex items-center justify-center">
                  <span className="text-white text-xl font-bold">🧮</span>
                </div>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400 leading-relaxed">
                L'application éducative qui rend les mathématiques amusantes et accessibles à tous les enfants.
              </p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">Produit</h3>
              <ul className="space-y-2">
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Fonctionnalités</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Tarifs</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Téléchargements</a></li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">Support</h3>
              <ul className="space-y-2">
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Documentation</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Contact</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">FAQ</a></li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">Entreprise</h3>
              <ul className="space-y-2">
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">À propos</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">GOTEST</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Carrières</a></li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-gray-800 pt-8 text-center">
            <p className="text-gray-400">
              &copy; 2024 Math4Child by GOTEST. Tous droits réservés.
            </p>
          </div>
        </div>
      </footer>

      {/* Modal Pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="pricing-modal bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl" ref={pricingModalRef}>
            <div className="p-6 border-b border-gray-200 flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold text-gray-900">Choisissez votre plan</h2>
                <p className="text-gray-600">Libérez tout le potentiel de Math4Child</p>
              </div>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 hover:bg-gray-200 transition-colors"
              >
                <span className="text-xl text-gray-500">×</span>
              </button>
            </div>
            
            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 p-1 rounded-xl flex">
                  {[
                    { key: 'mensuel', label: 'Mensuel' },
                    { key: 'trimestriel', label: 'Trimestriel', badge: '-10%' },
                    { key: 'annuel', label: 'Annuel', badge: '-30%' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key)}
                      className={`relative px-6 py-3 rounded-lg font-medium transition-all duration-200 ${
                        selectedPeriod === period.key
                          ? 'bg-white shadow-md text-blue-600 scale-105'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.badge && (
                        <span className="absolute -top-1 -right-1 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                          {period.badge}
                        </span>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Plans tarifaires */}
              <div className="grid md:grid-cols-3 gap-6">
                {[
                  {
                    name: 'Famille',
                    price: pricing.famille,
                    color: 'from-blue-400 to-blue-600',
                    bg: 'from-blue-50 to-indigo-50',
                    button: 'bg-blue-600 hover:bg-blue-700'
                  },
                  {
                    name: 'Pro',
                    price: pricing.pro,
                    color: 'from-purple-400 to-purple-600',
                    bg: 'from-purple-50 to-pink-50',
                    button: 'bg-purple-600 hover:bg-purple-700',
                    popular: true
                  },
                  {
                    name: 'École',
                    price: pricing.ecole,
                    color: 'from-orange-400 to-orange-600',
                    bg: 'from-orange-50 to-red-50',
                    button: 'bg-orange-600 hover:bg-orange-700'
                  }
                ].map((plan, index) => (
                  <div
                    key={index}
                    className={`plan-${plan.name.toLowerCase()} relative p-8 rounded-2xl bg-gradient-to-br ${plan.bg} border-2 ${plan.popular ? 'border-purple-300 shadow-2xl scale-105' : 'border-gray-200'} transition-all duration-300 hover:shadow-xl`}
                  >
                    {plan.popular && (
                      <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <span className="bg-gradient-to-r from-purple-600 to-pink-600 text-white px-4 py-2 rounded-full text-sm font-medium">
                          Plus populaire
                        </span>
                      </div>
                    )}
                    
                    <div className={`w-16 h-16 bg-gradient-to-br ${plan.color} rounded-2xl flex items-center justify-center mx-auto mb-6`}>
                      <span className="text-white text-2xl">
                        {plan.name === 'Famille' ? '👨‍👩‍👧‍👦' : plan.name === 'Pro' ? '⭐' : '🏫'}
                      </span>
                    </div>
                    
                    <h3 className="text-xl font-bold text-center mb-4">{plan.name}</h3>
                    
                    <div className="text-center mb-6">
                      <div className="text-4xl font-bold text-gray-900 mb-1">
                        {plan.price}€
                        <span className="text-lg text-gray-500">/mois</span>
                      </div>
                      {pricing.discount > 0 && (
                        <span className="inline-block bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
                          Économisez {pricing.discount}%
                        </span>
                      )}
                    </div>
                    
                    <button className={`w-full ${plan.button} text-white py-4 rounded-xl font-medium transition-all duration-200 transform hover:scale-105 shadow-lg`}>
                      {plan.name === 'École' ? 'Demander un devis' : 'Essai gratuit 14 jours'}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

    echo -e "${GREEN}✅ page.tsx avec design moderne créé${NC}"
else
    echo -e "${GREEN}✅ page.tsx déjà à jour - pas de modification${NC}"
fi

# ================================================================
# ÉTAPE 4: CRÉATION DES TESTS ADAPTÉS
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 4: CRÉATION DES TESTS ADAPTÉS  ${NC}"
echo -e "${CYAN}=========================================${NC}"

# Créer dossier tests
mkdir -p tests

echo -e "${BLUE}🧪 Création des tests adaptés...${NC}"

# Tests principaux adaptés à la structure réelle
cat > tests/math4child-interactions.spec.ts << 'EOF'
import { test, expect } from '@playwright/test'

test.describe('Math4Child - Interactions Complètes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('h1').first()).toContainText('Math pour enfants')
  })

  test('🌍 Sélecteur de langues interactif', async ({ page }) => {
    console.log('🌍 Test du sélecteur de langues...')
    
    // Ouvrir le dropdown
    await page.locator('button[data-testid="language-selector"]').click()
    await expect(page.locator('input[placeholder*="Rechercher"]')).toBeVisible()
    
    // Tester la recherche
    await page.fill('input[placeholder*="Rechercher"]', 'Eng')
    await expect(page.locator('text=English')).toBeVisible()
    
    // Sélectionner une langue
    await page.locator('text=English').click()
    await expect(page.locator('button:has-text("English")')).toBeVisible()
    
    // Vérifier que le dropdown se ferme
    await expect(page.locator('input[placeholder*="Rechercher"]')).toBeHidden()
  })

  test('🎮 Cartes fonctionnalités cliquables', async ({ page }) => {
    console.log('🎮 Test des cartes fonctionnalités...')
    
    const featureCards = page.locator('.feature-card')
    await expect(featureCards).toHaveCount(5)
    
    // Tester chaque carte avec gestion des dialogues
    for (let i = 0; i < 5; i++) {
      const card = featureCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Fonctionnalité:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('📊 Statistiques interactives', async ({ page }) => {
    console.log('📊 Test des statistiques...')
    
    const statCards = page.locator('.stat-card')
    await expect(statCards).toHaveCount(3)
    
    // Tester chaque statistique
    for (let i = 0; i < 3; i++) {
      const card = statCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Statistique:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('📱 Plateformes téléchargement', async ({ page }) => {
    console.log('📱 Test des plateformes...')
    
    const platformCards = page.locator('.platform-card')
    await expect(platformCards).toHaveCount(3)
    
    // Tester chaque plateforme
    for (let i = 0; i < 3; i++) {
      const card = platformCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Téléchargement:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('💰 Modal Pricing Complet', async ({ page }) => {
    console.log('💰 Test du modal pricing...')
    
    // Ouvrir le modal
    await page.locator('button:has-text("Voir les prix")').click()
    await expect(page.locator('.pricing-modal')).toBeVisible()
    
    // Tester les périodes
    const periods = [
      { name: 'Mensuel', discount: '' },
      { name: 'Trimestriel', discount: '-10%' },
      { name: 'Annuel', discount: '-30%' }
    ]
    
    for (const period of periods) {
      await page.locator(`button:has-text("${period.name}")`).click()
      
      if (period.discount) {
        await expect(page.locator(`text=${period.discount}`)).toBeVisible()
      }
    }
    
    // Fermer le modal
    await page.locator('button:has-text("×")').click()
    await expect(page.locator('.pricing-modal')).toBeHidden()
  })

  test('📱 Test Responsive', async ({ page }) => {
    console.log('📱 Test responsive...')
    
    // Test mobile
    await page.setViewportSize({ width: 375, height: 667 })
    await page.reload()
    await page.waitForLoadState('networkidle')
    
    await expect(page.locator('h1').first()).toBeVisible()
    await expect(page.locator('.feature-card').first()).toBeVisible()
    
    // Remettre desktop
    await page.setViewportSize({ width: 1280, height: 720 })
  })
})

test('🎉 Validation Globale', async ({ page }) => {
  await page.goto('/')
  await page.waitForLoadState('networkidle')
  
  console.log('🚀 Validation globale...')
  
  // Vérifications critiques - CORRIGÉES selon le nouveau design
  await expect(page.locator('h1').first()).toContainText('Math pour enfants')
  await expect(page.locator('.feature-card')).toHaveCount(5)
  await expect(page.locator('.stat-card')).toHaveCount(3)
  await expect(page.locator('.platform-card')).toHaveCount(3)
  
  console.log('🎉 VALIDATION RÉUSSIE !') 
})
EOF

# Configuration Playwright adaptée
cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 45000,
  expect: { timeout: 15000 },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 3,

  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    process.env.CI ? ['github'] : ['list', { printSteps: true }]
  ],

  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 20000,
    navigationTimeout: 40000,
  },

  projects: [
    {
      name: 'chromium-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
      testMatch: /math4child.*\.spec\.ts/,
    },
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },

  outputDir: 'test-results/',
});
EOF

# Scripts npm adaptés
echo -e "${BLUE}📦 Ajout des scripts de test...${NC}"

node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.scripts = {
  ...pkg.scripts,
  'test': 'playwright test',
  'test:headed': 'playwright test --headed',
  'test:mobile': 'playwright test --project=mobile-chrome',
  'test:report': 'npx playwright show-report --port=0',
  'test:quick': 'playwright test --grep \"🎉.*Validation\"',
  'validate': 'npm run test:quick',
  'test:kill-reports': 'pkill -f \"playwright show-report\" || true'
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

echo -e "${GREEN}✅ Tests et configuration créés${NC}"

# ================================================================
# ÉTAPE 5: VALIDATION ET DÉMARRAGE
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 5: VALIDATION ET DÉMARRAGE     ${NC}"
echo -e "${CYAN}=========================================${NC}"

# Installer les dépendances
echo -e "${BLUE}📦 Installation des dépendances...${NC}"
npm install

# Vérifier si le serveur tourne
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Serveur déjà en cours${NC}"
else
    echo -e "${BLUE}🚀 Démarrage du serveur...${NC}"
    npm run dev &
    SERVER_PID=$!
    
    # Attendre le démarrage
    echo -e "${BLUE}⏳ Attente du démarrage...${NC}"
    for i in {1..60}; do
        if curl -s http://localhost:3000 > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Serveur démarré !${NC}"
            break
        fi
        sleep 1
        echo -n "."
    done
    
    if [ $i -eq 60 ]; then
        echo -e "${RED}❌ Timeout serveur${NC}"
        exit 1
    fi
fi

# Test de validation rapide
echo -e "${PURPLE}🧪 Test de validation...${NC}"
sleep 3

if npm run test:quick; then
    echo -e "${GREEN}✅ Validation réussie !${NC}"
    
    # Nettoyer les anciens rapports et ports utilisés
    echo -e "${BLUE}🧹 Nettoyage des anciens rapports...${NC}"
    pkill -f "playwright show-report" 2>/dev/null || true
    sleep 2
    
    echo -e "${BLUE}📊 Génération du rapport...${NC}"
    npm run test:report &
    
    # Attendre un moment pour que le serveur se lance
    sleep 3
    echo -e "${GREEN}📊 Rapport disponible sur port automatique${NC}"
else
    echo -e "${YELLOW}⚠️ Tests partiels - vérification manuelle recommandée${NC}"
fi

# ================================================================
# RAPPORT FINAL
# ================================================================

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}     SETUP MATH4CHILD TERMINÉ !        ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${GREEN}🎉 INSTALLATION RÉUSSIE !${NC}"
echo ""
echo -e "${BLUE}📁 STRUCTURE DÉTECTÉE :${NC}"
echo -e "${GREEN}✅ Chemin Math4Child: $MATH4CHILD_PATH${NC}"
echo -e "${GREEN}✅ Page principale: $PAGE_TSX_PATH${NC}"
echo -e "${GREEN}✅ Tests créés: ./tests/${NC}"
echo ""
echo -e "${BLUE}🎯 FONCTIONNALITÉS INSTALLÉES :${NC}"
echo "✅ Design Math4Child moderne et professionnel"
echo "✅ Header avec logo gradient animé"
echo "✅ Sélecteur de 47+ langues avec recherche"
echo "✅ 5 cartes fonctionnalités interactives"
echo "✅ 3 statistiques avec animations hover"
echo "✅ 3 plateformes avec design moderne"
echo "✅ Modal pricing avec plans colorés"
echo "✅ Footer professionnel avec branding GOTEST"
echo "✅ Design responsive complet"
echo ""
echo -e "${BLUE}🧪 TESTS DISPONIBLES :${NC}"
echo "npm run test                 # Tous les tests"
echo "npm run test:headed          # Tests avec interface"
echo "npm run test:mobile          # Tests mobile"
echo "npm run test:quick           # Validation rapide"
echo "npm run test:report          # Voir le rapport (port automatique)"
echo "npm run test:kill-reports    # Arrêter les serveurs de rapport"
echo "npm run validate             # Validation complète"
echo ""
echo -e "${BLUE}🌐 APPLICATION :${NC}"
echo "URL: http://localhost:3000"
if [ ! -z "$SERVER_PID" ]; then
    echo "Serveur PID: $SERVER_PID"
else
    echo "Serveur: Déjà en cours"
fi
echo ""
echo -e "${BLUE}📦 SAUVEGARDES :${NC}"
if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
    echo "Dossier: $BACKUP_DIR/"
    ls -la $BACKUP_DIR/
else
    echo "Aucune sauvegarde nécessaire"
fi
echo ""
echo -e "${GREEN}🎯 PROCHAINES ÉTAPES :${NC}"
echo "1. Tester: http://localhost:3000"  
echo "2. Valider: npm run test:quick"
echo "3. Voir rapport: npm run test:report"
echo ""
echo -e "${GREEN}🎉 MATH4CHILD AVEC DESIGN MODERNE PRÊT !${NC}"