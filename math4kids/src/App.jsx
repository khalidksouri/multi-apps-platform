import { Award, Heart, RotateCcw, Trophy, Volume2, VolumeX, Zap, Globe } from 'lucide-react';
import { useCallback, useEffect, useRef, useState } from 'react';

// Configuration des langues supportées
const SUPPORTED_LANGUAGES = [
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr' },
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', direction: 'ltr' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
];

// Traductions complètes
const translations = {
  en: {
    appName: 'Math4Kids',
    level: 'Level',
    question: 'Question',
    yourAnswer: 'Your answer...',
    validate: 'Validate',
    checking: 'Checking...',
    excellent: '🎉 Excellent!',
    oops: '❌ Oops! The answer was',
    addition: 'Addition',
    subtraction: 'Subtraction',
    multiplication: 'Multiplication',
    division: 'Division',
    score: 'Score',
  },
  fr: {
    appName: 'Math4Kids',
    level: 'Niveau',
    question: 'Question',
    yourAnswer: 'Ta réponse...',
    validate: 'Valider',
    checking: 'Vérification...',
    excellent: '🎉 Excellent !',
    oops: '❌ Oups ! La réponse était',
    addition: 'Addition',
    subtraction: 'Soustraction',
    multiplication: 'Multiplication',
    division: 'Division',
    score: 'Score',
  },
  es: {
    appName: 'Math4Kids',
    level: 'Nivel',
    question: 'Pregunta',
    yourAnswer: 'Tu respuesta...',
    validate: 'Validar',
    checking: 'Verificando...',
    excellent: '🎉 ¡Excelente!',
    oops: '❌ ¡Ups! La respuesta era',
    addition: 'Suma',
    subtraction: 'Resta',
    multiplication: 'Multiplicación',
    division: 'División',
    score: 'Puntuación',
  },
  de: {
    appName: 'Math4Kids',
    level: 'Level',
    question: 'Frage',
    yourAnswer: 'Deine Antwort...',
    validate: 'Bestätigen',
    checking: 'Überprüfung...',
    excellent: '🎉 Ausgezeichnet!',
    oops: '❌ Ups! Die Antwort war',
    addition: 'Addition',
    subtraction: 'Subtraktion',
    multiplication: 'Multiplikation',
    division: 'Division',
    score: 'Punkte',
  },
  zh: {
    appName: 'Math4Kids',
    level: '级别',
    question: '问题',
    yourAnswer: '你的答案...',
    validate: '验证',
    checking: '检查中...',
    excellent: '🎉 太棒了!',
    oops: '❌ 哎呀！答案是',
    addition: '加法',
    subtraction: '减法',
    multiplication: '乘法',
    division: '除法',
    score: '得分',
  },
  ja: {
    appName: 'Math4Kids',
    level: 'レベル',
    question: '問題',
    yourAnswer: 'あなたの答え...',
    validate: '確認',
    checking: 'チェック中...',
    excellent: '🎉 素晴らしい!',
    oops: '❌ おっと！答えは',
    addition: '足し算',
    subtraction: '引き算',
    multiplication: '掛け算',
    division: '割り算',
    score: 'スコア',
  },
  ar: {
    appName: 'Math4Kids',
    level: 'المستوى',
    question: 'السؤال',
    yourAnswer: 'إجابتك...',
    validate: 'تأكيد',
    checking: 'فحص...',
    excellent: '🎉 ممتاز!',
    oops: '❌ أوه! الإجابة كانت',
    addition: 'الجمع',
    subtraction: 'الطرح',
    multiplication: 'الضرب',
    division: 'القسمة',
    score: 'النتيجة',
  },
  ru: {
    appName: 'Math4Kids',
    level: 'Уровень',
    question: 'Вопрос',
    yourAnswer: 'Ваш ответ...',
    validate: 'Проверить',
    checking: 'Проверка...',
    excellent: '🎉 Отлично!',
    oops: '❌ Упс! Ответ был',
    addition: 'Сложение',
    subtraction: 'Вычитание',
    multiplication: 'Умножение',
    division: 'Деление',
    score: 'Счёт',
  },
  hi: {
    appName: 'Math4Kids',
    level: 'स्तर',
    question: 'प्रश्न',
    yourAnswer: 'आपका उत्तर...',
    validate: 'सत्यापित करें',
    checking: 'जाँच रहे हैं...',
    excellent: '🎉 बहुत बढ़िया!',
    oops: '❌ अरे! उत्तर था',
    addition: 'जोड़',
    subtraction: 'घटाव',
    multiplication: 'गुणा',
    division: 'भाग',
    score: 'स्कोर',
  },
  pt: {
    appName: 'Math4Kids',
    level: 'Nível',
    question: 'Pergunta',
    yourAnswer: 'Sua resposta...',
    validate: 'Validar',
    checking: 'Verificando...',
    excellent: '🎉 Excelente!',
    oops: '❌ Ops! A resposta era',
    addition: 'Adição',
    subtraction: 'Subtração',
    multiplication: 'Multiplicação',
    division: 'Divisão',
    score: 'Pontuação',
  }
};

