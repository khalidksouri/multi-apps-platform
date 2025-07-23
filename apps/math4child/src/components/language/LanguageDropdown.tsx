'use client'

import { useState, useRef, useEffect } from 'react'
import { useLanguage } from '../../contexts/LanguageContext'
import { ChevronDown, Globe, Search, X } from 'lucide-react'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  region: string
  popular?: boolean
  searchTerms: string[]
}

const languages: Language[] = [
  // Europe
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', popular: true, searchTerms: ['french', 'français', 'france', 'fr'] },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe', popular: true, searchTerms: ['english', 'anglais', 'en', 'gb', 'uk'] },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', popular: true, searchTerms: ['spanish', 'español', 'espagnol', 'es'] },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', popular: true, searchTerms: ['german', 'deutsch', 'allemand', 'de'] },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', popular: true, searchTerms: ['italian', 'italiano', 'italien', 'it'] },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', popular: true, searchTerms: ['portuguese', 'português', 'portugais', 'pt'] },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', popular: true, searchTerms: ['russian', 'русский', 'russe', 'ru'] },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe', searchTerms: ['dutch', 'nederlands', 'néerlandais', 'nl'] },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe', searchTerms: ['polish', 'polski', 'polonais', 'pl'] },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe', searchTerms: ['swedish', 'svenska', 'suédois', 'sv'] },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe', searchTerms: ['norwegian', 'norsk', 'norvégien', 'no'] },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe', searchTerms: ['danish', 'dansk', 'danois', 'da'] },
  
  // Autres régions déjà existantes
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia', popular: true, searchTerms: ['japanese', '日本語', 'japonais', 'ja'] },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia', popular: true, searchTerms: ['chinese', '中文', 'chinois', 'zh'] },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia', searchTerms: ['korean', '한국어', 'coréen', 'ko'] },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', region: 'Middle East', popular: true, searchTerms: ['arabic', 'العربية', 'arabe', 'ar'] },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia', searchTerms: ['hindi', 'हिन्दी', 'hindi', 'hi'] },
]

const groupLanguagesByRegion = (langs: Language[]) => {
  const grouped = langs.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = []
    acc[lang.region].push(lang)
    return acc
  }, {} as Record<string, Language[]>)
  
  return Object.entries(grouped).sort(([a], [b]) => {
    const order = ['Europe', 'Asia', 'Middle East', 'Americas', 'Africa', 'Oceania']
    return order.indexOf(a) - order.indexOf(b)
  })
}

