import React from 'react'

export default function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 to-purple-700 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-white text-6xl font-bold mb-4">404</h1>
        <h2 className="text-white text-2xl mb-4">Page non trouvée</h2>
        <p className="text-blue-100 mb-8">La page que vous cherchez n'existe pas.</p>
        <a 
          href="/"
          className="bg-white text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-colors"
        >
          Retour à l'accueil
        </a>
      </div>
    </div>
  )
}
