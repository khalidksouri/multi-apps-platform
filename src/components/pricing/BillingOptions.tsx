"use client"

import { useState } from 'react'

export interface BillingOption {
  id: string
  name: string
  period: string
  discount?: number
}

interface BillingOptionsProps {
  onBillingChange?: (option: BillingOption) => void
  currentBilling?: string
}

export function BillingOptions({ onBillingChange, currentBilling = 'monthly' }: BillingOptionsProps) {
  const [selectedBilling, setSelectedBilling] = useState(currentBilling)

  const billingOptions: BillingOption[] = [
    {
      id: 'monthly',
      name: 'Mensuel',
      period: 'mois'
    },
    {
      id: 'quarterly',
      name: 'Trimestriel',
      period: '3 mois',
      discount: 10
    },
    {
      id: 'yearly',
      name: 'Annuel',
      period: 'an',
      discount: 20
    }
  ]

  const handleBillingChange = (option: BillingOption) => {
    setSelectedBilling(option.id)
    onBillingChange?.(option)
  }

  return (
    <div className="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
      <h3 className="text-xl font-bold text-gray-800 mb-4 text-center">
        🔄 Options de Facturation
      </h3>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
        {billingOptions.map((option) => (
          <button
            key={option.id}
            onClick={() => handleBillingChange(option)}
            className={`p-4 rounded-lg border-2 transition-all duration-200 relative ${
              selectedBilling === option.id
                ? 'border-blue-500 bg-blue-50 shadow-md'
                : 'border-gray-200 bg-gray-50 hover:border-gray-300'
            }`}
          >
            {option.discount && (
              <div className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full font-bold">
                -{option.discount}%
              </div>
            )}
            
            <div className="text-center">
              <div className={`font-semibold ${
                selectedBilling === option.id ? 'text-blue-700' : 'text-gray-700'
              }`}>
                {option.name}
              </div>
              <div className={`text-sm ${
                selectedBilling === option.id ? 'text-blue-600' : 'text-gray-500'
              }`}>
                par {option.period}
              </div>
              {option.discount && (
                <div className="text-xs text-green-600 font-medium mt-1">
                  Économisez {option.discount}%
                </div>
              )}
            </div>
          </button>
        ))}
      </div>

      <div className="mt-4 text-center">
        <p className="text-sm text-gray-600">
          💡 Plus d'engagement = Plus d'économies !
        </p>
      </div>
    </div>
  )
}
