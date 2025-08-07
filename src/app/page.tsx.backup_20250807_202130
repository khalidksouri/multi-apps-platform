"use client"

import { useState } from 'react'
import { Check, ArrowRight, Star, Zap, Users, GraduationCap, Calendar, Globe, BookOpen, TrendingUp, Smartphone, ChevronDown, Search } from 'lucide-react'

export default function HomePage() {
  const [billingCycle, setBillingCycle] = useState<'monthly' | 'quarterly' | 'yearly'>('monthly')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')

  // Langues disponibles
  const languages = [
    { code: 'fr', flag: '🇫🇷', name: 'Français', nativeName: 'Français' },
    { code: 'en', flag: '🇬🇧', name: 'English', nativeName: 'English' },
    { code: 'es', flag: '🇪🇸', name: 'Spanish', nativeName: 'Español' },
    { code: 'de', flag: '🇩🇪', name: 'German', nativeName: 'Deutsch' },
    { code: 'it', flag: '🇮🇹', name: 'Italian', nativeName: 'Italiano' },
    { code: 'pt', flag: '🇵🇹', name: 'Portuguese', nativeName: 'Português' },
    { code: 'ar', flag: '🇸🇦', name: 'Arabic', nativeName: 'العربية' },
    { code: 'zh', flag: '🇨🇳', name: 'Chinese', nativeName: '中文' },
    { code: 'ja', flag: '🇯🇵', name: 'Japanese', nativeName: '日本語' },
    { code: 'ko', flag: '🇰🇷', name: 'Korean', nativeName: '한국어' }
  ]

  const [currentLanguage, setCurrentLanguage] = useState('fr')

  const filteredLanguages = languages.filter(lang => 
    !searchTerm || 
    lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const plans = [
    {
      id: 'free',
      name: 'Gratuit',
      price: { monthly: '0€', quarterly: '0€', yearly: '0€' },
      period: { monthly: '/7 jours', quarterly: '/7 jours', yearly: '/7 jours' },
      profiles: 1,
      description: "Découverte du 1er niveau",
      features: [
        "1er niveau uniquement (50 questions)",
        "Accès pendant 7 jours",
        "Toutes les opérations de base",
        "1 profil enfant",
        "Support communautaire"
      ],
      buttonText: "Commencer gratuitement",
      buttonClass: "bg-gray-600 hover:bg-gray-700 text-white",
      popular: false
    },
    {
      id: 'premium',
      name: 'Premium',
      price: { 
        monthly: '9.99€', 
        quarterly: '26.97€', 
        yearly: '83.93€' 
      },
      period: { 
        monthly: '/mois', 
        quarterly: '/3 mois', 
        yearly: '/an' 
      },
      originalPrice: { 
        monthly: null, 
        quarterly: '29.97€', 
        yearly: '119.88€' 
      },
      discount: { 
        monthly: null, 
        quarterly: '10%', 
        yearly: '30%' 
      },
      profiles: 3,
      description: "Le plus choisi par les familles",
      features: [
        "✨ Tous les 5 niveaux débloqués",
        "🚀 Questions illimitées", 
        "👥 3 profils enfants",
        "📊 Statistiques avancées",
        "🚫 Sans publicité",
        "💬 Support prioritaire"
      ],
      buttonText: "Choisir Premium",
      buttonClass: "bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white",
      popular: billingCycle === 'monthly'
    },
    {
      id: 'family',
      name: 'Famille',
      price: { 
        monthly: '14.99€', 
        quarterly: '40.47€', 
        yearly: '125.93€' 
      },
      period: { 
        monthly: '/mois', 
        quarterly: '/3 mois', 
        yearly: '/an' 
      },
      originalPrice: { 
        monthly: null, 
        quarterly: '44.97€', 
        yearly: '179.88€' 
      },
      discount: { 
        monthly: null, 
        quarterly: '10%', 
        yearly: '30%' 
      },
      profiles: 5,
      description: "Parfait pour toute la famille",
      features: [
        "👨‍👩‍👧‍👦 Jusqu'à 5 profils enfants",
        "✨ Toutes les fonctionnalités Premium",
        "📈 Rapports familiaux détaillés",
        "🔒 Contrôle parental avancé",
        "🏆 Classements familiaux",
        "💎 Support VIP prioritaire"
      ],
      buttonText: "Choisir Famille",
      buttonClass: "bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white",
      popular: billingCycle === 'quarterly' || billingCycle === 'yearly'
    },
    {
      id: 'school',
      name: 'Écoles/Associations',
      price: { 
        monthly: '49.99€', 
        quarterly: '134.97€', 
        yearly: '419.93€' 
      },
      period: { 
        monthly: '/mois', 
        quarterly: '/3 mois', 
        yearly: '/an' 
      },
      originalPrice: { 
        monthly: null, 
        quarterly: '149.97€', 
        yearly: '599.88€' 
      },
      discount: { 
        monthly: null, 
        quarterly: '10%', 
        yearly: '30%' 
      },
      profiles: 30,
      description: "Pour établissements scolaires",
      features: [
        "🏫 Jusqu'à 30 profils élèves",
        "👩‍🏫 Dashboard enseignant complet",
        "📝 Assignation de devoirs",
        "📊 Rapports de classe détaillés",
        "🎓 Formation enseignants incluse",
        "🔧 Support technique dédié"
      ],
      buttonText: "Contacter l'équipe",
      buttonClass: "bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white",
      popular: false
    }
  ]

  // Fonctions d'action
  const handleStartFree = () => {
    alert('🚀 Démarrage de la version gratuite !\n\nVous avez accès au 1er niveau (50 questions) pendant 7 jours.')
  }

  const handleViewPlans = () => {
    // Scroll vers la section pricing
    const pricingSection = document.getElementById('pricing-section')
    if (pricingSection) {
      pricingSection.scrollIntoView({ behavior: 'smooth' })
    }
  }

  const handleChoosePlan = (plan: any) => {
    alert(`💎 Plan ${plan.name} sélectionné !\n\n${plan.profiles} profils • ${plan.description}`)
  }

  const handleLanguageChange = (langCode: string) => {
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
    alert(`🌍 Langue changée vers ${languages.find(l => l.code === langCode)?.nativeName}`)
  }

  const scrollToPricing = () => {
    const element = document.getElementById('pricing-section')
    element?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header/Navigation */}
      <nav className="bg-white/80 backdrop-blur-md border-b border-gray-200 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
              <span className="text-xl font-bold text-gray-900">Math4Child</span>
            </div>
            
            <div className="hidden md:flex items-center gap-8">
              <a href="/" className="text-gray-700 hover:text-blue-600 transition-colors">Accueil</a>
              <a href="/exercises" className="text-gray-700 hover:text-blue-600 transition-colors">Exercices</a>
              <a href="/profile" className="text-gray-700 hover:text-blue-600 transition-colors">Profil</a>
              <a href="/pricing" className="text-gray-700 hover:text-blue-600 transition-colors">Plans</a>
            </div>

            {/* Language Selector */}
            <div className="flex items-center gap-4">
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center gap-2 px-3 py-1 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors"
                >
                  <span className="text-xl">{languages.find(l => l.code === currentLanguage)?.flag}</span>
                  <span className="text-sm font-medium text-blue-700">
                    {languages.find(l => l.code === currentLanguage)?.nativeName}
                  </span>
                  <ChevronDown className="w-4 h-4 text-blue-700" />
                </button>

                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-2 w-80 bg-white rounded-xl shadow-lg border border-gray-200 z-50">
                    <div className="p-4 border-b border-gray-100">
                      <div className="relative">
                        <Search className="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                        <input
                          type="text"
                          placeholder="Rechercher une langue..."
                          value={searchTerm}
                          onChange={(e) => setSearchTerm(e.target.value)}
                          className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        />
                      </div>
                    </div>
                    
                    <div className="max-h-64 overflow-y-auto">
                      {filteredLanguages.map((lang) => (
                        <button
                          key={lang.code}
                          onClick={() => handleLanguageChange(lang.code)}
                          className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors ${
                            currentLanguage === lang.code ? 'bg-blue-50 text-blue-600' : ''
                          }`}
                        >
                          <span className="text-xl">{lang.flag}</span>
                          <div className="flex-1 text-left">
                            <div className="font-medium">{lang.nativeName}</div>
                            <div className="text-sm text-gray-500">{lang.name}</div>
                          </div>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>

      {/* Click overlay to close dropdown */}
      {showLanguageDropdown && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setShowLanguageDropdown(false)}
        />
      )}

      {/* Hero Section */}
      <section className="relative py-20 lg:py-32">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <div className="inline-flex items-center gap-2 bg-blue-100 text-blue-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <Star className="w-4 h-4" />
              ⭐ App éducative #1 en France ⭐
            </div>
            
            <h1 className="text-5xl md:text-7xl font-bold text-gray-900 mb-8 leading-tight">
              <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Apprends les maths en t'amusant !
              </span>
            </h1>
            
            <p className="text-xl text-gray-600 mb-4 max-w-4xl mx-auto">
              L'application éducative révolutionnaire
            </p>
            <p className="text-lg text-gray-600 mb-12 max-w-4xl mx-auto">
              Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
              <button 
                onClick={handleStartFree}
                className="bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white px-8 py-4 rounded-2xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
              >
                ▶ 🚀 Commencer gratuitement →
              </button>
              <button 
                onClick={handleViewPlans}
                className="border-2 border-gray-300 hover:border-gray-400 text-gray-700 px-8 py-4 rounded-2xl font-semibold text-lg transition-all duration-300 hover:bg-gray-50"
              >
                🔒 💎 Voir les plans
              </button>
            </div>

            <p className="text-gray-500">
              100k+ familles nous font confiance
            </p>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-20">
            <div className="text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Users className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">125,000+</div>
              <div className="text-gray-600">Familles actives</div>
            </div>
            
            <div className="text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-emerald-500 to-teal-600 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <BookOpen className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">50,000+</div>
              <div className="text-gray-600">Exercices résolus</div>
            </div>
            
            <div className="text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-amber-500 to-orange-600 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Globe className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">200+</div>
              <div className="text-gray-600">Langues supportées</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-6">Fonctionnalités principales</h2>
            <p className="text-xl text-gray-600">Découvre tout ce qui fait de Math4Child l'app n°1</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              { icon: Zap, title: "IA Adaptative", desc: "Questions personnalisées selon ton niveau et tes progrès", gradient: "from-blue-500 to-purple-600" },
              { icon: Globe, title: "200+ Langues", desc: "Support multilingue complet avec toutes les langues du monde", gradient: "from-emerald-500 to-teal-600" },
              { icon: TrendingUp, title: "5 Niveaux Progressifs", desc: "100 questions par niveau pour une progression méthodique", gradient: "from-amber-500 to-orange-600" },
              { icon: BookOpen, title: "Toutes les Opérations", desc: "Addition, soustraction, multiplication, division et mixte", gradient: "from-rose-500 to-pink-600" },
              { icon: Users, title: "Statistiques Détaillées", desc: "Suis tes progrès avec des graphiques et analyses avancées", gradient: "from-indigo-500 to-blue-600" },
              { icon: Smartphone, title: "Multi-plateforme", desc: "Web, Android et iOS avec synchronisation complète", gradient: "from-violet-500 to-purple-600" }
            ].map((feature, index) => (
              <div key={index} className="bg-gray-50 rounded-2xl p-8 hover:bg-gray-100 transition-colors cursor-pointer">
                <div className={`w-12 h-12 bg-gradient-to-r ${feature.gradient} rounded-xl flex items-center justify-center mb-6`}>
                  <feature.icon className="w-6 h-6 text-white" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">{feature.title}</h3>
                <p className="text-gray-600">{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing-section" className="py-20 bg-gradient-to-br from-gray-50 to-blue-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-6">Choisis ton plan Math4Child</h2>
            <p className="text-xl text-gray-600 mb-8">Débloque toutes les fonctionnalités pour progresser sans limites</p>
            
            {/* Billing Cycle Selector */}
            <div className="inline-flex bg-white rounded-2xl p-1 shadow-sm border mb-12">
              {[
                { key: 'monthly', label: 'Mensuel', badge: null },
                { key: 'quarterly', label: 'Trimestriel', badge: '-10%' },
                { key: 'yearly', label: 'Annuel', badge: '-30%' }
              ].map(cycle => (
                <button
                  key={cycle.key}
                  onClick={() => setBillingCycle(cycle.key as any)}
                  className={`px-6 py-3 rounded-xl font-medium text-sm transition-all relative ${
                    billingCycle === cycle.key
                      ? 'bg-blue-500 text-white shadow-sm'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  <Calendar className="w-4 h-4 inline mr-2" />
                  {cycle.label}
                  {cycle.badge && (
                    <span className={`absolute -top-2 -right-2 text-white text-xs px-2 py-1 rounded-full ${
                      cycle.key === 'quarterly' ? 'bg-green-500' : 'bg-red-500'
                    }`}>
                      {cycle.badge}
                    </span>
                  )}
                </button>
              ))}
            </div>
          </div>

          {/* Plans Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {plans.map((plan) => {
              const currentPrice = plan.price[billingCycle]
              const currentPeriod = plan.period[billingCycle]
              const originalPrice = plan.originalPrice?.[billingCycle]
              const discount = plan.discount?.[billingCycle]
              
              return (
                <div
                  key={plan.id}
                  className={`relative bg-white rounded-3xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 ${
                    plan.popular ? 'ring-2 ring-blue-500 scale-105' : ''
                  }`}
                >
                  {plan.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-10">
                      <span className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center gap-2">
                        🔥 Populaire
                      </span>
                    </div>
                  )}

                  <div className="p-8">
                    <div className="text-center mb-8">
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                      <p className="text-gray-600 mb-6">{plan.description}</p>
                      
                      <div className="mb-6">
                        <div className="text-4xl font-bold text-gray-900 mb-1">{currentPrice}</div>
                        <p className="text-gray-500">{currentPeriod}</p>
                        
                        {originalPrice && (
                          <div className="mt-2">
                            <p className="text-sm text-gray-400 line-through">{originalPrice}</p>
                            <p className="text-sm text-green-600 font-medium">Économisez {discount}</p>
                          </div>
                        )}
                      </div>

                      {plan.profiles > 1 && (
                        <div className="bg-blue-50 text-blue-700 px-3 py-1 rounded-full text-sm font-medium mb-6">
                          {plan.profiles} profils
                        </div>
                      )}
                    </div>

                    <ul className="space-y-3 mb-8">
                      {plan.features.map((feature, featureIndex) => (
                        <li key={featureIndex} className="flex items-start gap-3">
                          <Check className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                          <span className="text-gray-700 text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button 
                      onClick={() => handleChoosePlan(plan)}
                      className={`w-full py-4 rounded-2xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl ${plan.buttonClass}`}
                    >
                      {plan.buttonText}
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-r from-blue-600 to-purple-600">
        <div className="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold text-white mb-6">Bienvenue dans Math4Child !</h2>
          <p className="text-xl text-blue-100 mb-8">Commençons l'aventure mathématique !</p>
          <button 
            onClick={handleStartFree}
            className="bg-white text-blue-600 hover:bg-gray-50 px-8 py-4 rounded-2xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl inline-flex items-center gap-3"
          >
            ▶ 🚀 Commencer gratuitement <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                  <BookOpen className="w-6 h-6 text-white" />
                </div>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400">L'application éducative de référence pour apprendre les mathématiques en famille.</p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-6">Fonctionnalités</h3>
              <ul className="space-y-3 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Exercices interactifs</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Suivi des progrès</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Jeux éducatifs</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Mode multijoueurs</a></li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-6">Support</h3>
              <ul className="space-y-3 text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Centre d'aide</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Contact</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Guides parents</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Communauté</a></li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>© 2024 Math4Child. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
