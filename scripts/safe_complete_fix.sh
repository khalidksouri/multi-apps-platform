#!/bin/bash

# =====================================
# Script de correction SÛRE et COMPLÈTE
# Reconstruction complète du fichier avec syntaxe correcte
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
echo "🔧 CORRECTION SÛRE ET COMPLÈTE"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

# Diagnostic du problème
print_step "Diagnostic du problème JSX..."
echo -e "${YELLOW}🔍 Recherche des tags non fermés :${NC}"
grep -n "<header\|</header>" src/app/page.tsx || echo "Aucun header trouvé"

# Sauvegarde de sécurité
print_step "Sauvegarde de sécurité..."
cp src/app/page.tsx src/app/page.tsx.broken
print_success "Sauvegarde créée: src/app/page.tsx.broken"

# Reconstruction complète avec syntaxe JSX parfaite
print_step "Reconstruction complète du fichier..."

cat > "src/app/page.tsx" << 'EOF'
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

// Fonction pour détecter la langue du navigateur
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

// Fonction pour obtenir une langue par code avec fallback
function getLanguageByCodeSafe(code: string): Language {
  const found = UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
  return found || getFirstLanguage();
}

export default function HomePage() {
  // useState avec fonction d'initialisation STRICTE
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
    
    // Appliquer la direction RTL si nécessaire
    document.documentElement.dir = newLanguage.rtl ? 'rtl' : 'ltr';
    document.documentElement.lang = newLanguage.code;
  };

  // Textes traduits simples
  const getTexts = (langCode: string) => {
    const defaultTexts = {
      title: 'Math4Child',
      subtitle: 'Application éducative pour apprendre les maths',
      description: 'L\'application n°1 pour apprendre les mathématiques en famille !',
      startFree: 'Commencer gratuitement',
      selectedLanguage: 'Langue sélectionnée',
      language: 'Langue',
      continent: 'Continent',
      currency: 'Devise',
      whyChoose: 'Pourquoi choisir Math4Child ?',
      personalized: 'Personnalisé',
      personalizedDesc: 'Adapté au niveau de chaque enfant',
      multilingual: 'Multilingue',
      multilingualDesc: 'langues disponibles',
      family: 'En famille',
      familyDesc: 'Suivi des progrès pour les parents',
      families: 'familles satisfaites',
      satisfaction: 'de satisfaction',
      languages: 'langues disponibles'
    };

    const textsMap: Record<string, typeof defaultTexts> = {
      'fr': defaultTexts,
      'en': {
        title: 'Math4Child',
        subtitle: 'Educational app to learn math',
        description: 'The #1 app to learn mathematics as a family!',
        startFree: 'Start for free',
        selectedLanguage: 'Selected language',
        language: 'Language',
        continent: 'Continent',
        currency: 'Currency',
        whyChoose: 'Why choose Math4Child?',
        personalized: 'Personalized',
        personalizedDesc: 'Adapted to each child\'s level',
        multilingual: 'Multilingual',
        multilingualDesc: 'languages available',
        family: 'Family',
        familyDesc: 'Progress tracking for parents',
        families: 'satisfied families',
        satisfaction: 'satisfaction',
        languages: 'languages available'
      },
      'ar-PS': {
        title: 'Math4Child',
        subtitle: 'تطبيق تعليمي لتعلم الرياضيات',
        description: 'التطبيق رقم 1 لتعليم الرياضيات للعائلة في فلسطين!',
        startFree: 'ابدأ مجاناً',
        selectedLanguage: 'اللغة المختارة',
        language: 'اللغة',
        continent: 'القارة',
        currency: 'العملة',
        whyChoose: 'لماذا تختار Math4Child؟',
        personalized: 'مخصص',
        personalizedDesc: 'متكيف مع مستوى كل طفل',
        multilingual: 'متعدد اللغات',
        multilingualDesc: 'لغة متاحة',
        family: 'عائلي',
        familyDesc: 'تتبع التقدم للوالدين',
        families: 'عائلة راضية',
        satisfaction: 'رضا',
        languages: 'لغة متاحة'
      },
      'ar-MA': {
        title: 'Math4Child',
        subtitle: 'تطبيق تعليمي لتعلم الرياضيات',
        description: 'التطبيق رقم 1 لتعليم الرياضيات للعائلة في المغرب!',
        startFree: 'ابدأ مجاناً',
        selectedLanguage: 'اللغة المختارة',
        language: 'اللغة',
        continent: 'القارة',
        currency: 'العملة',
        whyChoose: 'لماذا تختار Math4Child؟',
        personalized: 'مخصص',
        personalizedDesc: 'متكيف مع مستوى كل طفل',
        multilingual: 'متعدد اللغات',
        multilingualDesc: 'لغة متاحة',
        family: 'عائلي',
        familyDesc: 'تتبع التقدم للوالدين',
        families: 'عائلة راضية',
        satisfaction: 'رضا',
        languages: 'لغة متاحة'
      }
    };
    
    return textsMap[langCode] ?? defaultTexts;
  };

  const currentTexts = getTexts(selectedLanguage.code);

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 ${selectedLanguage.rtl ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        {/* Header avec sélecteur de langue - SYNTAXE CORRECTE */}
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
            
            {/* Section d'informations sur la langue sélectionnée - AJOUT COMPLET */}
            <div className="mt-12 p-6 bg-white rounded-lg shadow-sm">
              <h3 className="text-lg font-semibold mb-4">
                {currentTexts.selectedLanguage}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span className="font-medium">{currentTexts.language}:</span> {selectedLanguage.name}
                </div>
                <div>
                  <span className="font-medium">{currentTexts.continent}:</span> {selectedLanguage.continent}
                </div>
                <div>
                  <span className="font-medium">{currentTexts.currency}:</span> {selectedLanguage.currency}
                </div>
              </div>
              
              {/* Support RTL */}
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

            {/* Section statistiques */}
            <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-8">
              <div className="text-center p-6 bg-white rounded-lg shadow-sm">
                <div className="text-4xl font-bold text-indigo-600 mb-2">100k+</div>
                <div className="text-gray-600">{currentTexts.families}</div>
              </div>
              <div className="text-center p-6 bg-white rounded-lg shadow-sm">
                <div className="text-4xl font-bold text-indigo-600 mb-2">98%</div>
                <div className="text-gray-600">{currentTexts.satisfaction}</div>
              </div>
              <div className="text-center p-6 bg-white rounded-lg shadow-sm">
                <div className="text-4xl font-bold text-indigo-600 mb-2">{UNIVERSAL_LANGUAGES.length}</div>
                <div className="text-gray-600">{currentTexts.languages}</div>
              </div>
            </div>

            {/* Section features */}
            <div className="mt-16">
              <h3 className="text-3xl font-bold text-gray-900 mb-12">
                {currentTexts.whyChoose}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div className="p-6 bg-white rounded-lg shadow-sm">
                  <div className="text-4xl mb-4">🎯</div>
                  <h4 className="text-xl font-bold mb-2">{currentTexts.personalized}</h4>
                  <p className="text-gray-600">{currentTexts.personalizedDesc}</p>
                </div>
                <div className="p-6 bg-white rounded-lg shadow-sm">
                  <div className="text-4xl mb-4">🌍</div>
                  <h4 className="text-xl font-bold mb-2">{currentTexts.multilingual}</h4>
                  <p className="text-gray-600">{UNIVERSAL_LANGUAGES.length} {currentTexts.multilingualDesc}</p>
                </div>
                <div className="p-6 bg-white rounded-lg shadow-sm">
                  <div className="text-4xl mb-4">👨‍👩‍👧‍👦</div>
                  <h4 className="text-xl font-bold mb-2">{currentTexts.family}</h4>
                  <p className="text-gray-600">{currentTexts.familyDesc}</p>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
EOF

print_success "Fichier reconstruit avec syntaxe JSX parfaite"

# Test de compilation
print_step "Test de compilation..."
if npm run type-check --silent 2>/dev/null; then
    echo ""
    print_success "🎉 CORRECTION RÉUSSIE - FICHIER PARFAIT !"
    echo ""
    echo -e "${GREEN}✅ PROBLÈMES RÉSOLUS :${NC}"
    echo "• Erreur JSX header non fermé → Corrigée"
    echo "• Section d'informations manquante → Ajoutée"
    echo "• Syntaxe TypeScript parfaite → Validée"
    echo ""
    echo -e "${BLUE}📄 CONTENU COMPLET DISPONIBLE :${NC}"
    echo "• Header avec sélecteur de langue"
    echo "• Section principale (titre, description, bouton)"
    echo "• Section d'informations sur la langue sélectionnée"
    echo "• Section statistiques (100k+, 98%, langues)"
    echo "• Section features (Personnalisé, Multilingue, Famille)"
    echo "• Support Palestine 🇵🇸 et Maroc 🇲🇦"
    echo "• Traductions FR/EN/AR-PS/AR-MA"
    echo ""
    echo -e "${GREEN}🚀 RAFRAÎCHISSEZ VOTRE NAVIGATEUR !${NC}"
    echo "La section d'informations devrait maintenant apparaître"
else
    echo ""
    print_error "Erreurs de compilation persistantes..."
    npm run type-check
    
    # Restaurer en cas d'erreur
    if [ -f "src/app/page.tsx.broken" ]; then
        cp src/app/page.tsx.broken src/app/page.tsx
        print_step "Fichier restauré depuis la sauvegarde"
    fi
fi

cd ../..