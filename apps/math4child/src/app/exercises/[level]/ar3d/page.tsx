'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import AR3DMath from '../../../../components/ar3d/AR3DMath';
import { generateExercise } from '../../../../data/exercises';
import { BranchInfoProvider } from '../../../../components/BranchInfo';

export default function AR3DPage() {
  const params = useParams();
  const level = parseInt(params.level as string) || 1;
  
  const [exercise, setExercise] = useState(generateExercise('multiplication', level, 'medium'));
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);

  const generateNewExercise = () => {
    const operations = ['addition', 'subtraction', 'multiplication', 'division'] as const;
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    const difficulties = ['easy', 'medium', 'hard'] as const;
    const randomDiff = difficulties[Math.floor(Math.random() * difficulties.length)];
    
    setExercise(generateExercise(randomOp, level, randomDiff));
    setIsCorrect(null);
  };

  const handleAnswer = (answer: number) => {
    setAttempts(prev => prev + 1);
    const correct = answer === exercise.answer;
    setIsCorrect(correct);
    
    if (correct) {
      setScore(prev => prev + exercise.points);
      setTimeout(() => {
        generateNewExercise();
      }, 2000);
    }
  };

  return (
    <BranchInfoProvider>
      <div className="min-h-screen bg-gradient-to-br from-orange-900 via-red-900 to-purple-900 text-white pt-20">
        <div className="max-w-7xl mx-auto px-4 py-20">
          {/* Header */}
          <div className="text-center mb-12">
            <h1 className="text-5xl font-bold mb-4 bg-gradient-to-r from-orange-400 to-red-400 bg-clip-text text-transparent">
              🥽 Mode Réalité Augmentée 3D
            </h1>
            <div className="flex justify-center items-center space-x-6 mb-6">
              <div className="bg-orange-500/20 px-4 py-2 rounded-full border border-orange-500/30">
                <span className="text-orange-400 font-bold">Niveau {level}</span>
              </div>
              <div className="bg-red-500/20 px-4 py-2 rounded-full border border-red-500/30">
                <span className="text-red-400 font-bold">Score: {score}</span>
              </div>
              <div className="bg-purple-500/20 px-4 py-2 rounded-full border border-purple-500/30">
                <span className="text-purple-400 font-bold">Interactions: {attempts}</span>
              </div>
            </div>
            <p className="text-xl text-gray-300">
              Visualise et manipule les mathématiques en environnement 3D immersif
            </p>
          </div>

          {/* Zone AR 3D */}
          <div className="mb-12">
            <AR3DMath
              exercise={{
                question: exercise.question,
                answer: exercise.answer,
                operation: exercise.operation
              }}
              onAnswer={handleAnswer}
            />
          </div>

          {/* Résultat */}
          {isCorrect !== null && (
            <div className={`max-w-2xl mx-auto p-8 rounded-2xl border mb-12 ${
              isCorrect 
                ? 'bg-green-500/20 border-green-500/30 text-green-400'
                : 'bg-orange-500/20 border-orange-500/30 text-orange-400'
            }`}>
              <div className="text-center">
                <div className="text-6xl mb-4">
                  {isCorrect ? '🎯' : '🔄'}
                </div>
                
                {isCorrect ? (
                  <div className="text-green-400 text-2xl font-bold">
                    🥽 Excellente manipulation 3D !
                    <div className="text-lg mt-2">
                      +{exercise.points} points pour la visualisation !
                    </div>
                  </div>
                ) : (
                  <div className="text-orange-400 text-xl">
                    🎮 Continue à explorer l'environnement 3D !
                    <div className="text-sm mt-2 text-gray-400">
                      La réponse correcte est {exercise.answer}
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Innovation showcase */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
            <div className="bg-gradient-to-br from-orange-500/20 to-red-500/20 p-8 rounded-2xl border border-orange-500/30">
              <div className="text-center mb-6">
                <div className="text-4xl mb-3">🔥</div>
                <h3 className="text-2xl font-bold text-orange-400">Révolution Pédagogique</h3>
              </div>
              <div className="space-y-4 text-gray-300">
                <div className="flex items-center">
                  <span className="text-green-400 mr-3 text-xl">🌐</span>
                  <div>
                    <div className="font-semibold">Environnement WebGL</div>
                    <div className="text-sm opacity-80">Rendu 3D temps réel optimisé</div>
                  </div>
                </div>
                <div className="flex items-center">
                  <span className="text-blue-400 mr-3 text-xl">🎮</span>
                  <div>
                    <div className="font-semibold">Manipulation Interactive</div>
                    <div className="text-sm opacity-80">Rotation, zoom, interaction objets</div>
                  </div>
                </div>
                <div className="flex items-center">
                  <span className="text-purple-400 mr-3 text-xl">🧮</span>
                  <div>
                    <div className="font-semibold">Géométrie Dynamique</div>
                    <div className="text-sm opacity-80">Concepts mathématiques visualisés</div>
                  </div>
                </div>
              </div>
            </div>

            <div className="bg-gradient-to-br from-purple-500/20 to-indigo-500/20 p-8 rounded-2xl border border-purple-500/30">
              <div className="text-center mb-6">
                <div className="text-4xl mb-3">🎯</div>
                <h3 className="text-2xl font-bold text-purple-400">Apprentissage Immersif</h3>
              </div>
              <div className="space-y-4 text-gray-300">
                <div className="flex items-center">
                  <span className="text-yellow-400 mr-3 text-xl">👁️</span>
                  <div>
                    <div className="font-semibold">Visualisation Spatiale</div>
                    <div className="text-sm opacity-80">Compréhension tridimensionnelle</div>
                  </div>
                </div>
                <div className="flex items-center">
                  <span className="text-green-400 mr-3 text-xl">🧠</span>
                  <div>
                    <div className="font-semibold">Connexions Neuronales</div>
                    <div className="text-sm opacity-80">Stimulation cognitive avancée</div>
                  </div>
                </div>
                <div className="flex items-center">
                  <span className="text-red-400 mr-3 text-xl">⚡</span>
                  <div>
                    <div className="font-semibold">Performance Optimisée</div>
                    <div className="text-sm opacity-80">60 FPS garanti sur tous appareils</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="text-center space-y-4">
            <button
              onClick={generateNewExercise}
              className="px-12 py-4 bg-gradient-to-r from-orange-600 to-red-600 hover:from-orange-700 hover:to-red-700 text-white rounded-lg font-semibold text-xl transition-all duration-300 shadow-lg"
            >
              🔄 Nouvel Environnement 3D
            </button>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-2xl mx-auto">
              <button className="py-3 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors">
                📊 Stats 3D
              </button>
              <button className="py-3 bg-orange-600 hover:bg-orange-700 text-white rounded-lg font-medium transition-colors">
                🎨 Thèmes
              </button>
              <button className="py-3 bg-purple-600 hover:bg-purple-700 text-white rounded-lg font-medium transition-colors">
                ⚙️ Qualité
              </button>
              <button className="py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium transition-colors">
                📱 Plein écran
              </button>
            </div>
          </div>

          {/* Instructions avancées */}
          <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🎮</div>
              <h4 className="font-semibold mb-2 text-center">Contrôles 3D</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Clic + glisser: rotation caméra</li>
                <li>• Molette: zoom avant/arrière</li>
                <li>• Clic objets: interaction directe</li>
                <li>• Touches fléchées: déplacement</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🌐</div>
              <h4 className="font-semibold mb-2 text-center">Environnement WebGL</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Rendu temps réel optimisé</li>
                <li>• Physique réaliste intégrée</li>
                <li>• Éclairage dynamique avancé</li>
                <li>• Compatibilité multi-navigateur</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🧮</div>
              <h4 className="font-semibold mb-2 text-center">Pédagogie 3D</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Visualisation concepts abstraits</li>
                <li>• Manipulation directe objets</li>
                <li>• Compréhension spatiale renforcée</li>
                <li>• Mémorisation améliorée</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </BranchInfoProvider>
  );
}
