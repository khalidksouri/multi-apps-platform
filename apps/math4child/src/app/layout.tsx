export const metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative moderne pour apprendre les mathématiques avec plaisir et efficacité. Exercices adaptés, apprentissage ludique, paiement sécurisé.',
  keywords: 'mathématiques, éducation, enfants, apprentissage, exercices, ludique, math4child',
  authors: [{ name: 'Math4Child Team' }],
  openGraph: {
    title: 'Math4Child - Application éducative',
    description: 'Apprendre les mathématiques en s\'amusant',
    type: 'website',
  },
  viewport: 'width=device-width, initial-scale=1',
  robots: 'index, follow'
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
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <style dangerouslySetInnerHTML={{
          __html: `
            * {
              box-sizing: border-box;
              margin: 0;
              padding: 0;
            }
            
            html {
              scroll-behavior: smooth;
            }
            
            body {
              margin: 0;
              padding: 0;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
              -webkit-font-smoothing: antialiased;
              -moz-osx-font-smoothing: grayscale;
            }
            
            button:focus {
              outline: 2px solid rgba(255, 255, 255, 0.5);
              outline-offset: 2px;
            }
            
            @media (prefers-reduced-motion: reduce) {
              *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
              }
              
              html {
                scroll-behavior: auto;
              }
            }
          `
        }} />
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
