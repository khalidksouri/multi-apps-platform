'use client'

import { useState, useEffect } from 'react'
import { useTranslation } from '@/hooks/useTranslation'
import { PricingPlan, BillingInfo } from '@/types/payment'
import { X, CreditCard, Lock, Shield, Check, AlertCircle, User } from 'lucide-react'

interface CheckoutModalProps {
  isOpen: boolean
  onClose: () => void
  plan: PricingPlan | null
  onSuccess: (sessionId: string) => void
}

export function CheckoutModal({ isOpen, onClose, plan, onSuccess }: CheckoutModalProps) {
  const { t, isRTL } = useTranslation()
  const [step, setStep] = useState<'billing' | 'payment' | 'processing' | 'success'>('billing')
  const [billingInfo, setBillingInfo] = useState<BillingInfo>({
    email: '',
    name: '',
    address: {
      line1: '',
      line2: '',
      city: '',
      state: '',
      postalCode: '',
      country: 'FR'
    }
  })
  const [agreeToTerms, setAgreeToTerms] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Reset modal state when opening
  useEffect(() => {
    if (isOpen) {
      setStep('billing')
      setError(null)
      setLoading(false)
    }
  }, [isOpen])

  if (!isOpen || !plan) return null

  const formatPrice = (price: number, currency: string = 'EUR') => {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency,
      minimumFractionDigits: price % 1 === 0 ? 0 : 2
    }).format(price)
  }

  const handleBillingSubmit = () => {
    if (!billingInfo.email || !billingInfo.name) {
      setError('Veuillez remplir tous les champs obligatoires')
      return
    }
    if (!agreeToTerms) {
      setError('Veuillez accepter les conditions d\'utilisation')
      return
    }
    setError(null)
    setStep('payment')
  }

  const handlePayment = async () => {
    setLoading(true)
    setError(null)
    setStep('processing')

    try {
      console.log('🔄 Création de la session checkout...', { plan: plan.id })

      // Simulation d'appel API en mode développement
      await new Promise(resolve => setTimeout(resolve, 2000))
      
      // Simuler un succès
      if (Math.random() > 0.1) { // 90% de succès
        console.log('✅ Paiement simulé réussi')
        setStep('success')
        setTimeout(() => {
          onSuccess('test_session_' + Date.now())
        }, 1500)
      } else {
        throw new Error('Erreur de paiement simulée')
      }
    } catch (err) {
      console.error('❌ Erreur paiement:', err)
      setError(err instanceof Error ? err.message : 'Erreur lors du paiement')
      setStep('payment')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Overlay */}
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      {/* Modal */}
      <div className={`relative bg-white rounded-3xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden ${isRTL ? 'rtl' : 'ltr'}`}>
        {/* Header */}
        <div className="bg-gradient-to-r from-purple-500 to-pink-500 p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-bold">Finaliser votre abonnement</h2>
              <p className="text-purple-100">Plan {plan.name} - {formatPrice(plan.price)}</p>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-6 overflow-y-auto max-h-[60vh]">
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start">
              <AlertCircle className="w-5 h-5 text-red-500 mr-3 mt-0.5" />
              <div>
                <p className="text-red-800 font-medium">Erreur</p>
                <p className="text-red-600 text-sm">{error}</p>
              </div>
            </div>
          )}

          {/* Step: Billing Info */}
          {step === 'billing' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <User className="w-5 h-5 mr-2" />
                  Informations de facturation
                </h3>
                
                <div className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Nom complet *
                      </label>
                      <input
                        type="text"
                        value={billingInfo.name}
                        onChange={(e) => setBillingInfo(prev => ({ ...prev, name: e.target.value }))}
                        className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                        placeholder="Jean Dupont"
                      />
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Email *
                      </label>
                      <input
                        type="email"
                        value={billingInfo.email}
                        onChange={(e) => setBillingInfo(prev => ({ ...prev, email: e.target.value }))}
                        className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                        placeholder="jean@example.com"
                      />
                    </div>
                  </div>
                </div>
              </div>

              {/* Terms */}
              <div className="flex items-start space-x-3">
                <input
                  type="checkbox"
                  id="terms"
                  checked={agreeToTerms}
                  onChange={(e) => setAgreeToTerms(e.target.checked)}
                  className="mt-1 w-4 h-4 text-purple-600 rounded border-gray-300 focus:ring-purple-500"
                />
                <label htmlFor="terms" className="text-sm text-gray-600">
                  J'accepte les conditions d'utilisation et la politique de confidentialité de GOTEST.
                </label>
              </div>
            </div>
          )}

          {/* Step: Payment */}
          {step === 'payment' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  <CreditCard className="w-5 h-5 mr-2" />
                  Confirmation de paiement
                </h3>

                <div className="bg-gradient-to-r from-purple-50 to-pink-50 rounded-lg p-6 mb-6">
                  <h4 className="font-semibold text-gray-900 mb-3">Récapitulatif de commande</h4>
                  <div className="space-y-2">
                    <div className="flex justify-between">
                      <span>Plan {plan.name}</span>
                      <span className="font-medium">{formatPrice(plan.price)}</span>
                    </div>
                    <div className="border-t pt-2 flex justify-between font-semibold text-lg">
                      <span>Total</span>
                      <span>{formatPrice(plan.price)}</span>
                    </div>
                    <div className="text-sm text-gray-600">
                      Mode test - Aucun paiement réel
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Step: Processing */}
          {step === 'processing' && (
            <div className="text-center py-12">
              <div className="animate-spin w-12 h-12 border-4 border-purple-500 border-t-transparent rounded-full mx-auto mb-4"></div>
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Traitement en cours...</h3>
              <p className="text-gray-600">Simulation du paiement en cours.</p>
            </div>
          )}

          {/* Step: Success */}
          {step === 'success' && (
            <div className="text-center py-12">
              <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <Check className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Paiement simulé réussi !</h3>
              <p className="text-gray-600 mb-4">
                Votre abonnement {plan.name} serait activé en production.
              </p>
              <div className="mt-4 text-xs text-gray-400">
                Facturé par GOTEST (SIRET: 53958712100028)
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        {step !== 'success' && step !== 'processing' && (
          <div className="border-t border-gray-200 p-6">
            <div className="flex items-center justify-between">
              <div className="flex items-center text-sm text-gray-500">
                <Shield className="w-4 h-4 mr-1" />
                <span>Mode test - Aucun paiement réel</span>
              </div>
              
              <div className="flex space-x-3">
                {step === 'payment' && (
                  <button
                    onClick={() => setStep('billing')}
                    className="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    Retour
                  </button>
                )}
                
                <button
                  onClick={step === 'billing' ? handleBillingSubmit : handlePayment}
                  disabled={loading}
                  className="px-6 py-2 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-lg hover:from-purple-600 hover:to-pink-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                >
                  {loading && <div className="animate-spin w-4 h-4 border-2 border-white border-t-transparent rounded-full mr-2"></div>}
                  {step === 'billing' ? 'Continuer' : 'Simuler le paiement'}
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
