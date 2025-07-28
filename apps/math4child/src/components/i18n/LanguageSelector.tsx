'use client';

import React, { useState } from 'react';
import { useTranslation } from '@/hooks/useTranslation';
import { SUPPORTED_LANGUAGES } from '@/lib/constants/languages';

export function LanguageSelector() {
  const { currentLanguage, setLanguage } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);

  const currentLang = SUPPORTED_LANGUAGES.find(lang => lang.code === currentLanguage);

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-3 py-2 rounded-lg border border-gray-300 bg-white hover:bg-gray-50"
        data-testid="language-selector"
      >
        <span className="text-lg">{currentLang?.flag || '🌍'}</span>
        <span className="hidden sm:inline">{currentLang?.name || 'Français'}</span>
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border z-50">
          <div className="p-2">
            {SUPPORTED_LANGUAGES.map((language) => (
              <button
                key={language.code}
                onClick={() => {
                  setLanguage(language.code);
                  setIsOpen(false);
                }}
                className={`w-full flex items-center space-x-3 px-3 py-2 rounded hover:bg-gray-100 ${
                  currentLanguage === language.code ? 'bg-blue-50' : ''
                }`}
                data-testid={`language-${language.code}`}
              >
                <span className="text-lg">{language.flag}</span>
                <div className="text-left">
                  <div className="font-medium">{language.name}</div>
                  <div className="text-sm text-gray-500">{language.nativeName}</div>
                </div>
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
