import './globals.css';

export const metadata = {
  title: 'MultiAI - Hub Intelligence Artificielle',
  description: 'Plateforme unifiée pour les services IA',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <div className="min-h-screen bg-gradient-to-br from-gray-900 to-blue-900">
          <header className="bg-white/10 backdrop-blur-md border-b border-white/20">
            <div className="max-w-7xl mx-auto px-4 py-6">
              <div className="flex items-center justify-between">
                <div>
                  <h1 className="text-3xl font-bold text-white">MultiAI</h1>
                  <p className="text-gray-300 text-sm mt-1">
                    Hub Intelligence Artificielle
                  </p>
                </div>
                <div className="flex items-center space-x-4">
                  <span className="px-3 py-1 bg-blue-500/20 text-blue-300 rounded-full text-xs font-medium border border-blue-400/30">
                    IA Avancée
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