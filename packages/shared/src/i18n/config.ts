// =============================================
// CONFIGURATION INTERNATIONALISATION
// =============================================

import { LOCALES } from '../constants/config';

// ===== TYPES =====
export type Locale = typeof LOCALES[keyof typeof LOCALES];

export interface TranslationResource {
  [key: string]: string | TranslationResource;
}

export interface I18nConfig {
  defaultLocale: Locale;
  supportedLocales: Locale[];
  fallbackLocale: Locale;
  resources: Record<Locale, TranslationResource>;
  interpolation: {
    prefix: string;
    suffix: string;
  };
}

export interface TranslationContext {
  count?: number;
  [key: string]: any;
}

// ===== CONFIGURATION PAR DÉFAUT =====
export const defaultI18nConfig: I18nConfig = {
  defaultLocale: LOCALES.FR,
  supportedLocales: [LOCALES.FR, LOCALES.EN, LOCALES.ES, LOCALES.DE],
  fallbackLocale: LOCALES.EN,
  resources: {
    [LOCALES.FR]: {},
    [LOCALES.EN]: {},
    [LOCALES.ES]: {},
    [LOCALES.DE]: {}
  },
  interpolation: {
    prefix: '{{',
    suffix: '}}'
  }
};

// ===== TRADUCTIONS COMMUNES =====
export const commonTranslations: Record<Locale, TranslationResource> = {
  [LOCALES.FR]: {
    common: {
      loading: 'Chargement...',
      error: 'Erreur',
      success: 'Succès',
      cancel: 'Annuler',
      confirm: 'Confirmer',
      save: 'Enregistrer',
      delete: 'Supprimer',
      edit: 'Modifier',
      add: 'Ajouter',
      search: 'Rechercher',
      filter: 'Filtrer',
      sort: 'Trier',
      next: 'Suivant',
      previous: 'Précédent',
      close: 'Fermer',
      submit: 'Soumettre',
      reset: 'Réinitialiser',
      retry: 'Réessayer'
    },
    validation: {
      required: 'Ce champ est requis',
      email: 'Format d\'email invalide',
      minLength: 'Minimum {{count}} caractères',
      maxLength: 'Maximum {{count}} caractères',
      min: 'Valeur minimum: {{value}}',
      max: 'Valeur maximum: {{value}}',
      pattern: 'Format invalide'
    },
    errors: {
      networkError: 'Erreur de connexion',
      serverError: 'Erreur serveur',
      notFound: 'Non trouvé',
      unauthorized: 'Non autorisé',
      forbidden: 'Accès interdit',
      timeout: 'Délai d\'attente dépassé',
      unknown: 'Erreur inconnue'
    },
    auth: {
      login: 'Connexion',
      logout: 'Déconnexion',
      register: 'Inscription',
      email: 'Email',
      password: 'Mot de passe',
      confirmPassword: 'Confirmer le mot de passe',
      forgotPassword: 'Mot de passe oublié ?',
      resetPassword: 'Réinitialiser le mot de passe',
      rememberMe: 'Se souvenir de moi'
    }
  },
  [LOCALES.EN]: {
    common: {
      loading: 'Loading...',
      error: 'Error',
      success: 'Success',
      cancel: 'Cancel',
      confirm: 'Confirm',
      save: 'Save',
      delete: 'Delete',
      edit: 'Edit',
      add: 'Add',
      search: 'Search',
      filter: 'Filter',
      sort: 'Sort',
      next: 'Next',
      previous: 'Previous',
      close: 'Close',
      submit: 'Submit',
      reset: 'Reset',
      retry: 'Retry'
    },
    validation: {
      required: 'This field is required',
      email: 'Invalid email format',
      minLength: 'Minimum {{count}} characters',
      maxLength: 'Maximum {{count}} characters',
      min: 'Minimum value: {{value}}',
      max: 'Maximum value: {{value}}',
      pattern: 'Invalid format'
    },
    errors: {
      networkError: 'Network error',
      serverError: 'Server error',
      notFound: 'Not found',
      unauthorized: 'Unauthorized',
      forbidden: 'Forbidden',
      timeout: 'Timeout',
      unknown: 'Unknown error'
    },
    auth: {
      login: 'Login',
      logout: 'Logout',
      register: 'Register',
      email: 'Email',
      password: 'Password',
      confirmPassword: 'Confirm password',
      forgotPassword: 'Forgot password?',
      resetPassword: 'Reset password',
      rememberMe: 'Remember me'
    }
  },
  [LOCALES.ES]: {
    common: {
      loading: 'Cargando...',
      error: 'Error',
      success: 'Éxito',
      cancel: 'Cancelar',
      confirm: 'Confirmar',
      save: 'Guardar',
      delete: 'Eliminar',
      edit: 'Editar',
      add: 'Añadir',
      search: 'Buscar',
      filter: 'Filtrar',
      sort: 'Ordenar',
      next: 'Siguiente',
      previous: 'Anterior',
      close: 'Cerrar',
      submit: 'Enviar',
      reset: 'Restablecer',
      retry: 'Reintentar'
    },
    validation: {
      required: 'Este campo es obligatorio',
      email: 'Formato de email inválido',
      minLength: 'Mínimo {{count}} caracteres',
      maxLength: 'Máximo {{count}} caracteres',
      min: 'Valor mínimo: {{value}}',
      max: 'Valor máximo: {{value}}',
      pattern: 'Formato inválido'
    },
    errors: {
      networkError: 'Error de conexión',
      serverError: 'Error del servidor',
      notFound: 'No encontrado',
      unauthorized: 'No autorizado',
      forbidden: 'Prohibido',
      timeout: 'Tiempo agotado',
      unknown: 'Error desconocido'
    },
    auth: {
      login: 'Iniciar sesión',
      logout: 'Cerrar sesión',
      register: 'Registrarse',
      email: 'Email',
      password: 'Contraseña',
      confirmPassword: 'Confirmar contraseña',
      forgotPassword: '¿Olvidaste tu contraseña?',
      resetPassword: 'Restablecer contraseña',
      rememberMe: 'Recordarme'
    }
  },
  [LOCALES.DE]: {
    common: {
      loading: 'Laden...',
      error: 'Fehler',
      success: 'Erfolg',
      cancel: 'Abbrechen',
      confirm: 'Bestätigen',
      save: 'Speichern',
      delete: 'Löschen',
      edit: 'Bearbeiten',
      add: 'Hinzufügen',
      search: 'Suchen',
      filter: 'Filtern',
      sort: 'Sortieren',
      next: 'Weiter',
      previous: 'Zurück',
      close: 'Schließen',
      submit: 'Absenden',
      reset: 'Zurücksetzen',
      retry: 'Wiederholen'
    },
    validation: {
      required: 'Dieses Feld ist erforderlich',
      email: 'Ungültiges E-Mail-Format',
      minLength: 'Mindestens {{count}} Zeichen',
      maxLength: 'Maximal {{count}} Zeichen',
      min: 'Mindestwert: {{value}}',
      max: 'Maximalwert: {{value}}',
      pattern: 'Ungültiges Format'
    },
    errors: {
      networkError: 'Netzwerkfehler',
      serverError: 'Serverfehler',
      notFound: 'Nicht gefunden',
      unauthorized: 'Nicht autorisiert',
      forbidden: 'Verboten',
      timeout: 'Zeitüberschreitung',
      unknown: 'Unbekannter Fehler'
    },
    auth: {
      login: 'Anmelden',
      logout: 'Abmelden',
      register: 'Registrieren',
      email: 'E-Mail',
      password: 'Passwort',
      confirmPassword: 'Passwort bestätigen',
      forgotPassword: 'Passwort vergessen?',
      resetPassword: 'Passwort zurücksetzen',
      rememberMe: 'Angemeldet bleiben'
    }
  }
};

