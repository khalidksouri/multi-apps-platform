"use client"

import { useState, useRef, useEffect } from "react"
import { ChevronDown, Globe, Search, X } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import { getLanguagesByRegion, REGIONS } from "@/data/languages/worldLanguages"

export default function LanguageSelector() {
  const { 
    language, 
    setLanguage, 
    availableLanguages, 
    currentLanguageInfo,
    totalLanguages
  } = useLanguage()
  
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedRegion, setSelectedRegion] = useState<string>("all")
  const dropdownRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm("")
      }
    }
    
    document.addEventListener("mousedown", handleClickOutside)
    return () => document.removeEventListener("mousedown", handleClickOutside)
  }, [])

  const filteredLanguages = availableLanguages.filter(lang => {
    const matchesSearch = !searchTerm || 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesRegion = selectedRegion === "all" || lang.region === selectedRegion
    
    return matchesSearch && matchesRegion
  })

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm("")
  }

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white hover:bg-gray-50 border border-gray-300 rounded-xl px-4 py-3 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[280px] group"
      >
        <Globe className="w-5 h-5 text-blue-600" />
        <span className="text-2xl">{currentLanguageInfo?.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-semibold text-gray-900">
            {currentLanguageInfo?.nativeName}
          </div>
          <div className="text-sm text-gray-500">
            {currentLanguageInfo?.name} • {currentLanguageInfo?.region}
          </div>
        </div>
        <div className="text-xs text-gray-400">
          {totalLanguages}+ langues
        </div>
        <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform group-hover:text-gray-600 ${isOpen ? "rotate-180" : ""}`} />
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 max-h-96 overflow-hidden">
          <div className="p-4 border-b border-gray-100 bg-gray-50">
            <div className="relative mb-3">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-8 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm("")}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
            
            <div className="flex flex-wrap gap-1">
              <button
                onClick={() => setSelectedRegion("all")}
                className={`px-3 py-1 text-xs rounded-full transition-colors ${
                  selectedRegion === "all"
                    ? "bg-blue-100 text-blue-700 font-medium"
                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                }`}
              >
                Toutes ({totalLanguages})
              </button>
              {REGIONS.map(region => {
                const count = getLanguagesByRegion(region).length
                return (
                  <button
                    key={region}
                    onClick={() => setSelectedRegion(region)}
                    className={`px-3 py-1 text-xs rounded-full transition-colors ${
                      selectedRegion === region
                        ? "bg-blue-100 text-blue-700 font-medium"
                        : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                    }`}
                  >
                    {region} ({count})
                  </button>
                )
              })}
            </div>
          </div>

          <div className="max-h-64 overflow-y-auto">
            {filteredLanguages.map((lang) => (
              <button
                key={lang.code}
                onClick={() => handleLanguageSelect(lang.code)}
                className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-blue-50 transition-all text-left border-b border-gray-50 last:border-b-0 ${
                  lang.code === language ? "bg-blue-100 border-r-4 border-blue-600" : ""
                }`}
              >
                <span className="text-2xl">{lang.flag}</span>
                <div className="flex-1 min-w-0">
                  <div className="font-semibold text-gray-900 truncate">
                    {lang.nativeName}
                  </div>
                  <div className="text-sm text-gray-500 truncate">
                    {lang.name} • {lang.region}
                    {lang.rtl && <span className="ml-1 text-xs bg-orange-100 text-orange-700 px-1 rounded">RTL</span>}
                  </div>
                </div>
                {lang.code === language && (
                  <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                )}
              </button>
            ))}
            
            {filteredLanguages.length === 0 && (
              <div className="p-8 text-center text-gray-500">
                <Globe className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                <p>Aucune langue trouvée</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
