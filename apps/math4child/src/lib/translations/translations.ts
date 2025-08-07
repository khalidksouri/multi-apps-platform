export interface Translation {
  [key: string]: string | { [key: string]: string };
}

export const translations: { [language: string]: Translation } = {
  // ==================================================
  // FRANÇAIS - TRADUCTION COMPLÈTE
  // ==================================================
  fr: {
    // Navigation et interface
    appTitle: "Math4Child",
    appSubtitle: "Apprendre les mathématiques en s'amusant",
    navigation: {
      home: "Accueil",
      exercises: "Exercices", 
      profile: "Profil",
      pricing: "Plans",
      about: "À propos"
    },

    // Page d'accueil
    hero: {
      title: "Apprends les maths en t'amusant !",
      subtitle: "L'application éducative révolutionnaire",
      description: "Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau",
      startFree: "🚀 Commencer gratuitement",
      viewPlans: "💎 Voir les plans",
      familyTrust: "100k+ familles nous font confiance"
    },

    // Statistiques
    stats: {
      correctAnswers: "Bonnes réponses",
      unlockedLevels: "Niveaux débloqués", 
      questionsRemaining: "Questions restantes",
      accuracy: "Précision",
      timeSpent: "Temps passé",
      streak: "Série de réussites"
    },

    // Fonctionnalités
    features: {
      title: "Fonctionnalités principales",
      subtitle: "Découvre tout ce qui fait de Math4Child l'app n°1",
      
      adaptiveAI: "IA Adaptative",
      adaptiveDesc: "Questions personnalisées selon ton niveau et tes progrès",
      
      worldLanguages: "200+ Langues",
      worldDesc: "Support multilingue complet avec toutes les langues du monde",
      
      progressiveLevels: "5 Niveaux Progressifs", 
      levelsDesc: "100 questions par niveau pour une progression méthodique",
      
      allOperations: "Toutes les Opérations",
      operationsDesc: "Addition, soustraction, multiplication, division et mixte",
      
      detailedStats: "Statistiques Détaillées",
      statsDesc: "Suis tes progrès avec des graphiques et analyses avancées",
      
      multiPlatform: "Multi-plateforme",
      platformDesc: "Web, Android et iOS avec synchronisation complète"
    },

    // Niveaux
    levels: {
      choose: "Choisis ton niveau",
      level1: "Niveau 1 - Découverte",
      level2: "Niveau 2 - Exploration", 
      level3: "Niveau 3 - Maîtrise",
      level4: "Niveau 4 - Expert",
      level5: "Niveau 5 - Champion",
      locked: "🔒 Verrouillé",
      unlocked: "🔓 Débloqué",
      completed: "✅ Terminé !",
      progress: "progrès",
      questionsCompleted: "questions complétées"
    },

    // Opérations
    operations: {
      choose: "Choisis ton opération",
      addition: "Addition",
      subtraction: "Soustraction", 
      multiplication: "Multiplication",
      division: "Division",
      mixed: "Exercices Mixtes",
      
      additionDesc: "Apprends à additionner des nombres",
      subtractionDesc: "Maîtrise la soustraction",
      multiplicationDesc: "Découvre les tables de multiplication",
      divisionDesc: "Comprends la division",
      mixedDesc: "Entraîne-toi avec tous les types"
    },

    // Exercices
    exercise: {
      title: "Exercice",
      question: "Question",
      answer: "Ta réponse",
      validate: "Valider",
      next: "Question suivante →",
      back: "← Retour",
      hint: "💡 Indice",
      
      // Messages de feedback
      correct: "🎉 Excellent ! Bonne réponse !",
      incorrect: "🤔 Pas tout à fait, essaie encore !",
      tryAgain: "Réessayer",
      showAnswer: "Voir la réponse",
      answerWas: "La réponse était :",
      
      // Progression
      questionOf: "Question {current} sur {total}",
      levelProgress: "Niveau {level} - Progrès : {percent}%",
      levelComplete: "🏆 Niveau terminé ! Félicitations !",
      unlockNext: "Déverrouiller le niveau suivant"
    },

    // Plans d'abonnement
    pricing: {
      title: "Choisis ton plan Math4Child",
      subtitle: "Débloque toutes les fonctionnalités pour progresser sans limites",
      
      free: "Gratuit",
      premium: "Premium", 
      family: "Famille",
      
      freePrice: "0€",
      premiumPrice: "4,99€",
      familyPrice: "9,99€",
      
      perMonth: "/mois",
      
      popular: "🔥 Populaire",
      recommended: "⭐ Recommandé",
      
      choosePlan: "Choisir ce plan",
      currentPlan: "Plan actuel",
      upgrade: "Améliorer",
      
      // Fonctionnalités des plans
      freeFeatures: [
        "Accès aux 2 premiers niveaux",
        "50 questions par jour",
        "Statistiques de base",
        "Publicités"
      ],
      
      premiumFeatures: [
        "✨ Tous les niveaux débloqués",
        "🚀 Questions illimitées", 
        "📊 Statistiques avancées",
        "🚫 Sans publicité",
        "💬 Support prioritaire"
      ],
      
      familyFeatures: [
        "👨‍👩‍👧‍👦 Jusqu'à 6 comptes enfants",
        "✨ Toutes les fonctionnalités Premium",
        "📈 Rapports familiaux détaillés",
        "🔒 Contrôle parental avancé",
        "📱 Synchronisation multi-appareils"
      ]
    },

    // Messages système
    messages: {
      loading: "Chargement...",
      error: "Une erreur s'est produite",
      retry: "Réessayer",
      success: "Succès !",
      
      limitReached: "Limite quotidienne atteinte",
      limitMessage: "Abonne-toi pour continuer sans limites !",
      
      welcome: "Bienvenue dans Math4Child !",
      letsStart: "Commençons l'aventure mathématique !"
    },

    // Footer
    footer: {
      description: "L'application éducative de référence pour apprendre les mathématiques en famille.",
      features: "Fonctionnalités",
      support: "Support", 
      download: "Télécharger",
      company: "Entreprise",
      
      // Liens fonctionnalités
      interactiveExercises: "Exercices interactifs",
      progressTracking: "Suivi des progrès",
      educationalGames: "Jeux éducatifs",
      multiPlayer: "Mode multi-joueurs",
      
      // Liens support
      helpCenter: "Centre d'aide",
      contact: "Contact",
      parentGuides: "Guides parents", 
      community: "Communauté",
      
      // Liens téléchargement
      appStore: "App Store",
      googlePlay: "Google Play",
      downloadOn: "Télécharger sur",
      
      // Liens entreprise
      about: "À propos",
      careers: "Carrières",
      press: "Presse",
      privacy: "Confidentialité",
      terms: "Conditions",
      
      copyright: "© 2024 Math4Child. Tous droits réservés."
    }
  },

  // ==================================================
  // ANGLAIS - TRADUCTION COMPLÈTE
  // ==================================================
  en: {
    // Navigation and interface
    appTitle: "Math4Child",
    appSubtitle: "Learn mathematics while having fun",
    navigation: {
      home: "Home",
      exercises: "Exercises",
      profile: "Profile", 
      pricing: "Plans",
      about: "About"
    },

    // Homepage
    hero: {
      title: "Learn math while having fun!",
      subtitle: "The revolutionary educational application",
      description: "Develop your math skills with progressive and fun exercises adapted to your level",
      startFree: "🚀 Start for free",
      viewPlans: "💎 View plans", 
      familyTrust: "100k+ families trust us"
    },

    // Statistics
    stats: {
      correctAnswers: "Correct answers",
      unlockedLevels: "Unlocked levels",
      questionsRemaining: "Remaining questions", 
      accuracy: "Accuracy",
      timeSpent: "Time spent",
      streak: "Success streak"
    },

    // Features
    features: {
      title: "Key Features",
      subtitle: "Discover everything that makes Math4Child the #1 app",
      
      adaptiveAI: "Adaptive AI",
      adaptiveDesc: "Personalized questions based on your level and progress",
      
      worldLanguages: "200+ Languages",
      worldDesc: "Complete multilingual support with all world languages",
      
      progressiveLevels: "5 Progressive Levels",
      levelsDesc: "100 questions per level for methodical progression",
      
      allOperations: "All Operations", 
      operationsDesc: "Addition, subtraction, multiplication, division and mixed",
      
      detailedStats: "Detailed Statistics",
      statsDesc: "Track your progress with advanced graphs and analytics",
      
      multiPlatform: "Multi-platform",
      platformDesc: "Web, Android and iOS with complete synchronization"
    },

    // Levels
    levels: {
      choose: "Choose your level",
      level1: "Level 1 - Discovery",
      level2: "Level 2 - Exploration",
      level3: "Level 3 - Mastery", 
      level4: "Level 4 - Expert",
      level5: "Level 5 - Champion",
      locked: "🔒 Locked",
      unlocked: "🔓 Unlocked",
      completed: "✅ Completed!",
      progress: "progress",
      questionsCompleted: "questions completed"
    },

    // Operations
    operations: {
      choose: "Choose your operation",
      addition: "Addition",
      subtraction: "Subtraction",
      multiplication: "Multiplication",
      division: "Division", 
      mixed: "Mixed Exercises",
      
      additionDesc: "Learn to add numbers",
      subtractionDesc: "Master subtraction",
      multiplicationDesc: "Discover multiplication tables", 
      divisionDesc: "Understand division",
      mixedDesc: "Practice with all types"
    },

    // Exercises
    exercise: {
      title: "Exercise",
      question: "Question", 
      answer: "Your answer",
      validate: "Validate",
      next: "Next question →",
      back: "← Back",
      hint: "💡 Hint",
      
      // Feedback messages
      correct: "🎉 Excellent! Correct answer!",
      incorrect: "🤔 Not quite, try again!",
      tryAgain: "Try again",
      showAnswer: "Show answer", 
      answerWas: "The answer was:",
      
      // Progression
      questionOf: "Question {current} of {total}",
      levelProgress: "Level {level} - Progress: {percent}%",
      levelComplete: "🏆 Level complete! Congratulations!",
      unlockNext: "Unlock next level"
    },

    // Pricing plans
    pricing: {
      title: "Choose your Math4Child plan",
      subtitle: "Unlock all features to progress without limits",
      
      free: "Free",
      premium: "Premium",
      family: "Family",
      
      freePrice: "€0",
      premiumPrice: "€4.99", 
      familyPrice: "€9.99",
      
      perMonth: "/month",
      
      popular: "🔥 Popular",
      recommended: "⭐ Recommended",
      
      choosePlan: "Choose this plan",
      currentPlan: "Current plan", 
      upgrade: "Upgrade",
      
      // Plan features
      freeFeatures: [
        "Access to first 2 levels",
        "50 questions per day",
        "Basic statistics",
        "Advertisements"
      ],
      
      premiumFeatures: [
        "✨ All levels unlocked",
        "🚀 Unlimited questions",
        "📊 Advanced statistics", 
        "🚫 Ad-free",
        "💬 Priority support"
      ],
      
      familyFeatures: [
        "👨‍👩‍👧‍👦 Up to 6 children accounts",
        "✨ All Premium features",
        "📈 Detailed family reports",
        "🔒 Advanced parental controls", 
        "📱 Multi-device synchronization"
      ]
    },

    // System messages
    messages: {
      loading: "Loading...",
      error: "An error occurred",
      retry: "Retry",
      success: "Success!",
      
      limitReached: "Daily limit reached",
      limitMessage: "Subscribe to continue without limits!",
      
      welcome: "Welcome to Math4Child!",
      letsStart: "Let's start the mathematical adventure!"
    },

    // Footer
    footer: {
      description: "The reference educational application for learning mathematics as a family.",
      features: "Features",
      support: "Support",
      download: "Download", 
      company: "Company",
      
      // Feature links
      interactiveExercises: "Interactive exercises",
      progressTracking: "Progress tracking",
      educationalGames: "Educational games",
      multiPlayer: "Multi-player mode",
      
      // Support links
      helpCenter: "Help center",
      contact: "Contact",
      parentGuides: "Parent guides",
      community: "Community",
      
      // Download links
      appStore: "App Store", 
      googlePlay: "Google Play",
      downloadOn: "Download on",
      
      // Company links
      about: "About",
      careers: "Careers",
      press: "Press",
      privacy: "Privacy",
      terms: "Terms",
      
      copyright: "© 2024 Math4Child. All rights reserved."
    }
  },

  // ==================================================
  // ARABE - TRADUCTION COMPLÈTE (RTL)
  // ==================================================
  ar: {
    // التنقل والواجهة
    appTitle: "Math4Child",
    appSubtitle: "تعلم الرياضيات بالمرح",
    navigation: {
      home: "الرئيسية",
      exercises: "التمارين",
      profile: "الملف الشخصي", 
      pricing: "الخطط",
      about: "حول"
    },

    // الصفحة الرئيسية
    hero: {
      title: "تعلم الرياضيات بالمرح!",
      subtitle: "التطبيق التعليمي الثوري",
      description: "طور مهاراتك الرياضية بتمارين متدرجة وممتعة مناسبة لمستواك",
      startFree: "🚀 ابدأ مجاناً",
      viewPlans: "💎 عرض الخطط",
      familyTrust: "100k+ عائلة تثق بنا"
    },

    // الإحصائيات
    stats: {
      correctAnswers: "الإجابات الصحيحة",
      unlockedLevels: "المستويات المفتوحة",
      questionsRemaining: "الأسئلة المتبقية",
      accuracy: "الدقة", 
      timeSpent: "الوقت المستغرق",
      streak: "سلسلة النجاح"
    },

    // المميزات
    features: {
      title: "المميزات الرئيسية",
      subtitle: "اكتشف كل ما يجعل Math4Child التطبيق رقم 1",
      
      adaptiveAI: "ذكاء اصطناعي تكيفي",
      adaptiveDesc: "أسئلة مخصصة حسب مستواك وتقدمك",
      
      worldLanguages: "200+ لغة",
      worldDesc: "دعم متعدد اللغات الكامل مع جميع لغات العالم",
      
      progressiveLevels: "5 مستويات متدرجة",
      levelsDesc: "100 سؤال لكل مستوى لتقدم منهجي",
      
      allOperations: "جميع العمليات",
      operationsDesc: "الجمع والطرح والضرب والقسمة والمختلط",
      
      detailedStats: "إحصائيات مفصلة", 
      statsDesc: "تتبع تقدمك بالرسوم البيانية والتحليلات المتقدمة",
      
      multiPlatform: "متعدد المنصات",
      platformDesc: "الويب وأندرويد وiOS مع مزامنة كاملة"
    },

    // المستويات
    levels: {
      choose: "اختر مستواك",
      level1: "المستوى 1 - الاكتشاف",
      level2: "المستوى 2 - الاستكشاف",
      level3: "المستوى 3 - الإتقان",
      level4: "المستوى 4 - الخبير",
      level5: "المستوى 5 - البطل",
      locked: "🔒 مقفل",
      unlocked: "🔓 مفتوح", 
      completed: "✅ مكتمل!",
      progress: "التقدم",
      questionsCompleted: "أسئلة مكتملة"
    },

    // العمليات
    operations: {
      choose: "اختر عمليتك",
      addition: "الجمع",
      subtraction: "الطرح",
      multiplication: "الضرب", 
      division: "القسمة",
      mixed: "تمارين مختلطة",
      
      additionDesc: "تعلم جمع الأرقام",
      subtractionDesc: "أتقن الطرح",
      multiplicationDesc: "اكتشف جداول الضرب",
      divisionDesc: "افهم القسمة",
      mixedDesc: "تدرب مع جميع الأنواع"
    },

    // التمارين
    exercise: {
      title: "التمرين",
      question: "السؤال",
      answer: "إجابتك", 
      validate: "تأكيد",
      next: "السؤال التالي ←",
      back: "→ رجوع",
      hint: "💡 تلميح",
      
      // رسائل الملاحظات
      correct: "🎉 ممتاز! إجابة صحيحة!",
      incorrect: "🤔 ليس تماماً، حاول مرة أخرى!",
      tryAgain: "حاول مرة أخرى",
      showAnswer: "عرض الإجابة",
      answerWas: "كانت الإجابة:",
      
      // التقدم
      questionOf: "السؤال {current} من {total}",
      levelProgress: "المستوى {level} - التقدم: {percent}%",
      levelComplete: "🏆 المستوى مكتمل! تهانينا!",
      unlockNext: "فتح المستوى التالي"
    },

    // خطط الاشتراك
    pricing: {
      title: "اختر خطة Math4Child الخاصة بك",
      subtitle: "افتح جميع المميزات للتقدم بلا حدود",
      
      free: "مجاني",
      premium: "مميز",
      family: "عائلي",
      
      freePrice: "0€",
      premiumPrice: "4.99€",
      familyPrice: "9.99€",
      
      perMonth: "/شهر",
      
      popular: "🔥 شائع",
      recommended: "⭐ موصى به",
      
      choosePlan: "اختر هذه الخطة",
      currentPlan: "الخطة الحالية",
      upgrade: "ترقية",
      
      // مميزات الخطط
      freeFeatures: [
        "الوصول إلى أول مستويين",
        "50 سؤال يومياً", 
        "إحصائيات أساسية",
        "إعلانات"
      ],
      
      premiumFeatures: [
        "✨ جميع المستويات مفتوحة",
        "🚀 أسئلة غير محدودة",
        "📊 إحصائيات متقدمة",
        "🚫 بدون إعلانات",
        "💬 دعم أولوية"
      ],
      
      familyFeatures: [
        "👨‍👩‍👧‍👦 حتى 6 حسابات أطفال",
        "✨ جميع مميزات المميز",
        "📈 تقارير عائلية مفصلة",
        "🔒 رقابة أبوية متقدمة",
        "📱 مزامنة متعددة الأجهزة"
      ]
    },

    // رسائل النظام
    messages: {
      loading: "جاري التحميل...",
      error: "حدث خطأ",
      retry: "إعادة المحاولة", 
      success: "نجح!",
      
      limitReached: "تم الوصول للحد اليومي",
      limitMessage: "اشترك للمتابعة بلا حدود!",
      
      welcome: "مرحباً بك في Math4Child!",
      letsStart: "لنبدأ المغامرة الرياضية!"
    },

    // التذييل
    footer: {
      description: "التطبيق التعليمي المرجعي لتعلم الرياضيات كعائلة.",
      features: "المميزات",
      support: "الدعم",
      download: "التحميل",
      company: "الشركة",
      
      // روابط المميزات
      interactiveExercises: "تمارين تفاعلية",
      progressTracking: "تتبع التقدم",
      educationalGames: "ألعاب تعليمية",
      multiPlayer: "وضع متعدد اللاعبين",
      
      // روابط الدعم
      helpCenter: "مركز المساعدة",
      contact: "اتصال",
      parentGuides: "أدلة الآباء",
      community: "المجتمع",
      
      // روابط التحميل
      appStore: "App Store",
      googlePlay: "Google Play",
      downloadOn: "تحميل على",
      
      // روابط الشركة
      about: "حول",
      careers: "وظائف",
      press: "الصحافة",
      privacy: "الخصوصية",
      terms: "الشروط",
      
      copyright: "© 2024 Math4Child. جميع الحقوق محفوظة."
    }
  },

  // ==================================================
  // ESPAGNOL - TRADUCTION COMPLÈTE
  // ==================================================
  es: {
    // Navegación e interfaz
    appTitle: "Math4Child",
    appSubtitle: "Aprende matemáticas divirtiéndote",
    navigation: {
      home: "Inicio",
      exercises: "Ejercicios",
      profile: "Perfil",
      pricing: "Planes",
      about: "Acerca de"
    },

    // Página de inicio
    hero: {
      title: "¡Aprende matemáticas divirtiéndote!",
      subtitle: "La aplicación educativa revolucionaria",
      description: "Desarrolla tus habilidades matemáticas con ejercicios progresivos y divertidos adaptados a tu nivel",
      startFree: "🚀 Comenzar gratis",
      viewPlans: "💎 Ver planes",
      familyTrust: "100k+ familias confían en nosotros"
    },

    // Estadísticas
    stats: {
      correctAnswers: "Respuestas correctas",
      unlockedLevels: "Niveles desbloqueados",
      questionsRemaining: "Preguntas restantes",
      accuracy: "Precisión",
      timeSpent: "Tiempo empleado",
      streak: "Racha de éxitos"
    },

    // Características
    features: {
      title: "Características principales",
      subtitle: "Descubre todo lo que hace de Math4Child la app #1",
      
      adaptiveAI: "IA Adaptativa",
      adaptiveDesc: "Preguntas personalizadas según tu nivel y progreso",
      
      worldLanguages: "200+ Idiomas",
      worldDesc: "Soporte multilingüe completo con todos los idiomas del mundo",
      
      progressiveLevels: "5 Niveles Progresivos",
      levelsDesc: "100 preguntas por nivel para una progresión metódica",
      
      allOperations: "Todas las Operaciones",
      operationsDesc: "Suma, resta, multiplicación, división y mixto",
      
      detailedStats: "Estadísticas Detalladas",
      statsDesc: "Sigue tu progreso con gráficos y análisis avanzados",
      
      multiPlatform: "Multi-plataforma",
      platformDesc: "Web, Android e iOS con sincronización completa"
    },

    // Niveles
    levels: {
      choose: "Elige tu nivel",
      level1: "Nivel 1 - Descubrimiento",
      level2: "Nivel 2 - Exploración",
      level3: "Nivel 3 - Dominio",
      level4: "Nivel 4 - Experto",
      level5: "Nivel 5 - Campeón",
      locked: "🔒 Bloqueado",
      unlocked: "🔓 Desbloqueado",
      completed: "✅ ¡Completado!",
      progress: "progreso",
      questionsCompleted: "preguntas completadas"
    },

    // Operaciones
    operations: {
      choose: "Elige tu operación",
      addition: "Suma",
      subtraction: "Resta",
      multiplication: "Multiplicación",
      division: "División",
      mixed: "Ejercicios Mixtos",
      
      additionDesc: "Aprende a sumar números",
      subtractionDesc: "Domina la resta",
      multiplicationDesc: "Descubre las tablas de multiplicar",
      divisionDesc: "Comprende la división",
      mixedDesc: "Practica con todos los tipos"
    },

    // Ejercicios
    exercise: {
      title: "Ejercicio",
      question: "Pregunta",
      answer: "Tu respuesta",
      validate: "Validar",
      next: "Siguiente pregunta →",
      back: "← Atrás",
      hint: "💡 Pista",
      
      // Mensajes de retroalimentación
      correct: "🎉 ¡Excelente! ¡Respuesta correcta!",
      incorrect: "🤔 No del todo, ¡inténtalo de nuevo!",
      tryAgain: "Intentar de nuevo",
      showAnswer: "Mostrar respuesta",
      answerWas: "La respuesta era:",
      
      // Progresión
      questionOf: "Pregunta {current} de {total}",
      levelProgress: "Nivel {level} - Progreso: {percent}%",
      levelComplete: "🏆 ¡Nivel completado! ¡Felicitaciones!",
      unlockNext: "Desbloquear siguiente nivel"
    },

    // Planes de precios
    pricing: {
      title: "Elige tu plan Math4Child",
      subtitle: "Desbloquea todas las características para progresar sin límites",
      
      free: "Gratis",
      premium: "Premium",
      family: "Familia",
      
      freePrice: "0€",
      premiumPrice: "4,99€",
      familyPrice: "9,99€",
      
      perMonth: "/mes",
      
      popular: "🔥 Popular",
      recommended: "⭐ Recomendado",
      
      choosePlan: "Elegir este plan",
      currentPlan: "Plan actual",
      upgrade: "Actualizar",
      
      // Características de los planes
      freeFeatures: [
        "Acceso a los primeros 2 niveles",
        "50 preguntas por día",
        "Estadísticas básicas",
        "Publicidad"
      ],
      
      premiumFeatures: [
        "✨ Todos los niveles desbloqueados",
        "🚀 Preguntas ilimitadas",
        "📊 Estadísticas avanzadas",
        "🚫 Sin publicidad",
        "💬 Soporte prioritario"
      ],
      
      familyFeatures: [
        "👨‍👩‍👧‍👦 Hasta 6 cuentas de niños",
        "✨ Todas las características Premium",
        "📈 Informes familiares detallados",
        "🔒 Controles parentales avanzados",
        "📱 Sincronización multi-dispositivo"
      ]
    },

    // Mensajes del sistema
    messages: {
      loading: "Cargando...",
      error: "Ocurrió un error",
      retry: "Reintentar",
      success: "¡Éxito!",
      
      limitReached: "Límite diario alcanzado",
      limitMessage: "¡Suscríbete para continuar sin límites!",
      
      welcome: "¡Bienvenido a Math4Child!",
      letsStart: "¡Comencemos la aventura matemática!"
    },

    // Pie de página
    footer: {
      description: "La aplicación educativa de referencia para aprender matemáticas en familia.",
      features: "Características",
      support: "Soporte",
      download: "Descargar",
      company: "Empresa",
      
      // Enlaces de características
      interactiveExercises: "Ejercicios interactivos",
      progressTracking: "Seguimiento del progreso",
      educationalGames: "Juegos educativos",
      multiPlayer: "Modo multijugador",
      
      // Enlaces de soporte
      helpCenter: "Centro de ayuda",
      contact: "Contacto",
      parentGuides: "Guías para padres",
      community: "Comunidad",
      
      // Enlaces de descarga
      appStore: "App Store",
      googlePlay: "Google Play",
      downloadOn: "Descargar en",
      
      // Enlaces de empresa
      about: "Acerca de",
      careers: "Carreras",
      press: "Prensa",
      privacy: "Privacidad",
      terms: "Términos",
      
      copyright: "© 2024 Math4Child. Todos los derechos reservados."
    }
  }
};

export const getTranslation = (language: string, key: string): string => {
  // Gérer les clés imbriquées comme "hero.title"
  const keys = key.split('.');
  let value: any = translations[language] || translations['fr'];
  
  for (const k of keys) {
    value = value?.[k];
    if (value === undefined) {
      // Fallback vers le français
      value = translations['fr'];
      for (const fallbackKey of keys) {
        value = value?.[fallbackKey];
        if (value === undefined) {
          return key; // Retourner la clé si pas trouvée
        }
      }
      break;
    }
  }
  
  return typeof value === 'string' ? value : key;
};

export const t = (language: string, key: string, params?: { [key: string]: string | number }): string => {
  let translation = getTranslation(language, key);
  
  // Remplacer les paramètres {param} dans la traduction
  if (params) {
    Object.entries(params).forEach(([paramKey, paramValue]) => {
      translation = translation.replace(new RegExp(`{${paramKey}}`, 'g'), String(paramValue));
    });
  }
  
  return translation;
};
