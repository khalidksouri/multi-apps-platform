import './globals.css'

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
      <body>
        <div id="__next">
          {children}
        </div>
      </body>
    </html>
  )
}
