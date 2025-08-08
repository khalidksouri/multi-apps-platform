"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'

export default function HomePage() {
  const { currentLanguage, isRTL, t } = useLanguage()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Chargement...</p>
        </div>
      </div>
    )
  }
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header simple intégré */}
      <header className="relative overflow-hidden">
        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="flex justify-between items-center">
            {/* Logo */}
            <Link href="/" className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-xl">🧮</span>
              </div>
              <span className="font-bold text-2xl text-gray-800">Math4Child</span>
            </Link>
            
            {/* Navigation simple */}
            <nav className="hidden md:flex space-x-8">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition-colors font-medium">
                Accueil
              </Link>
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors font-medium">
                Exercices
              </Link>
              <Link href="/profile" className="text-gray-600 hover:text-blue-600 transition-colors font-medium">
                Profil
              </Link>
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600 transition-colors font-medium">
                Plans
              </Link>
            </nav>
            
            {/* Language Selector */}
            <div className="flex items-center">
              <LanguageSelector />
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative py-20">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <div className="mb-8">
            <span className="inline-block px-4 py-2 bg-blue-100 text-blue-600 rounded-full text-sm font-semibold mb-6">
              ⭐ App éducative #1 en France ⭐
            </span>
          </div>
          
          <h1 className="text-4xl md:text-6xl font-bold text-gray-800 mb-6">
            Apprends les maths en t'amusant !
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto">
            L'application éducative révolutionnaire avec des exercices progressifs et amusants 
            adaptés à ton niveau. Interface premium avec 200+ langues, IA adaptive et système de 
            progression rigoureux.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-8">
            <Link 
              href="/exercises"
              className="inline-flex items-center gap-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-2xl font-bold text-lg hover:shadow-lg hover:scale-105 transition-all duration-300"
            >
              🚀 Commencer gratuitement
            </Link>
            
            <Link 
              href="/pricing"
              className="inline-flex items-center gap-2 bg-white text-gray-700 px-8 py-4 rounded-2xl font-bold text-lg border-2 border-gray-200 hover:border-blue-300 hover:shadow-lg transition-all duration-300"
            >
              💎 Voir les plans
            </Link>
          </div>

          <p className="text-gray-500 mt-8">
            100k+ familles nous font confiance
          </p>
        </div>
      </section>

      {/* Navigation mobile */}
      <div className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-2">
        <div className="flex justify-around">
          <Link href="/" className="flex flex-col items-center gap-1 text-blue-600">
            <span className="text-lg">🏠</span>
            <span className="text-xs">Accueil</span>
          </Link>
          <Link href="/exercises" className="flex flex-col items-center gap-1 text-gray-600">
            <span className="text-lg">📚</span>
            <span className="text-xs">Exercices</span>
          </Link>
          <Link href="/profile" className="flex flex-col items-center gap-1 text-gray-600">
            <span className="text-lg">👤</span>
            <span className="text-xs">Profil</span>
          </Link>
          <Link href="/pricing" className="flex flex-col items-center gap-1 text-gray-600">
            <span className="text-lg">💎</span>
            <span className="text-xs">Plans</span>
          </Link>
        </div>
      </div>

      {/* Stats Section */}
      <section className="py-20 bg-white/50">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-white rounded-2xl p-8 text-center shadow-lg">
              <div className="text-4xl mb-4">👨‍👩‍👧‍👦</div>
              <div className="text-3xl font-bold text-blue-600 mb-2">125,000+</div>
              <div className="text-gray-600">Familles actives</div>
            </div>
            
            <div className="bg-white rounded-2xl p-8 text-center shadow-lg">
              <div className="text-4xl mb-4">📚</div>
              <div className="text-3xl font-bold text-green-600 mb-2">50,000+</div>
              <div className="text-gray-600">Exercices résolus</div>
            </div>
            
            <div className="bg-white rounded-2xl p-8 text-center shadow-lg">
              <div className="text-4xl mb-4">🌍</div>
              <div className="text-3xl font-bold text-purple-600 mb-2">200+</div>
              <div className="text-gray-600">Langues supportées</div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <div className="flex items-center justify-center space-x-3 mb-6">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
              <span className="text-white font-bold text-lg">🧮</span>
            </div>
            <span className="font-bold text-xl">Math4Child</span>
          </div>
          <p className="text-gray-400 mb-4">
            L'application éducative révolutionnaire pour apprendre les mathématiques en s'amusant.
          </p>
          <p className="text-sm text-gray-500">
            © 2024 GOTEST. Tous droits réservés.
          </p>
        </div>
      </footer>
    </div>
  );
}
