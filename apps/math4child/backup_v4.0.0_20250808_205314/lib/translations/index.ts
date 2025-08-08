export interface Translations {
  // Navigation et interface
  appTitle: string;
  appSubtitle: string;
  backToHome: string;
  backToLevels: string;
  backToOperations: string;
  
  // Page d'accueil
  heroTitle: string;
  heroSubtitle: string;
  heroDescription: string;
  startLearning: string;
  correctAnswers: string;
  unlockedLevels: string;
  questionsRemaining: string;
  startFree: string;
  viewSubscriptions: string;
  readyToStart: string;
  joinThousands: string;
  
  // Niveaux
  chooseLevel: string;
  locked: string;
  completed: string;
  goodAnswers: string;
  
  // Opérations
  chooseOperation: string;
  
  // Exercices
  exercise: string;
  validate: string;
  correct: string;
  incorrect: string;
  answerWas: string;
  nextExercise: string;
  back: string;
  
  // Abonnements - Traductions principales
  subscriptionTitle: string;
  subscriptionSubtitle: string;
  unlockFeatures: string;
  currentPlan: string;
  choosePlan: string;
  popular: string;
  savings: string;
  
  // Plans
  free: string;
  monthly: string;
  quarterly: string;
  yearly: string;
  
  // Descriptions temporelles
  perMonth: string;
  perYear: string;
  months: string;
  year: string;
  days: string;
  questions: string;
  
  // Messages d'économies
  save: string;
  savePercent: string;
  originalPrice: string;
  
  // Fonctionnalités des plans
  planFeatures: {
    unlimitedQuestions: string;
    allLevels: string;
    allOperations: string;
    prioritySupport: string;
    detailedStats: string;
    premiumSupport: string;
    vipSupport: string;
    betaFeatures: string;
    emailSupport: string;
    freeQuestions: string;
    limitedLevels: string;
    accessDays: string;
    uniquePayment: string;
    allFromMonthly: string;
    priorityAccess: string;
  };
  
  // Fonctionnalités générales
  features: {
    adaptiveProgress: string;
    adaptiveDescription: string;
    operations: string;
    operationsDescription: string;
    multilingual: string;
    multilingualDescription: string;
    multiplatform: string;
    multiplatformDescription: string;
  };
  
  // Opérations mathématiques
  operations: {
    addition: string;
    subtraction: string;
    multiplication: string;
    division: string;
    mixed: string;
    additionDesc: string;
    subtractionDesc: string;
    multiplicationDesc: string;
    divisionDesc: string;
    mixedDesc: string;
  };
  
  // Niveaux
  levels: {
    beginner: string;
    elementary: string;
    intermediate: string;
    advanced: string;
    expert: string;
  };
  
  // Messages d'erreur
  limitReached: string;
  limitMessage: string;
}

