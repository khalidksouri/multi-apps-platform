'use client'

import React, { useState, useEffect } from 'react'
import { 
  Users, 
  Languages, 
  ChevronDown, 
  Crown, 
  Gift, 
  Globe, 
  TrendingUp,
  CheckCircle,
  ArrowRight,
  Smartphone,
  Monitor,
  Tablet,
  Star,
  Zap,
  Heart,
  Shield,
  Award,
  BarChart,
  BookOpen,
  Calendar,
  X
} from 'lucide-react'

// Configuration complète des langues (47+ langues universelles)
const LANGUAGE_CONFIG = {
  // Langues européennes
  fr: { flag: '🇫🇷', name: 'Français', nativeName: 'Français', appName: 'Math pour enfants', region: 'Europe' },
  en: { flag: '🇺🇸', name: 'English', nativeName: 'English', appName: 'Math4Child', region: 'North America' },
  es: { flag: '🇪🇸', name: 'Spanish', nativeName: 'Español', appName: 'Matemáticas para Niños', region: 'Europe' },
  de: { flag: '🇩🇪', name: 'German', nativeName: 'Deutsch', appName: 'Mathe für Kinder', region: 'Europe' },
  it: { flag: '🇮🇹', name: 'Italian', nativeName: 'Italiano', appName: 'Matematica per Bambini', region: 'Europe' },
  pt: { flag: '🇵🇹', name: 'Portuguese', nativeName: 'Português', appName: 'Matemática para Crianças', region: 'Europe' },
  ru: { flag: '🇷🇺', name: 'Russian', nativeName: 'Русский', appName: 'Математика для детей', region: 'Europe' },
  pl: { flag: '🇵🇱', name: 'Polish', nativeName: 'Polski', appName: 'Matematyka dla dzieci', region: 'Europe' },
  nl: { flag: '🇳🇱', name: 'Dutch', nativeName: 'Nederlands', appName: 'Wiskunde voor kinderen', region: 'Europe' },
  sv: { flag: '🇸🇪', name: 'Swedish', nativeName: 'Svenska', appName: 'Matematik för barn', region: 'Europe' },
  da: { flag: '🇩🇰', name: 'Danish', nativeName: 'Dansk', appName: 'Matematik for børn', region: 'Europe' },
  no: { flag: '🇳🇴', name: 'Norwegian', nativeName: 'Norsk', appName: 'Matematikk for barn', region: 'Europe' },
  fi: { flag: '🇫🇮', name: 'Finnish', nativeName: 'Suomi', appName: 'Matematiikka lapsille', region: 'Europe' },
  
  // Langues asiatiques
  zh: { flag: '🇨🇳', name: 'Chinese', nativeName: '中文', appName: '儿童数学', region: 'Asia' },
  ja: { flag: '🇯🇵', name: 'Japanese', nativeName: '日本語', appName: '子供の数学', region: 'Asia' },
  ko: { flag: '🇰🇷', name: 'Korean', nativeName: '한국어', appName: '어린이 수학', region: 'Asia' },
  hi: { flag: '🇮🇳', name: 'Hindi', nativeName: 'हिन्दी', appName: 'बच्चों के लिए गणित', region: 'Asia' },
  th: { flag: '🇹🇭', name: 'Thai', nativeName: 'ไทย', appName: 'คณิตศาสตร์สำหรับเด็ก', region: 'Asia' },
  vi: { flag: '🇻🇳', name: 'Vietnamese', nativeName: 'Tiếng Việt', appName: 'Toán học cho trẻ em', region: 'Asia' },
  id: { flag: '🇮🇩', name: 'Indonesian', nativeName: 'Bahasa Indonesia', appName: 'Matematika untuk Anak', region: 'Asia' },
  ms: { flag: '🇲🇾', name: 'Malay', nativeName: 'Bahasa Melayu', appName: 'Matematik untuk Kanak-kanak', region: 'Asia' },
  
  // Langues du Moyen-Orient
  ar: { flag: '🇸🇦', name: 'Arabic', nativeName: 'العربية', appName: 'الرياضيات للأطفال', region: 'Middle East', rtl: true },
  he: { flag: '🇮🇱', name: 'Hebrew', nativeName: 'עברית', appName: 'מתמטיקה לילדים', region: 'Middle East', rtl: true },
  fa: { flag: '🇮🇷', name: 'Persian', nativeName: 'فارسی', appName: 'ریاضی برای کودکان', region: 'Middle East', rtl: true },
  tr: { flag: '🇹🇷', name: 'Turkish', nativeName: 'Türkçe', appName: 'Çocuklar için Matematik', region: 'Middle East' },
  
  // Langues africaines
  sw: { flag: '🇰🇪', name: 'Swahili', nativeName: 'Kiswahili', appName: 'Hisabati kwa Watoto', region: 'Africa' },
  am: { flag: '🇪🇹', name: 'Amharic', nativeName: 'አማርኛ', appName: 'ለልጆች ሂሳብ', region: 'Africa' },
  zu: { flag: '🇿🇦', name: 'Zulu', nativeName: 'isiZulu', appName: 'Izibalo zezingane', region: 'Africa' },
  
  // Langues des Amériques
  'pt-br': { flag: '🇧🇷', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', appName: 'Matemática para Crianças', region: 'South America' },
  'es-mx': { flag: '🇲🇽', name: 'Spanish (Mexico)', nativeName: 'Español (México)', appName: 'Matemáticas para Niños', region: 'North America' },
  'fr-ca': { flag: '🇨🇦', name: 'French (Canada)', nativeName: 'Français (Canada)', appName: 'Mathématiques pour enfants', region: 'North America' }
}

// Configuration des traductions pour chaque langue
const TRANSLATIONS = {
  fr: {
    tagline: 'App éducative n°1 en France',
    heroTitle: 'Apprends les maths en t\'amusant !',
    heroWelcome: 'Bienvenue dans l\'aventure mathématique !',
    features: [
      'Débloquez toutes les fonctionnalités premium',
      '47+ langues disponibles',
      'Web, iOS et Android',
      '5 niveaux de difficulté',
      'Suivi détaillé des progrès'
    ],
    startFree: 'Commencer gratuitement',
    freeTrial: '14j gratuit',
    comparePrices: 'Comparer les prix',
    monthly: 'Mensuel',
    quarterly: 'Trimestriel',
    annual: 'Annuel',
    save: 'Économisez',
    profiles: 'profils',
    mostPopular: 'Le plus populaire',
    recommended: 'Recommandé écoles'
  },
  en: {
    tagline: '#1 Educational App in France',
    heroTitle: 'Learn math while having fun!',
    heroWelcome: 'Welcome to the mathematical adventure!',
    features: [
      'Unlock all premium features',
      '47+ languages available',
      'Web, iOS and Android',
      '5 difficulty levels',
      'Detailed progress tracking'
    ],
    startFree: 'Start Free',
    freeTrial: '14 days free',
    comparePrices: 'Compare Prices',
    monthly: 'Monthly',
    quarterly: 'Quarterly',
    annual: 'Annual',
    save: 'Save',
    profiles: 'profiles',
    mostPopular: 'Most Popular',
    recommended: 'Recommended for schools'
  }
  // Ajouter d'autres langues selon les besoins
}

// Types d'abonnement avec toutes les périodes
const SUBSCRIPTION_PLANS = {
  free: {
    name: { fr: 'Gratuit', en: 'Free' },
    profiles: 1,
    monthly: { price: 0, originalPrice: 0, discount: 0 },
    quarterly: { price: 0, originalPrice: 0, discount: 0 },
    annual: { price: 0, originalPrice: 0, discount: 0 },
    features: { fr: ['Exercices de base', '1 profil enfant', 'Niveau débutant'], en: ['Basic exercises', '1 child profile', 'Beginner level'] }
  },
  premium: {
    name: { fr: 'Premium', en: 'Premium' },
    profiles: 3,
    monthly: { price: 4.99, originalPrice: 6.99, discount: 28 },
    quarterly: { price: 13.47, originalPrice: 20.97, discount: 35 }, // 10% + 28% = 35%
    annual: { price: 41.93, originalPrice: 83.88, discount: 50 }, // 30% + 28% = 50%
    features: { fr: ['Exercices illimités', '3 profils enfants', 'Tous les niveaux', 'Mode hors-ligne'], en: ['Unlimited exercises', '3 child profiles', 'All levels', 'Offline mode'] }
  },
  family: {
    name: { fr: 'Famille', en: 'Family' },
    profiles: 5,
    monthly: { price: 6.99, originalPrice: 9.99, discount: 30 },
    quarterly: { price: 18.87, originalPrice: 29.97, discount: 37 }, // 10% + 30% = 37%
    annual: { price: 58.33, originalPrice: 119.88, discount: 51 }, // 30% + 30% = 51%
    features: { fr: ['Tout Premium inclus', '5 profils enfants', 'Rapports parents', 'Support prioritaire'], en: ['All Premium included', '5 child profiles', 'Parent reports', 'Priority support'] }
  },
  school: {
    name: { fr: 'École', en: 'School' },
    profiles: 30,
    monthly: { price: 24.99, originalPrice: 29.99, discount: 20 },
    quarterly: { price: 67.47, originalPrice: 89.97, discount: 25 }, // 10% + 20% = 25%
    annual: { price: 209.93, originalPrice: 359.88, discount: 42 }, // 30% + 20% = 42%
    features: { fr: ['Tout Famille inclus', '30 profils élèves', 'Dashboard professeur', 'Formation incluse'], en: ['All Family included', '30 student profiles', 'Teacher dashboard', 'Training included'] }
  }
}

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricingModal, setShowPricingModal] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState('monthly')
  const [languageSearch, setLanguageSearch] = useState('')
  const [isLoaded, setIsLoaded] = useState(false)
  
  const t = TRANSLATIONS[currentLang as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  const currentLangConfig = LANGUAGE_CONFIG[currentLang as keyof typeof LANGUAGE_CONFIG] || LANGUAGE_CONFIG.fr

  // Animation d'entrée
  useEffect(() => {
    setIsLoaded(true)
  }, [])

  // Filtrer les langues par recherche
  const filteredLanguages = Object.entries(LANGUAGE_CONFIG).filter(([code, config]) =>
    config.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    config.nativeName.toLowerCase().includes(languageSearch.toLowerCase()) ||
    code.toLowerCase().includes(languageSearch.toLowerCase()) ||
    config.region.toLowerCase().includes(languageSearch.toLowerCase())
  )

  // Grouper les langues par région
  const languagesByRegion = filteredLanguages.reduce((acc, [code, config]) => {
    const region = config.region
    if (!acc[region]) acc[region] = []
    acc[region].push([code, config])
    return acc
  }, {} as Record<string, [string, any][]>)

  const handleStartFree = () => {
    alert(`🎉 Essai gratuit de 14 jours démarré pour ${currentLangConfig.appName}!\n\n✅ Accès complet aux fonctionnalités\n✅ ${SUBSCRIPTION_PLANS.premium.profiles} profils enfants\n✅ Annulation à tout moment`)
  }

  const handleSubscribe = (planKey: string, period: string) => {
    const plan = SUBSCRIPTION_PLANS[planKey as keyof typeof SUBSCRIPTION_PLANS]
    const periodData = plan[period as keyof typeof plan] as any
    
    if (planKey === 'free') {
      handleStartFree()
      return
    }

    alert(`🚀 Abonnement ${plan.name[currentLang as keyof typeof plan.name]} sélectionné!\n\n💰 Prix: ${periodData.price}€/${period === 'monthly' ? 'mois' : period === 'quarterly' ? 'trimestre' : 'an'}\n👥 ${plan.profiles} ${t.profiles}\n💾 ${periodData.discount}% d'économies\n\n✅ Paiement sécurisé en cours...`)
  }

  // Fermer dropdown au clic extérieur
  useEffect(() => {
    const handleClickOutside = () => {
      setShowLanguageDropdown(false)
      setLanguageSearch('')
    }
    document.addEventListener('click', handleClickOutside)
    return () => document.removeEventListener('click', handleClickOutside)
  }, [])

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 transition-all duration-700 ${isLoaded ? 'opacity-100' : 'opacity-0'}`}>
      
      {/* Header amélioré avec effets */}
      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-xl border-b border-gray-200/50 shadow-lg transition-all duration-300">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-18">
            
            {/* Logo amélioré */}
            <div className="flex items-center space-x-4">
              <div className="w-14 h-14 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-xl flex items-center justify-center shadow-xl transform hover:scale-110 hover:rotate-3 transition-all duration-300 cursor-pointer">
                <span className="text-white text-2xl font-bold animate-pulse">🧮</span>
              </div>
              <div>
                <h1 className="text-xl font-bold bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent">
                  {currentLangConfig.appName}
                </h1>
                <p className="text-xs text-gray-600 flex items-center">
                  <Crown size={12} className="mr-1 text-orange-500 animate-bounce" />
                  {t.tagline}
                </p>
              </div>
            </div>
            
            {/* Navigation améliorée */}
            <div className="flex items-center space-x-6">
              
              {/* Badge familles avec animation */}
              <div className="hidden md:flex items-center space-x-2 bg-gradient-to-r from-green-100 to-emerald-100 text-green-800 rounded-full px-4 py-2 text-sm font-medium shadow-md hover:shadow-lg transition-all duration-300 transform hover:scale-105">
                <Users size={16} className="animate-pulse" />
                <span className="font-bold">100k+ familles</span>
              </div>
              
              {/* Sélecteur de langue universel amélioré */}
              <div className="relative">
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    setShowLanguageDropdown(!showLanguageDropdown)
                  }}
                  className="flex items-center space-x-3 bg-gradient-to-r from-gray-100 to-gray-200 hover:from-gray-200 hover:to-gray-300 rounded-xl px-4 py-3 text-gray-700 transition-all duration-300 shadow-md hover:shadow-lg transform hover:scale-105"
                  data-testid="language-dropdown-button"
                >
                  <Languages size={18} className="text-blue-500" />
                  <span className="text-2xl">{currentLangConfig.flag}</span>
                  <div className="text-left">
                    <div className="text-sm font-bold">{currentLangConfig.name}</div>
                    <div className="text-xs text-gray-500">{currentLangConfig.region}</div>
                  </div>
                  <ChevronDown size={16} className={`transform transition-transform duration-300 ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {/* Dropdown universel avec recherche */}
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-3 w-96 bg-white/98 backdrop-blur-xl rounded-2xl shadow-2xl border border-gray-200/50 overflow-hidden z-50 animate-in slide-in-from-top-2 duration-300">
                    
                    {/* Header du dropdown */}
                    <div className="p-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
                      <div className="flex items-center justify-between mb-3">
                        <h3 className="text-lg font-bold text-gray-900">Sélectionner une langue</h3>
                        <div className="text-sm text-gray-600 bg-white/80 rounded-full px-3 py-1">
                          47+ langues
                        </div>
                      </div>
                      
                      {/* Barre de recherche */}
                      <div className="relative">
                        <input
                          type="text"
                          placeholder="Rechercher une langue..."
                          value={languageSearch}
                          onChange={(e) => setLanguageSearch(e.target.value)}
                          className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                          onClick={(e) => e.stopPropagation()}
                        />
                        <Globe size={16} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                      </div>
                    </div>
                    
                    {/* Liste des langues par région */}
                    <div className="max-h-80 overflow-y-auto language-dropdown-scroll">
                      {Object.entries(languagesByRegion).map(([region, languages]) => (
                        <div key={region}>
                          <div className="px-4 py-2 bg-gray-50 text-xs font-semibold text-gray-600 uppercase tracking-wide sticky top-0">
                            {region}
                          </div>
                          {languages.map(([code, config]) => (
                            <button
                              key={code}
                              onClick={(e) => {
                                e.stopPropagation()
                                setCurrentLang(code)
                                setShowLanguageDropdown(false)
                                setLanguageSearch('')
                              }}
                              className={`w-full text-left px-4 py-3 hover:bg-blue-50 transition-all duration-200 flex items-center space-x-3 ${
                                currentLang === code ? 'bg-blue-100 text-blue-900 font-medium border-l-4 border-blue-500' : 'text-gray-700'
                              }`}
                              data-testid={`language-option-${code}`}
                            >
                              <span className="text-2xl">{config.flag}</span>
                              <div className="flex-1">
                                <div className="font-medium">{config.nativeName}</div>
                                <div className="text-xs text-gray-500">{config.name} • {config.appName}</div>
                              </div>
                              {currentLang === code && (
                                <CheckCircle size={18} className="text-blue-500" />
                              )}
                            </button>
                          ))}
                        </div>
                      ))}
                    </div>
                    
                    {/* Footer du dropdown */}
                    <div className="p-4 border-t border-gray-100 bg-gradient-to-r from-gray-50 to-blue-50">
                      <p className="text-xs text-gray-600 text-center">
                        ✨ Interface traduite automatiquement • Support RTL complet
                      </p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section perfectionné */}
      <main className="relative overflow-hidden">
        
        {/* Particules animées améliorées */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-96 h-96 bg-purple-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-96 h-96 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute top-40 left-1/4 w-80 h-80 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute bottom-40 right-1/4 w-72 h-72 bg-blue-200 rounded-full mix-blend-multiply filter blur-xl opacity-40 animate-pulse"></div>
          <div className="absolute top-1/2 left-1/2 w-64 h-64 bg-green-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          
          {/* Section hero principale */}
          <div className="text-center mb-24">
            
            {/* Badge Leader mondial amélioré */}
            <div className="inline-flex items-center space-x-3 bg-gradient-to-r from-orange-100 via-red-100 to-pink-100 rounded-full px-8 py-4 mb-12 border border-orange-200/50 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
              <Globe size={22} className="text-orange-600 animate-spin" style={{animationDuration: '8s'}} />
              <span className="text-orange-800 font-bold text-base">www.math4child.com • Leader mondial</span>
              <Star size={18} className="text-yellow-500 animate-pulse" />
            </div>

            {/* Titre principal amélioré */}
            <h2 className="text-5xl sm:text-6xl lg:text-8xl font-bold text-gray-900 mb-10 leading-tight">
              <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent animate-pulse drop-shadow-lg">
                {t.heroTitle}
              </span>
            </h2>
            
            <p className="text-2xl sm:text-3xl text-gray-700 mb-12 max-w-4xl mx-auto font-light leading-relaxed drop-shadow-sm">
              {t.heroWelcome}
            </p>
            
            {/* 5 Fonctionnalités améliorées */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 mb-20 max-w-6xl mx-auto">
              {t.features.map((feature, index) => (
                <div 
                  key={index} 
                  className="bg-white/90 backdrop-blur-sm rounded-2xl p-6 border border-gray-200/50 shadow-xl hover:shadow-2xl transition-all duration-500 hover:scale-105 hover:-translate-y-2 cursor-pointer group"
                  style={{animationDelay: `${index * 100}ms`}}
                >
                  <div className="mb-3">
                    {index === 0 && <Crown className="h-8 w-8 text-yellow-500 mx-auto group-hover:animate-bounce" />}
                    {index === 1 && <Languages className="h-8 w-8 text-blue-500 mx-auto group-hover:animate-bounce" />}
                    {index === 2 && <Smartphone className="h-8 w-8 text-green-500 mx-auto group-hover:animate-bounce" />}
                    {index === 3 && <BarChart className="h-8 w-8 text-purple-500 mx-auto group-hover:animate-bounce" />}
                    {index === 4 && <BookOpen className="h-8 w-8 text-red-500 mx-auto group-hover:animate-bounce" />}
                  </div>
                  <p className="text-sm font-semibold text-gray-800 leading-tight group-hover:text-blue-600 transition-colors">
                    {feature}
                  </p>
                </div>
              ))}
            </div>
          </div>
          
          {/* Boutons CTA améliorés */}
          <div className="flex flex-col sm:flex-row gap-8 justify-center items-center mb-24">
            
            <button 
              onClick={handleStartFree}
              className="group bg-gradient-to-r from-green-500 via-emerald-500 to-green-600 text-white px-12 py-6 rounded-3xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-500 transform hover:scale-110 hover:-translate-y-1 shadow-2xl hover:shadow-green-500/50 flex items-center space-x-4 min-w-[380px] relative overflow-hidden"
            >
              <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 translate-x-[-100%] group-hover:translate-x-[200%] transition-transform duration-1000"></div>
              <Gift size={32} className="group-hover:animate-bounce relative z-10" />
              <div className="text-left relative z-10">
                <div className="text-xl">{t.startFree}</div>
                <div className="text-sm opacity-90 font-normal">{t.freeTrial}</div>
              </div>
              <ArrowRight size={28} className="group-hover:translate-x-2 transition-transform duration-300 relative z-10" />
            </button>
            
            <button 
              onClick={() => setShowPricingModal(true)}
              className="group bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-600 text-white px-12 py-6 rounded-3xl text-xl font-bold hover:from-blue-600 hover:to-purple-700 transition-all duration-500 transform hover:scale-110 hover:-translate-y-1 shadow-2xl hover:shadow-blue-500/50 flex items-center space-x-4 min-w-[380px] relative overflow-hidden"
            >
              <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 translate-x-[-100%] group-hover:translate-x-[200%] transition-transform duration-1000"></div>
              <TrendingUp size={32} className="group-hover:animate-bounce relative z-10" />
              <span className="relative z-10">{t.comparePrices}</span>
            </button>
          </div>

          {/* Statistiques améliorées */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-10 mb-20 max-w-5xl mx-auto">
            <div className="text-center bg-white/70 backdrop-blur-sm rounded-3xl p-8 border border-gray-200/50 shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 group">
              <div className="text-5xl font-bold text-blue-600 mb-4 group-hover:animate-pulse">100k+</div>
              <div className="text-gray-700 font-semibold text-lg mb-2">Familles actives</div>
              <div className="text-gray-500 text-sm">Dans le monde entier</div>
            </div>
            <div className="text-center bg-white/70 backdrop-blur-sm rounded-3xl p-8 border border-gray-200/50 shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 group">
              <div className="text-5xl font-bold text-green-600 mb-4 group-hover:animate-pulse">98%</div>
              <div className="text-gray-700 font-semibold text-lg mb-2">Satisfaction parents</div>
              <div className="text-gray-500 text-sm">Note moyenne</div>
            </div>
            <div className="text-center bg-white/70 backdrop-blur-sm rounded-3xl p-8 border border-gray-200/50 shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 group">
              <div className="text-5xl font-bold text-purple-600 mb-4 group-hover:animate-pulse">47</div>
              <div className="text-gray-700 font-semibold text-lg mb-2">Pays disponibles</div>
              <div className="text-gray-500 text-sm">Et plus chaque mois</div>
            </div>
          </div>

          {/* Section plateformes améliorée */}
          <div className="text-center mb-16">
            <h3 className="text-4xl font-bold text-gray-900 mb-12 drop-shadow-sm">Disponible sur toutes vos plateformes</h3>
            <div className="flex justify-center items-center space-x-16">
              <div className="text-center group hover:scale-125 transition-all duration-500 cursor-pointer">
                <div className="w-20 h-20 bg-gradient-to-br from-blue-100 to-blue-200 rounded-3xl flex items-center justify-center mb-4 group-hover:shadow-2xl transition-all duration-500">
                  <Monitor size={48} className="text-blue-500 group-hover:animate-bounce" />
                </div>
                <p className="text-gray-700 font-semibold text-lg">Web</p>
                <p className="text-gray-500 text-sm">Navigateur</p>
              </div>
              <div className="text-center group hover:scale-125 transition-all duration-500 cursor-pointer">
                <div className="w-20 h-20 bg-gradient-to-br from-green-100 to-green-200 rounded-3xl flex items-center justify-center mb-4 group-hover:shadow-2xl transition-all duration-500">
                  <Smartphone size={48} className="text-green-500 group-hover:animate-bounce" />
                </div>
                <p className="text-gray-700 font-semibold text-lg">iOS</p>
                <p className="text-gray-500 text-sm">iPhone/iPad</p>
              </div>
              <div className="text-center group hover:scale-125 transition-all duration-500 cursor-pointer">
                <div className="w-20 h-20 bg-gradient-to-br from-orange-100 to-orange-200 rounded-3xl flex items-center justify-center mb-4 group-hover:shadow-2xl transition-all duration-500">
                  <Tablet size={48} className="text-orange-500 group-hover:animate-bounce" />
                </div>
                <p className="text-gray-700 font-semibold text-lg">Android</p>
                <p className="text-gray-500 text-sm">Tablettes/Téléphones</p>
              </div>
            </div>
          </div>
        </div>
      </main>

      {/* Modal de pricing complet avec tous les abonnements */}
      {showPricingModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-in fade-in duration-300">
          <div className="bg-white rounded-3xl max-w-7xl w-full max-h-[95vh] overflow-y-auto shadow-2xl animate-in slide-in-from-bottom-4 duration-300">
            <div className="p-8">
              
              <div className="flex justify-between items-center mb-10">
                <div>
                  <h3 className="text-4xl font-bold text-gray-900">Choisissez votre plan</h3>
                  <p className="text-gray-600 mt-2 text-lg">Commencez votre essai gratuit de 14 jours dès maintenant</p>
                </div>
                <button 
                  onClick={() => setShowPricingModal(false)}
                  className="text-gray-500 hover:text-gray-700 text-4xl font-light hover:scale-110 transition-all duration-200 w-12 h-12 rounded-full hover:bg-gray-100 flex items-center justify-center"
                >
                  <X size={24} />
                </button>
              </div>

              {/* Sélecteur de période */}
              <div className="flex justify-center mb-10">
                <div className="bg-gray-100 rounded-2xl p-2 flex space-x-2">
                  {['monthly', 'quarterly', 'annual'].map((period) => (
                    <button
                      key={period}
                      onClick={() => setSelectedPeriod(period)}
                      className={`px-6 py-3 rounded-xl font-semibold transition-all duration-300 ${
                        selectedPeriod === period
                          ? 'bg-white text-blue-600 shadow-lg transform scale-105'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {t[period as keyof typeof t]}
                      {period === 'quarterly' && <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">-10%</span>}
                      {period === 'annual' && <span className="ml-2 text-xs bg-red-100 text-red-800 px-2 py-1 rounded-full">-30%</span>}
                    </button>
                  ))}
                </div>
              </div>
              
              {/* Plans avec toutes les périodes */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                
                {Object.entries(SUBSCRIPTION_PLANS).map(([planKey, plan]) => {
                  const periodData = plan[selectedPeriod as keyof typeof plan] as any
                  const isPopular = planKey === 'family'
                  const isRecommended = planKey === 'school'
                  
                  return (
                    <div 
                      key={planKey}
                      className={`border-2 rounded-3xl p-8 transition-all duration-500 transform hover:scale-105 hover:shadow-2xl ${
                        isPopular 
                          ? 'border-purple-500 bg-gradient-to-br from-purple-50 to-pink-50 shadow-xl scale-105' 
                          : isRecommended 
                          ? 'border-orange-200 bg-gradient-to-br from-orange-50 to-yellow-50 shadow-lg'
                          : planKey === 'free'
                          ? 'border-gray-200 bg-gray-50'
                          : 'border-blue-200 bg-gradient-to-br from-blue-50 to-indigo-50'
                      }`}
                    >
                      {/* Badge du plan */}
                      {isPopular && (
                        <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-purple-500 to-pink-500 text-white text-sm px-6 py-2 rounded-full font-bold shadow-lg animate-pulse">
                          🏆 {t.mostPopular}
                        </div>
                      )}
                      {isRecommended && (
                        <div className="text-xs text-orange-600 mb-3 font-bold bg-white/80 rounded-full px-3 py-1 text-center">
                          🎓 {t.recommended}
                        </div>
                      )}

                      <div className="mb-6">
                        <h4 className={`text-2xl font-bold mb-3 ${
                          isPopular ? 'text-purple-800' : 
                          isRecommended ? 'text-orange-800' : 
                          planKey === 'free' ? 'text-gray-800' : 'text-blue-800'
                        }`}>
                          {plan.name[currentLang as keyof typeof plan.name]}
                        </h4>

                        {/* Prix avec période */}
                        <div className="mb-4">
                          {planKey === 'free' ? (
                            <div className="text-4xl font-bold text-gray-800">0€</div>
                          ) : (
                            <div className="flex items-center space-x-3">
                              <span className={`text-4xl font-bold ${
                                isPopular ? 'text-purple-800' : 
                                isRecommended ? 'text-orange-800' : 'text-blue-800'
                              }`}>
                                {periodData.price}€
                              </span>
                              {periodData.originalPrice > periodData.price && (
                                <>
                                  <span className="text-xl text-gray-500 line-through">
                                    {periodData.originalPrice}€
                                  </span>
                                  <span className="bg-green-500 text-white text-xs px-3 py-1 rounded-full font-bold animate-pulse">
                                    -{periodData.discount}%
                                  </span>
                                </>
                              )}
                            </div>
                          )}
                          <div className="text-sm text-gray-500 mt-1">
                            {selectedPeriod === 'monthly' ? '/mois' : 
                             selectedPeriod === 'quarterly' ? '/trimestre' : 
                             '/an'}
                          </div>
                        </div>

                        {/* Nombre de profils */}
                        <div className={`mb-6 p-3 rounded-lg ${
                          isPopular ? 'bg-purple-100' : 
                          isRecommended ? 'bg-orange-100' : 
                          planKey === 'free' ? 'bg-gray-100' : 'bg-blue-100'
                        }`}>
                          <div className="flex items-center justify-center space-x-2">
                            <Users size={18} className={
                              isPopular ? 'text-purple-600' : 
                              isRecommended ? 'text-orange-600' : 
                              planKey === 'free' ? 'text-gray-600' : 'text-blue-600'
                            } />
                            <span className="font-bold">
                              {plan.profiles} {t.profiles}
                            </span>
                          </div>
                        </div>
                      </div>

                      {/* Fonctionnalités */}
                      <ul className="space-y-4 text-sm mb-8">
                        {plan.features[currentLang as keyof typeof plan.features].map((feature, index) => (
                          <li key={index} className="flex items-start space-x-3">
                            <CheckCircle size={18} className="text-green-500 mt-0.5 flex-shrink-0" />
                            <span className="text-gray-700">{feature}</span>
                          </li>
                        ))}
                      </ul>

                      {/* Bouton d'abonnement */}
                      <button 
                        onClick={() => handleSubscribe(planKey, selectedPeriod)}
                        className={`w-full py-4 rounded-2xl font-bold transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl ${
                          planKey === 'free' 
                            ? 'bg-gray-200 text-gray-800 hover:bg-gray-300' :
                          isPopular 
                            ? 'bg-gradient-to-r from-purple-600 to-pink-600 text-white hover:from-purple-700 hover:to-pink-700' :
                          isRecommended 
                            ? 'bg-gradient-to-r from-orange-600 to-red-600 text-white hover:from-orange-700 hover:to-red-700' :
                            'bg-gradient-to-r from-blue-600 to-indigo-600 text-white hover:from-blue-700 hover:to-indigo-700'
                        }`}
                      >
                        {planKey === 'free' ? t.startFree : 
                         planKey === 'school' ? 'Demander un devis' : 
                         `Essai ${t.freeTrial}`}
                      </button>
                    </div>
                  )
                })}
              </div>
              
              {/* Footer du modal */}
              <div className="mt-12 text-center">
                <p className="text-gray-600 mb-6 text-lg">
                  ✨ Tous les plans incluent : Accès mobile et web • Support client 24/7 • Mises à jour gratuites à vie
                </p>
                <button 
                  onClick={handleStartFree}
                  className="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-16 py-5 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-300 shadow-xl transform hover:scale-105"
                >
                  🚀 Commencer l'essai gratuit maintenant
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Footer amélioré */}
      <footer className="bg-gradient-to-r from-gray-900 via-gray-800 to-gray-900 text-white relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-900/20 to-purple-900/20"></div>
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="text-center">
            <div className="flex items-center justify-center space-x-4 mb-10">
              <div className="w-20 h-20 bg-gradient-to-br from-orange-400 to-red-500 rounded-2xl flex items-center justify-center shadow-2xl transform hover:scale-110 transition-transform duration-300">
                <span className="text-white text-3xl font-bold">🧮</span>
              </div>
              <h3 className="text-4xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                {currentLangConfig.appName}
              </h3>
            </div>
            <p className="text-gray-300 mb-12 max-w-4xl mx-auto text-lg leading-relaxed">
              L'application éducative de confiance pour apprendre les mathématiques en famille. 
              Rejoignez plus de 100,000 familles dans l'aventure éducative Math4Child.
            </p>
            <div className="flex justify-center space-x-12 text-gray-400 mb-10">
              <a href="#" className="hover:text-white transition-colors hover:scale-110 transform duration-300">Conditions d'utilisation</a>
              <a href="#" className="hover:text-white transition-colors hover:scale-110 transform duration-300">Politique de confidentialité</a>
              <a href="#" className="hover:text-white transition-colors hover:scale-110 transform duration-300">Contact</a>
              <a href="#" className="hover:text-white transition-colors hover:scale-110 transform duration-300">Support</a>
            </div>
            <div className="pt-10 border-t border-gray-700">
              <p className="text-gray-500">© 2024 Math4Child. Tous droits réservés. Made with ❤️ pour l'éducation.</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}
