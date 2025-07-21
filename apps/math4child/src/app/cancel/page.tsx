'use client'

import { Home } from 'lucide-react'
import Link from 'next/link'

export default function CancelPage() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #ef4444, #dc2626)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '16px'
    }}>
      <div style={{
        background: 'white',
        borderRadius: '24px',
        maxWidth: '448px',
        width: '100%',
        padding: '32px',
        textAlign: 'center',
        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)'
      }}>
        <div style={{ fontSize: '64px', marginBottom: '24px' }}>😔</div>
        
        <h1 style={{
          fontSize: '24px',
          fontWeight: 'bold',
          color: '#374151',
          marginBottom: '16px',
          margin: '0 0 16px 0'
        }}>
          Paiement annulé
        </h1>
        
        <p style={{
          color: '#6b7280',
          marginBottom: '32px',
          margin: '0 0 32px 0'
        }}>
          Votre paiement a été annulé. Aucun montant n&apos;a été débité.
        </p>
        
        <Link 
          href="/"
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
            background: '#3b82f6',
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
          marginTop: '32px'
        }}>
          Des questions ? Contactez : khalid_ksouri@yahoo.fr
        </p>
      </div>
    </div>
  )
}
