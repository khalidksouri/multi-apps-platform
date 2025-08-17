import React from 'react'
import ContactInfo from '../components/ui/ContactInfo'

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
          <p className="text-lg md:text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            6 Innovations Révolutionnaires pour transformer l&apos;apprentissage des mathématiques
          </p>
          
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
            
            <div className="bg-blue-50 p-6 rounded-lg border border-blue-200">
              <div className="text-4xl mb-4">🧠</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">IA Adaptative Avancée</h4>
              <p className="text-gray-600 text-sm">Intelligence artificielle qui s&apos;adapte au niveau de chaque enfant</p>
            </div>

            <div className="bg-green-50 p-6 rounded-lg border border-green-200">
              <div className="text-4xl mb-4">✏️</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Reconnaissance Manuscrite</h4>
              <p className="text-gray-600 text-sm">Reconnaissance avancée de l&apos;écriture manuscrite</p>
            </div>

            <div className="bg-purple-50 p-6 rounded-lg border border-purple-200">
              <div className="text-4xl mb-4">🥽</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Réalité Augmentée 3D</h4>
              <p className="text-gray-600 text-sm">Expérience immersive en réalité augmentée</p>
            </div>

            <div className="bg-orange-50 p-6 rounded-lg border border-orange-200">
              <div className="text-4xl mb-4">🎙️</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Assistant Vocal IA</h4>
              <p className="text-gray-600 text-sm">Assistant vocal intelligent pour accompagner l&apos;apprentissage</p>
            </div>

            <div className="bg-red-50 p-6 rounded-lg border border-red-200">
              <div className="text-4xl mb-4">🧮</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Moteur d&apos;Exercices Révolutionnaire</h4>
              <p className="text-gray-600 text-sm">Générateur d&apos;exercices adaptatifs et personnalisés</p>
            </div>

            <div className="bg-indigo-50 p-6 rounded-lg border border-indigo-200">
              <div className="text-4xl mb-4">🌍</div>
              <h4 className="text-xl font-semibold text-gray-800 mb-2">Système Langues Universel</h4>
              <p className="text-gray-600 text-sm">Support de 200+ langues avec drapeaux spécifiques 🇲🇦🇵🇸</p>
            </div>
          </div>
        </div>
      </section>

      {/* Plans Section */}
      <section className="py-16 px-4 bg-gray-50">
        <div className="max-w-4xl mx-auto">
          <h3 className="text-3xl font-bold text-center text-gray-800 mb-12">
            5 Plans d&apos;Abonnement
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div className="bg-white p-4 rounded-lg shadow-sm text-center">
              <h4 className="font-semibold text-gray-800 mb-2">GRATUIT</h4>
              <p className="text-sm text-gray-600">1 semaine, 50 questions</p>
            </div>
            <div className="bg-white p-4 rounded-lg shadow-sm text-center">
              <h4 className="font-semibold text-gray-800 mb-2">BASIC</h4>
              <p className="text-sm text-gray-600">Fonctionnalités essentielles</p>
            </div>
            <div className="bg-white p-4 rounded-lg shadow-sm text-center">
              <h4 className="font-semibold text-gray-800 mb-2">STANDARD</h4>
              <p className="text-sm text-gray-600">Plus d&apos;exercices</p>
            </div>
            <div className="bg-gradient-to-br from-purple-100 to-blue-100 p-4 rounded-lg shadow-md text-center border-2 border-purple-300">
              <div className="bg-yellow-400 text-yellow-900 text-xs font-bold px-2 py-1 rounded mb-2">LE PLUS CHOISI</div>
              <h4 className="font-bold text-purple-800 mb-2">PREMIUM</h4>
              <p className="text-sm text-purple-700">Toutes les innovations</p>
            </div>
            <div className="bg-white p-4 rounded-lg shadow-sm text-center">
              <h4 className="font-semibold text-gray-800 mb-2">ULTIMATE</h4>
              <p className="text-sm text-gray-600">Institutions</p>
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
    </div>
  )
}
