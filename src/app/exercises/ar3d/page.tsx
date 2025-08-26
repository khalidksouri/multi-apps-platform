'use client';

export default function AR3DPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-900 to-red-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold mb-4">🥽 Mode Réalité Augmentée 3D</h1>
          <div className="bg-orange-500/20 px-4 py-2 rounded-full inline-block">
            <span className="text-orange-400 font-bold">Révolution Pédagogique</span>
          </div>
        </div>

        <div className="mb-12">
          <div className="bg-black/30 rounded-2xl p-8">
            <div className="text-center mb-8">
              <div className="text-7xl font-bold mb-4">4 × 3 = ?</div>
              <p className="text-gray-300">Visualise en 3D et résous</p>
            </div>
            
            <div className="flex justify-center">
              <div className="w-[600px] h-[400px] bg-gradient-to-br from-orange-500/20 to-red-500/20 rounded-lg border border-orange-500/30 flex items-center justify-center hover:scale-105 transition-transform">
                <div className="text-center">
                  <div className="text-8xl mb-4">🌟</div>
                  <div className="text-2xl font-bold mb-2">Environnement 3D WebGL</div>
                  <div className="text-gray-300 mb-4">Réalité augmentée mathématique immersive</div>
                  <div className="text-sm text-orange-400">Cliquez pour activer la 3D</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="text-center">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-2xl mx-auto">
            <button className="px-6 py-3 bg-orange-600 hover:bg-orange-700 rounded font-semibold transition-colors">
              🔄 Nouveau 3D
            </button>
            <a href="/exercises" className="px-6 py-3 bg-gray-600 hover:bg-gray-700 rounded font-semibold text-center transition-colors">
              🏠 Retour
            </a>
            <button className="px-6 py-3 bg-red-600 hover:bg-red-700 rounded font-semibold transition-colors">
              ⚙️ Options 3D
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
