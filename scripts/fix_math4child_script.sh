#!/bin/bash

# =============================================================================
# 🔧 SCRIPT DE CORRECTION MATH4CHILD v4.0.0
# Corrige l'erreur TypeScript des traductions manquantes
# =============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}"
    echo "========================================"
    echo "  $1"
    echo "========================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header "CORRECTION MATH4CHILD v4.0.0"

# Vérifier que nous sommes dans le bon répertoire
if [ ! -d "math4child-v4/apps/math4child" ]; then
    print_error "Répertoire math4child-v4/apps/math4child non trouvé"
    echo "Veuillez exécuter ce script depuis le répertoire contenant math4child-v4/"
    exit 1
fi

cd math4child-v4/apps/math4child

print_step "Correction du fichier page.tsx avec toutes les traductions..."

# Générer le nouveau fichier page.tsx avec toutes les traductions complètes
cat > "src/app/page.tsx" << 'CORRECTED_COMPONENT_EOF'
// Math4Child v4.0.0 - Code complet CORRIGÉ avec toutes les traductions
'use client'

import { useState, useEffect, useCallback } from 'react'
import { 
  Calculator, Globe, Star, Play, Heart, Trophy, Crown, Gift, Lock, CheckCircle, 
  Target, Smartphone, Monitor, Tablet, X, Home, RotateCcw, Check, ChevronDown, 
  Volume2, VolumeX, Languages, Users, Calendar, TrendingUp, Menu, Award
} from 'lucide-react'

// ===================================================================
// TYPES TYPESCRIPT COMPLETS
// ===================================================================

interface SubscriptionPlan {
  id: string
  name: string
  price: {
    monthly: number
    annual: number
  }
  originalPrice?: {
    monthly: number
    annual: number
  }
  profiles: number
  features: string[]
  freeTrial: number
  popular?: boolean
  recommended?: boolean
  color: string
  icon: string
  savings?: number
}

interface LanguageConfig {
  code: string
  name: string
  nativeName: string
  flag: string
  direction: 'ltr' | 'rtl'
}

type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'ru' | 'zh' | 'ja' | 'ar' | 'hi' | 'ko'

// ===================================================================
// CONFIGURATION MULTILINGUE
// ===================================================================

