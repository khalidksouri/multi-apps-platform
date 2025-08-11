'use client'

import React from 'react'
import Link from 'next/link'

interface ExerciseOperationPageProps {
  params: {
    level: string;
    operation: string;
  } | null;
}

export default function ExerciseOperationPage({ params }: ExerciseOperationPageProps) {
  // Vérification de la présence des params
  if (!params) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-red-600 mb-4">Erreur</h1>
          <p className="text-gray-600 mb-4">Paramètres manquants</p>
          <Link href="/exercises" className="bg-blue-500 text-white px-4 py-2 rounded">
            Retour aux exercices
          </Link>
        </div>
      </div>
    );
  }

  const level = parseInt(params.level);
  const operation = params.operation;

  // Validation des paramètres
  if (isNaN(level) || level < 1 || level > 5) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-red-600 mb-4">Niveau Invalide</h1>
          <p className="text-gray-600 mb-4">Le niveau doit être entre 1 et 5</p>
          <Link href="/exercises" className="bg-blue-500 text-white px-4 py-2 rounded">
            Retour aux exercices
          </Link>
        </div>
      </div>
    );
  }

  const validOperations = ['addition', 'subtraction', 'multiplication', 'division'];
  if (!validOperations.includes(operation)) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-red-600 mb-4">Opération Invalide</h1>
          <p className="text-gray-600 mb-4">Opération non supportée: {operation}</p>
          <Link href={`/exercises/${level}`} className="bg-blue-500 text-white px-4 py-2 rounded">
            Retour au niveau {level}
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      <div className="container mx-auto px-4 py-8">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold mb-4">
            🧮 Niveau {level} - {operation}
          </h1>
          <p className="text-xl text-gray-600">
            Exercices spécialisés en {operation}
          </p>
        </div>

        <div className="max-w-2xl mx-auto bg-white rounded-lg shadow-lg p-8">
          <div className="text-center">
            <div className="text-6xl mb-4">🚧</div>
            <h2 className="text-2xl font-bold mb-4">Page en Construction</h2>
            <p className="text-gray-600 mb-6">
              Cette page spécialisée pour {operation} de niveau {level} est en cours de développement.
            </p>
            
            <div className="space-y-4">
              <Link
                href={`/exercises/${level}`}
                className="block bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition-colors"
              >
                ← Retour au niveau {level}
              </Link>
              
              <Link
                href="/exercises"
                className="block bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition-colors"
              >
                ← Retour aux exercices
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
