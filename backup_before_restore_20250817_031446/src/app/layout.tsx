import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import Footer from '../components/layout/Footer'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '6 Innovations Révolutionnaires pour l\'apprentissage des mathématiques - IA Adaptative, Reconnaissance Manuscrite, Réalité Augmentée 3D, Assistant Vocal IA, Moteur d\'Exercices, Système Langues Universel - 200+ Langues supportées',
  keywords: 'Math4Child, v4.2.0, mathématiques, éducation, IA adaptative, 200+ langues',
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
