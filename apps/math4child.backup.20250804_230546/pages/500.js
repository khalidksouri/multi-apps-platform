export default function Custom500() {
  const styles = {
    container: {
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: 'Arial, sans-serif',
      backgroundColor: '#f7fafc',
      textAlign: 'center'
    },
    title: { fontSize: '4rem', margin: 0, color: '#e53e3e' },
    subtitle: { fontSize: '1.5rem', margin: '1rem 0', color: '#4a5568' },
    text: { fontSize: '1rem', color: '#718096', marginBottom: '2rem' },
    button: {
      backgroundColor: '#4299e1',
      color: 'white',
      padding: '12px 24px',
      textDecoration: 'none',
      borderRadius: '6px',
      fontSize: '1rem'
    }
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.title}>500</h1>
      <h2 style={styles.subtitle}>Erreur Serveur</h2>
      <p style={styles.text}>Une erreur temporaire s'est produite.</p>
      <a href="/" style={styles.button}>Retour à l'accueil</a>
    </div>
  );
}
