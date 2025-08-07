"use client"

import { useState, useRef, useEffect } from "react"
import { Globe, ChevronDown, Search, X } from "lucide-react"
import { WORLD_LANGUAGES, getAllRegions } from "@/data/languages/worldLanguages"

interface LanguageSelectorProps {
  currentLanguage: string
  onLanguageChange: (languageCode: string) => void
  className?: string
}

export default function LanguageSelector({ 
  currentLanguage, 
  onLanguageChange, 
  className = "" 
}: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedRegion, setSelectedRegion] = useState("all")
  const dropdownRef = useRef<HTMLDivElement>(null)

  const currentLang = WORLD_LANGUAGES.find(lang => lang.code === currentLanguage) || WORLD_LANGUAGES[0]
  const regions = getAllRegions()

  // Fermer le dropdown quand on clique à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm("")
        setSelectedRegion("all")
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filtrer les langues
  const filteredLanguages = WORLD_LANGUAGES.filter(lang => {
    // Filtre par région
    if (selectedRegion !== "all" && lang.region !== selectedRegion) {
      return false
    }
    
    // Filtre par recherche
    if (!searchTerm.trim()) return true
    
    const search = searchTerm.toLowerCase().trim()
    return (
      lang.nativeName.toLowerCase().includes(search) ||
      lang.name.toLowerCase().includes(search) ||
      lang.code.toLowerCase().includes(search) ||
      lang.region.toLowerCase().includes(search)
    )
  })

  const handleLanguageSelect = (languageCode: string) => {
    onLanguageChange(languageCode)
    setIsOpen(false)
    setSearchTerm("")
    setSelectedRegion("all")
  }

  const clearSearch = () => {
    setSearchTerm("")
    setSelectedRegion("all")
  }

  return (
    <div className={`relative ${className}`} ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 bg-white/90 hover:bg-white border border-gray-200 rounded-lg px-3 py-2 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[120px]"
      >
        <Globe className="w-4 h-4 text-blue-600" />
        <span className="text-lg">{currentLang.flag}</span>
        <span className="text-sm font-medium hidden sm:block truncate">
          {currentLang.nativeName}
        </span>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform ${
          isOpen ? 'rotate-180' : ''
        }`} />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full right-0 mt-2 w-96 bg-white border border-gray-200 rounded-xl shadow-2xl z-50">
          
          {/* Header avec recherche et statistiques */}
          <div className="p-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-sm font-semibold text-gray-900 flex items-center">
                <Globe className="w-4 h-4 mr-2 text-blue-500" />
                Choisir une langue
              </h3>
              <span className="text-xs bg-gradient-to-r from-blue-500 to-purple-500 text-white px-2 py-1 rounded-full font-medium">
                {filteredLanguages.length} / {WORLD_LANGUAGES.length}
              </span>
            </div>
            
            {/* Barre de recherche */}
            <div className="relative mb-3">
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-9 pr-9 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white"
              />
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              {(searchTerm || selectedRegion !== "all") && (
                <button
                  onClick={clearSearch}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>

            {/* Filtre par région */}
            <div className="flex gap-2 flex-wrap">
              <button
                onClick={() => setSelectedRegion("all")}
                className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${
                  selectedRegion === "all"
                    ? "bg-blue-500 text-white"
                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                }`}
              >
                Toutes
              </button>
              {regions.map(region => (
                <button
                  key={region}
                  onClick={() => setSelectedRegion(region)}
                  className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${
                    selectedRegion === region
                      ? "bg-blue-500 text-white"
                      : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                  }`}
                >
                  {region}
                </button>
              ))}
            </div>
          </div>
          
          {/* Liste des langues avec scroll stylisé */}
          <div 
            className="max-h-80 overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100"
          >
            {/* Message si aucun résultat */}
            {filteredLanguages.length === 0 && (
              <div className="p-6 text-center text-gray-500">
                <Search className="w-8 h-8 mx-auto mb-2 text-gray-400" />
                <p className="font-medium">Aucune langue trouvée</p>
                <p className="text-xs mt-1">
                  Essayez avec "{searchTerm}" ou changez de région
                </p>
                <button
                  onClick={clearSearch}
                  className="mt-2 text-blue-500 text-xs hover:underline"
                >
                  Effacer les filtres
                </button>
              </div>
            )}
            
            {/* Groupement par régions si pas de recherche */}
            {!searchTerm && selectedRegion === "all" ? (
              regions.map(region => {
                const regionLanguages = filteredLanguages.filter(lang => lang.region === region)
                if (regionLanguages.length === 0) return null
                
                return (
                  <div key={region}>
                    <div className="px-4 py-2 bg-gray-50 border-y border-gray-100">
                      <h4 className="text-xs font-semibold text-gray-600 uppercase tracking-wide">
                        {region} ({regionLanguages.length})
                      </h4>
                    </div>
                    {regionLanguages.map((language) => (
                      <LanguageItem
                        key={language.code}
                        language={language}
                        isSelected={currentLanguage === language.code}
                        onSelect={() => handleLanguageSelect(language.code)}
                      />
                    ))}
                  </div>
                )
              })
            ) : (
              // Liste simple si recherche ou filtre région
              filteredLanguages.map((language) => (
                <LanguageItem
                  key={language.code}
                  language={language}
                  isSelected={currentLanguage === language.code}
                  onSelect={() => handleLanguageSelect(language.code)}
                />
              ))
            )}
          </div>
          
          {/* Footer avec statistiques */}
          <div className="p-3 border-t border-gray-100 bg-gray-50">
            <div className="flex items-center justify-between text-xs text-gray-600">
              <span>
                🌍 {filteredLanguages.length} langue{filteredLanguages.length > 1 ? 's' : ''}
                {searchTerm && ` pour "${searchTerm}"`}
                {selectedRegion !== "all" && ` en ${selectedRegion}`}
              </span>
              {currentLanguage && (
                <span className="font-medium">
                  Actuelle: {currentLang.nativeName}
                </span>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

// Composant pour chaque langue
function LanguageItem({ 
  language, 
  isSelected, 
  onSelect 
}: { 
  language: typeof WORLD_LANGUAGES[0]
  isSelected: boolean
  onSelect: () => void
}) {
  return (
    <button
      onClick={onSelect}
      className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left group ${
        isSelected ? 'bg-blue-50 border-r-2 border-blue-500' : ''
      }`}
    >
      <span className="text-lg flex-shrink-0 group-hover:scale-110 transition-transform">
        {language.flag}
      </span>
      <div className="flex-1 min-w-0">
        <div className={`font-medium truncate ${
          isSelected ? 'text-blue-700' : 'text-gray-900'
        }`}>
          {language.nativeName}
        </div>
        <div className="text-xs text-gray-500 truncate flex items-center gap-2">
          <span>{language.name}</span>
          <span className="text-gray-300">•</span>
          <span>{language.region}</span>
          {language.isRTL && (
            <>
              <span className="text-gray-300">•</span>
              <span className="bg-orange-100 text-orange-600 px-1 rounded text-[10px] font-medium">
                RTL
              </span>
            </>
          )}
        </div>
      </div>
      {isSelected && (
        <div className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0 animate-pulse"></div>
      )}
    </button>
  )
}
