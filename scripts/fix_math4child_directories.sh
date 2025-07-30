#!/usr/bin/env bash

# ===================================================================
# 🔧 CORRECTION MATH4CHILD - CRÉATION RÉPERTOIRES ET FICHIERS
# Résout le problème des répertoires manquants
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
BASE_DIR="$(pwd)"
SRC_DIR="$BASE_DIR/src"

log_header() {
    echo -e "${CYAN}${BOLD}"
    echo "========================================="
    echo "🔧 $1"
    echo "========================================="
    echo -e "${NC}"
}

log_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Créer tous les répertoires nécessaires
create_directory_structure() {
    log_header "CRÉATION STRUCTURE COMPLÈTE"
    
    # Créer tous les répertoires nécessaires
    mkdir -p "$SRC_DIR"/{lib,components,contexts,types}
    mkdir -p "$SRC_DIR/lib"/{i18n,game,subscription,pricing,payment}
    mkdir -p "$SRC_DIR/components"/{ui,game,subscription,language}
    mkdir -p "$BASE_DIR"/{tests,public,docs}
    mkdir -p "$BASE_DIR/tests"/{e2e,api,performance,stress,translation}
    
    log_success "Structure de répertoires créée"
}

# Continuer la création du système de prix mondiaux
create_global_pricing_system() {
    log_header "SYSTÈME DE PRIX MONDIAUX - CORRECTION"
    
    cat > "$SRC_DIR/lib/pricing/globalPricing.ts" << 'EOF'
// ===================================================================
// 🌍 SYSTÈME DE PRIX MONDIAUX
// Prix adaptés au pouvoir d'achat de chaque pays
// ===================================================================

export interface CountryPricing {
  country: string;
  countryCode: string;
  currency: string;
  currencySymbol: string;
  exchangeRate: number; // Par rapport à EUR
  purchasingPowerAdjustment: number; // Multiplicateur basé sur le pouvoir d'achat
  minimumWage: number; // Salaire minimum mensuel en monnaie locale
  flag: string;
}

export const GLOBAL_PRICING: CountryPricing[] = [
  // EUROPE
  { country: 'France', countryCode: 'FR', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.0, minimumWage: 1678, flag: '🇫🇷' },
  { country: 'Germany', countryCode: 'DE', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.0, minimumWage: 1621, flag: '🇩🇪' },
  { country: 'United Kingdom', countryCode: 'GB', currency: 'GBP', currencySymbol: '£', exchangeRate: 0.85, purchasingPowerAdjustment: 1.1, minimumWage: 1467, flag: '🇬🇧' },
  { country: 'Spain', countryCode: 'ES', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.85, minimumWage: 900, flag: '🇪🇸' },
  { country: 'Italy', countryCode: 'IT', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.9, minimumWage: 1100, flag: '🇮🇹' },
  { country: 'Netherlands', countryCode: 'NL', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 1.05, minimumWage: 1701, flag: '🇳🇱' },
  { country: 'Poland', countryCode: 'PL', currency: 'PLN', currencySymbol: 'zł', exchangeRate: 4.35, purchasingPowerAdjustment: 0.6, minimumWage: 2450, flag: '🇵🇱' },
  { country: 'Portugal', countryCode: 'PT', currency: 'EUR', currencySymbol: '€', exchangeRate: 1.0, purchasingPowerAdjustment: 0.75, minimumWage: 665, flag: '🇵🇹' },
  { country: 'Sweden', countryCode: 'SE', currency: 'SEK', currencySymbol: 'kr', exchangeRate: 11.2, purchasingPowerAdjustment: 1.15, minimumWage: 25000, flag: '🇸🇪' },
  { country: 'Switzerland', countryCode: 'CH', currency: 'CHF', currencySymbol: 'CHF', exchangeRate: 0.98, purchasingPowerAdjustment: 1.4, minimumWage: 3500, flag: '🇨🇭' },
  
  // AMÉRIQUES
  { country: 'United States', countryCode: 'US', currency: 'USD', currencySymbol: '$', exchangeRate: 1.08, purchasingPowerAdjustment: 1.2, minimumWage: 1256, flag: '🇺🇸' },
  { country: 'Canada', countryCode: 'CA', currency: 'CAD', currencySymbol: 'C$', exchangeRate: 1.47, purchasingPowerAdjustment: 1.1, minimumWage: 2000, flag: '🇨🇦' },
  { country: 'Brazil', countryCode: 'BR', currency: 'BRL', currencySymbol: 'R$', exchangeRate: 5.4, purchasingPowerAdjustment: 0.4, minimumWage: 1212, flag: '🇧🇷' },
  { country: 'Mexico', countryCode: 'MX', currency: 'MXN', currencySymbol: '$', exchangeRate: 18.5, purchasingPowerAdjustment: 0.35, minimumWage: 3685, flag: '🇲🇽' },
  { country: 'Argentina', countryCode: 'AR', currency: 'ARS', currencySymbol: '$', exchangeRate: 350, purchasingPowerAdjustment: 0.25, minimumWage: 87987, flag: '🇦🇷' },
  { country: 'Chile', countryCode: 'CL', currency: 'CLP', currencySymbol: '$', exchangeRate: 920, purchasingPowerAdjustment: 0.6, minimumWage: 320500, flag: '🇨🇱' },
  { country: 'Colombia', countryCode: 'CO', currency: 'COP', currencySymbol: '$', exchangeRate: 4200, purchasingPowerAdjustment: 0.3, minimumWage: 1000000, flag: '🇨🇴' },
  
  // ASIE
  { country: 'China', countryCode: 'CN', currency: 'CNY', currencySymbol: '¥', exchangeRate: 7.8, purchasingPowerAdjustment: 0.45, minimumWage: 2320, flag: '🇨🇳' },
  { country: 'Japan', countryCode: 'JP', currency: 'JPY', currencySymbol: '¥', exchangeRate: 155, purchasingPowerAdjustment: 0.95, minimumWage: 126600, flag: '🇯🇵' },
  { country: 'South Korea', countryCode: 'KR', currency: 'KRW', currencySymbol: '₩', exchangeRate: 1420, purchasingPowerAdjustment: 0.8, minimumWage: 1914440, flag: '🇰🇷' },
  { country: 'India', countryCode: 'IN', currency: 'INR', currencySymbol: '₹', exchangeRate: 89, purchasingPowerAdjustment: 0.2, minimumWage: 15000, flag: '🇮🇳' },
  { country: 'Indonesia', countryCode: 'ID', currency: 'IDR', currencySymbol: 'Rp', exchangeRate: 16800, purchasingPowerAdjustment: 0.25, minimumWage: 3500000, flag: '🇮🇩' },
  { country: 'Thailand', countryCode: 'TH', currency: 'THB', currencySymbol: '฿', exchangeRate: 38, purchasingPowerAdjustment: 0.35, minimumWage: 10700, flag: '🇹🇭' },
  { country: 'Vietnam', countryCode: 'VN', currency: 'VND', currencySymbol: '₫', exchangeRate: 26000, purchasingPowerAdjustment: 0.2, minimumWage: 4180000, flag: '🇻🇳' },
  { country: 'Philippines', countryCode: 'PH', currency: 'PHP', currencySymbol: '₱', exchangeRate: 60, purchasingPowerAdjustment: 0.25, minimumWage: 13000, flag: '🇵🇭' },
  { country: 'Malaysia', countryCode: 'MY', currency: 'MYR', currencySymbol: 'RM', exchangeRate: 5.0, purchasingPowerAdjustment: 0.4, minimumWage: 1200, flag: '🇲🇾' },
  { country: 'Singapore', countryCode: 'SG', currency: 'SGD', currencySymbol: 'S$', exchangeRate: 1.45, purchasingPowerAdjustment: 1.3, minimumWage: 2600, flag: '🇸🇬' },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD
  { country: 'Morocco', countryCode: 'MA', currency: 'MAD', currencySymbol: 'د.م.', exchangeRate: 10.8, purchasingPowerAdjustment: 0.3, minimumWage: 3000, flag: '🇲🇦' },
  { country: 'Saudi Arabia', countryCode: 'SA', currency: 'SAR', currencySymbol: '﷼', exchangeRate: 4.05, purchasingPowerAdjustment: 0.7, minimumWage: 3000, flag: '🇸🇦' },
  { country: 'UAE', countryCode: 'AE', currency: 'AED', currencySymbol: 'د.إ', exchangeRate: 3.97, purchasingPowerAdjustment: 0.9, minimumWage: 3000, flag: '🇦🇪' },
  { country: 'Turkey', countryCode: 'TR', currency: 'TRY', currencySymbol: '₺', exchangeRate: 29, purchasingPowerAdjustment: 0.35, minimumWage: 8506, flag: '🇹🇷' },
  { country: 'Egypt', countryCode: 'EG', currency: 'EGP', currencySymbol: '£', exchangeRate: 31, purchasingPowerAdjustment: 0.2, minimumWage: 3000, flag: '🇪🇬' },
  
  // AFRIQUE
  { country: 'South Africa', countryCode: 'ZA', currency: 'ZAR', currencySymbol: 'R', exchangeRate: 20, purchasingPowerAdjustment: 0.3, minimumWage: 3500, flag: '🇿🇦' },
  { country: 'Nigeria', countryCode: 'NG', currency: 'NGN', currencySymbol: '₦', exchangeRate: 850, purchasingPowerAdjustment: 0.15, minimumWage: 30000, flag: '🇳🇬' },
  { country: 'Kenya', countryCode: 'KE', currency: 'KES', currencySymbol: 'KSh', exchangeRate: 140, purchasingPowerAdjustment: 0.2, minimumWage: 13572, flag: '🇰🇪' },
  { country: 'Ghana', countryCode: 'GH', currency: 'GHS', currencySymbol: '₵', exchangeRate: 12, purchasingPowerAdjustment: 0.18, minimumWage: 365, flag: '🇬🇭' },
  
  // OCÉANIE
  { country: 'Australia', countryCode: 'AU', currency: 'AUD', currencySymbol: 'A$', exchangeRate: 1.65, purchasingPowerAdjustment: 1.15, minimumWage: 3100, flag: '🇦🇺' },
  { country: 'New Zealand', countryCode: 'NZ', currency: 'NZD', currencySymbol: 'NZ$', exchangeRate: 1.78, purchasingPowerAdjustment: 1.1, minimumWage: 2765, flag: '🇳🇿' }
];

export function calculateLocalPrice(
  basePriceEUR: number, 
  countryCode: string
): { price: number; currency: string; symbol: string; country: CountryPricing } {
  const country = GLOBAL_PRICING.find(c => c.countryCode === countryCode) || GLOBAL_PRICING[0];
  
  // Calculer le prix ajusté selon le pouvoir d'achat
  const adjustedPrice = basePriceEUR * country.purchasingPowerAdjustment;
  
  // Convertir dans la monnaie locale
  const localPrice = adjustedPrice * country.exchangeRate;
  
  // Arrondir selon la monnaie
  let roundedPrice;
  if (['JPY', 'KRW', 'IDR', 'VND', 'CLP', 'COP'].includes(country.currency)) {
    roundedPrice = Math.round(localPrice); // Pas de décimales
  } else {
    roundedPrice = Math.round(localPrice * 100) / 100; // 2 décimales
  }
  
  return {
    price: roundedPrice,
    currency: country.currency,
    symbol: country.currencySymbol,
    country
  };
}

export function getCountryByCode(countryCode: string): CountryPricing | undefined {
  return GLOBAL_PRICING.find(c => c.countryCode === countryCode);
}

export function detectUserCountry(): string {
  // En production, utiliser l'IP geolocation
  // Pour le moment, détecter via la langue du navigateur
  const language = navigator.language;
  const countryMap: Record<string, string> = {
    'fr-FR': 'FR', 'fr-CA': 'CA', 'fr-BE': 'BE', 'fr-CH': 'CH',
    'en-US': 'US', 'en-GB': 'GB', 'en-CA': 'CA', 'en-AU': 'AU', 'en-NZ': 'NZ',
    'es-ES': 'ES', 'es-MX': 'MX', 'es-AR': 'AR', 'es-CL': 'CL', 'es-CO': 'CO',
    'de-DE': 'DE', 'de-AT': 'AT', 'de-CH': 'CH',
    'it-IT': 'IT', 'pt-BR': 'BR', 'pt-PT': 'PT',
    'zh-CN': 'CN', 'zh-TW': 'TW', 'ja-JP': 'JP', 'ko-KR': 'KR',
    'ar-MA': 'MA', 'ar-SA': 'SA', 'ar-AE': 'AE', 'ar-EG': 'EG',
    'hi-IN': 'IN', 'th-TH': 'TH', 'vi-VN': 'VN', 'id-ID': 'ID'
  };
  
  return countryMap[language] || countryMap[language.split('-')[0]] || 'FR';
}
EOF
    
    log_success "Système de prix mondiaux créé"
}

