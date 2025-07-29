import { ReactNode } from 'react'

export const metadata = {
  title: 'Math4Child - Application Éducative',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="fr">
      <body style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>
        {children}
      </body>
    </html>
  )
}
