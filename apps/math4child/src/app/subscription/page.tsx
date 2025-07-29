'use client'

import { useState } from 'react'

export default function SubscriptionPage() {
  const [billingPeriod, setBillingPeriod] = useState('monthly')

  const plans = [
    {
      id: 'free',
      name: 'Découverte',
      description: 'Parfait pour tester Math4Child',
      price: { monthly: 0, yearly: 0 },
      features: [
        '5 exercices par jour',
        'Suivi basique des progrès',
        'Accès aux additions simples',
        'Support par email',
        '1 profil enfant'
      ],
      color: 'border-gray-300',
      buttonColor: 'bg-gray-600 hover:bg-gray-700',
      target: 'Particuliers'
    },
    {
      id: 'premium',
      name: 'Premium',
      description: 'L\'expérience complète pour un enfant',
      price: { monthly: 9.99, yearly: 7.99 },
      features: [
        'Exercices illimités',
        'Toutes les opérations mathématiques',
        'Analyses détaillées des progrès',
        'Mode hors ligne',
        'Contenu adaptatif IA',
        'Support prioritaire',
        'Jusqu\'à 3 profils enfants'
      ],
      color: 'border-blue-500 ring-4 ring-blue-100',
      buttonColor: 'bg-blue-600 hover:bg-blue-700',
      popular: true,
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Familles'
    },
    {
      id: 'family',
      name: 'Famille',
      description: 'Idéal pour les familles nombreuses',
      price: { monthly: 19.99, yearly: 15.99 },
      features: [
        'Tout le contenu Premium',
        'Jusqu\'à 6 profils enfants',
        'Rapports détaillés par enfant',
        'Contrôle parental complet',
        'Support téléphonique',
        'Accès anticipé aux nouveautés'
      ],
      color: 'border-purple-300',
      buttonColor: 'bg-purple-600 hover:bg-purple-700',
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Grandes familles'
    },
    {
      id: 'school',
      name: 'Écoles & Associations',
      description: 'Solution complète pour institutions éducatives',
      price: { monthly: 49.99, yearly: 39.99 },
      features: [
        'Comptes illimités élèves',
        'Tableau de bord enseignant',
        'Gestion de classes multiples',
        'Conformité RGPD éducation',
        'Formation des enseignants incluse',
        'Support technique dédié'
      ],
      color: 'border-emerald-400 ring-4 ring-emerald-100',
      buttonColor: 'bg-emerald-600 hover:bg-emerald-700',
      target: 'Institutions',
      badge: '🏫 Professionnel',
      contact: true
    }
  ]

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1400px', margin: '0 auto' }}>
        {/* Header */}
        <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
          <h1 style={{ 
            fontSize: '3rem', 
            fontWeight: 'bold', 
            color: '#1f2937', 
            marginBottom: '1rem' 
          }}>
            💎 Choisissez votre abonnement
          </h1>
          <p style={{ fontSize: '1.25rem', color: '#6b7280', marginBottom: '2rem' }}>
            Débloquez tout le potentiel de Math4Child pour votre enfant ou votre établissement
          </p>

          {/* Toggle mensuel/annuel */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '1rem', marginBottom: '2rem' }}>
            <span style={{ color: billingPeriod === 'monthly' ? '#1f2937' : '#9ca3af', fontWeight: billingPeriod === 'monthly' ? '600' : '400' }}>
              Mensuel
            </span>
            <button
              onClick={() => setBillingPeriod(billingPeriod === 'monthly' ? 'yearly' : 'monthly')}
              style={{
                position: 'relative',
                width: '3rem',
                height: '1.5rem',
                background: billingPeriod === 'yearly' ? '#3b82f6' : '#d1d5db',
                borderRadius: '0.75rem',
                border: 'none',
                cursor: 'pointer',
                transition: 'background-color 0.2s'
              }}
            >
              <span style={{
                position: 'absolute',
                width: '1.25rem',
                height: '1.25rem',
                background: 'white',
                borderRadius: '50%',
                top: '0.125rem',
                left: billingPeriod === 'yearly' ? '1.625rem' : '0.125rem',
                transition: 'left 0.2s'
              }} />
            </button>
            <span style={{ color: billingPeriod === 'yearly' ? '#1f2937' : '#9ca3af', fontWeight: billingPeriod === 'yearly' ? '600' : '400' }}>
              Annuel
            </span>
            {billingPeriod === 'yearly' && (
              <span style={{
                background: '#dcfce7',
                color: '#166534',
                padding: '0.25rem 0.75rem',
                borderRadius: '1rem',
                fontSize: '0.875rem',
                fontWeight: '600'
              }}>
                💰 Économisez 20%
              </span>
            )}
          </div>
        </div>

        {/* Plans */}
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', 
          gap: '2rem',
          marginBottom: '4rem'
        }}>
          {plans.map((plan) => (
            <div key={plan.id} style={{
              background: 'white',
              borderRadius: '1.5rem',
              padding: '2rem',
              border: plan.color.includes('ring') ? '3px solid #3b82f6' : '2px solid #e5e7eb',
              position: 'relative',
              boxShadow: plan.popular ? '0 20px 40px rgba(59, 130, 246, 0.15)' : '0 10px 30px rgba(0,0,0,0.1)',
              transform: plan.popular ? 'scale(1.05)' : 'scale(1)',
              transition: 'all 0.3s'
            }}>
              {plan.popular && (
                <div style={{
                  position: 'absolute',
                  top: '-0.75rem',
                  left: '50%',
                  transform: 'translateX(-50%)',
                  background: '#3b82f6',
                  color: 'white',
                  padding: '0.5rem 1.5rem',
                  borderRadius: '1.5rem',
                  fontSize: '0.875rem',
                  fontWeight: '600'
                }}>
                  🔥 Plus populaire
                </div>
              )}

              {plan.badge && (
                <div style={{
                  position: 'absolute',
                  top: '-0.75rem',
                  left: '50%',
                  transform: 'translateX(-50%)',
                  background: '#10b981',
                  color: 'white',
                  padding: '0.5rem 1.5rem',
                  borderRadius: '1.5rem',
                  fontSize: '0.875rem',
                  fontWeight: '600'
                }}>
                  {plan.badge}
                </div>
              )}

              <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
                <div style={{ fontSize: '0.75rem', fontWeight: '500', color: '#6b7280', marginBottom: '0.5rem' }}>
                  {plan.target}
                </div>
                <h3 style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#1f2937', marginBottom: '0.5rem' }}>
                  {plan.name}
                </h3>
                <p style={{ color: '#6b7280', marginBottom: '1.5rem', fontSize: '0.875rem' }}>
                  {plan.description}
                </p>
                
                <div style={{ marginBottom: '1.5rem' }}>
                  {plan.price[billingPeriod] === 0 ? (
                    <span style={{ fontSize: '2.5rem', fontWeight: 'bold', color: '#1f2937' }}>Gratuit</span>
                  ) : plan.contact ? (
                    <div>
                      <span style={{ fontSize: '2rem', fontWeight: 'bold', color: '#10b981' }}>Sur devis</span>
                      <div style={{ fontSize: '0.75rem', color: '#6b7280', marginTop: '0.25rem' }}>
                        Tarifs préférentiels disponibles
                      </div>
                    </div>
                  ) : (
                    <div>
                      <span style={{ fontSize: '2.5rem', fontWeight: 'bold', color: '#1f2937' }}>
                        {plan.price[billingPeriod]}€
                      </span>
                      <span style={{ color: '#6b7280', fontSize: '1rem' }}>
                        /{billingPeriod === 'monthly' ? 'mois' : 'mois'}
                      </span>
                      {billingPeriod === 'yearly' && (
                        <div style={{ fontSize: '0.75rem', color: '#6b7280' }}>
                          Facturé {(plan.price.yearly * 12).toFixed(2)}€/an
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>

              <ul style={{ marginBottom: '2rem', padding: 0, listStyle: 'none' }}>
                {plan.features.map((feature, index) => (
                  <li key={index} style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    marginBottom: '0.75rem',
                    fontSize: '0.875rem',
                    color: '#374151'
                  }}>
                    <span style={{ color: '#10b981', marginRight: '0.75rem', fontSize: '1rem' }}>✓</span>
                    <span>{feature}</span>
                  </li>
                ))}
              </ul>

              <button style={{
                width: '100%',
                color: 'white',
                padding: '1rem',
                fontSize: '1rem',
                fontWeight: '600',
                borderRadius: '0.75rem',
                border: 'none',
                cursor: 'pointer',
                background: plan.id === 'free' ? '#6b7280' : 
                           plan.id === 'premium' ? '#3b82f6' : 
                           plan.id === 'family' ? '#8b5cf6' : '#10b981',
                transition: 'all 0.2s'
              }}>
                {plan.price[billingPeriod] === 0 ? 'Commencer gratuitement' : 
                 plan.contact ? 'Nous contacter' : 'Choisir ce plan'}
              </button>

              {plan.price[billingPeriod] > 0 && !plan.contact && (
                <p style={{ textAlign: 'center', fontSize: '0.75rem', color: '#6b7280', marginTop: '1rem', margin: '1rem 0 0 0' }}>
                  Essai gratuit de 7 jours • Annulable à tout moment
                </p>
              )}
            </div>
          ))}
        </div>

        {/* CTA pour les écoles */}
        <section style={{
          background: 'linear-gradient(135deg, #10b981, #3b82f6)',
          color: 'white',
          borderRadius: '1.5rem',
          padding: '3rem',
          textAlign: 'center'
        }}>
          <h2 style={{ fontSize: '2rem', fontWeight: 'bold', marginBottom: '1rem' }}>
            🎓 Vous êtes un établissement scolaire ?
          </h2>
          <p style={{ fontSize: '1.125rem', marginBottom: '2rem', opacity: 0.9 }}>
            Découvrez notre solution complète pour les écoles et associations
          </p>
          <button style={{
            background: 'white',
            color: '#10b981',
            padding: '1rem 2rem',
            borderRadius: '0.75rem',
            fontSize: '1.125rem',
            fontWeight: '600',
            border: 'none',
            cursor: 'pointer',
            boxShadow: '0 4px 20px rgba(0,0,0,0.2)'
          }}>
            📞 Demander une démonstration
          </button>
        </section>
      </div>
    </div>
  )
}
