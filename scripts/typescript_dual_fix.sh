#!/bin/bash

# =====================================
# Script de correction DUAL - 2 fichiers détectés
# Correction simultanée des 2 projets
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

print_error() {
    echo -e "${RED}❌${NC} $1"
}

echo -e "${BLUE}"
echo "======================================================="
echo "🔧 CORRECTION DUAL - 2 FICHIERS DÉTECTÉS"
echo "======================================================="
echo -e "${NC}"

# 1. Correction du fichier apps/math4child/src/app/page.tsx
fix_math4child_page() {
    print_step "Correction de apps/math4child/src/app/page.tsx..."
    
    cd apps/math4child
    
    # Vérifier le contenu problématique
    echo -e "${YELLOW}🔍 Ligne 95 actuelle dans apps/math4child:${NC}"
    sed -n '95p' src/app/page.tsx 2>/dev/null || echo "Ligne non trouvée"
    
    # Chercher et corriger tous les patterns problématiques
    if grep -q "languages\[0\]" src/app/page.tsx; then
        print_step "Pattern 'languages[0]' détecté - correction en cours..."
        
        # Remplacement direct avec sed
        sed -i.bak 's/languages\[0\]/() => getFirstLanguage()/g' src/app/page.tsx
        
        # Vérifier si la correction a fonctionné
        if grep -q "languages\[0\]" src/app/page.tsx; then
            print_error "Correction sed échouée, réécriture complète..."
            
            # Réécriture complète si sed échoue
            cat > "src/app/page.tsx" << 'EOF'
'use client';

import { useState, useEffect } from 'react';
import { UNIVERSAL_LANGUAGES, type Language } from '@/lib/i18n/languages';

const getFirstLanguage = (): Language => {
  const firstLang = UNIVERSAL_LANGUAGES[0];
  if (!firstLang) {
    throw new Error('UNIVERSAL_LANGUAGES ne peut pas être vide');
  }
  return firstLang;
};

function detectBrowserLanguage(): string {
  if (typeof window === 'undefined') return 'fr';
  const browserLang = navigator.language;
  if (!browserLang) return 'fr';
  const langParts = browserLang.split('-');
  const mainLang = langParts[0];
  if (!mainLang) return 'fr';
  const supportedLang = UNIVERSAL_LANGUAGES.find(
    lang => lang.code === browserLang || lang.code.startsWith(mainLang)
  );
  return supportedLang?.code || 'fr';
}

function getLanguageByCodeSafe(code: string): Language {
  const found = UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
  return found || getFirstLanguage();
}

export default function HomePage() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(() => getFirstLanguage());
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    const browserLang = detectBrowserLanguage();
    setSelectedLanguage(getLanguageByCodeSafe(browserLang));
  }, []);

  const handleLanguageChange = (languageCode: string) => {
    const newLanguage = getLanguageByCodeSafe(languageCode);
    setSelectedLanguage(newLanguage);
    setIsDropdownOpen(false);
    document.documentElement.dir = newLanguage.rtl ? 'rtl' : 'ltr';
    document.documentElement.lang = newLanguage.code;
  };

  const getTexts = (langCode: string) => {
    const defaultTexts = {
      title: 'Math4Child',
      subtitle: 'Application éducative pour apprendre les maths',
      description: 'L\'application n°1 pour apprendre les mathématiques en famille !',
      startFree: 'Commencer gratuitement',
      selectLanguage: 'Choisir la langue'
    };

    const textsMap: Record<string, typeof defaultTexts> = {
      'fr': defaultTexts,
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
    
    return textsMap[langCode] ?? defaultTexts;
  };

  const currentTexts = getTexts(selectedLanguage.code);

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 ${selectedLanguage.rtl ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-3xl font-bold text-indigo-900">{currentTexts.title}</h1>
          
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
        fi
        
        print_success "apps/math4child/src/app/page.tsx corrigé"
    else
        print_success "apps/math4child/src/app/page.tsx déjà correct"
    fi
    
    cd ../..
}

# 2. Correction du fichier src/app/page.tsx (racine)
fix_root_page() {
    print_step "Correction de src/app/page.tsx (racine)..."
    
    # Vérifier si le fichier existe
    if [ ! -f "src/app/page.tsx" ]; then
        print_step "src/app/page.tsx n'existe pas - création..."
        mkdir -p src/app
        touch src/app/page.tsx
    fi
    
    # Vérifier le contenu problématique
    echo -e "${YELLOW}🔍 Ligne 20 actuelle dans src/app:${NC}"
    sed -n '20p' src/app/page.tsx 2>/dev/null || echo "Ligne 20 non trouvée"
    
    # Correction de la ligne 20 problématique
    if grep -q "browserLang.split('-')\[0\]" src/app/page.tsx; then
        print_step "Pattern 'browserLang.split...' détecté - correction..."
        
        # Correction avec vérification de undefined
        sed -i.bak 's/browserLang.split.*\[0\]/browserLang.split("-")[0] || "fr"/g' src/app/page.tsx
    fi
    
    # Si le fichier est vide ou très petit, le réécrire complètement
    if [ ! -s "src/app/page.tsx" ] || [ $(wc -l < src/app/page.tsx) -lt 10 ]; then
        print_step "Fichier vide ou trop petit - réécriture complète..."
        
        cat > "src/app/page.tsx" << 'EOF'
'use client';

import { useState, useEffect } from 'react';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8">
        <main className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-6">
            Multi-Apps Platform
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Page racine du projet multi-applications
          </p>
          <div className="space-y-4">
            <a 
              href="/apps/math4child" 
              className="inline-block bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-6 rounded-lg transition-colors"
            >
              Accéder à Math4Child
            </a>
          </div>
        </main>
      </div>
    </div>
  );
}
EOF
    fi
    
    print_success "src/app/page.tsx (racine) corrigé"
}

