import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Application Éducative Mathématique',
  description: 'Application éducative moderne pour l\'apprentissage des mathématiques avec design interactif attrayant',
  keywords: ['mathématiques', 'enfants', 'éducation', 'apprentissage', 'IA'],
  authors: [{ name: 'Math4Child Team' }],
  robots: { index: true, follow: true },
  openGraph: {
    title: 'Math4Child v4.2.0',
    description: 'Application éducative révolutionnaire pour les mathématiques',
    url: 'https://www.math4child.com',
    type: 'website',
    locale: 'fr_FR',
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
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#3b82f6" />
      </head>
      <body className={`${inter.className} antialiased`}>
        {children}
      </body>
    </html>
  )
}
