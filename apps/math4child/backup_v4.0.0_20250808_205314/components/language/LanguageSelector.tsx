"use client"

import { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'

const LANGUAGES = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦' },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵' },
]

export function LanguageSelector() {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  
  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]
  
  const handleLanguageSelect = (languageCode: string) => {
    setLanguage(languageCode as any)
    setIsOpen(false)
  }
  
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 rounded-lg border border-gray-200 hover:border-blue-300 bg-white transition-all duration-200"
        type="button"
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium text-sm hidden sm:inline">{currentLang.nativeName}</span>
        <span className="text-xs">▼</span>
      </button>
      
      {isOpen && (
        <>
          <div 
            className="fixed inset-0 z-10" 
            onClick={() => setIsOpen(false)}
          />
          <div className="absolute top-full right-0 mt-2 w-48 bg-white border border-gray-200 rounded-lg shadow-xl z-20">
            <div className="py-1">
              {LANGUAGES.map((language) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language.code)}
                  className={`w-full flex items-center gap-3 px-3 py-2 hover:bg-gray-50 transition-colors text-left ${
                    currentLanguage === language.code ? 'bg-blue-50 text-blue-700' : 'text-gray-700'
                  }`}
                  type="button"
                >
                  <span className="text-lg">{language.flag}</span>
                  <div className="flex-1">
                    <div className="font-medium text-sm">{language.nativeName}</div>
                    <div className="text-xs text-gray-500">{language.name}</div>
                  </div>
                  {currentLanguage === language.code && (
                    <span className="text-blue-600 text-sm">✓</span>
                  )}
                </button>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  )
}
