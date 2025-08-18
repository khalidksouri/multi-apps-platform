import type { Viewport } from 'next'
import { defaultViewport } from '@/lib/viewport'

"use client"

import React from 'react'
import { BarChart3, TrendingUp, Clock, Target, Award, Users } from 'lucide-react'

export default function DashboardPage() {
  const childrenProfiles = [
    {
      name: 'Emma',
      age: 8,
      level: 3,
      progress: 78,
      timeToday: '45 min',
      accuracy: 89,
      streak: 7
    },
    {
      name: 'Lucas',
      age: 6,
      level: 2,
      progress: 45,
      timeToday: '23 min',
      accuracy: 76,
      streak: 3
    }
  ]

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Dashboard Parental</h1>
          <p className="text-gray-600">Suivez les progrès de vos enfants en temps réel</p>
        </div>

        {/* Stats globales */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <div className="flex items-center">
              <Users className="w-8 h-8 text-blue-600" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">2</div>
                <div className="text-sm text-gray-600">Profils actifs</div>
              </div>
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <div className="flex items-center">
              <Clock className="w-8 h-8 text-green-600" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">68 min</div>
                <div className="text-sm text-gray-600">Temps total aujourd'hui</div>
              </div>
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <div className="flex items-center">
              <Target className="w-8 h-8 text-purple-600" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">156</div>
                <div className="text-sm text-gray-600">Exercices cette semaine</div>
              </div>
            </div>
          </div>
          
          <div className="bg-white p-6 rounded-xl shadow-sm">
            <div className="flex items-center">
              <TrendingUp className="w-8 h-8 text-orange-600" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">83%</div>
                <div className="text-sm text-gray-600">Précision moyenne</div>
              </div>
            </div>
          </div>
        </div>

        {/* Profils des enfants */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {childrenProfiles.map((child, index) => (
            <div key={index} className="bg-white rounded-xl shadow-sm p-6">
              <div className="flex items-center mb-6">
                <div className="w-16 h-16 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                  {child.name[0]}
                </div>
                <div className="ml-4">
                  <h3 className="text-xl font-bold text-gray-900">{child.name}</h3>
                  <p className="text-gray-600">{child.age} ans • Niveau {child.level}</p>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-sm font-medium text-gray-700">Progression du niveau</span>
                    <span className="text-sm text-gray-600">{child.progress}%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-3">
                    <div 
                      className="bg-gradient-to-r from-blue-500 to-purple-600 h-3 rounded-full"
                      style={{ width: `${child.progress}%` }}
                    ></div>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-4">
                  <div className="text-center p-3 bg-blue-50 rounded-lg">
                    <div className="text-lg font-bold text-blue-600">{child.timeToday}</div>
                    <div className="text-xs text-blue-600">Temps aujourd'hui</div>
                  </div>
                  <div className="text-center p-3 bg-green-50 rounded-lg">
                    <div className="text-lg font-bold text-green-600">{child.accuracy}%</div>
                    <div className="text-xs text-green-600">Précision</div>
                  </div>
                  <div className="text-center p-3 bg-orange-50 rounded-lg">
                    <div className="text-lg font-bold text-orange-600">{child.streak} 🔥</div>
                    <div className="text-xs text-orange-600">Jours consécutifs</div>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

      </div>
    </div>
  )
}
