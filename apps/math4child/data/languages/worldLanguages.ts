// ===================================================================
// LANGUES MONDIALES - MATH4CHILD
// 200+ langues supportées avec métadonnées complètes
// ===================================================================

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  region: string;
  continent: string;
  rtl?: boolean;
  popular?: boolean;
  countries: string[];
  speakers?: number;
  difficulty?: 'easy' | 'medium' | 'hard';
}

// Base de langues principales (extensible à 200+)
export const WORLD_LANGUAGES: Language[] = [
  // 🇪🇺 EUROPE
  {
    code: 'fr',
    name: 'French',
    nativeName: 'Français',
    flag: '🇫🇷',
    region: 'Western Europe',
    continent: 'Europe',
    popular: true,
    countries: ['France', 'Belgium', 'Switzerland', 'Canada'],
    speakers: 280000000,
    difficulty: 'medium'
  },
  {
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flag: '🇬🇧',
    region: 'Western Europe',
    continent: 'Europe',
    popular: true,
    countries: ['United Kingdom', 'United States', 'Canada', 'Australia'],
    speakers: 1500000000,
    difficulty: 'easy'
  },
  {
    code: 'es',
    name: 'Spanish',
    nativeName: 'Español',
    flag: '🇪🇸',
    region: 'Southern Europe',
    continent: 'Europe',
    popular: true,
    countries: ['Spain', 'Mexico', 'Argentina', 'Colombia'],
    speakers: 500000000,
    difficulty: 'easy'
  },
  {
    code: 'de',
    name: 'German',
    nativeName: 'Deutsch',
    flag: '🇩🇪',
    region: 'Western Europe',
    continent: 'Europe',
    popular: true,
    countries: ['Germany', 'Austria', 'Switzerland'],
    speakers: 100000000,
    difficulty: 'hard'
  },
  {
    code: 'it',
    name: 'Italian',
    nativeName: 'Italiano',
    flag: '🇮🇹',
    region: 'Southern Europe',
    continent: 'Europe',
    countries: ['Italy', 'San Marino', 'Vatican City'],
    speakers: 65000000,
    difficulty: 'medium'
  },
  
  // 🌏 ASIE
  {
    code: 'zh',
    name: 'Chinese',
    nativeName: '中文',
    flag: '🇨🇳',
    region: 'East Asia',
    continent: 'Asia',
    popular: true,
    countries: ['China', 'Taiwan', 'Singapore'],
    speakers: 918000000,
    difficulty: 'hard'
  },
  {
    code: 'ja',
    name: 'Japanese',
    nativeName: '日本語',
    flag: '🇯🇵',
    region: 'East Asia',
    continent: 'Asia',
    popular: true,
    countries: ['Japan'],
    speakers: 125000000,
    difficulty: 'hard'
  },
  {
    code: 'ko',
    name: 'Korean',
    nativeName: '한국어',
    flag: '🇰🇷',
    region: 'East Asia',
    continent: 'Asia',
    countries: ['South Korea', 'North Korea'],
    speakers: 77000000,
    difficulty: 'hard'
  },
  {
    code: 'ar',
    name: 'Arabic',
    nativeName: 'العربية',
    flag: '🇲🇦',
    region: 'Middle East',
    continent: 'Asia',
    rtl: true,
    popular: true,
    countries: ['Morocco', 'Egypt', 'Saudi Arabia', 'UAE'],
    speakers: 422000000,
    difficulty: 'hard'
  },
  {
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिन्दी',
    flag: '🇮🇳',
    region: 'South Asia',
    continent: 'Asia',
    popular: true,
    countries: ['India'],
    speakers: 600000000,
    difficulty: 'hard'
  },
  
  // 🌍 AFRIQUE
  {
    code: 'sw',
    name: 'Swahili',
    nativeName: 'Kiswahili',
    flag: '🇰🇪',
    region: 'East Africa',
    continent: 'Africa',
    countries: ['Kenya', 'Tanzania', 'Uganda'],
    speakers: 100000000,
    difficulty: 'medium'
  },
  
  // 🌎 AMÉRIQUES
  {
    code: 'pt',
    name: 'Portuguese',
    nativeName: 'Português',
    flag: '🇧🇷',
    region: 'South America',
    continent: 'America',
    popular: true,
    countries: ['Brazil', 'Portugal'],
    speakers: 260000000,
    difficulty: 'medium'
  }
];

// Fonctions utilitaires CORRIGÉES (sans spread operator sur Set)
export const getAllRegions = (): string[] => {
  const regionsSet = new Set<string>();
  WORLD_LANGUAGES.forEach(lang => regionsSet.add(lang.region));
  return Array.from(regionsSet).sort();
};

export const getAllContinents = (): string[] => {
  const continentsSet = new Set<string>();
  WORLD_LANGUAGES.forEach(lang => continentsSet.add(lang.continent));
  return Array.from(continentsSet).sort();
};

export const getLanguagesByRegion = (region: string): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.region === region);
};

export const getLanguagesByContinent = (continent: string): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.continent === continent);
};

export const getPopularLanguages = (): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.popular === true);
};

export const getRTLLanguages = (): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.rtl === true);
};

export const searchLanguages = (query: string): Language[] => {
  const searchLower = query.toLowerCase();
  return WORLD_LANGUAGES.filter(lang => 
    lang.name.toLowerCase().includes(searchLower) ||
    lang.nativeName.toLowerCase().includes(searchLower) ||
    lang.code.toLowerCase().includes(searchLower)
  );
};

// Export par défaut
export default WORLD_LANGUAGES;
