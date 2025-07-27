'use client';

import React, { useState, useRef, useEffect } from 'react';
import { X, Star, Globe, Users, BookOpen, Trophy, Zap } from 'lucide-react';

// Types locaux
interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  rtl?: boolean;
  continent: string;
  currency: string;
  dateFormat: string;
}

interface PricingPlan {
  id: string;
  name: string;
  basePrice: number;
  features: string[];
  popular?: boolean;
}

// Données universelles mises à jour
const UNIVERSAL_LANGUAGES: Language[] = [
  // Europe
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', currency: 'GBP', dateFormat: 'DD/MM/YYYY' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', currency: 'EUR', dateFormat: 'DD.MM.YYYY' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', currency: 'EUR', dateFormat: 'DD-MM-YYYY' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe', currency: 'SEK', dateFormat: 'YYYY-MM-DD' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', currency: 'RUB', dateFormat: 'DD.MM.YYYY' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', currency: 'PLN', dateFormat: 'DD.MM.YYYY' },
  
  // Amérique du Nord
  { code: 'en-US', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', continent: 'North America', currency: 'USD', dateFormat: 'MM/DD/YYYY' },
  { code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-CA', name: 'Français (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-MX', name: 'Español (México)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'North America', currency: 'MXN', dateFormat: 'DD/MM/YYYY' },
  
  // Amérique du Sud
  { code: 'pt-BR', name: 'Português (Brasil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'South America', currency: 'BRL', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-AR', name: 'Español (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'South America', currency: 'ARS', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-CL', name: 'Español (Chile)', nativeName: 'Español (Chile)', flag: '🇨🇱', continent: 'South America', currency: 'CLP', dateFormat: 'DD-MM-YYYY' },
  { code: 'es-CO', name: 'Español (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', continent: 'South America', currency: 'COP', dateFormat: 'DD/MM/YYYY' },
  
  // Asie - Sous-continent indien (NOUVEAU : Ourdou ajouté, Hindi conservé)
  { code: 'hi', name: 'हिन्दी (Inde)', nativeName: 'हिन्दी', flag: '🇮🇳', continent: 'Asia', currency: 'INR', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-IN', name: 'English (India)', nativeName: 'English (India)', flag: '🇮🇳', continent: 'Asia', currency: 'INR', dateFormat: 'DD/MM/YYYY' },
  { code: 'ur', name: 'اردو (Pakistan)', nativeName: 'اردو', flag: '🇵🇰', continent: 'Asia', currency: 'PKR', dateFormat: 'DD/MM/YYYY', rtl: true },
  
  // Asie - Extrême-Orient
  { code: 'zh-CN', name: '中文 (简体)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', currency: 'CNY', dateFormat: 'YYYY/MM/DD' },
  { code: 'zh-TW', name: '中文 (繁體)', nativeName: '中文 (繁體)', flag: '🇹🇼', continent: 'Asia', currency: 'TWD', dateFormat: 'YYYY/MM/DD' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', currency: 'JPY', dateFormat: 'YYYY/MM/DD' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', currency: 'KRW', dateFormat: 'YYYY.MM.DD' },
  
  // Asie - Sud-Est
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', currency: 'THB', dateFormat: 'DD/MM/YYYY' },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', currency: 'VND', dateFormat: 'DD/MM/YYYY' },
  { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', currency: 'IDR', dateFormat: 'DD/MM/YYYY' },
  { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asia', currency: 'MYR', dateFormat: 'DD/MM/YYYY' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', continent: 'Asia', currency: 'PHP', dateFormat: 'MM/DD/YYYY' },
  
  // Moyen-Orient (HÉBREU SUPPRIMÉ)
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', currency: 'SAR', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-AE', name: 'العربية (الإمارات)', nativeName: 'العربية (الإمارات)', flag: '🇦🇪', continent: 'Asia', currency: 'AED', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-EG', name: 'العربية (مصر)', nativeName: 'العربية (مصر)', flag: '🇪🇬', continent: 'Africa', currency: 'EGP', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', currency: 'IRR', dateFormat: 'YYYY/MM/DD', rtl: true },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', currency: 'TRY', dateFormat: 'DD.MM.YYYY' },
  
  // Afrique
  { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', currency: 'KES', dateFormat: 'DD/MM/YYYY' },
  { code: 'am', name: 'አማርኛ', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', currency: 'ETB', dateFormat: 'DD/MM/YYYY' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', continent: 'Africa', currency: 'NGN', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-MA', name: 'Français (Maroc)', nativeName: 'Français (Maroc)', flag: '🇲🇦', continent: 'Africa', currency: 'MAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', currency: 'ZAR', dateFormat: 'DD/MM/YYYY' },
  
  // Océanie
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', currency: 'AUD', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-NZ', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', continent: 'Oceania', currency: 'NZD', dateFormat: 'DD/MM/YYYY' },
];

const CONTINENTS = [
  { code: 'all', name: 'Tous', emoji: '🌍' },
  { code: 'europe', name: 'Europe', emoji: '🇪🇺' },
  { code: 'north-america', name: 'North America', emoji: '🌎' },
  { code: 'south-america', name: 'South America', emoji: '🌎' },
  { code: 'asia', name: 'Asia', emoji: '🌏' },
  { code: 'africa', name: 'Africa', emoji: '🌍' },
  { code: 'oceania', name: 'Oceania', emoji: '🇦🇺' },
];

const FEATURES = [
  {
    id: 'premium-features',
    title: 'Fonctionnalités premium',
    description: 'Plus de 10 000 exercices personnalisés',
    icon: <Trophy className="w-8 h-8" />,
    gradient: 'from-yellow-400 to-orange-500',
    stats: '10 000+ exercices'
  },
  {
    id: 'progress-tracking',  
    title: 'Suivi détaillé des progrès',
    description: 'Rapports hebdomadaires parents',
    icon: <BookOpen className="w-8 h-8" />,
    gradient: 'from-green-400 to-blue-500',
    stats: 'Rapports hebdomadaires'
  },
  {
    id: 'interactive-games',
    title: 'Jeux interactifs',
    description: '50+ mini-jeux disponibles',
    icon: <Zap className="w-8 h-8" />,
    gradient: 'from-purple-400 to-pink-500',
    stats: '50+ mini-jeux'
  }
];

const BASE_PRICING_PLANS: PricingPlan[] = [
  {
    id: 'famille',
    name: 'Famille',
    basePrice: 9.99,
    features: ['3 enfants max', 'Suivi basique', 'Support email']
  },
  {
    id: 'premium',
    name: 'Premium',
    basePrice: 19.99,
    features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
    popular: true
  },
  {
    id: 'ecole',
    name: 'École',
    basePrice: 29.99,
    features: ['Classes multiples', 'Dashboard enseignant', 'API intégration']
  }
];

// Utilitaires intégrés
const getLanguageByCode = (code: string): Language => {
  return UNIVERSAL_LANGUAGES.find(lang => lang.code === code) || UNIVERSAL_LANGUAGES[0];
};

const detectUserLanguage = (): string => {
  if (typeof window === 'undefined') return 'fr';
  
  const browserLang = navigator.language;
  const supportedLang = UNIVERSAL_LANGUAGES.find(lang => 
    lang.code === browserLang || lang.code.startsWith(browserLang.split('-')[0])
  );
  
  return supportedLang?.code || 'fr';
};

const formatPrice = (price: number, currencyCode: string, locale: string): string => {
  try {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currencyCode,
      minimumFractionDigits: 2,
    }).format(price);
  } catch (error) {
    // Fallback pour devises non supportées
    const symbols: Record<string, string> = {
      'USD': '$', 'EUR': '€', 'GBP': '£', 'JPY': '¥', 'CNY': '¥', 'INR': '₹',
      'BRL': 'R$', 'CAD': 'C$', 'AUD': 'A$', 'SAR': '﷼', 'AED': 'د.إ',
      'EGP': 'E£', 'ZAR': 'R', 'NGN': '₦', 'KES': 'KSh', 'MAD': 'DH',
      'PKR': '₨', 'IRR': '﷼', 'TRY': '₺'
    };
    const symbol = symbols[currencyCode] || currencyCode;
    return `${symbol}${price.toFixed(2)}`;
  }
};

const convertPriceByRegion = (basePrice: number, targetCurrency: string): number => {
  // Conversion et ajustement par pouvoir d'achat
  const conversionRates: Record<string, number> = {
    'USD': 1.0, 'EUR': 0.85, 'GBP': 0.73, 'JPY': 110, 'CNY': 6.5,
    'INR': 75, 'BRL': 5.2, 'CAD': 1.25, 'AUD': 1.35, 'SAR': 3.75,
    'AED': 3.67, 'EGP': 15.7, 'ZAR': 14.5, 'NGN': 411, 'KES': 108,
    'MAD': 8.8, 'MXN': 20.1, 'ARS': 98.5, 'CLP': 712, 'COP': 3654,
    'PKR': 220, 'IRR': 42000, 'TRY': 8.5
  };
  
  const powerPurchasingAdjustment: Record<string, number> = {
    'INR': 0.3, 'NGN': 0.25, 'KES': 0.3, 'EGP': 0.4, 'BRL': 0.6,
    'ARS': 0.4, 'CLP': 0.7, 'COP': 0.5, 'MAD': 0.5, 'PKR': 0.25
  };
  
  const rate = conversionRates[targetCurrency] || 1.0;
  const adjustment = powerPurchasingAdjustment[targetCurrency] || 1.0;
  
  return Math.round((basePrice * rate * adjustment) * 100) / 100;
};

// Composant RegionSelector intégré
const RegionSelector: React.FC<{
  selectedLanguage: Language;
  onLanguageChange: (language: Language) => void;
  className?: string;
}> = ({ selectedLanguage, onLanguageChange, className = '' }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedContinent, setSelectedContinent] = useState<string>('all');
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang => {
    const matchesSearch = 
      lang.name.toLowerCase().includes(search.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(search.toLowerCase()) ||
      lang.continent.toLowerCase().includes(search.toLowerCase());
    
    const matchesContinent = selectedContinent === 'all' || 
      lang.continent.toLowerCase() === selectedContinent.replace('-', ' ').toLowerCase();
    
    return matchesSearch && matchesContinent;
  });

  const handleLanguageSelect = (language: Language) => {
    onLanguageChange(language);
    setIsOpen(false);
    setSearch('');
  };

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-4 py-2 rounded-lg border border-gray-200 hover:border-gray-300 bg-white transition-all duration-200 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        aria-label="Sélectionner une région et langue"
      >
        <span className="text-xl">{selectedLanguage.flag}</span>
        <div className="text-left">
          <div className="font-medium text-gray-700 text-sm">{selectedLanguage.name}</div>
          <div className="text-xs text-gray-500">{selectedLanguage.continent}</div>
        </div>
        <svg className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-96 bg-white rounded-xl shadow-2xl border border-gray-200 z-50 max-h-[500px] overflow-hidden">
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100">
            <div className="flex items-center space-x-2 mb-3">
              <Globe className="w-5 h-5 text-blue-500" />
              <h3 className="font-semibold text-gray-900">Choisir votre région</h3>
            </div>
            <input
              type="text"
              placeholder="Rechercher une langue ou un pays..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
              autoFocus
            />
          </div>

          {/* Filtres par continent */}
          <div className="p-3 border-b border-gray-100">
            <div className="flex flex-wrap gap-2">
              {CONTINENTS.map((continent) => (
                <button
                  key={continent.code}
                  onClick={() => setSelectedContinent(continent.code)}
                  className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${
                    selectedContinent === continent.code
                      ? 'bg-blue-100 text-blue-700' 
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {continent.emoji} {continent.name}
                </button>
              ))}
            </div>
          </div>

          {/* Liste des langues */}
          <div className="max-h-80 overflow-y-auto">
            {filteredLanguages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left ${
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
              {UNIVERSAL_LANGUAGES.length} langues • {CONTINENTS.length - 1} continents
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default function UniversalHomePage() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(() => {
    if (typeof window !== 'undefined') {
      const detectedLang = detectUserLanguage();
      return getLanguageByCode(detectedLang);
    }
    return UNIVERSAL_LANGUAGES[0];
  });
  
  const [isPricingModalOpen, setIsPricingModalOpen] = useState<boolean>(false);
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');

  const pricingModalRef = useRef<HTMLDivElement>(null);

  // Fermer le modal en cliquant à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (pricingModalRef.current && !pricingModalRef.current.contains(event.target as Node)) {
        setIsPricingModalOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Gestion du scroll pour le modal
  useEffect(() => {
    if (isPricingModalOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isPricingModalOpen]);

  const handleLanguageChange = (language: Language) => {
    setSelectedLanguage(language);
    console.log('Changement de région vers:', language.code, language.continent);
  };

  const handlePlanSelect = (planId: string, period: string) => {
    console.log('Plan sélectionné:', planId, 'Période:', period, 'Région:', selectedLanguage.code);
    setIsPricingModalOpen(false);
  };

  // Calculer les prix selon la région
  const getLocalizedPricing = () => {
    const discounts = {
      monthly: 1.0,
      quarterly: 0.9,  // -10%
      annual: 0.7      // -30%
    };

    return BASE_PRICING_PLANS.map(plan => {
      const discountedPrice = plan.basePrice * discounts[selectedPeriod];
      const localPrice = convertPriceByRegion(discountedPrice, selectedLanguage.currency);
      
      return {
        ...plan,
        price: localPrice,
        originalPrice: selectedPeriod !== 'monthly' ? convertPriceByRegion(plan.basePrice, selectedLanguage.currency) : undefined,
        formattedPrice: formatPrice(localPrice, selectedLanguage.currency, selectedLanguage.code)
      };
    });
  };

  const localizedPlans = getLocalizedPricing();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50" dir={selectedLanguage.rtl ? 'rtl' : 'ltr'}>
      {/* Header universel */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-lg border-b border-gray-200/50 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            
            {/* Logo avec animation */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-110 hover:rotate-3 transition-all duration-300 cursor-pointer">
                <span className="text-white font-bold text-xl">M4C</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math pour enfants</h1>
                <p className="text-sm text-gray-600">L'app n°1 mondiale</p>
              </div>
            </div>

            {/* Statistiques mondiales */}
            <div className="hidden md:flex items-center space-x-6">
              <div className="flex items-center space-x-2 text-green-600">
                <Users className="w-4 h-4" />
                <span className="font-semibold">100k+ familles</span>
              </div>
              <div className="flex items-center space-x-2 text-blue-600">
                <Globe className="w-4 h-4" />
                <span className="font-semibold">{UNIVERSAL_LANGUAGES.length}+ langues</span>
              </div>
              <div className="flex items-center space-x-2 text-purple-600">
                <span className="text-xl">🌍</span>
                <span className="font-semibold">6 continents</span>
              </div>
            </div>

            {/* Sélecteur de région universel */}
            <RegionSelector
              selectedLanguage={selectedLanguage}
              onLanguageChange={handleLanguageChange}
            />
          </div>
        </div>
      </header>

      {/* Section Hero universelle */}
      <main className="relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          
          {/* Badge de confiance mondial */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center space-x-2 bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
              <Star className="w-4 h-4 text-green-600" />
              <span>Plus de 100k familles dans {UNIVERSAL_LANGUAGES.length} pays nous font confiance !</span>
            </div>
          </div>

          {/* Titre principal avec détection de langue RTL */}
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
              Apprends les maths en
              <br />
              t'amusant !
            </h1>
            <p className="text-xl md:text-2xl text-gray-600 max-w-3xl mx-auto mb-8 leading-relaxed">
              Rejoins plus de 100 000 enfants de {UNIVERSAL_LANGUAGES.length} pays qui progressent 
              chaque jour avec des jeux interactifs, des défis passionnants et un suivi personnalisé.
            </p>
            
            {/* Indicateur de région */}
            <div className="flex items-center justify-center space-x-2 text-sm text-gray-500 mb-8">
              <span>{selectedLanguage.flag}</span>
              <span>Disponible en {selectedLanguage.nativeName}</span>
              <span>•</span>
              <span>Prix en {selectedLanguage.currency}</span>
              <span>•</span>
              <span>{selectedLanguage.continent}</span>
            </div>
          </div>

          {/* Boutons d'action localisés */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <button className="group bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl">
              <span className="mr-2">🎁</span>
              Commencer gratuitement
              <div className="text-sm opacity-90 group-hover:opacity-100">Essai gratuit 14 jours</div>
            </button>
            <button
              onClick={() => setIsPricingModalOpen(true)}
              className="group bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg border-2 border-blue-600 hover:bg-blue-50 transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl"
            >
              <span className="mr-2">💰</span>
              Voir les prix
              <div className="text-sm opacity-75 group-hover:opacity-100">
                À partir de {formatPrice(convertPriceByRegion(6.99, selectedLanguage.currency), selectedLanguage.currency, selectedLanguage.code)}/mois
              </div>
            </button>
          </div>

          {/* Section des fonctionnalités */}
          <div className="grid md:grid-cols-3 gap-8 mb-16">
            {FEATURES.map((feature) => (
              <div
                key={feature.id}
                className="group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-gray-100"
              >
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-r ${feature.gradient} flex items-center justify-center mb-6 text-white group-hover:scale-110 transition-transform duration-300`}>
                  {feature.icon}
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">{feature.title}</h3>
                <p className="text-gray-600 mb-4">{feature.description}</p>
                {feature.stats && (
                  <div className="text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg px-3 py-1 inline-block">
                    {feature.stats}
                  </div>
                )}
              </div>
            ))}
          </div>

          {/* Section statistiques mondiales */}
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-8 md:p-12 text-white text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-8">
              Disponible partout dans le monde
            </h2>
            
            {/* Statistiques par continent */}
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-6 mb-12">
              {[
                { emoji: '🇪🇺', name: 'Europe', count: UNIVERSAL_LANGUAGES.filter(l => l.continent === 'Europe').length },
                { emoji: '🌎', name: 'Amériques', count: UNIVERSAL_LANGUAGES.filter(l => l.continent.includes('America')).length },
                { emoji: '🌏', name: 'Asie', count: UNIVERSAL_LANGUAGES.filter(l => l.continent === 'Asia').length },
                { emoji: '🌍', name: 'Afrique', count: UNIVERSAL_LANGUAGES.filter(l => l.continent === 'Africa').length },
                { emoji: '🇦🇺', name: 'Océanie', count: UNIVERSAL_LANGUAGES.filter(l => l.continent === 'Oceania').length },
                { emoji: '🌐', name: 'Total', count: UNIVERSAL_LANGUAGES.length }
              ].map((region, index) => (
                <div key={index} className="text-center">
                  <div className="text-3xl mb-2">{region.emoji}</div>
                  <div className="text-2xl font-bold mb-1">{region.count}</div>
                  <div className="text-sm text-blue-100">{region.name}</div>
                </div>
              ))}
            </div>
            
            <div className="grid grid-cols-3 gap-8 pt-8 border-t border-blue-500/30">
              {[
                { value: '100k+', label: 'Familles actives', desc: 'Dans le monde entier' },
                { value: '98%', label: 'Satisfaction', desc: 'Toutes régions confondues' },
                { value: `${UNIVERSAL_LANGUAGES.length}`, label: 'Langues supportées', desc: 'Sur 6 continents' }
              ].map((stat, index) => (
                <div key={index} className="text-center">
                  <div className="text-3xl md:text-4xl font-bold mb-2">{stat.value}</div>
                  <div className="text-lg font-semibold mb-1">{stat.label}</div>
                  <div className="text-sm text-blue-100">{stat.desc}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>

      {/* Modal de pricing universel */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 overflow-y-auto">
          <div 
            ref={pricingModalRef}
            className="bg-white rounded-2xl max-w-5xl w-full max-h-[90vh] overflow-y-auto my-8"
          >
            {/* Header du modal avec info région */}
            <div className="sticky top-0 bg-white p-6 border-b border-gray-200 flex justify-between items-center rounded-t-2xl">
              <div>
                <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Choisissez votre plan</h2>
                <p className="text-gray-600 mt-1">
                  Prix adaptés pour {selectedLanguage.continent} • Essai gratuit de 14 jours
                </p>
                <div className="flex items-center space-x-2 mt-2 text-sm text-gray-500">
                  <span>{selectedLanguage.flag}</span>
                  <span>{selectedLanguage.nativeName}</span>
                  <span>•</span>
                  <span>Facturé en {selectedLanguage.currency}</span>
                </div>
              </div>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 hover:bg-gray-200 transition-colors text-gray-500 hover:text-gray-700"
                aria-label="Fermer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 rounded-xl p-1 flex">
                  {[
                    { key: 'monthly' as const, label: 'Mensuel' },
                    { key: 'quarterly' as const, label: 'Trimestriel', badge: '10% de réduction' },
                    { key: 'annual' as const, label: 'Annuel', badge: '30% de réduction' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key)}
                      className={`px-6 py-3 rounded-lg font-medium transition-all relative ${
                        selectedPeriod === period.key
                          ? 'bg-white text-blue-600 shadow-md'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.badge && (
                        <div className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full whitespace-nowrap">
                          {period.badge}
                        </div>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Grille des plans localisés */}
              <div className="grid md:grid-cols-3 gap-6">
                {localizedPlans.map((plan: any) => (
                  <div
                    key={plan.id}
                    className={`relative bg-white rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-lg ${
                      plan.popular 
                        ? 'border-purple-500 shadow-lg' 
                        : 'border-gray-200 hover:border-gray-300'
                    }`}
                  >
                    {plan.popular && (
                      <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                        <div className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                          Le plus populaire
                        </div>
                      </div>
                    )}

                    <div className="text-center mb-6">
                      <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                      <div className="flex items-center justify-center space-x-2">
                        <span className="text-3xl font-bold text-gray-900">{plan.formattedPrice}</span>
                        <span className="text-gray-500">/mois</span>
                      </div>
                      {plan.originalPrice && (
                        <div className="text-sm text-gray-500 line-through">
                          {formatPrice(plan.originalPrice, selectedLanguage.currency, selectedLanguage.code)}/mois
                        </div>
                      )}
                    </div>

                    <ul className="space-y-3 mb-6">
                      {plan.features.map((feature: string, index: number) => (
                        <li key={index} className="flex items-center space-x-3">
                          <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center">
                            <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                          </div>
                          <span className="text-gray-700">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button
                      onClick={() => handlePlanSelect(plan.id, selectedPeriod)}
                      className={`w-full py-3 px-4 rounded-xl font-semibold transition-all duration-300 hover:scale-105 ${
                        plan.popular
                          ? 'bg-gradient-to-r from-purple-500 to-purple-600 text-white hover:from-purple-600 hover:to-purple-700 shadow-lg'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {plan.popular ? 'Commencer l\'essai gratuit' : 'Choisir ce plan'}
                    </button>
                  </div>
                ))}
              </div>

              {/* Footer du modal avec info de localisation */}
              <div className="text-center mt-8 pt-6 border-t border-gray-200">
                <p className="text-sm text-gray-600 mb-2">
                  ✅ Essai gratuit de 14 jours • ✅ Annulation à tout moment • ✅ Support en {selectedLanguage.nativeName}
                </p>
                <p className="text-xs text-gray-500">
                  Prix adaptés pour {selectedLanguage.continent}. Facturé en {selectedLanguage.currency}. TVA incluse si applicable.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
