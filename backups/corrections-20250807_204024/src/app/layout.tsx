import { LanguageProvider } from '../contexts/LanguageContext'

export const metadata = {
  title: 'Math for Children',
  description: 'The #1 educational app to learn mathematics as a family',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <script src="https://cdn.tailwindcss.com"></script>
      </head>
      <body>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
