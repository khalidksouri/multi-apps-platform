'use client';

import { useState, useEffect } from 'react';

export default function DashboardPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div className="min-h-screen flex items-center justify-center">Chargement...</div>;

  const stats = [
    { emoji: '👥', value: '3', label: 'Profils actifs' },
    { emoji: '🎯', value: '847', label: 'Exercices résolus' },
    { emoji: '⏱️', value: '2h 15m', label: 'Temps aujourd\'hui' },
    { emoji: '🏆', value: '95%', label: 'Taux de réussite' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 to-indigo-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">📊 Dashboard Parental</h1>
          <p className="text-2xl">Suivez les progrès avec les 6 innovations</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
          {stats.map((stat, i) => (
            <div key={i} className="bg-gray-800/50 rounded-2xl p-6 text-center hover:scale-105 transition-transform">
              <div className="text-4xl mb-2">{stat.emoji}</div>
              <div className="text-2xl font-bold mb-1">{stat.value}</div>
              <div className="text-gray-400 text-sm">{stat.label}</div>
            </div>
          ))}
        </div>

        <div className="bg-gray-800/50 rounded-2xl p-8">
          <h2 className="text-2xl font-bold mb-6">📈 Progression par Innovation</h2>
          <div className="space-y-4">
            {[
              { name: 'IA Adaptative Avancée', progress: 95 },
              { name: 'Reconnaissance Manuscrite', progress: 88 },
              { name: 'Réalité Augmentée 3D', progress: 72 },
              { name: 'Assistant Vocal IA', progress: 91 },
              { name: 'Progression Gamifiée', progress: 85 },
              { name: 'Traduction Universelle', progress: 100 }
            ].map((innovation, i) => (
              <div key={i} className="flex items-center justify-between">
                <span className="flex-1">{innovation.name}</span>
                <div className="flex-1 mx-4 bg-gray-700 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-blue-500 to-green-500 h-3 rounded-full transition-all"
                    style={{ width: `${innovation.progress}%` }}
                  ></div>
                </div>
                <span className="w-12 text-right font-bold">{innovation.progress}%</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
