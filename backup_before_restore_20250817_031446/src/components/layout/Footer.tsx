import React from 'react'

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-white py-8 px-4 mt-16">
      <div className="max-w-6xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          
          {/* Marque */}
          <div>
            <h3 className="text-xl font-bold text-blue-400 mb-4">
              Math4Child v4.2.0
            </h3>
            <p className="text-gray-300 text-sm mb-2">
              Révolution Éducative Mondiale
            </p>
            <p className="text-gray-400 text-xs">
              6 Innovations Révolutionnaires • 200+ Langues
            </p>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-green-400">Contact</h4>
            <div className="space-y-2 text-sm">
              <div>
                <span className="text-gray-400">Support: </span>
                <a href="mailto:support@math4child.com" className="text-blue-400 hover:text-blue-300">
                  support@math4child.com
                </a>
              </div>
              <div>
                <span className="text-gray-400">Commercial: </span>
                <a href="mailto:commercial@math4child.com" className="text-purple-400 hover:text-purple-300">
                  commercial@math4child.com
                </a>
              </div>
              <div>
                <span className="text-gray-400">Site: </span>
                <span className="text-green-400">www.math4child.com</span>
              </div>
            </div>
          </div>

          {/* Innovations */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-purple-400">Innovations</h4>
            <ul className="text-xs text-gray-300 space-y-1">
              <li>🧠 IA Adaptative Avancée</li>
              <li>✏️ Reconnaissance Manuscrite</li>
              <li>🥽 Réalité Augmentée 3D</li>
              <li>🎙️ Assistant Vocal IA</li>
              <li>🧮 Moteur d&apos;Exercices</li>
              <li>🌍 200+ Langues 🇲🇦🇵🇸</li>
            </ul>
          </div>
        </div>

        <hr className="border-gray-700 my-6" />
        <div className="text-center text-sm text-gray-400">
          © 2025 Math4Child v4.2.0 - Révolution Éducative Mondiale
        </div>
      </div>
    </footer>
  )
}
