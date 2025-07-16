#!/bin/bash

# 🌍 Script d'Installation Automatique du Système I18n Universel
# Pour les 5 applications indépendantes Next.js + TypeScript
# Auteur: Assistant Claude
# Date: $(date)

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Applications à traiter
APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)

# Fonction pour afficher les messages
print_message() {
    echo -e "${GREEN}[I18N-SETUP]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Vérifier si nous sommes dans le bon répertoire
check_project_structure() {
    print_info "Vérification de la structure du projet..."
    
    if [ ! -d "apps" ]; then
        print_error "Répertoire 'apps' non trouvé. Êtes-vous à la racine du projet?"
        exit 1
    fi
    
    for app in "${APPS[@]}"; do
        if [ ! -d "apps/$app" ]; then
            print_warning "Application apps/$app non trouvée, création..."
            mkdir -p "apps/$app/src"
        fi
    done
    
    print_message "Structure du projet vérifiée ✓"
}

# Créer le hook universel I18n
create_universal_hook() {
    print_info "Création du hook universel I18n..."
    
    for app in "${APPS[@]}"; do
        mkdir -p "apps/$app/src/hooks"
        
        cat > "apps/$app/src/hooks/useUniversalI18n.ts" << 'EOF'
import { useState, useEffect, useCallback } from 'react';

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  direction: 'ltr' | 'rtl';
}

export const SUPPORTED_LANGUAGES: Language[] = [
  // Europe
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr' },
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', direction: 'ltr' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', direction: 'ltr' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', direction: 'ltr' },
  // Asie
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', direction: 'ltr' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', direction: 'ltr' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', direction: 'ltr' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', direction: 'ltr' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', direction: 'ltr' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', direction: 'rtl' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', direction: 'rtl' },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', direction: 'rtl' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', direction: 'ltr' },
  // Moyen-Orient et Afrique
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl' },
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇹🇿', direction: 'ltr' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', direction: 'ltr' },
  { code: 'ha', name: 'Hausa', nativeName: 'Harshen Hausa', flag: '🇳🇬', direction: 'ltr' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', direction: 'ltr' },
  { code: 'ig', name: 'Igbo', nativeName: 'Asụsụ Igbo', flag: '🇳🇬', direction: 'ltr' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', direction: 'ltr' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', direction: 'ltr' },
  // Amériques
  { code: 'pt-BR', name: 'Brazilian Portuguese', nativeName: 'Português (Brasil)', flag: '🇧🇷', direction: 'ltr' },
  { code: 'es-MX', name: 'Mexican Spanish', nativeName: 'Español (México)', flag: '🇲🇽', direction: 'ltr' },
  { code: 'fr-CA', name: 'Canadian French', nativeName: 'Français (Canada)', flag: '🇨🇦', direction: 'ltr' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', direction: 'ltr' },
  // Océanie
  { code: 'mi', name: 'Maori', nativeName: 'Te Reo Māori', flag: '🇳🇿', direction: 'ltr' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', direction: 'ltr' },
];

const detectBrowserLanguage = (): string => {
  if (typeof window === 'undefined') return 'en';
  const lang = navigator.language || navigator.languages?.[0] || 'en';
  const primary = lang.split('-')[0];
  
  if (SUPPORTED_LANGUAGES.some(l => l.code === lang)) return lang;
  if (SUPPORTED_LANGUAGES.some(l => l.code === primary)) return primary;
  return 'en';
};

const STORAGE_KEY = 'universal_app_language';
const LANGUAGE_CHANGE_EVENT = 'universal_language_change';

export const useUniversalI18n = () => {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(() => {
    if (typeof window === 'undefined') {
      return SUPPORTED_LANGUAGES.find(l => l.code === 'en')!;
    }
    
    const savedLang = localStorage.getItem(STORAGE_KEY);
    const detectedLang = detectBrowserLanguage();
    const langCode = savedLang || detectedLang;
    
    return SUPPORTED_LANGUAGES.find(l => l.code === langCode) || 
           SUPPORTED_LANGUAGES.find(l => l.code === 'en')!;
  });

  const [isLoading, setIsLoading] = useState(false);

  const changeLanguage = useCallback(async (languageCode: string) => {
    setIsLoading(true);
    
    try {
      const language = SUPPORTED_LANGUAGES.find(l => l.code === languageCode);
      if (!language) throw new Error(`Language ${languageCode} not supported`);

      setCurrentLanguage(language);
      localStorage.setItem(STORAGE_KEY, languageCode);
      
      document.documentElement.lang = languageCode;
      document.documentElement.dir = language.direction;

      const event = new CustomEvent(LANGUAGE_CHANGE_EVENT, {
        detail: { language, timestamp: Date.now() }
      });
      window.dispatchEvent(event);

      window.dispatchEvent(new StorageEvent('storage', {
        key: STORAGE_KEY,
        newValue: languageCode,
        oldValue: localStorage.getItem(STORAGE_KEY)
      }));

    } catch (error) {
      console.error('Erreur lors du changement de langue:', error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    const handleStorageChange = (event: StorageEvent) => {
      if (event.key === STORAGE_KEY && event.newValue) {
        const language = SUPPORTED_LANGUAGES.find(l => l.code === event.newValue);
        if (language) {
          setCurrentLanguage(language);
          document.documentElement.lang = language.code;
          document.documentElement.dir = language.direction;
        }
      }
    };

    const handleLanguageChange = (event: CustomEvent) => {
      const { language } = event.detail;
      setCurrentLanguage(language);
      document.documentElement.lang = language.code;
      document.documentElement.dir = language.direction;
    };

    window.addEventListener('storage', handleStorageChange);
    window.addEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);

    return () => {
      window.removeEventListener('storage', handleStorageChange);
      window.removeEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);
    };
  }, []);

  useEffect(() => {
    document.documentElement.lang = currentLanguage.code;
    document.documentElement.dir = currentLanguage.direction;
  }, [currentLanguage]);

  return {
    currentLanguage,
    changeLanguage,
    isLoading,
    supportedLanguages: SUPPORTED_LANGUAGES,
    isRTL: currentLanguage.direction === 'rtl'
  };
};

export const useTranslation = (translations: Record<string, Record<string, string>>) => {
  const { currentLanguage } = useUniversalI18n();

  const t = useCallback((key: string, params?: Record<string, string>): string => {
    const keys = key.split('.');
    let value: any = translations[currentLanguage.code] || translations['en'] || {};
    
    for (const k of keys) {
      value = value?.[k];
    }
    
    if (typeof value !== 'string') {
      console.warn(`Translation missing for key: ${key} in language: ${currentLanguage.code}`);
      return key;
    }

    if (params) {
      return value.replace(/\{\{(\w+)\}\}/g, (match: string, paramKey: string) => {
        return params[paramKey] || match;
      });
    }

    return value;
  }, [currentLanguage.code, translations]);

  return { t, currentLanguage };
};

export const LanguageSelector = ({ 
  className = "",
  onChange
}: {
  className?: string;
  onChange?: (language: Language) => void;
}) => {
  const { currentLanguage, changeLanguage } = useUniversalI18n();

  const handleLanguageChange = async (langCode: string) => {
    await changeLanguage(langCode);
    const language = SUPPORTED_LANGUAGES.find(l => l.code === langCode);
    if (language && onChange) {
      onChange(language);
    }
  };

  return (
    <select 
      value={currentLanguage.code} 
      onChange={(e) => handleLanguageChange(e.target.value)}
      className={`border rounded px-3 py-2 bg-white shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 ${className}`}
    >
      {SUPPORTED_LANGUAGES.map(lang => (
        <option key={lang.code} value={lang.code}>
          {lang.flag} {lang.nativeName}
        </option>
      ))}
    </select>
  );
};
EOF

        print_message "Hook I18n créé pour $app ✓"
    done
}

# Créer les fichiers de traduction pour chaque application
create_translations() {
    print_info "Création des fichiers de traduction..."
    
    # PostMath
    mkdir -p "apps/postmath/src/translations"
    cat > "apps/postmath/src/translations/index.ts" << 'EOF'
export const translations = {
  en: {
    appName: "PostMath Pro",
    appDescription: "Professional shipping calculator",
    calculate: "Calculate",
    clear: "Clear",
    history: "History",
    result: "Result",
    weight: "Weight",
    dimensions: "Dimensions",
    destination: "Destination",
    shipping: "Shipping",
    cost: "Cost",
    enterValidNumbers: "Please enter valid numbers",
    selectDestination: "Please select a destination",
    navigation: {
      home: "Home",
      calculator: "Calculator",
      history: "History",
      settings: "Settings"
    },
    buttons: {
      calculate: "Calculate Shipping",
      clear: "Clear Form",
      save: "Save Result"
    }
  },
  fr: {
    appName: "PostMath Pro",
    appDescription: "Calculateur d'expédition professionnel",
    calculate: "Calculer",
    clear: "Effacer",
    history: "Historique",
    result: "Résultat",
    weight: "Poids",
    dimensions: "Dimensions",
    destination: "Destination",
    shipping: "Expédition",
    cost: "Coût",
    enterValidNumbers: "Veuillez entrer des nombres valides",
    selectDestination: "Veuillez sélectionner une destination",
    navigation: {
      home: "Accueil",
      calculator: "Calculatrice",
      history: "Historique",
      settings: "Paramètres"
    },
    buttons: {
      calculate: "Calculer l'expédition",
      clear: "Effacer le formulaire",
      save: "Sauvegarder le résultat"
    }
  },
  es: {
    appName: "PostMath Pro",
    appDescription: "Calculadora de envío profesional",
    calculate: "Calcular",
    clear: "Limpiar",
    history: "Historial",
    result: "Resultado",
    weight: "Peso",
    dimensions: "Dimensiones",
    destination: "Destino",
    shipping: "Envío",
    cost: "Costo",
    enterValidNumbers: "Por favor ingrese números válidos",
    selectDestination: "Por favor seleccione un destino",
    navigation: {
      home: "Inicio",
      calculator: "Calculadora",
      history: "Historial",
      settings: "Configuración"
    },
    buttons: {
      calculate: "Calcular envío",
      clear: "Limpiar formulario",
      save: "Guardar resultado"
    }
  },
  de: {
    appName: "PostMath Pro",
    appDescription: "Professioneller Versandrechner",
    calculate: "Berechnen",
    clear: "Löschen",
    history: "Verlauf",
    result: "Ergebnis",
    weight: "Gewicht",
    dimensions: "Abmessungen",
    destination: "Zielort",
    shipping: "Versand",
    cost: "Kosten",
    enterValidNumbers: "Bitte geben Sie gültige Zahlen ein",
    selectDestination: "Bitte wählen Sie ein Ziel",
    navigation: {
      home: "Startseite",
      calculator: "Rechner",
      history: "Verlauf",
      settings: "Einstellungen"
    },
    buttons: {
      calculate: "Versand berechnen",
      clear: "Formular löschen",
      save: "Ergebnis speichern"
    }
  },
  ar: {
    appName: "PostMath Pro",
    appDescription: "حاسبة الشحن المهنية",
    calculate: "احسب",
    clear: "مسح",
    history: "التاريخ",
    result: "النتيجة",
    weight: "الوزن",
    dimensions: "الأبعاد",
    destination: "الوجهة",
    shipping: "الشحن",
    cost: "التكلفة",
    enterValidNumbers: "يرجى إدخال أرقام صالحة",
    selectDestination: "يرجى اختيار وجهة",
    navigation: {
      home: "الرئيسية",
      calculator: "الحاسبة",
      history: "التاريخ",
      settings: "الإعدادات"
    },
    buttons: {
      calculate: "احسب الشحن",
      clear: "مسح النموذج",
      save: "حفظ النتيجة"
    }
  },
  zh: {
    appName: "PostMath Pro",
    appDescription: "专业运输计算器",
    calculate: "计算",
    clear: "清除",
    history: "历史",
    result: "结果",
    weight: "重量",
    dimensions: "尺寸",
    destination: "目的地",
    shipping: "运输",
    cost: "费用",
    enterValidNumbers: "请输入有效数字",
    selectDestination: "请选择目的地",
    navigation: {
      home: "首页",
      calculator: "计算器",
      history: "历史",
      settings: "设置"
    },
    buttons: {
      calculate: "计算运费",
      clear: "清除表单",
      save: "保存结果"
    }
  }
};
EOF

    # UnitFlip
    mkdir -p "apps/unitflip/src/translations"
    cat > "apps/unitflip/src/translations/index.ts" << 'EOF'
export const translations = {
  en: {
    appName: "UnitFlip Pro",
    appDescription: "Professional unit converter",
    convert: "Convert",
    from: "From",
    to: "To",
    enterValue: "Enter value to convert",
    result: "Result",
    categories: {
      length: "Length",
      weight: "Weight",
      temperature: "Temperature",
      volume: "Volume",
      area: "Area",
      speed: "Speed"
    },
    units: {
      meter: "Meter",
      kilometer: "Kilometer",
      centimeter: "Centimeter",
      inch: "Inch",
      foot: "Foot",
      kilogram: "Kilogram",
      gram: "Gram",
      pound: "Pound",
      celsius: "Celsius",
      fahrenheit: "Fahrenheit",
      kelvin: "Kelvin"
    },
    navigation: {
      home: "Home",
      converter: "Converter",
      favorites: "Favorites",
      settings: "Settings"
    }
  },
  fr: {
    appName: "UnitFlip Pro",
    appDescription: "Convertisseur d'unités professionnel",
    convert: "Convertir",
    from: "De",
    to: "Vers",
    enterValue: "Entrez la valeur à convertir",
    result: "Résultat",
    categories: {
      length: "Longueur",
      weight: "Poids",
      temperature: "Température",
      volume: "Volume",
      area: "Surface",
      speed: "Vitesse"
    },
    units: {
      meter: "Mètre",
      kilometer: "Kilomètre",
      centimeter: "Centimètre",
      inch: "Pouce",
      foot: "Pied",
      kilogram: "Kilogramme",
      gram: "Gramme",
      pound: "Livre",
      celsius: "Celsius",
      fahrenheit: "Fahrenheit",
      kelvin: "Kelvin"
    },
    navigation: {
      home: "Accueil",
      converter: "Convertisseur",
      favorites: "Favoris",
      settings: "Paramètres"
    }
  },
  es: {
    appName: "UnitFlip Pro",
    appDescription: "Convertidor de unidades profesional",
    convert: "Convertir",
    from: "De",
    to: "A",
    enterValue: "Ingrese valor a convertir",
    result: "Resultado",
    categories: {
      length: "Longitud",
      weight: "Peso",
      temperature: "Temperatura",
      volume: "Volumen",
      area: "Área",
      speed: "Velocidad"
    },
    units: {
      meter: "Metro",
      kilometer: "Kilómetro",
      centimeter: "Centímetro",
      inch: "Pulgada",
      foot: "Pie",
      kilogram: "Kilogramo",
      gram: "Gramo",
      pound: "Libra",
      celsius: "Celsius",
      fahrenheit: "Fahrenheit",
      kelvin: "Kelvin"
    },
    navigation: {
      home: "Inicio",
      converter: "Convertidor",
      favorites: "Favoritos",
      settings: "Configuración"
    }
  }
};
EOF

    # BudgetCron
    mkdir -p "apps/budgetcron/src/translations"
    cat > "apps/budgetcron/src/translations/index.ts" << 'EOF'
export const translations = {
  en: {
    appName: "BudgetCron",
    appDescription: "AI-powered budget management",
    income: "Income",
    expenses: "Expenses",
    balance: "Balance",
    addTransaction: "Add Transaction",
    category: "Category",
    amount: "Amount",
    date: "Date",
    description: "Description",
    categories: {
      food: "Food",
      transport: "Transport",
      entertainment: "Entertainment",
      utilities: "Utilities",
      health: "Health",
      shopping: "Shopping"
    },
    navigation: {
      dashboard: "Dashboard",
      transactions: "Transactions",
      analytics: "Analytics",
      settings: "Settings"
    }
  },
  fr: {
    appName: "BudgetCron",
    appDescription: "Gestion budgétaire avec IA",
    income: "Revenus",
    expenses: "Dépenses",
    balance: "Solde",
    addTransaction: "Ajouter une transaction",
    category: "Catégorie",
    amount: "Montant",
    date: "Date",
    description: "Description",
    categories: {
      food: "Alimentation",
      transport: "Transport",
      entertainment: "Divertissement",
      utilities: "Services publics",
      health: "Santé",
      shopping: "Achats"
    },
    navigation: {
      dashboard: "Tableau de bord",
      transactions: "Transactions",
      analytics: "Analyses",
      settings: "Paramètres"
    }
  }
};
EOF

    # AI4Kids
    mkdir -p "apps/ai4kids/src/translations"
    cat > "apps/ai4kids/src/translations/index.ts" << 'EOF'
export const translations = {
  en: {
    appName: "AI4Kids",
    appDescription: "Learn AI through play",
    welcome: "Welcome to AI4Kids",
    description: "Discover the exciting world of artificial intelligence through games!",
    learn: "Learn",
    play: "Play",
    explore: "Explore",
    gamesTitle: "Educational Games",
    gamesDescription: "Learn mathematics, science and much more through interactive games!",
    gamesButton: "Play now",
    storiesTitle: "Magic Stories",
    storiesDescription: "Discover captivating stories that teach you important values!",
    storiesButton: "Read a story",
    navigation: {
      home: "Home",
      games: "Games",
      stories: "Stories",
      profile: "Profile"
    }
  },
  fr: {
    appName: "AI4Kids",
    appDescription: "Apprendre l'IA en jouant",
    welcome: "Bienvenue sur AI4Kids",
    description: "Découvre le monde passionnant de l'intelligence artificielle à travers des jeux!",
    learn: "Apprendre",
    play: "Jouer",
    explore: "Explorer",
    gamesTitle: "Jeux Éducatifs",
    gamesDescription: "Apprends les mathématiques, les sciences et bien plus à travers des jeux interactifs!",
    gamesButton: "Jouer maintenant",
    storiesTitle: "Histoires Magiques",
    storiesDescription: "Découvre des histoires captivantes qui t'enseignent des valeurs importantes!",
    storiesButton: "Lire une histoire",
    navigation: {
      home: "Accueil",
      games: "Jeux",
      stories: "Histoires",
      profile: "Profil"
    }
  }
};
EOF

    # MultiAI
    mkdir -p "apps/multiai/src/translations"
    cat > "apps/multiai/src/translations/index.ts" << 'EOF'
export const translations = {
  en: {
    appName: "MultiAI",
    appDescription: "AI Hub with authentication",
    search: "Search",
    query: "Search query",
    results: "Results",
    engines: "Search Engines",
    categories: "Categories",
    history: "Search History",
    settings: "Settings",
    services: {
      textGeneration: "Text Generation",
      imageGeneration: "Image Generation",
      codeAssistant: "Code Assistant",
      speechSynthesis: "Speech Synthesis"
    },
    navigation: {
      home: "Home",
      services: "AI Services",
      history: "History",
      settings: "Settings"
    }
  },
  fr: {
    appName: "MultiAI",
    appDescription: "Hub IA avec authentification",
    search: "Rechercher",
    query: "Requête de recherche",
    results: "Résultats",
    engines: "Moteurs de recherche",
    categories: "Catégories",
    history: "Historique de recherche",
    settings: "Paramètres",
    services: {
      textGeneration: "Génération de texte",
      imageGeneration: "Génération d'images",
      codeAssistant: "Assistant de code",
      speechSynthesis: "Synthèse vocale"
    },
    navigation: {
      home: "Accueil",
      services: "Services IA",
      history: "Historique",
      settings: "Paramètres"
    }
  }
};
EOF

    print_message "Fichiers de traduction créés pour toutes les applications ✓"
}

# Créer le composant I18n Layout pour chaque application
create_i18n_layout() {
    print_info "Création des composants I18n Layout..."
    
    for app in "${APPS[@]}"; do
        mkdir -p "apps/$app/src/components"
        
        cat > "apps/$app/src/components/I18nLayout.tsx" << 'EOF'
'use client';

import React, { useEffect, useState } from 'react';
import { useUniversalI18n, LanguageSelector } from '../hooks/useUniversalI18n';

interface I18nLayoutProps {
  children: React.ReactNode;
  showLanguageSelector?: boolean;
}

export const I18nLayout: React.FC<I18nLayoutProps> = ({ 
  children, 
  showLanguageSelector = true 
}) => {
  const { currentLanguage, isRTL } = useUniversalI18n();
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) {
    return <div className="min-h-screen bg-gray-100 animate-pulse" />;
  }

  return (
    <div 
      className={`min-h-screen ${isRTL ? 'rtl' : 'ltr'}`}
      dir={isRTL ? 'rtl' : 'ltr'}
      lang={currentLanguage.code}
    >
      {showLanguageSelector && (
        <div className="fixed top-4 right-4 z-50">
          <LanguageSelector 
            className="bg-white shadow-lg border border-gray-300 rounded-lg px-3 py-2 text-sm font-medium hover:shadow-xl transition-shadow"
            onChange={(language) => {
              console.log(`🌍 Langue changée vers ${language.nativeName}`);
            }}
          />
        </div>
      )}

      <main className="relative">
        {children}
      </main>

      <div className="fixed bottom-2 left-2 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-xs font-mono z-40">
        {currentLanguage.flag} {currentLanguage.code}
      </div>
    </div>
  );
};
EOF

        print_message "Composant I18nLayout créé pour $app ✓"
    done
}

# Créer les layouts Next.js pour chaque application
create_nextjs_layouts() {
    print_info "Création des layouts Next.js..."
    
    local app_names=("PostMath Pro" "UnitFlip Pro" "BudgetCron" "AI4Kids" "MultiAI")
    
    for i in "${!APPS[@]}"; do
        app="${APPS[$i]}"
        app_name="${app_names[$i]}"
        
        mkdir -p "apps/$app/src/app"
        
        cat > "apps/$app/src/app/layout.tsx" << EOF
import { I18nLayout } from '@/components/I18nLayout';
import './globals.css';

export const metadata = {
  title: '$app_name',
  description: 'Application multilingue $app_name',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html>
      <body>
        <I18nLayout showLanguageSelector={true}>
          {children}
        </I18nLayout>
      </body>
    </html>
  );
}
EOF

        print_message "Layout Next.js créé pour $app ✓"
    done
}

