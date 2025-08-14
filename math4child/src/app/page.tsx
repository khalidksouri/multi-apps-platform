'use client';

import React, { useState } from 'react';
import { 
  Book, Globe, Trophy, Play, Check, Users, Brain,
  Mic, Eye, Shield, Sparkles, ChevronDown, Plus, Minus, X, Divide
} from 'lucide-react';

interface Language {
  code: string;
  name: string;
  flag: string;
  rtl?: boolean;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  popular?: boolean;
  features: string[];
  badge?: string;
}

// 200+ langues supportées selon spécifications MATH4CHILD
const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  // Drapeaux arabes spécifiques selon spécifications
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', rtl: true }, // Drapeau marocain pour Afrique
  { code: 'ar-ps', name: 'العربية', flag: '🇵🇸', rtl: true }, // Drapeau palestinien pour Moyen-Orient
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺' },
  { code: 'ro', name: 'Română', flag: '🇷🇴' },
  { code: 'bg', name: 'Български', flag: '🇧🇬' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷' },
  { code: 'uk', name: 'Українська', flag: '🇺🇦' },
  { code: 'et', name: 'Eesti', flag: '🇪🇪' },
  { code: 'lv', name: 'Latviešu', flag: '🇱🇻' },
  { code: 'lt', name: 'Lietuvių', flag: '🇱🇹' },
  { code: 'sl', name: 'Slovenščina', flag: '🇸🇮' },
  { code: 'mt', name: 'Malti', flag: '🇲🇹' }
  // Note: Hébreu exclu selon spécifications MATH4CHILD
];

