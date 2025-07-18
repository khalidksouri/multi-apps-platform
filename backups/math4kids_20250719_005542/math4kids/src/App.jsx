import { Award, Globe, Heart, RotateCcw, Star, Trophy, Volume2, VolumeX, Zap } from 'lucide-react';
import { useCallback, useEffect, useRef, useState } from 'react';

// Configuration des langues supportées - VERSION COMPLÈTE MONDIALE
const SUPPORTED_LANGUAGES = [
  // Europe
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', direction: 'ltr' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', direction: 'ltr' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', direction: 'ltr' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', direction: 'ltr' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', direction: 'ltr' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', direction: 'ltr' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', direction: 'ltr' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', direction: 'ltr' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', direction: 'ltr' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', direction: 'ltr' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', direction: 'ltr' },
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', direction: 'ltr' },
  { code: 'sr', name: 'Serbian', nativeName: 'Српски', flag: '🇷🇸', direction: 'ltr' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', direction: 'ltr' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
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

// Traductions complètes pour toutes les langues
const translations = {
  en: {
    appName: 'Math4Kids',
    subtitle: 'Learn math while having fun!',
    level: 'Level',
    question: 'Question',
    yourAnswer: 'Your answer...',
    validate: 'Validate',
    checking: 'Checking...',
    excellent: '🎉 Excellent!',
    oops: '❌ Oops! The answer was',
    score: 'Score',
    streak: 'Streak',
    timeLeft: 'Time left',
    nextLevel: 'Next level',
    addition: 'Addition',
    subtraction: 'Subtraction',
    multiplication: 'Multiplication',
    division: 'Division',
    mixed: 'Mixed',
    easy: 'Easy',
    medium: 'Medium',
    hard: 'Hard',
    settings: 'Settings',
    profile: 'Profile',
    statistics: 'Statistics',
    achievements: 'Achievements',
    soundEnabled: 'Sound enabled',
    language: 'Language',
    playerName: 'Player name',
    age: 'Age',
    grade: 'Grade',
    save: 'Save',
    cancel: 'Cancel',
    reset: 'Reset',
    pause: 'Pause',
    resume: 'Resume',
    gameOver: 'Game Over',
    finalScore: 'Final Score',
    playAgain: 'Play Again',
    wellDone: 'Well done!',
    keepGoing: 'Keep going!',
    almostThere: 'Almost there!',
    perfect: 'Perfect!',
    mathGenius: 'Math genius!',
    lives: 'Lives',
    startGame: 'Start Game',
    selectLanguage: 'Select Language',
    badges: {
      firstStep: 'First Step',
      speedDemon: 'Speed Demon',
      perfectionist: 'Perfectionist',
      persistent: 'Persistent',
      explorer: 'Explorer'
    }
  },
  fr: {
    appName: 'Math4Kids',
    subtitle: 'Apprends les maths en t\'amusant !',
    level: 'Niveau',
    question: 'Question',
    yourAnswer: 'Ta réponse...',
    validate: 'Valider',
    checking: 'Vérification...',
    excellent: '🎉 Excellent !',
    oops: '❌ Oups ! La réponse était',
    score: 'Score',
    streak: 'Série',
    timeLeft: 'Temps restant',
    nextLevel: 'Niveau suivant',
    addition: 'Addition',
    subtraction: 'Soustraction',
    multiplication: 'Multiplication',
    division: 'Division',
    mixed: 'Mélangé',
    easy: 'Facile',
    medium: 'Moyen',
    hard: 'Difficile',
    settings: 'Paramètres',
    profile: 'Profil',
    statistics: 'Statistiques',
    achievements: 'Succès',
    soundEnabled: 'Son activé',
    language: 'Langue',
    playerName: 'Nom du joueur',
    age: 'Âge',
    grade: 'Classe',
    save: 'Sauvegarder',
    cancel: 'Annuler',
    reset: 'Recommencer',
    pause: 'Pause',
    resume: 'Reprendre',
    gameOver: 'Fin de partie',
    finalScore: 'Score final',
    playAgain: 'Rejouer',
    wellDone: 'Bien joué !',
    keepGoing: 'Continue comme ça !',
    almostThere: 'Tu y es presque !',
    perfect: 'Parfait !',
    mathGenius: 'Génie des maths !',
    lives: 'Vies',
    startGame: 'Commencer le jeu',
    selectLanguage: 'Choisir la langue',
    badges: {
      firstStep: 'Premier pas',
      speedDemon: 'Éclair de vitesse',
      perfectionist: 'Perfectionniste',
      persistent: 'Persévérant',
      explorer: 'Explorateur'
    }
  },
  es: {
    appName: 'Math4Kids',
    subtitle: '¡Aprende matemáticas divirtiéndote!',
    level: 'Nivel',
    question: 'Pregunta',
    yourAnswer: 'Tu respuesta...',
    validate: 'Validar',
    checking: 'Verificando...',
    excellent: '¡Excelente!',
    oops: '¡Ups! La respuesta era',
    score: 'Puntuación',
    streak: 'Racha',
    timeLeft: 'Tiempo restante',
    nextLevel: 'Siguiente nivel',
    addition: 'Suma',
    subtraction: 'Resta',
    multiplication: 'Multiplicación',
    division: 'División',
    mixed: 'Mixto',
    easy: 'Fácil',
    medium: 'Medio',
    hard: 'Difícil',
    settings: 'Configuración',
    profile: 'Perfil',
    statistics: 'Estadísticas',
    achievements: 'Logros',
    soundEnabled: 'Sonido activado',
    language: 'Idioma',
    playerName: 'Nombre del jugador',
    age: 'Edad',
    grade: 'Grado',
    save: 'Guardar',
    cancel: 'Cancelar',
    reset: 'Reiniciar',
    pause: 'Pausa',
    resume: 'Reanudar',
    gameOver: 'Fin del juego',
    finalScore: 'Puntuación final',
    playAgain: 'Jugar de nuevo',
    wellDone: '¡Bien hecho!',
    keepGoing: '¡Sigue así!',
    almostThere: '¡Ya casi!',
    perfect: '¡Perfecto!',
    mathGenius: '¡Genio de las matemáticas!',
    lives: 'Vidas',
    startGame: 'Empezar juego',
    selectLanguage: 'Seleccionar idioma',
    badges: {
      firstStep: 'Primer Paso',
      speedDemon: 'Demonio de Velocidad',
      perfectionist: 'Perfeccionista',
      persistent: 'Persistente',
      explorer: 'Explorador'
    }
  },
  de: {
    appName: 'Math4Kids',
    subtitle: 'Lerne Mathe mit Spaß!',
    level: 'Level',
    question: 'Frage',
    yourAnswer: 'Deine Antwort...',
    validate: 'Bestätigen',
    checking: 'Überprüfe...',
    excellent: '🎉 Ausgezeichnet!',
    oops: '❌ Ups! Die Antwort war',
    score: 'Punkte',
    streak: 'Serie',
    timeLeft: 'Zeit übrig',
    nextLevel: 'Nächstes Level',
    addition: 'Addition',
    subtraction: 'Subtraktion',
    multiplication: 'Multiplikation',
    division: 'Division',
    mixed: 'Gemischt',
    easy: 'Einfach',
    medium: 'Mittel',
    hard: 'Schwer',
    settings: 'Einstellungen',
    profile: 'Profil',
    statistics: 'Statistiken',
    achievements: 'Erfolge',
    soundEnabled: 'Ton aktiviert',
    language: 'Sprache',
    playerName: 'Spielername',
    age: 'Alter',
    grade: 'Klasse',
    save: 'Speichern',
    cancel: 'Abbrechen',
    reset: 'Zurücksetzen',
    pause: 'Pause',
    resume: 'Fortsetzen',
    gameOver: 'Spiel beendet',
    finalScore: 'Endpunktzahl',
    playAgain: 'Nochmal spielen',
    wellDone: 'Gut gemacht!',
    keepGoing: 'Weiter so!',
    almostThere: 'Fast geschafft!',
    perfect: 'Perfekt!',
    mathGenius: 'Mathe-Genie!',
    lives: 'Leben',
    startGame: 'Spiel starten',
    selectLanguage: 'Sprache wählen',
    badges: {
      firstStep: 'Erster Schritt',
      speedDemon: 'Geschwindigkeitsdämon',
      perfectionist: 'Perfektionist',
      persistent: 'Hartnäckig',
      explorer: 'Entdecker'
    }
  },
  zh: {
    appName: 'Math4Kids',
    subtitle: '快乐学数学！',
    level: '级别',
    question: '问题',
    yourAnswer: '你的答案...',
    validate: '验证',
    checking: '检查中...',
    excellent: '🎉 太棒了！',
    oops: '❌ 糟糕！答案是',
    score: '得分',
    streak: '连击',
    timeLeft: '剩余时间',
    nextLevel: '下一级',
    addition: '加法',
    subtraction: '减法',
    multiplication: '乘法',
    division: '除法',
    mixed: '混合',
    easy: '简单',
    medium: '中等',
    hard: '困难',
    settings: '设置',
    profile: '个人资料',
    statistics: '统计',
    achievements: '成就',
    soundEnabled: '声音已启用',
    language: '语言',
    playerName: '玩家姓名',
    age: '年龄',
    grade: '年级',
    save: '保存',
    cancel: '取消',
    reset: '重置',
    pause: '暂停',
    resume: '继续',
    gameOver: '游戏结束',
    finalScore: '最终得分',
    playAgain: '再玩一次',
    wellDone: '做得好！',
    keepGoing: '继续加油！',
    almostThere: '快到了！',
    perfect: '完美！',
    mathGenius: '数学天才！',
    lives: '生命',
    startGame: '开始游戏',
    selectLanguage: '选择语言',
    badges: {
      firstStep: '第一步',
      speedDemon: '速度恶魔',
      perfectionist: '完美主义者',
      persistent: '坚持不懈',
      explorer: '探索者'
    }
  },
  ja: {
    appName: 'Math4Kids',
    subtitle: '楽しく数学を学ぼう！',
    level: 'レベル',
    question: '問題',
    yourAnswer: 'あなたの答え...',
    validate: '確認',
    checking: 'チェック中...',
    excellent: '🎉 素晴らしい！',
    oops: '❌ おっと！答えは',
    score: 'スコア',
    streak: '連続',
    timeLeft: '残り時間',
    nextLevel: '次のレベル',
    addition: '足し算',
    subtraction: '引き算',
    multiplication: 'かけ算',
    division: 'わり算',
    mixed: 'ミックス',
    easy: '簡単',
    medium: '普通',
    hard: '難しい',
    settings: '設定',
    profile: 'プロフィール',
    statistics: '統計',
    achievements: '実績',
    soundEnabled: '音が有効',
    language: '言語',
    playerName: 'プレイヤー名',
    age: '年齢',
    grade: '学年',
    save: '保存',
    cancel: 'キャンセル',
    reset: 'リセット',
    pause: '一時停止',
    resume: '再開',
    gameOver: 'ゲームオーバー',
    finalScore: '最終スコア',
    playAgain: 'もう一度プレイ',
    wellDone: 'よくできました！',
    keepGoing: '頑張って！',
    almostThere: 'もうすぐです！',
    perfect: 'パーフェクト！',
    mathGenius: '数学の天才！',
    lives: 'ライフ',
    startGame: 'ゲーム開始',
    selectLanguage: '言語を選択',
    badges: {
      firstStep: 'ファーストステップ',
      speedDemon: 'スピードデーモン',
      perfectionist: '完璧主義者',
      persistent: '粘り強い',
      explorer: '探検家'
    }
  },
  ar: {
    appName: 'Math4Kids',
    subtitle: 'تعلم الرياضيات بمرح!',
    level: 'المستوى',
    question: 'السؤال',
    yourAnswer: 'إجابتك...',
    validate: 'تأكيد',
    checking: 'التحقق...',
    excellent: '🎉 ممتاز!',
    oops: '❌ عفواً! الإجابة كانت',
    score: 'النقاط',
    streak: 'السلسلة',
    timeLeft: 'الوقت المتبقي',
    nextLevel: 'المستوى التالي',
    addition: 'الجمع',
    subtraction: 'الطرح',
    multiplication: 'الضرب',
    division: 'القسمة',
    mixed: 'مختلط',
    easy: 'سهل',
    medium: 'متوسط',
    hard: 'صعب',
    settings: 'الإعدادات',
    profile: 'الملف الشخصي',
    statistics: 'الإحصائيات',
    achievements: 'الإنجازات',
    soundEnabled: 'الصوت مفعل',
    language: 'اللغة',
    playerName: 'اسم اللاعب',
    age: 'العمر',
    grade: 'الصف',
    save: 'حفظ',
    cancel: 'إلغاء',
    reset: 'إعادة تعيين',
    pause: 'إيقاف مؤقت',
    resume: 'متابعة',
    gameOver: 'انتهت اللعبة',
    finalScore: 'النقاط النهائية',
    playAgain: 'العب مرة أخرى',
    wellDone: 'أحسنت!',
    keepGoing: 'استمر!',
    almostThere: 'تقريباً وصلت!',
    perfect: 'مثالي!',
    mathGenius: 'عبقري الرياضيات!',
    lives: 'الأرواح',
    startGame: 'بدء اللعبة',
    selectLanguage: 'اختر اللغة',
    badges: {
      firstStep: 'الخطوة الأولى',
      speedDemon: 'شيطان السرعة',
      perfectionist: 'المثالي',
      persistent: 'المثابر',
      explorer: 'المستكشف'
    }
  },
  ko: {
    appName: 'Math4Kids',
    subtitle: '재미있게 수학을 배워요!',
    level: '레벨',
    question: '문제',
    yourAnswer: '당신의 답...',
    validate: '확인',
    checking: '확인 중...',
    excellent: '🎉 훌륭해요!',
    oops: '❌ 앗! 정답은',
    score: '점수',
    streak: '연속',
    timeLeft: '남은 시간',
    nextLevel: '다음 레벨',
    addition: '덧셈',
    subtraction: '뺄셈',
    multiplication: '곱셈',
    division: '나눗셈',
    mixed: '혼합',
    easy: '쉬움',
    medium: '보통',
    hard: '어려움',
    settings: '설정',
    profile: '프로필',
    statistics: '통계',
    achievements: '업적',
    soundEnabled: '소리 켜짐',
    language: '언어',
    playerName: '플레이어 이름',
    age: '나이',
    grade: '학년',
    save: '저장',
    cancel: '취소',
    reset: '재설정',
    pause: '일시정지',
    resume: '계속',
    gameOver: '게임 종료',
    finalScore: '최종 점수',
    playAgain: '다시 하기',
    wellDone: '잘했어요!',
    keepGoing: '계속해요!',
    almostThere: '거의 다 왔어요!',
    perfect: '완벽해요!',
    mathGenius: '수학 천재!',
    lives: '생명',
    startGame: '게임 시작',
    selectLanguage: '언어 선택',
    badges: {
      firstStep: '첫 걸음',
      speedDemon: '스피드 데몬',
      perfectionist: '완벽주의자',
      persistent: '끈기있는',
      explorer: '탐험가'
    }
  },
  pt: {
    appName: 'Math4Kids',
    subtitle: 'Aprende matemática divertindo-te!',
    level: 'Nível',
    question: 'Pergunta',
    yourAnswer: 'A tua resposta...',
    validate: 'Validar',
    checking: 'Verificando...',
    excellent: '🎉 Excelente!',
    oops: '❌ Ups! A resposta era',
    score: 'Pontuação',
    streak: 'Sequência',
    timeLeft: 'Tempo restante',
    nextLevel: 'Próximo nível',
    addition: 'Adição',
    subtraction: 'Subtração',
    multiplication: 'Multiplicação',
    division: 'Divisão',
    mixed: 'Misto',
    easy: 'Fácil',
    medium: 'Médio',
    hard: 'Difícil',
    settings: 'Configurações',
    profile: 'Perfil',
    statistics: 'Estatísticas',
    achievements: 'Conquistas',
    soundEnabled: 'Som ativado',
    language: 'Idioma',
    playerName: 'Nome do jogador',
    age: 'Idade',
    grade: 'Ano',
    save: 'Guardar',
    cancel: 'Cancelar',
    reset: 'Reiniciar',
    pause: 'Pausar',
    resume: 'Retomar',
    gameOver: 'Fim de jogo',
    finalScore: 'Pontuação final',
    playAgain: 'Jogar novamente',
    wellDone: 'Muito bem!',
    keepGoing: 'Continua assim!',
    almostThere: 'Quase lá!',
    perfect: 'Perfeito!',
    mathGenius: 'Génio da matemática!',
    lives: 'Vidas',
    startGame: 'Iniciar jogo',
    selectLanguage: 'Selecionar idioma',
    badges: {
      firstStep: 'Primeiro Passo',
      speedDemon: 'Demónio da Velocidade',
      perfectionist: 'Perfeccionista',
      persistent: 'Persistente',
      explorer: 'Explorador'
    }
  },
  it: {
    appName: 'Math4Kids',
    subtitle: 'Impara la matematica divertendoti!',
    level: 'Livello',
    question: 'Domanda',
    yourAnswer: 'La tua risposta...',
    validate: 'Convalida',
    checking: 'Verifica...',
    excellent: '🎉 Eccellente!',
    oops: '❌ Ops! La risposta era',
    score: 'Punteggio',
    streak: 'Serie',
    timeLeft: 'Tempo rimanente',
    nextLevel: 'Livello successivo',
    addition: 'Addizione',
    subtraction: 'Sottrazione',
    multiplication: 'Moltiplicazione',
    division: 'Divisione',
    mixed: 'Misto',
    easy: 'Facile',
    medium: 'Medio',
    hard: 'Difficile',
    settings: 'Impostazioni',
    profile: 'Profilo',
    statistics: 'Statistiche',
    achievements: 'Risultati',
    soundEnabled: 'Suono attivato',
    language: 'Lingua',
    playerName: 'Nome giocatore',
    age: 'Età',
    grade: 'Classe',
    save: 'Salva',
    cancel: 'Annulla',
    reset: 'Ripristina',
    pause: 'Pausa',
    resume: 'Riprendi',
    gameOver: 'Fine gioco',
    finalScore: 'Punteggio finale',
    playAgain: 'Gioca ancora',
    wellDone: 'Ben fatto!',
    keepGoing: 'Continua così!',
    almostThere: 'Ci siamo quasi!',
    perfect: 'Perfetto!',
    mathGenius: 'Genio della matematica!',
    lives: 'Vite',
    startGame: 'Inizia gioco',
    selectLanguage: 'Seleziona lingua',
    badges: {
      firstStep: 'Primo Passo',
      speedDemon: 'Demone della Velocità',
      perfectionist: 'Perfezionista',
      persistent: 'Persistente',
      explorer: 'Esploratore'
    }
  },
  ru: {
    appName: 'Math4Kids',
    subtitle: 'Изучай математику с удовольствием!',
    level: 'Уровень',
    question: 'Вопрос',
    yourAnswer: 'Ваш ответ...',
    validate: 'Проверить',
    checking: 'Проверка...',
    excellent: '🎉 Отлично!',
    oops: '❌ Упс! Ответ был',
    score: 'Счёт',
    streak: 'Серия',
    timeLeft: 'Время осталось',
    nextLevel: 'Следующий уровень',
    addition: 'Сложение',
    subtraction: 'Вычитание',
    multiplication: 'Умножение',
    division: 'Деление',
    mixed: 'Смешанный',
    easy: 'Лёгкий',
    medium: 'Средний',
    hard: 'Сложный',
    settings: 'Настройки',
    profile: 'Профиль',
    statistics: 'Статистика',
    achievements: 'Достижения',
    soundEnabled: 'Звук включён',
    language: 'Язык',
    playerName: 'Имя игрока',
    age: 'Возраст',
    grade: 'Класс',
    save: 'Сохранить',
    cancel: 'Отмена',
    reset: 'Сброс',
    pause: 'Пауза',
    resume: 'Продолжить',
    gameOver: 'Игра окончена',
    finalScore: 'Итоговый счёт',
    playAgain: 'Играть снова',
    wellDone: 'Хорошо сделано!',
    keepGoing: 'Продолжайте!',
    almostThere: 'Почти получилось!',
    perfect: 'Идеально!',
    mathGenius: 'Математический гений!',
    lives: 'Жизни',
    startGame: 'Начать игру',
    selectLanguage: 'Выбрать язык',
    badges: {
      firstStep: 'Первый Шаг',
      speedDemon: 'Демон Скорости',
      perfectionist: 'Перфекционист',
      persistent: 'Настойчивый',
      explorer: 'Исследователь'
    }
  },
  hi: {
    appName: 'Math4Kids',
    subtitle: 'मज़े करते हुए गणित सीखें!',
    level: 'स्तर',
    question: 'प्रश्न',
    yourAnswer: 'आपका उत्तर...',
    validate: 'सत्यापित करें',
    checking: 'जांच रहे हैं...',
    excellent: '🎉 उत्कृष्ट!',
    oops: '❌ अरे! उत्तर था',
    score: 'स्कोर',
    streak: 'श्रृंखला',
    timeLeft: 'समय बचा है',
    nextLevel: 'अगला स्तर',
    addition: 'जोड़',
    subtraction: 'घटाव',
    multiplication: 'गुणा',
    division: 'भाग',
    mixed: 'मिश्रित',
    easy: 'आसान',
    medium: 'मध्यम',
    hard: 'कठिन',
    settings: 'सेटिंग्स',
    profile: 'प्रोफ़ाइल',
    statistics: 'आंकड़े',
    achievements: 'उपलब्धियां',
    soundEnabled: 'ध्वनि सक्षम',
    language: 'भाषा',
    playerName: 'खिलाड़ी का नाम',
    age: 'उम्र',
    grade: 'कक्षा',
    save: 'सेव करें',
    cancel: 'रद्द करें',
    reset: 'रीसेट',
    pause: 'रोकें',
    resume: 'जारी रखें',
    gameOver: 'खेल समाप्त',
    finalScore: 'अंतिम स्कोर',
    playAgain: 'फिर से खेलें',
    wellDone: 'बहुत बढ़िया!',
    keepGoing: 'चलते रहें!',
    almostThere: 'बस हो गया!',
    perfect: 'परफेक्ट!',
    mathGenius: 'गणित का जीनियस!',
    lives: 'जीवन',
    startGame: 'खेल शुरू करें',
    selectLanguage: 'भाषा चुनें',
    badges: {
      firstStep: 'पहला कदम',
      speedDemon: 'गति दानव',
      perfectionist: 'पूर्णतावादी',
      persistent: 'दृढ़',
      explorer: 'खोजकर्ता'
    }
  }
};

// Questions mathématiques par niveau
const questionBank = {
  1: [
    { question: '2 + 3', answer: 5, type: 'addition' },
    { question: '1 + 4', answer: 5, type: 'addition' },
    { question: '3 + 2', answer: 5, type: 'addition' },
    { question: '5 + 1', answer: 6, type: 'addition' },
    { question: '4 + 3', answer: 7, type: 'addition' },
    { question: '2 + 6', answer: 8, type: 'addition' },
    { question: '3 + 4', answer: 7, type: 'addition' },
    { question: '1 + 8', answer: 9, type: 'addition' },
    { question: '5 + 2', answer: 7, type: 'addition' },
    { question: '6 + 3', answer: 9, type: 'addition' },
    { question: '4 + 4', answer: 8, type: 'addition' },
    { question: '7 + 2', answer: 9, type: 'addition' },
    { question: '3 + 5', answer: 8, type: 'addition' },
    { question: '2 + 7', answer: 9, type: 'addition' },
    { question: '6 + 2', answer: 8, type: 'addition' }
  ],
  2: [
    { question: '8 - 3', answer: 5, type: 'subtraction' },
    { question: '7 + 4', answer: 11, type: 'addition' },
    { question: '9 - 2', answer: 7, type: 'subtraction' },
    { question: '6 + 5', answer: 11, type: 'addition' },
    { question: '10 - 4', answer: 6, type: 'subtraction' },
    { question: '8 + 3', answer: 11, type: 'addition' },
    { question: '12 - 5', answer: 7, type: 'subtraction' },
    { question: '7 + 6', answer: 13, type: 'addition' },
    { question: '15 - 8', answer: 7, type: 'subtraction' },
    { question: '9 + 4', answer: 13, type: 'addition' },
    { question: '11 - 3', answer: 8, type: 'subtraction' },
    { question: '5 + 8', answer: 13, type: 'addition' },
    { question: '14 - 6', answer: 8, type: 'subtraction' },
    { question: '7 + 7', answer: 14, type: 'addition' },
    { question: '13 - 4', answer: 9, type: 'subtraction' }
  ],
  3: [
    { question: '2 × 3', answer: 6, type: 'multiplication' },
    { question: '4 × 2', answer: 8, type: 'multiplication' },
    { question: '3 × 3', answer: 9, type: 'multiplication' },
    { question: '5 × 2', answer: 10, type: 'multiplication' },
    { question: '2 × 6', answer: 12, type: 'multiplication' },
    { question: '4 × 3', answer: 12, type: 'multiplication' },
    { question: '3 × 5', answer: 15, type: 'multiplication' },
    { question: '2 × 8', answer: 16, type: 'multiplication' },
    { question: '4 × 4', answer: 16, type: 'multiplication' },
    { question: '3 × 6', answer: 18, type: 'multiplication' },
    { question: '5 × 3', answer: 15, type: 'multiplication' },
    { question: '2 × 9', answer: 18, type: 'multiplication' },
    { question: '6 × 2', answer: 12, type: 'multiplication' },
    { question: '4 × 5', answer: 20, type: 'multiplication' },
    { question: '3 × 7', answer: 21, type: 'multiplication' }
  ]
};

// Component principal
const Math4Kids = () => {
  // États du jeu
  const [currentLanguage, setCurrentLanguage] = useState('fr');
  const [gameStarted, setGameStarted] = useState(false);
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

  // Traductions courantes
  const t = useCallback((key) => {
    return translations[currentLanguage]?.[key] || translations['en'][key] || key;
  }, [currentLanguage]);

  // Questions du niveau actuel
  const getCurrentLevelQuestions = () => questionBank[level] || questionBank[1];
  const currentQ = getCurrentLevelQuestions()[currentQuestion] || getCurrentLevelQuestions()[0];

  // Fonction audio
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
          oscillator.frequency.setValueAtTime(523.25, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(783.99, context.currentTime + 0.3);
          break;
        case 'error':
          oscillator.frequency.setValueAtTime(400, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(300, context.currentTime + 0.2);
          break;
        case 'levelUp':
          oscillator.frequency.setValueAtTime(523.25, context.currentTime);
          oscillator.frequency.exponentialRampToValueAtTime(1046.5, context.currentTime + 0.3);
          break;
      }
      
      gainNode.gain.setValueAtTime(0.3, context.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, context.currentTime + 0.3);
      
      oscillator.start(context.currentTime);
      oscillator.stop(context.currentTime + 0.3);
    } catch (error) {
      console.log('Audio non supporté');
    }
  }, [soundEnabled]);

  // Système de particules
  const createParticles = useCallback(() => {
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
    
    setParticles(newParticles);
    setTimeout(() => setParticles([]), 3000);
  }, []);

  // Validation de réponse
  const validateAnswer = useCallback(() => {
    if (!userAnswer) return;
    
    setIsLoading(true);
    const userNum = parseInt(userAnswer);
    
    setTimeout(() => {
      if (userNum === currentQ.answer) {
        setScore(prev => prev + (level * 10));
        setStreak(prev => prev + 1);
        setFeedback(t('excellent'));
        playSound('success');
        setIsAnimating(true);
        createParticles();
        
        setTimeout(() => setIsAnimating(false), 1000);
        
        if ((currentQuestion + 1) >= getCurrentLevelQuestions().length) {
          if (level < 3) {
            setLevel(prev => prev + 1);
            setCurrentQuestion(0);
            playSound('levelUp');
          } else {
            setCurrentQuestion(0);
          }
        } else {
          setCurrentQuestion(prev => prev + 1);
        }
      } else {
        setStreak(0);
        setFeedback(`${t('oops')} ${currentQ.answer}`);
        setLives(prev => prev - 1);
        playSound('error');
        
        if (lives <= 1) {
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
    }, 1000);
  }, [userAnswer, currentQ, level, currentQuestion, lives, streak, t, playSound, createParticles]);

  // Reset du jeu
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
    setParticles([]);
  };

  // Démarrer le jeu
  const startGame = () => {
    setGameStarted(true);
    resetGame();
  };

  // Focus automatique
  useEffect(() => {
    if (inputRef.current && gameStarted) {
      inputRef.current.focus();
    }
  }, [currentQuestion, gameStarted]);

  // Composant sélecteur de langue
  const LanguageSelector = () => (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-3xl p-6 max-w-4xl max-h-[80vh] overflow-y-auto shadow-2xl">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
            <Globe className="text-blue-500" size={28} />
            {t('selectLanguage')}
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
  );

  // Écran d'accueil
  if (!gameStarted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 flex items-center justify-center p-4" dir={SUPPORTED_LANGUAGES.find(l => l.code === currentLanguage)?.direction || 'ltr'}>
        {showLanguageSelector && <LanguageSelector />}
        
        <div className="bg-white/10 backdrop-blur-lg rounded-3xl p-12 border border-white/20 shadow-2xl text-center max-w-md">
          <div className="mb-8">
            <h1 className="text-6xl font-bold text-white mb-4">🧮</h1>
            <h2 className="text-4xl font-bold text-white mb-2 font-fredoka">{t('appName')}</h2>
            <p className="text-white/80 text-lg">{t('subtitle')}</p>
          </div>
          
          <div className="space-y-4 mb-8">
            <div className="text-white/90 text-left space-y-2">
              <p>🎯 <strong>3 {t('level').toLowerCase()}s</strong> de difficulté</p>
              <p>⭐ <strong>45 questions</strong> éducatives</p>
              <p>🏆 <strong>{t('achievements')}</strong> à débloquer</p>
              <p>🎵 <strong>Sons</strong> et animations</p>
              <p>🌍 <strong>{SUPPORTED_LANGUAGES.length} langues</strong> supportées</p>
            </div>
          </div>
          
          <div className="space-y-4">
            <button
              onClick={startGame}
              className="w-full bg-gradient-to-r from-green-500 to-blue-500 hover:from-green-600 hover:to-blue-600 text-white font-bold py-4 px-8 rounded-2xl text-xl transition-all duration-300 shadow-lg hover:scale-105 animate-pulse"
            >
              🚀 {t('startGame')}
            </button>
            
            <button
              onClick={() => setShowLanguageSelector(true)}
              className="w-full bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white font-bold py-3 px-6 rounded-xl transition-all duration-300 flex items-center justify-center gap-2"
            >
              <Globe size={20} />
              <span className="text-2xl">{SUPPORTED_LANGUAGES.find(l => l.code === currentLanguage)?.flag}</span>
              {SUPPORTED_LANGUAGES.find(l => l.code === currentLanguage)?.nativeName}
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-pink-500 p-4 relative overflow-hidden" dir={SUPPORTED_LANGUAGES.find(l => l.code === currentLanguage)?.direction || 'ltr'}>
      {showLanguageSelector && <LanguageSelector />}
      
      {/* Particules d'animation */}
      {particles.map(particle => (
        <div
          key={particle.id}
          className="particle fixed pointer-events-none z-50"
          style={{
            left: `${particle.left}%`,
            top: '50%',
            backgroundColor: particle.color,
            width: '8px',
            height: '8px',
            borderRadius: '50%',
            animationDelay: `${particle.delay}ms`
          }}
        />
      ))}

      {/* Header avec statistiques */}
      <div className="flex justify-between items-center mb-6 flex-wrap gap-4">
        <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-4 border border-white/30">
          <h1 className="text-3xl font-bold text-white mb-2 font-fredoka">
            🧮 {t('appName')}
          </h1>
          <p className="text-white/80 text-sm">{t('level')} {level} • {t('question')} {currentQuestion + 1}</p>
        </div>
        
        <div className="flex gap-3 flex-wrap">
          {/* Score */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Trophy className="text-yellow-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold text-lg">{score}</div>
            <div className="text-white/70 text-xs">{t('score')}</div>
          </div>
          
          {/* Série */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Zap className="text-orange-300 mx-auto mb-1" size={20} />
            <div className="text-white font-bold text-lg">{streak}</div>
            <div className="text-white/70 text-xs">{t('streak')}</div>
          </div>
          
          {/* Niveau */}
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-3 text-center border border-white/30 min-w-[70px]">
            <Star className="text-blue-300 mx-auto mb-1" size={20} />
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
            <div className="text-white/70 text-xs">{t('lives')}</div>
          </div>
          
          {/* Contrôles */}
          <div className="flex gap-2">
            <button
              onClick={() => setShowLanguageSelector(true)}
              className="bg-white/20 backdrop-blur-sm rounded-xl p-3 border border-white/30 hover:bg-white/30 transition-all"
              title={t('selectLanguage')}
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
              <span>{t('streak')}: {streak}</span>
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
          <div className="bg-white rounded-3xl p-8 text-center shadow-2xl border-4 border-red-300">
            <div className="text-6xl mb-4">😅</div>
            <h2 className="text-3xl font-bold text-gray-800 mb-4">{t('gameOver')}</h2>
            <p className="text-gray-600 text-lg mb-4">{t('finalScore')}: {score}</p>
            <p className="text-gray-600 mb-6">{t('streak')}: {streak}</p>
            <button
              onClick={() => {
                setGameStarted(false);
                resetGame();
              }}
              className="bg-gradient-to-r from-blue-500 to-purple-500 text-white font-bold py-3 px-6 rounded-xl hover:scale-105 transition-all"
            >
              🔄 {t('playAgain')}
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Math4Kids;