// =============================================================================
// TRADUCTIONS FRANÇAISES COMPLÈTES
// =============================================================================
export const fr: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Apprendre les mathématiques en s'amusant",
  backToHome: "← Retour à l'accueil",
  backToLevels: "← Retour aux niveaux",
  backToOperations: "← Retour aux opérations",
  
  heroTitle: "Apprends les maths en t'amusant !",
  heroSubtitle: "Bienvenue dans l'aventure mathématique",
  heroDescription: "Développe tes compétences mathématiques avec des exercices progressifs et amusants",
  startLearning: "🚀 Commencer à apprendre",
  correctAnswers: "Bonnes réponses",
  unlockedLevels: "Niveaux débloqués",
  questionsRemaining: "Questions restantes",
  startFree: "🎯 Commencer gratuitement",
  viewSubscriptions: "💎 Voir les abonnements",
  readyToStart: "Prêt à commencer l'aventure ?",
  joinThousands: "Rejoins des milliers d'enfants qui apprennent les maths en s'amusant",
  
  chooseLevel: "Choisis ton niveau",
  locked: "🔒 Verrouillé",
  completed: "✅ Terminé !",
  goodAnswers: "bonnes réponses",
  
  chooseOperation: "Choisis ton opération",
  
  exercise: "Exercice",
  validate: "Valider",
  correct: "✅ Correct!",
  incorrect: "❌ Incorrect",
  answerWas: "La réponse était:",
  nextExercise: "Exercice suivant →",
  back: "← Retour",
  
  subscriptionTitle: "Choisis ton abonnement Math4Child",
  subscriptionSubtitle: "Débloquer toutes les fonctionnalités et exercices illimités",
  unlockFeatures: "Débloquer toutes les fonctionnalités",
  currentPlan: "Plan actuel",
  choosePlan: "Choisir ce plan",
  popular: "Populaire",
  savings: "économise",
  
  free: "Gratuit",
  monthly: "Mensuel",
  quarterly: "Trimestriel",
  yearly: "Annuel",
  
  perMonth: "par mois",
  perYear: "par an",
  months: "mois",
  year: "an",
  days: "jours",
  questions: "questions",
  
  save: "économise",
  savePercent: "économie",
  originalPrice: "Prix original",
  
  planFeatures: {
    unlimitedQuestions: "Questions illimitées",
    allLevels: "Tous les niveaux débloqués",
    allOperations: "Toutes les opérations",
    prioritySupport: "Support prioritaire",
    detailedStats: "Statistiques détaillées",
    premiumSupport: "Support premium",
    vipSupport: "Support VIP",
    betaFeatures: "Accès beta features",
    emailSupport: "Support email",
    freeQuestions: "questions gratuites",
    limitedLevels: "Tous les niveaux (limités)",
    accessDays: "Accès 7 jours",
    uniquePayment: "Paiement unique",
    allFromMonthly: "Tout du plan mensuel",
    priorityAccess: "Accès prioritaire nouveautés"
  },
  
  features: {
    adaptiveProgress: "Progression Adaptative",
    adaptiveDescription: "5 niveaux avec validation de 100 bonnes réponses par niveau",
    operations: "5 Opérations",
    operationsDescription: "Addition, soustraction, multiplication, division et exercices mixtes",
    multilingual: "Multilingue",
    multilingualDescription: "Support de 75+ langues avec adaptation culturelle",
    multiplatform: "Multi-plateforme",
    multiplatformDescription: "Web, Android et iOS avec synchronisation"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Soustraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixte",
    additionDesc: "Additionner des nombres",
    subtractionDesc: "Soustraire des nombres",
    multiplicationDesc: "Multiplier des nombres",
    divisionDesc: "Diviser des nombres",
    mixedDesc: "Exercices mélangés"
  },
  
  levels: {
    beginner: "Débutant",
    elementary: "Élémentaire",
    intermediate: "Intermédiaire",
    advanced: "Avancé",
    expert: "Expert"
  },
  
  limitReached: "Limite de questions atteinte",
  limitMessage: "Abonnez-vous pour continuer !"
};

