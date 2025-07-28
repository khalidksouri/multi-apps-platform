'use client';

import { useTranslation } from '@/hooks/useTranslation';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';

export default function NotFound() {
  const { t } = useTranslation();

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="text-center">
        <h1 className="text-9xl font-bold text-blue-600">404</h1>
        <h2 className="text-2xl font-semibold text-gray-900 mb-4">
          Page non trouvée
        </h2>
        <p className="text-gray-600 mb-8">
          La page que vous cherchez n&apos;existe pas.
        </p>
        <Link href="/">
          <Button>
            Retour à l&apos;accueil
          </Button>
        </Link>
      </div>
    </div>
  );
}
