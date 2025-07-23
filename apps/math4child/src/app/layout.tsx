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
        <style dangerouslySetInnerHTML={{
          __html: `
            *, *::before, *::after {
              box-sizing: border-box;
              margin: 0;
              padding: 0;
            }
            
            html, body {
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
              line-height: 1.6;
              color: #333;
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
          `
        }} />
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
