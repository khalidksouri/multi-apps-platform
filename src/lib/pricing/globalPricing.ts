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
