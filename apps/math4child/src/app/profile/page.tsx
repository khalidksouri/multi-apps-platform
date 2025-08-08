export default function ProfilePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        <div className="bg-white rounded-3xl shadow-xl p-8">
          <div className="text-center">
            <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full flex items-center justify-center text-white text-3xl font-bold mx-auto mb-4">
              U
            </div>
            <h1 className="text-3xl font-bold text-gray-800 mb-2">Utilisateur Démo</h1>
            <p className="text-gray-600 mb-6">demo@math4child.com</p>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-blue-50 rounded-2xl p-6 text-center">
                <div className="text-3xl font-bold text-blue-600 mb-2">0</div>
                <div className="text-gray-600">Bonnes réponses</div>
              </div>
              <div className="bg-green-50 rounded-2xl p-6 text-center">
                <div className="text-3xl font-bold text-green-600 mb-2">0</div>
                <div className="text-gray-600">Niveaux terminés</div>
              </div>
              <div className="bg-purple-50 rounded-2xl p-6 text-center">
                <div className="text-3xl font-bold text-purple-600 mb-2">0</div>
                <div className="text-gray-600">Questions répondues</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
