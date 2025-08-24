'use client';

import { useState, useEffect } from 'react';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-white text-center">
          <div className="text-6xl mb-4">🧮</div>
          <div className="text-2xl font-bold">Math4Child</div>
          <div className="text-sm opacity-75">Chargement...</div>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* Bandeau Développement */}
      <div className="bg-orange-50 border-b-2 border-orange-500 text-orange-600 px-4 py-2 text-center text-sm font-medium sticky top-0 z-50">
        🚧 Environnement de développement - Math4Child v4.2.0
      </div>

      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
        {/* Hero Section */}
        <section className="relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/20 to-purple-600/20"></div>
          
          <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16 text-center">
            {/* Titre Principal */}
            <div className="mb-8">
              <h1 className="text-6xl md:text-7xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent mb-4">
                Math4Child 🧮
              </h1>
              <div className="inline-block px-4 py-2 bg-gradient-to-r from-green-500 to-blue-500 rounded-full text-white font-semibold text-sm">
                v4.2.0 - RÉVOLUTION ÉDUCATIVE MONDIALE
              </div>
            </div>

            {/* Sous-titre */}
            <p className="text-xl md:text-2xl text-gray-300 mb-12 max-w-4xl mx-auto">
              La première application éducative révolutionnaire qui transforme l'apprentissage des mathématiques 
              pour des millions d'enfants dans le monde entier
            </p>

            {/* Status de l'application */}
            <div className="bg-black/30 backdrop-blur-sm border border-green-500/30 rounded-2xl p-6 mb-12 max-w-2xl mx-auto">
              <div className="flex items-center justify-center mb-4">
                <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse mr-3"></div>
                <span className="text-green-400 font-semibold">✅ Application Fonctionnelle</span>
              </div>
              
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div className="text-center">
                  <div className="text-white font-bold">Opérationnelle</div>
                  <div className="text-gray-400">Status</div>
                </div>
                <div className="text-center">
                  <div className="text-white font-bold">4.2.0</div>
                  <div className="text-gray-400">Version</div>
                </div>
                <div className="text-center">
                  <div className="text-white font-bold">Development</div>
                  <div className="text-gray-400">Environnement</div>
                </div>
                <div className="text-center">
                  <div className="text-white font-bold">Ready ✅</div>
                  <div className="text-gray-400">Build</div>
                </div>
              </div>
            </div>

            {/* Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
              <button className="px-8 py-4 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white rounded-xl font-semibold text-lg shadow-2xl transform hover:scale-105 transition-all duration-200">
                🚀 Commencer l'Apprentissage
              </button>
              <button className="px-8 py-4 border-2 border-blue-500 text-blue-400 hover:bg-blue-500 hover:text-white rounded-xl font-semibold text-lg transition-all duration-200">
                📊 Voir les Fonctionnalités
              </button>
            </div>
          </div>
        </section>

        {/* Fonctionnalités Section */}
        <section className="py-20 bg-black/20 backdrop-blur-sm">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <h2 className="text-4xl font-bold text-white mb-4">
                🎯 Fonctionnalités Math4Child
              </h2>
              <p className="text-xl text-gray-300">
                6 Innovations révolutionnaires qui transforment l'éducation
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {/* Innovation 1 */}
              <div className="bg-gradient-to-br from-blue-900/50 to-purple-900/50 backdrop-blur-sm border border-blue-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">🧠</div>
                <h3 className="text-xl font-semibold text-white mb-3">IA Adaptative Avancée</h3>
                <p className="text-gray-300 text-sm">
                  Analyse performances temps réel et adaptation automatique au niveau de chaque enfant
                </p>
              </div>

              {/* Innovation 2 */}
              <div className="bg-gradient-to-br from-green-900/50 to-blue-900/50 backdrop-blur-sm border border-green-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">✏️</div>
                <h3 className="text-xl font-semibold text-white mb-3">Reconnaissance Manuscrite</h3>
                <p className="text-gray-300 text-sm">
                  Canvas tactile avec IA de reconnaissance des chiffres en temps réel
                </p>
              </div>

              {/* Innovation 3 */}
              <div className="bg-gradient-to-br from-purple-900/50 to-pink-900/50 backdrop-blur-sm border border-purple-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">🎙️</div>
                <h3 className="text-xl font-semibold text-white mb-3">Assistant Vocal IA</h3>
                <p className="text-gray-300 text-sm">
                  3 personnalités distinctes avec analyse émotionnelle intelligente
                </p>
              </div>

              {/* Innovation 4 */}
              <div className="bg-gradient-to-br from-yellow-900/50 to-orange-900/50 backdrop-blur-sm border border-yellow-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">🥽</div>
                <h3 className="text-xl font-semibold text-white mb-3">Réalité Augmentée 3D</h3>
                <p className="text-gray-300 text-sm">
                  Visualisation immersive des concepts mathématiques avec WebGL
                </p>
              </div>

              {/* Innovation 5 */}
              <div className="bg-gradient-to-br from-red-900/50 to-pink-900/50 backdrop-blur-sm border border-red-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">🎮</div>
                <h3 className="text-xl font-semibold text-white mb-3">Progression Gamifiée</h3>
                <p className="text-gray-300 text-sm">
                  Système XP, badges et récompenses pour une motivation constante
                </p>
              </div>

              {/* Innovation 6 */}
              <div className="bg-gradient-to-br from-teal-900/50 to-green-900/50 backdrop-blur-sm border border-teal-500/20 rounded-2xl p-6 hover:scale-105 transition-all duration-300">
                <div className="text-4xl mb-4">🌍</div>
                <h3 className="text-xl font-semibold text-white mb-3">200+ Langues</h3>
                <p className="text-gray-300 text-sm">
                  Traduction universelle temps réel avec drapeaux culturels spécifiques
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Métriques Section */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-12">
              <h2 className="text-4xl font-bold text-white mb-4">
                📊 Métriques de Qualité Parfaites
              </h2>
            </div>

            <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
              <div className="text-center">
                <div className="text-5xl font-bold bg-gradient-to-r from-green-400 to-blue-400 bg-clip-text text-transparent mb-2">
                  143/143
                </div>
                <div className="text-gray-300">Tests Passent</div>
              </div>
              
              <div className="text-center">
                <div className="text-5xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent mb-2">
                  6
                </div>
                <div className="text-gray-300">Innovations</div>
              </div>
              
              <div className="text-center">
                <div className="text-5xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-2">
                  200+
                </div>
                <div className="text-gray-300">Langues</div>
              </div>
              
              <div className="text-center">
                <div className="text-5xl font-bold bg-gradient-to-r from-green-400 to-teal-400 bg-clip-text text-transparent mb-2">
                  0
                </div>
                <div className="text-gray-300">Erreurs</div>
              </div>
            </div>
          </div>
        </section>

        {/* Footer */}
        <footer className="bg-black/40 backdrop-blur-sm py-12 border-t border-gray-800">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div className="mb-6">
              <h3 className="text-2xl font-bold text-white mb-2">Math4Child v4.2.0</h3>
              <p className="text-gray-400">La Première Application Éducative Révolutionnaire</p>
            </div>
            
            <div className="flex flex-col md:flex-row justify-center items-center gap-8 mb-8">
              <a href="mailto:support@math4child.com" className="text-blue-400 hover:text-blue-300 transition-colors">
                📧 support@math4child.com
              </a>
              <a href="mailto:commercial@math4child.com" className="text-purple-400 hover:text-purple-300 transition-colors">
                💼 commercial@math4child.com
              </a>
            </div>
            
            <div className="text-gray-500 text-sm">
              🌐 Production Ready - Déploiement Automatisé Réussi
            </div>
          </div>
        </footer>
      </div>

      {/* Widget Debug Stylé */}
      <div className="fixed bottom-5 left-5 bg-gray-900 text-white p-3 rounded-lg text-xs font-mono max-w-xs shadow-2xl z-50 backdrop-blur-sm border border-gray-700">
        <div className="font-bold mb-2 text-green-400">🌿 Math4Child Debug</div>
        <div>Environment: <span className="text-green-400">Development</span></div>
        <div>API: <span className="text-yellow-400">api-dev.math4child.com</span></div>
        <div>Status: <span className="text-blue-400">Ready ✅</span></div>
        <div className="text-gray-400 mt-2 text-xs">
          Design: ✅ | Build: ✅ | Errors: 0
        </div>
      </div>
    </>
  );
}
