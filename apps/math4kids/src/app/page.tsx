'use client'
import React, { useState } from 'react'
import { Crown, Globe, Check, X, Zap } from 'lucide-react'

export default function Math4KidsApp() {
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4">
      <div className="max-w-4xl mx-auto">
        <header className="text-center mb-8">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center space-x-2 bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 text-white">
              <Globe size={20} />
              <span>🇫🇷 Français</span>
            </div>
            <button
              onClick={() => setShowSubscriptionModal(true)}
              className="flex items-center space-x-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-4 py-2 rounded-lg hover:from-yellow-500 hover:to-orange-600 transition-all transform hover:scale-105"
            >
              <Crown size={20} />
              <span>Passer à Premium</span>
            </button>
          </div>
          
          <h1 className="text-5xl font-bold text-white mb-2">Maths4Enfants</h1>
          <p className="text-xl text-white/90 mb-4">Apprends les maths en t&apos;amusant !</p>
          
          {/* Bandeau version gratuite */}
          <div className="bg-yellow-100 border border-yellow-300 rounded-lg p-3 mb-4">
            <p className="text-yellow-800">
              <Zap className="inline mr-1" size={16} />
              Essai gratuit se termine dans 7 jours
            </p>
            <p className="text-sm text-yellow-700">38 questions restantes aujourd&apos;hui</p>
          </div>
          
          {/* Section principale */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-8">
            <h2 className="text-2xl font-bold text-white mb-6">🎮 Math4Kids - Application Complète</h2>
            <div className="grid md:grid-cols-2 gap-4 text-white text-left mb-6">
              <div>✅ Support multilingue (30+ langues)</div>
              <div>✅ 5 niveaux de difficulté</div>
              <div>✅ Système d&apos;abonnement complet</div>
              <div>✅ Version gratuite limitée</div>
              <div>✅ Jeu interactif fonctionnel</div>
              <div>✅ Design ultra-moderne</div>
            </div>
            
            <button 
              onClick={() => setShowSubscriptionModal(true)}
              className="bg-gradient-to-r from-green-400 to-blue-500 text-white px-8 py-4 rounded-xl text-xl font-bold hover:from-green-500 hover:to-blue-600 transition-all transform hover:scale-105 shadow-lg">
              🚀 Voir les Plans d&apos;Abonnement
            </button>
          </div>
        </header>
      </div>
      
      {/* Modal d'abonnement */}
      {showSubscriptionModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl max-w-5xl w-full p-6 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-3xl font-bold text-gray-800">Choisissez votre abonnement Math4Kids</h2>
              <button onClick={() => setShowSubscriptionModal(false)} className="text-gray-500 hover:text-gray-700">
                <X size={24} />
              </button>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              {/* Version Gratuite */}
              <div className="border-2 border-gray-200 rounded-xl p-6">
                <h3 className="text-xl font-bold mb-2">Version Gratuite</h3>
                <div className="text-3xl font-bold text-gray-600 mb-4">0€<span className="text-sm">/7 jours</span></div>
                <ul className="space-y-2 mb-6">
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Niveau débutant seulement</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />50 questions/jour max</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Version web uniquement</li>
                </ul>
                <button className="w-full bg-gray-400 text-white py-2 rounded-lg cursor-not-allowed">
                  Forfait actuel
                </button>
              </div>

              {/* Mensuel */}
              <div className="border-2 border-blue-200 rounded-xl p-6">
                <h3 className="text-xl font-bold mb-2">Mensuel</h3>
                <div className="text-3xl font-bold text-blue-600 mb-4">9,99€<span className="text-sm">/mois</span></div>
                <ul className="space-y-2 mb-6">
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Tous les 5 niveaux</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Accès illimité</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Apps mobiles</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Sans publicité</li>
                </ul>
                <button className="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600">
                  Choisir ce forfait
                </button>
              </div>
              
              {/* Trimestriel */}
              <div className="border-2 border-green-500 rounded-xl p-6 relative">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-bold">ÉCONOMIE 10%</span>
                </div>
                <h3 className="text-xl font-bold mb-2">Trimestriel</h3>
                <div className="text-3xl font-bold text-green-600 mb-4">26,97€<span className="text-sm">/3 mois</span></div>
                <ul className="space-y-2 mb-6">
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Tous les 5 niveaux</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Accès illimité</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Apps mobiles</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Sans publicité</li>
                </ul>
                <button className="w-full bg-green-500 text-white py-2 rounded-lg hover:bg-green-600">
                  Choisir ce forfait
                </button>
              </div>
              
              {/* Annuel */}
              <div className="border-2 border-purple-500 rounded-xl p-6 relative">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-purple-500 text-white px-3 py-1 rounded-full text-sm font-bold">MEILLEUR CHOIX</span>
                </div>
                <div className="absolute -top-3 right-4">
                  <span className="bg-purple-500 text-white px-2 py-1 rounded-full text-xs font-bold">ÉCONOMIE 30%</span>
                </div>
                <h3 className="text-xl font-bold mb-2">Annuel</h3>
                <div className="text-3xl font-bold text-purple-600 mb-4">83,93€<span className="text-sm">/an</span></div>
                <ul className="space-y-2 mb-6">
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Tous les 5 niveaux</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Accès illimité</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Apps mobiles</li>
                  <li className="flex items-center"><Check size={16} className="text-green-500 mr-2" />Sans publicité</li>
                </ul>
                <button className="w-full bg-purple-500 text-white py-2 rounded-lg hover:bg-purple-600">
                  Choisir ce forfait
                </button>
              </div>
            </div>
            
            {/* Section avantages */}
            <div className="mt-8 text-center">
              <p className="text-gray-600 mb-4">🌐 Accès web + 📱 Apps mobiles (iOS & Android) + 🎯 Tous les niveaux</p>
              <p className="text-sm text-gray-500">math4child.com • Disponible sur App Store et Google Play</p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