# 3. Nettoyage des caches pour les 2 projets
cleanup_all_caches() {
    print_step "Nettoyage des caches pour les 2 projets..."
    
    # Cache racine
    rm -rf .next 2>/dev/null || true
    rm -rf node_modules/.cache 2>/dev/null || true
    rm -f tsconfig.tsbuildinfo 2>/dev/null || true
    
    # Cache apps/math4child
    cd apps/math4child 2>/dev/null || true
    rm -rf .next 2>/dev/null || true
    rm -rf node_modules/.cache 2>/dev/null || true
    rm -f tsconfig.tsbuildinfo 2>/dev/null || true
    cd ../.. 2>/dev/null || true
    
    print_success "Caches nettoyés pour les 2 projets"
}

# 4. Test TypeScript pour math4child
test_math4child() {
    print_step "Test TypeScript pour apps/math4child..."
    
    cd apps/math4child
    
    local result=0
    if npm run type-check --silent 2>/dev/null; then
        print_success "✅ apps/math4child - 0 erreur TypeScript"
    else
        print_error "❌ apps/math4child - Erreurs TypeScript persistantes"
        result=1
    fi
    
    cd ../..
    return $result
}

# 5. Test TypeScript pour le projet racine
test_root() {
    print_step "Test TypeScript pour le projet racine..."
    
    local result=0
    if npx tsc --noEmit --skipLibCheck 2>/dev/null; then
        print_success "✅ Projet racine - 0 erreur TypeScript"
    else
        print_error "❌ Projet racine - Erreurs TypeScript persistantes"
        result=1
    fi
    
    return $result
}

# 6. Fonction principale
main() {
    fix_math4child_page
    fix_root_page
    cleanup_all_caches
    
    print_step "Tests TypeScript pour les 2 projets..."
    
    local math4child_ok=0
    local root_ok=0
    
    test_math4child && math4child_ok=1
    test_root && root_ok=1
    
    echo ""
    if [ $math4child_ok -eq 1 ] && [ $root_ok -eq 1 ]; then
        print_success "🎉 SUCCÈS TOTAL - LES 2 PROJETS SONT FIXES !"
        echo ""
        echo -e "${GREEN}📊 CORRECTION DUAL RÉUSSIE :${NC}"
        echo "✅ apps/math4child/src/app/page.tsx - useState corrigé"
        echo "✅ src/app/page.tsx - browserLang.split corrigé"
        echo "✅ Caches nettoyés pour les 2 projets"
        echo "✅ 0 erreur TypeScript dans les 2 projets"
        echo ""
        echo -e "${BLUE}🌍 LANGUES ARABES PRÉSERVÉES :${NC}"
        echo "🇵🇸 Palestine (ar-PS) au Moyen-Orient"
        echo "🇲🇦 Maroc (ar-MA) en Afrique"
        echo ""
        echo -e "${GREEN}🚀 PROJETS 100% FONCTIONNELS !${NC}"
        echo ""
        echo -e "${BLUE}📋 COMMANDES DE TEST :${NC}"
        echo "1. cd apps/math4child && npm run dev"
        echo "2. npm run dev (projet racine)"
        echo "3. npm run type-check (dans chaque projet)"
        echo ""
        echo -e "${GREEN}🏆 MISSION DUAL RÉUSSIE !${NC}"
        
        return 0
    else
        echo ""
        print_error "Certains projets ont encore des erreurs..."
        echo ""
        if [ $math4child_ok -eq 0 ]; then
            echo -e "${YELLOW}📋 Erreurs apps/math4child :${NC}"
            cd apps/math4child && npm run type-check 2>&1 | head -5
            cd ../..
        fi
        if [ $root_ok -eq 0 ]; then
            echo -e "${YELLOW}📋 Erreurs projet racine :${NC}"
            npx tsc --noEmit 2>&1 | head -5
        fi
        echo ""
        return 1
    fi
}

# Exécution
main "$@"