'use client';

import React, { useState } from 'react';
import { AI4KidsLogo } from '../../components/AI4KidsLogo';
import { Button } from '../../components/ui/Button';
import { Card } from '../../components/ui/Card';
import { useLanguage } from '../../contexts/LanguageContext';
import Link from 'next/link';

export default function GamesPage() {
  const { translations } = useLanguage();
  const [currentGame, setCurrentGame] = useState<string | null>(null);
  const [mathQuestion, setMathQuestion] = useState<{question: string, answer: number} | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [score, setScore] = useState(0);
  const [feedback, setFeedback] = useState('');

  const generateMathQuestion = () => {
    const num1 = Math.floor(Math.random() * 10) + 1;
    const num2 = Math.floor(Math.random() * 10) + 1;
    const operators = ['+', '-', '*'];
    const operator = operators[Math.floor(Math.random() * operators.length)];
    
    let question = `${num1} ${operator} ${num2}`;
    let answer = 0;
    
    switch(operator) {
      case '+': answer = num1 + num2; break;
      case '-': answer = num1 - num2; break;
      case '*': answer = num1 * num2; break;
    }
    
    setMathQuestion({ question, answer });
    setUserAnswer('');
    setFeedback('');
  };

  const checkAnswer = () => {
    if (mathQuestion && parseInt(userAnswer) === mathQuestion.answer) {
      setScore(score + 1);
      setFeedback('🎉 Correct ! Bravo !');
      setTimeout(() => generateMathQuestion(), 1500);
    } else {
      setFeedback(`❌ Pas tout à fait. La réponse était ${mathQuestion?.answer}`);
      setTimeout(() => generateMathQuestion(), 2000);
    }
  };

  const games = [
    {
      id: 'math',
      title: 'Calcul Rapide',
      description: 'Résous les opérations mathématiques',
      icon: '🧮',
      color: 'bg-blue-500'
    },
    {
      id: 'colors',
      title: 'Couleurs Magiques',
      description: 'Apprends les couleurs en t\'amusant',
      icon: '🎨',
      color: 'bg-purple-500'
    },
    {
      id: 'animals',
      title: 'Animaux du Monde',
      description: 'Découvre les animaux et leurs cris',
      icon: '🦁',
      color: 'bg-green-500'
    },
    {
      id: 'memory',
      title: 'Jeu de Mémoire',
      description: 'Teste ta mémoire avec des cartes',
      icon: '🧠',
      color: 'bg-pink-500'
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-300 to-pink-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <Link href="/" className="flex items-center space-x-3">
            <AI4KidsLogo size={60} />
            <span className="text-white font-bold text-2xl">AI4KIDS</span>
          </Link>
          <Button variant="secondary" className="bg-white text-blue-600">
            <Link href="/">🏠 Accueil</Link>
          </Button>
        </div>

        {!currentGame ? (
          <>
            <div className="text-center mb-12">
              <h1 className="text-4xl font-bold text-white mb-4">
                🎮 {translations.gamesTitle}
              </h1>
              <p className="text-xl text-white/90">
                Choisis ton jeu préféré !
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {games.map((game) => (
                <Card key={game.id} className="text-center hover:scale-105 transition-transform">
                  <div className={`w-16 h-16 ${game.color} rounded-full flex items-center justify-center mx-auto mb-4`}>
                    <span className="text-2xl">{game.icon}</span>
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{game.title}</h3>
                  <p className="text-gray-600 mb-6">{game.description}</p>
                  <Button 
                    variant="primary" 
                    onClick={() => {
                      setCurrentGame(game.id);
                      if (game.id === 'math') generateMathQuestion();
                    }}
                  >
                    Jouer !
                  </Button>
                </Card>
              ))}
            </div>
          </>
        ) : (
          <div className="max-w-2xl mx-auto">
            <div className="text-center mb-8">
              <Button 
                variant="secondary" 
                onClick={() => setCurrentGame(null)}
                className="mb-4"
              >
                ← Retour aux jeux
              </Button>
              <div className="text-white">
                <span className="text-lg">Score: {score}</span>
              </div>
            </div>

            {currentGame === 'math' && (
              <Card className="text-center">
                <h2 className="text-3xl font-bold text-blue-600 mb-6">🧮 Calcul Rapide</h2>
                
                {mathQuestion && (
                  <div className="space-y-6">
                    <div className="text-4xl font-bold text-gray-800">
                      {mathQuestion.question} = ?
                    </div>
                    
                    <div className="flex items-center justify-center space-x-4">
                      <input
                        type="number"
                        value={userAnswer}
                        onChange={(e) => setUserAnswer(e.target.value)}
                        className="w-32 h-16 text-2xl text-center border-2 border-blue-300 rounded-lg focus:outline-none focus:border-blue-500"
                        placeholder="?"
                      />
                      <Button variant="primary" onClick={checkAnswer}>
                        Vérifier
                      </Button>
                    </div>
                    
                    {feedback && (
                      <div className="text-xl font-semibold text-center p-4 bg-gray-100 rounded-lg">
                        {feedback}
                      </div>
                    )}
                  </div>
                )}
              </Card>
            )}

            {currentGame === 'colors' && (
              <Card className="text-center">
                <h2 className="text-3xl font-bold text-purple-600 mb-6">🎨 Couleurs Magiques</h2>
                <div className="grid grid-cols-3 gap-4">
                  {['red', 'blue', 'green', 'yellow', 'purple', 'orange'].map(color => (
                    <div
                      key={color}
                      className={`w-20 h-20 rounded-full mx-auto cursor-pointer hover:scale-110 transition-transform bg-${color}-500`}
                      onClick={() => setFeedback(`Couleur: ${color}`)}
                    />
                  ))}
                </div>
                {feedback && (
                  <div className="mt-4 text-xl font-semibold">{feedback}</div>
                )}
              </Card>
            )}

            {currentGame === 'animals' && (
              <Card className="text-center">
                <h2 className="text-3xl font-bold text-green-600 mb-6">🦁 Animaux du Monde</h2>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {[
                    {emoji: '🐶', name: 'Chien', sound: 'Woof!'},
                    {emoji: '🐱', name: 'Chat', sound: 'Miaou!'},
                    {emoji: '🐮', name: 'Vache', sound: 'Meuh!'},
                    {emoji: '🐷', name: 'Cochon', sound: 'Groin!'},
                    {emoji: '🦁', name: 'Lion', sound: 'Roar!'},
                    {emoji: '🐸', name: 'Grenouille', sound: 'Croak!'},
                    {emoji: '🐔', name: 'Poule', sound: 'Cot cot!'},
                    {emoji: '🐴', name: 'Cheval', sound: 'Hiii!'}
                  ].map(animal => (
                    <div
                      key={animal.name}
                      className="p-4 bg-gray-100 rounded-lg cursor-pointer hover:bg-gray-200 transition-colors"
                      onClick={() => setFeedback(`${animal.emoji} ${animal.name}: ${animal.sound}`)}
                    >
                      <div className="text-4xl mb-2">{animal.emoji}</div>
                      <div className="text-sm font-semibold">{animal.name}</div>
                    </div>
                  ))}
                </div>
                {feedback && (
                  <div className="mt-4 text-xl font-semibold">{feedback}</div>
                )}
              </Card>
            )}

            {currentGame === 'memory' && (
              <Card className="text-center">
                <h2 className="text-3xl font-bold text-pink-600 mb-6">🧠 Jeu de Mémoire</h2>
                <div className="text-lg text-gray-600 mb-4">
                  Retourne les cartes pour trouver les paires !
                </div>
                <div className="grid grid-cols-4 gap-2">
                  {Array.from({length: 16}).map((_, i) => (
                    <div
                      key={i}
                      className="w-16 h-16 bg-blue-500 rounded-lg flex items-center justify-center text-white font-bold cursor-pointer hover:bg-blue-600 transition-colors"
                      onClick={() => setFeedback(`Carte ${i + 1} retournée !`)}
                    >
                      ?
                    </div>
                  ))}
                </div>
                {feedback && (
                  <div className="mt-4 text-lg font-semibold">{feedback}</div>
                )}
              </Card>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
