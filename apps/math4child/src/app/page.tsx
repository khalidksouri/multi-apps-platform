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
      start: 'Commencer gratuitement',
      about: 'En savoir plus',
      pricing_title: 'Choisissez votre plan',
      pricing_subtitle: 'Plans compétitifs avec essai gratuit - Annulation facile',
      features: {
        math: { title: 'Mathématiques', desc: 'Exercices adaptés à chaque niveau' },
        fun: { title: 'Ludique', desc: 'Apprendre en s\'amusant' },
        payment: { title: 'Paiement Sécurisé', desc: 'Système multi-provider' },
        progress: { title: 'Suivi de progrès', desc: 'Statistiques détaillées et rapports' },
        multilang: { title: 'Multilingue', desc: 'Support de 195+ langues' },
        offline: { title: 'Mode hors ligne', desc: 'Accès sans connexion internet' }
      },
      plans: {
        free: { name: 'Gratuit', price: '0€', period: '/mois', features: ['Support communautaire', 'Mode hors ligne limité', 'Exercices de base'] },
        trial7: { name: 'Essai 7 jours', price: 'Gratuit', period: '', features: ['Questions illimitées', 'Tous les niveaux', 'Support prioritaire'] },
        trial14: { name: 'Essai 14 jours', price: 'Gratuit', period: '', features: ['Questions illimitées', 'Tous les niveaux', 'Statistiques avancées'] },
        premium: { name: 'Premium', price: '9,99€', period: '/mois', features: ['Accès complet', 'Support prioritaire', 'Nouvelles fonctionnalités'] }
      },
      guarantees: {
        secure: { title: 'Paiement sécurisé', desc: 'Chiffrement SSL 256-bit' },
        cancel: { title: 'Annulation facile', desc: 'Résiliez à tout moment' },
        satisfaction: { title: 'Satisfaction garantie', desc: '30 jours satisfait ou remboursé' }
      }
    },
    en: { 
      title: 'Math4Child', 
      subtitle: 'Learn mathematics while having fun',
      description: 'A modern educational application to learn mathematics with pleasure and efficiency.',
      start: 'Start for free',
      about: 'Learn more',
      pricing_title: 'Choose your plan',
      pricing_subtitle: 'Competitive plans with free trial - Easy cancellation',
      features: {
        math: { title: 'Mathematics', desc: 'Exercises adapted to each level' },
        fun: { title: 'Fun Learning', desc: 'Learn while having fun' },
        payment: { title: 'Secure Payment', desc: 'Multi-provider system' },
        progress: { title: 'Progress Tracking', desc: 'Detailed statistics and reports' },
        multilang: { title: 'Multilingual', desc: 'Support for 195+ languages' },
        offline: { title: 'Offline Mode', desc: 'Access without internet connection' }
      },
      plans: {
        free: { name: 'Free', price: '€0', period: '/month', features: ['Community support', 'Limited offline mode', 'Basic exercises'] },
        trial7: { name: '7-day Trial', price: 'Free', period: '', features: ['Unlimited questions', 'All levels', 'Priority support'] },
        trial14: { name: '14-day Trial', price: 'Free', period: '', features: ['Unlimited questions', 'All levels', 'Advanced statistics'] },
        premium: { name: 'Premium', price: '€9.99', period: '/month', features: ['Full access', 'Priority support', 'New features first'] }
      },
      guarantees: {
        secure: { title: 'Secure Payment', desc: '256-bit SSL encryption' },
        cancel: { title: 'Easy Cancellation', desc: 'Cancel anytime' },
        satisfaction: { title: 'Satisfaction Guaranteed', desc: '30-day money back guarantee' }
      }
    },
    es: { 
      title: 'Math4Child', 
      subtitle: 'Aprende matemáticas divirtiéndote',
      description: 'Una aplicación educativa moderna para aprender matemáticas con placer y eficiencia.',
      start: 'Empezar gratis',
      about: 'Saber más',
      pricing_title: 'Elige tu plan',
      pricing_subtitle: 'Planes competitivos con prueba gratuita - Cancelación fácil',
      features: {
        math: { title: 'Matemáticas', desc: 'Ejercicios adaptados a cada nivel' },
        fun: { title: 'Lúdico', desc: 'Aprender divirtiéndose' },
        payment: { title: 'Pago Seguro', desc: 'Sistema multi-proveedor' },
        progress: { title: 'Seguimiento', desc: 'Estadísticas detalladas e informes' },
        multilang: { title: 'Multiidioma', desc: 'Soporte para 195+ idiomas' },
        offline: { title: 'Modo sin conexión', desc: 'Acceso sin conexión a internet' }
      },
      plans: {
        free: { name: 'Gratis', price: '0€', period: '/mes', features: ['Soporte comunitario', 'Modo sin conexión limitado', 'Ejercicios básicos'] },
        trial7: { name: 'Prueba 7 días', price: 'Gratis', period: '', features: ['Preguntas ilimitadas', 'Todos los niveles', 'Soporte prioritario'] },
        trial14: { name: 'Prueba 14 días', price: 'Gratis', period: '', features: ['Preguntas ilimitadas', 'Todos los niveles', 'Estadísticas avanzadas'] },
        premium: { name: 'Premium', price: '9,99€', period: '/mes', features: ['Acceso completo', 'Soporte prioritario', 'Nuevas funciones primero'] }
      },
      guarantees: {
        secure: { title: 'Pago Seguro', desc: 'Cifrado SSL de 256 bits' },
        cancel: { title: 'Cancelación Fácil', desc: 'Cancela en cualquier momento' },
        satisfaction: { title: 'Satisfacción Garantizada', desc: 'Garantía de devolución de 30 días' }
      }
    }
  }

  const t = texts[lang as keyof typeof texts] || texts.fr

  const languageOptions = [
    { code: 'fr', flag: '🇫🇷', name: 'FR' },
    { code: 'en', flag: '🇺🇸', name: 'EN' },  
    { code: 'es', flag: '🇪🇸', name: 'ES' }
  ]

  const handleSubscription = (plan: string) => {
    console.log(`Selected plan: ${plan}`)
    // Logique de paiement ici
  }

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
        @keyframes float {
          0%, 100% { transform: translateY(-10px); }
          50% { transform: translateY(10px); }
        }
      `}</style>

      <div style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
        lineHeight: '1.6'
      }}>
        {/* Header */}
        <header style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          padding: '2rem',
          maxWidth: '1200px',
          margin: '0 auto',
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
          
          {/* Sélecteur de langue glassmorphism */}
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

        <div style={{ padding: '0 2rem' }}>
          <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
            
            {/* Hero Section */}
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
              
              {/* Boutons CTA */}
              <div style={{ 
                display: 'flex', 
                gap: '1.5rem', 
                justifyContent: 'center', 
                flexWrap: 'wrap',
                marginBottom: '4rem'
              }}>
                <button 
                  onClick={() => handleSubscription('free')}
                  style={{
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
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.5rem'
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.transform = 'translateY(-2px)'
                    e.currentTarget.style.boxShadow = '0 12px 32px rgba(0, 0, 0, 0.2)'
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.transform = 'translateY(0)'
                    e.currentTarget.style.boxShadow = '0 8px 24px rgba(0, 0, 0, 0.15)'
                  }}
                >
                  <span>🎁</span>
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
                  transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
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

            {/* Section Pricing */}
            <section style={{ 
              marginBottom: '6rem',
              animation: 'fadeIn 1s ease-out 0.4s both'
            }}>
              <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
                <h3 style={{
                  color: 'white',
                  fontSize: 'clamp(2rem, 5vw, 3rem)',
                  fontWeight: '700',
                  marginBottom: '1rem',
                  textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                }}>
                  {t.pricing_title}
                </h3>
                <p style={{
                  color: 'rgba(255, 255, 255, 0.9)',
                  fontSize: '1.2rem',
                  maxWidth: '600px',
                  margin: '0 auto'
                }}>
                  {t.pricing_subtitle}
                </p>
              </div>

              {/* Plans de pricing */}
              <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
                gap: '2rem',
                marginBottom: '4rem'
              }}>
                {Object.entries(t.plans).map(([planKey, plan], index) => (
                  <div
                    key={planKey}
                    style={{
                      background: planKey === 'premium' 
                        ? 'linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%)'
                        : 'rgba(255, 255, 255, 0.1)',
                      borderRadius: '1.5rem',
                      padding: '2.5rem 2rem',
                      backdropFilter: 'blur(15px)',
                      border: planKey === 'premium' 
                        ? '2px solid rgba(255, 215, 0, 0.3)'
                        : '1px solid rgba(255, 255, 255, 0.2)',
                      boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
                      position: 'relative',
                      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                      cursor: 'pointer',
                      textAlign: 'center',
                      color: 'white',
                      animation: `slideInFromBottom 0.8s ease-out ${0.5 + index * 0.1}s both`
                    }}
                    onMouseEnter={(e) => {
                      e.currentTarget.style.transform = 'translateY(-8px)'
                      e.currentTarget.style.boxShadow = '0 16px 48px rgba(0,0,0,0.15)'
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.transform = 'translateY(0)'
                      e.currentTarget.style.boxShadow = '0 8px 32px rgba(0,0,0,0.1)'
                    }}
                  >
                    {planKey === 'premium' && (
                      <div style={{
                        position: 'absolute',
                        top: '-10px',
                        left: '50%',
                        transform: 'translateX(-50%)',
                        background: 'linear-gradient(45deg, #FFD700, #FFA500)',
                        color: '#333',
                        padding: '0.5rem 1rem',
                        borderRadius: '1rem',
                        fontSize: '0.8rem',
                        fontWeight: '700',
                        boxShadow: '0 4px 12px rgba(255, 215, 0, 0.3)'
                      }}>
                        ⭐ POPULAIRE
                      </div>
                    )}
                    
                    <h4 style={{
                      fontSize: '1.5rem',
                      fontWeight: '700',
                      marginBottom: '1rem',
                      textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                    }}>
                      {plan.name}
                    </h4>
                    
                    <div style={{ marginBottom: '2rem' }}>
                      <span style={{
                        fontSize: '2.5rem',
                        fontWeight: '800',
                        textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                      }}>
                        {plan.price}
                      </span>
                      <span style={{
                        fontSize: '1rem',
                        opacity: 0.8
                      }}>
                        {plan.period}
                      </span>
                    </div>
                    
                    <ul style={{
                      listStyle: 'none',
                      padding: 0,
                      marginBottom: '2rem',
                      textAlign: 'left'
                    }}>
                      {plan.features.map((feature, i) => (
                        <li key={i} style={{
                          display: 'flex',
                          alignItems: 'center',
                          gap: '0.5rem',
                          marginBottom: '0.75rem',
                          fontSize: '0.95rem'
                        }}>
                          <span style={{ color: '#10b981', fontSize: '1.2em' }}>✓</span>
                          {feature}
                        </li>
                      ))}
                    </ul>
                    
                    <button
                      onClick={() => handleSubscription(planKey)}
                      style={{
                        width: '100%',
                        padding: '1rem',
                        background: planKey === 'premium'
                          ? 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                          : planKey.includes('trial')
                          ? 'linear-gradient(135deg, #10b981 0%, #059669 100%)'
                          : 'rgba(255, 255, 255, 0.2)',
                        color: 'white',
                        border: 'none',
                        borderRadius: '0.75rem',
                        fontSize: '1rem',
                        fontWeight: '600',
                        cursor: 'pointer',
                        transition: 'all 0.3s ease',
                        boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
                      }}
                      onMouseEnter={(e) => {
                        e.currentTarget.style.transform = 'translateY(-2px)'
                        e.currentTarget.style.boxShadow = '0 8px 24px rgba(0,0,0,0.2)'
                      }}
                      onMouseLeave={(e) => {
                        e.currentTarget.style.transform = 'translateY(0)'
                        e.currentTarget.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)'
                      }}
                    >
                      {planKey.includes('trial') ? 'Essai gratuit' : planKey === 'free' ? 'Commencer' : 'Choisir Premium'}
                    </button>
                  </div>
                ))}
              </div>
            </section>

            {/* Features complètes */}
            <section style={{ 
              marginBottom: '6rem',
              animation: 'slideInFromBottom 1s ease-out 0.6s both'
            }}>
              <div style={{
                textAlign: 'center',
                marginBottom: '3rem'
              }}>
                <h3 style={{
                  color: 'white',
                  fontSize: 'clamp(2rem, 5vw, 3rem)',
                  fontWeight: '700',
                  marginBottom: '1rem',
                  textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                }}>
                  Fonctionnalités complètes
                </h3>
              </div>

              <div style={{ 
                display: 'grid', 
                gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
                gap: '2rem'
              }}>
                {Object.values(t.features).map((feature, index) => (
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
                      cursor: 'pointer',
                      color: 'white',
                      animation: `slideInFromBottom 0.8s ease-out ${0.7 + index * 0.1}s both`
                    }}
                    onMouseEnter={(e) => {
                      e.currentTarget.style.transform = 'translateY(-8px) scale(1.02)'
                      e.currentTarget.style.boxShadow = '0 16px 48px rgba(0,0,0,0.15)'
                      e.currentTarget.style.background = 'rgba(255, 255, 255, 0.15)'
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.transform = 'translateY(0) scale(1)'
                      e.currentTarget.style.boxShadow = '0 8px 32px rgba(0,0,0,0.1)'
                      e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)'
                    }}
                  >
                    <div style={{ 
                      fontSize: '4rem', 
                      marginBottom: '1.5rem',
                      filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.2))',
                      animation: 'float 3s ease-in-out infinite'
                    }}>
                      {index === 0 && '🧮'}
                      {index === 1 && '🎮'}
                      {index === 2 && '💳'}
                      {index === 3 && '📊'}
                      {index === 4 && '🌍'}
                      {index === 5 && '📱'}
                    </div>
                    <h4 style={{ 
                      fontSize: '1.5rem', 
                      fontWeight: '700', 
                      marginBottom: '1rem',
                      textShadow: '0 2px 4px rgba(0,0,0,0.3)'
                    }}>
                      {feature.title}
                    </h4>
                    <p style={{ 
                      color: 'rgba(255, 255, 255, 0.9)',
                      fontSize: '1.1rem',
                      lineHeight: '1.6'
                    }}>
                      {feature.desc}
                    </p>
                  </div>
                ))}
              </div>
            </section>

            {/* Garanties */}
            <section style={{
              marginBottom: '4rem',
              animation: 'fadeIn 1.2s ease-out 0.8s both'
            }}>
              <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
                gap: '2rem',
                textAlign: 'center'
              }}>
                {Object.values(t.guarantees).map((guarantee, index) => (
                  <div key={index} style={{
                    color: 'rgba(255, 255, 255, 0.9)',
                    padding: '2rem'
                  }}>
                    <div style={{ 
                      fontSize: '3rem', 
                      marginBottom: '1rem',
                      filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.3))'
                    }}>
                      {index === 0 && '🔒'}
                      {index === 1 && '↩️'}
                      {index === 2 && '✨'}
                    </div>
                    <h4 style={{ 
                      fontWeight: '600', 
                      marginBottom: '0.5rem',
                      fontSize: '1.2rem',
                      textShadow: '0 1px 2px rgba(0,0,0,0.3)'
                    }}>
                      {guarantee.title}
                    </h4>
                    <p style={{ fontSize: '0.95rem', opacity: 0.8 }}>
                      {guarantee.desc}
                    </p>
                  </div>
                ))}
              </div>
            </section>

            {/* Footer complet */}
            <footer style={{ 
              textAlign: 'center', 
              paddingTop: '3rem',
              borderTop: '1px solid rgba(255,255,255,0.2)',
              color: 'rgba(255, 255, 255, 0.9)',
              animation: 'fadeIn 1.4s ease-out 1s both'
            }}>
              <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
                gap: '2rem',
                marginBottom: '2rem',
                textAlign: 'left'
              }}>
                <div>
                  <h5 style={{ 
                    fontWeight: '600', 
                    marginBottom: '1rem',
                    color: 'white',
                    fontSize: '1.1rem'
                  }}>
                    Math4Child
                  </h5>
                  <p style={{ fontSize: '0.9rem', opacity: 0.8, lineHeight: '1.6' }}>
                    L'application éducative qui rend l'apprentissage des mathématiques amusant et efficace pour tous les enfants.
                  </p>
                </div>
                <div>
                  <h5 style={{ 
                    fontWeight: '600', 
                    marginBottom: '1rem',
                    color: 'white',
                    fontSize: '1.1rem'
                  }}>
                    Support
                  </h5>
                  <ul style={{ 
                    listStyle: 'none', 
                    padding: 0,
                    fontSize: '0.9rem',
                    opacity: 0.8,
                    lineHeight: '2'
                  }}>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>Centre d'aide</a></li>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>Nous contacter</a></li>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>FAQ</a></li>
                  </ul>
                </div>
                <div>
                  <h5 style={{ 
                    fontWeight: '600', 
                    marginBottom: '1rem',
                    color: 'white',
                    fontSize: '1.1rem'
                  }}>
                    Légal
                  </h5>
                  <ul style={{ 
                    listStyle: 'none', 
                    padding: 0,
                    fontSize: '0.9rem',
                    opacity: 0.8,
                    lineHeight: '2'
                  }}>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>Conditions d'utilisation</a></li>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>Politique de confidentialité</a></li>
                    <li><a href="#" style={{ color: 'inherit', textDecoration: 'none' }}>Cookies</a></li>
                  </ul>
                </div>
              </div>
              
              <div style={{ 
                borderTop: '1px solid rgba(255,255,255,0.1)',
                paddingTop: '2rem',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                flexWrap: 'wrap',
                gap: '1rem'
              }}>
                <p style={{ 
                  fontSize: '0.9rem',
                  margin: 0
                }}>
                  © 2024 Math4Child - Application éducative moderne
                </p>
                <p style={{ 
                  color: '#10b981', 
                  fontWeight: '600',
                  fontSize: '1rem',
                  textShadow: '0 2px 4px rgba(0,0,0,0.3)',
                  margin: 0
                }}>
                  ✅ Déployé avec succès sur Netlify !
                </p>
              </div>
            </footer>
          </div>
        </div>
      </div>
    </>
  )
}
