// ===================================================================
// DONNÉES DE TEST POUR MATH4CHILD
// Données statiques et configurations
// ===================================================================

import { Level, MathOperation, SupportedLanguage } from './test-utils';

export const TEST_DATA = {
  // Progressions utilisateur de test
  progressions: {
    newUser: {
      level: 'beginner' as Level,
      correctAnswers: { beginner: 0, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner'] as Level[],
      totalQuestions: 0,
      freeQuestionsUsed: 0
    },
    
    beginnerComplete: {
      level: 'elementary' as Level,
      correctAnswers: { beginner: 100, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner', 'elementary'] as Level[],
      totalQuestions: 150,
      freeQuestionsUsed: 50
    },
    
    intermediateUser: {
      level: 'intermediate' as Level,
      correctAnswers: { beginner: 100, elementary: 100, intermediate: 45, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner', 'elementary', 'intermediate'] as Level[],
      totalQuestions: 300,
      freeQuestionsUsed: 50
    },
    
    expertUser: {
      level: 'expert' as Level,
      correctAnswers: { beginner: 100, elementary: 100, intermediate: 100, advanced: 100, expert: 75 },
      unlockedLevels: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'] as Level[],
      totalQuestions: 1000,
      freeQuestionsUsed: 50
    },

    freeUserLimitReached: {
      level: 'beginner' as Level,
      correctAnswers: { beginner: 25, elementary: 0, intermediate: 0, advanced: 0, expert: 0 },
      unlockedLevels: ['beginner'] as Level[],
      totalQuestions: 50,
      freeQuestionsUsed: 50
    }
  },

  // Problèmes mathématiques de test
  mathProblems: {
    addition: [
      { num1: 2, num2: 3, answer: 5, level: 'beginner' },
      { num1: 15, num2: 27, answer: 42, level: 'elementary' },
      { num1: 89, num2: 156, answer: 245, level: 'intermediate' }
    ],
    
    subtraction: [
      { num1: 8, num2: 3, answer: 5, level: 'beginner' },
      { num1: 45, num2: 17, answer: 28, level: 'elementary' },
      { num1: 234, num2: 89, answer: 145, level: 'intermediate' }
    ],
    
    multiplication: [
      { num1: 3, num2: 4, answer: 12, level: 'beginner' },
      { num1: 12, num2: 8, answer: 96, level: 'elementary' },
      { num1: 23, num2: 15, answer: 345, level: 'intermediate' }
    ],
    
    division: [
      { num1: 12, num2: 3, answer: 4, level: 'beginner' },
      { num1: 84, num2: 7, answer: 12, level: 'elementary' },
      { num1: 144, num2: 12, answer: 12, level: 'intermediate' }
    ]
  },

  // Données d'abonnement
  subscriptionPlans: {
    free: {
      name: 'Free Version',
      price: 0,
      duration: '7 days - 50 questions',
      features: ['50 total questions', 'All levels limited', 'Email support', '7-day access']
    },
    
    monthly: {
      name: 'Monthly',
      price: 9.99,
      duration: 'per month',
      features: ['Unlimited questions', 'All levels unlocked', 'All operations', 'Priority support']
    },
    
    quarterly: {
      name: 'Quarterly',
      price: 26.97,
      originalPrice: 29.97,
      discount: 10,
      popular: true,
      duration: '3 months',
      features: ['Everything in monthly', '10% discount', 'Single payment', 'Premium support']
    },
    
    yearly: {
      name: 'Yearly',
      price: 83.93,
      originalPrice: 119.88,
      discount: 30,
      duration: '12 months',
      features: ['Everything in monthly', '30% discount', 'Single payment', 'VIP support']
    }
  },

  // Textes multilingues pour validation
  translations: {
    titles: {
      en: 'Math4Child - Learn math while having fun',
      fr: 'Math4Child - Apprendre les mathématiques en s\'amusant',
      es: 'Math4Child - Aprende matemáticas divirtiéndote',
      de: 'Math4Child - Mathematik lernen macht Spaß',
      ar: 'Math4Child - تعلم الرياضيات بمتعة',
      zh: 'Math4Child - 快乐学数学'
    } as Record<SupportedLanguage, string>,
    
    operations: {
      en: ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Mixed'],
      fr: ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Mixte'],
      es: ['Suma', 'Resta', 'Multiplicación', 'División', 'Mixto'],
      de: ['Addition', 'Subtraktion', 'Multiplikation', 'Division', 'Gemischt'],
      ar: ['جمع', 'طرح', 'ضرب', 'قسمة', 'مختلط'],
      zh: ['加法', '减法', '乘法', '除法', '混合']
    } as Record<SupportedLanguage, string[]>,
    
    levels: {
      en: ['Beginner', 'Elementary', 'Intermediate', 'Advanced', 'Expert'],
      fr: ['Débutant', 'Élémentaire', 'Intermédiaire', 'Avancé', 'Expert'],
      es: ['Principiante', 'Elemental', 'Intermedio', 'Avanzado', 'Experto'],
      de: ['Anfänger', 'Grundstufe', 'Mittelstufe', 'Fortgeschritten', 'Experte'],
      ar: ['مبتدئ', 'ابتدائي', 'متوسط', 'متقدم', 'خبير'],
      zh: ['初级', '小学', '中级', '高级', '专家']
    } as Record<SupportedLanguage, string[]>
  }
};

// Configuration des environnements
export const ENV_CONFIG = {
  // URLs par environnement
  urls: {
    development: 'http://localhost:3000',
    staging: 'https://staging.math4child.com',
    production: 'https://www.math4child.com'
  },

  // Timeouts par environnement
  timeouts: {
    development: { page: 30000, element: 15000 },
    ci: { page: 60000, element: 30000 },
    production: { page: 45000, element: 20000 }
  },

  // Configuration des navigateurs
  browsers: {
    desktop: ['chromium', 'firefox', 'webkit'],
    mobile: ['chromium', 'webkit'],
    ci: ['chromium']
  }
};

// Utilitaires de validation
export class ValidationHelpers {
  static async validateMathProblem(problemText: string): Promise<boolean> {
    const patterns = [
      /\d+\s*\+\s*\d+\s*=\s*\?/,  // Addition
      /\d+\s*-\s*\d+\s*=\s*\?/,   // Soustraction  
      /\d+\s*[×*]\s*\d+\s*=\s*\?/, // Multiplication
      /\d+\s*[÷/]\s*\d+\s*=\s*\?/  // Division
    ];
    
    return patterns.some(pattern => pattern.test(problemText));
  }

  static validateLanguageContent(content: string, language: SupportedLanguage): boolean {
    const config = TEST_DATA.translations;
    const title = config.titles[language];
    
    if (!title) return false;
    
    return content.toLowerCase().includes(title.split(' - ')[0].toLowerCase()) ||
           content.toLowerCase().includes(language);
  }

  static validateProgressionData(data: any): boolean {
    const required = ['level', 'correctAnswers', 'unlockedLevels', 'totalQuestions'];
    return required.every(field => field in data);
  }

  static validateSubscriptionPlan(plan: any): boolean {
    const required = ['name', 'price', 'features'];
    return required.every(field => field in plan) && Array.isArray(plan.features);
  }
}
