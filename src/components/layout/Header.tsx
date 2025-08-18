'use client'

import Link from 'next/link'
import { useState } from 'react'
import { ChevronDown, User, Settings, Globe, Menu, X } from 'lucide-react'

// Interface pour les langues
interface Language {
  code: string
  name: string
  flag: string
}

// Langues supportées - 200+ selon spécifications README.md
const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'ar-ma', name: 'العربية (المغرب)', flag: '🇲🇦' },
  { code: 'ar-ps', name: 'العربية (فلسطين)', flag: '🇵🇸' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
]

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false)
  const [isLangOpen, setIsLangOpen] = useState<boolean>(false)
  const [isUserOpen, setIsUserOpen] = useState<boolean>(false)
  const [currentLang, setCurrentLang] = useState<Language>(LANGUAGES[0])

  const toggleMenu = (): void => setIsMenuOpen(!isMenuOpen)
  const toggleLang = (): void => setIsLangOpen(!isLangOpen)
  const toggleUser = (): void => setIsUserOpen(!isUserOpen)

  const handleLangChange = (lang: Language): void => {
    setCurrentLang(lang)
    setIsLangOpen(false)
  }

  return (
    <header className="bg-white shadow-lg border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          
          {/* Logo */}
          <div className="flex items-center">
            <Link href="/" className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white font-bold text-xl">M4C</span>
              </div>
              <div>
                <div className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  Math4Child
                </div>
                <div className="text-xs text-gray-500">v4.2.0</div>
              </div>
            </Link>
          </div>

          {/* Navigation Desktop */}
          <nav className="hidden lg:flex items-center space-x-8">
            <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Accueil
            </Link>
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Exercices
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Plans
            </Link>
            <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Dashboard
            </Link>
            <Link href="/profile" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Profil
            </Link>
          </nav>

          {/* Actions Desktop */}
          <div className="hidden lg:flex items-center space-x-4">
            
            {/* Sélecteur de langue */}
            <div className="relative">
              <button
                onClick={toggleLang}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors"
                type="button"
              >
                <span className="text-lg">{currentLang.flag}</span>
                <span className="text-sm font-medium text-gray-700">{currentLang.code.toUpperCase()}</span>
                <ChevronDown className="w-4 h-4 text-gray-500" />
              </button>
              
              {isLangOpen && (
                <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50 max-h-80 overflow-y-auto">
                  <div className="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                    Choisir une langue
                  </div>
                  {LANGUAGES.map((lang: Language) => (
                    <button
                      key={lang.code}
                      onClick={() => handleLangChange(lang)}
                      className="w-full flex items-center space-x-3 px-3 py-2 hover:bg-blue-50 transition-colors text-left"
                      type="button"
                    >
                      <span className="text-lg">{lang.flag}</span>
                      <span className="text-sm font-medium text-gray-700">{lang.name}</span>
                    </button>
                  ))}
                  <div className="border-t border-gray-200 mt-2 pt-2 px-3">
                    <div className="text-xs text-gray-500">
                      200+ langues supportées selon README.md
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Menu utilisateur */}
            <div className="relative">
              <button
                onClick={toggleUser}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors"
                type="button"
              >
                <div className="w-8 h-8 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm font-bold">E</span>
                </div>
                <span className="text-sm font-medium text-gray-700">Emma</span>
                <ChevronDown className="w-4 h-4 text-gray-500" />
              </button>
              
              {isUserOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50">
                  <Link href="/profile" className="flex items-center space-x-2 px-4 py-2 hover:bg-gray-50 transition-colors">
                    <User className="w-4 h-4 text-gray-500" />
                    <span className="text-sm text-gray-700">Mon Profil</span>
                  </Link>
                  <Link href="/dashboard" className="flex items-center space-x-2 px-4 py-2 hover:bg-gray-50 transition-colors">
                    <Settings className="w-4 h-4 text-gray-500" />
                    <span className="text-sm text-gray-700">Paramètres</span>
                  </Link>
                  <div className="border-t border-gray-200 my-2"></div>
                  <div className="px-4 py-2">
                    <div className="text-xs text-gray-500">Plan actuel</div>
                    <div className="text-sm font-medium text-purple-600">PREMIUM</div>
                  </div>
                </div>
              )}
            </div>

            {/* Bouton principal */}
            <Link
              href="/exercises"
              className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-300"
            >
              Commencer
            </Link>
          </div>

          {/* Menu mobile */}
          <div className="lg:hidden">
            <button
              onClick={toggleMenu}
              className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
              type="button"
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {/* Menu mobile étendu */}
        {isMenuOpen && (
          <div className="lg:hidden border-t border-gray-200 py-4">
            <div className="space-y-4">
              <Link href="/" className="block text-gray-700 hover:text-blue-600 font-medium">
                Accueil
              </Link>
              <Link href="/exercises" className="block text-gray-700 hover:text-blue-600 font-medium">
                Exercices
              </Link>
              <Link href="/pricing" className="block text-gray-700 hover:text-blue-600 font-medium">
                Plans
              </Link>
              <Link href="/dashboard" className="block text-gray-700 hover:text-blue-600 font-medium">
                Dashboard
              </Link>
              <Link href="/profile" className="block text-gray-700 hover:text-blue-600 font-medium">
                Profil
              </Link>
              
              <div className="border-t border-gray-200 pt-4">
                <div className="flex items-center space-x-2 mb-3">
                  <Globe className="w-5 h-5 text-gray-500" />
                  <span className="text-sm font-medium text-gray-700">Langue: {currentLang.name}</span>
                </div>
                <Link
                  href="/exercises"
                  className="block w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-3 rounded-lg font-semibold text-center"
                >
                  Commencer
                </Link>
              </div>
            </div>
          </div>
        )}
      </div>
    </header>
  )
}
