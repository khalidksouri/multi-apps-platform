import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Learn Math While Having Fun',
  description: 'Interactive multilingual math learning platform for children aged 4-12. Support for French, English, Spanish, German, and Arabic.',
  keywords: 'math, children, education, multilingual, learning, games',
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
