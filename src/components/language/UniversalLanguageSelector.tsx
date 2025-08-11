"use client"

import { useState, useRef, useEffect } from 'react'
import { useLanguage } from '@/hooks/useLanguage'
import { UNIVERSAL_LANGUAGES, type Language } from '@/types/language'

interface UniversalLanguageSelectorProps {
  compact?: boolean
  showSearch?: boolean
  className?: string
}

export function UniversalLanguageSelector({ 
  compact = true, 
  showSearch = true,
  className = ''
}: UniversalLanguageSelectorProps) {
  const { currentLanguage, setLanguage, t, isRTL } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const dropdownRef = useRef<HTMLDivElement>(null)

  const currentLang = UNIVERSAL_LANGUAGES.find(l => l.code === currentLanguage) || UNIVERSAL_LANGUAGES[0]

  // Filtrer les langues selon la recherche
  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang =>
    searchTerm === '' || 
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.region.toLowerCase().includes(searchTerm.toLowerCase())
  )

  // Grouper par continent
  const languagesByContinents = filteredLanguages.reduce((acc, lang) => {
    if (!acc[lang.continent]) {
      acc[lang.continent] = []
    }
    acc[lang.continent].push(lang)
    return acc
  }, {} as Record<string, Language[]>)

  // Fermer dropdown si clic à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const selectLanguage = (langCode: string) => {
    console.log('🌍 [UNIVERSAL] Sélection langue:', langCode)
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
  }

  const getContinentIcon = (continent: string): string => {
    switch (continent) {
      case 'Europe': return '🇪🇺'
      case 'Asia': return '🌏'
      case 'Africa': return '🌍'
      case 'Americas': return '🌎'
      case 'Oceania': return '🏝️'
      default: return '🌐'
    }
  }

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`flex items-center gap-3 px-4 py-3 bg-white border-2 border-gray-200 rounded-xl hover:border-blue-300 hover:shadow-md transition-all duration-200 ${isRTL ? 'flex-row-reverse' : ''}`}
        data-testid="language-selector-button"
      >
        <span className="text-2xl">{currentLang.flag}</span>
        <div className={`flex flex-col ${isRTL ? 'text-right' : 'text-left'}`}>
          <span className="font-semibold text-gray-800 text-sm">{currentLang.nativeName}</span>
          <span className="text-xs text-gray-500">{currentLang.region}</span>
        </div>
        <span className={`text-gray-400 transition-transform ${isOpen ? 'rotate-180' : ''}`}>
          ▼
        </span>
      </button>

      {/* Dropdown des langues */}
      {isOpen && (
        <div className="absolute top-full mt-2 w-96 bg-white border-2 border-gray-200 rounded-xl shadow-xl z-50 max-h-96 overflow-hidden">
          {/* En-tête avec compteur et recherche */}
          <div className="p-4 border-b bg-gradient-to-r from-blue-50 to-purple-50">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-bold text-gray-800">{t('universal_languages')}</h3>
              <span className="bg-blue-100 text-blue-600 px-2 py-1 rounded-full text-xs font-bold">
                200+ langues
              </span>
            </div>
            
            {showSearch && (
              <div className="relative">
                <input
                  type="text"
                  placeholder={t('search_language')}
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:outline-none"
                  data-testid="language-search-input"
                />
                <span className="absolute right-3 top-2.5 text-gray-400">🔍</span>
              </div>
            )}
            
            <div className="text-xs text-gray-600 mt-2">
              {filteredLanguages.length} langues trouvées
            </div>
          </div>

          {/* Liste des langues par continent */}
          <div className="max-h-64 overflow-y-auto">
            {Object.entries(languagesByContinents).map(([continent, languages]) => (
              <div key={continent}>
                {/* En-tête continent */}
                <div className="px-4 py-2 bg-gray-50 border-b text-sm font-semibold text-gray-700 sticky top-0">
                  <span className="mr-2">{getContinentIcon(continent)}</span>
                  {continent} ({languages.length})
                </div>
                
                {/* Langues du continent */}
                {languages.map(language => (
                  <button
                    key={language.code}
                    onClick={() => selectLanguage(language.code)}
                    className={`w-full px-4 py-3 text-left hover:bg-blue-50 flex items-center gap-3 border-b border-gray-100 transition-colors ${
                      language.code === currentLanguage 
                        ? 'bg-blue-100 text-blue-700 font-medium' 
                        : 'text-gray-700'
                    }`}
                    data-testid={`language-option-${language.code}`}
                  >
                    <span className="text-xl">{language.flag}</span>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-sm truncate">{language.nativeName}</div>
                      <div className="text-xs text-gray-500 truncate">{language.name} - {language.region}</div>
                    </div>
                    {language.rtl && (
                      <span className="text-xs bg-orange-100 text-orange-600 px-2 py-1 rounded-full">
                        RTL
                      </span>
                    )}
                    {language.code === currentLanguage && (
                      <span className="text-blue-500">✓</span>
                    )}
                  </button>
                ))}
              </div>
            ))}
          </div>

          {/* Footer */}
          <div className="p-3 border-t bg-gray-50 text-center">
            <div className="text-xs text-gray-600 mb-1">
              <strong>🚀 {t('global_first')} :</strong> Support universel 200+ langues
            </div>
            <div className="text-xs text-gray-500">
              Math4Child v4.2.0 - Révolution Éducative Mondiale
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
