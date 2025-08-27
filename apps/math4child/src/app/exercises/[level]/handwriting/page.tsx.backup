'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import HandwritingCanvas from '../../../../components/handwriting/HandwritingCanvas';
import { generateExercise } from '../../../../data/exercises';
import { BranchInfoProvider } from '../../../../components/BranchInfo';

export default function HandwritingPage() {
  const params = useParams();
  const level = parseInt(params.level as string) || 1;
  
  const [exercise, setExercise] = useState(generateExercise('addition', level, 'medium'));
  const [recognizedDigit, setRecognizedDigit] = useState<number | null>(null);
  const [confidence, setConfidence] = useState<number>(0);
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);

  const generateNewExercise = () => {
    const operations = ['addition', 'subtraction', 'multiplication', 'division'] as const;
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    const difficulties = ['easy', 'medium', 'hard'] as const;
    const randomDiff = difficulties[Math.floor(Math.random() * difficulties.length)];
    
    setExercise(generateExercise(randomOp, level, randomDiff));
    setRecognizedDigit(null);
    setConfidence(0);
    setIsCorrect(null);
  };

  const handleDigitRecognized = (digit: number, conf: number) => {
    setRecognizedDigit(digit);
    setConfidence(conf);
    setAttempts(prev => prev + 1);
    
    const correct = digit === exercise.answer;
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
      <div className="min-h-screen bg-gradient-to-br from-green-900 via-blue-900 to-teal-900 text-white pt-20">
        <div className="max-w-6xl mx-auto px-4 py-20">
          {/* Header avec statistiques */}
          <div className="text-center mb-12">
            <h1 className="text-5xl font-bold mb-4 bg-gradient-to-r from-green-400 to-blue-400 bg-clip-text text-transparent">
              ✏️ Mode Reconnaissance Manuscrite
            </h1>
            <div className="flex justify-center items-center space-x-6 mb-6">
              <div className="bg-green-500/20 px-4 py-2 rounded-full border border-green-500/30">
                <span className="text-green-400 font-bold">Niveau {level}</span>
              </div>
              <div className="bg-blue-500/20 px-4 py-2 rounded-full border border-blue-500/30">
                <span className="text-blue-400 font-bold">Score: {score}</span>
              </div>
              <div className="bg-purple-500/20 px-4 py-2 rounded-full border border-purple-500/30">
                <span className="text-purple-400 font-bold">Tentatives: {attempts}</span>
              </div>
            </div>
            <p className="text-xl text-gray-300">
              Écris ta réponse avec ton doigt, stylet ou souris sur le canvas IA
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Zone d'exercice */}
            <div className="bg-black/30 backdrop-blur-sm border border-green-500/20 rounded-2xl p-8">
              <div className="text-center mb-8">
                <div className="bg-gradient-to-r from-green-400 to-blue-400 text-transparent bg-clip-text text-7xl font-bold mb-4">
                  {exercise.question}
                </div>
                <p className="text-gray-300 text-lg">
                  Écris la réponse sur le canvas ci-dessous
                </p>
                <div className="mt-4 flex justify-center space-x-4">
                  <span className="bg-green-500/20 px-3 py-1 rounded-full text-green-400 text-sm border border-green-500/30">
                    {exercise.operation.charAt(0).toUpperCase() + exercise.operation.slice(1)}
                  </span>
                  <span className="bg-blue-500/20 px-3 py-1 rounded-full text-blue-400 text-sm border border-blue-500/30">
                    {exercise.difficulty.charAt(0).toUpperCase() + exercise.difficulty.slice(1)}
                  </span>
                  <span className="bg-purple-500/20 px-3 py-1 rounded-full text-purple-400 text-sm border border-purple-500/30">
                    {exercise.points} points
                  </span>
                </div>
              </div>

              <div className="flex justify-center">
                <HandwritingCanvas
                  onDigitRecognized={handleDigitRecognized}
                  width={400}
                  height={400}
                />
              </div>
            </div>

            {/* Zone de résultats et feedback */}
            <div className="space-y-6">
              {/* Résultat reconnaissance */}
              {recognizedDigit !== null && (
                <div className={`p-6 rounded-2xl border ${
                  isCorrect 
                    ? 'bg-green-500/20 border-green-500/30 text-green-400'
                    : 'bg-orange-500/20 border-orange-500/30 text-orange-400'
                }`}>
                  <div className="text-center">
                    <div className="text-6xl font-bold mb-4">
                      {recognizedDigit}
                    </div>
                    <div className="text-2xl font-semibold mb-2">
                      Confiance IA: {Math.round(confidence * 100)}%
                    </div>
                    
                    {isCorrect ? (
                      <div className="text-green-400 text-2xl font-bold">
                        ✅ Parfait ! Excellente écriture !
                        <div className="text-lg mt-2">
                          +{exercise.points} points gagnés !
                        </div>
                      </div>
                    ) : (
                      <div className="text-orange-400 text-xl">
                        🤔 Tu as écrit {recognizedDigit}, mais la réponse est {exercise.answer}
                        <div className="text-sm mt-2 text-gray-400">
                          Essaie de réécrire plus clairement !
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* Suggestions IA */}
              {confidence < 0.8 && recognizedDigit !== null && (
                <div className="bg-blue-500/20 p-4 rounded-xl border border-blue-500/30">
                  <div className="text-blue-400 font-semibold mb-2">💡 Suggestions IA:</div>
                  <div className="text-sm text-gray-300 space-y-1">
                    <p>• Écris plus lentement et clairement</p>
                    <p>• Utilise tout l'espace du canvas</p>
                    <p>• Évite les traits trop fins ou épais</p>
                    <p>• Confiance actuelle: {Math.round(confidence * 100)}% (optimal: >80%)</p>
                  </div>
                  <div className="mt-3">
                    <p className="text-sm">
                      🤖 Peut-être vouliez-vous écrire: 
                      <span className="font-bold text-blue-400 ml-2">
                        {(recognizedDigit + 1) % 10} ou {(recognizedDigit + 2) % 10} ?
                      </span>
                    </p>
                  </div>
                </div>
              )}

              {/* Innovation showcase */}
              <div className="bg-gradient-to-br from-purple-500/20 to-pink-500/20 p-6 rounded-2xl border border-purple-500/30">
                <div className="text-center mb-4">
                  <div className="text-3xl mb-2">🌟</div>
                  <h3 className="text-xl font-bold text-purple-400">Innovation Mondiale</h3>
                </div>
                <div className="space-y-3 text-sm text-gray-300">
                  <div className="flex items-center">
                    <span className="text-green-400 mr-2">🧠</span>
                    Reconnaissance IA temps réel
                  </div>
                  <div className="flex items-center">
                    <span className="text-blue-400 mr-2">📊</span>
                    Analyse de courbure et patterns
                  </div>
                  <div className="flex items-center">
                    <span className="text-purple-400 mr-2">⚡</span>
                    Support multi-touch et souris
                  </div>
                  <div className="flex items-center">
                    <span className="text-orange-400 mr-2">💫</span>
                    Feedback adaptatif selon confiance
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className="space-y-3">
                <button
                  onClick={generateNewExercise}
                  className="w-full py-3 bg-gradient-to-r from-green-600 to-blue-600 hover:from-green-700 hover:to-blue-700 text-white rounded-lg font-semibold transition-all duration-300 shadow-lg"
                >
                  ➡️ Exercice Suivant
                </button>
                
                <div className="grid grid-cols-2 gap-3">
                  <button className="py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors">
                    📊 Statistiques
                  </button>
                  <button className="py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-lg font-medium transition-colors">
                    🎯 Paramètres IA
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Instructions et conseils */}
          <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">✏️</div>
              <h4 className="font-semibold mb-2 text-center">Comment écrire</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Écris au centre du canvas</li>
                <li>• Utilise des traits clairs</li>
                <li>• Évite les gribouillages</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🧠</div>
              <h4 className="font-semibold mb-2 text-center">IA Recognition</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Analyse temps réel</li>
                <li>• Confiance mesurée</li>
                <li>• Suggestions intelligentes</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🎯</div>
              <h4 className="font-semibold mb-2 text-center">Progression</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Points par exercice</li>
                <li>• Niveau adaptatif</li>
                <li>• Stats détaillées</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </BranchInfoProvider>
  );
}
