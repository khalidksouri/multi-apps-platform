#!/bin/bash

# =============================================================================
# Script d'ajout du sélecteur de langue AI4KIDS
# =============================================================================

set -e

echo "🌍 Ajout du sélecteur de langue AI4KIDS..."

# Configuration
PROJECT_ROOT="$(pwd)"
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonction pour afficher une étape
step() {
    echo -e "${BLUE}$1${NC}"
}

# Fonction pour afficher un succès
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Vérifier que nous sommes dans le bon dossier
if [ ! -d "$AI4KIDS_APP_DIR" ]; then
    echo -e "${RED}❌ Le dossier apps/ai4kids n'existe pas${NC}"
    exit 1
fi

cd "$AI4KIDS_APP_DIR"

# Créer le contexte de langue
step "🔧 Création du contexte de langue..."
mkdir -p src/contexts
cat > src/contexts/LanguageContext.tsx << 'EOF'
'use client';

import React, { createContext, useContext, useState, useEffect } from 'react';

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

export const languages: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳' },
];

interface LanguageContextType {
  currentLanguage: Language;
  setLanguage: (language: Language) => void;
  translations: Record<string, string>;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};

const defaultTranslations: Record<string, Record<string, string>> = {
  fr: {
    appName: 'AI4KIDS',
    welcome: 'Bienvenue sur AI4KIDS',
    description: 'Découvre le monde passionnant de l\'intelligence artificielle à travers des jeux, des histoires et des activités éducatives !',
    gamesTitle: 'Jeux Éducatifs',
    gamesDescription: 'Apprends les mathématiques, les sciences et bien plus à travers des jeux interactifs !',
    gamesButton: 'Jouer maintenant',
    storiesTitle: 'Histoires Magiques',
    storiesDescription: 'Découvre des histoires captivantes qui t\'enseignent des valeurs importantes !',
    storiesButton: 'Lire une histoire',
    aiTitle: 'Découvre l\'IA',
    aiDescription: 'Apprends comment fonctionne l\'intelligence artificielle de manière simple et amusante !',
    aiButton: 'Explorer l\'IA',
    ctaTitle: 'Prêt à commencer l\'aventure ?',
    ctaDescription: 'Rejoins des milliers d\'enfants qui apprennent et s\'amusent avec AI4KIDS !',
    ctaButton: 'Commencer maintenant',
    platformWeb: 'Version Web',
    platformMobile: 'Version',
    selectLanguage: 'Choisir la langue',
  },
  en: {
    appName: 'AI4KIDS',
    welcome: 'Welcome to AI4KIDS',
    description: 'Discover the exciting world of artificial intelligence through games, stories and educational activities!',
    gamesTitle: 'Educational Games',
    gamesDescription: 'Learn mathematics, science and much more through interactive games!',
    gamesButton: 'Play now',
    storiesTitle: 'Magic Stories',
    storiesDescription: 'Discover captivating stories that teach you important values!',
    storiesButton: 'Read a story',
    aiTitle: 'Discover AI',
    aiDescription: 'Learn how artificial intelligence works in a simple and fun way!',
    aiButton: 'Explore AI',
    ctaTitle: 'Ready to start the adventure?',
    ctaDescription: 'Join thousands of children who learn and have fun with AI4KIDS!',
    ctaButton: 'Start now',
    platformWeb: 'Web Version',
    platformMobile: 'Version',
    selectLanguage: 'Select language',
  },
  es: {
    appName: 'AI4KIDS',
    welcome: 'Bienvenido a AI4KIDS',
    description: '¡Descubre el emocionante mundo de la inteligencia artificial a través de juegos, historias y actividades educativas!',
    gamesTitle: 'Juegos Educativos',
    gamesDescription: '¡Aprende matemáticas, ciencias y mucho más a través de juegos interactivos!',
    gamesButton: 'Jugar ahora',
    storiesTitle: 'Historias Mágicas',
    storiesDescription: '¡Descubre historias cautivadoras que te enseñan valores importantes!',
    storiesButton: 'Leer una historia',
    aiTitle: 'Descubre la IA',
    aiDescription: '¡Aprende cómo funciona la inteligencia artificial de manera simple y divertida!',
    aiButton: 'Explorar IA',
    ctaTitle: '¿Listo para comenzar la aventura?',
    ctaDescription: '¡Únete a miles de niños que aprenden y se divierten con AI4KIDS!',
    ctaButton: 'Comenzar ahora',
    platformWeb: 'Versión Web',
    platformMobile: 'Versión',
    selectLanguage: 'Seleccionar idioma',
  },
  de: {
    appName: 'AI4KIDS',
    welcome: 'Willkommen bei AI4KIDS',
    description: 'Entdecke die aufregende Welt der künstlichen Intelligenz durch Spiele, Geschichten und Bildungsaktivitäten!',
    gamesTitle: 'Lernspiele',
    gamesDescription: 'Lerne Mathematik, Naturwissenschaften und vieles mehr durch interaktive Spiele!',
    gamesButton: 'Jetzt spielen',
    storiesTitle: 'Magische Geschichten',
    storiesDescription: 'Entdecke fesselnde Geschichten, die dir wichtige Werte vermitteln!',
    storiesButton: 'Geschichte lesen',
    aiTitle: 'KI entdecken',
    aiDescription: 'Lerne auf einfache und lustige Weise, wie künstliche Intelligenz funktioniert!',
    aiButton: 'KI erkunden',
    ctaTitle: 'Bereit für das Abenteuer?',
    ctaDescription: 'Schließe dich Tausenden von Kindern an, die mit AI4KIDS lernen und Spaß haben!',
    ctaButton: 'Jetzt starten',
    platformWeb: 'Web-Version',
    platformMobile: 'Version',
    selectLanguage: 'Sprache wählen',
  },
  it: {
    appName: 'AI4KIDS',
    welcome: 'Benvenuto su AI4KIDS',
    description: 'Scopri l\'entusiasmante mondo dell\'intelligenza artificiale attraverso giochi, storie e attività educative!',
    gamesTitle: 'Giochi Educativi',
    gamesDescription: 'Impara matematica, scienze e molto altro attraverso giochi interattivi!',
    gamesButton: 'Gioca ora',
    storiesTitle: 'Storie Magiche',
    storiesDescription: 'Scopri storie affascinanti che ti insegnano valori importanti!',
    storiesButton: 'Leggi una storia',
    aiTitle: 'Scopri l\'IA',
    aiDescription: 'Impara come funziona l\'intelligenza artificiale in modo semplice e divertente!',
    aiButton: 'Esplora IA',
    ctaTitle: 'Pronto per iniziare l\'avventura?',
    ctaDescription: 'Unisciti a migliaia di bambini che imparano e si divertono con AI4KIDS!',
    ctaButton: 'Inizia ora',
    platformWeb: 'Versione Web',
    platformMobile: 'Versione',
    selectLanguage: 'Seleziona lingua',
  },
  pt: {
    appName: 'AI4KIDS',
    welcome: 'Bem-vindo ao AI4KIDS',
    description: 'Descubra o emocionante mundo da inteligência artificial através de jogos, histórias e atividades educativas!',
    gamesTitle: 'Jogos Educativos',
    gamesDescription: 'Aprenda matemática, ciências e muito mais através de jogos interativos!',
    gamesButton: 'Jogar agora',
    storiesTitle: 'Histórias Mágicas',
    storiesDescription: 'Descubra histórias cativantes que ensinam valores importantes!',
    storiesButton: 'Ler uma história',
    aiTitle: 'Descubra a IA',
    aiDescription: 'Aprenda como a inteligência artificial funciona de forma simples e divertida!',
    aiButton: 'Explorar IA',
    ctaTitle: 'Pronto para começar a aventura?',
    ctaDescription: 'Junte-se a milhares de crianças que aprendem e se divertem com AI4KIDS!',
    ctaButton: 'Começar agora',
    platformWeb: 'Versão Web',
    platformMobile: 'Versão',
    selectLanguage: 'Selecionar idioma',
  },
  ar: {
    appName: 'AI4KIDS',
    welcome: 'مرحباً بك في AI4KIDS',
    description: 'اكتشف العالم المثير للذكاء الاصطناعي من خلال الألعاب والقصص والأنشطة التعليمية!',
    gamesTitle: 'الألعاب التعليمية',
    gamesDescription: 'تعلم الرياضيات والعلوم والكثير من خلال الألعاب التفاعلية!',
    gamesButton: 'العب الآن',
    storiesTitle: 'القصص السحرية',
    storiesDescription: 'اكتشف القصص الجذابة التي تعلمك القيم المهمة!',
    storiesButton: 'اقرأ قصة',
    aiTitle: 'اكتشف الذكاء الاصطناعي',
    aiDescription: 'تعلم كيف يعمل الذكاء الاصطناعي بطريقة بسيطة وممتعة!',
    aiButton: 'استكشف الذكاء الاصطناعي',
    ctaTitle: 'مستعد لبدء المغامرة؟',
    ctaDescription: 'انضم إلى آلاف الأطفال الذين يتعلمون ويستمتعون مع AI4KIDS!',
    ctaButton: 'ابدأ الآن',
    platformWeb: 'النسخة الإلكترونية',
    platformMobile: 'النسخة',
    selectLanguage: 'اختر اللغة',
  },
  zh: {
    appName: 'AI4KIDS',
    welcome: '欢迎来到 AI4KIDS',
    description: '通过游戏、故事和教育活动发现人工智能的精彩世界！',
    gamesTitle: '教育游戏',
    gamesDescription: '通过互动游戏学习数学、科学等更多知识！',
    gamesButton: '现在开始游戏',
    storiesTitle: '魔法故事',
    storiesDescription: '发现引人入胜的故事，教你重要的价值观！',
    storiesButton: '阅读故事',
    aiTitle: '发现人工智能',
    aiDescription: '以简单有趣的方式学习人工智能如何工作！',
    aiButton: '探索人工智能',
    ctaTitle: '准备开始冒险了吗？',
    ctaDescription: '加入成千上万与AI4KIDS一起学习和娱乐的孩子们！',
    ctaButton: '立即开始',
    platformWeb: '网页版',
    platformMobile: '版本',
    selectLanguage: '选择语言',
  },
};

