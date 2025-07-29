'use client';

import { useLanguage } from '@/contexts/LanguageContext';
import LanguageSelector from '@/components/ui/LanguageSelector';

export default function HomePage() {
  const { t, isRTL } = useLanguage();

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-sm border-b border-gray-200 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">{t('appName')}</h1>
                <p className="text-sm text-gray-600">{t('tagline')}</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <div className="hidden md:flex items-center space-x-4">
                <span className="text-gray-700">{t('seeExercises')}</span>
                <span className="text-gray-700">{t('seeGames')}</span>
              </div>
              <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-semibold">
                {t('startFree')}
              </button>
              <LanguageSelector />
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center mb-16">
          <div className="inline-flex items-center space-x-2 bg-orange-100 text-orange-800 rounded-full px-6 py-3 text-lg font-medium mb-8">
            <span>🏆</span>
            <span>{t('appBadge')}</span>
          </div>
          
          <h2 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6 leading-tight">
            {t('applicationCorrected')}
          </h2>
          
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            {t('functionsNow')}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16">
            <button className="bg-blue-600 hover:bg-blue-700 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105">
              <span className="mr-2">🧮</span>
              {t('seeExercises')}
            </button>
            <button className="bg-green-600 hover:bg-green-700 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105">
              <span className="mr-2">🎮</span>
              {t('seeGames')}
            </button>
            <button className="bg-purple-600 hover:bg-purple-700 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105">
              <span className="mr-2">⭐</span>
              {t('seePremiumPlans')}
            </button>
          </div>
        </div>

        {/* Section Jeux Mathématiques */}
        <div className="mb-16">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4 flex items-center justify-center">
              <span className="mr-3">🎮</span>
              {t('mathGames')}
            </h2>
            <p className="text-xl text-gray-600">
              {t('chooseGame')}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Puzzle Math */}
            <div className="bg-gradient-to-br from-green-400 to-blue-500 rounded-2xl p-8 text-white shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:scale-105">
              <div className="text-center">
                <div className="text-4xl mb-4">🧩</div>
                <h3 className="text-2xl font-bold mb-4">{t('puzzleMath')}</h3>
                <p className="text-white/90 mb-6">{t('puzzleMathDesc')}</p>
                <button className="bg-white/20 hover:bg-white/30 backdrop-blur-sm border border-white/30 text-white px-6 py-3 rounded-xl font-semibold transition-all duration-200">
                  {t('playNow')} ▶
                </button>
              </div>
            </div>

            {/* Memory Math */}
            <div className="bg-gradient-to-br from-purple-400 to-pink-500 rounded-2xl p-8 text-white shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:scale-105">
              <div className="text-center">
                <div className="text-4xl mb-4">🧠</div>
                <h3 className="text-2xl font-bold mb-4">{t('memoryMath')}</h3>
                <p className="text-white/90 mb-6">{t('memoryMathDesc')}</p>
                <button className="bg-white/20 hover:bg-white/30 backdrop-blur-sm border border-white/30 text-white px-6 py-3 rounded-xl font-semibold transition-all duration-200">
                  {t('playNow')} ▶
                </button>
              </div>
            </div>

            {/* Quick Math */}
            <div className="bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl p-8 text-white shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:scale-105">
              <div className="text-center">
                <div className="text-4xl mb-4">⚡</div>
                <h3 className="text-2xl font-bold mb-4">{t('quickMath')}</h3>
                <p className="text-white/90 mb-6">{t('quickMathDesc')}</p>
                <button className="bg-white/20 hover:bg-white/30 backdrop-blur-sm border border-white/30 text-white px-6 py-3 rounded-xl font-semibold transition-all duration-200">
                  {t('playNow')} ▶
                </button>
              </div>
            </div>
          </div>

          {/* Bouton Découvrir les Exercices */}
          <div className="text-center mt-12">
            <button className="bg-green-600 hover:bg-green-700 text-white px-8 py-4 rounded-2xl font-bold text-xl shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105">
              <span className="mr-2">📚</span>
              {t('discoverExercises')}
            </button>
          </div>
        </div>

        {/* Message de confiance */}
        <div className="text-center mb-12">
          <p className="text-lg text-gray-600 mb-2">
            {t('alreadyTrusted')}
          </p>
          <div className="flex justify-center">
            <div className="flex">
              {[...Array(5)].map((_, i) => (
                <span key={i} className="text-yellow-400 text-2xl">⭐</span>
              ))}
            </div>
          </div>
        </div>

        {/* Section "Pourquoi choisir Math4Child ?" */}
        <div className="text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">
            {t('whyChoose')}
          </h2>
          <p className="text-lg text-gray-600 mb-12">
            {t('whyChooseDesc')}
          </p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="text-center">
              <div className="text-3xl font-bold text-blue-600 mb-2">100k+</div>
              <div className="text-gray-600">{t('families')}</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-green-600 mb-2">5M+</div>
              <div className="text-gray-600">{t('questionsResolved')}</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-purple-600 mb-2">98%</div>
              <div className="text-gray-600">{t('satisfaction')}</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-orange-600 mb-2">4.9★</div>
              <div className="text-gray-600">{t('averageRating')}</div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
