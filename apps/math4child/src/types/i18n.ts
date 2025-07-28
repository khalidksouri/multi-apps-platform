export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  dir: 'ltr' | 'rtl';
  continent: string;
}

export interface AppTranslations {
  nav: {
    home: string;
    game: string;
    pricing: string;
    profile: string;
  };
  home: {
    title: string;
    subtitle: string;
    description: string;
    startFree: string;
    viewPlans: string;
  };
  game: {
    levels: {
      beginner: string;
      elementary: string;
      intermediate: string;
      advanced: string;
      expert: string;
    };
    operations: {
      addition: string;
      subtraction: string;
      multiplication: string;
      division: string;
    };
  };
}

export type Translations = Record<string, AppTranslations>;
