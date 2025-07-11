import './globals.css';

export const metadata = {
  title: 'PostMath Pro - Calcul d\'expédition',
  description: 'Calculez vos frais d\'expédition',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <div className="min-h-screen bg-gray-50">
          <header className="bg-white shadow-sm border-b">
            <div className="max-w-7xl mx-auto px-4 py-6">
              <div className="flex items-center justify-between">
                <div>
                  <h1 className="text-3xl font-bold text-blue-600">PostMath Pro</h1>
                  <p className="text-gray-600 text-sm mt-1">
                    Calculateur de frais d'expédition intelligent
                  </p>
                </div>
                <div className="flex items-center space-x-4">
                  <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-xs font-medium">
                    Version 1.0
                  </span>
                </div>
              </div>
            </div>
          </header>
          <main className="max-w-7xl mx-auto px-4 py-8">
            {children}
          </main>
          <footer className="bg-white border-t mt-12">
            <div className="max-w-7xl mx-auto px-4 py-6">
              <p className="text-center text-gray-500 text-sm">
                © 2024 PostMath Pro - Calculateur d'expédition intelligent
              </p>
            </div>
          </footer>
        </div>
      </body>
    </html>
  );
}
