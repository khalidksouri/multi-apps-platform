'use client'

import React, { useState } from 'react'
import type { Language } from '@/types'

interface LanguageSelectorProps {
  onLanguageChange: (language: Language) => void;
  defaultLanguage: string;
}

function LanguageSelector({ onLanguageChange, defaultLanguage }: LanguageSelectorProps) {
  const [selectedLanguage, setSelectedLanguage] = useState(defaultLanguage);
  
  const languages: Language[] = [
    { code: 'fr-FR', name: 'Français', nativeName: 'Français' },
    { code: 'en-US', name: 'English', nativeName: 'English' },
    { code: 'es-ES', name: 'Español', nativeName: 'Español' },
    { code: 'de-DE', name: 'Deutsch', nativeName: 'Deutsch' }
  ];

  const handleChange = (languageCode: string) => {
    const language = languages.find(lang => lang.code === languageCode);
    if (language) {
      setSelectedLanguage(languageCode);
      onLanguageChange(language);
    }
  };

  return (
    <select 
      value={selectedLanguage}
      onChange={(e) => handleChange(e.target.value)}
      className="border border-gray-300 rounded px-3 py-2"
    >
      {languages.map(lang => (
        <option key={lang.code} value={lang.code}>
          {lang.nativeName}
        </option>
      ))}
    </select>
  );
}

export default function LanguageDemo() {
  const [currentLanguage, setCurrentLanguage] = useState<Language>({
    code: 'fr-FR',
    name: 'Français', 
    nativeName: 'Français'
  });

  const handleLanguageChange = (language: Language) => {
    setCurrentLanguage(language);
  };

  return (
    <div className="language-demo p-6 bg-white rounded-lg shadow-lg">
      <h2 className="text-2xl font-bold mb-4">🌍 Démo Sélecteur de Langues</h2>
      
      <div className="mb-4">
        <label className="block text-sm font-medium mb-2">Choisir une langue:</label>
        <LanguageSelector
          onLanguageChange={handleLanguageChange}
          defaultLanguage={currentLanguage.code}
        />
      </div>
      
      <div className="bg-gray-50 p-4 rounded">
        <h3 className="font-bold">Langue sélectionnée:</h3>
        <p>Code: {currentLanguage.code}</p>
        <p>Nom: {currentLanguage.name}</p>
        <p>Nom natif: {currentLanguage.nativeName}</p>
      </div>
    </div>
  );
}
