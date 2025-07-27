import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown } from 'lucide-react';
import { LanguageSelectorProps } from '@/types';

export const LanguageSelector: React.FC<LanguageSelectorProps> = ({
  languages,
  selectedLanguage,
  onLanguageChange,
  className = ''
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const filteredLanguages = languages.filter(lang =>
    lang.name.toLowerCase().includes(search.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(search.toLowerCase())
  );

  const handleLanguageSelect = (language: any) => {
    onLanguageChange(language);
    setIsOpen(false);
    setSearch('');
  };

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-4 py-2 rounded-lg border border-gray-200 hover:border-gray-300 bg-white transition-all duration-200 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        aria-label="Sélectionner une langue"
        aria-expanded={isOpen}
      >
        <span className="text-xl" role="img" aria-label={`Drapeau ${selectedLanguage.name}`}>
          {selectedLanguage.flag}
        </span>
        <span className="font-medium text-gray-700">{selectedLanguage.name}</span>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-72 bg-white rounded-xl shadow-2xl border border-gray-200 z-50 max-h-96 overflow-hidden">
          <div className="p-3 border-b border-gray-100">
            <input
              type="text"
              placeholder="Rechercher une langue..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
              autoFocus
            />
          </div>
          <div className="max-h-64 overflow-y-auto">
            {filteredLanguages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left ${
                  selectedLanguage.code === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                }`}
              >
                <span className="text-xl" role="img" aria-label={`Drapeau ${language.name}`}>
                  {language.flag}
                </span>
                <div>
                  <div className="font-medium">{language.name}</div>
                  {language.nativeName !== language.name && (
                    <div className="text-sm text-gray-500">{language.nativeName}</div>
                  )}
                </div>
                {selectedLanguage.code === language.code && (
                  <div className="ml-auto text-blue-600" aria-label="Langue sélectionnée">✓</div>
                )}
              </button>
            ))}
            {filteredLanguages.length === 0 && (
              <div className="px-4 py-3 text-gray-500 text-center">
                Aucune langue trouvée
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
