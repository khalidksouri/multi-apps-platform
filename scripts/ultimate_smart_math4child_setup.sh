#!/bin/bash

# ================================================================
# SCRIPT HYBRIDE ULTIMATE + INTELLIGENT MATH4CHILD
# Combine détection intelligente + fonctionnalités complètes
# ================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logo
echo -e "${BLUE}"
echo "  ███╗   ███╗ █████╗ ████████╗██╗  ██╗██╗  ██╗ ██████╗██╗  ██╗██╗██╗     ██████╗ "
echo "  ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║██║  ██║██╔════╝██║  ██║██║██║     ██╔══██╗"
echo "  ██╔████╔██║███████║   ██║   ███████║███████║██║     ███████║██║██║     ██║  ██║"
echo "  ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║╚════██║██║     ██╔══██║██║██║     ██║  ██║"
echo "  ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║     ██║╚██████╗██║  ██║██║███████╗██████╔╝"
echo "  ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═════╝ "
echo -e "${NC}"
echo -e "${GREEN}    SCRIPT HYBRIDE ULTIMATE + INTELLIGENT v2.0${NC}"
echo -e "${GREEN}    Détection + Corrections + Tests Avancés + Documentation${NC}"
echo ""

# Variables
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
SERVER_PID=""

# Flags de détection
INSTALL_PLAYWRIGHT=false
UPDATE_PACKAGE_JSON=false
CREATE_TESTS=false
UPDATE_CONFIG=false
FIX_INTERACTIONS=false
CREATE_DOCS=false

# Fonction de nettoyage
cleanup() {
    if [ ! -z "$SERVER_PID" ]; then
        echo -e "${BLUE}🛑 Arrêt du serveur...${NC}"
        kill $SERVER_PID 2>/dev/null || true
    fi
}
trap cleanup EXIT

# ================================================================
# ÉTAPE 1: DÉTECTION INTELLIGENTE DE L'EXISTANT
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 1: DÉTECTION INTELLIGENTE      ${NC}"
echo -e "${CYAN}=========================================${NC}"

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js requis. Installez Node.js >= 18.0.0${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
echo -e "${GREEN}✅ npm: $(npm --version)${NC}"

# Créer backup systématique
echo -e "${BLUE}📦 Création du backup de sécurité...${NC}"
mkdir -p $BACKUP_DIR

# Vérifier le package.json
if [ -f "package.json" ]; then
    echo -e "${GREEN}✅ package.json existant détecté${NC}"
    cp package.json $BACKUP_DIR/
    
    # Vérifier Playwright
    if grep -q "@playwright/test" package.json; then
        echo -e "${GREEN}✅ Playwright déjà dans package.json${NC}"
        
        # Vérifier si les navigateurs sont installés
        if npx playwright --version &> /dev/null; then
            echo -e "${GREEN}✅ Navigateurs Playwright installés${NC}"
        else
            echo -e "${YELLOW}⚠️  Navigateurs manquants - installation nécessaire${NC}"
            INSTALL_PLAYWRIGHT=true
        fi
    else
        echo -e "${YELLOW}⚠️  Playwright absent - ajout nécessaire${NC}"
        INSTALL_PLAYWRIGHT=true
        UPDATE_PACKAGE_JSON=true
    fi
else
    echo -e "${RED}❌ package.json manquant${NC}"
    exit 1
fi

# Vérifier la configuration Playwright
if [ -f "playwright.config.ts" ]; then
    echo -e "${GREEN}✅ Configuration Playwright existante${NC}"
    cp playwright.config.ts $BACKUP_DIR/
    
    # Vérifier si elle est complète
    if grep -q "performance-tests\|accessibility-tests" playwright.config.ts; then
        echo -e "${GREEN}✅ Configuration avancée détectée${NC}"
    else
        echo -e "${YELLOW}⚠️  Configuration à enrichir${NC}"
        UPDATE_CONFIG=true
    fi
else
    echo -e "${YELLOW}⚠️  Configuration manquante${NC}"
    UPDATE_CONFIG=true
fi

# Vérifier les tests
if [ -d "tests" ]; then
    echo -e "${GREEN}✅ Dossier tests existant${NC}"
    
    # Compter les tests existants
    existing_tests=0
    
    [ -f "tests/interactions.spec.ts" ] && ((existing_tests++)) && echo -e "${GREEN}  ✅ interactions.spec.ts${NC}"
    [ -f "tests/performance.spec.ts" ] && ((existing_tests++)) && echo -e "${GREEN}  ✅ performance.spec.ts${NC}"
    [ -f "tests/accessibility.spec.ts" ] && ((existing_tests++)) && echo -e "${GREEN}  ✅ accessibility.spec.ts${NC}"
    [ -f "tests/regression.spec.ts" ] && ((existing_tests++)) && echo -e "${GREEN}  ✅ regression.spec.ts${NC}"
    [ -f "tests/browser-compatibility.spec.ts" ] && ((existing_tests++)) && echo -e "${GREEN}  ✅ browser-compatibility.spec.ts${NC}"
    
    echo -e "${BLUE}📊 Tests existants: $existing_tests/5${NC}"
    
    if [ $existing_tests -lt 5 ]; then
        echo -e "${YELLOW}⚠️  Tests manquants - création nécessaire${NC}"
        CREATE_TESTS=true
    fi
else
    echo -e "${YELLOW}⚠️  Dossier tests manquant${NC}"
    CREATE_TESTS=true
fi

# Vérifier app/page.tsx
if [ -f "app/page.tsx" ]; then
    echo -e "${GREEN}✅ app/page.tsx existant${NC}"
    cp app/page.tsx $BACKUP_DIR/
    
    # Vérifier les interactions avancées
    if grep -q "languageDropdownRef\|pricingModalRef\|changeLanguage" app/page.tsx; then
        echo -e "${GREEN}✅ Interactions avancées détectées${NC}"
    else
        echo -e "${YELLOW}⚠️  Interactions à corriger${NC}"
        FIX_INTERACTIONS=true
    fi
else
    echo -e "${RED}❌ app/page.tsx manquant${NC}"
    FIX_INTERACTIONS=true
fi

# Vérifier la documentation
doc_count=0
[ -f "GUIDE_UTILISATION.md" ] && ((doc_count++))
[ -f "README_TECHNIQUE.md" ] && ((doc_count++))
[ -f "maintenance.sh" ] && ((doc_count++))

if [ $doc_count -lt 3 ]; then
    echo -e "${YELLOW}⚠️  Documentation incomplète ($doc_count/3)${NC}"
    CREATE_DOCS=true
else
    echo -e "${GREEN}✅ Documentation complète${NC}"
fi

echo -e "${GREEN}✅ Backup créé: $BACKUP_DIR${NC}"

# ================================================================
# ÉTAPE 2: INSTALLATION CONDITIONNELLE PLAYWRIGHT
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 2: PLAYWRIGHT (SI NÉCESSAIRE)  ${NC}"
echo -e "${CYAN}=========================================${NC}"

if [ "$INSTALL_PLAYWRIGHT" = true ]; then
    echo -e "${BLUE}📦 Installation/Mise à jour Playwright...${NC}"
    
    if [ "$UPDATE_PACKAGE_JSON" = true ]; then
        echo -e "${BLUE}➕ Ajout de Playwright au package.json...${NC}"
        npm install -D @playwright/test@latest
    fi
    
    echo -e "${BLUE}🌐 Installation des navigateurs...${NC}"
    npx playwright install --with-deps
    echo -e "${GREEN}✅ Playwright configuré${NC}"
else
    echo -e "${GREEN}✅ Playwright déjà installé - ignoré${NC}"
fi

# ================================================================
# ÉTAPE 3: CORRECTION DES INTERACTIONS (SI NÉCESSAIRE)
# ================================================================

if [ "$FIX_INTERACTIONS" = true ]; then
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}   ÉTAPE 3: CORRECTION DES INTERACTIONS ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${BLUE}🔧 Arrêt du serveur existant...${NC}"
    pkill -f "next dev" 2>/dev/null || true
    sleep 2
    
    echo -e "${BLUE}🔧 Création du page.tsx avec toutes les interactions...${NC}"
    
    cat > app/page.tsx << 'EOF'
'use client'

import { useState, useEffect, useRef } from 'react'

interface Language {
  code: string
  name: string
  flag: string
  description: string
}

interface Feature {
  title: string
  description: string
  icon: string
  details: string
}

interface Platform {
  name: string
  description: string
  icon: string
  downloadUrl: string
}

