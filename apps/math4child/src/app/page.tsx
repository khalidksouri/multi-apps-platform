'use client'
import React, { useState } from 'react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import LanguageSelector from '@/components/language/LanguageSelector'
import PricingModal from '@/components/pricing/PricingModal'

export default function HomePage() {
  const { t } = useLanguage()
  const [isPricingOpen, setIsPricingOpen] = useState(false)

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="flex justify-center mb-4">
          <LanguageSelector />
        </div>
        <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-4">
          Math4Child
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Révolution éducative mondiale - Apprentissage mathématique avec IA
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link
            href="/exercises"
            className="bg-blue-600 text-white px-8 py-3 rounded-lg text-lg font-semibold hover:bg-blue-700 transition-colors"
          >
            🚀 Commencer les exercices
          </Link>
          <button
            onClick={() => setIsPricingOpen(true)}
            className="bg-green-600 text-white px-8 py-3 rounded-lg text-lg font-semibold hover:bg-green-700 transition-colors"
          >
            💎 Voir les tarifs
          </button>
        </div>
      </div>

      {/* Innovations */}
      <div className="grid md:grid-cols-3 gap-8 mb-12">
        <div className="bg-white rounded-lg p-6 shadow-lg">
          <div className="text-3xl mb-4">✍️</div>
          <h3 className="text-xl font-semibold mb-2">Reconnaissance Manuscrite</h3>
          <p className="text-gray-600">IA avancée pour reconnaître l'écriture manuscrite des enfants</p>
          <Link href="/handwriting" className="inline-block mt-4 text-blue-600 hover:text-blue-800">
            Tester →
          </Link>
        </div>

        <div className="bg-white rounded-lg p-6 shadow-lg">
          <div className="text-3xl mb-4">🎙️</div>
          <h3 className="text-xl font-semibold mb-2">Assistant Vocal IA</h3>
          <p className="text-gray-600">3 personnalités d'IA pour guider l'apprentissage</p>
          <Link href="/voice" className="inline-block mt-4 text-blue-600 hover:text-blue-800">
            Essayer →
          </Link>
        </div>

        <div className="bg-white rounded-lg p-6 shadow-lg">
          <div className="text-3xl mb-4">🥽</div>
          <h3 className="text-xl font-semibold mb-2">Réalité Augmentée 3D</h3>
          <p className="text-gray-600">Visualisation immersive des concepts mathématiques</p>
          <Link href="/ar3d" className="inline-block mt-4 text-blue-600 hover:text-blue-800">
            Découvrir →
          </Link>
        </div>
      </div>

      {/* Stats */}
      <div className="bg-blue-600 text-white rounded-lg p-8 text-center">
        <h2 className="text-2xl font-bold mb-4">Math4Child en chiffres</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div>
            <div className="text-3xl font-bold">200+</div>
            <div className="text-blue-200">Langues supportées</div>
          </div>
          <div>
            <div className="text-3xl font-bold">6</div>
            <div className="text-blue-200">Innovations révolutionnaires</div>
          </div>
          <div>
            <div className="text-3xl font-bold">5</div>
            <div className="text-blue-200">Niveaux de progression</div>
          </div>
          <div>
            <div className="text-3xl font-bold">∞</div>
            <div className="text-blue-200">Exercices adaptatifs</div>
          </div>
        </div>
      </div>

      {/* Modal de tarification */}
      <PricingModal
        isOpen={isPricingOpen}
        onClose={() => setIsPricingOpen(false)}
      />
    </div>
  )
}
