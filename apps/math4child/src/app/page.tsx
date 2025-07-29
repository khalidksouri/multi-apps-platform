'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function HomePage() {
  const [language, setLanguage] = useState('fr');

  const handleMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1.05)';
  };

  const handleMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1)';
  };

  const handleFeatureMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.borderColor = '#3b82f6';
    target.style.color = '#3b82f6';
  };

  const handleFeatureMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.borderColor = '#d1d5db';
    target.style.color = '#374151';
  };

  const translations = {
    fr: {
      title: 'Math4Child',
      subtitle: 'L\'apprentissage des mathématiques rendu amusant pour les enfants',
      description: 'Une application éducative interactive qui aide les enfants à maîtriser les mathématiques de base avec des exercices personnalisés et un suivi des progrès.',
      startLearning: 'Commencer l\'apprentissage',
      viewPlans: 'Voir les formules',
      features: 'Fonctionnalités',
      featuresSubtitle: 'Tout ce dont votre enfant a besoin pour réussir en mathématiques'
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Making math learning fun for children',
      description: 'An interactive educational app that helps children master basic mathematics with personalized exercises and progress tracking.',
      startLearning: 'Start Learning',
      viewPlans: 'View Plans',
      features: 'Features',
      featuresSubtitle: 'Everything your child needs to succeed in mathematics'
    }
  };

  const t = translations[language as keyof typeof translations];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <div className="text-2xl font-bold text-blue-600">
                🧮 {t.title}
              </div>
            </div>
            <nav className="flex space-x-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
                Accueil
              </Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium">
                Exercices
              </Link>
              <Link href="/subscription" className="text-gray-700 hover:text-blue-600 font-medium">
                Abonnement
              </Link>
            </nav>
            <div className="flex items-center space-x-4">
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value)}
                className="border border-gray-300 rounded-md px-3 py-1 text-sm"
              >
                <option value="fr">🇫🇷 Français</option>
                <option value="en">🇺🇸 English</option>
              </select>
            </div>
          </div>
        </div>
      </header>

      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            {t.title}
          </h1>
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto">
            {t.subtitle}
          </p>
          <p className="text-lg text-gray-500 mb-12 max-w-2xl mx-auto">
            {t.description}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="/exercises"
              className="bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg hover:bg-blue-700"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              {t.startLearning}
            </Link>
            <Link
              href="/subscription"
              className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg border-2 border-blue-600 hover:bg-blue-50"
              onMouseOver={handleFeatureMouseOver}
              onMouseOut={handleFeatureMouseOut}
            >
              {t.viewPlans}
            </Link>
          </div>
        </div>
      </section>

      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">{t.features}</h2>
            <p className="text-xl text-gray-600">{t.featuresSubtitle}</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              { icon: '🧮', title: 'Exercices Personnalisés', description: 'Des problèmes adaptés au niveau de votre enfant' },
              { icon: '🎯', title: 'Suivi des Progrès', description: 'Visualisez les améliorations en temps réel' },
              { icon: '📊', title: 'Statistiques Détaillées', description: 'Analyse complète des performances' },
              { icon: '🎮', title: 'Apprentissage Ludique', description: 'Rend les mathématiques amusantes' },
              { icon: '🌍', title: 'Multilingue', description: 'Disponible en plusieurs langues' },
              { icon: '📱', title: 'Multi-Plateforme', description: 'Web, Android et iOS' }
            ].map((feature, index) => (
              <div key={index} className="bg-gradient-to-br from-white to-gray-50 rounded-2xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 border border-gray-100">
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="py-20 bg-blue-600">
        <div className="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold text-white mb-6">Prêt à commencer l'aventure mathématique ?</h2>
          <p className="text-xl text-blue-100 mb-8">Rejoignez des milliers de familles qui font confiance à Math4Child</p>
          <Link href="/exercises" className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg" onMouseOver={handleMouseOver} onMouseOut={handleMouseOut}>
            Commencer gratuitement
          </Link>
        </div>
      </section>

      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div className="col-span-1 md:col-span-2">
              <div className="text-2xl font-bold mb-4">🧮 Math4Child</div>
              <p className="text-gray-400 mb-4">L'application qui rend l'apprentissage des mathématiques amusant et efficace pour tous les enfants.</p>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Liens rapides</h3>
              <ul className="space-y-2">
                <li><Link href="/" className="text-gray-400 hover:text-white">Accueil</Link></li>
                <li><Link href="/exercises" className="text-gray-400 hover:text-white">Exercices</Link></li>
                <li><Link href="/subscription" className="text-gray-400 hover:text-white">Abonnement</Link></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Support</h3>
              <ul className="space-y-2">
                <li><span className="text-gray-400">Email: support@math4child.com</span></li>
                <li><span className="text-gray-400">Version: 4.0.0</span></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center">
            <p className="text-gray-400">© 2025 Math4Child. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
