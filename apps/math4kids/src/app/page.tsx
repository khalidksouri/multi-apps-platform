export default function Home() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-purple-600 to-blue-600">
      <div className="text-center text-white">
        <h1 className="text-6xl font-bold mb-4">Math4Kids</h1>
        <p className="text-2xl mb-8">Apprendre les maths en s&apos;amusant !</p>
        <div className="space-y-4">
          <button className="bg-green-500 hover:bg-green-600 text-white font-bold py-4 px-8 rounded-lg text-xl transition-colors block mx-auto">
            🚀 Commencer le jeu
          </button>
          <p className="text-white/80">Application multilingue • 30+ langues supportées</p>
          <p className="text-white/80">5 niveaux de difficulté • Système de progression</p>
        </div>
      </div>
    </div>
  )
}
