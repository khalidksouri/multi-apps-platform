import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Math4Child.com - App Éducative #1 | 40% Moins Cher que la Concurrence',
  description: 'Math4Child: Leader mondial des apps éducatives. 5 profils famille, 30+ langues, mode hors-ligne. 40% moins cher que ABCmouse, Prodigy, SplashLearn. Essai gratuit 14 jours.',
  keywords: [
    'mathématiques enfants',
    'app éducative famille', 
    'moins cher que ABCmouse',
    'alternative Prodigy Math',
    'concurrence SplashLearn',
    'math4child prix compétitif',
    '5 profils famille',
    'mode hors ligne',
    'multilingue 30 langues'
  ].join(', '),
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <meta name="theme-color" content="#667eea" />
      </head>
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
