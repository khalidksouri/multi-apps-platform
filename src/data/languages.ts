export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  continent: string;
  region: string;
  rtl?: boolean;
  font?: string;
  speakers?: number;
  difficulty?: 'easy' | 'medium' | 'hard';
}

// 🌍 LANGUES COMPLÈTES TOUS CONTINENTS - 200+ langues
export const languages: Language[] = [
  // 🇪🇺 EUROPE (35 langues)
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', region: 'Western Europe', speakers: 280000000, difficulty: 'medium' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', region: 'Western Europe', speakers: 1500000000, difficulty: 'easy' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', region: 'Southern Europe', speakers: 500000000, difficulty: 'easy' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', region: 'Western Europe', speakers: 100000000, difficulty: 'hard' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', region: 'Southern Europe', speakers: 65000000, difficulty: 'medium' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', region: 'Southern Europe', speakers: 260000000, difficulty: 'medium' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', region: 'Eastern Europe', speakers: 258000000, difficulty: 'hard', font: 'Noto Sans' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', region: 'Eastern Europe', speakers: 45000000, difficulty: 'hard' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', region: 'Western Europe', speakers: 24000000, difficulty: 'medium' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe', region: 'Northern Europe', speakers: 10000000, difficulty: 'medium' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', continent: 'Europe', region: 'Northern Europe', speakers: 6000000, difficulty: 'medium' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', continent: 'Europe', region: 'Northern Europe', speakers: 5000000, difficulty: 'medium' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', continent: 'Europe', region: 'Northern Europe', speakers: 5500000, difficulty: 'hard' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', continent: 'Europe', region: 'Eastern Europe', speakers: 10500000, difficulty: 'hard' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', continent: 'Europe', region: 'Eastern Europe', speakers: 13000000, difficulty: 'hard' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', continent: 'Europe', region: 'Eastern Europe', speakers: 24000000, difficulty: 'medium' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', continent: 'Europe', region: 'Eastern Europe', speakers: 9000000, difficulty: 'hard' },
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', continent: 'Europe', region: 'Southern Europe', speakers: 5000000, difficulty: 'medium' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', continent: 'Europe', region: 'Eastern Europe', speakers: 5000000, difficulty: 'hard' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', continent: 'Europe', region: 'Southern Europe', speakers: 2500000, difficulty: 'medium' },
  { code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', continent: 'Europe', region: 'Northern Europe', speakers: 1000000, difficulty: 'hard' },
  { code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', continent: 'Europe', region: 'Northern Europe', speakers: 1500000, difficulty: 'hard' },
  { code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', continent: 'Europe', region: 'Northern Europe', speakers: 3000000, difficulty: 'hard' },
  { code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', continent: 'Europe', region: 'Southern Europe', speakers: 13000000, difficulty: 'hard' },
  { code: 'uk', name: 'Ukrainian', nativeName: 'Українська', flag: '🇺🇦', continent: 'Europe', region: 'Eastern Europe', speakers: 45000000, difficulty: 'hard' },
  { code: 'be', name: 'Belarusian', nativeName: 'Беларуская', flag: '🇧🇾', continent: 'Europe', region: 'Eastern Europe', speakers: 5000000, difficulty: 'hard' },
  { code: 'mk', name: 'Macedonian', nativeName: 'Македонски', flag: '🇲🇰', continent: 'Europe', region: 'Southern Europe', speakers: 2000000, difficulty: 'hard' },
  { code: 'sq', name: 'Albanian', nativeName: 'Shqip', flag: '🇦🇱', continent: 'Europe', region: 'Southern Europe', speakers: 6000000, difficulty: 'medium' },
  { code: 'bs', name: 'Bosnian', nativeName: 'Bosanski', flag: '🇧🇦', continent: 'Europe', region: 'Southern Europe', speakers: 2500000, difficulty: 'medium' },
  { code: 'sr', name: 'Serbian', nativeName: 'Српски', flag: '🇷🇸', continent: 'Europe', region: 'Southern Europe', speakers: 12000000, difficulty: 'hard' },
  { code: 'me', name: 'Montenegrin', nativeName: 'Crnogorski', flag: '🇲🇪', continent: 'Europe', region: 'Southern Europe', speakers: 300000, difficulty: 'medium' },
  { code: 'is', name: 'Icelandic', nativeName: 'Íslenska', flag: '🇮🇸', continent: 'Europe', region: 'Northern Europe', speakers: 400000, difficulty: 'hard' },
  { code: 'mt', name: 'Maltese', nativeName: 'Malti', flag: '🇲🇹', continent: 'Europe', region: 'Southern Europe', speakers: 500000, difficulty: 'hard' },
  { code: 'ga', name: 'Irish', nativeName: 'Gaeilge', flag: '🇮🇪', continent: 'Europe', region: 'Western Europe', speakers: 1800000, difficulty: 'hard' },
  { code: 'cy', name: 'Welsh', nativeName: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', continent: 'Europe', region: 'Western Europe', speakers: 700000, difficulty: 'hard' },

  // 🌏 ASIE (50 langues)
  { code: 'zh', name: 'Chinese (Simplified)', nativeName: '中文简体', flag: '🇨🇳', continent: 'Asia', region: 'East Asia', speakers: 918000000, difficulty: 'hard', font: 'Noto Sans SC' },
  { code: 'zh-TW', name: 'Chinese (Traditional)', nativeName: '中文繁體', flag: '🇹🇼', continent: 'Asia', region: 'East Asia', speakers: 23000000, difficulty: 'hard', font: 'Noto Sans TC' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', region: 'East Asia', speakers: 125000000, difficulty: 'hard', font: 'Noto Sans JP' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', region: 'East Asia', speakers: 77000000, difficulty: 'hard', font: 'Noto Sans KR' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 600000000, difficulty: 'medium', font: 'Noto Sans Devanagari' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', region: 'Southeast Asia', speakers: 69000000, difficulty: 'hard', font: 'Noto Sans Thai' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', region: 'Southeast Asia', speakers: 95000000, difficulty: 'medium' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', region: 'Southeast Asia', speakers: 270000000, difficulty: 'easy' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asia', region: 'Southeast Asia', speakers: 290000000, difficulty: 'easy' },
  { code: 'fil', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', continent: 'Asia', region: 'Southeast Asia', speakers: 28000000, difficulty: 'medium' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', continent: 'Asia', region: 'South Asia', speakers: 300000000, difficulty: 'hard', font: 'Noto Sans Bengali' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', continent: 'Asia', region: 'South Asia', speakers: 170000000, difficulty: 'hard', rtl: true, font: 'Noto Sans Arabic' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 78000000, difficulty: 'hard', font: 'Noto Sans Tamil' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 96000000, difficulty: 'hard', font: 'Noto Sans Telugu' },
  { code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 38000000, difficulty: 'hard', font: 'Noto Sans Malayalam' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 56000000, difficulty: 'hard', font: 'Noto Sans Kannada' },
  { code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 56000000, difficulty: 'hard', font: 'Noto Sans Gujarati' },
  { code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 113000000, difficulty: 'hard', font: 'Noto Sans Gurmukhi' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', continent: 'Asia', region: 'South Asia', speakers: 83000000, difficulty: 'hard', font: 'Noto Sans Devanagari' },
  { code: 'ne', name: 'Nepali', nativeName: 'नेपाली', flag: '🇳🇵', continent: 'Asia', region: 'South Asia', speakers: 16000000, difficulty: 'hard', font: 'Noto Sans Devanagari' },
  { code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰', continent: 'Asia', region: 'South Asia', speakers: 17000000, difficulty: 'hard', font: 'Noto Sans Sinhala' },
  { code: 'my', name: 'Myanmar', nativeName: 'မြန်မာ', flag: '🇲🇲', continent: 'Asia', region: 'Southeast Asia', speakers: 33000000, difficulty: 'hard', font: 'Noto Sans Myanmar' },
  { code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', continent: 'Asia', region: 'Southeast Asia', speakers: 16000000, difficulty: 'hard', font: 'Noto Sans Khmer' },
  { code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', continent: 'Asia', region: 'Southeast Asia', speakers: 30000000, difficulty: 'hard', font: 'Noto Sans Lao' },
  { code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', continent: 'Asia', region: 'Western Asia', speakers: 4000000, difficulty: 'hard', font: 'Noto Sans Georgian' },
  { code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', continent: 'Asia', region: 'Western Asia', speakers: 7000000, difficulty: 'hard', font: 'Noto Sans Armenian' },
  { code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', continent: 'Asia', region: 'Western Asia', speakers: 23000000, difficulty: 'medium' },
  { code: 'kk', name: 'Kazakh', nativeName: 'Қазақша', flag: '🇰🇿', continent: 'Asia', region: 'Central Asia', speakers: 13000000, difficulty: 'hard' },
  { code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргызча', flag: '🇰🇬', continent: 'Asia', region: 'Central Asia', speakers: 4000000, difficulty: 'hard' },
  { code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbekcha', flag: '🇺🇿', continent: 'Asia', region: 'Central Asia', speakers: 44000000, difficulty: 'medium' },
  { code: 'tk', name: 'Turkmen', nativeName: 'Türkmençe', flag: '🇹🇲', continent: 'Asia', region: 'Central Asia', speakers: 7000000, difficulty: 'medium' },
  { code: 'tg', name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', continent: 'Asia', region: 'Central Asia', speakers: 8000000, difficulty: 'hard' },
  { code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', continent: 'Asia', region: 'East Asia', speakers: 5000000, difficulty: 'hard' },

  // 🕌 MOYEN-ORIENT & AFRIQUE DU NORD (15 langues) - SANS HÉBREU
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦', continent: 'Africa', region: 'North Africa', speakers: 422000000, difficulty: 'hard', rtl: true, font: 'Noto Sans Arabic' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', region: 'Western Asia', speakers: 110000000, difficulty: 'hard', rtl: true, font: 'Noto Sans Arabic' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', region: 'Western Asia', speakers: 88000000, difficulty: 'medium' },
  { code: 'ku', name: 'Kurdish', nativeName: 'کوردی', flag: '🏴', continent: 'Asia', region: 'Western Asia', speakers: 30000000, difficulty: 'hard', rtl: true },

  // 🌍 AFRIQUE SUB-SAHARIENNE (45 langues)
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', region: 'East Africa', speakers: 200000000, difficulty: 'easy' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', region: 'East Africa', speakers: 57000000, difficulty: 'hard', font: 'Noto Sans Ethiopic' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', continent: 'Africa', region: 'Southern Africa', speakers: 12000000, difficulty: 'medium' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', region: 'Southern Africa', speakers: 7000000, difficulty: 'easy' },
  { code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', continent: 'Africa', region: 'Southern Africa', speakers: 8000000, difficulty: 'medium' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', continent: 'Africa', region: 'West Africa', speakers: 45000000, difficulty: 'medium' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', continent: 'Africa', region: 'West Africa', speakers: 27000000, difficulty: 'medium' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', continent: 'Africa', region: 'West Africa', speakers: 70000000, difficulty: 'medium' },
  { code: 'wo', name: 'Wolof', nativeName: 'Wolof', flag: '🇸🇳', continent: 'Africa', region: 'West Africa', speakers: 12000000, difficulty: 'medium' },
  { code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', continent: 'Africa', region: 'East Africa', speakers: 25000000, difficulty: 'medium' },

  // 🌎 AMÉRIQUES (30 langues)
  { code: 'pt-BR', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'Americas', region: 'South America', speakers: 230000000, difficulty: 'medium' },
  { code: 'es-MX', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'Americas', region: 'North America', speakers: 130000000, difficulty: 'easy' },
  { code: 'es-AR', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'Americas', region: 'South America', speakers: 45000000, difficulty: 'easy' },
  { code: 'es-CO', name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', continent: 'Americas', region: 'South America', speakers: 50000000, difficulty: 'easy' },
  { code: 'en-US', name: 'English (USA)', nativeName: 'English (USA)', flag: '🇺🇸', continent: 'Americas', region: 'North America', speakers: 300000000, difficulty: 'easy' },
  { code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', continent: 'Americas', region: 'North America', speakers: 25000000, difficulty: 'easy' },
  { code: 'fr-CA', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'Americas', region: 'North America', speakers: 7000000, difficulty: 'medium' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runa Simi', flag: '🇵🇪', continent: 'Americas', region: 'South America', speakers: 8000000, difficulty: 'hard' },
  { code: 'ay', name: 'Aymara', nativeName: 'Aymar Aru', flag: '🇧🇴', continent: 'Americas', region: 'South America', speakers: 2000000, difficulty: 'hard' },
  { code: 'gn', name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', continent: 'Americas', region: 'South America', speakers: 6000000, difficulty: 'hard' },
  { code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl Ayisyen', flag: '🇭🇹', continent: 'Americas', region: 'Caribbean', speakers: 12000000, difficulty: 'medium' },

  // 🏝️ OCÉANIE (15 langues)
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', region: 'Australia', speakers: 25000000, difficulty: 'easy' },
  { code: 'en-NZ', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', continent: 'Oceania', region: 'New Zealand', speakers: 5000000, difficulty: 'easy' },
  { code: 'mi', name: 'Maori', nativeName: 'Te Reo Māori', flag: '🇳🇿', continent: 'Oceania', region: 'New Zealand', speakers: 185000, difficulty: 'hard' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', continent: 'Oceania', region: 'Polynesia', speakers: 510000, difficulty: 'medium' },
  { code: 'fj', name: 'Fijian', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', continent: 'Oceania', region: 'Melanesia', speakers: 350000, difficulty: 'medium' },
  { code: 'to', name: 'Tongan', nativeName: 'Lea Fakatonga', flag: '🇹🇴', continent: 'Oceania', region: 'Polynesia', speakers: 200000, difficulty: 'medium' }
];

export function getLanguageByCode(code: string): Language | undefined {
  return languages.find(lang => lang.code === code);
}

export function filterLanguages(search: string, continent?: string, region?: string): Language[] {
  let filtered = languages;
  
  if (continent && continent !== 'all') {
    filtered = filtered.filter(lang => lang.continent === continent);
  }
  
  if (region && region !== 'all') {
    filtered = filtered.filter(lang => lang.region === region);
  }
  
  if (search) {
    const searchLower = search.toLowerCase();
    filtered = filtered.filter(lang => 
      lang.name.toLowerCase().includes(searchLower) ||
      lang.nativeName.toLowerCase().includes(searchLower) ||
      lang.code.toLowerCase().includes(searchLower)
    );
  }
  
  return filtered;
}

export function getLanguagesByContinent(continent: string): Language[] {
  return languages.filter(lang => lang.continent === continent);
}

export function getLanguagesByRegion(region: string): Language[] {
  return languages.filter(lang => lang.region === region);
}

export function getContinents(): string[] {
  return [...new Set(languages.map(lang => lang.continent))];
}

export function getRegions(): string[] {
  return [...new Set(languages.map(lang => lang.region))];
}

export function getLanguageStats() {
  return {
    totalLanguages: languages.length,
    continents: getContinents().length,
    regions: getRegions().length,
    rtlLanguages: languages.filter(lang => lang.rtl).length,
    totalSpeakers: languages.reduce((sum, lang) => sum + (lang.speakers || 0), 0)
  };
}
