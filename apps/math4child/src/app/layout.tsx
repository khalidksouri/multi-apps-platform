import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Application éducative mathématiques',
  description: 'Application éducative pour apprendre les mathématiques de manière ludique. Support 20 langues avec RTL natif.',
  keywords: 'mathématiques, éducation, enfants, apprentissage, multilingue, RTL, Math4Child',
  authors: [{ name: 'Khalid Ksouri' }], // ← Correction: suppression du champ 'email' non supporté
  creator: 'Khalid Ksouri',
  publisher: 'Multi-Apps Platform',
  applicationName: 'Math4Child',
  generator: 'Next.js',
  category: 'Education',
  openGraph: {
    title: 'Math4Child - Apprentissage des Mathématiques',
    description: 'Application éducative multilingue pour apprendre les mathématiques',
    url: 'https://github.com/khalidksouri/multi-apps-platform',
    siteName: 'Math4Child',
    type: 'website',
    locale: 'fr_FR',
    alternateLocale: ['en_US', 'es_ES', 'de_DE', 'ar_SA', 'zh_CN'],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - Apprentissage Mathématiques',
    description: 'Application éducative avec support 20 langues',
    creator: '@khalidksouri',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
    },
  },
  icons: {
    icon: [
      { url: '/favicon.ico' },
      { url: '/icon-192.png', sizes: '192x192', type: 'image/png' },
    ],
    apple: [
      { url: '/apple-icon-180.png', sizes: '180x180', type: 'image/png' },
    ],
  },
  manifest: '/manifest.json',
  other: {
    'github-repository': 'https://github.com/khalidksouri/multi-apps-platform',
    'contact-email': 'khalid_ksouri@yahoo.fr',
    'app-version': '2.0.0',
    'supported-languages': '20',
    'rtl-support': 'true',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="theme-color" content="#3B82F6" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="Math4Child" />
        <link rel="canonical" href="https://github.com/khalidksouri/multi-apps-platform" />
      </head>
      <body className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 antialiased">
        <div id="root" className="min-h-screen">
          {children}
        </div>
      </body>
    </html>
  )
}
