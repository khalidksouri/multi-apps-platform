import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import Footer from '@/components/layout/Footer'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '6 Innovations Révolutionnaires pour l\'apprentissage des mathématiques : IA Adaptative Avancée, Reconnaissance Manuscrite, Réalité Augmentée 3D, Assistant Vocal IA, Moteur d\'Exercices Révolutionnaire, Système Langues Universel. 200+ Langues supportées avec drapeaux spécifiques 🇲🇦🇵🇸. Prêt pour révolutionner l\'éducation mondiale !',
  keywords: [
    'Math4Child', 'v4.2.0', 'mathématiques', 'éducation', 'IA adaptative', 
    'reconnaissance manuscrite', 'réalité augmentée', 'assistant vocal',
    '200+ langues', 'révolution éducative', 'apprentissage', 'enfants'
  ].join(', '),
  authors: [{ name: 'Math4Child', email: 'support@math4child.com' }],
  creator: 'Math4Child',
  publisher: 'Math4Child',
  robots: 'index, follow',
  openGraph: {
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    description: '6 Innovations Révolutionnaires pour transformer l\'apprentissage des mathématiques',
    url: 'https://www.math4child.com',
    siteName: 'Math4Child',
    locale: 'fr_FR',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    description: '6 Innovations Révolutionnaires pour l\'apprentissage des mathématiques',
    creator: '@math4child',
  },
  viewport: 'width=device-width, initial-scale=1',
  themeColor: '#3B82F6',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <meta name="theme-color" content="#3B82F6" />
        <meta name="application-name" content="Math4Child" />
        <meta name="apple-mobile-web-app-title" content="Math4Child" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="mobile-web-app-capable" content="yes" />
      </head>
      <body className={inter.className}>
        <div className="min-h-screen flex flex-col">
          <main className="flex-grow">
            {children}
          </main>
          <Footer />
        </div>
      </body>
    </html>
  )
}
