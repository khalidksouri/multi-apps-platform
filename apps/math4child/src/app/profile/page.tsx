"use client"

import Navigation from '@/components/navigation/Navigation'

export default function ProfilePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <Navigation />
      <div className="container mx-auto px-4 py-16">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            👤 Profil Utilisateur
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Votre progression et statistiques Math4Child v4.2.0
          </p>
          
          <div className="bg-white rounded-xl shadow-lg p-8 max-w-2xl mx-auto">
            <div className="mb-6">
              <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-3xl text-white mx-auto mb-4">
                🌟
              </div>
              <h2 className="text-2xl font-bold text-gray-800">Petit Génie</h2>
              <p className="text-gray-600">Utilisateur Premium</p>
            </div>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
              <div className="text-center">
                <div className="text-2xl font-bold text-blue-600">156</div>
                <div className="text-sm text-gray-600">Questions</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-green-600">89%</div>
                <div className="text-sm text-gray-600">Précision</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-purple-600">23</div>
                <div className="text-sm text-gray-600">Série</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-orange-600">3</div>
                <div className="text-sm text-gray-600">Niveaux</div>
              </div>
            </div>
            
            <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg p-4">
              <h3 className="font-bold text-gray-800 mb-2">🏆 Prochains Objectifs</h3>
              <ul className="text-sm text-gray-600 space-y-1">
                <li>• Terminer le niveau 3 (73/100 bonnes réponses)</li>
                <li>• Débloquer l'innovation Réalité Augmentée</li>
                <li>• Atteindre une série de 30 bonnes réponses</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
