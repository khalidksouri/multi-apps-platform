export default function Custom404() {
  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '100vh',
      fontFamily: 'Arial, sans-serif',
      textAlign: 'center',
      backgroundColor: '#f5f5f5'
    }}>
      <h1 style={{ fontSize: '4rem', margin: 0, color: '#333' }}>404</h1>
      <h2 style={{ fontSize: '1.5rem', margin: '1rem 0', color: '#666' }}>
        Page Non Trouvée
      </h2>
      <p style={{ fontSize: '1rem', color: '#999', maxWidth: '400px' }}>
        La page que vous cherchez n'existe pas ou a été déplacée.
      </p>
      <a 
        href="/" 
        style={{
          marginTop: '2rem',
          padding: '12px 24px',
          backgroundColor: '#0070f3',
          color: 'white',
          textDecoration: 'none',
          borderRadius: '6px',
          fontSize: '1rem'
        }}
      >
        Retour à l'accueil
      </a>
    </div>
  );
}

// Pas de getStaticProps pour éviter les erreurs de rendu
