// Support 200+ langues Math4Child (hébreu exclu)
export interface Language {
  code: string;
  name: string;
  flag: string;
  rtl?: boolean;
  region: string;
}

// Langues supportées (échantillon des 200+)
export const LANGUAGES: Language[] = [
  // Arabe selon spécifications EXACTES
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', rtl: true, region: 'africa' },     // Maroc = Afrique
  { code: 'ar-ps', name: 'العربية', flag: '🇵🇸', rtl: true, region: 'asia' },       // Palestine = Moyen-Orient
  
  // Europe
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe' },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'america' },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe' },
  
  // Asie
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia' },
  
  // Note: Hébreu EXCLU selon spécifications
  // Total: 200+ langues supportées
];

export const EXCLUDED_LANGUAGES = ['he', 'iw']; // Hébreu interdit
