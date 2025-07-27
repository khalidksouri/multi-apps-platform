import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter'
})

export const metadata: Metadata = {
  title: 'Math4Child - L\'app éducative n°1 pour apprendre les maths en famille',
  description: 'Plus de 100k familles nous font confiance pour l\'apprentissage ludique des mathématiques. 195+ langues supportées, jeux interactifs, progression adaptative.',
  keywords: 'mathématiques, éducation, enfants, famille, apprentissage, jeux éducatifs, maths, calcul',
  authors: [{ name: 'GOTEST', url: 'https://gotest.fr' }],
  creator: 'GOTEST',
  publisher: 'GOTEST',
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  metadataBase: new URL('https://math4child.com'),
  alternates: {
    canonical: '/',
    languages: {
      'en-US': '/en',
      'fr-FR': '/fr',
      'es-ES': '/es',
      'de-DE': '/de',
      'it-IT': '/it',
      'pt-PT': '/pt',
      'ar-SA': '/ar',
      'zh-CN': '/zh',
      'ja-JP': '/ja',
      'ko-KR': '/ko',
    },
  },
  openGraph: {
    title: 'Math4Child - L\'app éducative n°1 pour apprendre les maths',
    description: 'Plus de 100k familles nous font confiance pour l\'apprentissage ludique des mathématiques',
    url: 'https://math4child.com',
    siteName: 'Math4Child',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Math4Child - App éducative de mathématiques',
      },
    ],
    locale: 'fr_FR',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - L\'app éducative n°1',
    description: 'Plus de 100k familles nous font confiance',
    images: ['/twitter-image.png'],
    creator: '@math4child',
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
    google: 'your-google-verification-code',
  },
  category: 'education',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" className={inter.variable}>
      <head>
        <link rel="icon" href="/favicon.ico" sizes="any" />
        <link rel="icon" href="/icon.svg" type="image/svg+xml" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#667eea" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5" />
      </head>
      <body className={`${inter.className} antialiased`}>
        <div id="root">
          {children}
        </div>
      </body>
    </html>
  )
}
