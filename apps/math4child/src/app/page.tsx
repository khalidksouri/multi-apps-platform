'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

// Système de traduction (extraits principaux)
const TRANSLATIONS = {
  fr: {
    appName: 'Math4Child',
    subtitle: 'L\'apprentissage des mathématiques en s\'amusant',
    hero: {
      title: 'Transformez l\'apprentissage des maths en aventure !',
      subtitle: 'Plus de 100 000 familles font confiance à Math4Child',
      cta: 'Commencer Gratuitement',
      freeTrial: '7 jours gratuits - 50 questions',
      watchDemo: 'Voir la Démo'
    },
    features: {
      title: 'Pourquoi Math4Child ?',
      subtitle: 'Une approche révolutionnaire de l\'apprentissage des mathématiques',
      items: [
        { icon: '🧮', title: 'Apprentissage Progressif', desc: '5 niveaux avec 100 bonnes réponses par niveau' },
        { icon: '📊', title: '5 Opérations Complètes', desc: 'Addition, soustraction, multiplication, division, mixte' },
        { icon: '🏆', title: 'Système de Récompenses', desc: 'Badges et défis pour motiver l\'apprentissage' },
        { icon: '🌍', title: '75+ Langues', desc: 'Interface disponible dans le monde entier' },
        { icon: '📱', title: 'Multi-Plateformes', desc: 'Web, iOS, Android - synchronisé partout' },
        { icon: '👨‍👩‍👧‍👦', title: 'Suivi Parental', desc: 'Rapports détaillés sur les performances' }
      ]
    },
    pricing: {
      title: 'Choisissez votre formule',
      subtitle: 'Plans flexibles pour tous les besoins',
      monthly: 'Mensuel',
      quarterly: 'Trimestriel', 
      annual: 'Annuel',
      save: 'Économisez',
      mostPopular: 'Le plus populaire',
      choosePlan: 'Choisir ce plan',
      profiles: 'profils',
      recommended: 'Recommandé pour écoles'
    },
    footer: {
      description: 'Math4Child aide les enfants de 4 à 12 ans à maîtriser les mathématiques grâce à des jeux éducatifs innovants.',
      features: 'Fonctionnalités',
      support: 'Support',
      download: 'Télécharger',
      interactive: 'Exercices interactifs',
      progress: 'Suivi des progrès',
      games: 'Jeux éducatifs',
      multiplayer: 'Mode multijoueur',
      help: 'Centre d\'aide',
      contact: 'Nous contacter',
      guides: 'Guides parents',
      community: 'Communauté',
      downloadOn: 'Télécharger sur',
      availableOn: 'Disponible sur',
      appStore: 'App Store',
      googlePlay: 'Google Play',
      rights: 'Tous droits réservés. Fait avec ❤️ pour l\'éducation.'
    }
  },
  en: {
    appName: 'Math4Child',
    subtitle: 'Making math learning fun and engaging',
    hero: {
      title: 'Transform Math Learning into an Adventure!',
      subtitle: 'Over 100,000 families trust Math4Child',
      cta: 'Start Free',
      freeTrial: '7 days free - 50 questions',
      watchDemo: 'Watch Demo'
    },
    features: {
      title: 'Why Math4Child?',
      subtitle: 'A revolutionary approach to mathematics learning',
      items: [
        { icon: '🧮', title: 'Progressive Learning', desc: '5 levels with 100 correct answers per level' },
        { icon: '📊', title: '5 Complete Operations', desc: 'Addition, subtraction, multiplication, division, mixed' },
        { icon: '🏆', title: 'Reward System', desc: 'Badges and challenges to motivate learning' },
        { icon: '🌍', title: '75+ Languages', desc: 'Interface available worldwide' },
        { icon: '📱', title: 'Multi-Platform', desc: 'Web, iOS, Android - synced everywhere' },
        { icon: '👨‍👩‍👧‍👦', title: 'Parental Control', desc: 'Detailed performance reports' }
      ]
    },
    pricing: {
      title: 'Choose Your Plan',
      subtitle: 'Flexible plans for every need',
      monthly: 'Monthly',
      quarterly: 'Quarterly',
      annual: 'Annual', 
      save: 'Save',
      mostPopular: 'Most Popular',
      choosePlan: 'Choose Plan',
      profiles: 'profiles',
      recommended: 'Recommended for schools'
    },
    footer: {
      description: 'Math4Child helps children aged 4-12 master mathematics through innovative educational games.',
      features: 'Features',
      support: 'Support',
      download: 'Download',
      interactive: 'Interactive exercises',
      progress: 'Progress tracking',
      games: 'Educational games',
      multiplayer: 'Multiplayer mode',
      help: 'Help Center',
      contact: 'Contact Us',
      guides: 'Parent Guides',
      community: 'Community',
      downloadOn: 'Download on',
      availableOn: 'Available on',
      appStore: 'App Store',
      googlePlay: 'Google Play',
      rights: 'All rights reserved. Made with ❤️ for education.'
    }
  }
}