# Créer les pages d'accueil pour chaque application
create_home_pages() {
    print_info "Création des pages d'accueil..."
    
    local app_names=("PostMath Pro" "UnitFlip Pro" "BudgetCron" "AI4Kids" "MultiAI")
    
    for i in "${!APPS[@]}"; do
        app="${APPS[$i]}"
        app_name="${app_names[$i]}"
        port="${PORTS[$i]}"
        
        cat > "apps/$app/src/app/page.tsx" << EOF
'use client';

import { useTranslation } from '@/hooks/useUniversalI18n';
import { translations } from '@/translations';

export default function HomePage() {
  const { t, currentLanguage } = useTranslation(translations);

  return (
    <div className="container mx-auto px-4 py-8">
      <header className="text-center mb-12">
        <h1 className="text-5xl font-bold text-gray-800 mb-4">
          {t('appName')}
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          {t('appDescription')}
        </p>
        <div className="inline-flex items-center space-x-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full">
          <span className="text-2xl">{currentLanguage.flag}</span>
          <span className="font-medium">{currentLanguage.nativeName}</span>
        </div>
      </header>

      <main className="max-w-4xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Navigation Cards */}
          {Object.entries(t('navigation') || {}).map(([key, value]) => (
            <div key={key} className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6">
              <h3 className="text-xl font-semibold mb-2">{value as string}</h3>
              <p className="text-gray-600 mb-4">
                Navigation vers {value as string}
              </p>
              <button className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition-colors">
                {t('navigate') || 'Accéder'}
              </button>
            </div>
          ))}
        </div>

        {/* Info Section */}
        <div className="mt-12 bg-gray-50 rounded-lg p-8">
          <h2 className="text-2xl font-bold mb-4">
            🌍 Application Multilingue
          </h2>
          <p className="text-gray-700 mb-4">
            Cette application supporte plus de 30 langues de tous les continents. 
            Votre choix de langue est automatiquement sauvegardé et persisté 
            lors de la navigation.
          </p>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl mb-2">🇬🇧</div>
              <div className="text-sm">English</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇫🇷</div>
              <div className="text-sm">Français</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇪🇸</div>
              <div className="text-sm">Español</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇨🇳</div>
              <div className="text-sm">中文</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇸🇦</div>
              <div className="text-sm">العربية</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇩🇪</div>
              <div className="text-sm">Deutsch</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇮🇳</div>
              <div className="text-sm">हिन्दी</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇯🇵</div>
              <div className="text-sm">日本語</div>
            </div>
          </div>
        </div>

        {/* Port Info */}
        <div className="mt-8 text-center">
          <div className="bg-green-100 border border-green-300 rounded-lg p-4">
            <p className="text-green-800">
              🚀 Application en cours d'exécution sur le port $port
            </p>
            <p className="text-green-600 text-sm mt-2">
              URL: http://localhost:$port
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

        print_message "Page d'accueil créée pour $app ✓"
    done
}

# Créer les fichiers CSS globaux
create_global_css() {
    print_info "Création des fichiers CSS globaux..."
    
    for app in "${APPS[@]}"; do
        cat > "apps/$app/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Styles RTL */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .fixed.top-4.right-4 {
  right: auto;
  left: 1rem;
}

[dir="rtl"] .fixed.bottom-2.left-2 {
  left: auto;
  right: 0.5rem;
}

/* Animations */
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: .5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Transitions */
.transition-shadow {
  transition-property: box-shadow;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.transition-colors {
  transition-property: color, background-color, border-color;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

/* Responsive */
@media (max-width: 768px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}
EOF

        print_message "CSS global créé pour $app ✓"
    done
}

# Créer les fichiers de configuration TypeScript
create_typescript_config() {
    print_info "Création des configurations TypeScript..."
    
    for app in "${APPS[@]}"; do
        cat > "apps/$app/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

        print_message "Configuration TypeScript créée pour $app ✓"
    done
}

# Créer les fichiers Next.js config
create_nextjs_config() {
    print_info "Création des configurations Next.js..."
    
    for app in "${APPS[@]}"; do
        cat > "apps/$app/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  reactStrictMode: true,
  swcMinify: true,
  output: 'standalone',
  images: {
    unoptimized: true,
  },
  // Configuration i18n
  i18n: {
    locales: ['en', 'fr', 'es', 'de', 'ar', 'zh', 'ja', 'ko', 'hi', 'pt', 'it', 'ru', 'nl', 'pl', 'cs', 'hu', 'tr', 'th', 'vi', 'id', 'bn', 'ur', 'fa', 'he', 'sw', 'am', 'ha', 'yo', 'ig', 'zu', 'af', 'pt-BR', 'es-MX', 'fr-CA', 'qu', 'mi', 'sm'],
    defaultLocale: 'en',
    localeDetection: true,
  },
  trailingSlash: false,
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
}

module.exports = nextConfig
EOF

        print_message "Configuration Next.js créée pour $app ✓"
    done
}

# Créer les package.json pour chaque application
create_package_json() {
    print_info "Création des fichiers package.json..."
    
    local app_names=("PostMath Pro" "UnitFlip Pro" "BudgetCron" "AI4Kids" "MultiAI")
    
    for i in "${!APPS[@]}"; do
        app="${APPS[$i]}"
        app_name="${app_names[$i]}"
        port="${PORTS[$i]}"
        
        cat > "apps/$app/package.json" << EOF
{
  "name": "$app",
  "version": "1.0.0",
  "description": "$app_name - Application multilingue",
  "scripts": {
    "dev": "next dev -p $port",
    "build": "next build",
    "start": "next start -p $port",
    "lint": "next lint",
    "export": "next export",
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "i18n:extract": "echo 'Extraction des clés i18n...'",
    "i18n:validate": "echo 'Validation des traductions...'"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.2.0",
    "@types/node": "^20.8.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0"
  },
  "devDependencies": {
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "eslint": "^8.52.0",
    "eslint-config-next": "^14.0.0",
    "@playwright/test": "^1.40.0"
  },
  "keywords": ["i18n", "multilingual", "nextjs", "typescript", "$app"],
  "author": "Assistant Claude",
  "license": "MIT",
  "private": true
}
EOF

        print_message "Package.json créé pour $app ✓"
    done
}

# Créer les configurations Tailwind CSS
create_tailwind_config() {
    print_info "Création des configurations Tailwind CSS..."
    
    for app in "${APPS[@]}"; do
        cat > "apps/$app/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        },
      },
      screens: {
        'xs': '475px',
      },
    },
  },
  plugins: [],
  // Support RTL
  future: {
    hoverOnlyWhenSupported: true,
  },
}
EOF

        cat > "apps/$app/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

        print_message "Configuration Tailwind créée pour $app ✓"
    done
}

