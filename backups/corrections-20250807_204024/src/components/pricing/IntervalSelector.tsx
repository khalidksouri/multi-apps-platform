'use client'
import { IntervalType } from '@/types/paddle'
import { getDiscountPercentage } from '@/lib/paddle/plans'

interface IntervalSelectorProps {
  selectedInterval: IntervalType
  onIntervalChange: (interval: IntervalType) => void
}

export function IntervalSelector({ selectedInterval, onIntervalChange }: IntervalSelectorProps) {
  const intervals: Array<{ key: IntervalType; label: string }> = [
    { key: 'month', label: 'Mensuel' },
    { key: 'quarter', label: 'Trimestriel' },
    { key: 'year', label: 'Annuel' }
  ]

  return (
    <div className="flex justify-center">
      <div className="bg-white/10 backdrop-blur-sm rounded-lg p-1 flex">
        {intervals.map(({ key, label }) => {
          const discount = getDiscountPercentage(key)
          const isSelected = selectedInterval === key
          
          return (
            <button
              key={key}
              onClick={() => onIntervalChange(key)}
              className={`relative px-6 py-3 rounded-md transition-all font-medium ${
                isSelected
                  ? 'bg-blue-600 text-white shadow-lg'
                  : 'text-white/70 hover:text-white hover:bg-white/5'
              }`}
            >
              {label}
              {discount > 0 && (
                <div className="absolute -top-2 -right-2">
                  <span className="bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                    -{discount}%
                  </span>
                </div>
              )}
            </button>
          )
        })}
      </div>
    </div>
  )
}
