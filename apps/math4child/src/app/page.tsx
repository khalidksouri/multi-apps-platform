'use client'

import { useState, useEffect } from 'react'

export default function HomePage() {
  const [lang, setLang] = useState('fr')
  const [mounted, setMounted] = useState(false)

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
        justifyContent: 'center',
        fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
      }}>
        <div style={{ 
          color: 'white', 
          fontSize: '1.5rem',
          textAlign: 'center'
        }}>
          <div style={{
            width: '50px',
            height: '50px',
            border: '3px solid rgba(255,255,255,0.3)',
            borderRadius: '50%',
            borderTopColor: 'white',
            animation: 'spin 1s linear infinite',
            margin: '0 auto 20px'
          }}></div>
          Chargement de Math4Child...
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
      about: 'En savoir plus',
      features: {
        math: { title: 'Mathématiques', desc: 'Exercices adaptés à chaque niveau' },
        fun: { title: 'Ludique', desc: 'Apprendre en s\'amusant' },
        payment: { title: 'Paiement Sécurisé', desc: 'Système multi-provider' }
      }
    },
    en: { 
      title: 'Math4Child', 
      subtitle: 'Learn mathematics while having fun',
      description: 'A modern educational application to learn mathematics with pleasure and efficiency.',
      start: 'Start',
      about: 'Learn more',
      features: {
        math: { title: 'Mathematics', desc: 'Exercises adapted to each level' },
        fun: { title: 'Fun Learning', desc: 'Learn while having fun' },
        payment: { title: 'Secure Payment', desc: 'Multi-provider system' }
      }
    },
    es: { 
      title: 'Math4Child', 
      subtitle: 'Aprende matemáticas divirtiéndote',
      description: 'Una aplicación educativa moderna para aprender matemáticas con placer y eficiencia.',
      start: 'Empezar',
      about: 'Saber más',
      features: {
        math: { title: 'Matemáticas', desc: 'Ejercicios adaptados a cada nivel' },
        fun: { title: 'Lúdico', desc: 'Aprender divirtiéndose' },
        payment: { title: 'Pago Seguro', desc: 'Sistema multi-proveedor' }
      }
    }
  }

  const t = texts[lang as keyof typeof texts] || texts.fr

  const languageOptions = [
    { code: 'fr', flag: '🇫🇷', name: 'FR' },
    { code: 'en', flag: '🇺🇸', name: 'EN' },
    { code: 'es', flag: '🇪🇸', name: 'ES' }
  ]

  return (
    <>
      <style jsx>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideInFromTop {
          from { opacity: 0; transform: translateY(-30px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideInFromBottom {
          from { opacity: 0; transform: translateY(30px); }
          to { opacity: 1; transform: translateY(0); }
        }
      `}</style>

      <div style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        padding: '2rem',
        fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
        lineHeight: '1.6'
      }}>
        <div style={{ 
          maxWidth: '1200px', 
          margin: '0 auto',
          animation: 'fadeIn 0.8s ease-out'
        }}>
          
          {/* Header avec sélecteur de langue amélioré */}
          <header style={{ 
            display: 'flex', 
            justifyContent: 'space-between', 
            alignItems: 'center',
            marginBottom: '4rem',
            flexWrap: 'wrap',
            gap: '2rem',
            animation: 'slideInFromTop 0.6s ease-out'
          }}>
            <h1 style={{ 
              color: 'white', 
              fontSize: 'clamp(2rem, 5vw, 3rem)', 
              fontWeight: '800',
              margin: 0,
              textShadow: '0 2px 4px rgba(0,0,0,0.3)',
              letterSpacing: '-0.02em'
            }}>
              {t.title}
            </h1>
            
            {/* Sélecteur de langue magnifique */}
            <div style={{ 
              display: 'flex', 
              gap: '0.5rem',
              background: 'rgba(255, 255, 255, 0.1)',
              padding: '0.5rem',
              borderRadius: '1rem',
              backdropFilter: 'blur(10px)',
              border: '1px solid rgba(255, 255, 255, 0.2)',
              boxShadow: '0 8px 32px rgba(0,0,0,0.1)'
            }}>
              {languageOptions.map((option) => (
                <button 
                  key={option.code}
                  onClick={() => setLang(option.code)}
                  style={{
                    padding: '0.75rem 1.25rem',
                    background: lang === option.code 
                      ? 'linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%)' 
                      : 'transparent',
                    color: lang === option.code ? '#4f46e5' : 'white',
                    border: 'none',
                    borderRadius: '0.75rem',
                    cursor: 'pointer',
                    fontWeight: '600',
                    fontSize: '0.95rem',
                    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.5rem',
                    boxShadow: lang === option.code 
                      ? '0 4px 12px rgba(0,0,0,0.15)' 
                      : 'none',
                    transform: lang === option.code ? 'translateY(-1px)' : 'none'
                  }}
                  onMouseEnter={(e) => {
                    if (lang !== option.code) {
                      e.currentTarget.style.background = 'rgba(255, 255, 255, 0.15)'
                      e.currentTarget.style.transform = 'translateY(-1px)'
                    }
                  }}
                  onMouseLeave={(e) => {
                    if (lang !== option.code) {
                      e.currentTarget.style.background = 'transparent'
                      e.currentTarget.style.transform = 'none'
                    }
                  }}
                >
                  <span style={{ fontSize: '1.1em' }}>{option.flag}</span>
                  {option.name}
                </button>
              ))}
            </div>
          </header>

          {/* Contenu principal magnifique */}
          <main style={{ 
            textAlign: 'center', 
            padding: '2rem 0 4rem',
            animation: 'slideInFromBottom 0.8s ease-out 0.2s both'
          }}>
            <h2 style={{ 
              color: 'white', 
              fontSize: 'clamp(2.5rem, 8vw, 5rem)', 
              fontWeight: '700',
              marginBottom: '2rem',
              lineHeight: '1.1',
              margin: '0 0 2rem 0',
              textShadow: '0 4px 8px rgba(0,0,0,0.3)',
              letterSpacing: '-0.02em'
            }}>
              {t.subtitle}
            </h2>
            
            <p style={{ 
              color: 'rgba(255, 255, 255, 0.95)', 
              fontSize: 'clamp(1.1rem, 3vw, 1.4rem)',
              marginBottom: '3rem',
              maxWidth: '700px',
              margin: '0 auto 3rem auto',
              lineHeight: '1.7',
              textShadow: '0 2px 4px rgba(0,0,0,0.2)'
            }}>
              {t.description}
            </p>
            
            {/* Boutons d'action magnifiques */}
            <div style={{ 
              display: 'flex', 
              gap: '1.5rem', 
              justifyContent: 'center', 
              flexWrap: 'wrap',
              marginBottom: '4rem'
            }}>
              <button style={{
                background: 'linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%)',
                color: '#4f46e5',
                padding: '1.25rem 3rem',
                border: 'none',
                borderRadius: '1rem',
                fontSize: '1.1rem',
                fontWeight: '600',
                cursor: 'pointer',
                boxShadow: '0 8px 24px rgba(0, 0, 0, 0.15)',
                transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                textTransform: 'none'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.transform = 'translateY(-2px)'
                e.currentTarget.style.boxShadow = '0 12px 32px rgba(0, 0, 0, 0.2)'
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.transform = 'translateY(0)'
                e.currentTarget.style.boxShadow = '0 8px 24px rgba(0, 0, 0, 0.15)'
              }}>
                {t.start}
              </button>
              
              <button style={{
                background: 'rgba(255, 255, 255, 0.1)',
                color: 'white',
                padding: '1.25rem 3rem',
                border: '2px solid rgba(255, 255, 255, 0.3)',
                borderRadius: '1rem',
                fontSize: '1.1rem',
                fontWeight: '600',
                cursor: 'pointer',
                backdropFilter: 'blur(10px)',
                transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                textTransform: 'none'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = 'rgba(255, 255, 255, 0.2)'
                e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.5)'
                e.currentTarget.style.transform = 'translateY(-2px)'
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)'
                e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.3)'
                e.currentTarget.style.transform = 'translateY(0)'
              }}>
                {t.about}
              </button>
            </div>
          </main>

          {/* Features magnifiques */}
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', 
            gap: '2rem',
            marginTop: '4rem',
            animation: 'slideInFromBottom 1s ease-out 0.4s both'
          }}>
            {[
              { icon: '🧮', ...t.features.math },
              { icon: '🎮', ...t.features.fun },
              { icon: '💳', ...t.features.payment }
            ].map((feature, index) => (
              <div 
                key={index} 
                style={{ 
                  textAlign: 'center',
                  padding: '3rem 2rem',
                  background: 'rgba(255, 255, 255, 0.1)',
                  borderRadius: '1.5rem',
                  backdropFilter: 'blur(15px)',
                  border: '1px solid rgba(255, 255, 255, 0.2)',
                  boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
                  transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                  cursor: 'pointer'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.transform = 'translateY(-8px)'
                  e.currentTarget.style.boxShadow = '0 16px 48px rgba(0,0,0,0.15)'
                  e.currentTarget.style.background = 'rgba(255, 255, 255, 0.15)'
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.transform = 'translateY(0)'
                  e.currentTarget.style.boxShadow = '0 8px 32px rgba(0,0,0,0.1)'
                  e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)'
                }}
              >
                <div style={{ 
                  fontSize: '4rem', 
                  marginBottom: '1.5rem',
                  filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.2))'
                }}>
                  {feature.icon}
                </div>
                <h3 style={{ 
                  color: 'white', 
                  fontSize: '1.5rem', 
                  fontWeight: '700', 
                  marginBottom: '1rem',
                  margin: '0 0 1rem 0',
                  textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                }}>
                  {feature.title}
                </h3>
                <p style={{ 
                  color: 'rgba(255, 255, 255, 0.9)',
                  fontSize: '1.1rem',
                  lineHeight: '1.6',
                  margin: 0
                }}>
                  {feature.desc}
                </p>
              </div>
            ))}
          </div>

          {/* Footer magnifique */}
          <footer style={{ 
            textAlign: 'center', 
            marginTop: '6rem', 
            paddingTop: '3rem',
            borderTop: '1px solid rgba(255,255,255,0.2)',
            color: 'rgba(255, 255, 255, 0.9)',
            animation: 'fadeIn 1.2s ease-out 0.6s both'
          }}>
            <p style={{ 
              marginBottom: '1rem',
              fontSize: '1.1rem',
              margin: '0 0 1rem 0'
            }}>
              © 2024 Math4Child - Application éducative moderne
            </p>
            <p style={{ 
              color: '#10b981', 
              fontWeight: '600',
              fontSize: '1.2rem',
              textShadow: '0 2px 4px rgba(0,0,0,0.3)',
              margin: 0
            }}>
              ✅ Déployé avec succès sur Netlify !
            </p>
          </footer>
        </div>
      </div>
    </>
  )
}
