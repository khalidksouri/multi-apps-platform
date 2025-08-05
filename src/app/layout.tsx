import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative révolutionnaire pour enfants de 6 à 12 ans. 195+ langues, IA adaptative, 5 niveaux de progression.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, jeux éducatifs',
  authors: [{ name: 'GOTEST', url: 'https://www.math4child.com' }],
  creator: 'GOTEST (SIRET: 53958712100028)',
  publisher: 'GOTEST',
  openGraph: {
    title: 'Math4Child - Révolutionnons l\'apprentissage des mathématiques',
    description: 'L\'application qui transforme les mathématiques en aventure ludique pour tous les enfants',
    url: 'https://www.math4child.com',
    siteName: 'Math4Child',
    locale: 'fr_FR',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - Mathématiques pour Enfants',
    description: 'Apprentissage révolutionnaire des mathématiques',
    creator: '@Math4Child',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  verification: {
    google: 'votre-code-verification-google',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" className="scroll-smooth">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#667eea" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="format-detection" content="telephone=no" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="msapplication-TileColor" content="#667eea" />
        <meta name="msapplication-config" content="/browserconfig.xml" />
      </head>
      <body className={`${inter.className} antialiased`}>
        {children}
      </body>
    </html>
  )
}
