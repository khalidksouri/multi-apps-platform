'use client';

import { useState, useRef, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { WORLD_LANGUAGES, getLanguagesByRegion, REGIONS } from '@/lib/i18n/languages';

export default function LanguageSelector() {
  const { currentLanguage, setLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);

  const currentLang = WORLD_LANGUAGES.find(l => l.code === currentLanguage) || WORLD_LANGUAGES[0];
  const groupedLanguages = getLanguagesByRegion();

  // Filtrer les langues selon la recherche
  const filteredLanguages = searchTerm 
    ? WORLD_LANGUAGES.filter(lang => 
        lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
      )
    : null;

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchTerm('');
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode);
    setIsOpen(false);
    setSearchTerm('');
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-3 px-4 py-3 bg-white/90 hover:bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all duration-200 transform hover:scale-105"
        data-testid="language-selector"
      >
        <span className="text-xl">{currentLang.flag}</span>
        <span className="font-medium text-gray-700 hidden sm:block">{currentLang.nativeName}</span>
        <svg className={`w-4 h-4 text-gray-500 transition-transform ${isOpen ? 'rotate-180' : ''}`} 
             fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 mt-2 w-80 bg-white border border-gray-200 rounded-xl shadow-xl z-50 max-h-96 overflow-hidden"
          data-testid="language-dropdown"
        >
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100">
            <input
              type="text"
              placeholder="Rechercher une langue..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
            />
          </div>

          {/* Contenu avec scroll visible */}
          <div className="overflow-y-auto max-h-80 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
            {filteredLanguages ? (
              // Résultats de recherche
              <div className="p-2">
                {filteredLanguages.length === 0 ? (
                  <div className="px-4 py-8 text-center text-gray-500">
                    Aucune langue trouvée
                  </div>
                ) : (
                  filteredLanguages.map((language) => (
                    <button
                      key={language.code}
                      onClick={() => handleLanguageSelect(language.code)}
                      className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg text-left hover:bg-gray-50 transition-colors ${
                        currentLanguage === language.code ? 'bg-blue-50 text-blue-700 font-medium' : 'text-gray-700'
                      }`}
                      data-testid={`language-option-${language.code}`}
                    >
                      <span className="text-lg">{language.flag}</span>
                      <div className="flex-1">
                        <div className="font-medium">{language.nativeName}</div>
                        <div className="text-xs text-gray-500">{language.name}</div>
                      </div>
                      {currentLanguage === language.code && (
                        <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                        </svg>
                      )}
                    </button>
                  ))
                )}
              </div>
            ) : (
              // Langues groupées par région
              Object.entries(groupedLanguages).map(([region, languages]) => (
                <div key={region} className="border-b border-gray-100 last:border-b-0">
                  <div className="px-4 py-2 bg-gray-50 border-b border-gray-100">
                    <h3 className="text-xs font-semibold text-gray-600 uppercase tracking-wide flex items-center gap-2">
                      <span>{REGIONS[region as keyof typeof REGIONS]}</span>
                      <span>{region}</span>
                    </h3>
                  </div>
                  <div className="p-2">
                    {languages.map((language) => (
                      <button
                        key={language.code}
                        onClick={() => handleLanguageSelect(language.code)}
                        className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg text-left hover:bg-gray-50 transition-colors ${
                          currentLanguage === language.code ? 'bg-blue-50 text-blue-700 font-medium' : 'text-gray-700'
                        }`}
                        data-testid={`language-option-${language.code}`}
                        data-language={language.code}
                      >
                        <span className="text-lg">{language.flag}</span>
                        <div className="flex-1">
                          <div className="font-medium">{language.nativeName}</div>
                          <div className="text-xs text-gray-500">{language.name}</div>
                        </div>
                        {currentLanguage === language.code && (
                          <svg className="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                            <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                          </svg>
                        )}
                      </button>
                    ))}
                  </div>
                </div>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="p-3 border-t border-gray-100 bg-gray-50 text-center">
            <p className="text-xs text-gray-600">
              ✨ 75+ langues • Support RTL complet
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
