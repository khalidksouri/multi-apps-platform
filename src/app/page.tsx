"use client"

import { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { StartFreeButton, ViewPlansButton } from '@/components/ui/InteractiveButtons'

export default function HomePage() {
  const { currentLanguage, isRTL, t } = useLanguage()
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="relative overflow-hidden">
        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="flex justify-between items-center">
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-xl">📚</span>
              </div>
              <span className="font-bold text-2xl text-gray-800">Math4Child</span>
            </div>
            
            {/* Navigation */}
            <nav className="hidden md:flex space-x-8">
              <a href="#" className="text-gray-600 hover:text-blue-600 transition-colors">Accueil</a>
              <a href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors">Exercices</a>
              <a href="/profile" className="text-gray-600 hover:text-blue-600 transition-colors">Profil</a>
              <a href="/pricing" className="text-gray-600 hover:text-blue-600 transition-colors">Plans</a>
            </nav>
            
            {/* Language Selector */}
            <LanguageSelector />
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative py-20">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <div className="mb-8">
            <span className="inline-block px-4 py-2 bg-blue-100 text-blue-600 rounded-full text-sm font-semibold mb-6">
              {t('appTitle') || '⭐ App éducative #1 en France ⭐'}
            </span>
          </div>
          
          <h1 className="text-4xl md:text-6xl font-bold text-gray-800 mb-6 animate-fadeIn">
            {t('heroTitle') || "Apprends les maths en t'amusant !"}
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-4 animate-fadeIn">
            {t('heroSubtitle') || "L'application éducative révolutionnaire"}
          </p>
          
          <p className="text-lg text-gray-600 mb-12 max-w-3xl mx-auto animate-fadeIn">
            {t('heroDescription') || "Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau"}
          </p>
          
          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16">
            <StartFreeButton />
            <ViewPlansButton />
          </div>
          
          <p className="text-gray-500">
            {t('trustedBy') || '100k+ familles nous font confiance'}
          </p>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <div className="text-center p-8 bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl">
              <div className="text-4xl mb-4">👥</div>
              <h3 className="text-2xl font-bold text-blue-600 mb-2">125,000+</h3>
              <p className="text-gray-600">Familles actives</p>
            </div>
            
            {/* Feature 2 */}
            <div className="text-center p-8 bg-gradient-to-br from-green-50 to-green-100 rounded-xl">
              <div className="text-4xl mb-4">📚</div>
              <h3 className="text-2xl font-bold text-green-600 mb-2">50,000+</h3>
              <p className="text-gray-600">Exercices résolus</p>
            </div>
            
            {/* Feature 3 */}
            <div className="text-center p-8 bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl">
              <div className="text-4xl mb-4">🌍</div>
              <h3 className="text-2xl font-bold text-orange-600 mb-2">200+</h3>
              <p className="text-gray-600">Langues supportées</p>
            </div>
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing-section" className="py-20 bg-gradient-to-br from-gray-50 to-gray-100">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-800 mb-4">
              💎 Nos Plans d'Abonnement
            </h2>
            <p className="text-xl text-gray-600">
              Choisissez le plan qui convient le mieux à votre famille
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Plan Gratuit */}
            <div className="bg-white p-8 rounded-xl shadow-lg">
              <h3 className="text-2xl font-bold text-gray-800 mb-4">Gratuit</h3>
              <div className="text-4xl font-bold text-gray-600 mb-4">0€</div>
              <p className="text-gray-600 mb-6">1 profil</p>
              <ul className="space-y-3 mb-8">
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>50 questions total</span>
                </li>
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>Niveaux 1-2 seulement</span>
                </li>
              </ul>
              <button className="w-full py-3 bg-gray-100 text-gray-800 rounded-lg font-semibold hover:bg-gray-200 transition-colors">
                Commencer gratuitement
              </button>
            </div>
            
            {/* Plan Premium */}
            <div data-plan="premium" className="bg-white p-8 rounded-xl shadow-lg ring-2 ring-blue-500">
              <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                  Le plus populaire
                </span>
              </div>
              <h3 className="text-2xl font-bold text-gray-800 mb-4">Premium</h3>
              <div className="text-4xl font-bold text-blue-600 mb-4">9.99€</div>
              <p className="text-gray-600 mb-6">3 profils</p>
              <ul className="space-y-3 mb-8">
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>3 profils enfants + 2 parents</span>
                </li>
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>Questions illimitées</span>
                </li>
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>Tous les 5 niveaux</span>
                </li>
              </ul>
              <button className="w-full py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition-colors">
                Choisir Premium
              </button>
            </div>
            
            {/* Plan Famille */}
            <div data-plan="family" className="bg-white p-8 rounded-xl shadow-lg">
              <h3 className="text-2xl font-bold text-gray-800 mb-4">Famille</h3>
              <div className="text-4xl font-bold text-purple-600 mb-4">14.99€</div>
              <p className="text-gray-600 mb-6">5 profils</p>
              <ul className="space-y-3 mb-8">
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>5 profils enfants + 2 parents</span>
                </li>
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>Questions illimitées</span>
                </li>
                <li className="flex items-center space-x-3">
                  <span className="text-green-500">✓</span>
                  <span>Rapports parents détaillés</span>
                </li>
              </ul>
              <button className="w-full py-3 bg-purple-100 text-purple-800 rounded-lg font-semibold hover:bg-purple-200 transition-colors">
                Choisir Famille
              </button>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}
