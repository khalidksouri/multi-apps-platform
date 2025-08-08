"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'

export default function HomePage() {
  const { t } = useLanguage()
  const [mounted, setMounted] = useState(false)
  const [currentFeature, setCurrentFeature] = useState(0)

  useEffect(() => {
    setMounted(true)
    
    const interval = setInterval(() => {
      setCurrentFeature(prev => (prev + 1) % 6)
    }, 3000)
    
    return () => clearInterval(interval)
  }, [])

  if (!mounted) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  const features = [
    {
      icon: '🧠',
      title: 'IA Adaptative',
      description: 'Première mondiale - IA qui adapte aux enfants'
    },
    {
      icon: '✍️',
      title: 'Écriture Manuscrite',
      description: 'Reconnaissance IA révolutionnaire'
    },
    {
      icon: '🥽',
      title: 'Réalité Augmentée',
      description: 'Mathématiques en 3D immersives'
    },
    {
      icon: '🎙️',
      title: 'Assistant Vocal',
      description: 'Tuteur IA personnel'
    },
    {
      icon: '🌍',
      title: 'Compétitions Mondiales',
      description: 'Temps réel avec millions de joueurs'
    },
    {
      icon: '🏆',
      title: 'Badges Gamifiés',
      description: 'Système RPG complet'
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <header className="bg-white/80 backdrop-blur-sm shadow-sm border-b sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white font-bold text-lg">🧮</span>
              </div>
              <div>
                <span className="font-bold text-xl text-gray-800">Math4Child</span>
                <div className="text-xs text-purple-600 font-medium">v4.2.0 ✨ Révolutionnaire</div>
              </div>
            </div>
            
            <nav className="hidden md:flex space-x-8">
              <Link href="/" className="text-blue-600 font-medium">Accueil</Link>
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors">Exercices</Link>
              <Link href="/profile" className="text-gray-600 hover:text-blue-600 transition-colors">Profil</Link>
            </nav>
            
            <LanguageSelector />
          </div>
        </div>
      </header>

      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <div className="inline-flex items-center gap-2 bg-purple-100 text-purple-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
                <span className="animate-pulse">🚀</span>
                Révolution Éducative Mondiale
              </div>
              
              <h1 className="text-5xl lg:text-6xl font-bold text-gray-800 mb-6 leading-tight">
                Math4Child
                <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
                  v4.2.0
                </span>
                <span className="block text-transparent bg-clip-text bg-gradient-to-r from-purple-600 to-pink-600">
                  L'Avenir Commence !
                </span>
              </h1>
              
              <p className="text-xl text-gray-600 mb-8 leading-relaxed">
                <strong>6 innovations révolutionnaires</strong> qui transforment l'apprentissage 
                des mathématiques : <strong>IA Adaptative, Réalité Augmentée, Assistant Vocal IA, 
                Reconnaissance Manuscrite, Compétitions Mondiales</strong> et plus encore !
              </p>
              
              <div className="flex flex-col sm:flex-row gap-4 mb-8">
                <Link 
                  href="/exercises"
                  className="bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 flex items-center justify-center gap-2"
                >
                  <span>🚀</span>
                  Découvrir les Innovations
                </Link>
              </div>
              
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
                <div className="flex items-center gap-2 text-green-600">
                  <span>✓</span>
                  <strong>IA Première Mondiale</strong>
                </div>
                <div className="flex items-center gap-2 text-blue-600">
                  <span>✓</span>
                  <strong>Réalité Augmentée 3D</strong>
                </div>
                <div className="flex items-center gap-2 text-purple-600">
                  <span>✓</span>
                  <strong>Assistant Vocal IA</strong>
                </div>
                <div className="flex items-center gap-2 text-orange-600">
                  <span>✓</span>
                  <strong>Reconnaissance Manuscrite</strong>
                </div>
                <div className="flex items-center gap-2 text-pink-600">
                  <span>✓</span>
                  <strong>Compétitions Mondiales</strong>
                </div>
                <div className="flex items-center gap-2 text-indigo-600">
                  <span>✓</span>
                  <strong>200+ Langues</strong>
                </div>
              </div>
            </div>
            
            <div className="relative">
              <div className="bg-gradient-to-br from-white to-gray-50 rounded-3xl shadow-2xl p-8 transform hover:scale-105 transition-transform duration-500">
                <div className="text-center mb-6">
                  <div className="text-6xl mb-4">{features[currentFeature].icon}</div>
                  <div className="text-2xl font-bold text-gray-800 mb-2">
                    {features[currentFeature].title}
                  </div>
                  <div className="text-gray-600">
                    {features[currentFeature].description}
                  </div>
                </div>
                
                <div className="bg-gradient-to-br from-blue-50 to-purple-50 rounded-2xl p-6 mb-6">
                  <div className="grid grid-cols-3 gap-4 text-center">
                    <div>
                      <div className="text-2xl font-bold text-blue-600">200+</div>
                      <div className="text-xs text-gray-600">Langues</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold text-green-600">6</div>
                      <div className="text-xs text-gray-600">Innovations</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold text-purple-600">1ère</div>
                      <div className="text-xs text-gray-600">Mondiale</div>
                    </div>
                  </div>
                </div>
                
                <div className="flex justify-center gap-2">
                  {features.map((_, index) => (
                    <div
                      key={index}
                      className={`w-2 h-2 rounded-full transition-colors duration-300 ${
                        index === currentFeature ? 'bg-purple-500' : 'bg-gray-300'
                      }`}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-800 mb-4">
              🚀 6 Innovations Révolutionnaires
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Chaque fonctionnalité est une <strong>première mondiale</strong> dans l'éducation mathématique
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <div 
                key={index}
                className="bg-gradient-to-br from-gray-50 to-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 group"
              >
                <div className="text-5xl mb-4 group-hover:animate-bounce">{feature.icon}</div>
                <h3 className="text-xl font-bold text-gray-800 mb-3">{feature.title}</h3>
                <p className="text-gray-600 leading-relaxed mb-4">{feature.description}</p>
                <div className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-3 py-1 rounded-full text-xs font-bold">
                  RÉVOLUTIONNAIRE
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="py-20 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-4xl font-bold text-white mb-6">
            🌟 Rejoignez la Révolution Éducative !
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            Soyez parmi les premiers à découvrir l'avenir de l'éducation mathématique
          </p>
          <Link 
            href="/exercises"
            className="inline-flex items-center gap-3 bg-white text-purple-600 px-8 py-4 rounded-xl font-bold text-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105"
          >
            <span className="text-2xl">🚀</span>
            Découvrir les Innovations
          </Link>
        </div>
      </section>
    </div>
  )
}
