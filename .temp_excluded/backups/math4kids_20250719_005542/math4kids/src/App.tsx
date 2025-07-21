import {
  Crown,
  Divide,
  Gamepad2,
  Globe,
  Heart,
  Home,
  Minus,
  Plus,
  RotateCcw,
  Settings,
  Star,
  Target,
  TrendingUp,
  Trophy, Volume2, VolumeX,
  X,
  Zap
} from 'lucide-react';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import './styles.css';

// =============================================================================
// SYSTÈME DE TRADUCTION MULTILINGUE
// =============================================================================

interface Translation {
  title: string;
  subtitle: string;
  level: string;
  score: string;
  lives: string;
  streak: string;
  answer: string;
  check: string;
  next: string;
  restart: string;
  settings: string;
  language: string;
  sound: string;
  difficulty: string;
  correct: string;
  incorrect: string;
  gameOver: string;
  finalScore: string;
  newRecord: string;
  achievements: string;
  playAgain: string;
  operations: {
    addition: string;
    subtraction: string;
    multiplication: string;
    division: string;
    mixed: string;
  };
  levels: {
    1: string;
    2: string;
    3: string;
    4: string;
    5: string;
  };
}

type LanguageCode = 'fr' | 'en' | 'es' | 'de' | 'ar' | 'zh' | 'ru' | 'pt' | 'hi' | 'ja';

interface LanguageOption {
  code: LanguageCode;
  name: string;
  flag: string;
}

type OperationType = 'addition' | 'subtraction' | 'multiplication' | 'division';
type GameScreen = 'home' | 'game' | 'settings' | 'gameOver';
type DifficultyLevel = 1 | 2 | 3 | 4 | 5;

interface Question {
  question: string;
  answer: number;
  operation: OperationType;
  level: DifficultyLevel;
}

interface Particle {
  id: number;
  color: string;
  x: number;
  y: number;
  delay: number;
}