interface LanguageProviderProps {
  children: React.ReactNode;
}

export const LanguageProvider: React.FC<LanguageProviderProps> = ({ children }) => {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(languages[0]);
  const [translations, setTranslations] = useState<Record<string, string>>(defaultTranslations.fr);

  useEffect(() => {
    // Charger la langue sauvegardée
    const savedLanguage = localStorage.getItem('ai4kids-language');
    if (savedLanguage) {
      const found = languages.find(lang => lang.code === savedLanguage);
      if (found) {
        setCurrentLanguage(found);
        setTranslations(defaultTranslations[found.code] || defaultTranslations.fr);
      }
    }
  }, []);

  const setLanguage = (language: Language) => {
    setCurrentLanguage(language);
    setTranslations(defaultTranslations[language.code] || defaultTranslations.fr);
    localStorage.setItem('ai4kids-language', language.code);
  };

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, translations }}>
      {children}
    </LanguageContext.Provider>
  );
};
EOF

success "Contexte de langue créé"

# Créer le composant sélecteur de langue
step "🎨 Création du composant sélecteur de langue..."
cat > src/components/LanguageSelector.tsx << 'EOF'
'use client';

import React, { useState } from 'react';
import { useLanguage, languages } from '../contexts/LanguageContext';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import { Capacitor } from '@capacitor/core';

