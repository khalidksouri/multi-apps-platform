import React from 'react'
import Link from 'next/link'
import ContactInfo from '@/components/ui/ContactInfo'

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Hero Section */}
      <section className="py-20 px-4">
        <div className="max-w-6xl mx-auto text-center">
          <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
            Math4Child v4.2.0
          </h1>
          <h2 className="text-2xl md:text-4xl font-semibold text-gray-800 mb-6">
            Révolution Éducative Mondiale
          </h2>
          <p className="text-lg md:text-xl text-gray-600 mb-8 max-w-4xl mx-auto">
            6 Innovations Révolutionnaires pour transformer l&apos;apprentissage des mathématiques avec l&apos;IA Adaptative, 
            la Reconnaissance Manuscrite, la Réalité Augmentée 3D et bien plus encore !
          </p>
          
          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
            <Link 
              href="/exercises" 
              className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-xl font-semibold text-lg hover:shadow-lg transform hover:scale-105 transition-all duration-300"
            >
              🚀 Commencer l&apos;Aventure
            </Link>
            <Link 
              href="/pricing" 
              className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg border-2 border-blue-600 hover:bg-blue-50 transition-all duration-300"
            >
              💎 Voir les Plans
            </Link>
          </div>
          
          {/* Badges */}
          <div className="flex flex-wrap justify-center gap-4 mb-12">
            <span className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium">
              🧠 IA Adaptative Avancée
            </span>
            <span className="bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
              200+ Langues 🇲🇦🇵🇸
            </span>
            <span className="bg-purple-100 text-purple-800 px-4 py-2 rounded-full text-sm font-medium">
              🥽 Réalité Augmentée 3D
            </span>
            <span className="bg-orange-100 text-orange-800 px-4 py-2 rounded-full text-sm font-medium">
              ✏️ Reconnaissance Manuscrite
            </span>
          </div>
        </div>
      </section>

      {/* Innovations Section */}
      <section className="py-16 px-4 bg-white">
        <div className="max-w-6xl mx-auto">
          <h3 className="text-3xl font-bold text-center text-gray-800 mb-12">
            6 Innovations Révolutionnaires
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 p-6 rounded-xl border border-blue-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">🧠</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">IA Adaptative Avancée</h4>
              <p className="text-gray-600 text-sm">Intelligence artificielle révolutionnaire qui s&apos;adapte en temps réel au niveau et au style d&apos;apprentissage de chaque enfant</p>
            </div>

            <div className="bg-gradient-to-br from-green-50 to-green-100 p-6 rounded-xl border border-green-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">✏️</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Reconnaissance Manuscrite</h4>
              <p className="text-gray-600 text-sm">Technologie avancée de reconnaissance de l&apos;écriture manuscrite pour une expérience d&apos;apprentissage naturelle</p>
            </div>

            <div className="bg-gradient-to-br from-purple-50 to-purple-100 p-6 rounded-xl border border-purple-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">🥽</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Réalité Augmentée 3D</h4>
              <p className="text-gray-600 text-sm">Expérience immersive en réalité augmentée pour visualiser les concepts mathématiques en 3D</p>
            </div>

            <div className="bg-gradient-to-br from-orange-50 to-orange-100 p-6 rounded-xl border border-orange-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">🎙️</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Assistant Vocal IA</h4>
              <p className="text-gray-600 text-sm">Assistant vocal intelligent avec personnalités multiples pour accompagner et encourager l&apos;apprentissage</p>
            </div>

            <div className="bg-gradient-to-br from-red-50 to-red-100 p-6 rounded-xl border border-red-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">🧮</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Moteur d&apos;Exercices Révolutionnaire</h4>
              <p className="text-gray-600 text-sm">Générateur d&apos;exercices adaptatifs et personnalisés avec progression intelligente</p>
            </div>

            <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 p-6 rounded-xl border border-indigo-200 hover:shadow-lg transition-all">
              <div className="text-4xl mb-4">🌍</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Système Langues Universel</h4>
              <p className="text-gray-600 text-sm">Support de 200+ langues avec traduction en temps réel et drapeaux spécifiques 🇲🇦🇵🇸</p>
            </div>
          </div>
        </div>
      </section>

      {/* Plans Section */}
      <section className="py-16 px-4 bg-gray-50">
        <div className="max-w-6xl mx-auto">
          <h3 className="text-3xl font-bold text-center text-gray-800 mb-12">
            5 Plans d&apos;Abonnement pour Tous
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div className="bg-white p-6 rounded-xl shadow-sm text-center border border-gray-200">
              <h4 className="font-bold text-gray-800 mb-2">GRATUIT</h4>
              <p className="text-2xl font-bold text-gray-600 mb-2">0€</p>
              <p className="text-sm text-gray-600 mb-4">1 semaine, 50 questions</p>
              <button className="w-full bg-gray-200 text-gray-800 py-2 rounded-lg">Essayer</button>
            </div>
            
            <div className="bg-white p-6 rounded-xl shadow-sm text-center border border-gray-200">
              <h4 className="font-bold text-gray-800 mb-2">BASIC</h4>
              <p className="text-2xl font-bold text-blue-600 mb-2">9.99€</p>
              <p className="text-sm text-gray-600 mb-4">Fonctionnalités essentielles</p>
              <button className="w-full bg-blue-600 text-white py-2 rounded-lg">Choisir</button>
            </div>
            
            <div className="bg-white p-6 rounded-xl shadow-sm text-center border border-gray-200">
              <h4 className="font-bold text-gray-800 mb-2">STANDARD</h4>
              <p className="text-2xl font-bold text-green-600 mb-2">19.99€</p>
              <p className="text-sm text-gray-600 mb-4">Plus d&apos;exercices</p>
              <button className="w-full bg-green-600 text-white py-2 rounded-lg">Choisir</button>
            </div>
            
            <div className="bg-gradient-to-br from-purple-500 to-blue-600 p-6 rounded-xl shadow-lg text-center border-2 border-yellow-400 relative transform scale-105">
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-yellow-400 text-yellow-900 px-4 py-1 rounded-full text-xs font-bold">
                LE PLUS CHOISI
              </div>
              <h4 className="font-bold text-white mb-2">PREMIUM</h4>
              <p className="text-2xl font-bold text-white mb-2">29.99€</p>
              <p className="text-sm text-purple-100 mb-4">Toutes les innovations</p>
              <button className="w-full bg-white text-purple-600 py-2 rounded-lg font-bold">Choisir</button>
            </div>
            
            <div className="bg-white p-6 rounded-xl shadow-sm text-center border border-gray-200">
              <h4 className="font-bold text-gray-800 mb-2">ULTIMATE</h4>
              <p className="text-2xl font-bold text-gray-600 mb-2">Sur devis</p>
              <p className="text-sm text-gray-600 mb-4">Institutions</p>
              <button className="w-full bg-gray-800 text-white py-2 rounded-lg">Contact</button>
            </div>
          </div>
        </div>
      </section>

      {/* Contact Section */}
      <section className="py-16 px-4">
        <div className="max-w-4xl mx-auto">
          <ContactInfo />
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 px-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white">
        <div className="max-w-6xl mx-auto">
          <h3 className="text-3xl font-bold text-center mb-12">
            Une Révolution Éducative en Chiffres
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="text-4xl font-bold mb-2">200+</div>
              <div className="text-lg">Langues Supportées</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2">6</div>
              <div className="text-lg">Innovations Révolutionnaires</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2">5</div>
              <div className="text-lg">Niveaux de Progression</div>
            </div>
            <div>
              <div className="text-4xl font-bold mb-2">3</div>
              <div className="text-lg">Modes d&apos;Exercices</div>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}
