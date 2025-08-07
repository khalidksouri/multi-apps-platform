"use client"

import { useState } from "react"
import Link from "next/link"
import { useLanguage } from "@/hooks/useLanguage"
import Navigation from "@/components/navigation/Navigation"

const levels = [
  {
    id: 1,
    name: "🎯 Découverte",
    description: "Nombres 1-10",
    difficulty: "Débutant",
    unlocked: true,
    progress: 100
  },
  {
    id: 2,
    name: "🚀 Exploration", 
    description: "Nombres 1-20",
    difficulty: "Facile",
    unlocked: true,
    progress: 85
  },
  {
    id: 3,
    name: "⭐ Maîtrise",
    description: "Nombres 1-50", 
    difficulty: "Intermédiaire",
    unlocked: false,
    progress: 0
  },
  {
    id: 4,
    name: "🏆 Expert",
    description: "Nombres 1-100",
    difficulty: "Avancé", 
    unlocked: false,
    progress: 0
  },
  {
    id: 5,
    name: "👑 Champion",
    description: "Nombres 1-1000+",
    difficulty: "Maître",
    unlocked: false,
    progress: 0
  }
]

const operations = [
  { id: 'addition', name: '➕ Addition', icon: '➕' },
  { id: 'subtraction', name: '➖ Soustraction', icon: '➖' },
  { id: 'multiplication', name: '✖️ Multiplication', icon: '✖️' },
  { id: 'division', name: '➗ Division', icon: '➗' },
  { id: 'mixed', name: '🎯 Mixte', icon: '🎯' }
]

export default function ExercisesPage() {
  const { isRTL, t } = useLanguage()
  const [selectedLevel, setSelectedLevel] = useState<number | null>(null)

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            {t('exercises.title')}
          </h1>
          <p className="text-xl text-gray-600">
            {t('exercises.subtitle')}
          </p>
        </div>

        {/* Sélection du niveau */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">
            {t('exercises.chooseLevelTitle')}
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {levels.map((level) => (
              <div
                key={level.id}
                onClick={() => level.unlocked && setSelectedLevel(level.id)}
                className={`relative p-6 rounded-xl shadow-lg transition-all duration-300 cursor-pointer ${
                  level.unlocked
                    ? selectedLevel === level.id
                      ? 'bg-blue-600 text-white transform scale-105'
                      : 'bg-white hover:shadow-xl hover:transform hover:scale-105'
                    : 'bg-gray-100 opacity-50 cursor-not-allowed'
                }`}
              >
                {!level.unlocked && (
                  <div className="absolute inset-0 flex items-center justify-center bg-black bg-opacity-20 rounded-xl">
                    <div className="text-4xl">🔒</div>
                  </div>
                )}
                
                <div className="text-center">
                  <h3 className="text-xl font-bold mb-2">{level.name}</h3>
                  <p className={`mb-3 ${selectedLevel === level.id ? 'text-blue-100' : 'text-gray-600'}`}>
                    {level.description}
                  </p>
                  <div className={`text-sm px-3 py-1 rounded-full inline-block mb-4 ${
                    selectedLevel === level.id ? 'bg-white text-blue-600' : 'bg-blue-100 text-blue-600'
                  }`}>
                    {level.difficulty}
                  </div>
                  
                  {level.unlocked && (
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-green-500 h-2 rounded-full transition-all duration-500"
                        style={{ width: `${level.progress}%` }}
                      ></div>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Sélection de l'opération */}
        {selectedLevel && (
          <div className="mb-12">
            <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">
              {t('exercises.chooseOperationTitle')}
            </h2>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
              {operations.map((operation) => (
                <Link
                  key={operation.id}
                  href={`/exercises/${selectedLevel}/${operation.id}`}
                  className="group"
                >
                  <div className="p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 text-center">
                    <div className="text-4xl mb-3 group-hover:scale-110 transition-transform">
                      {operation.icon}
                    </div>
                    <h3 className="font-semibold text-gray-800">
                      {operation.name}
                    </h3>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}

        {/* Instructions */}
        <div className="bg-white rounded-xl shadow-lg p-8 text-center">
          <h3 className="text-2xl font-bold text-gray-800 mb-4">
            {t('exercises.howItWorksTitle')}
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-left">
            <div className="flex items-start space-x-3">
              <div className="text-2xl">1️⃣</div>
              <div>
                <h4 className="font-semibold text-gray-800 mb-2">{t('exercises.step1')}</h4>
                <p className="text-gray-600">{t('exercises.step1Desc')}</p>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="text-2xl">2️⃣</div>
              <div>
                <h4 className="font-semibold text-gray-800 mb-2">{t('exercises.step2')}</h4>
                <p className="text-gray-600">{t('exercises.step2Desc')}</p>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="text-2xl">3️⃣</div>
              <div>
                <h4 className="font-semibold text-gray-800 mb-2">{t('exercises.step3')}</h4>
                <p className="text-gray-600">{t('exercises.step3Desc')}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
