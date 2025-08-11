"use client"

import Link from 'next/link'
import Navigation from '@/components/navigation/Navigation'

export default function HomePage() {
  const innovations = [
    {
      icon: '🧠',
      title: 'IA Adaptative',
      description: 'PREMIÈRE MONDIALE - IA qui s\'adapte à votre style d\'apprentissage',
      tag: 'PREMIÈRE MONDIALE'
    },
    {
      icon: '✍️',
      title: 'Reconnaissance Manuscrite',
      description: 'RÉVOLUTIONNAIRE - Écrivez vos réponses à la main',
      tag: 'RÉVOLUTIONNAIRE'
    },
    {
      icon: '🥽',
      title: 'Réalité Augmentée 3D',
      description: 'PREMIÈRE MONDIALE - Visualisez les maths en 3D immersif',
      tag: '3D IMMERSIVE'
    },
    {
      icon: '🎙️',
      title: 'Assistant Vocal IA',
      description: 'INNOVATION MAJEURE - Tuteur vocal avec 3 personnalités',
      tag: 'IA ÉMOTIONNELLE'
    },
    {
      icon: '🌍',
      title: 'Compétitions Mondiales',
      description: 'SYSTÈME LE PLUS AVANCÉ - Millions de joueurs temps réel',
      tag: 'TEMPS RÉEL'
    },
    {
      icon: '🏆',
      title: 'Système de Badges',
      description: 'LE PLUS COMPLET - 50+ badges, 5 raretés, 6 catégories',
      tag: 'ULTRA-GAMIFIÉ'
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <Navigation />
      
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-16">
          <h1 className="text-6xl md:text-8xl font-bold mb-6">
            <span className="text-blue-600">Math4Child</span>
            <span className="block text-purple-600 text-4xl md:text-5xl">v4.2.0</span>
          </h1>
          <p className="text-2xl md:text-3xl text-gray-700 mb-4 font-medium">
            🚀 Révolution Éducative Mondiale
          </p>
          <p className="text-lg text-gray-600 mb-8 max-w-3xl mx-auto">
            <strong>6 innovations révolutionnaires</strong> jamais vues dans l'éducation mathématique mondiale. 
            Première IA adaptative, réalité augmentée 3D, reconnaissance manuscrite, assistant vocal émotionnel.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-8">
            <Link 
              href="/exercises"
              className="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-8 py-4 rounded-xl font-bold text-xl hover:shadow-lg transition-all transform hover:scale-105 inline-flex items-center gap-2"
            >
              🚀 Découvrir les Innovations
            </Link>
            <Link 
              href="/pricing"
              className="bg-white text-gray-700 px-8 py-4 rounded-xl font-bold text-xl border-2 border-gray-200 hover:border-gray-300 transition-all"
            >
              💎 Voir les Plans
            </Link>
          </div>

          {/* Statistiques selon README.md */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto mb-12">
            <div className="bg-white rounded-lg p-4 shadow-md">
              <div className="text-2xl font-bold text-blue-600">200+</div>
              <div className="text-sm text-gray-600">Langues Universelles</div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-md">
              <div className="text-2xl font-bold text-green-600">6</div>
              <div className="text-sm text-gray-600">Innovations Premières Mondiales</div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-md">
              <div className="text-2xl font-bold text-purple-600">50+</div>
              <div className="text-sm text-gray-600">Badges Ultra-Gamifiés</div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-md">
              <div className="text-2xl font-bold text-orange-600">5</div>
              <div className="text-sm text-gray-600">Niveaux Progressifs</div>
            </div>
          </div>
        </div>

        {/* Grille des innovations selon README.md */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
          {innovations.map((innovation, index) => (
            <div 
              key={index}
              className="bg-white rounded-xl p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-all duration-300 transform hover:scale-105"
            >
              <div className="text-center">
                <div className="text-4xl mb-3">{innovation.icon}</div>
                <div className="inline-block bg-blue-100 text-blue-600 px-3 py-1 rounded-full text-xs font-bold mb-3">
                  {innovation.tag}
                </div>
                <h3 className="text-lg font-bold text-gray-800 mb-2">
                  {innovation.title}
                </h3>
                <p className="text-sm text-gray-600">
                  {innovation.description}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Section avantages concurrentiels README.md */}
        <div className="bg-white rounded-2xl p-8 shadow-lg mb-16">
          <h2 className="text-3xl font-bold text-center text-gray-800 mb-8">
            🥇 Domination Concurrentielle Totale
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-5xl mb-3">🆚</div>
              <h3 className="font-bold text-gray-800 mb-2">VS Khan Academy Kids</h3>
              <p className="text-gray-600 text-sm">❌ Pas d'IA adaptative<br/>✅ Math4Child: IA révolutionnaire</p>
            </div>
            <div className="text-center">
              <div className="text-5xl mb-3">🆚</div>
              <h3 className="font-bold text-gray-800 mb-2">VS Photomath</h3>
              <p className="text-gray-600 text-sm">❌ Pas de gamification<br/>✅ Math4Child: 50+ badges</p>
            </div>
            <div className="text-center">
              <div className="text-5xl mb-3">🆚</div>
              <h3 className="font-bold text-gray-800 mb-2">VS Prodigy Math</h3>
              <p className="text-gray-600 text-sm">❌ 20 langues<br/>✅ Math4Child: 200+ langues</p>
            </div>
          </div>
        </div>

        {/* Call-to-action final */}
        <div className="text-center">
          <div className="bg-gradient-to-r from-purple-100 to-blue-100 rounded-2xl p-8 border border-purple-200">
            <h2 className="text-3xl font-bold text-gray-800 mb-4">
              🌟 Objectif 2025 - 10 Millions d'Enfants Impactés
            </h2>
            <p className="text-lg text-gray-600 mb-6">
              Rejoignez la révolution éducative qui transforme l'apprentissage des mathématiques dans le monde entier
            </p>
            <Link 
              href="/exercises"
              className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-10 py-4 rounded-xl font-bold text-xl hover:shadow-lg transition-all transform hover:scale-105 inline-flex items-center gap-2"
            >
              ✨ Commencer la Révolution
            </Link>
          </div>
        </div>
      </div>

      {/* Footer avec informations société README.md */}
      <footer className="bg-gray-800 text-white py-8">
        <div className="container mx-auto px-4 text-center">
          <div className="mb-4">
            <h3 className="text-xl font-bold">Math4Child v4.2.0</h3>
            <p className="text-gray-300">Révolution Éducative Mondiale</p>
          </div>
          <div className="text-sm text-gray-400">
            <p>© 2025 GOTEST - www.math4child.com</p>
            <p>SIRET: 53958712100028 | Email: gotesttech@gmail.com</p>
            <p><strong>6 innovations révolutionnaires</strong> pour transformer l'éducation mathématique mondiale</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
