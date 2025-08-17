"use client"

import { useState } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageDropdown from '@/components/ui/LanguageDropdown'
import { 
  BookOpen, 
  Play, 
  Star, 
  Trophy,
  Clock,
  Target,
  Zap,
  Brain,
  Volume2,
  Eye,
  Hand,
  Sparkles
} from 'lucide-react'

export default function ExercisesPage() {
  const { t } = useLanguage()
  const [selectedLevel, setSelectedLevel] = useState(1)
  const [selectedOperation, setSelectedOperation] = useState('mixed')
  const [profile, setProfile] = useState({
    name: 'Emma',
    age: 8,
    currentLevel: 3,
    streak: 5,
    totalExercises: 127,
    accuracy: 0.85
  })

  const levels = [
    { 
      id: 1, 
      name: 'Débutant', 
      description: 'Nombres 1-10',
      color: 'from-green-400 to-green-600',
      unlocked: true,
      stars: 3
    },
    { 
      id: 2, 
      name: 'Apprenti', 
      description: 'Nombres 1-20',
      color: 'from-blue-400 to-blue-600',
      unlocked: true,
      stars: 3
    },
    { 
      id: 3, 
      name: 'Explorateur', 
      description: 'Nombres 1-50',
      color: 'from-purple-400 to-purple-600',
      unlocked: true,
      stars: 2
    },
    { 
      id: 4, 
      name: 'Expert', 
      description: 'Nombres 1-100',
      color: 'from-orange-400 to-orange-600',
      unlocked: profile.currentLevel >= 4,
      stars: 0
    },
    { 
      id: 5, 
      name: 'Maître', 
      description: 'Nombres 1-1000',
      color: 'from-red-400 to-red-600',
      unlocked: profile.currentLevel >= 5,
      stars: 0
    }
  ]

  const operations = [
    { id: 'mixed', name: 'Mélangé', icon: '🎲', description: 'Toutes les opérations' },
    { id: 'addition', name: 'Addition', icon: '➕', description: 'Apprendre à additionner' },
    { id: 'subtraction', name: 'Soustraction', icon: '➖', description: 'Apprendre à soustraire' },
    { id: 'multiplication', name: 'Multiplication', icon: '✖️', description: 'Tables de multiplication' },
    { id: 'division', name: 'Division', icon: '➗', description: 'Apprendre à diviser' }
  ]

  const innovations = [
    {
      title: "🤖 IA Adaptative",
      description: "S'adapte automatiquement au niveau de l'enfant",
      active: true
    },
    {
      title: "✍️ Reconnaissance Manuscrite", 
      description: "Écris la réponse à la main sur l'écran",
      active: true
    },
    {
      title: "🥽 Réalité Augmentée 3D",
      description: "Visualise les mathématiques en 3D",
      active: profile.currentLevel >= 3
    },
    {
      title: "🗣️ Assistant Vocal IA",
      description: "Aide vocale intelligente",
      active: profile.currentLevel >= 2
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
              <Link href="/" className="text-gray-600 hover:text-blue-600">Accueil</Link>
              <Link href="/exercises" className="text-blue-600 font-medium">Exercices</Link>
              <Link href="/dashboard" className="text-gray-600 hover:text-blue-600">Dashboard</Link>
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600">Plans</Link>
            </nav>

            <LanguageDropdown />
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        {/* Profil utilisateur */}
        <div className="bg-white rounded-2xl shadow-lg p-6 mb-8">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="w-16 h-16 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-xl">
                {profile.name.charAt(0)}
              </div>
              <div>
                <h2 className="text-2xl font-bold text-gray-800">{profile.name}</h2>
                <p className="text-gray-600">{profile.age} ans • Niveau {profile.currentLevel}</p>
              </div>
            </div>
            
            <div className="flex space-x-6 text-center">
              <div>
                <div className="text-2xl font-bold text-orange-500">{profile.streak}</div>
                <div className="text-sm text-gray-600">Jours consécutifs</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-blue-500">{profile.totalExercises}</div>
                <div className="text-sm text-gray-600">Exercices</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-green-500">{Math.round(profile.accuracy * 100)}%</div>
                <div className="text-sm text-gray-600">Précision</div>
              </div>
            </div>
          </div>
        </div>

        {/* Sélection du niveau */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">Choisis ton niveau</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            {levels.map((level) => (
              <button
                key={level.id}
                onClick={() => setSelectedLevel(level.id)}
                disabled={!level.unlocked}
                className={`relative p-6 rounded-xl transition-all ${
                  selectedLevel === level.id 
                    ? 'ring-2 ring-blue-500 transform scale-105' 
                    : ''
                } ${
                  level.unlocked 
                    ? 'bg-gradient-to-br ' + level.color + ' text-white hover:transform hover:scale-105' 
                    : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                }`}
              >
                {!level.unlocked && (
                  <div className="absolute inset-0 bg-black bg-opacity-50 rounded-xl flex items-center justify-center">
                    <span className="text-white font-bold">🔒</span>
                  </div>
                )}
                
                <div className="text-center">
                  <div className="text-lg font-bold mb-1">{level.name}</div>
                  <div className="text-sm opacity-90 mb-2">{level.description}</div>
                  
                  {level.unlocked && (
                    <div className="flex justify-center space-x-1">
                      {[...Array(3)].map((_, i) => (
                        <Star 
                          key={i} 
                          className={`w-4 h-4 ${
                            i < level.stars ? 'text-yellow-300 fill-current' : 'text-white opacity-50'
                          }`} 
                        />
                      ))}
                    </div>
                  )}
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Sélection de l'opération */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">Choisis une opération</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            {operations.map((operation) => (
              <button
                key={operation.id}
                onClick={() => setSelectedOperation(operation.id)}
                className={`p-4 rounded-xl border-2 transition-all ${
                  selectedOperation === operation.id
                    ? 'border-blue-500 bg-blue-50'
                    : 'border-gray-200 bg-white hover:border-blue-300'
                }`}
              >
                <div className="text-center">
                  <div className="text-3xl mb-2">{operation.icon}</div>
                  <div className="font-bold text-gray-800">{operation.name}</div>
                  <div className="text-sm text-gray-600">{operation.description}</div>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Innovations révolutionnaires */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">
            🌟 6 Innovations Révolutionnaires
          </h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {innovations.map((innovation, index) => (
              <div 
                key={index}
                className={`p-4 rounded-xl border-2 ${
                  innovation.active 
                    ? 'border-green-300 bg-green-50' 
                    : 'border-gray-300 bg-gray-50'
                }`}
              >
                <div className="flex items-center space-x-2 mb-2">
                  <span className="font-bold text-sm">{innovation.title}</span>
                  {innovation.active ? (
                    <span className="text-green-500">✅</span>
                  ) : (
                    <span className="text-gray-400">🔒</span>
                  )}
                </div>
                <p className="text-xs text-gray-600">{innovation.description}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Modes d'exercices */}
        <div className="mb-8">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">Choisis ton mode d'exercice</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Mode Classique */}
            <Link 
              href={`/exercises/${selectedLevel}?operation=${selectedOperation}`}
              className="group bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all transform hover:scale-105"
            >
              <div className="text-center">
                <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Play className="w-8 h-8 text-blue-600" />
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Mode Classique</h4>
                <p className="text-gray-600 mb-4">Exercices traditionnels avec clavier</p>
                <div className="bg-blue-500 text-white px-4 py-2 rounded-lg group-hover:bg-blue-600 transition-colors">
                  Commencer
                </div>
              </div>
            </Link>

            {/* Mode Manuscrit */}
            <Link 
              href={`/exercises/${selectedLevel}/handwriting?operation=${selectedOperation}`}
              className="group bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all transform hover:scale-105"
            >
              <div className="text-center">
                <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Hand className="w-8 h-8 text-purple-600" />
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Écriture Manuscrite</h4>
                <p className="text-gray-600 mb-4">Écris ta réponse à la main ✍️</p>
                <div className="bg-purple-500 text-white px-4 py-2 rounded-lg group-hover:bg-purple-600 transition-colors">
                  Essayer
                </div>
              </div>
            </Link>

            {/* Mode 3D */}
            <Link 
              href={`/exercises/${selectedLevel}/ar3d?operation=${selectedOperation}`}
              className="group bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all transform hover:scale-105"
            >
              <div className="text-center">
                <div className="w-16 h-16 bg-cyan-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Eye className="w-8 h-8 text-cyan-600" />
                </div>
                <h4 className="text-xl font-bold text-gray-800 mb-2">Réalité Augmentée 3D</h4>
                <p className="text-gray-600 mb-4">Visualise en 3D 🥽</p>
                <div className="bg-cyan-500 text-white px-4 py-2 rounded-lg group-hover:bg-cyan-600 transition-colors">
                  Explorer
                </div>
              </div>
            </Link>
          </div>
        </div>

        {/* Statistiques de session */}
        <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6 rounded-2xl">
          <div className="text-center">
            <h3 className="text-2xl font-bold mb-2">🎯 Prêt pour l'aventure ?</h3>
            <p className="text-blue-100 mb-4">
              Niveau {selectedLevel} • {operations.find(op => op.id === selectedOperation)?.name} • IA Adaptative activée
            </p>
            <div className="text-sm opacity-90">
              🌟 Math4Child v4.2.0 - Révolution Éducative Mondiale
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
