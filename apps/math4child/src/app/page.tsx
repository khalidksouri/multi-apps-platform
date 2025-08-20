export default function HomePage() {
  return (
    <main style={{ 
      padding: '2rem', 
      textAlign: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      minHeight: '100vh',
      color: 'white'
    }}>
      <div style={{
        maxWidth: '800px',
        margin: '0 auto',
        padding: '40px',
        background: 'rgba(255,255,255,0.1)',
        borderRadius: '20px',
        backdropFilter: 'blur(10px)'
      }}>
        <h1 style={{ fontSize: '3rem', marginBottom: '20px' }}>
          🎯 Math4Child v4.2.0
        </h1>
        
        <div style={{ fontSize: '1.2rem', marginBottom: '30px' }}>
          Révolution Éducative Mondiale
        </div>
        
        <div style={{
          background: 'rgba(34, 197, 94, 0.2)',
          border: '2px solid #22c55e',
          padding: '20px',
          borderRadius: '15px',
          margin: '30px 0'
        }}>
          <div style={{ fontSize: '1.5rem', marginBottom: '10px' }}>
            🚀 Déploiement Production Réussi !
          </div>
          <div>La première application éducative révolutionnaire est maintenant en ligne</div>
        </div>
        
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
          gap: '20px',
          margin: '30px 0'
        }}>
          {[
            { emoji: '🧠', title: 'IA Adaptative', desc: 'Personnalisation intelligente' },
            { emoji: '✍️', title: 'Reconnaissance Manuscrite', desc: 'Écriture naturelle' },
            { emoji: '🎙️', title: 'Assistant Vocal IA', desc: '3 personnalités distinctes' },
            { emoji: '🥽', title: 'Réalité Augmentée 3D', desc: 'Apprentissage immersif' },
            { emoji: '🎮', title: 'Progression Gamifiée', desc: 'Motivation maximale' },
            { emoji: '🌍', title: '200+ Langues', desc: 'Accessibilité universelle' }
          ].map((innovation, index) => (
            <div key={index} style={{
              background: 'rgba(255,255,255,0.1)',
              padding: '20px',
              borderRadius: '15px',
              borderLeft: '4px solid #22c55e'
            }}>
              <div style={{ fontSize: '2rem', marginBottom: '10px' }}>{innovation.emoji}</div>
              <div><strong>{innovation.title}</strong></div>
              <div style={{ fontSize: '0.9rem', opacity: 0.8 }}>{innovation.desc}</div>
            </div>
          ))}
        </div>
        
        <div style={{
          display: 'flex',
          justifyContent: 'space-around',
          margin: '30px 0',
          flexWrap: 'wrap'
        }}>
          {[
            { number: '143/143', label: 'Tests Passent' },
            { number: '6', label: 'Innovations Révolutionnaires' },
            { number: '200+', label: 'Langues Supportées' },
            { number: '0', label: 'Erreurs TypeScript' }
          ].map((stat, index) => (
            <div key={index} style={{ textAlign: 'center', margin: '10px' }}>
              <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#22c55e' }}>
                {stat.number}
              </div>
              <div style={{ fontSize: '0.9rem' }}>{stat.label}</div>
            </div>
          ))}
        </div>
        
        <div style={{ marginTop: '40px', fontSize: '0.9rem', opacity: 0.8 }}>
          <div>Math4Child v4.2.0 - La Première Application Éducative Révolutionnaire</div>
          <div style={{ marginTop: '10px' }}>
            📧 support@math4child.com | 💼 commercial@math4child.com
          </div>
          <div style={{ marginTop: '10px' }}>
            🌐 Production Ready - Déploiement Automatisé Réussi
          </div>
        </div>
      </div>
    </main>
  )
}
