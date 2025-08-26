'use client';

import { useState, useEffect } from 'react';

export default function VoicePage() {
  const [mounted, setMounted] = useState(false);
  const [personality, setPersonality] = useState('amical');

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div>Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 to-pink-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">🎙️ Assistant Vocal IA</h1>
          <p className="text-xl mb-6">Dites votre réponse avec 3 personnalités distinctes</p>
        </div>
        
        <div className="bg-black/30 rounded-2xl p-8 mb-8">
          <div className="text-center mb-8">
            <div className="text-8xl font-bold mb-4">6 × 3 = ?</div>
            <p className="text-gray-300">Résolvez cette opération</p>
          </div>
          
          <div className="max-w-md mx-auto">
            <div className="grid grid-cols-3 gap-3 mb-6">
              {[
                { key: 'amical', emoji: '😊', name: 'Amical' },
                { key: 'enthousiaste', emoji: '🎉', name: 'Enthousiaste' },
                { key: 'patient', emoji: '🧘', name: 'Patient' }
              ].map(p => (
                <button
                  key={p.key}
                  type="button"
                  onClick={() => setPersonality(p.key)}
                  className={`p-3 rounded transition-all ${
                    personality === p.key ? 'bg-blue-600' : 'bg-gray-600 hover:bg-blue-500'
                  }`}
                >
                  <div className="text-2xl">{p.emoji}</div>
                  <div className="text-sm font-semibold">{p.name}</div>
                </button>
              ))}
            </div>
            
            <div className="bg-white/10 p-6 rounded-lg mb-6">
              <div className="text-center">
                <div className="bg-gradient-to-br from-purple-600 to-pink-600 rounded-full p-8 mx-auto w-32 h-32 flex items-center justify-center">
                  <div className="text-6xl">🎤</div>
                </div>
                <p className="text-lg mt-4">Zone d'interaction vocale</p>
              </div>
            </div>
          </div>
        </div>
        
        <div className="text-center">
          <div className="grid grid-cols-2 gap-4 max-w-md mx-auto">
            <button 
              type="button"
              onClick={() => window.location.href = '/exercises'}
              className="py-3 bg-gray-600 hover:bg-gray-700 rounded font-semibold transition-colors"
            >
              🏠 Retour Hub
            </button>
            <button 
              type="button"
              className="py-3 bg-green-600 hover:bg-green-700 rounded font-semibold transition-colors"
            >
              ➡️ Suivant
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
