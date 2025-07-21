#!/bin/bash

# =============================================================================
# SCRIPT D'AMÉLIORATIONS MATH4CHILD - DESIGN PROFESSIONNEL+
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        🎨 AMÉLIORATIONS DESIGN MATH4CHILD 🎨           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"

cd apps/math4child

# Ajout d'animations et d'améliorations visuelles
print_info "Ajout d'animations avancées et de micro-interactions..."

cat > "src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { Sparkles, BookOpen, Calculator, Trophy, Globe, ChevronDown, Users, Star, Gamepad2, Heart, Zap, Target } from 'lucide-react'

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
  fr: {
    name: 'French',
    nativeName: 'Français',
    flag: '🇫🇷',
    appName: 'Math4Child'
  },
  en: {
    name: 'English',
    nativeName: 'English',
    flag: '🇺🇸',
    appName: 'Math4Child'
  },
  es: {
    name: 'Spanish',
    nativeName: 'Español',
    flag: '🇪🇸',
    appName: 'Math4Child'
  },
  de: {
    name: 'German',
    nativeName: 'Deutsch',
    flag: '🇩🇪',
    appName: 'Math4Child'
  },
  ar: {
    name: 'Arabic',
    nativeName: 'العربية',
    flag: '🇸🇦',
    appName: 'Math4Child',
    rtl: true
  }
}

// Traductions complètes avec plus de contenu
const translations: Record<SupportedLanguage, any> = {
  fr: {
    title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
    subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
    heroDescription: 'Transformez l\'apprentissage des mathématiques en aventure passionnante !',
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
      subscribe: 'S\'abonner - 9.99€/mois',
      demo: 'Voir la Démo'
    },
    stats: {
      students: 'Étudiants actifs',
      exercises: 'Exercices disponibles',
      languages: 'Langues supportées',
      satisfaction: 'Satisfaction parents'
    },
    benefits: {
      title: 'Pourquoi choisir Math4Child ?',
      adaptive: 'Apprentissage adaptatif',
      certified: 'Certifié par des pédagogues',
      safe: 'Environnement 100% sécurisé'
    }
  },
  en: {
    title: 'Math4Child - Learn math while having fun',
    subtitle: 'Multilingual educational platform for children aged 4 to 12',
    heroDescription: 'Transform math learning into an exciting adventure!',
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
      demo: 'View Demo'
    },
    stats: {
      students: 'Active students',
      exercises: 'Available exercises',
      languages: 'Supported languages',
      satisfaction: 'Parent satisfaction'
    },
    benefits: {
      title: 'Why choose Math4Child?',
      adaptive: 'Adaptive learning',
      certified: 'Certified by educators',
      safe: '100% safe environment'
    }
  },
  es: {
    title: 'Math4Child - Aprende matemáticas divirtiéndote',
    subtitle: 'Plataforma educativa multilingüe para niños de 4 a 12 años',
    heroDescription: '¡Transforma el aprendizaje de matemáticas en una aventura emocionante!',
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
    cta: {
      freeTrial: 'Prueba Gratuita 7 Días',
      freeTrialActive: '✨ ¡Prueba Activa!',
      subscribe: 'Suscribirse - €9.99/mes',
      demo: 'Ver Demo'
    },
    stats: {
      students: 'Estudiantes activos',
      exercises: 'Ejercicios disponibles',
      languages: 'Idiomas soportados',
      satisfaction: 'Satisfacción padres'
    },
    benefits: {
      title: '¿Por qué elegir Math4Child?',
      adaptive: 'Aprendizaje adaptativo',
      certified: 'Certificado por educadores',
      safe: 'Entorno 100% seguro'
    }
  },
  de: {
    title: 'Math4Child - Mathematik lernen macht Spaß',
    subtitle: 'Mehrsprachige Bildungsplattform für Kinder von 4 bis 12 Jahren',
    heroDescription: 'Verwandeln Sie das Mathematiklernen in ein aufregendes Abenteuer!',
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
    cta: {
      freeTrial: '7-Tage Kostenlos',
      freeTrialActive: '✨ Testversion aktiv!',
      subscribe: 'Abonnieren - €9.99/Monat',
      demo: 'Demo ansehen'
    },
    stats: {
      students: 'Aktive Schüler',
      exercises: 'Verfügbare Übungen',
      languages: 'Unterstützte Sprachen',
      satisfaction: 'Elternzufriedenheit'
    },
    benefits: {
      title: 'Warum Math4Child wählen?',
      adaptive: 'Adaptives Lernen',
      certified: 'Von Pädagogen zertifiziert',
      safe: '100% sichere Umgebung'
    }
  },
  ar: {
    title: 'Math4Child - تعلم الرياضيات بمتعة',
    subtitle: 'منصة تعليمية متعددة اللغات للأطفال من 4 إلى 12 سنة',
    heroDescription: 'حوّل تعلم الرياضيات إلى مغامرة مثيرة!',
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
    cta: {
      freeTrial: 'تجربة مجانية 7 أيام',
      freeTrialActive: '✨ التجربة نشطة!',
      subscribe: 'اشتراك - €9.99/شهر',
      demo: 'مشاهدة العرض'
    },
    stats: {
      students: 'الطلاب النشطون',
      exercises: 'التمارين المتاحة',
      languages: 'اللغات المدعومة',
      satisfaction: 'رضا الأولياء'
    },
    benefits: {
      title: 'لماذا نختار Math4Child؟',
      adaptive: 'التعلم التكيفي',
      certified: 'معتمد من قبل المربين',
      safe: 'بيئة آمنة 100%'
    }
  }
}

