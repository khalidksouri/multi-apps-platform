import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative complète avec système de progression, exercices adaptatifs et support multilingue',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className="antialiased">{children}</body>
    </html>
  )
}
