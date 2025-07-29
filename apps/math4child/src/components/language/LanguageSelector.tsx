'use client';

import { useState, useRef, useEffect } from 'react';
import { ChevronDown, Globe, X } from 'lucide-react';
import { useLanguage, SUPPORTED_LANGUAGES } from '@/hooks/useLanguage';

export default function LanguageSelector() {
  const { currentLanguage, setLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Fermer le dropdown en cliquant dehors
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchTerm('');
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Filtrer les langues selon la recherche
  const filteredLanguages = SUPPORTED_LANGUAGES.filter(lang =>
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.code.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleLanguageSelect = (language: typeof SUPPORTED_LANGUAGES[0]) => {
    setLanguage(language);
    setIsOpen(false);
    setSearchTerm('');
  };

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton de sélection */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 bg-white border border-gray-300 rounded-lg px-4 py-2 hover:border-blue-500 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
      >
        <Globe size={16} className="text-gray-600" />
        <span className="text-lg">{currentLanguage.flag}</span>
        <span className="font-medium text-gray-700">{currentLanguage.nativeName}</span>
        <ChevronDown 
          size={16} 
          className={`text-gray-600 transition-transform ${isOpen ? 'rotate-180' : ''}`} 
        />
      </button>

      {/* Dropdown premium */}
      {isOpen && (
        <div className="absolute top-full left-0 mt-1 w-80 bg-white border border-gray-300 rounded-lg shadow-lg z-50 max-h-96 overflow-hidden">
          {/* Header avec recherche */}
          <div className="p-3 border-b border-gray-200 bg-gray-50">
            <div className="flex items-center justify-between mb-2">
              <h3 className="font-semibold text-gray-800">75+ Langues Disponibles</h3>
              <button
                onClick={() => setIsOpen(false)}
                className="text-gray-500 hover:text-gray-700"
              >
                <X size={16} />
              </button>
            </div>
            
            <div className="relative">
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                autoFocus
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X size={14} />
                </button>
              )}
            </div>
          </div>

          {/* Liste des langues avec scroll visible */}
          <div className="overflow-y-auto max-h-64" style={{ scrollbarWidth: 'thin' }}>
            {filteredLanguages.length > 0 ? (
              <div className="py-1">
                {filteredLanguages.map((language) => (
                  <button
                    key={language.code}
                    onClick={() => handleLanguageSelect(language)}
                    className={`w-full px-4 py-3 text-left hover:bg-blue-50 flex items-center space-x-3 transition-colors ${
                      currentLanguage.code === language.code 
                        ? 'bg-blue-100 border-r-2 border-blue-500' 
                        : ''
                    }`}
                  >
                    <span className="text-xl">{language.flag}</span>
                    <div className="flex-1">
                      <div className="font-medium text-gray-900">{language.nativeName}</div>
                      <div className="text-sm text-gray-600">{language.name}</div>
                    </div>
                    {currentLanguage.code === language.code && (
                      <div className="text-blue-600 font-bold text-sm">✓</div>
                    )}
                  </button>
                ))}
              </div>
            ) : (
              <div className="px-4 py-8 text-center text-gray-500">
                <Globe size={32} className="mx-auto mb-2 text-gray-400" />
                <p>Aucune langue trouvée</p>
                <p className="text-sm">Essayez un autre terme de recherche</p>
              </div>
            )}
          </div>

          {/* Footer */}
          <div className="p-3 border-t border-gray-200 bg-gray-50">
            <p className="text-xs text-gray-600 text-center">
              Scroll pour voir plus de langues • Support RTL inclus
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
