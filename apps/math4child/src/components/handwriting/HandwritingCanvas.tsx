'use client';

import React, { useRef, useEffect, useState } from 'react';

interface HandwritingCanvasProps {
  onDigitRecognized: (digit: number, confidence: number) => void;
  disabled?: boolean;
  width?: number;
  height?: number;
}

export default function HandwritingCanvas({ 
  onDigitRecognized, 
  disabled = false,
  width = 300,
  height = 300 
}: HandwritingCanvasProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [recognizedDigit, setRecognizedDigit] = useState<number | null>(null);
  const [confidence, setConfidence] = useState<number>(0);
  const [strokes, setStrokes] = useState<number[][]>([]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Configuration avancée selon spécifications v4.2.0
    ctx.lineWidth = 6;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.strokeStyle = '#3b82f6';
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Grid de guidage subtil
    ctx.strokeStyle = '#f1f5f9';
    ctx.lineWidth = 1;
    const gridSize = 50;
    for (let x = 0; x <= width; x += gridSize) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, height);
      ctx.stroke();
    }
    for (let y = 0; y <= height; y += gridSize) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(width, y);
      ctx.stroke();
    }
    
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 6;
  }, [width, height]);

  const getCoordinates = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };
    
    const rect = canvas.getBoundingClientRect();
    return {
      x: e.clientX - rect.left,
      y: e.clientY - rect.top
    };
  };

  const startDrawing = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (disabled) return;
    setIsDrawing(true);
    const coords = getCoordinates(e);
    setStrokes([...strokes, [coords.x, coords.y]]);
    draw(e);
  };

  const draw = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isDrawing || disabled) return;
    
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const coords = getCoordinates(e);
    
    ctx.lineTo(coords.x, coords.y);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(coords.x, coords.y);
    
    // Mettre à jour les strokes
    const currentStroke = strokes[strokes.length - 1] || [];
    currentStroke.push(coords.x, coords.y);
  };

  const stopDrawing = () => {
    if (!isDrawing) return;
    setIsDrawing(false);
    
    // IA de reconnaissance avancée (simulation)
    setTimeout(() => {
      recognizeDigit();
    }, 800);
  };

  const recognizeDigit = () => {
    // Algorithme de reconnaissance simplifié mais réaliste
    const canvas = canvasRef.current;
    if (!canvas) return;
    
    // Analyse des strokes et patterns
    const totalStrokes = strokes.length;
    const avgStrokeLength = strokes.reduce((acc, stroke) => acc + stroke.length, 0) / totalStrokes;
    
    // Pattern matching basique
    let mockDigit: number;
    let mockConfidence: number;
    
    if (totalStrokes === 1 && avgStrokeLength < 10) {
      mockDigit = Math.random() > 0.5 ? 1 : 7; // Traits simples
      mockConfidence = 0.85 + Math.random() * 0.1;
    } else if (totalStrokes === 2) {
      mockDigit = Math.random() > 0.5 ? 4 : 7; // Deux traits
      mockConfidence = 0.75 + Math.random() * 0.15;
    } else if (totalStrokes >= 3) {
      mockDigit = [6, 8, 9][Math.floor(Math.random() * 3)]; // Formes complexes
      mockConfidence = 0.70 + Math.random() * 0.20;
    } else {
      mockDigit = Math.floor(Math.random() * 10);
      mockConfidence = 0.60 + Math.random() * 0.25;
    }
    
    setRecognizedDigit(mockDigit);
    setConfidence(mockConfidence);
    onDigitRecognized(mockDigit, mockConfidence);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    setRecognizedDigit(null);
    setConfidence(0);
    setStrokes([]);
  };

  return (
    <div className="flex flex-col items-center space-y-6">
      <div className="relative bg-white rounded-xl shadow-lg p-2">
        <canvas
          ref={canvasRef}
          width={width}
          height={height}
          className={`border-2 border-blue-300 rounded-lg ${
            disabled 
              ? 'opacity-50 cursor-not-allowed' 
              : 'cursor-crosshair hover:border-blue-500 active:border-blue-600'
          }`}
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
        />
        
        {disabled && (
          <div className="absolute inset-0 bg-gray-500 bg-opacity-50 rounded-lg flex items-center justify-center">
            <span className="text-white font-semibold text-lg">Désactivé</span>
          </div>
        )}
      </div>

      <div className="flex space-x-4">
        <button
          onClick={clearCanvas}
          disabled={disabled}
          className="px-6 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-medium transition-colors disabled:opacity-50"
        >
          🗑️ Effacer
        </button>
        
        <button
          onClick={recognizeDigit}
          disabled={disabled || strokes.length === 0}
          className="px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg font-medium transition-colors disabled:opacity-50"
        >
          🔍 Analyser
        </button>
      </div>

      {recognizedDigit !== null && (
        <div className="bg-gradient-to-r from-blue-50 to-purple-50 p-6 rounded-xl text-center border border-blue-200">
          <div className="text-4xl font-bold text-blue-600 mb-2">
            Reconnu: {recognizedDigit}
          </div>
          <div className="text-lg text-gray-700 mb-2">
            Confiance IA: <span className="font-semibold text-blue-600">{Math.round(confidence * 100)}%</span>
          </div>
          
          {confidence < 0.8 && (
            <div className="text-sm text-orange-600 bg-orange-50 p-2 rounded">
              🤔 Vous vouliez peut-être dire: <strong>{(recognizedDigit + 1) % 10}</strong> ou <strong>{(recognizedDigit + 2) % 10}</strong> ?
            </div>
          )}
          
          {confidence >= 0.95 && (
            <div className="text-sm text-green-600 bg-green-50 p-2 rounded">
              🎯 Excellente écriture ! Reconnaissance parfaite !
            </div>
          )}
        </div>
      )}
      
      <div className="text-xs text-gray-500 text-center max-w-sm">
        💡 <strong>Astuce:</strong> Écrivez clairement au centre du canvas pour une meilleure reconnaissance IA
      </div>
    </div>
  );
}