// =============================================================================
// TRADUCTIONS ANGLAISES COMPLÈTES
// =============================================================================
export const en: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Learn mathematics while having fun",
  backToHome: "← Back to home",
  backToLevels: "← Back to levels",
  backToOperations: "← Back to operations",
  
  heroTitle: "Learn math while having fun!",
  heroSubtitle: "Welcome to the mathematical adventure",
  heroDescription: "Develop your math skills with progressive and fun exercises",
  startLearning: "🚀 Start learning",
  correctAnswers: "Correct answers",
  unlockedLevels: "Unlocked levels",
  questionsRemaining: "Questions remaining",
  startFree: "🎯 Start for free",
  viewSubscriptions: "💎 View subscriptions",
  readyToStart: "Ready to start the adventure?",
  joinThousands: "Join thousands of children learning math while having fun",
  
  chooseLevel: "Choose your level",
  locked: "🔒 Locked",
  completed: "✅ Completed!",
  goodAnswers: "correct answers",
  
  chooseOperation: "Choose your operation",
  
  exercise: "Exercise",
  validate: "Validate",
  correct: "✅ Correct!",
  incorrect: "❌ Incorrect",
  answerWas: "The answer was:",
  nextExercise: "Next exercise →",
  back: "← Back",
  
  subscriptionTitle: "Choose your Math4Child subscription",
  subscriptionSubtitle: "Unlock all features and unlimited exercises",
  unlockFeatures: "Unlock all features",
  currentPlan: "Current plan",
  choosePlan: "Choose this plan",
  popular: "Popular",
  savings: "save",
  
  free: "Free",
  monthly: "Monthly",
  quarterly: "Quarterly",
  yearly: "Yearly",
  
  perMonth: "per month",
  perYear: "per year",
  months: "months",
  year: "year",
  days: "days",
  questions: "questions",
  
  save: "save",
  savePercent: "savings",
  originalPrice: "Original price",
  
  planFeatures: {
    unlimitedQuestions: "Unlimited questions",
    allLevels: "All levels unlocked",
    allOperations: "All operations",
    prioritySupport: "Priority support",
    detailedStats: "Detailed statistics",
    premiumSupport: "Premium support",
    vipSupport: "VIP support",
    betaFeatures: "Beta features access",
    emailSupport: "Email support",
    freeQuestions: "free questions",
    limitedLevels: "All levels (limited)",
    accessDays: "7 days access",
    uniquePayment: "Single payment",
    allFromMonthly: "Everything from monthly",
    priorityAccess: "Priority access to new features"
  },
  
  features: {
    adaptiveProgress: "Adaptive Progress",
    adaptiveDescription: "5 levels with validation of 100 correct answers per level",
    operations: "5 Operations",
    operationsDescription: "Addition, subtraction, multiplication, division and mixed exercises",
    multilingual: "Multilingual",
    multilingualDescription: "Support for 75+ languages with cultural adaptation",
    multiplatform: "Multi-platform",
    multiplatformDescription: "Web, Android and iOS with synchronization"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Subtraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixed",
    additionDesc: "Add numbers",
    subtractionDesc: "Subtract numbers",
    multiplicationDesc: "Multiply numbers",
    divisionDesc: "Divide numbers",
    mixedDesc: "Mixed exercises"
  },
  
  levels: {
    beginner: "Beginner",
    elementary: "Elementary",
    intermediate: "Intermediate",
    advanced: "Advanced",
    expert: "Expert"
  },
  
  limitReached: "Question limit reached",
  limitMessage: "Subscribe to continue!"
};