// Plans d'abonnement selon spécifications exactes MATH4CHILD
const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    profiles: 1, // 1 profil selon spécifications
    features: [
      '1 profil unique',
      '5 niveaux de progression',
      '100 réponses minimum par niveau',
      '5 opérations mathématiques',
      'Support communautaire',
      'Accès web uniquement'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 9.99,
    profiles: 2, // 2 profils selon spécifications
    features: [
      '2 profils utilisateur',
      'Toutes fonctionnalités BASIC',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Statistiques détaillées',
      'Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    profiles: 3, // 3 profils selon spécifications
    popular: true, // Le plus choisi selon spécifications
    badge: 'LE PLUS CHOISI',
    features: [
      '3 profils utilisateur',
      'Toutes fonctionnalités STANDARD',
      'Assistant vocal IA',
      'Réalité augmentée 3D',
      'Analytics avancées',
      'Personnalisation complète'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 19.99,
    profiles: 5, // 5 profils selon spécifications
    features: [
      '5 profils utilisateur',
      'Toutes fonctionnalités PREMIUM',
      'Rapports familiaux',
      'Contrôle parental avancé',
      'Support VIP prioritaire',
      'Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 29.99,
    profiles: 10, // 10+ profils selon spécifications
    features: [
      '10+ profils (sans limite)',
      'Devis personnalisé selon besoins',
      'API développeur',
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Personnalisation marque blanche'
    ]
  }
];

// Traductions selon spécifications multilingues
const translations = {
  fr: {
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    subtitle: 'La plateforme éducative la plus avancée technologiquement au monde',
    startLearning: 'Commencer l\'Apprentissage',
    features: 'Fonctionnalités Révolutionnaires',
    pricing: 'Tarification',
    level: 'Niveau',
    perMonth: '/mois',
    chooseThis: 'Choisir ce plan',
    support: 'Support : support@math4child.com',
    commercial: 'Commercial : commercial@math4child.com',
    freeVersion: 'Version gratuite 1 semaine - 50 questions',
    discounts: 'Réductions : 10% trimestriel, 30% annuel',
    multiPlatform: 'Multi-plateformes : jusqu\'à 75% de réduction'
  },
  en: {
    title: 'Math4Child v4.2.0 - Global Educational Revolution',
    subtitle: 'The world\'s most technologically advanced educational platform',
    startLearning: 'Start Learning',
    features: 'Revolutionary Features',
    pricing: 'Pricing',
    level: 'Level',
    perMonth: '/month',
    chooseThis: 'Choose this plan',
    support: 'Support: support@math4child.com',
    commercial: 'Commercial: commercial@math4child.com',
    freeVersion: 'Free version 1 week - 50 questions',
    discounts: 'Discounts: 10% quarterly, 30% annual',
    multiPlatform: 'Multi-platform: up to 75% discount'
  }
};

export default function Math4ChildApp() {
  const [selectedLanguage, setSelectedLanguage] = useState('fr');
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false);
  const [currentLevel, setCurrentLevel] = useState(1);

  const t = translations[selectedLanguage] || translations.fr;
  const currentLang = SUPPORTED_LANGUAGES.find(l => l.code === selectedLanguage) || SUPPORTED_LANGUAGES[0];
  const isRightToLeft = ['ar-ma', 'ar-ps'].includes(selectedLanguage);

  // 6 Innovations révolutionnaires selon spécifications
  const innovations = [
    {
      icon: <Brain className="w-8 h-8" />,
      title: 'IA Adaptative Avancée',
      description: 'PREMIÈRE MONDIALE - Intelligence artificielle qui s\'adapte en temps réel aux performances'
    },
    {
      icon: <Sparkles className="w-8 h-8" />,
      title: 'Reconnaissance Manuscrite',
      description: 'OCR avancé pour reconnaître l\'écriture dans tous les alphabets du monde'
    },
    {
      icon: <Eye className="w-8 h-8" />,
      title: 'Réalité Augmentée 3D',
      description: 'Visualisation immersive des concepts mathématiques en trois dimensions'
    },
    {
      icon: <Mic className="w-8 h-8" />,
      title: 'Assistant Vocal IA',
      description: 'Reconnaissance vocale multilingue dans plus de 200 langues'
    },
    {
      icon: <Trophy className="w-8 h-8" />,
      title: 'Moteur d\'Exercices Révolutionnaire',
      description: 'Générateur intelligent d\'exercices selon le niveau et les performances'
    },
    {
      icon: <Globe className="w-8 h-8" />,
      title: 'Système Langues Universel',
      description: 'Support de 200+ langues avec traduction en temps réel'
    }
  ];

  // 5 Opérations mathématiques selon spécifications
  const operations = [
    { icon: <Plus className="w-6 h-6" />, name: 'Addition', symbol: '+' },
    { icon: <Minus className="w-6 h-6" />, name: 'Soustraction', symbol: '-' },
    { icon: <X className="w-6 h-6" />, name: 'Multiplication', symbol: '×' },
    { icon: <Divide className="w-6 h-6" />, name: 'Division', symbol: '÷' },
    { icon: <Sparkles className="w-6 h-6" />, name: 'Mixte', symbol: '∞' }
  ];

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-600 via-purple-600 to-pink-500 ${isRightToLeft ? 'rtl' : 'ltr'}`}>
      {/* Header avec design interactif attrayant */}
      <header className="relative overflow-hidden bg-black/20 backdrop-blur-sm">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/20 to-purple-600/20"></div>
        <div className="relative container mx-auto px-6 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2">
                <Book className="w-8 h-8 text-white animate-pulse" />
                <span className="text-white font-bold text-xl">Math4Child</span>
                <span className="bg-white/20 text-white text-xs px-2 py-1 rounded-full">v4.2.0</span>
              </div>
            </div>
            
            {/* Sélecteur de langue avec scroll selon spécifications */}
            <div className="relative">
              <button
                onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                className="flex items-center space-x-2 bg-white/20 text-white px-4 py-2 rounded-lg hover:bg-white/30 transition-all transform hover:scale-105"
              >
                <Globe className="w-4 h-4" />
                <span className="text-lg">{currentLang.flag}</span>
                <span className="font-medium">{currentLang.name}</span>
                <ChevronDown className="w-4 h-4" />
              </button>

              {showLanguageDropdown && (
                <div className="absolute top-full right-0 mt-2 bg-white rounded-lg shadow-xl z-50 max-h-60 overflow-y-auto w-64">
                  {SUPPORTED_LANGUAGES.map((lang) => (
                    <button
                      key={lang.code}
                      onClick={() => {
                        setSelectedLanguage(lang.code);
                        setShowLanguageDropdown(false);
                      }}
                      className="w-full flex items-center space-x-3 px-4 py-3 hover:bg-blue-50 transition-colors text-left"
                    >
                      <span className="text-xl">{lang.flag}</span>
                      <span className="font-medium text-gray-800">{lang.name}</span>
                    </button>
                  ))}
                  <div className="px-4 py-2 text-center text-sm text-gray-500 border-t">
                    +170 autres langues disponibles...
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Section Hero avec design riche */}
      <section className="relative py-20">
        <div className="container mx-auto px-6 text-center">
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 leading-tight animate-float">
            {t.title}
          </h1>
          <p className="text-xl md:text-2xl text-white/90 mb-8 max-w-4xl mx-auto">
            {t.subtitle}
          </p>
          
          {/* Statistiques selon spécifications MATH4CHILD */}
          <div className="flex flex-wrap justify-center gap-8 mb-12">
            <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center transform hover:scale-105 transition-all">
              <div className="text-3xl font-bold text-white">200+</div>
              <div className="text-white/80">Langues Supportées</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center transform hover:scale-105 transition-all">
              <div className="text-3xl font-bold text-white">5</div>
              <div className="text-white/80">Niveaux de Progression</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center transform hover:scale-105 transition-all">
              <div className="text-3xl font-bold text-white">100</div>
              <div className="text-white/80">Réponses Min/Niveau</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center transform hover:scale-105 transition-all">
              <div className="text-3xl font-bold text-white">6</div>
              <div className="text-white/80">Innovations Révolutionnaires</div>
            </div>
          </div>

          <button className="bg-white text-blue-600 px-8 py-4 rounded-full text-xl font-bold hover:bg-blue-50 transition-all transform hover:scale-105 shadow-xl">
            <Play className="w-6 h-6 inline mr-2" />
            {t.startLearning}
          </button>
          
          {/* Version gratuite selon spécifications */}
          <div className="mt-6 text-white/80 text-sm">
            {t.freeVersion}
          </div>
        </div>
      </section>

      {/* Section 6 Innovations Révolutionnaires */}
      <section className="py-16 bg-black/20 backdrop-blur-sm">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center text-white mb-12">
            🚀 {t.features}
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {innovations.map((innovation, index) => (
              <div key={index} className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 hover:bg-white/20 transition-all transform hover:scale-105">
                <div className="text-white mb-4">{innovation.icon}</div>
                <h3 className="text-xl font-bold text-white mb-3">{innovation.title}</h3>
                <p className="text-white/80 text-sm">{innovation.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section 5 Niveaux de Progression selon spécifications */}
      <section className="py-16">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center text-white mb-12">
            🎮 Système de Progression (5 Niveaux)
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-5 gap-6 mb-12">
            {[1, 2, 3, 4, 5].map((level) => (
              <div key={level} className={`bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center transition-all transform hover:scale-105 ${currentLevel >= level ? 'bg-green-500/30' : ''}`}>
                <div className="text-3xl font-bold text-white mb-2">
                  {t.level} {level}
                </div>
                <div className="text-white/80 text-sm mb-4">
                  100 bonnes réponses minimum
                </div>
                <div className="flex items-center justify-center">
                  {currentLevel > level ? (
                    <Check className="w-6 h-6 text-green-400" />
                  ) : currentLevel === level ? (
                    <Trophy className="w-6 h-6 text-yellow-400" />
                  ) : (
                    <div className="w-6 h-6 border-2 border-white/40 rounded-full"></div>
                  )}
                </div>
              </div>
            ))}
          </div>

          {/* 5 Opérations mathématiques selon spécifications */}
          <h3 className="text-2xl font-bold text-center text-white mb-8">
            🧮 5 Opérations Mathématiques
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
            {operations.map((operation, index) => (
              <div key={index} className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 text-center hover:bg-white/30 transition-all transform hover:scale-105">
                <div className="text-white mb-4 flex justify-center">{operation.icon}</div>
                <h4 className="text-lg font-bold text-white mb-2">{operation.name}</h4>
                <div className="text-3xl font-bold text-white">{operation.symbol}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Tarification selon spécifications exactes */}
      <section className="py-16 bg-black/20 backdrop-blur-sm">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center text-white mb-12">
            💳 {t.pricing}
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div key={plan.id} className={`relative bg-white rounded-2xl p-6 shadow-xl transform hover:scale-105 transition-all ${plan.popular ? 'ring-4 ring-yellow-400' : ''}`}>
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <div className="bg-yellow-400 text-black px-4 py-1 rounded-full text-sm font-bold">
                      ⭐ {plan.badge}
                    </div>
                  </div>
                )}
                
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  <div className="text-4xl font-bold text-blue-600 mb-1">€{plan.price}</div>
                  <div className="text-gray-600 text-sm">{t.perMonth}</div>
                </div>

                <div className="space-y-3 mb-6">
                  <div className="flex items-center text-sm">
                    <Users className="w-4 h-4 text-blue-600 mr-2" />
                    <span className="font-semibold">{plan.profiles} profil{plan.profiles > 1 ? 's' : ''}</span>
                  </div>
                  {plan.features.slice(0, 4).map((feature, index) => (
                    <div key={index} className="flex items-start text-sm">
                      <Check className="w-4 h-4 text-green-500 mr-2 mt-0.5 flex-shrink-0" />
                      <span>{feature}</span>
                    </div>
                  ))}
                </div>

                <button className={`w-full py-3 rounded-lg font-bold transition-all ${plan.popular ? 'bg-blue-600 text-white hover:bg-blue-700' : 'bg-gray-100 text-gray-800 hover:bg-gray-200'}`}>
                  {t.chooseThis}
                </button>
              </div>
            ))}
          </div>

          {/* Réductions selon spécifications */}
          <div className="mt-12 text-center">
            <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 max-w-3xl mx-auto">
              <h3 className="text-xl font-bold text-white mb-4">📊 Système de Réductions</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-white text-sm">
                <div className="bg-white/10 rounded-lg p-4">
                  <div className="font-bold">Trimestriel</div>
                  <div className="text-green-400 text-lg">-10%</div>
                  <div>Paiement unique 3 mois</div>
                </div>
                <div className="bg-white/10 rounded-lg p-4">
                  <div className="font-bold">Annuel</div>
                  <div className="text-green-400 text-lg">-30%</div>
                  <div>Paiement unique 12 mois</div>
                </div>
                <div className="bg-white/10 rounded-lg p-4">
                  <div className="font-bold">Multi-plateformes</div>
                  <div className="text-green-400 text-lg">Jusqu'à -75%</div>
                  <div>2ème device: -50%, 3ème: -75%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer conforme aux spécifications */}
      <footer className="bg-black/40 backdrop-blur-sm py-12">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="flex items-center justify-center space-x-2 mb-4">
                <Book className="w-8 h-8 text-white" />
                <span className="text-white font-bold text-xl">Math4Child</span>
              </div>
              <p className="text-white/80 text-sm">Révolution Éducative Mondiale v4.2.0</p>
              <p className="text-white/60 text-xs mt-2">Applications hybrides: Web, Android, iOS</p>
            </div>
            
            <div>
              <h3 className="text-white font-bold mb-4">🔒 Sécurité & Conformité</h3>
              <div className="space-y-2 text-white/80 text-sm">
                <div>✅ Conformité COPPA/GDPR</div>
                <div>✅ Chiffrement bout-en-bout</div>
                <div>✅ Paiements sécurisés mondiaux</div>
                <div>✅ Hébergement souverain</div>
              </div>
            </div>
            
            <div>
              <h3 className="text-white font-bold mb-4">📞 Contact</h3>
              <div className="space-y-2 text-white/80 text-sm">
                <div>{t.support}</div>
                <div>{t.commercial}</div>
                <div className="text-white/60 text-xs mt-2">Domaine: www.math4child.com</div>
              </div>
            </div>
          </div>
          
          <div className="border-t border-white/20 mt-8 pt-8 text-center">
            <p className="text-white/60 text-sm">
              © 2025 Math4Child - La plateforme éducative la plus avancée technologiquement au monde
            </p>
            <div className="flex justify-center items-center space-x-4 mt-4">
              <div className="flex items-center space-x-1 text-white/80 text-sm">
                <Globe className="w-4 h-4" />
                <span>200+ Langues</span>
              </div>
              <div className="flex items-center space-x-1 text-white/80 text-sm">
                <Brain className="w-4 h-4" />
                <span>IA Adaptative</span>
              </div>
              <div className="flex items-center space-x-1 text-white/80 text-sm">
                <Shield className="w-4 h-4" />
                <span>100% Sécurisé</span>
              </div>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