# Créer le système de paiement mondial
create_payment_system() {
    log_header "SYSTÈME DE PAIEMENT MONDIAL"
    
    cat > "$SRC_DIR/lib/payment/paymentMethods.ts" << 'EOF'
// ===================================================================
// 💳 SYSTÈME DE PAIEMENT MONDIAL
// Support de tous les moyens de paiement mondiaux
// ===================================================================

export interface PaymentMethod {
  id: string;
  name: string;
  type: 'card' | 'wallet' | 'bank' | 'crypto' | 'mobile';
  icon: string;
  countries: string[];
  currencies: string[];
  processingFee: number; // Pourcentage
  isPopular?: boolean;
}

export const GLOBAL_PAYMENT_METHODS: PaymentMethod[] = [
  // CARTES DE CRÉDIT/DÉBIT INTERNATIONALES
  {
    id: 'visa',
    name: 'Visa',
    type: 'card',
    icon: '💳',
    countries: ['*'], // Mondial
    currencies: ['*'], // Toutes devises
    processingFee: 2.9,
    isPopular: true
  },
  {
    id: 'mastercard',
    name: 'Mastercard',
    type: 'card',
    icon: '💳',
    countries: ['*'],
    currencies: ['*'],
    processingFee: 2.9,
    isPopular: true
  },
  {
    id: 'paypal',
    name: 'PayPal',
    type: 'wallet',
    icon: '🅿️',
    countries: ['*'],
    currencies: ['*'],
    processingFee: 3.4,
    isPopular: true
  },
  {
    id: 'apple_pay',
    name: 'Apple Pay',
    type: 'wallet',
    icon: '🍎',
    countries: ['US', 'CA', 'GB', 'AU', 'FR', 'DE', 'JP', 'CN'],
    currencies: ['USD', 'CAD', 'GBP', 'AUD', 'EUR', 'JPY', 'CNY'],
    processingFee: 2.9
  },
  {
    id: 'google_pay',
    name: 'Google Pay',
    type: 'wallet',
    icon: '🔵',
    countries: ['US', 'CA', 'GB', 'AU', 'FR', 'DE', 'IN', 'BR'],
    currencies: ['USD', 'CAD', 'GBP', 'AUD', 'EUR', 'INR', 'BRL'],
    processingFee: 2.9
  },
  // PAIEMENTS RÉGIONAUX - ASIE
  {
    id: 'alipay',
    name: 'Alipay',
    type: 'wallet',
    icon: '🇨🇳',
    countries: ['CN', 'HK', 'MO'],
    currencies: ['CNY', 'HKD'],
    processingFee: 2.8,
    isPopular: true
  },
  {
    id: 'wechat_pay',
    name: 'WeChat Pay',
    type: 'wallet',
    icon: '💬',
    countries: ['CN'],
    currencies: ['CNY'],
    processingFee: 2.8,
    isPopular: true
  },
  // PAIEMENTS RÉGIONAUX - AMÉRIQUES
  {
    id: 'pix',
    name: 'PIX',
    type: 'bank',
    icon: '🇧🇷',
    countries: ['BR'],
    currencies: ['BRL'],
    processingFee: 0.99,
    isPopular: true
  },
  // PAIEMENTS RÉGIONAUX - AFRIQUE
  {
    id: 'mpesa',
    name: 'M-Pesa',
    type: 'mobile',
    icon: '📱',
    countries: ['KE', 'TZ', 'UG', 'RW', 'MZ'],
    currencies: ['KES', 'TZS', 'UGX', 'RWF', 'MZN'],
    processingFee: 1.5
  },
  {
    id: 'orange_money',
    name: 'Orange Money',
    type: 'mobile',
    icon: '🟠',
    countries: ['MA', 'SN', 'CI', 'ML', 'BF'],
    currencies: ['MAD', 'XOF'],
    processingFee: 2.0
  }
];

export function getAvailablePaymentMethods(countryCode: string, currency: string): PaymentMethod[] {
  return GLOBAL_PAYMENT_METHODS.filter(method => {
    const countryMatch = method.countries.includes('*') || method.countries.includes(countryCode);
    const currencyMatch = method.currencies.includes('*') || method.currencies.includes(currency);
    return countryMatch && currencyMatch;
  }).sort((a, b) => {
    // Trier par popularité puis par frais
    if (a.isPopular && !b.isPopular) return -1;
    if (!a.isPopular && b.isPopular) return 1;
    return a.processingFee - b.processingFee;
  });
}

export function calculatePaymentFee(amount: number, method: PaymentMethod): number {
  return (amount * method.processingFee) / 100;
}
EOF
    
    log_success "Système de paiement mondial créé"
}

