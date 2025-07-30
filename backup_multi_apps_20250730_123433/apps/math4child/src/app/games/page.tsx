'use client';

import Link from 'next/link';
import { ArrowLeft, Play, Brain, Zap, Puzzle } from 'lucide-react';

export default function GamesPage() {
  const games = [
    {
      id: 'quick-math',
      name: 'Quick Math',
      description: 'Résous un maximum de calculs en 30 secondes !',
      icon: <Zap className="w-8 h-8 text-yellow-500" />,
      color: 'from-yellow-400 to-orange-500'
    },
    {
      id: 'memory-math',
      name: 'Memory Math',
      description: 'Trouve les paires de nombres identiques !',
      icon: <Brain className="w-8 h-8 text-purple-500" />,
      color: 'from-purple-400 to-pink-500'
    },
    {
      id: 'puzzle-math',
      name: 'Puzzle Math',
      description: 'Résous le puzzle mathématique !',
      icon: <Puzzle className="w-8 h-8 text-green-500" />,
      color: 'from-green-400 to-blue-500'
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-white to-pink-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <Link 
              href="/" 
              className="flex items-center space-x-3 text-gray-700 hover:text-purple-600 transition-colors duration-200"
            >
              <ArrowLeft size={20} />
              <span className="font-medium">Retour à l'accueil</span>
            </Link>
            
            <div className="flex items-center space-x-2 text-gray-600">
              <div className="w-8 h-8 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-sm font-bold">M4C</span>
              </div>
              <span className="font-semibold text-gray-800">Math4Child</span>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            🎮 Jeux Mathématiques
          </h1>
          <p className="text-xl text-gray-600">
            Choisis ton jeu préféré et amuse-toi à apprendre !
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {games.map((game) => (
            <div key={game.id} className="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:scale-105">
              <div className={`bg-gradient-to-r ${game.color} p-6 text-white`}>
                <div className="flex items-center justify-center mb-4">
                  {game.icon}
                </div>
                <h3 className="text-xl font-bold text-center">{game.name}</h3>
              </div>
              
              <div className="p-6">
                <p className="text-gray-600 mb-6 text-center">
                  {game.description}
                </p>
                
                <button className="w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white py-3 rounded-lg font-semibold hover:from-blue-600 hover:to-purple-700 transition-all duration-200 flex items-center justify-center">
                  <Play className="w-4 h-4 mr-2" />
                  Jouer
                </button>
              </div>
            </div>
          ))}
        </div>

        <div className="text-center mt-12">
          <Link 
            href="/exercises"
            className="inline-flex items-center bg-green-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-600 transition-colors"
          >
            Découvrir les Exercices
            <ArrowLeft className="w-4 h-4 ml-2 rotate-180" />
          </Link>
        </div>
      </div>
    </div>
  );
}
