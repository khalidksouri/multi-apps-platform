import './globals.css'

export const metadata = {
  title: 'Math4Child - Apprentissage des mathématiques',
  description: 'Application éducative pour enfants',
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
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