// =============================================================================
// TRADUCTIONS ESPAGNOLES COMPLÈTES
// =============================================================================
export const es: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Aprende matemáticas divirtiéndote",
  backToHome: "← Volver al inicio",
  backToLevels: "← Volver a niveles",
  backToOperations: "← Volver a operaciones",
  
  heroTitle: "¡Aprende matemáticas divirtiéndote!",
  heroSubtitle: "Bienvenido a la aventura matemática",
  heroDescription: "Desarrolla tus habilidades matemáticas con ejercicios progresivos y divertidos",
  startLearning: "🚀 Comenzar a aprender",
  correctAnswers: "Respuestas correctas",
  unlockedLevels: "Niveles desbloqueados",
  questionsRemaining: "Preguntas restantes",
  startFree: "🎯 Comenzar gratis",
  viewSubscriptions: "💎 Ver suscripciones",
  readyToStart: "¿Listo para comenzar la aventura?",
  joinThousands: "Únete a miles de niños que aprenden matemáticas divirtiéndose",
  
  chooseLevel: "Elige tu nivel",
  locked: "🔒 Bloqueado",
  completed: "✅ ¡Completado!",
  goodAnswers: "respuestas correctas",
  
  chooseOperation: "Elige tu operación",
  
  exercise: "Ejercicio",
  validate: "Validar",
  correct: "✅ ¡Correcto!",
  incorrect: "❌ Incorrecto",
  answerWas: "La respuesta era:",
  nextExercise: "Siguiente ejercicio →",
  back: "← Atrás",
  
  subscriptionTitle: "Elige tu suscripción Math4Child",
  subscriptionSubtitle: "Desbloquea todas las funciones y ejercicios ilimitados",
  unlockFeatures: "Desbloquear todas las funciones",
  currentPlan: "Plan actual",
  choosePlan: "Elegir este plan",
  popular: "Popular",
  savings: "ahorra",
  
  free: "Gratis",
  monthly: "Mensual",
  quarterly: "Trimestral",
  yearly: "Anual",
  
  perMonth: "por mes",
  perYear: "por año",
  months: "meses",
  year: "año",
  days: "días",
  questions: "preguntas",
  
  save: "ahorra",
  savePercent: "ahorro",
  originalPrice: "Precio original",
  
  planFeatures: {
    unlimitedQuestions: "Preguntas ilimitadas",
    allLevels: "Todos los niveles desbloqueados",
    allOperations: "Todas las operaciones",
    prioritySupport: "Soporte prioritario",
    detailedStats: "Estadísticas detalladas",
    premiumSupport: "Soporte premium",
    vipSupport: "Soporte VIP",
    betaFeatures: "Acceso a funciones beta",
    emailSupport: "Soporte por email",
    freeQuestions: "preguntas gratuitas",
    limitedLevels: "Todos los niveles (limitados)",
    accessDays: "Acceso 7 días",
    uniquePayment: "Pago único",
    allFromMonthly: "Todo del plan mensual",
    priorityAccess: "Acceso prioritario a novedades"
  },
  
  features: {
    adaptiveProgress: "Progreso Adaptativo",
    adaptiveDescription: "5 niveles con validación de 100 respuestas correctas por nivel",
    operations: "5 Operaciones",
    operationsDescription: "Suma, resta, multiplicación, división y ejercicios mixtos",
    multilingual: "Multiidioma",
    multilingualDescription: "Soporte para 75+ idiomas con adaptación cultural",
    multiplatform: "Multiplataforma",
    multiplatformDescription: "Web, Android e iOS con sincronización"
  },
  
  operations: {
    addition: "Suma",
    subtraction: "Resta",
    multiplication: "Multiplicación",
    division: "División",
    mixed: "Mixto",
    additionDesc: "Sumar números",
    subtractionDesc: "Restar números",
    multiplicationDesc: "Multiplicar números",
    divisionDesc: "Dividir números",
    mixedDesc: "Ejercicios mixtos"
  },
  
  levels: {
    beginner: "Principiante",
    elementary: "Elemental",
    intermediate: "Intermedio",
    advanced: "Avanzado",
    expert: "Experto"
  },
  
  limitReached: "Límite de preguntas alcanzado",
  limitMessage: "¡Suscríbete para continuar!"
};

