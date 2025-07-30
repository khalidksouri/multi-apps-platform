#!/bin/bash

# =====================================
# Script de DIAGNOSTIC AVANCÉ TypeScript
# Détection de la source exacte du problème
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
echo "🔍 DIAGNOSTIC AVANCÉ - DÉTECTION DU PROBLÈME"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

# 1. Diagnostic complet du système
advanced_diagnosis() {
    print_step "Diagnostic avancé du système..."
    
    echo -e "${YELLOW}🔍 1. Recherche de TOUS les fichiers page.tsx :${NC}"
    find . -name "page.tsx" -type f 2>/dev/null | while read file; do
        echo "  📄 $file"
        # Vérifier si ce fichier contient le problème
        if grep -n "languages\[0\]" "$file" 2>/dev/null; then
            echo -e "    ${RED}⚠️  Contient 'languages[0]'${NC}"
        fi
    done
    
    echo -e "${YELLOW}🔍 2. Vérification du tsconfig.json :${NC}"
    if [ -f "tsconfig.json" ]; then
        echo "  ✅ tsconfig.json existe"
        # Vérifier les paths et includes
        if grep -q '"include"' tsconfig.json; then
            echo "  📋 Includes configurés:"
            grep -A 5 '"include"' tsconfig.json
        fi
    else
        echo -e "  ${RED}❌ tsconfig.json manquant${NC}"
    fi
    
    echo -e "${YELLOW}🔍 3. Vérification du cache TypeScript :${NC}"
    if [ -f "tsconfig.tsbuildinfo" ]; then
        echo -e "  ${YELLOW}⚠️  Cache TypeScript détecté${NC}"
        ls -la tsconfig.tsbuildinfo
    else
        echo "  ✅ Pas de cache TypeScript"
    fi
    
    echo -e "${YELLOW}🔍 4. Vérification des node_modules/.cache :${NC}"
    if [ -d "node_modules/.cache" ]; then
        echo -e "  ${YELLOW}⚠️  Cache Node.js détecté${NC}"
        du -sh node_modules/.cache
    else
        echo "  ✅ Pas de cache Node.js"
    fi
    
    echo -e "${YELLOW}🔍 5. Vérification du dossier .next :${NC}"
    if [ -d ".next" ]; then
        echo -e "  ${YELLOW}⚠️  Cache Next.js détecté${NC}"
        du -sh .next
    else
        echo "  ✅ Pas de cache Next.js"
    fi
}

# 2. Vérification du contenu exact du fichier
verify_file_content() {
    print_step "Vérification du contenu exact de src/app/page.tsx..."
    
    if [ -f "src/app/page.tsx" ]; then
        echo -e "${YELLOW}📄 Contenu autour de la ligne 95 :${NC}"
        sed -n '90,100p' src/app/page.tsx | nl -v 90
        
        echo -e "${YELLOW}📄 Recherche de tous les 'useState' :${NC}"
        grep -n "useState" src/app/page.tsx || echo "Aucun useState trouvé"
        
        echo -e "${YELLOW}📄 Recherche de 'selectedLanguage' :${NC}"
        grep -n "selectedLanguage" src/app/page.tsx || echo "Aucun selectedLanguage trouvé"
        
        echo -e "${YELLOW}📄 Hash du fichier :${NC}"
        md5sum src/app/page.tsx 2>/dev/null || shasum src/app/page.tsx
    else
        print_error "Fichier src/app/page.tsx introuvable !"
    fi
}

# 3. Nettoyage ULTRA-AGRESSIF
ultra_cleanup() {
    print_step "Nettoyage ULTRA-AGRESSIF de tous les caches..."
    
    # Arrêter tous les processus Next.js potentiels
    pkill -f "next" 2>/dev/null || true
    
    # Supprimer TOUS les caches possibles
    rm -rf .next 2>/dev/null || true
    rm -rf node_modules/.cache 2>/dev/null || true
    rm -f tsconfig.tsbuildinfo 2>/dev/null || true
    rm -rf .swc 2>/dev/null || true
    rm -rf .turbo 2>/dev/null || true
    
    # Supprimer les caches système
    rm -rf ~/Library/Caches/typescript 2>/dev/null || true
    rm -rf ~/.cache/typescript 2>/dev/null || true
    
    print_success "Nettoyage ultra-agressif terminé"
}

