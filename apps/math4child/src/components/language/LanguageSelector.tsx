"use client"

import { useState, useRef, useEffect } from "react"
import { Globe, ChevronDown, Search } from "lucide-react"

// Liste unique et corrigée des langues mondiales (sans doublons)
const WORLD_LANGUAGES = [
  // Europe
  { code: 'fr', flag: '🇫🇷', name: 'French', nativeName: 'Français' },
  { code: 'en', flag: '🇺🇸', name: 'English', nativeName: 'English' },
  { code: 'es', flag: '🇪🇸', name: 'Spanish', nativeName: 'Español' },
  { code: 'de', flag: '🇩🇪', name: 'German', nativeName: 'Deutsch' },
  { code: 'it', flag: '🇮🇹', name: 'Italian', nativeName: 'Italiano' },
  { code: 'pt', flag: '🇵🇹', name: 'Portuguese', nativeName: 'Português' },
  { code: 'ru', flag: '🇷🇺', name: 'Russian', nativeName: 'Русский' },
  { code: 'pl', flag: '🇵🇱', name: 'Polish', nativeName: 'Polski' },
  { code: 'nl', flag: '🇳🇱', name: 'Dutch', nativeName: 'Nederlands' },
  { code: 'sv', flag: '🇸🇪', name: 'Swedish', nativeName: 'Svenska' },
  { code: 'da', flag: '🇩🇰', name: 'Danish', nativeName: 'Dansk' },
  { code: 'no', flag: '🇳🇴', name: 'Norwegian', nativeName: 'Norsk' },
  { code: 'fi', flag: '🇫🇮', name: 'Finnish', nativeName: 'Suomi' },
  { code: 'cs', flag: '🇨🇿', name: 'Czech', nativeName: 'Čeština' },
  { code: 'hu', flag: '🇭🇺', name: 'Hungarian', nativeName: 'Magyar' },
  { code: 'ro', flag: '🇷🇴', name: 'Romanian', nativeName: 'Română' },
  { code: 'bg', flag: '🇧🇬', name: 'Bulgarian', nativeName: 'Български' },
  { code: 'hr', flag: '🇭🇷', name: 'Croatian', nativeName: 'Hrvatski' },
  { code: 'sk', flag: '🇸🇰', name: 'Slovak', nativeName: 'Slovenčina' },
  { code: 'sl', flag: '🇸🇮', name: 'Slovenian', nativeName: 'Slovenščina' },
  { code: 'et', flag: '🇪🇪', name: 'Estonian', nativeName: 'Eesti' },
  { code: 'lv', flag: '🇱🇻', name: 'Latvian', nativeName: 'Latviešu' },
  { code: 'lt', flag: '🇱🇹', name: 'Lithuanian', nativeName: 'Lietuvių' },
  { code: 'el', flag: '🇬🇷', name: 'Greek', nativeName: 'Ελληνικά' },
  { code: 'uk', flag: '🇺🇦', name: 'Ukrainian', nativeName: 'Українська' },
  { code: 'be', flag: '🇧🇾', name: 'Belarusian', nativeName: 'Беларуская' },
  { code: 'mk', flag: '🇲🇰', name: 'Macedonian', nativeName: 'Македонски' },
  { code: 'sq', flag: '🇦🇱', name: 'Albanian', nativeName: 'Shqip' },
  { code: 'bs', flag: '🇧🇦', name: 'Bosnian', nativeName: 'Bosanski' },
  { code: 'sr', flag: '🇷🇸', name: 'Serbian', nativeName: 'Српски' },
  { code: 'me', flag: '🇲🇪', name: 'Montenegrin', nativeName: 'Crnogorski' },
  
  // Asie
  { code: 'zh', flag: '🇨🇳', name: 'Chinese', nativeName: '中文' },
  { code: 'ja', flag: '🇯🇵', name: 'Japanese', nativeName: '日本語' },
  { code: 'ko', flag: '🇰🇷', name: 'Korean', nativeName: '한국어' },
  { code: 'hi', flag: '🇮🇳', name: 'Hindi', nativeName: 'हिन्दी' },
  { code: 'th', flag: '🇹🇭', name: 'Thai', nativeName: 'ไทย' },
  { code: 'vi', flag: '🇻🇳', name: 'Vietnamese', nativeName: 'Tiếng Việt' },
  { code: 'id', flag: '🇮🇩', name: 'Indonesian', nativeName: 'Bahasa Indonesia' },
  { code: 'ms', flag: '🇲🇾', name: 'Malay', nativeName: 'Bahasa Melayu' },
  { code: 'tl', flag: '🇵🇭', name: 'Filipino', nativeName: 'Filipino' },
  { code: 'bn', flag: '🇧🇩', name: 'Bengali', nativeName: 'বাংলা' },
  { code: 'ur', flag: '🇵🇰', name: 'Urdu', nativeName: 'اردو' },
  { code: 'ta', flag: '🇱🇰', name: 'Tamil', nativeName: 'தமிழ்' },
  { code: 'te', flag: '🇮🇳', name: 'Telugu', nativeName: 'తెలుగు' },
  { code: 'ml', flag: '🇮🇳', name: 'Malayalam', nativeName: 'മലയാളം' },
  { code: 'kn', flag: '🇮🇳', name: 'Kannada', nativeName: 'ಕನ್ನಡ' },
  { code: 'gu', flag: '🇮🇳', name: 'Gujarati', nativeName: 'ગુજરાતી' },
  { code: 'pa', flag: '🇮🇳', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ' },
  { code: 'mr', flag: '🇮🇳', name: 'Marathi', nativeName: 'मराठी' },
  { code: 'ne', flag: '🇳🇵', name: 'Nepali', nativeName: 'नेपाली' },
  { code: 'si', flag: '🇱🇰', name: 'Sinhala', nativeName: 'සිංහල' },
  { code: 'my', flag: '🇲🇲', name: 'Myanmar', nativeName: 'မြန်မာ' },
  { code: 'km', flag: '🇰🇭', name: 'Khmer', nativeName: 'ខ្មែរ' },
  { code: 'lo', flag: '🇱🇦', name: 'Lao', nativeName: 'ລາວ' },
  { code: 'ka', flag: '🇬🇪', name: 'Georgian', nativeName: 'ქართული' },
  { code: 'hy', flag: '🇦🇲', name: 'Armenian', nativeName: 'Հայերեն' },
  { code: 'az', flag: '🇦🇿', name: 'Azerbaijani', nativeName: 'Azərbaycan' },
  { code: 'kk', flag: '🇰🇿', name: 'Kazakh', nativeName: 'Қазақша' },
  { code: 'ky', flag: '🇰🇬', name: 'Kyrgyz', nativeName: 'Кыргызча' },
  { code: 'uz', flag: '🇺🇿', name: 'Uzbek', nativeName: 'Oʻzbekcha' },
  { code: 'tk', flag: '🇹🇲', name: 'Turkmen', nativeName: 'Türkmençe' },
  { code: 'tj', flag: '🇹🇯', name: 'Tajik', nativeName: 'Тоҷикӣ' },
  { code: 'mn', flag: '🇲🇳', name: 'Mongolian', nativeName: 'Монгол' },
  
  // Moyen-Orient (ARABE AVEC DRAPEAU MAROCAIN comme spécifié)
  { code: 'ar', flag: '🇲🇦', name: 'Arabic', nativeName: 'العربية' },
  { code: 'fa', flag: '🇮🇷', name: 'Persian', nativeName: 'فارسی' },
  { code: 'tr', flag: '🇹🇷', name: 'Turkish', nativeName: 'Türkçe' },
  { code: 'ku', flag: '🏴', name: 'Kurdish', nativeName: 'کوردی' },
  
  // Afrique
  { code: 'sw', flag: '🇰🇪', name: 'Swahili', nativeName: 'Kiswahili' },
  { code: 'am', flag: '🇪🇹', name: 'Amharic', nativeName: 'አማርኛ' },
  { code: 'zu', flag: '🇿🇦', name: 'Zulu', nativeName: 'isiZulu' },
  { code: 'af', flag: '🇿🇦', name: 'Afrikaans', nativeName: 'Afrikaans' },
  { code: 'xh', flag: '🇿🇦', name: 'Xhosa', nativeName: 'isiXhosa' },
  { code: 'st', flag: '🇱🇸', name: 'Sesotho', nativeName: 'Sesotho' },
  { code: 'tn', flag: '🇧🇼', name: 'Tswana', nativeName: 'Setswana' },
  { code: 'ss', flag: '🇸🇿', name: 'Swati', nativeName: 'SiSwati' },
  { code: 've', flag: '🇿🇦', name: 'Venda', nativeName: 'Tshivenḓa' },
  { code: 'ts', flag: '🇿🇦', name: 'Tsonga', nativeName: 'Xitsonga' },
  { code: 'nr', flag: '🇿🇦', name: 'Ndebele', nativeName: 'isiNdebele' },
  { code: 'ig', flag: '🇳🇬', name: 'Igbo', nativeName: 'Igbo' },
  { code: 'yo', flag: '🇳🇬', name: 'Yoruba', nativeName: 'Yorùbá' },
  { code: 'ha', flag: '🇳🇬', name: 'Hausa', nativeName: 'Hausa' },
  { code: 'ff', flag: '🇸🇳', name: 'Fulah', nativeName: 'Fulfulde' },
  { code: 'wo', flag: '🇸🇳', name: 'Wolof', nativeName: 'Wolof' },
  { code: 'mg', flag: '🇲🇬', name: 'Malagasy', nativeName: 'Malagasy' },
  { code: 'rw', flag: '🇷🇼', name: 'Kinyarwanda', nativeName: 'Ikinyarwanda' },
  { code: 'rn', flag: '🇧🇮', name: 'Kirundi', nativeName: 'Ikirundi' },
  { code: 'ny', flag: '🇲🇼', name: 'Chichewa', nativeName: 'Chichewa' },
  { code: 'sn', flag: '🇿🇼', name: 'Shona', nativeName: 'chiShona' },
  { code: 'nd', flag: '🇿🇼', name: 'Northern Ndebele', nativeName: 'isiNdebele' },
  
  // Amériques
  { code: 'pt-br', flag: '🇧🇷', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)' },
  { code: 'es-mx', flag: '🇲🇽', name: 'Spanish (Mexico)', nativeName: 'Español (México)' },
  { code: 'es-ar', flag: '🇦🇷', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)' },
  { code: 'es-co', flag: '🇨🇴', name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)' },
  { code: 'es-cl', flag: '🇨🇱', name: 'Spanish (Chile)', nativeName: 'Español (Chile)' },
  { code: 'es-pe', flag: '🇵🇪', name: 'Spanish (Peru)', nativeName: 'Español (Perú)' },
  { code: 'es-ve', flag: '🇻🇪', name: 'Spanish (Venezuela)', nativeName: 'Español (Venezuela)' },
  { code: 'fr-ca', flag: '🇨🇦', name: 'French (Canada)', nativeName: 'Français (Canada)' },
  { code: 'en-ca', flag: '🇨🇦', name: 'English (Canada)', nativeName: 'English (Canada)' },
  { code: 'qu', flag: '🇵🇪', name: 'Quechua', nativeName: 'Runa Simi' },
  { code: 'ay', flag: '🇧🇴', name: 'Aymara', nativeName: 'Aymar Aru' },
  { code: 'gn', flag: '🇵🇾', name: 'Guarani', nativeName: 'Avañe\'ẽ' },
  
  // Océanie
  { code: 'en-au', flag: '🇦🇺', name: 'English (Australia)', nativeName: 'English (Australia)' },
  { code: 'en-nz', flag: '🇳🇿', name: 'English (New Zealand)', nativeName: 'English (New Zealand)' },
  { code: 'mi', flag: '🇳🇿', name: 'Māori', nativeName: 'Te Reo Māori' },
  { code: 'to', flag: '🇹🇴', name: 'Tongan', nativeName: 'Lea Fakatonga' },
  { code: 'fj', flag: '🇫🇯', name: 'Fijian', nativeName: 'Na Vosa Vakaviti' },
  { code: 'sm', flag: '🇼🇸', name: 'Samoan', nativeName: 'Gagana Samoa' },
  
  // Langues régionales et minoritaires
  { code: 'is', flag: '🇮🇸', name: 'Icelandic', nativeName: 'Íslenska' },
  { code: 'fo', flag: '🇫🇴', name: 'Faroese', nativeName: 'Føroyskt' },
  { code: 'kl', flag: '🇬🇱', name: 'Greenlandic', nativeName: 'Kalaallisut' },
  { code: 'mt', flag: '🇲🇹', name: 'Maltese', nativeName: 'Malti' },
  { code: 'eu', flag: '🏴', name: 'Basque', nativeName: 'Euskera' },
  { code: 'ca', flag: '🏴', name: 'Catalan', nativeName: 'Català' },
  { code: 'gl', flag: '🏴', name: 'Galician', nativeName: 'Galego' },
  { code: 'cy', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', name: 'Welsh', nativeName: 'Cymraeg' },
  { code: 'ga', flag: '🇮🇪', name: 'Irish', nativeName: 'Gaeilge' },
  { code: 'gd', flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿', name: 'Scottish Gaelic', nativeName: 'Gàidhlig' },
  { code: 'br', flag: '🏴', name: 'Breton', nativeName: 'Brezhoneg' },
  { code: 'oc', flag: '🏴', name: 'Occitan', nativeName: 'Occitan' },
  { code: 'co', flag: '🏴', name: 'Corsican', nativeName: 'Corsu' },
  { code: 'sc', flag: '🏴', name: 'Sardinian', nativeName: 'Sardu' },
  { code: 'rm', flag: '🇨🇭', name: 'Romansh', nativeName: 'Rumantsch' },
  { code: 'lb', flag: '🇱🇺', name: 'Luxembourgish', nativeName: 'Lëtzebuergesch' },
  
  // Langues Sami (corrigé - une seule entrée)
  { code: 'se', flag: '🏴', name: 'Northern Sami', nativeName: 'Davvisámegiella' },
  
  // Langues construites
  { code: 'eo', flag: '🏴', name: 'Esperanto', nativeName: 'Esperanto' },
  { code: 'ia', flag: '🏴', name: 'Interlingua', nativeName: 'Interlingua' },
  { code: 'la', flag: '🏴', name: 'Latin', nativeName: 'Latina' },
  { code: 'sa', flag: '🏴', name: 'Sanskrit', nativeName: 'संस्कृतम्' },
  
  // Langues asiatiques additionnelles
  { code: 'bo', flag: '🇹🇧', name: 'Tibetan', nativeName: 'བོད་ཡིག' },
  { code: 'dz', flag: '🇧🇹', name: 'Dzongkha', nativeName: 'རྫོང་ཁ' }
]

interface LanguageSelectorProps {
  onLanguageChange?: (languageCode: string) => void
}

export default function LanguageSelector({ onLanguageChange }: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedLanguage, setSelectedLanguage] = useState("fr")
  const dropdownRef = useRef<HTMLDivElement>(null)

  // Fermer le dropdown quand on clique à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm("") // Reset search when closing
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Fonction de recherche améliorée et corrigée
  const filteredLanguages = WORLD_LANGUAGES.filter(lang => {
    if (!searchTerm.trim()) return true
    
    const search = searchTerm.toLowerCase().trim()
    
    // Recherche dans le nom natif, nom anglais, et code
    return (
      lang.nativeName.toLowerCase().includes(search) ||
      lang.name.toLowerCase().includes(search) ||
      lang.code.toLowerCase().includes(search) ||
      // Recherche spéciale pour "arabe" qui doit trouver العربية
      (search === 'arabe' && lang.code === 'ar') ||
      (search === 'arabic' && lang.code === 'ar') ||
      // Recherche pour les autres langues courantes
      (search === 'francais' && lang.code === 'fr') ||
      (search === 'english' && lang.code === 'en') ||
      (search === 'espagnol' && lang.code === 'es') ||
      (search === 'allemand' && lang.code === 'de') ||
      (search === 'italien' && lang.code === 'it') ||
      (search === 'chinois' && lang.code === 'zh') ||
      (search === 'japonais' && lang.code === 'ja')
    )
  })

  const currentLanguage = WORLD_LANGUAGES.find(lang => lang.code === selectedLanguage) || WORLD_LANGUAGES[0]

  const handleLanguageSelect = (languageCode: string) => {
    setSelectedLanguage(languageCode)
    setIsOpen(false)
    setSearchTerm("")
    onLanguageChange?.(languageCode)
  }

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bouton principal */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg px-3 py-2 font-medium transition-all duration-200 shadow-sm hover:shadow-md"
      >
        <Globe className="w-4 h-4 text-blue-600" />
        <span className="text-lg">{currentLanguage.flag}</span>
        <span className="text-sm font-medium">{currentLanguage.nativeName}</span>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute top-full right-0 mt-2 w-80 bg-white border border-gray-200 rounded-xl shadow-2xl z-50">
          
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-sm font-semibold text-gray-900 flex items-center">
                <Globe className="w-4 h-4 mr-2 text-blue-500" />
                Choisir une langue
              </h3>
              <span className="text-xs bg-gradient-to-r from-blue-500 to-purple-500 text-white px-2 py-1 rounded-full font-medium">
                {WORLD_LANGUAGES.length} langues
              </span>
            </div>
            
            <div className="relative">
              <input
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-9 pr-4 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white"
              />
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
            </div>
          </div>
          
          {/* Liste des langues avec scroll visible */}
          <div 
            className="max-h-80 overflow-y-auto language-dropdown-scroll"
            style={{
              scrollbarWidth: 'thin',
              scrollbarColor: '#cbd5e1 #f1f5f9'
            }}
          >
            <style jsx>{`
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
              }
              .language-dropdown-scroll::-webkit-scrollbar-thumb:hover {
                background: #94a3b8;
              }
            `}</style>
            
            {/* Message si aucun résultat */}
            {filteredLanguages.length === 0 && (
              <div className="p-6 text-center text-gray-500">
                <Search className="w-8 h-8 mx-auto mb-2 text-gray-400" />
                <p>Aucune langue trouvée pour "{searchTerm}"</p>
                <p className="text-xs mt-1">Essayez "arabe", "français", "english"...</p>
              </div>
            )}
            
            {filteredLanguages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageSelect(language.code)}
                className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left ${
                  selectedLanguage === language.code ? 'bg-blue-50 border-r-2 border-blue-500' : ''
                }`}
              >
                <span className="text-lg flex-shrink-0">{language.flag}</span>
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-gray-900 truncate">
                    {language.nativeName}
                  </div>
                  <div className="text-xs text-gray-500 truncate">
                    {language.name}
                  </div>
                </div>
                {selectedLanguage === language.code && (
                  <div className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0"></div>
                )}
              </button>
            ))}
          </div>
          
          {/* Footer */}
          <div className="p-3 border-t border-gray-100 bg-gray-50">
            <div className="text-xs text-gray-600 text-center">
              🌍 {filteredLanguages.length} langue{filteredLanguages.length > 1 ? 's' : ''} {searchTerm ? `trouvée${filteredLanguages.length > 1 ? 's' : ''}` : 'disponible'}
              {searchTerm && filteredLanguages.length > 0 ? ` pour "${searchTerm}"` : ''}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
