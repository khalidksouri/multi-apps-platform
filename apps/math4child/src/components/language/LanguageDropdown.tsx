'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Globe, Search, X, Check } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  region: string
  popular?: boolean
}

const LANGUAGES: Language[] = [
  // Langues populaires
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', popular: true },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Amérique', popular: true },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', popular: true },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', popular: true },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', popular: true },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', popular: true },
  
  // Autres langues
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  { code: 'zh', name: '中文 (简体)', nativeName: '中文', flag: '🇨🇳', region: 'Asie' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Moyen-Orient' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe' },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe' },
]

export default function AdvancedLanguageDropdown() {
  const { currentLanguage, setLanguage } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedIndex, setSelectedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([])

  // Filtrage et tri des langues
  const filteredLanguages = useMemo(() => {
    let filtered = LANGUAGES.filter(lang => 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    )
    
    return filtered.sort((a, b) => {
      if (a.popular && !b.popular) return -1
      if (!a.popular && b.popular) return 1
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm])

  const closeDropdown = () => {
    setIsOpen(false)
    setSearchTerm('')
    setSelectedIndex(-1)
  }

  // Clic à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        closeDropdown()
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = 'unset'
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
      document.body.style.overflow = 'unset'
    }
  }, [isOpen])

  // Focus sur la recherche
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100)
    }
  }, [isOpen])

  // Navigation clavier
  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      if (!isOpen) return

      switch (event.key) {
        case 'Escape':
          closeDropdown()
          break
        case 'ArrowDown':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev < filteredLanguages.length - 1 ? prev + 1 : 0
            return newIndex
          })
          break
        case 'ArrowUp':
          event.preventDefault()
          setSelectedIndex(prev => {
            const newIndex = prev > 0 ? prev - 1 : filteredLanguages.length - 1
            return newIndex
          })
          break
        case 'Enter':
          event.preventDefault()
          if (selectedIndex >= 0 && filteredLanguages[selectedIndex]) {
            handleLanguageSelect(filteredLanguages[selectedIndex])
          }
          break
      }
    }

    if (isOpen) {
      document.addEventListener('keydown', handleKeyDown)
    }

    return () => {
      document.removeEventListener('keydown', handleKeyDown)
    }
  }, [isOpen, selectedIndex, filteredLanguages])

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]

  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    closeDropdown()
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton trigger */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-all duration-200 text-white backdrop-blur-sm border border-white/20"
        aria-expanded={isOpen}
      >
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium hidden sm:inline">{currentLang.name}</span>
        <span className="font-medium sm:hidden">{currentLang.code.toUpperCase()}</span>
        <ChevronDown className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/20 backdrop-blur-sm z-40"
          onClick={closeDropdown}
        />
      )}

      {/* Dropdown menu */}
      {isOpen && (
        <div className="fixed inset-x-4 top-4 bottom-4 z-50 md:absolute md:inset-x-auto md:top-full md:left-0 md:translate-y-2 md:w-96 md:max-h-[500px] md:bottom-auto">
          <div className="bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden h-full flex flex-col">
            
            {/* Header */}
            <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
              <div className="flex items-center gap-2 text-gray-700 mb-3">
                <Globe className="w-5 h-5" />
                <h3 className="font-semibold">Choisir une langue</h3>
                <button onClick={closeDropdown} className="ml-auto p-1 hover:bg-gray-200 rounded-full">
                  <X className="w-4 h-4" />
                </button>
              </div>
              
              {/* Recherche */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Rechercher une langue..."
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>

            {/* Liste des langues */}
            <div className="flex-1 overflow-y-auto">
              {filteredLanguages.length === 0 ? (
                <div className="p-4 text-center text-gray-500">
                  <Search className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                  <p>Aucune langue trouvée</p>
                </div>
              ) : (
                filteredLanguages.map((language, index) => {
                  const isSelected = index === selectedIndex
                  const isCurrent = language.code === currentLanguage
                  
                  return (
                    <button
                      key={language.code}
                      ref={(el) => { itemRefs.current[index] = el }}
                      onClick={() => handleLanguageSelect(language)}
                      className={`w-full px-4 py-3 text-left transition-all flex items-center gap-3 ${
                        isCurrent 
                          ? 'bg-blue-100 border-l-4 border-blue-500' 
                          : isSelected
                          ? 'bg-blue-50 border-l-4 border-blue-300'
                          : 'border-l-4 border-transparent hover:bg-gray-50'
                      }`}
                    >
                      <span className="text-2xl">{language.flag}</span>
                      <div className="flex-1 min-w-0">
                        <div className={`font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'} flex items-center gap-2`}>
                          {language.name}
                          {language.popular && (
                            <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full">
                              Populaire
                            </span>
                          )}
                        </div>
                        <div className={`text-sm ${isCurrent ? 'text-blue-700' : 'text-gray-500'}`}>
                          {language.nativeName}
                        </div>
                      </div>
                      {isCurrent && <Check className="w-5 h-5 text-blue-500" />}
                    </button>
                  )
                })
              )}
            </div>

            {/* Footer */}
            <div className="px-4 py-2 bg-gray-50 border-t border-gray-200">
              <div className="flex justify-between items-center text-xs text-gray-500">
                <span>{filteredLanguages.length} langues disponibles</span>
                <span>100k+ familles</span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
