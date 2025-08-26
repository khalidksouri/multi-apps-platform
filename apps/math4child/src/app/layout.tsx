import type { Metadata, Viewport } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { BranchInfoProvider } from '../components/BranchInfo';
import NavigationWrapper from '../components/NavigationWrapper';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
  description: '6 Innovations Révolutionnaires selon README.md',
  keywords: ['mathématiques', 'enfants', 'éducation', 'IA', 'reconnaissance manuscrite', 'assistant vocal'],
  authors: [{ name: 'Math4Child Team' }],
  robots: { index: true, follow: true },
  openGraph: {
    type: 'website',
    locale: 'fr_FR',
    url: 'https://math4child.com',
    title: 'Math4Child v4.2.0',
    description: 'Révolution éducative mondiale - 6 innovations révolutionnaires'
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
          <NavigationWrapper />
          <main className="pt-16 min-h-screen">{children}</main>
          <footer className="bg-gray-900 text-white py-12">
            <div className="max-w-7xl mx-auto px-4">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div>
                  <h3 className="text-xl font-bold mb-4">Math4Child</h3>
                  <p className="text-gray-400">La révolution éducative mondiale avec 6 innovations</p>
                  <p className="text-sm text-gray-500 mt-2">v4.2.0</p>
                </div>
                <div>
                  <h4 className="font-bold mb-4">Innovations</h4>
                  <ul className="space-y-2 text-sm text-gray-400">
                    <li>🧠 IA Adaptative</li>
                    <li>✏️ Reconnaissance Manuscrite</li>
                    <li>🥽 Réalité Augmentée 3D</li>
                    <li>🎙️ Assistant Vocal IA</li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-bold mb-4">Support</h4>
                  <ul className="space-y-2 text-sm text-gray-400">
                    <li>📧 support@math4child.com</li>
                    <li>💼 commercial@math4child.com</li>
                    <li>📚 Documentation</li>
                    <li>🐛 Signaler un bug</li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-bold mb-4">🌍 Langues</h4>
                  <p className="text-sm text-gray-400">🌟 200+ langues supportées</p>
                  <p className="text-sm text-gray-400">👥 Millions d'utilisateurs</p>
                  <p className="text-sm text-gray-400">🏫 Écoles partenaires</p>
                </div>
              </div>
              <div className="border-t border-gray-800 mt-8 pt-8 text-center">
                <p className="text-gray-400">© 2025 Math4Child. Révolution éducative mondiale. MIT License.</p>
              </div>
            </div>
          </footer>
        </BranchInfoProvider>
      </body>
    </html>
  );
}