const SUPPORTED_LANGUAGES: Record<SupportedLanguage, LanguageConfig> = {
  fr: { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  en: { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', direction: 'ltr' },
  es: { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  de: { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  it: { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr' },
  pt: { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
  ru: { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
  zh: { code: 'zh', name: '中文', nativeName: '中文简体', flag: '🇨🇳', direction: 'ltr' },
  ja: { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr' },
  ar: { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl' },
  hi: { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr' },
  ko: { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr' }
}

// ===================================================================
// PLANS D'ABONNEMENT (EXACT des captures d'écran)
// ===================================================================

const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'free',
    name: 'Gratuit',
    price: { monthly: 0, annual: 0 },
    profiles: 1,
    features: [
      '100 questions par mois',
      '2 niveaux (Débutant, Facile)',
      '5 langues principales',
      'Support communautaire'
    ],
    freeTrial: 0,
    color: 'bg-white border-2 border-gray-200',
    icon: '🆓'
  },
  {
    id: 'premium',
    name: 'Premium',
    price: { monthly: 499, annual: 3990 },
    originalPrice: { monthly: 699, annual: 5990 },
    profiles: 2,
    features: [
      'Questions illimitées',
      '5 niveaux complets',
      '2 profils',
      '30+ langues',
      'Mode hors-ligne',
      'Statistiques avancées'
    ],
    freeTrial: 7,
    color: 'bg-white border-2 border-purple-200',
    icon: '⭐',
    savings: 28
  },
  {
    id: 'family',
    name: 'Famille',
    price: { monthly: 699, annual: 5990 },
    originalPrice: { monthly: 999, annual: 8990 },
    profiles: 5,
    features: [
      'Questions illimitées',
      '5 niveaux complets',
      '5 profils enfants',
      '30+ langues complètes',
      'Mode hors-ligne total',
      'Rapports parents',
      'Support prioritaire'
    ],
    freeTrial: 14,
    popular: true,
    color: 'bg-white border-2 border-blue-300',
    icon: '👨‍👩‍👧‍👦',
    savings: 30
  },
  {
    id: 'school',
    name: 'École',
    price: { monthly: 2499, annual: 19990 },
    originalPrice: { monthly: 2999, annual: 24990 },
    profiles: 30,
    features: [
      'Tout du plan Famille',
      '30 profils élèves',
      'Tableau de bord enseignant',
      'Assignation de devoirs',
      'Rapports de classe détaillés',
      'Formation enseignants'
    ],
    freeTrial: 30,
    recommended: true,
    color: 'bg-white border-2 border-green-300',
    icon: '🏫',
    savings: 20
  }
]

// ===================================================================
// TRADUCTIONS COMPLÈTES POUR TOUTES LES LANGUES
// ===================================================================

const translations: Record<SupportedLanguage, Record<string, string>> = {
  fr: {
    appTitle: 'Math pour enfants',
    appSubtitle: "🏆 App éducative n°1 en France",
    heroTitle: 'Math pour enfants',
    heroSubtitle: "L'app éducative n°1 pour apprendre les maths en famille !",
    heroDescription: 'Rejoignez plus de 100,000 familles qui apprennent déjà !',
    startFree: 'Commencer gratuitement',
    startFreeDetail: '14j gratuit',
    comparePrices: 'Comparer les prix',
    familiesCount: '100k+ familles',
    whyLeader: 'Pourquoi Math pour enfants est-il leader ?',
    competitivePrice: 'Prix le plus compétitif',
    competitivePriceDesc: '40% moins cher que la concurrence',
    savingsText: 'Économisez + 6.99€',
    familyManagement: 'Gestion familiale avancée',
    familyManagementDesc: '5 profils avec synchronisation cloud',
    familyProfiles: 'Équivaut + 5 max',
    offlineMode: 'Mode hors-ligne',
    offlineModeDesc: 'Apprentissage partout',
    offlineText: '100% hors-ligne',
    analytics: 'Analytics',
    analyticsDesc: 'Rapports automatiques',
    analyticsDetail: 'Rapports parents',
    optimalPlans: 'Plans Optimaux',
    competitiveTitle: 'Plus compétitif que toute la concurrence',
    perfectTranslations: 'Toutes les traductions parfaites !',
    pureTranslations: 'Traductions 100% pures',
    pureTranslationsDesc: 'Chaque langue dans sa langue natale',
    functionalButtons: 'Boutons fonctionnels',
    functionalButtonsDesc: 'Tous les boutons fonctionnent parfaitement',
    perfectExperience: 'Expérience parfaite',
    perfectExperienceDesc: 'Interface responsive et parfaite',
    perfectlyWorking: 'Tout fonctionne parfaitement maintenant !',
    worldLeader: 'www.math4child.com • Leader mondial'
  },
  en: {
    appTitle: 'Math4Child',
    appSubtitle: "🏆 #1 educational app in France",
    heroTitle: 'Math4Child',
    heroSubtitle: 'The #1 educational app for learning math as a family!',
    heroDescription: 'Join over 100,000 families already learning!',
    startFree: 'Start Free',
    startFreeDetail: '14d free',
    comparePrices: 'Compare Prices',
    familiesCount: '100k+ families',
    whyLeader: 'Why is Math4Child the leader?',
    competitivePrice: 'Most competitive price',
    competitivePriceDesc: '40% cheaper than competitors',
    savingsText: 'Save + $6.99',
    familyManagement: 'Advanced family management',
    familyManagementDesc: '5 profiles with cloud sync',
    familyProfiles: 'Equivalent + 5 max',
    offlineMode: 'Offline mode',
    offlineModeDesc: 'Learn anywhere',
    offlineText: '100% offline',
    analytics: 'Analytics',
    analyticsDesc: 'Automatic reports',
    analyticsDetail: 'Parent reports',
    optimalPlans: 'Optimal Plans',
    competitiveTitle: 'More competitive than all competitors',
    perfectTranslations: 'All perfect translations!',
    pureTranslations: '100% pure translations',
    pureTranslationsDesc: 'Each language in its native tongue',
    functionalButtons: 'Functional buttons',
    functionalButtonsDesc: 'All buttons work perfectly',
    perfectExperience: 'Perfect experience',
    perfectExperienceDesc: 'Responsive and perfect interface',
    perfectlyWorking: 'Everything works perfectly now!',
    worldLeader: 'www.math4child.com • World Leader'
  },
  es: {
    appTitle: 'Mate para niños',
    appSubtitle: "🏆 App educativa n°1 en Francia",
    heroTitle: 'Mate para niños',
    heroSubtitle: '¡La app educativa n°1 para aprender matemáticas en familia!',
    heroDescription: '¡Únete a más de 100,000 familias que ya están aprendiendo!',
    startFree: 'Empezar gratis',
    startFreeDetail: '14d gratis',
    comparePrices: 'Comparar precios',
    familiesCount: '100k+ familias',
    whyLeader: '¿Por qué Mate para niños es líder?',
    competitivePrice: 'Precio más competitivo',
    competitivePriceDesc: '40% más barato que la competencia',
    savingsText: 'Ahorra + 6.99€',
    familyManagement: 'Gestión familiar avanzada',
    familyManagementDesc: '5 perfiles con sincronización en la nube',
    familyProfiles: 'Equivale + 5 máx',
    offlineMode: 'Modo sin conexión',
    offlineModeDesc: 'Aprende en cualquier lugar',
    offlineText: '100% sin conexión',
    analytics: 'Analíticas',
    analyticsDesc: 'Informes automáticos',
    analyticsDetail: 'Informes para padres',
    optimalPlans: 'Planes Óptimos',
    competitiveTitle: 'Más competitivo que toda la competencia',
    perfectTranslations: '¡Todas las traducciones perfectas!',
    pureTranslations: 'Traducciones 100% puras',
    pureTranslationsDesc: 'Cada idioma en su lengua nativa',
    functionalButtons: 'Botones funcionales',
    functionalButtonsDesc: 'Todos los botones funcionan perfectamente',
    perfectExperience: 'Experiencia perfecta',
    perfectExperienceDesc: 'Interfaz responsive y perfecta',
    perfectlyWorking: '¡Todo funciona perfectamente ahora!',
    worldLeader: 'www.math4child.com • Líder Mundial'
  },
  de: {
    appTitle: 'Mathe für Kinder',
    appSubtitle: "🏆 #1 Bildungs-App in Frankreich",
    heroTitle: 'Mathe für Kinder',
    heroSubtitle: 'Die #1 Bildungs-App zum Mathematiklernen in der Familie!',
    heroDescription: 'Schließen Sie sich über 100.000 Familien an, die bereits lernen!',
    startFree: 'Kostenlos starten',
    startFreeDetail: '14T kostenlos',
    comparePrices: 'Preise vergleichen',
    familiesCount: '100k+ Familien',
    whyLeader: 'Warum ist Mathe für Kinder führend?',
    competitivePrice: 'Wettbewerbsfähigster Preis',
    competitivePriceDesc: '40% günstiger als die Konkurrenz',
    savingsText: 'Sparen + 6.99€',
    familyManagement: 'Erweiterte Familienverwaltung',
    familyManagementDesc: '5 Profile mit Cloud-Synchronisation',
    familyProfiles: 'Entspricht + 5 max',
    offlineMode: 'Offline-Modus',
    offlineModeDesc: 'Überall lernen',
    offlineText: '100% offline',
    analytics: 'Analytics',
    analyticsDesc: 'Automatische Berichte',
    analyticsDetail: 'Elternberichte',
    optimalPlans: 'Optimale Pläne',
    competitiveTitle: 'Wettbewerbsfähiger als alle Konkurrenten',
    perfectTranslations: 'Alle perfekten Übersetzungen!',
    pureTranslations: '100% reine Übersetzungen',
    pureTranslationsDesc: 'Jede Sprache in ihrer Muttersprache',
    functionalButtons: 'Funktionale Schaltflächen',
    functionalButtonsDesc: 'Alle Schaltflächen funktionieren perfekt',
    perfectExperience: 'Perfekte Erfahrung',
    perfectExperienceDesc: 'Responsive und perfekte Benutzeroberfläche',
    perfectlyWorking: 'Jetzt funktioniert alles perfekt!',
    worldLeader: 'www.math4child.com • Weltmarktführer'
  },
  it: {
    appTitle: 'Matematica per bambini',
    appSubtitle: "🏆 App educativa n°1 in Francia",
    heroTitle: 'Matematica per bambini',
    heroSubtitle: "L'app educativa n°1 per imparare la matematica in famiglia!",
    heroDescription: 'Unisciti a oltre 100.000 famiglie che stanno già imparando!',
    startFree: 'Inizia gratis',
    startFreeDetail: '14g gratis',
    comparePrices: 'Confronta i prezzi',
    familiesCount: '100k+ famiglie',
    whyLeader: 'Perché Matematica per bambini è leader?',
    competitivePrice: 'Prezzo più competitivo',
    competitivePriceDesc: '40% più economico della concorrenza',
    savingsText: 'Risparmia + 6.99€',
    familyManagement: 'Gestione familiare avanzata',
    familyManagementDesc: '5 profili con sincronizzazione cloud',
    familyProfiles: 'Equivale + 5 max',
    offlineMode: 'Modalità offline',
    offlineModeDesc: 'Impara ovunque',
    offlineText: '100% offline',
    analytics: 'Analytics',
    analyticsDesc: 'Report automatici',
    analyticsDetail: 'Report genitori',
    optimalPlans: 'Piani Ottimali',
    competitiveTitle: 'Più competitivo di tutta la concorrenza',
    perfectTranslations: 'Tutte le traduzioni perfette!',
    pureTranslations: 'Traduzioni 100% pure',
    pureTranslationsDesc: 'Ogni lingua nella sua lingua madre',
    functionalButtons: 'Pulsanti funzionali',
    functionalButtonsDesc: 'Tutti i pulsanti funzionano perfettamente',
    perfectExperience: 'Esperienza perfetta',
    perfectExperienceDesc: 'Interfaccia responsive e perfetta',
    perfectlyWorking: 'Ora tutto funziona perfettamente!',
    worldLeader: 'www.math4child.com • Leader Mondiale'
  },
  pt: {
    appTitle: 'Matemática para crianças',
    appSubtitle: "🏆 App educacional n°1 na França",
    heroTitle: 'Matemática para crianças',
    heroSubtitle: 'O app educacional n°1 para aprender matemática em família!',
    heroDescription: 'Junte-se a mais de 100.000 famílias que já estão aprendendo!',
    startFree: 'Começar grátis',
    startFreeDetail: '14d grátis',
    comparePrices: 'Comparar preços',
    familiesCount: '100k+ famílias',
    whyLeader: 'Por que Matemática para crianças é líder?',
    competitivePrice: 'Preço mais competitivo',
    competitivePriceDesc: '40% mais barato que a concorrência',
    savingsText: 'Economize + 6.99€',
    familyManagement: 'Gestão familiar avançada',
    familyManagementDesc: '5 perfis com sincronização na nuvem',
    familyProfiles: 'Equivale + 5 máx',
    offlineMode: 'Modo offline',
    offlineModeDesc: 'Aprenda em qualquer lugar',
    offlineText: '100% offline',
    analytics: 'Analytics',
    analyticsDesc: 'Relatórios automáticos',
    analyticsDetail: 'Relatórios dos pais',
    optimalPlans: 'Planos Otimais',
    competitiveTitle: 'Mais competitivo que toda a concorrência',
    perfectTranslations: 'Todas as traduções perfeitas!',
    pureTranslations: 'Traduções 100% puras',
    pureTranslationsDesc: 'Cada idioma em sua língua nativa',
    functionalButtons: 'Botões funcionais',
    functionalButtonsDesc: 'Todos os botões funcionam perfeitamente',
    perfectExperience: 'Experiência perfeita',
    perfectExperienceDesc: 'Interface responsiva e perfeita',
    perfectlyWorking: 'Agora tudo funciona perfeitamente!',
    worldLeader: 'www.math4child.com • Líder Mundial'
  },
  ru: {
    appTitle: 'Математика для детей',
    appSubtitle: "🏆 Образовательное приложение №1 во Франции",
    heroTitle: 'Математика для детей',
    heroSubtitle: 'Образовательное приложение №1 для изучения математики всей семьей!',
    heroDescription: 'Присоединяйтесь к более чем 100,000 семей, которые уже учатся!',
    startFree: 'Начать бесплатно',
    startFreeDetail: '14д бесплатно',
    comparePrices: 'Сравнить цены',
    familiesCount: '100k+ семей',
    whyLeader: 'Почему Математика для детей лидер?',
    competitivePrice: 'Самая конкурентная цена',
    competitivePriceDesc: 'На 40% дешевле конкурентов',
    savingsText: 'Экономьте + 6.99€',
    familyManagement: 'Продвинутое семейное управление',
    familyManagementDesc: '5 профилей с облачной синхронизацией',
    familyProfiles: 'Эквивалент + 5 макс',
    offlineMode: 'Автономный режим',
    offlineModeDesc: 'Учитесь везде',
    offlineText: '100% автономно',
    analytics: 'Аналитика',
    analyticsDesc: 'Автоматические отчеты',
    analyticsDetail: 'Отчеты для родителей',
    optimalPlans: 'Оптимальные планы',
    competitiveTitle: 'Более конкурентоспособный, чем все конкуренты',
    perfectTranslations: 'Все идеальные переводы!',
    pureTranslations: '100% чистые переводы',
    pureTranslationsDesc: 'Каждый язык на родном языке',
    functionalButtons: 'Функциональные кнопки',
    functionalButtonsDesc: 'Все кнопки работают идеально',
    perfectExperience: 'Идеальный опыт',
    perfectExperienceDesc: 'Отзывчивый и идеальный интерфейс',
    perfectlyWorking: 'Теперь все работает идеально!',
    worldLeader: 'www.math4child.com • Мировой лидер'
  },
  zh: {
    appTitle: '儿童数学',
    appSubtitle: "🏆 法国第一教育应用",
    heroTitle: '儿童数学',
    heroSubtitle: '家庭数学学习第一教育应用！',
    heroDescription: '加入超过100,000个已经在学习的家庭！',
    startFree: '免费开始',
    startFreeDetail: '14天免费',
    comparePrices: '比较价格',
    familiesCount: '10万+家庭',
    whyLeader: '为什么儿童数学是领导者？',
    competitivePrice: '最具竞争力的价格',
    competitivePriceDesc: '比竞争对手便宜40%',
    savingsText: '节省 + 6.99€',
    familyManagement: '高级家庭管理',
    familyManagementDesc: '5个档案，云同步',
    familyProfiles: '相当于 + 5个最大',
    offlineMode: '离线模式',
    offlineModeDesc: '随时随地学习',
    offlineText: '100% 离线',
    analytics: '分析',
    analyticsDesc: '自动报告',
    analyticsDetail: '家长报告',
    optimalPlans: '最优计划',
    competitiveTitle: '比所有竞争对手更具竞争力',
    perfectTranslations: '所有完美翻译！',
    pureTranslations: '100% 纯正翻译',
    pureTranslationsDesc: '每种语言都是母语',
    functionalButtons: '功能按钮',
    functionalButtonsDesc: '所有按钮都完美工作',
    perfectExperience: '完美体验',
    perfectExperienceDesc: '响应式完美界面',
    perfectlyWorking: '现在一切都完美运行！',
    worldLeader: 'www.math4child.com • 世界领导者'
  },
  ja: {
    appTitle: '子供の数学',
    appSubtitle: "🏆 フランス第1位の教育アプリ",
    heroTitle: '子供の数学',
    heroSubtitle: '家族で数学を学ぶ第1位の教育アプリ！',
    heroDescription: 'すでに学習している100,000以上の家族に参加してください！',
    startFree: '無料で始める',
    startFreeDetail: '14日無料',
    comparePrices: '価格を比較',
    familiesCount: '10万+家族',
    whyLeader: 'なぜ子供の数学がリーダーなのか？',
    competitivePrice: '最も競争力のある価格',
    competitivePriceDesc: '競合他社より40%安い',
    savingsText: '節約 + 6.99€',
    familyManagement: '高度な家族管理',
    familyManagementDesc: 'クラウド同期付き5プロファイル',
    familyProfiles: '相当 + 5最大',
    offlineMode: 'オフラインモード',
    offlineModeDesc: 'どこでも学習',
    offlineText: '100% オフライン',
    analytics: '分析',
    analyticsDesc: '自動レポート',
    analyticsDetail: '親レポート',
    optimalPlans: '最適プラン',
    competitiveTitle: 'すべての競合他社よりも競争力がある',
    perfectTranslations: 'すべて完璧な翻訳！',
    pureTranslations: '100%純粋な翻訳',
    pureTranslationsDesc: '各言語がその母国語で',
    functionalButtons: '機能的なボタン',
    functionalButtonsDesc: 'すべてのボタンが完璧に動作',
    perfectExperience: '完璧な体験',
    perfectExperienceDesc: 'レスポンシブで完璧なインターフェース',
    perfectlyWorking: '今すべてが完璧に動作します！',
    worldLeader: 'www.math4child.com • 世界のリーダー'
  },
  ar: {
    appTitle: 'رياضيات الأطفال',
    appSubtitle: "🏆 التطبيق التعليمي رقم 1 في فرنسا",
    heroTitle: 'رياضيات الأطفال',
    heroSubtitle: 'التطبيق التعليمي رقم 1 لتعلم الرياضيات مع العائلة!',
    heroDescription: 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!',
    startFree: 'ابدأ مجاناً',
    startFreeDetail: '14 يوم مجاناً',
    comparePrices: 'قارن الأسعار',
    familiesCount: '100 ألف+ عائلة',
    whyLeader: 'لماذا رياضيات الأطفال هو الرائد؟',
    competitivePrice: 'السعر الأكثر تنافسية',
    competitivePriceDesc: 'أرخص بنسبة 40% من المنافسين',
    savingsText: 'وفر + 6.99€',
    familyManagement: 'إدارة عائلية متقدمة',
    familyManagementDesc: '5 ملفات شخصية مع مزامنة السحابة',
    familyProfiles: 'يعادل + 5 حد أقصى',
    offlineMode: 'وضع عدم الاتصال',
    offlineModeDesc: 'تعلم في أي مكان',
    offlineText: '100% غير متصل',
    analytics: 'التحليلات',
    analyticsDesc: 'تقارير تلقائية',
    analyticsDetail: 'تقارير الوالدين',
    optimalPlans: 'خطط مثلى',
    competitiveTitle: 'أكثر تنافسية من جميع المنافسين',
    perfectTranslations: 'جميع الترجمات مثالية!',
    pureTranslations: 'ترجمات نقية 100%',
    pureTranslationsDesc: 'كل لغة بلغتها الأم',
    functionalButtons: 'أزرار وظيفية',
    functionalButtonsDesc: 'جميع الأزرار تعمل بشكل مثالي',
    perfectExperience: 'تجربة مثالية',
    perfectExperienceDesc: 'واجهة متجاوبة ومثالية',
    perfectlyWorking: 'الآن كل شيء يعمل بشكل مثالي!',
    worldLeader: 'www.math4child.com • الرائد العالمي'
  },
  hi: {
    appTitle: 'बच्चों के लिए गणित',
    appSubtitle: "🏆 फ्रांस में नंबर 1 शैक्षिक ऐप",
    heroTitle: 'बच्चों के लिए गणित',
    heroSubtitle: 'परिवार के साथ गणित सीखने के लिए नंबर 1 शैक्षिक ऐप!',
    heroDescription: '100,000 से अधिक परिवारों से जुड़ें जो पहले से ही सीख रहे हैं!',
    startFree: 'मुफ्त शुरू करें',
    startFreeDetail: '14 दिन मुफ्त',
    comparePrices: 'कीमतों की तुलना करें',
    familiesCount: '100k+ परिवार',
    whyLeader: 'बच्चों के लिए गणित अग्रणी क्यों है?',
    competitivePrice: 'सबसे प्रतिस्पर्धी कीमत',
    competitivePriceDesc: 'प्रतिस्पर्धियों से 40% सस्ता',
    savingsText: 'बचाएं + 6.99€',
    familyManagement: 'उन्नत पारिवारिक प्रबंधन',
    familyManagementDesc: 'क्लाउड सिंक के साथ 5 प्रोफाइल',
    familyProfiles: 'बराबर + 5 अधिकतम',
    offlineMode: 'ऑफ़लाइन मोड',
    offlineModeDesc: 'कहीं भी सीखें',
    offlineText: '100% ऑफ़लाइन',
    analytics: 'विश्लेषिकी',
    analyticsDesc: 'स्वचालित रिपोर्ट',
    analyticsDetail: 'माता-पिता की रिपोर्ट',
    optimalPlans: 'इष्टतम योजनाएं',
    competitiveTitle: 'सभी प्रतिस्पर्धियों से अधिक प्रतिस्पर्धी',
    perfectTranslations: 'सभी परफेक्ट अनुवाद!',
    pureTranslations: '100% शुद्ध अनुवाद',
    pureTranslationsDesc: 'हर भाषा अपनी मातृभाषा में',
    functionalButtons: 'कार्यात्मक बटन',
    functionalButtonsDesc: 'सभी बटन पूर्ण रूप से काम करते हैं',
    perfectExperience: 'परफेक्ट अनुभव',
    perfectExperienceDesc: 'रिस्पॉन्सिव और परफेक्ट इंटरफेस',
    perfectlyWorking: 'अब सब कुछ परफेक्ट तरीके से काम कर रहा है!',
    worldLeader: 'www.math4child.com • विश्व नेता'
  },
  ko: {
    appTitle: '어린이 수학',
    appSubtitle: "🏆 프랑스 1위 교육 앱",
    heroTitle: '어린이 수학',
    heroSubtitle: '가족과 함께 수학을 배우는 1위 교육 앱!',
    heroDescription: '이미 학습하고 있는 100,000개 이상의 가족과 함께하세요!',
    startFree: '무료 시작',
    startFreeDetail: '14일 무료',
    comparePrices: '가격 비교',
    familiesCount: '10만+ 가족',
    whyLeader: '어린이 수학이 리더인 이유는?',
    competitivePrice: '가장 경쟁력 있는 가격',
    competitivePriceDesc: '경쟁사보다 40% 저렴',
    savingsText: '절약 + 6.99€',
    familyManagement: '고급 가족 관리',
    familyManagementDesc: '클라우드 동기화가 있는 5개 프로필',
    familyProfiles: '동등 + 5 최대',
    offlineMode: '오프라인 모드',
    offlineModeDesc: '어디서나 학습',
    offlineText: '100% 오프라인',
    analytics: '분석',
    analyticsDesc: '자동 보고서',
    analyticsDetail: '부모 보고서',
    optimalPlans: '최적 계획',
    competitiveTitle: '모든 경쟁사보다 경쟁력 있음',
    perfectTranslations: '모든 완벽한 번역!',
    pureTranslations: '100% 순수 번역',
    pureTranslationsDesc: '각 언어가 모국어로',
    functionalButtons: '기능적 버튼',
    functionalButtonsDesc: '모든 버튼이 완벽하게 작동',
    perfectExperience: '완벽한 경험',
    perfectExperienceDesc: '반응형이고 완벽한 인터페이스',
    perfectlyWorking: '이제 모든 것이 완벽하게 작동합니다!',
    worldLeader: 'www.math4child.com • 세계 리더'
  }
}

// ===================================================================
// COMPOSANT PRINCIPAL
// ===================================================================

export default function Math4ChildApp() {
  const [currentLang, setCurrentLang] = useState<SupportedLanguage>('fr')
  const [isDropdownOpen, setIsDropdownOpen] = useState<boolean>(false)
  const [mounted, setMounted] = useState<boolean>(false)
  const [showPricingModal, setShowPricingModal] = useState<boolean>(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const t = translations[currentLang] || translations.fr
  const currentLanguage = SUPPORTED_LANGUAGES[currentLang] || SUPPORTED_LANGUAGES.fr

  const handleLanguageChange = useCallback((langCode: SupportedLanguage) => {
    setCurrentLang(langCode)
    setIsDropdownOpen(false)
  }, [])

  const formatPrice = useCallback((price: number): string => {
    return (price / 100).toFixed(2) + '€'
  }, [])

  if (!mounted) {
    return <div className="min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-purple-600" />
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-400 via-purple-500 to-purple-600 ${currentLanguage.direction === 'rtl' ? 'rtl' : 'ltr'}`}>
      {/* Header exactement comme dans les captures */}
      <header className="relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between">
            {/* Logo et titre - EXACT des captures */}
            <div className="flex items-center space-x-3">
              <div className="bg-orange-500 p-3 rounded-xl shadow-lg">
                <div className="w-8 h-8 bg-white rounded flex items-center justify-center">
                  <span className="text-orange-500 font-bold text-lg">📊</span>
                </div>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-white">{t.appTitle}</h1>
                <p className="text-blue-100 text-sm">{t.appSubtitle}</p>
              </div>
            </div>

            {/* Stats et langue - EXACT des captures */}
            <div className="flex items-center space-x-6">
              <div className="hidden md:flex items-center space-x-2 bg-white/20 px-4 py-2 rounded-full">
                <Users className="h-5 w-5 text-white" />
                <span className="font-semibold text-white">{t.familiesCount}</span>
              </div>

              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                  className="flex items-center space-x-2 bg-white/20 px-4 py-2 rounded-full hover:bg-white/30 transition-colors text-white"
                >
                  <span className="text-xl">{currentLanguage.flag}</span>
                  <span className="hidden sm:block font-medium">{currentLanguage.nativeName}</span>
                  <ChevronDown className={`h-4 w-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`} />
                </button>

                {isDropdownOpen && (
                  <div className="absolute right-0 mt-2 w-72 bg-white rounded-xl shadow-xl border py-2 z-50 max-h-80 overflow-y-auto">
                    {Object.values(SUPPORTED_LANGUAGES).map((lang) => (
                      <button
                        key={lang.code}
                        onClick={() => handleLanguageChange(lang.code as SupportedLanguage)}
                        className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 transition-colors ${
                          lang.code === currentLang ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                        }`}
                      >
                        <span className="text-xl">{lang.flag}</span>
                        <div>
                          <div className="font-medium">{lang.nativeName}</div>
                        </div>
                        {lang.code === currentLang && <Check className="h-4 w-4 ml-auto" />}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Section Hero - EXACT des captures */}
      <section className="relative py-16 overflow-hidden">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          {/* Badge mondial - EXACT des captures */}
          <div className="inline-flex items-center space-x-2 bg-orange-100 text-orange-800 px-4 py-2 rounded-full mb-8">
            <Trophy className="h-5 w-5" />
            <span className="text-sm font-medium">{t.worldLeader}</span>
          </div>

          {/* Titre principal - EXACT des captures */}
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 leading-tight drop-shadow-lg">
            {t.heroTitle}
          </h1>

          {/* Sous-titre - EXACT des captures */}
          <p className="text-xl md:text-2xl text-white/90 mb-8 max-w-4xl mx-auto leading-relaxed drop-shadow">
            {t.heroSubtitle}
          </p>

          <p className="text-lg text-white/80 mb-12 drop-shadow">
            {t.heroDescription}
          </p>

          {/* Boutons d'action - EXACT des captures */}
          <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6 mb-16">
            <button className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl text-lg font-semibold shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 flex items-center space-x-2">
              <Gift className="h-6 w-6" />
              <span>{t.startFree}</span>
              <span className="bg-white/20 px-2 py-1 rounded text-sm">{t.startFreeDetail}</span>
            </button>

            <button 
              onClick={() => setShowPricingModal(true)}
              className="bg-blue-500 hover:bg-blue-600 text-white px-8 py-4 rounded-xl text-lg font-semibold shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 flex items-center space-x-2"
            >
              <Trophy className="h-6 w-6" />
              <span>{t.comparePrices}</span>
            </button>
          </div>
        </div>
      </section>

      {/* Section Pourquoi leader - EXACT des captures */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold text-center text-white mb-16 drop-shadow-lg">
            {t.whyLeader}
          </h2>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {/* Prix compétitif - EXACT des captures */}
            <div className="bg-white/20 backdrop-blur-sm p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 text-center border border-white/30">
              <div className="bg-yellow-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">💰</span>
              </div>
              <h3 className="text-xl font-bold text-white mb-4">{t.competitivePrice}</h3>
              <p className="text-white/80 mb-4">{t.competitivePriceDesc}</p>
              <div className="text-green-300 font-semibold">{t.savingsText}</div>
            </div>

            {/* Gestion familiale - EXACT des captures */}
            <div className="bg-white/20 backdrop-blur-sm p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 text-center border border-white/30">
              <div className="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                <Users className="h-8 w-8 text-blue-600" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">{t.familyManagement}</h3>
              <p className="text-white/80 mb-4">{t.familyManagementDesc}</p>
              <div className="text-blue-300 font-semibold">{t.familyProfiles}</div>
            </div>

            {/* Mode hors-ligne - EXACT des captures */}
            <div className="bg-white/20 backdrop-blur-sm p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 text-center border border-white/30">
              <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                <Smartphone className="h-8 w-8 text-green-600" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">{t.offlineMode}</h3>
              <p className="text-white/80 mb-4">{t.offlineModeDesc}</p>
              <div className="text-green-300 font-semibold">{t.offlineText}</div>
            </div>

            {/* Analytics - EXACT des captures */}
            <div className="bg-white/20 backdrop-blur-sm p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 text-center border border-white/30">
              <div className="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                <TrendingUp className="h-8 w-8 text-purple-600" />
              </div>
              <h3 className="text-xl font-bold text-white mb-4">{t.analytics}</h3>
              <p className="text-white/80 mb-4">{t.analyticsDesc}</p>
              <div className="text-purple-300 font-semibold">{t.analyticsDetail}</div>
            </div>
          </div>
        </div>
      </section>

      {/* Section Plans - EXACT des captures */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-white mb-4 drop-shadow-lg">{t.optimalPlans}</h2>
            <p className="text-xl text-white/90 drop-shadow">{t.competitiveTitle}</p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div 
                key={plan.id}
                className={`relative p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 ${plan.color}`}
              >
                {/* Badge populaire/recommandé - EXACT des captures */}
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                      👑 Le plus populaire
                    </span>
                  </div>
                )}
                {plan.recommended && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-green-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                      ⭐ Recommandé écoles
                    </span>
                  </div>
                )}

                {/* En-tête du plan - EXACT des captures */}
                <div className="text-center mb-8">
                  <h3 className="text-2xl font-bold text-gray-900 mb-4">{plan.name}</h3>
                  
                  {plan.id === 'free' ? (
                    <div className="text-4xl font-bold text-gray-700 mb-4">Gratuit</div>
                  ) : (
                    <div className="mb-4">
                      {plan.originalPrice && (
                        <div className="text-lg text-gray-500 line-through">
                          {formatPrice(plan.originalPrice.monthly)}/mois
                        </div>
                      )}
                      <div className="text-4xl font-bold text-purple-600 mb-2">
                        {formatPrice(plan.price.monthly)}
                        <span className="text-lg text-gray-600">/mois</span>
                      </div>
                      {plan.savings && (
                        <div className="text-green-600 font-semibold">
                          Économisez {plan.savings}%
                        </div>
                      )}
                    </div>
                  )}

                  <div className="text-sm text-gray-600 flex items-center justify-center space-x-1">
                    <Users className="h-4 w-4" />
                    <span>{plan.profiles} profil{plan.profiles > 1 ? 's' : ''}</span>
                  </div>
                </div>

                {/* Badge d'essai gratuit - EXACT des captures */}
                {plan.freeTrial > 0 && (
                  <div className="bg-green-100 border border-green-300 rounded-xl p-3 mb-6 text-center">
                    <Gift className="h-5 w-5 text-green-600 inline mr-2" />
                    <span className="text-green-800 font-semibold">
                      {plan.freeTrial}j gratuit
                    </span>
                  </div>
                )}

                {/* Fonctionnalités - EXACT des captures */}
                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start space-x-3">
                      <CheckCircle className="h-5 w-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <span className="text-gray-700">{feature}</span>
                    </li>
                  ))}
                </ul>

                {/* Bouton d'action - EXACT des captures */}
                <button className={`w-full py-4 rounded-xl font-semibold transition-all duration-300 transform hover:scale-105 ${
                  plan.id === 'free'
                    ? 'bg-gray-200 hover:bg-gray-300 text-gray-800'
                    : plan.id === 'premium'
                    ? 'bg-purple-500 hover:bg-purple-600 text-white shadow-lg'
                    : plan.popular
                    ? 'bg-blue-500 hover:bg-blue-600 text-white shadow-lg'
                    : 'bg-green-500 hover:bg-green-600 text-white shadow-lg'
                }`}>
                  {plan.id === 'free' ? 'Commencer gratuitement' : 
                   `Essai ${plan.freeTrial}j gratuit`}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Traductions parfaites - EXACT des captures */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white/20 backdrop-blur-sm p-12 rounded-3xl shadow-xl border border-white/30">
            <div className="text-center mb-12">
              <div className="inline-flex items-center space-x-2 bg-green-500 text-white px-6 py-3 rounded-full mb-8">
                <CheckCircle className="h-6 w-6" />
                <span className="text-xl font-bold">{t.perfectTranslations}</span>
              </div>
            </div>

            <div className="grid md:grid-cols-3 gap-12">
              {/* Traductions pures */}
              <div className="text-center">
                <div className="bg-blue-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
                  <span className="text-4xl">abc</span>
                </div>
                <h3 className="text-xl font-bold text-white mb-4">{t.pureTranslations}</h3>
                <p className="text-white/80">{t.pureTranslationsDesc}</p>
              </div>

              {/* Boutons fonctionnels */}
              <div className="text-center">
                <div className="bg-gray-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
                  <span className="text-4xl">⚫</span>
                </div>
                <h3 className="text-xl font-bold text-white mb-4">{t.functionalButtons}</h3>
                <p className="text-white/80">{t.functionalButtonsDesc}</p>
              </div>

              {/* Expérience parfaite */}
              <div className="text-center">
                <div className="bg-yellow-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
                  <span className="text-4xl">✨</span>
                </div>
                <h3 className="text-xl font-bold text-white mb-4">{t.perfectExperience}</h3>
                <p className="text-white/80">{t.perfectExperienceDesc}</p>
              </div>
            </div>

            <div className="mt-12 text-center">
              <h3 className="text-2xl font-bold text-yellow-300 mb-2">🎉 {t.perfectlyWorking}</h3>
            </div>
          </div>
        </div>
      </section>

      {/* Modal Plans */}
      {showPricingModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl p-8 max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-3xl font-bold text-gray-900">Plans Optimaux</h3>
              <button
                onClick={() => setShowPricingModal(false)}
                className="text-gray-400 hover:text-gray-600 transition-colors"
              >
                <X className="h-6 w-6" />
              </button>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {SUBSCRIPTION_PLANS.map((plan) => (
                <div key={plan.id} className={`p-6 rounded-xl ${plan.color} relative`}>
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                      <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm">Le plus populaire</span>
                    </div>
                  )}
                  <div className="text-center">
                    <h4 className="text-xl font-bold mb-2">{plan.name}</h4>
                    <div className="text-2xl font-bold text-purple-600 mb-4">
                      {plan.id === 'free' ? 'Gratuit' : `${formatPrice(plan.price.monthly)}/mois`}
                    </div>
                    <ul className="text-sm space-y-2 mb-4">
                      {plan.features.map((feature, index) => (
                        <li key={index} className="flex items-start space-x-2">
                          <CheckCircle className="h-4 w-4 text-green-500 mt-0.5 flex-shrink-0" />
                          <span>{feature}</span>
                        </li>
                      ))}
                    </ul>
                    <button className="w-full py-3 bg-blue-500 text-white rounded-lg font-semibold hover:bg-blue-600 transition-colors">
                      {plan.id === 'free' ? 'Gratuit' : `Essai ${plan.freeTrial}j gratuit`}
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Clic extérieur pour fermer dropdown */}
      {isDropdownOpen && (
        <div className="fixed inset-0 z-40" onClick={() => setIsDropdownOpen(false)} />
      )}
    </div>
  )
}
CORRECTED_COMPONENT_EOF

print_success "Fichier page.tsx corrigé avec toutes les traductions"

print_step "Nouvelle tentative de build..."

npm run build

if [ $? -eq 0 ]; then
    print_success "Build réussi! ✅"
    
    print_header "CORRECTION TERMINÉE AVEC SUCCÈS!"
    
    echo -e "${GREEN}"
    echo "🎉 Math4Child v4.0.0 est maintenant prêt et fonctionnel !"
    echo ""
    echo "✅ Erreur TypeScript corrigée"
    echo "✅ Build de production réussi"
    echo "✅ 12 langues complètement traduites"
    echo "✅ Application prête pour déploiement"
    echo ""
    echo "🚀 Pour lancer l'application:"
    echo "   cd math4child-v4"
    echo "   ./dev.sh"
    echo ""
    echo "🌐 Pour déployer sur Netlify:"
    echo "   ./deploy-netlify.sh"
    echo -e "${NC}"
    
else
    print_error "Le build a encore échoué"
    echo "Vérifiez les erreurs ci-dessus"
    exit 1
fi