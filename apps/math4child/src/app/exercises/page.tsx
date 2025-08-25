'use client';

import { BranchInfoProvider } from '../../components/BranchInfo';

export default function ExercisesPage() {
  return (
    <BranchInfoProvider>
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 text-white pt-20">
        <div className="max-w-7xl mx-auto px-4 py-20">
          <div className="text-center mb-16">
            <h1 className="text-6xl font-bold mb-6 bg-gradient-to-r from-yellow-400 via-pink-500 to-purple-600 bg-clip-text text-transparent">
              🎯 Hub d'Exercices Math4Child
            </h1>
            <p className="text-2xl text-gray-300 mb-4">
              3 Modes d'apprentissage révolutionnaires
            </p>
            <div className="inline-block bg-gradient-to-r from-green-500 to-blue-500 text-white px-6 py-2 rounded-full font-semibold">
              ✨ 6 Innovations Mondiales Opérationnelles ✨
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
            {/* Mode Classique */}
            <div className="group bg-gradient-to-br from-blue-900/50 to-purple-900/50 backdrop-blur-sm border border-blue-500/20 rounded-2xl p-8 hover:scale-105 hover:border-blue-400/50 transition-all duration-300">
              <div className="text-8xl mb-6 text-center group-hover:animate-bounce">📢</div>
              <h2 className="text-3xl font-bold mb-4 text-center">Mode Classique</h2>
              <p className="text-gray-300 mb-6 text-center text-lg">
                Interface traditionnelle optimisée avec clavier numérique intuitif
              </p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">✅</span>
                  Interface ergonomique et accessible
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">✅</span>
                  Feedback immédiat avec explications
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">✅</span>
                  Progression sauvegardée
                </div>
              </div>
              <a 
                href="/exercises/1/addition"
                className="block w-full py-4 bg-blue-600 hover:bg-blue-700 text-center rounded-lg font-semibold text-lg transition-colors shadow-lg"
              >
                Commencer Maintenant
              </a>
            </div>

            {/* Mode Manuscrit - Innovation #2 */}
            <div className="group bg-gradient-to-br from-green-900/50 to-blue-900/50 backdrop-blur-sm border border-green-500/20 rounded-2xl p-8 hover:scale-105 hover:border-green-400/50 transition-all duration-300">
              <div className="text-8xl mb-6 text-center group-hover:animate-pulse">✏️</div>
              <h2 className="text-3xl font-bold mb-4 text-center">Mode Manuscrit</h2>
              <div className="bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-xs font-bold text-center mb-4">
                🌟 INNOVATION MONDIALE
              </div>
              <p className="text-gray-300 mb-6 text-center text-lg">
                Reconnaissance IA de l'écriture manuscrite temps réel
              </p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">🧠</span>
                  IA de reconnaissance avancée
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">📱</span>
                  Support tactile multi-device
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">🎯</span>
                  Pourcentage de confiance
                </div>
              </div>
              <a 
                href="/exercises/1/handwriting"
                className="block w-full py-4 bg-green-600 hover:bg-green-700 text-center rounded-lg font-semibold text-lg transition-colors shadow-lg"
              >
                ✏️ Écrire sa Réponse
              </a>
            </div>

            {/* Mode Vocal IA - Innovation #4 */}
            <div className="group bg-gradient-to-br from-purple-900/50 to-pink-900/50 backdrop-blur-sm border border-purple-500/20 rounded-2xl p-8 hover:scale-105 hover:border-purple-400/50 transition-all duration-300">
              <div className="text-8xl mb-6 text-center group-hover:animate-spin">🎙️</div>
              <h2 className="text-3xl font-bold mb-4 text-center">Mode Vocal IA</h2>
              <div className="bg-pink-400 text-pink-900 px-3 py-1 rounded-full text-xs font-bold text-center mb-4">
                🚀 PREMIÈRE ÉDUCATIVE
              </div>
              <p className="text-gray-300 mb-6 text-center text-lg">
                Assistant vocal intelligent avec 3 personnalités distinctes
              </p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">🎭</span>
                  3 personnalités IA uniques
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">❤️</span>
                  Analyse émotionnelle temps réel
                </div>
                <div className="flex items-center text-sm text-gray-300">
                  <span className="text-green-400 mr-2">🗣️</span>
                  Synthèse vocale adaptative
                </div>
              </div>
              <a 
                href="/exercises/1/voice"
                className="block w-full py-4 bg-purple-600 hover:bg-purple-700 text-center rounded-lg font-semibold text-lg transition-colors shadow-lg"
              >
                🎙️ Parler à l'IA
              </a>
            </div>
          </div>

          {/* Réalité Augmentée 3D - Innovation #3 */}
          <div className="text-center mb-16">
            <div className="group bg-gradient-to-br from-orange-900/50 to-red-900/50 backdrop-blur-sm border border-orange-500/20 rounded-2xl p-12 max-w-3xl mx-auto hover:scale-105 hover:border-orange-400/50 transition-all duration-300">
              <div className="text-8xl mb-6 group-hover:animate-bounce">🥽</div>
              <h2 className="text-4xl font-bold mb-4">Réalité Augmentée 3D</h2>
              <div className="bg-red-400 text-red-900 px-4 py-2 rounded-full text-sm font-bold inline-block mb-6">
                🔥 RÉVOLUTION PÉDAGOGIQUE
              </div>
              <p className="text-gray-300 mb-8 text-xl">
                Visualisation immersive des concepts mathématiques en 3D WebGL
              </p>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                <div className="bg-black/30 p-4 rounded-lg">
                  <div className="text-2xl mb-2">🎮</div>
                  <p className="text-sm text-gray-300">Manipulation interactive</p>
                </div>
                <div className="bg-black/30 p-4 rounded-lg">
                  <div className="text-2xl mb-2">🌐</div>
                  <p className="text-sm text-gray-300">Environnement WebGL</p>
                </div>
                <div className="bg-black/30 p-4 rounded-lg">
                  <div className="text-2xl mb-2">🧮</div>
                  <p className="text-sm text-gray-300">Géométrie interactive</p>
                </div>
              </div>
              <a 
                href="/exercises/1/ar3d"
                className="inline-block px-12 py-4 bg-orange-600 hover:bg-orange-700 rounded-lg font-semibold text-xl transition-colors shadow-lg"
              >
                🥽 Explorer en 3D
              </a>
            </div>
          </div>

          {/* Stats et Niveaux */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="bg-gradient-to-br from-indigo-900/50 to-blue-900/50 backdrop-blur-sm border border-indigo-500/20 rounded-2xl p-8">
              <h3 className="text-2xl font-bold mb-6 text-center">📊 Progression</h3>
              <div className="space-y-4">
                {[1, 2, 3, 4, 5].map((level) => (
                  <div key={level} className="flex items-center justify-between">
                    <span className="font-semibold">Niveau {level}</span>
                    <div className="w-32 bg-gray-700 rounded-full h-2">
                      <div 
                        className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full" 
                        style={{ width: `${Math.random() * 100}%` }}
                      ></div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
            
            <div className="bg-gradient-to-br from-purple-900/50 to-pink-900/50 backdrop-blur-sm border border-purple-500/20 rounded-2xl p-8">
              <h3 className="text-2xl font-bold mb-6 text-center">🏆 Innovations</h3>
              <div className="space-y-3">
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>IA Adaptative Avancée</span>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>Reconnaissance Manuscrite</span>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>Réalité Augmentée 3D</span>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>Assistant Vocal IA</span>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>Progression Gamifiée</span>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3">✅</span>
                  <span>Traduction Universelle</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </BranchInfoProvider>
  );
}
