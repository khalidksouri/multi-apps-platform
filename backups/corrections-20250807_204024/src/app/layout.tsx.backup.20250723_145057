import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import { LanguageProvider } from '../contexts/LanguageContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les maths en famille',
  description: "L'app éducative n°1 pour apprendre les mathématiques en s'amusant !",
  keywords: ['mathématiques', 'éducation', 'enfants', 'apprentissage', 'famille'],
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
  themeColor: '#667eea',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <LanguageProvider>
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
            {children}
          </div>
        </LanguageProvider>
      </body>
    </html>
  )
}
