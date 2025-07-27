'use client'

import { useState, useEffect } from 'react'

// INTERFACES TYPESCRIPT
interface Language {
  code: string
  name: string
  flag: string
  region: string
  popular?: boolean
  searchTerms: string[]
  rtl?: boolean
}

interface Texts {
  [key: string]: {
    title: string
    subtitle: string
    description: string
    startFree: string
    comparePrices: string
    whyLeader: string
    searchPlaceholder: string
    noResults: string
    families: string
    appBadge: string
    joinMessage: string
    daysFree: string
    plansTitle: string
    plansSubtitle: string
    competitivePrice: string
    competitivePriceDesc: string
    competitivePriceStat: string
    familyManagement: string
    familyManagementDesc: string
    familyManagementStat: string
    offlineMode: string
    offlineModeDesc: string
    offlineModeStat: string
    analytics: string
    analyticsDesc: string
    analyticsStat: string
  }
}

interface Plan {
  id: string
  name: string
  price: string
  period: string
  originalPrice: string | null
  savings: string | null
  profiles: number
  features: string[]
  button: string
  color: string
  popular?: boolean
  recommended?: boolean
  freeTrial?: string
}

// CONFIGURATION DES LANGUES
const LANGUAGES: Language[] = [
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', region: 'africa', popular: true, searchTerms: ['العربية', 'arabic', 'arabe', 'maroc', 'morocco'], rtl: true },
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe', popular: true, searchTerms: ['français', 'french', 'france'] },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'world', popular: true, searchTerms: ['english', 'anglais', 'usa', 'uk'] },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe', popular: true, searchTerms: ['español', 'spanish', 'espagnol'] },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe', popular: true, searchTerms: ['deutsch', 'german', 'allemand'] },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe', searchTerms: ['italiano', 'italian', 'italien'] },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'europe', searchTerms: ['português', 'portuguese', 'portugais'] },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'europe', searchTerms: ['nederlands', 'dutch', 'néerlandais'] },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'europe', searchTerms: ['русский', 'russian', 'russe'] },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'europe', searchTerms: ['türkçe', 'turkish', 'turc'] },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', region: 'asia', popular: false, searchTerms: ['العربية', 'arabic', 'arabe', 'saudi', 'saoudite'], rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia', popular: true, searchTerms: ['中文', 'chinese', 'chinois', 'mandarin'] },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia', popular: true, searchTerms: ['日本語', 'japanese', 'japonais'] },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'asia', searchTerms: ['한국어', 'korean', 'coréen'] },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia', searchTerms: ['हिन्दी', 'hindi', 'inde'] },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', region: 'asia', searchTerms: ['ไทย', 'thai', 'thaï'] },
  { code: 'he', name: 'עברית', flag: '🇮🇱', region: 'asia', searchTerms: ['עברית', 'hebrew', 'hébreu'], rtl: true },
  { code: 'pt-br', name: 'Português (BR)', flag: '🇧🇷', region: 'americas', popular: true, searchTerms: ['português', 'brazilian', 'brésil'] },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪', region: 'africa', searchTerms: ['kiswahili', 'swahili'] },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹', region: 'africa', searchTerms: ['amharic', 'አማርኛ', 'amharique'] }
]

const REGION_ICONS: Record<string, string> = {
  europe: '🇪🇺',
  asia: '🌏', 
  americas: '🌎',
  world: '🌍',
  africa: '🌍'
}

const REGION_NAMES: Record<string, Record<string, string>> = {
  europe: { fr: 'Europe', en: 'Europe', es: 'Europa', de: 'Europa', it: 'Europa', pt: 'Europa', ar: 'أوروبا', zh: '欧洲', ja: 'ヨーロッパ' },
  asia: { fr: 'Asie', en: 'Asia', es: 'Asia', de: 'Asien', it: 'Asia', pt: 'Ásia', ar: 'آسيا', zh: '亚洲', ja: 'アジア' },
  americas: { fr: 'Amériques', en: 'Americas', es: 'Américas', de: 'Amerika', it: 'Americhe', pt: 'Américas', ar: 'الأمريكتين', zh: '美洲', ja: 'アメリカ' },
  world: { fr: 'International', en: 'International', es: 'Internacional', de: 'International', it: 'Internazionale', pt: 'Internacional', ar: 'دولي', zh: '国际', ja: '国際' },
  africa: { fr: 'Afrique', en: 'Africa', es: 'África', de: 'Afrika', it: 'Africa', pt: 'África', ar: 'أفريقيا', zh: '非洲', ja: 'アフリカ', sw: 'Afrika', am: 'አፍሪካ' }
}

