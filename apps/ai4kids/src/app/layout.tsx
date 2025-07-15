import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'AI4Kids',
  description: 'Application AI4Kids - Plateforme MultiApps',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body className="min-h-screen bg-gray-50">
        <div className="container mx-auto px-4 py-8">
          {children}
        </div>
      </body>
    </html>
  );
}
