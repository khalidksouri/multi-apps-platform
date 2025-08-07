"use client"

import { useState, useEffect } from "react"
import { 
  Calculator, 
  Play, 
  Trophy, 
  Globe, 
  Users, 
  TrendingUp, 
  Award,
  Zap,
  BookOpen,
  BarChart3,
  Smartphone,
  Star,
  ArrowRight,
  Check
} from "lucide-react"
import Link from "next/link"
import { useLanguage } from "@/hooks/useLanguage"
import Navigation from "@/components/navigation/Navigation"

export default function HomePage() {
  const { t, isRTL } = useLanguage()
  const [stats, setStats] = useState({
    users: 0,
    exercises: 0,
    languages: 0
  })

  // Animation des statistiques
  useEffect(() => {
    const animateStats = () => {
      const duration = 2000
      const steps = 50
      const stepDuration = duration / steps

      let step = 0
      const timer = setInterval(() => {
        step++
        const progress = step / steps

        setStats({
          users: Math.floor(125000 * progress),
          exercises: Math.floor(50000 * progress),
          languages: Math.floor(200 * progress)
        })

        if (step >= steps) {
          clearInterval(timer)
          setStats({
            users: 125000,
            exercises: 50000,
            languages: 200
          })
        }
      }, stepDuration)

      return () => clearInterval(timer)
    }

    const timeout = setTimeout(animateStats, 500)
    return () => clearTimeout(timeout)
  }, [])

  const features = [
    {
      icon: Zap,
      title: t('features.adaptiveAI'),
      description: t('features.adaptiveDesc'),
      gradient: 'from-blue-500 to-purple-600'
    },
    {
      icon: Globe,
      title: t('features.worldLanguages'),
      description: t('features.worldDesc'),
      gradient: 'from-green-500 to-blue-500'
    },
    {
      icon: BookOpen,
      title: t('features.progressiveLevels'),
      description: t('features.levelsDesc'),
      gradient: 'from-orange-500 to-red-500'
    },
    {
      icon: Calculator,
      title: t('features.allOperations'),
      description: t('features.operationsDesc'),
      gradient: 'from-purple-500 to-pink-500'
    },
    {
      icon: BarChart3,
      title: t('features.detailedStats'),
      description: t('features.statsDesc'),
      gradient: 'from-cyan-500 to-blue-500'
    },
    {
      icon: Smartphone,
      title: t('features.multiPlatform'),
      description: t('features.platformDesc'),
      gradient: 'from-emerald-500 to-teal-500'
    }
  ]

  const pricingPlans = [
    {
      name: t('pricing.free'),
      price: t('pricing.freePrice'),
      period: t('pricing.perMonth'),
      popular: false,
      features: [
        "Accès aux 2 premiers niveaux",
        "50 questions par jour",
        "Statistiques de base",
        "Publicités"
      ],
      buttonText: t('pricing.choosePlan'),
      buttonStyle: "bg-gray-100 text-gray-700 hover:bg-gray-200"
    },
    {
      name: t('pricing.premium'),
      price: t('pricing.premiumPrice'),
      period: t('pricing.perMonth'),
      popular: true,
      features: [
        "✨ Tous les niveaux débloqués",
        "🚀 Questions illimitées",
        "📊 Statistiques avancées",
        "🚫 Sans publicité",
        "💬 Support prioritaire"
      ],
      buttonText: t('pricing.choosePlan'),
      buttonStyle: "bg-gradient-to-r from-blue-500 to-purple-600 text-white hover:from-blue-600 hover:to-purple-700"
    },
    {
      name: t('pricing.family'),
      price: t('pricing.familyPrice'),
      period: t('pricing.perMonth'),
      popular: false,
      features: [
        "👨‍👩‍👧‍👦 Jusqu'à 6 comptes enfants",
        "✨ Toutes les fonctionnalités Premium",
        "📈 Rapports familiaux détaillés",
        "🔒 Contrôle parental avancé",
        "📱 Synchronisation multi-appareils"
      ],
      buttonText: t('pricing.choosePlan'),
      buttonStyle: "bg-gradient-to-r from-emerald-500 to-teal-600 text-white hover:from-emerald-600 hover:to-teal-700"
    }
  ]

  return (
    <div className={`min-h-screen ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      {/* Hero Section */}
      <section className="relative pt-20 pb-16 bg-gradient-to-br from-blue-50 via-white to-purple-50 overflow-hidden">
        {/* Background decorations */}
        <div className="absolute inset-0 opacity-40">
          <div className="absolute top-20 left-10 w-72 h-72 bg-blue-200 rounded-full mix-blend-multiply filter blur-xl animate-pulse"></div>
          <div className="absolute top-40 right-10 w-72 h-72 bg-purple-200 rounded-full mix-blend-multiply filter blur-xl animate-pulse delay-1000"></div>
          <div className="absolute bottom-20 left-1/2 w-72 h-72 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl animate-pulse delay-500"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            {/* Badge */}
            <div className="inline-flex items-center gap-2 bg-gradient-to-r from-blue-500 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-medium mb-8 animate-fadeInUp">
              <Trophy className="w-4 h-4" />
              <span>App éducative #1 en France</span>
              <Star className="w-4 h-4 text-yellow-300" />
            </div>

            {/* Titre principal */}
            <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold mb-6 animate-fadeInUp">
              <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                {t('hero.title')}
              </span>
            </h1>

            {/* Sous-titre */}
            <p className="text-xl md:text-2xl text-gray-600 mb-4 max-w-3xl mx-auto animate-fadeInUp">
              {t('hero.subtitle')}
            </p>

            <p className="text-lg text-gray-500 mb-8 max-w-2xl mx-auto animate-fadeInUp">
              {t('hero.description')}
            </p>

            {/* Boutons CTA */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12 animate-fadeInUp">
              <Link
                href="/exercises"
                className="group bg-gradient-to-r from-blue-500 to-purple-600 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:from-blue-600 hover:to-purple-700 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1 flex items-center gap-2"
              >
                <Play className="w-5 h-5" />
                {t('hero.startFree')}
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Link>

              <Link
                href="/pricing"
                className="group bg-white text-gray-700 border-2 border-gray-200 px-8 py-4 rounded-xl font-semibold text-lg hover:bg-gray-50 hover:border-gray-300 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1 flex items-center gap-2"
              >
                <Award className="w-5 h-5" />
                {t('hero.viewPlans')}
              </Link>
            </div>

            {/* Trust indicator */}
            <p className="text-sm text-gray-500 animate-fadeInUp">
              {t('hero.familyTrust')}
            </p>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="bg-gradient-to-br from-blue-500 to-purple-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Users className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">
                {stats.users.toLocaleString()}+
              </div>
              <p className="text-gray-600">Familles actives</p>
            </div>

            <div className="text-center">
              <div className="bg-gradient-to-br from-emerald-500 to-teal-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <BookOpen className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">
                {stats.exercises.toLocaleString()}+
              </div>
              <p className="text-gray-600">Exercices résolus</p>
            </div>

            <div className="text-center">
              <div className="bg-gradient-to-br from-orange-500 to-red-500 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Globe className="w-8 h-8 text-white" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">
                {stats.languages}+
              </div>
              <p className="text-gray-600">Langues supportées</p>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-gradient-to-br from-gray-50 to-blue-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              {t('features.title')}
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              {t('features.subtitle')}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => {
              const Icon = feature.icon
              return (
                <div
                  key={index}
                  className="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2"
                >
                  <div className={`w-14 h-14 bg-gradient-to-br ${feature.gradient} rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300`}>
                    <Icon className="w-7 h-7 text-white" />
                  </div>
                  <h3 className="text-xl font-semibold text-gray-900 mb-3">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 leading-relaxed">
                    {feature.description}
                  </p>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              {t('pricing.title')}
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              {t('pricing.subtitle')}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {pricingPlans.map((plan, index) => (
              <div
                key={index}
                className={`relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 ${
                  plan.popular ? 'ring-2 ring-blue-500 scale-105' : ''
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-medium">
                      🔥 {t('pricing.popular')}
                    </span>
                  </div>
                )}

                <div className="text-center mb-8">
                  <h3 className="text-2xl font-semibold text-gray-900 mb-4">
                    {plan.name}
                  </h3>
                  <div className="text-5xl font-bold text-gray-900 mb-2">
                    {plan.price}
                  </div>
                  <p className="text-gray-500">{plan.period}</p>
                </div>

                <ul className="space-y-4 mb-8">
                  {plan.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-start gap-3">
                      <Check className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button className={`w-full py-4 rounded-xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 ${plan.buttonStyle}`}>
                  {plan.buttonText}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-br from-blue-600 to-purple-700">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
            {t('messages.welcome')}
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            {t('messages.letsStart')}
          </p>
          <Link
            href="/exercises"
            className="inline-flex items-center gap-3 bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg hover:bg-blue-50 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
          >
            <Play className="w-5 h-5" />
            {t('hero.startFree')}
            <ArrowRight className="w-4 h-4" />
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            {/* Logo et description */}
            <div className="col-span-1 md:col-span-2">
              <div className="flex items-center gap-2 mb-4">
                <Calculator className="w-8 h-8 text-blue-400" />
                <span className="text-2xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400 mb-6 max-w-md">
                {t('footer.description')}
              </p>
            </div>

            {/* Fonctionnalités */}
            <div>
              <h4 className="text-lg font-semibold mb-4">{t('footer.features')}</h4>
              <ul className="space-y-2 text-gray-400">
                <li>{t('footer.interactiveExercises')}</li>
                <li>{t('footer.progressTracking')}</li>
                <li>{t('footer.educationalGames')}</li>
                <li>{t('footer.multiPlayer')}</li>
              </ul>
            </div>

            {/* Support */}
            <div>
              <h4 className="text-lg font-semibold mb-4">{t('footer.support')}</h4>
              <ul className="space-y-2 text-gray-400">
                <li>{t('footer.helpCenter')}</li>
                <li>{t('footer.contact')}</li>
                <li>{t('footer.parentGuides')}</li>
                <li>{t('footer.community')}</li>
              </ul>
            </div>
          </div>

          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>{t('footer.copyright')}</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
