'use client'

import React from 'react'
import { useLanguage } from '../i18n/hooks/LanguageContext'
import { SUPPORTED_LANGUAGES } from '../i18n/language-config'

interface LanguageSelectorProps {
  showStats?: boolean
  compact?: boolean
  className?: string
}

export default function LanguageSelector({ 
  showStats = true, 
  compact = false,
  className = '' 
}: LanguageSelectorProps) {
  const { currentLanguage, changeLanguage, isRTL, isLoading, t, stats } = useLanguage()
  
  if (isLoading) {
    return (
      <div className={`animate-pulse bg-gray-200 rounded-lg w-36 h-10 ${className}`}></div>
    )
  }
  
  return (
    <div className={`flex items-center gap-4 ${className}`}>
      {/* Compteur de langues - EXACTEMENT 20 */}
      {showStats && (
        <div className="text-sm font-medium" data-testid="language-counter">
          <span className="text-blue-600 font-bold">{stats.total}</span>
          <span className="text-gray-600 ml-1">langues disponibles</span>
          {!compact && (
            <span className="text-xs text-gray-500 ml-2">
              ({stats.rtl} RTL + {stats.ltr} LTR)
            </span>
          )}
        </div>
      )}
      
      {/* Sélecteur principal */}
      <select
        data-testid="language-selector"
        className={`
          bg-white text-gray-800 px-4 py-2 rounded-lg border border-gray-300 
          focus:ring-2 focus:ring-blue-500 focus:border-transparent 
          outline-none cursor-pointer transition-all duration-200
          hover:border-gray-400 hover:shadow-md min-w-36
          ${isRTL ? 'text-right' : 'text-left'}
          ${compact ? 'text-sm' : ''}
        `}
        value={currentLanguage.code}
        onChange={(e) => changeLanguage(e.target.value as any)}
        dir={isRTL ? 'rtl' : 'ltr'}
        aria-label={t.interface.selectLanguage}
      >
        {SUPPORTED_LANGUAGES.map((lang) => (
          <option key={lang.code} value={lang.code}>
            {lang.flag} {compact ? lang.code.toUpperCase() : lang.nativeName}
          </option>
        ))}
      </select>
    </div>
  )
}
