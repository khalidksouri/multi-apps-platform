'use client'

import React, { useRef, useState, useCallback, useEffect } from 'react'

interface Point {
  x: number;
  y: number;
  pressure?: number;
  timestamp: number;
}

interface HandwritingRecognitionProps {
  onAnswer: (answer: string) => void;
  placeholder?: string;
  className?: string;
}

export default function HandwritingRecognitionAdvanced({ 
  onAnswer, 
  placeholder = "Écrivez votre réponse ici...",
  className = ""
}: HandwritingRecognitionProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [points, setPoints] = useState<Point[]>([]);
  const [recognizedText, setRecognizedText] = useState('');

  const startDrawing = useCallback((e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    setIsDrawing(true);
    const canvas = canvasRef.current;
    if (!canvas) return;

    const rect = canvas.getBoundingClientRect();
    let clientX: number, clientY: number, pressure = 1;

    if ('touches' in e) {
      const touch = e.touches[0];
      clientX = touch.clientX;
      clientY = touch.clientY;
      // @ts-ignore - pressure peut ne pas exister sur tous les navigateurs
      pressure = touch.force || 1;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
      // @ts-ignore - pressure peut ne pas exister sur MouseEvent
      pressure = e.pressure || 1;
    }

    const point: Point = {
      x: clientX - rect.left,
      y: clientY - rect.top,
      pressure: typeof pressure === 'number' ? pressure : 1,
      timestamp: Date.now()
    };

    setPoints([point]);
  }, []);

  const draw = useCallback((e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    if (!isDrawing) return;

    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    if (!canvas || !ctx) return;

    const rect = canvas.getBoundingClientRect();
    let clientX: number, clientY: number, pressure = 1;

    if ('touches' in e) {
      const touch = e.touches[0];
      clientX = touch.clientX;
      clientY = touch.clientY;
      // @ts-ignore
      pressure = touch.force || 1;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
      // @ts-ignore
      pressure = e.pressure || 1;
    }

    const newPoint: Point = {
      x: clientX - rect.left,
      y: clientY - rect.top,
      pressure: typeof pressure === 'number' ? pressure : 1,
      timestamp: Date.now()
    };

    setPoints(prev => {
      const newPoints = [...prev, newPoint];
      
      // Dessiner la ligne
      if (prev.length > 0) {
        const lastPoint = prev[prev.length - 1];
        ctx.beginPath();
        ctx.moveTo(lastPoint.x, lastPoint.y);
        ctx.lineTo(newPoint.x, newPoint.y);
        ctx.strokeStyle = '#2563eb';
        ctx.lineWidth = 2 + (newPoint.pressure || 1) * 2;
        ctx.lineCap = 'round';
        ctx.stroke();
      }
      
      return newPoints;
    });
  }, [isDrawing]);

  const stopDrawing = useCallback(() => {
    setIsDrawing(false);
    // Simulation de reconnaissance - dans un vrai projet, utiliser une API
    simulateRecognition();
  }, []);

  const simulateRecognition = () => {
    // Simulation simple basée sur le nombre de points
    const pointCount = points.length;
    let recognized = '';
    
    if (pointCount < 10) {
      recognized = '1';
    } else if (pointCount < 20) {
      recognized = '2';
    } else if (pointCount < 40) {
      recognized = Math.floor(Math.random() * 10).toString();
    } else {
      recognized = Math.floor(Math.random() * 100).toString();
    }
    
    setRecognizedText(recognized);
    onAnswer(recognized);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    if (!canvas || !ctx) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setPoints([]);
    setRecognizedText('');
  };

  return (
    <div className={`handwriting-recognition ${className}`}>
      <div className="mb-4">
        <h3 className="text-lg font-bold text-gray-800 mb-2">✍️ Reconnaissance Manuscrite</h3>
        <p className="text-sm text-gray-600">{placeholder}</p>
      </div>
      
      <div className="bg-white border-2 border-gray-200 rounded-lg p-4">
        <canvas
          ref={canvasRef}
          width={300}
          height={200}
          className="border border-gray-300 rounded cursor-crosshair bg-gray-50"
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
          onTouchStart={startDrawing}
          onTouchMove={draw}
          onTouchEnd={stopDrawing}
        />
        
        <div className="mt-4 flex justify-between items-center">
          <button
            onClick={clearCanvas}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition-colors"
          >
            Effacer
          </button>
          
          {recognizedText && (
            <div className="bg-green-100 border border-green-300 rounded px-3 py-2">
              <span className="text-green-800 font-bold">Reconnu: {recognizedText}</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
