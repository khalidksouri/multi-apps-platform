"use client"

import { useState } from "react"
import { X, Check, Star, Shield } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"

interface PricingModalProps {
  onClose: () => void
}

export default function PricingModal({ onClose }: PricingModalProps) {
  const [selectedPlan, setSelectedPlan] = useState("family")
  const { t } = useLanguage()

  const plans = [
    {
      id: "free",
      name: "Gratuit",
      price: "0€",
      period: "/semaine",
      features: [
        "1 profil enfant",
        "50 questions/jour",
        "Niveaux 1-2",
        "Support communautaire"
      ]
    },
    {
      id: "family",
      name: "Famille",
      price: "9.99€",
      period: "/mois",
      popular: true,
      features: [
        "5 profils enfants",
        "Questions illimitées",
        "Tous les 5 niveaux",
        "Suivi parental complet",
        "Support prioritaire"
      ]
    },
    {
      id: "premium",
      name: "Premium",
      price: "19.99€", 
      period: "/mois",
      bestValue: true,
      features: [
        "10 profils enfants",
        "IA coaching avancée",
        "Rapports détaillés",
        "Mode hors-ligne",
        "Support téléphonique"
      ]
    }
  ]

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center p-6 border-b">
          <h2 className="text-3xl font-bold">Plans Math4Child</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="p-6">
          <div className="grid md:grid-cols-3 gap-6">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className={`relative border-2 rounded-xl p-6 cursor-pointer transition-all ${
                  selectedPlan === plan.id
                    ? "border-blue-500 bg-blue-50"
                    : "border-gray-200 hover:border-gray-300"
                } ${plan.popular ? "ring-2 ring-blue-500" : ""}`}
                onClick={() => setSelectedPlan(plan.id)}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      Le plus populaire
                    </span>
                  </div>
                )}
                
                {plan.bestValue && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-green-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      Meilleure valeur
                    </span>
                  </div>
                )}

                <div className="text-center mb-6">
                  <h3 className="text-xl font-bold mb-2">{plan.name}</h3>
                  <div className="text-4xl font-black text-blue-600 mb-1">
                    {plan.price}
                  </div>
                  <div className="text-gray-500">{plan.period}</div>
                </div>

                <ul className="space-y-3 mb-6">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center gap-3">
                      <Check className="w-5 h-5 text-green-500 flex-shrink-0" />
                      <span className="text-gray-700">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  className={`w-full py-3 px-6 rounded-xl font-semibold transition-all ${
                    selectedPlan === plan.id
                      ? "bg-blue-600 text-white hover:bg-blue-700"
                      : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                  }`}
                >
                  {selectedPlan === plan.id ? "Sélectionné" : "Choisir ce plan"}
                </button>
              </div>
            ))}
          </div>

          <div className="mt-8 text-center">
            <div className="flex justify-center items-center gap-6 text-sm text-gray-600 mb-4">
              <div className="flex items-center gap-2">
                <Shield className="w-4 h-4 text-green-600" />
                <span>Garantie 30 jours</span>
              </div>
              <div className="flex items-center gap-2">
                <Star className="w-4 h-4 text-yellow-600" />
                <span>4.9/5 étoiles</span>
              </div>
            </div>
            
            <button className="bg-blue-600 text-white px-8 py-3 rounded-xl font-semibold hover:bg-blue-700 transition-colors">
              Continuer avec {plans.find(p => p.id === selectedPlan)?.name}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
