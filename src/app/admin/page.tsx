"use client"

import { useState } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageDropdown from '@/components/ui/LanguageDropdown'
import { 
  Shield, 
  Users, 
  BarChart3, 
  Settings,
  Database,
  AlertTriangle,
  CheckCircle,
  XCircle,
  TrendingUp,
  Globe,
  CreditCard,
  BookOpen
} from 'lucide-react'

export default function AdminPage() {
  const { t } = useLanguage()
  const [activeTab, setActiveTab] = useState('overview')

  // Données simulées d'administration
  const stats = {
    totalUsers: 150847,
    activeSubscriptions: 23456,
    totalRevenue: 87432,
    exercisesCompleted: 2847593
  }

  const recentUsers = [
    { name: 'Famille Martin', email: 'martin@email.com', plan: 'PREMIUM', status: 'active', joined: '2024-08-15' },
    { name: 'École Primaire Dupont', email: 'ecole@dupont.fr', plan: 'ULTIMATE', status: 'active', joined: '2024-08-14' },
    { name: 'Famille Schmidt', email: 'schmidt@email.de', plan: 'STANDARD', status: 'trial', joined: '2024-08-13' }
  ]

  const systemHealth = [
    { service: 'API Principal', status: 'healthy', uptime: '99.9%' },
    { service: 'Base de Données', status: 'healthy', uptime: '99.8%' },
    { service: 'IA Adaptative', status: 'warning', uptime: '98.2%' },
    { service: 'Paiements Stripe', status: 'healthy', uptime: '99.9%' }
  ]

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'healthy': return <CheckCircle className="w-5 h-5 text-green-500" />
      case 'warning': return <AlertTriangle className="w-5 h-5 text-yellow-500" />
      case 'error': return <XCircle className="w-5 h-5 text-red-500" />
      default: return <AlertTriangle className="w-5 h-5 text-gray-500" />
    }
  }

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Header Admin */}
      <header className="bg-gray-900 text-white shadow-lg">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-4">
              <Shield className="w-8 h-8 text-red-500" />
              <div>
                <h1 className="text-xl font-bold">Admin Math4Child v4.2.0</h1>
                <p className="text-sm text-gray-300">Panneau d'Administration</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              <Link href="/" className="text-gray-300 hover:text-white">
                Retour au site
              </Link>
              <LanguageDropdown />
            </div>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        {/* Navigation par onglets */}
        <div className="bg-white rounded-lg shadow-lg mb-8">
          <div className="border-b">
            <nav className="flex space-x-8 px-6">
              {[
                { id: 'overview', name: 'Vue d\'ensemble', icon: BarChart3 },
                { id: 'users', name: 'Utilisateurs', icon: Users },
                { id: 'system', name: 'Système', icon: Database },
                { id: 'settings', name: 'Paramètres', icon: Settings }
              ].map(tab => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center space-x-2 py-4 border-b-2 transition-colors ${
                    activeTab === tab.id 
                      ? 'border-blue-500 text-blue-600' 
                      : 'border-transparent text-gray-600 hover:text-blue-600'
                  }`}
                >
                  <tab.icon className="w-5 h-5" />
                  <span>{tab.name}</span>
                </button>
              ))}
            </nav>
          </div>

          <div className="p-6">
            {/* Vue d'ensemble */}
            {activeTab === 'overview' && (
              <div>
                <h2 className="text-2xl font-bold text-gray-800 mb-6">Tableau de Bord Administrateur</h2>
                
                {/* Statistiques principales */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                  <div className="bg-gradient-to-r from-blue-500 to-blue-600 p-6 rounded-xl text-white">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-blue-100">Utilisateurs Total</p>
                        <p className="text-3xl font-bold">{stats.totalUsers.toLocaleString()}</p>
                      </div>
                      <Users className="w-8 h-8 text-blue-200" />
                    </div>
                  </div>
                  
                  <div className="bg-gradient-to-r from-green-500 to-green-600 p-6 rounded-xl text-white">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-green-100">Abonnements Actifs</p>
                        <p className="text-3xl font-bold">{stats.activeSubscriptions.toLocaleString()}</p>
                      </div>
                      <CreditCard className="w-8 h-8 text-green-200" />
                    </div>
                  </div>
                  
                  <div className="bg-gradient-to-r from-purple-500 to-purple-600 p-6 rounded-xl text-white">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-purple-100">Revenus (€)</p>
                        <p className="text-3xl font-bold">{stats.totalRevenue.toLocaleString()}</p>
                      </div>
                      <TrendingUp className="w-8 h-8 text-purple-200" />
                    </div>
                  </div>
                  
                  <div className="bg-gradient-to-r from-orange-500 to-orange-600 p-6 rounded-xl text-white">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-orange-100">Exercices Complétés</p>
                        <p className="text-3xl font-bold">{(stats.exercisesCompleted / 1000000).toFixed(1)}M</p>
                      </div>
                      <BookOpen className="w-8 h-8 text-orange-200" />
                    </div>
                  </div>
                </div>

                {/* État du système */}
                <div className="bg-gray-50 p-6 rounded-xl">
                  <h3 className="text-lg font-bold text-gray-800 mb-4">État du Système</h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {systemHealth.map((service, index) => (
                      <div key={index} className="flex items-center justify-between p-4 bg-white rounded-lg">
                        <div className="flex items-center space-x-3">
                          {getStatusIcon(service.status)}
                          <span className="font-medium">{service.service}</span>
                        </div>
                        <span className="text-sm text-gray-600">{service.uptime}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* Utilisateurs */}
            {activeTab === 'users' && (
              <div>
                <h2 className="text-2xl font-bold text-gray-800 mb-6">Gestion des Utilisateurs</h2>
                
                <div className="bg-white rounded-lg border">
                  <div className="px-6 py-4 border-b">
                    <h3 className="text-lg font-semibold">Utilisateurs Récents</h3>
                  </div>
                  
                  <div className="divide-y">
                    {recentUsers.map((user, index) => (
                      <div key={index} className="px-6 py-4 flex items-center justify-between">
                        <div>
                          <p className="font-medium">{user.name}</p>
                          <p className="text-sm text-gray-600">{user.email}</p>
                        </div>
                        <div className="text-right">
                          <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                            user.plan === 'PREMIUM' ? 'bg-purple-100 text-purple-800' :
                            user.plan === 'ULTIMATE' ? 'bg-orange-100 text-orange-800' :
                            'bg-blue-100 text-blue-800'
                          }`}>
                            {user.plan}
                          </span>
                          <p className="text-sm text-gray-600 mt-1">{user.joined}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* Autres onglets */}
            {activeTab === 'system' && (
              <div>
                <h2 className="text-2xl font-bold text-gray-800 mb-6">Surveillance Système</h2>
                <p className="text-gray-600">Monitoring des services Math4Child v4.2.0 en temps réel...</p>
              </div>
            )}

            {activeTab === 'settings' && (
              <div>
                <h2 className="text-2xl font-bold text-gray-800 mb-6">Paramètres Globaux</h2>
                <p className="text-gray-600">Configuration de la plateforme Math4Child...</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
