import { useState, useEffect, useCallback, createContext, useContext } from 'react';
import { 
  type Locale, 
  type TranslationResource, 
  type TranslationContext,
  type I18nConfig,
  defaultI18nConfig,
  commonTranslations,
  detectBrowserLocale,
  isValidLocale
} from './config';

// =============================================
// TYPES
// =============================================

export interface TranslationHookReturn {
  t: (key: string, context?: TranslationContext) => string;
  locale: Locale;
  setLocale: (locale: Locale) => void;
  isLoading: boolean;
  error: string | null;
  addTranslations: (locale: Locale, translations: TranslationResource) => void;
  hasTranslation: (key: string, locale?: Locale) => boolean;
}

export interface I18nProviderProps {
  children: React.ReactNode;
  config?: Partial<I18nConfig>;
  initialLocale?: Locale;
}

// =============================================
// CONTEXTE
// =============================================

const I18nContext = createContext<TranslationHookReturn | null>(null);

// =============================================
// UTILITAIRES DE TRADUCTION
// =============================================

class TranslationManager {
  private config: I18nConfig;
  private loadedTranslations: Record<Locale, TranslationResource> = {};

  constructor(config: I18nConfig) {
    this.config = config;
    
    // Charger les traductions communes
    Object.entries(commonTranslations).forEach(([locale, translations]) => {
      this.loadedTranslations[locale as Locale] = { ...translations };
    });
  }

  addTranslations(locale: Locale, translations: TranslationResource): void {
    if (!this.loadedTranslations[locale]) {
      this.loadedTranslations[locale] = {};
    }
    
    this.loadedTranslations[locale] = this.mergeTranslations(
      this.loadedTranslations[locale],
      translations
    );
  }

