'use client'
import React from 'react'
import { useLanguage } from '@/hooks/useLanguage'

const LanguageSelector: React.FC = () => {
  const { language, setLanguage } = useLanguage()

  const languages = [
    { code: 'fr', name: 'Français', flag: '🇫🇷' },
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'es', name: 'Español', flag: '🇪🇸' }
  ]

  return (
    <div className="flex gap-2">
      {languages.map((lang) => (
        <button
          key={lang.code}
          onClick={() => setLanguage(lang.code)}
          className={`flex items-center gap-1 px-3 py-1 rounded-lg transition-all ${
            language === lang.code
              ? 'bg-blue-500 text-white'
              : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
          }`}
        >
          <span>{lang.flag}</span>
          <span className="text-sm">{lang.name}</span>
        </button>
      ))}
    </div>
  )
}

export default LanguageSelector
