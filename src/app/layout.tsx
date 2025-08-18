import type { Metadata, Viewport } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import Header from '@/components/layout/Header'
import Footer from '@/components/layout/Footer'

const inter = Inter({ subsets: ['latin'] })

// ✅ Metadata Math4Child v4.2.0
export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '6 Innovations Révolutionnaires pour l\'apprentissage des mathématiques : IA Adaptative Avancée, Reconnaissance Manuscrite, Réalité Augmentée 3D, Assistant Vocal IA, Moteur d\'Exercices Révolutionnaire, Système Langues Universel. 200+ Langues supportées avec drapeaux spécifiques 🇲🇦🇵🇸. Prêt pour révolutionner l\'éducation mondiale !',
  keywords: [
    'Math4Child', 'v4.2.0', 'mathématiques', 'éducation', 'IA adaptative', 
    'reconnaissance manuscrite', 'réalité augmentée', 'assistant vocal',
    '200+ langues', 'révolution éducative', 'apprentissage', 'enfants'
  ].join(', '),
  authors: [{ name: 'Math4Child' }],
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
}

// ✅ Viewport séparé selon Next.js 14
export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  themeColor: '#3B82F6',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <div className="min-h-screen flex flex-col">
          {/* ✅ HEADER AJOUTÉ */}
          <Header />
          
          {/* Contenu principal */}
          <main className="flex-grow">
            {children}
          </main>
          
          {/* Footer */}
          <Footer />
        </div>
      </body>
    </html>
  )
}
