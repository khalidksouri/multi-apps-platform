"use client"

import React, { useState } from 'react'
import { User, Settings, Trophy, Target, Clock, TrendingUp } from 'lucide-react'

export default function ProfilePage() {
  const [activeTab, setActiveTab] = useState('stats')

  const userStats = {
    name: 'Emma',
    age: 8,
    level: 3,
    totalPoints: 2847,
    streak: 7,
    accuracy: 89,
    timeSpent: '45h 23min',
    exercisesCompleted: 1247,
    badges: ['🌟', '🔥', '🎯', '🏆', '⚡', '🥇']
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Header Profil */}
        <div className="bg-white rounded-xl shadow-sm p-8 mb-8">
          <div className="flex items-center space-x-6">
            <div className="w-24 h-24 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full flex items-center justify-center text-white text-4xl font-bold">
              {userStats.name[0]}
            </div>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">{userStats.name}</h1>
              <p className="text-gray-600 text-lg">{userStats.age} ans • Niveau {userStats.level}</p>
              <div className="flex items-center space-x-4 mt-2">
                <span className="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm font-medium">
                  Plan PREMIUM
                </span>
                <span className="text-sm text-gray-500">
                  {userStats.badges.join(' ')}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <div className="bg-white rounded-xl shadow-sm mb-8">
          <div className="flex border-b border-gray-200">
            <button
              onClick={() => setActiveTab('stats')}
              className={`px-6 py-4 font-medium ${
                activeTab === 'stats'
                  ? 'text-blue-600 border-b-2 border-blue-600'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              📊 Statistiques
            </button>
            <button
              onClick={() => setActiveTab('achievements')}
              className={`px-6 py-4 font-medium ${
                activeTab === 'achievements'
                  ? 'text-blue-600 border-b-2 border-blue-600'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              🏆 Réussites
            </button>
            <button
              onClick={() => setActiveTab('settings')}
              className={`px-6 py-4 font-medium ${
                activeTab === 'settings'
                  ? 'text-blue-600 border-b-2 border-blue-600'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              ⚙️ Paramètres
            </button>
          </div>

          <div className="p-6">
            {activeTab === 'stats' && (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div className="text-center p-6 bg-blue-50 rounded-xl">
                  <Trophy className="w-8 h-8 text-blue-600 mx-auto mb-3" />
                  <div className="text-2xl font-bold text-blue-800">{userStats.totalPoints}</div>
                  <div className="text-sm text-blue-600">Points totaux</div>
                </div>
                
                <div className="text-center p-6 bg-green-50 rounded-xl">
                  <Target className="w-8 h-8 text-green-600 mx-auto mb-3" />
                  <div className="text-2xl font-bold text-green-800">{userStats.accuracy}%</div>
                  <div className="text-sm text-green-600">Précision</div>
                </div>
                
                <div className="text-center p-6 bg-orange-50 rounded-xl">
                  <Clock className="w-8 h-8 text-orange-600 mx-auto mb-3" />
                  <div className="text-2xl font-bold text-orange-800">{userStats.timeSpent}</div>
                  <div className="text-sm text-orange-600">Temps total</div>
                </div>
                
                <div className="text-center p-6 bg-purple-50 rounded-xl">
                  <TrendingUp className="w-8 h-8 text-purple-600 mx-auto mb-3" />
                  <div className="text-2xl font-bold text-purple-800">{userStats.exercisesCompleted}</div>
                  <div className="text-sm text-purple-600">Exercices</div>
                </div>
              </div>
            )}

            {activeTab === 'achievements' && (
              <div className="space-y-6">
                <h3 className="text-xl font-bold text-gray-900">Badges obtenus</h3>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                  {userStats.badges.map((badge, index) => (
                    <div key={index} className="text-center p-4 bg-gray-50 rounded-xl">
                      <div className="text-4xl mb-2">{badge}</div>
                      <div className="text-xs text-gray-600">Badge #{index + 1}</div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {activeTab === 'settings' && (
              <div className="space-y-6">
                <h3 className="text-xl font-bold text-gray-900">Paramètres du profil</h3>
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Nom du profil
                    </label>
                    <input
                      type="text"
                      value={userStats.name}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Âge
                    </label>
                    <input
                      type="number"
                      value={userStats.age}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Langue préférée
                    </label>
                    <select className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                      <option>🇫🇷 Français</option>
                      <option>🇺🇸 English</option>
                      <option>🇲🇦 العربية (المغرب)</option>
                      <option>🇵🇸 العربية (فلسطين)</option>
                    </select>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  )
}
