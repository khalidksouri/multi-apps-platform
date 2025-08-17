"use client"

import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageDropdown from '@/components/ui/LanguageDropdown'
import { Check, Star, Crown, Zap, BookOpen } from 'lucide-react'

export default function PricingPage() {
  const { t } = useLanguage()

  const plans = [
    {
      id: 'basic',
      name: 'BASIC',
      price: '4.99',
      badge: null,
      features: [
        '1 profil unique',
        '5 niveaux de progression',
        '100 réponses minimum par niveau',
        '5 opérations mathématiques',
        'Support communautaire'
      ]
    },
    {
      id: 'standard',
      name: 'STANDARD',
      price: '9.99',
      badge: null,
      features: [
        '2 profils utilisateur',
        'Toutes fonctionnalités BASIC',
        'IA Adaptative avancée',
        'Reconnaissance manuscrite',
        'Support prioritaire'
      ]
    },
    {
      id: 'premium',
      name: 'PREMIUM',
      price: '14.99',
      badge: 'LE PLUS CHOISI',
      popular: true,
      features: [
        '3 profils utilisateur',
        'Toutes fonctionnalités STANDARD',
        'Assistant vocal IA',
        'Réalité augmentée 3D',
        'Analytics avancées',
        'Personnalisation complète'
      ]
    },
    {
      id: 'famille',
      name: 'FAMILLE',
      price: '19.99',
      badge: null,
      features: [
        '5 profils utilisateur',
        'Toutes fonctionnalités PREMIUM',
        'Rapports familiaux',
        'Contrôle parental avancé',
        'Support VIP prioritaire'
      ]
    },
    {
      id: 'ultimate',
      name: 'ULTIMATE',
      price: 'Sur devis',
      badge: null,
      features: [
        '10+ profils (sans limite)',
        'API développeur',
        'Fonctionnalités école/institution',
        'Support dédié 24/7',
        'Formation équipes',
        'SLA personnalisé'
      ]
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <Link href="/" className="flex items-center space-x-2">
              <BookOpen className="w-8 h-8 text-blue-600" />
              <span className="text-xl font-bold text-gray-800">Math4Child</span>
              <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">v4.2.0</span>
            </Link>
            
            <nav className="hidden md:flex items-center space-x-6">
              <Link href="/" className="text-gray-600 hover:text-blue-600">Accueil</Link>
              <Link href="/dashboard" className="text-gray-600 hover:text-blue-600">Dashboard</Link>
              <Link href="/pricing" className="text-blue-600 font-medium">Plans</Link>
            </nav>

            <LanguageDropdown />
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-12">
        {/* En-tête de la page */}
        <div className="text-center mb-16">
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-4">
            Plans Math4Child v4.2.0
          </h1>
          <p className="text-xl text-gray-700 mb-8">
            Choisissez le plan parfait pour votre famille
          </p>
          
          <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-6 py-3 rounded-full inline-block">
            <span className="font-bold">🏆 45% des utilisateurs choisissent PREMIUM</span>
          </div>
        </div>

        {/* Grille des plans */}
        <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6 mb-12">
          {plans.map((plan) => (
            <div key={plan.id} className={`relative bg-white rounded-2xl shadow-lg p-6 ${
              plan.popular ? 'ring-2 ring-purple-500 transform scale-105' : ''
            }`}>
              {/* Badge */}
              {plan.badge && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                    {plan.badge}
                  </span>
                </div>
              )}

              {/* Icône du plan */}
              <div className="text-center mb-4">
                {plan.id === 'basic' && <Star className="w-8 h-8 text-blue-500 mx-auto" />}
                {plan.id === 'standard' && <Zap className="w-8 h-8 text-green-500 mx-auto" />}
                {plan.id === 'premium' && <Crown className="w-8 h-8 text-purple-500 mx-auto" />}
                {plan.id === 'famille' && <Star className="w-8 h-8 text-orange-500 mx-auto" />}
                {plan.id === 'ultimate' && <Crown className="w-8 h-8 text-red-500 mx-auto" />}
              </div>

              {/* Nom et prix */}
              <div className="text-center mb-6">
                <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                <div className="text-3xl font-bold text-gray-900">
                  {plan.price === 'Sur devis' ? (
                    <span className="text-lg">Sur devis</span>
                  ) : (
                    <>
                      €{plan.price}
                      <span className="text-sm text-gray-600 font-normal">/mois</span>
                    </>
                  )}
                </div>
              </div>

              {/* Fonctionnalités */}
              <ul className="space-y-3 mb-6">
                {plan.features.map((feature, index) => (
                  <li key={index} className="flex items-start space-x-2">
                    <Check className="w-4 h-4 text-green-500 mt-0.5 flex-shrink-0" />
                    <span className="text-sm text-gray-700">{feature}</span>
                  </li>
                ))}
              </ul>

              {/* Bouton d'action */}
              <button className={`w-full py-3 px-4 rounded-lg font-medium transition-all ${
                plan.popular 
                  ? 'bg-gradient-to-r from-purple-500 to-pink-500 text-white hover:from-purple-600 hover:to-pink-600' 
                  : 'bg-gray-100 text-gray-800 hover:bg-gray-200'
              }`}>
                {plan.price === 'Sur devis' ? 'Demander un devis' : 'Choisir ce plan'}
              </button>
            </div>
          ))}
        </div>

        {/* Informations supplémentaires */}
        <div className="text-center bg-white p-8 rounded-2xl shadow-lg">
          <h3 className="text-2xl font-bold text-gray-800 mb-4">
            🌍 Math4Child v4.2.0 - Révolution Éducative Mondiale
          </h3>
          <p className="text-gray-600 mb-6">
            6 innovations révolutionnaires • 200+ langues • 150,000+ familles nous font confiance
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-center">
            <div>
              <div className="text-3xl font-bold text-blue-600">98%</div>
              <div className="text-gray-600">Satisfaction client</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-600">45</div>
              <div className="text-gray-600">Pays supportés</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-purple-600">24/7</div>
              <div className="text-gray-600">Support disponible</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