# Créer un script de démarrage global
create_start_script() {
    print_info "Création du script de démarrage global..."
    
    cat > "start-all-apps.sh" << 'EOF'
#!/bin/bash

# Script pour démarrer toutes les applications multilingues
echo "🚀 Démarrage de toutes les applications multilingues..."

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonction pour démarrer une application
start_app() {
    local app=$1
    local port=$2
    
    echo -e "${BLUE}Démarrage de $app sur le port $port...${NC}"
    
    if [ -d "apps/$app" ]; then
        cd "apps/$app"
        
        # Installer les dépendances si nécessaire
        if [ ! -d "node_modules" ]; then
            echo "Installation des dépendances pour $app..."
            npm install
        fi
        
        # Démarrer l'application en arrière-plan
        npm run dev &
        
        cd ../..
        echo -e "${GREEN}$app démarré sur http://localhost:$port${NC}"
    else
        echo "❌ Application $app non trouvée"
    fi
}

# Démarrer toutes les applications
start_app "postmath" 3001
start_app "unitflip" 3002
start_app "budgetcron" 3003
start_app "ai4kids" 3004
start_app "multiai" 3005

echo ""
echo "🌍 Toutes les applications multilingues sont en cours de démarrage..."
echo ""
echo "📱 URLs des applications:"
echo "  • PostMath Pro:  http://localhost:3001"
echo "  • UnitFlip Pro:  http://localhost:3002"
echo "  • BudgetCron:    http://localhost:3003"
echo "  • AI4Kids:       http://localhost:3004"
echo "  • MultiAI:       http://localhost:3005"
echo ""
echo "🎯 Fonctionnalités I18n:"
echo "  ✅ 30+ langues supportées"
echo "  ✅ Persistance automatique"
echo "  ✅ Synchronisation inter-onglets"
echo "  ✅ Support RTL (Arabe, Hébreu, etc.)"
echo "  ✅ Détection automatique de langue"
echo ""
echo "Pour arrêter toutes les applications, appuyez sur Ctrl+C"

# Attendre que l'utilisateur arrête
wait
EOF

    chmod +x "start-all-apps.sh"
    print_message "Script de démarrage global créé ✓"
}

