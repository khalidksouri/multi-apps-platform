export default function NotFound() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem'
    }}>
      <div style={{ textAlign: 'center', color: 'white' }}>
        <h1 style={{ 
          fontSize: '6rem', 
          fontWeight: 'bold', 
          marginBottom: '1rem',
          margin: '0 0 1rem 0'
        }}>
          404
        </h1>
        <h2 style={{ 
          fontSize: '2rem', 
          marginBottom: '1rem',
          margin: '0 0 1rem 0'
        }}>
          Page non trouvée
        </h2>
        <p style={{ 
          fontSize: '1.2rem', 
          marginBottom: '2rem',
          margin: '0 0 2rem 0',
          opacity: 0.9
        }}>
          La page que vous cherchez n'existe pas.
        </p>
        <a 
          href="/"
          style={{
            backgroundColor: 'white',
            color: '#2563eb',
            padding: '0.75rem 1.5rem',
            borderRadius: '0.5rem',
            textDecoration: 'none',
            fontWeight: '600',
            display: 'inline-block'
          }}
        >
          Retour à l'accueil
        </a>
      </div>
    </div>
  )
}
