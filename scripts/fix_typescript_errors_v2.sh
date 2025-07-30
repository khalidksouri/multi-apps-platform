#!/bin/bash

# =====================================
# Script de correction des erreurs TypeScript v2
# Basé sur l'analyse des logs et l'existant du projet
# =====================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Vérifier la structure du projet
check_project_structure() {
    print_step "Vérification de la structure du projet..."
    
    if [ ! -d "apps/math4child" ]; then
        print_error "Structure apps/math4child non trouvée"
        exit 1
    fi
    
    cd apps/math4child
    print_success "Structure du projet confirmée"
}

# Créer une sauvegarde avant modifications  
create_backup() {
    print_step "Création d'une sauvegarde..."
    
    BACKUP_DIR="../backup_typescript_fixes_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder les fichiers qui vont être modifiés
    [ -f "src/app/page.tsx" ] && cp "src/app/page.tsx" "$BACKUP_DIR/"
    [ -f "next.config.ts" ] && cp "next.config.ts" "$BACKUP_DIR/"
    [ -f "capacitor.config.ts" ] && cp "capacitor.config.ts" "$BACKUP_DIR/"
    [ -f "src/lib/i18n/utils.ts" ] && cp "src/lib/i18n/utils.ts" "$BACKUP_DIR/"
    [ -f "src/lib/i18n/index.ts" ] && cp "src/lib/i18n/index.ts" "$BACKUP_DIR/"
    [ -f "src/components/ImprovedHomePage.tsx" ] && cp "src/components/ImprovedHomePage.tsx" "$BACKUP_DIR/"
    [ -f "src/components/ui/RegionSelector.tsx" ] && cp "src/components/ui/RegionSelector.tsx" "$BACKUP_DIR/"
    
    print_success "Sauvegarde créée dans $BACKUP_DIR"
}

