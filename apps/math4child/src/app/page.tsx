export default function HomePage() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem'
    }}>
      <div style={{
        textAlign: 'center',
        color: 'white',
        maxWidth: '600px'
      }}>
        <h1 style={{ 
          fontSize: 'clamp(2rem, 8vw, 4rem)', 
          fontWeight: 'bold',
          marginBottom: '2rem',
          margin: '0 0 2rem 0'
        }}>
          Math4Child
        </h1>
        
        <h2 style={{ 
          fontSize: 'clamp(1.2rem, 4vw, 2rem)', 
          marginBottom: '2rem',
          margin: '0 0 2rem 0',
          opacity: 0.95
        }}>
          Apprendre les mathématiques en s'amusant
        </h2>
        
        <p style={{ 
          fontSize: 'clamp(1rem, 3vw, 1.3rem)', 
          marginBottom: '3rem',
          margin: '0 0 3rem 0',
          lineHeight: '1.6',
          opacity: 0.9
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
            Commencer
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
            En savoir plus
          </button>
        </div>
        
        <div style={{ 
          marginTop: '4rem',
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
          gap: '2rem'
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🧮</div>
            <h3 style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>Mathématiques</h3>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🎮</div>
            <h3 style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>Ludique</h3>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>💳</div>
            <h3 style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>Paiement</h3>
          </div>
        </div>
        
        <footer style={{ 
          marginTop: '4rem',
          paddingTop: '2rem',
          borderTop: '1px solid rgba(255,255,255,0.3)',
          fontSize: '0.9rem',
          opacity: 0.8
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
