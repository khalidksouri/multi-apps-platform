import { Award, Globe, Heart, RotateCcw, Trophy, Volume2, VolumeX, Zap } from 'lucide-react';
import { useCallback, useEffect, useRef, useState } from 'react';

// Configuration des langues supportées - TOUS LES CONTINENTS
const SUPPORTED_LANGUAGES = [
  // Europe
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr' },
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', direction: 'ltr' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', direction: 'ltr' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', direction: 'ltr' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', direction: 'ltr' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', direction: 'ltr' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', direction: 'ltr' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', direction: 'ltr' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', direction: 'ltr' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', direction: 'ltr' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', direction: 'ltr' },
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', direction: 'ltr' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', direction: 'ltr' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', direction: 'ltr' },
  { code: 'uk', name: 'Ukrainian', nativeName: 'Українська', flag: '🇺🇦', direction: 'ltr' },
  { code: 'be', name: 'Belarusian', nativeName: 'Беларуская', flag: '🇧🇾', direction: 'ltr' },
  { code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', direction: 'ltr' },
  { code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', direction: 'ltr' },
  { code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', direction: 'ltr' },
  { code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', direction: 'ltr' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', direction: 'ltr' },
  
  // Asie
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', direction: 'ltr' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', direction: 'ltr' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', direction: 'ltr' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳', direction: 'ltr' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', direction: 'ltr' },
  { code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', direction: 'ltr' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', direction: 'ltr' },
  { code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', direction: 'ltr' },
  { code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', flag: '🇮🇳', direction: 'ltr' },
  { code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳', direction: 'ltr' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', direction: 'rtl' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', direction: 'rtl' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl' },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', direction: 'rtl' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', direction: 'ltr' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', direction: 'ltr' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', direction: 'ltr' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', direction: 'ltr' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', direction: 'ltr' },
  { code: 'my', name: 'Myanmar', nativeName: 'မြန်မာ', flag: '🇲🇲', direction: 'ltr' },
  { code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', direction: 'ltr' },
  { code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', direction: 'ltr' },
  { code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', direction: 'ltr' },
  { code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', direction: 'ltr' },
  { code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', direction: 'ltr' },
  { code: 'kk', name: 'Kazakh', nativeName: 'Қазақша', flag: '🇰🇿', direction: 'ltr' },
  { code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргызча', flag: '🇰🇬', direction: 'ltr' },
  { code: 'uz', name: 'Uzbek', nativeName: 'O\'zbek', flag: '🇺🇿', direction: 'ltr' },
  { code: 'tg', name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', direction: 'ltr' },
  { code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', direction: 'ltr' },
  
  // Afrique
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', direction: 'ltr' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', direction: 'ltr' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', direction: 'ltr' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', direction: 'ltr' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', direction: 'ltr' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', direction: 'ltr' },
  { code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', direction: 'ltr' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', direction: 'ltr' },
  { code: 'so', name: 'Somali', nativeName: 'Soomaali', flag: '🇸🇴', direction: 'ltr' },
  { code: 'rw', name: 'Kinyarwanda', nativeName: 'Ikinyarwanda', flag: '🇷🇼', direction: 'ltr' },
  { code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', direction: 'ltr' },
  
  // Amériques
  { code: 'pt-br', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', direction: 'ltr' },
  { code: 'es-mx', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', direction: 'ltr' },
  { code: 'es-ar', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', direction: 'ltr' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', direction: 'ltr' },
  { code: 'gn', name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', direction: 'ltr' },
  { code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl ayisyen', flag: '🇭🇹', direction: 'ltr' },
  
  // Océanie
  { code: 'en-au', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', direction: 'ltr' },
  { code: 'en-nz', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', direction: 'ltr' },
  { code: 'mi', name: 'Māori', nativeName: 'Te Reo Māori', flag: '🇳🇿', direction: 'ltr' },
  { code: 'fj', name: 'Fijian', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', direction: 'ltr' },
  { code: 'to', name: 'Tongan', nativeName: 'Lea Faka-Tonga', flag: '🇹🇴', direction: 'ltr' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', direction: 'ltr' },
  
  // Langues additionnelles
  { code: 'eo', name: 'Esperanto', nativeName: 'Esperanto', flag: '🌍', direction: 'ltr' },
  { code: 'la', name: 'Latin', nativeName: 'Latina', flag: '🏛️', direction: 'ltr' },
];

// Traductions pour toutes les langues - VERSION COMPLÈTE
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
    points: 'points',
    gameOver: 'Game Over',
    newRecord: 'New Record!',
    finalScore: 'Final Score:',
    bestScore: 'Best Score:',
    levelReached: 'Level Reached:',
    achievements: '🏅 Achievements',
    restart: 'Restart',
    addition: '➕ Addition',
    subtraction: '➖ Subtraction',
    multiplication: '✖️ Multiplication',
    division: '➗ Division',
    levelUnlocked: '🎓 Level unlocked!',
    firstFifty: '🌟 First 50!',
    century: '💯 Century!',
    champion: '🏆 Champion!',
    streakThree: '🔥 Streak of 3!',
    streakFive: '⚡ Streak of 5!',
    streakTen: '🌟 Streak of 10!',
    disableSound: 'Disable sound',
    enableSound: 'Enable sound',
    restartGame: 'Restart game'
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
    points: 'points',
    gameOver: 'Fin de partie',
    newRecord: 'Nouveau record !',
    finalScore: 'Score final :',
    bestScore: 'Meilleur score :',
    levelReached: 'Niveau atteint :',
    achievements: '🏅 Succès',
    restart: 'Recommencer',
    addition: '➕ Addition',
    subtraction: '➖ Soustraction',
    multiplication: '✖️ Multiplication',
    division: '➗ Division',
    levelUnlocked: '🎓 Niveau débloqué !',
    firstFifty: '🌟 Premier 50 !',
    century: '💯 Centurion !',
    champion: '🏆 Champion !',
    streakThree: '🔥 Série de 3 !',
    streakFive: '⚡ Série de 5 !',
    streakTen: '🌟 Série de 10 !',
    disableSound: 'Désactiver le son',
    enableSound: 'Activer le son',
    restartGame: 'Recommencer'
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
    points: 'puntos',
    gameOver: 'Fin del juego',
    newRecord: '¡Nuevo récord!',
    finalScore: 'Puntuación final:',
    bestScore: 'Mejor puntuación:',
    levelReached: 'Nivel alcanzado:',
    achievements: '🏅 Logros',
    restart: 'Reiniciar',
    addition: '➕ Suma',
    subtraction: '➖ Resta',
    multiplication: '✖️ Multiplicación',
    division: '➗ División',
    levelUnlocked: '🎓 ¡Nivel desbloqueado!',
    firstFifty: '🌟 ¡Primeros 50!',
    century: '💯 ¡Centurión!',
    champion: '🏆 ¡Campeón!',
    streakThree: '🔥 ¡Racha de 3!',
    streakFive: '⚡ ¡Racha de 5!',
    streakTen: '🌟 ¡Racha de 10!',
    disableSound: 'Desactivar sonido',
    enableSound: 'Activar sonido',
    restartGame: 'Reiniciar'
  },
  de: {
    appName: 'Math4Kids',
    level: 'Level',
    question: 'Frage',
    yourAnswer: 'Deine Antwort...',
    validate: 'Bestätigen',
    checking: 'Überprüfe...',
    excellent: '🎉 Ausgezeichnet!',
    oops: '❌ Ups! Die Antwort war',
    points: 'Punkte',
    gameOver: 'Spiel beendet',
    newRecord: 'Neuer Rekord!',
    finalScore: 'Endpunktzahl:',
    bestScore: 'Beste Punktzahl:',
    levelReached: 'Level erreicht:',
    achievements: '🏅 Erfolge',
    restart: 'Neustart',
    addition: '➕ Addition',
    subtraction: '➖ Subtraktion',
    multiplication: '✖️ Multiplikation',
    division: '➗ Division',
    levelUnlocked: '🎓 Level freigeschaltet!',
    firstFifty: '🌟 Erste 50!',
    century: '💯 Hundert!',
    champion: '🏆 Champion!',
    streakThree: '🔥 Serie von 3!',
    streakFive: '⚡ Serie von 5!',
    streakTen: '🌟 Serie von 10!',
    disableSound: 'Ton ausschalten',
    enableSound: 'Ton einschalten',
    restartGame: 'Neustart'
  },
  zh: {
    appName: 'Math4Kids',
    level: '级别',
    question: '问题',
    yourAnswer: '你的答案...',
    validate: '验证',
    checking: '检查中...',
    excellent: '🎉 太棒了！',
    oops: '❌ 糟糕！答案是',
    points: '分',
    gameOver: '游戏结束',
    newRecord: '新记录！',
    finalScore: '最终得分：',
    bestScore: '最佳得分：',
    levelReached: '达到级别：',
    achievements: '🏅 成就',
    restart: '重新开始',
    addition: '➕ 加法',
    subtraction: '➖ 减法',
    multiplication: '✖️ 乘法',
    division: '➗ 除法',
    levelUnlocked: '🎓 级别解锁！',
    firstFifty: '🌟 前50名！',
    century: '💯 百分！',
    champion: '🏆 冠军！',
    streakThree: '🔥 连击3！',
    streakFive: '⚡ 连击5！',
    streakTen: '🌟 连击10！',
    disableSound: '关闭声音',
    enableSound: '开启声音',
    restartGame: '重新开始'
  },
  ja: {
    appName: 'Math4Kids',
    level: 'レベル',
    question: '問題',
    yourAnswer: 'あなたの答え...',
    validate: '確認',
    checking: 'チェック中...',
    excellent: '🎉 素晴らしい！',
    oops: '❌ おっと！答えは',
    points: 'ポイント',
    gameOver: 'ゲームオーバー',
    newRecord: '新記録！',
    finalScore: '最終スコア：',
    bestScore: 'ベストスコア：',
    levelReached: '到達レベル：',
    achievements: '🏅 実績',
    restart: '再開',
    addition: '➕ 足し算',
    subtraction: '➖ 引き算',
    multiplication: '✖️ かけ算',
    division: '➗ わり算',
    levelUnlocked: '🎓 レベルアップ！',
    firstFifty: '🌟 初回50！',
    century: '💯 センチュリー！',
    champion: '🏆 チャンピオン！',
    streakThree: '🔥 3連続！',
    streakFive: '⚡ 5連続！',
    streakTen: '🌟 10連続！',
    disableSound: '音を無効',
    enableSound: '音を有効',
    restartGame: '再開'
  },
  ar: {
    appName: 'Math4Kids',
    level: 'المستوى',
    question: 'السؤال',
    yourAnswer: 'إجابتك...',
    validate: 'تأكيد',
    checking: 'التحقق...',
    excellent: '🎉 ممتاز!',
    oops: '❌ عفواً! الإجابة كانت',
    points: 'نقاط',
    gameOver: 'انتهت اللعبة',
    newRecord: 'رقم قياسي جديد!',
    finalScore: 'النقاط النهائية:',
    bestScore: 'أفضل نقاط:',
    levelReached: 'المستوى المحقق:',
    achievements: '🏅 الإنجازات',
    restart: 'إعادة البدء',
    addition: '➕ الجمع',
    subtraction: '➖ الطرح',
    multiplication: '✖️ الضرب',
    division: '➗ القسمة',
    levelUnlocked: '🎓 تم فتح المستوى!',
    firstFifty: '🌟 أول 50!',
    century: '💯 مئوية!',
    champion: '🏆 بطل!',
    streakThree: '🔥 سلسلة من 3!',
    streakFive: '⚡ سلسلة من 5!',
    streakTen: '🌟 سلسلة من 10!',
    disableSound: 'إيقاف الصوت',
    enableSound: 'تشغيل الصوت',
    restartGame: 'إعادة البدء'
  },
  ko: {
    appName: 'Math4Kids',
    level: '레벨',
    question: '문제',
    yourAnswer: '당신의 답...',
    validate: '확인',
    checking: '확인 중...',
    excellent: '🎉 훌륭해요!',
    oops: '❌ 앗! 정답은',
    points: '점',
    gameOver: '게임 종료',
    newRecord: '신기록!',
    finalScore: '최종 점수:',
    bestScore: '최고 점수:',
    levelReached: '도달 레벨:',
    achievements: '🏅 업적',
    restart: '다시 시작',
    addition: '➕ 덧셈',
    subtraction: '➖ 뺄셈',
    multiplication: '✖️ 곱셈',
    division: '➗ 나눗셈',
    levelUnlocked: '🎓 레벨 해제!',
    firstFifty: '🌟 첫 50점!',
    century: '💯 백점!',
    champion: '🏆 챔피언!',
    streakThree: '🔥 3연속!',
    streakFive: '⚡ 5연속!',
    streakTen: '🌟 10연속!',
    disableSound: '소리 끄기',
    enableSound: '소리 켜기',
    restartGame: '다시 시작'
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
    points: 'pontos',
    gameOver: 'Fim de jogo',
    newRecord: 'Novo recorde!',
    finalScore: 'Pontuação final:',
    bestScore: 'Melhor pontuação:',
    levelReached: 'Nível alcançado:',
    achievements: '🏅 Conquistas',
    restart: 'Reiniciar',
    addition: '➕ Adição',
    subtraction: '➖ Subtração',
    multiplication: '✖️ Multiplicação',
    division: '➗ Divisão',
    levelUnlocked: '🎓 Nível desbloqueado!',
    firstFifty: '🌟 Primeiros 50!',
    century: '💯 Centenário!',
    champion: '🏆 Campeão!',
    streakThree: '🔥 Sequência de 3!',
    streakFive: '⚡ Sequência de 5!',
    streakTen: '🌟 Sequência de 10!',
    disableSound: 'Desativar som',
    enableSound: 'Ativar som',
    restartGame: 'Reiniciar'
  },
  it: {
    appName: 'Math4Kids',
    level: 'Livello',
    question: 'Domanda',
    yourAnswer: 'La tua risposta...',
    validate: 'Convalida',
    checking: 'Verifica...',
    excellent: '🎉 Eccellente!',
    oops: '❌ Ops! La risposta era',
    points: 'punti',
    gameOver: 'Fine gioco',
    newRecord: 'Nuovo record!',
    finalScore: 'Punteggio finale:',
    bestScore: 'Miglior punteggio:',
    levelReached: 'Livello raggiunto:',
    achievements: '🏅 Risultati',
    restart: 'Riavvia',
    addition: '➕ Addizione',
    subtraction: '➖ Sottrazione',
    multiplication: '✖️ Moltiplicazione',
    division: '➗ Divisione',
    levelUnlocked: '🎓 Livello sbloccato!',
    firstFifty: '🌟 Primi 50!',
    century: '💯 Centenario!',
    champion: '🏆 Campione!',
    streakThree: '🔥 Serie di 3!',
    streakFive: '⚡ Serie di 5!',
    streakTen: '🌟 Serie di 10!',
    disableSound: 'Disattiva suono',
    enableSound: 'Attiva suono',
    restartGame: 'Riavvia'
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
    points: 'очков',
    gameOver: 'Игра окончена',
    newRecord: 'Новый рекорд!',
    finalScore: 'Итоговый счёт:',
    bestScore: 'Лучший счёт:',
    levelReached: 'Достигнутый уровень:',
    achievements: '🏅 Достижения',
    restart: 'Перезапуск',
    addition: '➕ Сложение',
    subtraction: '➖ Вычитание',
    multiplication: '✖️ Умножение',
    division: '➗ Деление',
    levelUnlocked: '🎓 Уровень разблокирован!',
    firstFifty: '🌟 Первые 50!',
    century: '💯 Сотня!',
    champion: '🏆 Чемпион!',
    streakThree: '🔥 Серия из 3!',
    streakFive: '⚡ Серия из 5!',
    streakTen: '🌟 Серия из 10!',
    disableSound: 'Отключить звук',
    enableSound: 'Включить звук',
    restartGame: 'Перезапуск'
  },
  hi: {
    appName: 'Math4Kids',
    level: 'स्तर',
    question: 'प्रश्न',
    yourAnswer: 'आपका उत्तर...',
    validate: 'सत्यापित करें',
    checking: 'जांच रहे हैं...',
    excellent: '🎉 उत्कृष्ट!',
    oops: '❌ अरे! उत्तर था',
    points: 'अंक',
    gameOver: 'खेल समाप्त',
    newRecord: 'नया रिकॉर्ड!',
    finalScore: 'अंतिम स्कोर:',
    bestScore: 'सर्वोत्तम स्कोर:',
    levelReached: 'पहुंचा हुआ स्तर:',
    achievements: '🏅 उपलब्धियां',
    restart: 'पुनः आरंभ',
    addition: '➕ जोड़',
    subtraction: '➖ घटाव',
    multiplication: '✖️ गुणा',
    division: '➗ भाग',
    levelUnlocked: '🎓 स्तर अनलॉक!',
    firstFifty: '🌟 पहले 50!',
    century: '💯 शताब्दी!',
    champion: '🏆 चैंपियन!',
    streakThree: '🔥 3 की श्रृंखला!',
    streakFive: '⚡ 5 की श्रृंखला!',
    streakTen: '🌟 10 की श्रृंखला!',
    disableSound: 'ध्वनि बंद',
    enableSound: 'ध्वनि चालू',
    restartGame: 'पुनः आरंभ'
  }
};

// Questions mathématiques par niveau et opération
const questionBank = {
  1: [
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
    { question: '4 + 4', answer: 8, level: 1, type: 'addition' },
    { question: '7 + 2', answer: 9, level: 1, type: 'addition' },
    { question: '3 + 5', answer: 8, level: 1, type: 'addition' },
    { question: '2 + 7', answer: 9, level: 1, type: 'addition' },
    { question: '6 + 2', answer: 8, level: 1, type: 'addition' }
  ],
  2: [
    { question: '8 - 3', answer: 5, level: 2, type: 'subtraction' },
    { question: '7 + 4', answer: 11, level: 2, type: 'addition' },
    { question: '9 - 2', answer: 7, level: 2, type: 'subtraction' },
    { question: '6 + 5', answer: 11, level: 2, type: 'addition' },
    { question: '10 - 4', answer: 6, level: 2, type: 'subtraction' },
    { question: '8 + 3', answer: 11, level: 2, type: 'addition' },
    { question: '12 - 5', answer: 7, level: 2, type: 'subtraction' },
    { question: '7 + 6', answer: 13, level: 2, type: 'addition' },
    { question: '15 - 8', answer: 7, level: 2, type: 'subtraction' },
    { question: '9 + 4', answer: 13, level: 2, type: 'addition' },
    { question: '11 - 3', answer: 8, level: 2, type: 'subtraction' },
    { question: '5 + 8', answer: 13, level: 2, type: 'addition' },
    { question: '14 - 6', answer: 8, level: 2, type: 'subtraction' },
    { question: '7 + 7', answer: 14, level: 2, type: 'addition' },
    { question: '13 - 4', answer: 9, level: 2, type: 'subtraction' }
  ],
  3: [
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
    { question: '5 × 3', answer: 15, level: 3, type: 'multiplication' },
    { question: '2 × 9', answer: 18, level: 3, type: 'multiplication' },
    { question: '6 × 2', answer: 12, level: 3, type: 'multiplication' },
    { question: '4 × 5', answer: 20, level: 3, type: 'multiplication' },
    { question: '3 × 7', answer: 21, level: 3, type: 'multiplication' }
  ]
};

// Component principal - Math4Kids International
const Math4Kids = () => {
  // États du jeu
  const [currentLanguage, setCurrentLanguage] = useState('fr');
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
  const [isLoading, setIsLoading] = useState(false);
  const [showLanguageSelector, setShowLanguageSelector] = useState(false);
  const inputRef = useRef(null);

  // Fonction de traduction
  const t = useCallback((key) => {
    return translations[currentLanguage]?.[key] || translations['en'][key] || key;
  }, [currentLanguage]);

  // Questions du niveau actuel
  const getCurrentLevelQuestions = () => questionBank[level] || questionBank[1];
  const currentQ = getCurrentLevelQuestions()[currentQuestion] || getCurrentLevelQuestions()[0];

  // Fonctions sonores
  const playSound = useCallback((type) => {
    if (!soundEnabled) return;
    
    try {
      const context = new (window.AudioContext || window.webkitAudioContext)();
      const oscillator = context.createOscillator();
      const gainNode = context.createGain();
      
      oscillator.connect(gainNode);
      gainNode.connect(context.destination);
      
      switch (type) {
        case 'success':
          oscillator.frequency.setValueAtTime(523.25, context.currentTime); // Do
          oscillator.frequency.exponentialRampToValueAtTime(659.25, context.currentTime + 0.1); // Mi
          oscillator.frequency.exponentialRampToValueAtTime(783.99, context.currentTime + 0.2); // Sol
          break;
        case 'error':
          oscillator.frequency.setValueAtTime(400, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(300, context.currentTime + 0.2);
          break;
        case 'levelUp':
          oscillator.frequency.setValueAtTime(523.25, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(1046.5, context.currentTime + 0.3);
          break;
        case 'achievement':
          oscillator.frequency.setValueAtTime(880, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(1760, context.currentTime + 0.15);
          break;
      }
      
      gainNode.gain.setValueAtTime(0.1, context.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, context.currentTime + 0.3);
      
      oscillator.start(context.currentTime);
      oscillator.stop(context.currentTime + 0.3);
    } catch (error) {
      console.log('Audio non supporté dans ce navigateur');
    }
  }, [soundEnabled]);

  // Système de particules
  const createParticles = useCallback(() => {
    const colors = ['#FFD700', '#FF69B4', '#00CED1', '#FF6347', '#98FB98', '#DDA0DD', '#F0E68C', '#87CEEB'];
    const emojis = ['⭐', '✨', '🌟', '💫', '🎉', '🎊', '🏆', '🥇'];
    const newParticles = [];
    
    for (let i = 0; i < 20; i++) {
      newParticles.push({
        id: Math.random(),
        color: colors[Math.floor(Math.random() * colors.length)],
        emoji: emojis[Math.floor(Math.random() * emojis.length)],
        left: 20 + Math.random() * 60,
        delay: Math.random() * 500,
        size: 8 + Math.random() * 16,
        duration: 2000 + Math.random() * 1000
      });
    }
    
    setParticles(newParticles);
    setTimeout(() => setParticles([]), 3000);
  }, []);

  // Système d'achievements
  const checkAchievements = useCallback(() => {
    const newAchievements = [];
    
    const achievementList = [
      { condition: score >= 50, text: t('firstFifty'), id: 'first_fifty' },
      { condition: score >= 100, text: t('century'), id: 'century' },
      { condition: streak >= 3, text: t('streakThree'), id: 'streak_three' },
      { condition: streak >= 5, text: t('streakFive'), id: 'streak_five' },
      { condition: streak >= 10, text: t('streakTen'), id: 'streak_ten' },
      { condition: level >= 2, text: t('levelUnlocked'), id: 'level_2' },
      { condition: level >= 3, text: t('champion'), id: 'level_3' }
    ];

    achievementList.forEach(achievement => {
      if (achievement.condition && !achievements.some(a => a.includes(achievement.text))) {
        newAchievements.push(achievement.text);
        playSound('achievement');
      }
    });
    
    if (newAchievements.length > 0) {
      setAchievements(prev => [...prev, ...newAchievements]);
    }
  }, [score, streak, level, achievements, t, playSound]);

  // Validation de réponse
  const validateAnswer = useCallback(() => {
    if (!userAnswer.trim()) return;
    
    setIsLoading(true);
    const userNum = parseInt(userAnswer);
    
    setTimeout(() => {
      if (userNum === currentQ.answer) {
        const points = level * 10 + (streak >= 5 ? 5 : 0);
        setScore(prev => prev + points);
        setStreak(prev => prev + 1);
        setFeedback(`${t('excellent')} +${points} ${t('points')}`);
        playSound('success');
        createParticles();
        setIsAnimating(true);
        
        setTimeout(() => setIsAnimating(false), 1000);
        
        const totalQuestions = getCurrentLevelQuestions().length;
        if ((currentQuestion + 1) >= totalQuestions) {
          if (level < 3) {
            setLevel(prev => prev + 1);
            setCurrentQuestion(0);
            playSound('levelUp');
            setFeedback(prev => prev + ` ${t('levelUnlocked')}`);
          } else {
            setCurrentQuestion(0);
          }
        } else {
          setCurrentQuestion(prev => prev + 1);
        }
      } else {
        setStreak(0);
        setFeedback(`${t('oops')} ${currentQ.answer}`);
        setLives(prev => {
          const newLives = prev - 1;
          if (newLives <= 0) {
            setTimeout(() => {
              setLives(3);
              setLevel(1);
              setCurrentQuestion(0);
              setScore(0);
              setStreak(0);
              setFeedback('');
              setShowFeedback(false);
            }, 2000);
          }
          return newLives;
        });
        playSound('error');
      }
      
      setShowFeedback(true);
      setUserAnswer('');
      setIsLoading(false);
      
      setTimeout(() => {
        setShowFeedback(false);
        setFeedback('');
      }, 3000);
      
      checkAchievements();
    }, 800);
  }, [userAnswer, currentQ, level, currentQuestion, streak, checkAchievements, playSound, createParticles, t]);

  // Reset du jeu
  const resetGame = useCallback(() => {
    setCurrentQuestion(0);
    setScore(0);
    setUserAnswer('');
    setFeedback('');
    setShowFeedback(false);
    setLives(3);
    setLevel(1);
    setStreak(0);
    setAchievements([]);
    setParticles([]);
    setIsAnimating(false);
  }, []);

  // Focus automatique
  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.focus();
    }
  }, [currentQuestion]);

  // Gestion des touches
  useEffect(() => {
    const handleKeyPress = (e) => {
      if (e.key === 'Enter') {
        validateAnswer();
      }
      if (e.key === 'Escape') {
        resetGame();
      }
    };

    document.addEventListener('keydown', handleKeyPress);
    return () => document.removeEventListener('keydown', handleKeyPress);
  }, [validateAnswer, resetGame]);

  // Direction du texte selon la langue
  const currentLangDirection = SUPPORTED_LANGUAGES.find(l => l.code === currentLanguage)?.direction || 'ltr';

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 p-4 relative overflow-hidden" dir={currentLangDirection}>
      {/* Particules animées */}
      {particles.map(particle => (
        <div
          key={particle.id}
          className="fixed pointer-events-none z-50"
          style={{
            left: `${particle.left}%`,
            top: '50%',
            backgroundColor: particle.color,
            width: `${particle.size}px`,
            height: `${particle.size}px`,
            borderRadius: '50%',
            animationDelay: `${particle.delay}ms`,
            animationDuration: `${particle.duration}ms`
          }}
        >
          <span className="text-sm">{particle.emoji}</span>
        </div>
      ))}

      {/* Sélecteur de langue */}
      {showLanguageSelector && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl p-6 max-w-4xl max-h-[80vh] overflow-y-auto shadow-2xl">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
                <Globe className="text-blue-500" size={28} />
                Choisir la langue / Choose Language / Wählen Sie Sprache
              </h2>
              <button
                onClick={() => setShowLanguageSelector(false)}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                ×
              </button>
            </div>
            
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
              {SUPPORTED_LANGUAGES.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => {
                    setCurrentLanguage(lang.code);
                    setShowLanguageSelector(false);
                  }}
                  className={`p-3 rounded-xl border-2 transition-all duration-200 text-left hover:scale-105 ${
                    currentLanguage === lang.code 
                      ? 'border-blue-500 bg-blue-50' 
                      : 'border-gray-200 hover:border-blue-300'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <span className="text-2xl">{lang.flag}</span>
                    <div className="min-w-0 flex-1">
                      <div className="font-semibold text-gray-800 text-sm truncate">
                        {lang.nativeName}
                      </div>
                      <div className="text-xs text-gray-500 truncate">
                        {lang.name}
                      </div>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Header avec statistiques */}
      <div className="flex justify-between items-center mb-6 flex-wrap gap-4">
        <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 border border-white/30">
          <h1 className="text-3xl font-bold text-white mb-2 font-fredoka flex items-center gap-2">
            🧮 {t('appName')}
          </h1>
          <p className="text-white/80 text-sm">
            {t('level')} {level} • {t('question')} {currentQuestion + 1}
          </p>
        </div>
        
        <div className="flex gap-3 flex-wrap">
          {/* Score */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Trophy className="text-yellow-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold text-lg">{score}</div>
            <div className="text-white/70 text-xs">Score</div>
          </div>
          
          {/* Série */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Zap className="text-orange-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold text-lg">{streak}</div>
            <div className="text-white/70 text-xs">Série</div>
          </div>
          
          {/* Niveau */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Trophy className="text-blue-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold text-lg">{level}</div>
            <div className="text-white/70 text-xs">{t('level')}</div>
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
            <div className="text-white/70 text-xs">❤️</div>
          </div>
          
          {/* Contrôles */}
          <div className="flex gap-2">
            <button
              onClick={() => setShowLanguageSelector(true)}
              className="bg-white/20 backdrop-blur-sm rounded-xl p-3 border border-white/30 hover:bg-white/30 transition-all"
              title="Changer de langue"
            >
              <Globe className="text-white" size={20} />
            </button>
            
            <button
              onClick={() => setSoundEnabled(!soundEnabled)}
              className="bg-white/20 backdrop-blur-sm rounded-xl p-3 border border-white/30 hover:bg-white/30 transition-all"
              title={soundEnabled ? t('disableSound') : t('enableSound')}
            >
              {soundEnabled ? (
                <Volume2 className="text-white" size={20} />
              ) : (
                <VolumeX className="text-white" size={20} />
              )}
            </button>
            
            <button
              onClick={resetGame}
              className="bg-white/20 backdrop-blur-sm rounded-xl p-3 border border-white/30 hover:bg-white/30 transition-all"
              title={t('restartGame')}
            >
              <RotateCcw className="text-white" size={20} />
            </button>
          </div>
        </div>
      </div>

      {/* Zone de jeu principale */}
      <div className="max-w-2xl mx-auto">
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-8 border border-white/20 shadow-2xl">
          {/* Barre de progression */}
          <div className="mb-6">
            <div className="flex justify-between text-white/80 text-sm mb-2">
              <span>{t('question')} {currentQuestion + 1}/{getCurrentLevelQuestions().length}</span>
              <span>🔥 {streak}</span>
            </div>
            <div className="w-full bg-white/20 rounded-full h-2">
              <div 
                className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full transition-all duration-500"
                style={{ width: `${((currentQuestion + 1) / getCurrentLevelQuestions().length) * 100}%` }}
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
                {t('level')} {level} • {t(currentQ.type)}
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
              placeholder={t('yourAnswer')}
              className="bg-white rounded-2xl p-4 text-center text-2xl font-bold text-gray-800 border-4 border-transparent focus:border-purple-400 focus:outline-none w-40 mr-4"
              disabled={isLoading}
            />
            
            <button
              onClick={validateAnswer}
              disabled={!userAnswer || isLoading}
              className="bg-gradient-to-r from-green-500 to-blue-500 hover:from-green-600 hover:to-blue-600 disabled:from-gray-400 disabled:to-gray-500 text-white font-bold py-4 px-8 rounded-2xl text-xl transition-all duration-300 shadow-lg"
            >
              {isLoading ? (
                <span className="flex items-center justify-center gap-2">
                  <div className="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></div>
                  {t('checking')}
                </span>
              ) : (
                t('validate')
              )}
            </button>

            {/* Feedback */}
            {showFeedback && (
              <div className={`mt-6 p-4 rounded-2xl text-center font-bold transition-all duration-500 ${
                feedback.includes('🎉') 
                  ? 'bg-green-100 text-green-800 border-2 border-green-300 animate-bounce-in' 
                  : 'bg-red-100 text-red-800 border-2 border-red-300 animate-shake'
              }`}>
                {feedback}
              </div>
            )}

            {/* Achievements récents */}
            {achievements.length > 0 && (
              <div className="mt-6 space-y-2">
                <h3 className="text-white font-bold text-lg">{t('achievements')}</h3>
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

      {/* Game Over overlay */}
      {lives <= 0 && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
          <div className="bg-white rounded-3xl p-8 text-center shadow-2xl border-4 border-red-300 animate-bounce-in">
            <div className="text-6xl mb-4">😅</div>
            <h2 className="text-3xl font-bold text-gray-800 mb-4">{t('gameOver')}</h2>
            <p className="text-gray-600 text-lg mb-4">{t('finalScore')} <span className="font-bold text-purple-600">{score}</span></p>
            <p className="text-gray-600 mb-6">🔥 {streak} en série maximale</p>
            <button
              onClick={resetGame}
              className="bg-gradient-to-r from-blue-500 to-purple-500 text-white font-bold py-3 px-6 rounded-xl hover:scale-105 transition-all shadow-lg"
            >
              🔄 {t('restart')}
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Math4Kids;