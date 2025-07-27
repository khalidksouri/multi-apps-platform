import { UNIVERSAL_LANGUAGES, CURRENCIES } from './languages';

export const getLanguageByCode = (code: string) => {
  return UNIVERSAL_LANGUAGES.find(lang => lang.code === code) || UNIVERSAL_LANGUAGES[0];
};

export const getLanguagesByContinent = (continent: string) => {
  return UNIVERSAL_LANGUAGES.filter(lang => 
    lang.continent.toLowerCase() === continent.toLowerCase()
  );
};

export const getCurrencySymbol = (currencyCode: string) => {
  const currency = CURRENCIES.find(c => c.code === currencyCode);
  return currency?.symbol || currencyCode;
};

export const formatPrice = (price: number, currencyCode: string, locale: string) => {
  try {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currencyCode,
      minimumFractionDigits: 2,
    }).format(price);
  } catch (error) {
    const symbol = getCurrencySymbol(currencyCode);
    return `${symbol}${price.toFixed(2)}`;
  }
};

export const formatDate = (date: Date, format: string, locale: string) => {
  try {
    return new Intl.DateTimeFormat(locale).format(date);
  } catch (error) {
    return date.toLocaleDateString();
  }
};

export const detectUserLanguage = (): string => {
  if (typeof window === 'undefined') return 'en';
  
  const browserLang = navigator.language;
  const supportedLang = UNIVERSAL_LANGUAGES.find(lang => 
    lang.code === browserLang || lang.code.startsWith(browserLang.split('-')[0])
  );
  
  return supportedLang?.code || 'en';
};

export const detectUserTimezone = (): string => {
  if (typeof window === 'undefined') return 'UTC';
  
  try {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch (error) {
    return 'UTC';
  }
};

export const convertPriceByRegion = (basePrice: number, targetCurrency: string): number => {
  // Conversion approximative basée sur le pouvoir d'achat
  const conversionRates: Record<string, number> = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110,
    'CNY': 6.5,
    'INR': 75,
    'BRL': 5.2,
    'CAD': 1.25,
    'AUD': 1.35,
    'SAR': 3.75,
    'AED': 3.67,
    'EGP': 15.7,
    'ZAR': 14.5,
    'NGN': 411,
    'KES': 108,
    'MAD': 8.8,
    'MXN': 20.1,
    'ARS': 98.5,
    'CLP': 712,
    'COP': 3654,
    'PEN': 3.6,
  };
  
  const rate = conversionRates[targetCurrency] || 1.0;
  
  // Ajustement du prix selon le pouvoir d'achat local
  const powerPurchasingAdjustment: Record<string, number> = {
    'INR': 0.3,  // Prix plus bas en Inde
    'NGN': 0.25, // Prix plus bas au Nigeria
    'KES': 0.3,  // Prix plus bas au Kenya
    'EGP': 0.4,  // Prix plus bas en Égypte
    'BRL': 0.6,  // Prix ajusté au Brésil
    'ARS': 0.4,  // Prix plus bas en Argentine
    'CLP': 0.7,  // Prix ajusté au Chili
    'COP': 0.5,  // Prix plus bas en Colombie
    'PEN': 0.6,  // Prix ajusté au Pérou
    'MAD': 0.5,  // Prix plus bas au Maroc
  };
  
  const adjustment = powerPurchasingAdjustment[targetCurrency] || 1.0;
  return Math.round((basePrice * rate * adjustment) * 100) / 100;
};
