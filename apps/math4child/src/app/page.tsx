'use client'

import React, { useState, useEffect } from 'react'
import { Sparkles, BookOpen, Calculator, Trophy, Globe, ChevronDown, Users, Star, Gamepad2, Heart, Zap, Target, Play, BookMarked, Settings, Check, X, ArrowLeft, CreditCard, Crown, Shield } from 'lucide-react'

// Types pour les langues supportées
type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'ar'

interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  appName: string
  rtl?: boolean
}

// Configuration des langues avec support RTL
const SUPPORTED_LANGUAGES: Record<SupportedLanguage, LanguageConfig> = {
  fr: { name: 'French', nativeName: 'Français', flag: '🇫🇷', appName: 'Math4Child' },
  en: { name: 'English', nativeName: 'English', flag: '🇺🇸', appName: 'Math4Child' },
  es: { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', appName: 'Math4Child' },
  de: { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', appName: 'Math4Child' },
  ar: { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', appName: 'Math4Child', rtl: true }
}

// Traductions complètes avec contenu d'abonnement
const translations: Record<SupportedLanguage, any> = {
  fr: {
    title: 'Math4Child - Apprendre les mathématiques en s&apos;amusant',
    subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
    heroDescription: '🌟 Transformez l&apos;apprentissage des mathématiques en aventure passionnante !',
    subscription: {
      title: 'Abonnement Math4Child',
      subtitle: 'Choisissez le plan parfait pour votre enfant',
      description: 'Offrez à votre enfant les meilleures ressources pour exceller en mathématiques',
      plans: {
        free: {
          name: 'Essai Gratuit',
          price: '0€',
          period: '7 jours d\'essai',
          description: 'Découvrez Math4Child gratuitement',
          features: [
            'Accès limité aux exercices',
            '2 langues disponibles',
            'Suivi basique des progrès',
            'Support par email',
            'Aucune carte bancaire requise'
          ],
          button: 'Commencer l\'essai',
          popular: false
        },
        standard: {
          name: 'Standard',
          price: '9,99€',
          period: 'par mois',
          description: 'Parfait pour un apprentissage régulier',
          features: [
            'Accès illimité aux exercices',
            '5 langues disponibles',
            'Suivi complet des progrès',
            'Plus de 100 jeux éducatifs',
            'Support prioritaire',
            'Rapports détaillés',
            'Mode hors ligne'
          ],
          button: 'S\'abonner maintenant',
          popular: true
        },
        family: {
          name: 'Famille',
          price: '19,99€',
          period: 'par mois',
          description: 'Idéal pour plusieurs enfants',
          features: [
            'Tout du plan Standard',
            'Jusqu\'à 5 profils enfants',
            'Contrôle parental avancé',
            'Sessions de groupe',
            'Rapports familiaux',
            'Support téléphonique',
            'Accès prioritaire aux nouveautés'
          ],
          button: 'Choisir Famille',
          popular: false
        }
      },
      guarantee: 'Garantie satisfait ou remboursé 30 jours',
      secure: 'Paiement 100% sécurisé',
      cancel: 'Annulation possible à tout moment'
    },
    features: {
      interactive: 'Apprentissage Interactif',
      interactiveDesc: 'Exercices ludiques et engageants',
      multilingual: 'Support Multilingue',
      multilingualDesc: 'Apprenez dans votre langue natale',
      progress: 'Suivi des Progrès',
      progressDesc: 'Tableau de bord personnalisé',
      games: 'Jeux Éducatifs',
      gamesDesc: 'Plus de 100 mini-jeux mathématiques'
    },
    cta: {
      freeTrial: 'Essai Gratuit 7 Jours',
      freeTrialActive: '✨ Essai Activé !',
      subscribe: 'S&apos;abonner - 9.99€/mois',
      demo: 'Voir la Démo Interactive'
    },
    stats: { students: 'Étudiants actifs', exercises: 'Exercices disponibles', languages: 'Langues supportées', satisfaction: 'Satisfaction parents' },
    benefits: { title: 'Pourquoi choisir Math4Child ?', adaptive: 'Apprentissage adaptatif', certified: 'Certifié par des pédagogues', safe: 'Environnement 100% sécurisé' }
  },
  en: {
    title: 'Math4Child - Learn math while having fun',
    subtitle: 'Multilingual educational platform for children aged 4 to 12',
    heroDescription: '🌟 Transform math learning into an exciting adventure!',
    subscription: {
      title: 'Math4Child Subscription',
      subtitle: 'Choose the perfect plan for your child',
      description: 'Give your child the best resources to excel in mathematics',
      plans: {
        free: {
          name: 'Free Trial',
          price: '$0',
          period: '7-day trial',
          description: 'Discover Math4Child for free',
          features: [
            'Limited access to exercises',
            '2 languages available',
            'Basic progress tracking',
            'Email support',
            'No credit card required'
          ],
          button: 'Start Trial',
          popular: false
        },
        standard: {
          name: 'Standard',
          price: '$9.99',
          period: 'per month',
          description: 'Perfect for regular learning',
          features: [
            'Unlimited access to exercises',
            '5 languages available',
            'Complete progress tracking',
            '100+ educational games',
            'Priority support',
            'Detailed reports',
            'Offline mode'
          ],
          button: 'Subscribe Now',
          popular: true
        },
        family: {
          name: 'Family',
          price: '$19.99',
          period: 'per month',
          description: 'Ideal for multiple children',
          features: [
            'Everything in Standard',
            'Up to 5 child profiles',
            'Advanced parental controls',
            'Group sessions',
            'Family reports',
            'Phone support',
            'Early access to new features'
          ],
          button: 'Choose Family',
          popular: false
        }
      },
      guarantee: '30-day money-back guarantee',
      secure: '100% secure payment',
      cancel: 'Cancel anytime'
    },
    features: {
      interactive: 'Interactive Learning',
      interactiveDesc: 'Fun and engaging exercises',
      multilingual: 'Multilingual Support',
      multilingualDesc: 'Learn in your native language',
      progress: 'Progress Tracking',
      progressDesc: 'Personalized dashboard',
      games: 'Educational Games',
      gamesDesc: '100+ math mini-games'
    },
    cta: {
      freeTrial: '7-Day Free Trial',
      freeTrialActive: '✨ Trial Active!',
      subscribe: 'Subscribe - $9.99/month',
      demo: 'Interactive Demo'
    },
    stats: { students: 'Active students', exercises: 'Available exercises', languages: 'Supported languages', satisfaction: 'Parent satisfaction' },
    benefits: { title: 'Why choose Math4Child?', adaptive: 'Adaptive learning', certified: 'Certified by educators', safe: '100% safe environment' }
  },
  es: {
    title: 'Math4Child - Aprende matemáticas divirtiéndote',
    subtitle: 'Plataforma educativa multilingüe para niños de 4 a 12 años',
    heroDescription: '🌟 ¡Transforma el aprendizaje de matemáticas en una aventura emocionante!',
    subscription: {
      title: 'Suscripción Math4Child',
      subtitle: 'Elige el plan perfecto para tu hijo',
      description: 'Dale a tu hijo los mejores recursos para sobresalir en matemáticas',
      plans: {
        free: {
          name: 'Prueba Gratuita',
          price: '0€',
          period: '7 días de prueba',
          description: 'Descubre Math4Child gratis',
          features: [
            'Acceso limitado a ejercicios',
            '2 idiomas disponibles',
            'Seguimiento básico del progreso',
            'Soporte por email',
            'No se requiere tarjeta de crédito'
          ],
          button: 'Comenzar Prueba',
          popular: false
        },
        standard: {
          name: 'Estándar',
          price: '9,99€',
          period: 'por mes',
          description: 'Perfecto para aprendizaje regular',
          features: [
            'Acceso ilimitado a ejercicios',
            '5 idiomas disponibles',
            'Seguimiento completo del progreso',
            'Más de 100 juegos educativos',
            'Soporte prioritario',
            'Informes detallados',
            'Modo sin conexión'
          ],
          button: 'Suscribirse Ahora',
          popular: true
        },
        family: {
          name: 'Familia',
          price: '19,99€',
          period: 'por mes',
          description: 'Ideal para varios niños',
          features: [
            'Todo del plan Estándar',
            'Hasta 5 perfiles de niños',
            'Control parental avanzado',
            'Sesiones grupales',
            'Informes familiares',
            'Soporte telefónico',
            'Acceso temprano a novedades'
          ],
          button: 'Elegir Familia',
          popular: false
        }
      },
      guarantee: 'Garantía de devolución de dinero de 30 días',
      secure: 'Pago 100% seguro',
      cancel: 'Cancelar en cualquier momento'
    },
    features: {
      interactive: 'Aprendizaje Interactivo',
      interactiveDesc: 'Ejercicios divertidos y atractivos',
      multilingual: 'Soporte Multilingüe',
      multilingualDesc: 'Aprende en tu idioma nativo',
      progress: 'Seguimiento del Progreso',
      progressDesc: 'Panel personalizado',
      games: 'Juegos Educativos',
      gamesDesc: '100+ mini-juegos matemáticos'
    },
    cta: { freeTrial: 'Prueba Gratuita 7 Días', freeTrialActive: '✨ ¡Prueba Activa!', subscribe: 'Suscribirse - €9.99/mes', demo: 'Demo Interactiva' },
    stats: { students: 'Estudiantes activos', exercises: 'Ejercicios disponibles', languages: 'Idiomas soportados', satisfaction: 'Satisfacción padres' },
    benefits: { title: '¿Por qué elegir Math4Child?', adaptive: 'Aprendizaje adaptativo', certified: 'Certificado por educadores', safe: 'Entorno 100% seguro' }
  },
  de: {
    title: 'Math4Child - Mathematik lernen macht Spaß',
    subtitle: 'Mehrsprachige Bildungsplattform für Kinder von 4 bis 12 Jahren',
    heroDescription: '🌟 Verwandeln Sie das Mathematiklernen in ein aufregendes Abenteuer!',
    subscription: {
      title: 'Math4Child Abonnement',
      subtitle: 'Wählen Sie den perfekten Plan für Ihr Kind',
      description: 'Geben Sie Ihrem Kind die besten Ressourcen für Erfolg in Mathematik',
      plans: {
        free: {
          name: 'Kostenlose Testversion',
          price: '0€',
          period: '7-Tage Test',
          description: 'Entdecken Sie Math4Child kostenlos',
          features: [
            'Begrenzter Zugang zu Übungen',
            '2 Sprachen verfügbar',
            'Basis Fortschrittsverfolgung',
            'E-Mail Support',
            'Keine Kreditkarte erforderlich'
          ],
          button: 'Test Starten',
          popular: false
        },
        standard: {
          name: 'Standard',
          price: '9,99€',
          period: 'pro Monat',
          description: 'Perfekt für regelmäßiges Lernen',
          features: [
            'Unbegrenzter Zugang zu Übungen',
            '5 Sprachen verfügbar',
            'Vollständige Fortschrittsverfolgung',
            '100+ Lernspiele',
            'Prioritätssupport',
            'Detaillierte Berichte',
            'Offline-Modus'
          ],
          button: 'Jetzt Abonnieren',
          popular: true
        },
        family: {
          name: 'Familie',
          price: '19,99€',
          period: 'pro Monat',
          description: 'Ideal für mehrere Kinder',
          features: [
            'Alles aus Standard',
            'Bis zu 5 Kinderprofile',
            'Erweiterte Kindersicherung',
            'Gruppensitzungen',
            'Familienberichte',
            'Telefonsupport',
            'Früher Zugang zu Neuheiten'
          ],
          button: 'Familie Wählen',
          popular: false
        }
      },
      guarantee: '30 Tage Geld-zurück-Garantie',
      secure: '100% sichere Zahlung',
      cancel: 'Jederzeit kündbar'
    },
    features: {
      interactive: 'Interaktives Lernen',
      interactiveDesc: 'Spaßige und fesselnde Übungen',
      multilingual: 'Mehrsprachige Unterstützung',
      multilingualDesc: 'Lernen Sie in Ihrer Muttersprache',
      progress: 'Fortschrittsverfolgung',
      progressDesc: 'Personalisiertes Dashboard',
      games: 'Lernspiele',
      gamesDesc: '100+ Mathematik-Minispiele'
    },
    cta: { freeTrial: '7-Tage Kostenlos', freeTrialActive: '✨ Testversion aktiv!', subscribe: 'Abonnieren - €9.99/Monat', demo: 'Interaktive Demo' },
    stats: { students: 'Aktive Schüler', exercises: 'Verfügbare Übungen', languages: 'Unterstützte Sprachen', satisfaction: 'Elternzufriedenheit' },
    benefits: { title: 'Warum Math4Child wählen?', adaptive: 'Adaptives Lernen', certified: 'Von Pädagogen zertifiziert', safe: '100% sichere Umgebung' }
  },
  ar: {
    title: 'Math4Child - تعلم الرياضيات بمتعة',
    subtitle: 'منصة تعليمية متعددة اللغات للأطفال من 4 إلى 12 سنة',
    heroDescription: '🌟 حوّل تعلم الرياضيات إلى مغامرة مثيرة!',
    subscription: {
      title: 'اشتراك Math4Child',
      subtitle: 'اختر الخطة المثالية لطفلك',
      description: 'امنح طفلك أفضل الموارد للتفوق في الرياضيات',
      plans: {
        free: {
          name: 'تجربة مجانية',
          price: '0€',
          period: 'تجربة 7 أيام',
          description: 'اكتشف Math4Child مجاناً',
          features: [
            'وصول محدود للتمارين',
            'لغتين متاحتين',
            'تتبع أساسي للتقدم',
            'دعم بالبريد الإلكتروني',
            'لا حاجة لبطاقة ائتمان'
          ],
          button: 'بدء التجربة',
          popular: false
        },
        standard: {
          name: 'قياسي',
          price: '9.99€',
          period: 'شهرياً',
          description: 'مثالي للتعلم المنتظم',
          features: [
            'وصول غير محدود للتمارين',
            '5 لغات متاحة',
            'تتبع كامل للتقدم',
            'أكثر من 100 لعبة تعليمية',
            'دعم أولوية',
            'تقارير مفصلة',
            'وضع بلا إنترنت'
          ],
          button: 'اشترك الآن',
          popular: true
        },
        family: {
          name: 'عائلي',
          price: '19.99€',
          period: 'شهرياً',
          description: 'مثالي لعدة أطفال',
          features: [
            'كل ما في الخطة القياسية',
            'حتى 5 ملفات شخصية للأطفال',
            'رقابة أبوية متقدمة',
            'جلسات جماعية',
            'تقارير عائلية',
            'دعم هاتفي',
            'وصول مبكر للميزات الجديدة'
          ],
          button: 'اختر العائلي',
          popular: false
        }
      },
      guarantee: 'ضمان استرداد المال لمدة 30 يوماً',
      secure: 'دفع آمن 100%',
      cancel: 'إلغاء في أي وقت'
    },
    features: {
      interactive: 'التعلم التفاعلي',
      interactiveDesc: 'تمارين ممتعة وجذابة',
      multilingual: 'دعم متعدد اللغات',
      multilingualDesc: 'تعلم بلغتك الأم',
      progress: 'تتبع التقدم',
      progressDesc: 'لوحة تحكم شخصية',
      games: 'ألعاب تعليمية',
      gamesDesc: '100+ لعبة رياضيات مصغرة'
    },
    cta: { freeTrial: 'تجربة مجانية 7 أيام', freeTrialActive: '✨ التجربة نشطة!', subscribe: 'اشتراك - €9.99/شهر', demo: 'عرض تفاعلي' },
    stats: { students: 'الطلاب النشطون', exercises: 'التمارين المتاحة', languages: 'اللغات المدعومة', satisfaction: 'رضا الأولياء' },
    benefits: { title: 'لماذا نختار Math4Child؟', adaptive: 'التعلم التكيفي', certified: 'معتمد من قبل المربين', safe: 'بيئة آمنة 100%' }
  }
}

// Types pour les vues
type ViewType = 'home' | 'demo' | 'subscribe' | 'interactive' | 'multilingual' | 'progress' | 'games'

export default function HomePage() {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('en')
  const [freeTrialActive, setFreeTrialActive] = useState(false)
  const [currentView, setCurrentView] = useState<ViewType>('home')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage as SupportedLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as SupportedLanguage] || translations['fr']
  const isRTL = currentLangConfig.rtl || false

  const startFreeTrial = () => {
    setFreeTrialActive(true)
    console.log('🎉 Essai gratuit démarré !')
    setTimeout(() => setFreeTrialActive(false), 3000)
  }

  const handleSubscribe = () => {
    setCurrentView('subscribe')
    console.log('Redirection vers abonnement Stripe')
  }

  const handleDemo = () => {
    setCurrentView('demo')
    console.log('Ouverture de la démo interactive')
  }

  const handleFeatureClick = (feature: string) => {
    switch(feature) {
      case 'interactive':
        setCurrentView('interactive')
        break
      case 'multilingual':
        setCurrentView('multilingual')
        break
      case 'progress':
        setCurrentView('progress')
        break
      case 'games':
        setCurrentView('games')
        break
    }
    console.log(`Ouverture de la section: ${feature}`)
  }

  if (!mounted) {
    return <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50"></div>
  }

  // Rendu conditionnel selon la vue
  if (currentView === 'demo') {
    return <DemoPage onBack={() => setCurrentView('home')} language={currentLanguage} />
  }
  if (currentView === 'subscribe') {
    return <SubscribePage onBack={() => setCurrentView('home')} language={currentLanguage} translations={t} />
  }
  if (currentView === 'interactive') {
    return <InteractivePage onBack={() => setCurrentView('home')} language={currentLanguage} />
  }
  if (currentView === 'multilingual') {
    return <MultilingualPage onBack={() => setCurrentView('home')} language={currentLanguage} />
  }
  if (currentView === 'progress') {
    return <ProgressPage onBack={() => setCurrentView('home')} language={currentLanguage} />
  }
  if (currentView === 'games') {
    return <GamesPage onBack={() => setCurrentView('home')} language={currentLanguage} />
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="p-4 flex justify-between items-center backdrop-blur-sm bg-white/30 sticky top-0 z-50">
        <div className="flex items-center space-x-2 group cursor-pointer" onClick={() => setCurrentView('home')}>
          <div className="p-2 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl group-hover:from-purple-600 group-hover:to-blue-500 transition-all duration-300">
            <Calculator className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            {currentLangConfig.appName}
          </span>
        </div>
        
        <div className="relative">
          <select 
            value={currentLanguage}
            onChange={(e) => setCurrentLanguage(e.target.value as SupportedLanguage)}
            className="appearance-none bg-white/90 backdrop-blur border border-gray-200 rounded-xl px-4 py-2 pr-10 text-sm font-medium text-gray-700 hover:border-blue-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200 cursor-pointer"
          >
            {(Object.entries(SUPPORTED_LANGUAGES) as [SupportedLanguage, LanguageConfig][]).map(([code, config]) => (
              <option key={code} value={code}>
                {config.flag} {config.nativeName}
              </option>
            ))}
          </select>
          <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
        </div>
      </header>

      {/* Contenu principal */}
      <main className="container mx-auto px-4 py-8">
        {/* Hero Section */}
        <div className="max-w-6xl mx-auto text-center mb-16">
          <div className="relative mb-8">
            <h1 
              className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight"
              dangerouslySetInnerHTML={{ __html: t.title }}
            />
            <div className="absolute -top-4 -right-4 text-4xl animate-bounce cursor-pointer" onClick={() => console.log('🎨 Rainbow emoji clicked!')}>
              🎨
            </div>
            <div className="absolute -bottom-2 -left-4 text-3xl animate-pulse cursor-pointer" onClick={() => console.log('✨ Sparkles clicked!')}>
              ✨
            </div>
          </div>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-4 max-w-4xl mx-auto">
            {t.subtitle}
          </p>
          <p 
            className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto"
            dangerouslySetInnerHTML={{ __html: t.heroDescription }}
          />

          {/* Stats Section - Cliquable */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 cursor-pointer" onClick={() => handleFeatureClick('interactive')}>
              <div className="text-3xl font-bold bg-gradient-to-r from-blue-500 to-blue-700 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform">
                10K+
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Users className="w-4 h-4 group-hover:text-blue-600 transition-colors" />
                {t.stats.students}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 cursor-pointer" onClick={() => handleFeatureClick('games')}>
              <div className="text-3xl font-bold bg-gradient-to-r from-green-500 to-green-700 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform">
                500+
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Target className="w-4 h-4 group-hover:text-green-600 transition-colors" />
                {t.stats.exercises}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 cursor-pointer" onClick={() => handleFeatureClick('multilingual')}>
              <div className="text-3xl font-bold bg-gradient-to-r from-purple-500 to-purple-700 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform">
                5
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Globe className="w-4 h-4 group-hover:text-purple-600 transition-colors" />
                {t.stats.languages}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 cursor-pointer" onClick={() => handleFeatureClick('progress')}>
              <div className="text-3xl font-bold bg-gradient-to-r from-yellow-500 to-orange-500 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform">
                98%
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Heart className="w-4 h-4 group-hover:text-yellow-600 transition-colors" />
                {t.stats.satisfaction}
              </div>
            </div>
          </div>

          {/* Features Grid - Cliquable */}
          <div className="grid md:grid-cols-4 gap-8 mb-16">
            <div 
              className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:rotate-1 cursor-pointer"
              onClick={() => handleFeatureClick('interactive')}
            >
              <div className="p-4 bg-gradient-to-r from-blue-500 to-blue-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <BookOpen className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg group-hover:text-blue-600 transition-colors">{t.features.interactive}</h3>
              <p className="text-gray-600 text-sm">{t.features.interactiveDesc}</p>
            </div>
            
            <div 
              className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:-rotate-1 cursor-pointer"
              onClick={() => handleFeatureClick('multilingual')}
            >
              <div className="p-4 bg-gradient-to-r from-green-500 to-green-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Globe className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg group-hover:text-green-600 transition-colors">{t.features.multilingual}</h3>
              <p className="text-gray-600 text-sm">{t.features.multilingualDesc}</p>
            </div>
            
            <div 
              className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:rotate-1 cursor-pointer"
              onClick={() => handleFeatureClick('progress')}
            >
              <div className="p-4 bg-gradient-to-r from-yellow-500 to-orange-500 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Trophy className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg group-hover:text-yellow-600 transition-colors">{t.features.progress}</h3>
              <p className="text-gray-600 text-sm">{t.features.progressDesc}</p>
            </div>
            
            <div 
              className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:-rotate-1 cursor-pointer"
              onClick={() => handleFeatureClick('games')}
            >
              <div className="p-4 bg-gradient-to-r from-purple-500 to-purple-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Gamepad2 className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg group-hover:text-purple-600 transition-colors">{t.features.games}</h3>
              <p className="text-gray-600 text-sm">{t.features.gamesDesc}</p>
            </div>
          </div>

          {/* Call to Action */}
          <div className="space-y-6 md:space-y-0 md:space-x-6 md:flex md:justify-center md:items-center">
            <button
              onClick={startFreeTrial}
              className={`group px-10 py-4 rounded-2xl font-bold text-white transition-all duration-300 transform hover:scale-105 shadow-2xl relative overflow-hidden ${
                freeTrialActive 
                  ? 'bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 animate-pulse' 
                  : 'bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700'
              }`}
            >
              <span className="relative z-10">
                {freeTrialActive ? t.cta.freeTrialActive : t.cta.freeTrial}
              </span>
              <div className="absolute inset-0 bg-white/20 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></div>
            </button>
            
            <button
              onClick={handleSubscribe}
              className="group px-10 py-4 bg-gradient-to-r from-purple-500 to-purple-600 text-white rounded-2xl font-bold hover:from-purple-600 hover:to-purple-700 transition-all duration-300 transform hover:scale-105 shadow-2xl relative overflow-hidden"
            >
              <span 
                className="relative z-10"
                dangerouslySetInnerHTML={{ __html: t.cta.subscribe }}
              />
              <div className="absolute inset-0 bg-white/20 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></div>
            </button>
            
            <button 
              onClick={handleDemo}
              className="group px-10 py-4 border-2 border-gray-300 text-gray-700 rounded-2xl font-bold hover:border-blue-400 hover:bg-blue-50 hover:text-blue-600 transition-all duration-300 transform hover:scale-105 relative overflow-hidden"
            >
              <span className="relative z-10 flex items-center gap-2">
                <Play className="w-5 h-5" />
                {t.cta.demo}
              </span>
            </button>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 text-center text-gray-500 bg-white/30 backdrop-blur-sm">
        <p className="flex items-center justify-center space-x-2">
          <span>&copy; 2024 {currentLangConfig.appName}.</span>
          <span>Made with</span>
          <Heart className="w-4 h-4 text-red-500 animate-pulse cursor-pointer" onClick={() => console.log('❤️ Heart clicked!')} />
          <span>for children worldwide.</span>
        </p>
      </footer>
    </div>
  )
}

// PAGE D'ABONNEMENT COMPLÈTE AVEC PLANS DE PRICING
function SubscribePage({ onBack, language, translations }: { onBack: () => void, language: SupportedLanguage, translations: any }) {
  const [selectedPlan, setSelectedPlan] = useState('standard')
  const [isProcessing, setIsProcessing] = useState(false)
  
  const t = translations.subscription

  const handleSubscription = (planType: string) => {
    setIsProcessing(true)
    console.log(`Démarrage de l'abonnement: ${planType}`)
    
    // Simulation de l'intégration Stripe
    setTimeout(() => {
      setIsProcessing(false)
      alert(`Redirection vers Stripe pour le plan ${planType}`)
    }, 2000)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-pink-50 to-blue-50 p-4 md:p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <button 
            onClick={onBack} 
            className="flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Retour
          </button>
          
          <div className="flex items-center gap-3 text-sm text-gray-600">
            <Shield className="w-4 h-4 text-green-600" />
            <span>{t.secure}</span>
          </div>
        </div>
        
        {/* Header Content */}
        <div className="text-center mb-16">
          <div className="flex items-center justify-center gap-3 mb-6">
            <div className="p-3 bg-gradient-to-r from-purple-500 to-pink-600 rounded-2xl">
              <CreditCard className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-4xl md:text-5xl font-bold text-gray-800">
              {t.title}
            </h1>
          </div>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-4">
            {t.subtitle}
          </p>
          <p className="text-lg text-gray-500 max-w-2xl mx-auto">
            {t.description}
          </p>
        </div>

        {/* Plans de Pricing */}
        <div className="grid md:grid-cols-3 gap-8 mb-16">
          {/* Plan Gratuit */}
          <div className={`relative bg-white/90 backdrop-blur-lg rounded-3xl shadow-xl p-8 transition-all duration-300 ${
            selectedPlan === 'free' ? 'ring-4 ring-blue-300 scale-105' : 'hover:shadow-2xl'
          }`}>
            <div className="text-center">
              <h3 className="text-2xl font-bold text-gray-800 mb-4">
                {t.plans.free.name}
              </h3>
              <div className="mb-6">
                <span className="text-4xl font-bold text-blue-600">{t.plans.free.price}</span>
                <span className="text-gray-500 ml-2">{t.plans.free.period}</span>
              </div>
              <p className="text-gray-600 mb-8">{t.plans.free.description}</p>
              
              <ul className="text-left space-y-3 mb-8">
                {t.plans.free.features.map((feature: string, index: number) => (
                  <li key={index} className="flex items-center gap-3">
                    <Check className="w-5 h-5 text-green-500 flex-shrink-0" />
                    <span className="text-gray-700">{feature}</span>
                  </li>
                ))}
              </ul>
              
              <button
                onClick={() => handleSubscription('free')}
                disabled={isProcessing}
                className="w-full py-3 bg-blue-600 text-white rounded-xl font-semibold hover:bg-blue-700 transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isProcessing ? 'Traitement...' : t.plans.free.button}
              </button>
            </div>
          </div>

          {/* Plan Standard - POPULAIRE */}
          <div className="relative bg-white/90 backdrop-blur-lg rounded-3xl shadow-2xl p-8 border-4 border-purple-500 scale-110 transform">
            {/* Badge Populaire */}
            <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <div className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-6 py-2 rounded-full text-sm font-bold flex items-center gap-2">
                <Crown className="w-4 h-4" />
                POPULAIRE
              </div>
            </div>
            
            <div className="text-center pt-4">
              <h3 className="text-2xl font-bold text-gray-800 mb-4">
                {t.plans.standard.name}
              </h3>
              <div className="mb-6">
                <span className="text-4xl font-bold text-purple-600">{t.plans.standard.price}</span>
                <span className="text-gray-500 ml-2">{t.plans.standard.period}</span>
              </div>
              <p className="text-gray-600 mb-8">{t.plans.standard.description}</p>
              
              <ul className="text-left space-y-3 mb-8">
                {t.plans.standard.features.map((feature: string, index: number) => (
                  <li key={index} className="flex items-center gap-3">
                    <Check className="w-5 h-5 text-purple-500 flex-shrink-0" />
                    <span className="text-gray-700">{feature}</span>
                  </li>
                ))}
              </ul>
              
              <button
                onClick={() => handleSubscription('standard')}
                disabled={isProcessing}
                className="w-full py-3 bg-gradient-to-r from-purple-600 to-purple-700 text-white rounded-xl font-semibold hover:from-purple-700 hover:to-purple-800 transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed shadow-lg"
              >
                {isProcessing ? 'Traitement...' : t.plans.standard.button}
              </button>
            </div>
          </div>

          {/* Plan Famille */}
          <div className={`relative bg-white/90 backdrop-blur-lg rounded-3xl shadow-xl p-8 transition-all duration-300 ${
            selectedPlan === 'family' ? 'ring-4 ring-blue-300 scale-105' : 'hover:shadow-2xl'
          }`}>
            <div className="text-center">
              <h3 className="text-2xl font-bold text-gray-800 mb-4">
                {t.plans.family.name}
              </h3>
              <div className="mb-6">
                <span className="text-4xl font-bold text-blue-600">{t.plans.family.price}</span>
                <span className="text-gray-500 ml-2">{t.plans.family.period}</span>
              </div>
              <p className="text-gray-600 mb-8">{t.plans.family.description}</p>
              
              <ul className="text-left space-y-3 mb-8">
                {t.plans.family.features.map((feature: string, index: number) => (
                  <li key={index} className="flex items-center gap-3">
                    <Check className="w-5 h-5 text-blue-500 flex-shrink-0" />
                    <span className="text-gray-700">{feature}</span>
                  </li>
                ))}
              </ul>
              
              <button
                onClick={() => handleSubscription('family')}
                disabled={isProcessing}
                className="w-full py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl font-semibold hover:from-blue-700 hover:to-blue-800 transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isProcessing ? 'Traitement...' : t.plans.family.button}
              </button>
            </div>
          </div>
        </div>

        {/* Garanties et Sécurité */}
        <div className="bg-white/80 backdrop-blur-lg rounded-2xl p-8 text-center">
          <div className="grid md:grid-cols-3 gap-8">
            <div className="flex items-center justify-center gap-3">
              <Shield className="w-6 h-6 text-green-600" />
              <span className="font-semibold text-gray-700">{t.guarantee}</span>
            </div>
            <div className="flex items-center justify-center gap-3">
              <CreditCard className="w-6 h-6 text-blue-600" />
              <span className="font-semibold text-gray-700">{t.secure}</span>
            </div>
            <div className="flex items-center justify-center gap-3">
              <X className="w-6 h-6 text-red-500" />
              <span className="font-semibold text-gray-700">{t.cancel}</span>
            </div>
          </div>
        </div>

        {/* Témoignages */}
        <div className="mt-16 text-center">
          <h3 className="text-2xl font-bold text-gray-800 mb-8">Ce que disent les parents</h3>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="bg-white/80 backdrop-blur-lg rounded-2xl p-6">
              <div className="flex items-center justify-center mb-4">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
                ))}
              </div>
              <p className="text-gray-600 italic mb-4">
                "Mon fils de 8 ans adore Math4Child ! Il a progressé énormément en quelques semaines."
              </p>
              <p className="font-semibold text-gray-800">- Sarah M.</p>
            </div>
            
            <div className="bg-white/80 backdrop-blur-lg rounded-2xl p-6">
              <div className="flex items-center justify-center mb-4">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
                ))}
              </div>
              <p className="text-gray-600 italic mb-4">
                "Interface magnifique et contenu pédagogique excellent. Je recommande vivement !"
              </p>
              <p className="font-semibold text-gray-800">- Thomas L.</p>
            </div>
            
            <div className="bg-white/80 backdrop-blur-lg rounded-2xl p-6">
              <div className="flex items-center justify-center mb-4">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
                ))}
              </div>
              <p className="text-gray-600 italic mb-4">
                "Le support multilingue est parfait pour notre famille bilingue."
              </p>
              <p className="font-semibold text-gray-800">- Maria R.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