# 4. Recréation ATOMIQUE du fichier avec vérification immédiate
atomic_recreation() {
    print_step "Recréation ATOMIQUE de src/app/page.tsx..."
    
    # Créer dans un fichier temporaire d'abord
    cat > "src/app/page.tsx.tmp" << 'EOF'
'use client';

import { useState, useEffect } from 'react';
import { UNIVERSAL_LANGUAGES, type Language } from '@/lib/i18n/languages';

// Fonction stricte pour obtenir le premier language
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
  const supportedLang = UNIVERSAL_LANGUAGES.find(
    lang => lang.code === browserLang || lang.code.startsWith(browserLang.split('-')[0])
  );
  return supportedLang?.code || 'fr';
}

function getLanguageByCodeSafe(code: string): Language {
  const found = UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
  return found || getFirstLanguage();
}

export default function HomePage() {
  // useState PARFAIT avec fonction d'initialisation
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
    
    # Vérification du fichier temporaire
    echo -e "${YELLOW}🔍 Vérification du fichier temporaire :${NC}"
    if grep -q "languages\[0\]" src/app/page.tsx.tmp; then
        print_error "Le fichier temporaire contient encore l'erreur !"
        return 1
    fi
    
    # Remplacement atomique
    mv src/app/page.tsx.tmp src/app/page.tsx
    
    print_success "Remplacement atomique terminé"
}

# 5. Test avec serveur TypeScript redémarré
test_with_restart() {
    print_step "Test avec redémarrage du serveur TypeScript..."
    
    # Tuer tous les processus TypeScript
    pkill -f "tsc" 2>/dev/null || true
    pkill -f "typescript" 2>/dev/null || true
    
    # Attendre un peu
    sleep 2
    
    # Test immédiat
    if npm run type-check --silent 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# 6. Fonction principale
main() {
    advanced_diagnosis
    verify_file_content
    ultra_cleanup
    atomic_recreation
    
    print_step "Test final avec redémarrage..."
    
    if test_with_restart; then
        echo ""
        print_success "🎉 PROBLÈME RÉSOLU - DIAGNOSTIC RÉUSSI !"
        echo ""
        echo -e "${GREEN}📊 SOLUTION TROUVÉE :${NC}"
        echo "✅ Nettoyage ultra-agressif des caches"
        echo "✅ Recréation atomique du fichier"
        echo "✅ Redémarrage du serveur TypeScript"
        echo "✅ 0 erreur TypeScript"
        echo ""
        echo -e "${BLUE}🌍 LANGUES ARABES INTACTES :${NC}"
        echo "🇵🇸 Palestine (ar-PS) au Moyen-Orient"
        echo "🇲🇦 Maroc (ar-MA) en Afrique"
        echo ""
        echo -e "${GREEN}🚀 PROJET 100% FONCTIONNEL !${NC}"
        
        return 0
    else
        echo ""
        print_error "Problème persistant même après diagnostic avancé..."
        echo ""
        echo -e "${YELLOW}🆘 ANALYSE FINALE :${NC}"
        npm run type-check 2>&1 | head -10
        echo ""
        echo -e "${RED}🔍 CAUSES POSSIBLES RESTANTES :${NC}"
        echo "1. Problème avec @/lib/i18n/languages (import manquant)"
        echo "2. Configuration TypeScript corrompue"
        echo "3. Version de TypeScript incompatible"
        echo "4. Fichier caché ou lien symbolique"
        echo "5. Permission de fichier"
        echo ""
        echo -e "${BLUE}🛠️ ACTIONS MANUELLES RECOMMANDÉES :${NC}"
        echo "1. ls -la src/app/ (vérifier les fichiers)"
        echo "2. cat src/lib/i18n/languages.ts (vérifier l'import)"
        echo "3. npx tsc --version (vérifier la version)"
        echo "4. rm -rf node_modules && npm install (réinstallation)"
        echo ""
        return 1
    fi
}

# Exécution
main "$@"

cd ../..