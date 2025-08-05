import "./globals.css"
import Navigation from "@/components/navigation/Navigation"
import { LanguageProvider } from "@/components/language/LanguageProvider"

export const metadata = {
  title: "Math4Child - Apprendre les maths en s'amusant !",
  description: "Application éducative révolutionnaire pour les mathématiques. 195+ langues, IA adaptative, développée par GOTEST.",
  keywords: "mathématiques, enfants, éducation, apprentissage, jeux éducatifs, GOTEST",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body className="font-inter antialiased bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 min-h-screen">
        <LanguageProvider>
          <Navigation />
          <main className="pt-20 pb-10">
            {children}
          </main>
        </LanguageProvider>
      </body>
    </html>
  )
}