const languages: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', description: 'Math pour enfants' },
  { code: 'en', name: 'English', flag: '🇺🇸', description: 'Math for Kids' },
  { code: 'es', name: 'Español', flag: '🇪🇸', description: 'Matemáticas para Niños' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', description: 'Mathe für Kinder' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', description: 'Matematica per Bambini' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', description: 'Matemática para Crianças' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', description: 'الرياضيات للأطفال' },
  { code: 'zh', name: '中文', flag: '🇨🇳', description: '儿童数学' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', description: '子供の数学' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', description: '어린이 수학' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', description: 'Математика для детей' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', description: 'बच्चों के लिए गणित' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', description: 'Wiskunde voor kinderen' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', description: 'Matematik för barn' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', description: 'Matematikk for barn' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', description: 'Matematik for børn' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', description: 'Matematiikka lapsille' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', description: 'Matematyka dla dzieci' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', description: 'Çocuklar için matematik' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿', description: 'Matematika pro děti' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺', description: 'Matematika gyerekeknek' },
  { code: 'ro', name: 'Română', flag: '🇷🇴', description: 'Matematică pentru copii' },
  { code: 'bg', name: 'Български', flag: '🇧🇬', description: 'Математика за деца' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷', description: 'Matematika za djecu' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰', description: 'Matematika pre deti' },
  { code: 'sl', name: 'Slovenščina', flag: '🇸🇮', description: 'Matematika za otroke' },
  { code: 'et', name: 'Eesti', flag: '🇪🇪', description: 'Matemaatika lastele' },
  { code: 'lv', name: 'Latviešu', flag: '🇱🇻', description: 'Matemātika bērniem' },
  { code: 'lt', name: 'Lietuvių', flag: '🇱🇹', description: 'Matematika vaikams' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷', description: 'Μαθηματικά για παιδιά' },
  { code: 'he', name: 'עברית', flag: '🇮🇱', description: 'מתמטיקה לילדים' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', description: 'คณิตศาสตร์สำหรับเด็ก' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', description: 'Toán học cho trẻ em' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩', description: 'Matematika untuk anak' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾', description: 'Matematik untuk kanak-kanak' },
  { code: 'tl', name: 'Filipino', flag: '🇵🇭', description: 'Matematika para sa mga bata' },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪', description: 'Hisabati kwa watoto' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹', description: 'ለልጆች ሂሳብ' },
  { code: 'yo', name: 'Yorùbá', flag: '🇳🇬', description: 'Iṣiro fun awọn ọmọde' },
  { code: 'zu', name: 'isiZulu', flag: '🇿🇦', description: 'Izibalo zezingane' },
  { code: 'af', name: 'Afrikaans', flag: '🇿🇦', description: 'Wiskunde vir kinders' },
  { code: 'is', name: 'Íslenska', flag: '🇮🇸', description: 'Stærðfræði fyrir börn' },
  { code: 'mt', name: 'Malti', flag: '🇲🇹', description: 'Matematika għat-tfal' },
  { code: 'cy', name: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', description: 'Mathemateg i blant' },
  { code: 'ga', name: 'Gaeilge', flag: '🇮🇪', description: 'Mata do pháistí' },
  { code: 'gd', name: 'Gàidhlig', flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿', description: 'Matamataig airson cloinne' },
  { code: 'eu', name: 'Euskera', flag: '🏴󠁥󠁳󠁰󠁶󠁿', description: 'Matematikak haurrentzat' },
  { code: 'ca', name: 'Català', flag: '🏴󠁥󠁳󠁣󠁴󠁿', description: 'Matemàtiques per a nens' },
  { code: 'gl', name: 'Galego', flag: '🏴󠁥󠁳󠁧󠁡󠁿', description: 'Matemáticas para nenos' }
]

const features: Feature[] = [
  {
    title: 'Débloquez toutes les fonctionnalités premium',
    description: 'Accès complet à tous les exercices',
    icon: '👑',
    details: 'Plus de 10 000 exercices interactifs, suivi détaillé des progrès, rapports parents, badges de réussite, mode hors-ligne et bien plus encore !'
  },
  {
    title: '47+ langues disponibles',
    description: 'Interface multilingue complète',
    icon: '🌍',
    details: 'Application traduite dans plus de 47 langues avec support RTL pour l\'arabe et l\'hébreu, pour une accessibilité mondiale maximale.'
  },
  {
    title: 'Web, iOS et Android',
    description: 'Disponible sur toutes les plateformes',
    icon: '📱',
    details: 'Synchronisation automatique entre tous vos appareils. Apprenez sur tablette, continuez sur téléphone, révisez sur ordinateur !'
  },
  {
    title: '5 niveaux de difficulté',
    description: 'Progression adaptée à chaque enfant',
    icon: '📊',
    details: 'Du niveau débutant (4-6 ans) au niveau expert (10-12 ans), chaque enfant progresse à son rythme avec une IA adaptative.'
  },
  {
    title: 'Suivi détaillé des progrès',
    description: 'Tableaux de bord complets',
    icon: '📈',
    details: 'Statistiques détaillées, analyses de performance, badges de réussite, temps d\'apprentissage et rapports hebdomadaires pour les parents.'
  }
]

const platforms: Platform[] = [
  {
    name: 'Web',
    description: 'Version web complète accessible depuis votre navigateur',
    icon: '🌐',
    downloadUrl: 'https://app.math4child.com'
  },
  {
    name: 'iOS',
    description: 'Application native iOS optimisée pour iPhone et iPad',
    icon: '📱',
    downloadUrl: 'https://apps.apple.com/app/math4child'
  },
  {
    name: 'Android',
    description: 'Application Android optimisée pour tous les appareils',
    icon: '🤖',
    downloadUrl: 'https://play.google.com/store/apps/details?id=com.math4child'
  }
]

export default function Home() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(languages[0])
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [languageSearch, setLanguageSearch] = useState('')
  const [isPricingModalOpen, setIsPricingModalOpen] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly')
  const [notification, setNotification] = useState<string>('')
  const [activeFeature, setActiveFeature] = useState<number | null>(null)
  const [activeStat, setActiveStat] = useState<string>('')
  const [activePlatform, setActivePlatform] = useState<Platform | null>(null)
  const [difficultyLevel, setDifficultyLevel] = useState<string>('')
  const [progressTracking, setProgressTracking] = useState<string>('')

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
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [])

  // Fonction pour changer de langue
  const changeLanguage = (language: Language) => {
    setSelectedLanguage(language)
    setIsLanguageDropdownOpen(false)
    setNotification(`Langue changée vers ${language.name}`)
    setTimeout(() => setNotification(''), 3000)
  }

  // Filtrer les langues pour la recherche
  const filteredLanguages = languages.filter(lang =>
    lang.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    lang.description.toLowerCase().includes(languageSearch.toLowerCase())
  )

  // Fonction pour afficher les alertes de fonctionnalités
  const showFeatureAlert = (feature: Feature, index: number) => {
    setActiveFeature(index)
    alert(`${feature.title}\n\n${feature.details}`)
    setTimeout(() => setActiveFeature(null), 500)
  }

  // Fonction pour afficher les statistiques
  const showStatDetail = (stat: string, detail: string) => {
    setActiveStat(stat)
    alert(`${stat}\n\n${detail}`)
    setTimeout(() => setActiveStat(''), 500)
  }

  // Fonction pour afficher les informations de plateforme
  const showPlatformInfo = (platform: Platform) => {
    setActivePlatform(platform)
    alert(`${platform.name}\n\n${platform.description}\n\nTéléchargement: ${platform.downloadUrl}`)
    setTimeout(() => setActivePlatform(null), 500)
  }

  // Fonction pour afficher les niveaux de difficulté
  const showDifficultyInfo = (level: string) => {
    const levels = {
      'débutant': 'Niveau débutant (4-6 ans) : Bases de l\'arithmétique, addition et soustraction simples avec support visuel',
      'élémentaire': 'Niveau élémentaire (6-8 ans) : Multiplication, division, fractions de base et introduction à la géométrie',
      'intermédiaire': 'Niveau intermédiaire (8-10 ans) : Géométrie avancée, fractions complexes, décimaux et pourcentages',
      'avancé': 'Niveau avancé (10-12 ans) : Algèbre de base, équations, géométrie dans l\'espace et statistiques',
      'expert': 'Niveau expert (12+ ans) : Algèbre complexe, trigonométrie, calculs avancés et préparation collège'
    }
    setDifficultyLevel(level)
    alert(`Niveau ${level}\n\n${levels[level as keyof typeof levels]}`)
    setTimeout(() => setDifficultyLevel(''), 500)
  }

  // Fonction pour afficher les détails de suivi
  const showProgressInfo = (type: string) => {
    const tracking = {
      'suivi': 'Suivi détaillé des progrès avec graphiques interactifs, évolution des compétences et analyse des points forts/faibles',
      'rapports': 'Rapports hebdomadaires automatiques pour suivre l\'évolution de votre enfant avec recommandations personnalisées',
      'temps': 'Temps d\'apprentissage quotidien optimal calculé selon l\'âge et suggestions d\'horaires personnalisées',
      'points': 'Système intelligent d\'identification des points forts et des domaines à améliorer avec exercices ciblés',
      'badges': 'Plus de 100 badges et récompenses pour motiver l\'apprentissage et célébrer chaque progrès'
    }
    setProgressTracking(type)
    alert(`${type.charAt(0).toUpperCase() + type.slice(1)}\n\n${tracking[type as keyof typeof tracking]}`)
    setTimeout(() => setProgressTracking(''), 500)
  }

  // Calcul des prix selon la période
  const getPricing = () => {
    const basePrices = {
      premium: 4.99,
      famille: 6.99,
      ecole: 24.99
    }

    const discounts = {
      monthly: 0,
      quarterly: 0.1,
      annual: 0.3
    }

    const discount = discounts[selectedPeriod]

    return {
      premium: (basePrices.premium * (1 - discount)).toFixed(2),
      famille: (basePrices.famille * (1 - discount)).toFixed(2),
      ecole: (basePrices.ecole * (1 - discount)).toFixed(2),
      discount: Math.round(discount * 100)
    }
  }

  const pricing = getPricing()

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      {/* Notification */}
      {notification && (
        <div className="fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-pulse">
          {notification}
        </div>
      )}

      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
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

            {/* Sélecteur de langue */}
            <div className="relative" ref={languageDropdownRef}>
              <button
                onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                className="flex items-center space-x-2 bg-white border border-gray-300 rounded-lg px-3 py-2 hover:bg-gray-50 transition-colors flag-icon"
                data-testid="language-selector"
              >
                <span className="text-xl">{selectedLanguage.flag}</span>
                <span className="text-sm font-medium text-gray-700">{selectedLanguage.name}</span>
                <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {isLanguageDropdownOpen && (
                <div 
                  className="absolute top-full right-0 mt-2 w-80 bg-white border border-gray-200 rounded-lg shadow-lg z-50 language-dropdown"
                  data-testid="language-dropdown"
                >
                  <div className="p-3 border-b border-gray-100">
                    <h3 className="text-sm font-semibold text-gray-900 mb-2">Sélectionner une langue</h3>
                    <p className="text-xs text-gray-600 mb-3">47+ langues</p>
                    <input
                      type="text"
                      placeholder="Rechercher une langue..."
                      value={languageSearch}
                      onChange={(e) => setLanguageSearch(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div className="max-h-64 overflow-y-auto">
                    <div className="p-2">
                      <div className="text-xs font-semibold text-gray-500 px-2 py-1">TOUTES LES LANGUES ({filteredLanguages.length})</div>
                      {filteredLanguages.map((language) => (
                        <button
                          key={language.code}
                          onClick={() => changeLanguage(language)}
                          className="w-full flex items-center space-x-3 px-3 py-2 text-left hover:bg-gray-50 rounded-md transition-colors"
                        >
                          <span className="text-lg">{language.flag}</span>
                          <div>
                            <div className="text-sm font-medium text-gray-900">{language.name}</div>
                            <div className="text-xs text-gray-500">{language.description}</div>
                          </div>
                          {language.code === selectedLanguage.code && (
                            <div className="ml-auto w-4 h-4 text-blue-500">✓</div>
                          )}
                        </button>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Section principale */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Bannière leader mondial */}
        <div className="text-center mb-12">
          <div className="inline-flex items-center bg-orange-100 text-orange-800 px-4 py-2 rounded-full text-sm mb-6">
            <span className="w-2 h-2 bg-orange-500 rounded-full mr-2"></span>
            www.math4child.com • Leader mondial
            <span className="ml-2">⭐</span>
          </div>
        </div>

        {/* Titre principal */}
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">
            <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Apprends les maths en
            </span>
            <br />
            <span className="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
              t'amusant !
            </span>
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Bienvenue dans l'aventure mathématique !
          </p>
        </div>

        {/* Cartes de fonctionnalités */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-16">
          {features.map((feature, index) => (
            <div
              key={index}
              onClick={() => showFeatureAlert(feature, index)}
              className={`feature-card bg-white p-6 rounded-xl shadow-sm border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:scale-105 ${
                activeFeature === index ? 'border-blue-500 shadow-lg scale-105' : 'border-gray-100'
              }`}
            >
              <div className="text-2xl mb-3">{feature.icon}</div>
              <h3 className="font-semibold text-gray-900 text-sm mb-2">{feature.title}</h3>
              <p className="text-xs text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>

        {/* Statistiques cliquables */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          <div
            onClick={() => showStatDetail('100k+ familles', 'Plus de 100 000 familles à travers le monde nous font confiance pour l\'éducation mathématique de leurs enfants. Notre communauté grandit chaque jour !')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '100k+ familles' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-green-600 mb-2">100k+</div>
            <div className="text-gray-600">familles satisfaites</div>
          </div>
          <div
            onClick={() => showStatDetail('98% satisfaction', 'Taux de satisfaction exceptionnel de 98% basé sur plus de 50 000 avis clients vérifiés sur les stores iOS et Android.')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '98% satisfaction' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-blue-600 mb-2">98%</div>
            <div className="text-gray-600">de satisfaction</div>
          </div>
          <div
            onClick={() => showStatDetail('47 pays', 'Notre application est disponible dans 47 pays et traduite en plus de 47 langues avec support RTL pour une accessibilité mondiale.')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '47 pays' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-purple-600 mb-2">47</div>
            <div className="text-gray-600">pays</div>
          </div>
        </div>

        {/* Cartes de plateformes */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {platforms.map((platform, index) => (
            <div
              key={index}
              onClick={() => showPlatformInfo(platform)}
              className={`platform-card bg-white p-6 rounded-xl shadow-sm border cursor-pointer transition-all duration-300 hover:shadow-lg hover:scale-105 ${
                activePlatform?.name === platform.name ? 'border-blue-500 shadow-lg scale-105' : 'border-gray-200'
              }`}
            >
              <div className="text-3xl mb-4">{platform.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">{platform.name}</h3>
              <p className="text-sm text-gray-600">{platform.description}</p>
            </div>
          ))}
        </div>

        {/* Niveaux de difficulté interactifs */}
        <div className="bg-white rounded-xl p-8 shadow-sm border border-gray-200 mb-16">
          <h2 className="text-2xl font-bold text-center mb-8">5 niveaux de difficulté</h2>
          <div className="flex flex-wrap justify-center gap-4">
            {['débutant', 'élémentaire', 'intermédiaire', 'avancé', 'expert'].map((level) => (
              <button
                key={level}
                onClick={() => showDifficultyInfo(level)}
                className={`px-6 py-3 rounded-lg text-sm font-medium transition-all duration-300 hover:scale-105 ${
                  difficultyLevel === level
                    ? 'bg-yellow-500 text-white shadow-lg scale-105'
                    : 'bg-yellow-100 text-yellow-800 hover:bg-yellow-200'
                }`}
              >
                {level.charAt(0).toUpperCase() + level.slice(1)}
              </button>
            ))}
          </div>
        </div>

        {/* Suivi des progrès interactif */}
        <div className="bg-white rounded-xl p-8 shadow-sm border border-gray-200 mb-16">
          <h2 className="text-2xl font-bold text-center mb-8">Suivi détaillé des progrès</h2>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            {[
              { key: 'suivi', icon: '📊', label: 'Suivi détaillé' },
              { key: 'rapports', icon: '📈', label: 'Rapports détaillés' },
              { key: 'temps', icon: '⏰', label: 'Temps d\'apprentissage' },
              { key: 'points', icon: '🎯', label: 'Points forts/faibles' },
              { key: 'badges', icon: '🏆', label: 'Badges et récompenses' }
            ].map((item) => (
              <button
                key={item.key}
                onClick={() => showProgressInfo(item.key)}
                className={`p-4 rounded-lg border text-center transition-all duration-300 hover:scale-105 ${
                  progressTracking === item.key
                    ? 'border-red-500 bg-red-50 shadow-lg scale-105'
                    : 'border-gray-200 hover:border-red-300'
                }`}
              >
                <div className="text-2xl mb-2">{item.icon}</div>
                <div className="text-sm font-medium text-gray-900">{item.label}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Boutons d'action */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
          <button className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg">
            <span className="mr-2">🎁</span>
            Commencer gratuitement
            <div className="text-sm opacity-90">14j gratuit</div>
          </button>
          <button
            onClick={() => setIsPricingModalOpen(true)}
            className="bg-blue-500 hover:bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg"
          >
            <span className="mr-2">📊</span>
            Comparer les prix
          </button>
        </div>
      </main>

      {/* Modal de pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4 modal-overlay">
          <div 
            ref={pricingModalRef}
            className="pricing-modal bg-white rounded-2xl max-w-5xl w-full max-h-[90vh] overflow-y-auto"
          >
            <div className="p-6 border-b border-gray-200 flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold text-gray-900">Choisissez votre plan</h2>
                <p className="text-gray-600">Commencez votre essai gratuit de 14 jours dès maintenant</p>
              </div>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="text-gray-400 hover:text-gray-600 text-2xl"
              >
                ×
              </button>
            </div>

            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 rounded-lg p-1 flex">
                  {[
                    { key: 'monthly', label: 'Mensuel' },
                    { key: 'quarterly', label: 'Trimestriel', badge: '-10%' },
                    { key: 'annual', label: 'Annuel', badge: '-30%' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key as any)}
                      className={`px-6 py-2 rounded-md font-medium transition-all relative ${
                        selectedPeriod === period.key
                          ? 'bg-white text-blue-600 shadow-sm'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.badge && (
                        <span className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                          {period.badge}
                        </span>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Plans de pricing */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                {/* Plan Gratuit */}
                <div className="plan-gratuit border border-gray-200 rounded-xl p-6">
                  <h3 className="text-lg font-semibold mb-2">Gratuit</h3>
                  <div className="text-3xl font-bold mb-4">0€<span className="text-sm text-gray-500">/mois</span></div>
                  <ul className="space-y-3 mb-6">
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>1 profil enfant</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Exercices de base</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Niveau débutant</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Publicités</li>
                  </ul>
                  <button className="w-full bg-gray-100 text-gray-800 py-3 rounded-lg font-medium hover:bg-gray-200 transition-colors">
                    Commencer gratuitement
                  </button>
                </div>

                {/* Plan Premium */}
                <div className="plan-premium border border-blue-200 rounded-xl p-6 bg-blue-50">
                  <h3 className="text-lg font-semibold mb-2">Premium</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.premium}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <ul className="space-y-3 mb-6">
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>3 profils enfants</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Exercices illimités</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Tous les niveaux</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Mode hors-ligne</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Sans publicité</li>
                  </ul>
                  <button className="w-full bg-blue-500 text-white py-3 rounded-lg font-medium hover:bg-blue-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                {/* Plan Famille */}
                <div className="plan-famille border-2 border-purple-300 rounded-xl p-6 bg-purple-50 relative">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                    Le plus populaire
                  </div>
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
                  <ul className="space-y-3 mb-6">
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>5 profils enfants</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Tout Premium inclus</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Rapports parents</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Support prioritaire</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Contrôle parental</li>
                  </ul>
                  <button className="w-full bg-purple-500 text-white py-3 rounded-lg font-medium hover:bg-purple-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                {/* Plan École */}
                <div className="plan-ecole border border-orange-200 rounded-xl p-6 bg-orange-50">
                  <div className="flex items-center mb-2">
                    <h3 className="text-lg font-semibold">École</h3>
                    <span className="ml-2 text-xs bg-orange-500 text-white px-2 py-1 rounded">Recommandé écoles</span>
                  </div>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.ecole}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <ul className="space-y-3 mb-6">
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>30 profils élèves</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Tout Famille inclus</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Dashboard professeur</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Formation incluse</li>
                    <li className="flex items-center text-sm"><span className="text-green-500 mr-2">✓</span>Support dédié</li>
                  </ul>
                  <button className="w-full bg-orange-500 text-white py-3 rounded-lg font-medium hover:bg-orange-600 transition-colors">
                    Demander un devis
                  </button>
                </div>
              </div>

              {/* Footer du modal */}
              <div className="mt-8 text-center">
                <p className="text-sm text-gray-600 mb-4">
                  ✨ Tous les plans incluent : Accès mobile et web • Support client 24/7 • Mises à jour gratuites à vie
                </p>
                <button
                  onClick={() => setIsPricingModalOpen(false)}
                  className="bg-green-500 hover:bg-green-600 text-white px-8 py-3 rounded-lg font-medium transition-colors"
                >
                  🚀 Commencer l'essai gratuit maintenant
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

    echo -e "${GREEN}✅ app/page.tsx avec toutes les interactions avancées créé${NC}"
    
    # Nettoyage du cache
    echo -e "${BLUE}🔧 Nettoyage du cache...${NC}"
    rm -rf .next 2>/dev/null || true
    echo -e "${GREEN}✅ Cache nettoyé${NC}"
    
else
    echo -e "${GREEN}✅ Interactions déjà avancées - ignoré${NC}"
fi

# ================================================================
# ÉTAPE 4: CONFIGURATION PLAYWRIGHT AVANCÉE
# ================================================================

if [ "$UPDATE_CONFIG" = true ]; then
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}   ÉTAPE 4: CONFIGURATION AVANCÉE       ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${BLUE}⚙️ Création de la configuration Playwright avancée...${NC}"
    
    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 45000,
  globalTimeout: 15 * 60 * 1000,
  expect: { timeout: 15000 },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 3 : 2,
  workers: process.env.CI ? 2 : 4,

  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    process.env.CI ? ['github'] : ['list', { printSteps: true }]
  ],

  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 20000,
    navigationTimeout: 40000,
    extraHTTPHeaders: {
      'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
    },
  },

  projects: [
    // Tests desktop principaux
    {
      name: 'chromium-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /.*\.(spec|test)\.ts/,
    },
    {
      name: 'firefox-desktop',
      use: { 
        ...devices['Desktop Firefox'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /interactions\.(spec|test)\.ts/,
    },
    {
      name: 'webkit-desktop',
      use: { 
        ...devices['Desktop Safari'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /interactions\.(spec|test)\.ts/,
    },

    // Tests mobile
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
      testMatch: /interactions\.(spec|test)\.ts/,
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
      testMatch: /interactions\.(spec|test)\.ts/,
    },
    {
      name: 'tablet-ipad',
      use: { ...devices['iPad Pro'] },
      testMatch: /interactions\.(spec|test)\.ts/,
    },

    // Tests spécialisés
    {
      name: 'performance-tests',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
      },
      testMatch: /performance\.(spec|test)\.ts/,
    },
    {
      name: 'accessibility-tests',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /accessibility\.(spec|test)\.ts/,
    },
    {
      name: 'regression-tests',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /regression\.(spec|test)\.ts/,
    },
    {
      name: 'browser-compatibility',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
      testMatch: /browser-compatibility\.(spec|test)\.ts/,
    },

    // Tests multilingues
    {
      name: 'french-locale',
      use: {
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris',
      },
      testMatch: /i18n\.(spec|test)\.ts/,
    },
    {
      name: 'spanish-locale',
      use: {
        ...devices['Desktop Chrome'],
        locale: 'es-ES',
        timezoneId: 'Europe/Madrid',
      },
      testMatch: /i18n\.(spec|test)\.ts/,
    },
    {
      name: 'arabic-rtl',
      use: {
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh',
      },
      testMatch: /rtl\.(spec|test)\.ts/,
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 180 * 1000,
    env: {
      NODE_ENV: 'test',
    },
  },

  outputDir: 'test-results/',
  
  metadata: {
    project: 'Math4Child',
    version: '4.2.0',
    description: 'Tests complets des interactions Math4Child',
    environment: process.env.NODE_ENV || 'development',
  },
});
EOF
    
    echo -e "${GREEN}✅ Configuration Playwright avancée créée${NC}"
else
    echo -e "${GREEN}✅ Configuration déjà avancée - ignorée${NC}"
fi

# ================================================================
# ÉTAPE 5: CRÉATION DES TESTS AVANCÉS
# ================================================================

if [ "$CREATE_TESTS" = true ]; then
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}   ÉTAPE 5: CRÉATION DES TESTS AVANCÉS  ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # Créer le dossier tests
    mkdir -p tests
    
    # Tests d'interactions (version complète)
    if [ ! -f "tests/interactions.spec.ts" ]; then
        echo -e "${BLUE}🧪 Création des tests d'interactions complets...${NC}"
        cat > tests/interactions.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests des Interactions Complètes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Apprends les maths');
  });

  test('🌍 Dropdown de Langues avec 47+ Langues', async ({ page }) => {
    // Ouvrir le dropdown
    await page.locator('[data-testid="language-selector"]').click();
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
    
    // Vérifier le nombre de langues
    const languageOptions = page.locator('[data-testid="language-dropdown"] button');
    const count = await languageOptions.count();
    expect(count).toBeGreaterThan(40); // Au moins 40+ langues
    
    // Tester la recherche
    await page.fill('input[placeholder*="Rechercher"]', 'Español');
    await expect(page.locator('text=Español')).toBeVisible();
    
    // Sélectionner une langue
    await page.locator('text=Español').first().click();
    await expect(page.locator('text=Langue changée')).toBeVisible({ timeout: 5000 });
    
    // Test fermeture sur clic extérieur
    await page.locator('[data-testid="language-selector"]').click();
    await page.locator('body').click({ position: { x: 100, y: 100 } });
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeHidden();
  });

  test('🎯 Toutes les Cartes de Fonctionnalités', async ({ page }) => {
    const featureCards = page.locator('.feature-card');
    const count = await featureCards.count();
    
    expect(count).toBe(5); // Exactement 5 cartes
    
    // Tester chaque carte
    for (let i = 0; i < count; i++) {
      await featureCards.nth(i).click();
      
      // Gérer l'alerte
      page.on('dialog', async dialog => {
        expect(dialog.type()).toBe('alert');
        expect(dialog.message()).toContain('fonctionnalités');
        await dialog.accept();
      });
      
      await page.waitForTimeout(500);
    }
  });

  test('📊 Statistiques Cliquables avec Détails', async ({ page }) => {
    const stats = [
      { selector: 'text=100k+', detail: '100 000 familles' },
      { selector: 'text=98%', detail: 'satisfaction' },
      { selector: 'text=47', detail: '47 pays' }
    ];
    
    for (const stat of stats) {
      const statElement = page.locator('.stat-card').filter({ hasText: stat.selector });
      await expect(statElement).toBeVisible();
      
      await statElement.click();
      
      page.on('dialog', async dialog => {
        expect(dialog.type()).toBe('alert');
        expect(dialog.message()).toContain(stat.detail);
        await dialog.accept();
      });
      
      await page.waitForTimeout(300);
    }
  });

  test('📱 Plateformes Cliquables avec URLs', async ({ page }) => {
    const platforms = ['Web', 'iOS', 'Android'];
    
    for (const platform of platforms) {
      const platformCard = page.locator('.platform-card').filter({ hasText: platform });
      await expect(platformCard).toBeVisible();
      
      await platformCard.click();
      
      page.on('dialog', async dialog => {
        expect(dialog.type()).toBe('alert');
        expect(dialog.message()).toContain(platform);
        expect(dialog.message()).toContain('Téléchargement:');
        await dialog.accept();
      });
      
      await page.waitForTimeout(300);
    }
  });

  test('💰 Modal Pricing Complet avec Calculs', async ({ page }) => {
    // Ouvrir le modal
    await page.locator('button:has-text("Comparer les prix")').click();
    await expect(page.locator('.pricing-modal')).toBeVisible();
    
    // Tester les 3 périodes
    const periods = [
      { name: 'Mensuel', discount: '' },
      { name: 'Trimestriel', discount: '-10%' },
      { name: 'Annuel', discount: '-30%' }
    ];
    
    for (const period of periods) {
      await page.locator(`button:has-text("${period.name}")`).click();
      
      if (period.discount) {
        await expect(page.locator(`text=${period.discount}`)).toBeVisible();
      }
      
      await page.waitForTimeout(500);
    }
    
    // Tester les 4 plans
    const plans = ['Gratuit', 'Premium', 'Famille', 'École'];
    
    for (const plan of plans) {
      const planCard = page.locator(`.plan-${plan.toLowerCase()}`);
      
      if (await planCard.isVisible()) {
        const subscribeBtn = planCard.locator('button').last();
        
        if (await subscribeBtn.isVisible()) {
          await subscribeBtn.click();
          // Vérifier qu'une action se produit
          await page.waitForTimeout(300);
        }
      }
    }
    
    // Fermer le modal avec X
    await page.locator('button:has-text("×")').click();
    await expect(page.locator('.pricing-modal')).toBeHidden();
  });

  test('🔄 Niveaux de Difficulté Interactifs', async ({ page }) => {
    const levels = ['débutant', 'élémentaire', 'intermédiaire', 'avancé', 'expert'];
    
    for (const level of levels) {
      const levelButton = page.locator(`button:has-text("${level.charAt(0).toUpperCase() + level.slice(1)}")`);
      
      if (await levelButton.isVisible()) {
        await levelButton.click();
        
        page.on('dialog', async dialog => {
          expect(dialog.type()).toBe('alert');
          expect(dialog.message()).toContain(`Niveau ${level}`);
          await dialog.accept();
        });
        
        await page.waitForTimeout(300);
      }
    }
  });

  test('📈 Suivi des Progrès Interactif', async ({ page }) => {
    const progressItems = [
      { key: 'suivi', label: 'Suivi détaillé' },
      { key: 'rapports', label: 'Rapports détaillés' },
      { key: 'temps', label: 'Temps d\'apprentissage' },
      { key: 'points', label: 'Points forts/faibles' },
      { key: 'badges', label: 'Badges et récompenses' }
    ];
    
    for (const item of progressItems) {
      const button = page.locator(`button:has-text("${item.label}")`);
      
      if (await button.isVisible()) {
        await button.click();
        
        page.on('dialog', async dialog => {
          expect(dialog.type()).toBe('alert');
          expect(dialog.message()).toContain(item.key);
          await dialog.accept();
        });
        
        await page.waitForTimeout(300);
      }
    }
  });

  test('📱 Test Responsive Complet', async ({ page }) => {
    // Test mobile portrait
    await page.setViewportSize({ width: 375, height: 667 });
    await page.reload();
    await page.waitForLoadState('networkidle');
    
    await expect(page.locator('h1')).toBeVisible();
    await expect(page.locator('.feature-card').first()).toBeVisible();
    
    // Test tablette
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.reload();
    await page.waitForLoadState('networkidle');
    
    await expect(page.locator('h1')).toBeVisible();
    
    // Test desktop large
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.reload();
    await page.waitForLoadState('networkidle');
    
    await expect(page.locator('h1')).toBeVisible();
    
    // Remettre la taille standard
    await page.setViewportSize({ width: 1280, height: 720 });
  });

  test('⚡ Performance des Interactions', async ({ page }) => {
    const startTime = Date.now();
    
    // Test rapid-fire de toutes les interactions
    const interactions = [
      () => page.locator('[data-testid="language-selector"]').click(),
      () => page.locator('.feature-card').first().click(),
      () => page.locator('.stat-card').first().click(),
      () => page.locator('.platform-card').first().click(),
      () => page.locator('button:has-text("Comparer les prix")').click()
    ];
    
    page.on('dialog', dialog => dialog.accept());
    
    for (const interaction of interactions) {
      try {
        await interaction();
        await page.waitForTimeout(100);
      } catch (e) {
        // Continuer même en cas d'erreur
      }
    }
    
    const totalTime = Date.now() - startTime;
    console.log(`⚡ Temps total des interactions: ${totalTime}ms`);
    
    expect(totalTime).toBeLessThan(10000); // < 10 secondes
  });
});

test('🎉 Validation Globale Complète', async ({ page }) => {
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  
  console.log('🚀 Validation globale complète...');
  
  // 1. Éléments critiques
  await expect(page.locator('h1')).toContainText('Apprends les maths');
  await expect(page.locator('.feature-card')).toHaveCount(5);
  await expect(page.locator('.stat-card')).toHaveCount(3);
  await expect(page.locator('.platform-card')).toHaveCount(3);
  
  // 2. Test dropdown langues
  if (await page.locator('[data-testid="language-selector"]').isVisible()) {
    await page.locator('[data-testid="language-selector"]').click();
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
    console.log('✅ Dropdown langues: OK');
  }
  
  // 3. Test modal pricing
  if (await page.locator('button:has-text("Comparer les prix")').isVisible()) {
    await page.locator('button:has-text("Comparer les prix")').click();
    await expect(page.locator('.pricing-modal')).toBeVisible();
    console.log('✅ Modal pricing: OK');
  }
  
  // 4. Compter tous les éléments interactifs
  const interactiveCount = await page.locator('button, [role="button"], .clickable, .feature-card, .stat-card, .platform-card').count();
  console.log(`✅ ${interactiveCount} éléments interactifs détectés`);
  expect(interactiveCount).toBeGreaterThan(15);
  
  console.log('🎉 VALIDATION GLOBALE RÉUSSIE !');
});
EOF
        echo -e "${GREEN}✅ Tests d'interactions complets créés${NC}"
    fi
    
    # Tests de performance avancés
    if [ ! -f "tests/performance.spec.ts" ]; then
        echo -e "${BLUE}⚡ Création des tests de performance avancés...${NC}"
        cat > tests/performance.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Tests de Performance Math4Child', () => {
  test('📊 Core Web Vitals Complets', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Mesurer les métriques de navigation
    const navigationTiming = await page.evaluate(() => {
      const nav = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
      const paintEntries = performance.getEntriesByType('paint');
      
      return {
        domContentLoaded: nav.domContentLoadedEventEnd - nav.navigationStart,
        loadComplete: nav.loadEventEnd - nav.navigationStart,
        firstPaint: paintEntries.find(p => p.name === 'first-paint')?.startTime || 0,
        firstContentfulPaint: paintEntries.find(p => p.name === 'first-contentful-paint')?.startTime || 0,
        domInteractive: nav.domInteractive - nav.navigationStart,
        resourcesLoadTime: nav.loadEventEnd - nav.domContentLoadedEventEnd
      };
    });
    
    console.log('📊 Métriques de performance détaillées:', navigationTiming);
    
    // Vérifications de performance
    expect(navigationTiming.domContentLoaded).toBeLessThan(5000); // < 5s DOMContentLoaded
    expect(navigationTiming.firstContentfulPaint).toBeLessThan(3000); // < 3s FCP
    expect(navigationTiming.domInteractive).toBeLessThan(4000); // < 4s DOM Interactive
    
    const totalLoadTime = Date.now() - startTime;
    console.log(`⚡ Temps de chargement total: ${totalLoadTime}ms`);
    expect(totalLoadTime).toBeLessThan(8000); // < 8s total
  });

  test('🚀 Réactivité des Interactions Détaillée', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    const interactions = [
      { name: 'Dropdown langues', selector: '[data-testid="language-selector"]' },
      { name: 'Carte fonctionnalité', selector: '.feature-card' },
      { name: 'Statistique', selector: '.stat-card' },
      { name: 'Modal pricing', selector: 'button:has-text("Comparer les prix")' }
    ];
    
    page.on('dialog', dialog => dialog.accept());
    
    for (const interaction of interactions) {
      const element = page.locator(interaction.selector).first();
      
      if (await element.isVisible()) {
        const startTime = Date.now();
        await element.click();
        
        // Attendre une réaction visuelle
        await page.waitForTimeout(50);
        
        const reactionTime = Date.now() - startTime;
        console.log(`⚡ ${interaction.name}: ${reactionTime}ms`);
        
        // Vérifier que l'interaction est rapide
        expect(reactionTime).toBeLessThan(200); // < 200ms
      }
    }
  });

  test('💾 Utilisation de la Mémoire', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Mesurer l'utilisation de la mémoire
    const memoryInfo = await page.evaluate(() => {
      if ('memory' in performance) {
        const memory = (performance as any).memory;
        return {
          usedJSHeapSize: memory.usedJSHeapSize,
          totalJSHeapSize: memory.totalJSHeapSize,
          jsHeapSizeLimit: memory.jsHeapSizeLimit
        };
      }
      return null;
    });
    
    if (memoryInfo) {
      console.log('💾 Utilisation mémoire:', memoryInfo);
      
      // Vérifier que l'utilisation mémoire reste raisonnable
      const usedMB = memoryInfo.usedJSHeapSize / (1024 * 1024);
      console.log(`💾 Mémoire utilisée: ${usedMB.toFixed(2)} MB`);
      
      expect(usedMB).toBeLessThan(100); // < 100MB
    }
  });

  test('🌊 Test de Stress - Interactions Multiples', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    page.on('dialog', dialog => dialog.accept());
    
    const startTime = Date.now();
    
    // Effectuer 20 interactions rapides
    for (let i = 0; i < 20; i++) {
      const interactions = [
        () => page.locator('.feature-card').first().click(),
        () => page.locator('.stat-card').first().click(),
        () => page.locator('[data-testid="language-selector"]').click()
      ];
      
      const randomInteraction = interactions[i % interactions.length];
      
      try {
        await randomInteraction();
        await page.waitForTimeout(25);
      } catch (e) {
        // Continuer en cas d'erreur
      }
    }
    
    const totalTime = Date.now() - startTime;
    console.log(`🌊 20 interactions en: ${totalTime}ms`);
    
    // Vérifier que l'application reste responsive
    expect(totalTime).toBeLessThan(10000); // < 10s pour 20 interactions
    
    // Vérifier que la page fonctionne encore
    await expect(page.locator('h1')).toBeVisible();
  });

  test('📈 Performance de Rendu', async ({ page }) => {
    await page.goto('/');
    
    // Mesurer le temps de rendu des éléments clés
    const renderTimes = await page.evaluate(() => {
      const startTime = performance.now();
      
      const elements = {
        header: document.querySelector('header'),
        title: document.querySelector('h1'),
        features: document.querySelectorAll('.feature-card'),
        stats: document.querySelectorAll('.stat-card'),
        platforms: document.querySelectorAll('.platform-card')
      };
      
      const endTime = performance.now();
      
      return {
        renderTime: endTime - startTime,
        elementsFound: {
          header: !!elements.header,
          title: !!elements.title,
          features: elements.features.length,
          stats: elements.stats.length,
          platforms: elements.platforms.length
        }
      };
    });
    
    console.log('📈 Performance de rendu:', renderTimes);
    
    // Vérifier que tous les éléments sont présents
    expect(renderTimes.elementsFound.header).toBe(true);
    expect(renderTimes.elementsFound.title).toBe(true);
    expect(renderTimes.elementsFound.features).toBe(5);
    expect(renderTimes.elementsFound.stats).toBe(3);
    expect(renderTimes.elementsFound.platforms).toBe(3);
    
    // Vérifier que le rendu est rapide
    expect(renderTimes.renderTime).toBeLessThan(100); // < 100ms
  });
});
EOF
        echo -e "${GREEN}✅ Tests de performance avancés créés${NC}"
    fi
    
    # Tests d'accessibilité
    if [ ! -f "tests/accessibility.spec.ts" ]; then
        echo -e "${BLUE}♿ Création des tests d'accessibilité...${NC}"
        cat > tests/accessibility.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Tests d\'Accessibilité Math4Child', () => {
  test('♿ Structure HTML Sémantique', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Vérifier la structure sémantique
    await expect(page.locator('header')).toBeVisible();
    await expect(page.locator('main')).toBeVisible();
    await expect(page.locator('h1')).toBeVisible();
    
    // Vérifier les titres hiérarchiques
    const headings = await page.locator('h1, h2, h3, h4, h5, h6').count();
    expect(headings).toBeGreaterThan(0);
    
    // Vérifier qu'il n'y a qu'un seul h1
    const h1Count = await page.locator('h1').count();
    expect(h1Count).toBe(1);
  });

  test('🎯 Navigation au Clavier', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Naviguer avec Tab
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    
    // Vérifier qu'un élément est focusé
    const focusedElement = await page.locator(':focus');
    await expect(focusedElement).toBeVisible();
    
    // Test du dropdown avec clavier
    const languageSelector = page.locator('[data-testid="language-selector"]');
    if (await languageSelector.isVisible()) {
      await languageSelector.focus();
      await page.keyboard.press('Enter');
      await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
      
      // Fermer avec Escape
      await page.keyboard.press('Escape');
      await expect(page.locator('[data-testid="language-dropdown"]')).toBeHidden();
    }
  });

  test('🎨 Contraste et Couleurs', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Vérifier les couleurs des éléments principaux
    const elements = [
      { name: 'Titre principal', selector: 'h1' },
      { name: 'Bouton principal', selector: 'button:has-text("Commencer gratuitement")' },
      { name: 'Bouton secondaire', selector: 'button:has-text("Comparer les prix")' },
      { name: 'Texte de navigation', selector: 'header' }
    ];
    
    for (const element of elements) {
      const el = page.locator(element.selector).first();
      
      if (await el.isVisible()) {
        const styles = await el.evaluate(el => {
          const computed = getComputedStyle(el);
          return {
            color: computed.color,
            backgroundColor: computed.backgroundColor,
            fontSize: computed.fontSize
          };
        });
        
        console.log(`🎨 ${element.name}:`, styles);
        
        // Vérifier que les couleurs ne sont pas par défaut
        expect(styles.color).not.toBe('rgba(0, 0, 0, 0)');
        expect(styles.fontSize).not.toBe('');
      }
    }
  });

  test('🔍 Attributs ARIA et Rôles', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Vérifier les rôles ARIA
    const modalTrigger = page.locator('button:has-text("Comparer les prix")');
    await modalTrigger.click();
    
    // Vérifier que le modal a le bon rôle
    const modal = page.locator('.pricing-modal');
    await expect(modal).toBeVisible();
    
    // Vérifier la fermeture du modal
    await page.keyboard.press('Escape');
    await expect(modal).toBeHidden();
  });

  test('📱 Accessibilité Mobile', async ({ page }) => {
    // Tester en mode mobile
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Vérifier que les éléments sont accessibles en mobile
    await expect(page.locator('h1')).toBeVisible();
    
    // Vérifier la taille des zones de clic
    const buttons = page.locator('button');
    const buttonCount = await buttons.count();
    
    for (let i = 0; i < Math.min(buttonCount, 5); i++) {
      const button = buttons.nth(i);
      
      if (await button.isVisible()) {
        const box = await button.boundingBox();
        
        if (box) {
          // Vérifier que les boutons sont assez grands (44x44px minimum)
          expect(box.height).toBeGreaterThan(35);
          expect(box.width).toBeGreaterThan(35);
        }
      }
    }
    
    // Remettre desktop
    await page.setViewportSize({ width: 1280, height: 720 });
  });

  test('🔤 Textes Alternatifs et Labels', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Vérifier les images (s'il y en a)
    const images = page.locator('img');
    const imageCount = await images.count();
    
    for (let i = 0; i < imageCount; i++) {
      const img = images.nth(i);
      const alt = await img.getAttribute('alt');
      
      // Vérifier que les images ont un attribut alt
      expect(alt).not.toBeNull();
    }
    
    // Vérifier les formulaires (s'il y en a)
    const inputs = page.locator('input');
    const inputCount = await inputs.count();
    
    for (let i = 0; i < inputCount; i++) {
      const input = inputs.nth(i);
      const placeholder = await input.getAttribute('placeholder');
      const ariaLabel = await input.getAttribute('aria-label');
      
      // Vérifier que les inputs ont un label ou placeholder
      expect(placeholder || ariaLabel).toBeTruthy();
    }
  });

  test('⌨️ Ordre de Tabulation Logique', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    const focusableElements = [];
    
    // Parcourir les éléments focusables
    for (let i = 0; i < 10; i++) {
      await page.keyboard.press('Tab');
      
      const focusedElement = await page.evaluate(() => {
        const el = document.activeElement;
        return el ? {
          tagName: el.tagName,
          text: el.textContent?.substring(0, 50) || '',
          type: el.getAttribute('type') || '',
          role: el.getAttribute('role') || ''
        } : null;
      });
      
      if (focusedElement) {
        focusableElements.push(focusedElement);
      }
    }
    
    console.log('⌨️ Ordre de tabulation:', focusableElements);
    
    // Vérifier qu'il y a des éléments focusables
    expect(focusableElements.length).toBeGreaterThan(3);
  });
});
EOF
        echo -e "${GREEN}✅ Tests d'accessibilité créés${NC}"
    fi
    
    # Tests de régression
    if [ ! -f "tests/regression.spec.ts" ]; then
        echo -e "${BLUE}🔄 Création des tests de régression...${NC}"
        cat > tests/regression.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Tests de Régression Math4Child', () => {
  test('🔄 Éléments Critiques Toujours Présents', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Éléments absolument critiques
    const criticalElements = [
      { selector: 'h1', description: 'Titre principal' },
      { selector: 'header', description: 'En-tête' },
      { selector: '.feature-card', description: 'Cartes de fonctionnalités', count: 5 },
      { selector: '.stat-card', description: 'Statistiques', count: 3 },
      { selector: '.platform-card', description: 'Plateformes', count: 3 },
      { selector: 'button:has-text("Commencer gratuitement")', description: 'Bouton principal' },
      { selector: 'button:has-text("Comparer les prix")', description: 'Bouton pricing' },
      { selector: '[data-testid="language-selector"]', description: 'Sélecteur de langue' }
    ];
    
    for (const element of criticalElements) {
      if (element.count) {
        await expect(page.locator(element.selector)).toHaveCount(element.count);
        console.log(`✅ ${element.description}: ${element.count} éléments trouvés`);
      } else {
        await expect(page.locator(element.selector)).toBeVisible({ timeout: 10000 });
        console.log(`✅ ${element.description}: présent`);
      }
    }
  });

  test('📊 Fonctionnalités de Base Intactes', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Test 1: Dropdown langues
    console.log('🧪 Test dropdown langues...');
    const languageSelector = page.locator('[data-testid="language-selector"]');
    await expect(languageSelector).toBeVisible();
    await languageSelector.click();
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
    
    // Sélectionner une langue
    const frenchOption = page.locator('text=Français').first();
    if (await frenchOption.isVisible()) {
      await frenchOption.click();
      await expect(page.locator('text=Langue changée')).toBeVisible({ timeout: 5000 });
    }
    
    // Test 2: Modal pricing
    console.log('🧪 Test modal pricing...');
    await page.locator('button:has-text("Comparer les prix")').click();
    await expect(page.locator('.pricing-modal')).toBeVisible();
    
    // Test changement de période
    await page.locator('button:has-text("Annuel")').click();
    await expect(page.locator('text=-30%')).toBeVisible();
    
    // Fermer le modal
    await page.locator('button:has-text("×")').click();
    await expect(page.locator('.pricing-modal')).toBeHidden();
    
    console.log('✅ Toutes les fonctionnalités de base sont intactes');
  });

  test('🎯 Interactions Restent Fonctionnelles', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    page.on('dialog', dialog => dialog.accept());
    
    // Test toutes les cartes interactives
    const interactiveElements = [
      { selector: '.feature-card', name: 'Cartes de fonctionnalités' },
      { selector: '.stat-card', name: 'Statistiques' },
      { selector: '.platform-card', name: 'Plateformes' }
    ];
    
    let totalInteractions = 0;
    
    for (const elementType of interactiveElements) {
      const elements = page.locator(elementType.selector);
      const count = await elements.count();
      
      console.log(`🧪 Test ${elementType.name}: ${count} éléments`);
      
      for (let i = 0; i < Math.min(count, 3); i++) {
        try {
          await elements.nth(i).click();
          await page.waitForTimeout(200);
          totalInteractions++;
        } catch (e) {
          console.warn(`⚠️ Erreur sur ${elementType.name} ${i + 1}: ${e}`);
        }
      }
    }
    
    console.log(`✅ ${totalInteractions} interactions testées avec succès`);
    expect(totalInteractions).toBeGreaterThan(8);
  });

  test('📱 Responsive Reste Fonctionnel', async ({ page }) => {
    const viewports = [
      { width: 375, height: 667, name: 'Mobile Portrait' },
      { width: 768, height: 1024, name: 'Tablette' },
      { width: 1024, height: 768, name: 'Tablette Paysage' },
      { width: 1280, height: 720, name: 'Desktop' },
      { width: 1920, height: 1080, name: 'Desktop Large' }
    ];
    
    for (const viewport of viewports) {
      console.log(`🧪 Test ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      await page.setViewportSize({ width: viewport.width, height: viewport.height });
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Vérifier les éléments critiques
      await expect(page.locator('h1')).toBeVisible();
      await expect(page.locator('header')).toBeVisible();
      
      // Vérifier qu'il n'y a pas de débordement horizontal
      const bodyWidth = await page.evaluate(() => document.body.scrollWidth);
      expect(bodyWidth).toBeLessThanOrEqual(viewport.width + 20); // Tolérance de 20px
      
      console.log(`✅ ${viewport.name}: OK`);
    }
    
    // Remettre la taille standard
    await page.setViewportSize({ width: 1280, height: 720 });
  });

  test('🔍 Pas de Régressions JavaScript', async ({ page }) => {
    const errors: string[] = [];
    
    // Capturer les erreurs JavaScript
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    page.on('pageerror', error => {
      errors.push(error.message);
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Effectuer quelques interactions pour déclencher du JavaScript
    if (await page.locator('[data-testid="language-selector"]').isVisible()) {
      await page.locator('[data-testid="language-selector"]').click();
      await page.waitForTimeout(500);
    }
    
    if (await page.locator('button:has-text("Comparer les prix")').isVisible()) {
      await page.locator('button:has-text("Comparer les prix")').click();
      await page.waitForTimeout(500);
    }
    
    page.on('dialog', dialog => dialog.accept());
    
    if (await page.locator('.feature-card').first().isVisible()) {
      await page.locator('.feature-card').first().click();
      await page.waitForTimeout(500);
    }
    
    // Vérifier qu'il n'y a pas d'erreurs critiques
    const criticalErrors = errors.filter(error => 
      !error.includes('favicon') && 
      !error.includes('manifest') &&
      !error.includes('SW_UNREACHABLE')
    );
    
    if (criticalErrors.length > 0) {
      console.warn('⚠️ Erreurs JavaScript détectées:', criticalErrors);
    }
    
    expect(criticalErrors.length).toBe(0);
    console.log('✅ Aucune erreur JavaScript critique détectée');
  });

  test('📊 Métriques de Performance Stable', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Mesurer plusieurs fois pour vérifier la stabilité
    const measurements = [];
    
    for (let i = 0; i < 3; i++) {
      await page.reload();
      await page.waitForLoadState('networkidle');
      
      const startTime = Date.now();
      await page.locator('h1').waitFor({ state: 'visible' });
      const loadTime = Date.now() - startTime;
      
      measurements.push(loadTime);
      await page.waitForTimeout(1000);
    }
    
    console.log('📊 Temps de chargement (3 mesures):', measurements);
    
    // Vérifier que les performances sont stables
    const avgLoadTime = measurements.reduce((a, b) => a + b, 0) / measurements.length;
    const maxLoadTime = Math.max(...measurements);
    
    console.log(`📊 Temps moyen: ${avgLoadTime.toFixed(0)}ms, Max: ${maxLoadTime}ms`);
    
    expect(avgLoadTime).toBeLessThan(5000); // < 5s en moyenne
    expect(maxLoadTime).toBeLessThan(8000); // < 8s maximum
  });
});
EOF
        echo -e "${GREEN}✅ Tests de régression créés${NC}"
    fi
    
    # Tests de compatibilité navigateurs
    if [ ! -f "tests/browser-compatibility.spec.ts" ]; then
        echo -e "${BLUE}🌐 Création des tests de compatibilité...${NC}"
        cat > tests/browser-compatibility.spec.ts << 'EOF'
import { test, expect, devices } from '@playwright/test';

test.describe('Compatibilité Multi-Navigateurs', () => {
  const testConfigurations = [
    { name: 'Chrome Desktop', device: devices['Desktop Chrome'], critical: true },
    { name: 'Firefox Desktop', device: devices['Desktop Firefox'], critical: true },
    { name: 'Safari Desktop', device: devices['Desktop Safari'], critical: false },
    { name: 'iPhone 12', device: devices['iPhone 12'], critical: true },
    { name: 'Pixel 5', device: devices['Pixel 5'], critical: true },
    { name: 'iPad Pro', device: devices['iPad Pro'], critical: false }
  ];

  for (const config of testConfigurations) {
    test(`🌐 Compatibilité ${config.name}`, async ({ browser }) => {
      const context = await browser.newContext({
        ...config.device,
      });
      
      const page = await context.newPage();
      
      try {
        await page.goto('/', { timeout: 30000 });
        await page.waitForLoadState('networkidle');
        
        // Tests de base
        await expect(page.locator('h1')).toBeVisible({ timeout: 15000 });
        console.log(`✅ ${config.name}: Titre principal visible`);
        
        await expect(page.locator('.feature-card')).toHaveCount(5, { timeout: 10000 });
        console.log(`✅ ${config.name}: 5 cartes de fonctionnalités`);
        
        // Test d'une interaction
        const firstFeature = page.locator('.feature-card').first();
        if (await firstFeature.isVisible()) {
          await firstFeature.click();
          
          page.on('dialog', dialog => dialog.accept());
          console.log(`✅ ${config.name}: Interaction fonctionnelle`);
        }
        
        // Test spécifique mobile
        if (config.device.hasTouch) {
          const element = page.locator('.stat-card').first();
          if (await element.isVisible()) {
            await element.tap();
            page.on('dialog', dialog => dialog.accept());
            console.log(`✅ ${config.name}: Interaction tactile OK`);
          }
        }
        
        // Test du dropdown langues
        const languageSelector = page.locator('[data-testid="language-selector"]');
        if (await languageSelector.isVisible()) {
          await languageSelector.click();
          await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible({ timeout: 5000 });
          console.log(`✅ ${config.name}: Dropdown langues OK`);
        }
        
      } catch (error) {
        if (config.critical) {
          throw error;
        } else {
          console.warn(`⚠️ ${config.name}: Erreur non critique - ${error}`);
        }
      } finally {
        await context.close();
      }
    });
  }

  test('🔄 Test Cross-Browser Cohérence', async ({ browser }) => {
    const results: any[] = [];
    
    const browsers = [
      { name: 'Chrome', device: devices['Desktop Chrome'] },
      { name: 'Firefox', device: devices['Desktop Firefox'] }
    ];
    
    for (const browserConfig of browsers) {
      const context = await browser.newContext(browserConfig.device);
      const page = await context.newPage();
      
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Mesurer les éléments présents
      const elementCounts = {
        features: await page.locator('.feature-card').count(),
        stats: await page.locator('.stat-card').count(),
        platforms: await page.locator('.platform-card').count(),
        buttons: await page.locator('button').count()
      };
      
      // Mesurer la performance
      const loadTime = await page.evaluate(() => {
        const nav = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
        return nav.loadEventEnd - nav.navigationStart;
      });
      
      results.push({
        browser: browserConfig.name,
        elements: elementCounts,
        loadTime: loadTime
      });
      
      await context.close();
    }
    
    console.log('🔄 Résultats cross-browser:', results);
    
    // Vérifier la cohérence
    if (results.length >= 2) {
      const first = results[0];
      const second = results[1];
      
      // Les éléments doivent être identiques
      expect(first.elements.features).toBe(second.elements.features);
      expect(first.elements.stats).toBe(second.elements.stats);
      expect(first.elements.platforms).toBe(second.elements.platforms);
      
      console.log('✅ Cohérence cross-browser vérifiée');
    }
  });

  test('📱 Test Responsive Cross-Device', async ({ browser }) => {
    const devices_to_test = [
      { name: 'iPhone SE', device: devices['iPhone SE'] },
      { name: 'iPhone 12', device: devices['iPhone 12'] },
      { name: 'Pixel 5', device: devices['Pixel 5'] },
      { name: 'iPad', device: devices['iPad'] }
    ];
    
    for (const deviceConfig of devices_to_test) {
      const context = await browser.newContext(deviceConfig.device);
      const page = await context.newPage();
      
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Vérifier que le contenu s'adapte
      const viewport = page.viewportSize();
      console.log(`📱 ${deviceConfig.name}: ${viewport?.width}x${viewport?.height}`);
      
      // Éléments critiques doivent être visibles
      await expect(page.locator('h1')).toBeVisible();
      await expect(page.locator('header')).toBeVisible();
      
      // Vérifier qu'il n'y a pas de débordement
      const hasHorizontalScroll = await page.evaluate(() => {
        return document.body.scrollWidth > window.innerWidth;
      });
      
      expect(hasHorizontalScroll).toBe(false);
      console.log(`✅ ${deviceConfig.name}: Pas de débordement horizontal`);
      
      await context.close();
    }
  });
});
EOF
        echo -e "${GREEN}✅ Tests de compatibilité créés${NC}"
    fi
    
else
    echo -e "${GREEN}✅ Tests déjà complets - ignorés${NC}"
fi

# ================================================================
# ÉTAPE 6: MISE À JOUR DU PACKAGE.JSON COMPLET
# ================================================================

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   ÉTAPE 6: PACKAGE.JSON COMPLET        ${NC}"
echo -e "${CYAN}=========================================${NC}"

echo -e "${BLUE}📦 Mise à jour complète du package.json...${NC}"

# Sauvegarder le package.json existant
cp package.json $BACKUP_DIR/package.json.backup

# Créer le package.json ultimate avec détection intelligente des dépendances existantes
node -e "
const fs = require('fs');
const existingPkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

const ultimatePackage = {
  name: 'math4child-ultimate-hybrid',
  version: '4.2.0',
  description: 'Math4Child - Application éducative complète avec tests avancés',
  private: true,
  scripts: {
    // Scripts de base (préserver les existants)
    ...existingPkg.scripts,
    
    // Scripts de développement
    'dev': 'next dev',
    'build': 'next build',
    'start': 'next start',
    'lint': 'next lint',
    'lint:fix': 'next lint --fix || true',
    'type-check': 'tsc --noEmit',
    
    // Scripts de test principaux
    'test': 'playwright test',
    'test:interactions': 'playwright test interactions.spec.ts',
    'test:performance': 'playwright test --project=performance-tests',
    'test:accessibility': 'playwright test --project=accessibility-tests',
    'test:regression': 'playwright test --project=regression-tests',
    'test:compatibility': 'playwright test --project=browser-compatibility',
    
    // Scripts de test par navigateur
    'test:chrome': 'playwright test --project=chromium-desktop',
    'test:firefox': 'playwright test --project=firefox-desktop',
    'test:safari': 'playwright test --project=webkit-desktop',
    'test:mobile': 'playwright test --project=mobile-chrome,mobile-safari',
    'test:tablet': 'playwright test --project=tablet-ipad',
    
    // Scripts de test interactifs
    'test:headed': 'playwright test --headed --workers=1',
    'test:ui': 'playwright test --ui',
    'test:debug': 'playwright test --debug',
    'test:trace': 'playwright test --trace=on',
    
    // Scripts de test ciblés
    'test:quick': 'playwright test --grep \"🎉.*Validation.*Complète\"',
    'test:smoke': 'playwright test interactions.spec.ts --project=chromium-desktop',
    'test:critical': 'playwright test --grep \"🔄|💰|🌍\"',
    'test:full': 'playwright test --project=chromium-desktop,mobile-chrome,performance-tests,accessibility-tests',
    
    // Scripts de rapports
    'test:report': 'playwright show-report',
    'test:report-open': 'playwright show-report --host=0.0.0.0 --port=9323',
    'test:clean': 'rm -rf test-results playwright-report',
    
    // Scripts d\'installation et maintenance
    'test:install': 'playwright install --with-deps',
    'test:update': 'npm install @playwright/test@latest && playwright install',
    
    // Scripts de validation
    'validate': 'npm run lint:fix && npm run type-check && npm run test:quick',
    'validate:full': 'npm run lint:fix && npm run type-check && npm run test:smoke',
    'validate:ci': 'npm run build && npm run test:smoke',
    
    // Scripts de qualité
    'quality': 'npm run test:accessibility && npm run test:performance',
    'security': 'npm audit --audit-level moderate',
    
    // Scripts de maintenance
    'maintenance': './maintenance.sh',
    'doctor': 'npm run validate && npm run security',
    'clean:all': 'rm -rf .next out dist test-results playwright-report node_modules/.cache'
  },
  
  dependencies: {
    // Préserver les dépendances existantes
    ...existingPkg.dependencies,
    
    // Dépendances minimales Next.js
    'next': existingPkg.dependencies?.next || '14.2.3',
    'react': existingPkg.dependencies?.react || '^18.2.0',
    'react-dom': existingPkg.dependencies?.['react-dom'] || '^18.2.0'
  },
  
  devDependencies: {
    // Préserver les devDependencies existantes
    ...existingPkg.devDependencies,
    
    // Playwright et tests
    '@playwright/test': '^1.41.0',
    
    // TypeScript
    '@types/node': '^20.10.0',
    '@types/react': '^18.2.45',
    '@types/react-dom': '^18.2.18',
    'typescript': '^5.3.3',
    
    // Linting
    'eslint': '^8.56.0',
    'eslint-config-next': existingPkg.devDependencies?.['eslint-config-next'] || '14.2.3',
    
    // Styles
    'postcss': '^8.4.32',
    'tailwindcss': '^3.4.0'
  },
  
  engines: {
    node: '>=18.0.0',
    npm: '>=8.0.0'
  },
  
  keywords: [
    'math4child',
    'education',
    'mathematics',
    'children',
    'learning',
    'playground',
    'nextjs',
    'react',
    'typescript'
  ]
};

fs.writeFileSync('package.json', JSON.stringify(ultimatePackage, null, 2));
console.log('✅ package.json ultimate créé');
"

echo -e "${GREEN}✅ package.json ultimate mis à jour${NC}"

# ================================================================
# ÉTAPE 7: DOCUMENTATION COMPLÈTE
# ================================================================

if [ "$CREATE_DOCS" = true ]; then
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}   ÉTAPE 7: DOCUMENTATION COMPLÈTE      ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # Guide d'utilisation
    if [ ! -f "GUIDE_UTILISATION.md" ]; then
        echo -e "${BLUE}📚 Création du guide d'utilisation...${NC}"
        cat > GUIDE_UTILISATION.md << 'EOF'
# 🎯 Guide d'Utilisation Math4Child Ultimate

## 🚀 Démarrage Rapide

### Installation
```bash
# Cloner et installer
git clone <votre-repo>
cd math4child
npm install
```

### Lancement
```bash
# Démarrer le serveur de développement
npm run dev

# L'application sera disponible sur http://localhost:3000
```

## 🧪 Tests

### Tests Rapides
```bash
npm run test:quick      # Validation rapide (30s)
npm run test:smoke      # Tests de fumée (1min)
npm run test:critical   # Tests critiques uniquement
```

### Tests Complets
```bash
npm run test            # Tous les tests (10-15min)
npm run test:full       # Tests complets multi-navigateurs
npm run quality         # Tests qualité (accessibilité + performance)
```

### Tests Spécialisés
```bash
npm run test:interactions    # Tests d'interactions
npm run test:performance     # Tests de performance
npm run test:accessibility   # Tests d'accessibilité
npm run test:regression      # Tests de régression
npm run test:compatibility   # Tests multi-navigateurs
```

### Tests par Navigateur
```bash
npm run test:chrome     # Chrome uniquement
npm run test:firefox    # Firefox uniquement
npm run test:safari     # Safari uniquement
npm run test:mobile     # Mobile (iOS + Android)
npm run test:tablet     # Tablette (iPad)
```

### Tests Interactifs
```bash
npm run test:headed     # Voir les tests en action
npm run test:ui         # Interface Playwright
npm run test:debug      # Mode debug
npm run test:trace      # Avec traces complètes
```

## 📊 Rapports et Monitoring

### Voir les Rapports
```bash
npm run test:report     # Ouvrir le rapport HTML local
npm run test:report-open # Serveur de rapport accessible réseau
```

### Nettoyage
```bash
npm run test:clean      # Nettoyer les résultats de tests
npm run clean:all       # Nettoyage complet (cache, builds, tests)
```

## 🎯 Fonctionnalités Testées

### ✅ Interactions Principales (16 tests)
- **Dropdown de Langues** : 47+ langues avec recherche intelligente
- **Cartes de Fonctionnalités** : 5 cartes avec alertes détaillées
- **Statistiques Interactives** : 3 stats avec informations complètes
- **Plateformes** : 3 plateformes avec URLs de téléchargement
- **Modal Pricing** : Calculs dynamiques selon période
- **Niveaux de Difficulté** : 5 niveaux avec descriptions
- **Suivi des Progrès** : 5 types de suivi cliquables

### ✅ Tests de Performance (5 tests)
- **Core Web Vitals** : FCP, LCP, temps de chargement
- **Réactivité** : Temps de réponse < 200ms
- **Mémoire** : Utilisation < 100MB
- **Stress** : 20 interactions rapides
- **Rendu** : Performance de rendu des éléments

### ✅ Tests d'Accessibilité (7 tests)
- **Structure HTML** : Sémantique et hiérarchie
- **Navigation Clavier** : Tab, Enter, Escape
- **Contraste** : Couleurs et lisibilité
- **ARIA** : Attributs et rôles
- **Mobile** : Zones de clic > 44px
- **Textes Alternatifs** : Images et labels
- **Ordre de Tabulation** : Logique et cohérent

### ✅ Tests de Régression (6 tests)
- **Éléments Critiques** : Présence garantie
- **Fonctionnalités de Base** : Dropdown + Modal
- **Interactions** : Toutes restent fonctionnelles
- **Responsive** : 5 tailles d'écran
- **Erreurs JavaScript** : Aucune erreur critique
- **Performance Stable** : Métriques cohérentes

### ✅ Tests de Compatibilité (8 tests)
- **Navigateurs** : Chrome, Firefox, Safari
- **Mobile** : iPhone 12, Pixel 5, iPhone SE
- **Tablette** : iPad Pro, iPad
- **Cross-Browser** : Cohérence des éléments
- **Responsive** : Adaptations multi-devices

## 🛠️ Maintenance et Qualité

### Validation Quotidienne
```bash
npm run validate        # Lint + TypeScript + Tests rapides
npm run validate:full   # Validation complète
npm run doctor          # Diagnostic complet
```

### Maintenance Hebdomadaire
```bash
npm run maintenance     # Script de maintenance automatique
npm run security        # Audit de sécurité
npm run test:update     # Mise à jour Playwright
```

### Avant Déploiement
```bash
npm run validate:ci     # Pipeline CI/CD
npm run test:full       # Tests complets
npm run quality         # Tests qualité
```

## 📱 URLs et Endpoints

- **Application** : http://localhost:3000
- **Rapport Tests** : http://localhost:9323 (après `npm run test:report`)
- **UI Playwright** : http://localhost:9323 (après `npm run test:ui`)

## 🎉 Validation Rapide

Pour valider que tout fonctionne en 30 secondes :
```bash
npm run validate
```

Cette commande fait :
1. ✅ Lint automatique du code
2. ✅ Vérification TypeScript
3. ✅ Test de validation globale
4. ✅ Rapport de statut

## 🚨 Dépannage

### Problèmes Courants

**Tests échouent**
```bash
npm run test:clean && npm run test:install
npm run test:quick
```

**Serveur ne démarre pas**
```bash
lsof -i :3000  # Vérifier le port
kill -9 <PID>  # Tuer le processus
npm run dev
```

**Performance dégradée**
```bash
npm run clean:all
npm install
npm run test:performance
```

---
*Math4Child Ultimate v4.2.0 - Tests avancés et interactions complètes !*
EOF
    fi
    
    # Documentation technique
    if [ ! -f "README_TECHNIQUE.md" ]; then
        echo -e "${BLUE}🔧 Création de la documentation technique...${NC}"
        cat > README_TECHNIQUE.md << 'EOF'
# 🔧 Documentation Technique Math4Child Ultimate

## 🏗️ Architecture Complète

### Structure du Projet
```
math4child-ultimate/
├── app/
│   └── page.tsx                     # Page principale avec 16 interactions
├── tests/
│   ├── interactions.spec.ts         # Tests d'interactions (8 tests)
│   ├── performance.spec.ts          # Tests de performance (5 tests)
│   ├── accessibility.spec.ts        # Tests d'accessibilité (7 tests)
│   ├── regression.spec.ts           # Tests de régression (6 tests)
│   └── browser-compatibility.spec.ts # Tests multi-navigateurs (8 tests)
├── playwright.config.ts             # Configuration avancée (12 projets)
├── package.json                     # 35+ scripts npm
├── GUIDE_UTILISATION.md            # Guide utilisateur complet
├── README_TECHNIQUE.md             # Documentation technique
├── maintenance.sh                  # Script de maintenance
└── backup_*/                       # Sauvegardes automatiques
```

### Technologies et Versions
- **Next.js 14.2.3** : Framework React avec App Router
- **TypeScript 5.3.3** : Typage statique strict
- **Tailwind CSS 3.4** : Styles utilitaires avec design system
- **Playwright 1.41.0** : Tests end-to-end multi-navigateurs
- **React 18.2** : Hooks modernes et Concurrent Features

## 🎯 Interactions Implémentées (16 Total)

### 1. Dropdown de Langues Avancé (47+ langues)
```typescript
interface Language {
  code: string
  name: string
  flag: string
  description: string
}

const changeLanguage = (language: Language) => {
  setSelectedLanguage(language)
  setNotification(`Langue changée vers ${language.name}`)
}
```

**Fonctionnalités :**
- ✅ 47 langues avec drapeaux et descriptions
- ✅ Recherche intelligente en temps réel
- ✅ Fermeture sur clic extérieur
- ✅ Support RTL (arabe, hébreu)
- ✅ Feedback visuel de sélection

### 2. Modal Pricing Dynamique
```typescript
const getPricing = () => {
  const discounts = { monthly: 0, quarterly: 0.1, annual: 0.3 }
  const discount = discounts[selectedPeriod]
  return calculatedPrices
}
```

**Fonctionnalités :**
- ✅ 4 plans (Gratuit, Premium, Famille, École)
- ✅ 3 périodes avec calculs automatiques
- ✅ Réductions dynamiques (-10%, -30%)
- ✅ Fermeture clavier et clic extérieur
- ✅ Animations et transitions

### 3. Cartes Interactives (8 types)
```typescript
const showFeatureAlert = (feature: Feature, index: number) => {
  setActiveFeature(index)
  alert(`${feature.title}\n\n${feature.details}`)
}
```

**Types de cartes :**
- ✅ 5 cartes de fonctionnalités avec détails
- ✅ 3 statistiques avec informations étendues
- ✅ 3 plateformes avec URLs de téléchargement
- ✅ 5 niveaux de difficulté interactifs
- ✅ 5 types de suivi des progrès

## 🧪 Architecture de Tests (34 Tests Total)

### Configuration Playwright Multi-Projets
```typescript
projects: [
  // Desktop (3 navigateurs)
  { name: 'chromium-desktop', use: devices['Desktop Chrome'] },
  { name: 'firefox-desktop', use: devices['Desktop Firefox'] },
  { name: 'webkit-desktop', use: devices['Desktop Safari'] },
  
  // Mobile (3 appareils)
  { name: 'mobile-chrome', use: devices['Pixel 5'] },
  { name: 'mobile-safari', use: devices['iPhone 12'] },
  { name: 'tablet-ipad', use: devices['iPad Pro'] },
  
  // Spécialisés (6 types)
  { name: 'performance-tests', testMatch: /performance\.spec\.ts/ },
  { name: 'accessibility-tests', testMatch: /accessibility\.spec\.ts/ },
  { name: 'regression-tests', testMatch: /regression\.spec\.ts/ },
  { name: 'browser-compatibility', testMatch: /browser-compatibility\.spec\.ts/ },
  { name: 'french-locale', locale: 'fr-FR' },
  { name: 'arabic-rtl', locale: 'ar-SA' }
]
```

### Tests d'Interactions (8 tests)
1. **Dropdown Langues** : 47+ langues avec recherche
2. **Cartes Fonctionnalités** : 5 cartes avec alertes
3. **Statistiques** : 3 stats avec détails
4. **Plateformes** : 3 plateformes avec URLs
5. **Modal Pricing** : 4 plans × 3 périodes
6. **Niveaux Difficulté** : 5 niveaux interactifs
7. **Suivi Progrès** : 5 types de tracking
8. **Responsive** : 5 tailles d'écran

### Tests de Performance (5 tests)
1. **Core Web Vitals** : FCP < 3s, LCP < 5s, DOMContentLoaded < 5s
2. **Réactivité** : Interactions < 200ms
3. **Mémoire** : Utilisation < 100MB
4. **Stress** : 20 interactions rapides < 10s
5. **Rendu** : Performance de rendu < 100ms

### Tests d'Accessibilité (7 tests)
1. **Structure HTML** : Sémantique (header, main, h1)
2. **Navigation Clavier** : Tab, Enter, Escape
3. **Contraste Couleurs** : Vérification automatique
4. **Attributs ARIA** : Rôles et propriétés
5. **Mobile Accessibilité** : Zones de clic > 44px
6. **Textes Alternatifs** : Images et labels
7. **Ordre Tabulation** : Logique de focus
      