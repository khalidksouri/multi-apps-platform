import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  fallback: ['system-ui', 'arial']
})

export const metadata = {
  title: 'Math4Child.com - Apprendre les maths en s\'amusant',
  description: 'Application éducative de mathématiques pour enfants. 195+ langues supportées, 5 niveaux de difficulté.',
  manifest: '/manifest.json',
}

// Séparation viewport selon Next.js 15
export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: '#667eea',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="manifest" href="/manifest.json" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      </head>
      <body className={`${inter.className} overflow-x-hidden`}>
        <div id="capacitor-app">
          {children}
        </div>
      </body>
    </html>
  )
}