const translations: Record<LanguageCode, Translation> = {
  // Français
  fr: {
    title: "Math4Kids",
    subtitle: "Apprendre les maths en s'amusant !",
    level: "Niveau",
    score: "Score",
    lives: "Vies",
    streak: "Série",
    answer: "Réponse",
    check: "Vérifier",
    next: "Suivant",
    restart: "Recommencer",
    settings: "Paramètres",
    language: "Langue",
    sound: "Son",
    difficulty: "Difficulté",
    correct: "Correct ! Excellent !",
    incorrect: "Oups ! Essaie encore !",
    gameOver: "Partie terminée !",
    finalScore: "Score final",
    newRecord: "Nouveau record !",
    achievements: "Succès",
    playAgain: "Rejouer",
    operations: {
      addition: "Addition",
      subtraction: "Soustraction", 
      multiplication: "Multiplication",
      division: "Division",
      mixed: "Mélangé"
    },
    levels: {
      1: "Débutant",
      2: "Facile", 
      3: "Moyen",
      4: "Difficile",
      5: "Expert"
    }
  },
  
  // English
  en: {
    title: "Math4Kids",
    subtitle: "Learn math while having fun!",
    level: "Level",
    score: "Score", 
    lives: "Lives",
    streak: "Streak",
    answer: "Answer",
    check: "Check",
    next: "Next",
    restart: "Restart",
    settings: "Settings",
    language: "Language",
    sound: "Sound",
    difficulty: "Difficulty",
    correct: "Correct! Excellent!",
    incorrect: "Oops! Try again!",
    gameOver: "Game Over!",
    finalScore: "Final Score",
    newRecord: "New Record!",
    achievements: "Achievements",
    playAgain: "Play Again",
    operations: {
      addition: "Addition",
      subtraction: "Subtraction",
      multiplication: "Multiplication", 
      division: "Division",
      mixed: "Mixed"
    },
    levels: {
      1: "Beginner",
      2: "Easy",
      3: "Medium", 
      4: "Hard",
      5: "Expert"
    }
  },

  // Español
  es: {
    title: "Math4Kids",
    subtitle: "¡Aprende matemáticas divirtiéndote!",
    level: "Nivel",
    score: "Puntuación",
    lives: "Vidas", 
    streak: "Racha",
    answer: "Respuesta",
    check: "Verificar",
    next: "Siguiente",
    restart: "Reiniciar",
    settings: "Configuración",
    language: "Idioma",
    sound: "Sonido",
    difficulty: "Dificultad",
    correct: "¡Correcto! ¡Excelente!",
    incorrect: "¡Ups! ¡Inténtalo de nuevo!",
    gameOver: "¡Juego terminado!",
    finalScore: "Puntuación final",
    newRecord: "¡Nuevo récord!",
    achievements: "Logros",
    playAgain: "Jugar de nuevo",
    operations: {
      addition: "Suma",
      subtraction: "Resta",
      multiplication: "Multiplicación",
      division: "División", 
      mixed: "Mixto"
    },
    levels: {
      1: "Principiante",
      2: "Fácil",
      3: "Medio",
      4: "Difícil", 
      5: "Experto"
    }
  },

  // Deutsch
  de: {
    title: "Math4Kids",
    subtitle: "Mathematik lernen macht Spaß!",
    level: "Level",
    score: "Punkte",
    lives: "Leben",
    streak: "Serie", 
    answer: "Antwort",
    check: "Prüfen",
    next: "Weiter",
    restart: "Neustart",
    settings: "Einstellungen",
    language: "Sprache",
    sound: "Ton",
    difficulty: "Schwierigkeit",
    correct: "Richtig! Ausgezeichnet!",
    incorrect: "Ups! Versuche es nochmal!",
    gameOver: "Spiel beendet!",
    finalScore: "Endpunktzahl",
    newRecord: "Neuer Rekord!",
    achievements: "Erfolge",
    playAgain: "Nochmal spielen",
    operations: {
      addition: "Addition",
      subtraction: "Subtraktion",
      multiplication: "Multiplikation",
      division: "Division",
      mixed: "Gemischt"
    },
    levels: {
      1: "Anfänger",
      2: "Einfach", 
      3: "Mittel",
      4: "Schwer",
      5: "Experte"
    }
  },

  // العربية
  ar: {
    title: "رياضيات للأطفال",
    subtitle: "تعلم الرياضيات مع المرح!",
    level: "المستوى",
    score: "النقاط",
    lives: "الأرواح",
    streak: "السلسلة",
    answer: "الإجابة", 
    check: "تحقق",
    next: "التالي",
    restart: "إعادة البدء",
    settings: "الإعدادات",
    language: "اللغة",
    sound: "الصوت",
    difficulty: "الصعوبة",
    correct: "صحيح! ممتاز!",
    incorrect: "خطأ! حاول مرة أخرى!",
    gameOver: "انتهت اللعبة!",
    finalScore: "النتيجة النهائية",
    newRecord: "رقم قياسي جديد!",
    achievements: "الإنجازات",
    playAgain: "العب مرة أخرى",
    operations: {
      addition: "الجمع",
      subtraction: "الطرح",
      multiplication: "الضرب",
      division: "القسمة",
      mixed: "مختلط"
    },
    levels: {
      1: "مبتدئ",
      2: "سهل",
      3: "متوسط",
      4: "صعب",
      5: "خبير"
    }
  },

  // 中文
  zh: {
    title: "儿童数学",
    subtitle: "快乐学数学！",
    level: "级别",
    score: "得分",
    lives: "生命",
    streak: "连击",
    answer: "答案",
    check: "检查",
    next: "下一题",
    restart: "重新开始",
    settings: "设置",
    language: "语言",
    sound: "声音",
    difficulty: "难度",
    correct: "正确！太棒了！",
    incorrect: "哎呀！再试一次！",
    gameOver: "游戏结束！",
    finalScore: "最终得分",
    newRecord: "新记录！",
    achievements: "成就",
    playAgain: "再玩一次",
    operations: {
      addition: "加法",
      subtraction: "减法",
      multiplication: "乘法",
      division: "除法",
      mixed: "混合"
    },
    levels: {
      1: "初学者",
      2: "简单",
      3: "中等",
      4: "困难",
      5: "专家"
    }
  },

  // Русский
  ru: {
    title: "Математика для детей",
    subtitle: "Изучаем математику с удовольствием!",
    level: "Уровень",
    score: "Счёт",
    lives: "Жизни",
    streak: "Серия",
    answer: "Ответ",
    check: "Проверить",
    next: "Далее",
    restart: "Начать заново",
    settings: "Настройки",
    language: "Язык",
    sound: "Звук",
    difficulty: "Сложность",
    correct: "Правильно! Отлично!",
    incorrect: "Упс! Попробуй ещё раз!",
    gameOver: "Игра окончена!",
    finalScore: "Финальный счёт",
    newRecord: "Новый рекорд!",
    achievements: "Достижения",
    playAgain: "Играть снова",
    operations: {
      addition: "Сложение",
      subtraction: "Вычитание",
      multiplication: "Умножение",
      division: "Деление",
      mixed: "Смешанное"
    },
    levels: {
      1: "Новичок",
      2: "Лёгкий",
      3: "Средний",
      4: "Сложный",
      5: "Эксперт"
    }
  },

  // Português
  pt: {
    title: "Math4Kids",
    subtitle: "Aprenda matemática se divertindo!",
    level: "Nível",
    score: "Pontuação",
    lives: "Vidas",
    streak: "Sequência",
    answer: "Resposta",
    check: "Verificar",
    next: "Próximo",
    restart: "Recomeçar",
    settings: "Configurações",
    language: "Idioma",
    sound: "Som",
    difficulty: "Dificuldade",
    correct: "Correto! Excelente!",
    incorrect: "Ops! Tente novamente!",
    gameOver: "Fim de jogo!",
    finalScore: "Pontuação final",
    newRecord: "Novo recorde!",
    achievements: "Conquistas",
    playAgain: "Jogar novamente",
    operations: {
      addition: "Adição",
      subtraction: "Subtração",
      multiplication: "Multiplicação",
      division: "Divisão",
      mixed: "Misto"
    },
    levels: {
      1: "Iniciante",
      2: "Fácil",
      3: "Médio",
      4: "Difícil",
      5: "Especialista"
    }
  },

  // हिंदी
  hi: {
    title: "बच्चों के लिए गणित",
    subtitle: "मज़े करते हुए गणित सीखें!",
    level: "स्तर",
    score: "अंक",
    lives: "जीवन",
    streak: "शृंखला",
    answer: "उत्तर",
    check: "जाँचें",
    next: "अगला",
    restart: "फिर से शुरू करें",
    settings: "सेटिंग्स",
    language: "भाषा",
    sound: "ध्वनि",
    difficulty: "कठिनाई",
    correct: "सही! बहुत बढ़िया!",
    incorrect: "अरे! फिर से कोशिश करें!",
    gameOver: "खेल समाप्त!",
    finalScore: "अंतिम स्कोर",
    newRecord: "नया रिकॉर्ड!",
    achievements: "उपलब्धियां",
    playAgain: "फिर से खेलें",
    operations: {
      addition: "जोड़",
      subtraction: "घटाव",
      multiplication: "गुणा",
      division: "भाग",
      mixed: "मिश्रित"
    },
    levels: {
      1: "शुरुआती",
      2: "आसान",
      3: "मध्यम",
      4: "कठिन",
      5: "विशेषज्ञ"
    }
  },

  // 日本語
  ja: {
    title: "子ども数学",
    subtitle: "楽しく数学を学ぼう！",
    level: "レベル",
    score: "スコア",
    lives: "ライフ",
    streak: "ストリーク",
    answer: "答え",
    check: "確認",
    next: "次へ",
    restart: "リスタート",
    settings: "設定",
    language: "言語",
    sound: "音",
    difficulty: "難易度",
    correct: "正解！素晴らしい！",
    incorrect: "おっと！もう一度！",
    gameOver: "ゲーム終了！",
    finalScore: "最終スコア",
    newRecord: "新記録！",
    achievements: "実績",
    playAgain: "もう一度プレイ",
    operations: {
      addition: "足し算",
      subtraction: "引き算",
      multiplication: "掛け算",
      division: "割り算",
      mixed: "混合"
    },
    levels: {
      1: "初心者",
      2: "簡単",
      3: "普通",
      4: "難しい",
      5: "専門家"
    }
  }
};

