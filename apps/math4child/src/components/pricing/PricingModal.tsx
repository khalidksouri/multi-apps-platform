'use client'
import React, { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'

interface PricingModalProps {
  isOpen: boolean
  onClose: () => void
}

const PricingModal: React.FC<PricingModalProps> = ({ isOpen, onClose }) => {
  const { t } = useLanguage()

  if (!isOpen) return null

  const plans = [
    {
      name: 'Basic',
      price: '4.99€',
      features: ['5 exercices/jour', 'Mode manuscrit', 'Support email']
    },
    {
      name: 'Premium',
      price: '14.99€',
      features: ['Exercices illimités', 'Tous les modes', 'IA adaptative', 'Support prioritaire']
    }
  ]

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold">Choisissez votre plan</h2>
            <button
              onClick={onClose}
              className="text-gray-500 hover:text-gray-700 text-2xl"
            >
              ×
            </button>
          </div>
          
          <div className="grid md:grid-cols-2 gap-6">
            {plans.map((plan) => (
              <div key={plan.name} className="border rounded-lg p-6 hover:shadow-lg transition-shadow">
                <h3 className="text-xl font-semibold mb-2">{plan.name}</h3>
                <p className="text-3xl font-bold text-blue-600 mb-4">{plan.price}</p>
                <ul className="space-y-2 mb-6">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center gap-2">
                      <span className="text-green-500">✓</span>
                      {feature}
                    </li>
                  ))}
                </ul>
                <button className="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors">
                  Choisir ce plan
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

export default PricingModal
