import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { LanguageProvider } from '@/contexts/LanguageContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - App éducative pour apprendre les maths',
  description: 'L\'application éducative n°1 pour apprendre les mathématiques en famille. Plus de 195 langues supportées.',
  keywords: 'mathématiques, éducation, enfants, famille, apprentissage, jeux éducatifs',
  authors: [{ name: 'GOTEST', url: 'https://math4child.com' }],
  creator: 'GOTEST',
  publisher: 'GOTEST',
  robots: 'index, follow',
  openGraph: {
    title: 'Math4Child - App éducative pour apprendre les maths',
    description: 'L\'application éducative n°1 pour apprendre les mathématiques en famille.',
    url: 'https://math4child.com',
    siteName: 'Math4Child',
    locale: 'fr_FR',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - App éducative pour apprendre les maths',
    description: 'L\'application éducative n°1 pour apprendre les mathématiques en famille.',
  },
  icons: {
    icon: '/favicon.ico',
    apple: '/apple-touch-icon.png',
  },
  manifest: '/manifest.json',
  other: {
    'apple-mobile-web-app-capable': 'yes',
    'apple-mobile-web-app-status-bar-style': 'default',
    'apple-mobile-web-app-title': 'Math4Child',
  }
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
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
