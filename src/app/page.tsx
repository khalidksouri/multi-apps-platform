"use client"

import { useState } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { UniversalLanguageSelector } from '@/components/language/UniversalLanguageSelector'

export default function HomePage() {
  const { t, isRTL } = useLanguage()
  const [showFeatures, setShowFeatures] = useState(false)

  const innovations = [
    {
      icon: '🧠',
      title: t('ai_adaptive'),
      description: 'IA qui s\'adapte en temps réel au niveau de l\'enfant',
      tag: t('global_first')
    },
    {
      icon: '✍️',
      title: t('handwriting_recognition'),
      description: 'Reconnaissance des écritures mathématiques manuscrites',
      tag: t('global_first')
    },
    {
      icon: '🥽',
      title: t('augmented_reality'),
      description: 'Visualisation 3D des concepts mathématiques',
      tag: t('global_first')
    },
    {
      icon: '🎙️',
      title: t('voice_assistant'),
      description: 'Assistant vocal avec intelligence émotionnelle',
      tag: t('global_first')
    },
    {
      icon: '🧮',
      title: t('exercise_engine'),
      description: 'Générateur intelligent d\'exercices adaptatifs',
      tag: t('global_first')
    },
    {
      icon: '🌍',
      title: t('universal_languages_system'),
      description: 'Support de 200+ langues avec traduction temps réel',
      tag: t('global_first')
    }
  ]

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-500 via-purple-600 to-pink-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header avec sélecteur de langues */}
      <header className="relative p-6">
        <div className="flex justify-between items-center max-w-7xl mx-auto">
          <div className="flex items-center gap-4">
            <div className="text-4xl">🧮</div>
            <div>
              <h1 className="text-2xl font-bold text-white">Math4Child v4.2.0</h1>
              <p className="text-white/80 text-sm">Révolution Éducative Mondiale</p>
            </div>
          </div>
          
          <UniversalLanguageSelector />
        </div>
      </header>

      {/* Hero Section */}
      <main className="px-6 py-12">
        <div className="max-w-7xl mx-auto text-center text-white">
          <h1 className="text-5xl md:text-7xl font-bold mb-6 leading-tight">
            {t('app_title')}
          </h1>
          
          <p className="text-xl md:text-2xl mb-8 text-white/90 max-w-4xl mx-auto">
            {t('app_subtitle')}
          </p>

          {/* Statistiques selon README.md */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto mb-12">
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
              <div className="text-3xl font-bold text-yellow-300">200+</div>
              <div className="text-white/80 text-sm">{t('universal_languages')}</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
              <div className="text-3xl font-bold text-green-300">6</div>
              <div className="text-white/80 text-sm">Innovations {t('global_first')}</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
              <div className="text-3xl font-bold text-blue-300">5</div>
              <div className="text-white/80 text-sm">{t('levels_available')}</div>
            </div>
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
              <div className="text-3xl font-bold text-purple-300">500</div>
              <div className="text-white/80 text-sm">{t('questions_total')}</div>
            </div>
          </div>

          {/* Boutons d'action */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <Link 
              href="/exercises"
              className="bg-white text-purple-600 px-8 py-4 rounded-xl font-bold text-xl hover:bg-gray-100 transition-all transform hover:scale-105 inline-flex items-center gap-2"
            >
              🚀 {t('start_learning')}
            </Link>
            <Link 
              href="/pricing"
              className="bg-transparent border-2 border-white text-white px-8 py-4 rounded-xl font-bold text-xl hover:bg-white hover:text-purple-600 transition-all"
            >
              💎 {t('view_plans')}
            </Link>
          </div>

          {/* Section des 6 innovations révolutionnaires */}
          <div className="mb-16">
            <h2 className="text-4xl font-bold mb-8 text-center">
              🏆 6 Innovations Révolutionnaires
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {innovations.map((innovation, index) => (
                <div 
                  key={index}
                  className="bg-white/15 backdrop-blur-sm rounded-xl p-6 hover:bg-white/25 transition-all duration-300 transform hover:scale-105"
                >
                  <div className="text-center">
                    <div className="text-5xl mb-4">{innovation.icon}</div>
                    <div className="inline-block bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-xs font-bold mb-3">
                      {innovation.tag}
                    </div>
                    <h3 className="text-xl font-bold text-white mb-3">
                      {innovation.title}
                    </h3>
                    <p className="text-white/80 text-sm">
                      {innovation.description}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Section spécifications primordiales selon README.md */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 mb-16">
            <h2 className="text-3xl font-bold text-center text-white mb-8">
              📋 Spécifications Primordiales
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 text-left">
              <div className="space-y-3">
                <h3 className="font-bold text-white">🎨 Design & Interface</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ Design interactif attrayant</li>
                  <li>✅ Interface révolutionnaire</li>
                  <li>✅ Version riche complète</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-bold text-white">🌍 Langues Universelles</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ 200+ langues supportées</li>
                  <li>✅ Traduction temps réel</li>
                  <li>✅ Support RTL (🇲🇦🇵🇸)</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-bold text-white">🎮 Progression</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ 5 niveaux structurés</li>
                  <li>✅ 100 réponses/niveau min</li>
                  <li>✅ 5 opérations mathématiques</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-bold text-white">💳 Abonnements</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ Version gratuite 1 semaine</li>
                  <li>✅ Plans compétitifs</li>
                  <li>✅ Multi-plateformes</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-bold text-white">🌐 Déploiement</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ Web + Android + iOS</li>
                  <li>✅ www.math4child.com</li>
                  <li>✅ Déploiements parallèles</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-bold text-white">🧪 Qualité</h3>
                <ul className="text-white/80 text-sm space-y-1">
                  <li>✅ Tests complets Playwright</li>
                  <li>✅ Tests traduction</li>
                  <li>✅ Tests performance</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </main>

      {/* Footer NETTOYÉ - Seul Math4Child visible */}
      <footer className="bg-black/20 backdrop-blur-sm py-8 mt-16">
        <div className="max-w-7xl mx-auto px-6 text-center text-white/80">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="text-2xl">🧮</div>
            <span className="text-xl font-bold text-white">Math4Child v4.2.0</span>
          </div>
          <p className="mb-2">Révolution Éducative Mondiale</p>
          <div className="space-y-1">
            <p className="text-sm">
              📧 <strong>Support :</strong> support@math4child.com
            </p>
            <p className="text-sm">
              💼 <strong>Commercial :</strong> commercial@math4child.com
            </p>
            <p className="text-sm">
              🌐 <strong>Site web :</strong> www.math4child.com
            </p>
          </div>
          <div className="mt-4 text-xs">
            © 2024 Math4Child. Tous droits réservés. 
            Cette version contient des innovations jamais vues dans l'éducation mondiale.
          </div>
        </div>
      </footer>
    </div>
  )
}
