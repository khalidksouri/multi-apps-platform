export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'Arial, sans-serif' }}>
      <h1 style={{ color: '#0066cc' }}>Math4Child 🧮</h1>
      <p>Application éducative pour enfants</p>
      <div style={{ marginTop: '2rem' }}>
        <h2>Opérations disponibles :</h2>
        <ul>
          <li>Addition</li>
          <li>Soustraction</li>
          <li>Multiplication</li>
          <li>Division</li>
        </ul>
      </div>
      <footer style={{ marginTop: '3rem', color: '#666' }}>
        <p>Math4Child - Version simple déployée manuellement</p>
      </footer>
    </main>
  )
}
