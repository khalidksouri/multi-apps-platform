'use client'

import { useState, useEffect } from 'react'

export default function HomePage() {
  const [lang, setLang] = useState('fr')
  const [mounted, setMounted] = useState(false)

  // Éviter hydration mismatch
  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <div style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
      }}>
        <div style={{ color: 'white', fontSize: '1.5rem' }}>
          Loading Math4Child...
        </div>
      </div>
    )
  }

  const texts = {
    fr: { 
      title: 'Math4Child', 
      subtitle: 'Apprendre les mathématiques en s\'amusant',
      description: 'Une application éducative moderne pour apprendre les mathématiques avec plaisir et efficacité.',
      start: 'Commencer',
      about: 'En savoir plus'
    },
    en: { 
      title: 'Math4Child', 
      subtitle: 'Learn mathematics while having fun',
      description: 'A modern educational application to learn mathematics with pleasure and efficiency.',
      start: 'Start',
      about: 'Learn more'
    },
    es: { 
      title: 'Math4Child', 
      subtitle: 'Aprende matemáticas divirtiéndote',
      description: 'Una aplicación educativa moderna para aprender matemáticas con placer y eficiencia.',
      start: 'Empezar',
      about: 'Saber más'
    }
  }

  const t = texts[lang as keyof typeof texts] || texts.fr

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      padding: '2rem',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        
        {/* Header avec sélecteur de langue */}
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

        {/* Contenu principal */}
        <main style={{ textAlign: 'center', padding: '4rem 0' }}>
          <h2 style={{ 
            color: 'white', 
            fontSize: 'clamp(2rem, 6vw, 4rem)', 
            fontWeight: 'bold',
            marginBottom: '2rem',
            lineHeight: '1.2',
            margin: '0 0 2rem 0'
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
            {t.description}
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
              boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
              transition: 'all 0.15s ease'
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
              cursor: 'pointer',
              transition: 'all 0.15s ease'
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
            { icon: '🧮', title: 'Mathématiques', desc: 'Exercices adaptés à chaque niveau' },
            { icon: '🎮', title: 'Ludique', desc: 'Apprendre en s\'amusant' },
            { icon: '💳', title: 'Paiement Sécurisé', desc: 'Système multi-provider' }
          ].map((feature, index) => (
            <div key={index} style={{ 
              textAlign: 'center',
              padding: '2rem',
              backgroundColor: 'rgba(255, 255, 255, 0.1)',
              borderRadius: '1rem',
              backdropFilter: 'blur(10px)',
              border: '1px solid rgba(255, 255, 255, 0.2)'
            }}>
              <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>{feature.icon}</div>
              <h3 style={{ 
                color: 'white', 
                fontSize: '1.5rem', 
                fontWeight: 'bold', 
                marginBottom: '0.75rem',
                margin: '0 0 0.75rem 0'
              }}>
                {feature.title}
              </h3>
              <p style={{ 
                color: 'rgba(255, 255, 255, 0.8)',
                fontSize: '1rem',
                lineHeight: '1.5'
              }}>
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
          <p style={{ marginBottom: '0.5rem' }}>
            © 2024 Math4Child - Application éducative moderne
          </p>
          <p style={{ 
            color: '#10b981', 
            fontWeight: '600',
            fontSize: '1.1rem'
          }}>
            ✅ Déployé avec succès sur Netlify en mode SPA !
          </p>
        </footer>
      </div>
    </div>
  )
}
