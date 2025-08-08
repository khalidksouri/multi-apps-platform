export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  continent?: string;
  region?: string;
  rtl?: boolean;
}

export const languages: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', region: 'Western Europe' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', region: 'Western Europe' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', region: 'Southern Europe' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', region: 'Western Europe' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', region: 'Southern Europe' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦', continent: 'Africa', region: 'North Africa', rtl: true },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', continent: 'Asia', region: 'East Asia' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', region: 'East Asia' },
]

export default languages
