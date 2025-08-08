"use client"

import { useLanguage } from '@/hooks/useLanguage'

interface LanguageSelectorProps {
  compact?: boolean
}

export function LanguageSelector({ compact = true }: LanguageSelectorProps) {
  const { currentLanguage, setLanguage } = useLanguage()

  return (
    <select 
      value={currentLanguage} 
      onChange={(e) => setLanguage(e.target.value as any)}
      className="bg-gray-100 border border-gray-300 rounded-lg px-3 py-1 text-sm"
    >
      <option value="fr">🇫🇷 FR</option>
      <option value="en">🇺🇸 EN</option>
      <option value="es">🇪🇸 ES</option>
    </select>
  )
}
