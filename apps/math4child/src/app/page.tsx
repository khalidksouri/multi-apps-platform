'use client'

import { useState } from 'react'

export default function HomePage() {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  
  const translations = {
    fr: {
      title: 'Math4Child',
      subtitle: 'Apprendre les mathématiques en s\'amusant !',
      start: 'Commencer',
      description: 'Application éducative pour maîtriser les mathématiques'
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Learn mathematics while having fun!',
      start: 'Start',
      description: 'Educational app to master mathematics'
    }
  }
  
  const t = translations[currentLanguage as keyof typeof translations]
  
  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-8">
      <div className="max-w-4xl mx-auto text-center">
        {/* Header */}
        <div className="mb-8">
          <div className="flex justify-end mb-4">
            <select 
              value={currentLanguage}
              onChange={(e) => setCurrentLanguage(e.target.value)}
              className="px-3 py-1 border rounded-lg"
            >
              <option value="fr">🇫🇷 Français</option>
              <option value="en">🇺🇸 English</option>
            </select>
          </div>
          
          <h1 className="text-6xl font-bold text-blue-600 mb-4">
            {t.title}
          </h1>
          
          <p className="text-xl text-gray-600 mb-8">
            {t.subtitle}
          </p>
        </div>
        
        {/* Logo/Visual */}
        <div className="mb-8">
          <div className="inline-flex items-center justify-center w-32 h-32 bg-blue-100 rounded-full mb-4">
            <span className="text-4xl">🧮</span>
          </div>
        </div>
        
        {/* Features */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white p-6 rounded-lg shadow-lg">
            <div className="text-3xl mb-2">➕</div>
            <h3 className="font-semibold mb-2">Addition</h3>
            <p className="text-sm text-gray-600">Maîtrise l'addition pas à pas</p>
          </div>
          
          <div className="bg-white p-6 rounded-lg shadow-lg">
            <div className="text-3xl mb-2">✖️</div>
            <h3 className="font-semibold mb-2">Multiplication</h3>
            <p className="text-sm text-gray-600">Tables de multiplication ludiques</p>
          </div>
          
          <div className="bg-white p-6 rounded-lg shadow-lg">
            <div className="text-3xl mb-2">🎯</div>
            <h3 className="font-semibold mb-2">Exercices</h3>
            <p className="text-sm text-gray-600">Entraînement personnalisé</p>
          </div>
        </div>
        
        {/* CTA Button */}
        <button className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
          {t.start} 🚀
        </button>
        
        {/* Status */}
        <div className="mt-8 p-4 bg-green-50 border border-green-200 rounded-lg">
          <p className="text-green-800">
            ✅ <strong>Math4Child opérationnel sur le port 3001</strong>
          </p>
          <p className="text-sm text-green-600 mt-1">
            Version 2.0.0 - {new Date().toLocaleDateString('fr-FR')}
          </p>
        </div>
      </div>
    </main>
  )
}
