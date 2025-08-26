import type { Metadata, Viewport } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { BranchInfoProvider } from '../components/BranchInfo';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '6 Innovations Révolutionnaires pour transformer apprentissage mathématiques',
  keywords: ['mathématiques', 'enfants', 'éducation', 'IA'],
  authors: [{ name: 'Math4Child Team' }],
  robots: { index: true, follow: true },
  openGraph: {
    type: 'website',
    locale: 'fr_FR',
    url: 'https://math4child.com',
    title: 'Math4Child v4.2.0',
  },
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  themeColor: '#3b82f6',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body className={`${inter.className} antialiased`}>
        <BranchInfoProvider>
          <nav className="fixed top-0 w-full z-40 bg-white/90 backdrop-blur border-b">
            <div className="max-w-7xl mx-auto px-4">
              <div className="flex justify-between items-center h-16">
                <div className="flex items-center space-x-4">
                  <div className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                    🎯 Math4Child
                  </div>
                  <div className="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                    v4.2.0
                  </div>
                </div>
                <div className="flex items-center space-x-6">
                  <a href="/exercises" className="text-gray-700 hover:text-blue-600 transition-colors">Exercices</a>
                  <a href="/pricing" className="text-gray-700 hover:text-blue-600 transition-colors">Plans</a>
                  <a href="/dashboard" className="text-gray-700 hover:text-blue-600 transition-colors">Dashboard</a>
                </div>
              </div>
            </div>
          </nav>
          <main className="pt-16 min-h-screen">{children}</main>
          <footer className="bg-gray-900 text-white py-12">
            <div className="max-w-7xl mx-auto px-4">
              <div className="text-center">
                <p className="text-gray-400">© 2025 Math4Child. Révolution éducative mondiale.</p>
                <p className="text-sm text-gray-500 mt-2">v4.2.0 - 6 Innovations Révolutionnaires</p>
              </div>
            </div>
          </footer>
        </BranchInfoProvider>
      </body>
    </html>
  );
}
