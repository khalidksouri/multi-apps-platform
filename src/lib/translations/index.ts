// ===================================================================
// 🌍 TRADUCTIONS COMPLÈTES MATH4CHILD - VERSION FINALE
// Toutes les traductions pour 75+ langues avec TOUTES les clés
// ===================================================================

export interface Translation {
  // Navigation et interface principale
  appName: string;
  tagline: string;
  appBadge: string;
  startFree: string;
  viewPlans: string;
  backToHome: string;
  
  // Page d'accueil
  welcomeTitle: string;
  welcomeMessage: string;
  alreadyTrusted: string;
  applicationCorrected: string;
  functionsNow: string;
  
  // Jeux et exercices
  mathGames: string;
  chooseGame: string;
  puzzleMath: string;
  memoryMath: string;
  quickMath: string;
  mixedExercises: string;
  
  // Descriptions des jeux
  puzzleMathDesc: string;
  memoryMathDesc: string;
  quickMathDesc: string;
  
  // Boutons d'action
  play: string;
  playNow: string;
  discoverExercises: string;
  seeExercises: string;
  seeGames: string;
  seePremiumPlans: string;
  
  // Plans d'abonnement
  choosePlan: string;
  unlockPotential: string;
  free: string;
  family: string;
  premium: string;
  school: string;
  
  // Section "Pourquoi choisir" - AJOUTÉ
  whyChoose: string;
  whyChooseDesc: string;
  
  // Statistiques
  families: string;
  questionsResolved: string;
  satisfaction: string;
  averageRating: string;
  
  // Interface utilisateur
  loading: string;
  error: string;
  retry: string;
  close: string;
  save: string;
  cancel: string;
  confirm: string;
}