# Corriger le fichier page.tsx principal (erreurs lignes 150, 158, 347)
fix_main_page_tsx() {
    print_step "Correction du fichier src/app/page.tsx..."
    
    if [ -f "src/app/page.tsx" ]; then
        # Correction des erreurs TypeScript identifiées
        cat > "src/app/page.tsx" << 'EOF'
'use client';

import { useState, useEffect } from 'react';
import { UNIVERSAL_LANGUAGES, getLanguageByCode, type Language } from '@/lib/i18n/languages';

// Fonction pour détecter la langue du navigateur avec vérification stricte
function detectBrowserLanguage(): string {
  if (typeof window === 'undefined') return 'fr';
  
  const browserLang = navigator.language;
  if (!browserLang) return 'fr';
  
  const langParts = browserLang.split('-');
  const mainLang = langParts[0];
  
  const supportedLang = UNIVERSAL_LANGUAGES.find(
    lang => lang.code === browserLang || lang.code.startsWith(mainLang)
  );
  
  return supportedLang?.code || 'fr';
}

// Fonction pour obtenir une langue par code avec fallback garanti - FIX ligne 150
function getLanguageByCodeSafe(code: string): Language {
  const found = UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
  return found || UNIVERSAL_LANGUAGES[0]; // Garantit qu'on retourne toujours une Language
}

export default function HomePage() {
  // FIX ligne 347 - useState avec fonction qui retourne toujours Language
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(() => {
    return getLanguageByCodeSafe('fr'); // Garantit un retour Language
  });

  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    // Détecter la langue du navigateur au montage du composant
    const browserLang = detectBrowserLanguage();
    setSelectedLanguage(getLanguageByCodeSafe(browserLang));
  }, []);

  const handleLanguageChange = (languageCode: string) => {
    const newLanguage = getLanguageByCodeSafe(languageCode);
    setSelectedLanguage(newLanguage);
    setIsDropdownOpen(false);
    
    // Appliquer la direction RTL si nécessaire
    document.documentElement.dir = newLanguage.rtl ? 'rtl' : 'ltr';
    document.documentElement.lang = newLanguage.code;
  };

  // Textes traduits basiques pour les nouvelles langues arabes
  const getTexts = (langCode: string) => {
    const textsMap: Record<string, any> = {
      'fr': {
        title: 'Math4Child',
        subtitle: 'Application éducative pour apprendre les maths',
        description: 'L\'application n°1 pour apprendre les mathématiques en famille !',
        startFree: 'Commencer gratuitement',
        selectLanguage: 'Choisir la langue'
      },
      'en': {
        title: 'Math4Child',
        subtitle: 'Educational app to learn math',
        description: 'The #1 app to learn mathematics as a family!',
        startFree: 'Start for free',
        selectLanguage: 'Select language'
      },
      'ar-PS': {
        title: 'Math4Child',
        subtitle: 'تطبيق تعليمي لتعلم الرياضيات',
        description: 'التطبيق رقم 1 لتعليم الرياضيات للعائلة في فلسطين!',
        startFree: 'ابدأ مجاناً',
        selectLanguage: 'اختر اللغة'
      },
      'ar-MA': {
        title: 'Math4Child',
        subtitle: 'تطبيق تعليمي لتعلم الرياضيات',
        description: 'التطبيق رقم 1 لتعليم الرياضيات للعائلة في المغرب!',
        startFree: 'ابدأ مجاناً',
        selectLanguage: 'اختر اللغة'
      }
    };
    
    return textsMap[langCode] || textsMap['fr'];
  };

  const currentTexts = getTexts(selectedLanguage.code);

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 ${selectedLanguage.rtl ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        {/* Header avec sélecteur de langue */}
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-3xl font-bold text-indigo-900">{currentTexts.title}</h1>
          
          {/* Sélecteur de langue */}
          <div className="relative">
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50 focus:ring-2 focus:ring-indigo-500"
              data-testid="language-selector"
            >
              <span className="text-xl">{selectedLanguage.flag}</span>
              <span className="font-medium">{selectedLanguage.name}</span>
              <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </button>
            
            {isDropdownOpen && (
              <div 
                className="absolute right-0 mt-2 w-80 bg-white border border-gray-200 rounded-lg shadow-lg max-h-96 overflow-y-auto z-50"
                data-testid="language-dropdown"
              >
                {/* Groupement par continent */}
                {['Europe', 'Asia', 'Africa', 'North America', 'South America', 'Oceania'].map(continent => {
                  const continentLanguages = UNIVERSAL_LANGUAGES.filter(lang => lang.continent === continent);
                  
                  if (continentLanguages.length === 0) return null;
                  
                  return (
                    <div key={continent} className="border-b border-gray-100 last:border-b-0">
                      <div className="px-3 py-2 bg-gray-50 border-b border-gray-100">
                        <h3 className="text-xs font-semibold text-gray-600 uppercase tracking-wide">
                          {continent === 'Asia' ? 'Asie & Moyen-Orient' : continent}
                        </h3>
                      </div>
                      
                      <div className="py-1">
                        {continentLanguages.map((language) => (
                          <button
                            key={language.code}
                            onClick={() => handleLanguageChange(language.code)}
                            className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 ${
                              selectedLanguage.code === language.code ? 'bg-indigo-50 text-indigo-600' : 'text-gray-700'
                            }`}
                            data-testid={`language-option-${language.code}`}
                          >
                            <span className="text-2xl">{language.flag}</span>
                            <div className="flex-1">
                              <div className="font-medium">{language.name}</div>
                              <div className="text-sm text-gray-500">{language.nativeName}</div>
                              <div className="text-xs text-gray-400">{language.continent} • {language.currency}</div>
                            </div>
                            {selectedLanguage.code === language.code && (
                              <div className="text-indigo-600">✓</div>
                            )}
                          </button>
                        ))}
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </header>

        {/* Contenu principal */}
        <main className="text-center">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-5xl font-bold text-gray-900 mb-6">
              {currentTexts.subtitle}
            </h2>
            
            <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
              {currentTexts.description}
            </p>
            
            <button className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
              {currentTexts.startFree}
            </button>
            
            {/* Informations sur la langue sélectionnée */}
            <div className="mt-12 p-6 bg-white rounded-lg shadow-sm">
              <h3 className="text-lg font-semibold mb-4">
                {selectedLanguage.code === 'ar-PS' && 'اللغة المختارة'}
                {selectedLanguage.code === 'ar-MA' && 'اللغة المختارة'}
                {!selectedLanguage.code.startsWith('ar') && 'Langue sélectionnée'}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span className="font-medium">Langue:</span> {selectedLanguage.name}
                </div>
                <div>
                  <span className="font-medium">Continent:</span> {selectedLanguage.continent}
                </div>
                <div>
                  <span className="font-medium">Devise:</span> {selectedLanguage.currency}
                </div>
              </div>
              {selectedLanguage.rtl && (
                <div className="mt-2 text-sm text-indigo-600">
                  ✨ Support RTL activé pour cette langue
                </div>
              )}
              
              {/* Informations spéciales pour Palestine et Maroc */}
              {selectedLanguage.code === 'ar-PS' && (
                <div className="mt-2 text-sm text-green-600">
                  🇵🇸 Palestine ajoutée au Moyen-Orient avec support complet
                </div>
              )}
              {selectedLanguage.code === 'ar-MA' && (
                <div className="mt-2 text-sm text-green-600">
                  🇲🇦 Maroc en Afrique avec drapeau marocain maintenu
                </div>
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
EOF
        print_success "Fichier src/app/page.tsx corrigé (erreurs lignes 150, 158, 347)"
    fi
}

# Corriger next.config.ts (erreur ligne 3)
fix_next_config() {
    print_step "Correction de next.config.ts..."
    
    if [ -f "next.config.ts" ]; then
        cat > "next.config.ts" << 'EOF'
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,
  
  // Export statique pour déploiements Capacitor - FIX: types stricts
  output: process.env.CAPACITOR_BUILD === 'true' ? 'export' : undefined,
  assetPrefix: process.env.CAPACITOR_BUILD === 'true' ? './' : undefined,
  trailingSlash: process.env.CAPACITOR_BUILD === 'true' ? true : undefined,
  
  // Configuration TypeScript et ESLint stricte
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    ignoreDuringBuilds: false,
  },
  
  // Configuration des images
  images: {
    unoptimized: process.env.CAPACITOR_BUILD === 'true' ? true : undefined,
    domains: ['localhost', 'math4child.com'],
    dangerouslyAllowSVG: false,
    formats: ['image/webp', 'image/avif'],
  },
  
  // Headers de sécurité
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options', 
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ];
  },
  
  // Optimisations
  swcMinify: true,
  poweredByHeader: false,
  compress: true,
  
  // Configuration webpack pour Capacitor
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      };
    }
    
    return config;
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_COMPANY: 'GOTEST',
    NEXT_PUBLIC_SIRET: '53958712100028',
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
};

export default nextConfig;
EOF
        print_success "next.config.ts corrigé (erreur ligne 3)"
    fi
}

# Corriger capacitor.config.ts (erreur ligne 80)
fix_capacitor_config() {
    print_step "Correction de capacitor.config.ts..."
    
    if [ -f "capacitor.config.ts" ]; then
        cat > "capacitor.config.ts" << 'EOF'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#3B82F6',
      showSpinner: false
    },
    StatusBar: {
      style: 'default',
      backgroundColor: '#3B82F6'
    },
    Keyboard: {
      resize: 'body',
      style: 'dark'
    }
  },
  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: process.env.NODE_ENV === 'development'
  },
  ios: {
    contentInset: 'automatic',
    scrollEnabled: true,
    webContentsDebuggingEnabled: process.env.NODE_ENV === 'development'
    // FIX: buildOptions supprimé - n'existe pas dans CapacitorConfig
  }
};

export default config;
EOF
        print_success "capacitor.config.ts corrigé (erreur ligne 80 - buildOptions supprimé)"
    fi
}

# Corriger les utilitaires i18n (erreurs dans utils.ts et index.ts)
fix_i18n_utils() {
    print_step "Correction des utilitaires i18n..."
    
    # Corriger src/lib/i18n/utils.ts
    if [ -f "src/lib/i18n/utils.ts" ]; then
        cat > "src/lib/i18n/utils.ts" << 'EOF'
import { UNIVERSAL_LANGUAGES, type Language } from './languages';

// Fonction pour détecter la langue du navigateur - FIX ligne 44
export function detectUserLanguage(): string {
  if (typeof window === 'undefined') return 'fr';
  
  const browserLang = navigator.language;
  if (!browserLang) return 'fr';
  
  const langParts = browserLang.split('-');
  const mainLang = langParts[0];
  
  const supportedLang = UNIVERSAL_LANGUAGES.find(
    lang => lang.code === browserLang || lang.code.startsWith(mainLang)
  );
  
  return supportedLang?.code || 'fr';
}

// Fonction pour formater une date selon la locale - FIX ligne 31 (format unused)
export function formatDate(date: Date, locale: string): string {
  const language = UNIVERSAL_LANGUAGES.find(lang => lang.code === locale);
  
  if (!language) return date.toLocaleDateString();
  
  try {
    return date.toLocaleDateString(locale, {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });
  } catch {
    return date.toLocaleDateString();
  }
}

// Fonction pour obtenir la direction du texte
export function getTextDirection(languageCode: string): 'ltr' | 'rtl' {
  const language = UNIVERSAL_LANGUAGES.find(lang => lang.code === languageCode);
  return language?.rtl ? 'rtl' : 'ltr';
}

// Fonction pour obtenir le symbole de devise
export function getCurrencySymbol(currencyCode: string): string {
  const currencySymbols: Record<string, string> = {
    'EUR': '€',
    'USD': '$',
    'GBP': '£',
    'MAD': 'MAD',
    'ILS': '₪',
    'SAR': 'ر.س',
    'AED': 'د.إ',
    'TND': 'د.ت',
    'DZD': 'د.ج'
  };
  
  return currencySymbols[currencyCode] || currencyCode;
}

// Export alternatif pour éviter les conflits - FIX lignes 2 dans index.ts
export { detectUserLanguage as detectBrowserLanguage };
export { getLanguageByCode } from './languages';
export { getLanguagesByContinent } from './languages';
EOF
        print_success "src/lib/i18n/utils.ts corrigé"
    fi

    # Corriger src/lib/i18n/index.ts - FIX conflits d'export
    if [ -f "src/lib/i18n/index.ts" ]; then
        cat > "src/lib/i18n/index.ts" << 'EOF'
// Export principal des fonctions i18n - FIX: éviter les conflits d'export
export * from './languages';
export { 
  detectUserLanguage, 
  detectBrowserLanguage,
  formatDate, 
  getTextDirection, 
  getCurrencySymbol 
} from './utils';
EOF
        print_success "src/lib/i18n/index.ts corrigé"
    fi
}

# Corriger les composants (imports inutilisés et erreurs de types)
fix_components() {
    print_step "Correction des composants..."
    
    # Corriger ImprovedHomePage.tsx (imports inutilisés)
    if [ -f "src/components/ImprovedHomePage.tsx" ]; then
        # Corriger juste la ligne d'import pour supprimer les imports inutilisés
        sed -i.bak 's/import { ChevronDown, Star, Globe, Users, BookOpen, Trophy, Zap } from '\''lucide-react'\'';/import { Star, Globe, Users } from '\''lucide-react'\'';/' src/components/ImprovedHomePage.tsx 2>/dev/null || \
        sed -i 's/import { ChevronDown, Star, Globe, Users, BookOpen, Trophy, Zap } from '\''lucide-react'\'';/import { Star, Globe, Users } from '\''lucide-react'\'';/' src/components/ImprovedHomePage.tsx
        
        # Ajouter une vérification de selectedLanguage pour éviter undefined - FIX ligne 15
        sed -i.bak 's/trackLanguageChange(selectedLanguage.code, language.code);/if (selectedLanguage) trackLanguageChange(selectedLanguage.code, language.code);/' src/components/ImprovedHomePage.tsx 2>/dev/null || \
        sed -i 's/trackLanguageChange(selectedLanguage.code, language.code);/if (selectedLanguage) trackLanguageChange(selectedLanguage.code, language.code);/' src/components/ImprovedHomePage.tsx
        
        print_success "ImprovedHomePage.tsx corrigé"
    fi
    
    # Corriger RegionSelector.tsx complètement
    if [ -f "src/components/ui/RegionSelector.tsx" ]; then
        cat > "src/components/ui/RegionSelector.tsx" << 'EOF'
'use client';

import { useState } from 'react';
import { Globe } from 'lucide-react';
import { UNIVERSAL_LANGUAGES, CONTINENTS } from '@/lib/i18n/languages';

interface RegionSelectorProps {
  onLanguageSelect: (languageCode: string) => void;
  selectedLanguage: { code: string; name: string; flag: string };
}

export function RegionSelector({ onLanguageSelect, selectedLanguage }: RegionSelectorProps) {
  const [selectedContinent, setSelectedContinent] = useState<string>('all');
  const [searchTerm, setSearchTerm] = useState('');

  // Filtrer les langues
  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang => {
    const matchesSearch = lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesContinent = selectedContinent === 'all' || lang.continent === selectedContinent;
    
    return matchesSearch && matchesContinent;
  });

  // Grouper par continent - FIX: CONTINENTS est un array de strings
  const groupedLanguages = CONTINENTS.reduce((acc, continent) => {
    acc[continent] = filteredLanguages.filter(lang => lang.continent === continent);
    return acc;
  }, {} as Record<string, typeof UNIVERSAL_LANGUAGES>);

  // Icônes pour les continents
  const continentIcons: Record<string, string> = {
    'Europe': '🇪🇺',
    'Asia': '🌏',
    'North America': '🌎',
    'South America': '🌎',
    'Africa': '🌍',
    'Oceania': '🌏'
  };

  return (
    <div className="w-full max-w-md mx-auto bg-white rounded-lg shadow-lg border border-gray-200">
      {/* Header */}
      <div className="p-4 border-b border-gray-100">
        <div className="flex items-center space-x-2 mb-3">
          <Globe className="w-5 h-5 text-indigo-600" />
          <h3 className="font-semibold text-gray-900">Sélectionner une langue</h3>
        </div>
        
        {/* Barre de recherche */}
        <input
          type="text"
          placeholder="Rechercher une langue..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
        />
      </div>

      {/* Filtres par continent - FIX: continent est maintenant string */}
      <div className="p-3 border-b border-gray-100">
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setSelectedContinent('all')}
            className={`px-3 py-1 text-sm rounded-full transition-colors ${
              selectedContinent === 'all'
                ? 'bg-indigo-100 text-indigo-700'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            Tous
          </button>
          {CONTINENTS.map((continent) => (
            <button
              key={continent}
              onClick={() => setSelectedContinent(continent)}
              className={`px-3 py-1 text-sm rounded-full transition-colors ${
                selectedContinent === continent
                  ? 'bg-indigo-100 text-indigo-700'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {continentIcons[continent]} {continent}
            </button>
          ))}
        </div>
      </div>

      {/* Liste des langues */}
      <div className="max-h-64 overflow-y-auto">
        {Object.entries(groupedLanguages).map(([continent, languages]) => {
          if (languages.length === 0) return null;
          
          return (
            <div key={continent} className="border-b border-gray-100 last:border-b-0">
              {selectedContinent === 'all' && (
                <div className="px-4 py-2 bg-gray-50">
                  <h4 className="text-xs font-semibold text-gray-600 uppercase tracking-wide flex items-center space-x-1">
                    <span>{continentIcons[continent]}</span>
                    <span>{continent}</span>
                  </h4>
                </div>
              )}
              
              <div className="py-1">
                {languages.map((language) => (
                  <button
                    key={language.code}
                    onClick={() => onLanguageSelect(language.code)}
                    className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 ${
                      selectedLanguage.code === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                    }`}
                  >
                    <span className="text-2xl">{language.flag}</span>
                    <div className="flex-1">
                      <div className="font-medium">{language.name}</div>
                      <div className="text-sm text-gray-500">{language.nativeName}</div>
                      <div className="text-xs text-gray-400 flex items-center space-x-2">
                        <span>{language.continent}</span>
                        <span>•</span>
                        <span>{language.currency}</span>
                      </div>
                    </div>
                    {selectedLanguage.code === language.code && (
                      <div className="text-blue-600">✓</div>
                    )}
                  </button>
                ))}
              </div>
            </div>
          );
        })}
        
        {filteredLanguages.length === 0 && (
          <div className="px-4 py-8 text-center text-gray-500">
            <Globe className="w-8 h-8 mx-auto mb-2 text-gray-300" />
            <p>Aucune langue trouvée</p>
            <p className="text-sm">Essayez un autre terme de recherche</p>
          </div>
        )}
      </div>

      {/* Footer */}
      <div className="p-3 border-t border-gray-100 bg-gray-50 text-center">
        <p className="text-xs text-gray-500">
          {UNIVERSAL_LANGUAGES.length} langues • {CONTINENTS.length} continents
        </p>
      </div>
    </div>
  );
}
EOF
        print_success "RegionSelector.tsx complètement corrigé"
    fi
}

# Corriger les imports et types dans les autres fichiers
fix_other_files() {
    print_step "Correction des autres fichiers..."
    
    # Corriger src/lib/constants.ts (React import manquant)
    if [ -f "src/lib/constants.ts" ]; then
        cat > "src/lib/constants.ts" << 'EOF'
import React from 'react';
import { Trophy, BookOpen, Zap } from 'lucide-react';

export const FEATURES = [
  {
    id: 'competitive',
    title: 'Prix compétitifs',
    description: 'Les meilleurs tarifs du marché',
    icon: React.createElement(Trophy, { className: "w-8 h-8" }),
    stat: '60% moins cher'
  },
  {
    id: 'family',
    title: 'Gestion familiale',
    description: 'Suivez les progrès de tous vos enfants',
    icon: React.createElement(BookOpen, { className: "w-8 h-8" }),
    stat: 'Jusqu\'à 6 profils'
  },
  {
    id: 'performance',
    title: 'Performances optimales',
    description: 'Application rapide et fluide',
    icon: React.createElement(Zap, { className: "w-8 h-8" }),
    stat: 'Chargement < 2s'
  }
];
EOF
        print_success "src/lib/constants.ts corrigé"
    fi
    
    # Corriger src/hooks/useLocalStorage.ts (useEffect unused)
    if [ -f "src/hooks/useLocalStorage.ts" ]; then
        cat > "src/hooks/useLocalStorage.ts" << 'EOF'
import { useState } from 'react';

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') {
      return initialValue;
    }
    
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(`Error reading localStorage key "${key}":`, error);
      return initialValue;
    }
  });

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      
      if (typeof window !== 'undefined') {
        window.localStorage.setItem(key, JSON.stringify(valueToStore));
      }
    } catch (error) {
      console.error(`Error setting localStorage key "${key}":`, error);
    }
  };

  return [storedValue, setValue] as const;
}
EOF
        print_success "src/hooks/useLocalStorage.ts corrigé"
    fi
}

