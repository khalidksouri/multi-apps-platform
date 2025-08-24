// src/app/layout.tsx - VERSION CORRIGÉE
import type { Metadata } from 'next';
import { BranchInfoProvider, BranchMetaTags } from '../components/BranchInfo';

export const metadata: Metadata = {
  title: 'Math4Child - Apprentissage Mathématiques pour Enfants',
  description: 'Plateforme révolutionnaire d\'apprentissage des mathématiques pour enfants',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <BranchInfoProvider>
          <BranchMetaTags />
          {children}
        </BranchInfoProvider>
      </body>
    </html>
  );
}
