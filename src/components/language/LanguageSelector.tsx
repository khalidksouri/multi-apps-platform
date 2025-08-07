"use client"
import { useState, useRef, useEffect } from 'react'
import { useLanguage } from '@/hooks/useLanguage'
import { 
  languages, 
  filterLanguages, 
  getContinents, 
  getRegions,
  getLanguageStats,
  type Language 
} from '@/data/languages'

export function LanguageSelector() {
  const { currentLanguage, setLanguage, t, isRTL, loadingStates } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedContinent, setSelectedContinent] = useState<string>('all')
  const [selectedRegion, setSelectedRegion] = useState<string>('all')
  const [showStats, setShowStats] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)
  
  // Langue actuelle avec infos complètes
  const currentLang = languages.find(lang => lang.code === currentLanguage) || languages[0]
  
  // Filtrage AVANCÉ avec continents et régions
  const filteredLanguages = filterLanguages(
    searchTerm, 
    selectedContinent === 'all' ? undefined : selectedContinent,
    selectedRegion === 'all' ? undefined : selectedRegion
  )
  
  // Stats des langues
  const stats = getLanguageStats()
  const continents = getContinents()
  const regions = getRegions()
  
  // Fermer dropdown si clic extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm('')
        setSelectedContinent('all')
        setSelectedRegion('all')
        setShowStats(false)
      }
    }
    
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])
  
  // Sélectionner une langue avec animation
  const handleLanguageSelect = (language: Language) => {
    setLanguage(language.code)
    setIsOpen(false)
    setSearchTerm('')
    setSelectedContinent('all')
    setSelectedRegion('all')
  }
  
  // Grouper langues par continent pour affichage
  const languagesByContinent = continents.reduce((acc, continent) => {
    acc[continent] = filteredLanguages.filter(lang => lang.continent === continent)
    return acc
  }, {} as Record<string, Language[]>)
  
  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton principal RICHE */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        data-testid="language-selector"
        className={`flex items-center gap-3 px-4 py-3 rounded-xl border-2 transition-all duration-300 bg-white shadow-lg hover:shadow-xl ${
          isOpen 
            ? 'border-blue-500 ring-4 ring-blue-500 ring-opacity-20' 
            : 'border-gray-200 hover:border-blue-300'
        } ${loadingStates.changing ? 'animate-pulse' : ''}`}
        disabled={loadingStates.changing}
      >
        <span className="text-2xl">{currentLang.flag}</span>
        <div className="flex flex-col items-start">
          <span className="font-bold text-gray-800">{currentLang.nativeName}</span>
          <span className="text-xs text-gray-500">{currentLang.name}</span>
        </div>
        {currentLang.rtl && (
          <span className="text-xs bg-blue-100 text-blue-600 px-2 py-1 rounded-full">RTL</span>
        )}
        {loadingStates.changing && (
          <div className="animate-spin rounded-full h-4 w-4 border-2 border-blue-500 border-t-transparent"></div>
        )}
        <svg 
          className={`w-5 h-5 transition-transform duration-300 ${isOpen ? 'rotate-180' : ''}`}
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      
      {/* Dropdown RICHE avec filtres */}
      {isOpen && (
        <div className="absolute top-full left-0 mt-2 w-96 bg-white border-2 border-gray-200 rounded-xl shadow-2xl z-50 animate-fadeIn">
          {/* Header avec stats */}
          <div className="p-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-bold text-lg text-gray-800">{t('selectLanguage')}</h3>
              <button
                onClick={() => setShowStats(!showStats)}
                className="text-sm text-blue-600 hover:text-blue-700 transition-colors"
              >
                📊 {showStats ? 'Masquer' : 'Stats'}
              </button>
            </div>
            
            {showStats && (
              <div className="grid grid-cols-2 gap-2 mb-3 text-xs">
                <div className="bg-white rounded-lg p-2 text-center">
                  <div className="font-bold text-blue-600">{stats.totalLanguages}</div>
                  <div className="text-gray-600">Langues</div>
                </div>
                <div className="bg-white rounded-lg p-2 text-center">
                  <div className="font-bold text-green-600">{stats.continents}</div>
                  <div className="text-gray-600">Continents</div>
                </div>
                <div className="bg-white rounded-lg p-2 text-center">
                  <div className="font-bold text-purple-600">{stats.rtlLanguages}</div>
                  <div className="text-gray-600">RTL</div>
                </div>
                <div className="bg-white rounded-lg p-2 text-center">
                  <div className="font-bold text-orange-600">{Math.round(stats.totalSpeakers / 1000000)}M</div>
                  <div className="text-gray-600">Locuteurs</div>
                </div>
              </div>
            )}
            
            {/* Barre de recherche avancée */}
            <div className="relative mb-3">
              <input
                type="text"
                placeholder={t('searchLanguage')}
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-4 py-2 pl-10 border border-gray-200 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500 focus:ring-opacity-20 transition-all"
              />
              <svg className="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            
            {/* Filtres par continent et région */}
            <div className="grid grid-cols-2 gap-2">
              <select
                value={selectedContinent}
                onChange={(e) => setSelectedContinent(e.target.value)}
                className="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500"
              >
                <option value="all">Tous continents</option>
                {continents.map(continent => (
                  <option key={continent} value={continent}>{continent}</option>
                ))}
              </select>
              
              <select
                value={selectedRegion}
                onChange={(e) => setSelectedRegion(e.target.value)}
                className="px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500"
              >
                <option value="all">Toutes régions</option>
                {regions.map(region => (
                  <option key={region} value={region}>{region}</option>
                ))}
              </select>
            </div>
          </div>
          
          {/* Liste des langues groupées par continent */}
          <div className
