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

export default function ExercisesLevelPage({ params }: { params: { level: string } }) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="bg-white rounded-xl shadow-sm p-6 mb-8">
          <div className="flex items-center justify-between">
            <Link 
              href="/"
              className="flex items-center gap-2 text-gray-600 hover:text-blue-600 transition-colors"
            >
              ← Retour à l'accueil
            </Link>
            <div className="text-center">
              <h1 className="text-2xl font-bold text-gray-900">Math4Child - Niveau {params.level}</h1>
              <p className="text-sm text-gray-600">Choisissez votre mode d'apprentissage</p>
            </div>
            <div className="text-sm text-gray-500">
              Niveau {params.level}/5
            </div>
          </div>
        </div>

        {/* 3 Modes d'apprentissage */}
        <div className="grid md:grid-cols-3 gap-8 mb-8">
          {/* Mode Manuscrite */}
          <Link 
            href={`/exercises/${params.level}/handwriting`}
            className="group bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all hover:-translate-y-1"
          >
            <div className="text-center">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-blue-200 transition-colors">
                <span className="text-2xl">✏️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Reconnaissance Manuscrite
              </h3>
              <p className="text-gray-600 mb-4">
                Écris tes réponses sur le canvas. L'IA reconnaît ton écriture et te corrige.
              </p>
              <div className="text-sm text-blue-600 font-medium">
                Innovation IA révolutionnaire →
              </div>
            </div>
          </Link>

          {/* Mode Vocal */}
          <Link 
            href={`/exercises/${params.level}/voice`}
            className="group bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all hover:-translate-y-1"
          >
            <div className="text-center">
              <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-purple-200 transition-colors">
                <span className="text-2xl">🎤</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Assistant Vocal IA
              </h3>
              <p className="text-gray-600 mb-4">
                Parle avec l'IA. 3 personnalités différentes t'accompagnent dans ton apprentissage.
              </p>
              <div className="text-sm text-purple-600 font-medium">
                IA conversationnelle avancée →
              </div>
            </div>
          </Link>

          {/* Mode AR 3D */}
          <Link 
            href={`/exercises/${params.level}/ar3d`}
            className="group bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-all hover:-translate-y-1"
          >
            <div className="text-center">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-green-200 transition-colors">
                <span className="text-2xl">👁️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Réalité Augmentée 3D
              </h3>
              <p className="text-gray-600 mb-4">
                Visualise les mathématiques en 3D. Environnement immersif et interactif.
              </p>
              <div className="text-sm text-green-600 font-medium">
                Expérience immersive 3D →
              </div>
            </div>
          </Link>
        </div>

        {/* Progression */}
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Votre Progression</h3>
            <div className="text-sm text-gray-500">100 bonnes réponses requis par niveau</div>
          </div>
          <div className="grid grid-cols-5 gap-2">
            {[1, 2, 3, 4, 5].map((level) => (
              <div
                key={level}
                className={`p-3 rounded-lg text-center ${
                  level <= parseInt(params.level)
                    ? 'bg-blue-100 text-blue-800'
                    : 'bg-gray-100 text-gray-500'
                }`}
              >
                <div className="font-semibold">Niveau {level}</div>
                <div className="text-xs">
                  {level <= parseInt(params.level) ? 'Disponible' : 'Verrouillé'}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
