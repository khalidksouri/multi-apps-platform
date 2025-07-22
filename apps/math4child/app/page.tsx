export default function Home() {
  return (
    <main>
      <div style={{ 
        padding: '3rem', 
        textAlign: 'center', 
        fontFamily: 'Arial, sans-serif',
        maxWidth: '600px',
        margin: '0 auto'
      }}>
        <h1 style={{ 
          fontSize: '3rem', 
          color: '#0066cc', 
          marginBottom: '1rem' 
        }}>
          Math4Child 🧮
        </h1>
        
        <p style={{ 
          fontSize: '1.2rem', 
          color: '#333', 
          marginBottom: '2rem' 
        }}>
          Application éducative pour enfants de 4 à 12 ans
        </p>
        
        <div style={{ 
          backgroundColor: '#f5f5f5', 
          padding: '2rem', 
          borderRadius: '8px',
          marginBottom: '2rem'
        }}>
          <h2 style={{ color: '#0066cc', marginBottom: '1rem' }}>
            Opérations disponibles :
          </h2>
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: '1fr 1fr', 
            gap: '1rem',
            fontSize: '1.1rem'
          }}>
            <div>➕ Addition</div>
            <div>➖ Soustraction</div>
            <div>✖️ Multiplication</div>
            <div>➗ Division</div>
          </div>
        </div>
        
        <div style={{ 
          backgroundColor: '#e7f3ff', 
          padding: '1.5rem', 
          borderRadius: '8px',
          border: '2px solid #0066cc'
        }}>
          <h3 style={{ color: '#0066cc', marginBottom: '1rem' }}>
            🎉 Site Déployé avec Succès !
          </h3>
          <p style={{ margin: 0, color: '#333' }}>
            Export statique Next.js sur Netlify<br/>
            Configuration : out/ → math4child.com
          </p>
        </div>
        
        <footer style={{ 
          marginTop: '3rem', 
          padding: '1rem', 
          fontSize: '0.9rem', 
          color: '#666',
          borderTop: '1px solid #eee'
        }}>
          <p>Math4Child - Version statique déployée manuellement</p>
          <p>Domaine : math4child.com | Hébergement : Netlify</p>
        </footer>
      </div>
    </main>
  )
}
