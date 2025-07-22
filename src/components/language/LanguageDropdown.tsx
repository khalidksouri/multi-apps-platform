'use client'
import { useState, useRef, useEffect } from 'react'
import { ChevronDown, Globe, Search, X } from 'lucide-react'
import { useLanguage } from '../../contexts/LanguageContext'
import { useTranslation } from '../../translations'

interface LanguageDropdownProps {
  className?: string
  enableDirectTyping?: boolean
}

export default function LanguageDropdown({ 
  className = "",
  enableDirectTyping = true
}: LanguageDropdownProps) {
  const { currentLanguage, setLanguage, availableLanguages } = useLanguage()
  const { t } = useTranslation(currentLanguage.code)
  
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  const filteredLanguages = availableLanguages.filter(language => 
    language.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    language.code.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const handleLanguageSelect = (language: any) => {
    setLanguage(language)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!isOpen) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault()
        setIsOpen(true)
      }
      return
    }

    switch (e.key) {
      case 'Escape':
        e.preventDefault()
        setIsOpen(false)
        setSearchTerm('')
        break
        
      case 'ArrowDown':
        e.preventDefault()
        setFocusedIndex(prev => 
          prev < filteredLanguages.length - 1 ? prev + 1 : 0
        )
        break
        
      case 'ArrowUp':
        e.preventDefault()
        setFocusedIndex(prev => 
          prev > 0 ? prev - 1 : filteredLanguages.length - 1
        )
        break
        
      case 'Enter':
        e.preventDefault()
        if (focusedIndex >= 0 && filteredLanguages[focusedIndex]) {
          handleLanguageSelect(filteredLanguages[focusedIndex])
        }
        break
    }
  }

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        className="w-full bg-white/20 backdrop-blur-sm border border-white/30 rounded-2xl px-4 py-3 flex items-center justify-between text-white hover:bg-white/25 transition-all duration-200 shadow-lg"
        data-testid="language-dropdown-button"
        aria-label={t('language.select')}
        aria-expanded={isOpen}
      >
        <div className="flex items-center space-x-3">
          <span className="text-xl">{currentLanguage.flag}</span>
          <span className="font-medium">{currentLanguage.name}</span>
        </div>
        <ChevronDown className={`w-5 h-5 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden z-50"
          data-testid="language-dropdown-menu"
        >
          <div className="p-4 border-b border-gray-100 bg-gray-50">
            <div className="flex items-center space-x-2 text-gray-700 mb-3">
              <Globe className="w-5 h-5" />
              <span className="font-semibold">{t('language.select')}</span>
              <span className="text-sm text-gray-500">
                ({filteredLanguages.length} {t('language.available')})
              </span>
            </div>
            
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                ref={searchInputRef}
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={t('language.search')}
                className="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
          </div>

          <div className="p-2 max-h-80 overflow-y-auto">
            {filteredLanguages.map((language, index) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language)}
                className={`w-full flex items-center space-x-3 px-4 py-3 rounded-xl transition-colors text-left ${
                  currentLanguage.code === language.code 
                    ? 'bg-blue-50 border-2 border-blue-200' 
                    : focusedIndex === index
                    ? 'bg-gray-100 border-2 border-gray-300'
                    : 'border-2 border-transparent hover:bg-gray-50'
                }`}
                data-testid={`language-option-${language.code}`}
                dir={language.rtl ? 'rtl' : 'ltr'}
              >
                <span className="text-xl">{language.flag}</span>
                <div className="flex-1">
                  <div className="font-medium text-gray-900">{language.name}</div>
                  <div className="text-sm text-gray-500">{language.code.toUpperCase()}</div>
                </div>
                {currentLanguage.code === language.code && (
                  <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                )}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
