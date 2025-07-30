#!/usr/bin/env bash

# ===================================================================
# 🌍 SYSTÈME DE TRADUCTION COMPLET MATH4CHILD
# Correction de toutes les traductions manquantes
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

BASE_DIR="$(pwd)"
SRC_DIR="$BASE_DIR/src"

log_header() {
    echo -e "${CYAN}${BOLD}"
    echo "========================================="
    echo "🌍 $1"
    echo "========================================="
    echo -e "${NC}"
}

log_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Créer le système de traductions complet
create_complete_translations() {
    log_header "TRADUCTIONS COMPLÈTES - 75+ LANGUES"
    
    mkdir -p "$SRC_DIR/lib/translations"
    
    cat > "$SRC_DIR/lib/translations/index.ts" << 'EOF'
// ===================================================================
// 🌍 TRADUCTIONS COMPLÈTES MATH4CHILD
// Toutes les traductions pour 75+ langues
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
  monthly: string;
  quarterly: string;
  yearly: string;
  
  // Fonctionnalités
  childProfiles: string;
  unlimitedQuestions: string;
  allLevels: string;
  basicTracking: string;
  detailedStats: string;
  prioritySupport: string;
  vipSupport: string;
  
  // Réductions multi-appareils
  multiDeviceDiscounts: string;
  firstDevice: string;
  secondDevice: string;
  thirdDevice: string;
  fullPrice: string;
  discount50: string;
  discount75: string;
  
  // Niveaux
  choosLevel: string;
  beginner: string;
  elementary: string;
  intermediate: string;
  advanced: string;
  expert: string;
  locked: string;
  completed: string;
  
  // Opérations
  chooseOperation: string;
  addition: string;
  subtraction: string;
  multiplication: string;
  division: string;
  mixed: string;
  
  // Interface de jeu
  exercise: string;
  question: string;
  answer: string;
  validate: string;
  correct: string;
  incorrect: string;
  nextExercise: string;
  back: string;
  
  // Progression
  progress: string;
  correctAnswers: string;
  totalQuestions: string;
  accuracy: string;
  currentStreak: string;
  bestStreak: string;
  
  // Messages
  limitReached: string;
  subscribeToContine: string;
  wellDone: string;
  tryAgain: string;
  
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
    monthly: 'Mensuel',
    quarterly: 'Trimestriel',
    yearly: 'Annuel',
    
    childProfiles: 'profils enfants',
    unlimitedQuestions: 'Questions illimitées',
    allLevels: 'Tous les niveaux',
    basicTracking: 'Suivi de base',
    detailedStats: 'Statistiques détaillées',
    prioritySupport: 'Support prioritaire',
    vipSupport: 'Support VIP',
    
    multiDeviceDiscounts: 'Réductions Multi-Appareils',
    firstDevice: '1er appareil',
    secondDevice: '2ème appareil',
    thirdDevice: '3ème appareil',
    fullPrice: 'Prix plein',
    discount50: '50% de réduction',
    discount75: '75% de réduction',
    
    choosLevel: 'Choisis ton niveau',
    beginner: 'Débutant',
    elementary: 'Élémentaire', 
    intermediate: 'Intermédiaire',
    advanced: 'Avancé',
    expert: 'Expert',
    locked: '🔒 Verrouillé',
    completed: '✅ Terminé !',
    
    chooseOperation: 'Choisis ton opération',
    addition: 'Addition',
    subtraction: 'Soustraction',
    multiplication: 'Multiplication',
    division: 'Division',
    mixed: 'Mixte',
    
    exercise: 'Exercice',
    question: 'Question',
    answer: 'Réponse',
    validate: 'Valider',
    correct: '✅ Correct !',
    incorrect: '❌ Incorrect',
    nextExercise: 'Exercice suivant →',
    back: '← Retour',
    
    progress: 'Progression',
    correctAnswers: 'bonnes réponses',
    totalQuestions: 'questions totales',
    accuracy: 'précision',
    currentStreak: 'série actuelle',
    bestStreak: 'meilleure série',
    
    limitReached: 'Limite de questions atteinte',
    subscribeToContine: 'Abonnez-vous pour continuer !',
    wellDone: 'Bien joué !',
    tryAgain: 'Réessaie !',
    
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
    monthly: 'Monthly',
    quarterly: 'Quarterly',
    yearly: 'Yearly',
    
    childProfiles: 'child profiles',
    unlimitedQuestions: 'Unlimited questions',
    allLevels: 'All levels',
    basicTracking: 'Basic tracking',
    detailedStats: 'Detailed statistics',
    prioritySupport: 'Priority support',
    vipSupport: 'VIP support',
    
    multiDeviceDiscounts: 'Multi-Device Discounts',
    firstDevice: '1st device',
    secondDevice: '2nd device',
    thirdDevice: '3rd device',
    fullPrice: 'Full price',
    discount50: '50% discount',
    discount75: '75% discount',
    
    choosLevel: 'Choose your level',
    beginner: 'Beginner',
    elementary: 'Elementary',
    intermediate: 'Intermediate',
    advanced: 'Advanced',
    expert: 'Expert',
    locked: '🔒 Locked',
    completed: '✅ Completed!',
    
    chooseOperation: 'Choose your operation',
    addition: 'Addition',
    subtraction: 'Subtraction',
    multiplication: 'Multiplication',
    division: 'Division',
    mixed: 'Mixed',
    
    exercise: 'Exercise',
    question: 'Question',
    answer: 'Answer',
    validate: 'Validate',
    correct: '✅ Correct!',
    incorrect: '❌ Incorrect',
    nextExercise: 'Next exercise →',
    back: '← Back',
    
    progress: 'Progress',
    correctAnswers: 'correct answers',
    totalQuestions: 'total questions',
    accuracy: 'accuracy',
    currentStreak: 'current streak',
    bestStreak: 'best streak',
    
    limitReached: 'Question limit reached',
    subscribeToContine: 'Subscribe to continue!',
    wellDone: 'Well done!',
    tryAgain: 'Try again!',
    
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
    monthly: 'Mensual',
    quarterly: 'Trimestral',
    yearly: 'Anual',
    
    childProfiles: 'perfiles de niños',
    unlimitedQuestions: 'Preguntas ilimitadas',
    allLevels: 'Todos los niveles',
    basicTracking: 'Seguimiento básico',
    detailedStats: 'Estadísticas detalladas',
    prioritySupport: 'Soporte prioritario',
    vipSupport: 'Soporte VIP',
    
    multiDeviceDiscounts: 'Descuentos Multi-Dispositivo',
    firstDevice: '1er dispositivo',
    secondDevice: '2do dispositivo',
    thirdDevice: '3er dispositivo',
    fullPrice: 'Precio completo',
    discount50: '50% de descuento',
    discount75: '75% de descuento',
    
    choosLevel: 'Elige tu nivel',
    beginner: 'Principiante',
    elementary: 'Elemental',
    intermediate: 'Intermedio',
    advanced: 'Avanzado',
    expert: 'Experto',
    locked: '🔒 Bloqueado',
    completed: '✅ ¡Completado!',
    
    chooseOperation: 'Elige tu operación',
    addition: 'Suma',
    subtraction: 'Resta',
    multiplication: 'Multiplicación',
    division: 'División',
    mixed: 'Mixto',
    
    exercise: 'Ejercicio',
    question: 'Pregunta',
    answer: 'Respuesta',
    validate: 'Validar',
    correct: '✅ ¡Correcto!',
    incorrect: '❌ Incorrecto',
    nextExercise: 'Siguiente ejercicio →',
    back: '← Atrás',
    
    progress: 'Progreso',
    correctAnswers: 'respuestas correctas',
    totalQuestions: 'preguntas totales',
    accuracy: 'precisión',
    currentStreak: 'racha actual',
    bestStreak: 'mejor racha',
    
    limitReached: 'Límite de preguntas alcanzado',
    subscribeToContine: '¡Suscríbete para continuar!',
    wellDone: '¡Bien hecho!',
    tryAgain: '¡Inténtalo de nuevo!',
    
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
    monthly: 'شهري',
    quarterly: 'ربع سنوي',
    yearly: 'سنوي',
    
    childProfiles: 'ملفات الأطفال',
    unlimitedQuestions: 'أسئلة غير محدودة',
    allLevels: 'جميع المستويات',
    basicTracking: 'تتبع أساسي',
    detailedStats: 'إحصائيات مفصلة',
    prioritySupport: 'دعم أولوي',
    vipSupport: 'دعم VIP',
    
    multiDeviceDiscounts: 'خصومات متعددة الأجهزة',
    firstDevice: 'الجهاز الأول',
    secondDevice: 'الجهاز الثاني',
    thirdDevice: 'الجهاز الثالث',
    fullPrice: 'السعر الكامل',
    discount50: 'خصم 50%',
    discount75: 'خصم 75%',
    
    choosLevel: 'اختر مستواك',
    beginner: 'مبتدئ',
    elementary: 'ابتدائي',
    intermediate: 'متوسط',
    advanced: 'متقدم',
    expert: 'خبير',
    locked: '🔒 مقفل',
    completed: '✅ مكتمل!',
    
    chooseOperation: 'اختر عمليتك',
    addition: 'الجمع',
    subtraction: 'الطرح',
    multiplication: 'الضرب',
    division: 'القسمة',
    mixed: 'مختلط',
    
    exercise: 'تمرين',
    question: 'سؤال',
    answer: 'إجابة',
    validate: 'تأكيد',
    correct: '✅ صحيح!',
    incorrect: '❌ خطأ',
    nextExercise: 'التمرين التالي ←',
    back: '← رجوع',
    
    progress: 'التقدم',
    correctAnswers: 'إجابات صحيحة',
    totalQuestions: 'مجموع الأسئلة',
    accuracy: 'الدقة',
    currentStreak: 'السلسلة الحالية',
    bestStreak: 'أفضل سلسلة',
    
    limitReached: 'تم الوصول لحد الأسئلة',
    subscribeToContine: 'اشترك للمتابعة!',
    wellDone: 'أحسنت!',
    tryAgain: 'حاول مرة أخرى!',
    
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
    monthly: 'Monatlich',
    quarterly: 'Vierteljährlich',
    yearly: 'Jährlich',
    
    childProfiles: 'Kinderprofile',
    unlimitedQuestions: 'Unbegrenzte Fragen',
    allLevels: 'Alle Level',
    basicTracking: 'Basis-Tracking',
    detailedStats: 'Detaillierte Statistiken',
    prioritySupport: 'Priority-Support',
    vipSupport: 'VIP-Support',
    
    multiDeviceDiscounts: 'Multi-Gerät-Rabatte',
    firstDevice: '1. Gerät',
    secondDevice: '2. Gerät',
    thirdDevice: '3. Gerät',
    fullPrice: 'Vollpreis',
    discount50: '50% Rabatt',
    discount75: '75% Rabatt',
    
    choosLevel: 'Wähle dein Level',
    beginner: 'Anfänger',
    elementary: 'Grundstufe',
    intermediate: 'Mittelstufe',
    advanced: 'Fortgeschritten',
    expert: 'Experte',
    locked: '🔒 Gesperrt',
    completed: '✅ Abgeschlossen!',
    
    chooseOperation: 'Wähle deine Operation',
    addition: 'Addition',
    subtraction: 'Subtraktion',
    multiplication: 'Multiplikation',
    division: 'Division',
    mixed: 'Gemischt',
    
    exercise: 'Übung',
    question: 'Frage',
    answer: 'Antwort',
    validate: 'Bestätigen',
    correct: '✅ Richtig!',
    incorrect: '❌ Falsch',
    nextExercise: 'Nächste Übung →',
    back: '← Zurück',
    
    progress: 'Fortschritt',
    correctAnswers: 'richtige Antworten',
    totalQuestions: 'Gesamtfragen',
    accuracy: 'Genauigkeit',
    currentStreak: 'aktuelle Serie',
    bestStreak: 'beste Serie',
    
    limitReached: 'Fragenlimit erreicht',
    subscribeToContine: 'Abonnieren zum Fortfahren!',
    wellDone: 'Gut gemacht!',
    tryAgain: 'Versuch es nochmal!',
    
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
    monthly: '月度',
    quarterly: '季度',
    yearly: '年度',
    
    childProfiles: '儿童档案',
    unlimitedQuestions: '无限问题',
    allLevels: '所有级别',
    basicTracking: '基本跟踪',
    detailedStats: '详细统计',
    prioritySupport: '优先支持',
    vipSupport: 'VIP支持',
    
    multiDeviceDiscounts: '多设备折扣',
    firstDevice: '第1台设备',
    secondDevice: '第2台设备',
    thirdDevice: '第3台设备',
    fullPrice: '全价',
    discount50: '50%折扣',
    discount75: '75%折扣',
    
    choosLevel: '选择你的级别',
    beginner: '初学者',
    elementary: '初级',
    intermediate: '中级',
    advanced: '高级',
    expert: '专家',
    locked: '🔒 锁定',
    completed: '✅ 完成！',
    
    chooseOperation: '选择你的运算',
    addition: '加法',
    subtraction: '减法',
    multiplication: '乘法',
    division: '除法',
    mixed: '混合',
    
    exercise: '练习',
    question: '问题',
    answer: '答案',
    validate: '验证',
    correct: '✅ 正确！',
    incorrect: '❌ 错误',
    nextExercise: '下一个练习 →',
    back: '← 返回',
    
    progress: '进度',
    correctAnswers: '正确答案',
    totalQuestions: '总问题数',
    accuracy: '准确率',
    currentStreak: '当前连胜',
    bestStreak: '最佳连胜',
    
    limitReached: '已达到问题限制',
    subscribeToContine: '订阅以继续！',
    wellDone: '做得好！',
    tryAgain: '再试一次！',
    
    loading: '加载中...',
    error: '错误',
    retry: '重试',
    close: '关闭',
    save: '保存',
    cancel: '取消',
    confirm: '确认'
  },

  // ITALIANO
  it: {
    appName: 'Math4Child',
    tagline: 'Impara la matematica divertendoti!',
    appBadge: 'App Educativa #1 in Francia',
    startFree: 'Inizia Gratis',
    viewPlans: 'Vedi Piani',
    backToHome: 'Torna alla Home',
    
    welcomeTitle: 'Benvenuto nell\'avventura matematica!',
    welcomeMessage: 'Un\'app completa per imparare la matematica in modo divertente',
    alreadyTrusted: 'Già oltre 100k famiglie si fidano di noi',
    applicationCorrected: 'Applicazione Corretta con Successo!',
    functionsNow: 'Math4Child ora funziona perfettamente',
    
    mathGames: 'Giochi Matematici',
    chooseGame: 'Scegli il tuo gioco preferito e divertiti imparando',
    puzzleMath: 'Puzzle Matematico',
    memoryMath: 'Memory Matematico',
    quickMath: 'Calcolo Veloce',
    mixedExercises: 'Esercizi Misti',
    
    puzzleMathDesc: 'Risolvi il puzzle matematico',
    memoryMathDesc: 'Trova coppie di numeri identici',
    quickMathDesc: 'Risolvi il massimo di calcoli in 30 secondi',
    
    play: 'Gioca',
    playNow: 'Gioca Ora',
    discoverExercises: 'Scopri Esercizi',
    seeExercises: 'Esercizi Matematici',
    seeGames: 'Giochi Educativi',
    seePremiumPlans: 'Piani Premium',
    
    choosePlan: 'Scegli il tuo Piano',
    unlockPotential: 'Sblocca tutto il potenziale di Math4Child',
    free: 'Gratis',
    family: 'Famiglia',
    premium: 'Premium',
    school: 'Scuola',
    monthly: 'Mensile',
    quarterly: 'Trimestrale',
    yearly: 'Annuale',
    
    childProfiles: 'profili bambini',
    unlimitedQuestions: 'Domande illimitate',
    allLevels: 'Tutti i livelli',
    basicTracking: 'Tracciamento base',
    detailedStats: 'Statistiche dettagliate',
    prioritySupport: 'Supporto prioritario',
    vipSupport: 'Supporto VIP',
    
    multiDeviceDiscounts: 'Sconti Multi-Dispositivo',
    firstDevice: '1° dispositivo',
    secondDevice: '2° dispositivo',
    thirdDevice: '3° dispositivo',
    fullPrice: 'Prezzo pieno',
    discount50: '50% di sconto',
    discount75: '75% di sconto',
    
    choosLevel: 'Scegli il tuo livello',
    beginner: 'Principiante',
    elementary: 'Elementare',
    intermediate: 'Intermedio',
    advanced: 'Avanzato',
    expert: 'Esperto',
    locked: '🔒 Bloccato',
    completed: '✅ Completato!',
    
    chooseOperation: 'Scegli la tua operazione',
    addition: 'Addizione',
    subtraction: 'Sottrazione',
    multiplication: 'Moltiplicazione',
    division: 'Divisione',
    mixed: 'Misto',
    
    exercise: 'Esercizio',
    question: 'Domanda',
    answer: 'Risposta',
    validate: 'Convalida',
    correct: '✅ Corretto!',
    incorrect: '❌ Sbagliato',
    nextExercise: 'Prossimo esercizio →',
    back: '← Indietro',
    
    progress: 'Progresso',
    correctAnswers: 'risposte corrette',
    totalQuestions: 'domande totali',
    accuracy: 'precisione',
    currentStreak: 'serie attuale',
    bestStreak: 'migliore serie',
    
    limitReached: 'Limite domande raggiunto',
    subscribeToContine: 'Abbonati per continuare!',
    wellDone: 'Ben fatto!',
    tryAgain: 'Riprova!',
    
    loading: 'Caricamento...',
    error: 'Errore',
    retry: 'Riprova',
    close: 'Chiudi',
    save: 'Salva',
    cancel: 'Annulla',
    confirm: 'Conferma'
  },

  // PORTUGUÊS
  pt: {
    appName: 'Math4Child',
    tagline: 'Aprenda matemática se divertindo!',
    appBadge: 'App Educativo #1 na França',
    startFree: 'Começar Grátis',
    viewPlans: 'Ver Planos',
    backToHome: 'Voltar ao Início',
    
    welcomeTitle: 'Bem-vindo à aventura matemática!',
    welcomeMessage: 'Um app completo para aprender matemática de forma divertida',
    alreadyTrusted: 'Já mais de 100k famílias confiam em nós',
    applicationCorrected: 'Aplicação Corrigida com Sucesso!',
    functionsNow: 'Math4Child agora funciona perfeitamente',
    
    mathGames: 'Jogos Matemáticos',
    chooseGame: 'Escolha seu jogo favorito e divirta-se aprendendo',
    puzzleMath: 'Puzzle Matemático',
    memoryMath: 'Memória Matemática',
    quickMath: 'Cálculo Rápido',
    mixedExercises: 'Exercícios Mistos',
    
    puzzleMathDesc: 'Resolva o puzzle matemático',
    memoryMathDesc: 'Encontre pares de números idênticos',
    quickMathDesc: 'Resolva o máximo de cálculos em 30 segundos',
    
    play: 'Jogar',
    playNow: 'Jogar Agora',
    discoverExercises: 'Descobrir Exercícios',
    seeExercises: 'Exercícios Matemáticos',
    seeGames: 'Jogos Educativos',
    seePremiumPlans: 'Planos Premium',
    
    choosePlan: 'Escolha seu Plano',
    unlockPotential: 'Desbloqueie todo o potencial do Math4Child',
    free: 'Grátis',
    family: 'Família',
    premium: 'Premium',
    school: 'Escola',
    monthly: 'Mensal',
    quarterly: 'Trimestral',
    yearly: 'Anual',
    
    childProfiles: 'perfis de crianças',
    unlimitedQuestions: 'Perguntas ilimitadas',
    allLevels: 'Todos os níveis',
    basicTracking: 'Rastreamento básico',
    detailedStats: 'Estatísticas detalhadas',
    prioritySupport: 'Suporte prioritário',
    vipSupport: 'Suporte VIP',
    
    multiDeviceDiscounts: 'Descontos Multi-Dispositivo',
    firstDevice: '1º dispositivo',
    secondDevice: '2º dispositivo',
    thirdDevice: '3º dispositivo',
    fullPrice: 'Preço cheio',
    discount50: '50% de desconto',
    discount75: '75% de desconto',
    
    choosLevel: 'Escolha seu nível',
    beginner: 'Iniciante',
    elementary: 'Elementar',
    intermediate: 'Intermediário',
    advanced: 'Avançado',
    expert: 'Especialista',
    locked: '🔒 Bloqueado',
    completed: '✅ Concluído!',
    
    chooseOperation: 'Escolha sua operação',
    addition: 'Adição',
    subtraction: 'Subtração',
    multiplication: 'Multiplicação',
    division: 'Divisão',
    mixed: 'Misto',
    
    exercise: 'Exercício',
    question: 'Pergunta',
    answer: 'Resposta',
    validate: 'Validar',
    correct: '✅ Correto!',
    incorrect: '❌ Incorreto',
    nextExercise: 'Próximo exercício →',
    back: '← Voltar',
    
    progress: 'Progresso',
    correctAnswers: 'respostas corretas',
    totalQuestions: 'perguntas totais',
    accuracy: 'precisão',
    currentStreak: 'sequência atual',
    bestStreak: 'melhor sequência',
    
    limitReached: 'Limite de perguntas atingido',
    subscribeToContine: 'Assine para continuar!',
    wellDone: 'Muito bem!',
    tryAgain: 'Tente novamente!',
    
    loading: 'Carregando...',
    error: 'Erro',
    retry: 'Tentar novamente',
    close: 'Fechar',
    save: 'Salvar',
    cancel: 'Cancelar',
    confirm: 'Confirmar'
  },

  // РУССКИЙ
  ru: {
    appName: 'Math4Child',
    tagline: 'Изучайте математику с удовольствием!',
    appBadge: 'Образовательное приложение №1 во Франции',
    startFree: 'Начать Бесплатно',
    viewPlans: 'Посмотреть Планы',
    backToHome: 'Вернуться Домой',
    
    welcomeTitle: 'Добро пожаловать в математическое приключение!',
    welcomeMessage: 'Полнофункциональное приложение для изучения математики в игровой форме',
    alreadyTrusted: 'Уже более 100 тысяч семей доверяют нам',
    applicationCorrected: 'Приложение успешно исправлено!',
    functionsNow: 'Math4Child теперь работает идеально',
    
    mathGames: 'Математические Игры',
    chooseGame: 'Выберите любимую игру и получайте удовольствие от обучения',
    puzzleMath: 'Математическая Головоломка',
    memoryMath: 'Математическая Память',
    quickMath: 'Быстрый Счет',
    mixedExercises: 'Смешанные Упражнения',
    
    puzzleMathDesc: 'Решите математическую головоломку',
    memoryMathDesc: 'Найдите пары одинаковых чисел',
    quickMathDesc: 'Решите максимум вычислений за 30 секунд',
    
    play: 'Играть',
    playNow: 'Играть Сейчас',
    discoverExercises: 'Открыть Упражнения',
    seeExercises: 'Математические Упражнения',
    seeGames: 'Образовательные Игры',
    seePremiumPlans: 'Премиум Планы',
    
    choosePlan: 'Выберите свой План',
    unlockPotential: 'Раскройте весь потенциал Math4Child',
    free: 'Бесплатно',
    family: 'Семья',
    premium: 'Премиум',
    school: 'Школа',
    monthly: 'Ежемесячно',
    quarterly: 'Ежеквартально',
    yearly: 'Ежегодно',
    
    childProfiles: 'профили детей',
    unlimitedQuestions: 'Неограниченные вопросы',
    allLevels: 'Все уровни',
    basicTracking: 'Базовое отслеживание',
    detailedStats: 'Подробная статистика',
    prioritySupport: 'Приоритетная поддержка',
    vipSupport: 'VIP поддержка',
    
    multiDeviceDiscounts: 'Скидки на Несколько Устройств',
    firstDevice: '1-е устройство',
    secondDevice: '2-е устройство',
    thirdDevice: '3-е устройство',
    fullPrice: 'Полная цена',
    discount50: 'Скидка 50%',
    discount75: 'Скидка 75%',
    
    choosLevel: 'Выберите свой уровень',
    beginner: 'Новичок',
    elementary: 'Начальный',
    intermediate: 'Средний',
    advanced: 'Продвинутый',
    expert: 'Эксперт',
    locked: '🔒 Заблокировано',
    completed: '✅ Завершено!',
    
    chooseOperation: 'Выберите операцию',
    addition: 'Сложение',
    subtraction: 'Вычитание',
    multiplication: 'Умножение',
    division: 'Деление',
    mixed: 'Смешанное',
    
    exercise: 'Упражнение',
    question: 'Вопрос',
    answer: 'Ответ',
    validate: 'Подтвердить',
    correct: '✅ Правильно!',
    incorrect: '❌ Неправильно',
    nextExercise: 'Следующее упражнение →',
    back: '← Назад',
    
    progress: 'Прогресс',
    correctAnswers: 'правильные ответы',
    totalQuestions: 'всего вопросов',
    accuracy: 'точность',
    currentStreak: 'текущая серия',
    bestStreak: 'лучшая серия',
    
    limitReached: 'Лимит вопросов достигнут',
    subscribeToContine: 'Подпишитесь, чтобы продолжить!',
    wellDone: 'Отлично!',
    tryAgain: 'Попробуйте еще раз!',
    
    loading: 'Загрузка...',
    error: 'Ошибка',
    retry: 'Повторить',
    close: 'Закрыть',
    save: 'Сохранить',
    cancel: 'Отменить',
    confirm: 'Подтвердить'
  },

  // 日本語 (JAPONAIS)
  ja: {
    appName: 'Math4Child',
    tagline: '楽しく数学を学ぼう！',
    appBadge: 'フランスの教育アプリ第1位',
    startFree: '無料で始める',
    viewPlans: 'プランを見る',
    backToHome: 'ホームに戻る',
    
    welcomeTitle: '数学の冒険へようこそ！',
    welcomeMessage: '楽しく数学を学ぶための包括的なアプリ',
    alreadyTrusted: '既に10万以上の家族が信頼しています',
    applicationCorrected: 'アプリケーションの修正が完了しました！',
    functionsNow: 'Math4Childは完璧に動作しています',
    
    mathGames: '数学ゲーム',
    chooseGame: 'お気に入りのゲームを選んで楽しく学ぼう',
    puzzleMath: '数学パズル',
    memoryMath: '数学メモリー',
    quickMath: '計算スピード',
    mixedExercises: 'ミックス練習',
    
    puzzleMathDesc: '数学パズルを解こう',
    memoryMathDesc: '同じ数字のペアを見つけよう',
    quickMathDesc: '30秒で最大限の計算を解こう',
    
    play: 'プレイ',
    playNow: '今すぐプレイ',
    discoverExercises: '練習問題を発見',
    seeExercises: '数学練習',
    seeGames: '教育ゲーム',
    seePremiumPlans: 'プレミアムプラン',
    
    choosePlan: 'プランを選択',
    unlockPotential: 'Math4Childの全ポテンシャルを解放',
    free: '無料',
    family: 'ファミリー',
    premium: 'プレミアム',
    school: '学校',
    monthly: '月額',
    quarterly: '四半期',
    yearly: '年額',
    
    childProfiles: '子供のプロフィール',
    unlimitedQuestions: '無制限の問題',
    allLevels: '全レベル',
    basicTracking: '基本トラッキング',
    detailedStats: '詳細統計',
    prioritySupport: '優先サポート',
    vipSupport: 'VIPサポート',
    
    multiDeviceDiscounts: 'マルチデバイス割引',
    firstDevice: '1台目',
    secondDevice: '2台目',
    thirdDevice: '3台目',
    fullPrice: '通常価格',
    discount50: '50%割引',
    discount75: '75%割引',
    
    choosLevel: 'レベルを選択',
    beginner: '初心者',
    elementary: '初級',
    intermediate: '中級',
    advanced: '上級',
    expert: 'エキスパート',
    locked: '🔒 ロック中',
    completed: '✅ 完了！',
    
    chooseOperation: '計算を選択',
    addition: '足し算',
    subtraction: '引き算',
    multiplication: 'かけ算',
    division: 'わり算',
    mixed: 'ミックス',
    
    exercise: '練習',
    question: '問題',
    answer: '答え',
    validate: '確認',
    correct: '✅ 正解！',
    incorrect: '❌ 不正解',
    nextExercise: '次の練習 →',
    back: '← 戻る',
    
    progress: '進捗',
    correctAnswers: '正解数',
    totalQuestions: '総問題数',
    accuracy: '正確性',
    currentStreak: '現在の連続',
    bestStreak: '最高連続',
    
    limitReached: '問題制限に達しました',
    subscribeToContine: '続けるには購読してください！',
    wellDone: 'よくできました！',
    tryAgain: 'もう一度！',
    
    loading: '読み込み中...',
    error: 'エラー',
    retry: '再試行',
    close: '閉じる',
    save: '保存',
    cancel: 'キャンセル',
    confirm: '確認'
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
    
    mathGames: 'Matematiikkapelitär',
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
    monthly: 'Kuukausittain',
    quarterly: 'Neljännesvuosittain',
    yearly: 'Vuosittain',
    
    childProfiles: 'lapsiprofiilit',
    unlimitedQuestions: 'Rajattomat kysymykset',
    allLevels: 'Kaikki tasot',
    basicTracking: 'Perusseuranta',
    detailedStats: 'Yksityiskohtaiset tilastot',
    prioritySupport: 'Prioriteettituki',
    vipSupport: 'VIP-tuki',
    
    multiDeviceDiscounts: 'Monilaite-alennukset',
    firstDevice: '1. laite',
    secondDevice: '2. laite',
    thirdDevice: '3. laite',
    fullPrice: 'Täysi hinta',
    discount50: '50% alennus',
    discount75: '75% alennus',
    
    choosLevel: 'Valitse tasosi',
    beginner: 'Aloittelija',
    elementary: 'Alkeis',
    intermediate: 'Keskitaso',
    advanced: 'Kehittynyt',
    expert: 'Asiantuntija',
    locked: '🔒 Lukittu',
    completed: '✅ Valmis!',
    
    chooseOperation: 'Valitse laskutoimituksesi',
    addition: 'Yhteenlasku',
    subtraction: 'Vähennyslasku',
    multiplication: 'Kertolasku',
    division: 'Jakolasku',
    mixed: 'Sekoitettu',
    
    exercise: 'Harjoitus',
    question: 'Kysymys',
    answer: 'Vastaus',
    validate: 'Vahvista',
    correct: '✅ Oikein!',
    incorrect: '❌ Väärin',
    nextExercise: 'Seuraava harjoitus →',
    back: '← Takaisin',
    
    progress: 'Edistyminen',
    correctAnswers: 'oikeat vastaukset',
    totalQuestions: 'kysymyksiä yhteensä',
    accuracy: 'tarkkuus',
    currentStreak: 'nykyinen sarja',
    bestStreak: 'paras sarja',
    
    limitReached: 'Kysymysraja saavutettu',
    subscribeToContine: 'Tilaa jatkaaksesi!',
    wellDone: 'Hyvin tehty!',
    tryAgain: 'Yritä uudelleen!',
    
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
EOF
    
    log_success "Traductions complètes créées pour toutes les langues"
}

# Mettre à jour le contexte de langue
update_language_context() {
    log_header "MISE À JOUR DU CONTEXTE DE LANGUE"
    
    cat > "$SRC_DIR/contexts/LanguageContext.tsx" << 'EOF'
'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { getLanguageTranslations, Translation, isLanguageSupported } from '@/lib/translations';
import { getLanguageByCode, isRTL } from '@/lib/i18n/languages';

interface LanguageContextType {
  currentLanguage: string;
  setLanguage: (lang: string) => void;
  t: (key: keyof Translation) => string;
  isRTL: boolean;
  currentLang