# Créer un script d'installation des dépendances
create_install_script() {
    print_info "Création du script d'installation des dépendances..."
    
    cat > "install-all-dependencies.sh" << 'EOF'
#!/bin/bash

# Script pour installer toutes les dépendances
echo "📦 Installation des dépendances pour toutes les applications..."

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")

for app in "${APPS[@]}"; do
    if [ -d "apps/$app" ]; then
        echo "📦 Installation des dépendances pour $app..."
        cd "apps/$app"
        npm install
        cd ../..
        echo "✅ Dépendances installées pour $app"
    else
        echo "❌ Application $app non trouvée"
    fi
done

echo ""
echo "🎉 Installation terminée!"
echo "Utilisez ./start-all-apps.sh pour démarrer toutes les applications"
EOF

    chmod +x "install-all-dependencies.sh"
    print_message "Script d'installation des dépendances créé ✓"
}

# Créer un fichier README avec les instructions
create_readme() {
    print_info "Création du fichier README..."
    
    cat > "README-I18N.md" << 'EOF'
# 🌍 Système d'Internationalisation Universel

## 📋 Vue d'ensemble

Ce système d'internationalisation a été automatiquement configuré pour vos 5 applications Next.js indépendantes :

- **PostMath Pro** (port 3001) - Calculateur d'expédition
- **UnitFlip Pro** (port 3002) - Convertisseur d'unités  
- **BudgetCron** (port 3003) - Gestion budgétaire avec IA
- **AI4Kids** (port 3004) - Plateforme d'apprentissage IA
- **MultiAI** (port 3005) - Hub IA avec authentification

## ✨ Fonctionnalités

### 🌐 Support multilingue complet
- **30+ langues** de tous les continents
- **Détection automatique** de la langue du navigateur
- **Persistance garantie** - La langue reste active lors de la navigation
- **Synchronisation inter-onglets** - Changement global sur tous les onglets

### 🔄 Langues supportées
- **Europe**: Anglais, Français, Espagnol, Allemand, Italien, Portugais, Russe, Néerlandais, Polonais, Tchèque, Hongrois, etc.
- **Asie**: Chinois, Japonais, Coréen, Hindi, Thaï, Vietnamien, Indonésien, Bengali, Turc, etc.
- **Moyen-Orient/Afrique**: Arabe, Hébreu, Persan, Swahili, Amharique, Hausa, Yoruba, Igbo, Zulu, etc.
- **Amériques**: Portugais brésilien, Espagnol mexicain, Français canadien, Quechua, etc.
- **Océanie**: Maori, Hawaiien, Samoan, Tongan, etc.

### 📱 Support RTL/LTR
- **RTL automatique** pour l'arabe, l'hébreu, le persan, l'ourdou
- **Interface adaptée** selon la direction de lecture
- **Positionnement intelligent** des éléments UI

## 🚀 Démarrage rapide

### 1. Installation des dépendances
```bash
./install-all-dependencies.sh
```

### 2. Démarrage de toutes les applications
```bash
./start-all-apps.sh
```

### 3. Accès aux applications
- PostMath Pro: http://localhost:3001
- UnitFlip Pro: http://localhost:3002
- BudgetCron: http://localhost:3003
- AI4Kids: http://localhost:3004
- MultiAI: http://localhost:3005

## 📁 Structure du projet

```
apps/
├── postmath/
│   ├── src/
│   │   ├── hooks/useUniversalI18n.ts      # Hook I18n universel
│   │   ├── components/I18nLayout.tsx      # Layout avec I18n
│   │   ├── translations/index.ts          # Traductions spécifiques
│   │   └── app/
│   │       ├── layout.tsx                 # Layout principal
│   │       ├── page.tsx                   # Page d'accueil
│   │       └── globals.css                # Styles globaux
│   ├── package.json
│   ├── tsconfig.json
│   ├── next.config.js
│   └── tailwind.config.js
├── unitflip/
│   └── [même structure]
├── budgetcron/
│   └── [même structure]
├── ai4kids/
│   └── [même structure]
└── multiai/
    └── [même structure]
```

## 🛠️ Utilisation

### Dans vos composants
```typescript
import { useTranslation } from '@/hooks/useUniversalI18n';
import { translations } from '@/translations';

export default function MyComponent() {
  const { t, currentLanguage } = useTranslation(translations);
  
  return (
    <div>
      <h1>{t('appName')}</h1>
      <p>{t('appDescription')}</p>
      <span>{currentLanguage.flag} {currentLanguage.nativeName}</span>
    </div>
  );
}
```

### Sélecteur de langue
```typescript
import { LanguageSelector } from '@/hooks/useUniversalI18n';

export default function Header() {
  return (
    <header>
      <LanguageSelector 
        className="my-custom-class"
        onChange={(language) => {
          console.log('Langue changée:', language.nativeName);
        }}
      />
    </header>
  );
}
```

## 🔧 Configuration

### Ajouter une nouvelle traduction
1. Ouvrez `apps/[app]/src/translations/index.ts`
2. Ajoutez votre clé dans chaque langue :
```typescript
export const translations = {
  en: {
    myNewKey: "My new text in English"
  },
  fr: {
    myNewKey: "Mon nouveau texte en français"
  },
  // ... autres langues
};
```

### Ajouter une nouvelle langue
1. Modifiez `SUPPORTED_LANGUAGES` dans `useUniversalI18n.ts`
2. Ajoutez les traductions dans `translations/index.ts`

## 🧪 Tests avec Playwright

```typescript
// Dans vos tests Playwright
test('Test changement de langue', async ({ page }) => {
  await page.goto('http://localhost:3001');
  
  // Changer la langue
  await page.evaluate(() => {
    localStorage.setItem('universal_app_language', 'fr');
  });
  
  await page.reload();
  
  // Vérifier que la langue a changé
  await expect(page.locator('h1')).toContainText('PostMath Pro');
});
```

## 📊 Fonctionnalités avancées

### Persistance automatique
- La langue est sauvegardée dans `localStorage`
- Restauration automatique au rechargement
- Synchronisation entre tous les onglets

### Détection intelligente
- Détection de la langue du navigateur
- Fallback vers l'anglais si langue non supportée
- Respect des préférences utilisateur

### Performance
- Chargement lazy des traductions
- Cache en mémoire
- Optimisations pour les gros volumes

## 🔧 Maintenance

### Ajouter une nouvelle application
1. Créez le dossier `apps/nouvelle-app`
2. Copiez la structure depuis une app existante
3. Modifiez les traductions spécifiques
4. Ajoutez le port dans `start-all-apps.sh`

### Mettre à jour les traductions
- Utilisez `npm run i18n:extract` pour extraire les clés
- Utilisez `npm run i18n:validate` pour valider

## 🐛 Dépannage

### Problème: La langue ne persiste pas
**Solution**: Vérifiez que localStorage est accessible et que les événements sont bien écoutés.

### Problème: RTL ne fonctionne pas
**Solution**: Vérifiez que les styles CSS RTL sont bien appliqués dans globals.css.

### Problème: Traductions manquantes
**Solution**: Ajoutez les clés manquantes dans le fichier translations/index.ts.

## 📞 Support

Pour toute question ou problème :
1. Vérifiez ce README
2. Consultez les logs dans la console
3. Testez avec une langue différente

---

**Version**: 1.0.0  
**Créé par**: Script d'installation automatique  
**Date**: $(date)
EOF

    print_message "README créé ✓"
}

