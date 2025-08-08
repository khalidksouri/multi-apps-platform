"use client"

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useLanguage } from '@/hooks/useLanguage';
import { OPERATIONS, getLevelById } from '@/lib/exercises/levels';
import { LocalDatabase } from '@/lib/database/localStorage';
import { Play, TrendingUp } from 'lucide-react';

export function OperationSelector() {
  const { t } = useLanguage();
  const params = useParams();
  const levelId = parseInt(params.level as string);
  const level = getLevelById(levelId);
  const [operationStats, setOperationStats] = useState<Record<string, any>>({});

  useEffect(() => {
    // Charger les statistiques par opération
    const progress = LocalDatabase.getProgress();
    if (progress && progress.levelProgress[levelId]) {
      setOperationStats(progress.levelProgress[levelId].operationProgress || {});
    }
  }, [levelId]);

  if (!level) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-800 mb-4">Niveau introuvable</h1>
          <Link href="/exercises" className="text-blue-600 hover:text-blue-700">
            ← Retour aux niveaux
          </Link>
        </div>
      </div>
    );
  }

  const getOperationProgress = (operationId: string) => {
    const stats = operationStats[operationId];
    return {
      correctAnswers: stats?.correctAnswers || 0,
      totalAttempts: stats?.totalAttempts || 0,
      accuracy: stats?.totalAttempts ? Math.round((stats.correctAnswers / stats.totalAttempts) * 100) : 0,
      averageTime: stats?.averageTime || 0
    };
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        {/* Header */}
        <div className="text-center mb-12">
          <Link 
            href="/exercises"
            className="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 mb-6 transition-colors"
          >
            ← Retour aux niveaux
          </Link>
          
          {/* Info du niveau */}
          <div className="bg-white rounded-2xl p-6 shadow-lg mb-8">
            <div className="flex items-center justify-center gap-4 mb-4">
              <div className="text-4xl">{level.emoji}</div>
              <div className="text-left">
                <h1 className="text-3xl font-bold text-gray-800">
                  Niveau {level.id} - {level.displayName}
                </h1>
                <p className="text-gray-600">{level.description}</p>
              </div>
            </div>
            <div className="flex items-center justify-center gap-6 text-sm">
              <div className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full">
                Nombres {level.numberRange[0]}-{level.numberRange[1]}
              </div>
              <div className="bg-purple-100 text-purple-700 px-3 py-1 rounded-full">
                {level.difficulty}
              </div>
            </div>
          </div>

          <h2 className="text-2xl font-bold text-gray-800 mb-4">
            {t('chooseOperation') || 'Choisis ton opération'}
          </h2>
          <p className="text-lg text-gray-600">
            Sélectionne le type d'exercices que tu veux pratiquer
          </p>
        </div>

        {/* Grille des opérations */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {OPERATIONS.map((operation) => {
            const progress = getOperationProgress(operation.id);

            return (
              <Link
                key={operation.id}
                href={`/exercises/${levelId}/${operation.id}`}
                className="group bg-white rounded-2xl shadow-lg border-2 border-gray-200 hover:border-blue-300 hover:shadow-xl transition-all duration-300 hover:scale-105"
              >
                <div className="p-6">
                  {/* Icône et titre */}
                  <div className="text-center mb-4">
                    <div className="text-5xl mb-3 group-hover:scale-110 transition-transform">
                      {operation.emoji}
                    </div>
                    <h3 className="text-xl font-bold text-gray-800 mb-2">
                      {operation.displayName}
                    </h3>
                    <p className="text-sm text-gray-600">
                      {operation.description}
                    </p>
                  </div>

                  {/* Symbole de l'opération */}
                  <div className="text-center mb-4">
                    <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full">
                      <span className="text-2xl font-bold text-blue-600">
                        {operation.symbol}
                      </span>
                    </div>
                  </div>

                  {/* Statistiques */}
                  {progress.totalAttempts > 0 && (
                    <div className="mb-4 space-y-2">
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Bonnes réponses</span>
                        <span className="font-medium text-green-600">
                          {progress.correctAnswers}
                        </span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Précision</span>
                        <span className="font-medium text-blue-600">
                          {progress.accuracy}%
                        </span>
                      </div>
                      {progress.averageTime > 0 && (
                        <div className="flex justify-between text-sm">
                          <span className="text-gray-600">Temps moyen</span>
                          <span className="font-medium text-purple-600">
                            {Math.round(progress.averageTime)}s
                          </span>
                        </div>
                      )}
                    </div>
                  )}

                  {/* Barre de progression */}
                  <div className="mb-4">
                    <div className="flex justify-between text-sm text-gray-600 mb-1">
                      <span>Progression niveau</span>
                      <span>{progress.correctAnswers}/100</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-gradient-to-r from-blue-500 to-purple-500 h-2 rounded-full transition-all duration-500"
                        style={{ width: `${Math.min((progress.correctAnswers / 100) * 100, 100)}%` }}
                      />
                    </div>
                  </div>

                  {/* Bouton de démarrage */}
                  <div className="text-center">
                    <div className="inline-flex items-center gap-2 bg-blue-500 text-white px-6 py-2 rounded-lg font-medium group-hover:bg-blue-600 transition-colors">
                      <Play className="w-4 h-4" />
                      {progress.totalAttempts > 0 ? 'Continuer' : 'Commencer'}
                    </div>
                  </div>
                </div>
              </Link>
            );
          })}
        </div>

        {/* Conseils */}
        <div className="mt-12">
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <div className="flex items-center gap-3 mb-4">
              <TrendingUp className="w-6 h-6 text-blue-600" />
              <h3 className="text-lg font-bold text-gray-800">
                Conseils pour progresser
              </h3>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
              <div className="space-y-2">
                <div className="font-medium text-gray-800">🎯 Stratégie</div>
                <ul className="text-gray-600 space-y-1">
                  <li>• Commence par l'addition pour t'échauffer</li>
                  <li>• Pratique chaque opération régulièrement</li>
                  <li>• Alterne entre les types d'exercices</li>
                </ul>
              </div>
              <div className="space-y-2">
                <div className="font-medium text-gray-800">💡 Astuces</div>
                <ul className="text-gray-600 space-y-1">
                  <li>• Prends ton temps pour bien comprendre</li>
                  <li>• Utilise les indices quand tu es bloqué</li>
                  <li>• Célèbre tes progrès !</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
