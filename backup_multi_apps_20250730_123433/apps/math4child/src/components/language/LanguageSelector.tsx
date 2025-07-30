'use client'

import React from 'react'
import { useLanguage } from '@/contexts/LanguageContext'
import { SUPPORTED_LANGUAGES } from '@/lib/translations/comprehensive'

export default function LanguageSelector() {
  const { currentLanguage, changeLanguage, isRTL } = useLanguage()
  
  return (
    <div className="relative">
      <select
        data-testid="language-selector"
        className={`
          bg-white text-gray-800 px-4 py-2 rounded-lg border-0 focus:ring-2 focus:ring-blue-500 outline-none cursor-pointer
          ${isRTL ? 'text-right' : 'text-left'}
        `}
        value={currentLanguage}
        onChange={(e) => changeLanguage(e.target.value as any)}
        dir={isRTL ? 'rtl' : 'ltr'}
      >
        {SUPPORTED_LANGUAGES.map((lang) => (
          <option key={lang.code} value={lang.code}>
            {lang.flag} {lang.name}
          </option>
        ))}
      </select>
    </div>
  )
}
