import React from 'react';
import { useLanguage } from '../hooks/useLanguage';

const languages = [
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'pt', name: 'Português', flag: '🇧🇷' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
];

interface LanguageSelectorProps {
  className?: string;
}

const LanguageSelector: React.FC<LanguageSelectorProps> = ({ className = '' }) => {
  const { changeLanguage, currentLanguage } = useLanguage();

  return (
    <div className={`relative ${className}`}>
      <select
        value={currentLanguage}
        onChange={(e) => changeLanguage(e.target.value)}
        className="bg-white/20 text-white border border-white/30 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-white/50"
      >
        {languages.map((lang) => (
          <option key={lang.code} value={lang.code} className="text-gray-800">
            {lang.flag} {lang.name}
          </option>
        ))}
      </select>
    </div>
  );
};

export default LanguageSelector;
