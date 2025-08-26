'use client';

export default function ExercisesPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">🎯 Hub d'Exercices Math4Child</h1>
          <p className="text-2xl mb-4">4 Modes d'apprentissage révolutionnaires</p>
          <div className="bg-green-500 text-white px-6 py-2 rounded-full inline-block">
            ✨ 6 Innovations Mondiales Opérationnelles ✨
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
          <div className="bg-blue-900/50 border border-blue-500/20 rounded-2xl p-6 hover:scale-105 transition-all">
            <div className="text-6xl mb-4 text-center">🔢</div>
            <h2 className="text-2xl font-bold mb-3 text-center">Mode Classique</h2>
            <p className="text-gray-300 mb-4 text-center text-sm">Interface traditionnelle optimisée</p>
            <a href="/exercises/addition" className="block w-full py-3 bg-blue-600 hover:bg-blue-700 text-center rounded-lg font-semibold transition-colors">
              Commencer
            </a>
          </div>
          
          <div className="bg-green-900/50 border border-green-500/20 rounded-2xl p-6 hover:scale-105 transition-all">
            <div className="text-6xl mb-4 text-center">✏️</div>
            <h2 className="text-2xl font-bold mb-3 text-center">Mode Manuscrit</h2>
            <div className="bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-bold text-center mb-3">
              🌟 INNOVATION MONDIALE
            </div>
            <p className="text-gray-300 mb-4 text-center text-sm">Reconnaissance IA manuscrite</p>
            <a href="/exercises/handwriting" className="block w-full py-3 bg-green-600 hover:bg-green-700 text-center rounded-lg font-semibold transition-colors">
              ✏️ Écrire
            </a>
          </div>
          
          <div className="bg-purple-900/50 border border-purple-500/20 rounded-2xl p-6 hover:scale-105 transition-all">
            <div className="text-6xl mb-4 text-center">🎙️</div>
            <h2 className="text-2xl font-bold mb-3 text-center">Mode Vocal IA</h2>
            <div className="bg-pink-400 text-pink-900 px-2 py-1 rounded-full text-xs font-bold text-center mb-3">
              🚀 PREMIÈRE ÉDUCATIVE
            </div>
            <p className="text-gray-300 mb-4 text-center text-sm">Assistant vocal 3 personnalités</p>
            <a href="/exercises/voice" className="block w-full py-3 bg-purple-600 hover:bg-purple-700 text-center rounded-lg font-semibold transition-colors">
              🎙️ Parler
            </a>
          </div>
          
          <div className="bg-orange-900/50 border border-orange-500/20 rounded-2xl p-6 hover:scale-105 transition-all">
            <div className="text-6xl mb-4 text-center">🥽</div>
            <h2 className="text-2xl font-bold mb-3 text-center">Réalité 3D</h2>
            <div className="bg-red-400 text-red-900 px-2 py-1 rounded-full text-xs font-bold text-center mb-3">
              🔥 RÉVOLUTION PÉDAGOGIQUE
            </div>
            <p className="text-gray-300 mb-4 text-center text-sm">Visualisation immersive WebGL</p>
            <a href="/exercises/ar3d" className="block w-full py-3 bg-orange-600 hover:bg-orange-700 text-center rounded-lg font-semibold transition-colors">
              🥽 Explorer 3D
            </a>
          </div>
        </div>

        <div className="text-center">
          <div className="bg-black/30 backdrop-blur rounded-2xl p-8 max-w-2xl mx-auto">
            <h2 className="text-3xl font-bold mb-4">🌍 6 Innovations Révolutionnaires</h2>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div className="text-blue-400">✏️ Reconnaissance Manuscrite IA</div>
              <div className="text-purple-400">🎙️ Assistant Vocal Multi-Personnalités</div>
              <div className="text-green-400">🌿 Détection Branche Temps Réel</div>
              <div className="text-orange-400">🥽 Réalité Augmentée 3D WebGL</div>
              <div className="text-pink-400">🧠 IA Adaptative Personnalisée</div>
              <div className="text-cyan-400">🌍 Support 200+ Langues</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
