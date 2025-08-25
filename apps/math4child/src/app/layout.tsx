import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { BranchInfoProvider } from '../components/BranchInfo';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '🎯 La première application éducative qui révolutionne l\'apprentissage des mathématiques avec 6 innovations mondiales: IA Adaptative, Reconnaissance Manuscrite, Assistant Vocal IA, Réalité Augmentée 3D, Progression Gamifiée et Traduction Universelle 200+ langues.',
  keywords: [
    'mathématiques', 'enfants', 'éducation', 'IA', 'reconnaissance manuscrite', 
    'assistant vocal', 'réalité augmentée', 'gamification', 'multilangue',
    'apprentissage adaptatif', 'innovation pédagogique'
  ],
  authors: [{ name: 'Math4Child Team' }],
  creator: 'Math4Child',
  publisher: 'Math4Child',
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
    },
  },
  openGraph: {
    type: 'website',
    locale: 'fr_FR',
    url: 'https://math4child.com',
    siteName: 'Math4Child',
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    description: 'La première application éducative qui révolutionne l\'apprentissage des mathématiques avec 6 innovations mondiales.',
    images: [
      {
        url: 'https://math4child.com/images/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Math4Child - Révolution Éducative',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    description: 'La première application éducative qui révolutionne l\'apprentissage des mathématiques avec 6 innovations mondiales.',
    images: ['https://math4child.com/images/twitter-image.png'],
  },
  viewport: {
    width: 'device-width',
    initialScale: 1,
    maximumScale: 1,
  },
  icons: {
    icon: '/favicon.ico',
    shortcut: '/favicon-16x16.png',
    apple: '/apple-touch-icon.png',
  },
  manifest: '/manifest.json',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr" className="scroll-smooth">
      <head>
        {/* Analytics conditionnelles selon environnement */}
        {process.env.NEXT_PUBLIC_APP_ENV === 'production' && (
          <>
            {/* Google Analytics */}
            <script
              async
              src={`https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID`}
            />
            <script
              dangerouslySetInnerHTML={{
                __html: `
                  window.dataLayer = window.dataLayer || [];
                  function gtag(){dataLayer.push(arguments);}
                  gtag('js', new Date());
                  gtag('config', 'GA_MEASUREMENT_ID');
                `,
              }}
            />
          </>
        )}
        
        {/* Préchargement assets critiques */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        
        {/* PWA Support */}
        <meta name="theme-color" content="#3b82f6" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="Math4Child" />
        
        {/* Informations build pour debug */}
        {(process.env.NEXT_PUBLIC_APP_ENV === 'development' || process.env.NEXT_PUBLIC_APP_ENV === 'staging') && (
          <>
            <meta name="build-branch" content={process.env.NEXT_PUBLIC_BRANCH} />
            <meta name="build-env" content={process.env.NEXT_PUBLIC_APP_ENV} />
            <meta name="build-time" content={process.env.NEXT_PUBLIC_BUILD_TIME} />
          </>
        )}
      </head>
      <body className={`${inter.className} antialiased bg-gray-50 text-gray-900`}>
        <BranchInfoProvider>
          {/* Navigation principale */}
          <nav className="fixed top-0 left-0 right-0 z-40 bg-white/90 backdrop-blur-sm border-b border-gray-200">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
              <div className="flex justify-between items-center h-16">
                <div className="flex items-center space-x-4">
                  <div className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                    🎯 Math4Child
                  </div>
                  <div className="hidden md:block text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                    v4.2.0
                  </div>
                </div>
                
                <div className="flex items-center space-x-6">
                  <a href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
                    Exercices
                  </a>
                  <a href="/pricing" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
                    Plans
                  </a>
                  <a href="/dashboard" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
                    Dashboard
                  </a>
                  <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                    Commencer
                  </button>
                </div>
              </div>
            </div>
          </nav>

          {/* Contenu principal */}
          <main className="pt-16">
            {children}
          </main>

          {/* Footer */}
          <footer className="bg-gray-900 text-white py-12">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div>
                  <div className="text-2xl font-bold mb-4 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
                    Math4Child
                  </div>
                  <p className="text-gray-400 text-sm mb-4">
                    La révolution éducative mondiale avec 6 innovations
                  </p>
                  <div className="text-xs text-gray-500">
                    v4.2.0 - {process.env.NEXT_PUBLIC_BRANCH}
                  </div>
                </div>
                
                <div>
                  <h4 className="font-semibold mb-4">Innovations</h4>
                  <ul className="space-y-2 text-sm text-gray-400">
                    <li>🧠 IA Adaptative</li>
                    <li>✏️ Reconnaissance Manuscrite</li>
                    <li>🥽 Réalité Augmentée 3D</li>
                    <li>🎙️ Assistant Vocal IA</li>
                  </ul>
                </div>
                
                <div>
                  <h4 className="font-semibold mb-4">Support</h4>
                  <ul className="space-y-2 text-sm text-gray-400">
                    <li>📧 support@math4child.com</li>
                    <li>💼 commercial@math4child.com</li>
                    <li>📚 Documentation</li>
                    <li>🐛 Signaler un bug</li>
                  </ul>
                </div>
                
                <div>
                  <h4 className="font-semibold mb-4">Communauté</h4>
                  <ul className="space-y-2 text-sm text-gray-400">
                    <li>🌍 200+ langues supportées</li>
                    <li>👨‍👩‍👧‍👦 Millions d'utilisateurs</li>
                    <li>🏫 Écoles partenaires</li>
                    <li>🔓 Open Source</li>
                  </ul>
                </div>
              </div>
              
              <div className="border-t border-gray-800 mt-8 pt-8 text-center">
                <p className="text-gray-400 text-sm">
                  © 2025 Math4Child. Révolution éducative mondiale. MIT License.
                </p>
                {(process.env.NEXT_PUBLIC_APP_ENV === 'development' || process.env.NEXT_PUBLIC_APP_ENV === 'staging') && (
                  <div className="mt-2 text-xs text-gray-600">
                    🌿 Build: {process.env.NEXT_PUBLIC_BRANCH} | 📍 Env: {process.env.NEXT_PUBLIC_APP_ENV} | ⏰ {process.env.NEXT_PUBLIC_BUILD_TIME}
                  </div>
                )}
              </div>
            </div>
          </footer>
        </BranchInfoProvider>
      </body>
    </html>
  );
}