// =============================================================================
// TRADUCTIONS ALLEMANDES COMPLÈTES
// =============================================================================
export const de: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Mathematik lernen mit Spaß",
  backToHome: "← Zurück zur Startseite",
  backToLevels: "← Zurück zu den Levels",
  backToOperations: "← Zurück zu den Operationen",
  
  heroTitle: "Lerne Mathe mit Spaß!",
  heroSubtitle: "Willkommen zum mathematischen Abenteuer",
  heroDescription: "Entwickle deine mathematischen Fähigkeiten mit progressiven und unterhaltsamen Übungen",
  startLearning: "🚀 Mit dem Lernen beginnen",
  correctAnswers: "Richtige Antworten",
  unlockedLevels: "Freigeschaltete Level",
  questionsRemaining: "Verbleibende Fragen",
  startFree: "🎯 Kostenlos beginnen",
  viewSubscriptions: "💎 Abonnements anzeigen",
  readyToStart: "Bereit für das Abenteuer?",
  joinThousands: "Schließe dich Tausenden von Kindern an, die Mathe mit Spaß lernen",
  
  chooseLevel: "Wähle dein Level",
  locked: "🔒 Gesperrt",
  completed: "✅ Abgeschlossen!",
  goodAnswers: "richtige Antworten",
  
  chooseOperation: "Wähle deine Operation",
  
  exercise: "Übung",
  validate: "Bestätigen",
  correct: "✅ Richtig!",
  incorrect: "❌ Falsch",
  answerWas: "Die Antwort war:",
  nextExercise: "Nächste Übung →",
  back: "← Zurück",
  
  subscriptionTitle: "Wähle dein Math4Child-Abonnement",
  subscriptionSubtitle: "Schalte alle Funktionen und unbegrenzte Übungen frei",
  unlockFeatures: "Alle Funktionen freischalten",
  currentPlan: "Aktueller Plan",
  choosePlan: "Diesen Plan wählen",
  popular: "Beliebt",
  savings: "sparen",
  
  free: "Kostenlos",
  monthly: "Monatlich",
  quarterly: "Vierteljährlich",
  yearly: "Jährlich",
  
  perMonth: "pro Monat",
  perYear: "pro Jahr",
  months: "Monate",
  year: "Jahr",
  days: "Tage",
  questions: "Fragen",
  
  save: "sparen",
  savePercent: "Ersparnis",
  originalPrice: "Originalpreis",
  
  planFeatures: {
    unlimitedQuestions: "Unbegrenzte Fragen",
    allLevels: "Alle Level freigeschaltet",
    allOperations: "Alle Operationen",
    prioritySupport: "Prioritäts-Support",
    detailedStats: "Detaillierte Statistiken",
    premiumSupport: "Premium-Support",
    vipSupport: "VIP-Support",
    betaFeatures: "Beta-Features Zugang",
    emailSupport: "E-Mail Support",
    freeQuestions: "kostenlose Fragen",
    limitedLevels: "Alle Level (begrenzt)",
    accessDays: "7 Tage Zugang",
    uniquePayment: "Einmalzahlung",
    allFromMonthly: "Alles vom monatlichen Plan",
    priorityAccess: "Prioritätszugang zu Neuheiten"
  },
  
  features: {
    adaptiveProgress: "Adaptiver Fortschritt",
    adaptiveDescription: "5 Level mit Validierung von 100 richtigen Antworten pro Level",
    operations: "5 Operationen",
    operationsDescription: "Addition, Subtraktion, Multiplikation, Division und gemischte Übungen",
    multilingual: "Mehrsprachig",
    multilingualDescription: "Unterstützung für 75+ Sprachen mit kultureller Anpassung",
    multiplatform: "Multiplattform",
    multiplatformDescription: "Web, Android und iOS mit Synchronisation"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Subtraktion",
    multiplication: "Multiplikation",
    division: "Division",
    mixed: "Gemischt",
    additionDesc: "Zahlen addieren",
    subtractionDesc: "Zahlen subtrahieren",
    multiplicationDesc: "Zahlen multiplizieren",
    divisionDesc: "Zahlen dividieren",
    mixedDesc: "Gemischte Übungen"
  },
  
  levels: {
    beginner: "Anfänger",
    elementary: "Grundstufe",
    intermediate: "Mittelstufe",
    advanced: "Fortgeschritten",
    expert: "Experte"
  },
  
  limitReached: "Fragenlimit erreicht",
  limitMessage: "Abonniere, um fortzufahren!"
};