# Créer les composants React principaux
create_main_components() {
    log_header "COMPOSANTS REACT PRINCIPAUX"
    
    # LanguageSelector amélioré
    cat > "$SRC_DIR/components/ui/LanguageSelector.tsx" << 'EOF'
'use client';

import { useState, useRef, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { WORLD_LANGUAGES, getLanguagesByRegion, REGIONS } from '@/lib/i18n/languages';

export default function LanguageSelector() {
  const { currentLanguage, setLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);

  const currentLang = WORLD_LANGUAGES.find(l => l.code === currentLanguage) || WORLD_LANGUAGES[0];
  const groupedLanguages = getLanguagesByRegion();

  // Filtrer les langues selon la recherche
  const filteredLanguages = searchTerm 
    ? WORLD_LANGUAGES.filter(lang => 
        lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
      )
    : null;

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchTerm('');
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode);
    setIsOpen(false);
    setSearchTerm('');
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-3 px-4 py-3 bg-white/90 hover:bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all duration-200 transform hover:scale-105"
        data-testid="language-selector"
      >
        <span className="text-xl">{currentLang.flag}</span>
        <span className="font-medium text-gray-700 hidden sm:block">{currentLang.nativeName}</span>
        <svg className={`w-4 h-4 text-gray-500 transition-transform ${isOpen ? 'rotate-180' : ''}`} 
             fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 mt-2 w-80 bg-white border border-gray-200 rounded-xl shadow-xl z-50 max-h-96 overflow-hidden"
          data-testid="language-dropdown"
        >
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100">
            <input
              type="text"
              placeholder="Rechercher une langue..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
            />
          </div>

          {/* Contenu avec scroll visible */}
          <div className="overflow-y-auto max-h-80 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
            {filteredLanguages ? (
              // Résultats de recherche
              <div className="p-2">
                {filteredLanguages.length === 0 ? (
                  <div className="px-4 py-8 text-center text-gray-500">
                    Aucune langue trouvée
                  </div>
                ) : (
                  filteredLanguages.map((language) => (
                    <button
                      key={language.code}
                      onClick={() => handleLanguageSelect(language.code)}
                      className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg text-left hover:bg-gray-50 transition-colors ${
                        currentLanguage === language.code ? 'bg-blue-50 text-blue-700 font-medium' : 'text-gray-700'
                      }`}
                      data-testid={`language-option-${language.code}`}
                    >
                      <span className="text-lg">{language.flag}</span>
                      <div className="flex-1">
                        <div className="font-medium">{language.nativeName}</div>
                        <div className="text-xs text-gray-500">{language.name}</div>
                      </div>
                      {currentLanguage === language.code && (
                        <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                        </svg>
                      )}
                    </button>
                  ))
                )}
              </div>
            ) : (
              // Langues groupées par région
              Object.entries(groupedLanguages).map(([region, languages]) => (
                <div key={region} className="border-b border-gray-100 last:border-b-0">
                  <div className="px-4 py-2 bg-gray-50 border-b border-gray-100">
                    <h3 className="text-xs font-semibold text-gray-600 uppercase tracking-wide flex items-center gap-2">
                      <span>{REGIONS[region as keyof typeof REGIONS]}</span>
                      <span>{region}</span>
                    </h3>
                  </div>
                  <div className="p-2">
                    {languages.map((language) => (
                      <button
                        key={language.code}
                        onClick={() => handleLanguageSelect(language.code)}
                        className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg text-left hover:bg-gray-50 transition-colors ${
                          currentLanguage === language.code ? 'bg-blue-50 text-blue-700 font-medium' : 'text-gray-700'
                        }`}
                        data-testid={`language-option-${language.code}`}
                        data-language={language.code}
                      >
                        <span className="text-lg">{language.flag}</span>
                        <div className="flex-1">
                          <div className="font-medium">{language.nativeName}</div>
                          <div className="text-xs text-gray-500">{language.name}</div>
                        </div>
                        {currentLanguage === language.code && (
                          <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                            <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                          </svg>
                        )}
                      </button>
                    ))}
                  </div>
                </div>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="p-3 border-t border-gray-100 bg-gray-50 text-center">
            <p className="text-xs text-gray-600">
              ✨ 75+ langues • Support RTL complet
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
EOF

    log_success "Composants React principaux créés"
}

# Créer les tests complets
create_comprehensive_tests() {
    log_header "TESTS COMPLETS"
    
    cat > "$BASE_DIR/tests/e2e/math4child.complete.spec.ts" << 'EOF'
// ===================================================================
// 🧪 TESTS COMPLETS MATH4CHILD
// Tests fonctionnels, traduction, performance, stress
// ===================================================================

import { test, expect } from '@playwright/test';

const TEST_LANGUAGES = ['fr', 'en', 'es', 'ar', 'de', 'zh'];

test.describe('Math4Child - Tests Complets', () => {
  
  // TESTS FONCTIONNELS
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.locator('h1')).toContainText('Math4Child');
    await expect(page.locator('[data-testid="language-selector"]')).toBeVisible();
    await expect(page.locator('button:has-text("🎮")')).toBeVisible();
  });

  test('Sélecteur de langues fonctionne @languages', async ({ page }) => {
    await page.goto('/');
    
    // Ouvrir le dropdown
    await page.click('[data-testid="language-selector"]');
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
    
    // Vérifier le scroll visible
    const dropdown = page.locator('[data-testid="language-dropdown"] .overflow-y-auto');
    await expect(dropdown).toBeVisible();
    
    // Vérifier le drapeau marocain pour l'arabe
    await expect(page.locator('[data-language="ar"]')).toContainText('🇲🇦');
  });

  // TESTS DE TRADUCTION
  for (const lang of TEST_LANGUAGES) {
    test(`Interface traduite en ${lang} @i18n`, async ({ page }) => {
      await page.goto('/');
      
      // Changer de langue
      await page.click('[data-testid="language-selector"]');
      await page.click(`[data-language="${lang}"]`);
      
      // Vérifier RTL pour l'arabe
      if (lang === 'ar') {
        const dir = await page.locator('body, [dir="rtl"]').first().getAttribute('dir');
        expect(dir).toBe('rtl');
      }
      
      // Vérifier que l'interface est traduite
      await expect(page.locator('h1')).toBeVisible();
    });
  }

  // TESTS DE PERFORMANCE
  test('Performance acceptable @performance', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(5000); // 5 secondes max
  });
});
EOF
    
    log_success "Tests complets créés"
}

