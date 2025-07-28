import { TranslationProvider } from '@/contexts/TranslationContext';
import './globals.css';

export const metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant',
  description: 'L\'application éducative n°1 pour apprendre les mathématiques en famille'
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <TranslationProvider>
          {children}
        </TranslationProvider>
      </body>
    </html>
  );
}
