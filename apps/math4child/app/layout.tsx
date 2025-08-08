import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { LanguageProvider } from "@/hooks/useLanguage"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Math4Child v4.2.0 - Révolution Éducative Mondiale",
  description: "La plateforme éducative la plus avancée technologiquement au monde avec IA, AR, Vocal et 200+ langues",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <body className={`${inter.className} antialiased`} suppressHydrationWarning>
        <LanguageProvider>
          <div id="root">
            {children}
          </div>
        </LanguageProvider>
      </body>
    </html>
  )
}
