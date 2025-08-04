export default function Custom404() {
  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: 'system-ui, Arial, sans-serif',
      backgroundColor: '#f8fafc',
      textAlign: 'center'
    }}>
      <h1 style={{ fontSize: '4rem', margin: 0, color: '#e53e3e' }}>404</h1>
      <h2 style={{ fontSize: '1.5rem', margin: '1rem 0', color: '#4a5568' }}>
        Page Non Trouvée
      </h2>
      <a href="/" style={{
        backgroundColor: '#3b82f6',
        color: 'white',
        padding: '12px 24px',
        textDecoration: 'none',
        borderRadius: '6px'
      }}>
        Retour à l'accueil
      </a>
    </div>
  );
}
