"use client"
import { useState } from 'react'

export function StartFreeButton() {
  const [showModal, setShowModal] = useState(false)
  
  return (
    <>
      <button 
        onClick={() => setShowModal(true)}
        className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white px-8 py-4 rounded-xl font-semibold transition-all duration-300 transform hover:scale-105 shadow-lg"
      >
        🎯 Commencer gratuitement →
      </button>
      
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl max-w-md mx-4 shadow-2xl">
            <div className="text-center">
              <div className="text-4xl mb-4">🚀</div>
              <h3 className="text-xl font-bold mb-4">Démarrage de la version gratuite !</h3>
              <div className="bg-blue-50 p-4 rounded-lg mb-4">
                <p className="text-blue-800 mb-2">✨ Démarrage de la version gratuite !</p>
                <p className="text-sm text-gray-600">Vous avez accès au 1er niveau (50 questions) pendant 7 jours.</p>
              </div>
              <button 
                onClick={() => setShowModal(false)}
                className="bg-cyan-500 hover:bg-cyan-600 text-white px-6 py-2 rounded-lg transition-colors"
              >
                OK
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}

export function ViewPlansButton() {
  const handleClick = () => {
    const pricingSection = document.getElementById('pricing-section')
    if (pricingSection) {
      pricingSection.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  }
  
  return (
    <button 
      onClick={handleClick}
      className="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-8 py-4 rounded-xl font-semibold transition-all duration-300 transform hover:scale-105 border border-white border-opacity-20 shadow-lg"
    >
      💎 Voir les plans
    </button>
  )
}
