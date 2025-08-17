'use client';

import { useLanguage } from '@/hooks/useLanguage';
import Link from 'next/link';

export default function Navigation() {
  const { t } = useLanguage();

  return (
    <nav className="flex gap-4">
      <Link href="/" className="text-white hover:text-white/80">Accueil</Link>
      <Link href="/exercises" className="text-white hover:text-white/80">Exercices</Link>
      <Link href="/pricing" className="text-white hover:text-white/80">{t('pricing')}</Link>
      <Link href="/profile" className="text-white hover:text-white/80">Profil</Link>
    </nav>
  );
}