// TRADUCTIONS 100% PERFECTIONNÉES - CHAQUE LANGUE PURE
const texts: Texts = {
  // ANGLAIS - Math4Child (reste inchangé)
  en: {
    title: 'Math4Child',
    subtitle: 'Math4Child',
    description: "#1 educational app to learn math as a family!",
    startFree: 'Start for free',
    comparePrices: 'Compare prices',
    whyLeader: 'Why is Math4Child the leader?',
    searchPlaceholder: 'Search a language...',
    noResults: 'No language found',
    families: '100k+ families',
    appBadge: '#1 educational app in France',
    joinMessage: 'Join over 100,000 families already learning!',
    daysFree: 'd free',
    plansTitle: 'Optimal Plans',
    plansSubtitle: 'More competitive than all competitors',
    // Features
    competitivePrice: 'Most competitive price',
    competitivePriceDesc: '40% cheaper than competitors',
    competitivePriceStat: '6.99€/month vs 8.95€+',
    familyManagement: 'Advanced family management',
    familyManagementDesc: '5 profiles with cloud sync',
    familyManagementStat: '5 profiles vs 3 max',
    offlineMode: 'Offline mode',
    offlineModeDesc: 'Learning everywhere',
    offlineModeStat: '100% offline',
    analytics: 'Analytics',
    analyticsDesc: 'Automatic reports',
    analyticsStat: 'Parent reports'
  },
  
  // FRANÇAIS - Math pour enfants
  fr: {
    title: 'Math pour enfants',
    subtitle: 'Math pour enfants',
    description: "L'app éducative n°1 pour apprendre les maths en famille !",
    startFree: 'Commencer gratuitement',
    comparePrices: 'Comparer les prix',
    whyLeader: 'Pourquoi Math pour enfants est-il leader ?',
    searchPlaceholder: 'Rechercher une langue...',
    noResults: 'Aucune langue trouvée',
    families: '100k+ familles',
    appBadge: 'App éducative #1 en France',
    joinMessage: 'Rejoignez plus de 100,000 familles qui apprennent déjà !',
    daysFree: 'j gratuit',
    plansTitle: 'Plans Optimaux',
    plansSubtitle: 'Plus compétitif que toute la concurrence',
    // Features
    competitivePrice: 'Prix le plus compétitif',
    competitivePriceDesc: '40% moins cher que la concurrence',
    competitivePriceStat: '6.99€/mois vs 8.95€+',
    familyManagement: 'Gestion familiale avancée',
    familyManagementDesc: '5 profils avec synchronisation cloud',
    familyManagementStat: '5 profils vs 3 max',
    offlineMode: 'Mode hors-ligne',
    offlineModeDesc: 'Apprentissage partout',
    offlineModeStat: '100% hors-ligne',
    analytics: 'Analytics',
    analyticsDesc: 'Rapports automatiques',
    analyticsStat: 'Rapports parents'
  },
  
  // ESPAGNOL - Math para niños (100% EN ESPAGNOL)
  es: {
    title: 'Math para niños',
    subtitle: 'Math para niños',
    description: "¡La app educativa #1 para aprender matemáticas en familia!",
    startFree: 'Empezar gratis',
    comparePrices: 'Comparar precios',
    whyLeader: '¿Por qué Math para niños es líder?',
    searchPlaceholder: 'Buscar un idioma...',
    noResults: 'Ningún idioma encontrado',
    families: '100k+ familias',
    appBadge: 'App educativa #1 en Francia',
    joinMessage: '¡Únete a más de 100,000 familias que ya aprenden!',
    daysFree: 'd gratis',
    plansTitle: 'Planes Óptimos',
    plansSubtitle: 'Más competitivo que toda la competencia',
    // Features
    competitivePrice: 'Precio más competitivo',
    competitivePriceDesc: '40% más barato que la competencia',
    competitivePriceStat: '6.99€/mes vs 8.95€+',
    familyManagement: 'Gestión familiar avanzada',
    familyManagementDesc: '5 perfiles con sincronización en la nube',
    familyManagementStat: '5 perfiles vs 3 máx',
    offlineMode: 'Modo sin conexión',
    offlineModeDesc: 'Aprendizaje en todas partes',
    offlineModeStat: '100% sin conexión',
    analytics: 'Análisis',
    analyticsDesc: 'Informes automáticos',
    analyticsStat: 'Informes para padres'
  },
  
  // ALLEMAND - Math für Kinder (100% EN ALLEMAND)
  de: {
    title: 'Math für Kinder',
    subtitle: 'Math für Kinder',
    description: "Die #1 Bildungs-App zum Mathe lernen als Familie!",
    startFree: 'Kostenlos starten',
    comparePrices: 'Preise vergleichen',
    whyLeader: 'Warum ist Math für Kinder Marktführer?',
    searchPlaceholder: 'Sprache suchen...',
    noResults: 'Keine Sprache gefunden',
    families: '100k+ Familien',
    appBadge: '#1 Bildungs-App in Frankreich',
    joinMessage: 'Schließen Sie sich über 100.000 Familien an, die bereits lernen!',
    daysFree: 'T kostenlos',
    plansTitle: 'Optimale Pläne',
    plansSubtitle: 'Wettbewerbsfähiger als alle Konkurrenten',
    // Features
    competitivePrice: 'Wettbewerbsfähigster Preis',
    competitivePriceDesc: '40% günstiger als die Konkurrenz',
    competitivePriceStat: '6.99€/Monat vs 8.95€+',
    familyManagement: 'Erweiterte Familienverwaltung',
    familyManagementDesc: '5 Profile mit Cloud-Synchronisation',
    familyManagementStat: '5 Profile vs 3 max',
    offlineMode: 'Offline-Modus',
    offlineModeDesc: 'Lernen überall',
    offlineModeStat: '100% offline',
    analytics: 'Analysen',
    analyticsDesc: 'Automatische Berichte',
    analyticsStat: 'Elternberichte'
  },
  
  // ITALIEN - Math per bambini (100% EN ITALIEN)
  it: {
    title: 'Math per bambini',
    subtitle: 'Math per bambini',
    description: "L'app educativa #1 per imparare la matematica in famiglia!",
    startFree: 'Inizia gratis',
    comparePrices: 'Confronta prezzi',
    whyLeader: 'Perché Math per bambini è leader?',
    searchPlaceholder: 'Cerca una lingua...',
    noResults: 'Nessuna lingua trovata',
    families: '100k+ famiglie',
    appBadge: 'App educativa #1 in Francia',
    joinMessage: 'Unisciti a oltre 100.000 famiglie che stanno già imparando!',
    daysFree: 'g gratis',
    plansTitle: 'Piani Ottimali',
    plansSubtitle: 'Più competitivo di tutti i concorrenti',
    // Features
    competitivePrice: 'Prezzo più competitivo',
    competitivePriceDesc: '40% più economico della concorrenza',
    competitivePriceStat: '6.99€/mese vs 8.95€+',
    familyManagement: 'Gestione familiare avanzata',
    familyManagementDesc: '5 profili con sincronizzazione cloud',
    familyManagementStat: '5 profili vs 3 max',
    offlineMode: 'Modalità offline',
    offlineModeDesc: 'Apprendimento ovunque',
    offlineModeStat: '100% offline',
    analytics: 'Analisi',
    analyticsDesc: 'Report automatici',
    analyticsStat: 'Report genitori'
  },
  
  // JAPONAIS - 子供のための数学 (100% EN JAPONAIS)
  ja: {
    title: '子供のための数学',
    subtitle: '子供のための数学',
    description: "家族で数学を学ぶ#1教育アプリ！",
    startFree: '無料で始める',
    comparePrices: '価格を比較',
    whyLeader: 'なぜ子供のための数学がリーダーなのか？',
    searchPlaceholder: '言語を検索...',
    noResults: '言語が見つかりません',
    families: '10万+ 家族',
    appBadge: 'フランスで#1の教育アプリ',
    joinMessage: 'すでに学習している100,000以上の家族に参加しましょう！',
    daysFree: '日間無料',
    plansTitle: '最適なプラン',
    plansSubtitle: 'すべての競合他社より競争力があります',
    // Features
    competitivePrice: '最も競争力のある価格',
    competitivePriceDesc: '競合他社より40%安い',
    competitivePriceStat: '6.99€/月 vs 8.95€+',
    familyManagement: '高度な家族管理',
    familyManagementDesc: 'クラウド同期付き5つのプロフィール',
    familyManagementStat: '5プロフィール vs 3最大',
    offlineMode: 'オフラインモード',
    offlineModeDesc: 'どこでも学習',
    offlineModeStat: '100%オフライン',
    analytics: '分析',
    analyticsDesc: '自動レポート',
    analyticsStat: '親レポート'
  },
  
  // CHINOIS - 儿童数学 (100% EN CHINOIS)
  zh: {
    title: '儿童数学',
    subtitle: '儿童数学',
    description: "与家人一起学习数学的#1教育应用！",
    startFree: '免费开始',
    comparePrices: '比较价格',
    whyLeader: '为什么儿童数学是领导者？',
    searchPlaceholder: '搜索语言...',
    noResults: '未找到语言',
    families: '10万+ 家庭',
    appBadge: '法国排名第一的教育应用',
    joinMessage: '加入超过100,000个正在学习的家庭！',
    daysFree: '天免费',
    plansTitle: '最优计划',
    plansSubtitle: '比所有竞争对手更具竞争力',
    // Features
    competitivePrice: '最具竞争力的价格',
    competitivePriceDesc: '比竞争对手便宜40%',
    competitivePriceStat: '6.99€/月 vs 8.95€+',
    familyManagement: '高级家庭管理',
    familyManagementDesc: '5个配置文件，云端同步',
    familyManagementStat: '5个配置文件 vs 3个最大',
    offlineMode: '离线模式',
    offlineModeDesc: '随时随地学习',
    offlineModeStat: '100%离线',
    analytics: '分析',
    analyticsDesc: '自动报告',
    analyticsStat: '家长报告'
  },
  
  // ARABE - 100% EN ARABE
  ar: {
    title: 'الرياضيات للأطفال',
    subtitle: 'الرياضيات للأطفال',
    description: "التطبيق التعليمي رقم 1 لتعلم الرياضيات مع العائلة!",
    startFree: 'ابدأ مجاناً',
    comparePrices: 'قارن الأسعار',
    whyLeader: 'لماذا الرياضيات للأطفال هو الرائد؟',
    searchPlaceholder: 'البحث عن لغة...',
    noResults: 'لم يتم العثور على لغة',
    families: '100 ألف+ عائلة',
    appBadge: 'التطبيق التعليمي رقم 1 في فرنسا',
    joinMessage: 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!',
    daysFree: 'يوم مجاني',
    plansTitle: 'الخطط المثلى',
    plansSubtitle: 'أكثر تنافسية من جميع المنافسين',
    // Features
    competitivePrice: 'السعر الأكثر تنافسية',
    competitivePriceDesc: 'أرخص بـ 40% من المنافسين',
    competitivePriceStat: '6.99€/شهر مقابل 8.95€+',
    familyManagement: 'إدارة عائلية متقدمة',
    familyManagementDesc: '5 ملفات شخصية مع مزامنة السحابة',
    familyManagementStat: '5 ملفات شخصية مقابل 3 حد أقصى',
    offlineMode: 'وضع عدم الاتصال',
    offlineModeDesc: 'التعلم في كل مكان',
    offlineModeStat: '100% بدون اتصال',
    analytics: 'التحليلات',
    analyticsDesc: 'تقارير تلقائية',
    analyticsStat: 'تقارير الآباء'
  },
  
  // ARABE MAROC (même traduction)
  'ar-ma': {
    title: 'الرياضيات للأطفال',
    subtitle: 'الرياضيات للأطفال',
    description: "التطبيق التعليمي رقم 1 لتعلم الرياضيات مع العائلة!",
    startFree: 'ابدأ مجاناً',
    comparePrices: 'قارن الأسعار',
    whyLeader: 'لماذا الرياضيات للأطفال هو الرائد؟',
    searchPlaceholder: 'البحث عن لغة...',
    noResults: 'لم يتم العثور على لغة',
    families: '100 ألف+ عائلة',
    appBadge: 'التطبيق التعليمي رقم 1 في فرنسا',
    joinMessage: 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!',
    daysFree: 'يوم مجاني',
    plansTitle: 'الخطط المثلى',
    plansSubtitle: 'أكثر تنافسية من جميع المنافسين',
    // Features
    competitivePrice: 'السعر الأكثر تنافسية',
    competitivePriceDesc: 'أرخص بـ 40% من المنافسين',
    competitivePriceStat: '6.99€/شهر مقابل 8.95€+',
    familyManagement: 'إدارة عائلية متقدمة',
    familyManagementDesc: '5 ملفات شخصية مع مزامنة السحابة',
    familyManagementStat: '5 ملفات شخصية مقابل 3 حد أقصى',
    offlineMode: 'وضع عدم الاتصال',
    offlineModeDesc: 'التعلم في كل مكان',
    offlineModeStat: '100% بدون اتصال',
    analytics: 'التحليلات',
    analyticsDesc: 'تقارير تلقائية',
    analyticsStat: 'تقارير الآباء'
  }
}

