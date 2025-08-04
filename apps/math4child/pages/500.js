export default function Custom500() {
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
      <h1 style={{ fontSize: '4rem', margin: 0, color: '#e53e3e' }}>500</h1>
      <h2 style={{ fontSize: '1.5rem', margin: '1rem 0', color: '#666' }}>
        Erreur Serveur
      </h2>
      <p style={{ fontSize: '1rem', color: '#999', maxWidth: '400px' }}>
        Une erreur s'est produite sur le serveur. Veuillez réessayer plus tard.
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
