"use client"

import Link from 'next/link'
import { useState } from 'react'
import { BookOpen, Play, Plus, Minus, X, DivideIcon, Shuffle } from 'lucide-react'

export default function ExercisesPage() {
  const [selectedLevel, setSelectedLevel] = useState('debutant')
  const [selectedOperation, setSelectedOperation] = useState('addition')

  // 5 niveaux selon spécifications
  const levels = [
    { id: 'debutant', name: 'Débutant', description: '100 bonnes réponses minimum', unlocked: true },
    { id: 'apprenti', name: 'Apprenti', description: '100 bonnes réponses minimum', unlocked: true },
    { id: 'explorateur', name: 'Explorateur', description: '100 bonnes réponses minimum', unlocked: false },
    { id: 'expert', name: 'Expert', description: '100 bonnes réponses minimum', unlocked: false },
    { id: 'maitre', name: 'Maître', description: '100 bonnes réponses minimum', unlocked: false }
  ]

  // 5 opérations mathématiques selon spécifications
  const operations = [
    { 
      id: 'addition', 
      name: 'Addition', 
      icon: <Plus className="w-6 h-6" />,
      description: 'Apprendre à additionner'
    },
    { 
      id: 'soustraction', 
      name: 'Soustraction', 
      icon: <Minus className="w-6 h-6" />,
      description: 'Apprendre à soustraire'
    },
    { 
      id: 'multiplication', 
      name: 'Multiplication', 
      icon: <X className="w-6 h-6" />,
      description: 'Apprendre à multiplier'
    },
    { 
      id: 'division', 
      name: 'Division', 
      icon: <DivideIcon className="w-6 h-6" />,
      description: 'Apprendre à diviser'
    },
    { 
      id: 'mixte', 
      name: 'Mixte', 
      icon: <Shuffle className="w-6 h-6" />,
      description: 'Mélange de toutes les opérations'
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <Link href="/" className="flex items-center space-x-2">
              <BookOpen className="w-8 h-8 text-blue-600" />
              <span className="text-xl font-bold text-gray-800">Math4Child</span>
              <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">v4.2.0</span>
            </Link>
            
            <nav className="hidden md:flex items-center space-x-6">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition-colors">
                Accueil
              </Link>
              <Link href="/exercises" className="text-blue-600 font-medium">
                Exercices
              </Link>
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600 transition-colors">
                Abonnements
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <div className="container mx-auto px-4 py-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-800 mb-6">
            🎮 Hub Exercices Math4Child
          </h1>
          <p className="text-xl text-gray-600">
            5 Opérations • 5 Niveaux • 3 Modes d'apprentissage
          </p>
        </div>

        {/* Sélection du niveau */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">🎯 Choisis ton niveau</h3>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            {levels.map((level, index) => (
              <button
                key={level.id}
                onClick={() => level.unlocked && setSelectedLevel(level.id)}
                className={`p-4 rounded-xl border-2 transition-all relative ${
                  selectedLevel === level.id 
                    ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-200' 
                    : level.unlocked 
                    ? 'border-gray-200 bg-white hover:border-blue-300' 
                    : 'border-gray-200 bg-gray-100 opacity-50 cursor-not-allowed'
                }`}
              >
                {!level.unlocked && (
                  <div className="absolute top-2 right-2">
                    <span className="text-gray-400">🔒</span>
                  </div>
                )}
                
                <div className="text-center">
                  <div className="text-2xl mb-2">{index + 1}</div>
                  <div className="font-bold text-gray-800">{level.name}</div>
                  <div className="text-sm text-gray-600">{level.description}</div>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Sélection de l'opération - 5 opérations selon spécifications */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">🧮 Choisis une opération</h3>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            {operations.map((operation) => (
              <button
                key={operation.id}
                onClick={() => setSelectedOperation(operation.id)}
                data-operation={operation.id}
                className={`p-4 rounded-xl border-2 transition-all ${
                  selectedOperation === operation.id
                    ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-200'
                    : 'border-gray-200 bg-white hover:border-blue-300'
                }`}
              >
                <div className="text-center">
                  <div className="flex justify-center mb-2 text-blue-600">
                    {operation.icon}
                  </div>
                  <div className="font-bold text-gray-800">{operation.name}</div>
                  <div className="text-sm text-gray-600">{operation.description}</div>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* 3 Modes d'exercices */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">🎮 Choisis ton mode d'exercice</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Mode Classique */}
            <div className="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all">
              <div className="text-center">
                <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Play className="w-8 h-8 text-blue-600" />
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Mode Classique</h4>
                <p className="text-gray-600 mb-4">Exercices traditionnels avec clavier</p>
                <button className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors">
                  Commencer
                </button>
              </div>
            </div>

            {/* Mode Manuscrit */}
            <div className="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all">
              <div className="text-center">
                <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  ✏️
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Écriture Manuscrite</h4>
                <p className="text-gray-600 mb-4">Écris ta réponse à la main</p>
                <button className="bg-purple-500 text-white px-4 py-2 rounded-lg hover:bg-purple-600 transition-colors">
                  Essayer
                </button>
              </div>
            </div>

            {/* Mode AR 3D */}
            <div className="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all">
              <div className="text-center">
                <div className="w-16 h-16 bg-cyan-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  🥽
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Réalité Augmentée 3D</h4>
                <p className="text-gray-600 mb-4">Visualise en 3D</p>
                <button className="bg-cyan-500 text-white px-4 py-2 rounded-lg hover:bg-cyan-600 transition-colors">
                  Explorer
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Statut actuel */}
        <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6 rounded-2xl text-center">
          <h3 className="text-2xl font-bold mb-2">🎯 Configuration actuelle</h3>
          <p className="text-blue-100 mb-4">
            Niveau: {levels.find(l => l.id === selectedLevel)?.name} • 
            Opération: {operations.find(o => o.id === selectedOperation)?.name}
          </p>
          <div className="text-sm opacity-90">
            🌟 Math4Child v4.2.0 - Révolution Éducative Mondiale
          </div>
        </div>
      </div>
    </div>
  )
}
