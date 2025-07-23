import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Mathématiques pour Enfants',
  description: 'L\'app éducative #1 pour apprendre les mathématiques en famille',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" dir="ltr">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
