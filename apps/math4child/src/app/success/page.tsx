'use client'

import { Suspense } from 'react'
import { Crown, CheckCircle, Home } from 'lucide-react'
import Link from 'next/link'
import { useSearchParams } from 'next/navigation'

function SuccessContent() {
  const searchParams = useSearchParams()
  const sessionId = searchParams?.get('session_id')

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #10b981, #059669)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '16px'
    }}>
      <div style={{
        background: 'white',
        borderRadius: '24px',
        maxWidth: '512px',
        width: '100%',
        padding: '48px',
        textAlign: 'center',
        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)'
      }}>
        <div style={{ fontSize: '64px', marginBottom: '24px' }}>🎉</div>
        
        <div style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          marginBottom: '16px'
        }}>
          <Crown style={{ color: '#f59e0b', marginRight: '8px' }} size={32} />
          <h1 style={{
            fontSize: '32px',
            fontWeight: 'bold',
            color: '#374151',
            margin: 0
          }}>
            Paiement réussi !
          </h1>
        </div>
        
        <div style={{
          background: '#d1fae5',
          border: '1px solid #a7f3d0',
          borderRadius: '12px',
          padding: '16px',
          marginBottom: '24px'
        }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            marginBottom: '8px'
          }}>
            <CheckCircle style={{ color: '#10b981', marginRight: '8px' }} size={24} />
            <span style={{ color: '#065f46', fontWeight: '600' }}>Confirmation</span>
          </div>
          
          <div style={{ fontSize: '14px', color: '#374151' }}>
            <p><strong>Formule:</strong> Math4Child Premium</p>
            <p><strong>Montant:</strong> 9,99€/mois</p>
            {sessionId && <p><strong>Session:</strong> {sessionId}</p>}
          </div>
        </div>
        
        <Link 
          href="/"
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '8px',
            background: 'linear-gradient(135deg, #3b82f6, #1d4ed8)',
            color: 'white',
            padding: '12px 24px',
            borderRadius: '12px',
            textDecoration: 'none',
            fontWeight: '600'
          }}
        >
          <Home size={20} />
          Retour à la page d&apos;accueil
        </Link>
        
        <p style={{
          fontSize: '12px',
          color: '#6b7280',
          marginTop: '24px'
        }}>
          Support: khalid_ksouri@yahoo.fr
        </p>
      </div>
    </div>
  )
}

export default function SuccessPage() {
  return (
    <Suspense fallback={
      <div style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #10b981, #059669)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
      }}>
        <div style={{ color: 'white', fontSize: '18px' }}>Chargement...</div>
      </div>
    }>
      <SuccessContent />
    </Suspense>
  )
}
