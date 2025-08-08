"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { LocalDatabase } from '@/lib/database/localStorage'

const LEVELS = [
  {
    id: 1,
    name: 'Découverte',
    description: 'Premiers pas avec les nombres 1-10',
    innovations: ['IA Adaptive', 'Manuscrit']
  },
  {
    id: 2,
    name: 'Exploration',
    description: 'Nombres 1-20 avec plus d\'innovations',
    innovations: ['IA Adaptive', 'Manuscrit', 'Vocal IA']
  },
  {
    id: 3,
    name: 'Maîtrise',
    description: 'Nombres 1-50 avec réalité augmentée',
    innovations: ['IA Adaptive', 'Manuscrit', 'Vocal IA', 'Réalité Augmentée']
  },
  {
    id: 4,
    name: 'Expert',
    description: 'Nombres 1-100 avec compétitions',
    innovations: ['Toutes les innovations', 'Compétitions Mondiales']
  },
  {
    id: 5,
    name: 'Champion',
    description: 'Maîtrise complète 1-1000+',
    innovations: ['Toutes les innovations', 'Badges Mythiques']
  }
]

export default function ExercisesPage() {
  const { t } = useLanguage()
  const [userProgress, setUserProgress] = useState<Record<number, number>>({})
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    let user = LocalDatabase.getUser()
    if (!user) {
      user = LocalDatabase.initDemoUser()
    }
    
    const progress = LocalDatabase.getProgress()
    if (progress) {
      const levelProgress: Record<number, number> = {}
      Object.entries(progress.levelProgress).forEach(([level, data]) => {
        levelProgress[parseInt(level)] = (data as any).totalCorrectAnswers || 0
      })
      setUserProgress(levelProgress)
    }
  }, [])

  if (!mounted) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  const isLevelUnlocked = (levelId: number): boolean => {
    if (levelId === 1) return true
    const previousLevel = levelId - 1
    return (userProgress[previousLevel] || 0) >= 100
  }

  const isLevelCompleted = (levelId: number): boolean => {
    return (userProgress[levelId] || 0) >= 100
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <header className="bg-white shadow-sm border-b sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <Link href="/" className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white font-bold text-lg">🧮</span>
              </div>
              <span className="font-bold text-xl text-gray-800">Math4Child</span>
            </Link>
            
            <nav className="hidden md:flex space-x-8">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition-colors">Accueil</Link>
              <Link href="/exercises" className="text-blue-600 font-medium">Exercices</Link>
              <Link href="/profile" className="text-gray-600 hover:text-blue-600 transition-colors">Profil</Link>
            </nav>
            
            <LanguageSelector />
          </div>
        </div>
      </header>

      <div className="py-8">
        <div className="max-w-6xl mx-auto px-4">
          <div className="text-center mb-12">
            <h1 className="text-4xl font-bold text-gray-800 mb-4">
              Choisis ton Niveau d'Innovation
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Chaque niveau débloque de <strong>nouvelles technologies révolutionnaires</strong> !
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {LEVELS.map((level) => {
              const isUnlocked = isLevelUnlocked(level.id)
              const isCompleted = isLevelCompleted(level.id)
              const progress = userProgress[level.id] || 0

              return (
                <div
                  key={level.id}
                  className={`bg-white rounded-2xl p-6 shadow-lg transition-all duration-300 ${
                    isUnlocked ? 'transform hover:scale-105 hover:shadow-xl' : 'opacity-60'
                  }`}
                >
                  <div className="text-center mb-4">
                    <div className="text-4xl mb-3">
                      {level.id === 1 ? '🌟' : level.id === 2 ? '🚀' : level.id === 3 ? '✨' : level.id === 4 ? '🏆' : '👑'}
                    </div>
                    <h3 className="text-xl font-bold text-gray-800">
                      Niveau {level.id} - {level.name}
                    </h3>
                    <p className="text-gray-600 text-sm">{level.description}</p>
                  </div>

                  <div className="mb-4">
                    <h4 className="text-sm font-bold text-gray-800 mb-2">🚀 Innovations :</h4>
                    <div className="space-y-1">
                      {level.innovations.map((innovation, index) => (
                        <div 
                          key={index}
                          className="bg-purple-100 text-purple-700 px-2 py-1 rounded text-xs"
                        >
                          ✨ {innovation}
                        </div>
                      ))}
                    </div>
                  </div>

                  {isUnlocked && (
                    <div className="mb-4">
                      <div className="flex justify-between text-sm text-gray-600 mb-1">
                        <span>Progression</span>
                        <span>{progress}/100</span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2">
                        <div 
                          className={`h-2 rounded-full transition-all duration-500 ${
                            isCompleted ? 'bg-green-500' : 'bg-blue-500'
                          }`}
                          style={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                        />
                      </div>
                    </div>
                  )}

                  <div className="text-center">
                    {!isUnlocked ? (
                      <div className="text-gray-500">
                        <span className="text-lg">🔒</span>
                        <div className="text-sm">Termine le niveau {level.id - 1}</div>
                      </div>
                    ) : (
                      <Link 
                        href={`/exercises/${level.id}`}
                        className={`inline-flex items-center gap-2 px-6 py-3 rounded-lg font-medium transition-all ${
                          isCompleted
                            ? 'bg-green-500 hover:bg-green-600 text-white'
                            : 'bg-blue-500 hover:bg-blue-600 text-white'
                        }`}
                      >
                        <span>{isCompleted ? '🏆' : '🚀'}</span>
                        {isCompleted ? 'Rejouer' : 'Découvrir'}
                      </Link>
                    )}
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
