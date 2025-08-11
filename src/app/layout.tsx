import type { Metadata } from "next"
import "./globals.css"
import { LanguageProvider } from "@/hooks/useLanguage"

export const metadata: Metadata = {
  title: "Math4Child v4.2.0 - Révolution Éducative Mondiale",
  description: "6 innovations révolutionnaires pour l'éducation mathématique",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body suppressHydrationWarning>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
