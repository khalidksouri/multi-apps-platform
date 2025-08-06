import "./globals.css"
import Navigation from "@/components/navigation/Navigation"
import { LanguageProvider } from "@/components/language/LanguageProvider"
import type { Metadata } from "next"

export const metadata: Metadata = {
  title: "Math4Child - Apprendre les maths en s amusant !",
  description: "Application éducative révolutionnaire pour les mathématiques. 195+ langues, IA adaptative, 5 niveaux de progression.",
  keywords: [
    "mathématiques enfants",
    "application éducative", 
    "apprentissage ludique",
    "IA adaptative",
    "multilingue",
    "GOTEST"
  ]
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" className="scroll-smooth">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
        <link rel="icon" href="/favicon.ico" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
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
