"use client"

import { useState } from 'react'
import Link from 'next/link'
import { ArrowLeft, Lock, Star, Trophy } from 'lucide-react'
import { useLanguage } from '@/hooks/useLanguage'
import { UniversalLanguageSelector } from '@/components/language/UniversalLanguageSelector'
import { MATH4CHILD_LEVELS, isLevelUnlocked } from '@/lib/progression/levels'

export default function ExercisesPage() {
  const { t, isRTL } = useLanguage()
  
  // Mock user progress - dans une vraie app, ça viendrait d'un store
  const [userProgress] = useState({
    1: 75,  // 75 bonnes réponses niveau 1
    2: 45,  // 45 bonnes réponses niveau 2
    3: 0,   // Pas encore commencé niveau 3
    4: 0,   // Bloqué
    5: 0    // Bloqué
  })

  const getLevelStatus = (levelId: number) => {
    const progress = userProgress[levelId] || 0
    const isUnlocked = isLevelUnlocked(levelId, userProgress)
    
    if (!isUnlocked) return 'locked'
    if (progress >= 100) return 'completed'
    if (progress > 0) return 'in_progress'
    return 'available'
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed': return <Trophy className="w-6 h-6 text-yellow-500" />
      case 'in_progress': return <Star className="w-6 h-6 text-blue-500" />
      case 'locked': return <Lock className="w-6 h-6 text-gray-400" />
      default: return <Star className="w-6 h-6 text-gray-500" />
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'from-yellow-400 to-orange-500'
      case 'in_progress': return 'from-blue-400 to-purple-500'
      case 'locked': return 'from-gray-300 to-gray-400'
      default: return 'from-green-400 to-blue-500'
    }
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-500 via-purple-600 to-pink-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="p-6">
        <div className="flex justify-between items-center max-w-7xl mx-auto">
          <div className="flex items-center gap-4">
            <Link 
              href="/"
              className="flex items-center gap-2 text-white hover:text-gray-200 transition-colors"
            >
              <ArrowLeft size={20} />
              {t('back_to_home') || 'Retour à l\'accueil'}
            </Link>
            <div className="flex items-center gap-4">
              <div className="text-3xl">🎮</div>
              <div>
                <h1 className="text-2xl font-bold text-white">Niveaux Math4Child</h1>
                <p className="text-white/80 text-sm">5 niveaux de progression</p>
              </div>
            </div>
          </div>
          
          <UniversalLanguageSelector />
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-6 py-8">
        <div className="max-w-6xl mx-auto">
          
          {/* Statistiques globales */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-6 mb-8 text-white">
            <h2 className="text-2xl font-bold mb-4">📊 Votre Progression</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div className="text-center">
                <div className="text-2xl font-bold text-yellow-300">
                  {Object.values(userProgress).reduce((sum, val) => sum + val, 0)}
                </div>
                <div className="text-white/80 text-sm">Bonnes réponses</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-green-300">
                  {Object.values(userProgress).filter(val => val >= 100).length}
                </div>
                <div className="text-white/80 text-sm">Niveaux terminés</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-blue-300">
                  {Math.round((Object.values(userProgress).reduce((sum, val) => sum + val, 0) / 500) * 100)}%
                </div>
                <div className="text-white/80 text-sm">Progression totale</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-purple-300">
                  {Object.values(userProgress).filter(val => val > 0 && val < 100).length}
                </div>
                <div className="text-white/80 text-sm">En cours</div>
              </div>
            </div>
          </div>

          {/* Grille des niveaux */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {MATH4CHILD_LEVELS.map((level) => {
              const status = getLevelStatus(level.id)
              const progress = userProgress[level.id] || 0
              const isUnlocked = status !== 'locked'
              
              return (
                <div
                  key={level.id}
                  className={`relative bg-white rounded-xl overflow-hidden shadow-lg transform transition-all duration-300 ${
                    isUnlocked ? 'hover:scale-105 hover:shadow-xl cursor-pointer' : 'opacity-60'
                  }`}
                >
                  {/* Header du niveau avec gradient */}
                  <div className={`bg-gradient-to-r ${getStatusColor(status)} p-6 text-white`}>
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-2xl font-bold">Niveau {level.id}</span>
                      {getStatusIcon(status)}
                    </div>
                    <h3 className="text-xl font-bold mb-1">{level.name}</h3>
                    <p className="text-white/90 text-sm">{level.description}</p>
                  </div>

                  {/* Contenu du niveau */}
                  <div className="p-6">
                    {/* Barre de progression */}
                    <div className="mb-4">
                      <div className="flex justify-between text-sm text-gray-600 mb-1">
                        <span>Progression</span>
                        <span>{progress}/100 bonnes réponses</span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2">
                        <div 
                          className={`bg-gradient-to-r ${getStatusColor(status)} h-2 rounded-full transition-all duration-300`}
                          style={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                        />
                      </div>
                    </div>

                    {/* Opérations supportées */}
                    <div className="mb-4">
                      <h4 className="font-semibold text-gray-800 mb-2">Opérations :</h4>
                      <div className="flex flex-wrap gap-2">
                        {level.operations.map((op) => (
                          <span 
                            key={op}
                            className="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm"
                          >
                            {op === 'addition' ? '➕ Addition' :
                             op === 'subtraction' ? '➖ Soustraction' :
                             op === 'multiplication' ? '✖️ Multiplication' :
                             op === 'division' ? '➗ Division' : '🔀 Mixte'}
                          </span>
                        ))}
                      </div>
                    </div>

                    {/* Badges */}
                    {level.rewards.length > 0 && (
                      <div className="mb-4">
                        <h4 className="font-semibold text-gray-800 mb-2">Récompenses :</h4>
                        <div className="flex gap-2">
                          {level.rewards.slice(0, 2).map((badge) => (
                            <div
                              key={badge.id}
                              className={`text-2xl p-2 rounded-lg ${
                                status === 'completed' ? 'bg-yellow-100' : 'bg-gray-100 opacity-50'
                              }`}
                              title={badge.description}
                            >
                              {badge.icon}
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Bouton d'action */}
                    {isUnlocked ? (
                      <Link
                        href={`/exercises/${level.id}`}
                        className={`w-full bg-gradient-to-r ${getStatusColor(status)} text-white py-3 px-4 rounded-lg font-bold text-center block hover:opacity-90 transition-opacity`}
                      >
                        {status === 'completed' ? '🏆 Rejouer' :
                         status === 'in_progress' ? '▶️ Continuer' : '🚀 Commencer'}
                      </Link>
                    ) : (
                      <div className="w-full bg-gray-300 text-gray-500 py-3 px-4 rounded-lg font-bold text-center">
                        🔒 Terminez le niveau précédent
                      </div>
                    )}

                    {/* Conditions de déblocage */}
                    {!isUnlocked && level.unlockConditions.length > 0 && (
                      <div className="mt-3 text-xs text-gray-500">
                        <strong>Condition :</strong> {level.unlockConditions[0]}
                      </div>
                    )}
                  </div>
                </div>
              )
            })}
          </div>

          {/* Section informations */}
          <div className="mt-12 bg-white/10 backdrop-blur-sm rounded-xl p-6 text-white">
            <h3 className="text-xl font-bold mb-4">ℹ️ Comment ça marche ?</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <h4 className="font-semibold mb-2">🎯 Objectif par niveau</h4>
                <p className="text-white/90 text-sm">
                  Répondez correctement à <strong>100 questions minimum</strong> pour débloquer le niveau suivant.
                  Vous gardez l'accès aux niveaux terminés pour vous entraîner.
                </p>
              </div>
              <div>
                <h4 className="font-semibold mb-2">🏆 Système de récompenses</h4>
                <p className="text-white/90 text-sm">
                  Gagnez des badges exclusifs en terminant chaque niveau. 
                  Plus vous progressez, plus les récompenses sont prestigieuses !
                </p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
