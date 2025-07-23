import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { LanguageProvider } from '@/contexts/LanguageContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative moderne pour l\'apprentissage des mathématiques',
  keywords: 'mathématiques, éducation, enfants, apprentissage',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <LanguageProvider defaultLanguage="fr">
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