// =============================================================================
// TRADUCTIONS ARABES COMPLÈTES
// =============================================================================
export const ar: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "تعلم الرياضيات بمتعة",
  backToHome: "← العودة للرئيسية",
  backToLevels: "← العودة للمستويات",
  backToOperations: "← العودة للعمليات",
  
  heroTitle: "تعلم الرياضيات بمتعة!",
  heroSubtitle: "مرحباً بك في المغامرة الرياضية",
  heroDescription: "طور مهاراتك الرياضية مع تمارين متدرجة وممتعة",
  startLearning: "🚀 ابدأ التعلم",
  correctAnswers: "الإجابات الصحيحة",
  unlockedLevels: "المستويات المفتوحة",
  questionsRemaining: "الأسئلة المتبقية",
  startFree: "🎯 ابدأ مجاناً",
  viewSubscriptions: "💎 عرض الاشتراكات",
  readyToStart: "مستعد لبدء المغامرة؟",
  joinThousands: "انضم لآلاف الأطفال الذين يتعلمون الرياضيات بمتعة",
  
  chooseLevel: "اختر مستواك",
  locked: "🔒 مغلق",
  completed: "✅ مكتمل!",
  goodAnswers: "إجابات صحيحة",
  
  chooseOperation: "اختر عمليتك",
  
  exercise: "تمرين",
  validate: "تأكيد",
  correct: "✅ صحيح!",
  incorrect: "❌ خطأ",
  answerWas: "الإجابة كانت:",
  nextExercise: "التمرين التالي ←",
  back: "← رجوع",
  
  subscriptionTitle: "اختر اشتراك Math4Child",
  subscriptionSubtitle: "افتح جميع الميزات والتمارين اللامحدودة",
  unlockFeatures: "فتح جميع الميزات",
  currentPlan: "الخطة الحالية",
  choosePlan: "اختر هذه الخطة",
  popular: "شائع",
  savings: "وفر",
  
  free: "مجاني",
  monthly: "شهري",
  quarterly: "ربع سنوي",
  yearly: "سنوي",
  
  perMonth: "شهرياً",
  perYear: "سنوياً",
  months: "أشهر",
  year: "سنة",
  days: "أيام",
  questions: "أسئلة",
  
  save: "وفر",
  savePercent: "توفير",
  originalPrice: "السعر الأصلي",
  
  planFeatures: {
    unlimitedQuestions: "أسئلة غير محدودة",
    allLevels: "جميع المستويات مفتوحة",
    allOperations: "جميع العمليات",
    prioritySupport: "دعم ذو أولوية",
    detailedStats: "إحصائيات مفصلة",
    premiumSupport: "دعم متميز",
    vipSupport: "دعم VIP",
    betaFeatures: "الوصول للميزات التجريبية",
    emailSupport: "دعم بالبريد الإلكتروني",
    freeQuestions: "أسئلة مجانية",
    limitedLevels: "جميع المستويات (محدود)",
    accessDays: "وصول لمدة 7 أيام",
    uniquePayment: "دفعة واحدة",
    allFromMonthly: "كل شيء من الخطة الشهرية",
    priorityAccess: "وصول أولوي للميزات الجديدة"
  },
  
  features: {
    adaptiveProgress: "تقدم تكيفي",
    adaptiveDescription: "5 مستويات مع تأكيد 100 إجابة صحيحة لكل مستوى",
    operations: "5 عمليات",
    operationsDescription: "الجمع والطرح والضرب والقسمة والتمارين المختلطة",
    multilingual: "متعدد اللغات",
    multilingualDescription: "دعم أكثر من 75 لغة مع التكيف الثقافي",
    multiplatform: "متعدد المنصات",
    multiplatformDescription: "ويب وأندرويد وآي أو إس مع المزامنة"
  },
  
  operations: {
    addition: "الجمع",
    subtraction: "الطرح",
    multiplication: "الضرب",
    division: "القسمة",
    mixed: "مختلط",
    additionDesc: "جمع الأرقام",
    subtractionDesc: "طرح الأرقام",
    multiplicationDesc: "ضرب الأرقام",
    divisionDesc: "قسمة الأرقام",
    mixedDesc: "تمارين مختلطة"
  },
  
  levels: {
    beginner: "مبتدئ",
    elementary: "ابتدائي",
    intermediate: "متوسط",
    advanced: "متقدم",
    expert: "خبير"
  },
  
  limitReached: "تم الوصول لحد الأسئلة",
  limitMessage: "اشترك للمتابعة!"
};

