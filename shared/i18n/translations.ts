import { Translation, SupportedLanguage } from './types/translations';

export const translations: Record<SupportedLanguage, Translation> = {
  fr: {
    appName: 'Multi-Apps Platform',
    appFullName: 'Multi-Apps Platform - Écosystème d\'Applications',
    tagline: 'Votre suite d\'applications tout-en-un',
    
    navigation: {
      home: 'Accueil',
      apps: 'Applications',
      pricing: 'Tarifs',
      about: 'À propos',
      contact: 'Contact'
    },
    
    apps: {
      postmath: 'PostMath Pro - Calculatrice Avancée',
      unitflip: 'UnitFlip Pro - Convertisseur d\'Unités',
      budgetcron: 'BudgetCron - Gestionnaire de Budget',
      ai4kids: 'AI4Kids - Apprentissage Interactif',
      multiai: 'MultiAI - Recherche Intelligente'
    },
    
    interface: {
      selectLanguage: 'Choisir la langue',
      loading: 'Chargement...',
      error: 'Erreur',
      success: 'Succès',
      tryAgain: 'Réessayer',
      save: 'Sauvegarder',
      cancel: 'Annuler',
      confirm: 'Confirmer'
    },
    
    pricing: {
      choosePlan: 'Choisir un plan',
      monthly: 'Mensuel',
      yearly: 'Annuel',
      free: 'Gratuit',
      premium: 'Premium',
      enterprise: 'Entreprise'
    }
  },

  en: {
    appName: 'Multi-Apps Platform',
    appFullName: 'Multi-Apps Platform - Application Ecosystem',
    tagline: 'Your all-in-one application suite',
    
    navigation: {
      home: 'Home',
      apps: 'Applications',
      pricing: 'Pricing',
      about: 'About',
      contact: 'Contact'
    },
    
    apps: {
      postmath: 'PostMath Pro - Advanced Calculator',
      unitflip: 'UnitFlip Pro - Unit Converter',
      budgetcron: 'BudgetCron - Budget Manager',
      ai4kids: 'AI4Kids - Interactive Learning',
      multiai: 'MultiAI - Smart Search'
    },
    
    interface: {
      selectLanguage: 'Select language',
      loading: 'Loading...',
      error: 'Error',
      success: 'Success',
      tryAgain: 'Try again',
      save: 'Save',
      cancel: 'Cancel',
      confirm: 'Confirm'
    },
    
    pricing: {
      choosePlan: 'Choose a plan',
      monthly: 'Monthly',
      yearly: 'Yearly',
      free: 'Free',
      premium: 'Premium',
      enterprise: 'Enterprise'
    }
  },

  ar: {
    appName: 'منصة التطبيقات المتعددة',
    appFullName: 'منصة التطبيقات المتعددة - نظام بيئي للتطبيقات',
    tagline: 'مجموعة تطبيقاتك الشاملة',
    
    navigation: {
      home: 'الرئيسية',
      apps: 'التطبيقات',
      pricing: 'الأسعار',
      about: 'حول',
      contact: 'اتصل بنا'
    },
    
    apps: {
      postmath: 'PostMath Pro - حاسبة متقدمة',
      unitflip: 'UnitFlip Pro - محول الوحدات',
      budgetcron: 'BudgetCron - مدير الميزانية',
      ai4kids: 'AI4Kids - التعلم التفاعلي',
      multiai: 'MultiAI - البحث الذكي'
    },
    
    interface: {
      selectLanguage: 'اختيار اللغة',
      loading: 'جاري التحميل...',
      error: 'خطأ',
      success: 'نجح',
      tryAgain: 'حاول مرة أخرى',
      save: 'حفظ',
      cancel: 'إلغاء',
      confirm: 'تأكيد'
    },
    
    pricing: {
      choosePlan: 'اختيار خطة',
      monthly: 'شهري',
      yearly: 'سنوي',
      free: 'مجاني',
      premium: 'مميز',
      enterprise: 'المؤسسات'
    }
  },

  // Les 17 autres langues suivent le même pattern...
  // Pour l'exemple, ajoutons les traductions principales
  es: {
    appName: 'Plataforma Multi-Apps',
    appFullName: 'Plataforma Multi-Apps - Ecosistema de Aplicaciones',
    tagline: 'Tu suite de aplicaciones todo-en-uno',
    
    navigation: { home: 'Inicio', apps: 'Aplicaciones', pricing: 'Precios', about: 'Acerca de', contact: 'Contacto' },
    apps: { postmath: 'PostMath Pro - Calculadora Avanzada', unitflip: 'UnitFlip Pro - Conversor de Unidades', budgetcron: 'BudgetCron - Gestor de Presupuesto', ai4kids: 'AI4Kids - Aprendizaje Interactivo', multiai: 'MultiAI - Búsqueda Inteligente' },
    interface: { selectLanguage: 'Seleccionar idioma', loading: 'Cargando...', error: 'Error', success: 'Éxito', tryAgain: 'Intentar de nuevo', save: 'Guardar', cancel: 'Cancelar', confirm: 'Confirmar' },
    pricing: { choosePlan: 'Elegir plan', monthly: 'Mensual', yearly: 'Anual', free: 'Gratis', premium: 'Premium', enterprise: 'Empresarial' }
  },

  // Placeholders pour les autres langues (de, it, pt, nl, ru, zh, ja, ko, hi, th, vi, he, fa, sv, tr, pl)
  de: {} as Translation,
  it: {} as Translation,
  pt: {} as Translation,
  nl: {} as Translation,
  ru: {} as Translation,
  zh: {} as Translation,
  ja: {} as Translation,
  ko: {} as Translation,
  hi: {} as Translation,
  th: {} as Translation,
  vi: {} as Translation,
  he: {} as Translation,
  fa: {} as Translation,
  sv: {} as Translation,
  tr: {} as Translation,
  pl: {} as Translation
};
