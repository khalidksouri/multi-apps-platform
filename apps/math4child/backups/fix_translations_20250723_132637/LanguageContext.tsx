'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// DICTIONNAIRE AVEC NOMS D'APPLICATION TRADUITS CORRECTEMENT
const translations: Record<string, Record<string, string>> = {
  fr: { 
    // Navigation et header - FRANÇAIS
    'app_name': 'Mathématiques pour Enfants',
    'app_name_short': 'Math4Enfants',
    'website': 'www.math4child.com',
    'world_leader': 'Leader mondial',
    'families_trust': '100k+ familles',
    'app_educative': 'App éducative #1 en France',
    
    // Titre principal
    'main_title': 'Mathématiques pour Enfants',
    'main_subtitle': "L'app éducative #1 pour apprendre les mathématiques en famille",
    'join_families': 'Rejoignez plus de 100.000 familles qui apprennent déjà !',
    
    // Boutons principaux
    'start_free': 'Commencer gratuitement',
    'trial_14d': '14j gratuit',
    'compare_prices': 'Comparer les prix',
    
    // Plans d'abonnement
    'plan_free': 'Gratuit',
    'plan_trial_14': 'Essai 14j',
    'plan_trial_7': 'Essai 7j',
    'plan_family': 'Plan Famille',
    
    // Fonctionnalités
    'community_support': 'Support communautaire',
    'offline_limited': 'Mode hors-ligne limité',
    'unlimited_questions': 'Questions illimitées',
    'complete_levels': '5 niveaux complets',
    'child_profiles_5': '5 profils enfants',
    'child_profiles_2': '2 profils',
    'languages_30_complete': '30+ langues complètes',
    'languages_30': '30+ langues',
    'offline_total': 'Mode hors-ligne total',
    'offline_mode': 'Mode hors-ligne',
    'student_profiles_30': '30 profils élèves',
    'teacher_dashboard': 'Tableau de bord enseignant',
    'homework_assignment': 'Assignation de devoirs',
    'detailed_reports': 'Rapports de classe détaillés',
    'family_plan_all': 'Tout du plan Famille',
    
    // Boutons d'essai
    'free_trial_14': 'Essai 14j gratuit',
    'free_trial_7': 'Essai 7j gratuit',
    'free_trial_30': 'Essai 30j gratuit',
    'start_free_btn': 'Commencer gratuitement',
    
    // Dropdown langues
    'select_language': 'Sélectionner une langue',
    'new_advanced_dropdown': 'NOUVEAU DROPDOWN AVANCÉ',
    'ultra_intelligent_search': 'RECHERCHE ULTRA-INTELLIGENTE',
    'languages_found': 'langues trouvées',
    'language_found': 'langue trouvée',
    'for_search': 'pour',
    'new_version_2024': 'NOUVELLE VERSION 2024',
    'current': 'ACTUELLE',
    'no_language_found': 'Aucune langue trouvée',
    'try_search': 'Essayez: "français", "english", "中文", "العربية"'
  },
  
  en: { 
    // Navigation and header - ENGLISH
    'app_name': 'Math for Children',
    'app_name_short': 'Math4Children',
    'website': 'www.math4child.com',
    'world_leader': 'World Leader',
    'families_trust': '100k+ families',
    'app_educative': '#1 educational app in France',
    
    // Main title
    'main_title': 'Math for Children',
    'main_subtitle': 'The #1 educational app to learn mathematics as a family',
    'join_families': 'Join over 100,000 families already learning!',
    
    // Main buttons
    'start_free': 'Start for free',
    'trial_14d': '14d free',
    'compare_prices': 'Compare prices',
    
    // Subscription plans
    'plan_free': 'Free',
    'plan_trial_14': '14-day Trial',
    'plan_trial_7': '7-day Trial',
    'plan_family': 'Family Plan',
    
    // Features
    'community_support': 'Community support',
    'offline_limited': 'Limited offline mode',
    'unlimited_questions': 'Unlimited questions',
    'complete_levels': '5 complete levels',
    'child_profiles_5': '5 child profiles',
    'child_profiles_2': '2 profiles',
    'languages_30_complete': '30+ complete languages',
    'languages_30': '30+ languages',
    'offline_total': 'Full offline mode',
    'offline_mode': 'Offline mode',
    'student_profiles_30': '30 student profiles',
    'teacher_dashboard': 'Teacher dashboard',
    'homework_assignment': 'Homework assignment',
    'detailed_reports': 'Detailed class reports',
    'family_plan_all': 'Everything in Family plan',
    
    // Trial buttons
    'free_trial_14': '14-day free trial',
    'free_trial_7': '7-day free trial',
    'free_trial_30': '30-day free trial',
    'start_free_btn': 'Start for free',
    
    // Language dropdown
    'select_language': 'Select a language',
    'new_advanced_dropdown': 'NEW ADVANCED DROPDOWN',
    'ultra_intelligent_search': 'ULTRA-INTELLIGENT SEARCH',
    'languages_found': 'languages found',
    'language_found': 'language found',
    'for_search': 'for',
    'new_version_2024': 'NEW VERSION 2024',
    'current': 'CURRENT',
    'no_language_found': 'No language found',
    'try_search': 'Try: "français", "english", "中文", "العربية"'
  },
  
  es: { 
    // Navegación y header - ESPAÑOL
    'app_name': 'Matemáticas para Niños',
    'app_name_short': 'Mate4Niños',
    'website': 'www.math4child.com',
    'world_leader': 'Líder Mundial',
    'families_trust': '100k+ familias',
    'app_educative': 'App educativa #1 en Francia',
    
    // Título principal
    'main_title': 'Matemáticas para Niños',
    'main_subtitle': 'La app educativa #1 para aprender matemáticas en familia',
    'join_families': '¡Únete a más de 100,000 familias que ya están aprendiendo!',
    
    // Botones principales
    'start_free': 'Comenzar gratis',
    'trial_14d': '14d gratis',
    'compare_prices': 'Comparar precios',
    
    // Planes de suscripción
    'plan_free': 'Gratis',
    'plan_trial_14': 'Prueba 14d',
    'plan_trial_7': 'Prueba 7d',
    'plan_family': 'Plan Familiar',
    
    // Funcionalidades
    'community_support': 'Soporte comunitario',
    'offline_limited': 'Modo sin conexión limitado',
    'unlimited_questions': 'Preguntas ilimitadas',
    'complete_levels': '5 niveles completos',
    'child_profiles_5': '5 perfiles de niños',
    'child_profiles_2': '2 perfiles',
    'languages_30_complete': '30+ idiomas completos',
    'languages_30': '30+ idiomas',
    'offline_total': 'Modo sin conexión total',
    'offline_mode': 'Modo sin conexión',
    'student_profiles_30': '30 perfiles de estudiantes',
    'teacher_dashboard': 'Panel de profesor',
    'homework_assignment': 'Asignación de tareas',
    'detailed_reports': 'Informes detallados de clase',
    'family_plan_all': 'Todo del plan Familiar',
    
    // Botones de prueba
    'free_trial_14': 'Prueba gratis 14d',
    'free_trial_7': 'Prueba gratis 7d',
    'free_trial_30': 'Prueba gratis 30d',
    'start_free_btn': 'Comenzar gratis',
    
    // Dropdown de idiomas
    'select_language': 'Seleccionar idioma',
    'new_advanced_dropdown': 'NUEVO DROPDOWN AVANZADO',
    'ultra_intelligent_search': 'BÚSQUEDA ULTRA-INTELIGENTE',
    'languages_found': 'idiomas encontrados',
    'language_found': 'idioma encontrado',
    'for_search': 'para',
    'new_version_2024': 'NUEVA VERSIÓN 2024',
    'current': 'ACTUAL',
    'no_language_found': 'Ningún idioma encontrado',
    'try_search': 'Prueba: "français", "english", "中文", "العربية"'
  },
  
  de: { 
    // Navigation und Header - DEUTSCH
    'app_name': 'Mathematik für Kinder',
    'app_name_short': 'Mathe4Kinder',
    'website': 'www.math4child.com',
    'world_leader': 'Weltmarktführer',
    'families_trust': '100k+ Familien',
    'app_educative': '#1 Bildungs-App in Frankreich',
    
    // Haupttitel
    'main_title': 'Mathematik für Kinder',
    'main_subtitle': 'Die #1 Bildungs-App zum Mathematiklernen in der Familie',
    'join_families': 'Schließe dich über 100.000 Familien an, die bereits lernen!',
    
    // Hauptbuttons
    'start_free': 'Kostenlos beginnen',
    'trial_14d': '14T kostenlos',
    'compare_prices': 'Preise vergleichen',
    
    // Abonnement-Pläne
    'plan_free': 'Kostenlos',
    'plan_trial_14': '14-Tage Test',
    'plan_trial_7': '7-Tage Test',
    'plan_family': 'Familienplan',
    
    // Funktionen
    'community_support': 'Community-Support',
    'offline_limited': 'Begrenzter Offline-Modus',
    'unlimited_questions': 'Unbegrenzte Fragen',
    'complete_levels': '5 vollständige Level',
    'child_profiles_5': '5 Kinderprofile',
    'child_profiles_2': '2 Profile',
    'languages_30_complete': '30+ vollständige Sprachen',
    'languages_30': '30+ Sprachen',
    'offline_total': 'Vollständiger Offline-Modus',
    'offline_mode': 'Offline-Modus',
    'student_profiles_30': '30 Schülerprofile',
    'teacher_dashboard': 'Lehrer-Dashboard',
    'homework_assignment': 'Hausaufgabenzuweisung',
    'detailed_reports': 'Detaillierte Klassenberichte',
    'family_plan_all': 'Alles vom Familienplan',
    
    // Test-Buttons
    'free_trial_14': '14-Tage kostenlos testen',
    'free_trial_7': '7-Tage kostenlos testen',
    'free_trial_30': '30-Tage kostenlos testen',
    'start_free_btn': 'Kostenlos beginnen',
    
    // Sprachen-Dropdown
    'select_language': 'Sprache wählen',
    'new_advanced_dropdown': 'NEUES ERWEITERTES DROPDOWN',
    'ultra_intelligent_search': 'ULTRA-INTELLIGENTE SUCHE',
    'languages_found': 'Sprachen gefunden',
    'language_found': 'Sprache gefunden',
    'for_search': 'für',
    'new_version_2024': 'NEUE VERSION 2024',
    'current': 'AKTUELL',
    'no_language_found': 'Keine Sprache gefunden',
    'try_search': 'Versuche: "français", "english", "中文", "العربية"'
  },
  
  it: { 
    // Navigazione e header - ITALIANO
    'app_name': 'Matematica per Bambini',
    'app_name_short': 'Mate4Bambini',
    'website': 'www.math4child.com',
    'world_leader': 'Leader Mondiale',
    'families_trust': '100k+ famiglie',
    'app_educative': 'App educativa #1 in Francia',
    
    // Titolo principale
    'main_title': 'Matematica per Bambini',
    'main_subtitle': "L'app educativa #1 per imparare la matematica in famiglia",
    'join_families': 'Unisciti a oltre 100.000 famiglie che stanno già imparando!',
    
    // Pulsanti principali
    'start_free': 'Inizia gratis',
    'trial_14d': '14g gratis',
    'compare_prices': 'Confronta prezzi',
    
    // Piani di abbonamento
    'plan_free': 'Gratuito',
    'plan_trial_14': 'Prova 14g',
    'plan_trial_7': 'Prova 7g',
    'plan_family': 'Piano Famiglia',
    
    // Funzionalità
    'community_support': 'Supporto della community',
    'offline_limited': 'Modalità offline limitata',
    'unlimited_questions': 'Domande illimitate',
    'complete_levels': '5 livelli completi',
    'child_profiles_5': '5 profili bambini',
    'child_profiles_2': '2 profili',
    'languages_30_complete': '30+ lingue complete',
    'languages_30': '30+ lingue',
    'offline_total': 'Modalità offline totale',
    'offline_mode': 'Modalità offline',
    'student_profiles_30': '30 profili studenti',
    'teacher_dashboard': 'Dashboard insegnante',
    'homework_assignment': 'Assegnazione compiti',
    'detailed_reports': 'Report dettagliati della classe',
    'family_plan_all': 'Tutto del piano Famiglia',
    
    // Pulsanti di prova
    'free_trial_14': 'Prova gratuita 14g',
    'free_trial_7': 'Prova gratuita 7g',
    'free_trial_30': 'Prova gratuita 30g',
    'start_free_btn': 'Inizia gratis',
    
    // Dropdown lingue
    'select_language': 'Seleziona lingua',
    'new_advanced_dropdown': 'NUOVO DROPDOWN AVANZATO',
    'ultra_intelligent_search': 'RICERCA ULTRA-INTELLIGENTE',
    'languages_found': 'lingue trovate',
    'language_found': 'lingua trovata',
    'for_search': 'per',
    'new_version_2024': 'NUOVA VERSIONE 2024',
    'current': 'ATTUALE',
    'no_language_found': 'Nessuna lingua trovata',
    'try_search': 'Prova: "français", "english", "中文", "العربية"'
  },
  
  pt: { 
    // Navegação e header - PORTUGUÊS
    'app_name': 'Matemática para Crianças',
    'app_name_short': 'Mate4Crianças',
    'website': 'www.math4child.com',
    'world_leader': 'Líder Mundial',
    'families_trust': '100k+ famílias',
    'app_educative': 'App educativo #1 na França',
    
    // Título principal
    'main_title': 'Matemática para Crianças',
    'main_subtitle': 'O app educativo #1 para aprender matemática em família',
    'join_families': 'Junte-se a mais de 100.000 famílias que já estão aprendendo!',
    
    // Botões principais
    'start_free': 'Começar grátis',
    'trial_14d': '14d grátis',
    'compare_prices': 'Comparar preços',
    
    // Planos de assinatura
    'plan_free': 'Gratuito',
    'plan_trial_14': 'Teste 14d',
    'plan_trial_7': 'Teste 7d',
    'plan_family': 'Plano Família',
    
    // Funcionalidades
    'community_support': 'Suporte da comunidade',
    'offline_limited': 'Modo offline limitado',
    'unlimited_questions': 'Perguntas ilimitadas',
    'complete_levels': '5 níveis completos',
    'child_profiles_5': '5 perfis de crianças',
    'child_profiles_2': '2 perfis',
    'languages_30_complete': '30+ idiomas completos',
    'languages_30': '30+ idiomas',
    'offline_total': 'Modo offline total',
    'offline_mode': 'Modo offline',
    'student_profiles_30': '30 perfis de estudantes',
    'teacher_dashboard': 'Painel do professor',
    'homework_assignment': 'Atribuição de lições',
    'detailed_reports': 'Relatórios detalhados da turma',
    'family_plan_all': 'Tudo do plano Família',
    
    // Botões de teste
    'free_trial_14': 'Teste grátis 14d',
    'free_trial_7': 'Teste grátis 7d',
    'free_trial_30': 'Teste grátis 30d',
    'start_free_btn': 'Começar grátis',
    
    // Dropdown de idiomas
    'select_language': 'Selecionar idioma',
    'new_advanced_dropdown': 'NOVO DROPDOWN AVANÇADO',
    'ultra_intelligent_search': 'PESQUISA ULTRA-INTELIGENTE',
    'languages_found': 'idiomas encontrados',
    'language_found': 'idioma encontrado',
    'for_search': 'para',
    'new_version_2024': 'NOVA VERSÃO 2024',
    'current': 'ATUAL',
    'no_language_found': 'Nenhum idioma encontrado',
    'try_search': 'Tente: "français", "english", "中文", "العربية"'
  },
  
  ar: { 
    // التنقل والرأس - العربية
    'app_name': 'الرياضيات للأطفال',
    'app_name_short': 'رياضيات4أطفال',
    'website': 'www.math4child.com',
    'world_leader': 'الرائد عالمياً',
    'families_trust': '100k+ عائلة',
    'app_educative': 'التطبيق التعليمي #1 في فرنسا',
    
    // العنوان الرئيسي
    'main_title': 'الرياضيات للأطفال',
    'main_subtitle': 'التطبيق التعليمي #1 لتعلم الرياضيات في العائلة',
    'join_families': 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!',
    
    // الأزرار الرئيسية
    'start_free': 'ابدأ مجاناً',
    'trial_14d': '14 يوم مجاني',
    'compare_prices': 'قارن الأسعار',
    
    // خطط الاشتراك
    'plan_free': 'مجاني',
    'plan_trial_14': 'تجربة 14 يوم',
    'plan_trial_7': 'تجربة 7 أيام',
    'plan_family': 'خطة العائلة',
    
    // الميزات
    'community_support': 'دعم المجتمع',
    'offline_limited': 'وضع عدم الاتصال محدود',
    'unlimited_questions': 'أسئلة غير محدودة',
    'complete_levels': '5 مستويات كاملة',
    'child_profiles_5': '5 ملفات أطفال',
    'child_profiles_2': 'ملفان',
    'languages_30_complete': '30+ لغة كاملة',
    'languages_30': '30+ لغة',
    'offline_total': 'وضع عدم الاتصال الكامل',
    'offline_mode': 'وضع عدم الاتصال',
    'student_profiles_30': '30 ملف طالب',
    'teacher_dashboard': 'لوحة المعلم',
    'homework_assignment': 'تعيين الواجبات',
    'detailed_reports': 'تقارير مفصلة للفصل',
    'family_plan_all': 'كل شيء من خطة العائلة',
    
    // أزرار التجربة
    'free_trial_14': 'تجربة مجانية 14 يوم',
    'free_trial_7': 'تجربة مجانية 7 أيام',
    'free_trial_30': 'تجربة مجانية 30 يوم',
    'start_free_btn': 'ابدأ مجاناً',
    
    // قائمة اللغات
    'select_language': 'اختر اللغة',
    'new_advanced_dropdown': 'قائمة متقدمة جديدة',
    'ultra_intelligent_search': 'بحث فائق الذكاء',
    'languages_found': 'لغة وجدت',
    'language_found': 'لغة وجدت',
    'for_search': 'لـ',
    'new_version_2024': 'نسخة جديدة 2024',
    'current': 'الحالية',
    'no_language_found': 'لم توجد لغة',
    'try_search': 'جرب: "français", "english", "中文", "العربية"'
  }
}

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    } else {
      const browserLang = navigator.language.split('-')[0]
      if (translations[browserLang]) {
        setCurrentLanguage(browserLang)
      }
    }
  }, [])

  const setLanguage = (lang: string) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child-language', lang)
    
    console.log('🌍 Langue changée vers:', lang)
    console.log('📱 Nouveau nom app:', translations[lang]?.['app_name'] || 'Math4Child')
    
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
  }

  const t = (key: string): string => {
    const translation = translations[currentLanguage]?.[key] || translations['en']?.[key] || key
    return translation
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