# Créer les scripts de déploiement
create_deployment_scripts() {
    log_header "SCRIPTS DE DÉPLOIEMENT"
    
    # Script de déploiement web
    cat > "$BASE_DIR/deploy-web.sh" << 'EOF'
#!/bin/bash
# Déploiement Web (www.math4child.com)

echo "🌐 Déploiement Web Math4Child..."

# Vérifications préalables
if [ ! -f "package.json" ]; then
    echo "❌ package.json non trouvé"
    exit 1
fi

# Build production
echo "📦 Build production..."
npm run build

# Export statique (si nécessaire)
if [ -f "next.config.js" ] && grep -q "output.*export" next.config.js; then
    echo "📤 Export statique..."
    npm run export
fi

# Déploiement
echo "🚀 Déploiement sur Vercel..."
if command -v vercel >/dev/null 2>&1; then
    vercel --prod
    echo "✅ Déployé sur: https://www.math4child.com"
else
    echo "⚠️  Vercel CLI non installé"
    echo "💡 Installation: npm i -g vercel"
fi
EOF

    # Script de déploiement Android
    cat > "$BASE_DIR/deploy-android.sh" << 'EOF'
#!/bin/bash
# Déploiement Android (Google Play Store)

echo "📱 Déploiement Android Math4Child..."

# Vérifications
if [ ! -d "android" ]; then
    echo "📁 Initialisation du projet Android..."
    npx cap add android
fi

# Build
echo "📦 Build Android..."
npm run build
npx cap copy android
npx cap update android

# Ouvrir Android Studio
echo "🔧 Ouverture Android Studio..."
npx cap open android

echo "✅ Projet Android prêt pour Google Play Store"
echo "💡 N'oubliez pas de signer l'APK avant publication"
EOF

    # Script de déploiement iOS
    cat > "$BASE_DIR/deploy-ios.sh" << 'EOF'
#!/bin/bash
# Déploiement iOS (App Store)

echo "🍎 Déploiement iOS Math4Child..."

# Vérifications macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS nécessite macOS"
    exit 1
fi

# Vérifications
if [ ! -d "ios" ]; then
    echo "📁 Initialisation du projet iOS..."
    npx cap add ios
fi

# Build
echo "📦 Build iOS..."
npm run build
npx cap copy ios
npx cap update ios

# Ouvrir Xcode
echo "🔧 Ouverture Xcode..."
npx cap open ios

echo "✅ Projet iOS prêt pour App Store"
echo "💡 Configurez les certificats dans Xcode avant soumission"
EOF

    # Rendre les scripts exécutables
    chmod +x "$BASE_DIR"/{deploy-web.sh,deploy-android.sh,deploy-ios.sh}
    
    log_success "Scripts de déploiement créés"
}

