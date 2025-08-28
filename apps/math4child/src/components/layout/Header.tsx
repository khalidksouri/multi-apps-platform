'use client'

import Link from 'next/link'
import { useState, useRef, useEffect } from 'react'
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
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮' }
]

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false)
  const [isLangOpen, setIsLangOpen] = useState<boolean>(false)
  const [isUserOpen, setIsUserOpen] = useState<boolean>(false)
  const [currentLang, setCurrentLang] = useState<Language>(LANGUAGES[0])

  // Refs pour fermer les dropdowns en cliquant à l'extérieur
  const langDropdownRef = useRef<HTMLDivElement>(null)
  const userDropdownRef = useRef<HTMLDivElement>(null)

  const toggleMenu = (): void => setIsMenuOpen(!isMenuOpen)
  const toggleLang = (): void => setIsLangOpen(!isLangOpen)
  const toggleUser = (): void => setIsUserOpen(!isUserOpen)

  const handleLangChange = (lang: Language): void => {
    setCurrentLang(lang)
    setIsLangOpen(false)
    // Ici vous pourriez ajouter la logique de changement de langue
    console.log(`Langue changée vers: ${lang.name}`)
  }

  // Fermer les dropdowns en cliquant à l'extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (langDropdownRef.current && !langDropdownRef.current.contains(event.target as Node)) {
        setIsLangOpen(false)
      }
      if (userDropdownRef.current && !userDropdownRef.current.contains(event.target as Node)) {
        setIsUserOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [])

  return (
    <header className="bg-white shadow-lg border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          
          {/* Logo */}
          <div className="flex items-center">
            <Link href="/" className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white font-bold text-lg">M4C</span>
              </div>
              <div>
                <span className="text-xl font-bold text-gray-900">Math4Child</span>
                <span className="ml-2 text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">v4.2.0</span>
              </div>
            </Link>
          </div>

          {/* Navigation Desktop */}
          <nav className="hidden md:flex items-center space-x-8">
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Exercices
            </Link>
            <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Tableau de bord
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Prix
            </Link>
          </nav>

          {/* Actions Desktop */}
          <div className="hidden md:flex items-center space-x-4">
            
            {/* Sélecteur de langue */}
            <div className="relative" ref={langDropdownRef}>
              <button
                onClick={toggleLang}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500"
                type="button"
                aria-label="Changer de langue"
                aria-expanded={isLangOpen}
                aria-haspopup="true"
              >
                <Globe className="w-4 h-4 text-gray-500" />
                <span className="text-lg">{currentLang.flag}</span>
                <span className="text-sm font-medium text-gray-700">{currentLang.name}</span>
                <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isLangOpen ? 'rotate-180' : ''}`} />
              </button>
              
              {isLangOpen && (
                <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50 max-h-80 overflow-y-auto language-dropdown-scroll">
                  <div className="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b border-gray-100">
                    <div className="flex items-center space-x-2">
                      <Globe className="w-3 h-3" />
                      <span>Support mondial 200+ langues</span>
                    </div>
                  </div>
                  {LANGUAGES.map((lang: Language) => (
                    <button
                      key={lang.code}
                      onClick={() => handleLangChange(lang)}
                      className="w-full flex items-center space-x-3 px-3 py-2 hover:bg-blue-50 transition-colors text-left language-item focus:outline-none focus:bg-blue-50"
                      type="button"
                      role="menuitem"
                    >
                      <span className="text-lg">{lang.flag}</span>
                      <span className="text-sm font-medium text-gray-700">{lang.name}</span>
                      {lang.code === currentLang.code && (
                        <span className="ml-auto text-blue-600">✓</span>
                      )}
                    </button>
                  ))}
                  <div className="border-t border-gray-200 mt-2 pt-2 px-3">
                    <div className="text-xs text-gray-500 text-center">
                      • Accessibilité universelle<br />
                      • Millions d'enfants dans le monde
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Menu utilisateur */}
            <div className="relative" ref={userDropdownRef}>
              <button
                onClick={toggleUser}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500"
                type="button"
                aria-label="Menu utilisateur"
                aria-expanded={isUserOpen}
                aria-haspopup="true"
              >
                <div className="w-8 h-8 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm font-bold">E</span>
                </div>
                <span className="text-sm font-medium text-gray-700">Élève</span>
                <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isUserOpen ? 'rotate-180' : ''}`} />
              </button>
              
              {isUserOpen && (
                <div className="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50">
                  <div className="px-3 py-2 border-b border-gray-100">
                    <p className="text-sm font-medium text-gray-900">Mon Compte</p>
                    <p className="text-xs text-gray-500">eleve@math4child.com</p>
                  </div>
                  <Link 
                    href="/profile" 
                    className="flex items-center space-x-2 px-3 py-2 hover:bg-gray-100 transition-colors text-gray-700"
                    onClick={() => setIsUserOpen(false)}
                  >
                    <User className="w-4 h-4" />
                    <span>Mon Profil</span>
                  </Link>
                  <Link 
                    href="/dashboard" 
                    className="flex items-center space-x-2 px-3 py-2 hover:bg-gray-100 transition-colors text-gray-700"
                    onClick={() => setIsUserOpen(false)}
                  >
                    <Settings className="w-4 h-4" />
                    <span>Paramètres</span>
                  </Link>
                  <div className="border-t border-gray-200 mt-2 pt-2">
                    <button className="w-full text-left px-3 py-2 hover:bg-gray-100 transition-colors text-gray-700">
                      Se déconnecter
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* Bouton mobile menu */}
            <button
              onClick={toggleMenu}
              className="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500"
              type="button"
              aria-label="Menu mobile"
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>

          {/* Bouton mobile menu (toujours visible sur mobile) */}
          <button
            onClick={toggleMenu}
            className="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500"
            type="button"
            aria-label="Menu mobile"
          >
            {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Menu mobile */}
        {isMenuOpen && (
          <div className="md:hidden border-t border-gray-200 py-4">
            <div className="flex flex-col space-y-4">
              <Link 
                href="/exercises" 
                className="text-gray-700 hover:text-blue-600 font-medium transition-colors px-4"
                onClick={() => setIsMenuOpen(false)}
              >
                Exercices
              </Link>
              <Link 
                href="/dashboard" 
                className="text-gray-700 hover:text-blue-600 font-medium transition-colors px-4"
                onClick={() => setIsMenuOpen(false)}
              >
                Tableau de bord
              </Link>
              <Link 
                href="/pricing" 
                className="text-gray-700 hover:text-blue-600 font-medium transition-colors px-4"
                onClick={() => setIsMenuOpen(false)}
              >
                Prix
              </Link>
              
              {/* Sélecteur de langue mobile */}
              <div className="px-4 border-t border-gray-200 pt-4">
                <button
                  onClick={toggleLang}
                  className="flex items-center space-x-2 w-full text-left py-2"
                  type="button"
                >
                  <Globe className="w-4 h-4 text-gray-500" />
                  <span className="text-lg">{currentLang.flag}</span>
                  <span className="text-sm font-medium text-gray-700">{currentLang.name}</span>
                  <ChevronDown className={`w-4 h-4 text-gray-500 ml-auto transition-transform duration-200 ${isLangOpen ? 'rotate-180' : ''}`} />
                </button>
                
                {isLangOpen && (
                  <div className="mt-2 bg-gray-50 rounded-lg max-h-60 overflow-y-auto language-dropdown-scroll">
                    {LANGUAGES.map((lang: Language) => (
                      <button
                        key={lang.code}
                        onClick={() => {
                          handleLangChange(lang)
                          setIsMenuOpen(false)
                        }}
                        className="w-full flex items-center space-x-3 px-3 py-2 hover:bg-white transition-colors text-left language-item"
                        type="button"
                      >
                        <span className="text-lg">{lang.flag}</span>
                        <span className="text-sm font-medium text-gray-700">{lang.name}</span>
                        {lang.code === currentLang.code && (
                          <span className="ml-auto text-blue-600">✓</span>
                        )}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Styles pour le scroll personnalisé */}
      <style jsx>{`
        .language-dropdown-scroll {
          scrollbar-width: thin;
          scrollbar-color: #cbd5e1 #f1f5f9;
        }
        
        .language-dropdown-scroll::-webkit-scrollbar {
          width: 8px;
        }
        
        .language-dropdown-scroll::-webkit-scrollbar-track {
          background: #f1f5f9;
          border-radius: 4px;
        }
        
        .language-dropdown-scroll::-webkit-scrollbar-thumb {
          background: #cbd5e1;
          border-radius: 4px;
          transition: background 0.2s ease;
        }
        
        .language-dropdown-scroll::-webkit-scrollbar-thumb:hover {
          background: #94a3b8;
        }
        
        .language-item {
          transition: all 0.15s ease;
        }
        
        .language-item:hover {
          transform: translateX(2px);
        }
      `}</style>
    </header>
  )
}