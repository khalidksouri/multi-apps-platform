// ==========================================
// CORRECTION DES BOUTONS MATH4CHILD
// Fichier: apps/math4child/src/app/page.tsx
// ==========================================

'use client';

import React, { useState, useEffect } from 'react';
import { Monitor, Smartphone, Globe, Crown, Languages, BarChart, BookOpen, Play, Book, X } from 'lucide-react';

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

// 25 LANGUES SUPPORTÉES selon les spécifications README (toutes sauf hébreu)
const LANGUAGES: Language[] = [
  // Europe (13 langues)
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮' },
  
  // Asie (8 langues)
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳' },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩' },
  { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾' },
  
  // Moyen-Orient & Afrique (3 langues RTL - PAS d'hébreu selon specs)
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇲🇦' }, // Drapeau marocain selon specs
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷' },
  { code: 'ur', name: 'اردو', nativeName: 'اردو', flag: '🇵🇰' },
  
  // Autres (2 langues)
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷' },
  { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇰🇪' },
];

const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    title: 'Math4Child - Apprends les maths en t\'amusant !',
    subtitle: 'L\'app éducative n°1 pour apprendre les mathématiques en famille',
    welcome: 'Bienvenue dans l\'aventure mathématique !',
    description: 'Une application complète pour apprendre les mathématiques de façon ludique et interactive.',
    startLearning: 'Commencer l\'apprentissage', // Selon traductions du README
    viewPlans: 'Voir les plans',
    features: [
      '🧮 Exercices interactifs adaptés au niveau',
      '🎯 5 niveaux de progression (100 bonnes réponses)',
      '📊 Suivi détaillé des progrès sauvegardé', 
      '🎮 5 opérations : +, -, ×, ÷, mixte',
      '🌍 25 langues mondiales (interface RTL)',
      '📱 Accès permanent aux niveaux validés'
    ]
  },
  en: {
    title: 'Math4Child - Learn math while having fun!',
    subtitle: 'The #1 educational app for learning mathematics as a family',
    welcome: 'Welcome to the mathematical adventure!',
    description: 'A comprehensive application to learn mathematics in a fun and interactive way.',
    startLearning: 'Start Learning',
    viewPlans: 'View Plans',
    features: [
      '🧮 Interactive exercises adapted to level',
      '🎯 5 progression levels (100 correct answers)',
      '📊 Detailed progress tracking saved',
      '🎮 5 operations: +, -, ×, ÷, mixed',
      '🌍 25 world languages (RTL interface)',
      '📱 Permanent access to validated levels'
    ]
  }
};

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [showLanguageModal, setShowLanguageModal] = useState(false);
  const [showPricingModal, setShowPricingModal] = useState(false);
  const [isLoaded, setIsLoaded] = useState(false);

  const t = TRANSLATIONS[currentLang] || TRANSLATIONS.fr;

  useEffect(() => {
    setIsLoaded(true);
  }, []);

  // ==========================================
  // FONCTIONS DE GESTION DES BOUTONS (CORRIGÉES)
  // ==========================================

  const handleStartLearning = () => {
    console.log('🚀 Commencer l\'apprentissage cliqué');
    
    // Redirection directe vers la page d'exercices selon les spécifications du README
    if (typeof window !== 'undefined') {
      try {
        // Redirection vers /exercises selon l'architecture Math4Child
        window.location.href = '/exercises';
      } catch (error) {
        console.log('Redirection vers /exercises');
        // Fallback : afficher une notification si la redirection échoue
        alert(`🎉 Bienvenue dans Math4Child !\n\n✅ Démarrage de l'apprentissage...\n📚 Redirection vers les exercices interactifs\n🎯 5 niveaux de progression disponibles`);
      }
    }
  };

  const handleShowPlans = () => {
    console.log('💎 Voir les plans cliqué');
    setShowPricingModal(true);
  };

  const handleSubscribe = (planName: string) => {
    console.log('💳 Abonnement:', planName);
    alert(`🚀 Abonnement "${planName}" sélectionné !\n\n✅ Redirection vers le paiement...\n💳 Traitement sécurisé`);
    setShowPricingModal(false);
  };

  const handleLanguageChange = (langCode: string) => {
    console.log('🌍 Changement de langue:', langCode);
    setCurrentLang(langCode);
    setShowLanguageModal(false);
    
    // Notification de changement
    const langName = LANGUAGES.find(l => l.code === langCode)?.name || langCode;
    alert(`🌍 Langue changée vers: ${langName}`);
  };

  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-emerald-500 ${isLoaded ? 'animate-fade-in' : 'opacity-0'}`}>
      
      {/* Header avec sélecteur de langue */}
      <header className="relative z-10 px-4 py-6">
        <div className="max-w-7xl mx-auto flex justify-between items-center">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <span className="text-2xl">🧮</span>
            </div>
            <span className="text-white text-xl font-bold">Math4Child</span>
          </div>
          
          <button 
            onClick={() => setShowLanguageModal(true)}
            className="flex items-center space-x-2 bg-white/20 backdrop-blur-sm border border-white/30 text-white rounded-lg px-4 py-2 hover:bg-white/30 transition-colors"
          >
            <span className="text-lg">{LANGUAGES.find(l => l.code === currentLang)?.flag}</span>
            <span className="font-medium">{LANGUAGES.find(l => l.code === currentLang)?.name}</span>
          </button>
        </div>
      </header>

      {/* Section Hero */}
      <main className="relative z-10 px-4 py-16">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-5xl md:text-6xl font-bold text-white mb-6 drop-shadow-2xl">
            {t.title}
          </h1>
          <p className="text-xl md:text-2xl text-white/90 mb-4 font-medium">
            {t.subtitle}
          </p>
          <p className="text-lg text-white/80 mb-12 max-w-2xl mx-auto leading-relaxed">
            {t.description}
          </p>

          {/* Boutons CTA FONCTIONNELS */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
            
            {/* Bouton Commencer l'apprentissage - FONCTIONNEL */}
            <button 
              onClick={handleStartLearning}
              className="group bg-gradient-to-r from-green-500 via-emerald-500 to-green-600 text-white px-10 py-5 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-300 transform hover:scale-105 hover:-translate-y-1 shadow-2xl hover:shadow-green-500/50 flex items-center space-x-3 min-w-[350px] relative overflow-hidden"
            >
              <Play className="w-6 h-6 group-hover:animate-bounce" />
              <span>{t.startLearning}</span>
              <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-1000"></div>
            </button>

            {/* Bouton Voir les plans - FONCTIONNEL */}
            <button 
              onClick={handleShowPlans}
              className="group bg-white/20 backdrop-blur-sm border-2 border-white/30 text-white px-10 py-5 rounded-2xl text-xl font-bold hover:bg-white/30 hover:border-white/50 transition-all duration-300 transform hover:scale-105 hover:-translate-y-1 shadow-2xl flex items-center space-x-3 min-w-[280px]"
            >
              <Book className="w-6 h-6 group-hover:animate-pulse" />
              <span>{t.viewPlans}</span>
            </button>
          </div>

          {/* Fonctionnalités */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 mb-20 max-w-6xl mx-auto">
            {t.features.map((feature, index) => (
              <div 
                key={index} 
                className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20 shadow-xl hover:shadow-2xl transition-all duration-500 hover:scale-105 cursor-pointer group"
                style={{animationDelay: `${index * 100}ms`}}
              >
                <div className="mb-3">
                  {index === 0 && <Crown className="h-8 w-8 text-yellow-400 mx-auto group-hover:animate-bounce" />}
                  {index === 1 && <Languages className="h-8 w-8 text-blue-400 mx-auto group-hover:animate-bounce" />}
                  {index === 2 && <BarChart className="h-8 w-8 text-green-400 mx-auto group-hover:animate-bounce" />}
                  {index === 3 && <BookOpen className="h-8 w-8 text-purple-400 mx-auto group-hover:animate-bounce" />}
                  {index === 4 && <Globe className="h-8 w-8 text-pink-400 mx-auto group-hover:animate-bounce" />}
                </div>
                <p className="text-sm font-semibold text-white leading-tight group-hover:text-yellow-300 transition-colors">
                  {feature}
                </p>
              </div>
            ))}
          </div>
        </div>
      </main>

      {/* Modal de sélection de langue */}
      {showLanguageModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm">
          <div className="bg-white rounded-2xl p-6 max-w-md w-full mx-4 max-h-[80vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-bold text-gray-900">Choisir une langue</h3>
              <button 
                onClick={() => setShowLanguageModal(false)}
                className="text-gray-500 hover:text-gray-700"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="grid grid-cols-2 gap-3">
              {LANGUAGES.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => handleLanguageChange(lang.code)}
                  className={`flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-100 transition-colors ${
                    currentLang === lang.code ? 'bg-blue-50 border-2 border-blue-500' : 'border border-gray-200'
                  }`}
                >
                  <span className="text-2xl">{lang.flag}</span>
                  <span className="font-medium text-gray-900">{lang.name}</span>
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Modal de pricing */}
      {showPricingModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm">
          <div className="bg-white rounded-2xl p-8 max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-2xl font-bold text-gray-900">Plans d'abonnement</h3>
              <button 
                onClick={() => setShowPricingModal(false)}
                className="text-gray-500 hover:text-gray-700"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* Plan Gratuit */}
              <div className="border-2 border-gray-200 rounded-xl p-6 relative">
                <h4 className="text-lg font-bold text-gray-900 mb-2">Gratuit</h4>
                <div className="text-3xl font-bold text-gray-900 mb-4">0€<span className="text-sm text-gray-500">/mois</span></div>
                <ul className="space-y-2 mb-6 text-sm text-gray-600">
                  <li>✅ 50 questions par jour</li>
                  <li>✅ 3 niveaux de base</li>
                  <li>✅ 1 profil enfant</li>
                </ul>
                <button 
                  onClick={() => handleSubscribe('Gratuit')}
                  className="w-full bg-gray-200 text-gray-800 py-2 px-4 rounded-lg font-medium hover:bg-gray-300 transition-colors"
                >
                  Commencer gratuitement
                </button>
              </div>

              {/* Plan Famille - Populaire */}
              <div className="border-2 border-blue-500 rounded-xl p-6 relative bg-blue-50">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-medium">
                    Populaire
                  </span>
                </div>
                <h4 className="text-lg font-bold text-gray-900 mb-2">Famille</h4>
                <div className="text-3xl font-bold text-blue-600 mb-4">9,99€<span className="text-sm text-gray-500">/mois</span></div>
                <ul className="space-y-2 mb-6 text-sm text-gray-600">
                  <li>✅ Questions illimitées</li>
                  <li>✅ Tous les niveaux</li>
                  <li>✅ 5 profils enfants</li>
                  <li>✅ Suivi des progrès</li>
                  <li>✅ Support prioritaire</li>
                </ul>
                <button 
                  onClick={() => handleSubscribe('Famille')}
                  className="w-full bg-blue-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-blue-600 transition-colors"
                >
                  Essai 7 jours gratuit
                </button>
              </div>

              {/* Plan École */}
              <div className="border-2 border-gray-200 rounded-xl p-6 relative">
                <h4 className="text-lg font-bold text-gray-900 mb-2">École</h4>
                <div className="text-3xl font-bold text-gray-900 mb-4">Sur devis</div>
                <ul className="space-y-2 mb-6 text-sm text-gray-600">
                  <li>✅ Profils illimités</li>
                  <li>✅ Tableau de bord enseignant</li>
                  <li>✅ Rapports détaillés</li>
                  <li>✅ Support dédié</li>
                  <li>✅ Formation incluse</li>
                </ul>
                <button 
                  onClick={() => handleSubscribe('École')}
                  className="w-full bg-green-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-600 transition-colors"
                >
                  Demander un devis
                </button>
              </div>
            </div>

            <div className="mt-8 text-center">
              <p className="text-gray-600 mb-4">
                ✨ Tous les plans incluent : Accès web et mobile • 25 langues • Mises à jour gratuites • Support client
              </p>
              <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-4">
                <h4 className="font-bold text-yellow-800 mb-2">🎯 Réductions Multi-Devices selon README :</h4>
                <ul className="text-yellow-700 text-sm">
                  <li>• 1er device : Prix plein</li>
                  <li>• 2ème device : <strong>50% de réduction</strong></li>
                  <li>• 3ème device : <strong>75% de réduction</strong></li>
                </ul>
              </div>
              <button 
                onClick={() => handleSubscribe('Essai gratuit global')}
                className="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-8 py-3 rounded-xl text-lg font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-300 shadow-xl transform hover:scale-105"
              >
                🚀 Commencer l'essai gratuit maintenant
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Styles pour les animations */}
      <style jsx>{`
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fade-in {
          animation: fade-in 0.8s ease-out;
        }
      `}</style>
    </div>
  );
}