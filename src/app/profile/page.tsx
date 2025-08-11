'use client'

import React, { useState, useEffect } from 'react'
import Link from 'next/link'
import { ProgressionManager } from '@/lib/database/progressionManager'
import type { UserStats } from '@/types'

export default function ProfilePage() {
  const [userStats, setUserStats] = useState<UserStats | null>(null);
  const [showExportModal, setShowExportModal] = useState(false);

  useEffect(() => {
    const progressionManager = ProgressionManager.getInstance();
    const stats = progressionManager.getUserStats();
    setUserStats(stats);
  }, []);

  const handleResetStats = () => {
    if (confirm('Êtes-vous sûr de vouloir réinitialiser toutes vos statistiques ?')) {
      const progressionManager = ProgressionManager.getInstance();
      progressionManager.resetStats();
      setUserStats(progressionManager.getUserStats());
    }
  };

  const handleExportStats = () => {
    const progressionManager = ProgressionManager.getInstance();
    const exportData = progressionManager.exportStats();
    const blob = new Blob([exportData], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `math4child-stats-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const getUserLevel = (): { level: number; title: string; emoji: string } => {
    if (!userStats) return { level: 1, title: 'Débutant', emoji: '🌱' };
    
    const questions = userStats.totalQuestions;
    
    if (questions >= 500) return { level: 10, title: 'Génie Mathématique', emoji: '🧠' };
    if (questions >= 300) return { level: 9, title: 'Maître Suprême', emoji: '👑' };
    if (questions >= 200) return { level: 8, title: 'Expert Confirmé', emoji: '⭐' };
    if (questions >= 150) return { level: 7, title: 'Mathématicien', emoji: '🎓' };
    if (questions >= 100) return { level: 6, title: 'Champion', emoji: '🏆' };
    if (questions >= 75) return { level: 5, title: 'Expert', emoji: '💎' };
    if (questions >= 50) return { level: 4, title: 'Avancé', emoji: '🚀' };
    if (questions >= 25) return { level: 3, title: 'Intermédiaire', emoji: '⚡' };
    if (questions >= 10) return { level: 2, title: 'Apprenti', emoji: '📚' };
    return { level: 1, title: 'Débutant', emoji: '🌱' };
  };

  if (!userStats) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <div className="text-4xl mb-4">👤</div>
          <div className="text-xl text-gray-600">Chargement du profil...</div>
        </div>
      </div>
    );
  }

  const userLevel = getUserLevel();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-6xl font-bold mb-4 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            👤 Mon Profil
          </h1>
          <p className="text-xl text-gray-600">
            Votre progression et statistiques Math4Child v4.2.0
          </p>
        </div>

        {/* Niveau Utilisateur */}
        <div className="bg-gradient-to-r from-purple-500 to-blue-500 text-white rounded-xl p-8 mb-8 text-center">
          <div className="text-6xl mb-4">{userLevel.emoji}</div>
          <h2 className="text-3xl font-bold mb-2">{userLevel.title}</h2>
          <p className="text-purple-100 mb-4">Niveau {userLevel.level}</p>
          <div className="bg-white/20 rounded-full h-2 max-w-md mx-auto">
            <div 
              className="bg-white h-2 rounded-full transition-all duration-300"
              style={{ width: `${Math.min((userStats.totalQuestions % 50) * 2, 100)}%` }}
            ></div>
          </div>
          <p className="text-purple-100 text-sm mt-2">
            {userStats.totalQuestions % 50}/50 questions vers le niveau suivant
          </p>
        </div>

        {/* Statistiques Principales */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg p-6 shadow-lg text-center">
            <div className="text-3xl font-bold text-blue-600 mb-2">{userStats.totalQuestions}</div>
            <div className="text-gray-600">Questions Répondues</div>
          </div>
          
          <div className="bg-white rounded-lg p-6 shadow-lg text-center">
            <div className="text-3xl font-bold text-green-600 mb-2">{userStats.overallPrecision}%</div>
            <div className="text-gray-600">Précision Globale</div>
          </div>
          
          <div className="bg-white rounded-lg p-6 shadow-lg text-center">
            <div className="text-3xl font-bold text-orange-600 mb-2">{userStats.bestStreak}</div>
            <div className="text-gray-600">Meilleure Série</div>
          </div>
          
          <div className="bg-white rounded-lg p-6 shadow-lg text-center">
            <div className="text-3xl font-bold text-purple-600 mb-2">{userStats.badges.length}</div>
            <div className="text-gray-600">Badges Obtenus</div>
          </div>
        </div>

        {/* Badges Collection */}
        <div className="bg-white rounded-lg p-6 shadow-lg mb-8">
          <h3 className="text-2xl font-bold mb-4">🏆 Collection de Badges</h3>
          {userStats.badges.length > 0 ? (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {userStats.badges.map((badge) => (
                <div 
                  key={badge.id}
                  className="bg-gradient-to-br from-yellow-100 to-yellow-200 rounded-lg p-4 text-center border border-yellow-300 hover:shadow-lg transition-shadow"
                >
                  <div className="text-4xl mb-2">{badge.icon}</div>
                  <h4 className="font-bold text-gray-800 text-sm">{badge.name}</h4>
                  <p className="text-gray-600 text-xs mt-1">{badge.description}</p>
                  <p className="text-gray-500 text-xs mt-2">
                    {new Date(badge.unlockedAt).toLocaleDateString()}
                  </p>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-8">
              <div className="text-6xl mb-4">🎯</div>
              <p className="text-gray-600 mb-4">Aucun badge débloqué pour le moment</p>
              <p className="text-gray-500 text-sm">Répondez à des questions pour gagner vos premiers badges !</p>
            </div>
          )}
        </div>

        {/* Progression par Niveau */}
        <div className="bg-white rounded-lg p-6 shadow-lg mb-8">
          <h3 className="text-2xl font-bold mb-4">📊 Progression par Niveau</h3>
          <div className="grid grid-cols-5 gap-4">
            {[1, 2, 3, 4, 5].map((level) => (
              <div 
                key={level}
                className={`text-center p-4 rounded-lg border-2 ${
                  userStats.levelsCompleted.includes(level)
                    ? 'bg-green-50 border-green-200'
                    : 'bg-gray-50 border-gray-200'
                }`}
              >
                <div className="text-2xl mb-2">
                  {userStats.levelsCompleted.includes(level) ? '✅' : '⭕'}
                </div>
                <div className="font-bold">Niveau {level}</div>
                <div className="text-xs text-gray-600 mt-1">
                  {userStats.levelsCompleted.includes(level) ? 'Maîtrisé' : 'À débloquer'}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Actions */}
        <div className="grid md:grid-cols-3 gap-4 mb-8">
          <Link
            href="/exercises"
            className="bg-blue-500 text-white px-6 py-4 rounded-lg font-bold text-center hover:bg-blue-600 transition-colors"
          >
            🚀 Continuer les Exercices
          </Link>
          
          <button
            onClick={handleExportStats}
            className="bg-green-500 text-white px-6 py-4 rounded-lg font-bold hover:bg-green-600 transition-colors"
          >
            📊 Exporter les Stats
          </button>
          
          <button
            onClick={handleResetStats}
            className="bg-red-500 text-white px-6 py-4 rounded-lg font-bold hover:bg-red-600 transition-colors"
          >
            🔄 Réinitialiser
          </button>
        </div>

        {/* Retour */}
        <div className="text-center">
          <Link
            href="/"
            className="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition-colors"
          >
            ← Retour à l'accueil
          </Link>
        </div>
      </div>
    </div>
  );
}
