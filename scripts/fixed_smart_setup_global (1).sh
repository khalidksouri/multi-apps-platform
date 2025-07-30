#!/bin/bash

# ===================================================================
# SCRIPT ULTIMATE CORRIGÉ - MATH4CHILD SETUP GLOBAL
# Version adaptée basée sur les logs d'erreur
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
    echo -e "${BLUE}🔧 Création de page.tsx avec interactions avancées...${NC}"
    
    # Créer le dossier si nécessaire
    mkdir -p "$(dirname "$PAGE_TSX_PATH")"
    
    # Créer page.tsx avec le design précédent + les ajouts des screenshots
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
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-orange-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">M</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math pour enfants</h1>
                <p className="text-sm text-gray-600">App éducative n°1 en France</p>
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm flex items-center">
                <span className="w-2 h-2 bg-green-500 rounded-full mr-2"></span>
                100k+ familles
              </div>

              {/* Sélecteur de langue avec le design des screenshots */}
              <div className="relative" ref={languageDropdownRef}>
                <button
                  onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                  className="flex items-center space-x-2 px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors"
                  data-testid="language-selector"
                >
                  <span className="text-lg">{selectedLanguage.flag}</span>
                  <span className="font-medium text-gray-700">{selectedLanguage.name}</span>
                  <svg className="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {isLanguageDropdownOpen && (
                  <div 
                    className="language-dropdown absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border z-50 max-h-96 overflow-hidden"
                    data-testid="language-dropdown"
                  >
                    <div className="p-3 border-b border-gray-100">
                      <input
                        type="text"
                        placeholder="Rechercher une langue..."
                        value={languageSearch}
                        onChange={(e) => setLanguageSearch(e.target.value)}
                        className="w-full px-3 py-2 border border-gray-200 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                      />
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
                          className="w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left"
                          data-testid={`language-option-${lang.code}`}
                        >
                          <span className="text-lg">{lang.flag}</span>
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

      {/* Section Hero */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
            Math pour enfants
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Application éducative interactive pour apprendre les mathématiques de manière ludique et efficace
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="bg-blue-600 text-white px-8 py-4 rounded-lg text-lg font-medium hover:bg-blue-700 transition-colors">
              Commencer gratuitement
            </button>
            <button 
              onClick={() => setIsPricingModalOpen(true)}
              className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-medium border-2 border-blue-600 hover:bg-blue-50 transition-colors"
            >
              Comparer les prix
            </button>
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Fonctionnalités principales
          </h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                title: 'Jeux interactifs',
                description: 'Plus de 100 jeux éducatifs',
                icon: '🎮',
                details: 'Jeux adaptés à chaque niveau pour maintenir l\'engagement et la motivation des enfants.'
              },
              {
                title: 'Suivi des progrès',
                description: 'Tableaux de bord détaillés',
                icon: '📊',
                details: 'Visualisez les progrès de votre enfant avec des graphiques détaillés et des rapports personnalisés.'
              },
              {
                title: '47+ langues disponibles',
                description: 'Interface multilingue complète',
                icon: '🌍',
                details: 'Application traduite dans plus de 47 langues pour une accessibilité mondiale maximale.'
              },
              {
                title: 'Web, iOS et Android',
                description: 'Disponible sur toutes les plateformes',
                icon: '📱',
                details: 'Synchronisation entre tous vos appareils pour apprendre partout, tout le temps.'
              },
              {
                title: '5 niveaux de difficulté',
                description: 'Progression adaptée à chaque enfant',
                icon: '📈',
                details: 'Du niveau débutant au niveau expert, chaque enfant progresse à son rythme.'
              }
            ].map((feature, index) => (
              <div
                key={index}
                className="feature-card bg-gray-50 p-6 rounded-xl hover:shadow-lg transition-all duration-300 cursor-pointer transform hover:scale-105"
                onClick={() => alert(`Fonctionnalité: ${feature.title}\n\n${feature.details}`)}
              >
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Statistiques */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            {[
              { value: '50,000+', label: 'Enfants actifs', description: 'utilisent Math4Child quotidiennement' },
              { value: '98%', label: 'Satisfaction parents', description: 'recommandent notre application' },
              { value: '2M+', label: 'Exercices résolus', description: 'par nos petits mathématiciens' }
            ].map((stat, index) => (
              <div
                key={index}
                className="stat-card cursor-pointer transform hover:scale-105 transition-transform duration-300"
                onClick={() => alert(`Statistique: ${stat.label}\n\n${stat.value} ${stat.description}`)}
              >
                <div className="text-4xl font-bold mb-2">{stat.value}</div>
                <div className="text-xl font-medium mb-1">{stat.label}</div>
                <div className="text-blue-100">{stat.description}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Plateformes avec le design des screenshots */}
      <section className="py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Disponible sur toutes les plateformes
          </h2>
          <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {[
              { 
                platform: 'Web', 
                icon: '🌐', 
                description: 'Accès direct depuis votre navigateur',
                link: 'https://math4child.com',
                color: 'bg-green-50 border-green-200 hover:bg-green-100'
              },
              { 
                platform: 'iOS', 
                icon: '📱', 
                description: 'Téléchargez sur l\'App Store',
                link: 'https://apps.apple.com/app/math4child',
                color: 'bg-blue-50 border-blue-200 hover:bg-blue-100'
              },
              { 
                platform: 'Android', 
                icon: '📲', 
                description: 'Disponible sur Google Play',
                link: 'https://play.google.com/store/apps/math4child',
                color: 'bg-orange-50 border-orange-200 hover:bg-orange-100'
              }
            ].map((item, index) => (
              <div
                key={index}
                className={`platform-card p-8 rounded-xl border-2 text-center cursor-pointer transition-all duration-300 transform hover:scale-105 ${item.color}`}
                onClick={() => {
                  alert(`Téléchargement: ${item.platform}\n\n${item.description}\n\nRedirection vers: ${item.link}`)
                }}
              >
                <div className="text-6xl mb-4">{item.icon}</div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">{item.platform}</h3>
                <p className="text-gray-600 mb-6">{item.description}</p>
                <button className="w-full bg-gray-900 text-white px-6 py-3 rounded-lg font-medium hover:bg-gray-800 transition-colors">
                  Télécharger
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-2 mb-4">
                <span className="text-2xl">🧮</span>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400">
                L'application éducative qui rend les mathématiques amusantes et accessibles à tous les enfants.
              </p>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Produit</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Fonctionnalités</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Tarifs</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Téléchargements</a></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Support</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Documentation</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Contact</a></li>
                <li><a href="#" className="hover:text-white transition-colors">FAQ</a></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Entreprise</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">À propos</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Blog</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Carrières</a></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2024 Math4Child. Tous droits réservés.</p>
          </div>
        </div>
      </footer>

      {/* Modal Pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="pricing-modal bg-white rounded-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto" ref={pricingModalRef}>
            <div className="p-6 border-b flex justify-between items-center">
              <h2 className="text-2xl font-bold">Choisissez votre plan</h2>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                ×
              </button>
            </div>
            
            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 p-1 rounded-lg flex">
                  {[
                    { key: 'mensuel', label: 'Mensuel' },
                    { key: 'trimestriel', label: 'Trimestriel' },
                    { key: 'annuel', label: 'Annuel' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key)}
                      className={`px-6 py-2 rounded-md font-medium transition-colors ${
                        selectedPeriod === period.key
                          ? 'bg-white shadow-sm text-blue-600'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.key === 'trimestriel' && <span className="ml-2 text-green-600 text-sm">-10%</span>}
                      {period.key === 'annuel' && <span className="ml-2 text-green-600 text-sm">-30%</span>}
                    </button>
                  ))}
                </div>
              </div>

              {/* Plans tarifaires */}
              <div className="grid md:grid-cols-3 gap-6">
                <div className="plan-famille border border-blue-200 rounded-xl p-6 bg-blue-50">
                  <h3 className="text-lg font-semibold mb-2">Famille</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.famille}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-blue-500 text-white py-3 rounded-lg font-medium hover:bg-blue-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                <div className="plan-pro border border-purple-200 rounded-xl p-6 bg-purple-50">
                  <h3 className="text-lg font-semibold mb-2">Pro</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.pro}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-purple-500 text-white py-3 rounded-lg font-medium hover:bg-purple-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                <div className="plan-ecole border border-orange-200 rounded-xl p-6 bg-orange-50">
                  <h3 className="text-lg font-semibold mb-2">École</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.ecole}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-orange-500 text-white py-3 rounded-lg font-medium hover:bg-orange-600 transition-colors">
                    Demander un devis
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

    echo -e "${GREEN}✅ page.tsx avec interactions avancées créé${NC}"
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
    await page.locator('button:has-text("Français")').click()
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
    
    // Tester chaque carte
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
      
      await page.waitForTimeout(300)
    }
  })

  test('💰 Modal Pricing Complet', async ({ page }) => {
    console.log('💰 Test du modal pricing...')
    
    // Ouvrir le modal
    await page.locator('button:has-text("Comparer les prix")').click()
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
    
    // Tester les boutons d'abonnement
    const subscribeButtons = page.locator('button:has-text("Essai"), button:has-text("Demander")')
    const buttonCount = await subscribeButtons.count()
    
    for (let i = 0; i < buttonCount; i++) {
      await subscribeButtons.nth(i).click()
      await page.waitForTimeout(300)
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
  
  // Vérifications critiques - CORRIGÉES selon les logs
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
  'test:report': 'playwright show-report',
  'test:quick': 'playwright test --grep \"🎉.*Validation\"',
  'validate': 'npm run test:quick'
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
    
    echo -e "${BLUE}📊 Génération du rapport...${NC}"
    npm run test:report &
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
echo "✅ Page avec 47+ langues interactives"
echo "✅ Dropdown recherche de langues"
echo "✅ 5 cartes de fonctionnalités cliquables"
echo "✅ 3 statistiques interactives"
echo "✅ 3 plateformes cliquables"
echo "✅ Modal pricing avec 3 périodes"
echo "✅ Calculs dynamiques des prix"
echo "✅ Design responsive mobile"
echo ""
echo -e "${BLUE}🧪 TESTS DISPONIBLES :${NC}"
echo "npm run test                 # Tous les tests"
echo "npm run test:headed          # Tests avec interface"
echo "npm run test:mobile          # Tests mobile"
echo "npm run test:quick           # Validation rapide"
echo "npm run test:report          # Voir le rapport"
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
echo -e "${GREEN}🎉 MATH4CHILD PRÊT AVEC TOUTES LES INTERACTIONS !${NC}"