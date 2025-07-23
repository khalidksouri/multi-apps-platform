'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// DICTIONNAIRE AVEC TOUTES LES TRADUCTIONS (Y COMPRIS JP, ZH, KO, HI)
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
  },

  // ============================================================================
  // 🇯🇵 JAPONAIS - NOUVELLES TRADUCTIONS COMPLÈTES
  // ============================================================================
  ja: {
    // ナビゲーションとヘッダー - 日本語
    'app_name': '子供の数学',
    'app_name_short': '数学4子供',
    'website': 'www.math4child.com',
    'world_leader': '世界のリーダー',
    'families_trust': '100k+家族',
    'app_educative': 'フランス#1教育アプリ',
    
    // メインタイトル
    'main_title': '子供の数学',
    'main_subtitle': '家族で数学を学ぶ#1教育アプリ',
    'join_families': 'すでに学習中の100,000以上の家族に参加しよう！',
    
    // メインボタン
    'start_free': '無料で始める',
    'trial_14d': '14日無料',
    'compare_prices': '価格を比較',
    
    // サブスクリプションプラン
    'plan_free': '無料',
    'plan_trial_14': '14日試用',
    'plan_trial_7': '7日試用',
    'plan_family': 'ファミリープラン',
    
    // 機能
    'community_support': 'コミュニティサポート',
    'offline_limited': '限定オフラインモード',
    'unlimited_questions': '無制限の質問',
    'complete_levels': '5つの完全レベル',
    'child_profiles_5': '5つの子供プロフィール',
    'child_profiles_2': '2つのプロフィール',
    'languages_30_complete': '30+完全言語',
    'languages_30': '30+言語',
    'offline_total': '完全オフラインモード',
    'offline_mode': 'オフラインモード',
    'student_profiles_30': '30の学生プロフィール',
    'teacher_dashboard': '教師ダッシュボード',
    'homework_assignment': '宿題の割り当て',
    'detailed_reports': '詳細なクラスレポート',
    'family_plan_all': 'ファミリープランのすべて',
    
    // 試用ボタン
    'free_trial_14': '14日無料試用',
    'free_trial_7': '7日無料試用',
    'free_trial_30': '30日無料試用',
    'start_free_btn': '無料で始める',
    
    // 言語ドロップダウン
    'select_language': '言語を選択',
    'new_advanced_dropdown': '新しい高度なドロップダウン',
    'ultra_intelligent_search': '超インテリジェント検索',
    'languages_found': '言語が見つかりました',
    'language_found': '言語が見つかりました',
    'for_search': 'の検索',
    'new_version_2024': '新しいバージョン2024',
    'current': '現在',
    'no_language_found': '言語が見つかりません',
    'try_search': '試してみる: "français", "english", "中文", "العربية"'
  },

  // ============================================================================
  // 🇨🇳 CHINOIS - NOUVELLES TRADUCTIONS COMPLÈTES
  // ============================================================================
  zh: {
    // 导航和标题 - 中文
    'app_name': '儿童数学',
    'app_name_short': '数学4儿童',
    'website': 'www.math4child.com',
    'world_leader': '世界领导者',
    'families_trust': '100k+家庭',
    'app_educative': '法国#1教育应用',
    
    // 主要标题
    'main_title': '儿童数学',
    'main_subtitle': '家庭学习数学的#1教育应用',
    'join_families': '加入已经在学习的100,000+家庭！',
    
    // 主要按钮
    'start_free': '免费开始',
    'trial_14d': '14天免费',
    'compare_prices': '比较价格',
    
    // 订阅计划
    'plan_free': '免费',
    'plan_trial_14': '14天试用',
    'plan_trial_7': '7天试用',
    'plan_family': '家庭计划',
    
    // 功能
    'community_support': '社区支持',
    'offline_limited': '有限离线模式',
    'unlimited_questions': '无限问题',
    'complete_levels': '5个完整级别',
    'child_profiles_5': '5个儿童档案',
    'child_profiles_2': '2个档案',
    'languages_30_complete': '30+完整语言',
    'languages_30': '30+语言',
    'offline_total': '完全离线模式',
    'offline_mode': '离线模式',
    'student_profiles_30': '30个学生档案',
    'teacher_dashboard': '教师仪表板',
    'homework_assignment': '作业分配',
    'detailed_reports': '详细班级报告',
    'family_plan_all': '家庭计划的一切',
    
    // 试用按钮
    'free_trial_14': '14天免费试用',
    'free_trial_7': '7天免费试用',
    'free_trial_30': '30天免费试用',
    'start_free_btn': '免费开始',
    
    // 语言下拉菜单
    'select_language': '选择语言',
    'new_advanced_dropdown': '新的高级下拉菜单',
    'ultra_intelligent_search': '超智能搜索',
    'languages_found': '找到的语言',
    'language_found': '找到的语言',
    'for_search': '搜索',
    'new_version_2024': '新版本2024',
    'current': '当前',
    'no_language_found': '未找到语言',
    'try_search': '试试: "français", "english", "中文", "العربية"'
  },

  // ============================================================================
  // 🇰🇷 CORÉEN - NOUVELLES TRADUCTIONS COMPLÈTES
  // ============================================================================
  ko: {
    // 내비게이션 및 헤더 - 한국어
    'app_name': '어린이 수학',
    'app_name_short': '수학4어린이',
    'website': 'www.math4child.com',
    'world_leader': '세계 리더',
    'families_trust': '100k+가족',
    'app_educative': '프랑스 #1 교육 앱',
    
    // 메인 제목
    'main_title': '어린이 수학',
    'main_subtitle': '가족과 함께 수학을 배우는 #1 교육 앱',
    'join_families': '이미 학습 중인 100,000+가족에 참여하세요!',
    
    // 메인 버튼
    'start_free': '무료로 시작',
    'trial_14d': '14일 무료',
    'compare_prices': '가격 비교',
    
    // 구독 계획
    'plan_free': '무료',
    'plan_trial_14': '14일 체험',
    'plan_trial_7': '7일 체험',
    'plan_family': '가족 요금제',
    
    // 기능
    'community_support': '커뮤니티 지원',
    'offline_limited': '제한된 오프라인 모드',
    'unlimited_questions': '무제한 질문',
    'complete_levels': '5개 완전 레벨',
    'child_profiles_5': '5개 어린이 프로필',
    'child_profiles_2': '2개 프로필',
    'languages_30_complete': '30+완전 언어',
    'languages_30': '30+언어',
    'offline_total': '완전 오프라인 모드',
    'offline_mode': '오프라인 모드',
    'student_profiles_30': '30개 학생 프로필',
    'teacher_dashboard': '교사 대시보드',
    'homework_assignment': '숙제 할당',
    'detailed_reports': '상세한 수업 보고서',
    'family_plan_all': '가족 요금제의 모든 것',
    
    // 체험 버튼
    'free_trial_14': '14일 무료 체험',
    'free_trial_7': '7일 무료 체험',
    'free_trial_30': '30일 무료 체험',
    'start_free_btn': '무료로 시작',
    
    // 언어 드롭다운
    'select_language': '언어 선택',
    'new_advanced_dropdown': '새로운 고급 드롭다운',
    'ultra_intelligent_search': '초지능 검색',
    'languages_found': '언어 발견',
    'language_found': '언어 발견',
    'for_search': '검색',
    'new_version_2024': '새 버전 2024',
    'current': '현재',
    'no_language_found': '언어를 찾을 수 없음',
    'try_search': '시도해보세요: "français", "english", "中文", "العربية"'
  },

  // ============================================================================
  // 🇮🇳 HINDI - NOUVELLES TRADUCTIONS COMPLÈTES
  // ============================================================================
  hi: {
    // नेवीगेशन और हेडर - हिन्दी
    'app_name': 'बच्चों के लिए गणित',
    'app_name_short': 'गणित4बच्चे',
    'website': 'www.math4child.com',
    'world_leader': 'विश्व अग्रणी',
    'families_trust': '100k+परिवार',
    'app_educative': 'फ्रांस #1 शैक्षिक ऐप',
    
    // मुख्य शीर्षक
    'main_title': 'बच्चों के लिए गणित',
    'main_subtitle': 'परिवार के साथ गणित सीखने का #1 शैक्षिक ऐप',
    'join_families': 'पहले से सीख रहे 100,000+परिवारों में शामिल हों!',
    
    // मुख्य बटन
    'start_free': 'मुफ्त में शुरू करें',
    'trial_14d': '14दिन मुफ्त',
    'compare_prices': 'कीमतों की तुलना करें',
    
    // सदस्यता योजनाएं
    'plan_free': 'मुफ्त',
    'plan_trial_14': '14दिन परीक्षण',
    'plan_trial_7': '7दिन परीक्षण',
    'plan_family': 'पारिवारिक योजना',
    
    // सुविधाएं
    'community_support': 'समुदाय समर्थन',
    'offline_limited': 'सीमित ऑफलाइन मोड',
    'unlimited_questions': 'असीमित प्रश्न',
    'complete_levels': '5 पूर्ण स्तर',
    'child_profiles_5': '5 बच्चों की प्रोफाइल',
    'child_profiles_2': '2 प्रोफाइल',
    'languages_30_complete': '30+पूर्ण भाषाएं',
    'languages_30': '30+भाषाएं',
    'offline_total': 'पूर्ण ऑफलाइन मोड',
    'offline_mode': 'ऑफलाइन मोड',
    'student_profiles_30': '30 छात्र प्रोफाइल',
    'teacher_dashboard': 'शिक्षक डैशबोर्ड',
    'homework_assignment': 'गृहकार्य असाइनमेंट',
    'detailed_reports': 'विस्तृत कक्षा रिपोर्ट',
    'family_plan_all': 'पारिवारिक योजना की सब कुछ',
    
    // परीक्षण बटन
    'free_trial_14': '14दिन मुफ्त परीक्षण',
    'free_trial_7': '7दिन मुफ्त परीक्षण',
    'free_trial_30': '30दिन मुफ्त परीक्षण',
    'start_free_btn': 'मुफ्त में शुरू करें',
    
    // भाषा ड्रॉपडाउन
    'select_language': 'भाषा चुनें',
    'new_advanced_dropdown': 'नया उन्नत ड्रॉपडाउन',
    'ultra_intelligent_search': 'अत्यधिक बुद्धिमान खोज',
    'languages_found': 'भाषाएं मिलीं',
    'language_found': 'भाषा मिली',
    'for_search': 'खोज के लिए',
    'new_version_2024': 'नया संस्करण 2024',
    'current': 'वर्तमान',
    'no_language_found': 'कोई भाषा नहीं मिली',
    'try_search': 'कोशिश करें: "français", "english", "中文", "العربية"'
  },

  // ============================================================================
  // 🇷🇺 RUSSE - DÉJÀ PRÉSENT
  // ============================================================================
  ru: {
    // Навигация и заголовок - РУССКИЙ
    'app_name': 'Математика для детей',
    'app_name_short': 'Мат4Дети',
    'website': 'www.math4child.com',
    'world_leader': 'Мировой лидер',
    'families_trust': '100k+семей',
    'app_educative': '#1 образовательное приложение во Франции',
    
    // Основной заголовок
    'main_title': 'Математика для детей',
    'main_subtitle': '#1 образовательное приложение для изучения математики в семье',
    'join_families': 'Присоединяйтесь к более чем 100,000 семей, которые уже учатся!',
    
    // Основные кнопки
    'start_free': 'Начать бесплатно',
    'trial_14d': '14д бесплатно',
    'compare_prices': 'Сравнить цены',
    
    // Планы подписки
    'plan_free': 'Бесплатно',
    'plan_trial_14': 'Пробная версия 14д',
    'plan_trial_7': 'Пробная версия 7д',
    'plan_family': 'Семейный план',
    
    // Функции
    'community_support': 'Поддержка сообщества',
    'offline_limited': 'Ограниченный офлайн режим',
    'unlimited_questions': 'Неограниченные вопросы',
    'complete_levels': '5 полных уровней',
    'child_profiles_5': '5 детских профилей',
    'child_profiles_2': '2 профиля',
    'languages_30_complete': '30+ полных языков',
    'languages_30': '30+ языков',
    'offline_total': 'Полный офлайн режим',
    'offline_mode': 'Офлайн режим',
    'student_profiles_30': '30 профилей учеников',
    'teacher_dashboard': 'Панель учителя',
    'homework_assignment': 'Назначение домашних заданий',
    'detailed_reports': 'Подробные отчеты класса',
    'family_plan_all': 'Все из семейного плана',
    
    // Кнопки пробной версии
    'free_trial_14': 'Бесплатная пробная версия 14д',
    'free_trial_7': 'Бесплатная пробная версия 7д',
    'free_trial_30': 'Бесплатная пробная версия 30д',
    'start_free_btn': 'Начать бесплатно',
    
    // Выпадающий список языков
    'select_language': 'Выбрать язык',
    'new_advanced_dropdown': 'НОВОЕ РАСШИРЕННОЕ МЕНЮ',
    'ultra_intelligent_search': 'УЛЬТРА-УМНЫЙ ПОИСК',
    'languages_found': 'языков найдено',
    'language_found': 'язык найден',
    'for_search': 'для',
    'new_version_2024': 'НОВАЯ ВЕРСИЯ 2024',
    'current': 'ТЕКУЩИЙ',
    'no_language_found': 'Язык не найден',
    'try_search': 'Попробуйте: "français", "english", "中文", "العربية"'
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
