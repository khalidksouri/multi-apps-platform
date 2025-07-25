'use client';

import { useState } from 'react';
import { Globe } from 'lucide-react';
import { UNIVERSAL_LANGUAGES, CONTINENTS } from '@/lib/i18n/languages';

interface RegionSelectorProps {
  onLanguageSelect: (languageCode: string) => void;
  selectedLanguage: { code: string; name: string; flag: string };
}

export function RegionSelector({ onLanguageSelect, selectedLanguage }: RegionSelectorProps) {
  const [selectedContinent, setSelectedContinent] = useState<string>('all');
  const [searchTerm, setSearchTerm] = useState('');

  // Filtrer les langues
  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang => {
    const matchesSearch = lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesContinent = selectedContinent === 'all' || lang.continent === selectedContinent;
    
    return matchesSearch && matchesContinent;
  });

  // Grouper par continent - FIX: CONTINENTS est un array de strings
  const groupedLanguages = CONTINENTS.reduce((acc, continent) => {
    acc[continent] = filteredLanguages.filter(lang => lang.continent === continent);
    return acc;
  }, {} as Record<string, typeof UNIVERSAL_LANGUAGES>);

  // Icônes pour les continents
  const continentIcons: Record<string, string> = {
    'Europe': '🇪🇺',
    'Asia': '🌏',
    'North America': '🌎',
    'South America': '🌎',
    'Africa': '🌍',
    'Oceania': '🌏'
  };

  return (
    <div className="w-full max-w-md mx-auto bg-white rounded-lg shadow-lg border border-gray-200">
      {/* Header */}
      <div className="p-4 border-b border-gray-100">
        <div className="flex items-center space-x-2 mb-3">
          <Globe className="w-5 h-5 text-indigo-600" />
          <h3 className="font-semibold text-gray-900">Sélectionner une langue</h3>
        </div>
        
        {/* Barre de recherche */}
        <input
          type="text"
          placeholder="Rechercher une langue..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
        />
      </div>

      {/* Filtres par continent - FIX: continent est maintenant string */}
      <div className="p-3 border-b border-gray-100">
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setSelectedContinent('all')}
            className={`px-3 py-1 text-sm rounded-full transition-colors ${
              selectedContinent === 'all'
                ? 'bg-indigo-100 text-indigo-700'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            Tous
          </button>
          {CONTINENTS.map((continent) => (
            <button
              key={continent}
              onClick={() => setSelectedContinent(continent)}
              className={`px-3 py-1 text-sm rounded-full transition-colors ${
                selectedContinent === continent
                  ? 'bg-indigo-100 text-indigo-700'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {continentIcons[continent]} {continent}
            </button>
          ))}
        </div>
      </div>

      {/* Liste des langues */}
      <div className="max-h-64 overflow-y-auto">
        {Object.entries(groupedLanguages).map(([continent, languages]) => {
          if (languages.length === 0) return null;
          
          return (
            <div key={continent} className="border-b border-gray-100 last:border-b-0">
              {selectedContinent === 'all' && (
                <div className="px-4 py-2 bg-gray-50">
                  <h4 className="text-xs font-semibold text-gray-600 uppercase tracking-wide flex items-center space-x-1">
                    <span>{continentIcons[continent]}</span>
                    <span>{continent}</span>
                  </h4>
                </div>
              )}
              
              <div className="py-1">
                {languages.map((language) => (
                  <button
                    key={language.code}
                    onClick={() => onLanguageSelect(language.code)}
                    className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 ${
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
              </div>
            </div>
          );
        })}
        
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
  );
}