export default function AdvancedLanguageDropdown() {
  const { currentLanguage, setLanguage, t } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [focusedIndex, setFocusedIndex] = useState(-1)
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchRef = useRef<HTMLInputElement>(null)

  const currentLang = languages.find(lang => lang.code === currentLanguage) || languages[0]
  
  // Filtrer les langues selon la recherche
  const filteredLanguages = languages.filter(lang => 
    searchTerm === '' || 
    lang.searchTerms.some(term => 
      term.toLowerCase().includes(searchTerm.toLowerCase())
    ) ||
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const groupedLanguages = groupLanguagesByRegion(filteredLanguages)
  const flatLanguages = groupedLanguages.flatMap(([, langs]) => langs)

  useEffect(() => {
    if (isOpen && searchRef.current) {
      searchRef.current.focus()
    }
  }, [isOpen])

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

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!isOpen) return

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        setFocusedIndex(prev => (prev < flatLanguages.length - 1 ? prev + 1 : 0))
        break
      case 'ArrowUp':
        e.preventDefault()
        setFocusedIndex(prev => (prev > 0 ? prev - 1 : flatLanguages.length - 1))
        break
      case 'Enter':
        e.preventDefault()
        if (focusedIndex >= 0 && flatLanguages[focusedIndex]) {
          handleLanguageSelect(flatLanguages[focusedIndex].code)
        }
        break
      case 'Escape':
        setIsOpen(false)
        setSearchTerm('')
        setFocusedIndex(-1)
        break
    }
  }

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
    setFocusedIndex(-1)
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        className="flex items-center space-x-2 px-4 py-2.5 bg-white/90 backdrop-blur-sm border border-gray-200 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 group relative overflow-hidden"
        aria-haspopup="listbox"
        aria-expanded={isOpen}
      >
        {/* Animation de fond au hover */}
        <div className="absolute inset-0 bg-gradient-to-r from-blue-50 to-purple-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        
        {/* Indicateur de statut */}
        <div className="absolute top-1 right-1 w-2 h-2 bg-green-400 rounded-full animate-pulse" />
        
        <div className="relative flex items-center space-x-2">
          <Globe className="w-4 h-4 text-blue-600" />
          <span className="text-xl" role="img" aria-label={currentLang.name}>{currentLang.flag}</span>
          <span className="font-medium text-gray-700">{currentLang.nativeName}</span>
          <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
        </div>
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
          {/* En-tête avec recherche */}
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-4 text-white">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-bold text-lg">{t('new_advanced_dropdown')}</h3>
              <button
                onClick={() => setIsOpen(false)}
                className="p-1 hover:bg-white/20 rounded-lg transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
            
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-blue-200" />
              <input
                ref={searchRef}
                type="text"
                value={searchTerm}
                onChange={(e) => {
                  setSearchTerm(e.target.value)
                  setFocusedIndex(-1)
                }}
                onKeyDown={handleKeyDown}
                placeholder={t('ultra_intelligent_search')}
                className="w-full pl-10 pr-4 py-2 bg-white/20 border border-white/30 rounded-lg placeholder-blue-200 text-white focus:outline-none focus:ring-2 focus:ring-white/50"
              />
            </div>
            
            {filteredLanguages.length > 0 && (
              <p className="text-xs text-blue-100 mt-2">
                <strong>{filteredLanguages.length}</strong> {filteredLanguages.length === 1 ? t('language_found') : t('languages_found')}
                {searchTerm && <span> {t('for_search')} "<strong>{searchTerm}</strong>"</span>}
              </p>
            )}
          </div>

          {/* Liste des langues */}
          <div className="max-h-96 overflow-y-auto custom-scrollbar">
            {filteredLanguages.length === 0 ? (
              <div className="p-6 text-center text-gray-500">
                <Globe className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                <p className="font-medium">{t('no_language_found')}</p>
                <p className="text-sm mt-1">{t('try_search')}</p>
              </div>
            ) : (
              groupedLanguages.map(([region, langs]) => (
                <div key={region} className="border-b border-gray-100 last:border-b-0">
                  <div className="sticky top-0 bg-gray-50/90 backdrop-blur-sm px-4 py-2 border-b border-gray-200">
                    <h4 className="font-semibold text-sm text-gray-600 flex items-center">
                      <span className="mr-2">
                        {region === 'Europe' && '🇪🇺'}
                        {region === 'Asia' && '🌏'}
                        {region === 'Middle East' && '🕌'}
                        {region === 'Americas' && '🌎'}
                        {region === 'Africa' && '🌍'}
                        {region === 'Oceania' && '🏝️'}
                      </span>
                      {region}
                      <span className="ml-2 bg-blue-100 text-blue-600 text-xs px-2 py-0.5 rounded-full">
                        {langs.length}
                      </span>
                    </h4>
                  </div>
                  
                  {langs.map((lang, index) => {
                    const globalIndex = flatLanguages.indexOf(lang)
                    const isSelected = lang.code === currentLanguage
                    const isFocused = globalIndex === focusedIndex
                    
                    return (
                      <button
                        key={lang.code}
                        onClick={() => handleLanguageSelect(lang.code)}
                        className={`w-full px-4 py-3 flex items-center space-x-3 hover:bg-blue-50 transition-all duration-200 group ${
                          isSelected ? 'bg-blue-100 border-r-4 border-blue-500' : ''
                        } ${
                          isFocused ? 'bg-blue-50 ring-2 ring-blue-200' : ''
                        }`}
                        role="option"
                        aria-selected={isSelected}
                      >
                        <span className="text-2xl" role="img" aria-label={lang.name}>
                          {lang.flag}
                        </span>
                        
                        <div className="flex-1 text-left">
                          <div className="flex items-center space-x-2">
                            <span className="font-medium text-gray-900">
                              {lang.nativeName}
                            </span>
                            {lang.popular && (
                              <span className="bg-gradient-to-r from-yellow-400 to-orange-400 text-white text-xs px-2 py-0.5 rounded-full font-medium">
                                ⭐ Populaire
                              </span>
                            )}
                            {isSelected && (
                              <span className="bg-blue-500 text-white text-xs px-2 py-0.5 rounded-full font-medium">
                                {t('current')}
                              </span>
                            )}
                          </div>
                          <span className="text-sm text-gray-500">{lang.name}</span>
                        </div>
                        
                        <div className="opacity-0 group-hover:opacity-100 transition-opacity">
                          <ChevronDown className="w-4 h-4 text-blue-500 rotate-[-90deg]" />
                        </div>
                      </button>
                    )
                  })}
                </div>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="bg-gradient-to-r from-gray-50 to-blue-50 p-3 border-t border-gray-200">
            <div className="flex items-center justify-between text-xs text-gray-500">
              <span>{t('new_version_2024')}</span>
              <span className="flex items-center space-x-1">
                <Globe className="w-3 h-3" />
                <span>{languages.length} langues</span>
              </span>
            </div>
          </div>
        </div>
      )}

      {/* Styles pour la scrollbar personnalisée */}
      <style jsx>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
          background: #f1f5f9;
          border-radius: 3px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: linear-gradient(180deg, #3b82f6, #1d4ed8);
          border-radius: 3px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(180deg, #1d4ed8, #1e40af);
        }
      `}</style>
    </div>
  )
}
