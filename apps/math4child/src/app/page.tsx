'use client';

import { useState, useEffect } from 'react';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-pink-900 text-white flex items-center justify-center">
        <div className="text-4xl font-bold">Math4Child Loading...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-pink-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-7xl font-bold mb-8 bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
            Math4Child v4.2.0
          </h1>
          <p className="text-3xl mb-6 text-gray-300">
            Révolution Éducative Mondiale
          </p>
          <div className="bg-green-500 text-white px-8 py-3 rounded-full inline-block text-xl font-bold">
            ✨ 6 Innovations Révolutionnaires Opérationnelles ✨
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          <div className="bg-white/10 backdrop-blur rounded-2xl p-8 hover:scale-105 transition-all duration-300">
            <div className="text-6xl mb-4 text-center">✏️</div>
            <h3 className="text-2xl font-bold mb-4 text-center">Reconnaissance Manuscrite</h3>
            <p className="text-gray-300 text-center mb-6">IA avancée reconnaît l'écriture en temps réel</p>
            <div className="bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-xs font-bold text-center">
              🌟 INNOVATION MONDIALE
            </div>
          </div>

          <div className="bg-white/10 backdrop-blur rounded-2xl p-8 hover:scale-105 transition-all duration-300">
            <div className="text-6xl mb-4 text-center">🎙️</div>
            <h3 className="text-2xl font-bold mb-4 text-center">Assistant Vocal IA</h3>
            <p className="text-gray-300 text-center mb-6">3 personnalités avec analyse émotionnelle</p>
            <div className="bg-pink-400 text-pink-900 px-3 py-1 rounded-full text-xs font-bold text-center">
              🚀 PREMIÈRE ÉDUCATIVE
            </div>
          </div>

          <div className="bg-white/10 backdrop-blur rounded-2xl p-8 hover:scale-105 transition-all duration-300">
            <div className="text-6xl mb-4 text-center">🥽</div>
            <h3 className="text-2xl font-bold mb-4 text-center">Réalité Augmentée 3D</h3>
            <p className="text-gray-300 text-center mb-6">Visualisation immersive WebGL</p>
            <div className="bg-red-400 text-red-900 px-3 py-1 rounded-full text-xs font-bold text-center">
              🔥 RÉVOLUTION PÉDAGOGIQUE
            </div>
          </div>
        </div>

        <div className="text-center mb-16">
          <button 
            type="button"
            onClick={() => window.location.href = '/exercises'}
            className="inline-block px-12 py-4 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 rounded-lg font-semibold text-xl transition-all duration-300 transform hover:scale-105"
          >
            🚀 Commencer l'Aventure Mathématique
          </button>
        </div>

        <div className="text-center">
          <div className="bg-black/30 backdrop-blur rounded-2xl p-8 max-w-4xl mx-auto">
            <h2 className="text-3xl font-bold mb-6">🌍 Impact Mondial Confirmé</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              <div>
                <div className="text-3xl font-bold text-blue-400">200+</div>
                <div className="text-gray-400">Langues</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-purple-400">6</div>
                <div className="text-gray-400">Innovations</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-pink-400">100%</div>
                <div className="text-gray-400">Opérationnel</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-green-400">∞</div>
                <div className="text-gray-400">Possibilités</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
