export interface Translation {
  appName: string;
  heroTitle: string;
  heroSubtitle: string;
  heroDescription: string;
  startFreeNow: string;
  learnMore: string;
  mathGames: string;
  chooseGame: string;
  puzzleMath: string;
  memoryMath: string;
  quickMath: string;
  mixedExercises: string;
  beginner: string;
  intermediate: string;
  advanced: string;
  expert: string;
  choosePlan: string;
  selectLanguage: string;
  pricing: string;
  home: string;
  games: string;
  about: string;
  contact: string;
}

export const translations: Record<string, Translation> = {
  fr: {
    appName: 'Math4Child',
    heroTitle: 'Les Mathématiques, c\'est Fantastique !',
    heroSubtitle: 'Apprendre en jouant n\'a jamais été aussi amusant',
    heroDescription: 'Développez les compétences mathématiques de votre enfant avec notre plateforme interactive',
    startFreeNow: 'Commencer Gratuitement',
    learnMore: 'En savoir plus',
    mathGames: 'Jeux Mathématiques',
    chooseGame: 'Choisis ton jeu préféré',
    puzzleMath: 'Puzzle Math',
    memoryMath: 'Mémoire Math',
    quickMath: 'Calcul Rapide',
    mixedExercises: 'Exercices Mixtes',
    beginner: 'Débutant',
    intermediate: 'Intermédiaire',
    advanced: 'Avancé',
    expert: 'Expert',
    choosePlan: 'Choisissez votre Plan',
    selectLanguage: 'Choisir la langue',
    pricing: 'Tarifs',
    home: 'Accueil',
    games: 'Jeux',
    about: 'À propos',
    contact: 'Contact',
  },
  
  en: {
    appName: 'Math4Child',
    heroTitle: 'Mathematics is Fantastic!',
    heroSubtitle: 'Learning through play has never been so fun',
    heroDescription: 'Develop your child\'s mathematical skills with our interactive platform',
    startFreeNow: 'Start Free Now',
    learnMore: 'Learn More',
    mathGames: 'Math Games',
    chooseGame: 'Choose your favorite game',
    puzzleMath: 'Math Puzzle',
    memoryMath: 'Math Memory',
    quickMath: 'Quick Math',
    mixedExercises: 'Mixed Exercises',
    beginner: 'Beginner',
    intermediate: 'Intermediate',
    advanced: 'Advanced',
    expert: 'Expert',
    choosePlan: 'Choose your Plan',
    selectLanguage: 'Select language',
    pricing: 'Pricing',
    home: 'Home',
    games: 'Games',
    about: 'About',
    contact: 'Contact',
  },
  
  ar: {
    appName: 'Math4Child',
    heroTitle: 'الرياضيات رائعة!',
    heroSubtitle: 'التعلم باللعب لم يكن ممتعاً أبداً هكذا',
    heroDescription: 'طور مهارات طفلك الرياضية مع منصتنا التفاعلية',
    startFreeNow: 'ابدأ مجاناً الآن',
    learnMore: 'اعرف المزيد',
    mathGames: 'ألعاب الرياضيات',
    chooseGame: 'اختر لعبتك المفضلة',
    puzzleMath: 'لغز الرياضيات',
    memoryMath: 'ذاكرة الرياضيات',
    quickMath: 'حساب سريع',
    mixedExercises: 'تمارين مختلطة',
    beginner: 'مبتدئ',
    intermediate: 'متوسط',
    advanced: 'متقدم',
    expert: 'خبير',
    choosePlan: 'اختر خطتك',
    selectLanguage: 'اختيار اللغة',
    pricing: 'الأسعار',
    home: 'الرئيسية',
    games: 'الألعاب',
    about: 'حول',
    contact: 'اتصل بنا',
  }
};

export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳', rtl: false },
  { code: 'ja', name: '日本語', flag: '🇯🇵', rtl: false },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', rtl: false },
  { code: 'pt', name: 'Português', flag: '🇵🇹', rtl: false },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', rtl: false }
] as const;

export type SupportedLanguage = keyof typeof translations;
