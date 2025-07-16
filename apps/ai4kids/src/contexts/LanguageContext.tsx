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
