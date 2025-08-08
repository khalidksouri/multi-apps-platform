"use client"

import { useState, useRef, useEffect } from 'react'
import { useLanguage } from '@/hooks/useLanguage'

export function LanguageSelector() {
  const { currentLanguage, setLanguage, supportedLanguages, languageStats } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedRegion, setSelectedRegion] = useState<string>('all')
  const dropdownRef = useRef<HTMLDivElement>(null)
  
  const currentLang = supportedLanguages.find(lang => lang.code === currentLanguage) || supportedLanguages[0]
  
  // Régions disponibles
  const regions = ['all', ...Array.from(new Set(supportedLanguages.map(lang => lang.region)))]
  
  // Filtrage des langues
  const filteredLanguages = supportedLanguages.filter(lang => {
    const matchesSearch = lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         lang.name.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesRegion = selectedRegion === 'all' || lang.region === selectedRegion
    return matchesSearch && matchesRegion
  })

  // Groupement par région
  const languagesByRegion = filteredLanguages.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = []
    acc[lang.region].push(lang)
    return acc
  }, {} as Record<string, typeof supportedLanguages>)

  // Tri par popularité
  Object.keys(languagesByRegion).forEach(region => {
    languagesByRegion[region].sort((a, b) => b.popularity - a.popularity)
  })

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
        setSelectedRegion('all')
      }
    }
    
    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
    }
    
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [isOpen])
  
  const handleLanguageSelect = async (languageCode: string) => {
    await setLanguage(languageCode as any)
    setIsOpen(false)
    setSearchTerm('')
    setSelectedRegion('all')
  }

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'easy': return 'text-green-600'
      case 'medium': return 'text-yellow-600'
      case 'hard': return 'text-red-600'
      default: return 'text-gray-600'
    }
  }

  const getDifficultyIcon = (difficulty: string) => {
    switch (difficulty) {
      case 'easy': return '🟢'
      case 'medium': return '🟡'
      case 'hard': return '🔴'
      default: return '⚪'
    }
  }
  
  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 px-4 py-3 rounded-xl border-2 border-gray-200 hover:border-blue-300 bg-white transition-all duration-200 shadow-sm hover:shadow-md min-w-[180px] group"
      >
        <span className="text-2xl group-hover:scale-110 transition-transform duration-200">
          {currentLang.flag}
        </span>
        <div className="flex-1 text-left">
          <div className="font-bold text-sm text-gray-800">
            {currentLang.nativeName}
          </div>
          <div className="text-xs text-gray-500 flex items-center gap-1">
            <span>{currentLang.region}</span>
            <span className={getDifficultyColor(currentLang.difficulty)}>
              {getDifficultyIcon(currentLang.difficulty)}
            </span>
          </div>
        </div>
        <svg 
          className={`w-5 h-5 text-gray-400 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      
      {isOpen && (
        <div className="absolute top-full left-0 mt-2 w-96 bg-white border-2 border-gray-200 rounded-xl shadow-2xl z-50 max-h-[500px] overflow-hidden">
          
          {/* Header avec statistiques */}
          <div className="px-4 py-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
            <div className="flex items-center gap-3 mb-3">
              <span className="text-2xl">🌍</span>
              <div>
                <h3 className="font-bold text-gray-800">Sélecteur Universel</h3>
                <p className="text-xs text-gray-600">
                  {languageStats.totalLanguages} langues • {languageStats.regionsCount} régions • {languageStats.rtlLanguages} RTL
                </p>
              </div>
            </div>
            
            {/* Barre de recherche */}
            <div className="relative mb-3">
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-3 py-2 pl-9 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              <svg className="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            
            {/* Filtre par région */}
            <div className="flex gap-1 overflow-x-auto">
              {regions.map(region => (
                <button
                  key={region}
                  onClick={() => setSelectedRegion(region)}
                  className={`px-3 py-1 rounded-full text-xs font-medium whitespace-nowrap transition-all ${
                    selectedRegion === region
                      ? 'bg-blue-500 text-white'
                      : 'bg-gray-200 text-gray-600 hover:bg-gray-300'
                  }`}
                >
                  {region === 'all' ? 'Toutes' : region}
                </button>
              ))}
            </div>
          </div>

          {/* Liste des langues par région */}
          <div className="max-h-80 overflow-y-auto">
            {Object.keys(languagesByRegion).length === 0 ? (
              <div className="px-4 py-8 text-center text-gray-500">
                <span className="text-2xl block mb-2">🔍</span>
                Aucune langue trouvée
              </div>
            ) : (
              Object.entries(languagesByRegion).map(([region, languages]) => (
                <div key={region}>
                  <div className="px-4 py-2 bg-gray-50 border-b border-gray-100">
                    <h4 className="font-semibold text-gray-700 text-sm">{region}</h4>
                  </div>
                  
                  {languages.map((language) => (
                    <button
                      key={language.code}
                      onClick={() => handleLanguageSelect(language.code)}
                      className={`w-full flex items-center gap-3 px-4 py-3 text-left hover:bg-blue-50 transition-all duration-150 border-b border-gray-50 ${
                        currentLanguage === language.code 
                          ? 'bg-blue-50 text-blue-700 border-r-4 border-blue-500' 
                          : 'text-gray-700 hover:text-blue-600'
                      }`}
                    >
                      <span className="text-xl flex-shrink-0">{language.flag}</span>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2">
                          <span className="font-medium text-sm truncate">
                            {language.nativeName}
                          </span>
                          {language.rtl && (
                            <span className="bg-purple-100 text-purple-600 px-1.5 py-0.5 rounded text-xs font-medium">
                              RTL
                            </span>
                          )}
                        </div>
                        <div className="flex items-center gap-2 text-xs text-gray-500">
                          <span className="truncate">{language.name}</span>
                          <span className={getDifficultyColor(language.difficulty)}>
                            {getDifficultyIcon(language.difficulty)}
                          </span>
                          <span className="text-gray-400">•</span>
                          <span>{language.popularity}%</span>
                        </div>
                      </div>
                      {currentLanguage === language.code && (
                        <svg className="w-5 h-5 text-blue-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                        </svg>
                      )}
                    </button>
                  ))}
                </div>
              ))
            )}
          </div>

          {/* Footer avec informations */}
          <div className="px-4 py-3 border-t border-gray-100 bg-gray-50">
            <div className="flex items-center justify-between text-xs text-gray-600">
              <span>🎯 {filteredLanguages.length} langues affichées</span>
              <span>🚀 Math4Child v4.2.0</span>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