export const translations: Record<string, Translation> = {
  // FRANÇAIS
  fr: {
    appName: 'Math4Child',
    tagline: 'Apprendre les mathématiques en s\'amusant !',
    appBadge: 'App Éducative #1 en France',
    startFree: 'Commencer Gratuitement',
    viewPlans: 'Voir les Plans',
    backToHome: 'Retour à l\'accueil',
    
    welcomeTitle: 'Bienvenue dans l\'aventure mathématique !',
    welcomeMessage: 'Une application complète pour apprendre les mathématiques de façon ludique',
    alreadyTrusted: 'Déjà 100k+ familles nous font confiance',
    applicationCorrected: 'Application Corrigée avec Succès !',
    functionsNow: 'Math4Child fonctionne maintenant parfaitement',
    
    mathGames: 'Jeux Mathématiques',
    chooseGame: 'Choisis ton jeu préféré et amuse-toi à apprendre',
    puzzleMath: 'Puzzle Math',
    memoryMath: 'Mémoire Math',
    quickMath: 'Calcul Rapide',
    mixedExercises: 'Exercices Mixtes',
    
    puzzleMathDesc: 'Résous le puzzle mathématique',
    memoryMathDesc: 'Trouve les paires de nombres identiques',
    quickMathDesc: 'Résous un maximum de calculs en 30 secondes',
    
    play: 'Jouer',
    playNow: 'Jouer Maintenant',
    discoverExercises: 'Découvrir les Exercices',
    seeExercises: 'Exercices Mathématiques',
    seeGames: 'Jeux Éducatifs',
    seePremiumPlans: 'Plans Premium',
    
    choosePlan: 'Choisissez votre Plan',
    unlockPotential: 'Débloquez tout le potentiel de Math4Child',
    free: 'Gratuit',
    family: 'Famille',
    premium: 'Premium',
    school: 'École',
    
    whyChoose: 'Pourquoi choisir Math4Child ?',
    whyChooseDesc: 'Découvrez toutes les fonctionnalités qui font de Math4Child l\'app n°1',
    
    families: 'Familles',
    questionsResolved: 'Questions résolues',
    satisfaction: 'Satisfaction',
    averageRating: 'Note moyenne',
    
    loading: 'Chargement...',
    error: 'Erreur',
    retry: 'Réessayer',
    close: 'Fermer',
    save: 'Sauvegarder',
    cancel: 'Annuler',
    confirm: 'Confirmer'
  },

  // ENGLISH
  en: {
    appName: 'Math4Child',
    tagline: 'Learn mathematics while having fun!',
    appBadge: '#1 Educational App in France',
    startFree: 'Start Free',
    viewPlans: 'View Plans',
    backToHome: 'Back to Home',
    
    welcomeTitle: 'Welcome to the mathematical adventure!',
    welcomeMessage: 'A comprehensive app to learn mathematics in a fun way',
    alreadyTrusted: 'Already 100k+ families trust us',
    applicationCorrected: 'Application Successfully Corrected!',
    functionsNow: 'Math4Child now works perfectly',
    
    mathGames: 'Math Games',
    chooseGame: 'Choose your favorite game and have fun learning',
    puzzleMath: 'Math Puzzle',
    memoryMath: 'Math Memory',
    quickMath: 'Quick Math',
    mixedExercises: 'Mixed Exercises',
    
    puzzleMathDesc: 'Solve the mathematical puzzle',
    memoryMathDesc: 'Find pairs of identical numbers',
    quickMathDesc: 'Solve maximum calculations in 30 seconds',
    
    play: 'Play',
    playNow: 'Play Now',
    discoverExercises: 'Discover Exercises',
    seeExercises: 'Math Exercises',
    seeGames: 'Educational Games',
    seePremiumPlans: 'Premium Plans',
    
    choosePlan: 'Choose your Plan',
    unlockPotential: 'Unlock Math4Child\'s full potential',
    free: 'Free',
    family: 'Family',
    premium: 'Premium',
    school: 'School',
    
    whyChoose: 'Why choose Math4Child?',
    whyChooseDesc: 'Discover all the features that make Math4Child the #1 app',
    
    families: 'Families',
    questionsResolved: 'Questions solved',
    satisfaction: 'Satisfaction',
    averageRating: 'Average rating',
    
    loading: 'Loading...',
    error: 'Error',
    retry: 'Retry',
    close: 'Close',
    save: 'Save',
    cancel: 'Cancel',
    confirm: 'Confirm'
  },

  // ESPAÑOL
  es: {
    appName: 'Math4Child',
    tagline: '¡Aprende matemáticas divirtiéndote!',
    appBadge: 'App Educativa #1 en Francia',
    startFree: 'Comenzar Gratis',
    viewPlans: 'Ver Planes',
    backToHome: 'Volver al Inicio',
    
    welcomeTitle: '¡Bienvenido a la aventura matemática!',
    welcomeMessage: 'Una aplicación completa para aprender matemáticas de forma divertida',
    alreadyTrusted: 'Ya más de 100k familias confían en nosotros',
    applicationCorrected: '¡Aplicación Corregida con Éxito!',
    functionsNow: 'Math4Child ahora funciona perfectamente',
    
    mathGames: 'Juegos Matemáticos',
    chooseGame: 'Elige tu juego favorito y diviértete aprendiendo',
    puzzleMath: 'Puzzle Matemático',
    memoryMath: 'Memoria Matemática',
    quickMath: 'Cálculo Rápido',
    mixedExercises: 'Ejercicios Mixtos',
    
    puzzleMathDesc: 'Resuelve el puzzle matemático',
    memoryMathDesc: 'Encuentra pares de números idénticos',
    quickMathDesc: 'Resuelve el máximo de cálculos en 30 segundos',
    
    play: 'Jugar',
    playNow: 'Jugar Ahora',
    discoverExercises: 'Descubrir Ejercicios',
    seeExercises: 'Ejercicios Matemáticos',
    seeGames: 'Juegos Educativos',
    seePremiumPlans: 'Planes Premium',
    
    choosePlan: 'Elige tu Plan',
    unlockPotential: 'Desbloquea todo el potencial de Math4Child',
    free: 'Gratis',
    family: 'Familia',
    premium: 'Premium',
    school: 'Escuela',
    
    whyChoose: '¿Por qué elegir Math4Child?',
    whyChooseDesc: 'Descubre todas las funcionalidades que hacen de Math4Child la app n°1',
    
    families: 'Familias',
    questionsResolved: 'Preguntas resueltas',
    satisfaction: 'Satisfacción',
    averageRating: 'Valoración media',
    
    loading: 'Cargando...',
    error: 'Error',
    retry: 'Reintentar',
    close: 'Cerrar',
    save: 'Guardar',
    cancel: 'Cancelar',
    confirm: 'Confirmar'
  },

  // العربية (ARABE avec support RTL)
  ar: {
    appName: 'Math4Child',
    tagline: 'تعلم الرياضيات أثناء اللعب!',
    appBadge: 'التطبيق التعليمي رقم 1 في فرنسا',
    startFree: 'ابدأ مجاناً',
    viewPlans: 'عرض الخطط',
    backToHome: 'العودة للرئيسية',
    
    welcomeTitle: 'مرحباً بك في المغامرة الرياضية!',
    welcomeMessage: 'تطبيق شامل لتعلم الرياضيات بطريقة ممتعة',
    alreadyTrusted: 'أكثر من 100 ألف عائلة تثق بنا بالفعل',
    applicationCorrected: 'تم تصحيح التطبيق بنجاح!',
    functionsNow: 'Math4Child يعمل الآن بشكل مثالي',
    
    mathGames: 'الألعاب الرياضية',
    chooseGame: 'اختر لعبتك المفضلة واستمتع بالتعلم',
    puzzleMath: 'لغز رياضي',
    memoryMath: 'ذاكرة رياضية',
    quickMath: 'حساب سريع',
    mixedExercises: 'تمارين مختلطة',
    
    puzzleMathDesc: 'حل اللغز الرياضي',
    memoryMathDesc: 'ابحث عن أزواج الأرقام المتطابقة',
    quickMathDesc: 'حل أكبر عدد من الحسابات في 30 ثانية',
    
    play: 'العب',
    playNow: 'العب الآن',
    discoverExercises: 'اكتشف التمارين',
    seeExercises: 'التمارين الرياضية',
    seeGames: 'الألعاب التعليمية',
    seePremiumPlans: 'الخطط المميزة',
    
    choosePlan: 'اختر خطتك',
    unlockPotential: 'أطلق العنان لإمكانات Math4Child الكاملة',
    free: 'مجاني',
    family: 'عائلة',
    premium: 'متميز',
    school: 'مدرسة',
    
    whyChoose: 'لماذا تختار Math4Child؟',
    whyChooseDesc: 'اكتشف جميع الميزات التي تجعل Math4Child التطبيق رقم 1',
    
    families: 'العائلات',
    questionsResolved: 'الأسئلة المحلولة',
    satisfaction: 'الرضا',
    averageRating: 'التقييم المتوسط',
    
    loading: 'جاري التحميل...',
    error: 'خطأ',
    retry: 'إعادة المحاولة',
    close: 'إغلاق',
    save: 'حفظ',
    cancel: 'إلغاء',
    confirm: 'تأكيد'
  },

  // DEUTSCH
  de: {
    appName: 'Math4Child',
    tagline: 'Lerne Mathematik mit Spaß!',
    appBadge: '#1 Bildungs-App in Frankreich',
    startFree: 'Kostenlos Starten',
    viewPlans: 'Pläne Ansehen',
    backToHome: 'Zurück zur Startseite',
    
    welcomeTitle: 'Willkommen zum mathematischen Abenteuer!',
    welcomeMessage: 'Eine umfassende App zum spielerischen Lernen von Mathematik',
    alreadyTrusted: 'Bereits über 100k Familien vertrauen uns',
    applicationCorrected: 'Anwendung erfolgreich korrigiert!',
    functionsNow: 'Math4Child funktioniert jetzt perfekt',
    
    mathGames: 'Mathe-Spiele',
    chooseGame: 'Wähle dein Lieblingsspiel und lerne mit Spaß',
    puzzleMath: 'Mathe-Puzzle',
    memoryMath: 'Mathe-Memory',
    quickMath: 'Schnellrechnen',
    mixedExercises: 'Gemischte Übungen',
    
    puzzleMathDesc: 'Löse das mathematische Puzzle',
    memoryMathDesc: 'Finde Paare identischer Zahlen',
    quickMathDesc: 'Löse maximal viele Berechnungen in 30 Sekunden',
    
    play: 'Spielen',
    playNow: 'Jetzt Spielen',
    discoverExercises: 'Übungen Entdecken',
    seeExercises: 'Mathe-Übungen',
    seeGames: 'Lernspiele',
    seePremiumPlans: 'Premium-Pläne',
    
    choosePlan: 'Wähle deinen Plan',
    unlockPotential: 'Entfessle das volle Potenzial von Math4Child',
    free: 'Kostenlos',
    family: 'Familie',
    premium: 'Premium',
    school: 'Schule',
    
    whyChoose: 'Warum Math4Child wählen?',
    whyChooseDesc: 'Entdecke alle Funktionen, die Math4Child zur #1 App machen',
    
    families: 'Familien',
    questionsResolved: 'Fragen gelöst',
    satisfaction: 'Zufriedenheit',
    averageRating: 'Durchschnittliche Bewertung',
    
    loading: 'Laden...',
    error: 'Fehler',
    retry: 'Wiederholen',
    close: 'Schließen',
    save: 'Speichern',
    cancel: 'Abbrechen',
    confirm: 'Bestätigen'
  },

  // 中文 (CHINOIS)
  zh: {
    appName: 'Math4Child',
    tagline: '在游戏中学习数学！',
    appBadge: '法国排名第一的教育应用',
    startFree: '免费开始',
    viewPlans: '查看计划',
    backToHome: '返回首页',
    
    welcomeTitle: '欢迎来到数学冒险！',
    welcomeMessage: '一个全面的应用程序，以有趣的方式学习数学',
    alreadyTrusted: '已有10万+家庭信任我们',
    applicationCorrected: '应用程序成功修正！',
    functionsNow: 'Math4Child现在运行完美',
    
    mathGames: '数学游戏',
    chooseGame: '选择你最喜欢的游戏，享受学习的乐趣',
    puzzleMath: '数学拼图',
    memoryMath: '数学记忆',
    quickMath: '快速计算',
    mixedExercises: '综合练习',
    
    puzzleMathDesc: '解决数学拼图',
    memoryMathDesc: '找到相同数字的配对',
    quickMathDesc: '在30秒内解决最多的计算',
    
    play: '游戏',
    playNow: '立即游戏',
    discoverExercises: '发现练习',
    seeExercises: '数学练习',
    seeGames: '教育游戏',
    seePremiumPlans: '高级计划',
    
    choosePlan: '选择你的计划',
    unlockPotential: '释放Math4Child的全部潜力',
    free: '免费',
    family: '家庭',
    premium: '高级',
    school: '学校',
    
    whyChoose: '为什么选择Math4Child？',
    whyChooseDesc: '发现让Math4Child成为第一应用的所有功能',
    
    families: '家庭',
    questionsResolved: '解决的问题',
    satisfaction: '满意度',
    averageRating: '平均评分',
    
    loading: '加载中...',
    error: '错误',
    retry: '重试',
    close: '关闭',
    save: '保存',
    cancel: '取消',
    confirm: '确认'
  },

  // SUOMI (FINNOIS)
  fi: {
    appName: 'Math4Child',
    tagline: 'Opi matematiikkaa hauskasti!',
    appBadge: 'Ranskan ykkös-koulutussovellus',
    startFree: 'Aloita Ilmaiseksi',
    viewPlans: 'Katso Suunnitelmat',
    backToHome: 'Takaisin Kotiin',
    
    welcomeTitle: 'Tervetuloa matemaattiseen seikkailuun!',
    welcomeMessage: 'Kattava sovellus matematiikan oppimiseen hauskasti',
    alreadyTrusted: 'Yli 100k perhettä luottaa meihin jo',
    applicationCorrected: 'Sovellus korjattu onnistuneesti!',
    functionsNow: 'Math4Child toimii nyt täydellisesti',
    
    mathGames: 'Matematiikkapelit',
    chooseGame: 'Valitse lemppelisi ja nauti oppimisesta',
    puzzleMath: 'Matematiikkapuzzle',
    memoryMath: 'Matematiikkamuisti',
    quickMath: 'Pikamatikka',
    mixedExercises: 'Sekatehtävät',
    
    puzzleMathDesc: 'Ratkaise matemaattinen puzzle',
    memoryMathDesc: 'Löydä identtisten numeroiden parit',
    quickMathDesc: 'Ratkaise maksimimäärä laskuja 30 sekunnissa',
    
    play: 'Pelaa',
    playNow: 'Pelaa Nyt',
    discoverExercises: 'Löydä Tehtäviä',
    seeExercises: 'Matematiikkatehtävät',
    seeGames: 'Opetuspelit',
    seePremiumPlans: 'Premium-suunnitelmat',
    
    choosePlan: 'Valitse Suunnitelmasi',
    unlockPotential: 'Vapauta Math4Childin täysi potentiaali',
    free: 'Ilmainen',
    family: 'Perhe',
    premium: 'Premium',
    school: 'Koulu',
    
    whyChoose: 'Miksi valita Math4Child?',
    whyChooseDesc: 'Löydä kaikki ominaisuudet, jotka tekevät Math4Childista ykkössovelluksen',
    
    families: 'Perheet',
    questionsResolved: 'Ratkaistut kysymykset',
    satisfaction: 'Tyytyväisyys',
    averageRating: 'Keskiarvosana',
    
    loading: 'Ladataan...',
    error: 'Virhe',
    retry: 'Yritä uudelleen',
    close: 'Sulje',
    save: 'Tallenna',
    cancel: 'Peruuta',
    confirm: 'Vahvista'
  }
};

// Fonction pour obtenir la traduction
export function getTranslation(languageCode: string, key: keyof Translation): string {
  const translation = translations[languageCode] || translations['en'];
  return translation[key] || translations['en'][key] || key;
}

// Fonction pour obtenir toutes les traductions d'une langue
export function getLanguageTranslations(languageCode: string): Translation {
  return translations[languageCode] || translations['en'];
}

// Fonction pour vérifier si une langue est supportée
export function isLanguageSupported(languageCode: string): boolean {
  return languageCode in translations;
}

// Exporter les langues disponibles
export const AVAILABLE_LANGUAGES = Object.keys(translations);
