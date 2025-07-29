'use client';

import React, { useState, useEffect } from 'react';

// Types TypeScript stricts
interface MathProblem {
  num1: number;
  num2: number;
  correctAnswer: number;
  operator: string;
}

type Operation = 'addition' | 'subtraction' | 'multiplication' | 'division';
type Level = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';

export default function ExercisesPage() {
  const [selectedOperation, setSelectedOperation] = useState<Operation>('addition');
  const [selectedLevel, setSelectedLevel] = useState<Level>('beginner');
  const [currentProblem, setCurrentProblem] = useState<MathProblem | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);

  const levelConfig = {
    beginner: { minNum: 1, maxNum: 10 },
    elementary: { minNum: 1, maxNum: 50 },
    intermediate: { minNum: 1, maxNum: 100 },
    advanced: { minNum: 1, maxNum: 500 },
    expert: { minNum: 1, maxNum: 1000 }
  };

  const randomInt = (min: number, max: number): number => 
    Math.floor(Math.random() * (max - min + 1)) + min;

  const generateExercise = (): MathProblem => {
    const config = levelConfig[selectedLevel];
    
    let num1: number = 1;
    let num2: number = 1;
    let correctAnswer: number = 2;
    let operator: string = '+';

    switch (selectedOperation) {
      case 'addition':
        operator = '+';
        num1 = randomInt(config.minNum, config.maxNum);
        num2 = randomInt(config.minNum, config.maxNum);
        correctAnswer = num1 + num2;
        break;
      
      case 'subtraction':
        operator = '-';
        num1 = randomInt(config.minNum, config.maxNum);
        num2 = randomInt(config.minNum, Math.min(num1, config.maxNum));
        if (num1 < num2) {
          [num1, num2] = [num2, num1];
        }
        correctAnswer = num1 - num2;
        break;
      
      case 'multiplication':
        operator = '×';
        num1 = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        correctAnswer = num1 * num2;
        break;
      
      case 'division':
        operator = '÷';
        correctAnswer = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = randomInt(2, 12);
        num1 = correctAnswer * num2;
        break;
    }

    return { num1, num2, correctAnswer, operator };
  };

  useEffect(() => {
    const problem = generateExercise();
    setCurrentProblem(problem);
    setUserAnswer('');
    setFeedback('');
  }, [selectedOperation, selectedLevel]);

  const checkAnswer = () => {
    if (!currentProblem || !userAnswer.trim()) return;

    const userNum = parseInt(userAnswer);
    const isCorrect = userNum === currentProblem.correctAnswer;
    
    setAttempts(prev => prev + 1);
    
    if (isCorrect) {
      setScore(prev => prev + 1);
      setFeedback('✅ Excellent ! Bonne réponse !');
    } else {
      setFeedback(`❌ Pas tout à fait ! La bonne réponse est ${currentProblem.correctAnswer}`);
    }
  };

  const nextProblem = () => {
    const newProblem = generateExercise();
    setCurrentProblem(newProblem);
    setUserAnswer('');
    setFeedback('');
  };

  const getOperationSymbol = (): string => {
    if (!currentProblem) return '+';
    return currentProblem.operator;
  };

  const handleMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1.05)';
  };

  const handleMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1)';
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-2xl p-6 shadow-lg mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Configuration de l'exercice</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Opération mathématique
              </label>
              <select
                value={selectedOperation}
                onChange={(e) => setSelectedOperation(e.target.value as Operation)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="addition">Addition (+)</option>
                <option value="subtraction">Soustraction (-)</option>
                <option value="multiplication">Multiplication (×)</option>
                <option value="division">Division (÷)</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Niveau de difficulté
              </label>
              <select
                value={selectedLevel}
                onChange={(e) => setSelectedLevel(e.target.value as Level)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="beginner">Débutant (1-10)</option>
                <option value="elementary">Élémentaire (1-50)</option>
                <option value="intermediate">Intermédiaire (1-100)</option>
                <option value="advanced">Avancé (1-500)</option>
                <option value="expert">Expert (1-1000)</option>
              </select>
            </div>
          </div>

          <div className="flex justify-center space-x-8 text-center">
            <div 
              className="bg-blue-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-blue-600">{score}</div>
              <div className="text-sm text-blue-800">Bonnes réponses</div>
            </div>
            <div 
              className="bg-green-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-green-600">{attempts}</div>
              <div className="text-sm text-green-800">Tentatives</div>
            </div>
            <div 
              className="bg-purple-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-purple-600">
                {attempts > 0 ? Math.round((score / attempts) * 100) : 0}%
              </div>
              <div className="text-sm text-purple-800">Précision</div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-3xl p-12 shadow-xl text-center">
          <div className="mb-4">
            <span className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium">
              {selectedOperation.charAt(0).toUpperCase() + selectedOperation.slice(1)} - {selectedLevel.charAt(0).toUpperCase() + selectedLevel.slice(1)}
            </span>
          </div>

          <h2 className="text-3xl font-bold text-gray-900 mb-8">
            Résous ce calcul
          </h2>
          
          {currentProblem && (
            <div className="text-6xl font-bold text-blue-600 mb-8">
              {currentProblem.num1} {getOperationSymbol()} {currentProblem.num2} = ?
            </div>
          )}
          
          <div className="space-y-6">
            <input
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              className="text-4xl text-center border-2 border-gray-300 rounded-xl p-4 w-48 focus:border-blue-500 focus:outline-none"
              placeholder="?"
              autoFocus
              onKeyPress={(e) => {
                if (e.key === 'Enter') {
                  checkAnswer();
                }
              }}
            />
            
            <div className="flex gap-4 justify-center">
              <button
                onClick={checkAnswer}
                className="px-8 py-4 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors font-semibold text-lg disabled:opacity-50"
                disabled={!userAnswer.trim()}
              >
                Vérifier
              </button>
              <button
                onClick={nextProblem}
                className="px-8 py-4 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors font-semibold text-lg"
              >
                Nouveau calcul
              </button>
            </div>
          </div>

          {feedback && (
            <div className={`mt-8 p-4 rounded-lg text-lg font-semibold ${
              feedback.includes('✅') 
                ? 'bg-green-100 text-green-800' 
                : 'bg-red-100 text-red-800'
            }`}>
              {feedback}
            </div>
          )}

          <div className="mt-8 pt-6 border-t border-gray-200">
            <div className="flex justify-center items-center space-x-6 text-sm text-gray-600">
              <span>🎯 Niveau: {selectedLevel}</span>
              <span>📊 Opération: {selectedOperation}</span>
              <span>🏆 Score: {score}/{attempts}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
