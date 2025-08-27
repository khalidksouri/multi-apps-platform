import React from 'react';
import Link from 'next/link';

// Fonction requise pour output: export
export async function generateStaticParams() {
  return [
    { level: '1' },
    { level: '2' },
    { level: '3' },
    { level: '4' },
    { level: '5' }
  ];
}

export default function VoicePage({ params }: { params: { level: string } }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-100 p-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="bg-white rounded-xl shadow-sm p-4 mb-6">
          <div className="flex items-center justify-between">
            <Link 
              href={`/exercises/${params.level}`}
              className="flex items-center gap-2 text-gray-600 hover:text-blue-600 transition-colors"
            >
              ← Retour aux exercices
            </Link>
            <div className="text-sm text-gray-500">Niveau {params.level}</div>
          </div>
        </div>

        {/* Contenu Voice */}
        <div className="bg-white rounded-xl shadow-lg p-8 text-center">
          <div className="mb-6">
            <div className="w-20 h-20 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-3xl">🎤</span>
            </div>
            <h1 className="text-3xl font-bold text-gray-900 mb-2">
              Assistant Vocal IA
            </h1>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Innovation révolutionnaire Math4Child - IA conversationnelle pour apprentissage
            </p>
          </div>

          <div className="bg-purple-50 border border-purple-200 rounded-lg p-6 mb-6">
            <h3 className="text-lg font-semibold text-purple-800 mb-3">
              Capacités IA Vocales
            </h3>
            <div className="grid md:grid-cols-2 gap-4 text-left">
              <div>• Reconnaissance vocale avancée</div>
              <div>• Réponses IA personnalisées</div>
              <div>• 3 personnalités différentes</div>
              <div>• Analyse émotionnelle temps réel</div>
            </div>
          </div>

          <div className="flex justify-center gap-4">
            <Link 
              href={`/exercises/${params.level}/handwriting`}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              ✏️ Mode Manuscrite
            </Link>
            <Link 
              href={`/exercises/${params.level}/ar3d`}
              className="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
            >
              👁️ Mode AR 3D
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
