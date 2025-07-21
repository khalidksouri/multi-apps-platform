import React, { useState, useEffect, useRef } from 'react';
import { Star, Heart, Trophy, Volume2, VolumeX, RotateCcw, Zap, Target, Award } from 'lucide-react';

const Math4Kids = () => {
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [score, setScore] = useState(0);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [lives, setLives] = useState(3);
  const [level, setLevel] = useState(1);
  const [streak, setStreak] = useState(0);
  const [soundEnabled, setSoundEnabled] = useState(true);
  const [isAnimating, setIsAnimating] = useState(false);
  const [achievements, setAchievements] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const inputRef = useRef(null);

  // Questions par niveau avec difficulté progressive
  const questions = [
    // Niveau 1 - Addition simple
    { question: '2 + 3', answer: 5, level: 1, type: 'addition' },
    { question: '1 + 4', answer: 5, level: 1, type: 'addition' },
    { question: '3 + 2', answer: 5, level: 1, type: 'addition' },
    { question: '5 + 1', answer: 6, level: 1, type: 'addition' },
    { question: '4 + 3', answer: 7, level: 1, type: 'addition' },
    { question: '2 + 6', answer: 8, level: 1, type: 'addition' },
    { question: '3 + 4', answer: 7, level: 1, type: 'addition' },
    { question: '1 + 8', answer: 9, level: 1, type: 'addition' },
    { question: '5 + 2', answer: 7, level: 1, type: 'addition' },
    { question: '6 + 3', answer: 9, level: 1, type: 'addition' },
    
    // Niveau 2 - Addition/Soustraction
    { question: '8 - 3', answer: 5, level: 2, type: 'soustraction' },
    { question: '7 + 4', answer: 11, level: 2, type: 'addition' },
    { question: '9 - 2', answer: 7, level: 2, type: 'soustraction' },
    { question: '6 + 5', answer: 11, level: 2, type: 'addition' },
    { question: '10 - 4', answer: 6, level: 2, type: 'soustraction' },
    { question: '8 + 3', answer: 11, level: 2, type: 'addition' },
    { question: '12 - 5', answer: 7, level: 2, type: 'soustraction' },
    { question: '7 + 6', answer: 13, level: 2, type: 'addition' },
    { question: '15 - 8', answer: 7, level: 2, type: 'soustraction' },
    { question: '9 + 4', answer: 13, level: 2, type: 'addition' },
    
    // Niveau 3 - Multiplication simple
    { question: '2 × 3', answer: 6, level: 3, type: 'multiplication' },
    { question: '4 × 2', answer: 8, level: 3, type: 'multiplication' },
    { question: '3 × 3', answer: 9, level: 3, type: 'multiplication' },
    { question: '5 × 2', answer: 10, level: 3, type: 'multiplication' },
    { question: '2 × 6', answer: 12, level: 3, type: 'multiplication' },
    { question: '4 × 3', answer: 12, level: 3, type: 'multiplication' },
    { question: '3 × 5', answer: 15, level: 3, type: 'multiplication' },
    { question: '2 × 8', answer: 16, level: 3, type: 'multiplication' },
    { question: '4 × 4', answer: 16, level: 3, type: 'multiplication' },
    { question: '3 × 6', answer: 18, level: 3, type: 'multiplication' },
  ];

  // Filtrer les questions par niveau
  const currentLevelQuestions = questions.filter(q => q.level === level);

  // Fonctions utilitaires
  const playSound = (type) => {
    if (!soundEnabled) return;
    
    const context = new (window.AudioContext || window.webkitAudioContext)();
    const oscillator = context.createOscillator();
    const gainNode = context.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(context.destination);
    
    if (type === 'success') {
      oscillator.frequency.setValueAtTime(523.25, context.currentTime);
      oscillator.frequency.exponentialRampToValueAtTime(783.99, context.currentTime + 0.3);
    } else if (type === 'error') {
      oscillator.frequency.setValueAtTime(300, context.currentTime);
      oscillator.frequency.exponentialRampToValueAtTime(200, context.currentTime + 0.3);
    }
    
    gainNode.gain.setValueAtTime(0.3, context.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, context.currentTime + 0.3);
    
    oscillator.start(context.currentTime);
    oscillator.stop(context.currentTime + 0.3);
  };

  const createParticles = () => {
    const colors = ['#FFD700', '#FF69B4', '#00CED1', '#FF6347', '#98FB98'];
    const newParticles = [];
    
    for (let i = 0; i < 15; i++) {
      newParticles.push({
        id: Math.random(),
        color: colors[Math.floor(Math.random() * colors.length)],
        left: Math.random() * 100,
        delay: Math.random() * 1000
      });
    }
    
    return newParticles;
  };

  const checkAchievements = () => {
    const newAchievements = [];
    
    if (score === 10 && !achievements.includes('🎯 Première dizaine!')) {
      newAchievements.push('🎯 Première dizaine!');
    }
    if (streak >= 5 && !achievements.includes('🔥 En feu!')) {
      newAchievements.push('🔥 En feu!');
    }
    if (level >= 3 && !achievements.includes('🚀 Expert!')) {
      newAchievements.push('🚀 Expert!');
    }
    
    setAchievements(prev => [...prev, ...newAchievements]);
  };

  // Validation de la réponse
  const validateAnswer = () => {
    if (!userAnswer) return;
    
    setIsLoading(true);
    const currentQ = currentLevelQuestions[currentQuestion];
    const userNum = parseInt(userAnswer);
    
    setTimeout(() => {
      if (userNum === currentQ.answer) {
        setScore(prev => prev + (level * 10));
        setStreak(prev => prev + 1);
        setFeedback('🎉 Excellent !');
        playSound('success');
        setIsAnimating(true);
        
        setTimeout(() => setIsAnimating(false), 1000);
        
        // Niveau suivant après 10 questions correctes
        if ((currentQuestion + 1) >= currentLevelQuestions.length) {
          if (level < 3) {
            setLevel(prev => prev + 1);
            setCurrentQuestion(0);
          } else {
            setCurrentQuestion(0); // Recommencer le niveau 3
          }
        } else {
          setCurrentQuestion(prev => prev + 1);
        }
      } else {
        setStreak(0);
        setFeedback(`❌ Oups ! La réponse était ${currentQ.answer}`);
        setLives(prev => prev - 1);
        playSound('error');
        
        if (lives <= 1) {
          // Game Over - Reset
          setTimeout(() => {
            setLives(3);
            setLevel(1);
            setCurrentQuestion(0);
            setScore(0);
            setFeedback('');
            setShowFeedback(false);
          }, 2000);
        }
      }
      
      setShowFeedback(true);
      setUserAnswer('');
      setIsLoading(false);
      
      setTimeout(() => {
        setShowFeedback(false);
        setFeedback('');
      }, 3000);
      
      checkAchievements();
    }, 1000);
  };

  const resetGame = () => {
    setCurrentQuestion(0);
    setScore(0);
    setUserAnswer('');
    setFeedback('');
    setShowFeedback(false);
    setLives(3);
    setLevel(1);
    setStreak(0);
    setAchievements([]);
  };

  // Focus automatique sur l'input
  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.focus();
    }
  }, [currentQuestion]);

  const currentQ = currentLevelQuestions[currentQuestion] || currentLevelQuestions[0];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 p-4 relative overflow-hidden">
      {/* Particules d'animation */}
      {isAnimating && createParticles().map(particle => (
        <div
          key={particle.id}
          className="particle"
          style={{
            left: `${particle.left}%`,
            backgroundColor: particle.color,
            width: '8px',
            height: '8px',
            animationDelay: `${particle.delay}ms`
          }}
        />
      ))}

      {/* Header avec statistiques */}
      <div className="flex justify-between items-center mb-6">
        <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 border border-white/30">
          <h1 className="text-3xl font-bold text-white mb-2 font-fredoka">
            🧮 Math4Kids
          </h1>
          <p className="text-white/80 text-sm">Apprends les maths en t'amusant !</p>
        </div>
        
        <div className="flex gap-4">
          {/* Score */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30">
            <Trophy className="text-yellow-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold">{score}</div>
            <div className="text-white/70 text-xs">Score</div>
          </div>
          
          {/* Niveau */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30">
            <Star className="text-blue-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold">{level}</div>
            <div className="text-white/70 text-xs">Niveau</div>
          </div>
          
          {/* Vies */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30">
            <div className="flex justify-center gap-1 mb-1">
              {Array.from({ length: 3 }, (_, i) => (
                <Heart
                  key={i}
                  className={i < lives ? 'text-red-400 fill-current' : 'text-white/30'}
                  size={16}
                />
              ))}
            </div>
            <div className="text-white/70 text-xs">Vies</div>
          </div>
          
          {/* Son */}
          <button
            onClick={() => setSoundEnabled(!soundEnabled)}
            className="bg-white/20 backdrop-blur-sm rounded-xl p-3 border border-white/30 haptic-feedback"
          >
            {soundEnabled ? (
              <Volume2 className="text-white" size={20} />
            ) : (
              <VolumeX className="text-white" size={20} />
            )}
          </button>
        </div>
      </div>

      {/* Zone de jeu principale */}
      <div className="max-w-2xl mx-auto">
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-8 border border-white/20 shadow-2xl">
          {/* Indicateur de progression */}
          <div className="mb-6">
            <div className="flex justify-between text-white/80 text-sm mb-2">
              <span>Question {currentQuestion + 1}/{currentLevelQuestions.length}</span>
              <span>Série: {streak}</span>
            </div>
            <div className="w-full bg-white/20 rounded-full h-2">
              <div 
                className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full transition-all duration-500"
                style={{ width: `${((currentQuestion + 1) / currentLevelQuestions.length) * 100}%` }}
              />
            </div>
          </div>

          {/* Question */}
          <div className="text-center mb-8">
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <h2 className="text-4xl font-bold text-gray-800 mb-4">
                {currentQ.question} = ?
              </h2>
              <div className="text-sm text-gray-600 mb-4">
                Niveau {level} • {currentQ.type}
              </div>
            </div>
          </div>

          {/* Input et bouton */}
          <div className="text-center">
            <input
              ref={inputRef}
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && validateAnswer()}
              placeholder="Ta réponse..."
              className="bg-white rounded-2xl p-4 text-center text-2xl font-bold text-gray-800 border-4 border-transparent focus:border-purple-400 focus:outline-none w-40 mr-4 haptic-feedback"
              disabled={isLoading}
            />
            
            <button
              onClick={validateAnswer}
              disabled={!userAnswer || isLoading}
              className="bg-gradient-to-r from-green-500 to-blue-500 hover:from-green-600 hover:to-blue-600 disabled:from-gray-400 disabled:to-gray-500 text-white font-bold py-4 px-8 rounded-2xl text-xl transition-all duration-300 shadow-lg haptic-feedback animate-pulse-glow"
            >
              {isLoading ? (
                <span className="flex items-center justify-center gap-2">
                  <div className="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></div>
                  Vérification...
                </span>
              ) : (
                'Valider'
              )}
            </button>

            {/* Feedback */}
            {showFeedback && (
              <div className={`mt-6 p-4 rounded-2xl text-center font-bold transition-all duration-500 ${
                feedback.includes('Excellent') 
                  ? 'bg-green-100 text-green-800 border-2 border-green-300 animate-bounce-in' 
                  : 'bg-red-100 text-red-800 border-2 border-red-300 animate-shake'
              }`}>
                {feedback}
              </div>
            )}

            {/* Achievements récents */}
            {achievements.length > 0 && (
              <div className="mt-6 space-y-2">
                {achievements.slice(-2).map((achievement, index) => (
                  <div
                    key={index}
                    className="bg-yellow-100 border-2 border-yellow-300 text-yellow-800 p-2 rounded-lg text-center text-sm font-medium animate-bounce-in"
                  >
                    <Award className="inline-block mr-2" size={16} />
                    {achievement}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Bouton reset */}
      <div className="absolute bottom-4 right-4">
        <button
          onClick={resetGame}
          className="bg-white/20 hover:bg-white/30 backdrop-blur-sm p-3 rounded-full transition-all duration-300 shadow-lg haptic-feedback"
          aria-label="Recommencer le jeu"
        >
          <RotateCcw className="text-white" size={24} />
        </button>
      </div>
    </div>
  );
};

export default Math4Kids;
