"use client"

import { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'

interface LanguageSelectorProps {
  compact?: boolean
}

export function LanguageSelector({ compact = true }: LanguageSelectorProps) {
  const { currentLanguage, setLanguage, supportedLanguages } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')

  const currentLang = supportedLanguages.find(l => l.code === currentLanguage) || supportedLanguages[0]

  const filteredLanguages = supportedLanguages.filter(lang =>
    searchTerm === '' || 
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const selectLanguage = (langCode: string) => {
    setLanguage(langCode as any)
    setIsOpen(false)
    setSearchTerm('')
  }

  if (compact) {
    return (
      <div className="relative">
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="flex items-center gap-2 px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
        >
          <span className="text-lg">{currentLang.flag}</span>
          <span className="font-medium text-sm">{currentLang.code.toUpperCase()}</span>
          <span className="text-xs text-gray-500">▼</span>
        </button>

        {isOpen && (
          <div className="absolute top-full right-0 mt-1 w-80 bg-white border border-gray-200 rounded-lg shadow-lg z-50 max-h-96 overflow-hidden">
            {/* En-tête avec recherche */}
            <div className="p-3 border-b bg-gradient-to-r from-blue-50 to-purple-50">
              <h3 className="font-bold text-gray-800 mb-2">🌍 Langues Universelles</h3>
              <input
                type="text"
                placeholder="🔍 Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:outline-none"
              />
              <div className="text-xs text-gray-600 mt-1">
                {filteredLanguages.length} / 200+ langues disponibles
              </div>
            </div>

            {/* Liste des langues avec régions */}
            <div className="max-h-64 overflow-y-auto">
              {['Global', 'Europe', 'Asia', 'MENA'].map(region => {
                const regionLanguages = filteredLanguages.filter(l => l.region === region)
                if (regionLanguages.length === 0) return null
                
                return (
                  <div key={region}>
                    <div className="px-3 py-2 bg-gray-50 border-b text-xs font-semibold text-gray-600">
                      {region === 'Global' ? '🌐 Global' : 
                       region === 'Europe' ? '🇪🇺 Europe' :
                       region === 'Asia' ? '🌏 Asie' : '🕌 MENA'}
                      ({regionLanguages.length})
                    </div>
                    {regionLanguages.map(language => (
                      <button
                        key={language.code}
                        onClick={() => selectLanguage(language.code)}
                        className={`w-full px-3 py-2 text-left hover:bg-gray-50 flex items-center gap-3 border-b border-gray-100 ${
                          language.code === currentLanguage ? 'bg-blue-50 text-blue-600 font-medium' : ''
                        }`}
                      >
                        <span className="text-lg">{language.flag}</span>
                        <div className="flex-1 min-w-0">
                          <div className="font-medium text-sm truncate">{language.nativeName}</div>
                          <div className="text-xs text-gray-500 truncate">{language.name}</div>
                        </div>
                        {language.code === 'ar' && (
                          <span className="text-xs bg-orange-100 text-orange-600 px-1 rounded">RTL</span>
                        )}
                      </button>
                    ))}
                  </div>
                )
              })}
            </div>

            {/* Footer */}
            <div className="p-3 border-t bg-gray-50 text-center">
              <div className="text-xs text-gray-600">
                <strong>�� PREMIÈRE MONDIALE :</strong> Support de 200+ langues
              </div>
              <div className="text-xs text-gray-500 mt-1">
                Plus de langues disponibles prochainement !
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }

  return <div>Sélecteur complet à implémenter</div>
}
