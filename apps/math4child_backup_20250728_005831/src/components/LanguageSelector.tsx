'use client';

import { useState, useRef, useEffect } from 'react';

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

interface LanguageSelectorProps {
  languages: Language[];
  currentLanguage: Language;
  onLanguageChange: (language: Language) => void;
}

export default function LanguageSelector({ 
  languages, 
  currentLanguage, 
  onLanguageChange 
}: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Fermer le dropdown quand on clique ailleurs
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleLanguageSelect = (language: Language) => {
    console.log('🌍 Langue sélectionnée:', language);
    onLanguageChange(language);
    setIsOpen(false);
  };

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
  };

  return (
    <div className="language-selector" ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={toggleDropdown}
        className="language-button"
        aria-label="Sélectionner une langue"
        aria-expanded={isOpen}
      >
        <div className="flex items-center gap-2">
          <span className="language-flag">{currentLanguage.flag}</span>
          <span className="language-name">{currentLanguage.nativeName}</span>
        </div>
        <svg 
          className={`dropdown-arrow ${isOpen ? 'open' : ''}`}
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* Dropdown menu */}
      {isOpen && (
        <div className="language-dropdown">
          {languages.map((language) => (
            <button
              key={language.code}
              onClick={() => handleLanguageSelect(language)}
              className="language-option"
              aria-label={`Changer vers ${language.nativeName}`}
            >
              <span className="language-option-flag">{language.flag}</span>
              <div className="language-option-text">
                <div className="language-option-native">{language.nativeName}</div>
                <div className="language-option-english">{language.name}</div>
              </div>
              {currentLanguage.code === language.code && (
                <span className="text-blue-500">✓</span>
              )}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
