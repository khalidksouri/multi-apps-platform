"use client"

import { useState, useRef, useEffect } from 'react'
import { useLanguage } from '@/hooks/useLanguage'

export function LanguageSelector() {
  const { currentLanguage, setLanguage, supportedLanguages } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)
  
  const currentLang = supportedLanguages.find(lang => lang.code === currentLanguage) || supportedLanguages[0]
  
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    
    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
    }
    
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [isOpen])
  
  const handleLanguageSelect = (languageCode: string) => {
    setLanguage(languageCode as any)
    setIsOpen(false)
  }
  
  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 rounded-lg border border-gray-200 hover:border-blue-300 bg-white transition-all duration-200 shadow-sm hover:shadow-md min-w-[140px]"
      >
        <span className="text-lg">{currentLang.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-medium text-sm text-gray-700">
            {currentLang.nativeName}
          </div>
          <div className="text-xs text-gray-500 truncate">
            {currentLang.region}
          </div>
        </div>
        <svg 
          className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      
      {isOpen && (
        <div className="absolute top-full left-0 mt-1 w-full min-w-[320px] bg-white border border-gray-200 rounded-lg shadow-xl z-50 max-h-96 overflow-hidden">
          <div className="px-3 py-3 border-b border-gray-100 bg-gray-50 rounded-t-lg">
            <div className="flex items-center gap-2 mb-3">
              <span className="text-lg">🌍</span>
              <span className="font-medium text-gray-700">
                Choisir une langue ({supportedLanguages.length}+ langues)
              </span>
            </div>
          </div>
          
          <div className="py-1 max-h-64 overflow-y-auto">
            {supportedLanguages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language.code)}
                className={`w-full flex items-center gap-3 px-3 py-2 text-left hover:bg-blue-50 transition-colors duration-150 ${
                  currentLanguage === language.code 
                    ? 'bg-blue-50 text-blue-700 border-r-2 border-blue-500' 
                    : 'text-gray-700 hover:text-blue-600'
                }`}
              >
                <span className="text-lg flex-shrink-0">{language.flag}</span>
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-sm truncate">
                    {language.nativeName}
                    {language.rtl && <span className="ml-1 text-xs text-blue-500">RTL</span>}
                  </div>
                  <div className="text-xs text-gray-500 truncate">
                    {language.name} • {language.region}
                  </div>
                </div>
                {currentLanguage === language.code && (
                  <svg className="w-4 h-4 text-blue-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                )}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
