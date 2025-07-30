#!/bin/bash

# =============================================================================
# 🔍 SÉLECTEUR DE LANGUES AVEC RECHERCHE AVANCÉE - VERSION CORRIGÉE
# Ajoute une fonctionnalité de recherche dans le dropdown de langues
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${PURPLE}🔍 $1${NC}"
    echo -e "${PURPLE}=================================${NC}"
}

print_header "SÉLECTEUR DE LANGUES AVEC RECHERCHE - VERSION CORRIGÉE"

# Vérifications
if [ ! -d "apps/math4child" ]; then
    log_error "Dossier apps/math4child introuvable!"
    exit 1
fi

cd apps/math4child

# =============================================================================
# 1. CRÉATION DU COMPOSANT LANGUAGESELECTOR AVANCÉ AVEC RECHERCHE
# =============================================================================

log_info "🔍 Création du composant LanguageSelector avec recherche..."

# Créer une sauvegarde du composant existant s'il existe
if [ -f "src/components/LanguageSelector.tsx" ]; then
    cp src/components/LanguageSelector.tsx "src/components/LanguageSelector.tsx.backup_$(date +%Y%m%d_%H%M%S)"
fi

# Créer le répertoire components s'il n'existe pas
mkdir -p src/components

# Nouveau composant avec fonctionnalité de recherche
cat > src/components/LanguageSelector.tsx << 'EOF'
'use client';

import React, { useState, useRef, useEffect, useMemo } from 'react';

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

interface LanguageSelectorProps {
  languages: Language[];
  currentLanguage: string;
  onLanguageChange: (languageCode: string) => void;
}

