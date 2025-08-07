'use client'

import { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'
import { WORLD_LANGUAGES } from '@/data/corrected_languages_data'
import { Search, Globe, Check } from 'lucide-react'

export default function LanguageSelector() {
  const { currentLanguage, setLanguage, t, isRTL } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')

  const filteredLanguages = WORLD_LANGUAGES.filter(lang => 
    !searchTerm || 
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.code.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const currentLang = WORLD_LANGUAGES.find(lang => lang.code === currentLanguage)

  return (
    <div className="relative">
      <button
        data-testid="language-selector"
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
      >
        <Globe className="w-4 h-4" />
        <span className="text-xl">{currentLang?.flag}</span>
        <span className="font-medium">{currentLang?.nativeName}</span>
      </button>

      {isOpen && (
        <div className="absolute top-full mt-2 w-80 bg-white border border-gray-200 rounded-lg shadow-lg z-50">
          <div className="p-4 border-b">
            <h3 className="font-semibold mb-2">{t('modal.selectLanguage')}</h3>
            <div className="relative">
              <Search className="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
              <input
                data-testid="language-search"
                type="text"
                placeholder={t('modal.searchPlaceholder')}
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md"
              />
            </div>
          </div>

          <div className="max-h-64 overflow-y-auto">
            {filteredLanguages.length === 0 ? (
              <div className="p-4 text-center text-gray-500">
                {t('modal.noResults')}
              </div>
            ) : (
              filteredLanguages.map((language) => (
                <button
                  key={language.code}
                  data-testid="language-option"
                  data-language-code={language.code}
                  onClick={() => {
                    setLanguage(language.code)
                    setIsOpen(false)
                    setSearchTerm('')
                  }}
                  className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors ${
                    currentLanguage === language.code ? 'bg-blue-50 text-blue-600' : ''
                  }`}
                >
                  <span className="text-xl">{language.flag}</span>
                  <div className="flex-1 text-left">
                    <div className="font-medium">{language.nativeName}</div>
                    <div className="text-sm text-gray-500">{language.name}</div>
                    <div className="text-xs text-gray-400">
                      {language.countries.slice(0, 3).join(', ')}
                      {language.countries.length > 3 && ` +${language.countries.length - 3}`}
                    </div>
                  </div>
                  {currentLanguage === language.code && (
                    <Check className="w-5 h-5 text-blue-600" />
                  )}
                </button>
              ))
            )}
          </div>
        </div>
      )}

      {isOpen && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setIsOpen(false)}
        />
      )}
    </div>
  )
}
