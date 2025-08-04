'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function HomePage() {
  const [count, setCount] = useState(0)
  const [mathResult, setMathResult] = useState<number | null>(null)
  const [currentProblem, setCurrentProblem] = useState({ a: 5, b: 3 })

  const generateNewProblem = () => {
    const a = Math.floor(Math.random() * 10) + 1
    const b = Math.floor(Math.random() * 10) + 1
    setCurrentProblem({ a, b })
    setMathResult(null)
  }

  // Données simulées de progression
  const userStats = {
    totalExercises: 147,
    accuracy: 90,
    currentStreak: 8,
    level: 5
  }

  return (
    <div className="min-h-screen bg-gradient-to-br">
      {/* Header */}
      <header className="bg-white/10 backdrop-blur-sm border-white/20">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold text-white">🧮 Math4Child</h1>
              <p className="text-white/80">L'apprentissage des mathématiques en s'amusant</p>
            </div>
            <div className="text-right">
              <div className="text-white/80 text-sm">Niveau {userStats.level}</div>
              <div className="text-white font-semibold">{userStats.totalExercises} exercices</div>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-4 py-12">
        {/* Stats rapides */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 text-center border-white/30">
            <div className="text-2xl font-bold text-white">{userStats.totalExercises}</div>
            <div className="text-white/80 text-sm">Exercices</div>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 text-center border-white/30">
            <div className="text-2xl font-bold text-white">{userStats.accuracy}%</div>
            <div className="text-white/80 text-sm">Précision</div>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 text-center border-white/30">
            <div className="text-2xl font-bold text-white">{userStats.currentStreak}</div>
            <div className="text-white/80 text-sm">Série</div>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 text-center border-white/30">
            <div className="text-2xl font-bold text-white">Niveau {userStats.level}</div>
            <div className="text-white/80 text-sm">Actuel</div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Section Interactive */}
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <h2 className="text-2xl font-bold text-white mb-6">🎮 Zone Interactive</h2>
            
            <div className="space-y-6">
              <div className="bg-white/10 rounded-2xl p-6">
                <h3 className="text-lg font-semibold text-white mb-4">Compteur Magique</h3>
                <div className="flex items-center gap-4">
                  <button 
                    onClick={() => setCount(count - 1)}
                    className="bg-red-500 hover:bg-red-600 text-white w-12 h-12 rounded-full text-xl font-bold transition-all transform hover:scale-110"
                  >
                    -
                  </button>
                  <div className="bg-white/20 px-6 py-3 rounded-xl text-2xl font-bold text-white min-w-[80px] text-center">
                    {count}
                  </div>
                  <button 
                    onClick={() => setCount(count + 1)}
                    className="bg-green-500 hover:bg-green-600 text-white w-12 h-12 rounded-full text-xl font-bold transition-all transform hover:scale-110"
                  >
                    +
                  </button>
                  <button 
                    onClick={() => setCount(0)}
                    className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-xl font-semibold transition-all"
                  >
                    Reset
                  </button>
                </div>
              </div>

              <div className="bg-white/10 rounded-2xl p-6">
                <h3 className="text-lg font-semibold text-white mb-4">🧠 Mini Calcul</h3>
                <div className="text-center">
                  <div className="text-3xl font-bold text-white mb-4">
                    {currentProblem.a} + {currentProblem.b} = ?
                  </div>
                  <div className="flex gap-3 justify-center">
                    <button
                      onClick={() => setMathResult(currentProblem.a + currentProblem.b)}
                      className="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-3 rounded-xl font-semibold transition-all"
                    >
                      Révéler: {currentProblem.a + currentProblem.b}
                    </button>
                    <button
                      onClick={generateNewProblem}
                      className="bg-purple-500 hover:bg-purple-600 text-white px-6 py-3 rounded-xl font-semibold transition-all"
                    >
                      Nouveau
                    </button>
                  </div>
                  {mathResult && (
                    <div className="mt-4 text-2xl text-yellow-300 font-bold animate-pulse">
                      ✨ Réponse: {mathResult} ✨
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Section Navigation */}
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <h2 className="text-2xl font-bold text-white mb-6">🚀 Modules d'Apprentissage</h2>
            
            <div className="grid grid-cols-1 gap-4">
              <Link href="/exercises" className="bg-blue-500/80 hover:bg-blue-600/80 rounded-2xl p-6 transition-all transform hover:scale-105 block">
                <div className="flex items-center gap-4">
                  <div className="text-4xl">📚</div>
                  <div>
                    <h3 className="text-xl font-bold text-white">Exercices</h3>
                    <p className="text-white/80">Pratique les 4 opérations</p>
                    <div className="text-white/60 text-sm mt-1">🔥 Mode entraînement avec timer</div>
                  </div>
                </div>
              </Link>
              
              <Link href="/games" className="bg-green-500/80 hover:bg-green-600/80 rounded-2xl p-6 transition-all transform hover:scale-105 block">
                <div className="flex items-center gap-4">
                  <div className="text-4xl">🎮</div>
                  <div>
                    <h3 className="text-xl font-bold text-white">Jeux</h3>
                    <p className="text-white/80">Apprendre en jouant</p>
                    <div className="text-white/60 text-sm mt-1">⚡ Quick Math, Memory & plus</div>
                  </div>
                </div>
              </Link>
              
              <Link href="/progress" className="bg-purple-500/80 hover:bg-purple-600/80 rounded-2xl p-6 transition-all transform hover:scale-105 block">
                <div className="flex items-center gap-4">
                  <div className="text-4xl">📊</div>
                  <div>
                    <h3 className="text-xl font-bold text-white">Progrès</h3>
                    <p className="text-white/80">Suivre ton évolution</p>
                    <div className="text-white/60 text-sm mt-1">🏆 Badges, stats et records</div>
                  </div>
                </div>
              </Link>
            </div>
          </div>
        </div>

        {/* Section Status */}
        <div className="mt-12 bg-white/10 backdrop-blur-sm rounded-3xl p-8 border-white/30">
          <h2 className="text-2xl font-bold text-white mb-6">✅ Status de l'Application</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-3xl mb-2">⚡</div>
              <h3 className="font-bold text-white">Application Complète</h3>
              <p className="text-white/80">Tous les modules actifs</p>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-2">🔧</div>
              <h3 className="font-bold text-white">React jsx-runtime</h3>
              <p className="text-green-300">✅ Résolu</p>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-2">🎯</div>
              <h3 className="font-bold text-white">Prêt pour</h3>
              <p className="text-white/80">Apprentissage complet</p>
            </div>
          </div>
        </div>

        {/* Message de bienvenue */}
        <div className="mt-8 bg-gradient-to-r from-green-500/80 to-blue-500/80 rounded-3xl p-8 text-center border-white/30">
          <div className="text-4xl mb-4">🎉</div>
          <h3 className="text-2xl font-bold text-white mb-4">Bienvenue dans Math4Child !</h3>
          <p className="text-white/80 mb-6">
            Ton aventure mathématique t'attend ! Choisis un module et commence à apprendre en t'amusant.
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <Link 
              href="/exercises"
              className="bg-white/20 hover:bg-white/30 text-white px-6 py-3 rounded-xl font-bold transition-all"
            >
              🚀 Commencer les exercices
            </Link>
            <Link 
              href="/games"
              className="bg-white/20 hover:bg-white/30 text-white px-6 py-3 rounded-xl font-bold transition-all"
            >
              🎮 Jouer aux jeux
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
