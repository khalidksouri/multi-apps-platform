'use client';

import { useState, useEffect } from 'react';

export default function ProfilePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div className="min-h-screen flex items-center justify-center">Chargement...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-900 to-purple-900 text-white">
      <div className="max-w-4xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-6">👤 Profil Utilisateur</h1>
          <p className="text-xl">Gérez votre compte Math4Child v4.2.0</p>
        </div>

        <div className="bg-white/10 rounded-2xl p-8">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h2 className="text-2xl font-bold mb-4">Informations personnelles</h2>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium mb-2">Nom d'utilisateur</label>
                  <div className="bg-black/20 p-3 rounded">utilisateur@math4child.com</div>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2">Plan actuel</label>
                  <div className="bg-yellow-500/20 text-yellow-400 p-3 rounded font-bold">PREMIUM (LE PLUS CHOISI)</div>
                </div>
                <div>
                  <label className="block text-sm font-medium mb-2">Profils enfants</label>
                  <div className="bg-green-500/20 text-green-400 p-3 rounded">3/3 profils utilisés</div>
                </div>
              </div>
            </div>
            
            <div>
              <h2 className="text-2xl font-bold mb-4">Paramètres</h2>
              <div className="space-y-4">
                <button 
                  type="button"
                  className="w-full py-3 bg-blue-600 hover:bg-blue-700 rounded font-semibold transition-colors"
                >
                  Modifier le profil
                </button>
                <button 
                  type="button"
                  className="w-full py-3 bg-green-600 hover:bg-green-700 rounded font-semibold transition-colors"
                >
                  Gérer les enfants
                </button>
                <button 
                  type="button"
                  className="w-full py-3 bg-purple-600 hover:bg-purple-700 rounded font-semibold transition-colors"
                >
                  Paramètres avancés
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