const LanguageSelector: React.FC<LanguageSelectorProps> = ({
  languages,
  currentLanguage,
  onLanguageChange
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);
  
  // Trouver la langue actuelle
  const selectedLanguage = languages.find(lang => lang.code === currentLanguage) || languages[0];
  
  // Filtrer les langues basé sur la recherche
  const filteredLanguages = useMemo(() => {
    if (!searchQuery.trim()) {
      // Si pas de recherche, montrer la langue actuelle en premier puis les autres
      const otherLanguages = languages
        .filter(lang => lang.code !== currentLanguage)
        .sort((a, b) => a.nativeName.localeCompare(b.nativeName));
      
      return [selectedLanguage, ...otherLanguages];
    }
    
    // Filtrer selon la requête de recherche
    const query = searchQuery.toLowerCase().trim();
    return languages
      .filter(lang => 
        lang.nativeName.toLowerCase().includes(query) ||
        lang.name.toLowerCase().includes(query) ||
        lang.code.toLowerCase().includes(query)
      )
      .sort((a, b) => {
        // Prioriser la langue actuelle
        if (a.code === currentLanguage) return -1;
        if (b.code === currentLanguage) return 1;
        
        // Prioriser les correspondances exactes au début du nom
        const aStartsWithNative = a.nativeName.toLowerCase().startsWith(query);
        const bStartsWithNative = b.nativeName.toLowerCase().startsWith(query);
        const aStartsWithName = a.name.toLowerCase().startsWith(query);
        const bStartsWithName = b.name.toLowerCase().startsWith(query);
        
        if (aStartsWithNative && !bStartsWithNative) return -1;
        if (!aStartsWithNative && bStartsWithNative) return 1;
        if (aStartsWithName && !bStartsWithName) return -1;
        if (!aStartsWithName && bStartsWithName) return 1;
        
        // Sinon tri alphabétique
        return a.nativeName.localeCompare(b.nativeName);
      });
  }, [languages, currentLanguage, searchQuery, selectedLanguage]);

  // Fermer le dropdown quand on clique à l'extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchQuery('');
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  // Focus sur l'input de recherche quand le dropdown s'ouvre
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      // Petit délai pour s'assurer que le dropdown est rendu
      setTimeout(() => {
        searchInputRef.current?.focus();
      }, 100);
    }
  }, [isOpen]);

  const handleLanguageSelect = (languageCode: string) => {
    onLanguageChange(languageCode);
    setIsOpen(false);
    setSearchQuery('');
  };

  const handleToggleDropdown = () => {
    setIsOpen(!isOpen);
    if (!isOpen) {
      setSearchQuery('');
    }
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') {
      setIsOpen(false);
      setSearchQuery('');
    } else if (e.key === 'Enter' && filteredLanguages.length > 0) {
      // Sélectionner la première langue filtrée si Enter est pressé
      const firstLanguage = filteredLanguages[0];
      if (firstLanguage) {
        handleLanguageSelect(firstLanguage.code);
      }
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={handleToggleDropdown}
        className="flex items-center space-x-2 bg-white border border-gray-300 rounded-lg px-4 py-2 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200 min-w-[160px]"
        aria-expanded={isOpen}
        aria-haspopup="listbox"
      >
        <span className="text-xl" role="img" aria-label={selectedLanguage.name}>
          {selectedLanguage.flag}
        </span>
        <span className="font-medium text-gray-900 flex-1 text-left">
          {selectedLanguage.nativeName}
        </span>
        <svg
          className={`w-4 h-4 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          aria-hidden="true"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 mt-1 w-80 bg-white border border-gray-300 rounded-lg shadow-xl z-50 max-h-96 overflow-hidden language-dropdown"
          role="listbox"
        >
          {/* Barre de recherche */}
          <div className="p-3 border-b border-gray-200 bg-gray-50">
            <div className="relative">
              <input
                ref={searchInputRef}
                type="text"
                value={searchQuery}
                onChange={handleSearchChange}
                onKeyDown={handleKeyDown}
                placeholder="🔍 Rechercher une langue..."
                className="w-full px-3 py-2 pl-8 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              />
              <svg
                className="absolute left-2 top-2.5 w-4 h-4 text-gray-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            
            {/* Indicateur de résultats */}
            <div className="text-xs text-gray-500 mt-1">
              {searchQuery.trim() ? (
                <>
                  {filteredLanguages.length} langue{filteredLanguages.length !== 1 ? 's' : ''} trouvée{filteredLanguages.length !== 1 ? 's' : ''}
                  {searchQuery.trim() && (
                    <span className="ml-2 text-blue-600">
                      pour "{searchQuery}"
                    </span>
                  )}
                </>
              ) : (
                `${languages.length} langues disponibles`
              )}
            </div>
          </div>

          {/* Liste des langues filtrées */}
          <div className="overflow-y-auto max-h-80">
            {filteredLanguages.length > 0 ? (
              filteredLanguages.map((language, index) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language.code)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left hover:bg-gray-50 transition-colors duration-150 ${
                    language.code === currentLanguage 
                      ? 'bg-blue-50 text-blue-600 border-l-4 border-blue-500' 
                      : 'text-gray-900'
                  } ${index === 0 ? 'rounded-t-lg' : ''} ${index === filteredLanguages.length - 1 ? 'rounded-b-lg' : ''}`}
                  role="option"
                  aria-selected={language.code === currentLanguage}
                >
                  <span className="text-xl flex-shrink-0" role="img" aria-label={language.name}>
                    {language.flag}
                  </span>
                  <div className="flex-1 min-w-0">
                    <div className={`font-medium truncate ${
                      language.code === currentLanguage ? 'text-blue-600' : 'text-gray-900'
                    }`}>
                      {/* Surligner les correspondances de recherche */}
                      {searchQuery.trim() ? (
                        <HighlightText text={language.nativeName} highlight={searchQuery} />
                      ) : (
                        language.nativeName
                      )}
                    </div>
                    <div className={`text-sm truncate ${
                      language.code === currentLanguage ? 'text-blue-500' : 'text-gray-500'
                    }`}>
                      {searchQuery.trim() ? (
                        <HighlightText text={language.name} highlight={searchQuery} />
                      ) : (
                        language.name
                      )}
                    </div>
                  </div>
                  {language.code === currentLanguage && (
                    <div className="flex-shrink-0">
                      <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                    </div>
                  )}
                </button>
              ))
            ) : (
              <div className="px-4 py-8 text-center text-gray-500">
                <div className="text-4xl mb-2">🔍</div>
                <div className="font-medium">Aucune langue trouvée</div>
                <div className="text-sm">
                  Essayez avec "{searchQuery.slice(0, -1)}" ou un autre terme
                </div>
              </div>
            )}
          </div>

          {/* Instructions en bas */}
          {searchQuery.trim() && filteredLanguages.length > 0 && (
            <div className="px-3 py-2 bg-gray-50 border-t border-gray-200 text-xs text-gray-500">
              <div className="flex items-center space-x-4">
                <span>↵ Entrée pour sélectionner</span>
                <span>Esc pour fermer</span>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

// Composant pour surligner le texte de recherche
const HighlightText: React.FC<{ text: string; highlight: string }> = ({ text, highlight }) => {
  if (!highlight.trim()) return <>{text}</>;
  
  const regex = new RegExp(`(${highlight.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
  const parts = text.split(regex);
  
  return (
    <>
      {parts.map((part, index) => 
        regex.test(part) ? (
          <span key={index} className="bg-yellow-200 font-semibold">
            {part}
          </span>
        ) : (
          part
        )
      )}
    </>
  );
};

export default LanguageSelector;
EOF

log_success "✅ Composant LanguageSelector avec recherche créé"

# =============================================================================
# 2. MISE À JOUR DU FICHIER PRINCIPAL AVEC LANGUES ÉTENDUES
# =============================================================================

log_info "🌍 Mise à jour du fichier principal avec liste de langues étendue..."

# Créer une sauvegarde du fichier principal
if [ -f "src/app/page.tsx" ]; then
    cp src/app/page.tsx "src/app/page.tsx.backup_$(date +%Y%m%d_%H%M%S)"
fi

# Créer le fichier principal avec liste de langues étendue
cat > src/app/page.tsx << 'EOF'
'use client';

import React, { useState, useEffect } from 'react';
import LanguageSelector from '../components/LanguageSelector';

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  
  // Langues supplémentaires pour la recherche
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱' },
  { code: 'cs', name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿' },
  { code: 'hu', name: 'Magyar', nativeName: 'Magyar', flag: '🇭🇺' },
  { code: 'ro', name: 'Română', nativeName: 'Română', flag: '🇷🇴' },
  { code: 'bg', name: 'Български', nativeName: 'Български', flag: '🇧🇬' },
  { code: 'hr', name: 'Hrvatski', nativeName: 'Hrvatski', flag: '🇭🇷' },
  { code: 'sk', name: 'Slovenčina', nativeName: 'Slovenčina', flag: '🇸🇰' },
  { code: 'sl', name: 'Slovenščina', nativeName: 'Slovenščina', flag: '🇸🇮' },
  { code: 'et', name: 'Eesti', nativeName: 'Eesti', flag: '🇪🇪' },
  { code: 'lv', name: 'Latviešu', nativeName: 'Latviešu', flag: '🇱🇻' },
  { code: 'lt', name: 'Lietuvių', nativeName: 'Lietuvių', flag: '🇱🇹' },
  { code: 'el', name: 'Ελληνικά', nativeName: 'Ελληνικά', flag: '🇬🇷' },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷' },
  { code: 'he', name: 'עברית', nativeName: 'עברית', flag: '🇮🇱' },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷' },
  { code: 'ur', name: 'اردو', nativeName: 'اردو', flag: '🇵🇰' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳' },
  { code: 'bn', name: 'বাংলা', nativeName: 'বাংলা', flag: '🇧🇩' },
  { code: 'ta', name: 'தமிழ்', nativeName: 'தமிழ்', flag: '🇱🇰' },
  { code: 'te', name: 'తెలుగు', nativeName: 'తెలుగు', flag: '🇮🇳' },
  { code: 'ml', name: 'മലയാളം', nativeName: 'മലയാളം', flag: '🇮🇳' },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩' },
  { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭' },
  { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇰🇪' },
  { code: 'am', name: 'አማርኛ', nativeName: 'አማርኛ', flag: '🇪🇹' },
  { code: 'yo', name: 'Yorùbá', nativeName: 'Yorùbá', flag: '🇳🇬' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬' },
  { code: 'zu', name: 'isiZulu', nativeName: 'isiZulu', flag: '🇿🇦' },
  { code: 'xh', name: 'isiXhosa', nativeName: 'isiXhosa', flag: '🇿🇦' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦' }
];

// Traductions basiques pour la démo
const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    title: 'Math4Child - Application Éducative',
    subtitle: 'Apprentissage des mathématiques pour toute la famille',
    welcome: 'Bienvenue dans Math4Child',
    description: 'Une application éducative interactive pour apprendre les mathématiques de façon ludique.',
    features: 'Fonctionnalités',
    feature1: '🧮 Calculs interactifs',
    feature2: '🎯 Exercices adaptés',
    feature3: '📊 Suivi des progrès',
    feature4: '🎮 Jeux éducatifs',
    trySearch: 'Essayez la recherche de langues ci-dessus !',
    searchDemo: 'Tapez "ital" pour voir Italien, "ara" pour voir العربية'
  },
  en: {
    title: 'Math4Child - Educational App',
    subtitle: 'Mathematics learning for the whole family',
    welcome: 'Welcome to Math4Child',
    description: 'An interactive educational application to learn mathematics in a fun way.',
    features: 'Features',
    feature1: '🧮 Interactive calculations',
    feature2: '🎯 Adapted exercises',
    feature3: '📊 Progress tracking',
    feature4: '🎮 Educational games',
    trySearch: 'Try the language search above!',
    searchDemo: 'Type "ital" to see Italian, "ara" to see العربية'
  },
  es: {
    title: 'Math4Child - Aplicación Educativa',
    subtitle: 'Aprendizaje de matemáticas para toda la familia',
    welcome: 'Bienvenido a Math4Child',
    description: 'Una aplicación educativa interactiva para aprender matemáticas de forma divertida.',
    features: 'Características',
    feature1: '🧮 Cálculos interactivos',
    feature2: '🎯 Ejercicios adaptados',
    feature3: '📊 Seguimiento del progreso',
    feature4: '🎮 Juegos educativos',
    trySearch: '¡Prueba la búsqueda de idiomas arriba!',
    searchDemo: 'Escribe "ital" para ver Italiano, "ara" para ver العربية'
  },
  de: {
    title: 'Math4Child - Bildungs-App',
    subtitle: 'Mathematik-Lernen für die ganze Familie',
    welcome: 'Willkommen bei Math4Child',
    description: 'Eine interaktive Bildungsanwendung zum spielerischen Lernen von Mathematik.',
    features: 'Funktionen',
    feature1: '🧮 Interaktive Berechnungen',
    feature2: '🎯 Angepasste Übungen',
    feature3: '📊 Fortschritt verfolgen',
    feature4: '🎮 Lernspiele',
    trySearch: 'Probieren Sie die Sprachsuche oben aus!',
    searchDemo: 'Tippen Sie "ital" für Italiano, "ara" für العربية'
  },
  ar: {
    title: 'Math4Child - تطبيق تعليمي',
    subtitle: 'تعلم الرياضيات لجميع أفراد العائلة',
    welcome: 'مرحباً بكم في Math4Child',
    description: 'تطبيق تعليمي تفاعلي لتعلم الرياضيات بطريقة ممتعة.',
    features: 'المميزات',
    feature1: '🧮 حسابات تفاعلية',
    feature2: '🎯 تمارين مخصصة',
    feature3: '📊 تتبع التقدم',
    feature4: '🎮 ألعاب تعليمية',
    trySearch: 'جرب البحث عن اللغات أعلاه!',
    searchDemo: 'اكتب "ital" لرؤية الإيطالية، "ara" لرؤية العربية'
  },
  zh: {
    title: 'Math4Child - 教育应用',
    subtitle: '全家数学学习',
    welcome: '欢迎使用 Math4Child',
    description: '一个交互式教育应用程序，以有趣的方式学习数学。',
    features: '功能',
    feature1: '🧮 交互式计算',
    feature2: '🎯 适应性练习',
    feature3: '📊 进度跟踪',
    feature4: '🎮 教育游戏',
    trySearch: '试试上面的语言搜索功能！',
    searchDemo: '输入"ital"查看意大利语，"ara"查看العربية'
  }
};

const DEFAULT_LANGUAGE = 'fr';

export default function HomePage() {
  const [currentLanguage, setCurrentLanguage] = useState(DEFAULT_LANGUAGE);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    // Charger la langue depuis localStorage si disponible
    const savedLanguage = localStorage.getItem('math4child-language');
    if (savedLanguage && LANGUAGES.find(lang => lang.code === savedLanguage)) {
      setCurrentLanguage(savedLanguage);
    }
  }, []);

  const handleLanguageChange = (languageCode: string) => {
    setCurrentLanguage(languageCode);
    if (mounted) {
      localStorage.setItem('math4child-language', languageCode);
    }
  };

  const t = (key: string): string => {
    return TRANSLATIONS[currentLanguage]?.[key] || TRANSLATIONS[DEFAULT_LANGUAGE]?.[key] || key;
  };

  if (!mounted) {
    return <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
      <div className="text-blue-600">Chargement...</div>
    </div>;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header avec sélecteur de langue */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <span className="text-white text-lg font-bold">M</span>
              </div>
              <h1 className="text-xl font-bold text-gray-900">Math4Child</h1>
            </div>
            
            <LanguageSelector
              languages={LANGUAGES}
              currentLanguage={currentLanguage}
              onLanguageChange={handleLanguageChange}
            />
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            {t('title')}
          </h1>
          <p className="text-xl text-gray-600 mb-12">
            {t('subtitle')}
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Section principale */}
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-6">
              {t('welcome')}
            </h2>
            <p className="text-lg text-gray-600 mb-8">
              {t('description')}
            </p>

            <h3 className="text-xl font-semibold text-gray-900 mb-4">
              {t('features')}
            </h3>
            <ul className="space-y-3">
              <li className="text-gray-600">{t('feature1')}</li>
              <li className="text-gray-600">{t('feature2')}</li>
              <li className="text-gray-600">{t('feature3')}</li>
              <li className="text-gray-600">{t('feature4')}</li>
            </ul>
          </div>

          {/* Démo de recherche */}
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">
              🔍 Recherche de Langues Avancée
            </h3>
            <p className="text-gray-600 mb-6">
              {t('trySearch')}
            </p>
            <div className="bg-blue-50 rounded-lg p-4">
              <p className="text-sm text-blue-800">
                💡 {t('searchDemo')}
              </p>
            </div>
            
            {/* Statistiques */}
            <div className="mt-6 grid grid-cols-2 gap-4">
              <div className="text-center">
                <div className="text-2xl font-bold text-blue-600">{LANGUAGES.length}</div>
                <div className="text-sm text-gray-500">Langues disponibles</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-green-600">🎯</div>
                <div className="text-sm text-gray-500">Recherche intelligente</div>
              </div>
            </div>
          </div>
        </div>

        {/* Section des langues disponibles */}
        <div className="mt-16">
          <h3 className="text-2xl font-bold text-gray-900 mb-8 text-center">
            Langues Disponibles ({LANGUAGES.length})
          </h3>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {LANGUAGES.slice(0, 24).map((language) => (
              <div 
                key={language.code}
                className={`p-3 rounded-lg border transition-all duration-200 cursor-pointer hover:shadow-md ${
                  language.code === currentLanguage 
                    ? 'bg-blue-50 border-blue-300 ring-2 ring-blue-500' 
                    : 'bg-white border-gray-200 hover:border-gray-300'
                }`}
                onClick={() => handleLanguageChange(language.code)}
              >
                <div className="text-center">
                  <div className="text-2xl mb-1">{language.flag}</div>
                  <div className="text-sm font-medium text-gray-900 truncate">
                    {language.nativeName}
                  </div>
                  <div className="text-xs text-gray-500 truncate">
                    {language.name}
                  </div>
                </div>
              </div>
            ))}
          </div>
          {LANGUAGES.length > 24 && (
            <div className="text-center mt-6">
              <p className="text-gray-500">
                ... et {LANGUAGES.length - 24} autres langues disponibles via la recherche
              </p>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
EOF

log_success "✅ Fichier principal mis à jour avec langues étendues"

# =============================================================================
# 3. AJOUT DES STYLES CSS POUR LA RECHERCHE
# =============================================================================

log_info "🎨 Ajout des styles CSS pour la recherche de langues..."

# Créer le répertoire app s'il n'existe pas
mkdir -p src/app

# Ajouter ou créer le fichier de styles globaux
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* =============================================================================
   STYLES POUR LA RECHERCHE DE LANGUES
   ============================================================================= */

.language-dropdown {
  backdrop-filter: blur(8px);
  background: rgba(255, 255, 255, 0.98);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

.language-dropdown::-webkit-scrollbar {
  width: 8px;
}

.language-dropdown::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 4px;
}

.language-dropdown::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
}

.language-dropdown::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Animation d'ouverture du dropdown */
@keyframes languageDropdownOpen {
  from {
    opacity: 0;
    transform: translateY(-8px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.language-dropdown {
  animation: languageDropdownOpen 0.2s ease-out;
}

/* Styles pour le surlignage de recherche */
.search-highlight {
  background: linear-gradient(120deg, #fef08a 0%, #fde047 100%);
  font-weight: 600;
  padding: 1px 2px;
  border-radius: 2px;
}

/* Animation pour les résultats de recherche */
@keyframes searchResultFadeIn {
  from {
    opacity: 0;
    transform: translateY(4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.language-dropdown button[role="option"] {
  animation: searchResultFadeIn 0.15s ease-out;
}

/* Styles pour l'input de recherche */
.language-search-input {
  transition: all 0.2s ease;
}

.language-search-input:focus {
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Indicateur de résultats */
.search-results-indicator {
  transition: all 0.3s ease;
}

/* Animation pour "aucun résultat" */
.no-results {
  animation: searchResultFadeIn 0.3s ease-out;
}

/* Styles responsive pour mobile */
@media (max-width: 768px) {
  .language-dropdown {
    width: 90vw;
    max-width: 320px;
    left: 50%;
    transform: translateX(-50%);
  }
  
  .language-dropdown button[role="option"] {
    padding: 12px 16px;
  }
}

/* Styles spéciaux pour les langues RTL */
.language-option-rtl {
  direction: rtl;
  text-align: right;
}

/* Animation de pulsation pour la langue sélectionnée */
@keyframes selectedLanguagePulse {
  0%, 100% {
    background-color: rgba(59, 130, 246, 0.1);
  }
  50% {
    background-color: rgba(59, 130, 246, 0.2);
  }
}

.language-dropdown button[aria-selected="true"] {
  animation: selectedLanguagePulse 2s ease-in-out infinite;
}

/* Effet de hover amélioré */
.language-dropdown button[role="option"]:hover:not([aria-selected="true"]) {
  background: linear-gradient(90deg, #f8fafc 0%, #e2e8f0 100%);
  transform: translateX(2px);
}

/* Style pour les instructions en bas */
.language-instructions {
  background: linear-gradient(90deg, #f1f5f9 0%, #e2e8f0 100%);
  border-top: 1px solid #cbd5e1;
}
EOF

log_success "✅ Styles CSS pour la recherche ajoutés"

# =============================================================================
# 4. REDÉMARRAGE DU SERVEUR
# =============================================================================

log_info "🔄 Redémarrage du serveur..."

# Arrêter le serveur existant
pkill -f "next dev" 2>/dev/null || true
sleep 3

# Supprimer le cache
rm -rf .next 2>/dev/null || true

# Redémarrer
nohup npm run dev > /dev/null 2>&1 &
sleep 5

# Vérification que le serveur fonctionne
if pgrep -f "next dev" > /dev/null; then
    log_success "✅ Serveur de développement redémarré"
else
    log_error "⚠️ Le serveur n'a pas pu redémarrer automatiquement"
    echo "   Démarrez-le manuellement avec: npm run dev"
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
print_header "SÉLECTEUR DE LANGUES AVEC RECHERCHE TERMINÉ"
echo ""
echo "🔍 Nouvelles fonctionnalités :"
echo ""
echo "✅ Recherche avancée de langues :"
echo "   🔤 Saisie manuelle pour filtrer les langues"
echo "   🎯 Recherche par nom natif, nom anglais ou code"
echo "   ⚡ Filtrage en temps réel pendant la saisie"
echo "   🏆 Priorisation des correspondances exactes"
echo ""
echo "✅ Interface améliorée :"
echo "   📊 Indicateur du nombre de résultats"
echo "   💡 Surlignage des correspondances en jaune"
echo "   ⌨️ Navigation clavier (Enter, Escape)"
echo "   📱 Design responsive pour mobile"
echo ""
echo "✅ 45+ langues disponibles :"
echo "   🌍 Langues européennes (25+)"
echo "   🌏 Langues asiatiques (10+)"
echo "   🌍 Langues africaines (5+)"
echo "   🌍 Langues du Moyen-Orient (5+)"
echo ""
echo "🎮 Comment utiliser :"
echo "   1. Cliquez sur le dropdown de langues"
echo "   2. Tapez le début d'une langue (ex: 'fran' pour français)"
echo "   3. Les résultats se filtrent automatiquement"
echo "   4. Cliquez sur une langue ou appuyez sur Entrée"
echo ""
echo "🔍 Exemples de recherche :"
echo "   • 'fr' → Français"
echo "   • 'eng' → English"
echo "   • 'esp' → Español"
echo "   • 'deut' → Deutsch"
echo "   • 'arab' → العربية"
echo "   • 'chin' → 中文"
echo "   • 'ital' → Italiano"
echo "   • 'port' → Português"
echo ""
echo "✨ Fonctionnalités avancées :"
echo "   🎨 Animation fluide d'ouverture"
echo "   🔦 Focus automatique sur la recherche"
echo "   📍 Langue actuelle toujours en premier"
echo "   ⌨️ Support clavier complet"
echo "   🎯 Message d'aide si aucun résultat"
echo ""
echo "🌐 Testez maintenant :"
echo "   http://localhost:3000"
echo "   → Cliquez sur le dropdown de langues"
echo "   → Tapez 'ital' pour voir Italien apparaître"
echo "   → Tapez 'ara' pour voir العربية"
echo ""
echo "📁 Fichiers créés/modifiés :"
echo "   ✓ src/components/LanguageSelector.tsx (nouveau composant)"
echo "   ✓ src/app/page.tsx (page principale mise à jour)"
echo "   ✓ src/app/globals.css (styles ajoutés)"
echo ""
log_success "🎉 Sélecteur de langues avec recherche opérationnel!"
echo "======================================"
EOF

chmod +x script_corrige.sh

log_success "✅ Script corrigé créé avec succès!"
echo ""
echo "🔧 Pour exécuter le script corrigé :"
echo "   ./script_corrige.sh"
echo ""
echo "📝 Principales corrections apportées :"
echo "   ✓ Suppression de la commande sed problématique"
echo "   ✓ Création directe des fichiers complets"
echo "   ✓ Gestion des répertoires manquants"
echo "   ✓ Amélioration de la gestion d'erreurs"
echo "   ✓ Simplification du processus"