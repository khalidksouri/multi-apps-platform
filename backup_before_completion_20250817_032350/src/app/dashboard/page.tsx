"use client"

import { useState } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageDropdown from '@/components/ui/LanguageDropdown'
import { 
  BookOpen, 
  TrendingUp, 
  Award, 
  Users, 
  Calendar,
  BarChart3,
  Settings,
  Home,
  PlayCircle
} from 'lucide-react'

export default function DashboardPage() {
  const { t, currentLanguage } = useLanguage()
  const [selectedChild, setSelectedChild] = useState('Emma')

  // Données simulées
  const children = [
    { name: 'Emma', age: 8, level: 3, progress: 75 },
    { name: 'Lucas', age: 6, level: 2, progress: 45 }
  ]

  const recentActivity = [
    { date: '15 Aug', exercise: 'Addition niveau 3', score: 18, total: 20 },
    { date: '14 Aug', exercise: 'Soustraction niveau 2', score: 15, total: 15 },
    { date: '13 Aug', exercise: 'Multiplication niveau 3', score: 12, total: 15 }
  ]

  const stats = {
    totalExercises: 245,
    totalTime: '18h 30min',
    averageScore: 87,
    streak: 12
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-4">
              <Link href="/" className="flex items-center space-x-2">
                <BookOpen className="w-8 h-8 text-blue-600" />
                <span className="text-xl font-bold text-gray-800">Math4Child</span>
                <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">v4.2.0</span>
              </Link>
            </div>
            
            <nav className="hidden md:flex items-center space-x-6">
              <Link href="/dashboard" className="text-blue-600 font-medium">Dashboard</Link>
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600">Exercices</Link>
              <Link href="/pricing" className="text-gray-600 hover:text-blue-600">Plans</Link>
            </nav>

            <LanguageDropdown />
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        {/* Titre et sélecteur d'enfant */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-800 mb-2">
              Tableau de Bord Parental
            </h1>
            <p className="text-gray-600">Suivez les progrès de vos enfants avec Math4Child v4.2.0</p>
          </div>
          
          <select 
            value={selectedChild}
            onChange={(e) => setSelectedChild(e.target.value)}
            className="bg-white border border-gray-300 rounded-lg px-4 py-2 focus:border-blue-500 focus:outline-none"
          >
            {children.map(child => (
              <option key={child.name} value={child.name}>
                {child.name} ({child.age} ans)
              </option>
            ))}
          </select>
        </div>

        {/* Statistiques principales */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Exercices Complétés</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalExercises}</p>
              </div>
              <BookOpen className="w-8 h-8 text-blue-500" />
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Temps Total</p>
                <p className="text-2xl font-bold text-gray-800">{stats.totalTime}</p>
              </div>
              <Calendar className="w-8 h-8 text-green-500" />
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Score Moyen</p>
                <p className="text-2xl font-bold text-gray-800">{stats.averageScore}%</p>
              </div>
              <Award className="w-8 h-8 text-yellow-500" />
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">Série Actuelle</p>
                <p className="text-2xl font-bold text-gray-800">{stats.streak} jours</p>
              </div>
              <TrendingUp className="w-8 h-8 text-purple-500" />
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Progression par enfant */}
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center">
              <Users className="w-5 h-5 mr-2" />
              Progression des Enfants
            </h3>
            
            <div className="space-y-4">
              {children.map(child => (
                <div key={child.name} className="border-l-4 border-blue-500 pl-4">
                  <div className="flex justify-between items-center mb-2">
                    <h4 className="font-semibold">{child.name} ({child.age} ans)</h4>
                    <span className="text-sm text-gray-600">Niveau {child.level}</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div 
                      className="bg-blue-500 h-2 rounded-full transition-all duration-300"
                      style={{ width: `${child.progress}%` }}
                    ></div>
                  </div>
                  <p className="text-sm text-gray-600 mt-1">{child.progress}% complété</p>
                </div>
              ))}
            </div>
          </div>

          {/* Activité récente */}
          <div className="bg-white p-6 rounded-xl shadow-lg">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center">
              <BarChart3 className="w-5 h-5 mr-2" />
              Activité Récente
            </h3>
            
            <div className="space-y-3">
              {recentActivity.map((activity, index) => (
                <div key={index} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                  <div>
                    <p className="font-medium text-gray-800">{activity.exercise}</p>
                    <p className="text-sm text-gray-600">{activity.date}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-green-600">{activity.score}/{activity.total}</p>
                    <p className="text-sm text-gray-600">
                      {Math.round((activity.score / activity.total) * 100)}%
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Actions rapides */}
        <div className="mt-8 bg-white p-6 rounded-xl shadow-lg">
          <h3 className="text-xl font-bold text-gray-800 mb-4">Actions Rapides</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <Link 
              href="/exercises"
              className="flex items-center justify-center space-x-2 bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition-colors"
            >
              <PlayCircle className="w-5 h-5" />
              <span>Commencer un Exercice</span>
            </Link>
            
            <Link 
              href="/pricing"
              className="flex items-center justify-center space-x-2 bg-purple-500 text-white px-6 py-3 rounded-lg hover:bg-purple-600 transition-colors"
            >
              <Award className="w-5 h-5" />
              <span>Voir les Plans</span>
            </Link>
            
            <button className="flex items-center justify-center space-x-2 bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition-colors">
              <Settings className="w-5 h-5" />
              <span>Paramètres</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
