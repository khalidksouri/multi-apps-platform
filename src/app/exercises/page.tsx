"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { LocalDatabase } from '@/lib/database/localStorage'

const LEVELS = [
  {
    id: 1,
    name: 'discovery',
    displayName: 'Découverte',
    description: 'Premiers pas avec les nombres 1-10',
    difficulty: 'Débutant',
    emoji: '🎯',
    numberRange: [1, 10]
  },
  {
    id: 2,
    name: 'exploration',
    displayName: 'Exploration',
    description: 'Exploration des nombres 1-20',
    difficulty: 'Facile',
    emoji: '🚀',
    numberRange: [1, 20]
  },
  {
    id: 3,
    name: 'mastery',
    displayName: 'Maîtrise',
    description: 'Maîtrise des nombres 1-50',
    difficulty: 'Intermédiaire',
    emoji: '⭐',
    numberRange: [1, 50]
  },
  {
    id: 4,
    name: 'expert',
    displayName: 'Expert',
    description: 'Expertise avec les nombres 1-100',
    difficulty: 'Avancé',
    emoji: '🏆',
    numberRange: [1, 100]
  },
  {
    id: 5,
    name: 'champion',
    displayName: 'Champion',
    description: 'Maîtrise complète avec nombres 1-1000+',
    difficulty: 'Maître',
    emoji: '👑',
    numberRange: [1, 1000]
  }
]

export default function ExercisesPage() {
  const { t } = useLanguage()
  const [userProgress, setUserProgress] = useState<Record<number, number>>({})
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    // Initialiser ou récupérer l'utilisateur
    let user = LocalDatabase.getUser()
    if (!user) {
      user = LocalDatabase.initDemoUser()
    }
    
    // Charger la progression
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
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Chargement...</p>
        </div>
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

  const getLevelProgress = (levelId: number): number => {
    return userProgress[levelId] || 0
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      {/* Header avec navigation */}
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
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600 transition-colors">Plans</Link>
            </nav>
            
            <LanguageSelector />
          </div>
        </div>
      </header>

      <div className="py-8">
        <div className="max-w-4xl mx-auto px-4">
          {/* Header de la page */}
          <div className="text-center mb-12">
            <h1 className="text-4xl font-bold text-gray-800 mb-4">
              Choisis ton niveau
            </h1>
            <p className="text-xl text-gray-600">
              Progresse étape par étape pour devenir un champion des maths !
            </p>
          </div>

          {/* Grille des niveaux */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {LEVELS.map((level) => {
              const isUnlocked = isLevelUnlocked(level.id)
              const isCompleted = isLevelCompleted(level.id)
              const progress = getLevelProgress(level.id)
              const progressPercent = Math.min((progress / 100) * 100, 100)

              return (
                <div
                  key={level.id}
                  className={`relative bg-white rounded-2xl shadow-lg border-2 transition-all duration-300 ${
                    isUnlocked 
                      ? isCompleted
                        ? 'border-green-300 shadow-green-100'
                        : 'border-blue-300 hover:shadow-xl hover:scale-105'
                      : 'border-gray-200 opacity-60'
                  }`}
                >
                  {/* Badge de niveau */}
                  <div className={`absolute -top-4 left-6 px-4 py-2 rounded-full text-white font-bold text-sm ${
                    isCompleted 
                      ? 'bg-green-500' 
                      : isUnlocked 
                        ? 'bg-blue-500' 
                        : 'bg-gray-400'
                  }`}>
                    Niveau {level.id}
                  </div>

                  <div className="p-6 pt-8">
                    {/* Emoji et titre */}
                    <div className="text-center mb-4">
                      <div className="text-4xl mb-2">{level.emoji}</div>
                      <h3 className="text-xl font-bold text-gray-800">
                        {level.displayName}
                      </h3>
                      <p className="text-sm text-gray-500">{level.difficulty}</p>
                    </div>

                    {/* Description */}
                    <p className="text-gray-600 text-sm mb-4 text-center">
                      {level.description}
                    </p>

                    {/* Nombres */}
                    <div className="text-center mb-4">
                      <span className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-sm font-medium">
                        Nombres {level.numberRange[0]}-{level.numberRange[1]}
                      </span>
                    </div>

                    {/* Progression */}
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
                            style={{ width: `${progressPercent}%` }}
                          />
                        </div>
                      </div>
                    )}

                    {/* Bouton d'action */}
                    <div className="text-center">
                      {!isUnlocked ? (
                        <div className="flex items-center justify-center gap-2 text-gray-500">
                          <span className="text-lg">🔒</span>
                          <span className="text-sm">Verrouillé</span>
                        </div>
                      ) : (
                        <Link 
                          href={`/exercises/${level.id}`}
                          className={`inline-flex items-center gap-2 px-6 py-2 rounded-lg font-medium transition-colors ${
                            isCompleted
                              ? 'bg-green-500 hover:bg-green-600 text-white'
                              : 'bg-blue-500 hover:bg-blue-600 text-white'
                          }`}
                        >
                          <span className="text-lg">
                            {isCompleted ? '✅' : '▶️'}
                          </span>
                          {isCompleted ? 'Terminé - Rejouer' : 'Commencer'}
                        </Link>
                      )}
                    </div>
                  </div>
                </div>
              )
            })}
          </div>

          {/* Informations sur le déblocage */}
          <div className="mt-12 text-center">
            <div className="bg-white rounded-lg p-6 shadow-lg max-w-2xl mx-auto">
              <h3 className="text-lg font-bold text-gray-800 mb-3">
                Comment débloquer les niveaux ?
              </h3>
              <p className="text-gray-600 mb-4">
                Pour débloquer un niveau, tu dois obtenir <strong>100 bonnes réponses</strong> dans le niveau précédent.
              </p>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div className="bg-blue-50 rounded-lg p-3">
                  <div className="text-blue-600 font-medium">🎯 Pratique</div>
                  <div className="text-gray-600">Réponds aux questions</div>
                </div>
                <div className="bg-green-50 rounded-lg p-3">
                  <div className="text-green-600 font-medium">✅ Progresse</div>
                  <div className="text-gray-600">100 bonnes réponses</div>
                </div>
                <div className="bg-purple-50 rounded-lg p-3">
                  <div className="text-purple-600 font-medium">🔓 Débloque</div>
                  <div className="text-gray-600">Niveau suivant</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Navigation mobile */}
      <div className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-2">
        <div className="flex justify-around">
          <Link href="/" className="flex flex-col items-center gap-1 text-gray-600">
            <span className="text-lg">🏠</span>
            <span className="text-xs">Accueil</span>
          </Link>
          <Link href="/exercises" className="flex flex-col items-center gap-1 text-blue-600">
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
    </div>
  )
}
