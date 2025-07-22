export const metadata = {
  title: 'Math4Child',
  description: 'Application éducative pour enfants',
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