export const LanguageSelector: React.FC = () => {
  const { currentLanguage, setLanguage, translations } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);

  const handleLanguageSelect = async (language: typeof languages[0]) => {
    // Feedback haptique sur mobile
    if (Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    
    setLanguage(language);
    setIsOpen(false);
  };

  const toggleOpen = async () => {
    if (Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    setIsOpen(!isOpen);
  };

  return (
    <div className="relative">
      {/* Bouton principal */}
      <button
        onClick={toggleOpen}
        className="flex items-center space-x-2 bg-white/20 backdrop-blur-sm rounded-full px-4 py-2 text-white hover:bg-white/30 transition-all duration-300 border border-white/30"
      >
        <span className="text-lg">{currentLanguage.flag}</span>
        <span className="text-sm font-medium hidden sm:block">{currentLanguage.nativeName}</span>
        <span className="text-sm font-medium sm:hidden">{currentLanguage.code.toUpperCase()}</span>
        <svg
          className={`w-4 h-4 transition-transform duration-300 ${isOpen ? 'rotate-180' : ''}`}
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* Menu déroulant */}
      {isOpen && (
        <>
          {/* Overlay pour fermer */}
          <div 
            className="fixed inset-0 z-40" 
            onClick={() => setIsOpen(false)}
          />
          
          {/* Menu */}
          <div className="absolute top-full right-0 mt-2 w-64 bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden z-50 animate-in slide-in-from-top-2 duration-300">
            <div className="p-3 border-b border-gray-100">
              <h3 className="text-sm font-semibold text-gray-700">
                {translations.selectLanguage}
              </h3>
            </div>
            
            <div className="max-h-64 overflow-y-auto">
              {languages.map((language) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left hover:bg-gray-50 transition-colors duration-200 ${
                    currentLanguage.code === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                  }`}
                >
                  <span className="text-xl">{language.flag}</span>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-medium truncate">
                      {language.nativeName}
                    </div>
                    <div className="text-xs text-gray-500 truncate">
                      {language.name}
                    </div>
                  </div>
                  {currentLanguage.code === language.code && (
                    <div className="text-blue-600">
                      <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                    </div>
                  )}
                </button>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
};
EOF

success "Composant sélecteur de langue créé"

# Mettre à jour la page d'accueil pour utiliser les traductions
step "🔄 Mise à jour de la page d'accueil avec les traductions..."
cat > src/app/page.tsx << 'EOF'
'use client';

import React from 'react';
import { AI4KidsLogoWithText } from '../components/AI4KidsLogo';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';
import { LanguageSelector } from '../components/LanguageSelector';
import { useCapacitor } from '../hooks/useCapacitor';
import { useLanguage } from '../contexts/LanguageContext';

export default function HomePage() {
  const { isNative, platform } = useCapacitor();
  const { translations } = useLanguage();

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-400 via-pink-300 to-orange-300">
      <div className="container mx-auto px-4 py-4 md:py-8">
        {/* Sélecteur de langue en haut à droite */}
        <div className="fixed top-4 right-4 z-50">
          <LanguageSelector />
        </div>

        {/* Header avec nouveau logo */}
        <header className="text-center mb-8 md:mb-12">
          <div className="flex justify-center mb-4 md:mb-6">
            <AI4KidsLogoWithText size={250} />
          </div>
          <h1 className="text-3xl md:text-5xl font-bold text-white mb-4 drop-shadow-lg">
            {translations.welcome}
          </h1>
          <p className="text-base md:text-xl text-white/90 max-w-2xl mx-auto px-4">
            {translations.description}
          </p>
          
          {/* Indicateur de plateforme */}
          <div className="mt-4 text-white/70 text-sm">
            {isNative ? (
              <span className="bg-white/20 px-3 py-1 rounded-full">
                📱 {translations.platformMobile} {platform}
              </span>
            ) : (
              <span className="bg-white/20 px-3 py-1 rounded-full">
                🌐 {translations.platformWeb}
              </span>
            )}
          </div>
        </header>

        {/* Section principales fonctionnalités */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8 mb-8 md:mb-12">
          {/* Jeux éducatifs */}
          <Card className="border-2 border-blue-200 text-center">
            <div className="text-5xl md:text-6xl mb-4">🎮</div>
            <h3 className="text-xl md:text-2xl font-bold text-blue-600 mb-4">
              {translations.gamesTitle}
            </h3>
            <p className="text-gray-700 mb-6 text-sm md:text-base">
              {translations.gamesDescription}
            </p>
            <Button variant="primary" haptic={true}>
              {translations.gamesButton}
            </Button>
          </Card>

          {/* Histoires interactives */}
          <Card className="border-2 border-green-200 text-center">
            <div className="text-5xl md:text-6xl mb-4">📚</div>
            <h3 className="text-xl md:text-2xl font-bold text-green-600 mb-4">
              {translations.storiesTitle}
            </h3>
            <p className="text-gray-700 mb-6 text-sm md:text-base">
              {translations.storiesDescription}
            </p>
            <Button variant="success" haptic={true}>
              {translations.storiesButton}
            </Button>
          </Card>

          {/* Découverte IA */}
          <Card className="border-2 border-orange-200 text-center">
            <div className="text-5xl md:text-6xl mb-4">🤖</div>
            <h3 className="text-xl md:text-2xl font-bold text-orange-600 mb-4">
              {translations.aiTitle}
            </h3>
            <p className="text-gray-700 mb-6 text-sm md:text-base">
              {translations.aiDescription}
            </p>
            <Button variant="secondary" haptic={true}>
              {translations.aiButton}
            </Button>
          </Card>
        </div>

        {/* Call to action */}
        <div className="text-center">
          <div className="bg-gradient-to-r from-purple-600 to-pink-600 rounded-3xl p-6 md:p-8 text-white shadow-xl">
            <h2 className="text-2xl md:text-3xl font-bold mb-4">
              {translations.ctaTitle}
            </h2>
            <p className="text-base md:text-xl mb-6 text-white/90">
              {translations.ctaDescription}
            </p>
            <Button size="lg" className="bg-white text-purple-600 hover:bg-gray-100" haptic={true}>
              {translations.ctaButton}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF

success "Page d'accueil mise à jour avec les traductions"

# Mettre à jour le layout pour inclure le provider de langue
step "🔧 Mise à jour du layout avec le provider de langue..."
cat > src/app/layout.tsx << 'EOF'
import type { Metadata, Viewport } from 'next';
import { LanguageProvider } from '../contexts/LanguageContext';
import './globals.css';

export const metadata: Metadata = {
  title: 'AI4KIDS - Intelligence Artificielle pour Enfants',
  description: 'Découvre le monde passionnant de l\'intelligence artificielle à travers des jeux, des histoires et des activités éducatives adaptées aux enfants.',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'default',
    title: 'AI4KIDS',
  },
  formatDetection: {
    telephone: false,
  },
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: '#4ECDC4',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="AI4KIDS" />
        <meta name="mobile-web-app-capable" content="yes" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Comic+Neue:wght@300;400;700&display=swap" rel="stylesheet" />
      </head>
      <body className="font-sans antialiased">
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  );
}
EOF

success "Layout mis à jour avec le provider de langue"

# Ajouter les styles pour les animations du sélecteur
step "🎨 Ajout des styles pour le sélecteur de langue..."
cat >> src/app/globals.css << 'EOF'

/* Animations pour le sélecteur de langue */
@keyframes slide-in-from-top {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation-duration: 0.2s;
  animation-fill-mode: both;
}

.slide-in-from-top-2 {
  animation-name: slide-in-from-top;
}

/* Styles pour le support RTL (arabe) */
html[dir="rtl"] {
  direction: rtl;
}

html[dir="rtl"] .rtl\:text-right {
  text-align: right;
}

html[dir="rtl"] .rtl\:flex-row-reverse {
  flex-direction: row-reverse;
}

/* Styles pour les langues avec polices spéciales */
.lang-ar {
  font-family: 'Arial', 'Helvetica', sans-serif;
}

.lang-zh {
  font-family: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
}

/* Amélioration du contraste pour l'accessibilité */
.high-contrast {
  filter: contrast(1.2);
}
EOF

success "Styles ajoutés pour le sélecteur de langue"

# Créer un hook pour la gestion des langues RTL
step "🔧 Création du hook pour les langues RTL..."
cat > src/hooks/useRTL.ts << 'EOF'
import { useEffect } from 'react';
import { useLanguage } from '../contexts/LanguageContext';

const RTL_LANGUAGES = ['ar', 'he', 'fa', 'ur'];

export const useRTL = () => {
  const { currentLanguage } = useLanguage();

  useEffect(() => {
    const isRTL = RTL_LANGUAGES.includes(currentLanguage.code);
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr');
    document.documentElement.setAttribute('lang', currentLanguage.code);
    
    // Ajouter une classe pour les polices spécifiques
    document.documentElement.className = `lang-${currentLanguage.code}`;
  }, [currentLanguage]);

  return {
    isRTL: RTL_LANGUAGES.includes(currentLanguage.code),
    currentLanguage,
  };
};
EOF

success "Hook RTL créé"

# Mettre à jour les dépendances dans package.json
step "📦 Mise à jour des dépendances..."
npm install

# Test de build
step "🧪 Test de build avec les traductions..."
npm run build

success "Build réussi avec les traductions"

# Message final
echo ""
echo -e "${GREEN}🎉 SÉLECTEUR DE LANGUE AJOUTÉ AVEC SUCCÈS !${NC}"
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}║      🌍 AI4KIDS - Sélecteur de langue intégré ! 🎨            ║${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 Fonctionnalités ajoutées :${NC}"
echo -e "${GREEN}✅${NC} Sélecteur de langue en haut à droite"
echo -e "${GREEN}✅${NC} 8 langues supportées : FR, EN, ES, DE, IT, PT, AR, ZH"
echo -e "${GREEN}✅${NC} Traductions complètes de l'interface"
echo -e "${GREEN}✅${NC} Persistance de la langue choisie"
echo -e "${GREEN}✅${NC} Support RTL pour l'arabe"
echo -e "${GREEN}✅${NC} Animations fluides"
echo -e "${GREEN}✅${NC} Feedback haptique sur mobile"
echo -e "${GREEN}✅${NC} Interface responsive"
echo ""
echo -e "${YELLOW}🌍 Langues disponibles :${NC}"
echo "🇫🇷 Français  🇬🇧 English  🇪🇸 Español  🇩🇪 Deutsch"
echo "🇮🇹 Italiano  🇵🇹 Português  🇸🇦 العربية  🇨🇳 中文"
echo ""
echo -e "${YELLOW}🚀 Testez maintenant :${NC}"
echo -e "${BLUE}npm run dev${NC}"
echo ""
echo -e "${YELLOW}🌐 Puis ouvrez :${NC}"
echo -e "${BLUE}http://localhost:3004${NC}"
echo ""
echo -e "${YELLOW}💡 Le sélecteur de langue est en haut à droite !${NC}"
echo ""
EOF

chmod +x "$PROJECT_ROOT/add_language_selector.sh"