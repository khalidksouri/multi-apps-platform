'use client';

import { useState, useRef, useEffect } from 'react';

interface Exercise {
  id: string;
  type: string;
  level: string;
  question: {
    num1: number;
    num2: number;
    operator: string;
    correctAnswer: number;
  };
  userAnswer?: number;
  isCorrect?: boolean;
}

interface ExerciseViewProps {
  exercise: Exercise;
  exerciseCount: number;
  selectedOperation: { name: string } | null;
  selectedLevel: { name: string } | null;
  questionsRemaining: number;
  onSubmitAnswer: (answer: string) => void;
  onNextExercise: () => void;
  onBack: () => void;
  showResult: boolean;
}

export default function ExerciseView({
  exercise,
  exerciseCount,
  selectedOperation,
  selectedLevel,
  questionsRemaining,
  onSubmitAnswer,
  onNextExercise,
  onBack,
  showResult
}: ExerciseViewProps) {
  const [userAnswer, setUserAnswer] = useState('');
  const inputRef = useRef<HTMLInputElement>(null);

  // Debug logs
  useEffect(() => {
    console.log('🎯 ExerciseView rendu avec:', exercise);
    console.log('📝 Question:', `${exercise.question.num1} ${exercise.question.operator} ${exercise.question.num2} = ?`);
  }, [exercise]);

  // Focus automatique
  useEffect(() => {
    if (!showResult && inputRef.current) {
      setTimeout(() => {
        inputRef.current?.focus();
      }, 100);
    }
  }, [showResult, exercise.id]);

  const handleSubmit = () => {
    console.log('📝 Soumission réponse:', userAnswer);
    if (userAnswer.trim()) {
      onSubmitAnswer(userAnswer);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !showResult && userAnswer.trim()) {
      handleSubmit();
    }
  };

  const handleNext = () => {
    setUserAnswer('');
    onNextExercise();
  };

  const problemDisplay = `${exercise.question.num1} ${exercise.question.operator} ${exercise.question.num2} = ?`;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={onBack}
            className="btn-secondary"
          >
            ← Retour aux opérations
          </button>
          <div className="text-center">
            <h2 className="text-2xl font-bold text-gray-900">
              {selectedOperation?.name} - {selectedLevel?.name}
            </h2>
            <p className="text-gray-600">Exercise #{exerciseCount + 1}</p>
          </div>
          <div className="text-right">
            <p className="text-sm text-gray-600">Questions restantes</p>
            <p className="font-bold text-lg text-purple-600">
              {questionsRemaining}
            </p>
          </div>
        </div>

        {/* Zone d'exercice */}
        <div className="bg-white rounded-3xl p-12 shadow-2xl text-center">
          {/* Zone du problème - AFFICHAGE FORCÉ */}
          <div className="math-problem">
            <div className="problem-text">
              {problemDisplay}
            </div>
          </div>

          {/* Zone de debug visible */}
          <div className="debug-zone">
            <div className="debug-title">🔍 Debug Information</div>
            <div className="debug-item">
              📝 Problème: {exercise.question.num1} {exercise.question.operator} {exercise.question.num2} = {exercise.question.correctAnswer}
            </div>
            <div className="debug-item">
              ✏️ Valeur input: "{userAnswer}"
            </div>
            <div className="debug-item">
              🎯 Type: {exercise.type} | Niveau: {exercise.level}
            </div>
          </div>

          {!showResult ? (
            <div className="space-y-8">
              <div>
                <label htmlFor="answer-input" className="block text-lg font-semibold text-gray-700 mb-4">
                  Saisir ta réponse :
                </label>
                <input
                  id="answer-input"
                  ref={inputRef}
                  type="number"
                  value={userAnswer}
                  onChange={(e) => {
                    console.log('✏️ Changement input:', e.target.value);
                    setUserAnswer(e.target.value);
                  }}
                  onKeyPress={handleKeyPress}
                  placeholder="Ta réponse..."
                  className="math-input"
                  autoFocus
                  inputMode="numeric"
                  autoComplete="off"
                />
              </div>
              <button
                onClick={handleSubmit}
                disabled={!userAnswer.trim()}
                className="btn-primary text-xl disabled:opacity-50 disabled:cursor-not-allowed"
              >
                ✓ Valider ma réponse
              </button>
            </div>
          ) : (
            <div className="space-y-8 result-animation">
              <div className={`text-8xl ${exercise.isCorrect ? 'text-green-500' : 'text-red-500'}`}>
                {exercise.isCorrect ? '🎉' : '😢'}
              </div>
              <div className={`text-3xl font-bold ${exercise.isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                {exercise.isCorrect ? 'Bravo ! C\'est correct !' : 'Pas tout à fait...'}
              </div>
              <div className="text-2xl text-gray-700">
                <p className="mb-2">Ta réponse : <span className="font-bold">{exercise.userAnswer}</span></p>
                <p>La bonne réponse est : <span className="font-bold text-green-600">{exercise.question.correctAnswer}</span></p>
              </div>
              {exercise.isCorrect && (
                <div className="text-lg text-blue-600 bg-blue-50 p-4 rounded-xl">
                  🎯 Bien joué ! Tu as gagné 1 point vers le prochain niveau !
                </div>
              )}
              <button
                onClick={handleNext}
                className="btn-primary text-xl"
              >
                Exercice suivant →
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