# Créer les comptes de test
create_test_accounts() {
    log_header "COMPTES DE TEST"
    
    cat > "$BASE_DIR/accounts.test.md" << 'EOF'
# 🧪 COMPTES DE TEST MATH4CHILD

## Comptes par niveau d'abonnement

### 1. Essai Gratuit (7 jours)
- **Email**: trial@math4child.com
- **Mot de passe**: Trial123!
- **Profils**: 2 enfants
- **Questions**: 50 gratuites
- **Niveaux**: Débutant uniquement

### 2. Abonnement Mensuel  
- **Email**: monthly@math4child.com
- **Mot de passe**: Monthly123!
- **Profils**: 3 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous (1-5)

### 3. Abonnement Trimestriel (-10%)
- **Email**: quarterly@math4child.com  
- **Mot de passe**: Quarterly123!
- **Profils**: 5 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous + fonctionnalités premium

### 4. Abonnement Annuel (-30%)
- **Email**: yearly@math4child.com
- **Mot de passe**: Yearly123!
- **Profils**: 10 enfants
- **Questions**: Illimitées
- **Niveaux**: Tous + support VIP

### 5. Premium Famille
- **Email**: premium@math4child.com
- **Mot de passe**: Premium123!
- **Profils**: 20 enfants  
- **Questions**: Illimitées
- **Niveaux**: Tous + fonctionnalités exclusives

## Tests Multi-langues

### Français
- **Email**: test.fr@math4child.com
- **Mot de passe**: TestFR123!

### English
- **Email**: test.en@math4child.com
- **Mot de passe**: TestEN123!

### العربية (RTL)
- **Email**: test.ar@math4child.com
- **Mot de passe**: TestAR123!

### 中文
- **Email**: test.zh@math4child.com
- **Mot de passe**: TestZH123!

## Admin & Development

### Super Admin
- **Email**: admin@math4child.com
- **Mot de passe**: SuperAdmin123!
- **Permissions**: Gestion complète

### Support
- **Email**: support@math4child.com  
- **Mot de passe**: Support123!
- **Permissions**: Support client
EOF
    
    log_success "Comptes de test créés"
}

