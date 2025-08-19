import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import Navigation from '@/components/navigation/Navigation'
import LanguageProvider from '@/components/language/LanguageProvider'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprentissage Mathématique Révolutionnaire',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques avec IA adaptative, reconnaissance manuscrite et réalité augmentée.',
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
          <Navigation />
          <main className="min-h-screen bg-gray-50">
            {children}
          </main>
        </LanguageProvider>
      </body>
    </html>
  )
}
