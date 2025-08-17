"use client"

import React, { useState, useEffect } from 'react'
import Link from 'next/link'

interface UserProfile {
  name: string
  level: number
  totalPoints: number
  streak: number
  accuracy: number
  badges: string[]
}

export default function ExercisesHub() {
  const [profile, setProfile] = useState<UserProfile>({
    name: 'Emma',
    level: 3,
    totalPoints: 2847,
    streak: 7,
    accuracy: 89,
    badges: ['🌟', '🔥', '🎯', '🏆']
  })

  const gameModes = [
    {
      id: 'classic',
      name: 'Mode Classique',
      description: 'Exercices traditionnels avec interface moderne',
      icon: '📚',
      color: 'from-blue-500 to-blue-600',
      path: '/exercises/1'
    },
    {
      id: 'handwriting',
      name: 'Reconnaissance Manuscrite',
      description: 'Écris tes réponses à la main !',
      icon: '✏️',
      color: 'from-green-500 to-green-600',
      path: '/exercises/1/handwriting'
    },
    {
      id: 'ar3d',
      name: 'Réalité Augmentée 3D',
      description: 'Visualise les maths en 3D !',
      icon: '🥽',
      color: 'from-purple-500 to-purple-600',
      path: '/exercises/1/ar3d'
    }
  ]

  const levels = [1, 2, 3, 4, 5]

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 p-4">
      <div className="max-w-6xl mx-auto">
        
        {/* Header avec profil Emma */}
        <div className="bg-white rounded-2xl shadow-lg p-6 mb-8">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="w-16 h-16 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                {profile.name[0]}
              </div>
              <div>
                <h1 className="text-2xl font-bold text-gray-800">Salut {profile.name} ! 👋</h1>
                <p className="text-gray-600">Prête pour une nouvelle aventure mathématique ?</p>
              </div>
            </div>
            <div className="text-right">
              <div className="text-3xl font-bold text-purple-600">{profile.totalPoints}</div>
              <div className="text-sm text-gray-600">points totaux</div>
            </div>
          </div>
          
          {/* Stats */}
          <div className="grid grid-cols-4 gap-4 mt-6">
            <div className="text-center p-3 bg-blue-50 rounded-lg">
              <div className="text-2xl font-bold text-blue-600">Niveau {profile.level}</div>
              <div className="text-xs text-blue-600">Progression</div>
            </div>
            <div className="text-center p-3 bg-orange-50 rounded-lg">
              <div className="text-2xl font-bold text-orange-600">{profile.streak} 🔥</div>
              <div className="text-xs text-orange-600">Jours consécutifs</div>
            </div>
            <div className="text-center p-3 bg-green-50 rounded-lg">
              <div className="text-2xl font-bold text-green-600">{profile.accuracy}%</div>
              <div className="text-xs text-green-600">Précision</div>
            </div>
            <div className="text-center p-3 bg-purple-50 rounded-lg">
              <div className="text-lg">{profile.badges.join(' ')}</div>
              <div className="text-xs text-purple-600">Badges</div>
            </div>
          </div>
        </div>

        {/* Modes de jeu */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-800 mb-6">🎮 Choisis ton Mode d&apos;Aventure</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {gameModes.map((mode) => (
              <Link key={mode.id} href={mode.path}>
                <div className={`bg-gradient-to-br ${mode.color} p-6 rounded-xl text-white hover:shadow-xl transform hover:scale-105 transition-all duration-300 cursor-pointer`}>
                  <div className="text-4xl mb-3">{mode.icon}</div>
                  <h3 className="text-xl font-bold mb-2">{mode.name}</h3>
                  <p className="text-sm opacity-90">{mode.description}</p>
                  <div className="mt-4 bg-white bg-opacity-20 rounded-lg p-2 text-center">
                    <span className="text-sm font-medium">Commencer →</span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>

        {/* Sélection des niveaux */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-800 mb-6">📊 Sélectionne ton Niveau</h2>
          <div className="grid grid-cols-5 gap-4">
            {levels.map((level) => (
              <Link key={level} href={`/exercises/${level}`}>
                <div className={`
                  p-6 rounded-xl text-center cursor-pointer transition-all duration-300 hover:shadow-lg
                  ${level <= profile.level 
                    ? 'bg-gradient-to-br from-green-400 to-green-500 text-white hover:scale-105' 
                    : 'bg-gray-100 text-gray-400 hover:bg-gray-200'
                  }
                `}>
                  <div className="text-2xl font-bold mb-2">Niveau {level}</div>
                  <div className="text-sm">
                    {level <= profile.level ? '✅ Débloqué' : '🔒 Verrouillé'}
                  </div>
                  {level === profile.level && (
                    <div className="mt-2 bg-white bg-opacity-20 rounded px-2 py-1 text-xs">
                      En cours
                    </div>
                  )}
                </div>
              </Link>
            ))}
          </div>
        </div>

        {/* Innovations disponibles */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <h2 className="text-2xl font-bold text-gray-800 mb-6">🚀 Innovations Disponibles</h2>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            <div className="p-4 bg-blue-50 rounded-lg text-center">
              <div className="text-3xl mb-2">🧠</div>
              <div className="text-sm font-medium text-blue-800">IA Adaptative</div>
              <div className="text-xs text-blue-600">Actif</div>
            </div>
            <div className="p-4 bg-green-50 rounded-lg text-center">
              <div className="text-3xl mb-2">✏️</div>
              <div className="text-sm font-medium text-green-800">Manuscrit</div>
              <div className="text-xs text-green-600">Disponible</div>
            </div>
            <div className="p-4 bg-purple-50 rounded-lg text-center">
              <div className="text-3xl mb-2">🥽</div>
              <div className="text-sm font-medium text-purple-800">AR 3D</div>
              <div className="text-xs text-purple-600">Disponible</div>
            </div>
            <div className="p-4 bg-orange-50 rounded-lg text-center">
              <div className="text-3xl mb-2">🎙️</div>
              <div className="text-sm font-medium text-orange-800">Vocal IA</div>
              <div className="text-xs text-orange-600">Actif</div>
            </div>
            <div className="p-4 bg-red-50 rounded-lg text-center">
              <div className="text-3xl mb-2">🧮</div>
              <div className="text-sm font-medium text-red-800">Moteur</div>
              <div className="text-xs text-red-600">Actif</div>
            </div>
            <div className="p-4 bg-indigo-50 rounded-lg text-center">
              <div className="text-3xl mb-2">🌍</div>
              <div className="text-sm font-medium text-indigo-800">200+ Langues</div>
              <div className="text-xs text-indigo-600">🇲🇦🇵🇸</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
