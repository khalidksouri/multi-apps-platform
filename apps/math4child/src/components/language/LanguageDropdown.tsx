'use client'

import { useState, useRef, useEffect } from 'react'
import { ChevronDown, Globe } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
}

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦' },
]

export default function LanguageDropdown() {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)
  const buttonRef = useRef<HTMLButtonElement>(null)

  // Fermer le dropdown si on clique à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
      // Désactiver le scroll du body quand le dropdown est ouvert
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'unset'
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'unset'
    }
  }, [isOpen])

  // Fermer le dropdown avec Escape
  useEffect(() => {
    function handleEscape(event: KeyboardEvent) {
      if (event.key === 'Escape') {
        setIsOpen(false)
      }
    }

    if (isOpen) {
      document.addEventListener('keydown', handleEscape)
    }

    return () => {
      document.removeEventListener('keydown', handleEscape)
    }
  }, [isOpen])

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]

  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    setIsOpen(false)
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton trigger */}
      <button
        ref={buttonRef}
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20"
        aria-expanded={isOpen}
        aria-haspopup="listbox"
        aria-label="Sélectionner une langue"
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium">{currentLang.name}</span>
        <ChevronDown 
          className={`w-4 h-4 transition-transform duration-200 ${
            isOpen ? 'rotate-180' : ''
          }`} 
        />
      </button>

      {/* Overlay pour fermer le dropdown */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={() => setIsOpen(false)}
        />
      )}

      {/* Dropdown menu */}
      {isOpen && (
        <div className="fixed inset-x-4 top-1/2 -translate-y-1/2 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:translate-x-0 md:w-80">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden max-h-[70vh] md:max-h-96">
            {/* Header */}
            <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700">
                <Globe className="w-5 h-5" />
                <h3 className="font-semibold">Sélectionner une langue</h3>
              </div>
            </div>

            {/* Liste des langues */}
            <div className="max-h-80 overflow-y-auto">
              {LANGUAGES.map((language) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language)}
                  className={`w-full px-4 py-3 text-left hover:bg-blue-50 transition-colors duration-150 flex items-center gap-3 ${
                    language.code === currentLanguage 
                      ? 'bg-blue-100 border-l-4 border-blue-500' 
                      : 'border-l-4 border-transparent'
                  }`}
                  role="option"
                  aria-selected={language.code === currentLanguage}
                >
                  <span className="text-2xl">{language.flag}</span>
                  <div className="flex-1 min-w-0">
                    <div className="font-medium text-gray-900">
                      {language.name}
                    </div>
                    <div className="text-sm text-gray-500 truncate">
                      {language.nativeName}
                    </div>
                  </div>
                  {language.code === currentLanguage && (
                    <div className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0" />
                  )}
                </button>
              ))}
            </div>

            {/* Footer */}
            <div className="px-4 py-2 bg-gray-50 border-t border-gray-200">
              <p className="text-xs text-gray-500 text-center">
                100k+ familles utilisent Math4Child
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