// Autres composants simplifiés (gardés identiques)
function DemoPage({ onBack }: { onBack: () => void, language: SupportedLanguage }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-blue-50 to-purple-50 p-8">
      <div className="max-w-4xl mx-auto">
        <button onClick={onBack} className="mb-8 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
          ← Retour
        </button>
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-8">🧮 Calculatrice Interactive</h1>
          <p className="text-xl text-gray-600">Démo interactive avec problèmes mathématiques</p>
        </div>
      </div>
    </div>
  )
}

function InteractivePage({ onBack }: { onBack: () => void, language: SupportedLanguage }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-cyan-50 to-teal-50 p-8">
      <div className="max-w-6xl mx-auto">
        <button onClick={onBack} className="mb-8 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
          ← Retour
        </button>
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-8">📚 Apprentissage Interactif</h1>
          <p className="text-xl text-gray-600">Méthodes innovantes</p>
        </div>
      </div>
    </div>
  )
}

function MultilingualPage({ onBack }: { onBack: () => void, language: SupportedLanguage }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-emerald-50 to-teal-50 p-8">
      <div className="max-w-6xl mx-auto">
        <button onClick={onBack} className="mb-8 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
          ← Retour
        </button>
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-8">🌍 Support Multilingue</h1>
          <p className="text-xl text-gray-600">5 langues supportées</p>
        </div>
      </div>
    </div>
  )
}

function ProgressPage({ onBack }: { onBack: () => void, language: SupportedLanguage }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-yellow-50 via-orange-50 to-red-50 p-8">
      <div className="max-w-6xl mx-auto">
        <button onClick={onBack} className="mb-8 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
          ← Retour
        </button>
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-8">📊 Suivi des Progrès</h1>
          <p className="text-xl text-gray-600">Tableau de bord personnalisé</p>
        </div>
      </div>
    </div>
  )
}

function GamesPage({ onBack }: { onBack: () => void, language: SupportedLanguage }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-pink-50 to-indigo-50 p-8">
      <div className="max-w-6xl mx-auto">
        <button onClick={onBack} className="mb-8 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">
          ← Retour
        </button>
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-8">🎮 Jeux Éducatifs</h1>
          <p className="text-xl text-gray-600">Plus de 100 mini-jeux</p>
        </div>
      </div>
    </div>
  )
}
