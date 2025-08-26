'use client';

export default function HandwritingPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-green-900 to-teal-900 text-white">
      <div className="max-w-6xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">✏️ Mode Reconnaissance Manuscrite</h1>
          <div className="bg-green-500/20 px-4 py-2 rounded-full inline-block">
            <span className="text-green-400 font-bold">Innovation IA Mondiale</span>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-black/30 rounded-2xl p-8">
            <div className="text-center mb-8">
              <div className="text-7xl font-bold mb-4">7 + 4 = ?</div>
              <p className="text-gray-300">Écris la réponse sur le canvas</p>
            </div>
            <div className="flex justify-center">
              <div className="bg-white rounded-lg p-4">
                <div className="w-96 h-96 bg-gray-100 border-2 border-dashed border-gray-400 rounded flex items-center justify-center">
                  <div className="text-center text-gray-500">
                    <div className="text-4xl mb-2">✏️</div>
                    <p>Canvas d'écriture manuscrite</p>
                    <p className="text-sm">Zone de dessin IA</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="space-y-6">
            <div className="bg-blue-500/20 p-6 rounded-2xl">
              <div className="text-center">
                <h3 className="text-2xl font-bold mb-4">🌟 Innovation IA</h3>
                <p className="text-gray-300">
                  Reconnaissance manuscrite temps réel avec analyse de confiance avancée
                </p>
              </div>
            </div>

            <div className="space-y-3">
              <button className="w-full py-3 bg-green-600 hover:bg-green-700 rounded font-semibold transition-colors">
                ➡️ Exercice Suivant
              </button>
              <div className="grid grid-cols-2 gap-3">
                <a href="/exercises" className="py-2 bg-gray-600 hover:bg-gray-700 rounded text-center transition-colors">
                  🏠 Retour
                </a>
                <button className="py-2 bg-purple-600 hover:bg-purple-700 rounded transition-colors">
                  🎯 Paramètres
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
