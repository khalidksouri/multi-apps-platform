'use client'

import { Suspense } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'

// Composant qui utilise useSearchParams (doit être dans Suspense)
function SuccessContent() {
  const searchParams = useSearchParams()
  const router = useRouter()
  const sessionId = searchParams.get('session_id')

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="max-w-md mx-auto text-center">
        <div className="mb-8">
          <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span className="text-2xl">✅</span>
          </div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            Paiement Réussi !
          </h1>
          <p className="text-gray-600">
            Votre abonnement Math4Child a été activé avec succès.
          </p>
        </div>

        {sessionId && (
          <div className="bg-white p-4 rounded-lg border mb-6">
            <p className="text-sm text-gray-500 mb-1">ID de session :</p>
            <p className="font-mono text-xs break-all">{sessionId}</p>
          </div>
        )}

        <div className="space-y-3">
          <button 
            onClick={() => router.push('/')}
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors"
          >
            Retour à l'accueil
          </button>
          <button 
            onClick={() => router.push('/stripe-test')}
            className="w-full bg-gray-200 text-gray-700 py-2 px-4 rounded-lg hover:bg-gray-300 transition-colors"
          >
            Tester un autre paiement
          </button>
        </div>
      </div>
    </div>
  )
}

// Composant de chargement
function SuccessLoading() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="max-w-md mx-auto text-center">
        <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <span className="text-2xl">⏳</span>
        </div>
        <p className="text-gray-600">Chargement...</p>
      </div>
    </div>
  )
}

// Page principale avec Suspense
export default function SuccessPage() {
  return (
    <Suspense fallback={<SuccessLoading />}>
      <SuccessContent />
    </Suspense>
  )
}
