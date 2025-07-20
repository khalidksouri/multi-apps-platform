import './globals.css'

export const metadata = {
  title: 'Math4Kids - Apprendre les maths en s\'amusant',
  description: 'Application éducative multilingue pour apprendre les mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  )
}
