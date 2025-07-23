'use client'

import React, { useState, useRef, useEffect } from 'react'
import { ChevronDown, Globe, Search } from 'lucide-react'
import { useLanguage } from '../../contexts/LanguageContext'

interface LanguageOption {
  code: string
  name: string
  nativeName: string
  flag: string
  keywords?: string[]
}

interface LanguageDropdownProps {
  className?: string
  showSearch?: boolean
  maxHeight?: string
}

const EXTENDED_LANGUAGES: LanguageOption[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', keywords: ['french', 'france'] },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', keywords: ['english', 'usa', 'america'] },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', keywords: ['spanish', 'spain', 'espanol'] },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', keywords: ['german', 'germany', 'allemand'] },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', keywords: ['italian', 'italy', 'italien'] },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', keywords: ['portuguese', 'portugal', 'brasil'] },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', keywords: ['russian', 'russia', 'russe'] },
  { code: 'zh', name: '中文', nativeName: '中文简体', flag: '🇨🇳', keywords: ['chinese', 'china', 'chinois'] },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', keywords: ['japanese', 'japan', 'japonais'] },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', keywords: ['arabic', 'arab', 'arabe'] },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', keywords: ['hindi', 'india', 'indien'] },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', keywords: ['korean', 'korea', 'coreen'] }
]

export default function LanguageDropdown({ 
  className = '', 
  showSearch = true, 
  maxHeight = '300px' 
}: LanguageDropdownProps) {
  const { currentLanguage, changeLanguage, t } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [filteredLanguages, setFilteredLanguages] = useState(EXTENDED_LANGUAGES)
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  // Trouve la langue actuelle
  const currentLang = EXTENDED_LANGUAGES.find(lang => lang.code === currentLanguage) || EXTENDED_LANGUAGES[0]

  // Filtrage des langues
  useEffect(() => {
    if (!searchTerm.trim()) {
      setFilteredLanguages(EXTENDED_LANGUAGES)
      return
    }

    const filtered = EXTENDED_LANGUAGES.filter(lang => {
      const searchLower = searchTerm.toLowerCase()
      return (
        lang.name.toLowerCase().includes(searchLower) ||
        lang.nativeName.toLowerCase().includes(searchLower) ||
        lang.code.toLowerCase().includes(searchLower) ||
        (lang.keywords && lang.keywords.some(keyword => keyword.includes(searchLower)))
      )
    })
    
    setFilteredLanguages(filtered)
  }, [searchTerm])

  // Fermer le dropdown si clic à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Focus automatique sur la recherche
  useEffect(() => {
    if (isOpen && showSearch && searchInputRef.current) {
      setTimeout(() => {
        searchInputRef.current?.focus()
      }, 100)
    }
  }, [isOpen, showSearch])

  // Gestion de la sélection de langue
  const handleLanguageSelect = (language: LanguageOption) => {
    changeLanguage(language.code)
    setIsOpen(false)
    setSearchTerm('')
    
    // Dispatch custom event pour tests
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent('languageChanged', { 
        detail: { language: language.code, name: language.name }
      }))
    }
  }

  // Gestion des touches clavier
  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === 'Escape') {
      setIsOpen(false)
      setSearchTerm('')
    } else if (event.key === 'Enter' && filteredLanguages.length === 1) {
      handleLanguageSelect(filteredLanguages[0])
    }
  }

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"
        aria-expanded={isOpen}
        aria-haspopup="listbox"
        data-testid="language-selector"
      >
        <Globe size={16} className="text-gray-500" />
        <span className="text-lg">{currentLang.flag}</span>
        <span className="text-sm font-medium text-gray-700">
          {currentLang.name}
        </span>
        <ChevronDown 
          size={16} 
          className={`text-gray-500 transform transition-transform ${isOpen ? 'rotate-180' : ''}`}
        />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div 
          className="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg z-50"
          style={{ maxHeight }}
        >
          {/* Barre de recherche */}
          {showSearch && (
            <div className="p-3 border-b border-gray-200">
              <div className="relative">
                <Search size={16} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  onKeyDown={handleKeyDown}
                  placeholder={t('language.search', 'Rechercher une langue...')}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
                  data-testid="language-search"
                />
              </div>
            </div>
          )}

          {/* Liste des langues */}
          <div className="max-h-60 overflow-y-auto">
            {filteredLanguages.length > 0 ? (
              filteredLanguages.map((language) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left hover:bg-blue-50 focus:bg-blue-50 focus:outline-none transition-colors ${
                    currentLanguage === language.code 
                      ? 'bg-blue-100 text-blue-700 font-medium' 
                      : 'text-gray-700'
                  }`}
                  data-testid={`language-${language.code}`}
                >
                  <span className="text-xl">{language.flag}</span>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-medium truncate">
                      {language.name}
                    </div>
                    <div className="text-xs text-gray-500 truncate">
                      {language.nativeName}
                    </div>
                  </div>
                  {currentLanguage === language.code && (
                    <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                  )}
                </button>
              ))
            ) : (
              <div className="px-4 py-8 text-center text-gray-500">
                <Globe size={24} className="mx-auto mb-2 opacity-50" />
                <p className="text-sm">{t('language.noResults', 'Aucune langue trouvée')}</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
