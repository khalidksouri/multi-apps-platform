'use client'

import { useState, useRef, useEffect } from 'react'
import { ChevronDown, Globe, Search, X } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', rtl: true },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷' },
  // ... plus de langues selon vos besoins
]

interface LanguageDropdownProps {
  enableSearch?: boolean
  enableDirectTyping?: boolean
  showNativeNames?: boolean
  className?: string
  onLanguageChange?: (language: Language) => void
}

export default function LanguageDropdown({ 
  enableSearch = true,
  enableDirectTyping = true,
  showNativeNames = true,
  className = '',
  onLanguageChange
}: LanguageDropdownProps) {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  // Filtrer les langues selon le terme de recherche
  const filteredLanguages = LANGUAGES.filter(lang => 
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.code.toLowerCase().includes(searchTerm.toLowerCase())
  )

  // Gestion des clics extérieurs
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
        setFocusedIndex(-1)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Focus automatique sur l'input de recherche
  useEffect(() => {
    if (isOpen && enableSearch && searchInputRef.current) {
      searchInputRef.current.focus()
    }
  }, [isOpen, enableSearch])

  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    onLanguageChange?.(language)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
  }

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage.code) || LANGUAGES[0]

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between px-4 py-3 bg-white/20 backdrop-blur-sm rounded-lg border border-white/30 text-white hover:bg-white/25 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-white/50"
        data-testid="language-dropdown-button"
        aria-haspopup="listbox"
        aria-expanded={isOpen}
      >
        <div className="flex items-center space-x-3">
          <Globe size={20} />
          <span className="text-2xl">{currentLang.flag}</span>
          <span className="font-medium">
            {showNativeNames ? currentLang.nativeName : currentLang.name}
          </span>
        </div>
        <ChevronDown 
          size={20} 
          className={`transform transition-transform duration-200 ${
            isOpen ? 'rotate-180' : ''
          }`} 
        />
      </button>

      {/* Menu déroulant */}
      {isOpen && (
        <div 
          className="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-xl border border-gray-200 z-50 max-h-80 overflow-hidden"
          data-testid="language-dropdown-menu"
          role="listbox"
        >
          {/* Barre de recherche */}
          {enableSearch && (
            <div className="p-3 border-b border-gray-200">
              <div className="relative">
                <Search size={16} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Tapez pour rechercher..."
                  className="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  data-testid="language-search-input"
                />
                {searchTerm && (
                  <button
                    onClick={() => setSearchTerm('')}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                    data-testid="clear-search-button"
                  >
                    <X size={16} />
                  </button>
                )}
              </div>
            </div>
          )}

          {/* Liste des langues */}
          <div className="max-h-60 overflow-y-auto">
            {filteredLanguages.length > 0 ? (
              filteredLanguages.map((language, index) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left hover:bg-gray-50 transition-colors duration-150 ${
                    currentLang.code === language.code 
                      ? 'bg-blue-100 text-blue-900 font-medium' 
                      : 'text-gray-700'
                  } ${language.rtl ? 'flex-row-reverse text-right' : ''}`}
                  role="option"
                  aria-selected={currentLang.code === language.code}
                  data-testid={`language-option-${language.code}`}
                >
                  <span className="text-xl">{language.flag}</span>
                  <div className="flex-1">
                    <div className="font-medium">
                      {showNativeNames ? language.nativeName : language.name}
                    </div>
                    {showNativeNames && language.name !== language.nativeName && (
                      <div className="text-sm text-gray-500">{language.name}</div>
                    )}
                  </div>
                  {currentLang.code === language.code && (
                    <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                  )}
                </button>
              ))
            ) : (
              <div className="px-4 py-8 text-center text-gray-500">
                <Search size={24} className="mx-auto mb-2 opacity-50" />
                <p>Aucune langue trouvée</p>
                <p className="text-sm">Essayez un autre terme de recherche</p>
              </div>
            )}
          </div>

          {/* Footer avec compteur */}
          <div className="px-4 py-2 bg-gray-50 border-t border-gray-200 text-sm text-gray-500 text-center">
            {filteredLanguages.length} langue{filteredLanguages.length > 1 ? 's' : ''} disponible{filteredLanguages.length > 1 ? 's' : ''}
          </div>
        </div>
      )}
    </div>
  )
}
