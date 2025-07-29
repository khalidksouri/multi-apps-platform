'use client'

import { useState } from 'react'

export default function HomePage() {
  const [selectedAge, setSelectedAge] = useState('')

  return (
    <div style={{ background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)', minHeight: '100vh' }}>
      {/* Hero Section */}
      <section style={{ padding: '5rem 2rem', textAlign: 'center' }}>
        <div style={{ maxWidth: '1024px', margin: '0 auto' }}>
          <h1 style={{
            fontSize: '3.5rem',
            fontWeight: 'bold',
            color: '#1f2937',
            marginBottom: '1.5rem',
            background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent'
          }}>
            🧮 Math4Child
          </h1>
          <p style={{
            fontSize: '1.25rem',
            color: '#6b7280',
            marginBottom: '2rem',
            maxWidth: '600px',
            margin: '0 auto 2rem auto'
          }}>
            L'application éducative révolutionnaire qui rend l'apprentissage 
            des mathématiques amusant et accessible pour tous les enfants.
          </p>
          
          <div style={{ marginBottom: '2rem' }}>
            <label style={{ display: 'block', fontSize: '1.125rem', fontWeight: '500', color: '#374151', marginBottom: '1rem' }}>
              Sélectionnez l'âge de votre enfant :
            </label>
            <select
              value={selectedAge}
              onChange={(e) => setSelectedAge(e.target.value)}
              style={{
                padding: '0.75rem 1.5rem',
                fontSize: '1.125rem',
                border: '2px solid #d1d5db',
                borderRadius: '0.5rem',
                background: 'white'
              }}
            >
              <option value="">Choisir un âge...</option>
              <option value="4-6">4-6 ans (Maternelle)</option>
              <option value="7-10">7-10 ans (Primaire)</option>
              <option value="11-14">11-14 ans (Collège)</option>
              <option value="15-18">15-18 ans (Lycée)</option>
            </select>
          </div>

          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <a
              href="/exercises"
              style={{
                background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                color: 'white',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none',
                display: 'inline-block',
                transition: 'transform 0.2s'
              }}
              onMouseOver={(e) => e.target.style.transform = 'scale(1.05)'}
              onMouseOut={(e) => e.target.style.transform = 'scale(1)'}
            >
              🚀 Commencer gratuitement
            </a>
            <a
              href="/subscription"
              style={{
                background: 'white',
                color: '#374151',
                border: '2px solid #d1d5db',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none',
                display: 'inline-block',
                transition: 'all 0.2s'
              }}
              onMouseOver={(e) => { e.target.style.borderColor = '#3b82f6'; e.target.style.color = '#3b82f6' }}
              onMouseOut={(e) => { e.target.style.borderColor = '#d1d5db'; e.target.style.color = '#374151' }}
            >
              💎 Voir les abonnements
            </a>
          </div>
        </div>
      </section>

      {/* Fonctionnalités */}
      <section style={{ padding: '4rem 2rem', background: 'white' }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          <h2 style={{ fontSize: '2rem', fontWeight: 'bold', textAlign: 'center', color: '#1f2937', marginBottom: '3rem' }}>
            ✨ Fonctionnalités principales
          </h2>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '2rem' }}>
            {[
              { icon: '🧮', title: 'Exercices Adaptés', desc: 'Plus de 10 000 exercices personnalisés' },
              { icon: '🎯', title: 'Suivi Personnalisé', desc: 'IA qui s\'adapte au rythme de l\'enfant' },
              { icon: '🏆', title: 'Gamification', desc: 'Points, badges et défis motivants' },
              { icon: '🌍', title: 'Multilingue', desc: 'Interface en 14 langues' }
            ].map((feature, index) => (
              <div key={index} style={{
                textAlign: 'center',
                padding: '2rem',
                background: 'white',
                borderRadius: '1rem',
                boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
                border: '1px solid #f3f4f6'
              }}>
                <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>{feature.icon}</div>
                <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '0.5rem' }}>
                  {feature.title}
                </h3>
                <p style={{ color: '#6b7280' }}>{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Final */}
      <section style={{
        padding: '4rem 2rem',
        background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
        color: 'white',
        textAlign: 'center'
      }}>
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <h2 style={{ fontSize: '2.5rem', fontWeight: 'bold', marginBottom: '1rem' }}>
            🎯 Prêt à commencer ?
          </h2>
          <p style={{ fontSize: '1.25rem', marginBottom: '2rem', opacity: 0.9 }}>
            Rejoignez plus de 50 000 familles qui font confiance à Math4Child
          </p>
          <a
            href="/exercises"
            style={{
              background: 'white',
              color: '#3b82f6',
              padding: '1rem 2rem',
              borderRadius: '0.5rem',
              fontSize: '1.125rem',
              fontWeight: '600',
              textDecoration: 'none',
              display: 'inline-block',
              boxShadow: '0 4px 20px rgba(0,0,0,0.2)'
            }}
          >
            🚀 Commencer maintenant
          </a>
        </div>
      </section>
    </div>
  )
}
