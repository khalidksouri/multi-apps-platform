'use client';

import { useState, useEffect } from 'react';

export default function ExercisesPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div className="min-h-screen flex items-center justify-center">Chargement...</div>;

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
          <button 
            type="button"
            onClick={() => window.location.href = '/exercises/addition'}
            className="bg-blue-900/50 border border-blue-500/20 rounded-2xl p-6 text-center hover:scale-105 transition-all cursor-pointer"
          >
            <div className="text-6xl mb-4">🔢</div>
            <h2 className="text-2xl font-bold mb-3">Mode Classique</h2>
            <p className="text-gray-300 text-sm mb-4">Interface traditionnelle optimisée</p>
            <div className="text-green-400 text-sm">✅ Interface ergonomique</div>
            <div className="text-green-400 text-sm">✅ Feedback immédiat</div>
            <div className="text-green-400 text-sm">✅ Progression sauvegardée</div>
          </button>
          
          <button 
            type="button"
            onClick={() => window.location.href = '/exercises/handwriting'}
            className="bg-green-900/50 border border-green-500/20 rounded-2xl p-6 text-center hover:scale-105 transition-all cursor-pointer"
          >
            <div className="text-6xl mb-4">✏️</div>
            <h2 className="text-2xl font-bold mb-3">Mode Manuscrit</h2>
            <div className="bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-bold mb-3">
              🌟 INNOVATION MONDIALE
            </div>
            <p className="text-gray-300 text-sm mb-4">Reconnaissance IA manuscrite</p>
            <div className="text-green-400 text-sm">🧠 IA reconnaissance avancée</div>
            <div className="text-green-400 text-sm">📱 Support tactile multi-device</div>
            <div className="text-green-400 text-sm">📊 Pourcentage de confiance</div>
          </button>
          
          <button 
            type="button"
            onClick={() => window.location.href = '/exercises/voice'}
            className="bg-purple-900/50 border border-purple-500/20 rounded-2xl p-6 text-center hover:scale-105 transition-all cursor-pointer"
          >
            <div className="text-6xl mb-4">🎙️</div>
            <h2 className="text-2xl font-bold mb-3">Mode Vocal IA</h2>
            <div className="bg-pink-400 text-pink-900 px-2 py-1 rounded-full text-xs font-bold mb-3">
              🚀 PREMIÈRE ÉDUCATIVE
            </div>
            <p className="text-gray-300 text-sm mb-4">Assistant vocal 3 personnalités</p>
            <div className="text-green-400 text-sm">🎭 3 personnalités IA uniques</div>
            <div className="text-green-400 text-sm">❤️ Analyse émotionnelle temps réel</div>
            <div className="text-green-400 text-sm">🎯 Synthèse vocale adaptative</div>
          </button>
          
          <button 
            type="button"
            onClick={() => window.location.href = '/exercises/ar3d'}
            className="bg-orange-900/50 border border-orange-500/20 rounded-2xl p-6 text-center hover:scale-105 transition-all cursor-pointer"
          >
            <div className="text-6xl mb-4">🥽</div>
            <h2 className="text-2xl font-bold mb-3">Réalité 3D</h2>
            <div className="bg-red-400 text-red-900 px-2 py-1 rounded-full text-xs font-bold mb-3">
              🔥 RÉVOLUTION PÉDAGOGIQUE
            </div>
            <p className="text-gray-300 text-sm mb-4">Visualisation immersive WebGL</p>
            <div className="text-green-400 text-sm">🎮 Manipulation interactive</div>
            <div className="text-green-400 text-sm">🌍 Environnement WebGL</div>
            <div className="text-green-400 text-sm">🎨 Géométrie interactive</div>
          </button>
        </div>

        <div className="text-center">
          <div className="bg-black/30 backdrop-blur rounded-2xl p-8 max-w-2xl mx-auto">
            <h2 className="text-3xl font-bold mb-4">📈 Progression</h2>
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <span>Niveau 1</span>
                <div className="flex-1 mx-4 bg-gray-700 rounded-full h-2">
                  <div className="bg-green-500 h-2 rounded-full" style={{ width: '100%' }}></div>
                </div>
                <span className="text-green-400">✅</span>
              </div>
              <div className="flex justify-between items-center">
                <span>Niveau 2</span>
                <div className="flex-1 mx-4 bg-gray-700 rounded-full h-2">
                  <div className="bg-blue-500 h-2 rounded-full" style={{ width: '75%' }}></div>
                </div>
                <span>75%</span>
              </div>
            </div>

            <h2 className="text-2xl font-bold mb-4 mt-8">🏆 Innovations</h2>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div className="text-green-400">✅ IA Adaptative Avancée</div>
              <div className="text-green-400">✅ Reconnaissance Manuscrite</div>
              <div className="text-green-400">✅ Réalité Augmentée 3D</div>
              <div className="text-green-400">✅ Assistant Vocal IA</div>
              <div className="text-green-400">✅ Progression Gamifiée</div>
              <div className="text-green-400">✅ Traduction Universelle</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
