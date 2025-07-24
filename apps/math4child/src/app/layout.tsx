export const metadata = {
  title: 'Math4Child - Application Éducative Multilingue',
  description: 'Application éducative professionnelle pour apprendre les mathématiques en famille. Support de 20+ langues avec interface RTL.',
  keywords: 'mathématiques, éducation, enfants, multilingue, famille, apprentissage',
  authors: [{ name: 'Math4Child Team' }],
  openGraph: {
    title: 'Math4Child - Application Éducative',
    description: 'Apprendre les mathématiques en famille avec support multilingue',
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
            *, *::before, *::after {
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
              border: none;
              background: none;
              transition: all 0.2s ease;
            }
            
            button:focus {
              outline: 2px solid rgba(255, 255, 255, 0.5);
              outline-offset: 2px;
            }
            
            /* Scrollbar personnalisé */
            *::-webkit-scrollbar {
              width: 8px;
            }
            
            *::-webkit-scrollbar-track {
              background: #f1f5f9;
              border-radius: 4px;
            }
            
            *::-webkit-scrollbar-thumb {
              background: #cbd5e1;
              border-radius: 4px;
              transition: background 0.2s ease;
            }
            
            *::-webkit-scrollbar-thumb:hover {
              background: #94a3b8;
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
