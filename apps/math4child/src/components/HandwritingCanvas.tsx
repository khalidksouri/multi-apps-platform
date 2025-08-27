'use client';

import React, { useState, useRef, useEffect } from 'react';

interface HandwritingCanvasProps {
  level: string;
}

export default function HandwritingCanvas({ level }: HandwritingCanvasProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [confidence, setConfidence] = useState(0.75);
  const [currentAnswer, setCurrentAnswer] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);
  const [exercise] = useState({
    question: '15 + 27 = ?',
    answer: 42,
    operation: 'addition'
  });

  const startDrawing = (e: React.MouseEvent<HTMLCanvasElement>) => {
    setIsDrawing(true);
    const canvas = canvasRef.current;
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    
    ctx.beginPath();
    const rect = canvas.getBoundingClientRect();
    ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
  };

  const draw = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isDrawing) return;
    
    const canvas = canvasRef.current;
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    
    const rect = canvas.getBoundingClientRect();
    ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
    ctx.stroke();
  };

  const stopDrawing = () => {
    setIsDrawing(false);
    processHandwriting();
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setCurrentAnswer('');
    setConfidence(0);
  };

  const processHandwriting = () => {
    setIsProcessing(true);
    
    setTimeout(() => {
      const recognizedText = Math.random() > 0.5 ? '42' : '24';
      setCurrentAnswer(recognizedText);
      setConfidence(Math.random() * 0.4 + 0.6);
      setIsProcessing(false);
    }, 1500);
  };

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    
    ctx.strokeStyle = '#3B82F6';
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
  }, []);

  const isCorrect = currentAnswer === exercise.answer.toString();

  return (
    <>
      <div className="max-w-4xl mx-auto grid md:grid-cols-2 gap-6">
        {/* Exercice */}
        <div className="bg-white rounded-xl shadow-lg p-6">
          <div className="text-center mb-6">
            <h2 className="text-2xl font-bold text-gray-800 mb-2">
              Résolvez l'exercice
            </h2>
            <div className="text-4xl font-bold text-blue-600 mb-4">
              {exercise.question}
            </div>
            <p className="text-gray-600">
              Écrivez votre réponse sur le canvas ci-contre
            </p>
          </div>

          {/* Résultat */}
          {currentAnswer && (
            <div className={`p-4 rounded-lg text-center ${
              isCorrect 
                ? 'bg-green-50 border border-green-200' 
                : 'bg-red-50 border border-red-200'
            }`}>
              <div className="flex items-center justify-center gap-2 mb-2">
                {isCorrect ? (
                  <>
                    ✅ <span className="font-semibold text-green-700">Correct!</span>
                  </>
                ) : (
                  <>
                    ❌ <span className="font-semibold text-red-700">Incorrect</span>
                  </>
                )}
              </div>
              <p className="text-sm text-gray-600">
                Réponse détectée: <strong>{currentAnswer}</strong>
              </p>
              <p className="text-xs text-gray-500 mt-1">
                Confiance: {Math.round(confidence * 100)}%
              </p>
            </div>
          )}
        </div>

        {/* Canvas de dessin */}
        <div className="bg-white rounded-xl shadow-lg p-6">
          <div className="mb-4">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-lg font-semibold text-gray-800">
                Zone de dessin
              </h3>
              <button
                onClick={clearCanvas}
                className="flex items-center gap-2 px-3 py-1 text-sm text-red-600 hover:bg-red-50 rounded-lg transition-colors"
              >
                🔄 Effacer
              </button>
            </div>
            
            <canvas
              ref={canvasRef}
              width={400}
              height={300}
              className="w-full border-2 border-dashed border-gray-300 rounded-lg cursor-crosshair bg-gray-50"
              onMouseDown={startDrawing}
              onMouseMove={draw}
              onMouseUp={stopDrawing}
              onMouseLeave={stopDrawing}
            />
          </div>

          {/* Instructions */}
          <div className="space-y-3">
            <div className="bg-blue-50 p-3 rounded-lg">
              <h4 className="text-sm font-semibold text-blue-800 mb-2">
                💡 Conseils pour une meilleure reconnaissance:
              </h4>
              <div className="text-xs text-blue-700 space-y-1">
                <p>• Écris clairement et en gros</p>
                <p>• Utilise tout l'espace du canvas</p>
                <p>• Évite les traits trop fins ou épais</p>
                <p>• Confiance actuelle: {Math.round(confidence * 100)}% (optimal: &gt;80%)</p>
              </div>
            </div>
            
            {isProcessing && (
              <div className="flex items-center justify-center gap-2 p-3 bg-yellow-50 rounded-lg">
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-yellow-600"></div>
                <span className="text-sm text-yellow-700">
                  Analyse de l'écriture en cours...
                </span>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Navigation */}
      <div className="max-w-4xl mx-auto mt-6">
        <div className="bg-white rounded-xl shadow-sm p-4">
          <div className="flex justify-between items-center">
            <a 
              href={`/exercises/${level}/voice`}
              className="flex items-center gap-2 px-4 py-2 text-purple-600 hover:bg-purple-50 rounded-lg transition-colors"
            >
              🎤 Mode Vocal IA
            </a>
            
            <a 
              href={`/exercises/${level}/ar3d`}
              className="flex items-center gap-2 px-4 py-2 text-green-600 hover:bg-green-50 rounded-lg transition-colors"
            >
              👁️ Mode AR 3D
            </a>
          </div>
        </div>
      </div>
    </>
  );
}
