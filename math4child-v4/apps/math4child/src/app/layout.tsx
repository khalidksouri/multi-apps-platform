import type { Metadata, Viewport } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math pour enfants - App éducative n°1',
  description: "L'application éducative n°1 pour apprendre les maths en famille ! Plus de 100k familles nous font confiance.",
  keywords: 'mathématiques, enfants, éducation, apprentissage, famille, application',
  authors: [{ name: 'Math4Child Team' }],
  openGraph: {
    title: 'Math pour enfants - App éducative n°1',
    description: "L'application éducative n°1 pour apprendre les maths en famille !",
    type: 'website',
    locale: 'fr_FR',
    siteName: 'Math4Child'
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math pour enfants - App éducative n°1',
    description: "L'application éducative n°1 pour apprendre les maths en famille !"
  },
  robots: {
    index: true,
    follow: true
  }
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: '#8B5CF6'
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}
