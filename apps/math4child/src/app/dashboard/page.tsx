'use client'

import React from 'react'
import Link from 'next/link'

export default function DashboardPage() {
  const stats = {
    exercisesCompleted: 42,
    accuracy: 85,
    streak: 7
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="mb-8">
          <Link href="/" className="text-blue-600 hover:underline">← Retour</Link>
        </div>
        
        <h1 className="text-4xl font-bold text-center text-gray-900 mb-12">
          Tableau de Bord
        </h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-white rounded-2xl p-8 shadow-xl text-center">
            <div className="text-4xl mb-4">📚</div>
            <div className="text-3xl font-bold text-blue-600">{stats.exercisesCompleted}</div>
            <div className="text-gray-600">Exercices complétés</div>
          </div>
          
          <div className="bg-white rounded-2xl p-8 shadow-xl text-center">
            <div className="text-4xl mb-4">🎯</div>
            <div className="text-3xl font-bold text-green-600">{stats.accuracy}%</div>
            <div className="text-gray-600">Précision</div>
          </div>
          
          <div className="bg-white rounded-2xl p-8 shadow-xl text-center">
            <div className="text-4xl mb-4">🔥</div>
            <div className="text-3xl font-bold text-orange-600">{stats.streak}</div>
            <div className="text-gray-600">Jours consécutifs</div>
          </div>
        </div>
      </div>
    </div>
  )
}
