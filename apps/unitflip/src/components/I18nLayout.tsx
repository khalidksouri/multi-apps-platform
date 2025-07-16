'use client';

import React, { useEffect, useState } from 'react';
import { useUniversalI18n, LanguageSelector } from '../hooks/useUniversalI18n';

interface I18nLayoutProps {
  children: React.ReactNode;
  showLanguageSelector?: boolean;
}

export const I18nLayout: React.FC<I18nLayoutProps> = ({ 
  children, 
  showLanguageSelector = true 
}) => {
  const { currentLanguage, isRTL } = useUniversalI18n();
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) {
    return <div className="min-h-screen bg-gray-100 animate-pulse" />;
  }

  return (
    <div 
      className={`min-h-screen ${isRTL ? 'rtl' : 'ltr'}`}
      dir={isRTL ? 'rtl' : 'ltr'}
      lang={currentLanguage.code}
    >
      {showLanguageSelector && (
        <div className="fixed top-4 right-4 z-50">
          <LanguageSelector 
            className="bg-white shadow-lg border border-gray-300 rounded-lg px-3 py-2 text-sm font-medium hover:shadow-xl transition-shadow"
            onChange={(language) => {
              console.log(`🌍 Langue changée vers ${language.nativeName}`);
            }}
          />
        </div>
      )}

      <main className="relative">
        {children}
      </main>

      <div className="fixed bottom-2 left-2 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-xs font-mono z-40">
        {currentLanguage.flag} {currentLanguage.code}
      </div>
    </div>
  );
};
