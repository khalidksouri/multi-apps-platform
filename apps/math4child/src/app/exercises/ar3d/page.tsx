'use client';

import { useState, useEffect } from 'react';

export default function AR3DPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div>Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-900 to-red-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">🥽 Réalité Augmentée 3D</h1>
          <p className="text-xl mb-6">Visualisez et manipulez les concepts en 3D immersif</p>
        </div>
        
        <div className="bg-black/30 rounded-2xl p-8 mb-8">
          <div className="text-center mb-8">
            <div className="text-8xl font-bold mb-4">4 × 3 = ?</div>
            <p className="text-gray-300">Résolvez cette opération</p>
          </div>
          
          <div className="max-w-md mx-auto">
            <div className="bg-white/10 p-6 rounded-lg mb-6">
              <div className="text-center">
                <div className="w-[600px] h-[400px] bg-gradient-to-br from-orange-500/20 to-red-500/20 rounded-lg border border-orange-500/30 flex items-center justify-center mx-auto">
                  <div className="text-center">
                    <div className="text-8xl mb-4">🌟</div>
                    <div className="text-2xl font-bold mb-2">Environnement 3D WebGL</div>
                    <div className="text-gray-300 mb-4">Réalité augmentée mathématique immersive</div>
                    <div className="text-sm text-orange-400">Cliquez pour activer la 3D</div>
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