# Corriger les tests (erreurs de types unknown)
fix_test_files() {
    print_step "Correction des fichiers de tests..."
    
    # Corriger les erreurs de type 'unknown' dans les tests
    test_files=(
        "tests/setup.spec.ts"
        "tests/stripe/stripe-robust.spec.ts" 
        "tests/translation/translation-robust.spec.ts"
        "tests/enhanced/enhanced-stripe.spec.ts"
        "tests/enhanced/enhanced-translation.spec.ts"
        "tests/helpers/test-helpers.ts"
        "tests/helpers/page-objects.ts"
    )
    
    for test_file in "${test_files[@]}"; do
        if [ -f "$test_file" ]; then
            # Corriger les erreurs de type unknown en ajoutant instanceof Error
            sed -i.bak 's/error\.message/(error instanceof Error ? error.message : String(error))/g' "$test_file" 2>/dev/null || \
            sed -i 's/error\.message/(error instanceof Error ? error.message : String(error))/g' "$test_file"
            
            # Corriger interactionError.message
            sed -i.bak 's/interactionError\.message/(interactionError instanceof Error ? interactionError.message : String(interactionError))/g' "$test_file" 2>/dev/null || \
            sed -i 's/interactionError\.message/(interactionError instanceof Error ? interactionError.message : String(interactionError))/g' "$test_file"
            
            # Supprimer les imports inutilisés comme 'expect' dans page-objects.ts
            if [[ "$test_file" == *"page-objects.ts" ]]; then
                sed -i.bak 's/import { Page, expect } from/import { Page } from/' "$test_file" 2>/dev/null || \
                sed -i 's/import { Page, expect } from/import { Page } from/' "$test_file"
            fi
            
            # Supprimer les variables inutilisées dans les tests
            sed -i.bak 's/{ page }/{ page: _ }/g' "$test_file" 2>/dev/null || \
            sed -i 's/{ page }/{ page: _ }/g' "$test_file"
            
            print_success "$(basename $test_file) corrigé"
        fi
    done
}

