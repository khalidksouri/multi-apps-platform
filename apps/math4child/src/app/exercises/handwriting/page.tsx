'use client';

import { useState, useEffect } from 'react';

export default function HandwritingPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div>Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-900 to-teal-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">✏️ Reconnaissance Manuscrite IA</h1>
          <p className="text-xl mb-6">Écrivez votre réponse directement avec reconnaissance temps réel</p>
        </div>
        
        <div className="bg-black/30 rounded-2xl p-8 mb-8">
          <div className="text-center mb-8">
            <div className="text-8xl font-bold mb-4">7 + 4 = ?</div>
            <p className="text-gray-300">Résolvez cette opération</p>
          </div>
          
          <div className="max-w-md mx-auto">
            <div className="bg-white/10 p-6 rounded-lg mb-6">
              <div className="text-center">
                <div className="w-96 h-96 bg-white rounded-lg mx-auto flex items-center justify-center">
                  <div className="text-center text-gray-500">
                    <div className="text-6xl mb-4">✏️</div>
                    <p className="text-lg">Zone d'écriture IA</p>
                    <p className="text-sm">Écrivez avec votre doigt ou stylet</p>
                  </div>
                </div>
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
