'use client';

import React, { useRef, useEffect, useState } from 'react';

interface AR3DMathProps {
  exercise: {
    question: string;
    answer: number;
    operation: string;
  };
  onAnswer: (answer: number) => void;
}

export default function AR3DMath({ exercise, onAnswer }: AR3DMathProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [objects3D, setObjects3D] = useState<any[]>([]);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);

  useEffect(() => {
    initializeAR3D();
  }, [exercise]);

  const initializeAR3D = () => {
    // Simulation 3D WebGL pour la démo
    setTimeout(() => {
      setIsLoaded(true);
      generateMathObjects();
    }, 1000);
  };

  const generateMathObjects = () => {
    const { operation } = exercise;
    
    // Génération d'objets 3D selon l'opération
    switch (operation) {
      case 'addition':
        setObjects3D([
          { type: 'cube', count: 5, color: 'blue', position: { x: -2, y: 0, z: 0 } },
          { type: 'cube', count: 3, color: 'red', position: { x: 2, y: 0, z: 0 } },
          { type: 'plus', color: 'green', position: { x: 0, y: 1, z: 0 } }
        ]);
        break;
      case 'multiplication':
        setObjects3D([
          { type: 'grid', rows: 4, cols: 3, color: 'purple', position: { x: 0, y: 0, z: 0 } },
          { type: 'multiply', color: 'orange', position: { x: 0, y: 2, z: 0 } }
        ]);
        break;
      default:
        setObjects3D([
          { type: 'sphere', count: 8, color: 'yellow', position: { x: 0, y: 0, z: 0 } }
        ]);
    }
  };

  const handleObjectClick = (value: number) => {
    setSelectedAnswer(value);
    onAnswer(value);
  };

  return (
    <div className="w-full max-w-4xl mx-auto">
      <div className="bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-900 rounded-2xl p-6 text-white">
        <div className="text-center mb-6">
          <h3 className="text-2xl font-bold mb-2">🥽 Réalité Augmentée Mathématique</h3>
          <p className="text-gray-300">Visualise et manipule les concepts en 3D</p>
        </div>

        <div className="relative bg-black/50 rounded-xl h-96 flex items-center justify-center mb-6">
          <canvas 
            ref={canvasRef}
            className="w-full h-full rounded-xl"
            style={{ background: 'linear-gradient(45deg, #1a1a2e, #16213e, #0f3460)' }}
          />
          
          {!isLoaded ? (
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="text-center">
                <div className="animate-spin text-6xl mb-4">🌀</div>
                <p className="text-white">Chargement environnement 3D...</p>
              </div>
            </div>
          ) : (
            <div className="absolute inset-0 flex items-center justify-center">
              {/* Simulation objets 3D */}
              <div className="grid grid-cols-3 gap-8 items-center">
                {exercise.operation === 'addition' && (
                  <>
                    {/* Groupe d'objets gauche */}
                    <div className="text-center">
                      <div className="flex justify-center flex-wrap gap-1 mb-2">
                        {[...Array(5)].map((_, i) => (
                          <div key={i} className="w-8 h-8 bg-blue-500 rounded transform rotate-12 shadow-lg animate-bounce" 
                               style={{ animationDelay: `${i * 0.1}s` }} />
                        ))}
                      </div>
                      <p className="text-blue-300 font-bold">5 objets</p>
                    </div>
                    
                    {/* Opérateur */}
                    <div className="text-center">
                      <div className="text-6xl text-green-400 animate-pulse">+</div>
                    </div>
                    
                    {/* Groupe d'objets droite */}
                    <div className="text-center">
                      <div className="flex justify-center flex-wrap gap-1 mb-2">
                        {[...Array(3)].map((_, i) => (
                          <div key={i} className="w-8 h-8 bg-red-500 rounded transform -rotate-12 shadow-lg animate-bounce"
                               style={{ animationDelay: `${(i + 5) * 0.1}s` }} />
                        ))}
                      </div>
                      <p className="text-red-300 font-bold">3 objets</p>
                    </div>
                  </>
                )}
                
                {exercise.operation === 'multiplication' && (
                  <div className="col-span-3 text-center">
                    <div className="grid grid-cols-4 gap-2 justify-center mb-4 max-w-xs mx-auto">
                      {[...Array(12)].map((_, i) => (
                        <div key={i} className="w-6 h-6 bg-purple-500 rounded shadow animate-pulse"
                             style={{ animationDelay: `${i * 0.05}s` }} />
                      ))}
                    </div>
                    <p className="text-purple-300 font-bold">3 × 4 = 12 objets</p>
                  </div>
                )}
              </div>
            </div>
          )}
          
          {/* Contrôles 3D */}
          <div className="absolute top-4 right-4 space-y-2">
            <button className="bg-white/20 text-white px-3 py-1 rounded text-sm hover:bg-white/30 transition-colors">
              🔄 Rotation
            </button>
            <button className="bg-white/20 text-white px-3 py-1 rounded text-sm hover:bg-white/30 transition-colors">
              🔍 Zoom
            </button>
            <button className="bg-white/20 text-white px-3 py-1 rounded text-sm hover:bg-white/30 transition-colors">
              🎨 Couleur
            </button>
          </div>
        </div>

        {/* Question et réponses interactives */}
        <div className="text-center">
          <h4 className="text-xl font-bold mb-4">{exercise.question}</h4>
          
          <div className="grid grid-cols-3 gap-4 max-w-md mx-auto">
            {[exercise.answer - 1, exercise.answer, exercise.answer + 1].map((option, index) => (
              <button
                key={index}
                onClick={() => handleObjectClick(option)}
                className={`
                  p-4 rounded-xl font-bold text-xl transition-all duration-300 transform hover:scale-105
                  ${selectedAnswer === option
                    ? 'bg-green-500 text-white scale-105 shadow-lg'
                    : 'bg-white/20 text-white hover:bg-white/30'
                  }
                `}
              >
                {option}
              </button>
            ))}
          </div>
          
          {selectedAnswer !== null && (
            <div className="mt-4 p-4 bg-white/10 rounded-xl">
              {selectedAnswer === exercise.answer ? (
                <p className="text-green-400 font-bold text-lg">
                  ✅ Excellent ! Tu as visualisé correctement !
                </p>
              ) : (
                <p className="text-orange-400 font-bold text-lg">
                  🤔 Observe bien les objets 3D et réessaie !
                </p>
              )}
            </div>
          )}
        </div>

        {/* Instructions */}
        <div className="mt-6 text-center">
          <div className="text-xs text-gray-400 bg-black/30 p-3 rounded">
            <p className="font-semibold mb-1">🎮 <strong>Contrôles AR 3D:</strong></p>
            <p>• Clique et glisse pour faire tourner • Molette pour zoomer • Clique sur les objets pour interagir</p>
          </div>
        </div>
      </div>
    </div>
  );
}
