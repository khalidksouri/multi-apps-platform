export interface Language {
  code: string;
  flag: string;
  name: string;
  nativeName: string;
  isRTL?: boolean;
  region: string;
  countries: string[];
  popular?: boolean;
}

export const WORLD_LANGUAGES: Language[] = [
  // LANGUES EUROPÉENNES
  {
    code: 'fr',
    flag: '🇫🇷',
    name: 'French',
    nativeName: 'Français',
    region: 'Europe',
    popular: true,
    countries: ['France', 'Belgique', 'Suisse', 'Luxembourg', 'Monaco', 'Sénégal', 'Côte d\'Ivoire', 'Mali', 'Burkina Faso', 'Niger', 'Guinée', 'Madagascar', 'Cameroun', 'RD Congo', 'Canada', 'Haïti']
  },
  {
    code: 'en',
    flag: '🇬🇧',
    name: 'English',
    nativeName: 'English',
    region: 'Europe',
    popular: true,
    countries: ['Royaume-Uni', 'États-Unis', 'Canada', 'Australie', 'Nouvelle-Zélande', 'Irlande', 'Afrique du Sud', 'Nigeria', 'Kenya', 'Ghana', 'Tanzanie', 'Ouganda', 'Zambie', 'Zimbabwe', 'Singapour', 'Hong Kong', 'Inde', 'Philippines']
  },
  {
    code: 'es',
    flag: '🇪🇸',
    name: 'Spanish',
    nativeName: 'Español',
    region: 'Europe',
    popular: true,
    countries: ['Espagne', 'Mexique', 'Argentine', 'Colombie', 'Venezuela', 'Pérou', 'Chili', 'Équateur', 'Guatemala', 'Cuba', 'Bolivie', 'République Dominicaine', 'Honduras', 'Paraguay', 'El Salvador', 'Nicaragua', 'Costa Rica', 'Panama', 'Uruguay']
  },
  {
    code: 'de',
    flag: '🇩🇪',
    name: 'German',
    nativeName: 'Deutsch',
    region: 'Europe',
    popular: true,
    countries: ['Allemagne', 'Autriche', 'Suisse', 'Liechtenstein', 'Luxembourg', 'Belgique', 'Italie du Sud']
  },
  {
    code: 'it',
    flag: '🇮🇹',
    name: 'Italian',
    nativeName: 'Italiano',
    region: 'Europe',
    countries: ['Italie', 'Saint-Marin', 'Vatican', 'Suisse', 'Slovénie', 'Croatie']
  },
  {
    code: 'pt',
    flag: '🇵🇹',
    name: 'Portuguese',
    nativeName: 'Português',
    region: 'Europe',
    countries: ['Portugal', 'Brésil', 'Angola', 'Mozambique', 'Cap-Vert', 'Guinée-Bissau', 'São Tomé-et-Príncipe', 'Timor Oriental', 'Macao']
  },
  {
    code: 'ru',
    flag: '🇷🇺',
    name: 'Russian',
    nativeName: 'Русский',
    region: 'Europe',
    countries: ['Russie', 'Biélorussie', 'Kazakhstan', 'Kirghizistan', 'Tadjikistan', 'Moldavie', 'Ukraine', 'Géorgie', 'Estonie', 'Lettonie', 'Lituanie']
  },
  {
    code: 'pl',
    flag: '🇵🇱',
    name: 'Polish',
    nativeName: 'Polski',
    region: 'Europe',
    countries: ['Pologne', 'Lituanie', 'République Tchèque', 'Slovaquie', 'Ukraine', 'Biélorussie']
  },
  {
    code: 'nl',
    flag: '🇳🇱',
    name: 'Dutch',
    nativeName: 'Nederlands',
    region: 'Europe',
    countries: ['Pays-Bas', 'Belgique', 'Suriname', 'Aruba', 'Curaçao', 'Sint Maarten']
  },

  // LANGUES ASIATIQUES
  {
    code: 'zh',
    flag: '🇨🇳',
    name: 'Chinese',
    nativeName: '中文',
    region: 'Asia',
    popular: true,
    countries: ['Chine', 'Taïwan', 'Hong Kong', 'Macao', 'Singapour', 'Malaisie', 'Indonésie', 'Thaïlande', 'Philippines']
  },
  {
    code: 'ja',
    flag: '🇯🇵',
    name: 'Japanese',
    nativeName: '日本語',
    region: 'Asia',
    popular: true,
    countries: ['Japon', 'Palaos', 'Brésil', 'Pérou', 'États-Unis']
  },
  {
    code: 'ko',
    flag: '🇰🇷',
    name: 'Korean',
    nativeName: '한국어',
    region: 'Asia',
    countries: ['Corée du Sud', 'Corée du Nord', 'Chine', 'Japon', 'États-Unis', 'Canada']
  },
  {
    code: 'hi',
    flag: '🇮🇳',
    name: 'Hindi',
    nativeName: 'हिन्दी',
    region: 'Asia',
    popular: true,
    countries: ['Inde', 'Népal', 'Fidji', 'Suriname', 'Guyana', 'Trinité-et-Tobago', 'Maurice', 'Afrique du Sud']
  },
  {
    code: 'th',
    flag: '🇹🇭',
    name: 'Thai',
    nativeName: 'ไทย',
    region: 'Asia',
    countries: ['Thaïlande', 'Laos', 'Myanmar', 'Cambodge', 'Viêt Nam', 'Malaisie']
  },
  {
    code: 'vi',
    flag: '🇻🇳',
    name: 'Vietnamese',
    nativeName: 'Tiếng Việt',
    region: 'Asia',
    countries: ['Viêt Nam', 'Cambodge', 'Laos', 'États-Unis', 'France', 'Australie', 'Canada']
  },

  // LANGUES DU MOYEN-ORIENT
  {
    code: 'ar',
    flag: '🇸🇦',
    name: 'Arabic',
    nativeName: 'العربية',
    isRTL: true,
    region: 'Middle East',
    popular: true,
    countries: ['Arabie saoudite', 'EAU', 'Qatar', 'Koweït', 'Bahreïn', 'Oman', 'Yémen', 'Jordanie', 'Liban', 'Syrie', 'Irak', 'Palestine', 'Maroc', 'Algérie', 'Tunisie', 'Libye', 'Égypte', 'Soudan', 'Mauritanie', 'Somalie', 'Djibouti', 'Comores']
  },
  {
    code: 'fa',
    flag: '🇮🇷',
    name: 'Persian',
    nativeName: 'فارسی',
    isRTL: true,
    region: 'Middle East',
    countries: ['Iran', 'Afghanistan', 'Tadjikistan', 'Ouzbékistan', 'Irak']
  },
  {
    code: 'tr',
    flag: '🇹🇷',
    name: 'Turkish',
    nativeName: 'Türkçe',
    region: 'Middle East',
    countries: ['Turquie', 'Chypre du Nord', 'Bulgarie', 'Grèce', 'Macédoine', 'Kosovo']
  },
  {
    code: 'he',
    flag: '🇮🇱',
    name: 'Hebrew',
    nativeName: 'עברית',
    isRTL: true,
    region: 'Middle East',
    countries: ['Israël', 'Palestine', 'États-Unis', 'Canada', 'France', 'Argentine']
  },

  // LANGUES AFRICAINES
  {
    code: 'sw',
    flag: '🇰🇪',
    name: 'Swahili',
    nativeName: 'Kiswahili',
    region: 'Africa',
    countries: ['Kenya', 'Tanzanie', 'Ouganda', 'RD Congo', 'Rwanda', 'Burundi', 'Mozambique', 'Malawi', 'Zambie', 'Somalie']
  },
  {
    code: 'zu',
    flag: '🇿🇦',
    name: 'Zulu',
    nativeName: 'isiZulu',
    region: 'Africa',
    countries: ['Afrique du Sud', 'Eswatini', 'Lesotho', 'Zimbabwe', 'Mozambique', 'Botswana']
  }
];

export const getTotalLanguages = (): number => WORLD_LANGUAGES.length;

export const isRTLLanguage = (code: string): boolean => {
  const language = WORLD_LANGUAGES.find(lang => lang.code === code);
  return language?.isRTL || false;
};

export const getLanguageByCode = (code: string): Language | undefined => {
  return WORLD_LANGUAGES.find(lang => lang.code === code);
};

export const getLanguagesByRegion = (region: string): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.region === region);
};

export const getAllRegions = (): string[] => {
  const regions = [...new Set(WORLD_LANGUAGES.map(lang => lang.region))];
  return regions.sort();
};

export const getPopularLanguages = (): Language[] => {
  return WORLD_LANGUAGES.filter(lang => lang.popular);
};
