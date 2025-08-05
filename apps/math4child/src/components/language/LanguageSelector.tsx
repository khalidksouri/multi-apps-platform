"use client"

import { useState } from "react"
import { ChevronDown, Globe } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"

export default function LanguageSelector() {
  const { language, setLanguage, availableLanguages } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)

  const currentLanguage = availableLanguages.find(lang => lang.code === language)

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white hover:bg-gray-50 border border-gray-300 rounded-xl px-4 py-3 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[200px]"
      >
        <Globe className="w-5 h-5 text-blue-600" />
        <span className="text-2xl">{currentLanguage?.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-semibold text-gray-900">{currentLanguage?.nativeName}</div>
          <div className="text-sm text-gray-500">{currentLanguage?.name}</div>
        </div>
        <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isOpen ? "rotate-180" : ""}`} />
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 max-h-64 overflow-y-auto">
          {availableLanguages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => {
                setLanguage(lang.code)
                setIsOpen(false)
              }}
              className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-blue-50 transition-all text-left ${
                lang.code === language ? "bg-blue-100 border-r-4 border-blue-600" : ""
              }`}
            >
              <span className="text-2xl">{lang.flag}</span>
              <div className="flex-1">
                <div className="font-semibold text-gray-900">{lang.nativeName}</div>
                <div className="text-sm text-gray-500">{lang.name} • {lang.region}</div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}
