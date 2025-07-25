'use client'

import { useState, useEffect, useRef } from 'react'

interface Language {
  code: string
  name: string
  flag: string
  description: string
}

interface Feature {
  title: string
  description: string
  icon: string
  details: string
}

interface Platform {
  name: string
  description: string
  icon: string
  downloadUrl: string
}

const languages: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', description: 'Math pour enfants' },
  { code: 'en', name: 'English', flag: '🇺🇸', description: 'Math for Kids' },
  { code: 'es', name: 'Español', flag: '🇪🇸', description: 'Matemáticas para Niños' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', description: 'Mathe für Kinder' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', description: 'Matematica per Bambini' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', description: 'Matemática para Crianças' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', description: 'الرياضيات للأطفال' },
  { code: 'zh', name: '中文', flag: '🇨🇳', description: '儿童数学' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', description: '子供の数学' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', description: '어린이 수학' }
  // ... plus de langues disponibles
]

const features: Feature[] = [
  {
    title: 'Débloquez toutes les fonctionnalités premium',
    description: 'Accès complet à tous les exercices',
    icon: '👑',
    details: 'Plus de 10 000 exercices interactifs, suivi détaillé des progrès, rapports parents et bien plus encore !'
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
    icon: '📊',
    details: 'Du niveau débutant au niveau expert, chaque enfant progresse à son rythme.'
  },
  {
    title: 'Suivi détaillé des progrès',
    description: 'Tableaux de bord complets',
    icon: '📈',
    details: 'Statistiques détaillées, badges de réussite et rapports de progression pour les parents.'
  }
]

const platforms: Platform[] = [
  {
    name: 'Web',
    description: 'Version web complète accessible depuis votre navigateur',
    icon: '🌐',
    downloadUrl: 'https://app.math4child.com'
  },
  {
    name: 'iOS',
    description: 'Application native iOS optimisée pour iPhone et iPad',
    icon: '📱',
    downloadUrl: 'https://apps.apple.com/app/math4child'
  },
  {
    name: 'Android',
    description: 'Application Android optimisée pour tous les appareils',
    icon: '🤖',
    downloadUrl: 'https://play.google.com/store/apps/details?id=com.math4child'
  }
]