// =============================================================================
// GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES
// =============================================================================

const generateQuestion = (level: DifficultyLevel, operation: OperationType): Question => {
  let question: string;
  let answer: number;
  
  switch (level) {
    case 1: // Débutant
      if (operation === 'addition') {
        const a = Math.floor(Math.random() * 5) + 1;
        const b = Math.floor(Math.random() * 5) + 1;
        question = `${a} + ${b}`;
        answer = a + b;
      } else if (operation === 'subtraction') {
        const a = Math.floor(Math.random() * 5) + 6;
        const b = Math.floor(Math.random() * 5) + 1;
        question = `${a} - ${b}`;
        answer = a - b;
      } else {
        question = '2 + 2';
        answer = 4;
      }
      break;
      
    case 2: // Facile
      if (operation === 'addition') {
        const a = Math.floor(Math.random() * 10) + 1;
        const b = Math.floor(Math.random() * 10) + 1;
        question = `${a} + ${b}`;
        answer = a + b;
      } else if (operation === 'subtraction') {
        const a = Math.floor(Math.random() * 10) + 11;
        const b = Math.floor(Math.random() * 10) + 1;
        question = `${a} - ${b}`;
        answer = a - b;
      } else if (operation === 'multiplication') {
        const a = Math.floor(Math.random() * 5) + 1;
        const b = Math.floor(Math.random() * 5) + 1;
        question = `${a} × ${b}`;
        answer = a * b;
      } else {
        question = '4 + 6';
        answer = 10;
      }
      break;
      
    case 3: // Moyen
      if (operation === 'addition') {
        const a = Math.floor(Math.random() * 50) + 10;
        const b = Math.floor(Math.random() * 50) + 10;
        question = `${a} + ${b}`;
        answer = a + b;
      } else if (operation === 'subtraction') {
        const a = Math.floor(Math.random() * 50) + 51;
        const b = Math.floor(Math.random() * 50) + 1;
        question = `${a} - ${b}`;
        answer = a - b;
      } else if (operation === 'multiplication') {
        const a = Math.floor(Math.random() * 10) + 1;
        const b = Math.floor(Math.random() * 10) + 1;
        question = `${a} × ${b}`;
        answer = a * b;
      } else if (operation === 'division') {
        const b = Math.floor(Math.random() * 9) + 2;
        const a = b * (Math.floor(Math.random() * 9) + 1);
        question = `${a} ÷ ${b}`;
        answer = a / b;
      } else {
        question = '15 + 25';
        answer = 40;
      }
      break;
      
    case 4: // Difficile
      if (operation === 'addition') {
        const a = Math.floor(Math.random() * 100) + 50;
        const b = Math.floor(Math.random() * 100) + 50;
        question = `${a} + ${b}`;
        answer = a + b;
      } else if (operation === 'subtraction') {
        const a = Math.floor(Math.random() * 100) + 101;
        const b = Math.floor(Math.random() * 100) + 1;
        question = `${a} - ${b}`;
        answer = a - b;
      } else if (operation === 'multiplication') {
        const a = Math.floor(Math.random() * 20) + 10;
        const b = Math.floor(Math.random() * 10) + 1;
        question = `${a} × ${b}`;
        answer = a * b;
      } else if (operation === 'division') {
        const b = Math.floor(Math.random() * 12) + 3;
        const a = b * (Math.floor(Math.random() * 20) + 1);
        question = `${a} ÷ ${b}`;
        answer = a / b;
      } else {
        question = '75 + 125';
        answer = 200;
      }
      break;
      
    case 5: // Expert
      if (operation === 'addition') {
        const a = Math.floor(Math.random() * 500) + 100;
        const b = Math.floor(Math.random() * 500) + 100;
        question = `${a} + ${b}`;
        answer = a + b;
      } else if (operation === 'subtraction') {
        const a = Math.floor(Math.random() * 500) + 501;
        const b = Math.floor(Math.random() * 500) + 1;
        question = `${a} - ${b}`;
        answer = a - b;
      } else if (operation === 'multiplication') {
        const a = Math.floor(Math.random() * 50) + 20;
        const b = Math.floor(Math.random() * 20) + 10;
        question = `${a} × ${b}`;
        answer = a * b;
      } else if (operation === 'division') {
        const b = Math.floor(Math.random() * 20) + 5;
        const a = b * (Math.floor(Math.random() * 50) + 10);
        question = `${a} ÷ ${b}`;
        answer = a / b;
      } else {
        question = '250 + 750';
        answer = 1000;
      }
      break;
      
    default:
      question = '2 + 2';
      answer = 4;
  }

  return { question, answer, operation, level };
};

