export const metadata = {
  title: 'Math4Child - Apprendre les Mathématiques en S\'amusant',
  description: 'Application éducative interactive pour apprendre les mathématiques. Pour enfants de 4 à 12 ans.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, calcul',
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🧮</text></svg>" />
        <style>{`
          * { box-sizing: border-box; margin: 0; padding: 0; }
          body { font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif; line-height: 1.6; }
          button:hover { transition: all 0.2s ease; }
          @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr !important; }
            h2 { font-size: 2rem !important; }
            .hero { padding: 2rem !important; }
          }
        `}</style>
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
