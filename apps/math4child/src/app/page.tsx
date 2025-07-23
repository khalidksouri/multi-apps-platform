'use client'

import { useState } from 'react'

export default function HomePage() {
  const [lang, setLang] = useState('fr')

  const content = {
    fr: {
      title: 'Math4Child',
      subtitle: 'Apprendre les mathématiques en s\'amusant',
      start: 'Commencer',
      about: 'À propos'
    },
    en: {
      title: 'Math4Child', 
      subtitle: 'Learn mathematics while having fun',
      start: 'Start',
      about: 'About'
    },
    es: {
      title: 'Math4Child',
      subtitle: 'Aprende matemáticas divirtiéndote', 
      start: 'Empezar',
      about: 'Acerca de'
    }
  }

  const t = content[lang] || content.fr

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-600 to-purple-700">
      <div className="container mx-auto px-4 py-8">
        
        {/* Header simple */}
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-white text-3xl font-bold">{t.title}</h1>
          
          {/* Sélecteur de langue simple */}
          <div className="flex space-x-2">
            <button 
              onClick={() => setLang('fr')}
              className={`px-3 py-1 rounded ${lang === 'fr' ? 'bg-white text-blue-600' : 'bg-blue-500 text-white'}`}
            >
              🇫🇷 FR
            </button>
            <button 
              onClick={() => setLang('en')}
              className={`px-3 py-1 rounded ${lang === 'en' ? 'bg-white text-blue-600' : 'bg-blue-500 text-white'}`}
            >
              🇺🇸 EN
            </button>
            <button 
              onClick={() => setLang('es')}
              className={`px-3 py-1 rounded ${lang === 'es' ? 'bg-white text-blue-600' : 'bg-blue-500 text-white'}`}
            >
              🇪🇸 ES
            </button>
          </div>
        </header>

        {/* Contenu principal */}
        <div className="text-center py-16">
          <h2 className="text-white text-5xl font-bold mb-6">
            {t.subtitle}
          </h2>
          
          <p className="text-blue-100 text-xl mb-12 max-w-2xl mx-auto">
            Une application éducative moderne pour apprendre les mathématiques avec plaisir.
          </p>
          
          <div className="space-x-4">
            <button className="bg-white text-blue-600 px-8 py-4 rounded-lg font-semibold hover:bg-blue-50">
              {t.start}
            </button>
            <button className="border-2 border-white text-white px-8 py-4 rounded-lg font-semibold hover:bg-white hover:text-blue-600">
              {t.about}
            </button>
          </div>
        </div>

        {/* Fonctionnalités */}
        <div className="grid md:grid-cols-3 gap-8 mt-16">
          <div className="text-center">
            <div className="text-6xl mb-4">🧮</div>
            <h3 className="text-white text-xl font-bold mb-2">Mathématiques</h3>
            <p className="text-blue-100">Exercices adaptés</p>
          </div>
          <div className="text-center">
            <div className="text-6xl mb-4">🎮</div>
            <h3 className="text-white text-xl font-bold mb-2">Ludique</h3>
            <p className="text-blue-100">Apprendre en jouant</p>
          </div>
          <div className="text-center">
            <div className="text-6xl mb-4">💳</div>
            <h3 className="text-white text-xl font-bold mb-2">Paiement</h3>
            <p className="text-blue-100">Système sécurisé</p>
          </div>
        </div>

        {/* Footer */}
        <footer className="mt-16 text-center text-blue-100">
          <p>© 2024 Math4Child - Application éducative</p>
          <p className="mt-2">✅ Déployé avec succès sur Netlify</p>
        </footer>
      </div>
    </main>
  )
}