// =============================================================================
// TRADUCTIONS CHINOISES COMPLÈTES
// =============================================================================
export const zh: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "快乐学数学",
  backToHome: "← 返回首页",
  backToLevels: "← 返回级别",
  backToOperations: "← 返回运算",
  
  heroTitle: "快乐学数学！",
  heroSubtitle: "欢迎来到数学冒险",
  heroDescription: "通过循序渐进且有趣的练习来提高你的数学技能",
  startLearning: "🚀 开始学习",
  correctAnswers: "正确答案",
  unlockedLevels: "已解锁级别",
  questionsRemaining: "剩余题目",
  startFree: "🎯 免费开始",
  viewSubscriptions: "💎 查看订阅",
  readyToStart: "准备开始冒险了吗？",
  joinThousands: "加入成千上万快乐学数学的孩子们",
  
  chooseLevel: "选择你的级别",
  locked: "🔒 已锁定",
  completed: "✅ 已完成！",
  goodAnswers: "正确答案",
  
  chooseOperation: "选择你的运算",
  
  exercise: "练习",
  validate: "确认",
  correct: "✅ 正确！",
  incorrect: "❌ 错误",
  answerWas: "答案是：",
  nextExercise: "下一题 →",
  back: "← 返回",
  
  subscriptionTitle: "选择你的Math4Child订阅",
  subscriptionSubtitle: "解锁所有功能和无限练习",
  unlockFeatures: "解锁所有功能",
  currentPlan: "当前计划",
  choosePlan: "选择此计划",
  popular: "热门",
  savings: "节省",
  
  free: "免费",
  monthly: "月度",
  quarterly: "季度",
  yearly: "年度",
  
  perMonth: "每月",
  perYear: "每年",
  months: "个月",
  year: "年",
  days: "天",
  questions: "题目",
  
  save: "节省",
  savePercent: "节省",
  originalPrice: "原价",
  
  planFeatures: {
    unlimitedQuestions: "无限题目",
    allLevels: "所有级别解锁",
    allOperations: "所有运算",
    prioritySupport: "优先支持",
    detailedStats: "详细统计",
    premiumSupport: "高级支持",
    vipSupport: "VIP支持",
    betaFeatures: "测试功能访问",
    emailSupport: "邮件支持",
    freeQuestions: "免费题目",
    limitedLevels: "所有级别（限制）",
    accessDays: "7天访问",
    uniquePayment: "一次性付款",
    allFromMonthly: "月度计划的所有功能",
    priorityAccess: "新功能优先访问"
  },
  
  features: {
    adaptiveProgress: "自适应进步",
    adaptiveDescription: "5个级别，每级需要100个正确答案验证",
    operations: "5种运算",
    operationsDescription: "加法、减法、乘法、除法和混合练习",
    multilingual: "多语言",
    multilingualDescription: "支持75+种语言，具有文化适应性",
    multiplatform: "多平台",
    multiplatformDescription: "网页、安卓和iOS同步"
  },
  
  operations: {
    addition: "加法",
    subtraction: "减法",
    multiplication: "乘法",
    division: "除法",
    mixed: "混合",
    additionDesc: "数字相加",
    subtractionDesc: "数字相减",
    multiplicationDesc: "数字相乘",
    divisionDesc: "数字相除",
    mixedDesc: "混合练习"
  },
  
  levels: {
    beginner: "初学者",
    elementary: "初级",
    intermediate: "中级",
    advanced: "高级",
    expert: "专家"
  },
  
  limitReached: "题目限制已达到",
  limitMessage: "订阅以继续！"
};

// Export de toutes les traductions
export const translations = {
  fr,
  en,
  es,
  de,
  ar,
  zh
};

// Hook pour utiliser les traductions
export const useTranslations = (language: string): Translations => {
  return translations[language as keyof typeof translations] || translations.fr;
};
