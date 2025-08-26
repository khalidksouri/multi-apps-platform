'use client';

import { useState } from 'react';

export default function VoicePage() {
  const [personality, setPersonality] = useState<'amical' | 'enthousiaste' | 'patient'>('amical');

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 to-pink-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">🎙️ Mode Assistant Vocal IA</h1>
          <div className="bg-purple-500/20 px-4 py-2 rounded-full inline-block">
            <span className="text-purple-400 font-bold">Première Éducative Mondiale</span>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-black/30 rounded-2xl p-8">
            <div className="text-center mb-8">
              <div className="text-7xl font-bold mb-4">6 × 3 = ?</div>
              <p className="text-gray-300">Dis ta réponse à l'assistant IA</p>
              
              <div className="grid grid-cols-3 gap-3 mt-6">
                {[
                  { key: 'amical', emoji: '😊', name: 'Amical' },
                  { key: 'enthousiaste', emoji: '🎉', name: 'Enthousiaste' },
                  { key: 'patient', emoji: '🧘', name: 'Patient' }
                ].map(p => (
                  <button
                    key={p.key}
                    onClick={() => setPersonality(p.key as any)}
                    className={`p-3 rounded transition-all ${
                      personality === p.key ? 'bg-blue-600' : 'bg-gray-600 hover:bg-blue-500'
                    }`}
                  >
                    <div className="text-2xl">{p.emoji}</div>
                    <div className="text-sm font-semibold">{p.name}</div>
                  </button>
                ))}
              </div>
            </div>

            <div className="flex justify-center">
              <div className="bg-gradient-to-br from-purple-600 to-pink-600 rounded-full p-8 hover:scale-105 transition-transform cursor-pointer">
                <div className="text-6xl">🎤</div>
              </div>
            </div>
          </div>

          <div className="space-y-6">
            <div className="bg-pink-500/20 p-6 rounded-2xl">
              <div className="text-center">
                <h3 className="text-2xl font-bold mb-4">🚀 Première Éducative</h3>
                <p className="text-gray-300">
                  Assistant vocal avec 3 personnalités et analyse émotionnelle temps réel
                </p>
              </div>
            </div>

            <div className="space-y-3">
              <button className="w-full py-3 bg-purple-600 hover:bg-purple-700 rounded font-semibold transition-colors">
                ➡️ Exercice Suivant
              </button>
              <div className="grid grid-cols-2 gap-3">
                <a href="/exercises" className="py-2 bg-gray-600 hover:bg-gray-700 rounded text-center transition-colors">
                  🏠 Retour
                </a>
                <button className="py-2 bg-indigo-600 hover:bg-indigo-700 rounded transition-colors">
                  🎨 Paramètres
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