# Vérification finale TypeScript
final_typescript_check() {
    print_step "Vérification finale TypeScript..."
    
    if npm run type-check --silent 2>/dev/null; then
        print_success "✅ TOUTES LES ERREURS TYPESCRIPT CORRIGÉES !"
        return 0
    else
        print_warning "Quelques erreurs persistent - vérification manuelle nécessaire"
        return 1
    fi
}

# Test des langues arabes
test_arabic_languages() {
    print_step "Test des langues arabes..."
    
    # Vérifier que les modifications des langues arabes sont toujours là
    if grep -q "ar-PS.*🇵🇸.*Asia" src/lib/i18n/languages.ts && \
       grep -q "ar-MA.*🇲🇦.*Africa" src/lib/i18n/languages.ts && \
       ! grep -q "ar-EG" src/lib/i18n/languages.ts; then
        print_success "✅ Langues arabes correctement configurées:"
        print_success "   🇵🇸 Palestine en Asie/Moyen-Orient"
        print_success "   🇲🇦 Maroc en Afrique"
        print_success "   ❌ Égypte supprimée"
    else
        print_warning "⚠️ Configuration des langues arabes à vérifier"
    fi
}

# Fonction principale
main() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "🔧 CORRECTION TYPESCRIPT v2 - MATH4CHILD"
    echo "=========================================="
    echo -e "${NC}"
    
    check_project_structure
    create_backup
    
    # Corrections dans l'ordre des erreurs les plus critiques
    fix_main_page_tsx          # src/app/page.tsx (lignes 150, 158, 347)
    fix_next_config           # next.config.ts (ligne 3)
    fix_capacitor_config      # capacitor.config.ts (ligne 80)
    fix_i18n_utils           # src/lib/i18n/utils.ts et index.ts
    fix_components           # Composants avec imports inutilisés
    fix_other_files          # Autres fichiers (constants, hooks)
    fix_test_files           # Tests avec erreurs de type unknown
    
    # Vérifications finales
    test_arabic_languages
    
    if final_typescript_check; then
        echo ""
        echo -e "${GREEN}🎉 SUCCÈS ! TOUTES LES ERREURS TYPESCRIPT CORRIGÉES !${NC}"
        echo ""
        echo -e "${BLUE}📋 RÉSUMÉ DES CORRECTIONS :${NC}"
        echo "✅ src/app/page.tsx - Types Language | undefined → Language strict"
        echo "✅ next.config.ts - Types NextConfig avec exactOptionalPropertyTypes"
        echo "✅ capacitor.config.ts - buildOptions supprimé (n'existe pas)"
        echo "✅ src/lib/i18n/utils.ts - Gestion browserLang undefined"
        echo "✅ src/lib/i18n/index.ts - Conflits d'export résolus"
        echo "✅ Composants - Imports inutilisés supprimés"
        echo "✅ Tests - Erreurs 'unknown' type corrigées"
        echo "✅ Langues arabes - Palestine 🇵🇸, Maroc 🇲🇦, Égypte ❌"
        echo ""
        echo -e "${GREEN}🚀 PROJET PRÊT ! Vous pouvez maintenant :${NC}"
        echo "1. npm run dev          # Démarrer le serveur"
        echo "2. npm run build        # Build de production"
        echo "3. npm run test         # Lancer les tests"
        echo ""
    else
        echo ""
        echo -e "${YELLOW}⚠️ Quelques erreurs persistent...${NC}"
        echo ""
        echo -e "${BLUE}🔧 Actions recommandées :${NC}"
        echo "1. Vérifiez les erreurs restantes avec: npm run type-check"
        echo "2. Consultez les logs détaillés ci-dessus"
        echo "3. Restaurez si nécessaire: cp $BACKUP_DIR/* ."
        echo ""
    fi
    
    cd ..
}

# Exécution avec gestion d'erreurs
trap 'print_error "Script interrompu"; exit 1' INT

main "$@"