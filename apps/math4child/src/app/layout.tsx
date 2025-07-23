import './globals.css'

export const metadata = {
  title: 'Math4Child - Apprendre les mathématiques',
  description: 'Application éducative pour apprendre les mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>
        {children}
      </body>
    </html>
  )
}