const Math4Kids = () => {
  const [score, setScore] = useState(0);
  const [level, setLevel] = useState(1);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [currentLanguage, setCurrentLanguage] = useState(SUPPORTED_LANGUAGES[0]);
  const [isAnimating, setIsAnimating] = useState(false);
  const inputRef = useRef(null);

  // Fonction de traduction avec fallback
  const t = useCallback((key) => {
    const currentTranslations = translations[currentLanguage.code];
    if (currentTranslations && currentTranslations[key]) {
      return currentTranslations[key];
    }
    return translations.en[key] || key;
  }, [currentLanguage.code]);

  // Générer une question avec variété selon le niveau
  const generateQuestion = useCallback(() => {
    const operations = [];
    
    if (level === 1) {
      operations.push({
        type: 'addition',
        generate: () => {
          const a = Math.floor(Math.random() * 50) + 1;
          const b = Math.floor(Math.random() * 20) + 1;
          return { question: `${a} + ${b}`, answer: a + b, type: 'addition' };
        }
      });
    }
    
    if (level >= 2) {
      operations.push({
        type: 'addition',
        generate: () => {
          const a = Math.floor(Math.random() * 95) + 5;
          const b = Math.floor(Math.random() * 95) + 5;
          return { question: `${a} + ${b}`, answer: a + b, type: 'addition' };
        }
      });
      
      operations.push({
        type: 'subtraction',
        generate: () => {
          const a = Math.floor(Math.random() * 91) + 10;
          const b = Math.floor(Math.random() * (a - 1)) + 1;
          return { question: `${a} - ${b}`, answer: a - b, type: 'subtraction' };
        }
      });
    }
    
    if (level >= 3) {
      operations.push({
        type: 'multiplication',
        generate: () => {
          const a = Math.floor(Math.random() * 25) + 1;
          const b = Math.floor(Math.random() * 25) + 1;
          return { question: `${a} × ${b}`, answer: a * b, type: 'multiplication' };
        }
      });
      
      operations.push({
        type: 'division',
        generate: () => {
          const result = Math.floor(Math.random() * 20) + 1;
          const divisor = Math.floor(Math.random() * 11) + 2;
          const dividend = result * divisor;
          return { question: `${dividend} ÷ ${divisor}`, answer: result, type: 'division' };
        }
      });
    }
    
    if (operations.length === 0) {
      const a = Math.floor(Math.random() * 10) + 1;
      const b = Math.floor(Math.random() * 10) + 1;
      return { question: `${a} + ${b}`, answer: a + b, type: 'addition' };
    }
    
    const operation = operations[Math.floor(Math.random() * operations.length)];
    return operation.generate();
  }, [level]);

  const [currentQ, setCurrentQ] = useState(() => generateQuestion());

  // Changer de langue
  const changeLanguage = useCallback((language) => {
    setCurrentLanguage(language);
    try {
      localStorage.setItem('math4kids_language', language.code);
    } catch (e) {
      console.warn('localStorage not available');
    }
    document.documentElement.setAttribute('dir', language.direction);
    document.documentElement.setAttribute('lang', language.code);
  }, []);

  // Gérer la réponse
  const handleAnswer = useCallback(() => {
    if (userAnswer === '' || isAnimating) return;
    
    setIsAnimating(true);
    const isCorrect = parseInt(userAnswer) === currentQ.answer;
    
    if (isCorrect) {
      const newScore = score + 10;
      setScore(newScore);
      setFeedback(t('excellent'));
      
      if (newScore > 0 && newScore % 50 === 0 && level < 3) {
        setLevel(prev => prev + 1);
      }
    } else {
      setFeedback(`${t('oops')} ${currentQ.answer}`);
    }
    
    setShowFeedback(true);
    
    setTimeout(() => {
      setIsAnimating(false);
      setShowFeedback(false);
      setFeedback('');
      setUserAnswer('');
      setCurrentQ(generateQuestion());
      setCurrentQuestion(prev => prev + 1);
      
      if (inputRef.current) {
        inputRef.current.focus();
      }
    }, 2000);
  }, [userAnswer, currentQ.answer, t, generateQuestion, isAnimating, score, level]);

  // Reset du jeu
  const resetGame = useCallback(() => {
    setScore(0);
    setLevel(1);
    setCurrentQuestion(0);
    setUserAnswer('');
    setFeedback('');
    setShowFeedback(false);
    setIsAnimating(false);
    setCurrentQ(generateQuestion());
  }, [generateQuestion]);

  // Gérer la touche Enter
  const handleKeyPress = useCallback((e) => {
    if (e.key === 'Enter' && !isAnimating) {
      handleAnswer();
    }
  }, [handleAnswer, isAnimating]);

  // Charger la langue au démarrage
  useEffect(() => {
    try {
      const savedLang = localStorage.getItem('math4kids_language');
      if (savedLang) {
        const found = SUPPORTED_LANGUAGES.find(lang => lang.code === savedLang);
        if (found) {
          setCurrentLanguage(found);
          document.documentElement.setAttribute('dir', found.direction);
          document.documentElement.setAttribute('lang', found.code);
        }
      }
    } catch (e) {
      console.warn('localStorage not available');
    }
  }, []);

  // Focus automatique sur l'input
  useEffect(() => {
    if (inputRef.current && !isAnimating) {
      inputRef.current.focus();
    }
  }, [isAnimating, currentQ]);

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #60a5fa 0%, #a855f7 50%, #ec4899 100%)',
      position: 'relative',
      overflow: 'hidden'
    }}>
      {/* Header */}
      <div style={{
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)',
        padding: '1rem',
        boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)'
      }}>
        <div style={{
          maxWidth: '64rem',
          margin: '0 auto',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '1rem',
          flexWrap: 'wrap'
        }}>
          <h1 style={{
            fontSize: '1.875rem',
            fontWeight: 'bold',
            color: 'white',
            margin: 0,
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem'
          }}>
            🧮 {t('appName')}
          </h1>
          
          <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
            <div style={{ 
              color: 'white', 
              display: 'flex', 
              alignItems: 'center',
              background: 'rgba(255, 255, 255, 0.2)',
              padding: '0.5rem',
              borderRadius: '8px'
            }}>
              <Trophy size={20} style={{ marginRight: '0.5rem' }} />
              {t('level')} {level} - {t('score')}: {score}
            </div>
            
            <select
              value={currentLanguage.code}
              onChange={(e) => {
                const lang = SUPPORTED_LANGUAGES.find(l => l.code === e.target.value);
                if (lang) changeLanguage(lang);
              }}
              style={{
                background: 'rgba(255, 255, 255, 0.9)',
                border: 'none',
                borderRadius: '8px',
                padding: '0.5rem',
                color: '#374151',
                cursor: 'pointer'
              }}
              aria-label="Select language"
            >
              {SUPPORTED_LANGUAGES.map(lang => (
                <option key={lang.code} value={lang.code}>
                  {lang.flag} {lang.nativeName}
                </option>
              ))}
            </select>
            
            <button
              onClick={resetGame}
              style={{
                background: 'rgba(255, 255, 255, 0.2)',
                border: 'none',
                padding: '0.5rem',
                borderRadius: '8px',
                cursor: 'pointer',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem'
              }}
              aria-label="Reset game"
            >
              <RotateCcw size={20} />
            </button>
          </div>
        </div>
      </div>

      {/* Contenu principal */}
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '2rem',
        minHeight: 'calc(100vh - 100px)'
      }}>
        <div style={{
          background: 'rgba(255, 255, 255, 0.95)',
          borderRadius: '24px',
          padding: '2rem',
          maxWidth: '28rem',
          width: '100%',
          textAlign: 'center',
          boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
          transition: 'transform 0.2s ease-in-out',
          transform: showFeedback ? 'scale(1.02)' : 'scale(1)'
        }}>
          <div style={{ marginBottom: '2rem' }}>
            <div style={{
              fontSize: '0.875rem',
              fontWeight: '500',
              color: '#6b7280',
              marginBottom: '0.5rem'
            }}>
              {t('question')} {currentQuestion + 1} - {t('level')} {level}
            </div>
            <div style={{
              fontSize: '3rem',
              fontWeight: 'bold',
              color: '#1f2937',
              marginBottom: '1rem',
              fontFamily: 'monospace'
            }}>
              {currentQ.question} = ?
            </div>
            <span style={{
              background: currentQ.type === 'addition' ? '#dcfce7' : 
                         currentQ.type === 'subtraction' ? '#fef3c7' : 
                         currentQ.type === 'multiplication' ? '#ddd6fe' :
                         '#fed7e2',
              color: currentQ.type === 'addition' ? '#166534' : 
                     currentQ.type === 'subtraction' ? '#92400e' : 
                     currentQ.type === 'multiplication' ? '#5b21b6' :
                     '#be185d',
              padding: '0.25rem 0.5rem',
              borderRadius: '9999px',
              fontSize: '0.75rem'
            }}>
              {currentQ.type === 'addition' ? '➕' : 
               currentQ.type === 'subtraction' ? '➖' : 
               currentQ.type === 'multiplication' ? '✖️' : '➗'} {t(currentQ.type)}
            </span>
          </div>

          <div style={{ marginBottom: '1.5rem' }}>
            <input
              ref={inputRef}
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder={t('yourAnswer')}
              style={{
                width: '100%',
                textAlign: 'center',
                fontSize: '1.5rem',
                fontWeight: 'bold',
                padding: '1rem',
                borderRadius: '1rem',
                border: '2px solid #d8b4fe',
                outline: 'none',
                background: isAnimating ? '#f3f4f6' : 'white',
                transition: 'all 0.2s ease-in-out'
              }}
              disabled={isAnimating}
              aria-label={t('yourAnswer')}
            />
          </div>

          <button
            onClick={handleAnswer}
            disabled={isAnimating || userAnswer === ''}
            style={{
              width: '100%',
              padding: '1rem',
              borderRadius: '1rem',
              fontWeight: 'bold',
              fontSize: '1.25rem',
              border: 'none',
              cursor: isAnimating || userAnswer === '' ? 'not-allowed' : 'pointer',
              background: isAnimating || userAnswer === '' 
                ? '#d1d5db' 
                : 'linear-gradient(135deg, #a855f7 0%, #ec4899 100%)',
              color: isAnimating || userAnswer === '' ? '#6b7280' : 'white',
              transition: 'all 0.2s ease-in-out'
            }}
          >
            {isAnimating ? t('checking') : t('validate')}
          </button>

          {showFeedback && (
            <div style={{
              marginTop: '1.5rem',
              padding: '1rem',
              borderRadius: '1rem',
              textAlign: 'center',
              fontWeight: 'bold',
              background: feedback.includes('🎉') ? '#dcfce7' : '#fef2f2',
              color: feedback.includes('🎉') ? '#166534' : '#dc2626',
              animation: 'fadeIn 0.3s ease-in-out'
            }}>
              {feedback}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Math4Kids;