// Plans d'abonnement CORRIGÉS
const SUBSCRIPTION_PLANS = {
  free: {
    name: { fr: 'Gratuit', en: 'Free' },
    profiles: 1,
    duration: { fr: '7 jours', en: '7 days' },
    totalQuestions: 50,
    price: 0,
    originalPrice: 0,
    discount: 0,
    features: { 
      fr: ['50 questions au total', '1 profil enfant', 'Accès 7 jours seulement', 'Niveau débutant uniquement', 'Support email basique'], 
      en: ['50 total questions', '1 child profile', '7 days access only', 'Beginner level only', 'Basic email support'] 
    },
    color: 'gray',
    popular: false
  },
  premium: {
    name: { fr: 'Premium', en: 'Premium' },
    profiles: 3,
    monthly: { price: 9.99, originalPrice: 12.99, discount: 23 },
    quarterly: { price: 26.97, originalPrice: 38.97, discount: 31 },
    annual: { price: 83.99, originalPrice: 155.88, discount: 46 },
    features: { 
      fr: ['Questions illimitées', '3 profils enfants', 'Tous les 5 niveaux', '5 opérations (addition, soustraction, multiplication, division, mixte)', 'Statistiques détaillées', 'Sans publicité'], 
      en: ['Unlimited questions', '3 child profiles', 'All 5 levels', '5 operations (addition, subtraction, multiplication, division, mixed)', 'Detailed statistics', 'Ad-free'] 
    },
    color: 'blue',
    popular: true
  },
  family: {
    name: { fr: 'Famille', en: 'Family' },
    profiles: 6,
    monthly: { price: 14.99, originalPrice: 19.99, discount: 25 },
    quarterly: { price: 40.47, originalPrice: 59.97, discount: 33 },
    annual: { price: 125.99, originalPrice: 239.88, discount: 47 },
    features: { 
      fr: ['Tout Premium inclus', '6 profils enfants', 'Rapports parents détaillés', 'Support prioritaire', 'Mode hors-ligne', 'Contrôles parentaux avancés'], 
      en: ['All Premium included', '6 child profiles', 'Detailed parent reports', 'Priority support', 'Offline mode', 'Advanced parental controls'] 
    },
    color: 'purple',
    popular: false
  },
  school: {
    name: { fr: 'École/Association', en: 'School/Association' },
    profiles: 50,
    monthly: { price: 49.99, originalPrice: 69.99, discount: 28 },
    quarterly: { price: 134.97, originalPrice: 209.97, discount: 36 },
    annual: { price: 419.99, originalPrice: 839.88, discount: 50 },
    features: { 
      fr: ['Tout Famille inclus', '50 profils élèves', 'Dashboard enseignant complet', 'Rapports de classe détaillés', 'Formation pédagogique incluse', 'Support dédié 24/7'], 
      en: ['All Family included', '50 student profiles', 'Complete teacher dashboard', 'Detailed class reports', 'Educational training included', 'Dedicated 24/7 support'] 
    },
    color: 'green',
    popular: false,
    badge: { fr: 'Recommandé pour écoles', en: 'Recommended for schools' }
  }
}

