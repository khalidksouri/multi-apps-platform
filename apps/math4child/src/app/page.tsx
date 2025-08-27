'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-900 to-purple-900">
        <div className="text-white text-2xl">Chargement Math4Child...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      {/* Navigation simple */}
      <nav className="fixed top-0 w-full z-40 bg-white/10 backdrop-blur border-b border-white/20">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-4">
              <div className="text-2xl font-bold bg-gradient-to-r from-blue-300 to-purple-300 bg-clip-text text-transparent">
                Math4Child
              </div>
              <div className="text-sm text-gray-300 bg-gray-700 px-3 py-1 rounded-full">
                v4.2.0
              </div>
            </div>
            <div className="flex items-center space-x-6">
              <Link href="/" className="text-white font-semibold">Accueil</Link>
              <Link href="/exercises" className="text-gray-300 hover:text-white">Exercices</Link>
              <Link href="/pricing" className="text-gray-300 hover:text-white">Plans</Link>
              <Link href="/dashboard" className="text-gray-300 hover:text-white">Dashboard</Link>
            </div>
          </div>
        </div>
      </nav>

      {/* Contenu principal */}
      <div className="pt-16 max-w-7xl mx-auto px-4 py-20">
        
        {/* Hero Section */}
        <div className="text-center mb-20">
          <h1 className="text-7xl font-bold mb-8 bg-gradient-to-r from-white to-blue-300 bg-clip-text text-transparent">
            Math4Child v4.2.0
          </h1>
          <p className="text-3xl mb-6 text-gray-300">
            Application Éducative Mathématique Moderne
          </p>
          <p className="text-xl mb-12 text-gray-400 max-w-4xl mx-auto">
            Découvrez l'apprentissage des mathématiques avec notre design interactif attrayant, 
            disponible sur Web (www.math4child.com), Android et iOS
          </p>
          
          {/* Boutons d'action */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center items-center">
            <Link 
              href="/exercises"
              className="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-10 py-4 rounded-2xl font-bold text-xl hover:from-blue-600 hover:to-purple-600 transition-all transform hover:scale-105 shadow-lg"
            >
              🚀 Commencer l'Apprentissage
            </Link>
            <Link 
              href="/pricing"
              className="bg-gradient-to-r from-green-500 to-blue-500 text-white px-10 py-4 rounded-2xl font-bold text-xl hover:from-green-600 hover:to-blue-600 transition-all transform hover:scale-105 shadow-lg"
            >
              💎 Voir les Plans
            </Link>
          </div>
        </div>

        {/* Fonctionnalités principales */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-20">
          
          {/* IA Adaptative */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">🧠</div>
            <h3 className="text-2xl font-bold mb-4">IA Adaptative</h3>
            <p className="text-gray-300">
              Adaptation automatique au niveau de l'enfant avec analyse des performances en temps réel
            </p>
          </div>

          {/* Reconnaissance Manuscrite */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">✏️</div>
            <h3 className="text-2xl font-bold mb-4">Reconnaissance Manuscrite</h3>
            <p className="text-gray-300">
              Canvas tactile pour écriture directe avec reconnaissance des chiffres 0-9
            </p>
          </div>

          {/* Assistant Vocal */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">🎙️</div>
            <h3 className="text-2xl font-bold mb-4">Assistant Vocal IA</h3>
            <p className="text-gray-300">
              3 personnalités distinctes avec reconnaissance vocale et analyse émotionnelle
            </p>
          </div>

          {/* Réalité Augmentée 3D */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">🥽</div>
            <h3 className="text-2xl font-bold mb-4">Réalité Augmentée 3D</h3>
            <p className="text-gray-300">
              Visualisation immersive des concepts mathématiques en 3D WebGL
            </p>
          </div>

          {/* Progression Gamifiée */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">🎮</div>
            <h3 className="text-2xl font-bold mb-4">Progression Gamifiée</h3>
            <p className="text-gray-300">
              5 niveaux avec 100 bonnes réponses minimum pour débloquer le suivant
            </p>
          </div>

          {/* Support Multilingue */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <div className="text-4xl mb-4">🌍</div>
            <h3 className="text-2xl font-bold mb-4">Support Multilingue</h3>
            <p className="text-gray-300">
              Interface dans toutes les langues avec adaptation culturelle
            </p>
          </div>
        </div>

        {/* Opérations mathématiques */}
        <div className="bg-white/10 rounded-2xl p-12 backdrop-blur border border-white/20 mb-20">
          <h2 className="text-4xl font-bold text-center mb-12">🧮 5 Opérations Mathématiques</h2>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
            {[
              { name: 'Addition', symbol: '➕', desc: 'Opérations de base et complexes' },
              { name: 'Soustraction', symbol: '➖', desc: 'Nombres positifs et négatifs' },
              { name: 'Multiplication', symbol: '✖️', desc: 'Tables et calculs avancés' },
              { name: 'Division', symbol: '➗', desc: 'Division euclidienne et décimale' },
              { name: 'Mixte', symbol: '🔀', desc: 'Combinaison intelligente' }
            ].map((op, index) => (
              <div key={index} className="text-center">
                <div className="text-6xl mb-4">{op.symbol}</div>
                <h3 className="text-xl font-bold mb-2">{op.name}</h3>
                <p className="text-sm text-gray-300">{op.desc}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Applications disponibles */}
        <div className="bg-gradient-to-r from-green-500/20 to-blue-500/20 rounded-2xl p-12 border border-green-400/50 mb-20">
          <h2 className="text-4xl font-bold text-center mb-8">📱 Applications Hybrides</h2>
          <p className="text-xl text-center text-gray-300 mb-8">
            Disponible sur toutes les plateformes avec synchronisation complète
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="text-6xl mb-4">🌐</div>
              <h3 className="text-2xl font-bold mb-2">Web</h3>
              <p className="text-gray-300">www.math4child.com</p>
              <p className="text-sm text-green-400 mt-2">Progressive Web App</p>
            </div>
            <div className="text-center">
              <div className="text-6xl mb-4">📱</div>
              <h3 className="text-2xl font-bold mb-2">Android</h3>
              <p className="text-gray-300">Google Play Store</p>
              <p className="text-sm text-green-400 mt-2">Version 7.0+ compatible</p>
            </div>
            <div className="text-center">
              <div className="text-6xl mb-4">🍎</div>
              <h3 className="text-2xl font-bold mb-2">iOS</h3>
              <p className="text-gray-300">Apple App Store</p>
              <p className="text-sm text-green-400 mt-2">iOS 12.0+ compatible</p>
            </div>
          </div>
        </div>

        {/* Support et contacts */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          
          {/* Support */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <h3 className="text-2xl font-bold mb-6">📞 Support Math4Child</h3>
            <div className="space-y-4">
              <div className="flex items-center">
                <span className="text-blue-400 mr-3">📧</span>
                <span>Support : support@math4child.com</span>
              </div>
              <div className="flex items-center">
                <span className="text-purple-400 mr-3">💼</span>
                <span>Commercial : commercial@math4child.com</span>
              </div>
              <div className="flex items-center">
                <span className="text-green-400 mr-3">🌐</span>
                <span>Web : www.math4child.com</span>
              </div>
            </div>
          </div>

          {/* Conformité */}
          <div className="bg-white/10 rounded-2xl p-8 backdrop-blur border border-white/20">
            <h3 className="text-2xl font-bold mb-6">✅ Conformité Garantie</h3>
            <div className="space-y-2 text-gray-300">
              <div>• 5 plans d'abonnement conformes</div>
              <div>• 5 niveaux de progression</div>
              <div>• 100 bonnes réponses minimum</div>
              <div>• 5 opérations mathématiques</div>
              <div>• Support multilingue complet</div>
              <div>• TypeScript 100% + Tests Playwright</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