export default function HomePage() {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('en')
  const [freeTrialActive, setFreeTrialActive] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  // Correction TypeScript : typage explicite et assertion de type
  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage as SupportedLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as SupportedLanguage] || translations['fr']
  const isRTL = currentLangConfig.rtl || false

  const startFreeTrial = () => {
    setFreeTrialActive(true)
    // Animation de confetti (simulation)
    console.log('🎉 Essai gratuit démarré !')
  }

  const handleSubscribe = () => {
    console.log('Redirection vers l\'abonnement Stripe')
  }

  const handleDemo = () => {
    console.log('Ouverture de la démo interactive')
  }

  if (!mounted) {
    return <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50"></div>
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header avec sélecteur de langue */}
      <header className="p-4 flex justify-between items-center backdrop-blur-sm bg-white/30 sticky top-0 z-50">
        <div className="flex items-center space-x-2 group">
          <div className="p-2 bg-blue-600 rounded-xl group-hover:bg-blue-700 transition-all duration-300">
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
            className="appearance-none bg-white/90 backdrop-blur border border-gray-200 rounded-xl px-4 py-2 pr-10 text-sm font-medium text-gray-700 hover:border-blue-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200"
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
        {/* Hero Section améliorée */}
        <div className="max-w-6xl mx-auto text-center mb-16">
          <div className="relative mb-8">
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
              {t.title}
            </h1>
            <div className="absolute -top-4 -right-4 text-4xl animate-bounce">🎨</div>
            <div className="absolute -bottom-2 -left-4 text-3xl animate-pulse">✨</div>
          </div>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-4 max-w-4xl mx-auto">
            {t.subtitle}
          </p>
          <p className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto">
            {t.heroDescription}
          </p>

          {/* Stats Section avec animations */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
              <div className="text-3xl font-bold bg-gradient-to-r from-blue-500 to-blue-700 bg-clip-text text-transparent mb-2">
                10K+
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Users className="w-4 h-4" />
                {t.stats.students}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
              <div className="text-3xl font-bold bg-gradient-to-r from-green-500 to-green-700 bg-clip-text text-transparent mb-2">
                500+
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Target className="w-4 h-4" />
                {t.stats.exercises}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
              <div className="text-3xl font-bold bg-gradient-to-r from-purple-500 to-purple-700 bg-clip-text text-transparent mb-2">
                5
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Globe className="w-4 h-4" />
                {t.stats.languages}
              </div>
            </div>
            
            <div className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
              <div className="text-3xl font-bold bg-gradient-to-r from-yellow-500 to-orange-500 bg-clip-text text-transparent mb-2">
                98%
              </div>
              <div className="text-sm text-gray-600 flex items-center gap-2">
                <Heart className="w-4 h-4" />
                {t.stats.satisfaction}
              </div>
            </div>
          </div>

          {/* Features Grid améliorée */}
          <div className="grid md:grid-cols-4 gap-8 mb-16">
            <div className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:rotate-1">
              <div className="p-4 bg-gradient-to-r from-blue-500 to-blue-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <BookOpen className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg">{t.features.interactive}</h3>
              <p className="text-gray-600 text-sm">{t.features.interactiveDesc}</p>
            </div>
            
            <div className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:-rotate-1">
              <div className="p-4 bg-gradient-to-r from-green-500 to-green-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Globe className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg">{t.features.multilingual}</h3>
              <p className="text-gray-600 text-sm">{t.features.multilingualDesc}</p>
            </div>
            
            <div className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:rotate-1">
              <div className="p-4 bg-gradient-to-r from-yellow-500 to-orange-500 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Trophy className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg">{t.features.progress}</h3>
              <p className="text-gray-600 text-sm">{t.features.progressDesc}</p>
            </div>
            
            <div className="group p-8 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:-rotate-1">
              <div className="p-4 bg-gradient-to-r from-purple-500 to-purple-600 rounded-2xl mx-auto w-fit mb-6 group-hover:scale-110 transition-transform duration-300">
                <Gamepad2 className="w-8 h-8 text-white" />
              </div>
              <h3 className="font-bold text-gray-800 mb-3 text-lg">{t.features.games}</h3>
              <p className="text-gray-600 text-sm">{t.features.gamesDesc}</p>
            </div>
          </div>

          {/* Section avantages */}
          <div className="mb-16 p-8 bg-gradient-to-r from-blue-50 to-purple-50 rounded-3xl">
            <h2 className="text-3xl font-bold text-gray-800 mb-8">{t.benefits.title}</h2>
            <div className="grid md:grid-cols-3 gap-6">
              <div className="flex items-center space-x-3 p-4 bg-white/60 rounded-xl">
                <Zap className="w-6 h-6 text-blue-600" />
                <span className="font-semibold text-gray-700">{t.benefits.adaptive}</span>
              </div>
              <div className="flex items-center space-x-3 p-4 bg-white/60 rounded-xl">
                <Star className="w-6 h-6 text-yellow-600" />
                <span className="font-semibold text-gray-700">{t.benefits.certified}</span>
              </div>
              <div className="flex items-center space-x-3 p-4 bg-white/60 rounded-xl">
                <Trophy className="w-6 h-6 text-green-600" />
                <span className="font-semibold text-gray-700">{t.benefits.safe}</span>
              </div>
            </div>
          </div>

          {/* Call to Action amélioré */}
          <div className="space-y-6 md:space-y-0 md:space-x-6 md:flex md:justify-center md:items-center">
            <button
              onClick={startFreeTrial}
              className={`group px-10 py-4 rounded-2xl font-bold text-white transition-all duration-300 transform hover:scale-105 shadow-2xl relative overflow-hidden ${
                freeTrialActive 
                  ? 'bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700' 
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
              <span className="relative z-10">{t.cta.subscribe}</span>
              <div className="absolute inset-0 bg-white/20 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></div>
            </button>
            
            <button 
              onClick={handleDemo}
              className="px-10 py-4 border-2 border-gray-300 text-gray-700 rounded-2xl font-bold hover:border-blue-400 hover:bg-blue-50 hover:text-blue-600 transition-all duration-300 transform hover:scale-105"
            >
              {t.cta.demo}
            </button>
          </div>
        </div>
      </main>

      {/* Footer amélioré */}
      <footer className="py-8 text-center text-gray-500 bg-white/30 backdrop-blur-sm">
        <p className="flex items-center justify-center space-x-2">
          <span>&copy; 2024 {currentLangConfig.appName}.</span>
          <span>Made with</span>
          <Heart className="w-4 h-4 text-red-500 animate-pulse" />
          <span>for children worldwide.</span>
        </p>
      </footer>
    </div>
  )
}
EOF

print_success "Interface avec animations et micro-interactions ajoutée"

# Amélioration du CSS global avec animations
cat > "src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Support RTL */
[dir="rtl"] {
  direction: rtl;
}

[dir="ltr"] {
  direction: ltr;
}

/* Animations personnalisées avancées */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px rgba(59, 130, 246, 0.5); }
  50% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.8), 0 0 30px rgba(59, 130, 246, 0.6); }
}

@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.float-animation {
  animation: float 3s ease-in-out infinite;
}

.glow-effect {
  animation: glow 2s ease-in-out infinite alternate;
}

.gradient-animated {
  background-size: 200% 200%;
  animation: gradient-shift 3s ease infinite;
}

/* Styles pour les langues RTL */
.rtl {
  direction: rtl;
}

.ltr {
  direction: ltr;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(45deg, #3b82f6, #8b5cf6);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(45deg, #2563eb, #7c3aed);
}

/* Effet de particules pour le background */
.particles {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: -1;
}

.particle {
  position: absolute;
  background: rgba(59, 130, 246, 0.1);
  border-radius: 50%;
  animation: float 6s ease-in-out infinite;
}

/* Responsive amélioré */
@media (max-width: 768px) {
  .container {
    padding: 0 1rem;
  }
}

/* Focus states améliorés */
button:focus,
select:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Transitions fluides */
* {
  transition: all 0.2s ease-in-out;
}
EOF

print_success "CSS avec animations avancées mis à jour"

print_info "Test de la nouvelle version..."
npm run build

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                🎨 DESIGN PROFESSIONNEL+ TERMINÉ 🎨       ║"
echo "║                                                            ║"
echo "║  ✨ Améliorations ajoutées :                              ║"
echo "║     🎭 Animations et micro-interactions                   ║"
echo "║     💫 Effets de hover avancés                           ║"
echo "║     🌈 Gradients animés                                   ║"
echo "║     🎯 Glassmorphism et backdrop-blur                     ║"
echo "║     💎 Cards flottantes avec rotations                   ║"
echo "║     ⚡ Transitions fluides partout                       ║"
echo "║     🎊 Effets visuels premium                            ║"
echo "║                                                            ║"
echo "║  🚀 Votre Math4Child est maintenant niveau PREMIUM !     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"