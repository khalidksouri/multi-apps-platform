'use client'

import { useState, useEffect } from 'react'
import { 
  Calculator, Globe, Star, Play, Heart, Trophy, Crown, Gift, Lock, CheckCircle, 
  Target, Smartphone, Monitor, Tablet, X, Home, RotateCcw, Check, ChevronDown, 
  Volume2, VolumeX, Languages, Users, Calendar, TrendingUp, Menu
} from 'lucide-react'

// Types TypeScript corrigés
interface Question {
  id: string
  question: string
  answer: number
  operation: string
  level: number
  offline?: boolean
}

interface CompetitivePlan {
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
  freeQuestions: number
  popular?: boolean
  recommended?: boolean
  color: string
  icon: string
  target: string
  savings?: number
}

interface PaymentProvider {
  name: string
  platform: 'web' | 'ios' | 'android' | 'all'
  fees: string
  advantages: string[]
}

interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  direction: 'ltr' | 'rtl'
  appName: string
}

// Types pour les variables non utilisées (corrigés)
type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'ru' | 'zh' | 'ja' | 'ar' | 'hi' | 'ko'
type ViewType = 'home' | 'game' | 'subscription'

// Configuration multilingue
const SUPPORTED_LANGUAGES: Record<SupportedLanguage, LanguageConfig> = {
  fr: { name: 'Français', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr', appName: 'Math4Enfants' },
  en: { name: 'English', nativeName: 'English', flag: '🇺🇸', direction: 'ltr', appName: 'Math4Child' },
  es: { name: 'Español', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr', appName: 'Mate4Niños' },
  de: { name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr', appName: 'Mathe4Kinder' },
  it: { name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr', appName: 'Mate4Bambini' },
  pt: { name: 'Português', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr', appName: 'Matemática4Crianças' },
  ru: { name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr', appName: 'Математика4Дети' },
  zh: { name: '中文', nativeName: '中文简体', flag: '🇨🇳', direction: 'ltr', appName: '儿童数学4' },
  ja: { name: '日本語', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr', appName: 'さんすう4こども' },
  ar: { name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl', appName: 'رياضيات4أطفال' },
  hi: { name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr', appName: 'गणित4बच्चे' },
  ko: { name: '한국어', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr', appName: '수학4어린이' }
}

// PLANS COMPÉTITIFS CORRIGÉS
const COMPETITIVE_PLANS: CompetitivePlan[] = [
  {
    id: 'free',
    name: 'Gratuit',
    price: { monthly: 0, annual: 0 },
    profiles: 1,
    features: [
      '100 questions par mois',
      '2 niveaux (Débutant, Facile)',
      '5 langues principales',
      'Support communautaire',
      'Mode hors-ligne limité'
    ],
    freeTrial: 0,
    freeQuestions: 100,
    color: 'bg-gray-100 border-gray-300',
    icon: '🆓',
    target: 'Découverte et test'
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
      'Statistiques avancées',
      'Rapports parents',
      'Support prioritaire',
      'Synchronisation cloud',
      'Badges et récompenses'
    ],
    freeTrial: 14,
    freeQuestions: 0,
    popular: true,
    color: 'bg-gradient-to-br from-blue-50 to-purple-50 border-blue-500',
    icon: '👨‍👩‍👧‍👦',
    target: 'Familles (Plan optimal)',
    savings: 30
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
      'Statistiques détaillées',
      'Support email'
    ],
    freeTrial: 7,
    freeQuestions: 0,
    color: 'bg-gradient-to-br from-purple-50 to-pink-50 border-purple-500',
    icon: '⭐',
    target: 'Utilisateurs avancés',
    savings: 28
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
      'API pour systèmes LMS',
      'Formation incluse',
      'Support téléphonique dédié',
      'Statistiques pédagogiques',
      'Gestion des groupes'
    ],
    freeTrial: 30,
    freeQuestions: 0,
    recommended: true,
    color: 'bg-gradient-to-br from-green-50 to-emerald-50 border-green-500',
    icon: '🏫',
    target: 'Écoles et enseignants',
    savings: 20
  }
]

// Traductions simplifiées
const translations: Record<SupportedLanguage, Record<string, string>> = {
  fr: {
    title: 'Math4Enfants',
    subtitle: 'L\'app éducative n°1 pour apprendre les maths en famille !',
    welcome: 'Rejoignez plus de 100,000 familles qui apprennent déjà !',
    startFree: 'Commencer gratuitement',
    whyLeader: 'Pourquoi Math4Child est-il leader ?',
    competitive: 'Prix le plus compétitif',
    competitiveDesc: '40% moins cher que la concurrence',
    family: 'Gestion familiale avancée',
    familyDesc: '5 profils avec synchronisation cloud'
  },
  en: {
    title: 'Math4Child',
    subtitle: 'The #1 educational app for learning math as a family!',
    welcome: 'Join over 100,000 families already learning!',
    startFree: 'Start Free',
    whyLeader: 'Why Math4Child is the leader?',
    competitive: 'Most competitive pricing',
    competitiveDesc: '40% cheaper than competition',
    family: 'Advanced family management',
    familyDesc: '5 profiles with cloud sync'
  },
  es: {
    title: 'Mate4Niños',
    subtitle: '¡La app educativa #1 para aprender matemáticas en familia!',
    welcome: '¡Únete a más de 100,000 familias que ya están aprendiendo!',
    startFree: 'Empezar gratis',
    whyLeader: '¿Por qué Mate4Niños es líder?',
    competitive: 'Precios más competitivos',
    competitiveDesc: '40% más barato que la competencia',
    family: 'Gestión familiar avanzada',
    familyDesc: '5 perfiles con sincronización en la nube'
  },
  // Autres langues basiques...
  de: { title: 'Mathe4Kinder', subtitle: 'Die #1 Lern-App für Mathematik!', welcome: 'Über 100.000 Familien lernen bereits!', startFree: 'Kostenlos starten', whyLeader: 'Warum ist Mathe4Kinder führend?', competitive: 'Wettbewerbsfähigste Preise', competitiveDesc: '40% günstiger als die Konkurrenz', family: 'Erweiterte Familienverwaltung', familyDesc: '5 Profile mit Cloud-Sync' },
  it: { title: 'Mate4Bambini', subtitle: 'L\'app educativa #1 per imparare la matematica in famiglia!', welcome: 'Unisciti a oltre 100.000 famiglie che già imparano!', startFree: 'Inizia gratis', whyLeader: 'Perché Mate4Bambini è leader?', competitive: 'Prezzi più competitivi', competitiveDesc: '40% più economico della concorrenza', family: 'Gestione familiare avanzata', familyDesc: '5 profili con sincronizzazione cloud' },
  pt: { title: 'Matemática4Crianças', subtitle: 'O app educativo #1 para aprender matemática em família!', welcome: 'Junte-se a mais de 100.000 famílias que já estão aprendendo!', startFree: 'Começar grátis', whyLeader: 'Por que Matemática4Crianças é líder?', competitive: 'Preços mais competitivos', competitiveDesc: '40% mais barato que a concorrência', family: 'Gestão familiar avançada', familyDesc: '5 perfis com sincronização na nuvem' },
  ru: { title: 'Математика4Дети', subtitle: 'Образовательное приложение #1 для изучения математики в семье!', welcome: 'Присоединяйтесь к более чем 100 000 семей, которые уже учатся!', startFree: 'Начать бесплатно', whyLeader: 'Почему Математика4Дети - лидер?', competitive: 'Самые конкурентные цены', competitiveDesc: 'На 40% дешевле конкурентов', family: 'Расширенное семейное управление', familyDesc: '5 профилей с облачной синхронизацией' },
  zh: { title: '儿童数学4', subtitle: '家庭数学学习第一教育应用！', welcome: '超过100,000个家庭已经在学习！', startFree: '免费开始', whyLeader: '为什么儿童数学4是领导者？', competitive: '最具竞争力的价格', competitiveDesc: '比竞争对手便宜40%', family: '高级家庭管理', familyDesc: '5个配置文件，云同步' },
  ja: { title: 'さんすう4こども', subtitle: '家族で数学を学ぶための教育アプリNo.1！', welcome: 'すでに10万以上の家族が学習中！', startFree: '無料で始める', whyLeader: 'なぜさんすう4こどもがリーダーなのか？', competitive: '最も競争力のある価格', competitiveDesc: '競合他社より40%安い', family: '高度な家族管理', familyDesc: 'クラウド同期付き5プロファイル' },
  ar: { title: 'رياضيات4أطفال', subtitle: 'التطبيق التعليمي رقم 1 لتعلم الرياضيات كعائلة!', welcome: 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!', startFree: 'ابدأ مجاناً', whyLeader: 'لماذا رياضيات4أطفال هو الأفضل؟', competitive: 'أسعار تنافسية للغاية', competitiveDesc: 'أرخص بنسبة 40% من المنافسة', family: 'إدارة عائلية متقدمة', familyDesc: '5 ملفات شخصية مع المزامنة السحابية' },
  hi: { title: 'गणित4बच्चे', subtitle: 'परिवार के साथ गणित सीखने के लिए शिक्षा ऐप #1!', welcome: '100,000 से अधिक परिवार पहले से सीख रहे हैं!', startFree: 'मुफ्त शुरू करें', whyLeader: 'गणित4बच्चे क्यों अग्रणी है?', competitive: 'सबसे प्रतिस्पर्धी मूल्य', competitiveDesc: 'प्रतिस्पर्धा से 40% सस्ता', family: 'उन्नत पारिवारिक प्रबंधन', familyDesc: 'क्लाउड सिंक के साथ 5 प्रोफ़ाइल' },
  ko: { title: '수학4어린이', subtitle: '가족과 함께 수학을 배우는 교육 앱 1위!', welcome: '이미 100,000개 이상의 가족이 학습 중입니다!', startFree: '무료로 시작', whyLeader: '수학4어린이가 선두인 이유는?', competitive: '가장 경쟁력 있는 가격', competitiveDesc: '경쟁사보다 40% 저렴', family: '고급 가족 관리', familyDesc: '클라우드 동기화가 있는 5개 프로필' }
}

export default function Math4ChildOptimal(): JSX.Element {
  // États principaux (corrigés pour éviter les warnings)
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('fr')
  const [mounted, setMounted] = useState<boolean>(false)
  const [showLanguageDropdown, setShowLanguageDropdown] = useState<boolean>(false)
  const [isProcessingPayment, setIsProcessingPayment] = useState<boolean>(false)
  const [userCountry, setUserCountry] = useState<string>('FR')
  const [showComparison, setShowComparison] = useState<boolean>(false)

  useEffect(() => {
    setMounted(true)
    // Détecter le pays de l'utilisateur pour optimisation prix
    detectUserCountry()
  }, [])

  const detectUserCountry = async () => {
    try {
      const response = await fetch('https://ipapi.co/json/')
      const data = await response.json()
      setUserCountry(data.country_code || 'FR')
    } catch {
      console.log('Fallback: FR')
    }
  }

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage]
  const t = translations[currentLanguage]

  const formatPrice = (priceInCents: number): string => {
    return `${(priceInCents / 100).toFixed(2)}€`
  }

  const getOptimalPaymentProvider = (platform: string) => {
    if (platform === 'ios' || platform === 'android') {
      return 'revenuecat'
    }
    
    // Web: Paddle pour EU, LemonSqueezy pour autres
    const euCountries = ['FR', 'DE', 'ES', 'IT', 'NL', 'BE', 'AT', 'PT']
    return euCountries.includes(userCountry) ? 'paddle' : 'lemonsqueezy'
  }

  const handleOptimalPayment = async (planId: string) => {
    setIsProcessingPayment(true)
    
    try {
      const plan = COMPETITIVE_PLANS.find(p => p.id === planId)
      if (!plan) throw new Error('Plan non trouvé')

      const provider = getOptimalPaymentProvider('web')
      
      const response = await fetch('/api/payments/create-checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          planId,
          provider,
          country: userCountry,
          amount: plan.price.monthly,
          currency: 'EUR',
          freeTrial: plan.freeTrial,
          metadata: {
            profiles: plan.profiles,
            features: plan.features,
            app: 'Math4Child'
          }
        })
      })

      const session = await response.json()
      
      if (session.checkoutUrl) {
        window.location.href = session.checkoutUrl
      }
    } catch (error) {
      console.error('Erreur paiement optimal:', error)
    } finally {
      setIsProcessingPayment(false)
    }
  }

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-100 via-purple-50 to-pink-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">{currentLangConfig.appName}</p>
        </div>
      </div>
    )
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-800 text-white ${currentLangConfig.direction === 'rtl' ? 'rtl' : 'ltr'}`}>
      {/* Particules animées */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10 p-4">
        {/* Header optimisé */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl flex items-center justify-center text-2xl">
                🧮
              </div>
              <div>
                <h1 className="text-2xl font-bold text-white">{currentLangConfig.appName}</h1>
                <p className="text-white/80 text-xs">www.math4child.com • Leader mondial</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Badge "100k+ familles" */}
              <div className="hidden md:flex items-center space-x-2 bg-green-500/20 rounded-full px-3 py-1 text-sm">
                <Users size={14} />
                <span>100k+ familles</span>
              </div>
              
              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-2 bg-white/20 rounded-xl px-4 py-2 text-white hover:bg-white/30 transition-all"
                >
                  <Languages size={16} />
                  <span className="text-sm">{currentLangConfig.flag} {currentLangConfig.name}</span>
                  <ChevronDown size={14} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-2 bg-white rounded-2xl shadow-xl z-50 min-w-64 max-h-96 overflow-y-auto">
                    <div className="p-3 border-b">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2 text-sm">
                        <Globe size={16} />
                        Sélectionner une langue
                      </h3>
                    </div>
                    
                    <div className="p-2">
                      {Object.entries(SUPPORTED_LANGUAGES).map(([code, lang]) => (
                        <button
                          key={code}
                          onClick={() => {
                            setCurrentLanguage(code as SupportedLanguage)
                            setShowLanguageDropdown(false)
                          }}
                          className={`w-full text-left px-3 py-2 rounded-lg flex items-center space-x-2 hover:bg-blue-50 transition-all text-sm ${
                            currentLanguage === code ? 'bg-blue-100 border-2 border-blue-500' : ''
                          }`}
                        >
                          <span className="text-lg">{lang.flag}</span>
                          <div>
                            <div className="font-medium text-gray-800">{lang.nativeName}</div>
                            <div className="text-xs text-gray-500">{lang.name}</div>
                          </div>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </nav>
        </header>

        {/* Vue Accueil optimisée */}
        <div className="text-center">
          {/* Hero Section avec preuve sociale */}
          <div className="mb-12">
            <div className="inline-flex items-center space-x-2 bg-green-500/20 rounded-full px-4 py-2 mb-6 text-green-300">
              <TrendingUp size={16} />
              <span className="text-sm font-medium">App éducative #1</span>
            </div>
            
            <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-yellow-300 via-pink-300 to-blue-300 bg-clip-text text-transparent animate-pulse">
              {currentLangConfig.appName}
            </h1>
            
            <p className="text-2xl md:text-3xl text-white/90 mb-4 drop-shadow-lg">
              {t.subtitle}
            </p>
            
            <p className="text-xl text-green-300 mb-8 font-medium">
              {t.welcome}
            </p>
            
            {/* CTA Buttons optimisés */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
              <button
                onClick={() => handleOptimalPayment('family')}
                className="bg-gradient-to-r from-green-400 to-green-600 hover:from-green-500 hover:to-green-700 text-white px-8 py-4 rounded-2xl text-xl font-bold flex items-center space-x-3 transform hover:scale-105 transition-all shadow-2xl"
              >
                <Gift size={24} />
                <span>{t.startFree}</span>
                <span className="bg-white/20 rounded-full px-2 py-1 text-sm">14j gratuit</span>
              </button>
              
              <button
                onClick={() => setShowComparison(true)}
                className="bg-white/10 backdrop-blur-sm border border-white/20 text-white px-8 py-4 rounded-2xl text-xl font-bold flex items-center space-x-3 hover:bg-white/20 transition-all"
              >
                <TrendingUp size={24} />
                <span>Comparer les prix</span>
              </button>
            </div>
          </div>

          {/* Section fonctionnalités */}
          <div className="mb-16">
            <h2 className="text-4xl font-bold text-white mb-8 drop-shadow-lg">
              {t.whyLeader}
            </h2>
            
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-5xl mx-auto">
              <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 hover:bg-white/15 transition-all">
                <div className="text-4xl mb-4">💰</div>
                <h3 className="text-lg font-bold text-white mb-2">{t.competitive}</h3>
                <p className="text-white/80 text-sm">{t.competitiveDesc}</p>
                <div className="mt-3 text-green-300 font-bold">6.99€/mois vs 8.95€+</div>
              </div>
              
              <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 hover:bg-white/15 transition-all">
                <div className="text-4xl mb-4">👨‍👩‍👧‍👦</div>
                <h3 className="text-lg font-bold text-white mb-2">{t.family}</h3>
                <p className="text-white/80 text-sm">{t.familyDesc}</p>
                <div className="mt-3 text-blue-300 font-bold">5 profils vs 3 max</div>
              </div>
              
              <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 hover:bg-white/15 transition-all">
                <div className="text-4xl mb-4">📱</div>
                <h3 className="text-lg font-bold text-white mb-2">Mode hors-ligne</h3>
                <p className="text-white/80 text-sm">Apprentissage partout</p>
                <div className="mt-3 text-purple-300 font-bold">100% hors-ligne</div>
              </div>
              
              <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 hover:bg-white/15 transition-all">
                <div className="text-4xl mb-4">📊</div>
                <h3 className="text-lg font-bold text-white mb-2">Analytics</h3>
                <p className="text-white/80 text-sm">Rapports automatiques</p>
                <div className="mt-3 text-yellow-300 font-bold">Rapports parents</div>
              </div>
            </div>
          </div>

          {/* Pricing Cards optimisées */}
          <div className="mb-16">
            <h2 className="text-4xl font-bold text-white mb-4">Plans Optimaux</h2>
            <p className="text-xl text-white/80 mb-12">Plus compétitif que toute la concurrence</p>
            
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-6xl mx-auto">
              {COMPETITIVE_PLANS.map((plan) => (
                <div
                  key={plan.id}
                  className={`relative rounded-3xl p-6 transition-all hover:scale-105 ${
                    plan.popular ? 'ring-4 ring-blue-400 ring-opacity-60' : ''
                  } ${plan.color}`}
                >
                  {plan.popular && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                      <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-bold">
                        Le plus populaire
                      </span>
                    </div>
                  )}
                  
                  {plan.recommended && (
                    <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                      <span className="bg-green-500 text-white px-4 py-2 rounded-full text-sm font-bold">
                        Recommandé
                      </span>
                    </div>
                  )}
                  
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">{plan.icon}</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                    
                    <div className="mb-4">
                      {plan.originalPrice && (
                        <div className="text-sm text-gray-500 line-through">
                          {formatPrice(plan.originalPrice.monthly)}/mois
                        </div>
                      )}
                      <div className="text-4xl font-bold text-gray-800">
                        {plan.price.monthly === 0 ? 'Gratuit' : formatPrice(plan.price.monthly)}
                        {plan.price.monthly > 0 && <span className="text-lg">/mois</span>}
                      </div>
                      {plan.savings && (
                        <div className="text-green-600 font-bold text-sm">
                          Économisez {plan.savings}%
                        </div>
                      )}
                    </div>
                    
                    <div className="flex items-center justify-center space-x-1 mb-4">
                      <Users size={16} className="text-gray-600" />
                      <span className="text-gray-700 font-medium">
                        {plan.profiles} profil{plan.profiles > 1 ? 's' : ''}
                      </span>
                    </div>
                    
                    {plan.freeTrial > 0 && (
                      <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium mb-4">
                        {plan.freeTrial} jours gratuit
                      </div>
                    )}
                  </div>
                  
                  <ul className="space-y-3 mb-6">
                    {plan.features.slice(0, 5).map((feature, index) => (
                      <li key={index} className="flex items-start space-x-2">
                        <CheckCircle size={16} className="text-green-500 mt-0.5 flex-shrink-0" />
                        <span className="text-gray-700 text-sm">{feature}</span>
                      </li>
                    ))}
                    {plan.features.length > 5 && (
                      <li className="text-gray-500 text-sm">
                        +{plan.features.length - 5} autres fonctionnalités
                      </li>
                    )}
                  </ul>
                  
                  <button
                    onClick={() => handleOptimalPayment(plan.id)}
                    disabled={isProcessingPayment}
                    className={`w-full py-3 rounded-xl font-bold transition-all disabled:opacity-50 ${
                      plan.id === 'free'
                        ? 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                        : plan.popular
                        ? 'bg-blue-500 text-white hover:bg-blue-600'
                        : plan.recommended  
                        ? 'bg-green-500 text-white hover:bg-green-600'
                        : 'bg-purple-500 text-white hover:bg-purple-600'
                    }`}
                  >
                    {isProcessingPayment ? (
                      <div className="flex items-center justify-center space-x-2">
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                        <span>Traitement...</span>
                      </div>
                    ) : plan.id === 'free' ? (
                      'Commencer gratuitement'
                    ) : plan.freeTrial > 0 ? (
                      `Essai ${plan.freeTrial}j gratuit`
                    ) : (
                      'Choisir ce plan'
                    )}
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* Garanties et sécurité */}
          <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-8 mb-8">
            <h3 className="text-2xl font-bold text-white mb-6">🛡️ Garanties Math4Child</h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="text-center">
                <CheckCircle size={24} className="text-green-400 mx-auto mb-2" />
                <h4 className="font-bold text-white mb-1">Annulation facile</h4>
                <p className="text-white/80 text-sm">Annulez en 1 clic, remboursement immédiat</p>
              </div>
              <div className="text-center">
                <Heart size={24} className="text-red-400 mx-auto mb-2" />
                <h4 className="font-bold text-white mb-1">Garantie satisfaction</h4>
                <p className="text-white/80 text-sm">30 jours satisfait ou remboursé</p>
              </div>
              <div className="text-center">
                <Lock size={24} className="text-blue-400 mx-auto mb-2" />
                <h4 className="font-bold text-white mb-1">Paiements sécurisés</h4>
                <p className="text-white/80 text-sm">Paddle, RevenueCat - Standards bancaires</p>
              </div>
            </div>
          </div>
        </div>

        {/* Modal de comparaison */}
        {showComparison && (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-3xl max-w-4xl w-full p-8 shadow-2xl max-h-[90vh] overflow-y-auto">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-3xl font-bold text-gray-800">Math4Child vs Concurrence</h2>
                <button
                  onClick={() => setShowComparison(false)}
                  className="text-gray-500 hover:text-gray-700"
                >
                  <X size={24} />
                </button>
              </div>
              
              <div className="space-y-4">
                <div className="grid grid-cols-4 gap-4 p-4 bg-red-50 rounded-xl">
                  <div className="font-bold">Khan Academy Kids</div>
                  <div>Gratuit</div>
                  <div>3 profils</div>
                  <div className="text-red-600">Limité, pas de hors-ligne</div>
                </div>
                
                <div className="grid grid-cols-4 gap-4 p-4 bg-red-50 rounded-xl">
                  <div className="font-bold">ABCmouse</div>
                  <div>$12.99/mois</div>
                  <div>4 profils</div>
                  <div className="text-red-600">86% plus cher</div>
                </div>
                
                <div className="grid grid-cols-4 gap-4 p-4 bg-red-50 rounded-xl">
                  <div className="font-bold">Prodigy Math</div>
                  <div>$8.95/mois</div>
                  <div>1 profil</div>
                  <div className="text-red-600">28% plus cher, 1 seul profil</div>
                </div>
                
                <div className="grid grid-cols-4 gap-4 p-4 bg-red-50 rounded-xl">
                  <div className="font-bold">SplashLearn</div>
                  <div>$7.99/mois</div>
                  <div>3 profils</div>
                  <div className="text-red-600">14% plus cher, 2 profils en moins</div>
                </div>
                
                <div className="grid grid-cols-4 gap-4 p-4 bg-green-50 rounded-xl border-2 border-green-500">
                  <div className="font-bold text-green-700">Math4Child</div>
                  <div className="text-green-700 font-bold">€6.99/mois</div>
                  <div className="text-green-700 font-bold">5 profils</div>
                  <div className="text-green-700 font-bold">✅ Le plus compétitif + 14j gratuit!</div>
                </div>
              </div>
              
              <div className="mt-8 text-center">
                <button
                  onClick={() => {
                    setShowComparison(false)
                    handleOptimalPayment('family')
                  }}
                  className="bg-green-500 text-white px-8 py-3 rounded-xl font-bold hover:bg-green-600 transition-all"
                >
                  Choisir Math4Child - Leader du marché !
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
