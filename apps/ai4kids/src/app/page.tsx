'use client';

import React from 'react';
import { AI4KidsLogoWithText } from '../components/AI4KidsLogo';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';
import { LanguageSelector } from '../components/LanguageSelector';
import { useCapacitor } from '../hooks/useCapacitor';
import { useLanguage } from '../contexts/LanguageContext';
import Link from 'next/link';

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
            <Link href="/games">
              <Button variant="primary" haptic={true}>
                {translations.gamesButton}
              </Button>
            </Link>
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
            <Link href="/stories">
              <Button variant="success" haptic={true}>
                {translations.storiesButton}
              </Button>
            </Link>
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
            <Link href="/ai-discovery">
              <Button variant="secondary" haptic={true}>
                {translations.aiButton}
              </Button>
            </Link>
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
            <Link href="/start">
              <Button size="lg" className="bg-white text-purple-600 hover:bg-gray-100" haptic={true}>
                {translations.ctaButton}
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