export default function Home() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(languages[0])
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [languageSearch, setLanguageSearch] = useState('')
  const [isPricingModalOpen, setIsPricingModalOpen] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly')
  const [notification, setNotification] = useState<string>('')
  const [activeFeature, setActiveFeature] = useState<number | null>(null)
  const [activeStat, setActiveStat] = useState<string>('')
  const [activePlatform, setActivePlatform] = useState<Platform | null>(null)

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
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [])

  // Fonction pour changer de langue
  const changeLanguage = (language: Language) => {
    setSelectedLanguage(language)
    setIsLanguageDropdownOpen(false)
    setNotification(`Langue changée vers ${language.name}`)
    setTimeout(() => setNotification(''), 3000)
  }

  // Filtrer les langues pour la recherche
  const filteredLanguages = languages.filter(lang =>
    lang.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    lang.description.toLowerCase().includes(languageSearch.toLowerCase())
  )

  // Fonction pour afficher les alertes de fonctionnalités
  const showFeatureAlert = (feature: Feature, index: number) => {
    setActiveFeature(index)
    alert(`${feature.title}\n\n${feature.details}`)
    setTimeout(() => setActiveFeature(null), 500)
  }

  // Fonction pour afficher les statistiques
  const showStatDetail = (stat: string, detail: string) => {
    setActiveStat(stat)
    alert(`${stat}\n\n${detail}`)
    setTimeout(() => setActiveStat(''), 500)
  }

  // Fonction pour afficher les informations de plateforme
  const showPlatformInfo = (platform: Platform) => {
    setActivePlatform(platform)
    alert(`${platform.name}\n\n${platform.description}\n\nTéléchargement: ${platform.downloadUrl}`)
    setTimeout(() => setActivePlatform(null), 500)
  }

  // Calcul des prix selon la période
  const getPricing = () => {
    const basePrices = { premium: 4.99, famille: 6.99, ecole: 24.99 }
    const discounts = { monthly: 0, quarterly: 0.1, annual: 0.3 }
    const discount = discounts[selectedPeriod]

    return {
      premium: (basePrices.premium * (1 - discount)).toFixed(2),
      famille: (basePrices.famille * (1 - discount)).toFixed(2),
      ecole: (basePrices.ecole * (1 - discount)).toFixed(2),
      discount: Math.round(discount * 100)
    }
  }

  const pricing = getPricing()

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      {/* Notification */}
      {notification && (
        <div className="fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-pulse">
          {notification}
        </div>
      )}

      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
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

            {/* Sélecteur de langue */}
            <div className="relative" ref={languageDropdownRef}>
              <button
                onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                className="flex items-center space-x-2 bg-white border border-gray-300 rounded-lg px-3 py-2 hover:bg-gray-50 transition-colors"
                data-testid="language-selector"
              >
                <span className="text-xl">{selectedLanguage.flag}</span>
                <span className="text-sm font-medium text-gray-700">{selectedLanguage.name}</span>
                <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {isLanguageDropdownOpen && (
                <div 
                  className="absolute top-full right-0 mt-2 w-80 bg-white border border-gray-200 rounded-lg shadow-lg z-50 language-dropdown"
                  data-testid="language-dropdown"
                >
                  <div className="p-3 border-b border-gray-100">
                    <h3 className="text-sm font-semibold text-gray-900 mb-2">Sélectionner une langue</h3>
                    <p className="text-xs text-gray-600 mb-3">47+ langues</p>
                    <input
                      type="text"
                      placeholder="Rechercher une langue..."
                      value={languageSearch}
                      onChange={(e) => setLanguageSearch(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div className="max-h-64 overflow-y-auto">
                    <div className="p-2">
                      {filteredLanguages.map((language) => (
                        <button
                          key={language.code}
                          onClick={() => changeLanguage(language)}
                          className="w-full flex items-center space-x-3 px-3 py-2 text-left hover:bg-gray-50 rounded-md transition-colors"
                        >
                          <span className="text-lg">{language.flag}</span>
                          <div>
                            <div className="text-sm font-medium text-gray-900">{language.name}</div>
                            <div className="text-xs text-gray-500">{language.description}</div>
                          </div>
                          {language.code === selectedLanguage.code && (
                            <div className="ml-auto w-4 h-4 text-blue-500">✓</div>
                          )}
                        </button>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Section principale */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Titre principal */}
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">
            <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Apprends les maths en
            </span>
            <br />
            <span className="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
              t'amusant !
            </span>
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Bienvenue dans l'aventure mathématique !
          </p>
        </div>

        {/* Cartes de fonctionnalités */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-16">
          {features.map((feature, index) => (
            <div
              key={index}
              onClick={() => showFeatureAlert(feature, index)}
              className={`feature-card bg-white p-6 rounded-xl shadow-sm border-2 cursor-pointer transition-all duration-300 hover:shadow-lg hover:scale-105 ${
                activeFeature === index ? 'border-blue-500 shadow-lg scale-105' : 'border-gray-100'
              }`}
            >
              <div className="text-2xl mb-3">{feature.icon}</div>
              <h3 className="font-semibold text-gray-900 text-sm mb-2">{feature.title}</h3>
              <p className="text-xs text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>

        {/* Statistiques cliquables */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          <div
            onClick={() => showStatDetail('100k+ familles', 'Plus de 100 000 familles à travers le monde nous font confiance pour l\'éducation mathématique de leurs enfants.')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '100k+ familles' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-green-600 mb-2">100k+</div>
            <div className="text-gray-600">familles satisfaites</div>
          </div>
          <div
            onClick={() => showStatDetail('98% satisfaction', 'Taux de satisfaction exceptionnel de 98% basé sur plus de 50 000 avis clients vérifiés.')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '98% satisfaction' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-blue-600 mb-2">98%</div>
            <div className="text-gray-600">de satisfaction</div>
          </div>
          <div
            onClick={() => showStatDetail('47 pays', 'Notre application est disponible dans 47 pays et traduite en plus de 47 langues.')}
            className={`stat-card text-center cursor-pointer transition-all duration-300 hover:scale-105 ${
              activeStat === '47 pays' ? 'scale-105' : ''
            }`}
          >
            <div className="text-4xl font-bold text-purple-600 mb-2">47</div>
            <div className="text-gray-600">pays</div>
          </div>
        </div>

        {/* Cartes de plateformes */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {platforms.map((platform, index) => (
            <div
              key={index}
              onClick={() => showPlatformInfo(platform)}
              className={`platform-card bg-white p-6 rounded-xl shadow-sm border cursor-pointer transition-all duration-300 hover:shadow-lg hover:scale-105 ${
                activePlatform?.name === platform.name ? 'border-blue-500 shadow-lg scale-105' : 'border-gray-200'
              }`}
            >
              <div className="text-3xl mb-4">{platform.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">{platform.name}</h3>
              <p className="text-sm text-gray-600">{platform.description}</p>
            </div>
          ))}
        </div>

        {/* Boutons d'action */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
          <button className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg">
            <span className="mr-2">🎁</span>
            Commencer gratuitement
            <div className="text-sm opacity-90">14j gratuit</div>
          </button>
          <button
            onClick={() => setIsPricingModalOpen(true)}
            className="bg-blue-500 hover:bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg"
          >
            <span className="mr-2">📊</span>
            Comparer les prix
          </button>
        </div>
      </main>

      {/* Modal de pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div 
            ref={pricingModalRef}
            className="pricing-modal bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto"
          >
            <div className="p-6 border-b border-gray-200 flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold text-gray-900">Choisissez votre plan</h2>
                <p className="text-gray-600">Commencez votre essai gratuit de 14 jours</p>
              </div>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="text-gray-400 hover:text-gray-600 text-2xl"
              >
                ×
              </button>
            </div>

            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 rounded-lg p-1 flex">
                  {[
                    { key: 'monthly', label: 'Mensuel' },
                    { key: 'quarterly', label: 'Trimestriel', badge: '-10%' },
                    { key: 'annual', label: 'Annuel', badge: '-30%' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key as any)}
                      className={`px-6 py-2 rounded-md font-medium transition-all relative ${
                        selectedPeriod === period.key
                          ? 'bg-white text-blue-600 shadow-sm'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.badge && (
                        <span className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                          {period.badge}
                        </span>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Plans */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="plan-premium border border-blue-200 rounded-xl p-6 bg-blue-50">
                  <h3 className="text-lg font-semibold mb-2">Premium</h3>
                  <div className="text-3xl font-bold mb-4">
                    {pricing.premium}€
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

                <div className="plan-famille border-2 border-purple-300 rounded-xl p-6 bg-purple-50 relative">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-purple-500 text-white px-4 py-1 rounded-full text-sm">
                    Le plus populaire
                  </div>
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
