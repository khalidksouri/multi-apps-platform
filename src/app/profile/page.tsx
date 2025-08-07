"use client"

import { useState } from 'react'
import { ArrowLeft, User, BarChart, Trophy, Clock, Target, BookOpen } from 'lucide-react'
import Link from 'next/link'

export default function ProfilePage() {
  const [activeTab, setActiveTab] = useState('dashboard')

  const profileData = {
    name: "Emma Dubois",
    age: 8,
    level: 3,
    accuracy: 87,
    correctAnswers: 1089,
    timeSpent: "45h 30m",
    streak: 12,
    badges: ['🌟 Premier niveau', '🎯 100 bonnes réponses', '🔥 Série de 10', '📚 Mathématicien junior']
  }

  const progressData = [
    { level: 'Niveau 1', completed: 100, total: 100, status: 'Terminé' },
    { level: 'Niveau 2', completed: 100, total: 100, status: 'Terminé' },
    { level: 'Niveau 3', completed: 67, total: 100, status: 'En cours' },
    { level: 'Niveau 4', completed: 0, total: 100, status: 'Verrouillé' },
    { level: 'Niveau 5', completed: 0, total: 100, status: 'Verrouillé' }
  ]

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <nav className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
              <span className="text-xl font-bold text-gray-900">Math4Child</span>
            </div>
            
            <div className="hidden md:flex items-center gap-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 transition-colors">Accueil</Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 transition-colors">Exercices</Link>
              <Link href="/profile" className="text-blue-600 font-medium">Profil</Link>
              <Link href="/pricing" className="text-gray-700 hover:text-blue-600 transition-colors">Plans</Link>
            </div>
          </div>
        </div>
      </nav>

      <div className="pt-8 pb-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="mb-8">
            <Link href="/" className="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6">
              <ArrowLeft className="w-4 h-4" />
              Retour à l'accueil
            </Link>
            
            <div className="bg-white rounded-2xl shadow-lg p-8">
              <div className="flex items-center gap-6 mb-6">
                <div className="w-20 h-20 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center">
                  <User className="w-10 h-10 text-white" />
                </div>
                <div>
                  <h1 className="text-3xl font-bold text-gray-900">{profileData.name}</h1>
                  <p className="text-gray-600">{profileData.age} ans • Niveau {profileData.level}</p>
                </div>
              </div>

              {/* Stats Cards */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                <div className="text-center">
                  <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mx-auto mb-3">
                    <Target className="w-6 h-6 text-blue-600" />
                  </div>
                  <div className="text-2xl font-bold text-gray-900">{profileData.accuracy}%</div>
                  <div className="text-sm text-gray-600">Précision</div>
                </div>
                
                <div className="text-center">
                  <div className="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center mx-auto mb-3">
                    <Trophy className="w-6 h-6 text-emerald-600" />
                  </div>
                  <div className="text-2xl font-bold text-gray-900">{profileData.correctAnswers}</div>
                  <div className="text-sm text-gray-600">Bonnes réponses</div>
                </div>
                
                <div className="text-center">
                  <div className="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center mx-auto mb-3">
                    <Clock className="w-6 h-6 text-amber-600" />
                  </div>
                  <div className="text-2xl font-bold text-gray-900">{profileData.timeSpent}</div>
                  <div className="text-sm text-gray-600">Temps passé</div>
                </div>
                
                <div className="text-center">
                  <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center mx-auto mb-3">
                    <BarChart className="w-6 h-6 text-red-600" />
                  </div>
                  <div className="text-2xl font-bold text-gray-900">{profileData.streak}</div>
                  <div className="text-sm text-gray-600">Série actuelle</div>
                </div>
              </div>
            </div>
          </div>

          {/* Tabs */}
          <div className="bg-white rounded-2xl shadow-lg overflow-hidden">
            <div className="border-b border-gray-200">
              <nav className="flex">
                {[
                  { id: 'dashboard', label: 'Dashboard de progression', icon: BarChart },
                  { id: 'badges', label: 'Système de badges', icon: Trophy },
                  { id: 'history', label: 'Historique d\'apprentissage', icon: Clock }
                ].map(tab => (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`flex items-center gap-2 px-6 py-4 border-b-2 font-medium text-sm transition-colors ${
                      activeTab === tab.id
                        ? 'border-blue-500 text-blue-600'
                        : 'border-transparent text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    <tab.icon className="w-4 h-4" />
                    {tab.label}
                  </button>
                ))}
              </nav>
            </div>

            <div className="p-8">
              {activeTab === 'dashboard' && (
                <div>
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">Dashboard de progression</h3>
                  <div className="space-y-4">
                    {progressData.map((level, index) => (
                      <div key={index} className="bg-gray-50 rounded-xl p-6">
                        <div className="flex justify-between items-center mb-3">
                          <h4 className="font-semibold text-gray-900">{level.level}</h4>
                          <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                            level.status === 'Terminé' ? 'bg-green-100 text-green-700' :
                            level.status === 'En cours' ? 'bg-blue-100 text-blue-700' :
                            'bg-gray-100 text-gray-700'
                          }`}>
                            {level.status}
                          </span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-3">
                          <div 
                            className="bg-gradient-to-r from-blue-500 to-purple-600 h-3 rounded-full transition-all"
                            style={{ width: `${(level.completed / level.total) * 100}%` }}
                          ></div>
                        </div>
                        <div className="mt-2 text-sm text-gray-600">
                          {level.completed}/{level.total} questions complétées
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {activeTab === 'badges' && (
                <div>
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">Système de badges</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {profileData.badges.map((badge, index) => (
                      <div key={index} className="bg-gradient-to-r from-yellow-50 to-amber-50 border border-yellow-200 rounded-xl p-6 flex items-center gap-4">
                        <div className="text-3xl">{badge.split(' ')[0]}</div>
                        <div>
                          <h4 className="font-semibold text-gray-900">{badge.substring(2)}</h4>
                          <p className="text-sm text-gray-600">Badge obtenu</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {activeTab === 'history' && (
                <div>
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">Historique d'apprentissage</h3>
                  <div className="space-y-4">
                    {[
                      { date: 'Aujourd\'hui', activity: 'Niveau 3 - Addition', score: '15/20', time: '12 min' },
                      { date: 'Hier', activity: 'Niveau 3 - Soustraction', score: '18/20', time: '15 min' },
                      { date: '2 jours', activity: 'Niveau 2 - Révision', score: '20/20', time: '10 min' },
                      { date: '3 jours', activity: 'Niveau 3 - Multiplication', score: '16/20', time: '18 min' }
                    ].map((entry, index) => (
                      <div key={index} className="bg-gray-50 rounded-xl p-6 flex justify-between items-center">
                        <div>
                          <h4 className="font-semibold text-gray-900">{entry.activity}</h4>
                          <p className="text-sm text-gray-600">{entry.date}</p>
                        </div>
                        <div className="text-right">
                          <div className="font-semibold text-gray-900">{entry.score}</div>
                          <div className="text-sm text-gray-600">{entry.time}</div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
