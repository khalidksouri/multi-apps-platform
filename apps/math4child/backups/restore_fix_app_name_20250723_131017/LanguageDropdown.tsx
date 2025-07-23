'use client'

import { useState, useRef, useEffect, useMemo } from 'react'
import { ChevronDown, Search, X, Globe } from 'lucide-react'

interface Language {
  code: string
  name: string
  flag: string
  nativeName?: string
  region?: string
  popular?: boolean
  searchTerms?: string[]
  rtl?: boolean
}

interface LanguageDropdownProps {
  onLanguageChange?: (language: Language) => void
  className?: string
  defaultLanguage?: string
  enableSearch?: boolean
}

export default function AdvancedLanguageDropdown({ 
  onLanguageChange, 
  className = "",
  defaultLanguage = "fr",
  enableSearch = true
}: LanguageDropdownProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [selectedLanguage, setSelectedLanguage] = useState<Language | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)
  const listRef = useRef<HTMLDivElement>(null)

  const languages: Language[] = [
    // Europe
    { 
      code: 'fr', 
      name: 'Français', 
      flag: '🇫🇷', 
      nativeName: 'Français',
      region: 'Europe',
      popular: true,
      searchTerms: ['français', 'french', 'fra', 'fr']
    },
    { 
      code: 'en', 
      name: 'English', 
      flag: '🇺🇸', 
      nativeName: 'English',
      region: 'Europe',
      popular: true,
      searchTerms: ['english', 'anglais', 'eng', 'en']
    },
    { 
      code: 'es', 
      name: 'Español', 
      flag: '🇪🇸', 
      nativeName: 'Español',
      region: 'Europe',
      popular: true,
      searchTerms: ['español', 'spanish', 'espagnol', 'esp', 'es']
    },
    { 
      code: 'de', 
      name: 'Deutsch', 
      flag: '🇩🇪', 
      nativeName: 'Deutsch',
      region: 'Europe',
      popular: true,
      searchTerms: ['deutsch', 'german', 'allemand', 'ger', 'de']
    },
    { 
      code: 'it', 
      name: 'Italiano', 
      flag: '🇮🇹', 
      nativeName: 'Italiano',
      region: 'Europe',
      searchTerms: ['italiano', 'italian', 'italien', 'ita', 'it']
    },
    { 
      code: 'pt', 
      name: 'Português', 
      flag: '🇵🇹', 
      nativeName: 'Português',
      region: 'Europe',
      searchTerms: ['português', 'portuguese', 'portugais', 'por', 'pt']
    },
    { 
      code: 'ru', 
      name: 'Русский', 
      flag: '🇷🇺', 
      nativeName: 'Русский',
      region: 'Europe',
      searchTerms: ['русский', 'russian', 'russe', 'rus', 'ru']
    },
    { 
      code: 'nl', 
      name: 'Nederlands', 
      flag: '🇳🇱', 
      nativeName: 'Nederlands',
      region: 'Europe',
      searchTerms: ['nederlands', 'dutch', 'néerlandais', 'nld', 'nl']
    },
    { 
      code: 'pl', 
      name: 'Polski', 
      flag: '🇵🇱', 
      nativeName: 'Polski',
      region: 'Europe',
      searchTerms: ['polski', 'polish', 'polonais', 'pol', 'pl']
    },
    { 
      code: 'sv', 
      name: 'Svenska', 
      flag: '🇸🇪', 
      nativeName: 'Svenska',
      region: 'Europe',
      searchTerms: ['svenska', 'swedish', 'suédois', 'swe', 'sv']
    },

    // Asie
    { 
      code: 'zh', 
      name: '中文', 
      flag: '🇨🇳', 
      nativeName: '中文',
      region: 'Asie',
      popular: true,
      searchTerms: ['中文', 'chinese', 'chinois', 'chi', 'zh', 'mandarin']
    },
    { 
      code: 'ja', 
      name: '日本語', 
      flag: '🇯🇵', 
      nativeName: '日本語',
      region: 'Asie',
      popular: true,
      searchTerms: ['日本語', 'japanese', 'japonais', 'jpn', 'ja']
    },
    { 
      code: 'ko', 
      name: '한국어', 
      flag: '🇰🇷', 
      nativeName: '한국어',
      region: 'Asie',
      searchTerms: ['한국어', 'korean', 'coréen', 'kor', 'ko']
    },
    { 
      code: 'hi', 
      name: 'हिन्दी', 
      flag: '🇮🇳', 
      nativeName: 'हिन्दी',
      region: 'Asie',
      searchTerms: ['हिन्दी', 'hindi', 'hin', 'hi']
    },
    { 
      code: 'th', 
      name: 'ไทย', 
      flag: '🇹🇭', 
      nativeName: 'ไทย',
      region: 'Asie',
      searchTerms: ['ไทย', 'thai', 'thaï', 'tha', 'th']
    },
    { 
      code: 'vi', 
      name: 'Tiếng Việt', 
      flag: '🇻🇳', 
      nativeName: 'Tiếng Việt',
      region: 'Asie',
      searchTerms: ['tiếng việt', 'vietnamese', 'vietnamien', 'vie', 'vi']
    },

    // Moyen-Orient & Afrique
    { 
      code: 'ar', 
      name: 'العربية', 
      flag: '🇸🇦', 
      nativeName: 'العربية',
      region: 'Moyen-Orient',
      popular: true,
      rtl: true,
      searchTerms: ['العربية', 'arabic', 'arabe', 'ara', 'ar']
    },
    { 
      code: 'he', 
      name: 'עברית', 
      flag: '🇮🇱', 
      nativeName: 'עברית',
      region: 'Moyen-Orient',
      rtl: true,
      searchTerms: ['עברית', 'hebrew', 'hébreu', 'heb', 'he']
    },
    { 
      code: 'fa', 
      name: 'فارسی', 
      flag: '🇮🇷', 
      nativeName: 'فارسی',
      region: 'Moyen-Orient',
      rtl: true,
      searchTerms: ['فارسی', 'persian', 'persan', 'fas', 'fa']
    },
    { 
      code: 'tr', 
      name: 'Türkçe', 
      flag: '🇹🇷', 
      nativeName: 'Türkçe',
      region: 'Moyen-Orient',
      searchTerms: ['türkçe', 'turkish', 'turc', 'tur', 'tr']
    }
  ]

  // Filtrage amélioré avec recherche multi-critères
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
      
      // Ensuite par popularité
      if (a.popular && !b.popular) return -1
      if (!a.popular && b.popular) return 1
      
      return a.name.localeCompare(b.name)
    })
  }, [searchTerm, languages])

  // Grouper par région pour l'affichage
  const groupedLanguages = useMemo(() => {
    const groups: Record<string, Language[]> = {}
    
    filteredLanguages.forEach(lang => {
      const region = lang.region || 'Autres'
      if (!groups[region]) groups[region] = []
      groups[region].push(lang)
    })
    
    return groups
  }, [filteredLanguages])

  // Initialiser la langue par défaut
  useEffect(() => {
    const defaultLang = languages.find(lang => lang.code === defaultLanguage) || languages[0]
    setSelectedLanguage(defaultLang)
  }, [defaultLanguage])

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
            handleLanguageSelect(filteredLanguages[focusedIndex])
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

  // Focus automatique sur la recherche à l'ouverture
  useEffect(() => {
    if (isOpen && enableSearch && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100)
    }
  }, [isOpen, enableSearch])

  const handleLanguageSelect = (language: Language) => {
    setSelectedLanguage(language)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
    onLanguageChange?.(language)
    
    console.log('🌍 Langue sélectionnée:', language.name, language.code)
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

  if (!selectedLanguage) return null

  const regionEmojis: Record<string, string> = {
    'Europe': '🇪🇺',
    'Asie': '🌏',
    'Moyen-Orient': '🕌',
    'Autres': '🌍'
  }

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      {/* Bouton de sélection */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white/10 backdrop-blur-sm text-white px-4 py-3 rounded-xl border border-white/20 hover:bg-white/20 transition-all duration-200 shadow-lg focus:outline-none focus:ring-2 focus:ring-white/50 min-w-[200px]"
        aria-label="Sélectionner une langue"
        aria-expanded={isOpen}
        data-testid="language-dropdown-button"
      >
        <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
        <Globe size={18} className="text-white/80" />
        <span className="text-xl" role="img" aria-label={`Drapeau ${selectedLanguage.name}`}>
          {selectedLanguage.flag}
        </span>
        <span className="font-medium text-white">{selectedLanguage.name}</span>
        <ChevronDown 
          className={`w-5 h-5 text-white/80 transition-transform duration-200 ml-auto ${
            isOpen ? 'rotate-180' : 'rotate-0'
          }`} 
        />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full right-0 mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
          {/* En-tête avec gradient */}
          <div className="bg-gradient-to-r from-blue-500 to-purple-600 p-4 text-white">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <Globe size={20} />
                <span className="font-bold">Choisir une langue</span>
              </div>
              <span className="text-blue-100 text-sm">
                {filteredLanguages.length} langue{filteredLanguages.length > 1 ? 's' : ''}
              </span>
            </div>
            
            {/* Barre de recherche */}
            {enableSearch && (
              <div className="relative">
                <Search size={16} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-white/70" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Tapez 'fr', 'english', '中文'..."
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
            )}
          </div>

          {/* Liste des langues avec scroll stylisé */}
          <div 
            ref={listRef}
            className="max-h-80 overflow-y-auto scrollbar-custom"
            role="listbox"
            data-testid="language-list"
          >
            {filteredLanguages.length === 0 && searchTerm && (
              <div className="px-6 py-8 text-center text-gray-500">
                <Search className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                <p className="font-medium mb-2">Aucune langue trouvée</p>
                <p className="text-sm text-gray-400 mb-4">
                  Essayez "fr" pour Français, "eng" pour English...
                </p>
                <button
                  onClick={clearSearch}
                  className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                >
                  Effacer la recherche
                </button>
              </div>
            )}

            {searchTerm ? (
              // Affichage simple lors de la recherche
              <div className="p-2">
                {filteredLanguages.map((language, index) => (
                  <button
                    key={language.code}
                    onClick={() => handleLanguageSelect(language)}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-150 text-left ${
                      selectedLanguage.code === language.code 
                        ? 'bg-blue-50 border-2 border-blue-200' 
                        : focusedIndex === index
                        ? 'bg-gray-100 border-2 border-gray-300'
                        : 'border-2 border-transparent hover:bg-gray-50'
                    }`}
                    data-testid={`language-option-${language.code}`}
                    role="option"
                    aria-selected={selectedLanguage.code === language.code}
                  >
                    <span className="text-xl flex-shrink-0">{language.flag}</span>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-gray-900 truncate">
                        {language.name}
                        {language.popular && (
                          <span className="ml-2 text-xs bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-2 py-1 rounded-full">
                            ⭐ Populaire
                          </span>
                        )}
                      </div>
                      <div className="text-sm text-gray-500 truncate">
                        {language.nativeName} • {language.code.toUpperCase()}
                        {language.rtl && (
                          <span className="ml-2 text-xs bg-purple-100 text-purple-700 px-1 rounded">
                            RTL
                          </span>
                        )}
                      </div>
                    </div>
                    {selectedLanguage.code === language.code && (
                      <div className="flex-shrink-0">
                        <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                      </div>
                    )}
                  </button>
                ))}
              </div>
            ) : (
              // Affichage groupé par région
              <div className="p-2">
                {Object.entries(groupedLanguages).map(([region, langs]) => (
                  <div key={region} className="mb-4">
                    <div className="flex items-center gap-2 px-3 py-2 bg-gray-50 rounded-lg mb-2">
                      <span className="text-lg">{regionEmojis[region]}</span>
                      <span className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
                        {region}
                      </span>
                      <span className="ml-auto bg-gray-200 text-gray-600 text-xs px-2 py-1 rounded-full">
                        {langs.length}
                      </span>
                    </div>
                    
                    {langs.map((language, index) => (
                      <button
                        key={language.code}
                        onClick={() => handleLanguageSelect(language)}
                        className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-150 text-left mb-1 ${
                          selectedLanguage.code === language.code 
                            ? 'bg-blue-50 border-2 border-blue-200' 
                            : 'border-2 border-transparent hover:bg-gray-50'
                        }`}
                        data-testid={`language-option-${language.code}`}
                        role="option"
                        aria-selected={selectedLanguage.code === language.code}
                      >
                        <span className="text-xl flex-shrink-0">{language.flag}</span>
                        <div className="flex-1 min-w-0">
                          <div className="font-medium text-gray-900 truncate">
                            {language.name}
                            {language.popular && (
                              <span className="ml-2 text-xs bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-2 py-1 rounded-full">
                                ⭐ Populaire
                              </span>
                            )}
                          </div>
                          <div className="text-sm text-gray-500 truncate">
                            {language.nativeName} • {language.code.toUpperCase()}
                            {language.rtl && (
                              <span className="ml-2 text-xs bg-purple-100 text-purple-700 px-1 rounded">
                                RTL
                              </span>
                            )}
                          </div>
                        </div>
                        {selectedLanguage.code === language.code && (
                          <div className="flex-shrink-0">
                            <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                          </div>
                        )}
                      </button>
                    ))}
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Footer avec info */}
          <div className="bg-gradient-to-r from-gray-50 to-blue-50 px-4 py-3 border-t border-gray-200">
            <div className="flex items-center justify-between text-sm text-gray-600">
              <span>🌍 {languages.length} langues disponibles</span>
              <span className="text-xs text-gray-400">↑↓ + Enter pour naviguer</span>
            </div>
          </div>
        </div>
      )}

      <style jsx>{`
        .scrollbar-custom {
          scrollbar-width: thin;
          scrollbar-color: #3b82f6 #f1f5f9;
        }
        
        .scrollbar-custom::-webkit-scrollbar {
          width: 8px;
        }
        
        .scrollbar-custom::-webkit-scrollbar-track {
          background: #f1f5f9;
          border-radius: 4px;
        }
        
        .scrollbar-custom::-webkit-scrollbar-thumb {
          background: linear-gradient(180deg, #3b82f6 0%, #1d4ed8 100%);
          border-radius: 4px;
        }
        
        .scrollbar-custom::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(180deg, #1d4ed8 0%, #1e40af 100%);
        }
      `}</style>
    </div>
  )
}
