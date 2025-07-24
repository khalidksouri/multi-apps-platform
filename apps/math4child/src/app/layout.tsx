import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Application Éducative',
  description: 'Application éducative de mathématiques pour enfants avec jeux interactifs et suivi des progrès',
  keywords: ['mathématiques', 'enfants', 'éducation', 'jeux', 'apprentissage'],
  authors: [{ name: 'Math4Child Team' }],
  creator: 'Math4Child',
  publisher: 'Math4Child',
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
    },
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="icon" href="/favicon.ico" />
      </head>
      <body className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50">
        <div className="math4child-container">
          {children}
        </div>
      </body>
    </html>
  )
}
