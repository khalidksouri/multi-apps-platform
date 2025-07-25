'use client';

import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown, Globe } from 'lucide-react';
import { UNIVERSAL_LANGUAGES, CONTINENTS, getLanguagesByContinent } from '@/lib/i18n/languages';
import { detectUserLanguage } from '@/lib/i18n/utils';

interface RegionSelectorProps {
  selectedLanguage: any;
  onLanguageChange: (language: any) => void;
  className?: string;
}

export const RegionSelector: React.FC<RegionSelectorProps> = ({
  selectedLanguage,
  onLanguageChange,
  className = ''
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedContinent, setSelectedContinent] = useState<string>('all');
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

  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang => {
    const matchesSearch = 
      lang.name.toLowerCase().includes(search.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(search.toLowerCase()) ||
      lang.continent.toLowerCase().includes(search.toLowerCase());
    
    const matchesContinent = selectedContinent === 'all' || 
      lang.continent.toLowerCase() === selectedContinent.toLowerCase();
    
    return matchesSearch && matchesContinent;
  });

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
        aria-label="Sélectionner une région et langue"
      >
        <span className="text-xl">{selectedLanguage.flag}</span>
        <div className="text-left">
          <div className="font-medium text-gray-700 text-sm">{selectedLanguage.name}</div>
          <div className="text-xs text-gray-500">{selectedLanguage.continent}</div>
        </div>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-96 bg-white rounded-xl shadow-2xl border border-gray-200 z-50 max-h-[500px] overflow-hidden">
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100">
            <div className="flex items-center space-x-2 mb-3">
              <Globe className="w-5 h-5 text-blue-500" />
              <h3 className="font-semibold text-gray-900">Choisir votre région</h3>
            </div>
            <input
              type="text"
              placeholder="Rechercher une langue ou un pays..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
              autoFocus
            />
          </div>

          {/* Filtres par continent */}
          <div className="p-3 border-b border-gray-100">
            <div className="flex flex-wrap gap-2">
              <button
                onClick={() => setSelectedContinent('all')}
                className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${
                  selectedContinent === 'all' 
                    ? 'bg-blue-100 text-blue-700' 
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                🌍 Tous
              </button>
              {CONTINENTS.map((continent) => (
                <button
                  key={continent.code}
                  onClick={() => setSelectedContinent(continent.name)}
                  className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${
                    selectedContinent.toLowerCase() === continent.name.toLowerCase()
                      ? 'bg-blue-100 text-blue-700' 
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {continent.emoji} {continent.name}
                </button>
              ))}
            </div>
          </div>

          {/* Liste des langues */}
          <div className="max-h-80 overflow-y-auto">
            {filteredLanguages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left ${
                  selectedLanguage.code === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                }`}
              >
                <span className="text-2xl">{language.flag}</span>
                <div className="flex-1">
                  <div className="font-medium">{language.name}</div>
                  <div className="text-sm text-gray-500">{language.nativeName}</div>
                  <div className="text-xs text-gray-400 flex items-center space-x-2">
                    <span>{language.continent}</span>
                    <span>•</span>
                    <span>{language.currency}</span>
                  </div>
                </div>
                {selectedLanguage.code === language.code && (
                  <div className="text-blue-600">✓</div>
                )}
              </button>
            ))}
            
            {filteredLanguages.length === 0 && (
              <div className="px-4 py-8 text-center text-gray-500">
                <Globe className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                <p>Aucune langue trouvée</p>
                <p className="text-sm">Essayez un autre terme de recherche</p>
              </div>
            )}
          </div>

          {/* Footer */}
          <div className="p-3 border-t border-gray-100 bg-gray-50 text-center">
            <p className="text-xs text-gray-500">
              {UNIVERSAL_LANGUAGES.length} langues • {CONTINENTS.length} continents
            </p>
          </div>
        </div>
      )}
    </div>
  );
};