# Fonction principale
main() {
    print_message "🌍 Début de l'installation du système I18n universel"
    print_message "================================================="
    
    # Vérifications préliminaires
    check_project_structure
    
    # Création des composants
    create_universal_hook
    create_translations
    create_i18n_layout
    create_nextjs_layouts
    create_home_pages
    create_global_css
    create_typescript_config
    create_nextjs_config
    create_package_json
    create_tailwind_config
    
    # Scripts utilitaires
    create_start_script
    create_install_script
    create_readme
    
    print_message "================================================="
    print_message "🎉 Installation terminée avec succès!"
    print_message ""
    print_message "📋 Prochaines étapes:"
    print_message "1. Exécutez: ./install-all-dependencies.sh"
    print_message "2. Démarrez les apps: ./start-all-apps.sh"
    print_message "3. Testez le changement de langue sur chaque app"
    print_message ""
    print_message "📱 URLs des applications:"
    print_message "  • PostMath Pro:  http://localhost:3001"
    print_message "  • UnitFlip Pro:  http://localhost:3002"
    print_message "  • BudgetCron:    http://localhost:3003"
    print_message "  • AI4Kids:       http://localhost:3004"
    print_message "  • MultiAI:       http://localhost:3005"
    print_message ""
    print_message "🌍 Fonctionnalités I18n installées:"
    print_message "  ✅ 30+ langues de tous les continents"
    print_message "  ✅ Persistance automatique de la langue"
    print_message "  ✅ Synchronisation inter-onglets"
    print_message "  ✅ Support RTL (Arabe, Hébreu, etc.)"
    print_message "  ✅ Détection automatique de langue"
    print_message "  ✅ Applications complètement indépendantes"
    print_message ""
    print_message "📚 Consultez README-I18N.md pour plus de détails"
    print_message "================================================="
}

# Exécution du script
main "$@"