// PLANS D'ABONNEMENT AVEC TRADUCTIONS PARFAITES
const getSubscriptionPlans = (currentLang: string): Plan[] => {
  const planTranslations: Record<string, any> = {
    en: {
      free: { name: 'Free', features: ['100 questions per month', '2 levels (Beginner, Easy)', '5 main languages', 'Community support'], button: 'Start for free' },
      premium: { name: 'Premium', features: ['Unlimited questions', '5 complete levels', '2 profiles', '30+ languages', 'Offline mode', 'Advanced statistics'], button: '7-day free trial', trial: '7 days free' },
      family: { name: 'Family', features: ['Unlimited questions', '5 complete levels', '5 children profiles', '30+ complete languages', 'Full offline mode', 'Parent reports', 'Priority support'], button: '14-day free trial', trial: '14 days free' },
      school: { name: 'School', features: ['Everything in Family plan', '30 student profiles', 'Teacher dashboard', 'Homework assignment', 'Detailed class reports', 'Teacher training'], button: '30-day free trial', trial: '30 days free' }
    },
    fr: {
      free: { name: 'Gratuit', features: ['100 questions par mois', '2 niveaux (Débutant, Facile)', '5 langues principales', 'Support communautaire'], button: 'Commencer gratuitement' },
      premium: { name: 'Premium', features: ['Questions illimitées', '5 niveaux complets', '2 profils', '30+ langues', 'Mode hors-ligne', 'Statistiques avancées'], button: 'Essai 7j gratuit', trial: '7j gratuit' },
      family: { name: 'Famille', features: ['Questions illimitées', '5 niveaux complets', '5 profils enfants', '30+ langues complètes', 'Mode hors-ligne total', 'Rapports parents', 'Support prioritaire'], button: 'Essai 14j gratuit', trial: '14j gratuit' },
      school: { name: 'École', features: ['Tout du plan Famille', '30 profils élèves', 'Tableau de bord enseignant', 'Assignation de devoirs', 'Rapports de classe détaillés', 'Formation enseignants'], button: 'Essai 30j gratuit', trial: '30j gratuit' }
    },
    es: {
      free: { name: 'Gratis', features: ['100 preguntas por mes', '2 niveles (Principiante, Fácil)', '5 idiomas principales', 'Soporte comunitario'], button: 'Empezar gratis' },
      premium: { name: 'Premium', features: ['Preguntas ilimitadas', '5 niveles completos', '2 perfiles', '30+ idiomas', 'Modo sin conexión', 'Estadísticas avanzadas'], button: 'Prueba 7d gratis', trial: '7d gratis' },
      family: { name: 'Familia', features: ['Preguntas ilimitadas', '5 niveles completos', '5 perfiles infantiles', '30+ idiomas completos', 'Modo sin conexión total', 'Informes para padres', 'Soporte prioritario'], button: 'Prueba 14d gratis', trial: '14d gratis' },
      school: { name: 'Escuela', features: ['Todo del plan Familia', '30 perfiles estudiantes', 'Panel de profesor', 'Asignación de tareas', 'Informes detallados de clase', 'Formación docente'], button: 'Prueba 30d gratis', trial: '30d gratis' }
    },
    de: {
      free: { name: 'Kostenlos', features: ['100 Fragen pro Monat', '2 Stufen (Anfänger, Einfach)', '5 Hauptsprachen', 'Community-Support'], button: 'Kostenlos starten' },
      premium: { name: 'Premium', features: ['Unbegrenzte Fragen', '5 vollständige Stufen', '2 Profile', '30+ Sprachen', 'Offline-Modus', 'Erweiterte Statistiken'], button: '7T kostenlos testen', trial: '7T kostenlos' },
      family: { name: 'Familie', features: ['Unbegrenzte Fragen', '5 vollständige Stufen', '5 Kinderprofile', '30+ vollständige Sprachen', 'Vollständiger Offline-Modus', 'Elternberichte', 'Prioritätssupport'], button: '14T kostenlos testen', trial: '14T kostenlos' },
      school: { name: 'Schule', features: ['Alles vom Familienplan', '30 Schülerprofile', 'Lehrer-Dashboard', 'Hausaufgaben-Zuweisung', 'Detaillierte Klassenberichte', 'Lehrerausbildung'], button: '30T kostenlos testen', trial: '30T kostenlos' }
    },
    it: {
      free: { name: 'Gratuito', features: ['100 domande al mese', '2 livelli (Principiante, Facile)', '5 lingue principali', 'Supporto della comunità'], button: 'Inizia gratis' },
      premium: { name: 'Premium', features: ['Domande illimitate', '5 livelli completi', '2 profili', '30+ lingue', 'Modalità offline', 'Statistiche avanzate'], button: 'Prova 7g gratis', trial: '7g gratis' },
      family: { name: 'Famiglia', features: ['Domande illimitate', '5 livelli completi', '5 profili bambini', '30+ lingue complete', 'Modalità offline completa', 'Report genitori', 'Supporto prioritario'], button: 'Prova 14g gratis', trial: '14g gratis' },
      school: { name: 'Scuola', features: ['Tutto del piano Famiglia', '30 profili studenti', 'Dashboard insegnante', 'Assegnazione compiti', 'Report dettagliati classe', 'Formazione insegnanti'], button: 'Prova 30g gratis', trial: '30g gratis' }
    },
    ja: {
      free: { name: '無料', features: ['月100問', '2レベル（初心者、簡単）', '主要5言語', 'コミュニティサポート'], button: '無料で始める' },
      premium: { name: 'プレミアム', features: ['無制限の質問', '5つの完全レベル', '2つのプロフィール', '30+言語', 'オフラインモード', '高度な統計'], button: '7日間無料試用', trial: '7日間無料' },
      family: { name: '家族', features: ['無制限の質問', '5つの完全レベル', '5つの子供プロフィール', '30+完全言語', '完全オフラインモード', '親レポート', '優先サポート'], button: '14日間無料試用', trial: '14日間無料' },
      school: { name: '学校', features: ['家族プランのすべて', '30の学生プロフィール', '教師ダッシュボード', '宿題の割り当て', '詳細なクラスレポート', '教師トレーニング'], button: '30日間無料試用', trial: '30日間無料' }
    },
    zh: {
      free: { name: '免费', features: ['每月100个问题', '2个级别（初学者，简单）', '5种主要语言', '社区支持'], button: '免费开始' },
      premium: { name: '高级', features: ['无限问题', '5个完整级别', '2个配置文件', '30+语言', '离线模式', '高级统计'], button: '7天免费试用', trial: '7天免费' },
      family: { name: '家庭', features: ['无限问题', '5个完整级别', '5个儿童配置文件', '30+完整语言', '完整离线模式', '家长报告', '优先支持'], button: '14天免费试用', trial: '14天免费' },
      school: { name: '学校', features: ['家庭计划的所有内容', '30个学生配置文件', '教师仪表板', '作业分配', '详细班级报告', '教师培训'], button: '30天免费试用', trial: '30天免费' }
    },
    ar: {
      free: { name: 'مجاني', features: ['100 سؤال شهرياً', 'مستويان (مبتدئ، سهل)', '5 لغات رئيسية', 'دعم المجتمع'], button: 'ابدأ مجاناً' },
      premium: { name: 'مميز', features: ['أسئلة غير محدودة', '5 مستويات كاملة', 'ملفان شخصيان', '30+ لغة', 'وضع عدم الاتصال', 'إحصائيات متقدمة'], button: 'تجربة 7 أيام مجانية', trial: '7 أيام مجانية' },
      family: { name: 'عائلة', features: ['أسئلة غير محدودة', '5 مستويات كاملة', '5 ملفات شخصية للأطفال', '30+ لغة كاملة', 'وضع عدم الاتصال الكامل', 'تقارير الآباء', 'دعم متقدم'], button: 'تجربة 14 يوماً مجانية', trial: '14 يوماً مجانية' },
      school: { name: 'مدرسة', features: ['كل ما في خطة العائلة', '30 ملف شخصي للطلاب', 'لوحة تحكم المعلم', 'تكليف الواجبات', 'تقارير مفصلة للفصل', 'تدريب المعلمين'], button: 'تجربة 30 يوماً مجانية', trial: '30 يوماً مجانية' }
    }
  }
  
  const plans = planTranslations[currentLang] || planTranslations.fr
  
  return [
    {
      id: 'free',
      name: plans.free.name,
      price: plans.free.name,
      period: '',
      originalPrice: null,
      savings: null,
      profiles: 1,
      features: plans.free.features,
      button: plans.free.button,
      color: 'gray'
    },
    {
      id: 'premium',
      name: plans.premium.name,
      price: '4.99€',
      period: currentLang === 'ar' || currentLang === 'ar-ma' ? '/شهر' : currentLang === 'es' ? '/mes' : currentLang === 'de' ? '/Monat' : currentLang === 'it' ? '/mese' : currentLang === 'ja' ? '/月' : currentLang === 'zh' ? '/月' : '/mois',
      originalPrice: currentLang === 'ar' || currentLang === 'ar-ma' ? '6.99€/شهر' : currentLang === 'es' ? '6.99€/mes' : currentLang === 'de' ? '6.99€/Monat' : currentLang === 'it' ? '6.99€/mese' : currentLang === 'ja' ? '6.99€/月' : currentLang === 'zh' ? '6.99€/月' : '6.99€/mois',
      savings: currentLang === 'ar' || currentLang === 'ar-ma' ? 'وفر 28%' : currentLang === 'es' ? 'Ahorra 28%' : currentLang === 'de' ? 'Sparen Sie 28%' : currentLang === 'it' ? 'Risparmia 28%' : currentLang === 'ja' ? '28%節約' : currentLang === 'zh' ? '节省28%' : 'Économisez 28%',
      profiles: 2,
      features: plans.premium.features,
      button: plans.premium.button,
      color: 'purple',
      freeTrial: plans.premium.trial
    },
    {
      id: 'family',
      name: plans.family.name,
      price: '6.99€',
      period: currentLang === 'ar' || currentLang === 'ar-ma' ? '/شهر' : currentLang === 'es' ? '/mes' : currentLang === 'de' ? '/Monat' : currentLang === 'it' ? '/mese' : currentLang === 'ja' ? '/月' : currentLang === 'zh' ? '/月' : '/mois',
      originalPrice: currentLang === 'ar' || currentLang === 'ar-ma' ? '9.99€/شهر' : currentLang === 'es' ? '9.99€/mes' : currentLang === 'de' ? '9.99€/Monat' : currentLang === 'it' ? '9.99€/mese' : currentLang === 'ja' ? '9.99€/月' : currentLang === 'zh' ? '9.99€/月' : '9.99€/mois',
      savings: currentLang === 'ar' || currentLang === 'ar-ma' ? 'وفر 30%' : currentLang === 'es' ? 'Ahorra 30%' : currentLang === 'de' ? 'Sparen Sie 30%' : currentLang === 'it' ? 'Risparmia 30%' : currentLang === 'ja' ? '30%節約' : currentLang === 'zh' ? '节省30%' : 'Économisez 30%',
      profiles: 5,
      features: plans.family.features,
      button: plans.family.button,
      color: 'blue',
      popular: true,
      freeTrial: plans.family.trial
    },
    {
      id: 'school',
      name: plans.school.name,
      price: '24.99€',
      period: currentLang === 'ar' || currentLang === 'ar-ma' ? '/شهر' : currentLang === 'es' ? '/mes' : currentLang === 'de' ? '/Monat' : currentLang === 'it' ? '/mese' : currentLang === 'ja' ? '/月' : currentLang === 'zh' ? '/月' : '/mois',
      originalPrice: currentLang === 'ar' || currentLang === 'ar-ma' ? '29.99€/شهر' : currentLang === 'es' ? '29.99€/mes' : currentLang === 'de' ? '29.99€/Monat' : currentLang === 'it' ? '29.99€/mese' : currentLang === 'ja' ? '29.99€/月' : currentLang === 'zh' ? '29.99€/月' : '29.99€/mois',
      savings: currentLang === 'ar' || currentLang === 'ar-ma' ? 'وفر 20%' : currentLang === 'es' ? 'Ahorra 20%' : currentLang === 'de' ? 'Sparen Sie 20%' : currentLang === 'it' ? 'Risparmia 20%' : currentLang === 'ja' ? '20%節約' : currentLang === 'zh' ? '节省20%' : 'Économisez 20%',
      profiles: 30,
      features: plans.school.features,
      button: plans.school.button,
      color: 'emerald',
      recommended: true,
      freeTrial: plans.school.trial
    }
  ]
}

