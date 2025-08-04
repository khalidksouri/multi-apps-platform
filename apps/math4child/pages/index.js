export default function Home() {
  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: 'system-ui, Arial, sans-serif',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
      padding: '20px',
      textAlign: 'center'
    }}>
      <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>🧮</div>
      <h1 style={{ 
        fontSize: '3rem', 
        fontWeight: 'bold', 
        marginBottom: '1rem',
        textShadow: '2px 2px 4px rgba(0,0,0,0.3)'
      }}>
        Math4Child Beta
      </h1>
      <p style={{ 
        fontSize: '1.25rem', 
        maxWidth: '600px', 
        lineHeight: '1.6',
        marginBottom: '2rem',
        textShadow: '1px 1px 2px rgba(0,0,0,0.3)'
      }}>
        🌟 Programme Beta Exclusif ! 🌟<br/>
        L'application révolutionnaire qui transforme l'apprentissage des mathématiques 
        en aventure ludique pour les enfants de 6 à 12 ans.
      </p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
        gap: '20px',
        maxWidth: '800px',
        marginBottom: '3rem'
      }}>
        <div style={{
          backgroundColor: 'rgba(255,255,255,0.2)',
          padding: '20px',
          borderRadius: '15px',
          backdropFilter: 'blur(10px)'
        }}>
          <div style={{ fontSize: '2rem', marginBottom: '10px' }}>🌍</div>
          <h3>195+ Langues</h3>
          <p>Support multilingue complet avec RTL</p>
        </div>
        
        <div style={{
          backgroundColor: 'rgba(255,255,255,0.2)',
          padding: '20px',
          borderRadius: '15px',
          backdropFilter: 'blur(10px)'
        }}>
          <div style={{ fontSize: '2rem', marginBottom: '10px' }}>🎮</div>
          <h3>IA Adaptative</h3>
          <p>S'adapte au niveau de chaque enfant</p>
        </div>
        
        <div style={{
          backgroundColor: 'rgba(255,255,255,0.2)',
          padding: '20px',
          borderRadius: '15px',
          backdropFilter: 'blur(10px)'
        }}>
          <div style={{ fontSize: '2rem', marginBottom: '10px' }}>📊</div>
          <h3>Suivi Temps Réel</h3>
          <p>Dashboard parent complet</p>
        </div>
        
        <div style={{
          backgroundColor: 'rgba(255,255,255,0.2)',
          padding: '20px',
          borderRadius: '15px',
          backdropFilter: 'blur(10px)'
        }}>
          <div style={{ fontSize: '2rem', marginBottom: '10px' }}>🏆</div>
          <h3>Gamification</h3>
          <p>Récompenses et achievements</p>
        </div>
      </div>

      <div style={{
        backgroundColor: 'rgba(255,255,255,0.15)',
        padding: '30px',
        borderRadius: '20px',
        backdropFilter: 'blur(15px)',
        border: '1px solid rgba(255,255,255,0.2)',
        maxWidth: '500px'
      }}>
        <h2 style={{ marginBottom: '20px', fontSize: '1.5rem' }}>
          🎁 Avantages Beta Testeur
        </h2>
        <ul style={{ textAlign: 'left', lineHeight: '1.8' }}>
          <li>✅ 3 mois Premium GRATUIT</li>
          <li>✅ Contact direct équipe GOTEST</li>
          <li>✅ Badge exclusif permanent</li>
          <li>✅ 50% réduction à vie</li>
          <li>✅ Influence sur l'app finale</li>
        </ul>
        
        <a 
          href="mailto:gotesttech@gmail.com?subject=Candidature%20Beta%20Math4Child&body=Bonjour,%0D%0A%0D%0AJe%20souhaite%20participer%20au%20programme%20beta%20Math4Child.%0D%0A%0D%0AInformations%20famille:%0D%0A-%20Nom:%0D%0A-%20Email:%0D%0A-%20Âge%20enfant(s):%0D%0A-%20Équipement%20(Android/iOS/Web):%0D%0A-%20Motivation:%0D%0A%0D%0AMerci%20!"
          style={{
            display: 'inline-block',
            marginTop: '20px',
            padding: '15px 30px',
            backgroundColor: '#ff6b6b',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '30px',
            fontSize: '1.1rem',
            fontWeight: 'bold',
            boxShadow: '0 4px 15px rgba(0,0,0,0.2)',
            transition: 'transform 0.2s'
          }}
          onMouseOver={(e) => e.target.style.transform = 'scale(1.05)'}
          onMouseOut={(e) => e.target.style.transform = 'scale(1)'}
        >
          📧 Rejoindre la Beta (50 places)
        </a>
      </div>
      
      <div style={{ 
        marginTop: '3rem', 
        fontSize: '0.9rem', 
        opacity: 0.8 
      }}>
        Développé par GOTEST (SIRET: 53958712100028)<br/>
        Contact: gotesttech@gmail.com
      </div>
    </div>
  );
}

export function getStaticProps() {
  return {
    props: {},
  };
}