  private mergeTranslations(
    target: TranslationResource,
    source: TranslationResource
  ): TranslationResource {
    const result = { ...target };
    
    Object.entries(source).forEach(([key, value]) => {
      if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
        result[key] = this.mergeTranslations(
          (result[key] as TranslationResource) || {},
          value as TranslationResource
        );
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }

  translate(
    key: string,
    locale: Locale,
    context: TranslationContext = {}
  ): string {
    const translation = this.getTranslation(key, locale);
    
    if (!translation) {
      // Essayer avec la locale de fallback
      if (locale !== this.config.fallbackLocale) {
        const fallbackTranslation = this.getTranslation(key, this.config.fallbackLocale);
        if (fallbackTranslation) {
          return this.interpolate(fallbackTranslation, context);
        }
      }
      
      // Retourner la clé si aucune traduction trouvée
      console.warn(`Translation missing for key: ${key} (locale: ${locale})`);
      return key;
    }
    
    return this.interpolate(translation, context);
  }

  private getTranslation(key: string, locale: Locale): string | null {
    const translations = this.loadedTranslations[locale];
    if (!translations) return null;
    
    const keys = key.split('.');
    let current: any = translations;
    
    for (const k of keys) {
      if (current && typeof current === 'object' && k in current) {
        current = current[k];
      } else {
        return null;
      }
    }
    
    return typeof current === 'string' ? current : null;
  }

  private interpolate(template: string, context: TranslationContext): string {
    const { prefix, suffix } = this.config.interpolation;
    
    return template.replace(
      new RegExp(`${this.escapeRegex(prefix)}(.*?)${this.escapeRegex(suffix)}`, 'g'),
      (match, key) => {
        const value = context[key.trim()];
        return value !== undefined ? String(value) : match;
      }
    );
  }

  private escapeRegex(str: string): string {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  hasTranslation(key: string, locale: Locale): boolean {
    return this.getTranslation(key, locale) !== null;
  }

  getSupportedLocales(): Locale[] {
    return this.config.supportedLocales;
  }

  getDefaultLocale(): Locale {
    return this.config.defaultLocale;
  }
}

// =============================================
// STORAGE LOCAL
// =============================================

const LOCALE_STORAGE_KEY = 'i18n_locale';

function getStoredLocale(): Locale | null {
  if (typeof window === 'undefined') return null;
  
  const stored = localStorage.getItem(LOCALE_STORAGE_KEY);
  return stored && isValidLocale(stored) ? stored : null;
}

function setStoredLocale(locale: Locale): void {
  if (typeof window === 'undefined') return;
  localStorage.setItem(LOCALE_STORAGE_KEY, locale);
}

// =============================================
// HOOK PRINCIPAL
// =============================================

export function useTranslation(
  config: Partial<I18nConfig> = {}
): TranslationHookReturn {
  const mergedConfig = { ...defaultI18nConfig, ...config };
  const [manager] = useState(() => new TranslationManager(mergedConfig));
  
  // Déterminer la locale initiale
  const initialLocale = 
    getStoredLocale() ||
    config.defaultLocale ||
    detectBrowserLocale() ||
    mergedConfig.defaultLocale;
    
  const [locale, setLocaleState] = useState<Locale>(initialLocale);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Fonction de traduction
  const t = useCallback((key: string, context: TranslationContext = {}): string => {
    try {
      return manager.translate(key, locale, context);
    } catch (err) {
      console.error('Translation error:', err);
      return key;
    }
  }, [manager, locale]);

  // Changer de locale
  const setLocale = useCallback(async (newLocale: Locale) => {
    if (!manager.getSupportedLocales().includes(newLocale)) {
      console.warn(`Locale ${newLocale} is not supported`);
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      // Sauvegarder dans le localStorage
      setStoredLocale(newLocale);
      
      // Mettre à jour l'état
      setLocaleState(newLocale);
      
      // Potentiellement charger des traductions supplémentaires
      // (pour les traductions lazy-loaded)
      
    } catch (err) {
      setError('Erreur lors du changement de langue');
      console.error('Locale change error:', err);
    } finally {
      setIsLoading(false);
    }
  }, [manager]);

  // Ajouter des traductions
  const addTranslations = useCallback((
    targetLocale: Locale,
    translations: TranslationResource
  ) => {
    manager.addTranslations(targetLocale, translations);
  }, [manager]);

  // Vérifier si une traduction existe
  const hasTranslation = useCallback((
    key: string,
    checkLocale?: Locale
  ): boolean => {
    return manager.hasTranslation(key, checkLocale || locale);
  }, [manager, locale]);

  return {
    t,
    locale,
    setLocale,
    isLoading,
    error,
    addTranslations,
    hasTranslation
  };
}

// =============================================
// PROVIDER
// =============================================

export function I18nProvider({ 
  children, 
  config = {},
  initialLocale 
}: I18nProviderProps): JSX.Element {
  const translation = useTranslation({
    ...config,
    defaultLocale: initialLocale || config.defaultLocale
  });

  return (
    <I18nContext.Provider value={translation}>
      {children}
    </I18nContext.Provider>
  );
}

// =============================================
// HOOK DE CONTEXTE
// =============================================

export function useI18n(): TranslationHookReturn {
  const context = useContext(I18nContext);
  
  if (!context) {
    throw new Error('useI18n must be used within an I18nProvider');
  }
  
  return context;
}

// =============================================
// HOOKS UTILITAIRES
// =============================================

export function useLocaleDirection(): 'ltr' | 'rtl' {
  const { locale } = useI18n();
  
  // La plupart des langues supportées sont LTR
  // Ajouter RTL pour l'arabe, l'hébreu, etc. si nécessaire
  const rtlLocales: Locale[] = [];
  
  return rtlLocales.includes(locale) ? 'rtl' : 'ltr';
}

export function useFormattedNumber() {
  const { locale } = useI18n();
  
  return useCallback((
    value: number,
    options?: Intl.NumberFormatOptions
  ) => {
    return new Intl.NumberFormat(locale, options).format(value);
  }, [locale]);
}

export function useFormattedCurrency() {
  const { locale } = useI18n();
  
  return useCallback((
    value: number,
    currency: string = 'EUR'
  ) => {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency
    }).format(value);
  }, [locale]);
}

export function useFormattedDate() {
  const { locale } = useI18n();
  
  return useCallback((
    date: Date,
    options?: Intl.DateTimeFormatOptions
  ) => {
    return new Intl.DateTimeFormat(locale, options).format(date);
  }, [locale]);
}

// =============================================
// HELPERS DE TRADUCTION
// =============================================

export function createTranslationHelpers(translations: Record<Locale, TranslationResource>) {
  return {
    // Ajouter des traductions à toutes les locales
    addToAllLocales: (manager: TranslationManager) => {
      Object.entries(translations).forEach(([locale, trans]) => {
        manager.addTranslations(locale as Locale, trans);
      });
    },
    
    // Vérifier la complétude des traductions
    checkCompleteness: (baseLocale: Locale = 'fr-FR') => {
      const baseKeys = extractKeys(translations[baseLocale]);
      const results: Record<Locale, { missing: string[]; extra: string[] }> = {};
      
      Object.keys(translations).forEach(locale => {
        if (locale === baseLocale) return;
        
        const localeKeys = extractKeys(translations[locale as Locale]);
        const missing = baseKeys.filter(key => !localeKeys.includes(key));
        const extra = localeKeys.filter(key => !baseKeys.includes(key));
        
        results[locale as Locale] = { missing, extra };
      });
      
      return results;
    }
  };
}

function extractKeys(obj: TranslationResource, prefix = ''): string[] {
  const keys: string[] = [];
  
  Object.entries(obj).forEach(([key, value]) => {
    const fullKey = prefix ? `${prefix}.${key}` : key;
    
    if (typeof value === 'string') {
      keys.push(fullKey);
    } else if (typeof value === 'object' && value !== null) {
      keys.push(...extractKeys(value as TranslationResource, fullKey));
    }
  });
  
  return keys;
}

// =============================================
// COMPOSANTS UTILITAIRES
// =============================================

export interface TransProps {
  i18nKey: string;
  values?: TranslationContext;
  fallback?: string;
}

export function Trans({ i18nKey, values = {}, fallback }: TransProps): JSX.Element {
  const { t } = useI18n();
  
  const translation = t(i18nKey, values);
  const displayText = translation === i18nKey && fallback ? fallback : translation;
  
  return <span>{displayText}</span>;
}

// =============================================
// TYPES D'EXPORT
// =============================================

export type TranslationFunction = (key: string, context?: TranslationContext) => string;
export type LocaleChangeFunction = (locale: Locale) => void;