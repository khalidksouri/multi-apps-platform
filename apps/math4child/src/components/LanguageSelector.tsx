'use client'

import { useState } from 'react'
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
  const { currentLanguage, changeLanguage, getLanguagesByRegion, isRTL } = useTranslation()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')

  const languagesByRegion = getLanguagesByRegion()

  // Filtrer les langues par terme de recherche
  const filteredRegions = Object.entries(languagesByRegion).reduce((acc, [region, languages]) => {
    const filteredLanguages = languages.filter(lang => 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    )
    if (filteredLanguages.length > 0) {
      acc[region] = filteredLanguages
    }
    return acc
  }, {} as { [key: string]: any[] })

  const handleLanguageChange = (langCode: string) => {
    changeLanguage(langCode)
    setIsOpen(false)
    setSearchTerm('')
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
      >
        <span className="text-lg">{currentLanguage.flag}</span>
        <span className="font-medium">{currentLanguage.name}</span>
        <ChevronDown className={`w-4 h-4 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-gray-200 max-h-96 overflow-hidden z-50">
          {/* Header avec recherche */}
          {showSearch && (
            <div className="p-4 border-b border-gray-100">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <input
                  type="text"
                  placeholder="Rechercher une langue..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-10 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
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

          {/* Liste des langues par région */}
          <div className="max-h-80 overflow-y-auto">
            {Object.entries(filteredRegions).map(([region, languages]) => (
              <div key={region} className="p-2">
                {showRegions && Object.keys(filteredRegions).length > 1 && (
                  <h4 className="text-xs font-medium text-gray-500 uppercase tracking-wide mb-2 px-2">
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
                  >
                    <span className="text-2xl">{lang.flag}</span>
                    <div className="flex-1">
                      <div className="font-medium text-gray-800">{lang.name}</div>
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
          <div className="border-t border-gray-100 p-3 bg-gray-50">
            <div className="flex items-center justify-center space-x-2 text-xs text-gray-500">
              <Globe className="w-3 h-3" />
              <span>{Object.values(filteredRegions).flat().length} langues disponibles</span>
            </div>
          </div>
        </div>
      )}

      {/* Overlay pour fermer */}
      {isOpen && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setIsOpen(false)}
        />
      )}
    </div>
  )
}
