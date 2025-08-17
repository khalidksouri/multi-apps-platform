"use client"

import { useState } from 'react'
import { Check, ArrowLeft, Star, Zap, Users, GraduationCap, Calendar, BookOpen } from 'lucide-react'
import Link from 'next/link'

export default function PricingPage() {
  const [billingCycle, setBillingCycle] = useState<'monthly' | 'quarterly' | 'yearly'>('monthly')

  const plans = [
    {
      id: 'free',
      name: 'Gratuit',
      icon: Star,
      description: "Découverte du 1er niveau",
      profiles: 1,
      pricing: {
        monthly: { price: '0€', period: '/7 jours' },
        quarterly: { price: '0€', period: '/7 jours' },
        yearly: { price: '0€', period: '/7 jours' }
      },
      features: [
        "1er niveau uniquement (50 questions)",
        "7 jours d'accès gratuit",
        "Toutes les opérations de base",
        "1 profil enfant",
        "Support communautaire"
      ],
      buttonText: "Commencer gratuitement",
      buttonStyle: "bg-gray-600 hover:bg-gray-700 text-white"
    },
    {
      id: 'premium',
      name: 'Premium',
      icon: Zap,
      description: "Le plus choisi par les familles",
      profiles: 3,
      pricing: {
        monthly: { price: '9.99€', period: '/mois' },
        quarterly: { price: '26.97€', period: '/3 mois', originalPrice: '29.97€', discount: '10%' },
        yearly: { price: '83.93€', period: '/an', originalPrice: '119.88€', discount: '30%' }
      },
      features: [
        "✨ Tous les 5 niveaux débloqués",
        "🚀 Questions illimitées",
        "👥 3 profils enfants",
        "📊 Statistiques avancées",
        "🚫 Sans publicité",
        "💬 Support prioritaire"
      ],
      buttonText: "Choisir Premium",
      buttonStyle: "bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white",
      popular: billingCycle === 'monthly'
    },
    {
      id: 'family',
      name: 'Famille',
      icon: Users,
      description: "Parfait pour toute la famille",
      profiles: 5,
      pricing: {
        monthly: { price: '14.99€', period: '/mois' },
        quarterly: { price: '40.47€', period: '/3 mois', originalPrice: '44.97€', discount: '10%' },
        yearly: { price: '125.93€', period: '/an', originalPrice: '179.88€', discount: '30%' }
      },
      features: [
        "👨‍👩‍👧‍👦 Jusqu'à 5 profils enfants",
        "✨ Toutes les fonctionnalités Premium",
        "📈 Rapports familiaux détaillés",
        "🔒 Contrôle parental avancé",
        "🏆 Classements familiaux",
        "💎 Support VIP prioritaire"
      ],
      buttonText: "Choisir Famille",
      buttonStyle: "bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 text-white",
      popular: billingCycle === 'quarterly' || billingCycle === 'yearly'
    },
    {
      id: 'school',
      name: 'Écoles/Associations',
      icon: GraduationCap,
      description: "Pour établissements scolaires",
      profiles: 30,
      pricing: {
        monthly: { price: '49.99€', period: '/mois' },
        quarterly: { price: '134.97€', period: '/3 mois', originalPrice: '149.97€', discount: '10%' },
        yearly: { price: '419.93€', period: '/an', originalPrice: '599.88€', discount: '30%' }
      },
      features: [
        "🏫 Jusqu'à 30 profils élèves",
        "👩‍🏫 Dashboard enseignant complet",
        "📝 Assignation de devoirs",
        "📊 Rapports de classe détaillés",
        "🎓 Formation enseignants incluse",
        "🔧 Support technique dédié"
      ],
      buttonText: "Contacter l'équipe",
      buttonStyle: "bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white"
    }
  ]

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <nav className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
              <span className="text-xl font-bold text-gray-900">Math4Child</span>
            </div>
            
            <div className="hidden md:flex items-center gap-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 transition-colors">Accueil</Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 transition-colors">Exercices</Link>
              <Link href="/profile" className="text-gray-700 hover:text-blue-600 transition-colors">Profil</Link>
              <Link href="/pricing" className="text-blue-600 font-medium">Plans</Link>
            </div>
          </div>
        </div>
      </nav>

      <div className="pt-20 pb-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="text-center mb-16">
            <Link href="/" className="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6">
              <ArrowLeft className="w-4 h-4" />
              Retour à l'accueil
            </Link>
            
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Choisissez votre plan Math4Child
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
              Débloquez toutes les fonctionnalités pour progresser sans limites
            </p>
            
            {/* Billing Cycle Selector */}
            <div className="inline-flex bg-gray-100 rounded-xl p-1 mb-8">
              {[
                { key: 'monthly', label: 'Mensuel', badge: null },
                { key: 'quarterly', label: 'Trimestriel', badge: '-10%' },
                { key: 'yearly', label: 'Annuel', badge: '-30%' }
              ].map(cycle => (
                <button
                  key={cycle.key}
                  onClick={() => setBillingCycle(cycle.key as any)}
                  className={`px-6 py-3 rounded-lg font-medium text-sm transition-all relative ${
                    billingCycle === cycle.key
                      ? 'bg-white text-gray-900 shadow-sm'
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

          {/* Plans */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
            {plans.map((plan) => {
              const Icon = plan.icon
              const currentPricing = plan.pricing[billingCycle]
              
              return (
                <div
                  key={plan.id}
                  data-plan={plan.id}
                  className={`relative bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 ${
                    plan.popular ? 'ring-2 ring-blue-500 scale-105' : ''
                  }`}
                >
                  {plan.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-10">
                      <span className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-medium">
                        🔥 Populaire
                      </span>
                    </div>
                  )}

                  <div className="p-8">
                    <div className="text-center mb-8">
                      <div className="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <Icon className="w-8 h-8 text-gray-600" />
                      </div>
                      
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                      <p className="text-gray-600 mb-4">{plan.description}</p>
                      
                      <div className="mb-4">
                        <div className="text-4xl font-bold text-gray-900 mb-1">
                          {currentPricing.price}
                        </div>
                        <p className="text-gray-500">{currentPricing.period}</p>
                        
                        {currentPricing.originalPrice && (
                          <div className="mt-2">
                            <p className="text-sm text-gray-400 line-through">
                              {currentPricing.originalPrice}
                            </p>
                            <p className="text-sm text-green-600 font-medium">
                              Économisez {currentPricing.discount}
                            </p>
                          </div>
                        )}
                      </div>

                      <div className="bg-blue-50 text-blue-700 px-3 py-1 rounded-full text-sm font-medium mb-4">
                        {plan.profiles === 1 ? '1 profil' : `${plan.profiles} profils`}
                      </div>
                    </div>

                    <ul className="space-y-3 mb-8">
                      {plan.features.map((feature, featureIndex) => (
                        <li key={featureIndex} className="flex items-start gap-3">
                          <Check className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                          <span className="text-gray-700 text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button className={`w-full py-4 rounded-xl font-semibold text-lg transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl ${plan.buttonStyle}`}>
                      {plan.buttonText}
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      </div>
    </div>
  )
}
