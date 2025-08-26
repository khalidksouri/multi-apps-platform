'use client';

import { useState, useEffect } from 'react';

export default function AdditionPage() {
  const [mounted, setMounted] = useState(false);
  const [answer, setAnswer] = useState('');

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div>Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">🔢 Mode Addition</h1>
          <p className="text-xl mb-6">Interface classique optimisée avec clavier numérique intuitif</p>
        </div>
        
        <div className="bg-black/30 rounded-2xl p-8 mb-8">
          <div className="text-center mb-8">
            <div className="text-8xl font-bold mb-4">5 + 3 = ?</div>
            <p className="text-gray-300">Résolvez cette opération</p>
          </div>
          
          <div className="max-w-md mx-auto">
            <div className="grid grid-cols-3 gap-4 mb-6">
              {[1,2,3,4,5,6,7,8,9].map(num => (
                <button 
                  key={num}
                  type="button"
                  onClick={() => setAnswer(prev => prev + num.toString())}
                  className="bg-gray-700 hover:bg-gray-600 text-2xl font-bold py-4 rounded transition-colors"
                >
                  {num}
                </button>
              ))}
              <button 
                type="button"
                onClick={() => setAnswer(prev => prev + '0')}
                className="bg-gray-700 hover:bg-gray-600 text-2xl font-bold py-4 rounded"
              >
                0
              </button>
              <button 
                type="button"
                onClick={() => setAnswer('')}
                className="bg-red-600 hover:bg-red-700 font-bold py-4 rounded"
              >
                ⌫
              </button>
              <button 
                type="button"
                className="bg-green-600 hover:bg-green-700 font-bold py-4 rounded"
              >
                ✓
              </button>
            </div>
            
            <div className="bg-black/50 p-4 rounded text-center mb-6">
              <div className="text-3xl font-bold text-yellow-400 min-h-12 flex items-center justify-center">
                {answer || 'Votre réponse...'}
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
