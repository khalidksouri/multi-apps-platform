'use client';

import React from 'react';
import { Translations } from '../lib/translations';

interface Exercise {
  id: number;
  question: string;
  answer: number;
  operation: string;
  difficulty: number;
  type: string;
  level: number;
}

interface ExerciseViewProps {
  exercise: Exercise;
  userAnswer: string;
  onAnswerChange: (answer: string) => void;
  onSubmit: () => void;
  onNext: () => void;
  onBack: () => void;
  showResult: boolean;
  isCorrect?: boolean;
  translations: Translations;
}

const ExerciseView: React.FC<ExerciseViewProps> = ({
  exercise,
  userAnswer,
  onAnswerChange,
  onSubmit,
  onNext,
  onBack,
  showResult,
  isCorrect,
  translations: t
}) => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-3xl p-12 shadow-xl text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-8">
            {t.exercise} {exercise.operation}
          </h2>
          
          <div className="text-6xl font-bold text-blue-600 mb-8">
            {exercise.question}
          </div>
          
          {!showResult ? (
            <div className="space-y-6">
              <input
                type="number"
                value={userAnswer}
                onChange={(e) => onAnswerChange(e.target.value)}
                className="text-4xl text-center border-2 border-gray-300 rounded-xl p-4 w-48 focus:border-blue-500 focus:outline-none"
                placeholder="?"
                autoFocus
              />
              
              <div className="flex gap-4 justify-center">
                <button
                  onClick={onBack}
                  className="btn-secondary"
                >
                  {t.back}
                </button>
                <button
                  onClick={onSubmit}
                  className="btn-primary"
                  disabled={!userAnswer}
                >
                  {t.validate}
                </button>
              </div>
            </div>
          ) : (
            <div className="space-y-6">
              <div className={`text-6xl ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                {isCorrect ? t.correct : t.incorrect}
              </div>
              
              <div className="text-2xl text-gray-700">
                {t.answerWas} <strong>{exercise.answer}</strong>
              </div>
              
              <button
                onClick={onNext}
                className="btn-primary"
              >
                {t.nextExercise}
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ExerciseView;
