"use client"

import { Calculator, Lock, CheckCircle, Play, ArrowLeft } from "lucide-react"
import Link from "next/link"
import { useLanguage } from "@/hooks/useLanguage"
import Navigation from "@/components/navigation/Navigation"

export default function ExercisesPage() {
  const { t, isRTL } = useLanguage()

  const levels = [
    {
      id: 1,
      title: t('levels.level1') || "Niveau 1 - Découverte",
      description: "Nombres de 1 à 10",
      progress: 85,
      completed: 85,
      total: 100,
      unlocked: true,
      icon: "🎯"
    },
    {
      id: 2,
      title: t('levels.level2') || "Niveau 2 - Exploration",
      description: "Nombres de 1 à 20",
      progress: 45,
      completed: 45,
      total: 100,
      unlocked: true,
      icon: "🚀"
    },
    {
      id: 3,
      title: t('levels.level3') || "Niveau 3 - Maîtrise",
      description: "Nombres de 1 à 50",
      progress: 0,
      completed: 0,
      total: 100,
      unlocked: false,
      icon: "⭐"
    },
    {
      id: 4,
      title: t('levels.level4') || "Niveau 4 - Expert",
      description: "Nombres de 1 à 100",
      progress: 0,
      completed: 0,
      total: 100,
      unlocked: false,
      icon: "🏆"
    },
    {
      id: 5,
      title: t('levels.level5') || "Niveau 5 - Champion",
      description: "Nombres avancés",
      progress: 0,
      completed: 0,
      total: 100,
      unlocked: false,
      icon: "👑"
    }
  ]

  const operations = [
    {
      id: 'addition',
      name: t('operations.addition') || "Addition",
      description: t('operations.additionDesc') || "Apprendre à additionner",
      icon: '➕',
      color: 'from-green-500 to-emerald-600'
    },
    {
      id: 'subtraction',
      name: t('operations.subtraction') || "Soustraction",
      description: t('operations.subtractionDesc') || "Apprendre à soustraire",
      icon: '➖',
      color: 'from-red-500 to-rose-600'
    },
    {
      id: 'multiplication',
      name: t('operations.multiplication') || "Multiplication",
      description: t('operations.multiplicationDesc') || "Apprendre à multiplier",
      icon: '✖️',
      color: 'from-blue-500 to-indigo-600'
    },
    {
      id: 'division',
      name: t('operations.division') || "Division",
      description: t('operations.divisionDesc') || "Apprendre à diviser",
      icon: '➗',
      color: 'from-purple-500 to-violet-600'
    },
    {
      id: 'mixed',
      name: t('operations.mixed') || "Mixte",
      description: t('operations.mixedDesc') || "Exercices variés",
      icon: '🎯',
      color: 'from-orange-500 to-amber-600'
    }
  ]

  return (
    <div className={`min-h-screen bg-gray-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      <div className="pt-20 pb-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          {/* Header */}
          <div className="mb-8">
            <Link 
              href="/"
              className="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4"
            >
              <ArrowLeft className="w-4 h-4" />
              {t('exercise.back') || "← Retour"}
            </Link>
            <h1 className="text-4xl font-bold text-gray-900 mb-2">
              {t('levels.choose') || "Choisis ton niveau"}
            </h1>
            <p className="text-xl text-gray-600">
              Progresse à ton rythme avec nos 5 niveaux adaptatifs
            </p>
          </div>

          {/* Niveaux */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
            {levels.map((level) => (
              <div
                key={level.id}
                className={`relative bg-white rounded-2xl p-6 shadow-lg transition-all duration-300 ${
                  level.unlocked 
                    ? 'hover:shadow-xl hover:-translate-y-1 cursor-pointer' 
                    : 'opacity-60 cursor-not-allowed'
                }`}
              >
                {/* Status indicator */}
                <div className="absolute top-4 right-4">
                  {level.completed === level.total ? (
                    <CheckCircle className="w-6 h-6 text-green-500" />
                  ) : !level.unlocked ? (
                    <Lock className="w-6 h-6 text-gray-400" />
                  ) : (
                    <Play className="w-6 h-6 text-blue-500" />
                  )}
                </div>

                {/* Icon */}
                <div className="text-4xl mb-4">{level.icon}</div>

                {/* Title */}
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  {level.title}
                </h3>

                {/* Description */}
                <p className="text-gray-600 mb-4">{level.description}</p>

                {/* Progress */}
                {level.unlocked && (
                  <div className="mb-4">
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm text-gray-600">
                        {t('levels.progress') || "Progrès"}
                      </span>
                      <span className="text-sm font-medium text-gray-900">
                        {level.completed}/{level.total}
                      </span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div
                        className="bg-gradient-to-r from-blue-500 to-purple-600 h-2 rounded-full transition-all duration-300"
                        style={{ width: `${level.progress}%` }}
                      ></div>
                    </div>
                  </div>
                )}

                {/* Status text */}
                <div className="text-sm font-medium">
                  {level.completed === level.total ? (
                    <span className="text-green-600">{t('levels.completed') || "✅ Terminé !"}</span>
                  ) : !level.unlocked ? (
                    <span className="text-gray-500">{t('levels.locked') || "🔒 Verrouillé"}</span>
                  ) : (
                    <span className="text-blue-600">{t('levels.unlocked') || "🔓 Débloqué"}</span>
                  )}
                </div>
              </div>
            ))}
          </div>

          {/* Opérations */}
          <div className="mb-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-6">
              {t('operations.choose') || "Choisis ton opération"}
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {operations.map((operation) => (
              <div
                key={operation.id}
                className="group bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 cursor-pointer"
              >
                <div className={`w-16 h-16 bg-gradient-to-br ${operation.color} rounded-xl flex items-center justify-center text-2xl text-white mb-4 group-hover:scale-110 transition-transform`}>
                  {operation.icon}
                </div>
                
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  {operation.name}
                </h3>
                
                <p className="text-gray-600 mb-4">
                  {operation.description}
                </p>
                
                <div className="flex items-center text-blue-600 font-medium">
                  <Play className="w-4 h-4 mr-2" />
                  Commencer
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}