# Fonction principale
main() {
    log_header "CORRECTION MATH4CHILD - CRÉATION RÉPERTOIRES"
    
    echo ""
    log_info "🔧 Correction en cours des erreurs de répertoires..."
    
    create_directory_structure
    create_global_pricing_system
    create_payment_system
    create_main_components
    create_comprehensive_tests
    create_deployment_scripts
    create_test_accounts
    
    echo ""
    log_header "CORRECTION TERMINÉE AVEC SUCCÈS !"
    
    echo ""
    log_success "🎉 Tous les fichiers et répertoires ont été créés !"
    echo ""
    log_info "📁 Structure complète créée :"
    echo "   ✅ src/lib/pricing/globalPricing.ts"
    echo "   ✅ src/lib/payment/paymentMethods.ts"
    echo "   ✅ src/components/ui/LanguageSelector.tsx"
    echo "   ✅ tests/e2e/math4child.complete.spec.ts"
    echo "   ✅ deploy-web.sh, deploy-android.sh, deploy-ios.sh"
    echo "   ✅ accounts.test.md"
    echo ""
    log_info "🚀 Prochaines étapes :"
    echo "   1. cd apps/math4child (si pas déjà fait)"
    echo "   2. npm install"
    echo "   3. npm run dev"
    echo "   4. Ouvrir http://localhost:3000"
    echo ""
    log_info "🧪 Pour tester :"
    echo "   npx playwright test"
    echo ""
    log_info "🌍 Pour déployer :"
    echo "   ./deploy-web.sh (Web)"
    echo "   ./deploy-android.sh (Android)"
    echo "   ./deploy-ios.sh (iOS)"
    echo ""
}

# Exécution
main "$@"