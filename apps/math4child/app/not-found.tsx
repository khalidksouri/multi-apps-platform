export default function NotFound() {
  return (
    <html>
      <body>
        <div style={{ padding: '2rem', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
          <h1>Math4Child 🧮</h1>
          <h2>Page d'accueil</h2>
          <p>Application éducative pour enfants</p>
          <div style={{ marginTop: '2rem' }}>
            <h3>Opérations disponibles :</h3>
            <ul style={{ listStyle: 'none', padding: 0 }}>
              <li>➕ Addition</li>
              <li>➖ Soustraction</li>
              <li>✖️ Multiplication</li>
              <li>➗ Division</li>
            </ul>
          </div>
          <div style={{ marginTop: '2rem', fontSize: '0.9em', color: '#666' }}>
            <p>Math4Child - Application déployée sur Netlify</p>
          </div>
        </div>
      </body>
    </html>
  )
}
