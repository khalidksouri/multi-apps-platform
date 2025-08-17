"use client"

import { useState } from 'react'

export default function LanguageDropdown() {
  const [isOpen, setIsOpen] = useState(false)
  const [currentLang, setCurrentLang] = useState({ name: 'Français', flag: '🇫🇷', code: 'fr' })

  const languages = [
    { name: 'Français', flag: '🇫🇷', code: 'fr' },
    { name: 'English', flag: '🇺🇸', code: 'en' },
    { name: 'Español', flag: '🇪🇸', code: 'es' },
    { name: 'Deutsch', flag: '🇩🇪', code: 'de' },
    { name: 'العربية', flag: '🇸🇦', code: 'ar' }
  ]

  const handleSelect = (lang: typeof currentLang) => {
    setCurrentLang(lang)
    setIsOpen(false)
    console.log('🌍 Langue changée vers:', lang.name)
  }

  return (
    <div className="relative z-50">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-4 py-2 bg-white rounded-lg border border-gray-200 shadow-sm hover:shadow-md transition-all"
        aria-label="Sélectionner la langue"
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium text-sm">{currentLang.name}</span>
        <span className="text-xs text-gray-500">{isOpen ? '▲' : '▼'}</span>
      </button>

      {isOpen && (
        <>
          <div
            className="fixed inset-0 z-40"
            onClick={() => setIsOpen(false)}
          />
          
          <div className="absolute top-full right-0 mt-2 w-64 bg-white border border-gray-200 rounded-lg shadow-xl z-50">
            <div className="p-3 border-b bg-gradient-to-r from-blue-50 to-purple-50">
              <h3 className="font-bold text-gray-800 text-sm">🌍 Math4Child v4.2.0</h3>
              <p className="text-xs text-gray-600 mt-1">200+ langues supportées</p>
            </div>
            
            <div className="max-h-48 overflow-y-auto">
              {languages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => handleSelect(lang)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-blue-50 transition-colors text-left ${
                    currentLang.code === lang.code ? 'bg-blue-100 border-r-2 border-blue-500' : ''
                  }`}
                >
                  <span className="text-lg">{lang.flag}</span>
                  <div>
                    <div className="font-medium text-sm text-gray-800">{lang.name}</div>
                    <div className="text-xs text-gray-500">{lang.code}</div>
                  </div>
                  {currentLang.code === lang.code && (
                    <span className="ml-auto text-blue-500 text-sm">✓</span>
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
