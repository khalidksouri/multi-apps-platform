'use client'

import { useState, useRef, useEffect } from 'react'

// Configuration des langues avec leurs codes
const languages = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇬🇧' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'hi', name: 'हिंदी', flag: '🇮🇳' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷' },
  { code: 'he', name: 'עברית', flag: '🇮🇱' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾' },
  { code: 'tl', name: 'Filipino', flag: '🇵🇭' },
  { code: 'uk', name: 'Українська', flag: '🇺🇦' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺' },
  { code: 'ro', name: 'Română', flag: '🇷🇴' },
  { code: 'bg', name: 'Български', flag: '🇧🇬' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷' },
  { code: 'sr', name: 'Српски', flag: '🇷🇸' },
  { code: 'sl', name: 'Slovenščina', flag: '🇸🇮' },
  { code: 'et', name: 'Eesti', flag: '🇪🇪' },
  { code: 'lv', name: 'Latviešu', flag: '🇱🇻' },
  { code: 'lt', name: 'Lietuvių', flag: '🇱🇹' },
  { code: 'mt', name: 'Malti', flag: '🇲🇹' },
  { code: 'is', name: 'Íslenska', flag: '🇮🇸' },
  { code: 'ga', name: 'Gaeilge', flag: '🇮🇪' },
  { code: 'cy', name: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿' },
  { code: 'eu', name: 'Euskera', flag: '🏴' },
  { code: 'ca', name: 'Català', flag: '🏴' },
  { code: 'gl', name: 'Galego', flag: '🏴' },
  { code: 'af', name: 'Afrikaans', flag: '🇿🇦' },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹' },
  { code: 'ka', name: 'ქართული', flag: '🇬🇪' },
  { code: 'hy', name: 'Հայերեն', flag: '🇦🇲' }
]

export default function Math4ChildPage() {
  const [selectedLanguage, setSelectedLanguage] = useState(languages[0])
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [languageSearch, setLanguageSearch] = useState('')
  const [isPricingModalOpen, setIsPricingModalOpen] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState('mensuel')
  
  const languageDropdownRef = useRef<HTMLDivElement>(null)
  const pricingModalRef = useRef<HTMLDivElement>(null)

  // Fermer les dropdowns en cliquant à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target as Node)) {
        setIsLanguageDropdownOpen(false)
      }
      if (pricingModalRef.current && !pricingModalRef.current.contains(event.target as Node)) {
        setIsPricingModalOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filtrer les langues selon la recherche
  const filteredLanguages = languages.filter(lang =>
    lang.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    lang.code.toLowerCase().includes(languageSearch.toLowerCase())
  )

  // Configuration du pricing
  const pricingConfig = {
    mensuel: { famille: 9.99, pro: 19.99, ecole: 29.99, discount: 0 },
    trimestriel: { famille: 8.99, pro: 17.99, ecole: 26.99, discount: 10 },
    annuel: { famille: 6.99, pro: 13.99, ecole: 20.99, discount: 30 }
  }

  const pricing = pricingConfig[selectedPeriod as keyof typeof pricingConfig]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-orange-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">M</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math pour enfants</h1>
                <p className="text-sm text-gray-600">App éducative n°1 en France</p>
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm flex items-center">
                <span className="w-2 h-2 bg-green-500 rounded-full mr-2"></span>
                100k+ familles
              </div>

              {/* Sélecteur de langue avec le design des screenshots */}
              <div className="relative" ref={languageDropdownRef}>
                <button
                  onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                  className="flex items-center space-x-2 px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors"
                  data-testid="language-selector"
                >
                  <span className="text-lg">{selectedLanguage.flag}</span>
                  <span className="font-medium text-gray-700">{selectedLanguage.name}</span>
                  <svg className="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {isLanguageDropdownOpen && (
                  <div 
                    className="language-dropdown absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border z-50 max-h-96 overflow-hidden"
                    data-testid="language-dropdown"
                  >
                    <div className="p-3 border-b border-gray-100">
                      <input
                        type="text"
                        placeholder="Rechercher une langue..."
                        value={languageSearch}
                        onChange={(e) => setLanguageSearch(e.target.value)}
                        className="w-full px-3 py-2 border border-gray-200 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                      />
                    </div>
                    <div className="max-h-64 overflow-y-auto">
                      {filteredLanguages.map((lang) => (
                        <button
                          key={lang.code}
                          onClick={() => {
                            setSelectedLanguage(lang)
                            setIsLanguageDropdownOpen(false)
                            setLanguageSearch('')
                          }}
                          className="w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left"
                          data-testid={`language-option-${lang.code}`}
                        >
                          <span className="text-lg">{lang.flag}</span>
                          <div className="flex-1">
                            <div className="font-medium text-gray-900">{lang.name}</div>
                            <div className="text-xs text-gray-500">({lang.code})</div>
                          </div>
                        </button>
                      ))}
                    </div>
                    {filteredLanguages.length === 0 && (
                      <div className="p-4 text-center text-gray-500">
                        Aucune langue trouvée
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Section Hero */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
            Math pour enfants
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Application éducative interactive pour apprendre les mathématiques de manière ludique et efficace
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="bg-blue-600 text-white px-8 py-4 rounded-lg text-lg font-medium hover:bg-blue-700 transition-colors">
              Commencer gratuitement
            </button>
            <button 
              onClick={() => setIsPricingModalOpen(true)}
              className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-medium border-2 border-blue-600 hover:bg-blue-50 transition-colors"
            >
              Comparer les prix
            </button>
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Fonctionnalités principales
          </h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                title: 'Jeux interactifs',
                description: 'Plus de 100 jeux éducatifs',
                icon: '🎮',
                details: 'Jeux adaptés à chaque niveau pour maintenir l\'engagement et la motivation des enfants.'
              },
              {
                title: 'Suivi des progrès',
                description: 'Tableaux de bord détaillés',
                icon: '📊',
                details: 'Visualisez les progrès de votre enfant avec des graphiques détaillés et des rapports personnalisés.'
              },
              {
                title: '47+ langues disponibles',
                description: 'Interface multilingue complète',
                icon: '🌍',
                details: 'Application traduite dans plus de 47 langues pour une accessibilité mondiale maximale.'
              },
              {
                title: 'Web, iOS et Android',
                description: 'Disponible sur toutes les plateformes',
                icon: '📱',
                details: 'Synchronisation entre tous vos appareils pour apprendre partout, tout le temps.'
              },
              {
                title: '5 niveaux de difficulté',
                description: 'Progression adaptée à chaque enfant',
                icon: '📈',
                details: 'Du niveau débutant au niveau expert, chaque enfant progresse à son rythme.'
              }
            ].map((feature, index) => (
              <div
                key={index}
                className="feature-card bg-gray-50 p-6 rounded-xl hover:shadow-lg transition-all duration-300 cursor-pointer transform hover:scale-105"
                onClick={() => alert(`Fonctionnalité: ${feature.title}\n\n${feature.details}`)}
              >
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Statistiques */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            {[
              { value: '50,000+', label: 'Enfants actifs', description: 'utilisent Math4Child quotidiennement' },
              { value: '98%', label: 'Satisfaction parents', description: 'recommandent notre application' },
              { value: '2M+', label: 'Exercices résolus', description: 'par nos petits mathématiciens' }
            ].map((stat, index) => (
              <div
                key={index}
                className="stat-card cursor-pointer transform hover:scale-105 transition-transform duration-300"
                onClick={() => alert(`Statistique: ${stat.label}\n\n${stat.value} ${stat.description}`)}
              >
                <div className="text-4xl font-bold mb-2">{stat.value}</div>
                <div className="text-xl font-medium mb-1">{stat.label}</div>
                <div className="text-blue-100">{stat.description}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Plateformes avec le design des screenshots */}
      <section className="py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Disponible sur toutes les plateformes
          </h2>
          <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {[
              { 
                platform: 'Web', 
                icon: '🌐', 
                description: 'Accès direct depuis votre navigateur',
                link: 'https://math4child.com',
                color: 'bg-green-50 border-green-200 hover:bg-green-100'
              },
              { 
                platform: 'iOS', 
                icon: '📱', 
                description: 'Téléchargez sur l\'App Store',
                link: 'https://apps.apple.com/app/math4child',
                color: 'bg-blue-50 border-blue-200 hover:bg-blue-100'
              },
              { 
                platform: 'Android', 
                icon: '📲', 
                description: 'Disponible sur Google Play',
                link: 'https://play.google.com/store/apps/math4child',
                color: 'bg-orange-50 border-orange-200 hover:bg-orange-100'
              }
            ].map((item, index) => (
              <div
                key={index}
                className={`platform-card p-8 rounded-xl border-2 text-center cursor-pointer transition-all duration-300 transform hover:scale-105 ${item.color}`}
                onClick={() => {
                  alert(`Téléchargement: ${item.platform}\n\n${item.description}\n\nRedirection vers: ${item.link}`)
                }}
              >
                <div className="text-6xl mb-4">{item.icon}</div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">{item.platform}</h3>
                <p className="text-gray-600 mb-6">{item.description}</p>
                <button className="w-full bg-gray-900 text-white px-6 py-3 rounded-lg font-medium hover:bg-gray-800 transition-colors">
                  Télécharger
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-2 mb-4">
                <span className="text-2xl">🧮</span>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400">
                L'application éducative qui rend les mathématiques amusantes et accessibles à tous les enfants.
              </p>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Produit</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Fonctionnalités</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Tarifs</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Téléchargements</a></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Support</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Documentation</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Contact</a></li>
                <li><a href="#" className="hover:text-white transition-colors">FAQ</a></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Entreprise</h3>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">À propos</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Blog</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Carrières</a></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2024 Math4Child. Tous droits réservés.</p>
          </div>
        </div>
      </footer>

      {/* Modal Pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="pricing-modal bg-white rounded-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto" ref={pricingModalRef}>
            <div className="p-6 border-b flex justify-between items-center">
              <h2 className="text-2xl font-bold">Choisissez votre plan</h2>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                ×
              </button>
            </div>
            
            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 p-1 rounded-lg flex">
                  {[
                    { key: 'mensuel', label: 'Mensuel' },
                    { key: 'trimestriel', label: 'Trimestriel' },
                    { key: 'annuel', label: 'Annuel' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key)}
                      className={`px-6 py-2 rounded-md font-medium transition-colors ${
                        selectedPeriod === period.key
                          ? 'bg-white shadow-sm text-blue-600'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.key === 'trimestriel' && <span className="ml-2 text-green-600 text-sm">-10%</span>}
                      {period.key === 'annuel' && <span className="ml-2 text-green-600 text-sm">-30%</span>}
                    </button>
                  ))}
                </div>
              </div>

              {/* Plans tarifaires */}
              <div className="grid md:grid-cols-3 gap-6">
                <div className="plan-famille border border-blue-200 rounded-xl p-6 bg-blue-50">
                  <h3 className="text-lg font-semibold mb-2">Famille</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.famille}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-blue-500 text-white py-3 rounded-lg font-medium hover:bg-blue-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                <div className="plan-pro border border-purple-200 rounded-xl p-6 bg-purple-50">
                  <h3 className="text-lg font-semibold mb-2">Pro</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.pro}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-purple-500 text-white py-3 rounded-lg font-medium hover:bg-purple-600 transition-colors">
                    Essai 14j gratuit
                  </button>
                </div>

                <div className="plan-ecole border border-orange-200 rounded-xl p-6 bg-orange-50">
                  <h3 className="text-lg font-semibold mb-2">École</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.ecole}€
                    <span className="text-sm text-gray-500">/mois</span>
                    {pricing.discount > 0 && (
                      <span className="ml-2 text-sm bg-green-500 text-white px-2 py-1 rounded">
                        -{pricing.discount}%
                      </span>
                    )}
                  </div>
                  <button className="w-full bg-orange-500 text-white py-3 rounded-lg font-medium hover:bg-orange-600 transition-colors">
                    Demander un devis
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
