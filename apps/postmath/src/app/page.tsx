'use client';

import { useTranslation } from '../hooks/useUniversalI18n';
import { translations } from '../translations';

export default function HomePage() {
  const { t, currentLanguage } = useTranslation(translations);

  return (
    <div className="container mx-auto px-4 py-8">
      <header className="text-center mb-12">
        <h1 className="text-5xl font-bold text-gray-800 mb-4">
          {t('appName')}
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          {t('appDescription')}
        </p>
        <div className="inline-flex items-center space-x-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full">
          <span className="text-2xl">{currentLanguage.flag}</span>
          <span className="font-medium">{currentLanguage.nativeName}</span>
        </div>
      </header>

      <main className="max-w-4xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Navigation Cards */}
          {Object.entries(t('navigation') || {}).map(([key, value]) => (
            <div key={key} className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6">
              <h3 className="text-xl font-semibold mb-2">{value as string}</h3>
              <p className="text-gray-600 mb-4">
                Navigation vers {value as string}
              </p>
              <button className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition-colors">
                {t('navigate') || 'Accéder'}
              </button>
            </div>
          ))}
        </div>

        {/* Info Section */}
        <div className="mt-12 bg-gray-50 rounded-lg p-8">
          <h2 className="text-2xl font-bold mb-4">
            🌍 Application Multilingue
          </h2>
          <p className="text-gray-700 mb-4">
            Cette application supporte plus de 30 langues de tous les continents. 
            Votre choix de langue est automatiquement sauvegardé et persisté 
            lors de la navigation.
          </p>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl mb-2">🇬🇧</div>
              <div className="text-sm">English</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇫🇷</div>
              <div className="text-sm">Français</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇪🇸</div>
              <div className="text-sm">Español</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇨🇳</div>
              <div className="text-sm">中文</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇸🇦</div>
              <div className="text-sm">العربية</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇩🇪</div>
              <div className="text-sm">Deutsch</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇮🇳</div>
              <div className="text-sm">हिन्दी</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-2">🇯🇵</div>
              <div className="text-sm">日本語</div>
            </div>
          </div>
        </div>

        {/* Port Info */}
        <div className="mt-8 text-center">
          <div className="bg-green-100 border border-green-300 rounded-lg p-4">
            <p className="text-green-800">
              🚀 Application en cours d'exécution sur le port 3001
            </p>
            <p className="text-green-600 text-sm mt-2">
              URL: http://localhost:3001
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
