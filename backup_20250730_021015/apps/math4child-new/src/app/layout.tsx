import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Apprends les maths en t\'amusant !',
  description: 'L\'app éducative n°1 pour apprendre les maths en famille. Plus de 100k familles nous font confiance.',
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
