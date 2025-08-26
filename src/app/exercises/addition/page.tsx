'use client';

export default function AdditionPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      <div className="max-w-4xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">➕ Addition</h1>
          <div className="bg-blue-500/20 px-4 py-2 rounded-full inline-block">
            <span className="text-blue-400 font-bold">Mode Classique</span>
          </div>
        </div>

        <div className="bg-black/30 rounded-2xl p-8">
          <div className="text-center mb-8">
            <div className="text-8xl font-bold mb-4">5 + 3 = ?</div>
            <p className="text-gray-300">Utilise le clavier pour répondre</p>
          </div>

          <div className="max-w-md mx-auto">
            <div className="grid grid-cols-3 gap-4 mb-6">
              {[1,2,3,4,5,6,7,8,9].map(num => (
                <button key={num} className="bg-gray-700 hover:bg-gray-600 text-2xl font-bold py-4 rounded transition-colors">
                  {num}
                </button>
              ))}
              <button className="bg-gray-700 hover:bg-gray-600 text-2xl font-bold py-4 rounded">0</button>
              <button className="bg-red-600 hover:bg-red-700 font-bold py-4 rounded">⌫</button>
              <button className="bg-green-600 hover:bg-green-700 font-bold py-4 rounded">✓</button>
            </div>
            
            <div className="bg-black/50 p-4 rounded text-center">
              <div className="text-3xl font-bold text-yellow-400 min-h-12 flex items-center justify-center">
                Ta réponse...
              </div>
            </div>
          </div>

          <div className="text-center mt-8">
            <div className="grid grid-cols-2 gap-4 max-w-md mx-auto">
              <a href="/exercises" className="py-3 bg-gray-600 hover:bg-gray-700 rounded text-center transition-colors">
                🏠 Retour
              </a>
              <button className="py-3 bg-blue-600 hover:bg-blue-700 rounded transition-colors">
                ➡️ Suivant
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
