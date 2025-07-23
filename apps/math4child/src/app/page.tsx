'use client'

import { useState } from 'react'

export default function HomePage() {
  const [lang, setLang] = useState('fr')

  const texts = {
    fr: { title: 'Math4Child', subtitle: 'Apprendre les mathématiques en s\'amusant' },
    en: { title: 'Math4Child', subtitle: 'Learn mathematics while having fun' },
    es: { title: 'Math4Child', subtitle: 'Aprende matemáticas divirtiéndote' }
  }

  const t = texts[lang] || texts.fr

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        
        {/* Header */}
        <header style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          marginBottom: '3rem'
        }}>
          <h1 style={{ color: 'white', fontSize: '2rem', fontWeight: 'bold' }}>
            {t.title}
          </h1>
          
          {/* Language Selector */}
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            <button 
              onClick={() => setLang('fr')}
              style={{
                padding: '0.5rem 1rem',
                backgroundColor: lang === 'fr' ? 'white' : '#3b82f6',
                color: lang === 'fr' ? '#2563eb' : 'white',
                border: 'none',
                borderRadius: '0.5rem',
                cursor: 'pointer',
                fontWeight: '500'
              }}
            >
              🇫🇷 FR
            </button>
            <button 
              onClick={() => setLang('en')}
              style={{
                padding: '0.5rem 1rem',
                backgroundColor: lang === 'en' ? 'white' : '#3b82f6',
                color: lang === 'en' ? '#2563eb' : 'white',
                border: 'none',
                borderRadius: '0.5rem',
                cursor: 'pointer',
                fontWeight: '500'
              }}
            >
              🇺🇸 EN
            </button>
            <button 
              onClick={() => setLang('es')}
              style={{
                padding: '0.5rem 1rem',
                backgroundColor: lang === 'es' ? 'white' : '#3b82f6',
                color: lang === 'es' ? '#2563eb' : 'white',
                border: 'none',
                borderRadius: '0.5rem',
                cursor: 'pointer',
                fontWeight: '500'
              }}
            >
              🇪🇸 ES
            </button>
          </div>
        </header>

        {/* Main Content */}
        <main style={{ textAlign: 'center', padding: '4rem 0' }}>
          <h2 style={{ 
            color: 'white', 
            fontSize: '3rem', 
            fontWeight: 'bold',
            marginBottom: '2rem',
            lineHeight: '1.2'
          }}>
            {t.subtitle}
          </h2>
          
          <p style={{ 
            color: '#dbeafe', 
            fontSize: '1.25rem',
            marginBottom: '3rem',
            maxWidth: '600px',
            margin: '0 auto 3rem auto'
          }}>
            Une application éducative moderne pour apprendre les mathématiques avec plaisir et efficacité.
          </p>
          
          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <button style={{
              backgroundColor: 'white',
              color: '#2563eb',
              padding: '1rem 2rem',
              border: 'none',
              borderRadius: '0.5rem',
              fontSize: '1.1rem',
              fontWeight: '600',
              cursor: 'pointer'
            }}>
              Commencer gratuitement
            </button>
            <button style={{
              backgroundColor: 'transparent',
              color: 'white',
              padding: '1rem 2rem',
              border: '2px solid white',
              borderRadius: '0.5rem',
              fontSize: '1.1rem',
              fontWeight: '600',
              cursor: 'pointer'
            }}>
              En savoir plus
            </button>
          </div>
        </main>

        {/* Features */}
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: '2rem',
          marginTop: '4rem'
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>🧮</div>
            <h3 style={{ color: 'white', fontSize: '1.25rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              Mathématiques
            </h3>
            <p style={{ color: '#dbeafe' }}>Exercices adaptés à chaque niveau</p>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>🎮</div>
            <h3 style={{ color: 'white', fontSize: '1.25rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              Ludique
            </h3>
            <p style={{ color: '#dbeafe' }}>Apprendre en s'amusant</p>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>💳</div>
            <h3 style={{ color: 'white', fontSize: '1.25rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              Paiement Sécurisé
            </h3>
            <p style={{ color: '#dbeafe' }}>Système multi-provider</p>
          </div>
        </div>

        {/* Footer */}
        <footer style={{ 
          textAlign: 'center', 
          marginTop: '4rem', 
          color: '#dbeafe',
          borderTop: '1px solid rgba(255,255,255,0.2)',
          paddingTop: '2rem'
        }}>
          <p>© 2024 Math4Child - Application éducative moderne</p>
          <p style={{ marginTop: '0.5rem', color: '#10b981' }}>
            ✅ Déployé avec succès sur Netlify !
          </p>
        </footer>
      </div>
    </div>
  )
}
