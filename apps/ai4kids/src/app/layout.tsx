import './globals.css';

export const metadata = {
  title: 'AI4Kids - Intelligence Artificielle pour Enfants',
  description: 'Apprendre l\'IA de manière ludique',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-100">
          <header className="bg-white shadow-sm border-b">
            <div className="max-w-7xl mx-auto px-4 py-6">
              <div className="flex items-center justify-between">
                <div>
                  <h1 className="text-3xl font-bold text-purple-600">AI4Kids</h1>
                  <p className="text-gray-600 text-sm mt-1">
                    Intelligence Artificielle pour les enfants
                  </p>
                </div>
                <div className="flex items-center space-x-4">
                  <span className="px-3 py-1 bg-purple-100 text-purple-800 rounded-full text-xs font-medium">
                    Version Enfant
                  </span>
                </div>
              </div>
            </div>
          </header>
          <main className="max-w-7xl mx-auto px-4 py-8">
            {children}
          </main>
        </div>
      </body>
    </html>
  );
}