// Langues supportées (75+) - Extraits principaux
const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'ar', name: 'العربية', flag: '🇲🇦' }, // Représenté par drapeau marocain
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱' }
  // ... 60+ autres langues
]

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricingModal, setShowPricingModal] = useState(false)
  const [selectedPeriod, setSelectedPeriod] = useState('monthly')
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  const t = TRANSLATIONS[currentLang as keyof typeof TRANSLATIONS]

  const formatPrice = (planKey: string, period: string) => {
    const plan = SUBSCRIPTION_PLANS[planKey as keyof typeof SUBSCRIPTION_PLANS]
    if (planKey === 'free') return '0€'
    
    const periodData = (plan as any)[period]
    if (!periodData) return '0€'
    
    return `${periodData.price.toFixed(2)}€`
  }

  const getDiscount = (planKey: string, period: string) => {
    const plan = SUBSCRIPTION_PLANS[planKey as keyof typeof SUBSCRIPTION_PLANS]
    if (planKey === 'free') return 0
    
    const periodData = (plan as any)[period]
    return periodData?.discount || 0
  }

  return (
    <div className="min-h-screen bg-white">
      {/* Header Navigation */}
      <header className="bg-white shadow-sm border-b sticky top-0 z-50">
        <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">🧮</span>
              </div>
              <div>
                <div className="font-bold text-xl text-gray-900">{t.appName}</div>
              </div>
            </div>

            {/* Desktop Menu */}
            <div className="hidden md:flex items-center space-x-8">
              <Link href="#features" className="text-gray-600 hover:text-gray-900 font-medium">
                Fonctionnalités
              </Link>
              <Link href="#pricing" className="text-gray-600 hover:text-gray-900 font-medium">
                Tarifs
              </Link>
              <Link href="/exercises" className="text-gray-600 hover:text-gray-900 font-medium">
                Exercices
              </Link>
              <Link href="/games" className="text-gray-600 hover:text-gray-900 font-medium">
                Jeux
              </Link>
              
              {/* Language Selector avec scroll */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-2 px-3 py-2 rounded-lg border hover:bg-gray-50"
                >
                  <span className="text-xl">
                    {LANGUAGES.find(lang => lang.code === currentLang)?.flag}
                  </span>
                  <span className="text-sm font-medium">
                    {LANGUAGES.find(lang => lang.code === currentLang)?.name}
                  </span>
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                  </svg>
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border py-2 z-10 max-h-96 overflow-y-auto">
                    <div className="px-4 py-2 text-xs text-gray-500 font-semibold border-b">
                      75+ Langues Disponibles
                    </div>
                    {LANGUAGES.map(language => (
                      <button
                        key={language.code}
                        onClick={() => {
                          setCurrentLang(language.code)
                          setShowLanguageDropdown(false)
                        }}
                        className={`w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center space-x-3 ${
                          currentLang === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                        }`}
                      >
                        <span className="text-xl">{language.flag}</span>
                        <span className="font-medium">{language.name}</span>
                      </button>
                    ))}
                    <div className="px-4 py-2 text-xs text-gray-400 border-t">
                      Barre de défilement active
                    </div>
                  </div>
                )}
              </div>

              <button
                onClick={() => setShowPricingModal(true)}
                className="bg-blue-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
              >
                {t.hero.cta}
              </button>
            </div>

            {/* Mobile menu button */}
            <div className="md:hidden">
              <button
                onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                className="text-gray-500 hover:text-gray-700"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              </button>
            </div>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            {/* Hero Content */}
            <div>
              <div className="inline-flex items-center px-4 py-2 rounded-full bg-orange-100 text-orange-800 text-sm font-medium mb-6">
                <span className="mr-2">🎉</span>
                {t.hero.subtitle}
              </div>
              
              <h1 className="text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
                {t.hero.title}
              </h1>
              
              <p className="text-xl text-gray-600 mb-8 leading-relaxed">
                {t.subtitle}
              </p>
              
              <div className="flex flex-col sm:flex-row gap-4">
                <button
                  onClick={() => setShowPricingModal(true)}
                  className="bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:bg-blue-700 transition-colors shadow-lg"
                >
                  {t.hero.cta}
                </button>
                <button className="border border-gray-300 text-gray-700 px-8 py-4 rounded-xl font-semibold text-lg hover:bg-gray-50 transition-colors">
                  {t.hero.watchDemo}
                </button>
              </div>
              
              <div className="mt-6 text-sm text-gray-500">
                {t.hero.freeTrial} • Aucune carte requise
              </div>
            </div>

            {/* Hero Visual */}
            <div className="relative">
              <div className="bg-white rounded-2xl shadow-2xl p-8 transform rotate-3 hover:rotate-0 transition-transform duration-300">
                <div className="text-center mb-6">
                  <div className="text-4xl mb-4">🧮</div>
                  <h3 className="text-2xl font-bold text-gray-900">Math4Child</h3>
                  <p className="text-gray-600">5 Niveaux • 5 Opérations • 75+ Langues</p>
                </div>
                
                <div className="space-y-4">
                  <div className="bg-blue-50 rounded-lg p-4">
                    <div className="text-center">
                      <div className="text-3xl font-bold text-blue-600 mb-2">15 + 7 = ?</div>
                      <div className="flex justify-center gap-2">
                        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm">22</button>
                        <button className="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg text-sm">21</button>
                        <button className="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg text-sm">23</button>
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex justify-between text-sm">
                    <span className="text-green-600 font-semibold">✓ Niveau 3/5</span>
                    <span className="text-orange-600 font-semibold">🔥 87/100 bonnes réponses</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              {t.features.title}
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              {t.features.subtitle}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {t.features.items.map((feature, index) => (
              <div key={index} className="bg-white p-8 rounded-2xl border border-gray-100 hover:shadow-lg transition-shadow group">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-100 to-purple-100 rounded-2xl flex items-center justify-center text-2xl mb-6 group-hover:scale-110 transition-transform">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-4">{feature.title}</h3>
                <p className="text-gray-600 leading-relaxed">{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Quick Access */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Commencer Maintenant
            </h2>
            <p className="text-xl text-gray-600">
              Choisissez votre mode d'apprentissage
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <Link href="/exercises" className="group bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition-shadow border">
              <div className="text-center">
                <div className="w-16 h-16 bg-blue-100 rounded-2xl flex items-center justify-center text-3xl mx-auto mb-6 group-hover:scale-110 transition-transform">
                  📚
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-4">Exercices</h3>
                <p className="text-gray-600 mb-6">5 niveaux progressifs avec validation par 100 bonnes réponses</p>
                <div className="bg-blue-50 text-blue-600 px-4 py-2 rounded-lg text-sm font-medium">
                  5 opérations complètes
                </div>
              </div>
            </Link>

            <Link href="/games" className="group bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition-shadow border">
              <div className="text-center">
                <div className="w-16 h-16 bg-green-100 rounded-2xl flex items-center justify-center text-3xl mx-auto mb-6 group-hover:scale-110 transition-transform">
                  🎮
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-4">Jeux</h3>
                <p className="text-gray-600 mb-6">Apprentissage ludique avec défis et récompenses</p>
                <div className="bg-green-50 text-green-600 px-4 py-2 rounded-lg text-sm font-medium">
                  Gamification avancée
                </div>
              </div>
            </Link>

            <Link href="/progress" className="group bg-white rounded-2xl p-8 shadow-sm hover:shadow-lg transition-shadow border">
              <div className="text-center">
                <div className="w-16 h-16 bg-purple-100 rounded-2xl flex items-center justify-center text-3xl mx-auto mb-6 group-hover:scale-110 transition-transform">
                  📊
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-4">Progrès</h3>
                <p className="text-gray-600 mb-6">Suivi détaillé avec rapports pour parents et enseignants</p>
                <div className="bg-purple-50 text-purple-600 px-4 py-2 rounded-lg text-sm font-medium">
                  Analytics avancées
                </div>
              </div>
            </Link>
          </div>
        </div>
      </section>

      {/* Pricing Modal CORRIGÉ */}
      {showPricingModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl max-w-7xl w-full max-h-screen overflow-y-auto p-8">
            <div className="flex justify-between items-center mb-8">
              <div>
                <h2 className="text-3xl font-bold text-gray-900">{t.pricing.title}</h2>
                <p className="text-xl text-gray-600">{t.pricing.subtitle}</p>
              </div>
              <button
                onClick={() => setShowPricingModal(false)}
                className="text-gray-400 hover:text-gray-600 text-2xl"
              >
                ×
              </button>
            </div>

            {/* Period Selector */}
            <div className="flex justify-center mb-8">
              <div className="bg-gray-100 rounded-lg p-1 flex">
                {['monthly', 'quarterly', 'annual'].map(period => (
                  <button
                    key={period}
                    onClick={() => setSelectedPeriod(period)}
                    className={`px-6 py-2 rounded-md font-medium transition-colors ${
                      selectedPeriod === period 
                        ? 'bg-white text-gray-900 shadow-sm' 
                        : 'text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    {t.pricing[period as keyof typeof t.pricing]}
                    {period === 'annual' && (
                      <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">
                        {t.pricing.save} 47%
                      </span>
                    )}
                  </button>
                ))}
              </div>
            </div>

            {/* Pricing Cards CORRIGÉES */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {Object.entries(SUBSCRIPTION_PLANS).map(([planKey, plan]) => (
                <div
                  key={planKey}
                  className={`relative bg-white rounded-2xl border-2 p-6 ${
                    plan.popular 
                      ? 'border-blue-500 shadow-lg' 
                      : planKey === 'school'
                      ? 'border-green-500 shadow-md'
                      : 'border-gray-200'
                  }`}
                >
                  {plan.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                      <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                        {t.pricing.mostPopular}
                      </span>
                    </div>
                  )}
                  
                  {planKey === 'school' && plan.badge && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                      <span className="bg-green-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                        {plan.badge[currentLang as keyof typeof plan.badge]}
                      </span>
                    </div>
                  )}
                  
                  <div className="text-center">
                    <h3 className="text-2xl font-bold text-gray-900 mb-2">
                      {plan.name[currentLang as keyof typeof plan.name]}
                    </h3>
                    
                    <div className="mb-6">
                      {planKey === 'free' ? (
                        <div>
                          <div className="text-4xl font-bold text-gray-900">Gratuit</div>
                          <div className="text-sm text-gray-500">{plan.duration[currentLang as keyof typeof plan.duration]}</div>
                          <div className="text-sm text-orange-600 font-medium">{plan.totalQuestions} questions max</div>
                        </div>
                      ) : (
                        <>
                          <div className="text-4xl font-bold text-gray-900">
                            {formatPrice(planKey, selectedPeriod)}
                            <span className="text-lg text-gray-500 font-normal">
                              /{selectedPeriod === 'monthly' ? 'mois' : selectedPeriod === 'quarterly' ? 'trimestre' : 'an'}
                            </span>
                          </div>
                          {getDiscount(planKey, selectedPeriod) > 0 && (
                            <div className="text-sm text-green-600 font-medium">
                              Économisez {getDiscount(planKey, selectedPeriod)}%
                            </div>
                          )}
                        </>
                      )}
                    </div>

                    <div className="text-gray-600 mb-6">
                      {plan.profiles} {t.pricing.profiles}
                    </div>

                    <ul className="space-y-3 mb-8 text-left">
                      {plan.features[currentLang as keyof typeof plan.features].map((feature, index) => (
                        <li key={index} className="flex items-start text-gray-600">
                          <svg className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" />
                          </svg>
                          <span className="text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button className={`w-full py-3 px-6 rounded-lg font-semibold transition-colors ${
                      plan.popular 
                        ? 'bg-blue-600 text-white hover:bg-blue-700' 
                        : planKey === 'school'
                        ? 'bg-green-600 text-white hover:bg-green-700'
                        : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                    }`}>
                      {t.pricing.choosePlan}
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Réductions multi-appareils */}
            <div className="mt-8 bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-6">
              <h3 className="text-lg font-bold text-gray-900 mb-4">🎁 Réductions Multi-Appareils</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div className="text-center">
                  <div className="text-2xl font-bold text-blue-600">1er</div>
                  <div className="text-gray-600">Appareil : Prix plein</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-orange-600">2ème</div>
                  <div className="text-gray-600">Appareil : -50%</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-green-600">3ème</div>
                  <div className="text-gray-600">Appareil : -75%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-3 mb-6">
                <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center">
                  <span className="text-white text-xl font-bold">🧮</span>
                </div>
                <span className="text-2xl font-bold">{t.appName}</span>
              </div>
              <p className="text-gray-400 leading-relaxed">
                {t.footer.description}
              </p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t.footer.features}</h3>
              <ul className="space-y-2 text-gray-400">
                <li>{t.footer.interactive}</li>
                <li>{t.footer.progress}</li>
                <li>{t.footer.games}</li>
                <li>{t.footer.multiplayer}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t.footer.support}</h3>
              <ul className="space-y-2 text-gray-400">
                <li>{t.footer.help}</li>
                <li>{t.footer.contact}</li>
                <li>{t.footer.guides}</li>
                <li>{t.footer.community}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t.footer.download}</h3>
              <div className="space-y-3">
                <div className="bg-gray-800 rounded-lg p-3 flex items-center space-x-3 hover:bg-gray-700 transition-colors cursor-pointer">
                  <span className="text-2xl">📱</span>
                  <div>
                    <div className="text-sm text-gray-400">{t.footer.downloadOn}</div>
                    <div className="font-semibold">{t.footer.appStore}</div>
                  </div>
                </div>
                <div className="bg-gray-800 rounded-lg p-3 flex items-center space-x-3 hover:bg-gray-700 transition-colors cursor-pointer">
                  <span className="text-2xl">🤖</span>
                  <div>
                    <div className="text-sm text-gray-400">{t.footer.availableOn}</div>
                    <div className="font-semibold">{t.footer.googlePlay}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>&copy; 2024 Math4Child. {t.footer.rights}</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
