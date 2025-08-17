"use client"

import LanguageDropdown from '@/components/ui/LanguageDropdown'
import { useLanguage } from '@/hooks/useLanguage'

export default function HomePage() {
  const { t, currentLanguage } = useLanguage()

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header avec sélecteur de langue */}
      <header className="container mx-auto px-4 py-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-800">Math4Child v4.2.0</h1>
            <p className="text-sm text-gray-600">Révolution Éducative Mondiale</p>
          </div>
          <LanguageDropdown />
        </div>
      </header>

      {/* Contenu principal */}
      <main className="container mx-auto px-4 py-12">
        <div className="text-center max-w-4xl mx-auto">
          <h2 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
            {t('app_title')}
          </h2>
          
          <p className="text-xl text-gray-700 mb-8">
            La plateforme éducative la plus avancée technologiquement au monde
          </p>

          <div className="grid md:grid-cols-3 gap-8 mt-12">
            <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-4xl mb-4">🎯</div>
              <h3 className="text-xl font-bold mb-2">5 Niveaux</h3>
              <p className="text-gray-600">Progression adaptée à chaque enfant</p>
            </div>
            
            <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-4xl mb-4">🧠</div>
              <h3 className="text-xl font-bold mb-2">IA Adaptative</h3>
              <p className="text-gray-600">Intelligence artificielle révolutionnaire</p>
            </div>
            
            <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-4xl mb-4">🌍</div>
              <h3 className="text-xl font-bold mb-2">200+ Langues</h3>
              <p className="text-gray-600">Support universel multilingue</p>
            </div>
          </div>

          <div className="mt-12 space-y-4">
            <button className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:from-blue-700 hover:to-purple-700 transition-all transform hover:scale-105 shadow-lg">
              {t('start_learning')}
            </button>
            
            <div className="text-sm text-gray-500">
              Langue actuelle: {currentLanguage}
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="container mx-auto px-4 py-8 mt-16 border-t">
        <div className="text-center text-gray-600">
          <p>© 2024 Math4Child v4.2.0 - Révolution Éducative Mondiale</p>
          <p className="text-sm mt-2">Première mondiale des 6 innovations révolutionnaires</p>
        </div>
      </footer>
    </div>
  )
}
