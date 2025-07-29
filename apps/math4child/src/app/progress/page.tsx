'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

interface ProgressData {
  totalExercises: number
  correctAnswers: number
  averageAccuracy: number
  currentStreak: number
  bestStreak: number
  timeSpent: number
  favoriteOperation: string
  level: number
  badges: string[]
  weeklyProgress: number[]
}

export default function ProgressPage() {
  const [progressData, setProgressData] = useState<ProgressData>({
    totalExercises: 147,
    correctAnswers: 132,
    averageAccuracy: 90,
    currentStreak: 8,
    bestStreak: 15,
    timeSpent: 2340, // en secondes
    favoriteOperation: 'Addition',
    level: 5,
    badges: ['🔥 Premier streak', '🎯 90% précision', '⚡ Speed Master', '🧮 Math Expert'],
    weeklyProgress: [12, 18, 15, 22, 19, 25, 20]
  })

  const formatTime = (seconds: number) => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    return `${hours}h ${minutes}m`
  }

  const getLevelProgress = () => {
    const currentLevelStart = (progressData.level - 1) * 30
    const nextLevelStart = progressData.level * 30
    const progress = ((progressData.totalExercises - currentLevelStart) / (nextLevelStart - currentLevelStart)) * 100
    return Math.min(progress, 100)
  }

  const getNextBadge = () => {
    if (progressData.totalExercises >= 200 && !progressData.badges.includes('🏆 Champion')) return '🏆 Champion (200 exercices)'
    if (progressData.bestStreak >= 20 && !progressData.badges.includes('🔥 Mega Streak')) return '🔥 Mega Streak (20 de suite)'
    if (progressData.averageAccuracy >= 95 && !progressData.badges.includes('🎯 Perfectionniste')) return '🎯 Perfectionniste (95% précision)'
    return '⭐ Continue comme ça !'
  }

  const weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim']

  return (
    <div className="min-h-screen bg-gradient-to-br">
      {/* Header */}
      <header className="bg-white/10 backdrop-blur-sm border-white/20">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <Link href="/" className="text-white hover:text-yellow-300 mb-4 block">
            ← Retour à l'accueil
          </Link>
          <h1 className="text-3xl font-bold text-white">📊 Tes Progrès</h1>
          <p className="text-white/80">Suis ton évolution et tes performances</p>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* Vue d'ensemble */}
        <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 mb-8 border-white/30">
          <h2 className="text-2xl font-bold text-white mb-6">🎯 Vue d'ensemble</h2>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <div className="bg-blue-500/80 rounded-2xl p-4 text-center">
              <div className="text-3xl font-bold text-white">{progressData.totalExercises}</div>
              <div className="text-white/80">Exercices</div>
            </div>
            <div className="bg-green-500/80 rounded-2xl p-4 text-center">
              <div className="text-3xl font-bold text-white">{progressData.averageAccuracy}%</div>
              <div className="text-white/80">Précision</div>
            </div>
            <div className="bg-orange-500/80 rounded-2xl p-4 text-center">
              <div className="text-3xl font-bold text-white">{progressData.currentStreak}</div>
              <div className="text-white/80">Série actuelle</div>
            </div>
            <div className="bg-purple-500/80 rounded-2xl p-4 text-center">
              <div className="text-3xl font-bold text-white">{formatTime(progressData.timeSpent)}</div>
              <div className="text-white/80">Temps total</div>
            </div>
          </div>

          {/* Niveau et progression */}
          <div className="bg-white/10 rounded-2xl p-6">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-bold text-white">Niveau {progressData.level}</h3>
              <span className="text-white/80">Prochain niveau: {Math.ceil((progressData.level * 30 - progressData.totalExercises))} exercices</span>
            </div>
            <div className="bg-white/20 rounded-full h-4">
              <div 
                className="bg-gradient-to-r from-yellow-400 to-orange-500 h-4 rounded-full transition-all duration-500"
                style={{ width: `${getLevelProgress()}%` }}
              ></div>
            </div>
          </div>
        </div>

        {/* Graphique de la semaine */}
        <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 mb-8 border-white/30">
          <h2 className="text-2xl font-bold text-white mb-6">📈 Activité de la semaine</h2>
          
          <div className="flex items-end justify-between h-40 mb-4">
            {progressData.weeklyProgress.map((exercises, index) => (
              <div key={index} className="flex flex-col items-center">
                <div 
                  className="bg-blue-500 rounded-t-lg w-12 transition-all duration-500"
                  style={{ height: `${(exercises / Math.max(...progressData.weeklyProgress)) * 100}%` }}
                ></div>
                <div className="text-white font-bold mt-2">{exercises}</div>
                <div className="text-white/60 text-sm">{weekDays[index]}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Badges et réalisations */}
        <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 mb-8 border-white/30">
          <h2 className="text-2xl font-bold text-white mb-6">🏆 Tes Badges</h2>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            {progressData.badges.map((badge, index) => (
              <div key={index} className="bg-yellow-500/80 rounded-2xl p-4 text-center">
                <div className="text-2xl mb-2">{badge.split(' ')[0]}</div>
                <div className="text-white font-semibold text-sm">{badge.split(' ').slice(1).join(' ')}</div>
              </div>
            ))}
          </div>

          <div className="bg-white/10 rounded-2xl p-4">
            <h3 className="text-lg font-bold text-white mb-2">🎯 Prochain objectif</h3>
            <p className="text-white/80">{getNextBadge()}</p>
          </div>
        </div>

        {/* Statistiques détaillées */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Performance par opération */}
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <h2 className="text-xl font-bold text-white mb-6">📊 Par Opération</h2>
            
            <div className="space-y-4">
              {[
                { op: 'Addition', accuracy: 95, exercises: 45, color: 'bg-green-500' },
                { op: 'Soustraction', accuracy: 88, exercises: 38, color: 'bg-blue-500' },
                { op: 'Multiplication', accuracy: 92, exercises: 42, color: 'bg-purple-500' },
                { op: 'Division', accuracy: 85, exercises: 22, color: 'bg-orange-500' }
              ].map((item, index) => (
                <div key={index} className="bg-white/10 rounded-xl p-4">
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-white font-semibold">{item.op}</span>
                    <span className="text-white/80">{item.accuracy}%</span>
                  </div>
                  <div className="bg-white/20 rounded-full h-2">
                    <div 
                      className={`${item.color} h-2 rounded-full transition-all duration-500`}
                      style={{ width: `${item.accuracy}%` }}
                    ></div>
                  </div>
                  <div className="text-white/60 text-sm mt-1">{item.exercises} exercices</div>
                </div>
              ))}
            </div>
          </div>

          {/* Records personnels */}
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <h2 className="text-xl font-bold text-white mb-6">🥇 Tes Records</h2>
            
            <div className="space-y-4">
              <div className="bg-white/10 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-white font-semibold">🔥 Meilleure série</span>
                  <span className="text-yellow-300 font-bold">{progressData.bestStreak}</span>
                </div>
              </div>
              
              <div className="bg-white/10 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-white font-semibold">⚡ Plus rapide</span>
                  <span className="text-green-300 font-bold">3.2s</span>
                </div>
              </div>
              
              <div className="bg-white/10 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-white font-semibold">📅 Meilleur jour</span>
                  <span className="text-blue-300 font-bold">28 exercices</span>
                </div>
              </div>
              
              <div className="bg-white/10 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-white font-semibold">🎯 Précision parfaite</span>
                  <span className="text-purple-300 font-bold">12 fois</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Encouragements */}
        <div className="mt-8 bg-gradient-to-r from-pink-500/80 to-purple-500/80 rounded-3xl p-8 text-center border-white/30">
          <div className="text-4xl mb-4">🌟</div>
          <h3 className="text-2xl font-bold text-white mb-4">Continue comme ça !</h3>
          <p className="text-white/80 mb-6">
            Tu progresses très bien ! Avec {progressData.averageAccuracy}% de précision, tu es sur la bonne voie pour devenir un expert en mathématiques !
          </p>
          <Link 
            href="/exercises"
            className="bg-white/20 hover:bg-white/30 text-white px-8 py-4 rounded-xl font-bold text-lg transition-all inline-block"
          >
            🚀 Continuer à s'entraîner
          </Link>
        </div>
      </div>
    </div>
  )
}
