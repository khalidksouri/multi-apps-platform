import './globals.css'

export const metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant',
  description: 'Application éducative révolutionnaire pour l\'apprentissage des mathématiques. Plus de 100,000 familles nous font confiance.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, jeux éducatifs',
  authors: [{ name: 'Math4Child Team' }],
  openGraph: {
    title: 'Math4Child - Apprendre les maths en s\'amusant',
    description: 'Application éducative révolutionnaire pour l\'apprentissage des mathématiques',
    type: 'website',
    locale: 'fr_FR',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - Apprendre les maths en s\'amusant',
    description: 'Application éducative révolutionnaire pour l\'apprentissage des mathématiques',
  },
  viewport: 'width=device-width, initial-scale=1',
  themeColor: '#2563eb',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
      </head>
      <body className="antialiased">
        <div id="__next">
          {children}
        </div>
      </body>
    </html>
  )
}
