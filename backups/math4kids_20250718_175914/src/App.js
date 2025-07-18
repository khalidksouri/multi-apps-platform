import { Award, Heart, RotateCcw, Trophy, Volume2, VolumeX, Zap } from 'lucide-react';
import { useEffect, useRef, useState } from 'react';
import './styles.css';

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
  const [particles, setParticles] = useState([]);
  const [achievements, setAchievements] = useState([]);
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
    { question: '12 - 5', answer: 7, level: 2, type: 'soustraction' },
    { question: '6 + 7', answer: 13, level: 2, type: 'addition' },
    { question: '15 - 8', answer: 7, level: 2, type: 'soustraction' },
    { question: '9 + 6', answer: 15, level: 2, type: 'addition' },
    { question: '14 - 7', answer: 7, level: 2, type: 'soustraction' },
    { question: '8 + 9', answer: 17, level: 2, type: 'addition' },
    { question: '16 - 9', answer: 7, level: 2, type: 'soustraction' },
    { question: '7 + 8', answer: 15, level: 2, type: 'addition' },
    
    // Niveau 3 - Multiplication simple
    { question: '2 × 3', answer: 6, level: 3, type: 'multiplication' },
    { question: '4 × 2', answer: 8, level: 3, type: 'multiplication' },
    { question: '3 × 5', answer: 15, level: 3, type: 'multiplication' },
    { question: '6 × 2', answer: 12, level: 3, type: 'multiplication' },
    { question: '5 × 4', answer: 20, level: 3, type: 'multiplication' },
    { question: '2 × 7', answer: 14, level: 3, type: 'multiplication' },
    { question: '3 × 6', answer: 18, level: 3, type: 'multiplication' },
    { question: '4 × 5', answer: 20, level: 3, type: 'multiplication' },
    { question: '2 × 8', answer: 16, level: 3, type: 'multiplication' },
    { question: '3 × 7', answer: 21, level: 3, type: 'multiplication' },
  ];

  // Filtrer les questions selon le niveau
  const levelQuestions = questions.filter(q => q.level === level);
  const currentQ = levelQuestions[currentQuestion % levelQuestions.length] || levelQuestions[0];

  // Système de sons avec Web Audio API
  const playSound = (type) => {
    if (!soundEnabled) return;
    
    try {
      const context = new (window.AudioContext || window.webkitAudioContext)();
      const oscillator = context.createOscillator();
      const gainNode = context.createGain();
      
      oscillator.connect(gainNode);
      gainNode.connect(context.destination);
      
      switch (type) {
        case 'correct':
          // Mélodie de réussite : Do-Mi-Sol-Do
          oscillator.frequency.setValueAtTime(523.25, context.currentTime);
          oscillator.frequency.setValueAtTime(659.25, context.currentTime + 0.1);
          oscillator.frequency.setValueAtTime(783.99, context.currentTime + 0.2);
          oscillator.frequency.setValueAtTime(1046.5, context.currentTime + 0.3);
          break;
        case 'incorrect':
          // Son d'erreur : descente
          oscillator.frequency.setValueAtTime(300, context.currentTime);
          oscillator.frequency.setValueAtTime(200, context.currentTime + 0.2);
          break;
        case 'levelUp':
          // Fanfare de niveau
          oscillator.frequency.setValueAtTime(523.25, context.currentTime);
          oscillator.frequency.setValueAtTime(659.25, context.currentTime + 0.1);
          oscillator.frequency.setValueAtTime(783.99, context.currentTime + 0.2);
          oscillator.frequency.setValueAtTime(1046.5, context.currentTime + 0.3);
          oscillator.frequency.setValueAtTime(1318.5, context.currentTime + 0.4);
          break;
      }
      
      gainNode.gain.setValueAtTime(0.1, context.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, context.currentTime + 0.5);
      
      oscillator.start(context.currentTime);
      oscillator.stop(context.currentTime + 0.5);
    } catch (error) {
      console.log('Audio non supporté dans ce navigateur');
    }
  };

  // Système de particules amélioré
  const createParticles = (type) => {
    const newParticles = [];
    const count = type === 'correct' ? 20 : 8;
    const colors = type === 'correct' 
      ? ['#FFD700', '#FFA500', '#FF69B4', '#00CED1', '#98FB98']
      : ['#FF6B6B', '#FF4444', '#CC0000'];
    
    for (let i = 0; i < count; i++) {
      newParticles.push({
        id: Date.now() + i,
        x: Math.random() * 100,
        y: Math.random() * 100,
        color: colors[Math.floor(Math.random() * colors.length)],
        size: Math.random() * 15 + 5,
        velocity: {
          x: (Math.random() - 0.5) * 15,
          y: (Math.random() - 0.5) * 15
        },
        rotation: Math.random() * 360,
        life: 1
      });
    }
    
    setParticles(newParticles);
    
    // Animation des particules
    const animateParticles = () => {
      setParticles(prev => prev.map(particle => ({
        ...particle,
        x: particle.x + particle.velocity.x * 0.02,
        y: particle.y + particle.velocity.y * 0.02,
        rotation: particle.rotation + 5,
        life: particle.life - 0.02
      })).filter(particle => particle.life > 0));
    };
    
    const interval = setInterval(animateParticles, 16);
    setTimeout(() => {
      clearInterval(interval);
      setParticles([]);
    }, 2000);
  };

  // Feedback haptique pour mobile
  const hapticFeedback = (type) => {
    if (navigator.vibrate) {
      switch (type) {
        case 'correct':
          navigator.vibrate([100, 50, 100]);
          break;
        case 'incorrect':
          navigator.vibrate([200]);
          break;
        case 'levelUp':
          navigator.vibrate([100, 50, 100, 50, 200]);
          break;
      }
    }
  };

  // Gestion des réponses
  const handleAnswer = () => {
    if (userAnswer === '') return;
    
    setIsAnimating(true);
    const isCorrect = parseInt(userAnswer) === currentQ.answer;
    
    if (isCorrect) {
      const points = 10 * level;
      setScore(score + points);
      setStreak(streak + 1);
      setFeedback(`🎉 Excellent ! +${points} points !`);
      playSound('correct');
      createParticles('correct');
      hapticFeedback('correct');
      
      // Vérifier les achievements
      checkAchievements();
      
      // Passage au niveau supérieur
      if (streak > 0 && streak % 5 === 0 && level < 3) {
        setTimeout(() => {
          setLevel(level + 1);
          playSound('levelUp');
          hapticFeedback('levelUp');
          setAchievements(prev => [...prev, `🎓 Niveau ${level + 1} débloqué !`]);
        }, 1000);
      }
    } else {
      setLives(lives - 1);
      setStreak(0);
      setFeedback(`❌ Oups ! La réponse était ${currentQ.answer}`);
      playSound('incorrect');
      createParticles('incorrect');
      hapticFeedback('incorrect');
    }
    
    setShowFeedback(true);
    
    setTimeout(() => {
      setIsAnimating(false);
      setShowFeedback(false);
      setFeedback('');
      setUserAnswer('');
      
      if (lives > 1 || isCorrect) {
        const nextQuestion = (currentQuestion + 1) % levelQuestions.length;
        setCurrentQuestion(nextQuestion);
      }
      
      if (inputRef.current) {
        inputRef.current.focus();
      }
    }, 2000);
  };

  // Vérifier les achievements
  const checkAchievements = () => {
    const newAchievements = [];
    
    if (score >= 50 && !achievements.includes('🌟 Premier 50 !')) {
      newAchievements.push('🌟 Premier 50 !');
    }
    
    if (score >= 100 && !achievements.includes('💯 Century !')) {
      newAchievements.push('💯 Century !');
    }
    
    if (score >= 200 && !achievements.includes('🏆 Champion !')) {
      newAchievements.push('🏆 Champion !');
    }
    
    if (streak >= 3 && !achievements.includes('🔥 Série de 3 !')) {
      newAchievements.push('🔥 Série de 3 !');
    }
    
    if (streak >= 5 && !achievements.includes('⚡ Série de 5 !')) {
      newAchievements.push('⚡ Série de 5 !');
    }
    
    if (streak >= 10 && !achievements.includes('🌟 Série de 10 !')) {
      newAchievements.push('🌟 Série de 10 !');
    }
    
    if (newAchievements.length > 0) {
      setAchievements(prev => [...prev, ...newAchievements]);
    }
  };

  // Reset du jeu
  const resetGame = () => {
    setScore(0);
    setLives(3);
    setLevel(1);
    setStreak(0);
    setCurrentQuestion(0);
    setUserAnswer('');
    setFeedback('');
    setShowFeedback(false);
    setAchievements([]);
    setParticles([]);
    if (inputRef.current) {
      inputRef.current.focus();
    }
  };

  // Gestion du clavier
  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !isAnimating) {
      handleAnswer();
    }
  };

  // Focus automatique
  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.focus();
    }
  }, [currentQuestion]);

  // Sauvegarde du score dans localStorage
  useEffect(() => {
    const savedScore = localStorage.getItem('math4kids_highscore');
    if (savedScore && parseInt(savedScore) > score) {
      // Charger le meilleur score
    }
  }, []);

  useEffect(() => {
    const savedScore = localStorage.getItem('math4kids_highscore');
    if (!savedScore || score > parseInt(savedScore)) {
      localStorage.setItem('math4kids_highscore', score.toString());
    }
  }, [score]);

  // Game Over
  if (lives <= 0) {
    const highScore = localStorage.getItem('math4kids_highscore') || 0;
    const isNewRecord = score > parseInt(highScore);
    
    return (
      <div className="min-h-screen bg-gradient-to-br from-red-400 via-pink-500 to-purple-600 flex items-center justify-center p-4">
        <div className="bg-white/95 backdrop-blur-sm rounded-3xl p-8 max-w-md w-full text-center shadow-2xl animate-bounce-in">
          <div className="text-6xl mb-4">
            {isNewRecord ? '🏆' : '😢'}
          </div>
          <h2 className="text-3xl font-bold text-gray-800 mb-4 font-fredoka">
            {isNewRecord ? 'Nouveau record !' : 'Game Over'}
          </h2>
          <div className="text-xl text-gray-600 mb-6">
            <div>Score final: <span className="font-bold text-purple-600">{score}</span></div>
            <div>Meilleur score: <span className="font-bold text-amber-600">{Math.max(score, parseInt(highScore))}</span></div>
            <div>Niveau atteint: <span className="font-bold text-green-600">{level}</span></div>
          </div>
          {achievements.length > 0 && (
            <div className="mb-6">
              <h3 className="text-lg font-bold text-gray-700 mb-2">🏅 Achievements</h3>
              <div className="flex flex-wrap gap-2 justify-center">
                {achievements.slice(-3).map((achievement, index) => (
                  <span
                    key={index}
                    className="bg-yellow-100 text-yellow-800 px-3 py-1 rounded-full text-sm font-medium"
                  >
                    {achievement}
                  </span>
                ))}
              </div>
            </div>
          )}
          <button
            onClick={resetGame}
            className="bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold py-3 px-6 rounded-full transition-all duration-300 transform hover:scale-105 shadow-lg haptic-feedback"
          >
            <RotateCcw className="inline-block mr-2" size={20} />
            Recommencer
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 relative overflow-hidden">
      {/* Particules d'animation */}
      <div className="absolute inset-0 pointer-events-none">
        {particles.map((particle) => (
          <div
            key={particle.id}
            className="absolute particle"
            style={{
              left: `${particle.x}%`,
              top: `${particle.y}%`,
              width: `${particle.size}px`,
              height: `${particle.size}px`,
              backgroundColor: particle.color,
              borderRadius: '50%',
              transform: `rotate(${particle.rotation}deg)`,
              opacity: particle.life,
            }}
          />
        ))}
      </div>

      {/* Header avec stats */}
      <div className="bg-white/10 backdrop-blur-sm p-4 shadow-lg">
        <div className="max-w-4xl mx-auto flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <h1 className="text-2xl md:text-3xl font-bold text-white flex items-center gap-2 font-fredoka">
              <span className="text-3xl">🧮</span>
              Math4Kids
            </h1>
            <div className="flex items-center gap-2 text-white">
              <span className="text-sm font-medium">Niveau</span>
              <span className="bg-white/20 px-3 py-1 rounded-full font-bold animate-pulse-glow">{level}</span>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 text-white">
              <Trophy className="text-yellow-300" size={20} />
              <span className="font-bold">{score}</span>
            </div>
            
            <div className="flex items-center gap-2 text-white">
              <Zap className="text-orange-300" size={20} />
              <span className="font-bold">{streak}</span>
            </div>
            
            <div className="flex items-center gap-1">
              {[...Array(3)].map((_, i) => (
                <Heart
                  key={i}
                  className={`${i < lives ? 'text-red-400 fill-red-400' : 'text-white/30'} transition-all duration-300`}
                  size={20}
                />
              ))}
            </div>
            
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className="bg-white/20 hover:bg-white/30 p-2 rounded-full transition-all duration-300 haptic-feedback"
              aria-label={soundEnabled ? "Désactiver le son" : "Activer le son"}
            >
              {soundEnabled ? <Volume2 className="text-white" size={20} /> : <VolumeX className="text-white" size={20} />}
            </button>
          </div>
        </div>
      </div>

      {/* Contenu principal */}
      <div className="flex-1 flex items-center justify-center p-4">
        <div className="bg-white/95 backdrop-blur-sm rounded-3xl p-8 max-w-md w-full shadow-2xl">
          {/* Question */}
          <div className="text-center mb-8">
            <div className="text-sm font-medium text-gray-500 mb-2">
              Question {currentQuestion + 1} / {levelQuestions.length}
            </div>
            <div className="text-4xl md:text-5xl font-bold text-gray-800 mb-4 font-fredoka">
              {currentQ.question} = ?
            </div>
            <div className="text-sm text-gray-600 flex items-center justify-center gap-2">
              {currentQ.type === 'addition' && (
                <>
                  <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs">
                    ➕ Addition
                  </span>
                </>
              )}
              {currentQ.type === 'soustraction' && (
                <>
                  <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full text-xs">
                    ➖ Soustraction
                  </span>
                </>
              )}
              {currentQ.type === 'multiplication' && (
                <>
                  <span className="bg-purple-100 text-purple-800 px-2 py-1 rounded-full text-xs">
                    ✖️ Multiplication
                  </span>
                </>
              )}
            </div>
          </div>

          {/* Input */}
          <div className="mb-6">
            <input
              ref={inputRef}
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Ta réponse..."
              className="w-full text-center text-2xl font-bold py-4 px-6 rounded-2xl border-2 border-purple-200 focus:border-purple-500 focus:outline-none transition-all duration-300 shadow-lg focus-visible"
              disabled={isAnimating}
              inputMode="numeric"
            />
          </div>

          {/* Bouton de réponse */}
          <button
            onClick={handleAnswer}
            disabled={isAnimating || userAnswer === ''}
            className={`w-full py-4 px-6 rounded-2xl font-bold text-xl transition-all duration-300 shadow-lg transform haptic-feedback ${
              isAnimating || userAnswer === ''
                ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                : 'bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white hover:scale-105 active:scale-95'
            }`}
          >
            {isAnimating ? (
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