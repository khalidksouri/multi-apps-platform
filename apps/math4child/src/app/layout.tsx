import type { Metadata } from 'next';
import './globals.css';
import { LanguageProvider } from '@/components/providers/LanguageProvider';

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant',
  description: 'Application éducative premium pour apprendre les mathématiques en famille. 75+ langues, 5 niveaux, système multilingue complet avec support RTL.',
  keywords: 'mathématiques, éducation, enfants, apprentissage, jeux éducatifs, multilingue, RTL, arabe, français, espagnol',
  authors: [{ name: 'Math4Child Team' }],
  icons: {
    icon: '/favicon.ico',
  },
  manifest: '/manifest.json',
  openGraph: {
    title: 'Math4Child - Apprendre les maths en s\'amusant',
    description: 'Application éducative premium avec système multilingue complet',
    type: 'website',
    locale: 'fr_FR',
    alternateLocale: ['en_US', 'es_ES', 'de_DE', 'ar_SA'],
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr" dir="ltr">
      <body className="antialiased">
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  );
}
