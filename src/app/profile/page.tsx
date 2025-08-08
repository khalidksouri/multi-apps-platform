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
    let userData = LocalDatabase.getUser()
    if (!userData) {
      userData = LocalDatabase.initDemoUser()
    }
    setUser(userData)
    
    const progressData = LocalDatabase.getProgress()
    setProgress(progressData)
  }, [])

  if (!mounted || !user || !progress) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  const totalQuestionsAnswered = progress.totalQuestionsAnswered || 0
  const totalCorrectAnswers = progress.totalCorrectAnswers || 0
  const accuracy = totalQuestionsAnswered > 0 ? Math.round((totalCorrectAnswers / totalQuestionsAnswered) * 100) : 0

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
            <LanguageSelector />
          </div>
        </div>
      </header>

      <div className="py-8">
        <div className="max-w-4xl mx-auto px-4">
          <div className="bg-white rounded-3xl shadow-xl p-8">
            <div className="flex items-center gap-6 mb-8">
              <div className="w-24 h-24 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-white text-4xl font-bold">
                {user.name.charAt(0).toUpperCase()}
              </div>
              <div>
                <h1 className="text-3xl font-bold text-gray-800">{user.name}</h1>
                <p className="text-gray-600">{user.email}</p>
              </div>
            </div>

            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-8">
              <div className="text-center">
                <div className="text-3xl font-bold text-blue-600">{totalCorrectAnswers}</div>
                <div className="text-sm text-gray-500">Bonnes réponses</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-green-600">{accuracy}%</div>
                <div className="text-sm text-gray-500">Précision</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-purple-600">{progress.badges?.length || 0}</div>
                <div className="text-sm text-gray-500">Badges</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-orange-600">{progress.streakDays}</div>
                <div className="text-sm text-gray-500">Série</div>
              </div>
            </div>

            <Link 
              href="/exercises" 
              className="w-full bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 text-white px-8 py-4 rounded-xl font-bold text-lg text-center block"
            >
              🚀 Continuer les Exercices
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
