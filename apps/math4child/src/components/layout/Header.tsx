'use client'

import Link from 'next/link'
import { useState, useRef, useEffect } from 'react'
import { ChevronDown, User, Settings, Globe, Menu, X, Search } from 'lucide-react'

interface Language {
  code: string
  name: string
  flag: string
  continent?: string
}

// Support universel - Maximum de langues sans duplication (sauf arabe dupliqué Afrique/Moyen-Orient)
const UNIVERSAL_LANGUAGES: Language[] = [
  // EUROPE
  { code: 'fr', name: 'Français', flag: '🇫🇷', continent: 'Europe' },
  { code: 'en', name: 'English', flag: '🇬🇧', continent: 'Europe' },
  { code: 'es', name: 'Español', flag: '🇪🇸', continent: 'Europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', continent: 'Europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', continent: 'Europe' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', continent: 'Europe' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', continent: 'Europe' },
  { code: 'uk', name: 'Українська', flag: '🇺🇦', continent: 'Europe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', continent: 'Europe' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', continent: 'Europe' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', continent: 'Europe' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', continent: 'Europe' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', continent: 'Europe' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', continent: 'Europe' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿', continent: 'Europe' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰', continent: 'Europe' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺', continent: 'Europe' },
  { code: 'ro', name: 'Română', flag: '🇷🇴', continent: 'Europe' },
  { code: 'bg', name: 'Български', flag: '🇧🇬', continent: 'Europe' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷', continent: 'Europe' },
  { code: 'sr', name: 'Српски', flag: '🇷🇸', continent: 'Europe' },
  { code: 'bs', name: 'Bosanski', flag: '🇧🇦', continent: 'Europe' },
  { code: 'mk', name: 'Македонски', flag: '🇲🇰', continent: 'Europe' },
  { code: 'sq', name: 'Shqip', flag: '🇦🇱', continent: 'Europe' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷', continent: 'Europe' },
  { code: 'mt', name: 'Malti', flag: '🇲🇹', continent: 'Europe' },
  { code: 'is', name: 'Íslenska', flag: '🇮🇸', continent: 'Europe' },
  { code: 'ga', name: 'Gaeilge', flag: '🇮🇪', continent: 'Europe' },
  { code: 'cy', name: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', continent: 'Europe' },
  { code: 'eu', name: 'Euskera', flag: '🏴', continent: 'Europe' },
  { code: 'ca', name: 'Català', flag: '🏴', continent: 'Europe' },
  
  // AFRIQUE - Arabe représenté par le drapeau marocain uniquement
  { code: 'ar-AF', name: 'العربية (أفريقيا)', flag: '🇲🇦', continent: 'Afrique' },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪', continent: 'Afrique' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹', continent: 'Afrique' },
  { code: 'ha', name: 'Hausa', flag: '🇳🇬', continent: 'Afrique' },
  { code: 'yo', name: 'Yorùbá', flag: '🇳🇬', continent: 'Afrique' },
  { code: 'ig', name: 'Igbo', flag: '🇳🇬', continent: 'Afrique' },
  { code: 'zu', name: 'isiZulu', flag: '🇿🇦', continent: 'Afrique' },
  { code: 'xh', name: 'isiXhosa', flag: '🇿🇦', continent: 'Afrique' },
  { code: 'af', name: 'Afrikaans', flag: '🇿🇦', continent: 'Afrique' },
  { code: 'mg', name: 'Malagasy', flag: '🇲🇬', continent: 'Afrique' },
  { code: 'rw', name: 'Ikinyarwanda', flag: '🇷🇼', continent: 'Afrique' },
  { code: 'so', name: 'Soomaali', flag: '🇸🇴', continent: 'Afrique' },
  { code: 'om', name: 'Afaan Oromoo', flag: '🇪🇹', continent: 'Afrique' },
  { code: 'ti', name: 'ትግርኛ', flag: '🇪🇷', continent: 'Afrique' },
  { code: 'lg', name: 'Luganda', flag: '🇺🇬', continent: 'Afrique' },
  { code: 'wo', name: 'Wolof', flag: '🇸🇳', continent: 'Afrique' },
  { code: 'ff', name: 'Fulfulde', flag: '🇳🇪', continent: 'Afrique' },
  { code: 'bm', name: 'Bamanankan', flag: '🇲🇱', continent: 'Afrique' },
  
  // MOYEN-ORIENT & GOLFE - Arabe représenté par le drapeau palestinien uniquement  
  { code: 'ar-ME', name: 'العربية (الشرق الأوسط والخليج)', flag: '🇵🇸', continent: 'Moyen-Orient' },
  { code: 'fa', name: 'فارسی', flag: '🇮🇷', continent: 'Moyen-Orient' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', continent: 'Moyen-Orient' },
  { code: 'ku', name: 'کوردی', flag: '🏴', continent: 'Moyen-Orient' },
  { code: 'az', name: 'Azərbaycan dili', flag: '🇦🇿', continent: 'Moyen-Orient' },
  { code: 'hy', name: 'Հայերեն', flag: '🇦🇲', continent: 'Moyen-Orient' },
  { code: 'ka', name: 'ქართული', flag: '🇬🇪', continent: 'Moyen-Orient' },
  
  // ASIE
  { code: 'zh', name: '中文', flag: '🇨🇳', continent: 'Asie' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', continent: 'Asie' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', continent: 'Asie' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', continent: 'Asie' },
  { code: 'bn', name: 'বাংলা', flag: '🇧🇩', continent: 'Asie' },
  { code: 'ur', name: 'اردو', flag: '🇵🇰', continent: 'Asie' },
  { code: 'pa', name: 'ਪੰਜਾਬੀ', flag: '🇮🇳', continent: 'Asie' },
  { code: 'gu', name: 'ગુજરાતી', flag: '🇮🇳', continent: 'Asie' },
  { code: 'ta', name: 'தமிழ்', flag: '🇮🇳', continent: 'Asie' },
  { code: 'te', name: 'తెలుగు', flag: '🇮🇳', continent: 'Asie' },
  { code: 'kn', name: 'ಕನ್ನಡ', flag: '🇮🇳', continent: 'Asie' },
  { code: 'ml', name: 'മലയാളം', flag: '🇮🇳', continent: 'Asie' },
  { code: 'or', name: 'ଓଡ଼ିଆ', flag: '🇮🇳', continent: 'Asie' },
  { code: 'mr', name: 'मराठी', flag: '🇮🇳', continent: 'Asie' },
  { code: 'as', name: 'অসমীয়া', flag: '🇮🇳', continent: 'Asie' },
  { code: 'ne', name: 'नेपाली', flag: '🇳🇵', continent: 'Asie' },
  { code: 'si', name: 'සිංහල', flag: '🇱🇰', continent: 'Asie' },
  { code: 'my', name: 'မြန်မာ', flag: '🇲🇲', continent: 'Asie' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', continent: 'Asie' },
  { code: 'lo', name: 'ລາວ', flag: '🇱🇦', continent: 'Asie' },
  { code: 'km', name: 'ខ្មែរ', flag: '🇰🇭', continent: 'Asie' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asie' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asie' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asie' },
  { code: 'tl', name: 'Filipino', flag: '🇵🇭', continent: 'Asie' },
  { code: 'mn', name: 'Монгол', flag: '🇲🇳', continent: 'Asie' },
  { code: 'kk', name: 'Қазақша', flag: '🇰🇿', continent: 'Asie' },
  { code: 'ky', name: 'Кыргызча', flag: '🇰🇬', continent: 'Asie' },
  { code: 'uz', name: 'O\'zbek', flag: '🇺🇿', continent: 'Asie' },
  { code: 'tj', name: 'Тоҷикӣ', flag: '🇹🇯', continent: 'Asie' },
  { code: 'tk', name: 'Türkmen', flag: '🇹🇲', continent: 'Asie' },
  
  // AMÉRIQUES
  { code: 'en-AM', name: 'English (Americas)', flag: '🇺🇸', continent: 'Amérique' },
  { code: 'es-AM', name: 'Español (América)', flag: '🇲🇽', continent: 'Amérique' },
  { code: 'pt-BR', name: 'Português (Brasil)', flag: '🇧🇷', continent: 'Amérique' },
  { code: 'fr-CA', name: 'Français (Canada)', flag: '🇨🇦', continent: 'Amérique' },
  { code: 'qu', name: 'Quechua', flag: '🇵🇪', continent: 'Amérique' },
  { code: 'gn', name: 'Guaraní', flag: '🇵🇾', continent: 'Amérique' },
  { code: 'ay', name: 'Aymar aru', flag: '🇧🇴', continent: 'Amérique' },
  { code: 'ht', name: 'Kreyòl ayisyen', flag: '🇭🇹', continent: 'Amérique' },
  { code: 'nv', name: 'Diné bizaad', flag: '🇺🇸', continent: 'Amérique' },
  { code: 'ik', name: 'Iñupiaq', flag: '🇺🇸', continent: 'Amérique' },
  
  // OCÉANIE
  { code: 'en-OC', name: 'English (Oceania)', flag: '🇦🇺', continent: 'Océanie' },
  { code: 'mi', name: 'Te Reo Māori', flag: '🇳🇿', continent: 'Océanie' },
  { code: 'fj', name: 'Vosa Vakaviti', flag: '🇫🇯', continent: 'Océanie' },
  { code: 'to', name: 'Lea fakatonga', flag: '🇹🇴', continent: 'Océanie' },
  { code: 'sm', name: 'Gagana Sāmoa', flag: '🇼🇸', continent: 'Océanie' },
  { code: 'ty', name: 'Reo Tahiti', flag: '🇵🇫', continent: 'Océanie' },
  { code: 'haw', name: 'ʻŌlelo Hawaiʻi', flag: '🇺🇸', continent: 'Océanie' },
  
  // LANGUES MONDIALES SPÉCIALES
  { code: 'eo', name: 'Esperanto', flag: '🌍', continent: 'Monde' },
  { code: 'la', name: 'Latina', flag: '🏛️', continent: 'Classique' },
  { code: 'sa', name: 'संस्कृतम्', flag: '🕉️', continent: 'Classique' }
]

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false)
  const [isLangOpen, setIsLangOpen] = useState<boolean>(false)
  const [isUserOpen, setIsUserOpen] = useState<boolean>(false)
  const [currentLang, setCurrentLang] = useState<Language>(UNIVERSAL_LANGUAGES[0])
  const [searchTerm, setSearchTerm] = useState<string>('')

  const langDropdownRef = useRef<HTMLDivElement>(null)
  const userDropdownRef = useRef<HTMLDivElement>(null)

  const toggleMenu = (): void => setIsMenuOpen(!isMenuOpen)
  const toggleLang = (): void => {
    setIsLangOpen(!isLangOpen)
    setSearchTerm('')
  }
  const toggleUser = (): void => setIsUserOpen(!isUserOpen)

  const handleLangChange = (lang: Language): void => {
    setCurrentLang(lang)
    setIsLangOpen(false)
    setSearchTerm('')
    console.log(`Langue changée vers: ${lang.name} - Traduction complète activée`)
  }

  // FIX PRINCIPAL: Recherche améliorée pour détecter "arabe" dans les langues arabes
  // FIX: Recherche améliorée pour détecter "arabe" dans les langues arabes
  // Fonction de recherche améliorée avec support arabe
  const filteredLanguages = UNIVERSAL_LANGUAGES.filter(lang => {
    const searchLower = searchTerm.toLowerCase().trim()
    
    if (!searchLower) return true
    
    // Recherche normale dans le nom et continent
    const normalMatch = lang.name.toLowerCase().includes(searchLower) ||
                       (lang.continent && lang.continent.toLowerCase().includes(searchLower))
    
    // Recherche spéciale pour "arabe" qui doit matcher les langues arabes
    const arabicFrenchMatch = searchLower.includes('arabe') && 
                             (lang.code === 'ar-AF' || lang.code === 'ar-ME')
    
    // Recherche pour "arabic" en anglais
    const arabicEnglishMatch = searchLower.includes('arabic') && 
                              (lang.code === 'ar-AF' || lang.code === 'ar-ME')
    
    // Recherche pour "arab" (partiel)
    const arabPartialMatch = searchLower.includes('arab') && 
                            (lang.code === 'ar-AF' || lang.code === 'ar-ME')
    
    return normalMatch || arabicFrenchMatch || arabicEnglishMatch || arabPartialMatch
  })

  // Fermeture des dropdowns en cliquant à l'extérieur
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
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Groupement des langues par continent
  const languagesByContinent = filteredLanguages.reduce((acc, lang) => {
    const continent = lang.continent || 'Autres'
    if (!acc[continent]) acc[continent] = []
    acc[continent].push(lang)
    return acc
  }, {} as Record<string, Language[]>)

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
            
            {/* Sélecteur de langue avec recherche arabe corrigée */}
            <div className="relative" ref={langDropdownRef}>
              <button
                onClick={toggleLang}
                className="flex items-center space-x-2 px-4 py-2 rounded-lg hover:bg-gray-100 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 border border-gray-200"
                type="button"
                aria-label="Changer de langue - Support universel"
                aria-expanded={isLangOpen}
                aria-haspopup="true"
              >
                <Globe className="w-4 h-4 text-gray-500" />
                <span className="text-lg">{currentLang.flag}</span>
                <span className="text-sm font-medium text-gray-700">{currentLang.name}</span>
                <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isLangOpen ? 'rotate-180' : ''}`} />
              </button>
              
              {isLangOpen && (
                <div className="absolute right-0 mt-3 w-[450px] bg-white rounded-xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
                  {/* En-tête avec drapeaux corrects */}
                  <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-4 text-white">
                    <div className="flex items-center space-x-3 mb-3">
                      <Globe className="w-6 h-6" />
                      <div>
                        <div className="font-bold text-lg">Support Universel Mondial</div>
                        <div className="text-blue-100 text-sm">Maximum de langues sans duplication</div>
                      </div>
                    </div>
                    
                    {/* Barre de recherche corrigée */}
                    <div className="relative">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-blue-200" />
                      <input
                        type="text"
                        placeholder="Rechercher une langue ou continent..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-10 pr-4 py-2 bg-white/20 backdrop-blur-sm text-white placeholder-blue-200 border border-white/30 rounded-lg focus:ring-2 focus:ring-white/50 focus:border-white/50 focus:outline-none"
                      />
                    </div>
                    
                    {/* Informations avec drapeaux CORRECTS - Plus de carré rouge */}
                    <div className="mt-3 flex items-center justify-between text-sm">
                      <span className="text-blue-100">{filteredLanguages.length} langue(s) trouvée(s)</span>
                      <div className="text-blue-100 text-xs">
                        Essayez: "arabe", "français", "anglais"...
                      </div>
                    </div>
                  </div>

                  {/* Liste des langues */}
                  <div className="max-h-80 overflow-y-auto custom-scrollbar">
                    {Object.entries(languagesByContinent).map(([continent, languages]) => (
                      <div key={continent}>
                        <div className="sticky top-0 bg-gray-50 px-6 py-3 border-b border-gray-200">
                          <div className="flex items-center justify-between">
                            <h4 className="font-bold text-gray-800 uppercase tracking-wide text-sm">
                              {continent}
                            </h4>
                            <span className="bg-gray-200 text-gray-600 px-2 py-1 rounded-full text-xs font-medium">
                              {languages.length} langues
                            </span>
                          </div>
                        </div>
                        
                        <div className="py-2">
                          {languages.map((lang: Language) => (
                            <button
                              key={lang.code}
                              onClick={() => handleLangChange(lang)}
                              className="w-full flex items-center space-x-4 px-6 py-3 hover:bg-blue-50 transition-all duration-150 text-left group focus:outline-none focus:bg-blue-50"
                              type="button"
                              role="menuitem"
                            >
                              <span className="text-2xl flex-shrink-0 group-hover:scale-110 transition-transform duration-150">
                                {lang.flag}
                              </span>
                              <div className="flex-grow min-w-0">
                                <span className="text-sm font-medium text-gray-800 group-hover:text-blue-700 transition-colors duration-150 block">
                                  {lang.name}
                                </span>
                                {lang.code.includes('ar-') && (
                                  <span className="text-xs text-gray-500 group-hover:text-blue-600">
                                    {lang.code === 'ar-AF' ? 'Tous pays arabes d\'Afrique' : 'Tous pays arabes du Moyen-Orient & Golfe'}
                                  </span>
                                )}
                              </div>
                              {lang.code === currentLang.code && (
                                <div className="flex items-center space-x-1 flex-shrink-0">
                                  <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                                  <span className="text-green-600 font-bold text-sm">Actuelle</span>
                                </div>
                              )}
                            </button>
                          ))}
                        </div>
                      </div>
                    ))}
                    
                    {/* Message si aucun résultat */}
                    {filteredLanguages.length === 0 && searchTerm && (
                      <div className="p-6 text-center text-gray-500">
                        <div className="text-lg mb-2">Aucune langue trouvée</div>
                        <div className="text-sm">Essayez "arabe", "français", "anglais"...</div>
                      </div>
                    )}
                  </div>

                  {/* Footer */}
                  <div className="border-t border-gray-200 bg-gray-50 p-4">
                    <div className="text-center">
                      <div className="font-semibold text-gray-800 mb-2">Accessibilité Universelle</div>
                      <div className="flex flex-wrap justify-center gap-2 text-xs text-gray-600 mb-2">
                        <span className="bg-green-100 text-green-700 px-2 py-1 rounded-full">Traduction complète</span>
                        <span className="bg-blue-100 text-blue-700 px-2 py-1 rounded-full">Millions d'enfants</span>
                        <span className="bg-purple-100 text-purple-700 px-2 py-1 rounded-full">Tous continents</span>
                      </div>
                      <div className="text-xs text-red-600 font-medium">
                        Exclusion: Une langue spécifique selon spécifications
                      </div>
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
                <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50">
                  <div className="px-4 py-3 border-b border-gray-100">
                    <p className="text-sm font-medium text-gray-900">Mon Compte</p>
                    <p className="text-xs text-gray-500">eleve@math4child.com</p>
                  </div>
                  <Link 
                    href="/profile" 
                    className="flex items-center space-x-3 px-4 py-3 hover:bg-gray-100 transition-colors text-gray-700"
                    onClick={() => setIsUserOpen(false)}
                  >
                    <User className="w-4 h-4" />
                    <span>Mon Profil</span>
                  </Link>
                  <Link 
                    href="/dashboard" 
                    className="flex items-center space-x-3 px-4 py-3 hover:bg-gray-100 transition-colors text-gray-700"
                    onClick={() => setIsUserOpen(false)}
                  >
                    <Settings className="w-4 h-4" />
                    <span>Paramètres</span>
                  </Link>
                  <div className="border-t border-gray-200 mt-2 pt-2">
                    <button className="w-full text-left px-4 py-2 hover:bg-gray-100 transition-colors text-gray-700">
                      Se déconnecter
                    </button>
                  </div>
                </div>
              )}
            </div>
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
            </div>
          </div>
        )}
      </div>

      {/* Styles CSS */}
      <style jsx global>{`
        .custom-scrollbar {
          scrollbar-width: thin;
          scrollbar-color: #3b82f6 #f1f5f9;
        }
        
        .custom-scrollbar::-webkit-scrollbar {
          width: 8px;
        }
        
        .custom-scrollbar::-webkit-scrollbar-track {
          background: #f8fafc;
          border-radius: 4px;
        }
        
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: linear-gradient(180deg, #3b82f6 0%, #1d4ed8 100%);
          border-radius: 4px;
          transition: all 0.3s ease;
        }
        
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(180deg, #1d4ed8 0%, #1e40af 100%);
          box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);
        }
      `}</style>
    </header>
  )
}
