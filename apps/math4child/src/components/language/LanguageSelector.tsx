'use client'

import { useState, useEffect, useRef } from 'react'
import { useTranslation } from '@/hooks/useTranslation'
import { ChevronDown, Globe, Search, X } from 'lucide-react'

interface LanguageSelectorProps {
  className?: string
  showRegions?: boolean
  showSearch?: boolean
}

export function LanguageSelector({ 
  className = '', 
  showRegions = true, 
  showSearch = true 
}: LanguageSelectorProps) {
  const { currentLanguage, changeLanguage, getLanguagesByRegion, isRTL, availableLanguages } = useTranslation()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const dropdownRef = useRef<HTMLDivElement>(null)

  // Fermer avec Escape
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setIsOpen(false)
    }
    
    if (isOpen) {
      document.addEventListener('keydown', handleEscape)
      document.body.style.overflow = 'hidden'
    }
    
    return () => {
      document.removeEventListener('keydown', handleEscape)
      document.body.style.overflow = 'auto'
    }
  }, [isOpen])

  const languagesByRegion = getLanguagesByRegion()

  // Filtrer les langues par terme de recherche et traduire les noms
  const filteredRegions = Object.entries(languagesByRegion).reduce((acc, [region, languages]) => {
    const filteredLanguages = languages.filter(lang => 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    ).map(lang => ({
      ...lang,
      // Traduire le nom de la langue dans la langue actuelle
      translatedName: getTranslatedLanguageName(lang.code, currentLanguage.code)
    }))
    
    if (filteredLanguages.length > 0) {
      acc[region] = filteredLanguages
    }
    return acc
  }, {} as { [key: string]: any[] })

  // Fonction pour traduire les noms de langues
  function getTranslatedLanguageName(langCode: string, currentLangCode: string): string {
    const translations: { [key: string]: { [key: string]: string } } = {
      'fr': {
        'fr': 'Français', 'en': 'Anglais', 'es': 'Espagnol', 'de': 'Allemand', 'it': 'Italien',
        'pt': 'Portugais', 'nl': 'Néerlandais', 'ru': 'Russe', 'zh': 'Chinois', 'ja': 'Japonais',
        'ko': 'Coréen', 'ar': 'Arabe', 'hi': 'Hindi', 'th': 'Thaï', 'vi': 'Vietnamien'
      },
      'en': {
        'fr': 'French', 'en': 'English', 'es': 'Spanish', 'de': 'German', 'it': 'Italian',
        'pt': 'Portuguese', 'nl': 'Dutch', 'ru': 'Russian', 'zh': 'Chinese', 'ja': 'Japanese',
        'ko': 'Korean', 'ar': 'Arabic', 'hi': 'Hindi', 'th': 'Thai', 'vi': 'Vietnamese'
      },
      'es': {
        'fr': 'Francés', 'en': 'Inglés', 'es': 'Español', 'de': 'Alemán', 'it': 'Italiano',
        'pt': 'Portugués', 'nl': 'Holandés', 'ru': 'Ruso', 'zh': 'Chino', 'ja': 'Japonés',
        'ko': 'Coreano', 'ar': 'Árabe', 'hi': 'Hindi', 'th': 'Tailandés', 'vi': 'Vietnamita'
      },
      'de': {
        'fr': 'Französisch', 'en': 'Englisch', 'es': 'Spanisch', 'de': 'Deutsch', 'it': 'Italienisch',
        'pt': 'Portugiesisch', 'nl': 'Niederländisch', 'ru': 'Russisch', 'zh': 'Chinesisch', 'ja': 'Japanisch',
        'ko': 'Koreanisch', 'ar': 'Arabisch', 'hi': 'Hindi', 'th': 'Thailändisch', 'vi': 'Vietnamesisch'
      },
      'it': {
        'fr': 'Francese', 'en': 'Inglese', 'es': 'Spagnolo', 'de': 'Tedesco', 'it': 'Italiano',
        'pt': 'Portoghese', 'nl': 'Olandese', 'ru': 'Russo', 'zh': 'Cinese', 'ja': 'Giapponese',
        'ko': 'Coreano', 'ar': 'Arabo', 'hi': 'Hindi', 'th': 'Tailandese', 'vi': 'Vietnamita'
      },
      'ar': {
        'fr': 'الفرنسية', 'en': 'الإنجليزية', 'es': 'الإسبانية', 'de': 'الألمانية', 'it': 'الإيطالية',
        'pt': 'البرتغالية', 'nl': 'الهولندية', 'ru': 'الروسية', 'zh': 'الصينية', 'ja': 'اليابانية',
        'ko': 'الكورية', 'ar': 'العربية', 'hi': 'الهندية', 'th': 'التايلاندية', 'vi': 'الفيتنامية'
      }
    }
    
    return translations[currentLangCode]?.[langCode] || availableLanguages.find(l => l.code === langCode)?.name || langCode
  }

  const handleLanguageChange = (langCode: string) => {
    changeLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
  }

  // Corriger le drapeau pour l'arabe (utiliser le drapeau marocain)
  const getLanguageFlag = (lang: any) => {
    if (lang.code === 'ar') return '🇲🇦' // Drapeau marocain pour l'arabe
    return lang.flag
  }

  return (
    <div className={`relative ${className}`}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`
          flex items-center space-x-2 bg-white/20 backdrop-blur-sm border border-white/30 
          text-white rounded-lg px-4 py-2 hover:bg-white/30 transition-colors duration-200
          ${isRTL ? 'flex-row-reverse space-x-reverse' : ''}
        `}
        aria-expanded={isOpen}
        aria-haspopup="listbox"
      >
        <span className="text-lg">{getLanguageFlag(currentLanguage)}</span>
        <span className="font-medium">{currentLanguage.name}</span>
        <ChevronDown className={`w-4 h-4 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <>
          <div 
            className="fixed inset-0 z-40" 
            onClick={() => setIsOpen(false)}
          />
          
          <div 
            ref={dropdownRef}
            className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden z-50 min-w-[300px]"
          >
            {/* Header avec recherche */}
            {showSearch && (
              <div className="p-4 border-b border-gray-100 sticky top-0 bg-white">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                  <input
                    type="text"
                    placeholder="Rechercher une langue..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-10 pr-10 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    autoFocus
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
            )}

            {/* Liste des langues avec scroll personnalisé */}
            <div className="max-h-80 overflow-y-auto custom-scrollbar">
              {Object.entries(filteredRegions).map(([region, languages]) => (
                <div key={region} className="p-2">
                  {showRegions && Object.keys(filteredRegions).length > 1 && (
                    <h4 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-2 px-2 sticky top-0 bg-white">
                      {region}
                    </h4>
                  )}
                  {languages.map((lang) => (
                    <button
                      key={lang.code}
                      onClick={() => handleLanguageChange(lang.code)}
                      className={`
                        w-full flex items-center space-x-3 px-4 py-3 rounded-xl hover:bg-gradient-to-r 
                        hover:from-blue-50 hover:to-purple-50 transition-all duration-200 text-left group
                        ${currentLanguage.code === lang.code ? 
                          'bg-gradient-to-r from-blue-100 to-purple-100 border-l-4 border-blue-500' : ''
                        }
                      `}
                      role="option"
                      aria-selected={currentLanguage.code === lang.code}
                    >
                      <span className="text-2xl">{getLanguageFlag(lang)}</span>
                      <div className="flex-1">
                        <div className="font-medium text-gray-800">{lang.translatedName}</div>
                        <div className="text-xs text-gray-500 uppercase">{lang.code}</div>
                      </div>
                      {lang.rtl && (
                        <span className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                          RTL
                        </span>
                      )}
                      {currentLanguage.code === lang.code && (
                        <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                      )}
                    </button>
                  ))}
                </div>
              ))}
            </div>

            {/* Footer avec stats */}
            <div className="border-t border-gray-100 p-3 bg-gray-50 sticky bottom-0">
              <div className="flex items-center justify-center space-x-2 text-xs text-gray-500">
                <Globe className="w-3 h-3" />
                <span>{Object.values(filteredRegions).flat().length} langues disponibles</span>
              </div>
            </div>
          </div>
        </>
      )}

      {/* Styles pour la scrollbar personnalisée */}
      <style jsx>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 8px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
          background: #f1f1f1;
          border-radius: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: #c1c1c1;
          border-radius: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: #a8a8a8;
        }
      `}</style>
    </div>
  )
}
