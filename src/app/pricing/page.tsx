"use client"

import Navigation from "@/components/navigation/Navigation"
import { useLanguage } from "@/hooks/useLanguage"
import { BillingOptions } from "@/components/pricing/BillingOptions"
import { pricingPlans } from "@/data/pricing"
import { useState } from "react"

export default function PricingPage() {
  const { isRTL } = useLanguage()
  const [billingCycle, setBillingCycle] = useState<'monthly' | 'quarterly' | 'yearly'>('monthly')
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            💎 Nos Plans d'Abonnement
          </h1>
          <p className="text-xl text-gray-600">
            Choisissez le plan qui convient le mieux à votre famille
          </p>
        </div>
        
        <BillingOptions onBillingChange={setBillingCycle} />
        
        <div id="pricing-section" className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {pricingPlans.map((plan) => (
            <div
              key={plan.id}
              data-plan={plan.id}
              className={`relative bg-white rounded-xl shadow-lg p-8 ${
                plan.popular ? 'ring-2 ring-blue-500 transform scale-105' : ''
              }`}
            >
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                    Le plus populaire
                  </span>
                </div>
              )}
              
              <div className="text-center">
                <h3 className="text-2xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                
                <div className="mb-6">
                  <div className="text-4xl font-bold text-blue-600 mb-2">
                    {plan.price[billingCycle]}
                  </div>
                  
                  {plan.originalPrice?.[billingCycle] && (
                    <div className="text-sm text-gray-500">
                      <span className="line-through">{plan.originalPrice[billingCycle]}</span>
                      <span className="ml-2 text-green-600 font-semibold">
                        -{plan.discount?.[billingCycle]}
                      </span>
                    </div>
                  )}
                </div>
                
                <div className="text-lg font-semibold text-gray-700 mb-6">
                  {plan.profiles} profils
                </div>
                
                <ul className="text-left space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start space-x-3">
                      <span className="text-green-500 mt-1">✓</span>
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
                
                <button className={`w-full py-3 px-6 rounded-lg font-semibold transition-colors ${
                  plan.popular
                    ? 'bg-blue-600 text-white hover:bg-blue-700'
                    : 'bg-gray-100 text-gray-800 hover:bg-gray-200'
                }`}>
                  {plan.id === 'free' ? 'Commencer gratuitement' : 'Choisir ce plan'}
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
