import {
  Award,
  ChevronDown,
  Crown,
  Divide,
  Gift,
  Globe,
  Heart,
  Home,
  Minus,
  Plus,
  Rocket,
  RotateCcw,
  Settings,
  Sparkles,
  Star,
  Target,
  Trophy, Volume2, VolumeX,
  X,
  Zap
} from 'lucide-react';
import React, { useCallback, useEffect, useRef, useState } from 'react';

// =============================================================================
// TYPES TYPESCRIPT
// =============================================================================

interface Translation {
  appName: string;
  title: string;
  subtitle: string;
  welcomeMessage: string;
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
  excellent: string;
  tryAgain: string;
  gameOver: string;
  finalScore: string;
  newRecord: string;
  achievements: string;
  playAgain: string;
  startGame: string;
  selectLanguage: string;
  instructions: string;
  chooseLevel: string;
  chooseOperation: string;
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

interface LanguageOption {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  direction: 'ltr' | 'rtl';
  continent: string;
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

// =============================================================================
// LANGUES SUPPORTÉES - TOUS LES CONTINENTS
// =============================================================================

const SUPPORTED_LANGUAGES: LanguageOption[] = [
  // EUROPE
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr', continent: 'Europe' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr', continent: 'Europe' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr', continent: 'Europe' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr', continent: 'Europe' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr', continent: 'Europe' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr', continent: 'Europe' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr', continent: 'Europe' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', direction: 'ltr', continent: 'Europe' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', direction: 'ltr', continent: 'Europe' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', direction: 'ltr', continent: 'Europe' },
  
  // ASIE
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', direction: 'ltr', continent: 'Asia' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr', continent: 'Asia' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr', continent: 'Asia' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr', continent: 'Asia' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl', continent: 'Asia' },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', direction: 'rtl', continent: 'Asia' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', direction: 'ltr', continent: 'Asia' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', direction: 'ltr', continent: 'Asia' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', direction: 'ltr', continent: 'Asia' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', direction: 'ltr', continent: 'Asia' },
  
