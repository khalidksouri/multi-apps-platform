// =============================================
// 📄 packages/shared/src/index.ts
// =============================================

// ===== TYPES DE BASE =====
export interface APIResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
    timestamp?: string;
  };
}

// ===== TYPES POUR LE SHIPPING =====
export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

// ===== TYPES POUR LA CONVERSION D'UNITÉS =====
export interface ConversionResult {
  value: number;
  unit: string;
  explanation: string;
}

export interface UnitCategory {
  id: string;
  name: string;
  units: UnitDefinition[];
}

export interface UnitDefinition {
  id: string;
  name: string;
  symbol: string;
  toBase: (value: number) => number;
  fromBase: (value: number) => number;
}

// ===== TYPES POUR LE BUDGET =====
export interface BudgetCategory {
  id: string;
  name: string;
  budget: number;
  spent: number;
  color: string;
}

export interface BudgetInsight {
  id: number;
  type: 'savings_opportunity' | 'budget_alert' | 'spending_pattern';
  title: string;
  description: string;
  confidence: number;
  color: string;
}

export interface BankAccount {
  id: string;
  name: string;
  type: string;
  balance: number;
  status: 'active' | 'error' | 'pending';
  lastSync: Date;
}

// ===== FONCTIONS UTILITAIRES =====
export function formatCurrency(amount: number, currency: string = 'EUR'): string {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency
  }).format(amount);
}

export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function formatDate(date: Date): string {
  return date.toLocaleDateString('fr-FR');
}

// ===== CONSTANTES =====
export const APP_URLS = {
  AI4KIDS: process.env.AI4KIDS_URL || 'http://localhost:3004',
  MULTIAI: process.env.MULTIAI_URL || 'http://localhost:3005',
  BUDGETCRON: process.env.BUDGETCRON_URL || 'http://localhost:3003',
  UNITFLIP: process.env.UNITFLIP_URL || 'http://localhost:3002',
  POSTMATH: process.env.POSTMATH_URL || 'http://localhost:3001'
} as const;

// ===== EXPORTS DE TYPES SPÉCIALISÉS =====
export * from './types/common';
export * from './types/ai4kids';
export * from './types/budgetcron';
export * from './types/multiai';
export * from './types/postmath';
export * from './types/unitflip';

// ===== EXPORTS D'UTILITAIRES =====
export * from './utils/api';
export * from './utils/date';
export * from './utils/string';
export * from './utils/validation';

// ===== EXPORTS DE CONSTANTES (sans conflit) =====
export {
  APP_PORTS,
  TIMEOUTS,
  LIMITS,
  ERROR_CODES,
  ERROR_MESSAGES,
  STATUS,
  HTTP_STATUS,
  LOCALES,
  CURRENCIES,
  TIMEZONES,
  DATE_FORMATS,
  NUMBER_FORMATS,
  CONVERSION_CATEGORIES,
  BUDGET_CATEGORIES,
  UNITS,
  CARRIERS,
  USER_ROLES,
  PERMISSIONS,
  FEATURE_FLAGS,
  PATTERNS,
  API_CONFIG,
  TEST_CONFIG,
  PERFORMANCE_THRESHOLDS,
  A11Y_CONFIG,
  SECURITY_CONFIG,
  ENVIRONMENTS,
  APP_INFO
} from './constants/config';

// ===== EXPORTS D'INTERNATIONALISATION (sans conflit de types) =====
export {
  type TranslationResource,
  type I18nConfig,
  type TranslationContext,
  defaultI18nConfig,
  commonTranslations,
  detectBrowserLocale,
  isValidLocale,
  getLocaleInfo,
  formatNumber,
  formatCurrency as formatCurrencyI18n,
  formatDate as formatDateI18n,
  formatRelativeTime,
  getPluralRule,
  getPlural,
  type SupportedLocale,
  type TranslationKey,
  type InterpolationValues
} from './i18n/config';

// ===== RE-EXPORT DU TYPE LOCALE DEPUIS CONSTANTS =====
export type { Locale, Currency, Timezone, ConversionCategory, UserRole, Permission, Environment, ErrorCode } from './constants/config';

// ===== EXPORTS DE HOOKS (commentés pour éviter les dépendances React) =====
// Note: Les hooks React sont exportés séparément pour éviter les dépendances
// export * from './hooks/use-auth';
// export * from './i18n/useTranslation';