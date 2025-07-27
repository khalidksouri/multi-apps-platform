export default function NotFound() {
  return (
    <div style={{ 
      minHeight: '100vh', 
      display: 'flex', 
      alignItems: 'center', 
      justifyContent: 'center',
      flexDirection: 'column',
      fontFamily: 'system-ui, sans-serif'
    }}>
      <h1>404 - Page non trouvée</h1>
      <p>La page que vous cherchez n'existe pas.</p>
      <a href="/" style={{ color: '#0066cc', textDecoration: 'underline' }}>
        Retour à l'accueil
      </a>
    </div>
  )
}
