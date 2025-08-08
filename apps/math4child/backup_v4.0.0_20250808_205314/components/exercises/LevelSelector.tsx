"use client"

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useLanguage } from '@/hooks/useLanguage';
import { LEVELS, getUnlockedLevels } from '@/lib/exercises/levels';
import { LocalDatabase } from '@/lib/database/localStorage';
import { Lock, CheckCircle, Play } from 'lucide-react';

export function LevelSelector() {
  const { t } = useLanguage();
  const [userProgress, setUserProgress] = useState<Record<number, number>>({});
  const [unlockedLevels, setUnlockedLevels] = useState<number[]>([1]);

  useEffect(() => {
    // Charger la progression utilisateur
    const progress = LocalDatabase.getProgress();
    if (progress) {
      const levelProgress: Record<number, number> = {};
      Object.entries(progress.levelProgress).forEach(([level, data]) => {
        levelProgress[parseInt(level)] = data.totalCorrectAnswers;
      });
      setUserProgress(levelProgress);
      setUnlockedLevels(getUnlockedLevels(levelProgress));
    }
  }, []);

  const isLevelUnlocked = (levelId: number): boolean => {
    return unlockedLevels.includes(levelId);
  };

  const isLevelCompleted = (levelId: number): boolean => {
    return (userProgress[levelId] || 0) >= 100;
  };

  const getLevelProgress = (levelId: number): number => {
    return userProgress[levelId] || 0;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        {/* Header */}
        <div className="text-center mb-12">
          <Link 
            href="/"
            className="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 mb-6 transition-colors"
          >
            ← Retour à l'accueil
          </Link>
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            {t('chooseLevel') || 'Choisis ton niveau'}
          </h1>
          <p className="text-xl text-gray-600">
            Progresse étape par étape pour devenir un champion des maths !
          </p>
        </div>

        {/* Grille des niveaux */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {LEVELS.map((level) => {
            const isUnlocked = isLevelUnlocked(level.id);
            const isCompleted = isLevelCompleted(level.id);
            const progress = getLevelProgress(level.id);
            const progressPercent = Math.min((progress / 100) * 100, 100);

            return (
              <div
                key={level.id}
                className={`relative bg-white rounded-2xl shadow-lg border-2 transition-all duration-300 ${
                  isUnlocked 
                    ? isCompleted
                      ? 'border-green-300 shadow-green-100'
                      : 'border-blue-300 hover:shadow-xl hover:scale-105'
                    : 'border-gray-200 opacity-60'
                }`}
              >
                {/* Badge de niveau */}
                <div className={`absolute -top-4 left-6 px-4 py-2 rounded-full text-white font-bold text-sm ${
                  isCompleted 
                    ? 'bg-green-500' 
                    : isUnlocked 
                      ? 'bg-blue-500' 
                      : 'bg-gray-400'
                }`}>
                  Niveau {level.id}
                </div>

                <div className="p-6 pt-8">
                  {/* Emoji et titre */}
                  <div className="text-center mb-4">
                    <div className="text-4xl mb-2">{level.emoji}</div>
                    <h3 className="text-xl font-bold text-gray-800">
                      {level.displayName}
                    </h3>
                    <p className="text-sm text-gray-500">{level.difficulty}</p>
                  </div>

                  {/* Description */}
                  <p className="text-gray-600 text-sm mb-4 text-center">
                    {level.description}
                  </p>

                  {/* Nombres */}
                  <div className="text-center mb-4">
                    <span className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-sm font-medium">
                      Nombres {level.numberRange[0]}-{level.numberRange[1]}
                    </span>
                  </div>

                  {/* Progression */}
                  {isUnlocked && (
                    <div className="mb-4">
                      <div className="flex justify-between text-sm text-gray-600 mb-1">
                        <span>Progression</span>
                        <span>{progress}/100</span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2">
                        <div 
                          className={`h-2 rounded-full transition-all duration-500 ${
                            isCompleted ? 'bg-green-500' : 'bg-blue-500'
                          }`}
                          style={{ width: `${progressPercent}%` }}
                        />
                      </div>
                    </div>
                  )}

                  {/* Bouton d'action */}
                  <div className="text-center">
                    {!isUnlocked ? (
                      <div className="flex items-center justify-center gap-2 text-gray-500">
                        <Lock className="w-4 h-4" />
                        <span className="text-sm">Verrouillé</span>
                      </div>
                    ) : isCompleted ? (
                      <Link 
                        href={`/exercises/${level.id}`}
                        className="inline-flex items-center gap-2 bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-lg font-medium transition-colors"
                      >
                        <CheckCircle className="w-4 h-4" />
                        Terminé - Rejouer
                      </Link>
                    ) : (
                      <Link 
                        href={`/exercises/${level.id}`}
                        className="inline-flex items-center gap-2 bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg font-medium transition-colors"
                      >
                        <Play className="w-4 h-4" />
                        Commencer
                      </Link>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Informations sur le déblocage */}
        <div className="mt-12 text-center">
          <div className="bg-white rounded-lg p-6 shadow-lg max-w-2xl mx-auto">
            <h3 className="text-lg font-bold text-gray-800 mb-3">
              Comment débloquer les niveaux ?
            </h3>
            <p className="text-gray-600 mb-4">
              Pour débloquer un niveau, tu dois obtenir <strong>100 bonnes réponses</strong> dans le niveau précédent.
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
              <div className="bg-blue-50 rounded-lg p-3">
                <div className="text-blue-600 font-medium">🎯 Pratique</div>
                <div className="text-gray-600">Réponds aux questions</div>
              </div>
              <div className="bg-green-50 rounded-lg p-3">
                <div className="text-green-600 font-medium">✅ Progresse</div>
                <div className="text-gray-600">100 bonnes réponses</div>
              </div>
              <div className="bg-purple-50 rounded-lg p-3">
                <div className="text-purple-600 font-medium">🔓 Débloque</div>
                <div className="text-gray-600">Niveau suivant</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
