import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

// Données éducatives
const mathQuestions = [
  { question: "2 + 3 = ?", answer: 5, options: [4, 5, 6, 7] },
  { question: "7 - 4 = ?", answer: 3, options: [2, 3, 4, 5] },
  { question: "3 × 4 = ?", answer: 12, options: [10, 11, 12, 13] },
  { question: "15 ÷ 3 = ?", answer: 5, options: [4, 5, 6, 7] },
  { question: "6 + 9 = ?", answer: 15, options: [14, 15, 16, 17] },
];

const animals = [
  { name: "🦁 Lion", sound: "Roar!", fact: "Les lions peuvent courir jusqu'à 80 km/h !" },
  { name: "🐘 Éléphant", sound: "Trumpet!", fact: "Les éléphants peuvent se souvenir pendant 25 ans !" },
  { name: "🐧 Pingouin", sound: "Squawk!", fact: "Les pingouins peuvent nager jusqu'à 35 km/h !" },
  { name: "🦒 Girafe", sound: "Hum!", fact: "Les girafes ont le même nombre de vertèbres que nous !" },
  { name: "🐨 Koala", sound: "Grunt!", fact: "Les koalas dorment 20 heures par jour !" },
];

const colors = [
  { name: "Rouge", hex: "#ef4444", emoji: "🔴" },
  { name: "Bleu", hex: "#3b82f6", emoji: "🔵" },
  { name: "Vert", hex: "#10b981", emoji: "🟢" },
  { name: "Jaune", hex: "#f59e0b", emoji: "🟡" },
  { name: "Violet", hex: "#8b5cf6", emoji: "🟣" },
  { name: "Orange", hex: "#f97316", emoji: "🟠" },
];

type ActivityType = 'math' | 'animals' | 'colors' | 'home';

