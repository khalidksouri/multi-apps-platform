import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative moderne pour l\'apprentissage des mathématiques avec système de paiement optimisé',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>
        {children}
      </body>
    </html>
  )
}
