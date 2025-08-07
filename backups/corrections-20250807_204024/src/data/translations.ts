export interface Translation {
  [key: string]: string | { [key: string]: string };
}

export const translations: { [language: string]: Translation } = {
  fr: {
    navigation: {
      home: "Accueil",
      exercises: "Exercices", 
      profile: "Profil",
      pricing: "Plans",
      about: "À propos"
    },
    homepage: {
      appBadge: "App éducative n°1 en France",
      title: "Apprends les maths en t'amusant !",
      subtitle: "L'application éducative révolutionnaire",
      description: "Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau",
      startFree: "🚀 Commencer gratuitement",
      viewPlans: "💎 Voir les plans",
      freeTrial: "14j gratuit",
      comparePrices: "Comparer les prix",
      families: "100k+ familles nous font confiance",
      joinMessage: "Rejoins plus de 100 000 familles qui apprennent déjà !",
      languageSelector: "Choisir une langue",
      searchLanguage: "Rechercher une langue...",
      noLanguageFound: "Aucune langue trouvée",
      popularLanguages: "Langues populaires"
    },
    plans: {
      title: "Plans optimaux",
      subtitle: "Plus compétitifs que tous les concurrents",
      monthly: "Mensuel",
      quarterly: "Trimestriel", 
      yearly: "Annuel",
      save: "Économisez",
      discount10: "-10%",
      discount30: "-30%",
      profiles: "profils",
      mostPopular: "Le plus populaire",
      recommended: "Recommandé",
      choosePlan: "Choisir ce plan",
      freeTrial: "Essai gratuit"
    },
    planPremium: {
      name: "Premium",
      description: "Le plus choisi",
      features: [
        "Questions illimitées",
        "5 niveaux complets",
        "3 profils enfants",
        "30+ langues",
        "Mode hors-ligne",
        "Support prioritaire"
      ],
      button: "Essai 7j gratuit",
      trial: "7j gratuit"
    },
    planFamily: {
      name: "Famille",
      description: "Idéal pour toute la famille",
      features: [
        "Questions illimitées",
        "5 niveaux complets", 
        "5 profils enfants",
        "30+ langues complètes",
        "Rapports parents",
        "Support VIP"
      ],
      button: "Essai 14j gratuit",
      trial: "14j gratuit"
    },
    modal: {
      close: "Fermer",
      cancel: "Annuler",
      confirm: "Confirmer",
      selectLanguage: "Sélectionner une langue",
      searchPlaceholder: "Rechercher une langue...",
      noResults: "Aucun résultat trouvé",
      loading: "Chargement...",
      error: "Une erreur s'est produite",
      success: "Succès !"
    }
  },
  en: {
    navigation: {
      home: "Home",
      exercises: "Exercises",
      profile: "Profile", 
      pricing: "Plans",
      about: "About"
    },
    homepage: {
      appBadge: "#1 Educational App in France",
      title: "Learn math while having fun!",
      subtitle: "The revolutionary educational application",
      description: "Develop your math skills with progressive and fun exercises adapted to your level",
      startFree: "🚀 Start for free",
      viewPlans: "💎 View plans",
      freeTrial: "14d free",
      comparePrices: "Compare prices",
      families: "100k+ families trust us",
      joinMessage: "Join over 100,000 families already learning!",
      languageSelector: "Choose a language",
      searchLanguage: "Search for a language...",
      noLanguageFound: "No language found",
      popularLanguages: "Popular languages"
    },
    plans: {
      title: "Optimal plans",
      subtitle: "More competitive than all competitors",
      monthly: "Monthly",
      quarterly: "Quarterly",
      yearly: "Yearly", 
      save: "Save",
      discount10: "-10%",
      discount30: "-30%",
      profiles: "profiles",
      mostPopular: "Most popular",
      recommended: "Recommended",
      choosePlan: "Choose this plan",
      freeTrial: "Free trial"
    },
    planPremium: {
      name: "Premium", 
      description: "Most chosen",
      features: [
        "Unlimited questions",
        "5 complete levels",
        "3 child profiles",
        "30+ languages",
        "Offline mode",
        "Priority support"
      ],
      button: "7d free trial",
      trial: "7d free"
    },
    planFamily: {
      name: "Family",
      description: "Ideal for the whole family",
      features: [
        "Unlimited questions",
        "5 complete levels",
        "5 child profiles", 
        "30+ complete languages",
        "Parent reports",
        "VIP support"
      ],
      button: "14d free trial",
      trial: "14d free"
    },
    modal: {
      close: "Close",
      cancel: "Cancel",
      confirm: "Confirm",
      selectLanguage: "Select a language",
      searchPlaceholder: "Search for a language...",
      noResults: "No results found",
      loading: "Loading...",
      error: "An error occurred", 
      success: "Success!"
    }
  },
  es: {
    navigation: {
      home: "Inicio",
      exercises: "Ejercicios",
      profile: "Perfil",
      pricing: "Planes", 
      about: "Acerca de"
    },
    homepage: {
      appBadge: "App educativa #1 en Francia",
      title: "¡Aprende matemáticas divirtiéndote!",
      subtitle: "La aplicación educativa revolucionaria",
      description: "Desarrolla tus habilidades matemáticas con ejercicios progresivos y divertidos adaptados a tu nivel",
      startFree: "🚀 Empezar gratis",
      viewPlans: "💎 Ver planes",
      freeTrial: "14d gratis",
      comparePrices: "Comparar precios",
      families: "100k+ familias confían en nosotros",
      joinMessage: "¡Únete a más de 100,000 familias que ya están aprendiendo!",
      languageSelector: "Elegir un idioma",
      searchLanguage: "Buscar un idioma...",
      noLanguageFound: "No se encontró idioma",
      popularLanguages: "Idiomas populares"
    },
    plans: {
      title: "Planes óptimos",
      subtitle: "Más competitivos que todos los competidores",
      monthly: "Mensual",
      quarterly: "Trimestral",
      yearly: "Anual",
      save: "Ahorra",
      discount10: "-10%",
      discount30: "-30%",
      profiles: "perfiles", 
      mostPopular: "Más popular",
      recommended: "Recomendado",
      choosePlan: "Elegir este plan",
      freeTrial: "Prueba gratuita"
    },
    planPremium: {
      name: "Premium",
      description: "El más elegido",
      features: [
        "Preguntas ilimitadas",
        "5 niveles completos",
        "3 perfiles infantiles", 
        "30+ idiomas",
        "Modo sin conexión",
        "Soporte prioritario"
      ],
      button: "Prueba 7d gratis",
      trial: "7d gratis"
    },
    planFamily: {
      name: "Familia",
      description: "Ideal para toda la familia",
      features: [
        "Preguntas ilimitadas",
        "5 niveles completos",
        "5 perfiles infantiles",
        "30+ idiomas completos",
        "Informes para padres",
        "Soporte VIP"
      ],
      button: "Prueba 14d gratis",
      trial: "14d gratis"
    },
    modal: {
      close: "Cerrar",
      cancel: "Cancelar",
      confirm: "Confirmar",
      selectLanguage: "Seleccionar un idioma",
      searchPlaceholder: "Buscar un idioma...",
      noResults: "No se encontraron resultados",
      loading: "Cargando...",
      error: "Ocurrió un error",
      success: "¡Éxito!"
    }
  },
  ar: {
    navigation: {
      home: "الرئيسية",
      exercises: "التمارين",
      profile: "الملف الشخصي",
      pricing: "الخطط", 
      about: "حول"
    },
    homepage: {
      appBadge: "التطبيق التعليمي رقم 1 في فرنسا",
      title: "تعلم الرياضيات بالمرح!",
      subtitle: "التطبيق التعليمي الثوري",
      description: "طور مهاراتك الرياضية بتمارين متدرجة وممتعة مناسبة لمستواك",
      startFree: "🚀 ابدأ مجاناً",
      viewPlans: "💎 عرض الخطط",
      freeTrial: "14 يوم مجاني",
      comparePrices: "قارن الأسعار",
      families: "100k+ عائلة تثق بنا",
      joinMessage: "انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!",
      languageSelector: "اختر لغة",
      searchLanguage: "البحث عن لغة...",
      noLanguageFound: "لم يتم العثور على لغة",
      popularLanguages: "اللغات الشائعة"
    },
    plans: {
      title: "الخطط المثلى",
      subtitle: "أكثر تنافسية من جميع المنافسين",
      monthly: "شهري",
      quarterly: "ربع سنوي",
      yearly: "سنوي",
      save: "وفر",
      discount10: "-10%", 
      discount30: "-30%",
      profiles: "ملفات شخصية",
      mostPopular: "الأكثر شعبية",
      recommended: "موصى به",
      choosePlan: "اختر هذه الخطة",
      freeTrial: "تجربة مجانية"
    },
    planPremium: {
      name: "مميز",
      description: "الأكثر اختياراً",
      features: [
        "أسئلة غير محدودة",
        "5 مستويات كاملة",
        "3 ملفات شخصية للأطفال",
        "30+ لغة", 
        "وضع عدم الاتصال",
        "دعم متقدم"
      ],
      button: "تجربة 7 أيام مجانية",
      trial: "7 أيام مجانية"
    },
    planFamily: {
      name: "عائلة",
      description: "مثالي للعائلة كلها",
      features: [
        "أسئلة غير محدودة",
        "5 مستويات كاملة",
        "5 ملفات شخصية للأطفال",
        "30+ لغة كاملة",
        "تقارير الآباء",
        "دعم VIP"
      ],
      button: "تجربة 14 يوماً مجانية",
      trial: "14 يوماً مجانية"
    },
    modal: {
      close: "إغلاق",
      cancel: "إلغاء",
      confirm: "تأكيد",
      selectLanguage: "اختر لغة",
      searchPlaceholder: "البحث عن لغة...",
      noResults: "لا توجد نتائج",
      loading: "جاري التحميل...",
      error: "حدث خطأ",
      success: "نجح!"
    }
  }
};

export const getTranslation = (language: string, key: string): string => {
  const keys = key.split('.');
  let translation: any = translations[language] || translations.fr;
  
  for (const k of keys) {
    translation = translation[k];
    if (!translation) {
      translation = translations.fr;
      for (const fallbackKey of keys) {
        translation = translation[fallbackKey];
        if (!translation) return key;
      }
      break;
    }
  }
  
  return typeof translation === 'string' ? translation : key;
};

export const isRTLLanguage = (language: string): boolean => {
  return ['ar', 'he', 'fa', 'ur'].includes(language);
};

export const getSupportedLanguages = (): string[] => {
  return Object.keys(translations);
};
