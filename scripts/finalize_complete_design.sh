#!/bin/bash

# =====================================
# Script de finalisation du design complet
# Ajout des éléments manquants pour le design final
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
echo "🎨 FINALISATION DU DESIGN COMPLET"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

# 1. Analyse de ce qui manque
analyze_missing_elements() {
    print_step "Analyse des éléments manquants..."
    
    echo -e "${YELLOW}📄 Éléments détectés :${NC}"
    if grep -q "Section d'informations" src/app/page.tsx; then
        print_success "✅ Section d'informations sur la langue"
    else
        print_error "❌ Section d'informations manquante"
    fi
    
    if grep -q "Langue sélectionnée" src/app/page.tsx; then
        print_success "✅ Bloc langue sélectionnée"
    else
        print_error "❌ Bloc langue sélectionnée manquant"
    fi
    
    if grep -q "Header avec sélecteur" src/app/page.tsx; then
        print_success "✅ Header avec sélecteur"
    else
        print_error "❌ Header manquant"
    fi
}

# 2. Finalisation complète avec TOUS les éléments
finalize_complete_design() {
    print_step "Finalisation du design complet avec tous les éléments..."
    
    # Sauvegarde
    cp src/app/page.tsx src/app/page.tsx.before-final
    
    # Version finale complète
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

  // Textes traduits avec toutes les langues
  const getTexts = (langCode: string) => {
    const defaultTexts = {
      title: 'Math4Child',
      subtitle: 'Application éducative pour apprendre les maths',
      description: 'L\'application n°1 pour apprendre les mathématiques en famille !',
      startFree: 'Commencer gratuitement',
      selectLanguage: 'Choisir la langue',
      selectedLanguage: 'Langue sélectionnée',
      language: 'Langue',
      continent: 'Continent',
      currency: 'Devise',
      rtlEnabled: 'Support RTL activé pour cette langue',
      palestineInfo: 'Palestine ajoutée au Moyen-Orient avec support complet',
      moroccoInfo: 'Maroc en Afrique avec drapeau marocain maintenu',
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
        selectLanguage: 'Select language',
        selectedLanguage: 'Selected language',
        language: 'Language',
        continent: 'Continent',
        currency: 'Currency',
        rtlEnabled: 'RTL support enabled for this language',
        palestineInfo: 'Palestine added to Middle East with full support',
        moroccoInfo: 'Morocco in Africa with Moroccan flag maintained',
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
      'de': {
        title: 'Math4Child',
        subtitle: 'Lern-App für Mathematik',
        description: 'Die #1 App zum Mathe lernen als Familie!',
        startFree: 'Kostenlos starten',
        selectLanguage: 'Sprache auswählen',
        selectedLanguage: 'Ausgewählte Sprache',
        language: 'Sprache',
        continent: 'Kontinent',
        currency: 'Währung',
        rtlEnabled: 'RTL-Unterstützung für diese Sprache aktiviert',
        palestineInfo: 'Palästina zum Nahen Osten mit vollständiger Unterstützung hinzugefügt',
        moroccoInfo: 'Marokko in Afrika mit marokkanischer Flagge beibehalten',
        whyChoose: 'Warum Math4Child wählen?',
        personalized: 'Personalisiert',
        personalizedDesc: 'An das Niveau jedes Kindes angepasst',
        multilingual: 'Mehrsprachig',
        multilingualDesc: 'verfügbare Sprachen',
        family: 'Familie',
        familyDesc: 'Fortschrittsverfolgung für Eltern',
        families: 'zufriedene Familien',
        satisfaction: 'Zufriedenheit',
        languages: 'verfügbare Sprachen'
      },
      'es': {
        title: 'Math4Child',
        subtitle: 'Aplicación educativa para aprender matemáticas',
        description: '¡La aplicación #1 para aprender matemáticas en familia!',
        startFree: 'Empezar gratis',
        selectLanguage: 'Seleccionar idioma',
        selectedLanguage: 'Idioma seleccionado',
        language: 'Idioma',
        continent: 'Continente',
        currency: 'Moneda',
        rtlEnabled: 'Soporte RTL habilitado para este idioma',
        palestineInfo: 'Palestina añadida a Oriente Medio con soporte completo',
        moroccoInfo: 'Marruecos en África con bandera marroquí mantenida',
        whyChoose: '¿Por qué elegir Math4Child?',
        personalized: 'Personalizado',
        personalizedDesc: 'Adaptado al nivel de cada niño',
        multilingual: 'Multiidioma',
        multilingualDesc: 'idiomas disponibles',
        family: 'En familia',
        familyDesc: 'Seguimiento del progreso para padres',
        families: 'familias satisfechas',
        satisfaction: 'de satisfacción',
        languages: 'idiomas disponibles'
      },
      'ar-PS': {
        title: 'Math4Child',
        subtitle: 'تطبيق تعليمي لتعلم الرياضيات',
        description: 'التطبيق رقم 1 لتعليم الرياضيات للعائلة في فلسطين!',
        startFree: 'ابدأ مجاناً',
        selectLanguage: 'اختر اللغة',
        selectedLanguage: 'اللغة المختارة',
        language: 'اللغة',
        continent: 'القارة',
        currency: 'العملة',
        rtlEnabled: 'دعم الكتابة من اليمين إلى اليسار مُفعل',
        palestineInfo: 'فلسطين مضافة للشرق الأوسط مع دعم كامل',
        moroccoInfo: 'المغرب في أفريقيا مع الحفاظ على العلم المغربي',
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
        selectLanguage: 'اختر اللغة',
        selectedLanguage: 'اللغة المختارة',
        language: 'اللغة',
        continent: 'القارة',
        currency: 'العملة',
        rtlEnabled: 'دعم الكتابة من اليمين إلى اليسار مُفعل',
        palestineInfo: 'فلسطين مضافة للشرق الأوسط مع دعم كامل',
        moroccoInfo: 'المغرب في أفريقيا مع الحفاظ على العلم المغربي',
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
            
            {/* Section d'informations sur la langue sélectionnée */}
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
                  ✨ {currentTexts.rtlEnabled}
                </div>
              )}
              
              {/* Informations spéciales pour Palestine et Maroc */}
              {selectedLanguage.code === 'ar-PS' && (
                <div className="mt-2 text-sm text-green-600">
                  🇵🇸 {currentTexts.palestineInfo}
                </div>
              )}
              {selectedLanguage.code === 'ar-MA' && (
                <div className="mt-2 text-sm text-green-600">
                  🇲🇦 {currentTexts.moroccoInfo}
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
    
    print_success "Design complet finalisé avec tous les éléments"
}

# 3. Vérification complète
verify_complete_design() {
    print_step "Vérification du design complet..."
    
    echo -e "${YELLOW}📄 Taille finale du fichier :${NC}"
    wc -l src/app/page.tsx
    
    echo -e "${YELLOW}📄 Vérification des éléments clés :${NC}"
    
    # Header avec sélecteur
    if grep -q "Header avec sélecteur" src/app/page.tsx; then
        print_success "✅ Header avec sélecteur de langue"
    fi
    
    # Section d'informations
    if grep -q "Section d'informations sur la langue" src/app/page.tsx; then
        print_success "✅ Section d'informations sur la langue"
    fi
    
    # Section statistiques
    if grep -q "Section statistiques" src/app/page.tsx; then
        print_success "✅ Section statistiques"
    fi
    
    # Section features
    if grep -q "Section features" src/app/page.tsx; then
        print_success "✅ Section features"
    fi
    
    # Traductions complètes
    if grep -q "whyChoose.*Warum" src/app/page.tsx; then
        print_success "✅ Traductions complètes"
    fi
}

# 4. Test final
test_complete() {
    print_step "Test final de compilation..."
    
    if npm run type-check --silent 2>/dev/null; then
        print_success "✅ Compilation TypeScript parfaite"
        return 0
    else
        print_error "❌ Erreurs de compilation"
        npm run type-check
        return 1
    fi
}

# 5. Fonction principale
main() {
    analyze_missing_elements
    finalize_complete_design
    verify_complete_design
    
    if test_complete; then
        echo ""
        print_success "🎉 DESIGN COMPLET FINALISÉ AVEC SUCCÈS !"
        echo ""
        echo -e "${GREEN}🎨 DESIGN FINAL INCLUT :${NC}"
        echo "✅ Header avec titre Math4Child + sélecteur de langue"
        echo "✅ Section principale avec titre, description, bouton"
        echo "✅ Section d'informations sur la langue sélectionnée"
        echo "✅ Section statistiques (100k+, 98%, nombre de langues)"
        echo "✅ Section \"Pourquoi choisir Math4Child?\" avec 3 cartes"
        echo "✅ Support RTL complet pour langues arabes"
        echo "✅ Traductions complètes pour 6 langues"
        echo ""
        echo -e "${BLUE}🌍 LANGUES SUPPORTÉES :${NC}"
        echo "🇫🇷 Français (fr) - Europe"
        echo "🇬🇧 English (en) - Europe"
        echo "🇩🇪 Deutsch (de) - Europe"
        echo "🇪🇸 Español (es) - Europe"
        echo "🇵🇸 العربية (ar-PS) - Asie/Moyen-Orient"
        echo "🇲🇦 العربية (ar-MA) - Afrique"
        echo ""
        echo -e "${GREEN}🚀 PAGE COMPLÈTE ET PROFESSIONNELLE !${NC}"
        echo ""
        echo -e "${BLUE}📋 RAFRAÎCHISSEZ VOTRE NAVIGATEUR${NC}"
        echo "Vous devriez maintenant voir :"
        echo "- La section d'informations sur la langue en bas"
        echo "- Tous les textes traduits selon la langue"
        echo "- Messages spéciaux pour Palestine et Maroc"
        echo "- Interface complète et professionnelle"
        
        return 0
    else
        echo ""
        print_error "Erreurs de compilation..."
        return 1
    fi
}

# Exécution
main "$@"

cd ../..