  // AMÉRIQUES
  { code: 'en-us', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', direction: 'ltr', continent: 'Americas' },
  { code: 'es-mx', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', direction: 'ltr', continent: 'Americas' },
  { code: 'pt-br', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', direction: 'ltr', continent: 'Americas' },
  { code: 'fr-ca', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', direction: 'ltr', continent: 'Americas' },
  
  // AFRIQUE
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', direction: 'ltr', continent: 'Africa' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', direction: 'ltr', continent: 'Africa' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', direction: 'ltr', continent: 'Africa' },
  
  // OCÉANIE
  { code: 'en-au', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', direction: 'ltr', continent: 'Oceania' },
];

// =============================================================================
// TRADUCTIONS COMPLÈTES - AVEC TRADUCTION ALLEMANDE COMPLÈTE
// =============================================================================

const translations: Record<string, Translation> = {
  fr: {
    appName: "Math4Kids",
    title: "Math4Kids",
    subtitle: "Apprendre les maths en s'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    level: "Niveau", score: "Score", lives: "Vies", streak: "Série",
    answer: "Réponse", check: "Vérifier", next: "Suivant", restart: "Recommencer",
    settings: "Paramètres", language: "Langue", sound: "Son", difficulty: "Difficulté",
    correct: "🎉 Excellent !", incorrect: "❌ Oups ! Essaie encore !",
    excellent: "🌟 Formidable !", tryAgain: "Réessaie !",
    gameOver: "Partie terminée !", finalScore: "Score final", newRecord: "🏆 Nouveau record !",
    achievements: "Succès", playAgain: "Rejouer", startGame: "🚀 Commencer le jeu",
    selectLanguage: "Choisir la langue", instructions: "Instructions",
    chooseLevel: "Choisis ton niveau", chooseOperation: "Choisis l'opération",
    operations: {
      addition: "Addition", subtraction: "Soustraction",
      multiplication: "Multiplication", division: "Division", mixed: "Mélangé"
    },
    levels: { 1: "Débutant", 2: "Facile", 3: "Moyen", 4: "Difficile", 5: "Expert" }
  },
  
  en: {
    appName: "Math4Kids",
    title: "Math4Kids",
    subtitle: "Learn math while having fun!",
    welcomeMessage: "Welcome to the math adventure!",
    level: "Level", score: "Score", lives: "Lives", streak: "Streak",
    answer: "Answer", check: "Check", next: "Next", restart: "Restart",
    settings: "Settings", language: "Language", sound: "Sound", difficulty: "Difficulty",
    correct: "🎉 Excellent!", incorrect: "❌ Oops! Try again!",
    excellent: "🌟 Amazing!", tryAgain: "Try again!",
    gameOver: "Game Over!", finalScore: "Final Score", newRecord: "🏆 New Record!",
    achievements: "Achievements", playAgain: "Play Again", startGame: "🚀 Start Game",
    selectLanguage: "Select Language", instructions: "Instructions",
    chooseLevel: "Choose your level", chooseOperation: "Choose operation",
    operations: {
      addition: "Addition", subtraction: "Subtraction",
      multiplication: "Multiplication", division: "Division", mixed: "Mixed"
    },
    levels: { 1: "Beginner", 2: "Easy", 3: "Medium", 4: "Hard", 5: "Expert" }
  },
  
  es: {
    appName: "Mates4Niños",
    title: "Mates4Niños",
    subtitle: "¡Aprende matemáticas divirtiéndote!",
    welcomeMessage: "¡Bienvenido a la aventura matemática!",
    level: "Nivel", score: "Puntuación", lives: "Vidas", streak: "Racha",
    answer: "Respuesta", check: "Verificar", next: "Siguiente", restart: "Reiniciar",
    settings: "Configuración", language: "Idioma", sound: "Sonido", difficulty: "Dificultad",
    correct: "🎉 ¡Excelente!", incorrect: "❌ ¡Ups! ¡Inténtalo de nuevo!",
    excellent: "🌟 ¡Increíble!", tryAgain: "¡Inténtalo de nuevo!",
    gameOver: "¡Juego terminado!", finalScore: "Puntuación final", newRecord: "🏆 ¡Nuevo récord!",
    achievements: "Logros", playAgain: "Jugar de nuevo", startGame: "🚀 Empezar juego",
    selectLanguage: "Seleccionar idioma", instructions: "Instrucciones",
    chooseLevel: "Elige tu nivel", chooseOperation: "Elige la operación",
    operations: {
      addition: "Suma", subtraction: "Resta",
      multiplication: "Multiplicación", division: "División", mixed: "Mixto"
    },
    levels: { 1: "Principiante", 2: "Fácil", 3: "Medio", 4: "Difícil", 5: "Experto" }
  },
  
  // TRADUCTION ALLEMANDE COMPLÈTE ET CORRIGÉE
  de: {
    appName: "Mathe4Kinder",
    title: "Mathe4Kinder",
    subtitle: "Mathematik lernen macht Spaß!",
    welcomeMessage: "Willkommen im Mathematik-Abenteuer!",
    level: "Level", score: "Punkte", lives: "Leben", streak: "Serie",
    answer: "Antwort", check: "Prüfen", next: "Weiter", restart: "Neustart",
    settings: "Einstellungen", language: "Sprache", sound: "Ton", difficulty: "Schwierigkeit",
    correct: "🎉 Ausgezeichnet!", incorrect: "❌ Ups! Versuche es nochmal!",
    excellent: "🌟 Großartig!", tryAgain: "Versuche es nochmal!",
    gameOver: "Spiel beendet!", finalScore: "Endpunktzahl", newRecord: "🏆 Neuer Rekord!",
    achievements: "Erfolge", playAgain: "Nochmal spielen", startGame: "🚀 Spiel starten",
    selectLanguage: "Sprache wählen", instructions: "Anweisungen",
    chooseLevel: "Wähle dein Level", chooseOperation: "Wähle die Operation",
    operations: {
      addition: "Addition", subtraction: "Subtraktion",
      multiplication: "Multiplikation", division: "Division", mixed: "Gemischt"
    },
    levels: { 1: "Anfänger", 2: "Einfach", 3: "Mittel", 4: "Schwer", 5: "Experte" }
  },
  
  ar: {
    appName: "رياضيات الأطفال",
    title: "رياضيات الأطفال",
    subtitle: "تعلم الرياضيات مع المرح!",
    welcomeMessage: "مرحباً بك في مغامرة الرياضيات!",
    level: "المستوى", score: "النقاط", lives: "الأرواح", streak: "السلسلة",
    answer: "الإجابة", check: "تحقق", next: "التالي", restart: "إعادة البدء",
    settings: "الإعدادات", language: "اللغة", sound: "الصوت", difficulty: "الصعوبة",
    correct: "🎉 ممتاز!", incorrect: "❌ خطأ! حاول مرة أخرى!",
    excellent: "🌟 رائع!", tryAgain: "حاول مرة أخرى!",
    gameOver: "انتهت اللعبة!", finalScore: "النتيجة النهائية", newRecord: "🏆 رقم قياسي جديد!",
    achievements: "الإنجازات", playAgain: "العب مرة أخرى", startGame: "🚀 بدء اللعبة",
    selectLanguage: "اختر اللغة", instructions: "التعليمات",
    chooseLevel: "اختر مستواك", chooseOperation: "اختر العملية",
    operations: {
      addition: "الجمع", subtraction: "الطرح",
      multiplication: "الضرب", division: "القسمة", mixed: "مختلط"
    },
    levels: { 1: "مبتدئ", 2: "سهل", 3: "متوسط", 4: "صعب", 5: "خبير" }
  },
  
  zh: {
    appName: "儿童数学",
    title: "儿童数学",
    subtitle: "快乐学数学！",
    welcomeMessage: "欢迎来到数学冒险！",
    level: "级别", score: "得分", lives: "生命", streak: "连击",
    answer: "答案", check: "检查", next: "下一题", restart: "重新开始",
    settings: "设置", language: "语言", sound: "声音", difficulty: "难度",
    correct: "🎉 太棒了！", incorrect: "❌ 哎呀！再试一次！",
    excellent: "🌟 太神奇了！", tryAgain: "再试一次！",
    gameOver: "游戏结束！", finalScore: "最终得分", newRecord: "🏆 新记录！",
    achievements: "成就", playAgain: "再玩一次", startGame: "🚀 开始游戏",
    selectLanguage: "选择语言", instructions: "说明",
    chooseLevel: "选择你的级别", chooseOperation: "选择运算",
    operations: {
      addition: "加法", subtraction: "减法",
      multiplication: "乘法", division: "除法", mixed: "混合"
    },
    levels: { 1: "初学者", 2: "简单", 3: "中等", 4: "困难", 5: "专家" }
  }
};

// Ajouter les autres langues avec fallback aux traductions existantes
Object.assign(translations, {
  'en-us': translations.en,
  'es-mx': translations.es,
  'pt-br': translations.es, // Utilisera l'espagnol comme fallback temporaire
  'fr-ca': translations.fr,
  it: translations.en, pt: translations.en, ru: translations.en,
  nl: translations.en, sv: translations.en, pl: translations.en,
  ja: translations.zh, ko: translations.zh, hi: translations.zh,
  he: translations.ar, th: translations.zh, vi: translations.zh,
  id: translations.zh, tr: translations.en, sw: translations.en,
  am: translations.en, af: translations.en, 'en-au': translations.en
});

// =============================================================================
// GÉNÉRATEUR DE QUESTIONS
// =============================================================================

const generateQuestion = (level: DifficultyLevel, operation: OperationType): Question => {
  let question: string;
  let answer: number;
  
  const ranges = {
    1: { min: 1, max: 10 },
    2: { min: 1, max: 20 },
    3: { min: 10, max: 100 },
    4: { min: 50, max: 500 },
    5: { min: 100, max: 1000 }
  };
  
  const range = ranges[level];
  
  if (operation === 'addition') {
    const a = Math.floor(Math.random() * range.max) + range.min;
    const b = Math.floor(Math.random() * range.max) + range.min;
    question = `${a} + ${b}`;
    answer = a + b;
  } else if (operation === 'subtraction') {
    const a = Math.floor(Math.random() * range.max) + range.max;
    const b = Math.floor(Math.random() * range.max) + range.min;
    question = `${a} - ${b}`;
    answer = a - b;
  } else if (operation === 'multiplication') {
    const a = Math.floor(Math.random() * Math.min(range.max / 10, 20)) + 1;
    const b = Math.floor(Math.random() * Math.min(range.max / 10, 20)) + 1;
    question = `${a} × ${b}`;
    answer = a * b;
  } else if (operation === 'division') {
    const b = Math.floor(Math.random() * 10) + 2;
    const a = b * (Math.floor(Math.random() * 20) + 1);
    question = `${a} ÷ ${b}`;
    answer = a / b;
  } else {
    question = '2 + 2';
    answer = 4;
  }

  return { question, answer, operation, level };
};

// =============================================================================
// COMPOSANT PRINCIPAL
// =============================================================================

const Math4KidsEnhanced: React.FC = () => {
  // États principaux
  const [language, setLanguage] = useState('fr');
  const [currentScreen, setCurrentScreen] = useState<GameScreen>('home');
  const [level, setLevel] = useState<DifficultyLevel>(1);
  const [operation, setOperation] = useState<OperationType>('addition');
  const [score, setScore] = useState(0);
  const [lives, setLives] = useState(3);
  const [streak, setStreak] = useState(0);
  const [bestScore, setBestScore] = useState(0);
  const [soundEnabled, setSoundEnabled] = useState(true);
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false);
  
  // États du jeu
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [particles, setParticles] = useState<Particle[]>([]);
  
  // Références
  const inputRef = useRef<HTMLInputElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);
  
  // Traductions actuelles
  const t = translations[language] || translations.fr;
  const currentLang = SUPPORTED_LANGUAGES.find(l => l.code === language) || SUPPORTED_LANGUAGES[0];
  
  // Fermer dropdown en cliquant à l'extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setShowLanguageDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);
  
  // Sauvegarder/charger données
  useEffect(() => {
    const savedData = localStorage.getItem('math4kids-data');
    if (savedData) {
      try {
        const data = JSON.parse(savedData);
        setBestScore(data.bestScore || 0);
        setLanguage(data.language || 'fr');
        setSoundEnabled(data.soundEnabled ?? true);
      } catch (error) {
        console.error('Erreur chargement:', error);
      }
    }
  }, []);
  
  useEffect(() => {
    const dataToSave = { bestScore, language, soundEnabled };
    localStorage.setItem('math4kids-data', JSON.stringify(dataToSave));
  }, [bestScore, language, soundEnabled]);
  
  // Générer nouvelle question
  const generateNewQuestion = useCallback(() => {
    const newQuestion = generateQuestion(level, operation);
    setCurrentQuestion(newQuestion);
    setUserAnswer('');
    setShowFeedback(false);
    setTimeout(() => inputRef.current?.focus(), 100);
  }, [level, operation]);
  
  // Fonctions de jeu
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
    
    if (isCorrect) {
      const points = (level * 10) + (streak * 5);
      setScore(score + points);
      setStreak(streak + 1);
      setFeedback(t.correct);
      createParticles('success');
      
      if (score + points > bestScore) {
        setBestScore(score + points);
        setFeedback(t.newRecord);
      }
    } else {
      setLives(lives - 1);
      setStreak(0);
      setFeedback(`${t.incorrect} ${t.answer}: ${currentQuestion.answer}`);
      createParticles('error');
      
      if (lives <= 1) {
        setCurrentScreen('gameOver');
        return;
      }
    }
    
    setShowFeedback(true);
    setTimeout(() => {
      generateNewQuestion();
    }, 2000);
  };
  
  const createParticles = (type: 'success' | 'error') => {
    const colors = {
      success: ['#10b981', '#34d399', '#6ee7b7'],
      error: ['#ef4444', '#f87171', '#fca5a5']
    };
    
    const newParticles: Particle[] = [];
    for (let i = 0; i < 8; i++) {
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
  
  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') checkAnswer();
  };
  
  const changeLanguage = (newLanguage: string) => {
    setLanguage(newLanguage);
    setShowLanguageDropdown(false);
  };
  
  // =============================================================================
  // COMPOSANTS DE RENDU
  // =============================================================================
  
  const LanguageDropdown: React.FC = () => (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
        className="bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl px-4 py-3 text-white hover:bg-white/30 transition-all duration-300 flex items-center gap-2 shadow-lg hover:shadow-xl"
      >
        <Globe className="w-5 h-5" />
        <span className="text-2xl">{currentLang.flag}</span>
        <span className="hidden sm:inline font-medium">{currentLang.nativeName}</span>
        <ChevronDown className={`w-4 h-4 transition-transform duration-300 ${showLanguageDropdown ? 'rotate-180' : ''}`} />
      </button>
      
      {showLanguageDropdown && (
        <div className="absolute top-full right-0 mt-2 w-80 max-h-80 overflow-y-auto bg-white/95 backdrop-blur-lg rounded-2xl shadow-2xl border border-white/20 z-50">
          <div className="p-2">
            <div className="text-center p-3 border-b border-gray-200/50">
              <h3 className="font-bold text-gray-800">{t.selectLanguage}</h3>
            </div>
            
            {['Europe', 'Asia', 'Americas', 'Africa', 'Oceania'].map(continent => {
              const continentLanguages = SUPPORTED_LANGUAGES.filter(lang => lang.continent === continent);
              if (continentLanguages.length === 0) return null;
              
              return (
                <div key={continent} className="mb-2">
                  <div className="px-3 py-2 text-xs font-semibold text-gray-600 uppercase bg-gray-100/50 rounded-lg mx-1 mt-2">
                    {continent}
                  </div>
                  <div className="mt-1">
                    {continentLanguages.map((lang) => (
                      <button
                        key={lang.code}
                        onClick={() => changeLanguage(lang.code)}
                        className={`w-full p-3 rounded-xl transition-all duration-200 text-left hover:bg-blue-50 flex items-center gap-3 ${
                          language === lang.code ? 'bg-blue-100 text-blue-800 font-semibold' : 'text-gray-700'
                        }`}
                      >
                        <span className="text-xl">{lang.flag}</span>
                        <div className="flex-1">
                          <div className="font-medium text-sm">{lang.nativeName}</div>
                          <div className="text-xs text-gray-500">{lang.name}</div>
                        </div>
                        {language === lang.code && <div className="w-2 h-2 bg-blue-500 rounded-full"></div>}
                      </button>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
  
  const HomeScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-pink-600 to-blue-600 relative overflow-hidden" dir={currentLang.direction}>
      {/* Éléments décoratifs */}
      <div className="absolute inset-0 overflow-hidden">
        {[...Array(20)].map((_, i) => (
          <div
            key={i}
            className="absolute animate-float text-3xl opacity-70 hover:opacity-100 hover:scale-125 transition-all duration-300 cursor-pointer"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 3}s`,
              animationDuration: `${3 + Math.random() * 2}s`
            }}
            onClick={() => createParticles('success')}
          >
            {['🌟', '⭐', '✨', '🎈', '🎯', '🏆', '🎉', '🌈'][Math.floor(Math.random() * 8)]}
          </div>
        ))}
      </div>
      
      {/* Sélecteur de langue */}
      <div className="absolute top-6 right-6 z-20">
        <LanguageDropdown />
      </div>
      
      {/* Contenu principal */}
      <div className="flex flex-col items-center justify-center min-h-screen p-4 relative z-10">
        <div className="max-w-lg mx-auto">
          <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/20 hover:bg-white/15 transition-all duration-500">
            
            {/* En-tête */}
            <div className="text-center mb-8">
              <div className="text-8xl mb-4 animate-bounce cursor-pointer" onClick={() => createParticles('success')}>🧮</div>
              <h1 className="text-6xl font-bold text-white mb-2 font-fredoka">{t.appName}</h1>
              <p className="text-xl text-white/90 mb-4">{t.subtitle}</p>
              <p className="text-lg text-white/80">{t.welcomeMessage}</p>
            </div>
            
            {/* Statistiques */}
            {bestScore > 0 && (
              <div className="mb-8 bg-gradient-to-r from-yellow-400/20 to-orange-400/20 rounded-2xl p-6 border border-yellow-400/30">
                <div className="flex items-center justify-center text-yellow-300">
                  <Trophy className="w-6 h-6 mr-3" />
                  <span className="font-bold text-lg">Record: {bestScore}</span>
                  <Crown className="w-6 h-6 ml-3" />
                </div>
              </div>
            )}
            
            {/* Sélection niveau */}
            <div className="mb-6">
              <h3 className="text-white font-bold mb-4 text-center">{t.chooseLevel}</h3>
              <div className="grid grid-cols-5 gap-2">
                {([1, 2, 3, 4, 5] as const).map(lvl => (
                  <button
                    key={lvl}
                    onClick={() => setLevel(lvl)}
                    className={`p-4 rounded-xl font-bold transition-all duration-300 hover:scale-110 ${
                      level === lvl
                        ? 'bg-white text-purple-600 shadow-2xl scale-105'
                        : 'bg-white/20 text-white hover:bg-white/30'
                    }`}
                  >
                    <div className="text-2xl mb-1">{lvl}</div>
                    <div className="text-xs">{t.levels[lvl]}</div>
                  </button>
                ))}
              </div>
            </div>
            
            {/* Sélection opération */}
            <div className="mb-8">
              <h3 className="text-white font-bold mb-4 text-center">{t.chooseOperation}</h3>
              <div className="grid grid-cols-2 gap-3">
                {(['addition', 'subtraction', 'multiplication', 'division'] as const).map(op => (
                  <button
                    key={op}
                    onClick={() => setOperation(op)}
                    className={`p-4 rounded-xl font-semibold transition-all duration-300 flex items-center justify-center gap-2 hover:scale-105 ${
                      operation === op
                        ? 'bg-white text-purple-600 shadow-2xl scale-105'
                        : 'bg-white/20 text-white hover:bg-white/30'
                    }`}
                    disabled={level < 2 && (op === 'multiplication' || op === 'division')}
                  >
                    {op === 'addition' && <Plus className="w-5 h-5" />}
                    {op === 'subtraction' && <Minus className="w-5 h-5" />}
                    {op === 'multiplication' && <X className="w-5 h-5" />}
                    {op === 'division' && <Divide className="w-5 h-5" />}
                    <span className="text-sm">{t.operations[op]}</span>
                  </button>
                ))}
              </div>
            </div>
            
            {/* Boutons d'action */}
            <div className="space-y-4">
              <button
                onClick={startGame}
                className="w-full bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 text-white font-bold py-5 px-8 rounded-2xl text-xl shadow-2xl hover:shadow-3xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
              >
                <Rocket className="w-7 h-7 animate-bounce" />
                {t.startGame}
                <Sparkles className="w-7 h-7" />
              </button>
              
              <button
                onClick={() => setCurrentScreen('settings')}
                className="w-full bg-white/20 text-white font-semibold py-3 px-6 rounded-xl hover:bg-white/30 transition-all duration-300 flex items-center justify-center gap-2 hover:scale-105"
              >
                <Settings className="w-5 h-5" />
                {t.settings}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
  
  const GameScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 p-4 relative overflow-hidden" dir={currentLang.direction}>
      {/* Particules */}
      {particles.map(particle => (
        <div
          key={particle.id}
          className="absolute w-4 h-4 rounded-full animate-float pointer-events-none z-20"
          style={{
            backgroundColor: particle.color,
            left: `${particle.x}%`,
            top: `${particle.y}%`,
            animationDelay: `${particle.delay}s`,
            boxShadow: `0 0 20px ${particle.color}`
          }}
        />
      ))}
      
      {/* En-tête stats */}
      <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-6 mb-8 shadow-2xl border border-white/20">
        <div className="flex justify-between items-center flex-wrap gap-4">
          <div className="flex items-center space-x-4 flex-wrap">
            <div className="flex items-center text-white bg-gradient-to-r from-yellow-400/30 to-orange-400/30 rounded-xl px-4 py-3 shadow-lg">
              <Star className="w-6 h-6 mr-2 text-yellow-400" />
              <div>
                <span className="font-bold text-xl">{score}</span>
                <div className="text-xs opacity-80">{t.score}</div>
              </div>
            </div>
            
            <div className="flex items-center text-white bg-gradient-to-r from-red-400/30 to-pink-400/30 rounded-xl px-4 py-3 shadow-lg">
              <Heart className="w-6 h-6 mr-2 text-red-400" />
              <div>
                <span className="font-bold text-xl">{lives}</span>
                <div className="text-xs opacity-80">{t.lives}</div>
              </div>
            </div>
            
            <div className="flex items-center text-white bg-gradient-to-r from-blue-400/30 to-cyan-400/30 rounded-xl px-4 py-3 shadow-lg">
              <Zap className="w-6 h-6 mr-2 text-blue-400" />
              <div>
                <span className="font-bold text-xl">{streak}</span>
                <div className="text-xs opacity-80">{t.streak}</div>
              </div>
            </div>
          </div>
          
          <div className="flex items-center space-x-3">
            <div className="text-white text-sm bg-white/20 rounded-xl px-4 py-2 font-semibold">
              {t.level} {level}
            </div>
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className="text-white p-3 hover:bg-white/20 rounded-xl transition-all duration-300 bg-white/10"
            >
              {soundEnabled ? <Volume2 className="w-6 h-6" /> : <VolumeX className="w-6 h-6" />}
            </button>
            <button
              onClick={() => setCurrentScreen('home')}
              className="text-white p-3 hover:bg-white/20 rounded-xl transition-all duration-300 bg-white/10"
            >
              <Home className="w-6 h-6" />
            </button>
          </div>
        </div>
      </div>
      
      {/* Zone de jeu */}
      <div className="max-w-2xl mx-auto bg-white/10 backdrop-blur-xl rounded-3xl p-8 shadow-2xl text-center border border-white/20">
        {currentQuestion && (
          <>
            {/* Question */}
            <div className="mb-10">
              <div className="bg-gradient-to-br from-white via-blue-50 to-purple-50 rounded-3xl p-8 shadow-2xl mb-6 hover:scale-105 transition-transform duration-300">
                <div className="text-7xl text-gray-800 font-bold mb-4">{currentQuestion.question} = ?</div>
                <div className="text-lg text-gray-600 font-semibold">
                  {t.level} {level} • {t.operations[currentQuestion.operation]}
                </div>
              </div>
              
              <div className="flex justify-center mb-6">
                <div className="p-4 rounded-full bg-white/20 backdrop-blur-sm hover:bg-white/30 transition-all duration-300">
                  {currentQuestion.operation === 'addition' && <Plus className="w-12 h-12 text-green-400" />}
                  {currentQuestion.operation === 'subtraction' && <Minus className="w-12 h-12 text-red-400" />}
                  {currentQuestion.operation === 'multiplication' && <X className="w-12 h-12 text-blue-400" />}
                  {currentQuestion.operation === 'division' && <Divide className="w-12 h-12 text-purple-400" />}
                </div>
              </div>
            </div>
            
            {/* Input réponse */}
            <div className="mb-8">
              <input
                ref={inputRef}
                type="number"
                value={userAnswer}
                onChange={(e) => setUserAnswer(e.target.value)}
                onKeyPress={handleKeyPress}
                placeholder={t.answer}
                className="w-full max-w-md mx-auto p-6 text-3xl text-center bg-white/95 rounded-3xl text-gray-800 border-4 border-transparent focus:border-purple-400 focus:outline-none transition-all duration-300 shadow-2xl font-bold"
                disabled={showFeedback}
              />
            </div>
            
            {/* Bouton vérifier */}
            <button
              onClick={checkAnswer}
              disabled={!userAnswer || showFeedback}
              className="bg-gradient-to-r from-emerald-400 via-cyan-400 to-blue-500 text-white font-bold py-6 px-12 rounded-3xl text-2xl shadow-2xl hover:shadow-3xl transform hover:scale-110 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none flex items-center justify-center mx-auto gap-4"
            >
              <Target className="w-8 h-8" />
              {t.check}
              <Sparkles className="w-8 h-8" />
            </button>
            
            {/* Feedback */}
            {showFeedback && (
              <div className={`mt-8 p-6 rounded-3xl font-bold text-2xl text-center transition-all duration-500 shadow-2xl ${
                feedback.includes('🎉') || feedback.includes('🏆') || feedback.includes('🌟')
                  ? 'bg-gradient-to-r from-green-500/30 via-emerald-500/30 to-green-600/30 text-green-100 border-4 border-green-400/50' 
                  : 'bg-gradient-to-r from-red-500/30 via-pink-500/30 to-red-600/30 text-red-100 border-4 border-red-400/50'
              }`}>
                <div className="flex items-center justify-center gap-3">
                  {feedback.includes('🎉') ? <Gift className="w-8 h-8" /> : <RotateCcw className="w-8 h-8" />}
                  <span>{feedback}</span>
                  {feedback.includes('🎉') && <Sparkles className="w-8 h-8" />}
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
  
  const GameOverScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-red-600 via-pink-600 to-purple-600 flex flex-col items-center justify-center p-4" dir={currentLang.direction}>
      <div className="text-center max-w-lg mx-auto">
        <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/20">
          <div className="text-8xl mb-6 animate-bounce">😢</div>
          <h2 className="text-5xl font-bold text-white mb-6">{t.gameOver}</h2>
          
          <div className="bg-gradient-to-br from-white/20 to-white/10 rounded-3xl p-8 mb-8 shadow-xl">
            <div className="text-white text-2xl mb-4 font-semibold">{t.finalScore}</div>
            <div className="text-6xl font-bold text-yellow-300 mb-4">{score}</div>
            
            {score === bestScore && score > 0 && (
              <div className="mt-6 text-yellow-300 font-bold flex items-center justify-center gap-3">
                <Crown className="w-8 h-8" />
                {t.newRecord}
                <Trophy className="w-8 h-8" />
              </div>
            )}
          </div>
          
          <div className="space-y-4">
            <button
              onClick={startGame}
              className="w-full bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 text-white font-bold py-5 px-8 rounded-3xl text-xl shadow-2xl hover:shadow-3xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <RotateCcw className="w-7 h-7" />
              {t.playAgain}
              <Rocket className="w-7 h-7" />
            </button>
            
            <button
              onClick={() => setCurrentScreen('home')}
              className="w-full bg-white/20 text-white font-semibold py-4 px-6 rounded-2xl hover:bg-white/30 transition-all duration-300 flex items-center justify-center gap-2 hover:scale-105"
            >
              <Home className="w-6 h-6" />
              {t.settings}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
  
  const SettingsScreen: React.FC = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-teal-600 to-green-600 p-4" dir={currentLang.direction}>
      <div className="max-w-lg mx-auto">
        <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/20">
          <div className="flex items-center justify-between mb-8">
            <h2 className="text-4xl font-bold text-white flex items-center gap-3">
              <Settings className="w-8 h-8" />
              {t.settings}
            </h2>
            <button
              onClick={() => setCurrentScreen('home')}
              className="text-white p-3 hover:bg-white/20 rounded-xl transition-all duration-300 hover:scale-110"
            >
              <Home className="w-7 h-7" />
            </button>
          </div>
          
          {/* Paramètres langue */}
          <div className="mb-8">
            <h3 className="text-white font-bold mb-4 flex items-center gap-2 text-xl">
              <Globe className="w-6 h-6" />
              {t.language}
            </h3>
            <LanguageDropdown />
          </div>
          
          {/* Paramètres son */}
          <div className="mb-8">
            <h3 className="text-white font-bold mb-4 flex items-center gap-2 text-xl">
              {soundEnabled ? <Volume2 className="w-6 h-6" /> : <VolumeX className="w-6 h-6" />}
              {t.sound}
            </h3>
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className={`w-full p-6 rounded-2xl font-bold text-xl transition-all duration-300 hover:scale-105 ${
                soundEnabled
                  ? 'bg-gradient-to-r from-green-500 to-emerald-500 text-white shadow-2xl'
                  : 'bg-gradient-to-r from-red-500 to-pink-500 text-white shadow-2xl'
              }`}
            >
              {soundEnabled ? '🔊 ON' : '🔇 OFF'}
            </button>
          </div>
          
          {/* Statistiques */}
          <div className="bg-gradient-to-br from-white/20 to-white/10 rounded-3xl p-6 shadow-xl">
            <h3 className="text-white font-bold mb-6 flex items-center gap-2 text-xl">
              <Award className="w-6 h-6" />
              Statistiques
            </h3>
            <div className="grid grid-cols-2 gap-4 text-white">
              <div className="bg-gradient-to-br from-yellow-400/20 to-orange-400/20 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-sm">Record:</span>
                  <span className="font-bold text-xl text-yellow-300">{bestScore}</span>
                </div>
              </div>
              <div className="bg-gradient-to-br from-purple-400/20 to-pink-400/20 rounded-xl p-4">
                <div className="flex justify-between items-center">
                  <span className="text-sm">{t.language}:</span>
                  <span className="font-bold text-lg">{currentLang.nativeName}</span>
                </div>
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
    <div className="font-sans math4kids-enhanced-app" dir={currentLang.direction}>
      {currentScreen === 'home' && <HomeScreen />}
      {currentScreen === 'game' && <GameScreen />}
      {currentScreen === 'gameOver' && <GameOverScreen />}
      {currentScreen === 'settings' && <SettingsScreen />}
    </div>
  );
};

export default Math4KidsEnhanced;