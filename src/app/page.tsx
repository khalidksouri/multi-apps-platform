'use client';

import { useState, useEffect } from 'react';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8">
        <main className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-6">
            Multi-Apps Platform
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Page racine du projet multi-applications
          </p>
          <div className="space-y-4">
            <a 
              href="/apps/math4child" 
              className="inline-block bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-6 rounded-lg transition-colors"
            >
              Accéder à Math4Child
            </a>
          </div>
        </main>
      </div>
    </div>
  );
}
