export default function Home() {
  const styles = {
    container: {
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: 'Arial, sans-serif',
      backgroundColor: '#f0f2f5',
      padding: '20px'
    },
    title: {
      fontSize: '3rem',
      fontWeight: 'bold',
      color: '#1a365d',
      marginBottom: '1rem',
      textAlign: 'center'
    },
    subtitle: {
      fontSize: '1.5rem',
      color: '#4a5568',
      marginBottom: '2rem',
      textAlign: 'center',
      maxWidth: '600px'
    },
    button: {
      backgroundColor: '#4299e1',
      color: 'white',
      border: 'none',
      padding: '15px 30px',
      fontSize: '1.2rem',
      borderRadius: '8px',
      cursor: 'pointer',
      textDecoration: 'none',
      display: 'inline-block',
      marginTop: '1rem'
    },
    features: {
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
      gap: '20px',
      marginTop: '3rem',
      maxWidth: '800px'
    },
    feature: {
      backgroundColor: 'white',
      padding: '20px',
      borderRadius: '10px',
      textAlign: 'center',
      boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
    }
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.title}>🧮 Math4Child Beta</h1>
      <p style={styles.subtitle}>
        L'application révolutionnaire qui transforme l'apprentissage des mathématiques 
        en aventure ludique pour les enfants de 6 à 12 ans !
      </p>
      
      <a href="#demo" style={styles.button}>
        🚀 Commencer la Demo
      </a>
      
      <div style={styles.features}>
        <div style={styles.feature}>
          <h3>🌍 195+ Langues</h3>
          <p>Support multilingue complet</p>
        </div>
        <div style={styles.feature}>
          <h3>🎮 Adaptatif</h3>
          <p>S'adapte au niveau de l'enfant</p>
        </div>
        <div style={styles.feature}>
          <h3>📊 Suivi</h3>
          <p>Progression en temps réel</p>
        </div>
        <div style={styles.feature}>
          <h3>🏆 Récompenses</h3>
          <p>Système de motivation</p>
        </div>
      </div>
    </div>
  );
}
