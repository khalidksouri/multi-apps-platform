'use client';

import { useState, useEffect } from 'react';

export default function AdminPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div className="min-h-screen flex items-center justify-center">Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-red-900 to-orange-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-5xl font-bold mb-6">⚙️ Administration Math4Child</h1>
          <p className="text-xl">Panneau d'administration v4.2.0</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          <div className="bg-white/10 rounded-2xl p-6 text-center">
            <div className="text-4xl mb-4">👥</div>
            <h3 className="text-xl font-bold mb-2">Utilisateurs</h3>
            <p className="text-3xl font-bold text-blue-400">1,247</p>
            <p className="text-sm text-gray-400">Utilisateurs actifs</p>
          </div>
          
          <div className="bg-white/10 rounded-2xl p-6 text-center">
            <div className="text-4xl mb-4">🎯</div>
            <h3 className="text-xl font-bold mb-2">Exercices</h3>
            <p className="text-3xl font-bold text-green-400">45,892</p>
            <p className="text-sm text-gray-400">Exercices complétés</p>
          </div>
          
          <div className="bg-white/10 rounded-2xl p-6 text-center">
            <div className="text-4xl mb-4">🌍</div>
            <h3 className="text-xl font-bold mb-2">Langues</h3>
            <p className="text-3xl font-bold text-purple-400">200+</p>
            <p className="text-sm text-gray-400">Langues supportées</p>
          </div>
        </div>

        <div className="bg-white/10 rounded-2xl p-8">
          <h2 className="text-2xl font-bold mb-6">Outils d'administration</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <button 
              type="button"
              className="py-3 bg-blue-600 hover:bg-blue-700 rounded font-semibold transition-colors"
            >
              Utilisateurs
            </button>
            <button 
              type="button"
              className="py-3 bg-green-600 hover:bg-green-700 rounded font-semibold transition-colors"
            >
              Exercices
            </button>
            <button 
              type="button"
              className="py-3 bg-purple-600 hover:bg-purple-700 rounded font-semibold transition-colors"
            >
              Analytics
            </button>
            <button 
              type="button"
              className="py-3 bg-orange-600 hover:bg-orange-700 rounded font-semibold transition-colors"
            >
              Configurations
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
