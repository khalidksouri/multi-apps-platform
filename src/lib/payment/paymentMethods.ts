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