// ===== UTILITAIRES DE DÉTECTION =====
export function detectBrowserLocale(): Locale {
  if (typeof window === 'undefined') return LOCALES.FR;

  const browserLang = navigator.language || navigator.languages?.[0];
  
  if (browserLang) {
    // Correspondance exacte
    const exactMatch = Object.values(LOCALES).find(locale => 
      locale === browserLang
    ) as Locale;
    if (exactMatch) return exactMatch;

    // Correspondance par langue (ex: en-GB -> en-US)
    const langCode = browserLang.split('-')[0];
    const langMatch = Object.values(LOCALES).find(locale => 
      locale.startsWith(langCode)
    ) as Locale;
    if (langMatch) return langMatch;
  }

  return LOCALES.FR; // Fallback
}

export function isValidLocale(locale: string): locale is Locale {
  return Object.values(LOCALES).includes(locale as Locale);
}

export function getLocaleInfo(locale: Locale) {
  const localeInfo = {
    [LOCALES.FR]: {
      name: 'Français',
      nativeName: 'Français',
      flag: '🇫🇷',
      direction: 'ltr',
      currency: 'EUR',
      dateFormat: 'dd/MM/yyyy',
      timeFormat: 'HH:mm'
    },
    [LOCALES.EN]: {
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
      direction: 'ltr',
      currency: 'USD',
      dateFormat: 'MM/dd/yyyy',
      timeFormat: 'h:mm a'
    },
    [LOCALES.ES]: {
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      direction: 'ltr',
      currency: 'EUR',
      dateFormat: 'dd/MM/yyyy',
      timeFormat: 'HH:mm'
    },
    [LOCALES.DE]: {
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      direction: 'ltr',
      currency: 'EUR',
      dateFormat: 'dd.MM.yyyy',
      timeFormat: 'HH:mm'
    }
  };

  return localeInfo[locale];
}

// ===== FORMATAGE LOCALISÉ =====
export function formatNumber(
  value: number,
  locale: Locale = LOCALES.FR,
  options?: Intl.NumberFormatOptions
): string {
  return new Intl.NumberFormat(locale, options).format(value);
}

export function formatCurrency(
  value: number,
  locale: Locale = LOCALES.FR,
  currency: string = 'EUR'
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency
  }).format(value);
}

export function formatDate(
  date: Date,
  locale: Locale = LOCALES.FR,
  options?: Intl.DateTimeFormatOptions
): string {
  return new Intl.DateTimeFormat(locale, options).format(date);
}

export function formatRelativeTime(
  value: number,
  unit: Intl.RelativeTimeFormatUnit,
  locale: Locale = LOCALES.FR
): string {
  return new Intl.RelativeTimeFormat(locale, { numeric: 'auto' }).format(value, unit);
}

// ===== PLURALISATION =====
export function getPluralRule(
  count: number,
  locale: Locale = LOCALES.FR
): Intl.LDMLPluralRule {
  return new Intl.PluralRules(locale).select(count);
}

export function getPlural(
  count: number,
  translations: { zero?: string; one: string; few?: string; many?: string; other: string },
  locale: Locale = LOCALES.FR
): string {
  const rule = getPluralRule(count, locale);
  
  if (count === 0 && translations.zero) return translations.zero;
  
  switch (rule) {
    case 'one':
      return translations.one;
    case 'few':
      return translations.few || translations.other;
    case 'many':
      return translations.many || translations.other;
    default:
      return translations.other;
  }
}

// ===== EXPORT DE TYPES =====
export type SupportedLocale = typeof LOCALES[keyof typeof LOCALES];
export type TranslationKey = string;
export type InterpolationValues = Record<string, string | number>;