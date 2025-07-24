'use client'

import { useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import { CheckCircle, ArrowLeft, CreditCard } from 'lucide-react'
import Link from 'next/link'

export default function SuccessPage() {
  const searchParams = useSearchParams()
  const sessionId = searchParams.get('session_id')
  const [sessionDetails, setSessionDetails] = useState<any>(null)

  useEffect(() => {
    if (sessionId) {
      // Simuler les détails de session pour les tests
      setSessionDetails({
        id: sessionId,
        status: 'complete',
        customer_email: 'test@math4child.com',
        amount_total: 699,
        currency: 'eur',
        payment_status: 'paid',
        created: Date.now() / 1000,
        testMode: true
      })
    }
  }, [sessionId])

  if (!sessionId) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-red-50 to-pink-50 flex items-center justify-center p-6">
        <div className="max-w-md mx-auto text-center">
          <div className="text-6xl mb-4">❌</div>
          <h1 className="text-2xl font-bold text-gray-800 mb-4">Aucune session trouvée</h1>
          <Link href="/stripe-test" className="inline-flex items-center bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition-colors">
            <ArrowLeft className="w-4 h-4 mr-2" />
            Retour aux tests
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 p-6">
      <div className="max-w-4xl mx-auto">
        
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-green-500 rounded-full mb-6">
            <CheckCircle className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-4xl font-bold text-gray-800 mb-4">🎉 Paiement Réussi !</h1>
          <p className="text-xl text-gray-600 mb-2">Votre abonnement Math4Child a été activé avec succès</p>
          <div className="inline-flex items-center bg-yellow-100 text-yellow-800 px-4 py-2 rounded-full text-sm">
            🧪 Mode Test - Aucun paiement réel effectué
          </div>
        </div>

        {sessionDetails && (
          <div className="bg-white rounded-xl shadow-lg p-8 mb-8">
            <h2 className="text-2xl font-bold text-gray-800 mb-6">📄 Détails de la transaction</h2>
            <div className="space-y-4">
              <div>
                <p className="text-sm text-gray-500">ID de session</p>
                <p className="font-mono text-sm text-gray-800">{sessionDetails.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500">Statut</p>
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  Test réussi
                </span>
              </div>
            </div>
          </div>
        )}

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link href="/" className="inline-flex items-center justify-center bg-blue-500 text-white px-8 py-3 rounded-lg hover:bg-blue-600 transition-colors font-semibold">
            <ArrowLeft className="w-4 h-4 mr-2" />
            Retour à l'accueil
          </Link>
          
          <Link href="/stripe-test" className="inline-flex items-center justify-center bg-gray-500 text-white px-8 py-3 rounded-lg hover:bg-gray-600 transition-colors font-semibold">
            <CreditCard className="w-4 h-4 mr-2" />
            Tester un autre paiement
          </Link>
        </div>

      </div>
    </div>
  )
}