// =============================================================================
// COMPOSANT PRINCIPAL
// =============================================================================

const Math4Kids: React.FC = () => {
  // États principaux
  const [language, setLanguage] = useState<LanguageCode>('fr');
  const [currentScreen, setCurrentScreen] = useState<GameScreen>('home');
  const [level, setLevel] = useState<DifficultyLevel>(1);
  const [operation, setOperation] = useState<OperationType>('addition');
  const [score, setScore] = useState(0);
  const [lives, setLives] = useState(3);
  const [streak, setStreak] = useState(0);
  const [bestScore, setBestScore] = useState(0);
  const [soundEnabled, setSoundEnabled] = useState(true);
  
  // États du jeu
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [isAnimating, setIsAnimating] = useState(false);
  const [particles, setParticles] = useState<Particle[]>([]);
  const [achievements] = useState<string[]>([]);
  
  // Références
  const inputRef = useRef<HTMLInputElement>(null);
  const gameAreaRef = useRef<HTMLDivElement>(null);
  
  // Traductions actuelles
  const t = translations[language] || translations.fr;
  
  // =============================================================================
  // EFFETS ET HOOKS
  // =============================================================================
  
  // Charger les données sauvegardées
  useEffect(() => {
    const savedData = localStorage.getItem('math4kids-data');
    if (savedData) {
      try {
        const data = JSON.parse(savedData);
        setBestScore(data.bestScore || 0);
        setLanguage(data.language || 'fr');
        setSoundEnabled(data.soundEnabled ?? true);
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      }
    }
  }, []);
  
  // Sauvegarder les données
  useEffect(() => {
    const dataToSave = {
      bestScore,
      language,
      soundEnabled,
      achievements
    };
    localStorage.setItem('math4kids-data', JSON.stringify(dataToSave));
  }, [bestScore, language, soundEnabled, achievements]);
  
  // Générer nouvelle question
  const generateNewQuestion = useCallback(() => {
    const newQuestion = generateQuestion(level, operation);
    setCurrentQuestion(newQuestion);
    setUserAnswer('');
    setShowFeedback(false);
    
    // Focus sur l'input après un court délai
    setTimeout(() => {
      if (inputRef.current) {
        inputRef.current.focus();
      }
    }, 100);
  }, [level, operation]);
  
  // =============================================================================
  // FONCTIONS DE JEU
  // =============================================================================
  
  const startGame = () => {
    setCurrentScreen('game');
    setScore(0);
    setLives(3);
    setStreak(0);
    generateNewQuestion();
  };
  
  const checkAnswer = () => {
    if (!currentQuestion || userAnswer === '') return;
    
    const isCorrect = parseInt(userAnswer) === currentQuestion.answer;
    setIsAnimating(true);
    
    if (isCorrect) {
      const points = (level * 10) + (streak * 5);
      setScore(score + points);
      setStreak(streak + 1);
      setFeedback(t.correct);
      createParticles('success');
      
      // Vérifier nouveau record
      if (score + points > bestScore) {
        setBestScore(score + points);
        setFeedback(`${t.newRecord} ${t.correct}`);
      }
      
      // Augmenter le niveau tous les 5 bonnes réponses
      if ((score + points) % 50 === 0 && level < 5) {
        setLevel(Math.min(5, level + 1) as DifficultyLevel);
        createParticles('levelUp');
      }
      
    } else {
      setLives(lives - 1);
      setStreak(0);
      setFeedback(t.incorrect);
      createParticles('error');
      
      if (lives <= 1) {
        // Game Over
        setCurrentScreen('gameOver');
        return;
      }
    }
    
    setShowFeedback(true);
    
    // Continuer après 2 secondes
    setTimeout(() => {
      setIsAnimating(false);
      generateNewQuestion();
    }, 2000);
  };
  
  const createParticles = (type: 'success' | 'error' | 'levelUp') => {
    const colors = {
      success: ['#10b981', '#34d399', '#6ee7b7'],
      error: ['#ef4444', '#f87171', '#fca5a5'],
      levelUp: ['#8b5cf6', '#a78bfa', '#c4b5fd']
    };
    
    const newParticles: Particle[] = [];
    for (let i = 0; i < 10; i++) {
      newParticles.push({
        id: Date.now() + i,
        color: colors[type][Math.floor(Math.random() * colors[type].length)],
        x: Math.random() * 100,
        y: Math.random() * 100,
        delay: Math.random() * 0.5
      });
    }
    
    setParticles(newParticles);
    setTimeout(() => setParticles([]), 3000);
  };
  
  const restartGame = () => {
    setCurrentScreen('home');
    setLevel(1);
    setOperation('addition');
  };
  
  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      checkAnswer();
    }
  };
  
  // =============================================================================
  // COMPOSANTS DE RENDU
  // =============================================================================
  
  const LanguageSelector: React.FC = () => {
    const languages: LanguageOption[] = [
      { code: 'fr', name: 'Français', flag: '🇫🇷' },
      { code: 'en', name: 'English', flag: '🇺🇸' },
      { code: 'es', name: 'Español', flag: '🇪🇸' },
      { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
      { code: 'ar', name: 'العربية', flag: '🇸🇦' },
      { code: 'zh', name: '中文', flag: '🇨🇳' },
      { code: 'ru', name: 'Русский', flag: '🇷🇺' },
      { code: 'pt', name: 'Português', flag: '🇧🇷' },
      { code: 'hi', name: 'हिंदी', flag: '🇮🇳' },
      { code: 'ja', name: '日本語', flag: '🇯🇵' }
    ];
    
    return (
      <div className="relative">
        <select
          value={language}
          onChange={(e) => setLanguage(e.target.value as LanguageCode)}
          className="bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-white/50 cursor-pointer"
          style={{ direction: language === 'ar' ? 'rtl' : 'ltr' }}
        >
          {languages.map(lang => (
            <option key={lang.code} value={lang.code} className="bg-gray-800 text-white">
              {lang.flag} {lang.name}
            </option>
          ))}
        </select>
        <Globe className="absolute right-3 top-3 w-4 h-4 text-white pointer-events-none" />
      </div>
    );
  };
  
  const HomeScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-pink-600 to-blue-600 flex flex-col items-center justify-center p-4 relative overflow-hidden">
      {/* Éléments décoratifs animés */}
      <div className="absolute inset-0 overflow-hidden">
        {[...Array(20)].map((_, i) => (
          <div
            key={i}
            className="absolute animate-bounce"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 3}s`,
              animationDuration: `${2 + Math.random() * 2}s`
            }}
          >
            {['🌟', '⭐', '✨', '🎈', '🎯', '🏆'][Math.floor(Math.random() * 6)]}
          </div>
        ))}
      </div>
      
      {/* Sélecteur de langue */}
      <div className="absolute top-4 right-4 z-10">
        <LanguageSelector />
      </div>
      
      {/* Contenu principal */}
      <div className="text-center z-10 max-w-md mx-auto">
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-8 shadow-2xl border border-white/20">
          <div className="text-6xl mb-4 animate-pulse">🧮</div>
          <h1 className="text-5xl font-bold text-white mb-2 font-['Comic_Sans_MS']">
            {t.title}
          </h1>
          <p className="text-xl text-white/90 mb-8">{t.subtitle}</p>
          
          {/* Meilleur score */}
          {bestScore > 0 && (
            <div className="bg-yellow-400/20 rounded-xl p-4 mb-6">
              <div className="flex items-center justify-center text-yellow-300">
                <Trophy className="w-5 h-5 mr-2" />
                <span className="font-semibold">Record: {bestScore}</span>
              </div>
            </div>
          )}
          
          {/* Boutons de niveau */}
          <div className="mb-6">
            <h3 className="text-white font-semibold mb-3">{t.level}</h3>
            <div className="grid grid-cols-3 gap-2">
              {([1, 2, 3, 4, 5] as const).map(lvl => (
                <button
                  key={lvl}
                  onClick={() => setLevel(lvl)}
                  className={`p-3 rounded-xl font-semibold transition-all duration-200 ${
                    level === lvl
                      ? 'bg-white text-purple-600 shadow-lg scale-105'
                      : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                >
                  {lvl}
                </button>
              ))}
            </div>
          </div>
          
          {/* Sélection d'opération */}
          <div className="mb-6">
            <h3 className="text-white font-semibold mb-3">{t.operations.addition}</h3>
            <div className="grid grid-cols-2 gap-2">
              {(['addition', 'subtraction', 'multiplication', 'division'] as const).map(op => (
                <button
                  key={op}
                  onClick={() => setOperation(op)}
                  className={`p-3 rounded-xl font-semibold transition-all duration-200 flex items-center justify-center ${
                    operation === op
                      ? 'bg-white text-purple-600 shadow-lg scale-105'
                      : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                  disabled={level < 2 && (op === 'multiplication' || op === 'division')}
                >
                  {op === 'addition' && <Plus className="w-4 h-4 mr-1" />}
                  {op === 'subtraction' && <Minus className="w-4 h-4 mr-1" />}
                  {op === 'multiplication' && <X className="w-4 h-4 mr-1" />}
                  {op === 'division' && <Divide className="w-4 h-4 mr-1" />}
                  <span className="text-xs">{t.operations[op]}</span>
                </button>
              ))}
            </div>
          </div>
          
          {/* Bouton de démarrage */}
          <button
            onClick={startGame}
            className="w-full bg-gradient-to-r from-green-400 to-blue-500 text-white font-bold py-4 px-8 rounded-2xl text-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 flex items-center justify-center"
          >
            <Gamepad2 className="w-6 h-6 mr-2" />
            {language === 'fr' ? 'Commencer' : language === 'en' ? 'Start Game' : 
             language === 'es' ? 'Empezar' : language === 'de' ? 'Spielen' :
             language === 'ar' ? 'ابدأ' : language === 'zh' ? '开始' :
             language === 'ru' ? 'Начать' : language === 'pt' ? 'Começar' :
             language === 'hi' ? 'शुरू करें' : language === 'ja' ? 'スタート' : 'Commencer'}
          </button>
          
          {/* Bouton paramètres */}
          <button
            onClick={() => setCurrentScreen('settings')}
            className="w-full mt-4 bg-white/20 text-white font-semibold py-3 px-6 rounded-xl hover:bg-white/30 transition-all duration-200 flex items-center justify-center"
          >
            <Settings className="w-5 h-5 mr-2" />
            {t.settings}
          </button>
        </div>
      </div>
    </div>
  );
  
  const GameScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 p-4 relative overflow-hidden">
      {/* Particules animées */}
      {particles.map(particle => (
        <div
          key={particle.id}
          className="absolute w-2 h-2 rounded-full animate-ping"
          style={{
            backgroundColor: particle.color,
            left: `${particle.x}%`,
            top: `${particle.y}%`,
            animationDelay: `${particle.delay}s`
          }}
        />
      ))}
      
      {/* En-tête avec stats */}
      <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 mb-6 shadow-lg">
        <div className="flex justify-between items-center">
          <div className="flex items-center space-x-4">
            <div className="flex items-center text-white">
              <Star className="w-5 h-5 mr-1 text-yellow-400" />
              <span className="font-bold">{score}</span>
            </div>
            <div className="flex items-center text-white">
              <Heart className="w-5 h-5 mr-1 text-red-400" />
              <span className="font-bold">{lives}</span>
            </div>
            <div className="flex items-center text-white">
              <Zap className="w-5 h-5 mr-1 text-blue-400" />
              <span className="font-bold">{streak}</span>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <div className="text-white text-sm">
              {t.level} {level}
            </div>
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className="text-white p-2 hover:bg-white/20 rounded-lg transition-colors"
            >
              {soundEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
            </button>
            <button
              onClick={() => setCurrentScreen('home')}
              className="text-white p-2 hover:bg-white/20 rounded-lg transition-colors"
            >
              <Home className="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>
      
      {/* Zone de jeu principale */}
      <div
        ref={gameAreaRef}
        className="max-w-md mx-auto bg-white/10 backdrop-blur-lg rounded-3xl p-8 shadow-2xl text-center"
      >
        {currentQuestion && (
          <>
            {/* Question */}
            <div className="mb-8">
              <div className="text-4xl text-white font-bold mb-4">
                {currentQuestion.question} = ?
              </div>
              <div className="flex justify-center">
                {currentQuestion.operation === 'addition' && <Plus className="w-8 h-8 text-green-400" />}
                {currentQuestion.operation === 'subtraction' && <Minus className="w-8 h-8 text-red-400" />}
                {currentQuestion.operation === 'multiplication' && <X className="w-8 h-8 text-blue-400" />}
                {currentQuestion.operation === 'division' && <Divide className="w-8 h-8 text-purple-400" />}
              </div>
            </div>
            
            {/* Input de réponse */}
            <div className="mb-6">
              <input
                ref={inputRef}
                type="number"
                value={userAnswer}
                onChange={(e) => setUserAnswer(e.target.value)}
                onKeyPress={handleKeyPress}
                placeholder={t.answer}
                className={`w-full p-4 text-2xl text-center bg-white/20 border border-white/30 rounded-2xl text-white placeholder-white/70 focus:outline-none focus:ring-2 focus:ring-white/50 focus:bg-white/30 transition-all ${
                  isAnimating ? 'animate-pulse-glow' : ''
                }`}
                disabled={showFeedback}
              />
            </div>
            
            {/* Bouton de vérification */}
            <button
              onClick={checkAnswer}
              disabled={!userAnswer || showFeedback}
              className={`w-full bg-gradient-to-r from-emerald-400 to-cyan-400 text-white font-bold py-4 px-8 rounded-2xl text-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none flex items-center justify-center ${
                isAnimating ? 'animate-shake' : ''
              }`}
            >
              <Target className="w-6 h-6 mr-2" />
              {t.check}
            </button>
            
            {/* Feedback */}
            {showFeedback && (
              <div className={`mt-6 p-4 rounded-2xl font-bold text-lg ${
                feedback.includes(t.correct) 
                  ? 'bg-green-500/20 text-green-300 border border-green-500/30' 
                  : 'bg-red-500/20 text-red-300 border border-red-500/30'
              } animate-bounce`}>
                {feedback}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
  
  const GameOverScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-red-600 via-pink-600 to-purple-600 flex flex-col items-center justify-center p-4">
      <div className="text-center max-w-md mx-auto">
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-8 shadow-2xl border border-white/20">
          <div className="text-6xl mb-4">😢</div>
          <h2 className="text-4xl font-bold text-white mb-4">{t.gameOver}</h2>
          
          <div className="bg-white/20 rounded-2xl p-6 mb-6">
            <div className="text-white text-xl mb-2">{t.finalScore}</div>
            <div className="text-4xl font-bold text-yellow-300">{score}</div>
            
            {score === bestScore && score > 0 && (
              <div className="mt-4 text-yellow-300 font-semibold flex items-center justify-center">
                <Crown className="w-5 h-5 mr-2" />
                {t.newRecord}
              </div>
            )}
          </div>
          
          <div className="space-y-3">
            <button
              onClick={startGame}
              className="w-full bg-gradient-to-r from-green-400 to-blue-500 text-white font-bold py-4 px-8 rounded-2xl text-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 flex items-center justify-center"
            >
              <RotateCcw className="w-6 h-6 mr-2" />
              {t.playAgain}
            </button>
            
            <button
              onClick={restartGame}
              className="w-full bg-white/20 text-white font-semibold py-3 px-6 rounded-xl hover:bg-white/30 transition-all duration-200 flex items-center justify-center"
            >
              <Home className="w-5 h-5 mr-2" />
              {language === 'fr' ? 'Accueil' : language === 'en' ? 'Home' : 
               language === 'es' ? 'Inicio' : language === 'de' ? 'Startseite' :
               language === 'ar' ? 'الرئيسية' : language === 'zh' ? '首页' :
               language === 'ru' ? 'Главная' : language === 'pt' ? 'Início' :
               language === 'hi' ? 'होम' : language === 'ja' ? 'ホーム' : 'Accueil'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
  
  const SettingsScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-teal-600 to-green-600 p-4">
      <div className="max-w-md mx-auto">
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-8 shadow-2xl border border-white/20">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-3xl font-bold text-white">{t.settings}</h2>
            <button
              onClick={() => setCurrentScreen('home')}
              className="text-white p-2 hover:bg-white/20 rounded-lg transition-colors"
            >
              <Home className="w-6 h-6" />
            </button>
          </div>
          
          {/* Paramètres langue */}
          <div className="mb-6">
            <h3 className="text-white font-semibold mb-3 flex items-center">
              <Globe className="w-5 h-5 mr-2" />
              {t.language}
            </h3>
            <LanguageSelector />
          </div>
          
          {/* Paramètres son */}
          <div className="mb-6">
            <h3 className="text-white font-semibold mb-3 flex items-center">
              {soundEnabled ? <Volume2 className="w-5 h-5 mr-2" /> : <VolumeX className="w-5 h-5 mr-2" />}
              {t.sound}
            </h3>
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className={`w-full p-4 rounded-xl font-semibold transition-all duration-200 ${
                soundEnabled
                  ? 'bg-green-500 text-white shadow-lg'
                  : 'bg-red-500 text-white shadow-lg'
              }`}
            >
              {soundEnabled ? 'ON' : 'OFF'}
            </button>
          </div>
          
          {/* Statistiques */}
          <div className="bg-white/20 rounded-2xl p-6">
            <h3 className="text-white font-semibold mb-3 flex items-center">
              <TrendingUp className="w-5 h-5 mr-2" />
              {language === 'fr' ? 'Statistiques' : language === 'en' ? 'Statistics' : 
               language === 'es' ? 'Estadísticas' : language === 'de' ? 'Statistiken' :
               language === 'ar' ? 'الإحصائيات' : language === 'zh' ? '统计' :
               language === 'ru' ? 'Статистика' : language === 'pt' ? 'Estatísticas' :
               language === 'hi' ? 'आंकड़े' : language === 'ja' ? '統計' : 'Statistiques'}
            </h3>
            <div className="space-y-2 text-white">
              <div className="flex justify-between">
                <span>{language === 'fr' ? 'Meilleur score' : 'Best Score'}:</span>
                <span className="font-bold text-yellow-300">{bestScore}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
  
  // =============================================================================
  // RENDU PRINCIPAL
  // =============================================================================
  
  return (
    <div className="font-sans math4kids-app" style={{ direction: language === 'ar' ? 'rtl' : 'ltr' }}>
      {currentScreen === 'home' && <HomeScreen />}
      {currentScreen === 'game' && <GameScreen />}
      {currentScreen === 'gameOver' && <GameOverScreen />}
      {currentScreen === 'settings' && <SettingsScreen />}
    </div>
  );
};

export default Math4Kids;