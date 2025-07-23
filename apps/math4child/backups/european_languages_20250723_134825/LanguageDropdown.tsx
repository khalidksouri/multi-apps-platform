'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { useLanguage } from '@/contexts/LanguageContext'
import { ChevronDown, Search, X, Globe } from 'lucide-react'

interface Language {
  code: string
  name: string
  flag: string
  nativeName?: string
  searchTerms?: string[]
}

export default function AdvancedLanguageDropdown() {
  const { currentLanguage, setLanguage, t } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  const languages: Language[] = [
    { 
      code: 'fr', 
      name: 'Français', 
      flag: '🇫🇷', 
      nativeName: 'Français',
      searchTerms: ['français', 'french', 'fra', 'fr']
    },
    { 
      code: 'en', 
      name: 'English', 
      flag: '🇬🇧', 
      nativeName: 'English',
      searchTerms: ['english', 'anglais', 'eng', 'en']
    },
    { 
      code: 'es', 
      name: 'Español', 
      flag: '🇪🇸', 
      nativeName: 'Español',
      searchTerms: ['español', 'spanish', 'espagnol', 'esp', 'es']
    },
    { 
      code: 'de', 
      name: 'Deutsch', 
      flag: '🇩🇪', 
      nativeName: 'Deutsch',
      searchTerms: ['deutsch', 'german', 'allemand', 'ger', 'de']
    },
    { 
      code: 'it', 
      name: 'Italiano', 
      flag: '🇮🇹', 
      nativeName: 'Italiano',
      searchTerms: ['italiano', 'italian', 'italien', 'ita', 'it']
    },
    { 
      code: 'pt', 
      name: 'Português', 
      flag: '🇵🇹', 
      nativeName: 'Português',
      searchTerms: ['português', 'portuguese', 'portugais', 'por', 'pt']
    },
    { 
      code: 'ar', 
      name: 'العربية', 
      flag: '🇸🇦', 
      nativeName: 'العربية',
      searchTerms: ['العربية', 'arabic', 'arabe', 'ara', 'ar']
    },
    { 
      code: 'zh', 
      name: '中文', 
      flag: '🇨🇳', 
      nativeName: '中文',
      searchTerms: ['中文', 'chinese', 'chinois', 'chi', 'zh', 'mandarin']
    },
    { 
      code: 'ja', 
      name: '日本語', 
      flag: '🇯🇵', 
      nativeName: '日本語',
      searchTerms: ['日本語', 'japanese', 'japonais', 'jpn', 'ja', 'jap']
    },
    { 
      code: 'ko', 
      name: '한국어', 
      flag: '🇰🇷', 
      nativeName: '한국어',
      searchTerms: ['한국어', 'korean', 'coréen', 'kor', 'ko']
    },
    { 
      code: 'ru', 
      name: 'Русский', 
      flag: '🇷🇺', 
      nativeName: 'Русский',
      searchTerms: ['русский', 'russian', 'russe', 'rus', 'ru']
    },
    { 
      code: 'hi', 
      name: 'हिन्दी', 
      flag: '🇮🇳', 
      nativeName: 'हिन्दी',
      searchTerms: ['हिन्दी', 'hindi', 'hin', 'hi']
    }
  ]

  const currentLang = languages.find(lang => lang.code === currentLanguage) || languages[0]

  // Filtrage intelligent avec recherche multi-critères
  const filteredLanguages = useMemo(() => {
    if (!searchTerm.trim()) return languages
    
    const searchLower = searchTerm.toLowerCase().trim()
    
    return languages.filter(language => {
      // Recherche dans les termes de recherche
      const termsMatch = language.searchTerms?.some(term => 
        term.toLowerCase().includes(searchLower)
      )
      
      // Recherche dans le nom et nom natif
      const nameMatch = language.name.toLowerCase().includes(searchLower)
      const nativeMatch = language.nativeName?.toLowerCase().includes(searchLower)
      const codeMatch = language.code.toLowerCase().startsWith(searchLower)
      
      return termsMatch || nameMatch || nativeMatch || codeMatch
    }).sort((a, b) => {
      // Prioriser les correspondances exactes au début
      const aStartsWith = a.name.toLowerCase().startsWith(searchLower) || 
                         a.searchTerms?.some(term => term.toLowerCase().startsWith(searchLower))
      const bStartsWith = b.name.toLowerCase().startsWith(searchLower) || 
                         b.searchTerms?.some(term => term.toLowerCase().startsWith(searchLower))
      
      if (aStartsWith && !bStartsWith) return -1
      if (!aStartsWith && bStartsWith) return 1
      
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm, languages])

  // Navigation clavier
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!isOpen) return

      switch (e.key) {
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
            handleLanguageSelect(filteredLanguages[focusedIndex].code)
          }
          break
        case 'Escape':
          setIsOpen(false)
          setSearchTerm('')
          setFocusedIndex(-1)
          break
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, focusedIndex, filteredLanguages])

  // Focus automatique sur la recherche
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100)
    }
  }, [isOpen])

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
    
    console.log('🌍 Langue sélectionnée:', langCode)
  }

  const clearSearch = () => {
    setSearchTerm('')
    setFocusedIndex(-1)
    searchInputRef.current?.focus()
  }

  // Fermer le dropdown quand on clique ailleurs
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

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton de sélection */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 bg-white/10 backdrop-blur-sm text-white px-4 py-2 rounded-lg border border-white/20 hover:bg-white/20 transition-colors duration-200"
        data-testid="language-dropdown-button"
      >
        <Globe size={16} />
        <span className="text-lg">{currentLang.flag}</span>
        <span className="font-medium">{currentLang.name}</span>
        <ChevronDown 
          size={16} 
          className={`transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} 
        />
      </button>

      {/* Dropdown avancé v2.0 BETA */}
      {isOpen && (
        <div className="absolute top-full right-0 mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
          
          {/* Header avec badge v2.0 BETA */}
          <div className="bg-gradient-to-r from-red-500 to-orange-600 p-4 text-white relative">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <span className="text-xl">🔥</span>
                <span className="font-bold text-lg">{t('new_advanced_dropdown') || 'NOUVEAU DROPDOWN AVANCÉ'}</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm font-bold">
                  v2.0 BETA
                </span>
                <button
                  onClick={() => setIsOpen(false)}
                  className="text-white/80 hover:text-white"
                >
                  <X size={20} />
                </button>
              </div>
            </div>
            
            {/* Barre de recherche ultra-intelligente */}
            <div className="relative">
              <Search size={16} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-white/70" />
              <input
                ref={searchInputRef}
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Tapez 'fr', 'jap', 'chin'..."
                className="w-full bg-white/20 border border-white/30 rounded-lg pl-10 pr-10 py-2 text-white placeholder-white/70 focus:outline-none focus:ring-2 focus:ring-white/50 focus:bg-white/30"
                data-testid="language-search-input"
              />
              {searchTerm && (
                <button
                  onClick={clearSearch}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-white/70 hover:text-white"
                  data-testid="clear-search-button"
                >
                  <X size={16} />
                </button>
              )}
            </div>
          </div>

          {/* Résultats de recherche */}
          {searchTerm && (
            <div className="bg-gradient-to-r from-red-100 to-orange-100 px-4 py-2 border-b">
              <div className="flex items-center gap-2 text-red-700">
                <span className="text-lg">🔥</span>
                <span className="font-medium">
                  {filteredLanguages.length} {filteredLanguages.length === 1 
                    ? (t('language_found') || 'langue trouvée') 
                    : (t('languages_found') || 'langues trouvées')
                  } {t('for_search') || 'pour'} "{searchTerm}"
                </span>
              </div>
            </div>
          )}

          {/* Liste des langues */}
          <div 
            className="max-h-64 overflow-y-auto scrollbar-custom"
            data-testid="language-list"
          >
            {filteredLanguages.length === 0 && searchTerm && (
              <div className="px-6 py-8 text-center text-gray-500">
                <Search className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                <p className="font-medium mb-2">{t('no_language_found') || 'Aucune langue trouvée'}</p>
                <p className="text-sm text-gray-400 mb-4">
                  {t('try_search') || 'Essayez: "français", "english", "中文", "العربية"'}
                </p>
                <button
                  onClick={clearSearch}
                  className="text-red-600 hover:text-red-800 text-sm font-medium"
                >
                  Effacer la recherche
                </button>
              </div>
            )}

            {filteredLanguages.map((language, index) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language.code)}
                className={`w-full flex items-center gap-3 px-4 py-3 transition-all duration-150 text-left ${
                  currentLanguage === language.code 
                    ? 'bg-red-50 border-l-4 border-red-500' 
                    : focusedIndex === index
                    ? 'bg-gray-100'
                    : 'hover:bg-gray-50'
                }`}
                data-testid={`language-option-${language.code}`}
              >
                <span className="text-xl flex-shrink-0">{language.flag}</span>
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-gray-900 truncate">
                    {language.name}
                  </div>
                  <div className="text-sm text-gray-500 truncate">
                    {language.nativeName}
                  </div>
                </div>
                {currentLanguage === language.code && (
                  <div className="flex-shrink-0">
                    <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  </div>
                )}
              </button>
            ))}
          </div>

          {/* Footer v2.0 BETA */}
          <div className="bg-gradient-to-r from-green-50 to-blue-50 px-4 py-3 border-t border-gray-200">
            <div className="flex items-center justify-between text-sm">
              <div className="flex items-center gap-2 text-green-700 font-medium">
                <span className="text-lg">🔥</span>
                <span>{t('new_version_2024') || 'NOUVELLE VERSION 2024'}</span>
              </div>
              <div className="flex items-center gap-2 text-blue-600 text-xs">
                <span>⭐</span>
                <span>
                  {filteredLanguages.length} {t('languages_found') || 'langues'} • 100k+ {t('families_trust') || 'familles'} • v2.0 BETA
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      <style jsx>{`
        .scrollbar-custom {
          scrollbar-width: thin;
          scrollbar-color: #ef4444 #f1f5f9;
        }
        
        .scrollbar-custom::-webkit-scrollbar {
          width: 6px;
        }
        
        .scrollbar-custom::-webkit-scrollbar-track {
          background: #f1f5f9;
        }
        
        .scrollbar-custom::-webkit-scrollbar-thumb {
          background: linear-gradient(180deg, #ef4444 0%, #dc2626 100%);
          border-radius: 3px;
        }
        
        .scrollbar-custom::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(180deg, #dc2626 0%, #b91c1c 100%);
        }
      `}</style>
    </div>
  )
}
