"use client"

import { X } from "lucide-react"

interface PricingModalProps {
  onClose: () => void
}

export default function PricingModal({ onClose }: PricingModalProps) {
  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="relative p-8 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-t-3xl">
          <button
            onClick={onClose}
            className="absolute top-6 right-6 p-2 hover:bg-white/20 rounded-xl transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
          
          <div className="text-center">
            <h2 className="text-4xl font-black mb-4">
              Plans Math4Child
            </h2>
            <p className="text-xl text-blue-100">
              Choisissez votre plan d'abonnement
            </p>
          </div>
        </div>

        <div className="p-8">
          <div className="grid md:grid-cols-3 gap-6">
            {[
              { name: "Gratuit", price: "0€", desc: "7 jours d'essai" },
              { name: "Mensuel", price: "9,99€", desc: "Par mois" },
              { name: "Annuel", price: "83,93€", desc: "Par an (30% de réduction)" }
            ].map((plan) => (
              <div
                key={plan.name}
                className="relative rounded-2xl border-2 border-gray-200 p-6 hover:border-blue-300 transition-all"
              >
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <div className="text-3xl font-black text-gray-900">{plan.price}</div>
                  <div className="text-sm text-gray-500">{plan.desc}</div>
                </div>
                
                <button className="w-full py-3 rounded-xl font-bold bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:shadow-lg transform hover:scale-105 transition-all duration-200">
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
