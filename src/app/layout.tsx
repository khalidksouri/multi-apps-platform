import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { LanguageProvider } from "@/hooks/useLanguage"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Math4Child v4.2.0 - Révolution Éducative Mondiale",
  description: "La plateforme éducative la plus avancée technologiquement au monde avec IA Adaptative, Réalité Augmentée, Assistant Vocal et 200+ langues",
  keywords: "mathématiques, éducation, enfants, IA, réalité augmentée, assistant vocal, 200 langues, première mondiale",
  authors: [{ name: "Math4Child", url: "https://math4child.com" }],
  creator: "Math4Child",
  publisher: "Math4Child",
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  openGraph: {
    title: "Math4Child v4.2.0 - Révolution Éducative Mondiale",
    description: "6 innovations révolutionnaires pour transformer l'apprentissage des mathématiques",
    url: "https://math4child.com",
    siteName: "Math4Child",
    images: [
      {
        url: "https://math4child.com/og-image.jpg",
        width: 1200,
        height: 630,
        alt: "Math4Child - Révolution Éducative",
      },
    ],
    locale: "fr_FR",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Math4Child v4.2.0 - Révolution Éducative",
    description: "6 innovations révolutionnaires pour l'éducation mathématique",
    creator: "@math4child",
    images: ["https://math4child.com/og-image.jpg"],
  },
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
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#3b82f6" />
      </head>
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
