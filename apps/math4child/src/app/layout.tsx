import { ReactNode } from 'react'

export const metadata = {
  title: 'Math4Child - Application Éducative',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="fr">
      <body style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>
        <header style={{
          background: 'white',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
          padding: '1rem 2rem',
          borderBottom: '4px solid #3b82f6'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <div style={{
                width: '40px',
                height: '40px',
                background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                borderRadius: '8px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: 'white',
                fontWeight: 'bold'
              }}>
                M4C
              </div>
              <div>
                <h1 style={{ margin: 0, fontSize: '1.5rem', color: '#1f2937' }}>Math4Child</h1>
                <p style={{ margin: 0, fontSize: '0.75rem', color: '#6b7280' }}>Apprendre en s'amusant</p>
              </div>
            </div>
            
            <nav style={{ display: 'flex', gap: '2rem' }}>
              <a href="/exercises" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                🧮 Exercices
              </a>
              <a href="/subscription" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                💎 Abonnement
              </a>
              <a href="/dashboard" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                📊 Tableau de bord
              </a>
            </nav>
            
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <span style={{
                background: '#f3f4f6',
                color: '#374151',
                padding: '0.25rem 0.75rem',
                borderRadius: '1rem',
                fontSize: '0.75rem',
                fontWeight: '500'
              }}>
                Gratuit
              </span>
              <select style={{ padding: '0.25rem 0.5rem', borderRadius: '0.375rem', border: '1px solid #d1d5db' }}>
                <option value="fr">🇫🇷 FR</option>
                <option value="en">🇺🇸 EN</option>
                <option value="es">🇪🇸 ES</option>
                <option value="ar">🇲🇦 AR</option>
              </select>
            </div>
          </div>
        </header>
        
        <main style={{ minHeight: 'calc(100vh - 140px)' }}>
          {children}
        </main>
        
        <footer style={{
          background: '#1f2937',
          color: 'white',
          padding: '2rem',
          textAlign: 'center'
        }}>
          <p>© 2024 Math4Child. Application éducative révolutionnaire.</p>
        </footer>
      </body>
    </html>
  )
}
