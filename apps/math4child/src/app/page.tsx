'use client'

import { useState } from 'react'

type Language = 'fr' | 'en' | 'es'

interface Texts {
  title: string
  subtitle: string
  start: string
  about: string
}

export default function HomePage() {
  const [lang, setLang] = useState<Language>('fr')

  const texts: Record<Language, Texts> = {
    fr: { 
      title: 'Math4Child', 
      subtitle: 'Apprendre les mathématiques en s\'amusant',
      start: 'Commencer',
      about: 'À propos'
    },
    en: { 
      title: 'Math4Child', 
      subtitle: 'Learn mathematics while having fun',
      start: 'Start',
      about: 'About'
    },
    es: { 
      title: 'Math4Child', 
      subtitle: 'Aprende matemáticas divirtiéndote',
      start: 'Empezar',
      about: 'Acerca de'
    }
  }

  const t = texts[lang]

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      padding: '2rem',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        
        {/* Header */}
        <header style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          marginBottom: '3rem',
          flexWrap: 'wrap',
          gap: '1rem'
        }}>
          <h1 style={{ 
            color: 'white', 
            fontSize: 'clamp(1.5rem, 4vw, 2.5rem)', 
            fontWeight: 'bold',
            margin: 0
          }}>
            {t.title}
          </h1>
          
          {/* Language Selector */}
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            {(['fr', 'en', 'es'] as const).map((language) => (
              <button 
                key={language}
                onClick={() => setLang(language)}
                style={{
                  padding: '0.75rem 1.25rem',
                  backgroundColor: lang === language ? 'white' : 'rgba(59, 130, 246, 0.8)',
                  color: lang === language ? '#2563eb' : 'white',
                  border: 'none',
                  borderRadius: '0.5rem',
                  cursor: 'pointer',
                  fontWeight: '600',
                  fontSize: '0.9rem',
                  transition: 'all 0.15s ease'
                }}
              >
                {language === 'fr' && '🇫🇷 FR'}
                {language === 'en' && '🇺🇸 EN'}
                {language === 'es' && '🇪🇸 ES'}
              </button>
            ))}
          </div>
        </header>

        {/* Main Content */}
        <main style={{ textAlign: 'center', padding: '4rem 0' }}>
          <h2 style={{ 
            color: 'white', 
            fontSize: 'clamp(2rem, 6vw, 4rem)', 
            fontWeight: 'bold',
            marginBottom: '2rem',
            lineHeight: '1.2'
          }}>
            {t.subtitle}
          </h2>
          
          <p style={{ 
            color: 'rgba(255, 255, 255, 0.9)', 
            fontSize: 'clamp(1rem, 3vw, 1.25rem)',
            marginBottom: '3rem',
            maxWidth: '600px',
            margin: '0 auto 3rem auto',
            lineHeight: '1.6'
          }}>
            Une application éducative moderne pour apprendre les mathématiques avec plaisir et efficacité.
          </p>
          
          <div style={{ 
            display: 'flex', 
            gap: '1rem', 
            justifyContent: 'center', 
            flexWrap: 'wrap'
          }}>
            <button style={{
              backgroundColor: 'white',
              color: '#2563eb',
              padding: '1rem 2rem',
              border: 'none',
              borderRadius: '0.75rem',
              fontSize: '1.1rem',
              fontWeight: '600',
              cursor: 'pointer',
              boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
            }}>
              {t.start}
            </button>
            <button style={{
              backgroundColor: 'transparent',
              color: 'white',
              padding: '1rem 2rem',
              border: '2px solid white',
              borderRadius: '0.75rem',
              fontSize: '1.1rem',
              fontWeight: '600',
              cursor: 'pointer'
            }}>
              {t.about}
            </button>
          </div>
        </main>

        {/* Features */}
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', 
          gap: '2rem',
          marginTop: '4rem'
        }}>
          {[
            { icon: '🧮', title: 'Mathématiques', desc: 'Exercices adaptés' },
            { icon: '🎮', title: 'Ludique', desc: 'Apprendre en jouant' },
            { icon: '💳', title: 'Paiement', desc: 'Système sécurisé' }
          ].map((feature, index) => (
            <div key={index} style={{ 
              textAlign: 'center',
              padding: '2rem',
              backgroundColor: 'rgba(255, 255, 255, 0.1)',
              borderRadius: '1rem',
              backdropFilter: 'blur(10px)'
            }}>
              <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>{feature.icon}</div>
              <h3 style={{ 
                color: 'white', 
                fontSize: '1.5rem', 
                fontWeight: 'bold', 
                marginBottom: '0.75rem'
              }}>
                {feature.title}
              </h3>
              <p style={{ color: 'rgba(255, 255, 255, 0.8)' }}>
                {feature.desc}
              </p>
            </div>
          ))}
        </div>

        {/* Footer */}
        <footer style={{ 
          textAlign: 'center', 
          marginTop: '4rem', 
          paddingTop: '2rem',
          borderTop: '1px solid rgba(255,255,255,0.2)',
          color: 'rgba(255, 255, 255, 0.8)'
        }}>
          <p>© 2024 Math4Child - Application éducative</p>
          <p style={{ marginTop: '0.5rem', color: '#10b981', fontWeight: '600' }}>
            ✅ Déployé avec succès sur Netlify !
          </p>
        </footer>
      </div>
    </div>
  )
}