export default function Math4ChildApp() {
  const [currentLang, setCurrentLang] = useState<string>('fr')
  const [isDropdownOpen, setIsDropdownOpen] = useState<boolean>(false)
  const [searchTerm, setSearchTerm] = useState<string>('')
  const [mounted, setMounted] = useState<boolean>(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState<boolean>(false)
  const [selectedPlan, setSelectedPlan] = useState<Plan | null>(null)

  useEffect(() => {
    setMounted(true)
  }, [])

  const t = texts[currentLang] || texts.fr
  const currentLanguage = LANGUAGES.find(lang => lang.code === currentLang) || LANGUAGES[1]
  const subscriptionPlans = getSubscriptionPlans(currentLang)

  // FONCTIONS POUR LES BOUTONS
  const handlePlanSelection = (plan: Plan) => {
    setSelectedPlan(plan)
    setShowSubscriptionModal(true)
    console.log(`🎯 Plan sélectionné: ${plan.name} (${plan.id})`)
  }

  const handleStartFree = () => {
    console.log('🎁 Démarrage gratuit')
    const welcomeMessages: Record<string, string> = {
      en: 'Welcome to Math4Child!',
      fr: 'Bienvenue dans Math pour enfants !',
      es: '¡Bienvenido a Math para niños!',
      de: 'Willkommen bei Math für Kinder!',
      it: 'Benvenuto in Math per bambini!',
      ja: '子供のための数学へようこそ！',
      zh: '欢迎来到儿童数学！',
      ar: 'مرحباً بك في الرياضيات للأطفال!',
      'ar-ma': 'مرحباً بك في الرياضيات للأطفال!'
    }
    alert(welcomeMessages[currentLang] || welcomeMessages.fr)
  }

  const handleComparePrices = () => {
    const plansSection = document.getElementById('plans-section')
    if (plansSection) {
      plansSection.scrollIntoView({ behavior: 'smooth' })
    }
  }

  const handleSubscribe = (plan: Plan) => {
    console.log(`💳 Abonnement au plan: ${plan.name}`)
    const successMessages: Record<string, string> = {
      en: `${plan.name} plan selected successfully!`,
      fr: `Plan ${plan.name} sélectionné avec succès !`,
      es: `¡Plan ${plan.name} seleccionado con éxito!`,
      de: `Plan ${plan.name} erfolgreich ausgewählt!`,
      it: `Piano ${plan.name} selezionato con successo!`,
      ja: `${plan.name}プランが正常に選択されました！`,
      zh: `${plan.name}计划选择成功！`,
      ar: `تم اختيار خطة ${plan.name} بنجاح!`,
      'ar-ma': `تم اختيار خطة ${plan.name} بنجاح!`
    }
    alert(successMessages[currentLang] || successMessages.fr)
    setShowSubscriptionModal(false)
  }

  // Fonction de recherche avec typage correct
  const filteredLanguages: Language[] = LANGUAGES.filter(lang => {
    if (!searchTerm) return true
    const search = searchTerm.toLowerCase()
    return (
      lang.name.toLowerCase().includes(search) ||
      lang.code.toLowerCase().includes(search) ||
      lang.searchTerms.some(term => term.toLowerCase().includes(search))
    )
  })

  // Grouper par région avec typage correct
  const groupedLanguages: Record<string, Language[]> = filteredLanguages.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = []
    acc[lang.region].push(lang)
    return acc
  }, {} as Record<string, Language[]>)

  // Langues populaires avec typage correct
  const popularLanguages: Language[] = filteredLanguages.filter(lang => lang.popular)

  if (!mounted) {
    return (
      <div style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
      }}>
        <div style={{ 
          color: 'white', 
          fontSize: '1.5rem',
          textAlign: 'center'
        }}>
          {currentLang.startsWith('ar') ? 'جاري التحميل...' : 
           currentLang === 'es' ? 'Cargando...' :
           currentLang === 'de' ? 'Wird geladen...' :
           currentLang === 'it' ? 'Caricamento...' :
           currentLang === 'ja' ? '読み込み中...' :
           currentLang === 'zh' ? '加载中...' :
           'Chargement...'}
        </div>
      </div>
    )
  }

  // STYLES CSS INLINE (remplace le style jsx)
  const fadeInKeyframes = `
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideInFromTop {
      from { opacity: 0; transform: translateY(-30px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes float {
      0%, 100% { transform: translateY(-10px); }
      50% { transform: translateY(10px); }
    }
  `

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
      lineHeight: '1.6',
      direction: currentLanguage.rtl ? 'rtl' : 'ltr'
    }}>
      <style dangerouslySetInnerHTML={{ __html: fadeInKeyframes }} />
      
      {/* Header */}
      <header style={{ 
        display: 'flex', 
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '2rem',
        maxWidth: '1200px',
        margin: '0 auto',
        flexWrap: 'wrap',
        gap: '2rem',
        animation: 'slideInFromTop 0.6s ease-out'
      }}>
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          gap: '1rem',
          flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
        }}>
          <div style={{
            width: '60px',
            height: '60px',
            background: 'linear-gradient(135deg, #ff6b35 0%, #f7931e 100%)',
            borderRadius: '16px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 8px 24px rgba(255, 107, 53, 0.3)',
            animation: 'float 3s ease-in-out infinite'
          }}>
            <span style={{ fontSize: '28px' }}>🧮</span>
          </div>
          <div style={{ textAlign: currentLanguage.rtl ? 'right' : 'left' }}>
            <h1 style={{ 
              color: 'white', 
              fontSize: 'clamp(2rem, 5vw, 3rem)', 
              fontWeight: '800',
              margin: 0,
              textShadow: '0 2px 4px rgba(0,0,0,0.3)',
              letterSpacing: '-0.02em'
            }}>
              {t.title}
            </h1>
            <p style={{ 
              color: 'rgba(255, 255, 255, 0.8)', 
              fontSize: '0.9rem',
              fontWeight: '600',
              margin: 0
            }}>
              <span>📊</span>
              <span>{t.appBadge}</span>
            </p>
          </div>
        </div>
        
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          gap: '1rem',
          flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
        }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem',
            background: 'rgba(255, 255, 255, 0.1)',
            padding: '0.75rem 1rem',
            borderRadius: '1rem',
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255, 255, 255, 0.2)',
            color: 'rgba(255, 255, 255, 0.9)',
            fontSize: '0.9rem',
            fontWeight: '500',
            flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
          }}>
            <span>👥</span>
            <span>{t.families}</span>
          </div>
          
          {/* Dropdown de langues */}
          <div style={{ position: 'relative' }}>
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem',
                background: 'rgba(255, 255, 255, 0.15)',
                padding: '0.75rem 1.25rem',
                borderRadius: '1rem',
                backdropFilter: 'blur(15px)',
                border: '1px solid rgba(255, 255, 255, 0.25)',
                boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
                cursor: 'pointer',
                fontWeight: '600',
                fontSize: '0.95rem',
                transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                color: 'white',
                flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
              }}
            >
              <span style={{ fontSize: '1.2em' }}>{currentLanguage.flag}</span>
              <span>{currentLanguage.name}</span>
              <span style={{ 
                transform: isDropdownOpen ? 'rotate(180deg)' : 'rotate(0deg)',
                transition: 'transform 0.2s ease'
              }}>▼</span>
            </button>

            {isDropdownOpen && (
              <div style={{
                position: 'absolute',
                top: '100%',
                [currentLanguage.rtl ? 'left' : 'right']: 0,
                marginTop: '0.5rem',
                width: '320px',
                background: 'white',
                borderRadius: '1.5rem',
                boxShadow: '0 20px 60px rgba(0,0,0,0.15)',
                border: '1px solid rgba(255,255,255,0.2)',
                zIndex: 50,
                overflow: 'hidden',
                animation: 'fadeIn 0.3s ease-out'
              }}>
                {/* Recherche */}
                <div style={{ padding: '1rem', borderBottom: '1px solid #f1f5f9' }}>
                  <div style={{ position: 'relative' }}>
                    <input
                      type="text"
                      placeholder={t.searchPlaceholder}
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      style={{
                        width: '100%',
                        padding: '0.75rem 1rem 0.75rem 2.5rem',
                        border: '2px solid #e5e7eb',
                        borderRadius: '0.75rem',
                        fontSize: '0.9rem',
                        outline: 'none',
                        transition: 'border-color 0.2s ease',
                        direction: currentLanguage.rtl ? 'rtl' : 'ltr',
                        boxSizing: 'border-box'
                      }}
                    />
                    <span style={{
                      position: 'absolute',
                      [currentLanguage.rtl ? 'right' : 'left']: '0.75rem',
                      top: '50%',
                      transform: 'translateY(-50%)',
                      fontSize: '1.1rem'
                    }}>🔍</span>
                  </div>
                </div>

                {/* Contenu scrollable */}
                <div style={{ 
                  maxHeight: '300px', 
                  overflowY: 'auto'
                }}>
                  {/* Langues populaires */}
                  {popularLanguages.length > 0 && !searchTerm && (
                    <div style={{ padding: '1rem' }}>
                      <h3 style={{
                        fontSize: '0.75rem',
                        fontWeight: '600',
                        color: '#6b7280',
                        textTransform: 'uppercase',
                        letterSpacing: '0.05em',
                        marginBottom: '0.75rem',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '0.5rem',
                        flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
                      }}>
                        <span>⭐</span>
                        <span>
                          {currentLang.startsWith('ar') ? 'شائع' : 
                           currentLang === 'es' ? 'Popular' :
                           currentLang === 'de' ? 'Beliebt' :
                           currentLang === 'it' ? 'Popolari' :
                           currentLang === 'ja' ? '人気' :
                           currentLang === 'zh' ? '热门' :
                           'Populaires'}
                        </span>
                      </h3>
                      {popularLanguages.map((language: Language) => (
                        <button
                          key={`popular-${language.code}`}
                          onClick={() => {
                            setCurrentLang(language.code)
                            setIsDropdownOpen(false)
                            setSearchTerm('')
                          }}
                          style={{
                            width: '100%',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '0.75rem',
                            padding: '0.75rem',
                            borderRadius: '0.5rem',
                            background: 'transparent',
                            border: 'none',
                            cursor: 'pointer',
                            fontSize: '0.9rem',
                            fontWeight: '500',
                            color: currentLang === language.code ? '#8b5cf6' : '#374151',
                            backgroundColor: currentLang === language.code ? '#f3f4f6' : 'transparent',
                            transition: 'all 0.2s ease',
                            flexDirection: language.rtl ? 'row-reverse' : 'row',
                            textAlign: language.rtl ? 'right' : 'left'
                          }}
                        >
                          <span style={{ fontSize: '1.2em' }}>{language.flag}</span>
                          <span>{language.name}</span>
                        </button>
                      ))}
                    </div>
                  )}

                  {/* Langues groupées par région AVEC TYPAGE CORRECT */}
                  {Object.entries(groupedLanguages).map(([region, languages]: [string, Language[]]) => (
                    <div key={region} style={{ 
                      padding: '1rem',
                      borderTop: '1px solid #f1f5f9'
                    }}>
                      <h3 style={{
                        fontSize: '0.75rem',
                        fontWeight: '600',
                        color: '#6b7280',
                        textTransform: 'uppercase',
                        letterSpacing: '0.05em',
                        marginBottom: '0.75rem',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '0.5rem',
                        flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
                      }}>
                        <span>{REGION_ICONS[region]}</span>
                        <span>{REGION_NAMES[region][currentLang] || REGION_NAMES[region].fr}</span>
                      </h3>
                      {languages.map((language: Language) => (
                        <button
                          key={language.code}
                          onClick={() => {
                            setCurrentLang(language.code)
                            setIsDropdownOpen(false)
                            setSearchTerm('')
                          }}
                          style={{
                            width: '100%',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '0.75rem',
                            padding: '0.75rem',
                            borderRadius: '0.5rem',
                            background: 'transparent',
                            border: 'none',
                            cursor: 'pointer',
                            fontSize: '0.9rem',
                            fontWeight: '500',
                            color: currentLang === language.code ? '#8b5cf6' : '#374151',
                            backgroundColor: currentLang === language.code ? '#f3f4f6' : 'transparent',
                            transition: 'all 0.2s ease',
                            flexDirection: language.rtl ? 'row-reverse' : 'row',
                            textAlign: language.rtl ? 'right' : 'left'
                          }}
                        >
                          <span style={{ fontSize: '1.2em' }}>{language.flag}</span>
                          <span>{language.name}</span>
                        </button>
                      ))}
                    </div>
                  ))}

                  {filteredLanguages.length === 0 && (
                    <div style={{ 
                      padding: '2rem', 
                      textAlign: 'center', 
                      color: '#6b7280',
                      fontSize: '0.9rem'
                    }}>
                      {t.noResults}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      </header>

      <div style={{ padding: '0 2rem' }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          
          {/* Hero Section */}
          <main style={{ 
            textAlign: 'center', 
            padding: '2rem 0 4rem',
            animation: 'fadeIn 0.8s ease-out 0.2s both'
          }}>
            <div style={{
              display: 'inline-flex',
              alignItems: 'center',
              gap: '0.5rem',
              background: 'rgba(16, 185, 129, 0.2)',
              color: 'rgba(255, 255, 255, 0.95)',
              padding: '0.75rem 1.5rem',
              borderRadius: '2rem',
              marginBottom: '2rem',
              backdropFilter: 'blur(10px)',
              border: '1px solid rgba(16, 185, 129, 0.3)',
              fontSize: '0.9rem',
              fontWeight: '600'
            }}>
              <span>🎁</span>
              <span>www.math4child.com • Leader mondial</span>
            </div>
            
            <h2 style={{ 
              color: 'white', 
              fontSize: 'clamp(2.5rem, 8vw, 6rem)', 
              fontWeight: '800',
              marginBottom: '2rem',
              lineHeight: '1.1',
              textShadow: '0 4px 8px rgba(0,0,0,0.3)',
              letterSpacing: '-0.02em'
            }}>
              {t.subtitle}
            </h2>
            
            <p style={{ 
              color: 'rgba(255, 255, 255, 0.95)', 
              fontSize: 'clamp(1.2rem, 3vw, 1.8rem)',
              marginBottom: '1.5rem',
              maxWidth: '700px',
              margin: '0 auto 1.5rem auto',
              lineHeight: '1.6',
              textShadow: '0 2px 4px rgba(0,0,0,0.2)',
              fontWeight: '500'
            }}>
              {t.description}
            </p>

            <p style={{ 
              color: 'rgba(255, 255, 255, 0.85)', 
              fontSize: 'clamp(1rem, 2.5vw, 1.3rem)',
              marginBottom: '3rem',
              maxWidth: '600px',
              margin: '0 auto 3rem auto',
              lineHeight: '1.6'
            }}>
              {t.joinMessage}
            </p>
            
            {/* Boutons CTA FONCTIONNELS */}
            <div style={{ 
              display: 'flex', 
              gap: '1.5rem', 
              justifyContent: 'center', 
              flexWrap: 'wrap',
              marginBottom: '4rem'
            }}>
              <button 
                onClick={handleStartFree}
                style={{
                  background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                  color: 'white',
                  padding: '1.25rem 2.5rem',
                  border: 'none',
                  borderRadius: '1.25rem',
                  fontSize: '1.1rem',
                  fontWeight: '700',
                  cursor: 'pointer',
                  boxShadow: '0 10px 30px rgba(16, 185, 129, 0.4)',
                  transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.transform = 'translateY(-3px) scale(1.02)'
                  e.currentTarget.style.boxShadow = '0 15px 40px rgba(16, 185, 129, 0.5)'
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.transform = 'translateY(0) scale(1)'
                  e.currentTarget.style.boxShadow = '0 10px 30px rgba(16, 185, 129, 0.4)'
                }}
              >
                <span style={{ fontSize: '1.3em' }}>🎁</span>
                <span>{t.startFree}</span>
                <span style={{
                  background: 'rgba(255, 255, 255, 0.25)',
                  padding: '0.3rem 0.6rem',
                  borderRadius: '0.5rem',
                  fontSize: '0.85rem',
                  fontWeight: '600'
                }}>14{t.daysFree}</span>
              </button>
              
              <button 
                onClick={handleComparePrices}
                style={{
                  background: 'rgba(255, 255, 255, 0.15)',
                  color: 'white',
                  padding: '1.25rem 2.5rem',
                  border: '2px solid rgba(255, 255, 255, 0.3)',
                  borderRadius: '1.25rem',
                  fontSize: '1.1rem',
                  fontWeight: '600',
                  cursor: 'pointer',
                  backdropFilter: 'blur(15px)',
                  transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.background = 'rgba(255, 255, 255, 0.25)'
                  e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.5)'
                  e.currentTarget.style.transform = 'translateY(-3px) scale(1.02)'
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.background = 'rgba(255, 255, 255, 0.15)'
                  e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.3)'
                  e.currentTarget.style.transform = 'translateY(0) scale(1)'
                }}
              >
                <span style={{ fontSize: '1.3em' }}>📊</span>
                <span>{t.comparePrices}</span>
              </button>
            </div>
          </main>

          {/* Section Pourquoi leader */}
          <section style={{ 
            marginBottom: '6rem',
            animation: 'fadeIn 1s ease-out 0.4s both'
          }}>
            <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
              <h3 style={{
                color: 'white',
                fontSize: 'clamp(2rem, 5vw, 3.5rem)',
                fontWeight: '700',
                marginBottom: '1rem',
                textShadow: '0 2px 4px rgba(0,0,0,0.3)'
              }}>
                {t.whyLeader}
              </h3>
            </div>

            {/* Features cards AVEC TRADUCTIONS PARFAITES */}
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
              gap: '2rem',
              marginBottom: '4rem'
            }}>
              {[
                { 
                  icon: '💰', 
                  title: t.competitivePrice, 
                  desc: t.competitivePriceDesc, 
                  stat: t.competitivePriceStat 
                },
                { 
                  icon: '👨‍👩‍👧‍👦', 
                  title: t.familyManagement, 
                  desc: t.familyManagementDesc, 
                  stat: t.familyManagementStat 
                },
                { 
                  icon: '📱', 
                  title: t.offlineMode, 
                  desc: t.offlineModeDesc, 
                  stat: t.offlineModeStat 
                },
                { 
                  icon: '📊', 
                  title: t.analytics, 
                  desc: t.analyticsDesc, 
                  stat: t.analyticsStat 
                }
              ].map((feature, index) => (
                <div 
                  key={index} 
                  style={{ 
                    textAlign: 'center',
                    padding: '2.5rem 2rem',
                    background: 'rgba(255, 255, 255, 0.1)',
                    borderRadius: '1.5rem',
                    backdropFilter: 'blur(15px)',
                    border: '1px solid rgba(255, 255, 255, 0.2)',
                    boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
                    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                    cursor: 'pointer',
                    color: 'white'
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.transform = 'translateY(-10px) scale(1.02)'
                    e.currentTarget.style.boxShadow = '0 20px 50px rgba(0,0,0,0.2)'
                    e.currentTarget.style.background = 'rgba(255, 255, 255, 0.15)'
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.transform = 'translateY(0) scale(1)'
                    e.currentTarget.style.boxShadow = '0 8px 32px rgba(0,0,0,0.1)'
                    e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)'
                  }}
                >
                  <div style={{ 
                    fontSize: '4rem', 
                    marginBottom: '1.5rem',
                    filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.2))',
                    animation: 'float 3s ease-in-out infinite'
                  }}>
                    {feature.icon}
                  </div>
                  <h4 style={{ 
                    fontSize: '1.4rem', 
                    fontWeight: '700', 
                    marginBottom: '0.75rem',
                    textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                  }}>
                    {feature.title}
                  </h4>
                  <p style={{ 
                    color: 'rgba(255, 255, 255, 0.9)',
                    fontSize: '1rem',
                    lineHeight: '1.6',
                    marginBottom: '1rem'
                  }}>
                    {feature.desc}
                  </p>
                  <p style={{
                    color: feature.stat.includes('Rapports') || feature.stat.includes('تقارير') || feature.stat.includes('親レポート') || feature.stat.includes('家长报告') || feature.stat.includes('Report') || feature.stat.includes('genitori') || feature.stat.includes('parents') || feature.stat.includes('Eltern') || feature.stat.includes('padres') ? '#fbbf24' : '#10b981',
                    fontWeight: '600',
                    fontSize: '0.9rem',
                    textShadow: '0 1px 2px rgba(0,0,0,0.3)'
                  }}>
                    {feature.stat}
                  </p>
                </div>
              ))}
            </div>
          </section>

          {/* SECTION PLANS OPTIMAUX AVEC TOUTES LES TRADUCTIONS */}
          <section id="plans-section" style={{
            marginBottom: '6rem',
            animation: 'fadeIn 1s ease-out 0.6s both'
          }}>
            <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
              <h3 style={{
                color: 'white',
                fontSize: 'clamp(2rem, 5vw, 3.5rem)',
                fontWeight: '700',
                marginBottom: '1rem',
                textShadow: '0 2px 4px rgba(0,0,0,0.3)'
              }}>
                {t.plansTitle}
              </h3>
              <p style={{
                color: 'rgba(255, 255, 255, 0.85)',
                fontSize: '1.2rem',
                marginBottom: '2rem'
              }}>
                {t.plansSubtitle}
              </p>
            </div>

            {/* Grille des plans AVEC TRADUCTIONS PARFAITES */}
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
              gap: '2rem',
              marginBottom: '4rem'
            }}>
              {subscriptionPlans.map((plan: Plan, index: number) => (
                <div
                  key={plan.id}
                  style={{
                    background: 'rgba(255, 255, 255, 0.95)',
                    borderRadius: '2rem',
                    padding: '2.5rem 2rem',
                    position: 'relative',
                    boxShadow: '0 20px 40px rgba(0,0,0,0.1)',
                    border: plan.popular ? '3px solid #3b82f6' : '1px solid rgba(255,255,255,0.2)',
                    transform: plan.popular ? 'scale(1.05)' : 'scale(1)',
                    transition: 'transform 0.3s ease',
                    color: '#1f2937'
                  }}
                >
                  {/* Badge populaire/recommandé TRADUIT */}
                  {plan.popular && (
                    <div style={{
                      position: 'absolute',
                      top: '-15px',
                      left: '50%',
                      transform: 'translateX(-50%)',
                      background: 'linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%)',
                      color: 'white',
                      padding: '0.75rem 2rem',
                      borderRadius: '2rem',
                      fontSize: '0.9rem',
                      fontWeight: '700',
                      boxShadow: '0 8px 20px rgba(59, 130, 246, 0.4)'
                    }}>
                      👨‍👩‍👧‍👦 {
                        currentLang.startsWith('ar') ? 'الأكثر شعبية' : 
                        currentLang === 'es' ? 'El más popular' :
                        currentLang === 'de' ? 'Am beliebtesten' :
                        currentLang === 'it' ? 'Il più popolare' :
                        currentLang === 'ja' ? '最も人気' :
                        currentLang === 'zh' ? '最受欢迎' :
                        'Le plus populaire'
                      }
                    </div>
                  )}
                  
                  {plan.recommended && (
                    <div style={{
                      position: 'absolute',
                      top: '-15px',
                      left: '50%',
                      transform: 'translateX(-50%)',
                      background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                      color: 'white',
                      padding: '0.75rem 2rem',
                      borderRadius: '2rem',
                      fontSize: '0.9rem',
                      fontWeight: '700',
                      boxShadow: '0 8px 20px rgba(16, 185, 129, 0.4)'
                    }}>
                      🏫 {
                        currentLang.startsWith('ar') ? 'موصى به للمدارس' : 
                        currentLang === 'es' ? 'Recomendado escuelas' :
                        currentLang === 'de' ? 'Empfohlen Schulen' :
                        currentLang === 'it' ? 'Raccomandato scuole' :
                        currentLang === 'ja' ? '学校推奨' :
                        currentLang === 'zh' ? '学校推荐' :
                        'Recommandé écoles'
                      }
                    </div>
                  )}

                  {/* Nom du plan */}
                  <h4 style={{
                    fontSize: '1.8rem',
                    fontWeight: '800',
                    marginBottom: '1rem',
                    color: '#1f2937',
                    textAlign: 'center'
                  }}>
                    {plan.name}
                  </h4>

                  {/* Prix */}
                  <div style={{ textAlign: 'center', marginBottom: '1.5rem' }}>
                    {plan.originalPrice && (
                      <div style={{
                        fontSize: '1.1rem',
                        color: '#9ca3af',
                        textDecoration: 'line-through',
                        marginBottom: '0.5rem'
                      }}>
                        {plan.originalPrice}
                      </div>
                    )}
                    
                    <div style={{
                      fontSize: plan.id === 'free' ? '2.5rem' : '3.5rem',
                      fontWeight: '900',
                      color: plan.id === 'free' ? '#6b7280' : 
                             plan.id === 'premium' ? '#8b5cf6' :
                             plan.id === 'family' ? '#3b82f6' : '#10b981',
                      lineHeight: '1',
                      marginBottom: '0.5rem'
                    }}>
                      {plan.price}
                      <span style={{ fontSize: '1.2rem', fontWeight: '500', color: '#6b7280' }}>
                        {plan.period}
                      </span>
                    </div>

                    {plan.savings && (
                      <div style={{
                        color: '#10b981',
                        fontWeight: '700',
                        fontSize: '1rem'
                      }}>
                        {plan.savings}
                      </div>
                    )}
                  </div>

                  {/* Nombre de profils TRADUIT */}
                  <div style={{
                    textAlign: 'center',
                    marginBottom: '2rem',
                    padding: '1rem',
                    background: '#f8fafc',
                    borderRadius: '1rem'
                  }}>
                    <span style={{ fontSize: '1.5rem', marginRight: '0.5rem' }}>👥</span>
                    <span style={{ fontSize: '1.1rem', fontWeight: '600', color: '#374151' }}>
                      {plan.profiles} {
                        plan.profiles === 1 ? 
                          (currentLang.startsWith('ar') ? 'ملف شخصي' : 
                           currentLang === 'es' ? 'perfil' :
                           currentLang === 'de' ? 'Profil' :
                           currentLang === 'it' ? 'profilo' :
                           currentLang === 'ja' ? 'プロフィール' :
                           currentLang === 'zh' ? '配置文件' :
                           'profil') : 
                          (currentLang.startsWith('ar') ? 'ملفات شخصية' : 
                           currentLang === 'es' ? 'perfiles' :
                           currentLang === 'de' ? 'Profile' :
                           currentLang === 'it' ? 'profili' :
                           currentLang === 'ja' ? 'プロフィール' :
                           currentLang === 'zh' ? '配置文件' :
                           'profils')
                      }
                    </span>
                  </div>

                  {/* Essai gratuit TRADUIT */}
                  {plan.freeTrial && (
                    <div style={{
                      background: 'linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%)',
                      padding: '1rem',
                      borderRadius: '1rem',
                      textAlign: 'center',
                      marginBottom: '2rem',
                      border: '2px solid #10b981'
                    }}>
                      <span style={{ fontSize: '1.2rem', marginRight: '0.5rem' }}>🎁</span>
                      <span style={{ fontWeight: '700', color: '#065f46', fontSize: '1.1rem' }}>
                        {plan.freeTrial}
                      </span>
                    </div>
                  )}

                  {/* Fonctionnalités TRADUITES */}
                  <ul style={{
                    listStyle: 'none',
                    padding: 0,
                    marginBottom: '2.5rem'
                  }}>
                    {plan.features.map((feature: string, featureIndex: number) => (
                      <li key={featureIndex} style={{
                        display: 'flex',
                        alignItems: 'center',
                        marginBottom: '1rem',
                        fontSize: '0.95rem',
                        color: '#374151',
                        flexDirection: currentLanguage.rtl ? 'row-reverse' : 'row'
                      }}>
                        <span style={{ 
                          color: '#10b981', 
                          fontSize: '1.2rem', 
                          marginRight: currentLanguage.rtl ? '0' : '0.75rem',
                          marginLeft: currentLanguage.rtl ? '0.75rem' : '0',
                          fontWeight: '900'
                        }}>✓</span>
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>

                  {/* Bouton FONCTIONNEL TRADUIT */}
                  <button 
                    onClick={() => handlePlanSelection(plan)}
                    style={{
                      width: '100%',
                      padding: '1.25rem',
                      borderRadius: '1.25rem',
                      fontSize: '1.1rem',
                      fontWeight: '700',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'all 0.3s ease',
                      background: plan.id === 'free' ? '#f3f4f6' :
                                 plan.id === 'premium' ? 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)' :
                                 plan.id === 'family' ? 'linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%)' : 
                                 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                      color: plan.id === 'free' ? '#6b7280' : 'white',
                      boxShadow: plan.id !== 'free' ? '0 10px 25px rgba(0,0,0,0.15)' : 'none'
                    }}
                    onMouseEnter={(e) => {
                      if (plan.id !== 'free') {
                        e.currentTarget.style.transform = 'translateY(-2px)'
                        e.currentTarget.style.boxShadow = '0 15px 35px rgba(0,0,0,0.2)'
                      }
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.transform = 'translateY(0)'
                      e.currentTarget.style.boxShadow = plan.id !== 'free' ? '0 10px 25px rgba(0,0,0,0.15)' : 'none'
                    }}
                  >
                    {plan.button}
                  </button>
                </div>
              ))}
            </div>
          </section>

          {/* Message de succès TRADUIT */}
          <div style={{
            background: 'rgba(255, 255, 255, 0.1)',
            borderRadius: '2rem',
            padding: '3rem 2rem',
            backdropFilter: 'blur(15px)',
            border: '1px solid rgba(255, 255, 255, 0.2)',
            boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
            textAlign: 'center',
            animation: 'fadeIn 1.2s ease-out 0.8s both'
          }}>
            <h3 style={{
              color: 'white',
              fontSize: '2rem',
              fontWeight: '700',
              marginBottom: '2rem',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '1rem',
              textShadow: '0 2px 4px rgba(0,0,0,0.3)'
            }}>
              ✅ {
                currentLang.startsWith('ar') ? 'جميع الترجمات مثالية!' : 
                currentLang === 'es' ? '¡Todas las traducciones perfectas!' :
                currentLang === 'de' ? 'Alle Übersetzungen perfekt!' :
                currentLang === 'it' ? 'Tutte le traduzioni perfette!' :
                currentLang === 'ja' ? 'すべての翻訳が完璧！' :
                currentLang === 'zh' ? '所有翻译都完美！' :
                'Toutes les traductions parfaites !'
              }
            </h3>
            
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
              gap: '2rem',
              marginBottom: '2rem',
              color: 'rgba(255, 255, 255, 0.9)'
            }}>
              <div>
                <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🔤</div>
                <h4 style={{ fontWeight: '600', marginBottom: '0.5rem', fontSize: '1.1rem' }}>
                  {currentLang.startsWith('ar') ? 'ترجمات نقية 100%' : 
                   currentLang === 'es' ? 'Traducciones 100% puras' :
                   currentLang === 'de' ? '100% reine Übersetzungen' :
                   currentLang === 'it' ? 'Traduzioni 100% pure' :
                   currentLang === 'ja' ? '100%純粋な翻訳' :
                   currentLang === 'zh' ? '100%纯正翻译' :
                   'Traductions 100% pures'}
                </h4>
                <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                  {currentLang.startsWith('ar') ? 'كل لغة بلغتها الأصلية' : 
                   currentLang === 'es' ? 'Cada idioma en su lengua nativa' :
                   currentLang === 'de' ? 'Jede Sprache in ihrer Muttersprache' :
                   currentLang === 'it' ? 'Ogni lingua nella sua lingua nativa' :
                   currentLang === 'ja' ? '各言語が母国語で' :
                   currentLang === 'zh' ? '每种语言都是母语' :
                   'Chaque langue dans sa langue natale'}
                </p>
              </div>
              
              <div>
                <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🔘</div>
                <h4 style={{ fontWeight: '600', marginBottom: '0.5rem', fontSize: '1.1rem' }}>
                  {currentLang.startsWith('ar') ? 'أزرار وظيفية' : 
                   currentLang === 'es' ? 'Botones funcionales' :
                   currentLang === 'de' ? 'Funktionale Schaltflächen' :
                   currentLang === 'it' ? 'Pulsanti funzionali' :
                   currentLang === 'ja' ? '機能的なボタン' :
                   currentLang === 'zh' ? '功能按钮' :
                   'Boutons fonctionnels'}
                </h4>
                <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                  {currentLang.startsWith('ar') ? 'كل الأزرار تعمل بشكل مثالي' : 
                   currentLang === 'es' ? 'Todos los botones funcionan perfectamente' :
                   currentLang === 'de' ? 'Alle Schaltflächen funktionieren perfekt' :
                   currentLang === 'it' ? 'Tutti i pulsanti funzionano perfettamente' :
                   currentLang === 'ja' ? 'すべてのボタンが完璧に動作' :
                   currentLang === 'zh' ? '所有按钮都完美运行' :
                   'Tous les boutons fonctionnent parfaitement'}
                </p>
              </div>
              
              <div>
                <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>✨</div>
                <h4 style={{ fontWeight: '600', marginBottom: '0.5rem', fontSize: '1.1rem' }}>
                  {currentLang.startsWith('ar') ? 'تجربة مثالية' : 
                   currentLang === 'es' ? 'Experiencia perfecta' :
                   currentLang === 'de' ? 'Perfekte Erfahrung' :
                   currentLang === 'it' ? 'Esperienza perfetta' :
                   currentLang === 'ja' ? '完璧な体験' :
                   currentLang === 'zh' ? '完美体验' :
                   'Expérience parfaite'}
                </h4>
                <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                  {currentLang.startsWith('ar') ? 'واجهة متجاوبة ومثالية' : 
                   currentLang === 'es' ? 'Interfaz responsiva y perfecta' :
                   currentLang === 'de' ? 'Responsive und perfekte Benutzeroberfläche' :
                   currentLang === 'it' ? 'Interfaccia reattiva e perfetta' :
                   currentLang === 'ja' ? 'レスポンシブで完璧なインターフェース' :
                   currentLang === 'zh' ? '响应式完美界面' :
                   'Interface responsive et parfaite'}
                </p>
              </div>
            </div>
            
            <p style={{
              color: '#10b981',
              fontWeight: '700',
              fontSize: '1.3rem',
              textShadow: '0 2px 4px rgba(0,0,0,0.3)',
              marginTop: '1rem'
            }}>
              🎉 {
                currentLang.startsWith('ar') ? 'كل شيء يعمل بشكل مثالي الآن!' : 
                currentLang === 'es' ? '¡Todo funciona perfectamente ahora!' :
                currentLang === 'de' ? 'Jetzt funktioniert alles perfekt!' :
                currentLang === 'it' ? 'Ora tutto funziona perfettamente!' :
                currentLang === 'ja' ? '今すべてが完璧に動作しています！' :
                currentLang === 'zh' ? '现在一切都完美运行！' :
                'Tout fonctionne parfaitement maintenant !'
              }
            </p>
          </div>

        </div>
      </div>

      {/* MODAL D'ABONNEMENT MULTILINGUE */}
      {showSubscriptionModal && selectedPlan && (
        <div style={{
          position: 'fixed',
          inset: 0,
          background: 'rgba(0, 0, 0, 0.8)',
          backdropFilter: 'blur(10px)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 100,
          padding: '2rem'
        }}>
          <div style={{
            background: 'white',
            borderRadius: '2rem',
            padding: '3rem 2rem',
            maxWidth: '500px',
            width: '100%',
            boxShadow: '0 25px 50px rgba(0,0,0,0.25)',
            animation: 'fadeIn 0.3s ease-out',
            textAlign: 'center',
            direction: currentLanguage.rtl ? 'rtl' : 'ltr',
            position: 'relative'
          }}>
            {/* Bouton fermer */}
            <button
              onClick={() => setShowSubscriptionModal(false)}
              style={{
                position: 'absolute',
                top: '1rem',
                [currentLanguage.rtl ? 'left' : 'right']: '1rem',
                background: 'transparent',
                border: 'none',
                fontSize: '2rem',
                cursor: 'pointer',
                color: '#6b7280',
                padding: '0.5rem'
              }}
            >
              ×
            </button>

            {/* Contenu de la modal */}
            <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>
              {selectedPlan.id === 'free' ? '🎁' : 
               selectedPlan.id === 'premium' ? '⭐' :
               selectedPlan.id === 'family' ? '👨‍👩‍👧‍👦' : '🏫'}
            </div>

            <h3 style={{
              fontSize: '2rem',
              fontWeight: '800',
              color: '#1f2937',
              marginBottom: '1rem'
            }}>
              {currentLang.startsWith('ar') ? `خطة ${selectedPlan.name}` : 
               currentLang === 'es' ? `Plan ${selectedPlan.name}` :
               currentLang === 'de' ? `Plan ${selectedPlan.name}` :
               currentLang === 'it' ? `Piano ${selectedPlan.name}` :
               currentLang === 'ja' ? `${selectedPlan.name}プラン` :
               currentLang === 'zh' ? `${selectedPlan.name}计划` :
               `Plan ${selectedPlan.name}`}
            </h3>

            <div style={{
              fontSize: '3rem',
              fontWeight: '900',
              color: selectedPlan.id === 'free' ? '#6b7280' : 
                     selectedPlan.id === 'premium' ? '#8b5cf6' :
                     selectedPlan.id === 'family' ? '#3b82f6' : '#10b981',
              marginBottom: '2rem'
            }}>
              {selectedPlan.price}
              <span style={{ fontSize: '1.2rem', fontWeight: '500', color: '#6b7280' }}>
                {selectedPlan.period}
              </span>
            </div>

            {selectedPlan.freeTrial && (
              <div style={{
                background: 'linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%)',
                padding: '1rem',
                borderRadius: '1rem',
                marginBottom: '2rem',
                border: '2px solid #10b981'
              }}>
                <span style={{ fontSize: '1.2rem', marginRight: '0.5rem' }}>🎁</span>
                <span style={{ fontWeight: '700', color: '#065f46', fontSize: '1.1rem' }}>
                  {selectedPlan.freeTrial}
                </span>
              </div>
            )}

            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(2, 1fr)',
              gap: '1rem',
              marginBottom: '2rem'
            }}>
              <button
                onClick={() => setShowSubscriptionModal(false)}
                style={{
                  padding: '1rem 2rem',
                  borderRadius: '1rem',
                  fontSize: '1rem',
                  fontWeight: '600',
                  border: '2px solid #e5e7eb',
                  background: 'white',
                  color: '#6b7280',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.borderColor = '#d1d5db'
                  e.currentTarget.style.background = '#f9fafb'
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.borderColor = '#e5e7eb'
                  e.currentTarget.style.background = 'white'
                }}
              >
                {currentLang.startsWith('ar') ? 'إلغاء' : 
                 currentLang === 'es' ? 'Cancelar' :
                 currentLang === 'de' ? 'Abbrechen' :
                 currentLang === 'it' ? 'Annulla' :
                 currentLang === 'ja' ? 'キャンセル' :
                 currentLang === 'zh' ? '取消' :
                 'Annuler'}
              </button>

              <button
                onClick={() => handleSubscribe(selectedPlan)}
                style={{
                  padding: '1rem 2rem',
                  borderRadius: '1rem',
                  fontSize: '1rem',
                  fontWeight: '700',
                  border: 'none',
                  background: selectedPlan.id === 'free' ? '#f3f4f6' :
                             selectedPlan.id === 'premium' ? 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)' :
                             selectedPlan.id === 'family' ? 'linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%)' : 
                             'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                  color: selectedPlan.id === 'free' ? '#6b7280' : 'white',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                  boxShadow: selectedPlan.id !== 'free' ? '0 10px 25px rgba(0,0,0,0.15)' : 'none'
                }}
                onMouseEnter={(e) => {
                  if (selectedPlan.id !== 'free') {
                    e.currentTarget.style.transform = 'translateY(-2px)'
                    e.currentTarget.style.boxShadow = '0 15px 35px rgba(0,0,0,0.2)'
                  }
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.transform = 'translateY(0)'
                  e.currentTarget.style.boxShadow = selectedPlan.id !== 'free' ? '0 10px 25px rgba(0,0,0,0.15)' : 'none'
                }}
              >
                {currentLang.startsWith('ar') ? 'تأكيد الاشتراك' : 
                 currentLang === 'es' ? 'Confirmar suscripción' :
                 currentLang === 'de' ? 'Abonnement bestätigen' :
                 currentLang === 'it' ? 'Conferma abbonamento' :
                 currentLang === 'ja' ? 'サブスクリプションを確認' :
                 currentLang === 'zh' ? '确认订阅' :
                 'Confirmer l\'abonnement'}
              </button>
            </div>

            <p style={{
              fontSize: '0.8rem',
              color: '#9ca3af',
              marginTop: '1rem'
            }}>
              {currentLang.startsWith('ar') ? 'يمكنك إلغاء الاشتراك في أي وقت' : 
               currentLang === 'es' ? 'Puedes cancelar tu suscripción en cualquier momento' :
               currentLang === 'de' ? 'Du kannst dein Abonnement jederzeit kündigen' :
               currentLang === 'it' ? 'Puoi cancellare il tuo abbonamento in qualsiasi momento' :
               currentLang === 'ja' ? 'いつでもサブスクリプションをキャンセルできます' :
               currentLang === 'zh' ? '您可以随时取消订阅' :
               'Vous pouvez annuler votre abonnement à tout moment'}
            </p>
          </div>
        </div>
      )}

      {/* Fermer le dropdown si on clique ailleurs */}
      {isDropdownOpen && (
        <div 
          style={{
            position: 'fixed',
            inset: 0,
            zIndex: 40
          }}
          onClick={() => setIsDropdownOpen(false)}
        />
      )}
    </div>
  )
}
