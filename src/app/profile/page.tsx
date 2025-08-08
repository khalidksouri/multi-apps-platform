"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { LocalDatabase } from '@/lib/database/localStorage'

export default function ProfilePage() {
  const { t } = useLanguage()
  const [user, setUser] = useState<any>(null)
  const [progress, setProgress] = useState<any>(null)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    // Initialiser ou récupérer l'utilisateur
    let userData = LocalDatabase.getUser()
    if (!userData) {
      userData = LocalDatabase.initDemoUser()
    }
    setUser(userData)
    
    // Charger la progression
    const progressData = LocalDatabase.getProgress()
    setProgress(progressData)
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

  if (!user || !progress) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600">Erreur de chargement du profil</p>
        </div>
      </div>
    )
  }

  const totalQuestionsAnswered = progress.totalQuestionsAnswered || 0
  const totalCorrectAnswers = progress.totalCorrectAnswers || 0
  const accuracy = totalQuestionsAnswered > 0 ? Math.round((totalCorrectAnswers / totalQuestionsAnswered) * 100) : 0
  const completedLevels = Object.values(progress.levelProgress).filter((level: any) => level.isCompleted).length
  const freeQuestionsUsed = progress.freeQuestionsUsed || 0

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
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors">Exercices</Link>
              <Link href="/profile" className="text-blue-600 font-medium">Profil</Link>
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600 transition-colors">Plans</Link>
            </nav>
            
            <LanguageSelector />
          </div>
        </div>
      </header>

      <div className="py-8">
        <div className="max-w-6xl mx-auto px-4">
          
          {/* Header du profil */}
          <div className="bg-white rounded-3xl shadow-xl p-8 mb-8">
            <div className="flex items-center gap-6">
              <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-white text-3xl font-bold">
                {user.name.charAt(0).toUpperCase()}
              </div>
              <div className="flex-1">
                <h1 className="text-3xl font-bold text-gray-800 mb-2">{user.name}</h1>
                <p className="text-gray-600 mb-3">{user.email}</p>
                <div className="flex items-center gap-4 text-sm">
                  <div className={`px-3 py-1 rounded-full text-xs font-medium ${
                    user.subscriptionType === 'free' 
                      ? 'bg-gray-100 text-gray-600' 
                      : 'bg-blue-100 text-blue-600'
                  }`}>
                    {user.subscriptionType === 'free' ? 'Gratuit' : 'Premium'}
                  </div>
                </div>
              </div>
              <div className="text-right">
                <div className="text-2xl font-bold text-blue-600">{accuracy}%</div>
                <div className="text-sm text-gray-500">Précision globale</div>
              </div>
            </div>
          </div>

          {/* Statistiques principales */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div className="bg-white rounded-2xl p-6 shadow-lg">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                  <span className="text-blue-600 text-lg">🎯</span>
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-800">{totalCorrectAnswers}</div>
                  <div className="text-sm text-gray-500">Bonnes réponses</div>
                </div>
              </div>
              <div className="text-xs text-gray-400">
                Sur {totalQuestionsAnswered} questions
              </div>
            </div>

            <div className="bg-white rounded-2xl p-6 shadow-lg">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                  <span className="text-green-600 text-lg">🏆</span>
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-800">{completedLevels}</div>
                  <div className="text-sm text-gray-500">Niveaux terminés</div>
                </div>
              </div>
              <div className="text-xs text-gray-400">
                Sur 5 niveaux
              </div>
            </div>

            <div className="bg-white rounded-2xl p-6 shadow-lg">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center">
                  <span className="text-orange-600 text-lg">🔥</span>
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-800">{progress.streakDays || 0}</div>
                  <div className="text-sm text-gray-500">Jours de suite</div>
                </div>
              </div>
              <div className="text-xs text-gray-400">
                Série actuelle
              </div>
            </div>

            <div className="bg-white rounded-2xl p-6 shadow-lg">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                  <span className="text-purple-600 text-lg">📚</span>
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-800">{Object.keys(progress.levelProgress).length}</div>
                  <div className="text-sm text-gray-500">Niveaux débloqués</div>
                </div>
              </div>
              <div className="text-xs text-gray-400">
                Progression globale
              </div>
            </div>
          </div>

          {/* Limitation plan gratuit */}
          {user.subscriptionType === 'free' && (
            <div className="bg-gradient-to-r from-blue-500 to-purple-500 rounded-2xl p-6 mb-8 text-white">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-bold mb-2">Plan Gratuit</h3>
                  <p className="text-blue-100 mb-4">
                    Tu as utilisé {freeQuestionsUsed}/50 questions gratuites.
                  </p>
                  <p className="text-sm text-blue-200">
                    Passe au plan Premium pour des questions illimitées !
                  </p>
                </div>
                <div className="text-right">
                  <div className="text-3xl font-bold mb-2">
                    {50 - freeQuestionsUsed}
                  </div>
                  <div className="text-blue-200 text-sm">questions restantes</div>
                  <Link 
                    href="/pricing"
                    className="inline-block bg-white text-blue-600 px-4 py-2 rounded-lg font-medium hover:bg-blue-50 transition-colors mt-3"
                  >
                    Améliorer
                  </Link>
                </div>
              </div>
            </div>
          )}

          {/* Actions rapides */}
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <h3 className="text-xl font-bold text-gray-800 mb-6">Actions rapides</h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Link 
                href="/exercises"
                className="flex items-center gap-3 p-4 bg-blue-50 rounded-xl hover:bg-blue-100 transition-colors"
              >
                <span className="text-2xl">🧮</span>
                <div>
                  <div className="font-medium text-gray-800">Continuer les exercices</div>
                  <div className="text-sm text-gray-600">Progresse dans ton niveau actuel</div>
                </div>
              </Link>
              
              <Link 
                href="/pricing"
                className="flex items-center gap-3 p-4 bg-purple-50 rounded-xl hover:bg-purple-100 transition-colors"
              >
                <span className="text-2xl">💎</span>
                <div>
                  <div className="font-medium text-gray-800">Voir les plans</div>
                  <div className="text-sm text-gray-600">Débloque toutes les fonctionnalités</div>
                </div>
              </Link>
              
              <button 
                onClick={() => {
                  LocalDatabase.removeUser()
                  window.location.reload()
                }}
                className="flex items-center gap-3 p-4 bg-red-50 rounded-xl hover:bg-red-100 transition-colors"
              >
                <span className="text-2xl">🔄</span>
                <div>
                  <div className="font-medium text-gray-800">Recommencer</div>
                  <div className="text-sm text-gray-600">Réinitialiser la progression</div>
                </div>
              </button>
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
          <Link href="/exercises" className="flex flex-col items-center gap-1 text-gray-600">
            <span className="text-lg">📚</span>
            <span className="text-xs">Exercices</span>
          </Link>
          <Link href="/profile" className="flex flex-col items-center gap-1 text-blue-600">
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
