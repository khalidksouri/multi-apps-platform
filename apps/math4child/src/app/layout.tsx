export const metadata = {
  title: 'Math4Child - Apprendre les mathématiques',
  description: 'Application éducative pour apprendre les mathématiques en s\'amusant',
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
        <style dangerouslySetInnerHTML={{
          __html: `
            *, *::before, *::after {
              box-sizing: border-box;
              margin: 0;
              padding: 0;
            }
            
            html {
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
              line-height: 1.6;
              -webkit-text-size-adjust: 100%;
            }
            
            body {
              min-height: 100vh;
              color: #333;
              background: #f8fafc;
            }
            
            button {
              font-family: inherit;
              cursor: pointer;
              border: none;
              background: none;
              transition: all 0.15s ease;
            }
            
            button:hover {
              transform: translateY(-1px);
            }
            
            button:focus {
              outline: 2px solid #3b82f6;
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
