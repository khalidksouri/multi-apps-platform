import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Apprentissage des Mathématiques',
  description: 'Application éducative pour apprendre les mathématiques de manière ludique',
  keywords: 'mathématiques, éducation, enfants, apprentissage',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
        <div id="root">
          {children}
        </div>
      </body>
    </html>
  )
}
