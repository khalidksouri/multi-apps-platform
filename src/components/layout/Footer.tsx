import React from 'react'
import Link from 'next/link'

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-white py-12 px-4">
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-5 gap-8">
          
          {/* Marque et description */}
          <div className="md:col-span-1">
            <h3 className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent mb-4">
              Math4Child v4.2.0
            </h3>
            <p className="text-gray-300 text-sm mb-4">
              Révolution Éducative Mondiale
            </p>
            <p className="text-gray-400 text-xs">
              6 Innovations Révolutionnaires • 200+ Langues • IA Adaptative
            </p>
          </div>

          {/* Navigation */}
          <div className="md:col-span-1">
            <h4 className="text-lg font-semibold mb-4 text-blue-300">Navigation</h4>
            <ul className="space-y-2 text-sm">
              <li><Link href="/" className="text-gray-300 hover:text-white transition-colors">Accueil</Link></li>
              <li><Link href="/exercises" className="text-gray-300 hover:text-white transition-colors">Exercices</Link></li>
              <li><Link href="/pricing" className="text-gray-300 hover:text-white transition-colors">Tarification</Link></li>
              <li><Link href="/profile" className="text-gray-300 hover:text-white transition-colors">Profil</Link></li>
              <li><Link href="/dashboard" className="text-gray-300 hover:text-white transition-colors">Dashboard</Link></li>
            </ul>
          </div>

          {/* Contact et Support */}
          <div className="md:col-span-1">
            <h4 className="text-lg font-semibold mb-4 text-green-300">Support & Contact</h4>
            <div className="space-y-3">
              <div>
                <p className="text-sm text-gray-400 mb-1">Support Technique</p>
                <a 
                  href="mailto:support@math4child.com" 
                  className="text-blue-400 hover:text-blue-300 transition-colors text-sm font-medium"
                >
                  support@math4child.com
                </a>
              </div>
              <div>
                <p className="text-sm text-gray-400 mb-1">Équipe Commerciale</p>
                <a 
                  href="mailto:commercial@math4child.com" 
                  className="text-purple-400 hover:text-purple-300 transition-colors text-sm font-medium"
                >
                  commercial@math4child.com
                </a>
              </div>
              <div>
                <p className="text-sm text-gray-400 mb-1">Site Web</p>
                <a 
                  href="https://www.math4child.com" 
                  className="text-green-400 hover:text-green-300 transition-colors text-sm font-medium"
                >
                  www.math4child.com
                </a>
              </div>
            </div>
          </div>

          {/* Innovations */}
          <div className="md:col-span-1">
            <h4 className="text-lg font-semibold mb-4 text-purple-300">6 Innovations Révolutionnaires</h4>
            <ul className="space-y-2 text-sm text-gray-300">
              <li className="flex items-center">
                <span className="text-blue-400 mr-2">🧠</span>
                IA Adaptative Avancée
              </li>
              <li className="flex items-center">
                <span className="text-green-400 mr-2">✏️</span>
                Reconnaissance Manuscrite
              </li>
              <li className="flex items-center">
                <span className="text-purple-400 mr-2">🥽</span>
                Réalité Augmentée 3D
              </li>
              <li className="flex items-center">
                <span className="text-orange-400 mr-2">🎙️</span>
                Assistant Vocal IA
              </li>
              <li className="flex items-center">
                <span className="text-red-400 mr-2">🧮</span>
                Moteur d&apos;Exercices
              </li>
              <li className="flex items-center">
                <span className="text-indigo-400 mr-2">🌍</span>
                200+ Langues 🇲🇦🇵🇸
              </li>
            </ul>
          </div>

          {/* Plans et Support */}
          <div className="md:col-span-1">
            <h4 className="text-lg font-semibold mb-4 text-yellow-300">Plans d&apos;Abonnement</h4>
            <ul className="space-y-2 text-sm text-gray-300">
              <li>📦 GRATUIT - 1 semaine, 50 questions</li>
              <li>🔹 BASIC - Fonctionnalités essentielles</li>
              <li>⭐ STANDARD - Plus d&apos;exercices</li>
              <li className="bg-gradient-to-r from-purple-600/20 to-blue-600/20 p-2 rounded-lg border border-purple-400/30">
                <span className="text-yellow-400 font-bold">👑 PREMIUM - LE PLUS CHOISI</span>
              </li>
              <li>🏢 ULTIMATE - Institutions</li>
            </ul>
          </div>
        </div>

        {/* Ligne de séparation */}
        <hr className="border-gray-700 my-8" />

        {/* Copyright et liens légaux */}
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="text-sm text-gray-400 mb-4 md:mb-0">
            © 2025 Math4Child v4.2.0 - Révolution Éducative Mondiale
          </div>
          <div className="flex space-x-6 text-sm">
            <Link href="/privacy" className="text-gray-400 hover:text-white transition-colors">
              Confidentialité
            </Link>
            <Link href="/terms" className="text-gray-400 hover:text-white transition-colors">
              Conditions d&apos;utilisation
            </Link>
            <Link href="/pricing" className="text-gray-400 hover:text-white transition-colors">
              Tarification
            </Link>
            <Link href="/exercises" className="text-gray-400 hover:text-white transition-colors">
              Exercices
            </Link>
          </div>
        </div>

        {/* Badges de conformité et certifications */}
        <div className="mt-6 pt-6 border-t border-gray-700">
          <div className="flex flex-wrap justify-center items-center gap-4 text-xs text-gray-500">
            <span className="bg-green-900/30 text-green-400 px-3 py-1 rounded-full border border-green-600/30">
              ✅ 100% Sécurisé
            </span>
            <span className="bg-blue-900/30 text-blue-400 px-3 py-1 rounded-full border border-blue-600/30">
              🌍 200+ Langues
            </span>
            <span className="bg-purple-900/30 text-purple-400 px-3 py-1 rounded-full border border-purple-600/30">
              🧠 IA Adaptative
            </span>
            <span className="bg-orange-900/30 text-orange-400 px-3 py-1 rounded-full border border-orange-600/30">
              📱 Applications Hybrides
            </span>
            <span className="bg-red-900/30 text-red-400 px-3 py-1 rounded-full border border-red-600/30">
              ⚡ Performance Optimisée
            </span>
            <span className="bg-indigo-900/30 text-indigo-400 px-3 py-1 rounded-full border border-indigo-600/30">
              🏆 Production Ready
            </span>
          </div>
        </div>
      </div>
    </footer>
  )
}
