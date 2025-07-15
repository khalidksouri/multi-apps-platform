export default function HomePage() {
  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          🧠 MultiAI
        </h1>
        <p className="text-xl text-gray-600">
          Bienvenue sur MultiAI - Port 3005
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-4">
          🧠 Fonctionnalités
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">🚀 Interface moderne</h3>
            <p className="text-gray-600">Interface utilisateur intuitive et responsive</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">⚡ Performance</h3>
            <p className="text-gray-600">Application optimisée pour la vitesse</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">🔒 Sécurité</h3>
            <p className="text-gray-600">Données protégées et sécurisées</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">📱 Mobile</h3>
            <p className="text-gray-600">Compatible mobile et tablette</p>
          </div>
        </div>
      </div>

      <div className="text-center">
        <button className="btn btn-primary">
          Commencer
        </button>
      </div>
    </div>
  );
}