const App: React.FC = () => {
  const [currentActivity, setCurrentActivity] = useState<ActivityType>('home');
  const [isNative, setIsNative] = useState(false);
  const [score, setScore] = useState(0);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [showFeedback, setShowFeedback] = useState('');

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    // Charger le score
    const savedScore = localStorage.getItem('ai4kids_score');
    if (savedScore) {
      setScore(parseInt(savedScore));
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const saveScore = (newScore: number) => {
    setScore(newScore);
    localStorage.setItem('ai4kids_score', newScore.toString());
  };

  const handleMathAnswer = async (selectedAnswer: number) => {
    await triggerHaptic();
    const correct = selectedAnswer === mathQuestions[currentQuestion].answer;
    
    if (correct) {
      const newScore = score + 1;
      saveScore(newScore);
      setShowFeedback('🎉 Correct !');
      await triggerHaptic(ImpactStyle.Medium);
    } else {
      setShowFeedback('❌ Essaie encore !');
      await triggerHaptic(ImpactStyle.Heavy);
    }

    setTimeout(() => {
      setShowFeedback('');
      if (currentQuestion < mathQuestions.length - 1) {
        setCurrentQuestion(currentQuestion + 1);
      } else {
        setCurrentQuestion(0);
      }
    }, 1500);
  };

  const playAnimalSound = async (animal: typeof animals[0]) => {
    await triggerHaptic(ImpactStyle.Light);
    setShowFeedback(`${animal.name} fait : ${animal.sound}`);
    setTimeout(() => setShowFeedback(''), 2000);
  };

  const showColorInfo = async (color: typeof colors[0]) => {
    await triggerHaptic(ImpactStyle.Light);
    setShowFeedback(`${color.emoji} ${color.name}`);
    setTimeout(() => setShowFeedback(''), 2000);
  };

  const renderHomeScreen = () => (
    <div className="text-center space-y-6">
      <div className="text-8xl mb-4">🎨</div>
      <h2 className="text-3xl font-bold text-white mb-6">AI4Kids</h2>
      <p className="text-white/80 mb-8">Apprends en t'amusant !</p>
      
      <div className="grid grid-cols-1 gap-4">
        <button
          onClick={() => setCurrentActivity('math')}
          className="bg-blue-500/30 hover:bg-blue-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🧮</div>
          <div className="text-white font-bold text-lg">Mathématiques</div>
          <div className="text-white/70 text-sm">Résous des calculs amusants</div>
        </button>

        <button
          onClick={() => setCurrentActivity('animals')}
          className="bg-green-500/30 hover:bg-green-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🦁</div>
          <div className="text-white font-bold text-lg">Animaux</div>
          <div className="text-white/70 text-sm">Découvre le monde animal</div>
        </button>

        <button
          onClick={() => setCurrentActivity('colors')}
          className="bg-purple-500/30 hover:bg-purple-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🌈</div>
          <div className="text-white font-bold text-lg">Couleurs</div>
          <div className="text-white/70 text-sm">Apprends les couleurs</div>
        </button>
      </div>

      <div className="mt-8 bg-white/10 backdrop-blur-lg rounded-xl p-4 border border-white/20">
        <div className="text-white/70 text-sm">Score total</div>
        <div className="text-2xl font-bold text-yellow-300">{score} points</div>
      </div>
    </div>
  );

  const renderMathActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🧮</div>
      <h3 className="text-2xl font-bold text-white mb-6">Mathématiques</h3>
      
      <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-6">
        <div className="text-3xl font-bold text-white mb-6">
          {mathQuestions[currentQuestion].question}
        </div>
        
        <div className="grid grid-cols-2 gap-4">
          {mathQuestions[currentQuestion].options.map((option, index) => (
            <button
              key={index}
              onClick={() => handleMathAnswer(option)}
              className="bg-blue-500/30 hover:bg-blue-500/50 text-white font-bold py-4 px-6 rounded-xl transition-all duration-200 active:scale-95 text-xl"
            >
              {option}
            </button>
          ))}
        </div>
      </div>

      <div className="text-white/70">
        Question {currentQuestion + 1} sur {mathQuestions.length}
      </div>
      <div className="text-yellow-300 font-bold">Score: {score}</div>
    </div>
  );

  const renderAnimalsActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🦁</div>
      <h3 className="text-2xl font-bold text-white mb-6">Animaux</h3>
      
      <div className="grid grid-cols-1 gap-4 mb-6">
        {animals.map((animal, index) => (
          <div key={index} className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <button
              onClick={() => playAnimalSound(animal)}
              className="w-full text-left hover:bg-white/10 rounded-xl p-4 transition-colors"
            >
              <div className="text-4xl mb-2">{animal.name}</div>
              <div className="text-white/70 text-sm">{animal.fact}</div>
            </button>
          </div>
        ))}
      </div>
    </div>
  );

  const renderColorsActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🌈</div>
      <h3 className="text-2xl font-bold text-white mb-6">Couleurs</h3>
      
      <div className="grid grid-cols-2 gap-4">
        {colors.map((color, index) => (
          <button
            key={index}
            onClick={() => showColorInfo(color)}
            className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 transition-all duration-200 active:scale-95 hover:bg-white/20"
            style={{ backgroundColor: `${color.hex}40` }}
          >
            <div className="text-4xl mb-2">{color.emoji}</div>
            <div className="text-white font-bold">{color.name}</div>
          </button>
        ))}
      </div>
    </div>
  );

  const renderCurrentActivity = () => {
    switch (currentActivity) {
      case 'math':
        return renderMathActivity();
      case 'animals':
        return renderAnimalsActivity();
      case 'colors':
        return renderColorsActivity();
      default:
        return renderHomeScreen();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-500 to-rose-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">🎨 AI4Kids</h1>
              <p className="text-white/80">Application Éducative</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Contenu principal */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 min-h-[500px]">
            {renderCurrentActivity()}
          </div>

          {/* Feedback */}
          {showFeedback && (
            <div className="fixed inset-0 flex items-center justify-center z-50 bg-black/50">
              <div className="bg-white rounded-2xl p-8 max-w-sm mx-4 text-center transform animate-pulse">
                <div className="text-4xl mb-4">{showFeedback.includes('🎉') ? '🎉' : showFeedback.includes('❌') ? '❌' : '🔊'}</div>
                <div className="text-2xl font-bold text-gray-800">{showFeedback}</div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default App;
