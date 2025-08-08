"use client"

import { useState } from 'react'
import Navigation from '@/components/navigation/Navigation'
import ExerciseEngine from '@/components/exercises/ExerciseEngine'

export default function ExercisesPage() {
  const [selectedLevel, setSelectedLevel] = useState<number | null>(null)

  const levels = [
    { 
      id: 1, 
      name: 'Découverte', 
      description: 'Addition simple avec IA Adaptative', 
      color: 'green', 
      icon: '🌱'
    },
    { 
      id: 2, 
      name: 'Exploration', 
      description: 'Addition/Soustraction + IA + Manuscrite', 
      color: 'blue', 
      icon: '🚀'
    },
    { 
      id: 3, 
      name: 'Maîtrise', 
      description: 'Toutes opérations + IA + AR', 
      color: 'purple', 
      icon: '🧠'
    },
    { 
      id: 4, 
      name: 'Expert', 
      description: 'Toutes innovations + Compétitions', 
      color: 'red', 
      icon: '👑'
    },
    { 
      id: 5, 
      name: 'Champion', 
      description: 'Toutes innovations + Badges Mythiques', 
      color: 'yellow', 
      icon: '🏆'
    }
  ]

  if (selectedLevel) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
        <Navigation />
        <div className="container mx-auto px-4 py-8">
          <div className="flex justify-between items-center mb-8">
            <h1 className="text-3xl font-bold text-gray-800">
              🧮 Exercices Révolutionnaires - Niveau {selectedLevel}
            </h1>
            <button
              onClick={() => setSelectedLevel(null)}
              className="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors"
            >
              ← Retour aux niveaux
            </button>
          </div>
          
          <ExerciseEngine 
            level={selectedLevel} 
            onComplete={(result) => {
              console.log('Exercice terminé:', result)
            }}
          />
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <Navigation />
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            🧮 Exercices Révolutionnaires
          </h1>
          <p className="text-xl text-gray-600">
            Choisissez votre niveau et découvrez nos innovations
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-4xl mx-auto">
          {levels.map((level) => (
            <button
              key={level.id}
              onClick={() => setSelectedLevel(level.id)}
              className={`p-6 rounded-xl border-2 transition-all duration-300 transform hover:scale-105 hover:shadow-lg bg-white ${
                level.color === 'green' ? 'border-green-200 hover:border-green-400' :
                level.color === 'blue' ? 'border-blue-200 hover:border-blue-400' :
                level.color === 'purple' ? 'border-purple-200 hover:border-purple-400' :
                level.color === 'red' ? 'border-red-200 hover:border-red-400' :
                'border-yellow-200 hover:border-yellow-400'
              }`}
            >
              <div className="text-4xl mb-4">{level.icon}</div>
              <h3 className="text-xl font-bold text-gray-800 mb-2">
                {level.name}
              </h3>
              <p className="text-sm text-gray-600 mb-4">
                {level.description}
              </p>
              <div className={`inline-block px-3 py-1 rounded-full text-sm font-medium ${
                level.color === 'green' ? 'bg-green-100 text-green-800' :
                level.color === 'blue' ? 'bg-blue-100 text-blue-800' :
                level.color === 'purple' ? 'bg-purple-100 text-purple-800' :
                level.color === 'red' ? 'bg-red-100 text-red-800' :
                'bg-yellow-100 text-yellow-800'
              }`}>
                Niveau {level.id}
              </div>
            </button>
          ))}
        </div>

        {/* Section fonctionnalités */}
        <div className="text-center mt-12">
          <div className="bg-white p-8 rounded-xl shadow-lg border border-gray-200 max-w-4xl mx-auto">
            <h3 className="text-2xl font-bold text-gray-800 mb-6">
              🧠 Fonctionnalités IA Adaptative Révolutionnaires
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="text-center">
                <div className="text-3xl mb-3">📊</div>
                <div className="font-semibold text-gray-700">Analyse en Temps Réel</div>
                <div className="text-sm text-gray-600">Style d'apprentissage et état cognitif</div>
              </div>
              <div className="text-center">
                <div className="text-3xl mb-3">🎯</div>
                <div className="font-semibold text-gray-700">Adaptation Automatique</div>
                <div className="text-sm text-gray-600">Difficulté et modalités personnalisées</div>
              </div>
              <div className="text-center">
                <div className="text-3xl mb-3">💡</div>
                <div className="font-semibold text-gray-700">Recommandations IA</div>
                <div className="text-sm text-gray-600">Exercices générés pour vous</div>
              </div>
            </div>
            
            <div className="mt-6 bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg p-4">
              <p className="text-sm text-gray-700">
                <strong>🌟 PREMIÈRE MONDIALE :</strong> Notre IA analyse votre style d'apprentissage 
                et adapte automatiquement chaque exercice à votre profil unique !
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
