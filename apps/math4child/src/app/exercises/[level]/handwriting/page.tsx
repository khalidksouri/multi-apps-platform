import React from 'react';
import Link from 'next/link';
import HandwritingCanvas from '@/components/HandwritingCanvas';

// Fonction generateStaticParams pour export statique
export async function generateStaticParams() {
  return [
    { level: '1' },
    { level: '2' },
    { level: '3' },
    { level: '4' },
    { level: '5' }
  ];
}

export default function HandwritingPage({ params }: { params: { level: string } }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      {/* Header */}
      <div className="max-w-4xl mx-auto mb-6">
        <div className="flex items-center justify-between bg-white rounded-xl shadow-sm p-4">
          <Link 
            href={`/exercises/${params.level}`}
            className="flex items-center gap-2 text-gray-600 hover:text-blue-600 transition-colors"
          >
            ← Retour aux exercices
          </Link>
          
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 text-blue-600">
              ✨ <span className="font-semibold">Reconnaissance Manuscrite IA</span>
            </div>
            <div className="text-sm text-gray-500">
              Niveau {params.level}
            </div>
          </div>
        </div>
      </div>

      {/* Composant Client */}
      <HandwritingCanvas level={params.level} />
    </div>
  );
}
