"use client"
import { useState } from 'react'

interface BillingOptionsProps {
  onBillingChange: (cycle: 'monthly' | 'quarterly' | 'yearly') => void
}

export function BillingOptions({ onBillingChange }: BillingOptionsProps) {
  const [selected, setSelected] = useState<'monthly' | 'quarterly' | 'yearly'>('monthly')
  
  const options = [
    { 
      id: 'monthly' as const, 
      label: 'Mensuel', 
      description: 'Flexibilité maximale' 
    },
    { 
      id: 'quarterly' as const, 
      label: 'Trimestriel', 
      description: 'Économisez 10%', 
      discount: '10%',
      badge: 'Populaire'
    },
    { 
      id: 'yearly' as const, 
      label: 'Annuel', 
      description: 'Économisez 30%', 
      discount: '30%',
      badge: 'Meilleure offre'
    }
  ]
  
  const handleChange = (cycle: 'monthly' | 'quarterly' | 'yearly') => {
    setSelected(cycle)
    onBillingChange(cycle)
  }
  
  return (
    <div className="flex justify-center mb-8">
      <div className="bg-gray-100 p-2 rounded-xl flex flex-wrap gap-2">
        {options.map(option => (
          <button
            key={option.id}
            onClick={() => handleChange(option.id)}
            className={`relative px-6 py-3 rounded-lg font-semibold transition-all ${
              selected === option.id 
                ? 'bg-blue-600 text-white shadow-lg transform scale-105' 
                : 'text-gray-600 hover:text-blue-600 hover:bg-white'
            }`}
          >
            <div className="text-center">
              <div className="font-bold">{option.label}</div>
              <div className="text-xs opacity-80">{option.description}</div>
            </div>
            {option.discount && (
              <span className="absolute -top-2 -right-2 text-xs bg-green-500 text-white px-2 py-1 rounded-full">
                -{option.discount}
              </span>
            )}
            {option.badge && selected === option.id && (
              <span className="absolute -top-2 -left-2 text-xs bg-orange-500 text-white px-2 py-1 rounded-full">
                {option.badge}
              </span>
            )}
          </button>
        ))}
      </div>
    </div>
  )
}
