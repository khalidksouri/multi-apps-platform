import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Math4Child v4.2.0 - Révolution Éducative Mondiale",
  description: "La plateforme éducative la plus avancée technologiquement au monde avec IA Adaptative, Réalité Augmentée, Assistant Vocal et 200+ langues",
  keywords: "mathématiques, éducation, enfants, IA, réalité augmentée, assistant vocal, 200 langues, première mondiale",
  authors: [{ name: "Math4Child", url: "https://math4child.com" }],
  creator: "Math4Child",
  publisher: "Math4Child"
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <head>
        <link rel="icon" href="/favicon.ico" />
        <meta name="theme-color" content="#3b82f6" />
      </head>
      <body className={`${inter.className} antialiased`} suppressHydrationWarning>
        <div id="root">
          {children}
        </div>
      </body>
    </html>
  )
}
