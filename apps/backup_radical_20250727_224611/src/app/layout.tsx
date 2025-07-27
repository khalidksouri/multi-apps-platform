export const metadata = {
  title: 'Math4Child - Application Éducative Magnifique',
  description: 'Application éducative avec design professionnel pour apprendre les mathématiques en famille. Interface multilingue avec support RTL.',
  keywords: 'mathématiques, éducation, enfants, multilingue, famille, apprentissage, gradient, design',
  authors: [{ name: 'Math4Child Team' }],
  openGraph: {
    title: 'Math4Child - Design Magnifique',
    description: 'Application éducative avec le plus beau design',
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
        <style dangerouslySetInnerHTML={{
          __html: `
            * {
              box-sizing: border-box;
              margin: 0;
              padding: 0;
            }
            
            html, body {
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
              line-height: 1.6;
              color: #333;
              -webkit-font-smoothing: antialiased;
              -moz-osx-font-smoothing: grayscale;
            }
            
            button {
              font-family: inherit;
              cursor: pointer;
              transition: all 0.2s ease;
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
