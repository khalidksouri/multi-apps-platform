'use client'

import Link from 'next/link'
import { useState } from 'react'
import { Menu, X, Globe, BookOpen, ChevronDown } from 'lucide-react'

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar-ma', name: 'العربية (المغرب)', flag: '🇲🇦' },
  { code: 'ar-ps', name: 'العربية (فلسطين)', flag: '🇵🇸' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
]

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [isLangOpen, setIsLangOpen] = useState(false)
  const [currentLang, setCurrentLang] = useState(LANGUAGES[0])

  return (
    <header className="bg-white shadow-sm sticky top-0 z-50 border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
              <BookOpen className="w-6 h-6 text-white" />
            </div>
            <div>
              <div className="font-bold text-xl text-gray-900">Math4Child</div>
              <div className="text-xs text-gray-500">v4.2.0</div>
            </div>
          </Link>

          {/* Navigation Desktop */}
          <nav className="hidden md:flex space-x-8">
            <Link href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 transition-colors">
              Accueil
            </Link>
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 px-3 py-2 transition-colors">
              Exercices
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 px-3 py-2 transition-colors">
              Tarification
            </Link>
            <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 px-3 py-2 transition-colors">
              Dashboard
            </Link>
          </nav>

          {/* Actions droite */}
          <div className="flex items-center space-x-4">
            {/* Badge 200+ Langues */}
            <div className="hidden sm:flex items-center space-x-2 px-3 py-1 bg-blue-50 rounded-full">
              <Globe className="w-4 h-4 text-blue-600" />
              <span className="text-sm font-medium text-blue-700">200+ Langues</span>
            </div>
            
            {/* Dropdown langues */}
            <div className="relative">
              <button
                onClick={() => setIsLangOpen(!isLangOpen)}
                className="flex items-center space-x-2 px-3 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
              >
                <span className="text-lg">{currentLang.flag}</span>
                <span className="hidden sm:inline text-sm font-medium">{currentLang.name}</span>
                <ChevronDown className={`w-4 h-4 transition-transform ${isLangOpen ? 'rotate-180' : ''}`} />
              </button>
              
              {isLangOpen && (
                <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50">
                  <div className="px-4 py-2 border-b border-gray-100">
                    <div className="text-xs font-semibold text-gray-500 uppercase tracking-wide">
                      Support Mondial 200+ Langues
                    </div>
                  </div>
                  <div className="max-h-64 overflow-y-auto">
                    {LANGUAGES.map((lang) => (
                      <button
                        key={lang.code}
                        onClick={() => {
                          setCurrentLang(lang)
                          setIsLangOpen(false)
                        }}
                        className={`w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center space-x-3 ${
                          currentLang.code === lang.code ? 'bg-blue-50 text-blue-700' : ''
                        }`}
                      >
                        <span className="text-lg">{lang.flag}</span>
                        <span className="text-sm">{lang.name}</span>
                      </button>
                    ))}
                  </div>
                  <div className="px-4 py-2 border-t border-gray-100">
                    <div className="text-xs text-gray-500">
                      Millions d'enfants • Accessibilité universelle
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Menu mobile */}
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="md:hidden p-2 text-gray-600 hover:text-gray-900"
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {/* Menu mobile ouvert */}
        {isMenuOpen && (
          <div className="md:hidden py-4 border-t border-gray-200">
            <div className="flex flex-col space-y-2">
              <Link href="/" className="px-3 py-2 text-gray-700 hover:text-blue-600">
                Accueil
              </Link>
              <Link href="/exercises" className="px-3 py-2 text-gray-700 hover:text-blue-600">
                Exercices
              </Link>
              <Link href="/pricing" className="px-3 py-2 text-gray-700 hover:text-blue-600">
                Tarification
              </Link>
              <Link href="/dashboard" className="px-3 py-2 text-gray-700 hover:text-blue-600">
                Dashboard
              </Link>
            </div>
          </div>
        )}
      </div>
    </header>
  )
}
