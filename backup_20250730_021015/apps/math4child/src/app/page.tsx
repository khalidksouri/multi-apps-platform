'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Play, Star, Globe, Trophy, Users, BookOpen, Sparkles } from 'lucide-react';
import { useLanguage } from '@/hooks/useLanguage';
import LanguageSelector from '@/components/language/LanguageSelector';
import PricingModal from '@/components/pricing/PricingModal';

export default function HomePage() {
  const { t, currentLanguage } = useLanguage();
  const [showMessage, setShowMessage] = useState(false);
  const [showPricingModal, setShowPricingModal] = useState(false);

  const features = [
    {
      icon: <BookOpen className="w-8 h-8 text-blue-500" />,
      title: t('exercises'),
      description: "Calculs adaptés à chaque niveau"
    },
    {
      icon: <Trophy className="w-8 h-8 text-yellow-500" />,
      title: t('levels5'),
      description: t('levelsDesc')
    },
    {
      icon: <Users className="w-8 h-8 text-green-500" />,
      title: t('multiProfiles'),
      description: t('multiProfilesDesc')
    },
    {
      icon: <Globe className="w-8 h-8 text-purple-500" />,
      title: t('languages75'),
      description: t('languagesDesc')
    }
  ];

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 ${currentLanguage.rtl ? 'rtl' : 'ltr'}`}>
      {/* Header premium avec sélecteur de langues */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-gray-800">{t('appName')}</h1>
                <p className="text-sm text-gray-600">{t('appDescription')}</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              <LanguageSelector />
              <nav className="hidden md:flex space-x-6">
                <Link href="/exercises" className="text-gray-600 hover:text-blue-600 font-medium">
                  {t('exercises')}
                </Link>
                <Link href="/games" className="text-gray-600 hover:text-blue-600 font-medium">
                  {t('games')}
                </Link>
                <button 
                  onClick={() => setShowPricingModal(true)}
                  className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-6 py-2 rounded-lg hover:from-blue-600 hover:to-purple-700 transition-all duration-200 font-semibold"
                >
                  {t('startFree')}
                </button>
              </nav>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section Premium */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="inline-flex items-center bg-gradient-to-r from-blue-100 to-purple-100 px-6 py-3 rounded-full mb-8 border border-blue-200">
            <Star className="w-5 h-5 text-blue-600 mr-2" />
            <span className="text-blue-800 font-semibold">App Éducative #1 en France</span>
            <Sparkles className="w-5 h-5 text-purple-600 ml-2" />
          </div>
          
          <div className="mb-8">
            <div className="text-6xl mb-4">🎉</div>
            <h2 className="text-3xl font-bold text-green-600 mb-4">
              {t('correctedApp')}
            </h2>
            <p className="text-xl text-gray-600 mb-8">
              {t('worksPerfectly')}
            </p>
          </div>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
            <Link 
              href="/exercises"
              className="bg-blue-500 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:bg-blue-600 transition-all duration-200 flex items-center justify-center"
            >
              🧮 {t('exercises')}
            </Link>
            
            <Link 
              href="/games"
              className="bg-green-500 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center"
            >
              🎮 {t('games')}
            </Link>
            
            <button 
              onClick={() => setShowPricingModal(true)}
              className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:from-purple-600 hover:to-pink-600 transition-all duration-200 flex items-center justify-center"
            >
              <Star className="w-5 h-5 mr-2" />
              Plans Premium
            </button>
          </div>
          
          <div className="text-center mb-8">
            <p className="text-gray-500 mb-4">Déjà 100k+ familles nous font confiance</p>
            <div className="flex justify-center items-center space-x-1">
              {[...Array(5)].map((_, i) => (
                <Star key={i} className="w-6 h-6 text-yellow-400 fill-current" />
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Features Section Premium */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              Pourquoi choisir Math4Child ?
            </h2>
            <p className="text-gray-600 text-xl">
              Découvrez toutes les fonctionnalités qui font de Math4Child l'app n°1
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="text-center p-8 rounded-2xl bg-gradient-to-br from-gray-50 to-white hover:from-blue-50 hover:to-purple-50 hover:shadow-lg transition-all duration-300 border border-gray-100">
                <div className="mb-6 flex justify-center">
                  <div className="p-4 bg-white rounded-2xl shadow-md">
                    {feature.icon}
                  </div>
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  {feature.title}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Test d'interactivité premium */}
      <section className="py-12 bg-gradient-to-r from-purple-50 to-pink-50">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h3 className="text-2xl font-bold text-gray-800 mb-6">
            Testez les Nouvelles Fonctionnalités Premium
          </h3>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-8">
            <button 
              onClick={() => setShowMessage(!showMessage)}
              className="bg-purple-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-purple-600 transition-colors"
            >
              ⚡ {t('testInteractivity')}
            </button>
            
            <button 
              onClick={() => setShowPricingModal(true)}
              className="bg-gradient-to-r from-blue-500 to-green-500 text-white px-6 py-3 rounded-lg font-semibold hover:from-blue-600 hover:to-green-600 transition-all duration-200"
            >
              💰 Voir les Plans
            </button>
          </div>
          
          {showMessage && (
            <div className="bg-white border-2 border-green-400 rounded-xl p-6 mb-6 animate-pulse">
              <p className="text-green-800 font-semibold text-lg">
                ✅ {t('interactivityWorks')}
              </p>
              <div className="mt-4 flex justify-center space-x-4">
                <span className="text-2xl">{currentLanguage.flag}</span>
                <span className="font-bold text-purple-600">{currentLanguage.nativeName}</span>
                <span className="text-sm text-gray-600">Langue actuelle</span>
              </div>
            </div>
          )}
        </div>
      </section>

      {/* Footer premium */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="flex items-center justify-center space-x-3 mb-6">
            <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
              <span className="text-white text-lg font-bold">M4C</span>
            </div>
            <span className="text-xl font-bold">{t('appName')}</span>
          </div>
          <p className="text-gray-400 mb-6">
            {t('copyright')}
          </p>
          <div className="flex justify-center space-x-6">
            <span className="text-sm text-gray-500">🌍 {t('languages75')}</span>
            <span className="text-sm text-gray-500">📱 Multi-Plateformes</span>
            <span className="text-sm text-gray-500">🏆 {t('levels5')}</span>
          </div>
        </div>
      </footer>

      {/* Modal de tarification premium */}
      <PricingModal 
        isOpen={showPricingModal} 
        onClose={() => setShowPricingModal(false)} 
      />
    </div>
  );
}
