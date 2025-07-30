export interface Translation {
  // Métadonnées application
  appName: string;
  appFullName: string;
  tagline: string;
  
  // Navigation
  navigation: {
    home: string;
    apps: string;
    pricing: string;
    about: string;
    contact: string;
  };
  
  // Applications
  apps: {
    postmath: string;
    unitflip: string;
    budgetcron: string;
    ai4kids: string;
    multiai: string;
  };
  
  // Interface générale
  interface: {
    selectLanguage: string;
    loading: string;
    error: string;
    success: string;
    tryAgain: string;
    save: string;
    cancel: string;
    confirm: string;
  };
  
  // Pricing
  pricing: {
    choosePlan: string;
    monthly: string;
    yearly: string;
    free: string;
    premium: string;
    enterprise: string;
  };
}

export interface Language {
  code: string;
  name: string;
  flag: string;
  nativeName: string;
  rtl?: boolean;
  region: string;
}

export type SupportedLanguage = 
  | 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'nl' | 'ru'  // Europe/Americas (8)
  | 'zh' | 'ja' | 'ko' | 'hi' | 'th' | 'vi'                // Asia (6)
  | 'ar' | 'he' | 'fa'                                     // RTL (3)
  | 'sv' | 'tr' | 'pl';                                    // Autres (3)
  // TOTAL: 20 langues exactement
