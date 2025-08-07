import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { LanguageProvider } from "@/hooks/useLanguage"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Math4Child - Apprends les maths en t'amusant !",
  description: "L'application éducative révolutionnaire pour apprendre les mathématiques. 200+ langues supportées, 5 niveaux progressifs.",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
