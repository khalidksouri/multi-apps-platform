import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: 'La première application éducative révolutionnaire',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>
        <nav style={{ padding: '1rem', background: '#667eea', color: 'white' }}>
          <h1>Math4Child v4.2.0</h1>
        </nav>
        {children}
      </body>
    </html>
  )
}
